Return-Path: <netdev+bounces-11415-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 305E97330C3
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:07:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 618681C20FC1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B53BA1952F;
	Fri, 16 Jun 2023 12:06:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DA219529
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 12:06:42 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4411D30C6
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=GJCdhl7dHkTvfYLybx9b59umNf9fUYi6iq2EY5olQqg=; b=fc+4YAHzPCgJYGPt6pqmZkawl+
	RAHzVdst9XXIL7VgeCJts8GWwJQS+Ffn7dcGPM9n2exErL4tLEluylwapz/NrY83jPoLzyjCcblr2
	jWiGLRB+arQdXsIdryJJ5ZEd2HTLXq/DyC+7WB61n7R6NKyK8wJSL8X+E/cigcpJPjrUO4EiuZDSs
	lpm2HOW6uHMt+Vh4/j/FTiFIJN8kQf3JY3IVfQUrouxHAisNz3vv60eLKmhUdn//j4H6nn3L0m0NN
	6WcXvs2abpayBE5MwLlGVwef3TNaRL8/wCb5DBLxLLZDI9Y5XpEeilkWYus2qZYfxaygpdpAqOr+g
	gn1UAD7Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:58002 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1qA8Dk-00051m-Et; Fri, 16 Jun 2023 13:06:28 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1qA8Dj-00EaFG-Mt; Fri, 16 Jun 2023 13:06:27 +0100
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
Subject: [PATCH net-next 02/15] net: phylink: convert
 phylink_mii_c22_pcs_config() to neg_mode
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1qA8Dj-00EaFG-Mt@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 16 Jun 2023 13:06:27 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use phylink_pcs_neg_mode() for phylink_mii_c22_pcs_config(). This
results in no functional change.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index e2169ca00979..601d64f57e33 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -3521,6 +3521,7 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 			       phy_interface_t interface,
 			       const unsigned long *advertising)
 {
+	unsigned int neg_mode;
 	bool changed = 0;
 	u16 bmcr;
 	int ret, adv;
@@ -3534,15 +3535,13 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 		changed = ret;
 	}
 
-	/* Ensure ISOLATE bit is disabled */
-	if (mode == MLO_AN_INBAND &&
-	    (interface == PHY_INTERFACE_MODE_SGMII ||
-	     interface == PHY_INTERFACE_MODE_QSGMII ||
-	     linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising)))
+	neg_mode = phylink_pcs_neg_mode(mode, interface, advertising);
+	if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED)
 		bmcr = BMCR_ANENABLE;
 	else
 		bmcr = 0;
 
+	/* Configure the inband state. Ensure ISOLATE bit is disabled */
 	ret = mdiodev_modify(pcs, MII_BMCR, BMCR_ANENABLE | BMCR_ISOLATE, bmcr);
 	if (ret < 0)
 		return ret;
-- 
2.30.2


