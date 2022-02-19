Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D784BC847
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 12:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiBSLrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 06:47:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiBSLrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 06:47:39 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534261E549C
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 03:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=snv6472ftEHjfmq9UV3wTSlkJiNDwgbzyetg9ACaauA=; b=EvaZiDh30hPMfjabnVJwdHQXVo
        h5dGBNrRFChSMf1nIdObPPZi1OzHWQ79QpFKbQ88zKhup+3nWliWarOy4BTF24VsNODIwtZpV8IPk
        48bdIImYrvEuQpCTQj+eQDT9pIYGlm1jwB+53pVt/uZNi7pbkSlk9kbLl19zFYzP0NzWU4vVbX+JO
        /+3V6fXcUN4aJYvd7WdosMCUeP30g8pkSKRngPSXbn6ognS4dV0wDdDXs8eU8nUK4AZSt4uHtqEol
        dnfGf1qkK1kEWWb6NhlYE8qkD5WYpfoJNQ00nIuRkwAtV4axSH9gFgpl74piMg4yWVvUYDX5bzqWR
        J/Tn8PGA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:51434 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nLOCs-00072b-15; Sat, 19 Feb 2022 11:47:18 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nLOCr-009eFW-BZ; Sat, 19 Feb 2022 11:47:17 +0000
In-Reply-To: <YhDYpHEBHGCVo+2z@shell.armlinux.org.uk>
References: <YhDYpHEBHGCVo+2z@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: remove pcs_poll
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nLOCr-009eFW-BZ@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Sat, 19 Feb 2022 11:47:17 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With drivers converted over to using phylink PCS, there is no need for
the struct dsa_switch member "pcs_poll" to exist anymore - there is a
flag in the struct phylink_pcs which indicates whether this PCS needs
to be polled which supersedes this.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/net/dsa.h | 5 -----
 net/dsa/port.c    | 1 -
 2 files changed, 6 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index bc6eef6af810..f13de2d8aef3 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -391,11 +391,6 @@ struct dsa_switch {
 	 */
 	u32			vlan_filtering:1;
 
-	/* MAC PCS does not provide link state change interrupt, and requires
-	 * polling. Flag passed on to PHYLINK.
-	 */
-	u32			pcs_poll:1;
-
 	/* For switches that only have the MRU configurable. To ensure the
 	 * configured MTU is not exceeded, normalization of MRU on all bridged
 	 * interfaces is needed.
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 056c6f51ac20..258782bf4271 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1251,7 +1251,6 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 
 	dp->pl_config.dev = ds->dev;
 	dp->pl_config.type = PHYLINK_DEV;
-	dp->pl_config.pcs_poll = ds->pcs_poll;
 
 	err = dsa_port_phylink_create(dp);
 	if (err)
-- 
2.30.2

