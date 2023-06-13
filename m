Return-Path: <netdev+bounces-10410-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E2672E5EE
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2CAA1C20CD9
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAC0837B72;
	Tue, 13 Jun 2023 14:38:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E6917FEB
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:38:00 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803C21732
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=8kyfftYMQN3kKLVGTIq+W6p5HS8Y8L4IX8ljzmx/WbE=; b=EEBPO36aDwoL+Izu+Dbnw/HJhe
	MKyeN21ILM1q0vqJKj4qeF1GZL1JVOIreLTAO8B3g2/EWh4V4zmpD72oyjB8M2ljkRTqQIGRGiGIL
	lXBGvhYRhles4xhVrjwmp2sAS0+msy72Q25AncTEKhrOA0co5zfp0u4iEBIjerpzYp2kJ7kIAZ+AY
	7ROIAZBiq8Dw+1gSciIk5shoF5TNrP5KcZTvgFC3bEkfT2E50V2PBwYPf00sGbOYPjx/7rqjUnPur
	re8XiTZtiA8vlCk9BerJ35mw37xWR11wJr7/Iu9SHFqVIzJxO1tNj4rg8KmtfFiuWxowWnclXtdom
	BlXl7eRQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:51824 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q959T-0007QZ-M6; Tue, 13 Jun 2023 15:37:43 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q959T-00EBvk-0S; Tue, 13 Jun 2023 15:37:43 +0100
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
Subject: [PATCH RFC net-next 03/15] net: phylink: pass neg_mode into
 phylink_mii_c22_pcs_config()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q959T-00EBvk-0S@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 13 Jun 2023 15:37:43 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Convert fman_dtsec, xilinx_axienet and pcs-lynx to pass the neg_mode
into phylink_mii_c22_pcs_config(). Where appropriate, drivers are
updated to have neg_mode passed into their pcs_config() and
pcs_link_up() functions. For other drivers, we just hoist the call
to phylink_pcs_neg_mode() to their pcs_config() method out of
phylink_mii_c22_pcs_config().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/freescale/fman/fman_dtsec.c   |  7 ++++---
 .../net/ethernet/xilinx/xilinx_axienet_main.c  |  6 ++++--
 drivers/net/pcs/pcs-lynx.c                     | 18 ++++++++++++------
 drivers/net/phy/phylink.c                      |  9 ++++-----
 include/linux/phylink.h                        |  5 +++--
 5 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index d528ca681b6f..3088da7adf0f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -763,15 +763,15 @@ static void dtsec_pcs_get_state(struct phylink_pcs *pcs,
 	phylink_mii_c22_pcs_get_state(dtsec->tbidev, state);
 }
 
-static int dtsec_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+static int dtsec_pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 			    phy_interface_t interface,
 			    const unsigned long *advertising,
 			    bool permit_pause_to_mac)
 {
 	struct fman_mac *dtsec = pcs_to_dtsec(pcs);
 
-	return phylink_mii_c22_pcs_config(dtsec->tbidev, mode, interface,
-					  advertising);
+	return phylink_mii_c22_pcs_config(dtsec->tbidev, interface,
+					  advertising, neg_mode);
 }
 
 static void dtsec_pcs_an_restart(struct phylink_pcs *pcs)
@@ -1447,6 +1447,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
 		goto _return_fm_mac_free;
 	}
 	dtsec->pcs.ops = &dtsec_pcs_ops;
+	dtsec->pcs.neg_mode = true;
 	dtsec->pcs.poll = true;
 
 	supported = mac_dev->phylink_config.supported_interfaces;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3e310b55bce2..ae7b9af7b7d7 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1631,7 +1631,7 @@ static void axienet_pcs_an_restart(struct phylink_pcs *pcs)
 	phylink_mii_c22_pcs_an_restart(pcs_phy);
 }
 
-static int axienet_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+static int axienet_pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 			      phy_interface_t interface,
 			      const unsigned long *advertising,
 			      bool permit_pause_to_mac)
@@ -1653,7 +1653,8 @@ static int axienet_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		}
 	}
 
-	ret = phylink_mii_c22_pcs_config(pcs_phy, mode, interface, advertising);
+	ret = phylink_mii_c22_pcs_config(pcs_phy, interface, advertising,
+					 neg_mode);
 	if (ret < 0)
 		netdev_warn(ndev, "Failed to configure PCS: %d\n", ret);
 
