Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21D938B021
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 15:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbhETNiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 09:38:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3631 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233196AbhETNiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 09:38:18 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fm9hG4PGVzmWtK;
        Thu, 20 May 2021 21:34:38 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 21:36:55 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 20
 May 2021 21:36:54 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: atm: use DEVICE_ATTR_RO macro
Date:   Thu, 20 May 2021 21:36:45 +0800
Message-ID: <20210520133645.48412-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEVICE_ATTR_RO helper instead of plain DEVICE_ATTR,
which makes the code a bit shorter and easier to read.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/atm/atm_sysfs.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/atm/atm_sysfs.c b/net/atm/atm_sysfs.c
index aa1b57161f3b..0fdbdfd19474 100644
--- a/net/atm/atm_sysfs.c
+++ b/net/atm/atm_sysfs.c
@@ -11,7 +11,7 @@
 
 #define to_atm_dev(cldev) container_of(cldev, struct atm_dev, class_dev)
 
-static ssize_t show_type(struct device *cdev,
+static ssize_t type_show(struct device *cdev,
 			 struct device_attribute *attr, char *buf)
 {
 	struct atm_dev *adev = to_atm_dev(cdev);
@@ -19,7 +19,7 @@ static ssize_t show_type(struct device *cdev,
 	return scnprintf(buf, PAGE_SIZE, "%s\n", adev->type);
 }
 
-static ssize_t show_address(struct device *cdev,
+static ssize_t address_show(struct device *cdev,
 			    struct device_attribute *attr, char *buf)
 {
 	struct atm_dev *adev = to_atm_dev(cdev);
@@ -27,7 +27,7 @@ static ssize_t show_address(struct device *cdev,
 	return scnprintf(buf, PAGE_SIZE, "%pM\n", adev->esi);
 }
 
-static ssize_t show_atmaddress(struct device *cdev,
+static ssize_t atmaddress_show(struct device *cdev,
 			       struct device_attribute *attr, char *buf)
 {
 	unsigned long flags;
@@ -50,7 +50,7 @@ static ssize_t show_atmaddress(struct device *cdev,
 	return count;
 }
 
-static ssize_t show_atmindex(struct device *cdev,
+static ssize_t atmindex_show(struct device *cdev,
 			     struct device_attribute *attr, char *buf)
 {
 	struct atm_dev *adev = to_atm_dev(cdev);
@@ -58,7 +58,7 @@ static ssize_t show_atmindex(struct device *cdev,
 	return scnprintf(buf, PAGE_SIZE, "%d\n", adev->number);
 }
 
-static ssize_t show_carrier(struct device *cdev,
+static ssize_t carrier_show(struct device *cdev,
 			    struct device_attribute *attr, char *buf)
 {
 	struct atm_dev *adev = to_atm_dev(cdev);
@@ -67,7 +67,7 @@ static ssize_t show_carrier(struct device *cdev,
 			 adev->signal == ATM_PHY_SIG_LOST ? 0 : 1);
 }
 
-static ssize_t show_link_rate(struct device *cdev,
+static ssize_t link_rate_show(struct device *cdev,
 			      struct device_attribute *attr, char *buf)
 {
 	struct atm_dev *adev = to_atm_dev(cdev);
@@ -90,12 +90,12 @@ static ssize_t show_link_rate(struct device *cdev,
 	return scnprintf(buf, PAGE_SIZE, "%d\n", link_rate);
 }
 
-static DEVICE_ATTR(address, 0444, show_address, NULL);
-static DEVICE_ATTR(atmaddress, 0444, show_atmaddress, NULL);
-static DEVICE_ATTR(atmindex, 0444, show_atmindex, NULL);
-static DEVICE_ATTR(carrier, 0444, show_carrier, NULL);
-static DEVICE_ATTR(type, 0444, show_type, NULL);
-static DEVICE_ATTR(link_rate, 0444, show_link_rate, NULL);
+static DEVICE_ATTR_RO(address);
+static DEVICE_ATTR_RO(atmaddress);
+static DEVICE_ATTR_RO(atmindex);
+static DEVICE_ATTR_RO(carrier);
+static DEVICE_ATTR_RO(type);
+static DEVICE_ATTR_RO(link_rate);
 
 static struct device_attribute *atm_attrs[] = {
 	&dev_attr_atmaddress,
-- 
2.17.1

