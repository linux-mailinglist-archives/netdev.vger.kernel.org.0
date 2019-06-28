Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01C22594E7
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfF1H33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 03:29:29 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:47988 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725792AbfF1H3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:29:25 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 12F64C0BE9;
        Fri, 28 Jun 2019 07:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561706965; bh=IccGUKOHDR/b38rhUdgJPsk514AFw+D9drlccvFJMpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=YDiUMpG1wpLxye2fKOiZaHzHwQGKrXs4IoBtisMuSYVey5PkYAJs6XtfqVGqmzarx
         yZBiJUtB5reqyH5X2meCazzRgo1G7otB5oWeKx1MrppqQj+qe+v53uX6hnhuSMesvZ
         mgkE5nGHTi4f8H316l0ZbsOnKTOZBqhGQWf7oyr/ADcYrWpFt3AtJnw91dTDCj6qkE
         SKLvzP0BTbjDqfRrqJ4I0gwdMqE+zAhaqZFQVLJwMzh2ZtoTpRuuJ6FbVdPyTt95TP
         VEIP39jn1PiHyXtD0JuiIcBFuWXX1OLaOOYD18YLPtVbs1hazsqpRYlWXCBtO/ICSR
         6mjbfpgd3IIXg==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id AE2A1A0235;
        Fri, 28 Jun 2019 07:29:23 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 9A5A43E958;
        Fri, 28 Jun 2019 09:29:23 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 05/10] net: stmmac: Add the missing speeds that XGMAC supports
Date:   Fri, 28 Jun 2019 09:29:16 +0200
Message-Id: <978ab2150f02207d2bcccc8f95dbc1ed18f6868c.1561706801.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561706800.git.joabreu@synopsys.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
In-Reply-To: <cover.1561706800.git.joabreu@synopsys.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XGMAC supports following speeds:
	- 10G XGMII
	- 5G XGMII
	- 2.5G XGMII
	- 2.5G GMII
	- 1G GMII
	- 100M MII
	- 10M MII

