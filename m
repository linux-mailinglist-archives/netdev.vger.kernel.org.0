Return-Path: <netdev+bounces-11422-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E0947330D7
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:09:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF06B1C20B1D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E58F19BC4;
	Fri, 16 Jun 2023 12:07:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437C617ACA
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 12:07:20 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C531230DE
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=eg91R/4bLRJqVHaX1c+jQLkL1kvmGgrwFdpTChy8MoE=; b=GKdEkXWHdCnWD6tQxYcuuBGD0v
	LhlocxIT2RJb8UKwTYtTQbrIBgmsJitzs0zF2MueZDpPJYi/i8mSPKW35fwcnODzrmmO3CyVqAiHq
	kG9JdoWJIMxNpQX0PQsduOHVoCyi3LFlOgc6z83vUU/g4o7z4hXeaG5RBLGLPKQ1NyHQccjwnp6K+
	rFRFbEXlONX/Qf8iAfUz3Sxuupq9sCjAkybMStCjGJZBFA4AZC0Inrr7WrMhuSZh2X1Zg44olyu71
	QKGZJRmQi9h0HBNHBBg3EF4FiVxsZYs68VKRlwSpoqdgMgSnp2egBsklbiJ0Rnieg0x+YgDZx9ROP
	J+puT8UA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:58892 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1qA8EK-00055M-Gm; Fri, 16 Jun 2023 13:07:04 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1qA8EJ-00EaFx-P6; Fri, 16 Jun 2023 13:07:03 +0100
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
Subject: [PATCH net-next 09/15] net: mvpp2: update PCS driver to use neg_mode
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1qA8EJ-00EaFx-P6@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 16 Jun 2023 13:07:03 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Update mvpp2's embedded PCS drivers to use neg_mode rather than the
mode argument, remembering to update the ACPI path as well. As there
are no pcs_link_up() methods, this only affects the two pcs_config()
methods.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index adc953611913..1fec84b4c068 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6168,8 +6168,7 @@ static void mvpp2_xlg_pcs_get_state(struct phylink_pcs *pcs,
 		state->pause |= MLO_PAUSE_RX;
 }
 
-static int mvpp2_xlg_pcs_config(struct phylink_pcs *pcs,
-				unsigned int mode,
+static int mvpp2_xlg_pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 				phy_interface_t interface,
 				const unsigned long *advertising,
 				bool permit_pause_to_mac)
@@ -6232,7 +6231,7 @@ static void mvpp2_gmac_pcs_get_state(struct phylink_pcs *pcs,
 		state->pause |= MLO_PAUSE_TX;
 }
 
-static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 				 phy_interface_t interface,
 				 const unsigned long *advertising,
 				 bool permit_pause_to_mac)
@@ -6246,7 +6245,7 @@ static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	       MVPP2_GMAC_FLOW_CTRL_AUTONEG |
 	       MVPP2_GMAC_AN_DUPLEX_EN;
 
-	if (phylink_autoneg_inband(mode)) {
+	if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED) {
 		mask |= MVPP2_GMAC_CONFIG_MII_SPEED |
 			MVPP2_GMAC_CONFIG_GMII_SPEED |
 			MVPP2_GMAC_CONFIG_FULL_DUPLEX;
@@ -6649,8 +6648,9 @@ static void mvpp2_acpi_start(struct mvpp2_port *port)
 	mvpp2_mac_prepare(&port->phylink_config, MLO_AN_INBAND,
 			  port->phy_interface);
 	mvpp2_mac_config(&port->phylink_config, MLO_AN_INBAND, &state);
-	pcs->ops->pcs_config(pcs, MLO_AN_INBAND, port->phy_interface,
-			     state.advertising, false);
+	pcs->ops->pcs_config(pcs, PHYLINK_PCS_NEG_INBAND_ENABLED,
+			     port->phy_interface, state.advertising,
+			     false);
 	mvpp2_mac_finish(&port->phylink_config, MLO_AN_INBAND,
 			 port->phy_interface);
 	mvpp2_mac_link_up(&port->phylink_config, NULL,
@@ -6896,7 +6896,9 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	dev->dev.of_node = port_node;
 
 	port->pcs_gmac.ops = &mvpp2_phylink_gmac_pcs_ops;
+	port->pcs_gmac.neg_mode = true;
 	port->pcs_xlg.ops = &mvpp2_phylink_xlg_pcs_ops;
+	port->pcs_xlg.neg_mode = true;
 
 	if (!mvpp2_use_acpi_compat_mode(port_fwnode)) {
 		port->phylink_config.dev = &dev->dev;
-- 
2.30.2


