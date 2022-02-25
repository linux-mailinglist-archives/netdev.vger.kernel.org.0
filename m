Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934C04C4A73
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242868AbiBYQUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242854AbiBYQUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:20:14 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FAC6F489
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=y+a6uE9CaIkzgDU5v3MVKtDHY9vCiD2SWHIhtZjEc1Y=; b=NAbNfIPOlOjUPn9vJcqrYR8iLv
        8mAfiojAoR0HaxT7/l35NsY9sG7BspuqvBCs5Z7Nqh8fppswaWiMahE/j4DiJBhDXJtn4dBu7uXSB
        eQgIdUdyOkzgsIB8n7l/c9q4iF9hhoU+QxDHBT2ZudgaYcWnwuuaoA+CKxDce3yz8Qt0h/Ncw9cdk
        RxqwJWRQcYrsNt1KwDc0DXYnCnuvKbu2OoPzP+Qi5IUtfe5iJtijJCe37kjCsqW+cYVq7q5D4h2UI
        Mv1DN+wUHslAHFwlxgsZ+1WNQyDiqWu+OUlQntCAkvq8KvHITzpevZR93LQgz2D6wgI5xI1icMXdN
        XfyPOwjg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47602 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nNdJb-0005hR-H9; Fri, 25 Feb 2022 16:19:31 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nNdJa-00AsoY-U5; Fri, 25 Feb 2022 16:19:30 +0000
In-Reply-To: <YhkBfuRJkOG9gVZR@shell.armlinux.org.uk>
References: <YhkBfuRJkOG9gVZR@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] net: dsa: ocelot: remove interface checks
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nNdJa-00AsoY-U5@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 25 Feb 2022 16:19:30 +0000
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

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 7 -------
 drivers/net/dsa/ocelot/seville_vsc9953.c | 7 -------
 2 files changed, 14 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 33f0ceae381d..434c7e4f0648 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -944,15 +944,8 @@ static void vsc9959_phylink_validate(struct ocelot *ocelot, int port,
 				     unsigned long *supported,
 				     struct phylink_link_state *state)
 {
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    state->interface != ocelot_port->phy_mode) {
-		linkmode_zero(supported);
-		return;
-	}
-
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 	phylink_set(mask, Pause);
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index f2f1608a476c..f12c1a1a3d5c 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -917,15 +917,8 @@ static void vsc9953_phylink_validate(struct ocelot *ocelot, int port,
 				     unsigned long *supported,
 				     struct phylink_link_state *state)
 {
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    state->interface != ocelot_port->phy_mode) {
-		linkmode_zero(supported);
-		return;
-	}
-
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 	phylink_set(mask, Pause);
-- 
2.30.2

