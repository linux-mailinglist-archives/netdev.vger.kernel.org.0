Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0897C174DC0
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgCAOpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:45:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgCAOpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:45:17 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B9D72468A;
        Sun,  1 Mar 2020 14:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073917;
        bh=pd/NGsl+FJgnqBYsiZ/s5l3256lUdAtpUXAA0265xgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKDyMxj9fpi3CZBT+VBarUaR0JDS4Jw7swPU+Qn0yO9rvD/jiJE5J5BnE+HnpLCp/
         PDHLAC5Rx+eOrYSsK/gP6CIVQTgLaAIe5VfmWHcP3USzJ4uGcCnmv40k8iHfF82Sqe
         Rg3iu4Ap7KqUI67NrqriiVga2X9+2fAK/V+t4SAw=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Robert Richter <rrichter@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH net-next 06/23] net/cavium: Clean driver versions
Date:   Sun,  1 Mar 2020 16:44:39 +0200
Message-Id: <20200301144457.119795-7-leon@kernel.org>
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

Delete driver and module versions in favor of global
linux kernel variant.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c    | 4 ----
 drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c | 2 --
 2 files changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index e9575887a4f8..2985699ad1da 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -28,7 +28,6 @@
 #include <asm/octeon/cvmx-agl-defs.h>
 
 #define DRV_NAME "octeon_mgmt"
-#define DRV_VERSION "2.0"
 #define DRV_DESCRIPTION \
 	"Cavium Networks Octeon MII (management) port Network Driver"
 
@@ -1340,7 +1339,6 @@ static void octeon_mgmt_get_drvinfo(struct net_device *netdev,
 				    struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->fw_version, "N/A", sizeof(info->fw_version));
 	strlcpy(info->bus_info, "N/A", sizeof(info->bus_info));
 }
@@ -1517,7 +1515,6 @@ static int octeon_mgmt_probe(struct platform_device *pdev)
 	if (result)
 		goto err;
 
-	dev_info(&pdev->dev, "Version " DRV_VERSION "\n");
 	return 0;
 
 err:
@@ -1574,4 +1571,3 @@ module_exit(octeon_mgmt_mod_exit);
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_AUTHOR("David Daney");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
index 5e0b16bb95a0..83dabcffc789 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
@@ -16,7 +16,6 @@
 #include "../common/cavium_ptp.h"
 
 #define DRV_NAME	"nicvf"
-#define DRV_VERSION     "1.0"
 
 struct nicvf_stat {
 	char name[ETH_GSTRING_LEN];
@@ -192,7 +191,6 @@ static void nicvf_get_drvinfo(struct net_device *netdev,
 	struct nicvf *nic = netdev_priv(netdev);
 
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(nic->pdev), sizeof(info->bus_info));
 }
 
-- 
2.24.1

