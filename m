Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B8160479F
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbiJSNmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbiJSNln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:41:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBCB1103
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FET5N1jIVAopgqHZ3UAQJzGj0VvZKQ9s+JYXeM9+4kM=; b=Cb4MWO/sIjKawzPJsm5AXNvJmZ
        KFxB/fBBcmoI/Ngq+zyqQ9rH0Kxs/qwIbFbKUu+bJqDFrUvGneihgF8m4rMhlZj3ezjT0xCRlxdj6
        T+Zfk349uMGLqq1feohKKVf1s8XRRO2DQsO20eny6w2NY35jGCwqwENp0B4w7DO0pNA9POzOrMIjp
        vEyIP/0AoDELUXVqTwKm28CK8RHWBlSuVzCA/OZ8ljeJI4WuQIBx48YMWeZPnIHqjCOJkTv7XrQhi
        XqM4zizCYhOTAgvWJhUfnkQEDMGfAde9zIeoR4AAcy23Jf7Z4Kp4Y9uyQOSXqMfpzsPxFVYv9BvFv
        1g7cC40g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:51920 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ol982-0005jc-2K; Wed, 19 Oct 2022 14:29:02 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1ol981-00EDSj-FZ; Wed, 19 Oct 2022 14:29:01 +0100
In-Reply-To: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/7] net: sfp: ignore power level 3 prior to SFF-8472
 Rev 11.4
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ol981-00EDSj-FZ@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 19 Oct 2022 14:29:01 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

