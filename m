Return-Path: <netdev+bounces-11428-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30D747330E1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:11:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF26928184D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7978B1993D;
	Fri, 16 Jun 2023 12:07:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696A618C1C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 12:07:49 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB37A30E1
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gWIapYiw/sDaQusNCqhjwNu1a8M8yXgn/oDDTG5bQlY=; b=Jb6XQFwWOjLeAllj8Wck16Ns40
	jS4rwcqjxQVZ0wekj54Vn3Ke97J8f0cpIVDjOpkTemDerANuOM1sl9r2OZzQNXJW7xdPNASarPX0d
	0PmOapbEnt6kijONnMPNTCwq8fb27kmJTOW2UwqomTs9TU+1Ozq+1dck2Ss6xw/B8nNyVX+wapf18
	1um68uNRgPX8EftZtKMnS5hPosNqR79JXGhVK2dj1YQmbs2Qn+8KXNFalYA3nZw62hgSnKQYTBRXa
	hHWS+VItWpWs/xeow0Q7QFVWRzv9pZtVJPD2KvgaxAiQANGnxYzbyXemlZFXGFSstmzjAS7czVkPB
	sOvakRZQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36958 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1qA8Ep-00058m-C0; Fri, 16 Jun 2023 13:07:35 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1qA8Eo-00EaGX-KJ; Fri, 16 Jun 2023 13:07:34 +0100
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
Subject: [PATCH net-next 15/15] net: macb: update PCS driver to use neg_mode
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1qA8Eo-00EaGX-KJ@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 16 Jun 2023 13:07:34 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Update macb's embedded PCS drivers to use neg_mode, even though it
makes no use of it or the "mode" argument. This makes the driver
consistent with converted drivers.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/cadence/macb_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 50a4b04315e9..e2640c81fe8c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -563,7 +563,7 @@ static void macb_set_tx_clk(struct macb *bp, int speed)
 		netdev_err(bp->dev, "adjusting tx_clk failed.\n");
 }
 
-static void macb_usx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+static void macb_usx_pcs_link_up(struct phylink_pcs *pcs, unsigned int neg_mode,
 				 phy_interface_t interface, int speed,
 				 int duplex)
 {
@@ -596,7 +596,7 @@ static void macb_usx_pcs_get_state(struct phylink_pcs *pcs,
 }
 
 static int macb_usx_pcs_config(struct phylink_pcs *pcs,
-			       unsigned int mode,
+			       unsigned int neg_mode,
 			       phy_interface_t interface,
 			       const unsigned long *advertising,
 			       bool permit_pause_to_mac)
@@ -621,7 +621,7 @@ static void macb_pcs_an_restart(struct phylink_pcs *pcs)
 }
 
 static int macb_pcs_config(struct phylink_pcs *pcs,
-			   unsigned int mode,
+			   unsigned int neg_mode,
 			   phy_interface_t interface,
 			   const unsigned long *advertising,
 			   bool permit_pause_to_mac)
@@ -862,7 +862,9 @@ static int macb_mii_probe(struct net_device *dev)
 	struct macb *bp = netdev_priv(dev);
 
 	bp->phylink_sgmii_pcs.ops = &macb_phylink_pcs_ops;
+	bp->phylink_sgmii_pcs.neg_mode = true;
 	bp->phylink_usx_pcs.ops = &macb_phylink_usx_pcs_ops;
+	bp->phylink_usx_pcs.neg_mode = true;
 
 	bp->phylink_config.dev = &dev->dev;
 	bp->phylink_config.type = PHYLINK_NETDEV;
-- 
2.30.2


