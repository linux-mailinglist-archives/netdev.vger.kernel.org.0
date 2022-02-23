Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4564C1163
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 12:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239954AbiBWLfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 06:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239957AbiBWLfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 06:35:14 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D5892843
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 03:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=paCGtpP/ZhQMLZc3iDwxQIlZbZ7Zk52B/3okQ8tkR14=; b=VyGxTwta5zVbw5xS51TkUg68rl
        BV3QShvpiaUzoiS5mXZ80UtG9Uoog3k1B2LeXkv8CK21CZU0c4IaumhMnbP8SIGWfKZa62JNCupBq
        xBBIISkbpb6qewQWH2Z4ux+comdQ28NEVpaYHXjCyUmFlme7G4lErljTCi28qKzUuEw/YP3GB2kwZ
        +3vJZY/+aOVLMGn+nkAlu6OshvzXWvfEszSUvsJRT5bX0XtJ5IJal30P7Qs26wWt7VnzEiSdPHFbX
        JtHfBVWtgsjEjbhhc3SusvA8ZJiRVhPA9+xfa2GQOBCzGVdL0mxVCPBSmGYo1UFZIgbCZOvNJNXuX
        SKtJR4fg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57382 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nMpuo-0002k1-G2; Wed, 23 Feb 2022 11:34:38 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nMpun-00AJou-Sm; Wed, 23 Feb 2022 11:34:37 +0000
In-Reply-To: <YhYbpNsFROcSe4z+@shell.armlinux.org.uk>
References: <YhYbpNsFROcSe4z+@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next v2 05/10] net: dsa: mt7530: drop use of
 phylink_helper_basex_speed()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nMpun-00AJou-Sm@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 23 Feb 2022 11:34:37 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a better method to select SFP interface modes, we
no longer need to use phylink_helper_basex_speed() in a driver's
validation function.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mt7530.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9579cd9aaa18..25c3c54f1380 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2942,11 +2942,6 @@ mt753x_phylink_validate(struct dsa_switch *ds, int port,
 
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
-
-	/* We can only operate at 2500BaseX or 1000BaseX.  If requested
-	 * to advertise both, only report advertising at 2500BaseX.
-	 */
-	phylink_helper_basex_speed(state);
 }
 
 static int
-- 
2.30.2

