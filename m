Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC71314A2CC
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 12:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730351AbgA0LQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 06:16:38 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:44532 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730220AbgA0LPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 06:15:52 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2B69240686;
        Mon, 27 Jan 2020 11:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1580123371; bh=pcWoruQFAEk+c+2GkezwGa9LXTHob64AMZbCenOjLZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=DAFFzf9GWWjZjA6xKfNJuRQHiZczy3mm1+AZnS7mv+uGsByNXLehVJyeidS2xVKZb
         /TvdM65SJsIhyL8wAgT3VV+ePo4DheKus7Rf8/vR+umncCjNjI+pKJlpo9JVq/HTvF
         yJSrj1qTQZEoJLHcH/cYImCGz7m1//4Cp3HQgElrpLLeIFNFhJzafv05bYfBzTfnjC
         edRWc6HnVdeIwHONq1YnrIhgkDjd/K0edOU5NbwV2ZmzX18aGGGOSjJK5wYECP+ZHI
         TiHrOR2sCqfgZNT5Eau1Wm/V7yoSMJWlcVxT7uvZUBfdRFsToobBJWuCDX9wy8/NwG
         P2IJhSfnA+NwA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id DAB5EA00A4;
        Mon, 27 Jan 2020 11:09:28 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC net-next 8/8] net: stmmac: Integrate it with DesignWare XPCS
Date:   Mon, 27 Jan 2020 12:09:13 +0100
Message-Id: <26c3a51fe9a31723309f60cd1de7e1b71aa4490d.1580122909.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1580122909.git.Jose.Abreu@synopsys.com>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1580122909.git.Jose.Abreu@synopsys.com>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds all the necessary logic so that stmmac can be used with Synopsys
DesignWare XPCS.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig       |  1 +
 drivers/net/ethernet/stmicro/stmmac/common.h      |  3 +++
 drivers/net/ethernet/stmicro/stmmac/hwif.h        | 12 ++++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 16 +++++++++++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 27 +++++++++++++++++++++++
 include/linux/stmmac.h                            |  1 +
 6 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 338e25a6374e..9ad927f646e8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -3,6 +3,7 @@ config STMMAC_ETH
 	tristate "STMicroelectronics Multi-Gigabit Ethernet driver"
 	depends on HAS_IOMEM && HAS_DMA
 	select MII
+	select MDIO_XPCS
 	select PAGE_POOL
 	select PHYLINK
 	select CRC32
diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 487099092693..9bdbf589d93f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -15,6 +15,7 @@
 #include <linux/netdevice.h>
 #include <linux/stmmac.h>
 #include <linux/phy.h>
