Return-Path: <netdev+bounces-10415-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73C4572E5F7
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7F701C20CDA
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C069538CC0;
	Tue, 13 Jun 2023 14:38:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61502A9CE
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:38:23 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7244710E6
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fzL6+Y0vNhBXA8sflIEtw0SjPY5l7wumFywop7cYerI=; b=PkE/36qT6+hWzk6aktbOMuLBAq
	3ITZtd6hCv7mRN8sl+BPWNXSE5y4pWTxBtNB8ITD+dPAfq53DTCdJw7UjywZjjffsWO36lfgjn++r
	B41B6D1hv8Ufq4QO0CGmphjP/24cCArH2gbCkunx5XuAaYgkJBWdyckW57+dAOnNEMTjon3HxOLjJ
	Y6lA7vTs3UcwZJbTKiJ8c7Fyt/ij3nRlKX3bZyKIrINuEVponwv/loZl2duZpH4WIVfGZg+JB48Ml
	sDmu3z+PcmLjscC1VGrL78nY4WUP0HQl2TTnKiALnQzlwFBxAQ+s5BDv1AX7+dt5a2+Lkbzl+dnv1
	O1PX4bkg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34280 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q959t-0007Te-If; Tue, 13 Jun 2023 15:38:09 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q959s-00EBwE-Pm; Tue, 13 Jun 2023 15:38:08 +0100
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
Subject: [PATCH RFC net-next 08/15] net: mvneta: update PCS driver to use
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
Message-Id: <E1q959s-00EBwE-Pm@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 13 Jun 2023 15:38:08 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Update mvneta's embedded PCS driver to use neg_mode rather than the
mode argument. As there is no pcs_link_up() method, this only affects
the pcs_config() method.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index e2abc00d0472..ff5647bcdfca 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4002,8 +4002,8 @@ static void mvneta_pcs_get_state(struct phylink_pcs *pcs,
 		state->pause |= MLO_PAUSE_TX;
 }
 
-static int mvneta_pcs_config(struct phylink_pcs *pcs,
-			     unsigned int mode, phy_interface_t interface,
+static int mvneta_pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
+			     phy_interface_t interface,
 			     const unsigned long *advertising,
 			     bool permit_pause_to_mac)
 {
@@ -4016,7 +4016,7 @@ static int mvneta_pcs_config(struct phylink_pcs *pcs,
 	       MVNETA_GMAC_AN_FLOW_CTRL_EN |
 	       MVNETA_GMAC_AN_DUPLEX_EN;
 
-	if (phylink_autoneg_inband(mode)) {
+	if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED) {
 		mask |= MVNETA_GMAC_CONFIG_MII_SPEED |
 			MVNETA_GMAC_CONFIG_GMII_SPEED |
 			MVNETA_GMAC_CONFIG_FULL_DUPLEX;
@@ -5518,6 +5518,7 @@ static int mvneta_probe(struct platform_device *pdev)
 		clk_prepare_enable(pp->clk_bus);
 
 	pp->phylink_pcs.ops = &mvneta_phylink_pcs_ops;
+	pp->phylink_pcs.neg_mode = true;
 
 	pp->phylink_config.dev = &dev->dev;
 	pp->phylink_config.type = PHYLINK_NETDEV;
-- 
2.30.2


