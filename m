Return-Path: <netdev+bounces-10412-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE74B72E5F2
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:39:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81FE7281009
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D06B82A715;
	Tue, 13 Jun 2023 14:38:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27432A6F4
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:38:09 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74468E54
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=MHixeibMQ3MyRA31rtGo+GfEunYI7FZP5KJiewFCVP4=; b=nMUhm60hRmFbBd7nywSyukmlbj
	/K3gD0kB72ZTnj/wopgCOFLFpympTFE21k181HUzxERg3tLSKBGGpQ1O/aY0B9mjCeqaPnozM2LHD
	Witub1+qgUni/Ww//6B1U/9qH7QZx32BZn2D/rfGzsi0zKXtiXXATu5eMlt04qa5vRkNBIepx1huk
	7Hb/HiLySelSb+ESEPIbKoeEW5Hn/wYodPQmvcs1XCVwuhklGcArev8NMdraXZq6Skn9aZZasNLfn
	0HddB6hJ3+QPWuVxArSsEpJDnLfOEm8qBR/xOjQoVTgJg8/2uG0PS4lXs/+SXQ3crXjBsvi5DxJdO
	C/GsHlcQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:59944 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q959e-0007RR-0o; Tue, 13 Jun 2023 15:37:54 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q959d-00EBvw-9T; Tue, 13 Jun 2023 15:37:53 +0100
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
Subject: [PATCH RFC net-next 05/15] net: pcs: lynxi: update PCS driver to use
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
Message-Id: <E1q959d-00EBvw-9T@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 13 Jun 2023 15:37:53 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Update the Lynxi PCS driver to use neg_mode rather than the mode
argument. This ensures that the link_up() method will always program
the speed and duplex when negotiation is disabled.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-mtk-lynxi.c | 39 ++++++++++++++-------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/net/pcs/pcs-mtk-lynxi.c b/drivers/net/pcs/pcs-mtk-lynxi.c
index 888452325edc..b0f3ede945d9 100644
--- a/drivers/net/pcs/pcs-mtk-lynxi.c
+++ b/drivers/net/pcs/pcs-mtk-lynxi.c
@@ -102,13 +102,13 @@ static void mtk_pcs_lynxi_get_state(struct phylink_pcs *pcs,
 					 FIELD_GET(SGMII_LPA, adv));
 }
 
-static int mtk_pcs_lynxi_config(struct phylink_pcs *pcs, unsigned int mode,
+static int mtk_pcs_lynxi_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 				phy_interface_t interface,
 				const unsigned long *advertising,
 				bool permit_pause_to_mac)
 {
 	struct mtk_pcs_lynxi *mpcs = pcs_to_mtk_pcs_lynxi(pcs);
-	bool mode_changed = false, changed, use_an;
+	bool mode_changed = false, changed;
 	unsigned int rgc3, sgm_mode, bmcr;
 	int advertise, link_timer;
 
@@ -121,30 +121,21 @@ static int mtk_pcs_lynxi_config(struct phylink_pcs *pcs, unsigned int mode,
 	 * we assume that fixes it's speed at bitrate = line rate (in
 	 * other words, 1000Mbps or 2500Mbps).
 	 */
-	if (interface == PHY_INTERFACE_MODE_SGMII) {
+	if (interface == PHY_INTERFACE_MODE_SGMII)
 		sgm_mode = SGMII_IF_MODE_SGMII;
-		if (phylink_autoneg_inband(mode)) {
-			sgm_mode |= SGMII_REMOTE_FAULT_DIS |
-				    SGMII_SPEED_DUPLEX_AN;
-			use_an = true;
-		} else {
-			use_an = false;
-		}
-	} else if (phylink_autoneg_inband(mode)) {
-		/* 1000base-X or 2500base-X autoneg */
-		sgm_mode = SGMII_REMOTE_FAULT_DIS;
-		use_an = linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
-					   advertising);
-	} else {
-		/* 1000base-X or 2500base-X without autoneg */
+	else
 		sgm_mode = 0;
-		use_an = false;
-	}
 
-	if (use_an)
+	if (neg_mode & PHYLINK_PCS_NEG_INBAND)
+		sgm_mode |= SGMII_REMOTE_FAULT_DIS;
+
+	if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED) {
+		if (interface == PHY_INTERFACE_MODE_SGMII)
+			sgm_mode |= SGMII_SPEED_DUPLEX_AN;
 		bmcr = BMCR_ANENABLE;
-	else
+	} else {
 		bmcr = 0;
+	}
 
 	if (mpcs->interface != interface) {
 		link_timer = phylink_get_link_timer_ns(interface);
@@ -216,14 +207,15 @@ static void mtk_pcs_lynxi_restart_an(struct phylink_pcs *pcs)
 	regmap_set_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1, BMCR_ANRESTART);
 }
 
-static void mtk_pcs_lynxi_link_up(struct phylink_pcs *pcs, unsigned int mode,
+static void mtk_pcs_lynxi_link_up(struct phylink_pcs *pcs,
+				  unsigned int neg_mode,
 				  phy_interface_t interface, int speed,
 				  int duplex)
 {
 	struct mtk_pcs_lynxi *mpcs = pcs_to_mtk_pcs_lynxi(pcs);
 	unsigned int sgm_mode;
 
-	if (!phylink_autoneg_inband(mode)) {
+	if (neg_mode != PHYLINK_PCS_NEG_INBAND_ENABLED) {
 		/* Force the speed and duplex setting */
 		if (speed == SPEED_10)
 			sgm_mode = SGMII_SPEED_10;
@@ -286,6 +278,7 @@ struct phylink_pcs *mtk_pcs_lynxi_create(struct device *dev,
 	mpcs->regmap = regmap;
 	mpcs->flags = flags;
 	mpcs->pcs.ops = &mtk_pcs_lynxi_ops;
+	mpcs->pcs.neg_mode = true;
 	mpcs->pcs.poll = true;
 	mpcs->interface = PHY_INTERFACE_MODE_NA;
 
-- 
2.30.2


