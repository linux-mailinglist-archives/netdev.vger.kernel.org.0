Return-Path: <netdev+bounces-10408-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFFBD72E5EB
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:38:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31A981C209EA
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D712A6F4;
	Tue, 13 Jun 2023 14:37:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E606D23DB
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:37:53 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32CB172B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/SdxG8eZJcstNtF+F6g4ls6raucD6WdcYye0InZUeFY=; b=0lBKyZHw6IkYRFwgmbPhx7IVdi
	JyeFC1VQtKHK2nDriHrN/PduOVffQ86sRdCSXVx3HjXcqOZCoJAv48p8EHcZKKF3jWfIgYx3BSt2X
	YzmzDef2s66aMUyUHI4pXVh9JNaloa2TNkkkhNk0JZm6yNZi4ft5tjnSUoQ27ck146Dgm7qOZ8Lu3
	G535/j2dYa/hUUUeIvE/WvK2YtWH5V32n1Tu02Mek9a7y0ZomNQdGET7CRquqFmGAaZuHgCM3IuFj
	1+/8U5R4ym8LFG+i9X3Tfj8mK/k0o+ZB/ZsumH9PVSwMIOsBSRULC4VJIT1WKho6j81lzuIju4ZlD
	ZE1WoZzg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:35604 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q959J-0007Q3-EA; Tue, 13 Jun 2023 15:37:33 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q959I-00EBvY-Oq; Tue, 13 Jun 2023 15:37:32 +0100
In-Reply-To: <ZIh/CLQ3z89g0Ua0@shell.armlinux.org.uk>
References: <ZIh/CLQ3z89g0Ua0@shell.armlinux.org.uk>
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
Subject: [PATCH RFC net-next 01/15] net: phylink: add PCS negotiation mode
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q959I-00EBvY-Oq@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 13 Jun 2023 15:37:32 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PCS have to work out whether they should enable PCS negotiation by
looking at the "mode" and "interface" arguments, and the Autoneg bit
in the advertising mask.

This leads to some complex logic, so lets pull that out into phylink
and instead pass a "neg_mode" argument to the PCS configuration and
link up methods, instead of the "mode" argument.

In order to transition drivers, add a "neg_mode" flag to the phylink
PCS structure to PCS can indicate whether they want to be passed the
neg_mode or the old mode argument.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c |  45 +++++++++++++----
 include/linux/phylink.h   | 104 +++++++++++++++++++++++++++++++++++---
 2 files changed, 132 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 1ae7868d2137..e2169ca00979 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -71,6 +71,7 @@ struct phylink {
 	struct mutex state_mutex;
 	struct phylink_link_state phy_state;
 	struct work_struct resolve;
+	unsigned int pcs_neg_mode;
 
 	bool mac_link_dropped;
 	bool using_mac_select_pcs;
@@ -992,23 +993,23 @@ static void phylink_resolve_an_pause(struct phylink_link_state *state)
 	}
 }
 
