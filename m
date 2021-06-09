Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB223A1CE8
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 20:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhFISoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhFISoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 14:44:16 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CC2C061574
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 11:42:14 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id u24so29664855edy.11
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 11:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lZVV1y+iSaZlt0336aI4AjHEmp/+FSlUNb7E2ndj0xY=;
        b=IbSW49Bc3rX2crxTvWXECPg1LZ5JyUM8SeFh0vsSHPuRhhQ/g1TpL01td5DbnHDr95
         tx8FWkkC+SndZ+YXuz3dI1SVLlAm8g+5H3SlSys9fqfkOmgqANpNTyMYr1oiZHsK7bCl
         HtAdai2qgqU19gxUQ/ZQqo+xrMCqUA8/HIVTikLPSSTUHaf1y9h6p6WLwCWWDkwelG6M
         VuxV0p8C+wJQowb1OL1l5NNOsxiAyY2cf6azc2lS6FgqmZY0T1Pn094YQgXLzaQ9IXK2
         6m1oE62l1UagjWOk1fIRlKllhNbI1m9n04sd/TGP9+dXafpjEeookEzU56PhWuVK8DJ7
         xzjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lZVV1y+iSaZlt0336aI4AjHEmp/+FSlUNb7E2ndj0xY=;
        b=julT+BVoX67ZjSQcwR1LUFbrJM50F+qYHdf1kgezKWKYlSqhuiSlbuNjArJQX0K8cB
         mT9JdEcugBUTh3EBQrlQFmjZ9AXMyBu9KbU0k4eFGzR8fYP1zexNtGJBjciS6FwtjRPI
         A51i4i60piwfY/g+NG3WQEDBVNuq+0TaQIXiIZMhsrA+HxzYI7yxfjLGsQ3uHMtE3/+S
         ODDdcJmDYAsSwx5mB3qoHUIpoOJgt2Jv/V+xCAO2ltsN4z7EpMn8z4F9W1JhcUeZt7XY
         UmQ2IqdPiIq2dPpH1ZXT9LJZv63hfwyVVwmm4KHHj6rlLwqH7ejwkfGvFBj2MMklq3ue
         5YjQ==
X-Gm-Message-State: AOAM532EwF/GJJn9ohRJV95PlzCsXyTYmmQ2lIYE5e15hTAW5n0rR7jk
        m6zKr/qDMkPTqiVSTi31o0lYubB6Y7c=
X-Google-Smtp-Source: ABdhPJz5J1Fhxvo3XGPh9XXRfgPWQBLhJS7B/qwn4gO+csdR6lm9b7qNx2+T56hVNkt1/agHzFSQMw==
X-Received: by 2002:a05:6402:1559:: with SMTP id p25mr767243edx.343.1623264132859;
        Wed, 09 Jun 2021 11:42:12 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id oz11sm194935ejb.16.2021.06.09.11.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:42:12 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 01/13] net: pcs: xpcs: rename mdio_xpcs_args to dw_xpcs
