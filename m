Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11D2607A2B
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiJUPKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiJUPJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:09:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C6840549;
        Fri, 21 Oct 2022 08:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FET5N1jIVAopgqHZ3UAQJzGj0VvZKQ9s+JYXeM9+4kM=; b=lnFx6aE7A8ykb4zXIhIM0i08JZ
        4OAlp0DjaNsHAm/9EAIMbwEoclQMkqasMfEONVBJMBmhohlBHv3UbnQN+WDyBExTcAxA2IM54i6j0
        xp5D9NX1dxrxHjlmN/zDVVoKWGEfaLODBf9QtZclyhUyFZgZs1KK4h+twS4Yx2iOSGTcPziwH3n/7
        8qvjDe2512ksYcMe4nhAqsbW3TkWdynXk8IznnfKLJIzCTEwiOY0U0B/9x12vvmZ/ADhRmB2E6pGj
        YkByXL2inSm7/lBE//2U+3sMb3VJHaWelWO/CNxSJC5hzSysNbdeyDQ2W3tq/3CzJjVz0Zjv8E5dJ
        1CFXcjeg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36026 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oltek-0000Mi-Uz; Fri, 21 Oct 2022 16:09:54 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oltek-00Fwx5-8v; Fri, 21 Oct 2022 16:09:54 +0100
In-Reply-To: <Y1K17UtfFopACIi2@shell.armlinux.org.uk>
References: <Y1K17UtfFopACIi2@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH net-next 4/7] net: sfp: ignore power level 3 prior to SFF-8472
 Rev 11.4
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oltek-00Fwx5-8v@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 21 Oct 2022 16:09:54 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Power level 3 was included in SFF-8472 revision 11.9, but this does
not have a compliance code. Use revision 11.4 as the minimum
compliance level instead.

This should avoid any spurious indication of 2W modules.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index a7635b02524a..af676e28ba6a 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1764,7 +1764,9 @@ static int sfp_module_parse_power(struct sfp *sfp)
 	if (sfp->id.ext.sff8472_compliance >= SFP_SFF8472_COMPLIANCE_REV10_2 &&
 	    sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
 		power_mW = 1500;
-	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
+	/* Added in Rev 11.9, but there is no compliance code for this */
+	if (sfp->id.ext.sff8472_compliance >= SFP_SFF8472_COMPLIANCE_REV11_4 &&
+	    sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
 		power_mW = 2000;
 
 	/* Power level 1 modules (max. 1W) are always supported. */
-- 
2.30.2

