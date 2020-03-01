Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B17E174DD2
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgCAOqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:46:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbgCAOqD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:46:03 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C639B222C4;
        Sun,  1 Mar 2020 14:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073962;
        bh=ojnVKuIBscFkgpCyHHinaL2UxBWi7ja7K/pmKVS70Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMYEge2sibgAzpTb7Eonfahj9MVdv+sVYJQAROGg6DfyNSMi1uGbgxyfBczGHdURW
         bZS1rJI/78VY35hsnaBxZXP/irTPYjJLmu9kpD5JPcwiTdAylGMmv1ojW1FOBeg6Cz
         2ipu6DJBV0piqYUFljEDDJ+Ah/2k1sKTIcHsHOjw=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        linuxppc-dev@lists.ozlabs.org, Li Yang <leoyang.li@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>
Subject: [PATCH net-next 20/23] net/freescale: Clean drivers from static versions
Date:   Sun,  1 Mar 2020 16:44:53 +0200
Message-Id: <20200301144457.119795-21-leon@kernel.org>
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

There is no need to set static versions because linux kernel is
released all together with same version applicable to the whole
code base.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c  |  2 --
 drivers/net/ethernet/freescale/enetc/enetc_pf.c     | 13 -------------
 drivers/net/ethernet/freescale/enetc/enetc_vf.c     | 12 ------------
 drivers/net/ethernet/freescale/fec_main.c           |  1 -
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c   |  2 --
 drivers/net/ethernet/freescale/fs_enet/fs_enet.h    |  2 --
 drivers/net/ethernet/freescale/gianfar.c            |  2 --
 drivers/net/ethernet/freescale/gianfar.h            |  1 -
 drivers/net/ethernet/freescale/gianfar_ethtool.c    |  2 --
 drivers/net/ethernet/freescale/ucc_geth.c           |  1 -
 drivers/net/ethernet/freescale/ucc_geth.h           |  1 -
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c   |  1 -
 12 files changed, 40 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 66d150872d48..13ab669ca8b3 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -110,8 +110,6 @@ static void dpaa_get_drvinfo(struct net_device *net_dev,
 
 	strlcpy(drvinfo->driver, KBUILD_MODNAME,
 		sizeof(drvinfo->driver));
-	len = snprintf(drvinfo->version, sizeof(drvinfo->version),
-		       "%X", 0);
 	len = snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		       "%X", 0);
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index fc0d7d99e9a1..545a344bce00 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -7,12 +7,6 @@
 #include <linux/of_net.h>
 #include "enetc_pf.h"
 
-#define ENETC_DRV_VER_MAJ 1
-#define ENETC_DRV_VER_MIN 0
-
-#define ENETC_DRV_VER_STR __stringify(ENETC_DRV_VER_MAJ) "." \
-			  __stringify(ENETC_DRV_VER_MIN)
-static const char enetc_drv_ver[] = ENETC_DRV_VER_STR;
 #define ENETC_DRV_NAME_STR "ENETC PF driver"
 static const char enetc_drv_name[] = ENETC_DRV_NAME_STR;
 
@@ -929,9 +923,6 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 
 	netif_carrier_off(ndev);
 
-	netif_info(priv, probe, ndev, "%s v%s\n",
-		   enetc_drv_name, enetc_drv_ver);
-
 	return 0;
 
 err_reg_netdev:
@@ -959,9 +950,6 @@ static void enetc_pf_remove(struct pci_dev *pdev)
 		enetc_sriov_configure(pdev, 0);
 
 	priv = netdev_priv(si->ndev);
-	netif_info(priv, drv, si->ndev, "%s v%s remove\n",
-		   enetc_drv_name, enetc_drv_ver);
-
 	unregister_netdev(si->ndev);
 
 	enetc_mdio_remove(pf);
@@ -995,4 +983,3 @@ module_pci_driver(enetc_pf_driver);
 
 MODULE_DESCRIPTION(ENETC_DRV_NAME_STR);
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(ENETC_DRV_VER_STR);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index ebd21bf4cfa1..28a786b2f3e7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -4,12 +4,6 @@
 #include <linux/module.h>
 #include "enetc.h"
 
-#define ENETC_DRV_VER_MAJ 1
-#define ENETC_DRV_VER_MIN 0
-
-#define ENETC_DRV_VER_STR __stringify(ENETC_DRV_VER_MAJ) "." \
-			  __stringify(ENETC_DRV_VER_MIN)
-static const char enetc_drv_ver[] = ENETC_DRV_VER_STR;
 #define ENETC_DRV_NAME_STR "ENETC VF driver"
 static const char enetc_drv_name[] = ENETC_DRV_NAME_STR;
 