Add them to the stmmac driver.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h       |  6 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     | 10 ++-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 14 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 79 ++++++++++++++++++----
 4 files changed, 86 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 14d8f6d7cb9a..9e8f4dbdcc22 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -392,8 +392,12 @@ struct mac_link {
 	u32 speed100;
 	u32 speed1000;
 	u32 speed2500;
-	u32 speed10000;
 	u32 duplex;
+	struct {
+		u32 speed2500;
+		u32 speed5000;
+		u32 speed10000;
+	} xgmii;
 };
 
 struct mii_regs {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index c9e802faabb5..29db9b538874 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -15,10 +15,14 @@
 /* MAC Registers */
 #define XGMAC_TX_CONFIG			0x00000000
 #define XGMAC_CONFIG_SS_OFF		29
-#define XGMAC_CONFIG_SS_MASK		GENMASK(30, 29)
+#define XGMAC_CONFIG_SS_MASK		GENMASK(31, 29)
 #define XGMAC_CONFIG_SS_10000		(0x0 << XGMAC_CONFIG_SS_OFF)
-#define XGMAC_CONFIG_SS_2500		(0x2 << XGMAC_CONFIG_SS_OFF)
-#define XGMAC_CONFIG_SS_1000		(0x3 << XGMAC_CONFIG_SS_OFF)
+#define XGMAC_CONFIG_SS_2500_GMII	(0x2 << XGMAC_CONFIG_SS_OFF)
+#define XGMAC_CONFIG_SS_1000_GMII	(0x3 << XGMAC_CONFIG_SS_OFF)
+#define XGMAC_CONFIG_SS_100_MII		(0x4 << XGMAC_CONFIG_SS_OFF)
+#define XGMAC_CONFIG_SS_5000		(0x5 << XGMAC_CONFIG_SS_OFF)
+#define XGMAC_CONFIG_SS_2500		(0x6 << XGMAC_CONFIG_SS_OFF)
+#define XGMAC_CONFIG_SS_10_MII		(0x7 << XGMAC_CONFIG_SS_OFF)
 #define XGMAC_CONFIG_SARC		GENMASK(22, 20)
 #define XGMAC_CONFIG_SARC_SHIFT		20
 #define XGMAC_CONFIG_JD			BIT(16)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index bfa7d6913fd4..0a32c96a7854 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -36,7 +36,7 @@ static void dwxgmac2_core_init(struct mac_device_info *hw,
 
 		switch (hw->ps) {
 		case SPEED_10000:
-			tx |= hw->link.speed10000;
+			tx |= hw->link.xgmii.speed10000;
 			break;
 		case SPEED_2500:
 			tx |= hw->link.speed2500;
@@ -381,11 +381,13 @@ int dwxgmac2_setup(struct stmmac_priv *priv)
 		mac->mcast_bits_log2 = ilog2(mac->multicast_filter_bins);
 
 	mac->link.duplex = 0;
-	mac->link.speed10 = 0;
-	mac->link.speed100 = 0;
-	mac->link.speed1000 = XGMAC_CONFIG_SS_1000;
-	mac->link.speed2500 = XGMAC_CONFIG_SS_2500;
-	mac->link.speed10000 = XGMAC_CONFIG_SS_10000;
+	mac->link.speed10 = XGMAC_CONFIG_SS_10_MII;
+	mac->link.speed100 = XGMAC_CONFIG_SS_100_MII;
+	mac->link.speed1000 = XGMAC_CONFIG_SS_1000_GMII;
+	mac->link.speed2500 = XGMAC_CONFIG_SS_2500_GMII;
+	mac->link.xgmii.speed2500 = XGMAC_CONFIG_SS_2500;
+	mac->link.xgmii.speed5000 = XGMAC_CONFIG_SS_5000;
+	mac->link.xgmii.speed10000 = XGMAC_CONFIG_SS_10000;
 	mac->link.speed_mask = XGMAC_CONFIG_SS_MASK;
 
 	mac->mii.addr = XGMAC_MDIO_ADDR;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 40408a067400..4a5941caaadc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -805,14 +805,43 @@ static void stmmac_validate(struct phylink_config *config,
 			    struct phylink_link_state *state)
 {
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mac_supported) = { 0, };
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 	int tx_cnt = priv->plat->tx_queues_to_use;
 	int max_speed = priv->plat->max_speed;
 
+	phylink_set(mac_supported, 10baseT_Half);
+	phylink_set(mac_supported, 10baseT_Full);
+	phylink_set(mac_supported, 100baseT_Half);
+	phylink_set(mac_supported, 100baseT_Full);
+
+	phylink_set(mac_supported, Autoneg);
+	phylink_set(mac_supported, Pause);
+	phylink_set(mac_supported, Asym_Pause);
+	phylink_set_port_modes(mac_supported);
+
+	if (priv->plat->has_gmac ||
+	    priv->plat->has_gmac4 ||
+	    priv->plat->has_xgmac) {
+		phylink_set(mac_supported, 1000baseT_Half);
+		phylink_set(mac_supported, 1000baseT_Full);
+		phylink_set(mac_supported, 1000baseKX_Full);
+	}
+
 	/* Cut down 1G if asked to */
 	if ((max_speed > 0) && (max_speed < 1000)) {
 		phylink_set(mask, 1000baseT_Full);
 		phylink_set(mask, 1000baseX_Full);
+	} else if (priv->plat->has_xgmac) {
+		phylink_set(mac_supported, 2500baseT_Full);
+		phylink_set(mac_supported, 5000baseT_Full);
+		phylink_set(mac_supported, 10000baseSR_Full);
+		phylink_set(mac_supported, 10000baseLR_Full);
+		phylink_set(mac_supported, 10000baseER_Full);
+		phylink_set(mac_supported, 10000baseLRM_Full);
+		phylink_set(mac_supported, 10000baseT_Full);
+		phylink_set(mac_supported, 10000baseKX4_Full);
+		phylink_set(mac_supported, 10000baseKR_Full);
 	}
 
 	/* Half-Duplex can only work with single queue */
@@ -822,7 +851,12 @@ static void stmmac_validate(struct phylink_config *config,
 		phylink_set(mask, 1000baseT_Half);
 	}
 
-	bitmap_andnot(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(supported, supported, mac_supported,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_andnot(supported, supported, mask,
+		      __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mac_supported,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
 	bitmap_andnot(state->advertising, state->advertising, mask,
 		      __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
@@ -842,18 +876,37 @@ static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
 	ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
 	ctrl &= ~priv->hw->link.speed_mask;
 
-	switch (state->speed) {
-	case SPEED_1000:
-		ctrl |= priv->hw->link.speed1000;
-		break;
-	case SPEED_100:
-		ctrl |= priv->hw->link.speed100;
-		break;
-	case SPEED_10:
-		ctrl |= priv->hw->link.speed10;
-		break;
-	default:
-		return;
+	if (state->interface == PHY_INTERFACE_MODE_USXGMII) {
+		switch (state->speed) {
+		case SPEED_10000:
+			ctrl |= priv->hw->link.xgmii.speed10000;
+			break;
+		case SPEED_5000:
+			ctrl |= priv->hw->link.xgmii.speed5000;
+			break;
+		case SPEED_2500:
+			ctrl |= priv->hw->link.xgmii.speed2500;
+			break;
+		default:
+			return;
+		}
+	} else {
+		switch (state->speed) {
+		case SPEED_2500:
+			ctrl |= priv->hw->link.speed2500;
+			break;
+		case SPEED_1000:
+			ctrl |= priv->hw->link.speed1000;
+			break;
+		case SPEED_100:
+			ctrl |= priv->hw->link.speed100;
+			break;
+		case SPEED_10:
+			ctrl |= priv->hw->link.speed10;
+			break;
+		default:
+			return;
+		}
 	}
 
 	priv->speed = state->speed;
-- 
2.7.4

