Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3194C4416
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 13:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240375AbiBYMAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240371AbiBYMAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:00:43 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0692D2692A4
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tkUN5/Y2RxIU5y/4cMBGXQwJ6wlsGiAJl7uIDiLAQv8=; b=LtcT63GGSEGl0h+d6F1Jx50XkD
        lQvtTygSwQJ3cn4ws3DKqCO5JUeMUuaDwepmXcXcWhjnxtvlqavgDBu77OEFi0r726hIuA2shQrrp
        29f6rbi5xAWAsTI04eEZtJCB2uxYRAJtKdORGkNk26t5wJCx6chhRpyfQxxDcS0xUF+KhWIYMAHEG
        Sb2Zu4AY/mRQi5zs/wEWEtsbN/Mlsz/IDY4t83B5075TJHDT254Ebqh3s5/urHhUdNoLQ+JTI8Hv0
        8cwzR+WKr2kGwCk2K11or3HM8UKT9CgbL3YaWZ09X8CweUV952bFq44EwZKPdqZg5psQz8vHbXzdL
        Dy6h0ueA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46076 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nNZGZ-0005Iv-PG; Fri, 25 Feb 2022 12:00:07 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nNZGZ-00AbGn-6p; Fri, 25 Feb 2022 12:00:07 +0000
In-Reply-To: <YhjEm/Vu+w1XQpGT@shell.armlinux.org.uk>
References: <YhjEm/Vu+w1XQpGT@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/6] net: dsa: sja1105: remove interface checks
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nNZGZ-00AbGn-6p@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 25 Feb 2022 12:00:07 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the supported interfaces bitmap is populated, phylink will itself
check that the interface mode is present in this bitmap. Drivers no
longer need to perform this check themselves. Remove these checks.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 29 --------------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 90e73a982faf..e278bd86e3c6 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1358,19 +1358,6 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	return sja1105_clocking_setup_port(priv, port);
 }
 
-/* The SJA1105 MAC programming model is through the static config (the xMII
- * Mode table cannot be dynamically reconfigured), and we have to program
- * that early (earlier than PHYLINK calls us, anyway).
- * So just error out in case the connected PHY attempts to change the initial
- * system interface MII protocol from what is defined in the DT, at least for
- * now.
- */
-static bool sja1105_phy_mode_mismatch(struct sja1105_private *priv, int port,
-				      phy_interface_t interface)
-{
-	return priv->phy_mode[port] != interface;
-}
-
 static void sja1105_mac_config(struct dsa_switch *ds, int port,
 			       unsigned int mode,
 			       const struct phylink_link_state *state)
@@ -1379,12 +1366,6 @@ static void sja1105_mac_config(struct dsa_switch *ds, int port,
 	struct sja1105_private *priv = ds->priv;
 	struct dw_xpcs *xpcs;
 
-	if (sja1105_phy_mode_mismatch(priv, port, state->interface)) {
-		dev_err(ds->dev, "Changing PHY mode to %s not supported!\n",
-			phy_modes(state->interface));
-		return;
-	}
-
 	xpcs = priv->xpcs[port];
 
 	if (xpcs)
@@ -1438,16 +1419,6 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 
 	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
 
-	/* include/linux/phylink.h says:
-	 *     When @state->interface is %PHY_INTERFACE_MODE_NA, phylink
-	 *     expects the MAC driver to return all supported link modes.
-	 */
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    sja1105_phy_mode_mismatch(priv, port, state->interface)) {
-		linkmode_zero(supported);
-		return;
-	}
-
 	/* The MAC does not support pause frames, and also doesn't
 	 * support half-duplex traffic modes.
 	 */
-- 
2.30.2

