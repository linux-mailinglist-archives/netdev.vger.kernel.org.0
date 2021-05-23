Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14B138D88E
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 05:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhEWDhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 23:37:36 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5667 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbhEWDhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 23:37:33 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FnmC01Zmqz1BQ9W;
        Sun, 23 May 2021 11:33:16 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 23 May 2021 11:36:05 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sun, 23
 May 2021 11:36:04 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <yuehaibing@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] wlcore: use DEVICE_ATTR_<RW|RO> macro
Date:   Sun, 23 May 2021 11:35:38 +0800
Message-ID: <20210523033538.25568-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEVICE_ATTR_<RW|RO> helper instead of plain DEVICE_ATTR,
which makes the code a bit shorter and easier to read.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ti/wlcore/sysfs.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sysfs.c b/drivers/net/wireless/ti/wlcore/sysfs.c
index 5cf0379b88b6..35b535c125b6 100644
--- a/drivers/net/wireless/ti/wlcore/sysfs.c
+++ b/drivers/net/wireless/ti/wlcore/sysfs.c
@@ -12,9 +12,9 @@
 #include "debug.h"
 #include "sysfs.h"
 
-static ssize_t wl1271_sysfs_show_bt_coex_state(struct device *dev,
-					       struct device_attribute *attr,
-					       char *buf)
+static ssize_t bt_coex_state_show(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
 {
 	struct wl1271 *wl = dev_get_drvdata(dev);
 	ssize_t len;
@@ -30,9 +30,9 @@ static ssize_t wl1271_sysfs_show_bt_coex_state(struct device *dev,
 
 }
 
-static ssize_t wl1271_sysfs_store_bt_coex_state(struct device *dev,
-						struct device_attribute *attr,
-						const char *buf, size_t count)
+static ssize_t bt_coex_state_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
 {
 	struct wl1271 *wl = dev_get_drvdata(dev);
 	unsigned long res;
@@ -71,13 +71,11 @@ static ssize_t wl1271_sysfs_store_bt_coex_state(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(bt_coex_state, 0644,
-		   wl1271_sysfs_show_bt_coex_state,
-		   wl1271_sysfs_store_bt_coex_state);
+static DEVICE_ATTR_RW(bt_coex_state);
 
-static ssize_t wl1271_sysfs_show_hw_pg_ver(struct device *dev,
-					   struct device_attribute *attr,
-					   char *buf)
+static ssize_t hw_pg_ver_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
 {
 	struct wl1271 *wl = dev_get_drvdata(dev);
 	ssize_t len;
@@ -94,7 +92,7 @@ static ssize_t wl1271_sysfs_show_hw_pg_ver(struct device *dev,
 	return len;
 }
 
-static DEVICE_ATTR(hw_pg_ver, 0444, wl1271_sysfs_show_hw_pg_ver, NULL);
+static DEVICE_ATTR_RO(hw_pg_ver);
 
 static ssize_t wl1271_sysfs_read_fwlog(struct file *filp, struct kobject *kobj,
 				       struct bin_attribute *bin_attr,
-- 
2.17.1

