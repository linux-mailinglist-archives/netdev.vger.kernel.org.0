Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9307C166042
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgBTO75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:59:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727761AbgBTO74 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 09:59:56 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A605206F4;
        Thu, 20 Feb 2020 14:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582210795;
        bh=YABNmhkto0V4n4RmXfOUZbjL+PGxfsTuQhCYjZCHCqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n4sGpvYOWb8FmEaqvgy0AJui5naWJk+zGiQ+iDxqde0adhG3r4q00gKH+GBrFF4Vt
         Vf+ZTjocSEacSnCJSz7SmOuNG0uZaXQU+4hod8TUyrP/YEeiTiEX6oVWKDVFww+Qgu
         2gF/UPH6xl3McUQR0B8q3dOFq0HpfKTEI3y3mu+Y=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net-next 13/16] net/apm: Remove useless driver version and properly mark lack of FW
Date:   Thu, 20 Feb 2020 16:58:52 +0200
Message-Id: <20200220145855.255704-14-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220145855.255704-1-leon@kernel.org>
References: <20200220145855.255704-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Delete module version in favor of global and unique linux kernel.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/apm/xgene-v2/ethtool.c         | 2 --
 drivers/net/ethernet/apm/xgene-v2/main.c            | 1 -
 drivers/net/ethernet/apm/xgene-v2/main.h            | 1 -
 drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c | 2 --
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c    | 1 -
 drivers/net/ethernet/apm/xgene/xgene_enet_main.h    | 1 -
 6 files changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/apm/xgene-v2/ethtool.c b/drivers/net/ethernet/apm/xgene-v2/ethtool.c
index a58250c1b57a..b78d1a99fe81 100644
--- a/drivers/net/ethernet/apm/xgene-v2/ethtool.c
+++ b/drivers/net/ethernet/apm/xgene-v2/ethtool.c
@@ -89,8 +89,6 @@ static void xge_get_drvinfo(struct net_device *ndev,
 	struct platform_device *pdev = pdata->pdev;

 	strcpy(info->driver, "xgene-enet-v2");
-	strcpy(info->version, XGENE_ENET_V2_VERSION);
-	snprintf(info->fw_version, ETHTOOL_FWVERS_LEN, "N/A");
 	sprintf(info->bus_info, "%s", pdev->name);
 }

diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index c48f60996761..860c18fb7aae 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -741,5 +741,4 @@ module_platform_driver(xge_driver);

 MODULE_DESCRIPTION("APM X-Gene SoC Ethernet v2 driver");
 MODULE_AUTHOR("Iyappan Subramanian <isubramanian@apm.com>");
-MODULE_VERSION(XGENE_ENET_V2_VERSION);
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.h b/drivers/net/ethernet/apm/xgene-v2/main.h
index d41439d2709d..b3985a7be59d 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.h
+++ b/drivers/net/ethernet/apm/xgene-v2/main.h
@@ -28,7 +28,6 @@
 #include "ring.h"
 #include "ethtool.h"

-#define XGENE_ENET_V2_VERSION	"v1.0"
 #define XGENE_ENET_STD_MTU	1536
 #define XGENE_ENET_MIN_FRAME	60
 #define IRQ_ID_SIZE             16
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c b/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c
index 246dec27140d..ada70425b48c 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c
@@ -103,8 +103,6 @@ static void xgene_get_drvinfo(struct net_device *ndev,
 	struct platform_device *pdev = pdata->pdev;

 	strcpy(info->driver, "xgene_enet");
-	strcpy(info->version, XGENE_DRV_VERSION);
-	snprintf(info->fw_version, ETHTOOL_FWVERS_LEN, "N/A");
 	sprintf(info->bus_info, "%s", pdev->name);
 }

diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 6aee2f0fc0db..5f1fc6582d74 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -2179,7 +2179,6 @@ static struct platform_driver xgene_enet_driver = {
 module_platform_driver(xgene_enet_driver);

 MODULE_DESCRIPTION("APM X-Gene SoC Ethernet driver");
-MODULE_VERSION(XGENE_DRV_VERSION);
 MODULE_AUTHOR("Iyappan Subramanian <isubramanian@apm.com>");
 MODULE_AUTHOR("Keyur Chudgar <kchudgar@apm.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.h b/drivers/net/ethernet/apm/xgene/xgene_enet_main.h
index 18f4923b1723..d35a338120cf 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.h
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.h
@@ -28,7 +28,6 @@
 #include "xgene_enet_ring2.h"
 #include "../../../phy/mdio-xgene.h"

-#define XGENE_DRV_VERSION	"v1.0"
 #define ETHER_MIN_PACKET	64
 #define ETHER_STD_PACKET	1518
 #define XGENE_ENET_STD_MTU	1536
--
2.24.1

