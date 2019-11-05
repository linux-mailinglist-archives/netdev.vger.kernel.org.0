Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4AAF05A7
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 20:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390903AbfKETIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 14:08:13 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46383 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390464AbfKETIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 14:08:12 -0500
Received: by mail-wr1-f65.google.com with SMTP id b3so17013438wrs.13;
        Tue, 05 Nov 2019 11:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IKLqZDfaXgP1Xe4wcnvHCplcbZautxg4bTR6MW4+Zio=;
        b=BMMZ2lkzExkFdN7VhZwnWJLKDc8vYMFVO52+g4rNM+iC1cnAWzej9DOx3/58fmmaeo
         sNTpJWwU1gVTbYu0gV/HPgbICFYDLdDfA0ObY9Py7RSwG08pwGMiXW4oTiZobzIgFD/E
         c6U0vO24ajBdKlzRQmIIUbQwRRlTIEANNpdlgQ3kdqoaQPnVyth+IwBIuzUUtSCf2dej
         fQ/aDSw6Qygi6X3VgUHpqk5/M2j5zJEtLAqJExoF25ui3QRn9k1ZLQ3CTLy77PYoI+25
         mtiS7G8Gd565fXbfWFpNd4XeKG9vsaysBbPMnk6RPPy1gAilMgVyiMfMPe3P3KBDo012
         y/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IKLqZDfaXgP1Xe4wcnvHCplcbZautxg4bTR6MW4+Zio=;
        b=XP9+44QqeIIUDPRG4e6Rvdodkm6cEjX487yWWiFWL6xyvwa57BpNajBYacje7pPS6C
         s0hn3a11hCCCgPhCfIUhmY7I4KwV4s5aOxRcNQEZZYTp5eXyahki0wUcs9RmkIRb8iKI
         nNukMsV2yNsBov6FGrV2XtLxnguOH5A4P/KOXSv0yF1saOQG0euSI8xiwdAsPI1k3rj9
         P0w63IBnTVZKIFEkRNU5fc84TeKRy+uyfjBLVHMlA+54wgb45Ayqh95RTVtRuOIxTI5e
         C1aXqSb4ZUWzF0PdAJrXGXvMKTcfEDCl4gnws58er0js29ZEYK4iZVZbUNE5ZyWd+T3F
         NxPw==
X-Gm-Message-State: APjAAAVqfzOO8KUDlTx/zrUuEVBpxGj5I4YW7epB1cRksrjV4m8EHWNp
        J3rlR8YWAZ3v2ax1akC7cE4=
X-Google-Smtp-Source: APXvYqwrLt6T5QwOQq3hYcPKrQBm2Z8JK2JSFKUhlvK8aWPziZvSlU/PNydQ26ZwXHm+FvbebaLvjA==
X-Received: by 2002:adf:fdd0:: with SMTP id i16mr31303052wrs.227.1572980890148;
        Tue, 05 Nov 2019 11:08:10 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d11sm25974703wrf.80.2019.11.05.11.08.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 05 Nov 2019 11:08:09 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 2/3] Revert "net: bcmgenet: soft reset 40nm EPHYs before MAC init"
Date:   Tue,  5 Nov 2019 11:07:25 -0800
Message-Id: <1572980846-37707-3-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572980846-37707-1-git-send-email-opendmb@gmail.com>
References: <1572980846-37707-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 1f515486275a08a17a2c806b844cca18f7de5b34.

This commit improved the chances of the umac resetting cleanly by
ensuring that the PHY was restored to its normal operation prior
to resetting the umac. However, there were still cases when the
PHY might not be driving a Tx clock to the umac during this window
(e.g. when the PHY detects no link).

The previous commit now ensures that the unimac receives clocks
from the MAC during its reset window so this commit is no longer
needed. This commit also has an unintended negative impact on the
MDIO performance of the UniMAC MDIO interface because it is used
before the MDIO interrupts are reenabled, so it should be removed.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |  28 +++----
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |   2 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c   | 112 ++++++++++++++-----------
 3 files changed, 73 insertions(+), 69 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index a1776ed8d7a1..b5255dd08265 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2877,12 +2877,6 @@ static int bcmgenet_open(struct net_device *dev)
 	if (priv->internal_phy)
 		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
 
