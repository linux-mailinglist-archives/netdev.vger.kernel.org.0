Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24684C3151
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 17:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiBXQa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 11:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiBXQaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 11:30:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC361F83E7
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lIY6XpFN6DHXZxJ3h/lyIVZFaJkNxeJQjru2eCe7kOs=; b=oZ90EN2ioNDkkzGs/YVFGai3Gu
        pzC69jRgRZ2lAGcl6cNuk3yyoJQOloUWNsa9c4rvPasv/7b2hwnIL1716y+YeNdlZCZh5bqatc1vS
        bvL5EiGMgr7IiMdNuypnJNx+7LMfNammvkkhvZpuxPZHsVaSWYgceIBhTduItsGQdzgomM8QkqiPh
        b0AtfGs3kI7MHRCI6fEWZE5NyiFoR1vzPOJ8LngQID2BJES9ARYhLM6sB6mx3+1qqsEx3NNJ0p9ZI
        U0mYcjMuVMczXm1l0Wu5iWGLcQXGfOc9Rjb1bIo4mJ9U0hcI0891uajKheSq44e4aij2LYQPr8F1G
        mxolV8uw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39178 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nNGlw-0004C0-LE; Thu, 24 Feb 2022 16:15:16 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nNGlv-00AOid-Vd; Thu, 24 Feb 2022 16:15:16 +0000
In-Reply-To: <YhevAJyU87bfCzfs@shell.armlinux.org.uk>
References: <YhevAJyU87bfCzfs@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 1/6] net: dsa: sja1105: populate
 supported_interfaces
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nNGlv-00AOid-Vd@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 24 Feb 2022 16:15:15 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces bitmap for the SJA1105 DSA switch.

This switch only supports a static model of configuration, so we
restrict the interface modes to the configured setting.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b513713be610..90e73a982faf 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1412,6 +1412,18 @@ static void sja1105_mac_link_up(struct dsa_switch *ds, int port,
 	sja1105_inhibit_tx(priv, BIT(port), false);
 }
 
+static void sja1105_phylink_get_caps(struct dsa_switch *ds, int port,
+				     struct phylink_config *config)
+{
+	struct sja1105_private *priv = ds->priv;
+
+	/* The SJA1105 MAC programming model is through the static config
+	 * (the xMII Mode table cannot be dynamically reconfigured), and
+	 * we have to program that early.
+	 */
+	__set_bit(priv->phy_mode[port], config->supported_interfaces);
+}
+
 static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 				     unsigned long *supported,
 				     struct phylink_link_state *state)
@@ -3152,6 +3164,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.set_ageing_time	= sja1105_set_ageing_time,
 	.port_change_mtu	= sja1105_change_mtu,
 	.port_max_mtu		= sja1105_get_max_mtu,
+	.phylink_get_caps	= sja1105_phylink_get_caps,
 	.phylink_validate	= sja1105_phylink_validate,
 	.phylink_mac_config	= sja1105_mac_config,
 	.phylink_mac_link_up	= sja1105_mac_link_up,
-- 
2.30.2

