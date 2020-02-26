Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E6D16FC1E
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 11:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgBZK0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 05:26:41 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45620 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgBZK0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 05:26:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=U2C389YDD9wIDLDhBEkkx1b5Jtw0Ypfhi+Dyxt33wDk=; b=WGKMf57M3uxeuGnW4MA5OtZ20w
        uVwwaa6C70SGiNKDzeRkKRcNtZ2mdzb2K/xNCN1DTQrUV1WnnEC37KZDPXdnUkpRkM4Zt6VTzWN7O
        xfEDKGbYGt9aozHA+lCnzlLrLu8u9SY99N2s778TcN/S+JSwRc5bLpK8zWV4zA8zGVNPEf0TQWqDi
        auP4RuavaH54f6zHu9AJAJG+jRFCk682Dn/8xQPQVRNF+Ptwu8Lf483CkX3NbIn5ZZU7qteqpcIAG
        p3lBrUgCKT7RAIwvefbYvaq8XVqcpCDtGxVgFSqLEm2RHe6iOlYILuGThsyFeWtpyhs0Ow0b7uZP6
        qjWhxV7w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41410 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j6trR-0006sI-A0; Wed, 26 Feb 2020 10:24:13 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j6trK-0003Gn-Ta; Wed, 26 Feb 2020 10:24:06 +0000
In-Reply-To: <20200226102312.GX25745@shell.armlinux.org.uk>
References: <20200226102312.GX25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v2 6/8] net: macb: use resolved link config in
 mac_link_up()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j6trK-0003Gn-Ta@rmk-PC.armlinux.org.uk>
Date:   Wed, 26 Feb 2020 10:24:06 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the macb ethernet driver to use the finalised link
parameters in mac_link_up() rather than the parameters in mac_config().

Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/cadence/macb.h      |  1 -
 drivers/net/ethernet/cadence/macb_main.c | 50 ++++++++++++++----------
 2 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index a3f0f27fc79a..ab827fb4b6b9 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1200,7 +1200,6 @@ struct macb {
 	unsigned int		dma_burst_length;
 
 	phy_interface_t		phy_interface;
-	int			speed;
 
 	/* AT91RM9200 transmit */
 	struct sk_buff *skb;			/* holds skb until xmit interrupt completes */
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 7ab0bef5e1bd..3a7c26b08607 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -571,37 +571,20 @@ static void macb_mac_config(struct phylink_config *config, unsigned int mode,
 
 	old_ctrl = ctrl = macb_or_gem_readl(bp, NCFGR);
 
-	/* Clear all the bits we might set later */
-	ctrl &= ~(MACB_BIT(SPD) | MACB_BIT(FD) | MACB_BIT(PAE));
-
 	if (bp->caps & MACB_CAPS_MACB_IS_EMAC) {
 		if (state->interface == PHY_INTERFACE_MODE_RMII)
 			ctrl |= MACB_BIT(RM9200_RMII);
 	} else {
-		ctrl &= ~(GEM_BIT(GBE) | GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
-
-		/* We do not support MLO_PAUSE_RX yet */
-		if (state->pause & MLO_PAUSE_TX)
-			ctrl |= MACB_BIT(PAE);
+		ctrl &= ~(GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
 
 		if (state->interface == PHY_INTERFACE_MODE_SGMII)
 			ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
 	}
 
-	if (state->speed == SPEED_1000)
-		ctrl |= GEM_BIT(GBE);
-	else if (state->speed == SPEED_100)
-		ctrl |= MACB_BIT(SPD);
-
-	if (state->duplex)
-		ctrl |= MACB_BIT(FD);
-
 	/* Apply the new configuration, if any */
 	if (old_ctrl ^ ctrl)
 		macb_or_gem_writel(bp, NCFGR, ctrl);
 
-	bp->speed = state->speed;
-
 	spin_unlock_irqrestore(&bp->lock, flags);
 }
 
@@ -635,10 +618,33 @@ static void macb_mac_link_up(struct phylink_config *config,
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct macb *bp = netdev_priv(ndev);
 	struct macb_queue *queue;
+	unsigned long flags;
 	unsigned int q;
+	u32 ctrl;
+
+	spin_lock_irqsave(&bp->lock, flags);
+
+	ctrl = macb_or_gem_readl(bp, NCFGR);
+
+	ctrl &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
+
+	if (speed == SPEED_100)
+		ctrl |= MACB_BIT(SPD);
+
+	if (duplex)
+		ctrl |= MACB_BIT(FD);
 
 	if (!(bp->caps & MACB_CAPS_MACB_IS_EMAC)) {
-		macb_set_tx_clk(bp->tx_clk, bp->speed, ndev);
+		ctrl &= ~(GEM_BIT(GBE) | MACB_BIT(PAE));
+
+		if (speed == SPEED_1000)
+			ctrl |= GEM_BIT(GBE);
+
+		/* We do not support MLO_PAUSE_RX yet */
+		if (tx_pause)
+			ctrl |= MACB_BIT(PAE);
+
+		macb_set_tx_clk(bp->tx_clk, speed, ndev);
 
 		/* Initialize rings & buffers as clearing MACB_BIT(TE) in link down
 		 * cleared the pipeline and control registers.
@@ -651,6 +657,10 @@ static void macb_mac_link_up(struct phylink_config *config,
 				     bp->rx_intr_mask | MACB_TX_INT_FLAGS | MACB_BIT(HRESP));
 	}
 
+	macb_or_gem_writel(bp, NCFGR, ctrl);
+
+	spin_unlock_irqrestore(&bp->lock, flags);
+
 	/* Enable Rx and Tx */
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
 
@@ -4432,8 +4442,6 @@ static int macb_probe(struct platform_device *pdev)
 	else
 		bp->phy_interface = interface;
 
-	bp->speed = SPEED_UNKNOWN;
-
 	/* IP specific init */
 	err = init(pdev);
 	if (err)
-- 
2.20.1

