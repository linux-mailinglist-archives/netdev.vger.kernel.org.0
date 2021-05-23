Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2007938D881
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 05:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhEWD0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 23:26:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4587 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbhEWD0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 23:26:19 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fnly35sQ1zkXyx;
        Sun, 23 May 2021 11:22:03 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 23 May 2021 11:24:52 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sun, 23
 May 2021 11:24:52 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ecree.xilinx@gmail.com>, <habetsm.xilinx@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] sfc: falcon: use DEVICE_ATTR_*() macro
Date:   Sun, 23 May 2021 11:24:09 +0800
Message-ID: <20210523032409.47076-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEVICE_ATTR_*() helper instead of plain DEVICE_ATTR,
which makes the code a bit shorter and easier to read.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/sfc/falcon/efx.c           |  4 ++--
 drivers/net/ethernet/sfc/falcon/falcon_boards.c | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 5e7a57b680ca..9ec752a43c75 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2254,12 +2254,12 @@ static struct notifier_block ef4_netdev_notifier = {
 };
 
 static ssize_t
-show_phy_type(struct device *dev, struct device_attribute *attr, char *buf)
+phy_type_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct ef4_nic *efx = dev_get_drvdata(dev);
 	return sprintf(buf, "%d\n", efx->phy_type);
 }
-static DEVICE_ATTR(phy_type, 0444, show_phy_type, NULL);
+static DEVICE_ATTR_RO(phy_type);
 
 static int ef4_register_netdev(struct ef4_nic *efx)
 {
diff --git a/drivers/net/ethernet/sfc/falcon/falcon_boards.c b/drivers/net/ethernet/sfc/falcon/falcon_boards.c
index 729a05c1b0cf..2d2d8099011e 100644
--- a/drivers/net/ethernet/sfc/falcon/falcon_boards.c
+++ b/drivers/net/ethernet/sfc/falcon/falcon_boards.c
@@ -354,16 +354,16 @@ static int sfe4001_poweron(struct ef4_nic *efx)
 	return rc;
 }
 
-static ssize_t show_phy_flash_cfg(struct device *dev,
+static ssize_t phy_flash_cfg_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
 	struct ef4_nic *efx = dev_get_drvdata(dev);
 	return sprintf(buf, "%d\n", !!(efx->phy_mode & PHY_MODE_SPECIAL));
 }
 
-static ssize_t set_phy_flash_cfg(struct device *dev,
-				 struct device_attribute *attr,
-				 const char *buf, size_t count)
+static ssize_t phy_flash_cfg_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
 {
 	struct ef4_nic *efx = dev_get_drvdata(dev);
 	enum ef4_phy_mode old_mode, new_mode;
@@ -396,7 +396,7 @@ static ssize_t set_phy_flash_cfg(struct device *dev,
 	return err ? err : count;
 }
 
-static DEVICE_ATTR(phy_flash_cfg, 0644, show_phy_flash_cfg, set_phy_flash_cfg);
+static DEVICE_ATTR_RW(phy_flash_cfg);
 
 static void sfe4001_fini(struct ef4_nic *efx)
 {
-- 
2.17.1