-	ret = bcmgenet_mii_connect(dev);
-	if (ret) {
-		netdev_err(dev, "failed to connect to PHY\n");
-		goto err_clk_disable;
-	}
-
 	/* take MAC out of reset */
 	bcmgenet_umac_reset(priv);
 
@@ -2892,12 +2886,6 @@ static int bcmgenet_open(struct net_device *dev)
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	priv->crc_fwd_en = !!(reg & CMD_CRC_FWD);
 
-	ret = bcmgenet_mii_config(dev, true);
-	if (ret) {
-		netdev_err(dev, "unsupported PHY\n");
-		goto err_disconnect_phy;
-	}
-
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
 	if (priv->internal_phy) {
@@ -2913,7 +2901,7 @@ static int bcmgenet_open(struct net_device *dev)
 	ret = bcmgenet_init_dma(priv);
 	if (ret) {
 		netdev_err(dev, "failed to initialize DMA\n");
-		goto err_disconnect_phy;
+		goto err_clk_disable;
 	}
 
 	/* Always enable ring 16 - descriptor ring */
@@ -2936,19 +2924,25 @@ static int bcmgenet_open(struct net_device *dev)
 		goto err_irq0;
 	}
 
+	ret = bcmgenet_mii_probe(dev);
+	if (ret) {
+		netdev_err(dev, "failed to connect to PHY\n");
+		goto err_irq1;
+	}
+
 	bcmgenet_netif_start(dev);
 
 	netif_tx_start_all_queues(dev);
 
 	return 0;
 
+err_irq1:
+	free_irq(priv->irq1, priv);
 err_irq0:
 	free_irq(priv->irq0, priv);
 err_fini_dma:
 	bcmgenet_dma_teardown(priv);
 	bcmgenet_fini_dma(priv);
-err_disconnect_phy:
-	phy_disconnect(dev->phydev);
 err_clk_disable:
 	if (priv->internal_phy)
 		bcmgenet_power_down(priv, GENET_POWER_PASSIVE);
@@ -3629,8 +3623,6 @@ static int bcmgenet_resume(struct device *d)
 	if (priv->internal_phy)
 		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
 
-	phy_init_hw(dev->phydev);
-
 	bcmgenet_umac_reset(priv);
 
 	init_umac(priv);
@@ -3639,6 +3631,8 @@ static int bcmgenet_resume(struct device *d)
 	if (priv->wolopts)
 		clk_disable_unprepare(priv->clk_wol);
 
+	phy_init_hw(dev->phydev);
+
 	/* Speed settings must be restored */
 	bcmgenet_mii_config(priv->dev, false);
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 7fbf573d8d52..dbc69d8fa05f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -720,8 +720,8 @@ GENET_IO_MACRO(rbuf, GENET_RBUF_OFF);
 
 /* MDIO routines */
 int bcmgenet_mii_init(struct net_device *dev);
-int bcmgenet_mii_connect(struct net_device *dev);
 int bcmgenet_mii_config(struct net_device *dev, bool init);
+int bcmgenet_mii_probe(struct net_device *dev);
 void bcmgenet_mii_exit(struct net_device *dev);
 void bcmgenet_phy_power_set(struct net_device *dev, bool enable);
 void bcmgenet_mii_setup(struct net_device *dev);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index fcd181ae3a7d..dbe18cdf6c1b 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -173,46 +173,6 @@ static void bcmgenet_moca_phy_setup(struct bcmgenet_priv *priv)
 					  bcmgenet_fixed_phy_link_update);
 }
 
