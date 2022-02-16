Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803854B8C06
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbiBPPGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:06:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbiBPPG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:06:27 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF62295FFA
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 07:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=y778rSaer7SHdzoEBNUEkWOYz2DakYuXvuN0Yx0h/tw=; b=mKN/koElBYVwhiuPg0+S7tf72u
        GyodqHnZV+c++BiNNdWYZzyGBlv5KOtT/elHOe9xuCgiU+qUcnpEY1GE9pf8xLR2cStmDlBuzdpZF
        IuqWjDOb+MjRozGVPS2ZA8wAaJpKSSTWeLeBWeNGKD4s9PfxYsn0WwnuXVgH+M7EwHeUybCZMfn7/
        HkhNhdxMOhgr90CaZmNaB+3pW6K11Fdjza3ax/KpEMz8ZjpFYVhhHxAN79C4HigiA3GRVxuorS1jl
        Pni0tRBQgENM//i8uq+jTMdwhvE11yDyafazy3R9jcDRoxjeB2CBlr2Rtg1Ryj/Ekmp7/0XPg818o
        T0LhPfQQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46588 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nKLsh-0003z2-TA; Wed, 16 Feb 2022 15:06:11 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nKLsh-009NMm-A9; Wed, 16 Feb 2022 15:06:11 +0000
In-Reply-To: <Yg0SYHh1YNWsPB1D@shell.armlinux.org.uk>
References: <Yg0SYHh1YNWsPB1D@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 3/6] net: dsa: qca8k: move
 qca8k_phylink_mac_link_state()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nKLsh-009NMm-A9@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 16 Feb 2022 15:06:11 +0000
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
index 22938d7cd161..fb052d6eae52 100644
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