+#include <linux/mdio-xpcs.h>
 #include <linux/module.h>
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 #define STMMAC_VLAN_TAG_USED
@@ -446,6 +447,8 @@ struct mac_device_info {
 	const struct stmmac_hwtimestamp *ptp;
 	const struct stmmac_tc_ops *tc;
 	const struct stmmac_mmc_ops *mmc;
+	const struct mdio_xpcs_ops *xpcs;
+	struct mdio_xpcs_args xpcs_args;
 	struct mii_regs mii;	/* MII register Addresses */
 	struct mac_link link;
 	void __iomem *pcsr;     /* vpointer to device CSRs */
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index df63b0367aff..c71dd99c8abf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -577,6 +577,18 @@ struct stmmac_mmc_ops {
 #define stmmac_mmc_read(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mmc, read, __args)
 
+/* XPCS callbacks */
+#define stmmac_xpcs_validate(__priv, __args...) \
+	stmmac_do_callback(__priv, xpcs, validate, __args)
+#define stmmac_xpcs_config(__priv, __args...) \
+	stmmac_do_callback(__priv, xpcs, config, __args)
+#define stmmac_xpcs_get_state(__priv, __args...) \
+	stmmac_do_callback(__priv, xpcs, get_state, __args)
+#define stmmac_xpcs_link_up(__priv, __args...) \
+	stmmac_do_callback(__priv, xpcs, link_up, __args)
+#define stmmac_xpcs_probe(__priv, __args...) \
+	stmmac_do_callback(__priv, xpcs, probe, __args)
+
 struct stmmac_regs_off {
 	u32 ptp_off;
 	u32 mmc_off;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index eaedea4b353e..19084b10f3c2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -863,12 +863,18 @@ static void stmmac_validate(struct phylink_config *config,
 
 	phylink_and(state->advertising, mac_supported);
 	phylink_andnot(state->advertising, mask);
+
+	/* If PCS is supported, check which modes it supports */
+	stmmac_xpcs_validate(priv, &priv->hw->xpcs_args, supported, state);
 }
 
 static void stmmac_mac_pcs_get_state(struct phylink_config *config,
 				     struct phylink_link_state *state)
 {
+	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
+
 	state->link = 0;
+	stmmac_xpcs_get_state(priv, &priv->hw->xpcs_args, state);
 }
 
 static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
@@ -877,6 +883,11 @@ static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 	u32 ctrl;
 
+	if (priv->hw->xpcs && !state->an_complete) {
+		stmmac_xpcs_config(priv, &priv->hw->xpcs_args, state);
+		return;
+	}
+
 	ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
 	ctrl &= ~priv->hw->link.speed_mask;
 
@@ -952,6 +963,7 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 {
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 
+	stmmac_xpcs_link_up(priv, &priv->hw->xpcs_args, priv->speed, interface);
 	stmmac_mac_set(priv, priv->ioaddr, true);
 	if (phy && priv->dma_cap.eee) {
 		priv->eee_active = phy_init_eee(phy, 1) >= 0;
@@ -1040,6 +1052,7 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 
 	priv->phylink_config.dev = &priv->dev->dev;
 	priv->phylink_config.type = PHYLINK_NETDEV;
+	priv->phylink_config.pcs_poll = true;
 
 	if (!fwnode)
 		fwnode = dev_fwnode(priv->device);
@@ -2687,7 +2700,8 @@ static int stmmac_open(struct net_device *dev)
 	int ret;
 
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
-	    priv->hw->pcs != STMMAC_PCS_RTBI) {
+	    priv->hw->pcs != STMMAC_PCS_RTBI &&
+	    priv->hw->xpcs == NULL) {
 		ret = stmmac_init_phy(dev);
 		if (ret) {
 			netdev_err(priv->dev,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index cfe5d8b73142..b2a707e2ef43 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -382,6 +382,14 @@ int stmmac_mdio_register(struct net_device *ndev)
 		max_addr = PHY_MAX_ADDR;
 	}
 
+	if (mdio_bus_data->has_xpcs) {
+		priv->hw->xpcs = mdio_xpcs_get_ops();
+		if (!priv->hw->xpcs) {
+			err = -ENODEV;
+			goto bus_register_fail;
+		}
+	}
+
 	if (mdio_bus_data->needs_reset)
 		new_bus->reset = &stmmac_mdio_reset;
 
@@ -433,6 +441,25 @@ int stmmac_mdio_register(struct net_device *ndev)
 		found = 1;
 	}
 
+	/* Try to probe the XPCS by scanning all addresses. */
+	if (priv->hw->xpcs) {
+		struct mdio_xpcs_args *xpcs = &priv->hw->xpcs_args;
+		int ret, mode = priv->plat->phy_interface;
+		max_addr = PHY_MAX_ADDR;
+
+		xpcs->bus = new_bus;
+
+		for (addr = 0; addr < max_addr; addr++) {
+			xpcs->addr = addr;
+
+			ret = stmmac_xpcs_probe(priv, xpcs, mode);
+			if (!ret) {
+				found = 1;
+				break;
+			}
+		}
+	}
+
 	if (!found && !mdio_node) {
 		dev_warn(dev, "No PHY found\n");
 		mdiobus_unregister(new_bus);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 19190c609282..fbafb353e9be 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -80,6 +80,7 @@
 
 struct stmmac_mdio_bus_data {
 	unsigned int phy_mask;
+	unsigned int has_xpcs;
 	int *irqs;
 	int probed_phy_irq;
 	bool needs_reset;
-- 
2.7.4