-int bcmgenet_mii_connect(struct net_device *dev)
-{
-	struct bcmgenet_priv *priv = netdev_priv(dev);
-	struct device_node *dn = priv->pdev->dev.of_node;
-	struct phy_device *phydev;
-	u32 phy_flags = 0;
-	int ret;
-
-	/* Communicate the integrated PHY revision */
-	if (priv->internal_phy)
-		phy_flags = priv->gphy_rev;
-
-	/* Initialize link state variables that bcmgenet_mii_setup() uses */
-	priv->old_link = -1;
-	priv->old_speed = -1;
-	priv->old_duplex = -1;
-	priv->old_pause = -1;
-
-	if (dn) {
-		phydev = of_phy_connect(dev, priv->phy_dn, bcmgenet_mii_setup,
-					phy_flags, priv->phy_interface);
-		if (!phydev) {
-			pr_err("could not attach to PHY\n");
-			return -ENODEV;
-		}
-	} else {
-		phydev = dev->phydev;
-		phydev->dev_flags = phy_flags;
-
-		ret = phy_connect_direct(dev, phydev, bcmgenet_mii_setup,
-					 priv->phy_interface);
-		if (ret) {
-			pr_err("could not attach to PHY\n");
-			return -ENODEV;
-		}
-	}
-
-	return 0;
-}
-
 int bcmgenet_mii_config(struct net_device *dev, bool init)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
@@ -339,21 +299,71 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
 	}
 
-	if (init) {
-		linkmode_copy(phydev->advertising, phydev->supported);
+	if (init)
+		dev_info(kdev, "configuring instance for %s\n", phy_name);
 
-		/* The internal PHY has its link interrupts routed to the
-		 * Ethernet MAC ISRs. On GENETv5 there is a hardware issue
-		 * that prevents the signaling of link UP interrupts when
-		 * the link operates at 10Mbps, so fallback to polling for
-		 * those versions of GENET.
-		 */
-		if (priv->internal_phy && !GENET_IS_V5(priv))
-			phydev->irq = PHY_IGNORE_INTERRUPT;
+	return 0;
+}
 
-		dev_info(kdev, "configuring instance for %s\n", phy_name);
+int bcmgenet_mii_probe(struct net_device *dev)
+{
+	struct bcmgenet_priv *priv = netdev_priv(dev);
+	struct device_node *dn = priv->pdev->dev.of_node;
+	struct phy_device *phydev;
+	u32 phy_flags = 0;
+	int ret;
+
+	/* Communicate the integrated PHY revision */
+	if (priv->internal_phy)
+		phy_flags = priv->gphy_rev;
+
+	/* Initialize link state variables that bcmgenet_mii_setup() uses */
+	priv->old_link = -1;
+	priv->old_speed = -1;
+	priv->old_duplex = -1;
+	priv->old_pause = -1;
+
+	if (dn) {
+		phydev = of_phy_connect(dev, priv->phy_dn, bcmgenet_mii_setup,
+					phy_flags, priv->phy_interface);
+		if (!phydev) {
+			pr_err("could not attach to PHY\n");
+			return -ENODEV;
+		}
+	} else {
+		phydev = dev->phydev;
+		phydev->dev_flags = phy_flags;
+
+		ret = phy_connect_direct(dev, phydev, bcmgenet_mii_setup,
+					 priv->phy_interface);
+		if (ret) {
+			pr_err("could not attach to PHY\n");
+			return -ENODEV;
+		}
+	}
+
+	/* Configure port multiplexer based on what the probed PHY device since
+	 * reading the 'max-speed' property determines the maximum supported
+	 * PHY speed which is needed for bcmgenet_mii_config() to configure
+	 * things appropriately.
+	 */
+	ret = bcmgenet_mii_config(dev, true);
+	if (ret) {
+		phy_disconnect(dev->phydev);
+		return ret;
 	}
 
+	linkmode_copy(phydev->advertising, phydev->supported);
+
+	/* The internal PHY has its link interrupts routed to the
+	 * Ethernet MAC ISRs. On GENETv5 there is a hardware issue
+	 * that prevents the signaling of link UP interrupts when
+	 * the link operates at 10Mbps, so fallback to polling for
+	 * those versions of GENET.
+	 */
+	if (priv->internal_phy && !GENET_IS_V5(priv))
+		dev->phydev->irq = PHY_IGNORE_INTERRUPT;
+
 	return 0;
 }
 
-- 
2.7.4

