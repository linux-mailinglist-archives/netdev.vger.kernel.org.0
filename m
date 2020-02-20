Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC1DC16603F
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgBTO7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:59:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:57610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727761AbgBTO7t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 09:59:49 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39140206F4;
        Thu, 20 Feb 2020 14:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582210788;
        bh=jfBA030ZNUWZdUC2fcPCCqP9qkT4PNkK7GV+CJuCOpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNb05t8uvA23LZ/gmSnGNn5T9Ehb3VDqBqNDTYPgRnc6xjcdrwxyBNM+gI7SN0xmc
         wywXULPu2u+u9WWXozSfcn/agy0wjQ0tHBqza897/VhekUTXpK6rxZwVX1nRYXVuhx
         bBh19jIY2OGrcynEeTXLIltwmQVCo/Ffz67vRR/I=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net-next 15/16] net/arc: Delete driver version
Date:   Thu, 20 Feb 2020 16:58:54 +0200
Message-Id: <20200220145855.255704-16-leon@kernel.org>
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

Drop constant driver version in favour of global linux kernel.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/arc/emac.h          | 1 -
 drivers/net/ethernet/arc/emac_arc.c      | 2 --
 drivers/net/ethernet/arc/emac_main.c     | 1 -
 drivers/net/ethernet/arc/emac_rockchip.c | 2 --
 4 files changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/arc/emac.h b/drivers/net/ethernet/arc/emac.h
index d9efbc8d783b..d820ae03a966 100644
--- a/drivers/net/ethernet/arc/emac.h
+++ b/drivers/net/ethernet/arc/emac.h
@@ -130,7 +130,6 @@ struct arc_emac_mdio_bus_data {
  */
 struct arc_emac_priv {
 	const char *drv_name;
-	const char *drv_version;
 	void (*set_mac_speed)(void *priv, unsigned int speed);

 	/* Devices */
diff --git a/drivers/net/ethernet/arc/emac_arc.c b/drivers/net/ethernet/arc/emac_arc.c
index 539166112993..1c7736b7eaf7 100644
--- a/drivers/net/ethernet/arc/emac_arc.c
+++ b/drivers/net/ethernet/arc/emac_arc.c
@@ -15,7 +15,6 @@
 #include "emac.h"

 #define DRV_NAME    "emac_arc"
-#define DRV_VERSION "1.0"

 static int emac_arc_probe(struct platform_device *pdev)
 {
@@ -36,7 +35,6 @@ static int emac_arc_probe(struct platform_device *pdev)

 	priv = netdev_priv(ndev);
 	priv->drv_name = DRV_NAME;
-	priv->drv_version = DRV_VERSION;

 	err = of_get_phy_mode(dev->of_node, &interface);
 	if (err) {
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index 17bda4e8cc45..38cd968b6a3b 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -92,7 +92,6 @@ static void arc_emac_get_drvinfo(struct net_device *ndev,
 	struct arc_emac_priv *priv = netdev_priv(ndev);

 	strlcpy(info->driver, priv->drv_name, sizeof(info->driver));
-	strlcpy(info->version, priv->drv_version, sizeof(info->version));
 }

 static const struct ethtool_ops arc_emac_ethtool_ops = {
diff --git a/drivers/net/ethernet/arc/emac_rockchip.c b/drivers/net/ethernet/arc/emac_rockchip.c
index aae231c5224f..48ecdf15eddc 100644
--- a/drivers/net/ethernet/arc/emac_rockchip.c
+++ b/drivers/net/ethernet/arc/emac_rockchip.c
@@ -16,7 +16,6 @@
 #include "emac.h"

 #define DRV_NAME        "rockchip_emac"
-#define DRV_VERSION     "1.1"

 struct emac_rockchip_soc_data {
 	unsigned int grf_offset;
@@ -112,7 +111,6 @@ static int emac_rockchip_probe(struct platform_device *pdev)

 	priv = netdev_priv(ndev);
 	priv->emac.drv_name = DRV_NAME;
-	priv->emac.drv_version = DRV_VERSION;
 	priv->emac.set_mac_speed = emac_rockchip_set_mac_speed;

 	err = of_get_phy_mode(dev->of_node, &interface);
--
2.24.1

