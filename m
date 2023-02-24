Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E2F6A1C3D
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 13:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjBXMgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 07:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjBXMgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 07:36:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2E0679A2
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 04:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yi14cTdYANNPEap3pqdxxJ1hsHfM+r9CN0mSG8FKdBA=; b=14UfcOsBa6nbww2NhPSDz98UyC
        +sFNmp9pAjgVPiU7itFTJ8ULwVo44eVKET6hhwcpDD9Ac85eLDe1GACqUf9OGWjD6FTYEM/5jE8Al
        zAkAa2nqiOzIrCe41tOYLlf4Yyz1TL2M+jCPM7m0Hb1fEec7gjX7nQdW+KrSyeEt561a8VH1cW1Qj
        PlP01S1KwGMV50TSql80FwfcOunRRZp9Cnye1PWNbaXd7pOO9Blm1mW+z8qGFO9ielq5nBHDPKEVf
        JiRKF+BWhR4Str2km1OS56pv4aAzeNsieIYJ20mfcknAkdYNSfmb7Mek3M3KBR7jW7iSfjfZBBtZd
        Uob2NqrA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49018 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pVXJ6-0000dF-68; Fri, 24 Feb 2023 12:36:12 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pVXJ5-00CT9m-CT; Fri, 24 Feb 2023 12:36:11 +0000
In-Reply-To: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
References: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>,
        Daniel Golle <daniel@makrotopia.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 1/4] net: mtk_eth_soc: tidy
 mtk_gmac0_rgmii_adjust()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pVXJ5-00CT9m-CT@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 24 Feb 2023 12:36:11 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get rid of the multiple tenary operators in mtk_gmac0_rgmii_adjust()
replacing them with a single if(), thus making the code easier to read.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 34 ++++++++++++---------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 14be6ea51b88..c63f17929ccf 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -397,38 +397,42 @@ static int mt7621_gmac0_rgmii_adjust(struct mtk_eth *eth,
 static void mtk_gmac0_rgmii_adjust(struct mtk_eth *eth,
 				   phy_interface_t interface, int speed)
 {
-	u32 val;
+	unsigned long rate;
+	u32 tck, rck, intf;
 	int ret;
 
 	if (interface == PHY_INTERFACE_MODE_TRGMII) {
 		mtk_w32(eth, TRGMII_MODE, INTF_MODE);
-		val = 500000000;
-		ret = clk_set_rate(eth->clks[MTK_CLK_TRGPLL], val);
+		ret = clk_set_rate(eth->clks[MTK_CLK_TRGPLL], 500000000);
 		if (ret)
 			dev_err(eth->dev, "Failed to set trgmii pll: %d\n", ret);
 		return;
 	}
 
-	val = (speed == SPEED_1000) ?
-		INTF_MODE_RGMII_1000 : INTF_MODE_RGMII_10_100;
-	mtk_w32(eth, val, INTF_MODE);
+	if (speed == SPEED_1000) {
+		intf = INTF_MODE_RGMII_1000;
+		rate = 250000000;
+		rck = RCK_CTRL_RGMII_1000;
+		tck = TCK_CTRL_RGMII_1000;
+	} else {
+		intf = INTF_MODE_RGMII_10_100;
+		rate = 500000000;
+		rck = RCK_CTRL_RGMII_10_100;
+		tck = TCK_CTRL_RGMII_10_100;
+	}
+
+	mtk_w32(eth, intf, INTF_MODE);
 
 	regmap_update_bits(eth->ethsys, ETHSYS_CLKCFG0,
 			   ETHSYS_TRGMII_CLK_SEL362_5,
 			   ETHSYS_TRGMII_CLK_SEL362_5);
 
-	val = (speed == SPEED_1000) ? 250000000 : 500000000;
-	ret = clk_set_rate(eth->clks[MTK_CLK_TRGPLL], val);
+	ret = clk_set_rate(eth->clks[MTK_CLK_TRGPLL], rate);
 	if (ret)
 		dev_err(eth->dev, "Failed to set trgmii pll: %d\n", ret);
 
-	val = (speed == SPEED_1000) ?
-		RCK_CTRL_RGMII_1000 : RCK_CTRL_RGMII_10_100;
-	mtk_w32(eth, val, TRGMII_RCK_CTRL);
-
-	val = (speed == SPEED_1000) ?
-		TCK_CTRL_RGMII_1000 : TCK_CTRL_RGMII_10_100;
-	mtk_w32(eth, val, TRGMII_TCK_CTRL);
+	mtk_w32(eth, rck, TRGMII_RCK_CTRL);
+	mtk_w32(eth, tck, TRGMII_TCK_CTRL);
 }
 
 static struct phylink_pcs *mtk_mac_select_pcs(struct phylink_config *config,
-- 
2.30.2