Date:   Wed,  9 Jun 2021 21:41:43 +0300
Message-Id: <20210609184155.921662-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609184155.921662-1-olteanv@gmail.com>
References: <20210609184155.921662-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The struct mdio_xpcs_args is reminiscent of when a similarly named
struct mdio_xpcs_ops existed. Now that that is removed, we can shorten
the name to dw_xpcs (dw for DesignWare).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |  2 +-
 drivers/net/pcs/pcs-xpcs.c                    | 73 +++++++++----------
 include/linux/pcs/pcs-xpcs.h                  | 14 ++--
 4 files changed, 45 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 8a83f9e1e95b..5fecc83f175b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -503,7 +503,7 @@ struct mac_device_info {
 	const struct stmmac_hwtimestamp *ptp;
 	const struct stmmac_tc_ops *tc;
 	const struct stmmac_mmc_ops *mmc;
-	struct mdio_xpcs_args *xpcs;
+	struct dw_xpcs *xpcs;
 	struct mii_regs mii;	/* MII register Addresses */
 	struct mac_link link;
 	void __iomem *pcsr;     /* vpointer to device CSRs */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index bc900e240da2..3b3033b20b1d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -401,7 +401,7 @@ int stmmac_xpcs_setup(struct mii_bus *bus)
 {
 	int mode, addr;
 	struct net_device *ndev = bus->priv;
-	struct mdio_xpcs_args *xpcs;
+	struct dw_xpcs *xpcs;
 	struct stmmac_priv *priv;
 	struct mdio_device *mdiodev;
 
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 98c4a3973402..a2cbb2d926b7 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -109,7 +109,7 @@
 #define DW_VR_MII_EEE_TRN_LPI		BIT(0)	/* Transparent Mode Enable */
 
 #define phylink_pcs_to_xpcs(pl_pcs) \
-	container_of((pl_pcs), struct mdio_xpcs_args, pcs)
+	container_of((pl_pcs), struct dw_xpcs, pcs)
 
 static const int xpcs_usxgmii_features[] = {
 	ETHTOOL_LINK_MODE_Pause_BIT,
@@ -236,7 +236,7 @@ static const struct xpcs_compat *xpcs_find_compat(const struct xpcs_id *id,
 	return NULL;
 }
 
-int xpcs_get_an_mode(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
+int xpcs_get_an_mode(struct dw_xpcs *xpcs, phy_interface_t interface)
 {
 	const struct xpcs_compat *compat;
 
@@ -263,7 +263,7 @@ static bool __xpcs_linkmode_supported(const struct xpcs_compat *compat,
 #define xpcs_linkmode_supported(compat, mode) \
 	__xpcs_linkmode_supported(compat, ETHTOOL_LINK_MODE_ ## mode ## _BIT)
 
-static int xpcs_read(struct mdio_xpcs_args *xpcs, int dev, u32 reg)
+static int xpcs_read(struct dw_xpcs *xpcs, int dev, u32 reg)
 {
 	u32 reg_addr = mdiobus_c45_addr(dev, reg);
 	struct mii_bus *bus = xpcs->mdiodev->bus;
@@ -272,7 +272,7 @@ static int xpcs_read(struct mdio_xpcs_args *xpcs, int dev, u32 reg)
 	return mdiobus_read(bus, addr, reg_addr);
 }
 
-static int xpcs_write(struct mdio_xpcs_args *xpcs, int dev, u32 reg, u16 val)
+static int xpcs_write(struct dw_xpcs *xpcs, int dev, u32 reg, u16 val)
 {
 	u32 reg_addr = mdiobus_c45_addr(dev, reg);
 	struct mii_bus *bus = xpcs->mdiodev->bus;
@@ -281,28 +281,28 @@ static int xpcs_write(struct mdio_xpcs_args *xpcs, int dev, u32 reg, u16 val)
 	return mdiobus_write(bus, addr, reg_addr, val);
 }
 
-static int xpcs_read_vendor(struct mdio_xpcs_args *xpcs, int dev, u32 reg)
+static int xpcs_read_vendor(struct dw_xpcs *xpcs, int dev, u32 reg)
 {
 	return xpcs_read(xpcs, dev, DW_VENDOR | reg);
 }
 
-static int xpcs_write_vendor(struct mdio_xpcs_args *xpcs, int dev, int reg,
+static int xpcs_write_vendor(struct dw_xpcs *xpcs, int dev, int reg,
 			     u16 val)
 {
 	return xpcs_write(xpcs, dev, DW_VENDOR | reg, val);
 }
 
-static int xpcs_read_vpcs(struct mdio_xpcs_args *xpcs, int reg)
+static int xpcs_read_vpcs(struct dw_xpcs *xpcs, int reg)
 {
 	return xpcs_read_vendor(xpcs, MDIO_MMD_PCS, reg);
 }
 
-static int xpcs_write_vpcs(struct mdio_xpcs_args *xpcs, int reg, u16 val)
+static int xpcs_write_vpcs(struct dw_xpcs *xpcs, int reg, u16 val)
 {
 	return xpcs_write_vendor(xpcs, MDIO_MMD_PCS, reg, val);
 }
 
-static int xpcs_poll_reset(struct mdio_xpcs_args *xpcs, int dev)
+static int xpcs_poll_reset(struct dw_xpcs *xpcs, int dev)
 {
 	/* Poll until the reset bit clears (50ms per retry == 0.6 sec) */
 	unsigned int retries = 12;
@@ -318,7 +318,7 @@ static int xpcs_poll_reset(struct mdio_xpcs_args *xpcs, int dev)
 	return (ret & MDIO_CTRL1_RESET) ? -ETIMEDOUT : 0;
 }
 
-static int xpcs_soft_reset(struct mdio_xpcs_args *xpcs,
+static int xpcs_soft_reset(struct dw_xpcs *xpcs,
 			   const struct xpcs_compat *compat)
 {
 	int ret, dev;
@@ -348,7 +348,7 @@ static int xpcs_soft_reset(struct mdio_xpcs_args *xpcs,
 		dev_warn(&(__xpcs)->mdiodev->dev, ##__args); \
 })
 
-static int xpcs_read_fault_c73(struct mdio_xpcs_args *xpcs,
+static int xpcs_read_fault_c73(struct dw_xpcs *xpcs,
 			       struct phylink_link_state *state)
 {
 	int ret;
@@ -399,7 +399,7 @@ static int xpcs_read_fault_c73(struct mdio_xpcs_args *xpcs,
 	return 0;
 }
 
-static int xpcs_read_link_c73(struct mdio_xpcs_args *xpcs, bool an)
+static int xpcs_read_link_c73(struct dw_xpcs *xpcs, bool an)
 {
 	bool link = true;
 	int ret;
@@ -439,7 +439,7 @@ static int xpcs_get_max_usxgmii_speed(const unsigned long *supported)
 	return max;
 }
 
-static void xpcs_config_usxgmii(struct mdio_xpcs_args *xpcs, int speed)
+static void xpcs_config_usxgmii(struct dw_xpcs *xpcs, int speed)
 {
 	int ret, speed_sel;
 
@@ -500,7 +500,7 @@ static void xpcs_config_usxgmii(struct mdio_xpcs_args *xpcs, int speed)
 	pr_err("%s: XPCS access returned %pe\n", __func__, ERR_PTR(ret));
 }
 
-static int _xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs,
+static int _xpcs_config_aneg_c73(struct dw_xpcs *xpcs,
 				 const struct xpcs_compat *compat)
 {
 	int ret, adv;
@@ -545,7 +545,7 @@ static int _xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs,
 	return xpcs_write(xpcs, MDIO_MMD_AN, DW_SR_AN_ADV1, adv);
 }
 
-static int xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs,
+static int xpcs_config_aneg_c73(struct dw_xpcs *xpcs,
 				const struct xpcs_compat *compat)
 {
 	int ret;
@@ -563,7 +563,7 @@ static int xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs,
 	return xpcs_write(xpcs, MDIO_MMD_AN, MDIO_CTRL1, ret);
 }
 
-static int xpcs_aneg_done_c73(struct mdio_xpcs_args *xpcs,
+static int xpcs_aneg_done_c73(struct dw_xpcs *xpcs,
 			      struct phylink_link_state *state,
 			      const struct xpcs_compat *compat)
 {
@@ -590,7 +590,7 @@ static int xpcs_aneg_done_c73(struct mdio_xpcs_args *xpcs,
 	return 0;
 }
 
-static int xpcs_read_lpa_c73(struct mdio_xpcs_args *xpcs,
+static int xpcs_read_lpa_c73(struct dw_xpcs *xpcs,
 			     struct phylink_link_state *state)
 {
 	int ret;
@@ -639,7 +639,7 @@ static int xpcs_read_lpa_c73(struct mdio_xpcs_args *xpcs,
 	return 0;
 }
 
-static void xpcs_resolve_lpa_c73(struct mdio_xpcs_args *xpcs,
+static void xpcs_resolve_lpa_c73(struct dw_xpcs *xpcs,
 				 struct phylink_link_state *state)
 {
 	int max_speed = xpcs_get_max_usxgmii_speed(state->lp_advertising);
@@ -649,7 +649,7 @@ static void xpcs_resolve_lpa_c73(struct mdio_xpcs_args *xpcs,
 	state->duplex = DUPLEX_FULL;
 }
 
-static int xpcs_get_max_xlgmii_speed(struct mdio_xpcs_args *xpcs,
+static int xpcs_get_max_xlgmii_speed(struct dw_xpcs *xpcs,
 				     struct phylink_link_state *state)
 {
 	unsigned long *adv = state->advertising;
@@ -703,7 +703,7 @@ static int xpcs_get_max_xlgmii_speed(struct mdio_xpcs_args *xpcs,
 	return speed;
 }
 
-static void xpcs_resolve_pma(struct mdio_xpcs_args *xpcs,
+static void xpcs_resolve_pma(struct dw_xpcs *xpcs,
 			     struct phylink_link_state *state)
 {
 	state->pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
@@ -722,7 +722,7 @@ static void xpcs_resolve_pma(struct mdio_xpcs_args *xpcs,
 	}
 }
 
-void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
+void xpcs_validate(struct dw_xpcs *xpcs, unsigned long *supported,
 		   struct phylink_link_state *state)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(xpcs_supported);
@@ -752,8 +752,7 @@ void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
 }
 EXPORT_SYMBOL_GPL(xpcs_validate);
 
-int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
-		    int enable)
+int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns, int enable)
 {
 	int ret;
 
@@ -786,7 +785,7 @@ int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
 }
 EXPORT_SYMBOL_GPL(xpcs_config_eee);
 
-static int xpcs_config_aneg_c37_sgmii(struct mdio_xpcs_args *xpcs)
+static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs)
 {
 	int ret;
 
@@ -827,7 +826,7 @@ static int xpcs_config_aneg_c37_sgmii(struct mdio_xpcs_args *xpcs)
 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
 }
 
-static int xpcs_config_2500basex(struct mdio_xpcs_args *xpcs)
+static int xpcs_config_2500basex(struct dw_xpcs *xpcs)
 {
 	int ret;
 
@@ -849,8 +848,8 @@ static int xpcs_config_2500basex(struct mdio_xpcs_args *xpcs)
 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, ret);
 }
 
-static int xpcs_do_config(struct mdio_xpcs_args *xpcs,
-			  phy_interface_t interface, unsigned int mode)
+static int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
+			  unsigned int mode)
 {
 	const struct xpcs_compat *compat;
 	int ret;
@@ -889,12 +888,12 @@ static int xpcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		       const unsigned long *advertising,
 		       bool permit_pause_to_mac)
 {
-	struct mdio_xpcs_args *xpcs = phylink_pcs_to_xpcs(pcs);
+	struct dw_xpcs *xpcs = phylink_pcs_to_xpcs(pcs);
 
 	return xpcs_do_config(xpcs, interface, mode);
 }
 
-static int xpcs_get_state_c73(struct mdio_xpcs_args *xpcs,
+static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
 			      struct phylink_link_state *state,
 			      const struct xpcs_compat *compat)
 {
@@ -928,7 +927,7 @@ static int xpcs_get_state_c73(struct mdio_xpcs_args *xpcs,
 	return 0;
 }
 
-static int xpcs_get_state_c37_sgmii(struct mdio_xpcs_args *xpcs,
+static int xpcs_get_state_c37_sgmii(struct dw_xpcs *xpcs,
 				    struct phylink_link_state *state)
 {
 	int ret;
@@ -972,7 +971,7 @@ static int xpcs_get_state_c37_sgmii(struct mdio_xpcs_args *xpcs,
 static void xpcs_get_state(struct phylink_pcs *pcs,
 			   struct phylink_link_state *state)
 {
-	struct mdio_xpcs_args *xpcs = phylink_pcs_to_xpcs(pcs);
+	struct dw_xpcs *xpcs = phylink_pcs_to_xpcs(pcs);
 	const struct xpcs_compat *compat;
 	int ret;
 
@@ -1004,13 +1003,13 @@ static void xpcs_get_state(struct phylink_pcs *pcs,
 static void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 			 phy_interface_t interface, int speed, int duplex)
 {
-	struct mdio_xpcs_args *xpcs = phylink_pcs_to_xpcs(pcs);
+	struct dw_xpcs *xpcs = phylink_pcs_to_xpcs(pcs);
 
 	if (interface == PHY_INTERFACE_MODE_USXGMII)
 		return xpcs_config_usxgmii(xpcs, speed);
 }
 
-static u32 xpcs_get_id(struct mdio_xpcs_args *xpcs)
+static u32 xpcs_get_id(struct dw_xpcs *xpcs)
 {
 	int ret;
 	u32 id;
@@ -1095,10 +1094,10 @@ static const struct phylink_pcs_ops xpcs_phylink_ops = {
 	.pcs_link_up = xpcs_link_up,
 };
 
-struct mdio_xpcs_args *xpcs_create(struct mdio_device *mdiodev,
-				   phy_interface_t interface)
+struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
+			    phy_interface_t interface)
 {
-	struct mdio_xpcs_args *xpcs;
+	struct dw_xpcs *xpcs;
 	u32 xpcs_id;
 	int i, ret;
 
@@ -1144,7 +1143,7 @@ struct mdio_xpcs_args *xpcs_create(struct mdio_device *mdiodev,
 }
 EXPORT_SYMBOL_GPL(xpcs_create);
 
-void xpcs_destroy(struct mdio_xpcs_args *xpcs)
+void xpcs_destroy(struct dw_xpcs *xpcs)
 {
 	kfree(xpcs);
 }
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 4d815f03b4b2..4f1cdf6f3d4c 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -17,19 +17,19 @@
 
 struct xpcs_id;
 
-struct mdio_xpcs_args {
+struct dw_xpcs {
 	struct mdio_device *mdiodev;
 	const struct xpcs_id *id;
 	struct phylink_pcs pcs;
 };
 
-int xpcs_get_an_mode(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
-void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
+int xpcs_get_an_mode(struct dw_xpcs *xpcs, phy_interface_t interface);
+void xpcs_validate(struct dw_xpcs *xpcs, unsigned long *supported,
 		   struct phylink_link_state *state);
-int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
+int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns,
 		    int enable);
-struct mdio_xpcs_args *xpcs_create(struct mdio_device *mdiodev,
-				   phy_interface_t interface);
-void xpcs_destroy(struct mdio_xpcs_args *xpcs);
+struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
+			    phy_interface_t interface);
+void xpcs_destroy(struct dw_xpcs *xpcs);
 
 #endif /* __LINUX_PCS_XPCS_H */
-- 
2.25.1