@@ -2129,6 +2130,7 @@ static int axienet_probe(struct platform_device *pdev)
 		}
 		of_node_put(np);
 		lp->pcs.ops = &axienet_pcs_ops;
+		lp->pcs.neg_mode = true;
 		lp->pcs.poll = true;
 	}
 
diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index fca48ebf0b81..25bd4b45eb7b 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -112,9 +112,10 @@ static void lynx_pcs_get_state(struct phylink_pcs *pcs,
 		state->link, state->an_complete);
 }
 
-static int lynx_pcs_config_giga(struct mdio_device *pcs, unsigned int mode,
+static int lynx_pcs_config_giga(struct mdio_device *pcs,
 				phy_interface_t interface,
-				const unsigned long *advertising)
+				const unsigned long *advertising,
+				unsigned int neg_mode)
 {
 	int link_timer_ns;
 	u32 link_timer;
@@ -132,8 +133,9 @@ static int lynx_pcs_config_giga(struct mdio_device *pcs, unsigned int mode,
 	if (interface == PHY_INTERFACE_MODE_1000BASEX) {
 		if_mode = 0;
 	} else {
+		/* SGMII and QSGMII */
 		if_mode = IF_MODE_SGMII_EN;
-		if (mode == MLO_AN_INBAND)
+		if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED)
 			if_mode |= IF_MODE_USE_SGMII_AN;
 	}
 
@@ -143,7 +145,8 @@ static int lynx_pcs_config_giga(struct mdio_device *pcs, unsigned int mode,
 	if (err)
 		return err;
 
-	return phylink_mii_c22_pcs_config(pcs, mode, interface, advertising);
+	return phylink_mii_c22_pcs_config(pcs, interface, advertising,
+					  neg_mode);
 }
 
 static int lynx_pcs_config_usxgmii(struct mdio_device *pcs, unsigned int mode,
@@ -170,13 +173,16 @@ static int lynx_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 			   bool permit)
 {
 	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
+	unsigned int neg_mode;
+
+	neg_mode = phylink_pcs_neg_mode(mode, ifmode, advertising);
 
 	switch (ifmode) {
 	case PHY_INTERFACE_MODE_1000BASEX:
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
-		return lynx_pcs_config_giga(lynx->mdio, mode, ifmode,
-					    advertising);
+		return lynx_pcs_config_giga(lynx->mdio, ifmode, advertising,
+					    neg_mode);
 	case PHY_INTERFACE_MODE_2500BASEX:
 		if (phylink_autoneg_inband(mode)) {
 			dev_err(&lynx->mdio->dev,
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 601d64f57e33..414508ed5512 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -3508,20 +3508,20 @@ EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_encode_advertisement);
 /**
  * phylink_mii_c22_pcs_config() - configure clause 22 PCS
  * @pcs: a pointer to a &struct mdio_device.
- * @mode: link autonegotiation mode
  * @interface: the PHY interface mode being configured
  * @advertising: the ethtool advertisement mask
+ * @neg_mode: PCS negotiation mode
  *
  * Configure a Clause 22 PCS PHY with the appropriate negotiation
  * parameters for the @mode, @interface and @advertising parameters.
  * Returns negative error number on failure, zero if the advertisement
  * has not changed, or positive if there is a change.
  */
-int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
+int phylink_mii_c22_pcs_config(struct mdio_device *pcs,
 			       phy_interface_t interface,
-			       const unsigned long *advertising)
+			       const unsigned long *advertising,
+			       unsigned int neg_mode)
 {
-	unsigned int neg_mode;
 	bool changed = 0;
 	u16 bmcr;
 	int ret, adv;
@@ -3535,7 +3535,6 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 		changed = ret;
 	}
 
-	neg_mode = phylink_pcs_neg_mode(mode, interface, advertising);
 	if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED)
 		bmcr = BMCR_ANENABLE;
 	else
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 2b322d7fa51a..516240f1e950 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -743,9 +743,10 @@ void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
 				   struct phylink_link_state *state);
 int phylink_mii_c22_pcs_encode_advertisement(phy_interface_t interface,
 					     const unsigned long *advertising);
-int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
+int phylink_mii_c22_pcs_config(struct mdio_device *pcs,
 			       phy_interface_t interface,
-			       const unsigned long *advertising);
+			       const unsigned long *advertising,
+			       unsigned int neg_mode);
 void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs);
 
 void phylink_resolve_c73(struct phylink_link_state *state);
-- 
2.30.2


