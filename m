Return-Path: <netdev+bounces-11417-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFF707330CE
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:07:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A9CB2816FD
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D558118C1B;
	Fri, 16 Jun 2023 12:06:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ACE19BA8
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 12:06:54 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0497630DD
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=NtI/xlg2JkySFlJdtFDtJuE0yQO9r62xLvg5DGpcsbU=; b=WCvB0rTzrhoU0VYbzui9+ldidb
	G6G1jfJciA3pf6zZXZprzEMYw2kVzyoN8LgHR0sYzIz047lfeb93rg38QBSwj4Lt6f55Ww4mbgFse
	6Fh8jzQm2Gp06IhytM6TBJtU7PU1yRGTOmZVvRj7MwGcSdDvb92WCfrmMoqgltBVvLcNS2R3LbIVG
	V+7R0dserFwZSUjsHQamewOcXFL6KGj5nLygXVapkwwE63goGSzwKkgEBsbyuXdZCYzih3qAEpzEG
	2SxJNA32dEI6AQaVqBQzNrzMHtR8TLrTWxP4SMbCIla08x437LBU+fG/FQ4v1Ft7yOrhB8WpDFt1s
	rAwfTHEw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46082 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1qA8Du-00052X-Oa; Fri, 16 Jun 2023 13:06:39 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1qA8Dt-00EaFS-W9; Fri, 16 Jun 2023 13:06:38 +0100
In-Reply-To: <ZIxQIBfO9dH5xFlg@shell.armlinux.org.uk>
References: <ZIxQIBfO9dH5xFlg@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Alexander Couzens <lynxis@fe80.eu>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Cc@web.codeaurora.org:Alexander Couzens <lynxis@fe80.eu>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	DENG Qingfang <dqfext@gmail.com>, Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Madalin Bucur <madalin.bucur@nxp.com>,
	Marcin Wojtas <mw@semihalf.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Michal Simek <michal.simek@amd.com>, netdev@vger.kernel.org,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 04/15] net: pcs: xpcs: update PCS driver to use
 neg_mode
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1qA8Dt-00EaFS-W9@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 16 Jun 2023 13:06:37 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Update xpcs to use neg_mode to configure whether inband negotiation
should be used. We need to update sja1105 as well as that directly
calls into the XPCS driver's config function.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 14 ++++-----
 drivers/net/pcs/pcs-xpcs.c             | 43 ++++++++++++++------------
 include/linux/pcs/pcs-xpcs.h           |  4 +--
 3 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b70dcf32a26d..a55a6436fc05 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2314,7 +2314,7 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 
 	for (i = 0; i < ds->num_ports; i++) {
 		struct dw_xpcs *xpcs = priv->xpcs[i];
-		unsigned int mode;
+		unsigned int neg_mode;
 
 		rc = sja1105_adjust_port_config(priv, i, speed_mbps[i]);
 		if (rc < 0)
@@ -2324,17 +2324,15 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 			continue;
 
 		if (bmcr[i] & BMCR_ANENABLE)
-			mode = MLO_AN_INBAND;
-		else if (priv->fixed_link[i])
-			mode = MLO_AN_FIXED;
+			neg_mode = PHYLINK_PCS_NEG_INBAND_ENABLED;
 		else
-			mode = MLO_AN_PHY;
+			neg_mode = PHYLINK_PCS_NEG_OUTBAND;
 
-		rc = xpcs_do_config(xpcs, priv->phy_mode[i], mode, NULL);
+		rc = xpcs_do_config(xpcs, priv->phy_mode[i], NULL, neg_mode);
 		if (rc < 0)
 			goto out;
 
-		if (!phylink_autoneg_inband(mode)) {
+		if (neg_mode == PHYLINK_PCS_NEG_OUTBAND) {
 			int speed = SPEED_UNKNOWN;
 
 			if (priv->phy_mode[i] == PHY_INTERFACE_MODE_2500BASEX)
@@ -2346,7 +2344,7 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 			else
 				speed = SPEED_10;
 
-			xpcs_link_up(&xpcs->pcs, mode, priv->phy_mode[i],
+			xpcs_link_up(&xpcs->pcs, neg_mode, priv->phy_mode[i],
 				     speed, DUPLEX_FULL);
 		}
 	}
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index e4e59aa9faf7..44b037646865 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -657,7 +657,8 @@ int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns, int enable)
 }
 EXPORT_SYMBOL_GPL(xpcs_config_eee);
 
-static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
+static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs,
+				      unsigned int neg_mode)
 {
 	int ret, mdio_ctrl;
 
@@ -707,7 +708,7 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 	if (ret < 0)
 		return ret;
 
-	if (phylink_autoneg_inband(mode))
+	if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED)
 		ret |= DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
 	else
 		ret &= ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
@@ -716,14 +717,15 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 	if (ret < 0)
 		return ret;
 
-	if (phylink_autoneg_inband(mode))
+	if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED)
 		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
 				 mdio_ctrl | AN_CL37_EN);
 
 	return ret;
 }
 
