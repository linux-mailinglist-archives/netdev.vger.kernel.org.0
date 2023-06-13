Return-Path: <netdev+bounces-10419-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C3AF72E5FF
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:41:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D43D72800AF
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B42A37B98;
	Tue, 13 Jun 2023 14:38:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E38E2A71D
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:38:42 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD017172A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=OV7Zlg5Gab5MogTbW6kZqsvqHvc8pH95bB3AVMriHDE=; b=BAvz+TpfKDLg5JJP8cGy2BNzGi
	pG3okIGq4Myjx+Oyi/bDMUA30LYRZC33RiLtBTWA4ly8cRfYO7ypba2Knwv8mSQpSmcaP7UJ7QZrQ
	2Mw8PWD+i7fmGGRSoepDSsE+hCyjIATnVxciXfO/HGABz6W7xILJ8SGjZJN2jchU6qfvE3jTPjugj
	PCQJipBRJ3nOCgd71xehl0C6LX/wtaugzLRnkNKmqnfcZHfLAgL1XEWSAu1yJA2s7r/QfWM6xm3Ho
	5DAra/HPn+/FyWeTOj1xdRwNfua35YxiBw04TcUGruFOCb5173oreCa4NFu2GLRbU5J34LUPMMi0u
	/VtbL8Ow==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46216 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q95AE-0007XM-0F; Tue, 13 Jun 2023 15:38:30 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q95AD-00EBwc-9d; Tue, 13 Jun 2023 15:38:29 +0100
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
Subject: [PATCH RFC net-next 12/15] net: sparx5: update PCS driver to use
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
Message-Id: <E1q95AD-00EBwc-9d@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 13 Jun 2023 15:38:29 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Update Sparx5's embedded PCS driver to use neg_mode rather than the
mode argument. As there is no pcs_link_up() method, this only affects
the pcs_config() method.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c    | 1 +
 drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index a7edf524eedb..dc9af480bfea 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -281,6 +281,7 @@ static int sparx5_create_port(struct sparx5 *sparx5,
 	spx5_port->custom_etype = 0x8880; /* Vitesse */
 	spx5_port->phylink_pcs.poll = true;
 	spx5_port->phylink_pcs.ops = &sparx5_phylink_pcs_ops;
+	spx5_port->phylink_pcs.neg_mode = true;
 	spx5_port->is_mrouter = false;
 	INIT_LIST_HEAD(&spx5_port->tc_templates);
 	sparx5->ports[config->portno] = spx5_port;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
index bb97d27a1da4..f8562c1a894d 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
@@ -91,8 +91,7 @@ static void sparx5_pcs_get_state(struct phylink_pcs *pcs,
 	state->pause = status.pause;
 }
 
-static int sparx5_pcs_config(struct phylink_pcs *pcs,
-			     unsigned int mode,
+static int sparx5_pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 			     phy_interface_t interface,
 			     const unsigned long *advertising,
 			     bool permit_pause_to_mac)
@@ -104,8 +103,9 @@ static int sparx5_pcs_config(struct phylink_pcs *pcs,
 	conf = port->conf;
 	conf.power_down = false;
 	conf.portmode = interface;
-	conf.inband = phylink_autoneg_inband(mode);
-	conf.autoneg = phylink_test(advertising, Autoneg);
+	conf.inband = neg_mode == PHYLINK_PCS_NEG_INBAND_DISABLED ||
+		      neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED;
+	conf.autoneg = neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED;
 	conf.pause_adv = 0;
 	if (phylink_test(advertising, Pause))
 		conf.pause_adv |= ADVERTISE_1000XPAUSE;
-- 
2.30.2


