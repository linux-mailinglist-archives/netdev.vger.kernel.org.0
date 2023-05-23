Return-Path: <netdev+bounces-4737-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A574970E11D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:56:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6081A1C20D99
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC5A4200AB;
	Tue, 23 May 2023 15:55:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1461F92A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:55:29 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2113D8E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=F4o/J5FzymS1KheJW/oauXNnuAkkjjUwab7Wsigr0g8=; b=BXHTiXcpUDPnCXYxnxn5doQyhu
	UP550vRS/sRnVj1nV1DjQVpS+fmuvW1gyUN9ffg+nQJikzW9G8z2UzOLK4YkNjAnK9kAmWmmTf/Ya
	WlPuV5Zvgp7cAWlCOq7sfAn6zhXjzCpwAtVIfzGelpl0JUfzc0eZCtuOgILQ4byuH6pEyLBonfJ4Z
	E9mAKv7KUHA8NuWGmxdtxe5hgbWv6P8O3L1U3cGSbD9qeJ3SHNCkdIcbqngURNkogLntR+ZIywNxJ
	G2UBo8DwC5PtByqbPMh15cqCsZ6GeGQJMlIJiD4YiqVYk9I+zzk1LXSTZ2jYiccfq9AlSaYh9oysc
	jBrdJM3g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46156 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q1UM4-0000iy-Qf; Tue, 23 May 2023 16:55:20 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q1UM4-007FSo-74; Tue, 23 May 2023 16:55:20 +0100
In-Reply-To: <ZGzhvePzPjJ0v2En@shell.armlinux.org.uk>
References: <ZGzhvePzPjJ0v2En@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	linux-arm-kernel@lists.infradead.org,
	Madalin Bucur <madalin.bucur@nxp.com>,
	Marcin Wojtas <mw@semihalf.com>,
	Michal Simek <michal.simek@amd.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com,
	Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RFC net-next 3/9] net: phylink: pass aneg_mode into
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
Message-Id: <E1q1UM4-007FSo-74@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 23 May 2023 16:55:20 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Pass the aneg_mode into phylink_mii_c22_pcs_config() in preparation
to moving it up as a parameter passed to the pcs_config() method.
In doing so, we no longer need to pass the MLO_AN_* mode to this
function.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/freescale/fman/fman_dtsec.c   |  7 +++++--
 .../net/ethernet/xilinx/xilinx_axienet_main.c  |  5 ++++-
 drivers/net/pcs/pcs-lynx.c                     | 18 ++++++++++++------
 drivers/net/phy/phylink.c                      |  9 ++++-----
 include/linux/phylink.h                        |  5 +++--
 5 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index d528ca681b6f..e6a5a7f03dbe 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -769,9 +769,12 @@ static int dtsec_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 			    bool permit_pause_to_mac)
 {
 	struct fman_mac *dtsec = pcs_to_dtsec(pcs);
+	unsigned int neg_mode;
 
-	return phylink_mii_c22_pcs_config(dtsec->tbidev, mode, interface,
-					  advertising);
+	neg_mode = phylink_pcs_neg_mode(mode, interface, advertising);
+
+	return phylink_mii_c22_pcs_config(dtsec->tbidev, interface,
+					  advertising, neg_mode);
 }
 
 static void dtsec_pcs_an_restart(struct phylink_pcs *pcs)
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3e310b55bce2..380a4db686b7 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1639,6 +1639,7 @@ static int axienet_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	struct mdio_device *pcs_phy = pcs_to_axienet_local(pcs)->pcs_phy;
 	struct net_device *ndev = pcs_to_axienet_local(pcs)->ndev;
 	struct axienet_local *lp = netdev_priv(ndev);
+	unsigned int neg_mode;
 	int ret;
 
 	if (lp->switch_x_sgmii) {
@@ -1653,7 +1654,9 @@ static int axienet_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		}
 	}
 
-	ret = phylink_mii_c22_pcs_config(pcs_phy, mode, interface, advertising);
+	neg_mode = phylink_pcs_neg_mode(mode, interface, advertising);
+	ret = phylink_mii_c22_pcs_config(pcs_phy, interface, advertising,
+					 neg_mode);
 	if (ret < 0)
 		netdev_warn(ndev, "Failed to configure PCS: %d\n", ret);
 
diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index 622c3de3f3a8..5a0de1fcb833 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -119,9 +119,10 @@ static void lynx_pcs_get_state(struct phylink_pcs *pcs,
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
@@ -139,8 +140,9 @@ static int lynx_pcs_config_giga(struct mdio_device *pcs, unsigned int mode,
 	if (interface == PHY_INTERFACE_MODE_1000BASEX) {
 		if_mode = 0;
 	} else {
+		/* SGMII and QSGMII */
 		if_mode = IF_MODE_SGMII_EN;
-		if (mode == MLO_AN_INBAND)
+		if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED)
 			if_mode |= IF_MODE_USE_SGMII_AN;
 	}
 
@@ -150,7 +152,8 @@ static int lynx_pcs_config_giga(struct mdio_device *pcs, unsigned int mode,
 	if (err)
 		return err;
 
-	return phylink_mii_c22_pcs_config(pcs, mode, interface, advertising);
+	return phylink_mii_c22_pcs_config(pcs, interface, advertising,
+					  neg_mode);
 }
 
 static int lynx_pcs_config_usxgmii(struct mdio_device *pcs, unsigned int mode,
@@ -177,13 +180,16 @@ static int lynx_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 			   bool permit)
 {
 	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
+	unsigned int neg_mode;
+
+	neg_mode = phylink_pcs_neg_mode(mode, interface, advertising);
 
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
index c800bdcddeb8..03e4ff8bf289 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -3509,20 +3509,20 @@ EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_encode_advertisement);
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
@@ -3536,7 +3536,6 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 		changed = ret;
 	}
 
-	neg_mode = phylink_pcs_neg_mode(mode, interface, advertising);
 	if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED)
 		bmcr = BMCR_ANENABLE;
 	else
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index e3cb0b4eed1d..8510c922b3f4 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -727,9 +727,10 @@ void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
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


