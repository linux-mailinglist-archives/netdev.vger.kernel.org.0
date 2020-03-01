Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D6F174DC5
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgCAOpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:45:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:52440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgCAOpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:45:31 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47083222C4;
        Sun,  1 Mar 2020 14:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073931;
        bh=dRTUDK/zna5vWAPetyPDG+iXghZBP2wMcs+mkp9zs4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dfwk0Y+3q6vNSTympBSNJXq+BJbXhcfn2U/ztqXWXmfXelF6e1L2tJUwTAB54Y50b
         hWt9a6lsgUXZeIbrAFm1n12LV7LGFjmvpYy6NCApXTbUOI5PG2XLs2/0RNYoa/8zCE
         m2Eb/SXeWtaq5SUyVYXyOzHFQ1Zso0eOYF+n6JZc=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Derek Chickles <dchickles@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>, netdev@vger.kernel.org,
        Satanand Burla <sburla@marvell.com>
Subject: [PATCH net-next 04/23] net/liquidio: Delete driver version assignment
Date:   Sun,  1 Mar 2020 16:44:37 +0200
Message-Id: <20200301144457.119795-5-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200301144457.119795-1-leon@kernel.org>
References: <20200301144457.119795-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Drop driver version in favor of global to linux kernel version.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/cavium/liquidio/lio_ethtool.c     | 2 --
 drivers/net/ethernet/cavium/liquidio/lio_main.c        | 8 --------
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c     | 5 ++---
 drivers/net/ethernet/cavium/liquidio/liquidio_common.h | 5 -----
 4 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
index abe5d0dac851..2b27e3aad9db 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
@@ -442,7 +442,6 @@ lio_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 
 	memset(drvinfo, 0, sizeof(struct ethtool_drvinfo));
 	strcpy(drvinfo->driver, "liquidio");
-	strcpy(drvinfo->version, LIQUIDIO_VERSION);
 	strncpy(drvinfo->fw_version, oct->fw_info.liquidio_firmware_version,
 		ETHTOOL_FWVERS_LEN);
 	strncpy(drvinfo->bus_info, pci_name(oct->pci_dev), 32);
@@ -459,7 +458,6 @@ lio_get_vf_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 
 	memset(drvinfo, 0, sizeof(struct ethtool_drvinfo));
 	strcpy(drvinfo->driver, "liquidio_vf");
-	strcpy(drvinfo->version, LIQUIDIO_VERSION);
 	strncpy(drvinfo->fw_version, oct->fw_info.liquidio_firmware_version,
 		ETHTOOL_FWVERS_LEN);
 	strncpy(drvinfo->bus_info, pci_name(oct->pci_dev), 32);
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index eab05b5534ea..a8d9ec927627 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -39,7 +39,6 @@
 MODULE_AUTHOR("Cavium Networks, <support@cavium.com>");
 MODULE_DESCRIPTION("Cavium LiquidIO Intelligent Server Adapter Driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(LIQUIDIO_VERSION);
 MODULE_FIRMWARE(LIO_FW_DIR LIO_FW_BASE_NAME LIO_210SV_NAME
 		"_" LIO_FW_NAME_TYPE_NIC LIO_FW_NAME_SUFFIX);
 MODULE_FIRMWARE(LIO_FW_DIR LIO_FW_BASE_NAME LIO_210NV_NAME
@@ -1414,13 +1413,6 @@ static int octeon_chip_specific_setup(struct octeon_device *oct)
 			dev_id);
 	}
 
-	if (!ret)
-		dev_info(&oct->pci_dev->dev, "%s PASS%d.%d %s Version: %s\n", s,
-			 OCTEON_MAJOR_REV(oct),
-			 OCTEON_MINOR_REV(oct),
-			 octeon_get_conf(oct)->card_name,
-			 LIQUIDIO_VERSION);
-
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 7a77544a54f5..bbd9bfa4a989 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -32,7 +32,6 @@
 MODULE_AUTHOR("Cavium Networks, <support@cavium.com>");
 MODULE_DESCRIPTION("Cavium LiquidIO Intelligent Server Adapter Virtual Function Driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(LIQUIDIO_VERSION);
 
 static int debug = -1;
 module_param(debug, int, 0644);
@@ -2352,8 +2351,8 @@ static int octeon_device_init(struct octeon_device *oct)
 	}
 	atomic_set(&oct->status, OCT_DEV_MSIX_ALLOC_VECTOR_DONE);
 
-	dev_info(&oct->pci_dev->dev, "OCTEON_CN23XX VF Version: %s, %d ioqs\n",
-		 LIQUIDIO_VERSION, oct->sriov_info.rings_per_vf);
+	dev_info(&oct->pci_dev->dev, "OCTEON_CN23XX VF: %d ioqs\n",
+		 oct->sriov_info.rings_per_vf);
 
 	/* Setup the interrupt handler and record the INT SUM register address*/
 	if (octeon_setup_interrupt(oct, oct->sriov_info.rings_per_vf))
diff --git a/drivers/net/ethernet/cavium/liquidio/liquidio_common.h b/drivers/net/ethernet/cavium/liquidio/liquidio_common.h
index a5e0e9f17959..2d61790c2e51 100644
--- a/drivers/net/ethernet/cavium/liquidio/liquidio_common.h
+++ b/drivers/net/ethernet/cavium/liquidio/liquidio_common.h
@@ -31,11 +31,6 @@
 #define LIQUIDIO_BASE_MICRO_VERSION 2
 #define LIQUIDIO_BASE_VERSION   __stringify(LIQUIDIO_BASE_MAJOR_VERSION) "." \
 				__stringify(LIQUIDIO_BASE_MINOR_VERSION)
-#define LIQUIDIO_MICRO_VERSION  "." __stringify(LIQUIDIO_BASE_MICRO_VERSION)
-#define LIQUIDIO_VERSION        LIQUIDIO_PACKAGE \
-				__stringify(LIQUIDIO_BASE_MAJOR_VERSION) "." \
-				__stringify(LIQUIDIO_BASE_MINOR_VERSION) \
-				"." __stringify(LIQUIDIO_BASE_MICRO_VERSION)
 
 struct lio_version {
 	u16  major;
-- 
2.24.1