-static int xpcs_config_aneg_c37_1000basex(struct dw_xpcs *xpcs, unsigned int mode,
+static int xpcs_config_aneg_c37_1000basex(struct dw_xpcs *xpcs,
+					  unsigned int neg_mode,
 					  const unsigned long *advertising)
 {
 	phy_interface_t interface = PHY_INTERFACE_MODE_1000BASEX;
@@ -774,8 +776,7 @@ static int xpcs_config_aneg_c37_1000basex(struct dw_xpcs *xpcs, unsigned int mod
 	if (ret < 0)
 		return ret;
 
-	if (phylink_autoneg_inband(mode) &&
-	    linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising)) {
+	if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED) {
 		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
 				 mdio_ctrl | AN_CL37_EN);
 		if (ret < 0)
@@ -808,7 +809,7 @@ static int xpcs_config_2500basex(struct dw_xpcs *xpcs)
 }
 
 int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
-		   unsigned int mode, const unsigned long *advertising)
+		   const unsigned long *advertising, unsigned int neg_mode)
 {
 	const struct xpcs_compat *compat;
 	int ret;
@@ -821,19 +822,19 @@ int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 	case DW_10GBASER:
 		break;
 	case DW_AN_C73:
-		if (test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising)) {
+		if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED) {
 			ret = xpcs_config_aneg_c73(xpcs, compat);
 			if (ret)
 				return ret;
 		}
 		break;
 	case DW_AN_C37_SGMII:
-		ret = xpcs_config_aneg_c37_sgmii(xpcs, mode);
+		ret = xpcs_config_aneg_c37_sgmii(xpcs, neg_mode);
 		if (ret)
 			return ret;
 		break;
 	case DW_AN_C37_1000BASEX:
-		ret = xpcs_config_aneg_c37_1000basex(xpcs, mode,
+		ret = xpcs_config_aneg_c37_1000basex(xpcs, neg_mode,
 						     advertising);
 		if (ret)
 			return ret;
@@ -857,14 +858,14 @@ int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 }
 EXPORT_SYMBOL_GPL(xpcs_do_config);
 
-static int xpcs_config(struct phylink_pcs *pcs, unsigned int mode,
+static int xpcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 		       phy_interface_t interface,
 		       const unsigned long *advertising,
 		       bool permit_pause_to_mac)
 {
 	struct dw_xpcs *xpcs = phylink_pcs_to_xpcs(pcs);
 
-	return xpcs_do_config(xpcs, interface, mode, advertising);
+	return xpcs_do_config(xpcs, interface, advertising, neg_mode);
 }
 
 static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
@@ -898,7 +899,8 @@ static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
 
 		state->link = 0;
 
-		return xpcs_do_config(xpcs, state->interface, MLO_AN_INBAND, NULL);
+		return xpcs_do_config(xpcs, state->interface, NULL,
+				      PHYLINK_PCS_NEG_INBAND_ENABLED);
 	}
 
 	/* There is no point doing anything else if the link is down. */
@@ -1046,12 +1048,12 @@ static void xpcs_get_state(struct phylink_pcs *pcs,
 	}
 }
 
-static void xpcs_link_up_sgmii(struct dw_xpcs *xpcs, unsigned int mode,
+static void xpcs_link_up_sgmii(struct dw_xpcs *xpcs, unsigned int neg_mode,
 			       int speed, int duplex)
 {
 	int val, ret;
 
-	if (phylink_autoneg_inband(mode))
+	if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED)
 		return;
 
 	val = mii_bmcr_encode_fixed(speed, duplex);
@@ -1060,12 +1062,12 @@ static void xpcs_link_up_sgmii(struct dw_xpcs *xpcs, unsigned int mode,
 		pr_err("%s: xpcs_write returned %pe\n", __func__, ERR_PTR(ret));
 }
 
-static void xpcs_link_up_1000basex(struct dw_xpcs *xpcs, unsigned int mode,
+static void xpcs_link_up_1000basex(struct dw_xpcs *xpcs, unsigned int neg_mode,
 				   int speed, int duplex)
 {
 	int val, ret;
 
-	if (phylink_autoneg_inband(mode))
+	if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED)
 		return;
 
 	switch (speed) {
@@ -1089,7 +1091,7 @@ static void xpcs_link_up_1000basex(struct dw_xpcs *xpcs, unsigned int mode,
 		pr_err("%s: xpcs_write returned %pe\n", __func__, ERR_PTR(ret));
 }
 
-void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+void xpcs_link_up(struct phylink_pcs *pcs, unsigned int neg_mode,
 		  phy_interface_t interface, int speed, int duplex)
 {
 	struct dw_xpcs *xpcs = phylink_pcs_to_xpcs(pcs);
@@ -1097,9 +1099,9 @@ void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 	if (interface == PHY_INTERFACE_MODE_USXGMII)
 		return xpcs_config_usxgmii(xpcs, speed);
 	if (interface == PHY_INTERFACE_MODE_SGMII)
-		return xpcs_link_up_sgmii(xpcs, mode, speed, duplex);
+		return xpcs_link_up_sgmii(xpcs, neg_mode, speed, duplex);
 	if (interface == PHY_INTERFACE_MODE_1000BASEX)
-		return xpcs_link_up_1000basex(xpcs, mode, speed, duplex);
+		return xpcs_link_up_1000basex(xpcs, neg_mode, speed, duplex);
 }
 EXPORT_SYMBOL_GPL(xpcs_link_up);
 
@@ -1283,6 +1285,7 @@ static struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
 		}
 
 		xpcs->pcs.ops = &xpcs_phylink_ops;
+		xpcs->pcs.neg_mode = true;
 		if (compat->an_mode == DW_10GBASER)
 			return xpcs;
 
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index ec8175b847cc..ff99cf7a5d0d 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -29,10 +29,10 @@ struct dw_xpcs {
 };
 
 int xpcs_get_an_mode(struct dw_xpcs *xpcs, phy_interface_t interface);
-void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+void xpcs_link_up(struct phylink_pcs *pcs, unsigned int neg_mode,
 		  phy_interface_t interface, int speed, int duplex);
 int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
-		   unsigned int mode, const unsigned long *advertising);
+		   const unsigned long *advertising, unsigned int neg_mode);
 void xpcs_get_interfaces(struct dw_xpcs *xpcs, unsigned long *interfaces);
 int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns,
 		    int enable);
-- 
2.30.2


