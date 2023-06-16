Return-Path: <netdev+bounces-11426-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60D377330DB
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:10:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91A621C21005
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C84A19932;
	Fri, 16 Jun 2023 12:07:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C68182AD
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 12:07:40 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1F030ED
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=9J/en89BNiDN/VLD4ALvh4m6EdXoX9oLSq/ICFr6TF8=; b=mdQJXoapqn++w4AJi22exchsu9
	243VccepB1yaHIkW9gaH18HcdyDZnDY9a9VtCEUXFiuW+xTRTsXGd5WrSLtpMdsJuDEld8hk/99fE
	Im/8UwOPLdiEf1pgiAJTd3jgg8Ib795hcI+tQcTKhjSOqdTm3YtLrAczj+XgyM1X43sZe34m54GHT
	QtYPe7tikN27jwWpaHCiuiXr69X3l2ARvcB5mRHAWixJODmzWKpsip69Hh/s9J1JCq7TlVnU+3V6X
	3/NwJlyq8/cd3Xl2YjONWEskl2HIRCdkbrkfKyWQ/82TPOda9SnHTsey2SAsc4dOmMjnMTRUqjgi9
	2NghRI1Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34046 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1qA8Ef-00057b-4n; Fri, 16 Jun 2023 13:07:25 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1qA8Ee-00EaGL-Az; Fri, 16 Jun 2023 13:07:24 +0100
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
Subject: [PATCH net-next 13/15] net: dsa: b53: update PCS driver to use
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
Message-Id: <E1qA8Ee-00EaGL-Az@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 16 Jun 2023 13:07:24 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Update B53's embedded PCS driver to use neg_mode, even though it makes
no use of it or the "mode" argument. This makes the driver consistent
with converted drivers.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/b53/b53_serdes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_serdes.c b/drivers/net/dsa/b53/b53_serdes.c
index 0690210770ff..b0ccebcd3ffa 100644
--- a/drivers/net/dsa/b53/b53_serdes.c
+++ b/drivers/net/dsa/b53/b53_serdes.c
@@ -65,7 +65,7 @@ static u16 b53_serdes_read(struct b53_device *dev, u8 lane,
 	return b53_serdes_read_blk(dev, offset, block);
 }
 
-static int b53_serdes_config(struct phylink_pcs *pcs, unsigned int mode,
+static int b53_serdes_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 			     phy_interface_t interface,
 			     const unsigned long *advertising,
 			     bool permit_pause_to_mac)
@@ -239,6 +239,7 @@ int b53_serdes_init(struct b53_device *dev, int port)
 	pcs->dev = dev;
 	pcs->lane = lane;
 	pcs->pcs.ops = &b53_pcs_ops;
+	pcs->pcs.neg_mode = true;
 
 	return 0;
 }
-- 
2.30.2


