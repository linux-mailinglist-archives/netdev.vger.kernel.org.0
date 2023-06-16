Return-Path: <netdev+bounces-11419-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83D077330D2
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:08:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F7A2280D4D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8660418C18;
	Fri, 16 Jun 2023 12:07:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7382718B0F
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 12:07:07 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B23630EB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Z9kCDrSj/xvgFRAb3eci8WWAHMeXvGpfeZeBPABs0DI=; b=HuhjydpVdXyvC9uLlMQWDKKYIh
	JchqGEMWJcRER4KtUXfWUqO6wu8oeEohFMlrDpNPHmjd5sYLL50xmNFuOISLdPNuWm+yNR30MIugV
	PXCioBotBngPLH3C4vL77mTpZwyP7F6wVTi+x843X/9e9bMzMTCZzc7f7Eu0m7aKftWWaNNwciySe
	p6XTXSqzj4PkmQ9+BnTocOec95D18RkjiLDui38ZBvFacUZruaJHwA5hVZCazOGKr/7JmStAdAwY7
	UOfd70Tr9HDu++fNMSUN0dcf7dQ5xyVsi3R87ZcAypU5MH2MYQvhthhL0M2Do2Oob1gUiqjzR98fh
	t7P7L64A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43796 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1qA8E5-00053d-4q; Fri, 16 Jun 2023 13:06:49 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1qA8E4-00EaFf-Bf; Fri, 16 Jun 2023 13:06:48 +0100
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
Subject: [PATCH net-next 06/15] net: pcs: lynx: update PCS driver to use
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
Message-Id: <E1qA8E4-00EaFf-Bf@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 16 Jun 2023 13:06:48 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Update the Lynx PCS driver to use neg_mode rather than the mode
argument. This ensures that the link_up() method will always program
the speed and duplex when negotiation is disabled.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-lynx.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index 25bd4b45eb7b..9021b96d4f9d 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -149,13 +149,14 @@ static int lynx_pcs_config_giga(struct mdio_device *pcs,
 					  neg_mode);
 }
 
-static int lynx_pcs_config_usxgmii(struct mdio_device *pcs, unsigned int mode,
-				   const unsigned long *advertising)
+static int lynx_pcs_config_usxgmii(struct mdio_device *pcs,
+				   const unsigned long *advertising,
+				   unsigned int neg_mode)
 {
 	struct mii_bus *bus = pcs->bus;
 	int addr = pcs->addr;
 
-	if (!phylink_autoneg_inband(mode)) {
+	if (neg_mode != PHYLINK_PCS_NEG_INBAND_ENABLED) {
 		dev_err(&pcs->dev, "USXGMII only supports in-band AN for now\n");
 		return -EOPNOTSUPP;
 	}
@@ -167,15 +168,11 @@ static int lynx_pcs_config_usxgmii(struct mdio_device *pcs, unsigned int mode,
 				 ADVERTISE_SGMII | ADVERTISE_LPACK);
 }
 
-static int lynx_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+static int lynx_pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 			   phy_interface_t ifmode,
-			   const unsigned long *advertising,
-			   bool permit)
+			   const unsigned long *advertising, bool permit)
 {
 	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
-	unsigned int neg_mode;
-
-	neg_mode = phylink_pcs_neg_mode(mode, ifmode, advertising);
 
 	switch (ifmode) {
 	case PHY_INTERFACE_MODE_1000BASEX:
@@ -184,14 +181,15 @@ static int lynx_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		return lynx_pcs_config_giga(lynx->mdio, ifmode, advertising,
 					    neg_mode);
 	case PHY_INTERFACE_MODE_2500BASEX:
-		if (phylink_autoneg_inband(mode)) {
+		if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED) {
 			dev_err(&lynx->mdio->dev,
 				"AN not supported on 3.125GHz SerDes lane\n");
 			return -EOPNOTSUPP;
 		}
 		break;
 	case PHY_INTERFACE_MODE_USXGMII:
-		return lynx_pcs_config_usxgmii(lynx->mdio, mode, advertising);
+		return lynx_pcs_config_usxgmii(lynx->mdio, advertising,
+					       neg_mode);
 	case PHY_INTERFACE_MODE_10GBASER:
 		/* Nothing to do here for 10GBASER */
 		break;
@@ -209,7 +207,8 @@ static void lynx_pcs_an_restart(struct phylink_pcs *pcs)
 	phylink_mii_c22_pcs_an_restart(lynx->mdio);
 }
 
-static void lynx_pcs_link_up_sgmii(struct mdio_device *pcs, unsigned int mode,
+static void lynx_pcs_link_up_sgmii(struct mdio_device *pcs,
+				   unsigned int neg_mode,
 				   int speed, int duplex)
 {
 	u16 if_mode = 0, sgmii_speed;
@@ -217,7 +216,7 @@ static void lynx_pcs_link_up_sgmii(struct mdio_device *pcs, unsigned int mode,
 	/* The PCS needs to be configured manually only
 	 * when not operating on in-band mode
 	 */
-	if (mode == MLO_AN_INBAND)
+	if (neg_mode != PHYLINK_PCS_NEG_INBAND_ENABLED)
 		return;
 
 	if (duplex == DUPLEX_HALF)
@@ -264,12 +263,12 @@ static void lynx_pcs_link_up_sgmii(struct mdio_device *pcs, unsigned int mode,
  * 2500 Mbps and we do rate adaptation through pause frames.
  */
 static void lynx_pcs_link_up_2500basex(struct mdio_device *pcs,
-				       unsigned int mode,
+				       unsigned int neg_mode,
 				       int speed, int duplex)
 {
 	u16 if_mode = 0;
 
-	if (mode == MLO_AN_INBAND) {
+	if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED) {
 		dev_err(&pcs->dev, "AN not supported for 2500BaseX\n");
 		return;
 	}
@@ -283,7 +282,7 @@ static void lynx_pcs_link_up_2500basex(struct mdio_device *pcs,
 		       if_mode);
 }
 
-static void lynx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+static void lynx_pcs_link_up(struct phylink_pcs *pcs, unsigned int neg_mode,
 			     phy_interface_t interface,
 			     int speed, int duplex)
 {
@@ -292,10 +291,10 @@ static void lynx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 	switch (interface) {
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
-		lynx_pcs_link_up_sgmii(lynx->mdio, mode, speed, duplex);
+		lynx_pcs_link_up_sgmii(lynx->mdio, neg_mode, speed, duplex);
 		break;
 	case PHY_INTERFACE_MODE_2500BASEX:
-		lynx_pcs_link_up_2500basex(lynx->mdio, mode, speed, duplex);
+		lynx_pcs_link_up_2500basex(lynx->mdio, neg_mode, speed, duplex);
 		break;
 	case PHY_INTERFACE_MODE_USXGMII:
 		/* At the moment, only in-band AN is supported for USXGMII
@@ -325,6 +324,7 @@ static struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
 	mdio_device_get(mdio);
 	lynx->mdio = mdio;
 	lynx->pcs.ops = &lynx_pcs_phylink_ops;
+	lynx->pcs.neg_mode = true;
 	lynx->pcs.poll = true;
 
 	return lynx_to_phylink_pcs(lynx);
-- 
2.30.2


