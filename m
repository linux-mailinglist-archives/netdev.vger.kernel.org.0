Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7038B4BA843
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244335AbiBQSbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:31:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240974AbiBQSbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:31:04 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADA638A4
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dnOyk9FKjQZTnTOfVy2TBoOjkOtllCA2gIRWM9ZJ+dU=; b=zH4zs4yMSXa3mbd80ELfCCv88j
        1Shy0vohj6gcjRlx8tRGgcaT/sdYm4QEJYgSvurA3ZPSnuEEn46TGnKR5CY/p1wqFuq9d+Sgq20nY
        v6lxqbJd4QhPpp/DJJvUdqlRjo//XhSAMv4g8hRJq4e41SpEPjPHFarbRTjrvj3qcTRHUSDQOhLtw
        Nbu0XgFSWwfur2sCQT751IobF7aKKtL8A/A/RFVPFkSzMDVm1CHKQl7Z267o/PQZR7Vol+rlD9ntG
        UvGZeUl3lWtD4731TLIN7kj/bx1htwi908kF0ebAa9gTzI+jy76lg4UyB/aRULUsXG6oAsZZi7+Rd
        bMzqqWLA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34442 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nKlYE-0005GR-IN; Thu, 17 Feb 2022 18:30:46 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nKlYD-009aL4-W1; Thu, 17 Feb 2022 18:30:46 +0000
In-Reply-To: <Yg6UHt2HAw7YTiwN@shell.armlinux.org.uk>
References: <Yg6UHt2HAw7YTiwN@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v2 3/6] net: dsa: qca8k: move
 qca8k_phylink_mac_link_state()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nKlYD-009aL4-W1@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 17 Feb 2022 18:30:45 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move qca8k_phylink_mac_link_state() to separate the code movement from
code changes.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/qca8k.c | 84 ++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 760fbc6e3c4d..ff572aba1430 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1852,48 +1852,6 @@ static void qca8k_phylink_get_caps(struct dsa_switch *ds, int port,
 		MAC_10 | MAC_100 | MAC_1000FD;
 }
 
-static int
-qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
-			     struct phylink_link_state *state)
-{
-	struct qca8k_priv *priv = ds->priv;
-	u32 reg;
-	int ret;
-
-	ret = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port), &reg);
-	if (ret < 0)
-		return ret;
-
-	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
-	state->an_complete = state->link;
-	state->an_enabled = !!(reg & QCA8K_PORT_STATUS_LINK_AUTO);
-	state->duplex = (reg & QCA8K_PORT_STATUS_DUPLEX) ? DUPLEX_FULL :
-							   DUPLEX_HALF;
-
-	switch (reg & QCA8K_PORT_STATUS_SPEED) {
-	case QCA8K_PORT_STATUS_SPEED_10:
-		state->speed = SPEED_10;
-		break;
-	case QCA8K_PORT_STATUS_SPEED_100:
-		state->speed = SPEED_100;
-		break;
-	case QCA8K_PORT_STATUS_SPEED_1000:
-		state->speed = SPEED_1000;
-		break;
-	default:
-		state->speed = SPEED_UNKNOWN;
-		break;
-	}
-
-	state->pause = MLO_PAUSE_NONE;
-	if (reg & QCA8K_PORT_STATUS_RXFLOW)
-		state->pause |= MLO_PAUSE_RX;
-	if (reg & QCA8K_PORT_STATUS_TXFLOW)
-		state->pause |= MLO_PAUSE_TX;
-
-	return 1;
-}
-
 static void
 qca8k_phylink_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 			    phy_interface_t interface)
@@ -1944,6 +1902,48 @@ qca8k_phylink_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
 	qca8k_write(priv, QCA8K_REG_PORT_STATUS(port), reg);
 }
 
+static int
+qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
+			     struct phylink_link_state *state)
+{
+	struct qca8k_priv *priv = ds->priv;
+	u32 reg;
+	int ret;
+
+	ret = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port), &reg);
+	if (ret < 0)
+		return ret;
+
+	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
+	state->an_complete = state->link;
+	state->an_enabled = !!(reg & QCA8K_PORT_STATUS_LINK_AUTO);
+	state->duplex = (reg & QCA8K_PORT_STATUS_DUPLEX) ? DUPLEX_FULL :
+							   DUPLEX_HALF;
+
+	switch (reg & QCA8K_PORT_STATUS_SPEED) {
+	case QCA8K_PORT_STATUS_SPEED_10:
+		state->speed = SPEED_10;
+		break;
+	case QCA8K_PORT_STATUS_SPEED_100:
+		state->speed = SPEED_100;
+		break;
+	case QCA8K_PORT_STATUS_SPEED_1000:
+		state->speed = SPEED_1000;
+		break;
+	default:
+		state->speed = SPEED_UNKNOWN;
+		break;
+	}
+
+	state->pause = MLO_PAUSE_NONE;
+	if (reg & QCA8K_PORT_STATUS_RXFLOW)
+		state->pause |= MLO_PAUSE_RX;
+	if (reg & QCA8K_PORT_STATUS_TXFLOW)
+		state->pause |= MLO_PAUSE_TX;
+
+	return 1;
+}
+
 static void
 qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data)
 {
-- 
2.30.2