@@ -201,9 +195,6 @@ static int enetc_vf_probe(struct pci_dev *pdev,
 
 	netif_carrier_off(ndev);
 
-	netif_info(priv, probe, ndev, "%s v%s\n",
-		   enetc_drv_name, enetc_drv_ver);
-
 	return 0;
 
 err_reg_netdev:
@@ -225,8 +216,6 @@ static void enetc_vf_remove(struct pci_dev *pdev)
 	struct enetc_ndev_priv *priv;
 
 	priv = netdev_priv(si->ndev);
-	netif_info(priv, drv, si->ndev, "%s v%s remove\n",
-		   enetc_drv_name, enetc_drv_ver);
 	unregister_netdev(si->ndev);
 
 	enetc_free_msix(priv);
@@ -254,4 +243,3 @@ module_pci_driver(enetc_vf_driver);
 
 MODULE_DESCRIPTION(ENETC_DRV_NAME_STR);
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(ENETC_DRV_VER_STR);
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 12edd4e358f8..af7653e341f2 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2128,7 +2128,6 @@ static void fec_enet_get_drvinfo(struct net_device *ndev,
 
 	strlcpy(info->driver, fep->pdev->dev.driver->name,
 		sizeof(info->driver));
-	strlcpy(info->version, "Revision: 1.0", sizeof(info->version));
 	strlcpy(info->bus_info, dev_name(&ndev->dev), sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index add61fed33ee..ce85feaac357 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -53,7 +53,6 @@
 MODULE_AUTHOR("Pantelis Antoniou <panto@intracom.gr>");
 MODULE_DESCRIPTION("Freescale Ethernet Driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_MODULE_VERSION);
 
 static int fs_enet_debug = -1; /* -1 == use FS_ENET_DEF_MSG_ENABLE as value */
 module_param(fs_enet_debug, int, 0);
@@ -790,7 +789,6 @@ static void fs_get_drvinfo(struct net_device *dev,
 			    struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 }
 
 static int fs_get_regs_len(struct net_device *dev)
diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet.h b/drivers/net/ethernet/freescale/fs_enet/fs_enet.h
index 195fae6aec4a..5ff2634bee2f 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet.h
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet.h
@@ -190,8 +190,6 @@ void fs_cleanup_bds(struct net_device *dev);
 
 #define DRV_MODULE_NAME		"fs_enet"
 #define PFX DRV_MODULE_NAME	": "
-#define DRV_MODULE_VERSION	"1.1"
-#define DRV_MODULE_RELDATE	"Sep 22, 2014"
 
 /***************************************************************************/
 
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index f7e5cafe89a9..b3c69e9038ea 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -103,8 +103,6 @@
 
 #define TX_TIMEOUT      (5*HZ)
 
-const char gfar_driver_version[] = "2.0";
-
 MODULE_AUTHOR("Freescale Semiconductor, Inc");
 MODULE_DESCRIPTION("Gianfar Ethernet Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ethernet/freescale/gianfar.h
index 432c6a818ae5..8ced783f5302 100644
--- a/drivers/net/ethernet/freescale/gianfar.h
+++ b/drivers/net/ethernet/freescale/gianfar.h
@@ -68,7 +68,6 @@ struct ethtool_rx_list {
 #define RXBUF_ALIGNMENT 64
 
 #define DRV_NAME "gfar-enet"
-extern const char gfar_driver_version[];
 
 /* MAXIMUM NUMBER OF QUEUES SUPPORTED */
 #define MAX_TX_QS	0x8
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 3c8e4e2efc07..7b69e80d6b30 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -164,8 +164,6 @@ static void gfar_gdrvinfo(struct net_device *dev,
 			  struct ethtool_drvinfo *drvinfo)
 {
 	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, gfar_driver_version,
-		sizeof(drvinfo->version));
 	strlcpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
 	strlcpy(drvinfo->bus_info, "N/A", sizeof(drvinfo->bus_info));
 }
diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 0d101c00286f..6e5f6dd169b5 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3990,5 +3990,4 @@ module_exit(ucc_geth_exit);
 
 MODULE_AUTHOR("Freescale Semiconductor, Inc");
 MODULE_DESCRIPTION(DRV_DESC);
-MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/freescale/ucc_geth.h b/drivers/net/ethernet/freescale/ucc_geth.h
index a86a42131fc7..3fe903972195 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.h
+++ b/drivers/net/ethernet/freescale/ucc_geth.h
@@ -26,7 +26,6 @@
 
 #define DRV_DESC "QE UCC Gigabit Ethernet Controller"
 #define DRV_NAME "ucc_geth"
-#define DRV_VERSION "1.1"
 
 #define NUM_TX_QUEUES                   8
 #define NUM_RX_QUEUES                   8
diff --git a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
index dfebacf443fc..bc7ba70d176c 100644
--- a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
+++ b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
@@ -334,7 +334,6 @@ uec_get_drvinfo(struct net_device *netdev,
                        struct ethtool_drvinfo *drvinfo)
 {
 	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, DRV_VERSION, sizeof(drvinfo->version));
 	strlcpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
 	strlcpy(drvinfo->bus_info, "QUICC ENGINE", sizeof(drvinfo->bus_info));
 }
-- 
2.24.1

