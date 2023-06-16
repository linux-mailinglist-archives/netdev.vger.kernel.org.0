Return-Path: <netdev+bounces-11423-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 004FB7330D8
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:09:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2CF0281748
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCD4A19916;
	Fri, 16 Jun 2023 12:07:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DC019512
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 12:07:23 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFDB30C5
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Df526YwvzaRm2ShTOHccKVkFURtBcAMuu7bcoPYzOP4=; b=dB8Nw/xOX/M+T0cI7XmDl3Mg29
	zZ+2MH3WD9Gbr9vWYmfXp0zEKdZBnyoKffhi+WWaPJss0di39SpbykemdJqGDqu1qIfoJnTk/Ox4X
	nY0FVYnFmQqx1Cd+ER7mjvZuBbWmdRum9zgU5W1OVSbnyihNRagXvjD+M/zagmlLrInk4jPEyARxa
	ST2e59AXYzYTFa3yzHECF+GuzT+pXUtskRX1z+FSTuzEn63P9t9JDukMqPze6TzbK2iHpx0XrR8Qb
	V4jBclqbzQXEdgl2HqsTuy6zeE8NdQ7euv+QHfk4JOgsPTyNpaU9ndavm4CMhOCFtS68v+bkc4G+O
	55CRtqQA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46428 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1qA8EP-00055q-Mx; Fri, 16 Jun 2023 13:07:09 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1qA8EO-00EaG3-TR; Fri, 16 Jun 2023 13:07:08 +0100
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
Subject: [PATCH net-next 10/15] net: prestera: update PCS driver to use
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
Message-Id: <E1qA8EO-00EaG3-TR@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 16 Jun 2023 13:07:08 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Update prestera's embedded PCS driver to use neg_mode rather than the
mode argument. As there is no pcs_link_up() method, this only affects
the pcs_config() method.

Acked-by: Elad Nachman <enachman@marvell.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 9d504142e51a..4fb886c57cd7 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -300,8 +300,7 @@ static void prestera_pcs_get_state(struct phylink_pcs *pcs,
 	}
 }
 
-static int prestera_pcs_config(struct phylink_pcs *pcs,
-			       unsigned int mode,
+static int prestera_pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 			       phy_interface_t interface,
 			       const unsigned long *advertising,
 			       bool permit_pause_to_mac)
@@ -316,30 +315,25 @@ static int prestera_pcs_config(struct phylink_pcs *pcs,
 
 	cfg_mac.admin = true;
 	cfg_mac.fec = PRESTERA_PORT_FEC_OFF;
+	cfg_mac.inband = neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED;
 
 	switch (interface) {
 	case PHY_INTERFACE_MODE_10GBASER:
 		cfg_mac.speed = SPEED_10000;
-		cfg_mac.inband = 0;
 		cfg_mac.mode = PRESTERA_MAC_MODE_SR_LR;
 		break;
 	case PHY_INTERFACE_MODE_2500BASEX:
 		cfg_mac.speed = SPEED_2500;
 		cfg_mac.duplex = DUPLEX_FULL;
-		cfg_mac.inband = test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
-					  advertising);
 		cfg_mac.mode = PRESTERA_MAC_MODE_SGMII;
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
-		cfg_mac.inband = 1;
 		cfg_mac.mode = PRESTERA_MAC_MODE_SGMII;
 		break;
 	case PHY_INTERFACE_MODE_1000BASEX:
 	default:
 		cfg_mac.speed = SPEED_1000;
 		cfg_mac.duplex = DUPLEX_FULL;
-		cfg_mac.inband = test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
-					  advertising);
 		cfg_mac.mode = PRESTERA_MAC_MODE_1000BASE_X;
 		break;
 	}
@@ -401,6 +395,7 @@ static int prestera_port_sfp_bind(struct prestera_port *port)
 			continue;
 
 		port->phylink_pcs.ops = &prestera_pcs_ops;
+		port->phylink_pcs.neg_mode = true;
 
 		port->phy_config.dev = &port->dev->dev;
 		port->phy_config.type = PHYLINK_NETDEV;
-- 
2.30.2


