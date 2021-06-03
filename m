Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E735399FA3
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 13:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhFCLTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 07:19:32 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3407 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhFCLTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 07:19:32 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FwjvW6z5hz67Sq;
        Thu,  3 Jun 2021 19:13:59 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 19:17:45 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 19:17:44 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] can: janz-ican3: use DEVICE_ATTR_RO/RW() helper macro
Date:   Thu, 3 Jun 2021 19:17:39 +0800
Message-ID: <20210603111739.11983-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEVICE_ATTR_RO/RW() helper macro instead of plain DEVICE_ATTR(), which
makes the code a bit shorter and easier to read.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/net/can/janz-ican3.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 2a6c918186c02ed..c68ad56628bd444 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1815,9 +1815,9 @@ static int ican3_get_berr_counter(const struct net_device *ndev,
  * Sysfs Attributes
  */
 
-static ssize_t ican3_sysfs_show_term(struct device *dev,
-				     struct device_attribute *attr,
-				     char *buf)
+static ssize_t termination_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
 {
 	struct ican3_dev *mod = netdev_priv(to_net_dev(dev));
 	int ret;
@@ -1834,9 +1834,9 @@ static ssize_t ican3_sysfs_show_term(struct device *dev,
 	return snprintf(buf, PAGE_SIZE, "%u\n", mod->termination_enabled);
 }
 
-static ssize_t ican3_sysfs_set_term(struct device *dev,
-				    struct device_attribute *attr,
-				    const char *buf, size_t count)
+static ssize_t termination_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
 {
 	struct ican3_dev *mod = netdev_priv(to_net_dev(dev));
 	unsigned long enable;
@@ -1852,18 +1852,17 @@ static ssize_t ican3_sysfs_set_term(struct device *dev,
 	return count;
 }
 
-static ssize_t ican3_sysfs_show_fwinfo(struct device *dev,
-				       struct device_attribute *attr,
-				       char *buf)
+static ssize_t fwinfo_show(struct device *dev,
+			   struct device_attribute *attr,
+			   char *buf)
 {
 	struct ican3_dev *mod = netdev_priv(to_net_dev(dev));
 
 	return scnprintf(buf, PAGE_SIZE, "%s\n", mod->fwinfo);
 }
 
-static DEVICE_ATTR(termination, 0644, ican3_sysfs_show_term,
-		   ican3_sysfs_set_term);
-static DEVICE_ATTR(fwinfo, 0444, ican3_sysfs_show_fwinfo, NULL);
+static DEVICE_ATTR_RW(termination);
+static DEVICE_ATTR_RO(fwinfo);
 
 static struct attribute *ican3_sysfs_attrs[] = {
 	&dev_attr_termination.attr,
-- 
2.26.0.106.g9fadedd


