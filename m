Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D2E4A86E7
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 15:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244797AbiBCOs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 09:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbiBCOsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 09:48:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8348C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 06:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IEKgNN7+x8FEdBHEHkuvMDdG6N4ZgFGww6hZX+ce4fg=; b=JlMbD0odGgMgIPVxl/KLfTNe1k
        GG5v3XEadG5hIWm65RlYYq6bUxT2nH4PhVlYll4DdJWVyc5GcYCxWTV/QeoZb9CJd6TsclCF5BraC
        pBPEtdYSHNVUaECmxz2UNhvPrCpIQVtcg/uXF20g/mdvQi+o7VNby3YX2G9enPdIaBtG0QpisG6UD
        cH85MouyyeHA/2h3xxZBGLl7NlrErLKh0zjipi6IEg5imMCP2F97Ox/HDdA9bU3cp9mxc6LFLEmIL
        tT0Qc0GOv+M6X7KUCQ33RhF2E8lK8zoJJd6jGSF7XZL0Rr6PYRWHrCHnOJLSoIuHJzwL9IVYKya+j
        XB2SjeEQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54208 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nFdPJ-0002ki-4H; Thu, 03 Feb 2022 14:48:21 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nFdPI-006Wh0-HW; Thu, 03 Feb 2022 14:48:20 +0000
In-Reply-To: <YfvrIf/FDddglaKE@shell.armlinux.org.uk>
References: <YfvrIf/FDddglaKE@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 1/5] net: dsa: b53: clean up if() condition to be
 more readable
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nFdPI-006Wh0-HW@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 03 Feb 2022 14:48:20 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've stared at this if() statement for a while trying to work out if
it really does correspond with the comment above, and it does seem to.
However, let's make it more readable and phrase it in the same way as
the comment.

Also add a FIXME into the comment - we appear to deny Gigabit modes for
802.3z interface modes, but 802.3z interface modes only operate at
gigabit and above.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/b53/b53_common.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index a3b98992f180..7d62b0aeaae9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1327,11 +1327,14 @@ void b53_phylink_validate(struct dsa_switch *ds, int port,
 
 	/* With the exclusion of 5325/5365, MII, Reverse MII and 802.3z, we
 	 * support Gigabit, including Half duplex.
+	 *
+	 * FIXME: this is weird - 802.3z is always Gigabit, but we exclude
+	 * it here. Why? This makes no sense.
 	 */
-	if (state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_REVMII &&
-	    !phy_interface_mode_is_8023z(state->interface) &&
-	    !(is5325(dev) || is5365(dev))) {
+	if (!(state->interface == PHY_INTERFACE_MODE_MII ||
+	      state->interface == PHY_INTERFACE_MODE_REVMII ||
+	      phy_interface_mode_is_8023z(state->interface) ||
+	      is5325(dev) || is5365(dev))) {
 		phylink_set(mask, 1000baseT_Full);
 		phylink_set(mask, 1000baseT_Half);
 	}
-- 
2.30.2