-static int phylink_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+static int phylink_pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 			      const struct phylink_link_state *state,
 			      bool permit_pause_to_mac)
 {
 	if (!pcs)
 		return 0;
 
-	return pcs->ops->pcs_config(pcs, mode, state->interface,
+	return pcs->ops->pcs_config(pcs, neg_mode, state->interface,
 				    state->advertising, permit_pause_to_mac);
 }
 
-static void phylink_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+static void phylink_pcs_link_up(struct phylink_pcs *pcs, unsigned int neg_mode,
 				phy_interface_t interface, int speed,
 				int duplex)
 {
 	if (pcs && pcs->ops->pcs_link_up)
-		pcs->ops->pcs_link_up(pcs, mode, interface, speed, duplex);
+		pcs->ops->pcs_link_up(pcs, neg_mode, interface, speed, duplex);
 }
 
 static void phylink_pcs_poll_stop(struct phylink *pl)
@@ -1058,10 +1059,15 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 	struct phylink_pcs *pcs = NULL;
 	bool pcs_changed = false;
 	unsigned int rate_kbd;
+	unsigned int neg_mode;
 	int err;
 
 	phylink_dbg(pl, "major config %s\n", phy_modes(state->interface));
 
+	pl->pcs_neg_mode = phylink_pcs_neg_mode(pl->cur_link_an_mode,
+						state->interface,
+						state->advertising);
+
 	if (pl->using_mac_select_pcs) {
 		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
 		if (IS_ERR(pcs)) {
@@ -1094,9 +1100,12 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 
 	phylink_mac_config(pl, state);
 
-	err = phylink_pcs_config(pl->pcs, pl->cur_link_an_mode, state,
-				 !!(pl->link_config.pause &
-				    MLO_PAUSE_AN));
+	neg_mode = pl->cur_link_an_mode;
+	if (pl->pcs && pl->pcs->neg_mode)
+		neg_mode = pl->pcs_neg_mode;
+
+	err = phylink_pcs_config(pl->pcs, neg_mode, state,
+				 !!(pl->link_config.pause & MLO_PAUSE_AN));
 	if (err < 0)
 		phylink_err(pl, "pcs_config failed: %pe\n",
 			    ERR_PTR(err));
@@ -1131,6 +1140,7 @@ static void phylink_major_config(struct phylink *pl, bool restart,
  */
 static int phylink_change_inband_advert(struct phylink *pl)
 {
+	unsigned int neg_mode;
 	int ret;
 
 	if (test_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state))
@@ -1149,12 +1159,20 @@ static int phylink_change_inband_advert(struct phylink *pl)
 		    __ETHTOOL_LINK_MODE_MASK_NBITS, pl->link_config.advertising,
 		    pl->link_config.pause);
 
+	/* Recompute the PCS neg mode */
+	pl->pcs_neg_mode = phylink_pcs_neg_mode(pl->cur_link_an_mode,
+					pl->link_config.interface,
+					pl->link_config.advertising);
+
+	neg_mode = pl->cur_link_an_mode;
+	if (pl->pcs->neg_mode)
+		neg_mode = pl->pcs_neg_mode;
+
 	/* Modern PCS-based method; update the advert at the PCS, and
 	 * restart negotiation if the pcs_config() helper indicates that
 	 * the programmed advertisement has changed.
 	 */
-	ret = phylink_pcs_config(pl->pcs, pl->cur_link_an_mode,
-				 &pl->link_config,
+	ret = phylink_pcs_config(pl->pcs, neg_mode, &pl->link_config,
 				 !!(pl->link_config.pause & MLO_PAUSE_AN));
 	if (ret < 0)
 		return ret;
@@ -1257,6 +1275,7 @@ static void phylink_link_up(struct phylink *pl,
 			    struct phylink_link_state link_state)
 {
 	struct net_device *ndev = pl->netdev;
+	unsigned int neg_mode;
 	int speed, duplex;
 	bool rx_pause;
 
@@ -1287,8 +1306,12 @@ static void phylink_link_up(struct phylink *pl,
 
 	pl->cur_interface = link_state.interface;
 
-	phylink_pcs_link_up(pl->pcs, pl->cur_link_an_mode, pl->cur_interface,
-			    speed, duplex);
+	neg_mode = pl->cur_link_an_mode;
+	if (pl->pcs && pl->pcs->neg_mode)
+		neg_mode = pl->pcs_neg_mode;
+
+	phylink_pcs_link_up(pl->pcs, neg_mode, pl->cur_interface, speed,
+			    duplex);
 
 	pl->mac_ops->mac_link_up(pl->config, pl->phydev, pl->cur_link_an_mode,
 				 pl->cur_interface, speed, duplex,
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 0cf07d7d11b8..2b322d7fa51a 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -21,6 +21,24 @@ enum {
 	MLO_AN_FIXED,	/* Fixed-link mode */
 	MLO_AN_INBAND,	/* In-band protocol */
 
+	/* PCS "negotiation" mode.
+	 *  PHYLINK_PCS_NEG_NONE - protocol has no inband capability
+	 *  PHYLINK_PCS_NEG_OUTBAND - some out of band or fixed link setting
+	 *  PHYLINK_PCS_NEG_INBAND_DISABLED - inband mode disabled, e.g.
+	 *				      1000base-X with autoneg off
+	 *  PHYLINK_PCS_NEG_INBAND_ENABLED - inband mode enabled
+	 * Additionally, this can be tested using bitmasks:
+	 *  PHYLINK_PCS_NEG_INBAND - inband mode selected
+	 *  PHYLINK_PCS_NEG_ENABLED - negotiation mode enabled
+	 */
+	PHYLINK_PCS_NEG_NONE = 0,
+	PHYLINK_PCS_NEG_ENABLED = BIT(4),
+	PHYLINK_PCS_NEG_OUTBAND = BIT(5),
+	PHYLINK_PCS_NEG_INBAND = BIT(6),
+	PHYLINK_PCS_NEG_INBAND_DISABLED = PHYLINK_PCS_NEG_INBAND,
+	PHYLINK_PCS_NEG_INBAND_ENABLED = PHYLINK_PCS_NEG_INBAND |
+					 PHYLINK_PCS_NEG_ENABLED,
+
 	/* MAC_SYM_PAUSE and MAC_ASYM_PAUSE are used when configuring our
 	 * autonegotiation advertisement. They correspond to the PAUSE and
 	 * ASM_DIR bits defined by 802.3, respectively.
@@ -79,6 +97,70 @@ static inline bool phylink_autoneg_inband(unsigned int mode)
 	return mode == MLO_AN_INBAND;
 }
 
+/**
+ * phylink_pcs_neg_mode() - helper to determine PCS inband mode
+ * @mode: one of %MLO_AN_FIXED, %MLO_AN_PHY, %MLO_AN_INBAND.
+ * @interface: interface mode to be used
+ * @advertising: adertisement ethtool link mode mask
+ *
+ * Determines the negotiation mode to be used by the PCS, and returns
+ * one of:
+ * %PHYLINK_PCS_NEG_NONE: interface mode does not support inband
+ * %PHYLINK_PCS_NEG_OUTBAND: an out of band mode (e.g. reading the PHY)
+ *   will be used.
+ * %PHYLINK_PCS_NEG_INBAND_DISABLED: inband mode selected but autoneg disabled
+ * %PHYLINK_PCS_NEG_INBAND_ENABLED: inband mode selected and autoneg enabled
+ *
+ * Note: this is for cases where the PCS itself is involved in negotiation
+ * (e.g. Clause 37, SGMII and similar) not Clause 73.
+ */
+static inline unsigned int phylink_pcs_neg_mode(unsigned int mode,
+						phy_interface_t interface,
+						const unsigned long *advertising)
+{
+	unsigned int neg_mode;
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_QUSGMII:
+	case PHY_INTERFACE_MODE_USXGMII:
+		/* These protocols are designed for use with a PHY which
+		 * communicates its negotiation result back to the MAC via
+		 * inband communication. Note: there exist PHYs that run
+		 * with SGMII but do not send the inband data.
+		 */
+		if (!phylink_autoneg_inband(mode))
+			neg_mode = PHYLINK_PCS_NEG_OUTBAND;
+		else
+			neg_mode = PHYLINK_PCS_NEG_INBAND_ENABLED;
+		break;
+
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		/* 1000base-X is designed for use media-side for Fibre
+		 * connections, and thus the Autoneg bit needs to be
+		 * taken into account. We also do this for 2500base-X
+		 * as well, but drivers may not support this, so may
+		 * need to override this.
+		 */
+		if (!phylink_autoneg_inband(mode))
+			neg_mode = PHYLINK_PCS_NEG_OUTBAND;
+		else if (linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+					   advertising))
+			neg_mode = PHYLINK_PCS_NEG_INBAND_ENABLED;
+		else
+			neg_mode = PHYLINK_PCS_NEG_INBAND_DISABLED;
+		break;
+
+	default:
+		neg_mode = PHYLINK_PCS_NEG_NONE;
+		break;
+	}
+
+	return neg_mode;
+}
+
 /**
  * struct phylink_link_state - link state structure
  * @advertising: ethtool bitmask containing advertised link modes
@@ -436,6 +518,7 @@ struct phylink_pcs_ops;
 /**
  * struct phylink_pcs - PHYLINK PCS instance
  * @ops: a pointer to the &struct phylink_pcs_ops structure
+ * @neg_mode: provide PCS neg mode via "mode" argument
  * @poll: poll the PCS for link changes
  *
  * This structure is designed to be embedded within the PCS private data,
@@ -443,6 +526,7 @@ struct phylink_pcs_ops;
  */
 struct phylink_pcs {
 	const struct phylink_pcs_ops *ops;
+	bool neg_mode;
 	bool poll;
 };
 
@@ -460,12 +544,12 @@ struct phylink_pcs_ops {
 			    const struct phylink_link_state *state);
 	void (*pcs_get_state)(struct phylink_pcs *pcs,
 			      struct phylink_link_state *state);
-	int (*pcs_config)(struct phylink_pcs *pcs, unsigned int mode,
+	int (*pcs_config)(struct phylink_pcs *pcs, unsigned int neg_mode,
 			  phy_interface_t interface,
 			  const unsigned long *advertising,
 			  bool permit_pause_to_mac);
 	void (*pcs_an_restart)(struct phylink_pcs *pcs);
-	void (*pcs_link_up)(struct phylink_pcs *pcs, unsigned int mode,
+	void (*pcs_link_up)(struct phylink_pcs *pcs, unsigned int neg_mode,
 			    phy_interface_t interface, int speed, int duplex);
 };
 
@@ -508,7 +592,7 @@ void pcs_get_state(struct phylink_pcs *pcs,
 /**
  * pcs_config() - Configure the PCS mode and advertisement
  * @pcs: a pointer to a &struct phylink_pcs.
- * @mode: one of %MLO_AN_FIXED, %MLO_AN_PHY, %MLO_AN_INBAND.
+ * @neg_mode: link negotiation mode (see below)
  * @interface: interface mode to be used
  * @advertising: adertisement ethtool link mode mask
  * @permit_pause_to_mac: permit forwarding pause resolution to MAC
@@ -526,8 +610,12 @@ void pcs_get_state(struct phylink_pcs *pcs,
  * For 1000BASE-X, the advertisement should be programmed into the PCS.
  *
  * For most 10GBASE-R, there is no advertisement.
+ *
+ * The %neg_mode argument should be tested via the phylink_mode_*() family of
+ * functions, or for PCS that set pcs->neg_mode true, should be tested
+ * against the %PHYLINK_PCS_NEG_* definitions.
  */
-int pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+int pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 	       phy_interface_t interface, const unsigned long *advertising,
 	       bool permit_pause_to_mac);
 
@@ -543,7 +631,7 @@ void pcs_an_restart(struct phylink_pcs *pcs);
 /**
  * pcs_link_up() - program the PCS for the resolved link configuration
  * @pcs: a pointer to a &struct phylink_pcs.
- * @mode: link autonegotiation mode
+ * @neg_mode: link negotiation mode (see below)
  * @interface: link &typedef phy_interface_t mode
  * @speed: link speed
  * @duplex: link duplex
@@ -552,8 +640,12 @@ void pcs_an_restart(struct phylink_pcs *pcs);
  * the resolved link parameters. For example, a PCS operating in SGMII
  * mode without in-band AN needs to be manually configured for the link
  * and duplex setting. Otherwise, this should be a no-op.
+ *
+ * The %mode argument should be tested via the phylink_mode_*() family of
+ * functions, or for PCS that set pcs->neg_mode true, should be tested
+ * against the %PHYLINK_PCS_NEG_* definitions.
  */
-void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+void pcs_link_up(struct phylink_pcs *pcs, unsigned int neg_mode,
 		 phy_interface_t interface, int speed, int duplex);
 #endif
 
-- 
2.30.2


