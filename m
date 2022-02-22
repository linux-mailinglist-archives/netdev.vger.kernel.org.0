Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609174BF593
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiBVKQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiBVKQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:16:37 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455DB13D91E
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 02:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WgK69KSnjGRwhvkFJlQk/Vo1p3pd4aMi2MXWda7+Y9s=; b=aRXJNLF5ShUdmIpaBDnBQV2nuX
        SGvM8yatyyqkqUMbMcWDemrDwX4TNYCjOcDWgWCLRLohVVcIU8Ci2uoPk2+C1/H+Wo7QZGHaNCAiq
        IL4xzfifQFXX9OGge3okeSX132jZVl2dmoh9MNsqFwniijwdpqmu7qBZA4lrnV7/ENYR/cFdhhCi7
        Yf7aUWaVbP/5ozLfVn9BD8UYrn/DPHD7h6GzROR4SrGaG+V47q4g9Pv4Wvmx021ISp12e8PYm0XGf
        WinKg3DU7gmjZuGK7HtgjX4v+USU5tlWaWvJ7ytJ0tGSLyVrMmPWN3SvhMLi8GAflGTOwSyt3gqcc
        QW0z6uvA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:48106 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nMSDI-0001PT-IP; Tue, 22 Feb 2022 10:16:08 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nMSDH-00A2Rf-Va; Tue, 22 Feb 2022 10:16:08 +0000
In-Reply-To: <YhS3cko8D5c5tr+E@shell.armlinux.org.uk>
References: <YhS3cko8D5c5tr+E@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 3/5] net: dsa: b53: drop use of
 phylink_helper_basex_speed()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nMSDH-00A2Rf-Va@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 22 Feb 2022 10:16:07 +0000
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
 drivers/net/dsa/b53/b53_common.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 211c0e499370..a637e44bce0b 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1348,8 +1348,6 @@ void b53_phylink_validate(struct dsa_switch *ds, int port,
 
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
-
-	phylink_helper_basex_speed(state);
 }
 EXPORT_SYMBOL(b53_phylink_validate);
 
-- 
2.30.2

