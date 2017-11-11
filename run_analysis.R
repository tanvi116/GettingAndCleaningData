install.packages("reshape2")
library(reshape2)

#read activity_labels
activityLabel<-read.table("./UCI HAR Dataset/activity_labels.txt")
activityLabel[,2]<-as.character(activityLabel[,2])

#read features
features<-read.table("./UCI HAR Dataset/features.txt")
features[,2]<-as.character(features[,2])

#extract only mean and std

wantedFeature<-grep(".*mean.*|.*std.*",features[,2])

#use descriptive names for labels in datasets
wantedFeature.names<-gsub("-mean","Mean",wantedFeature.names)
wantedFeature.names<-gsub("-std","Std",wantedFeature.names)
wantedFeature.names<-gsub("[-()]","",wantedFeature.names)

# read train data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")[wantedFeature]
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
Sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

train<-cbind(Sub_train,Y_train,X_train)

# read test data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")[wantedFeature]
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
Sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

test<-cbind(Sub_test,Y_test,X_test)

#merge datasets

alldata<-rbind(train,test)

colnames(alldata)<-c("subject","activity",wantedFeature.names)

#use descriptive activity names for activities

alldata$activity<-factor(alldata$activity,levels = activityLabel[,1],labels = activityLabel[,2])
allData$subject <- as.factor(allData$subject)
alldata.melted<-melt(alldata,id=c("subject","activity"))
alldata.mean<-dcast(alldata.melted,subject+activity~variable,mean)
write.table(alldata.mean, "./tidy.txt", row.names = FALSE, quote = FALSE)

