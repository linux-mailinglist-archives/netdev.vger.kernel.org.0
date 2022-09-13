Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3D95B7A90
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 21:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbiIMTGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 15:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiIMTGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 15:06:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C1331EF1
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 12:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ynokmYv7OrS8g8yvY9cAZ7WLV0jmFUvFd4Ycc9BWlz8=; b=yPkGU1OEdDS6AZyuD8kM8j832Z
        dm0lP4pq8fkvNkQm9vpd0hqI6iR9n7Uing/p9v0GYa0X5+9fsSW9oUFlhcNChzp/NOtQ0sXK8yqhj
        nah3DXeYdsy9zAIQjLaocHzbutIC/XOIaC2dUDO0qNsusfm1XxS4oNtD+hGIexmLYlEmitjiMTHxG
        64oTYNnTFrX9Pi/bFnZyfQkg5ODbtwpDuhsLYInBltBqk5lsl75E4encBFmvNnS/kojc8ez8HfpO4
        LMmhq36ljJ0PaLQ5JmO56ea0VJc1UfSXNTWm5GhJL5yHCkqGI//1oZ87zAuib8hHpNLI0wabozPm5
        SenNCeJA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:51748 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oYBF5-0003RE-GO; Tue, 13 Sep 2022 20:06:43 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oYBF4-006kCK-Ti; Tue, 13 Sep 2022 20:06:42 +0100
In-Reply-To: <YyDUnvM1b0dZPmmd@shell.armlinux.org.uk>
References: <YyDUnvM1b0dZPmmd@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Josef Schlehofer <pepe.schlehofer@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/5] net: sfp: move Huawei MA5671A fixup
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oYBF4-006kCK-Ti@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 13 Sep 2022 20:06:42 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move this module over to the new fixup mechanism.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 2ef7bb4c00d1..d2d66c691f97 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -316,6 +316,11 @@ static void sfp_fixup_long_startup(struct sfp *sfp)
 	sfp->module_t_start_up = T_START_UP_BAD_GPON;
 }
 
+static void sfp_fixup_ignore_tx_fault(struct sfp *sfp)
+{
+	sfp->tx_fault_ignore = true;
+}
+
 static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
 				unsigned long *modes)
 {
@@ -353,6 +358,7 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.vendor = "HUAWEI",
 		.part = "MA5671A",
 		.modes = sfp_quirk_2500basex,
+		.fixup = sfp_fixup_ignore_tx_fault,
 	}, {
 		// Lantech 8330-262D-E can operate at 2500base-X, but
 		// incorrectly report 2500MBd NRZ in their EEPROM
@@ -2011,11 +2017,7 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 
 	sfp->module_t_start_up = T_START_UP;
 
-	if (!memcmp(id.base.vendor_name, "HUAWEI          ", 16) &&
-	    !memcmp(id.base.vendor_pn, "MA5671A         ", 16))
-		sfp->tx_fault_ignore = true;
-	else
-		sfp->tx_fault_ignore = false;
+	sfp->tx_fault_ignore = false;
 
 	sfp->quirk = sfp_lookup_quirk(&id);
 	if (sfp->quirk && sfp->quirk->fixup)
-- 
2.30.2

