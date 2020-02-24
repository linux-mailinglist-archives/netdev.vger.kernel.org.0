Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74DEE16AA53
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgBXPlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:41:03 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:32177 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727719AbgBXPlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:41:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1582558863; x=1614094863;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D0rok9tfPVHwA0eM4ABgaJIqr8zR0bnHBdaFur4T8l4=;
  b=vNEFZlljj+V92GVur0cgahY199X5xOd5QmSc43ltrh0PuoAmslkS7Ckd
   qoyWZx1OWdUjM0jXh/x75AvqsyjF7TIgzF0JGrM0Z4SM1Wmh4pA+3/199
   8onpsP166v39RIb/rPtDz7HsjlvNfaigglMadMS3CIYLVCfwgPF1qLwhy
   Q=;
IronPort-SDR: 0V58PJWEF5F9u07iGENWwpmsmnr5ui4EEIM0grJkFEETMz8qPQEwmNb+c/YxcuJnu12J/SShDE
 T0FUgTjnnJ8Q==
X-IronPort-AV: E=Sophos;i="5.70,480,1574121600"; 
   d="scan'208";a="28498747"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 24 Feb 2020 15:41:01 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 7F0B4A026B;
        Mon, 24 Feb 2020 15:41:00 +0000 (UTC)
Received: from EX13D22EUA001.ant.amazon.com (10.43.165.37) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Mon, 24 Feb 2020 15:40:59 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D22EUA001.ant.amazon.com (10.43.165.37) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 24 Feb 2020 15:40:58 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 24 Feb 2020 15:40:56 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id A4E6681C97; Mon, 24 Feb 2020 15:40:56 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH] net/amazon: Ensure that driver version is aligned to the linux kernel
Date:   Mon, 24 Feb 2020 15:40:27 +0000
Message-ID: <20200224154027.16499-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200224094116.GD422704@unreal>
References: <20200224094116.GD422704@unreal>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Upstream drivers are managed inside global repository and released all
together, this ensure that driver version is the same as linux kernel,
so update amazon drivers to properly reflect it.

Also rename current driver version constants used in interface with
ENA device FW for code clarity.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  1 -
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 17 ++++-------------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  | 16 ++++++++--------
 3 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 971f02ea5..ad2148b86 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -404,7 +404,6 @@ static void ena_get_drvinfo(struct net_device *dev,
 	struct ena_adapter *adapter = netdev_priv(dev);
 
 	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 }
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 1c1a41bd1..b14772812 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -49,12 +49,9 @@
 #include "ena_netdev.h"
 #include "ena_pci_id_tbl.h"
 
-static char version[] = DEVICE_NAME " v" DRV_MODULE_VERSION "\n";
-
 MODULE_AUTHOR("Amazon.com, Inc. or its affiliates");
 MODULE_DESCRIPTION(DEVICE_NAME);
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_MODULE_VERSION);
 
 /* Time in jiffies before concluding the transmitter is hung. */
 #define TX_TIMEOUT  (5 * HZ)
@@ -2441,9 +2438,9 @@ static void ena_config_host_info(struct ena_com_dev *ena_dev,
 	strncpy(host_info->os_dist_str, utsname()->release,
 		sizeof(host_info->os_dist_str) - 1);
 	host_info->driver_version =
-		(DRV_MODULE_VER_MAJOR) |
-		(DRV_MODULE_VER_MINOR << ENA_ADMIN_HOST_INFO_MINOR_SHIFT) |
-		(DRV_MODULE_VER_SUBMINOR << ENA_ADMIN_HOST_INFO_SUB_MINOR_SHIFT) |
+		(DRV_MODULE_GEN_MAJOR) |
+		(DRV_MODULE_GEN_MINOR << ENA_ADMIN_HOST_INFO_MINOR_SHIFT) |
+		(DRV_MODULE_GEN_SUBMINOR << ENA_ADMIN_HOST_INFO_SUB_MINOR_SHIFT) |
 		("K"[0] << ENA_ADMIN_HOST_INFO_MODULE_TYPE_SHIFT);
 	host_info->num_cpus = num_online_cpus();
 
@@ -2822,9 +2819,7 @@ static int ena_restore_device(struct ena_adapter *adapter)
 		netif_carrier_on(adapter->netdev);
 
 	mod_timer(&adapter->timer_service, round_jiffies(jiffies + HZ));
-	dev_err(&pdev->dev,
-		"Device reset completed successfully, Driver info: %s\n",
-		version);
+	dev_err(&pdev->dev, "Device reset completed successfully\n");
 
 	return rc;
 err_disable_msix:
@@ -3459,8 +3454,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
-	dev_info_once(&pdev->dev, "%s", version);
-
 	rc = pci_enable_device_mem(pdev);
 	if (rc) {
 		dev_err(&pdev->dev, "pci_enable_device_mem() failed!\n");
@@ -3766,8 +3759,6 @@ static struct pci_driver ena_pci_driver = {
 
 static int __init ena_init(void)
 {
-	pr_info("%s", version);
-
 	ena_wq = create_singlethread_workqueue(DRV_MODULE_NAME);
 	if (!ena_wq) {
 		pr_err("Failed to create workqueue\n");
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 2fe5eeea6..ac3f481b7 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -44,16 +44,16 @@
 #include "ena_com.h"
 #include "ena_eth_com.h"
 
-#define DRV_MODULE_VER_MAJOR	2
-#define DRV_MODULE_VER_MINOR	1
-#define DRV_MODULE_VER_SUBMINOR 0
+#define DRV_MODULE_GEN_MAJOR	2
+#define DRV_MODULE_GEN_MINOR	1
+#define DRV_MODULE_GEN_SUBMINOR 0
 
 #define DRV_MODULE_NAME		"ena"
-#ifndef DRV_MODULE_VERSION
-#define DRV_MODULE_VERSION \
-	__stringify(DRV_MODULE_VER_MAJOR) "."	\
-	__stringify(DRV_MODULE_VER_MINOR) "."	\
-	__stringify(DRV_MODULE_VER_SUBMINOR) "K"
+#ifndef DRV_MODULE_GENERATION
+#define DRV_MODULE_GENERATION \
+	__stringify(DRV_MODULE_GEN_MAJOR) "."	\
+	__stringify(DRV_MODULE_GEN_MINOR) "."	\
+	__stringify(DRV_MODULE_GEN_SUBMINOR) "K"
 #endif
 
 #define DEVICE_NAME	"Elastic Network Adapter (ENA)"
-- 
2.24.1.AMZN

