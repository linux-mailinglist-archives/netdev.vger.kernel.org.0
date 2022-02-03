Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB544A86EB
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 15:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351390AbiBCOsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 09:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237254AbiBCOse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 09:48:34 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14685C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 06:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WgK69KSnjGRwhvkFJlQk/Vo1p3pd4aMi2MXWda7+Y9s=; b=KUqnKuEZ6IEag8JUhObUe0+wFV
        rQ+kk3HXeaCBymz+gD3npoIBu7kscjJMoZtC+alzyYSHxaTgIjHfzCNYq54FT5Wnli7RCzo9oceP1
        ojtJ1M8TmcBWe/rp0+YTAUeCGNoK85jGhMpVhdDOeJqhrePaOQoMo48o6fJdW0bR4VDj5HyPk6tcV
        0rCtP43F6sZkZz56tjF+aU3KGgHlqqXVfPu9xuar+vWrDl6C7au1SE/4UZGbiWZPyB1xKnYGjZTe6
        kJZ673Fvg1ZHlx3yE/iS7An9/vLy11YvQxq5Rs6w/K3G4RfVpp0+Jw0NSCglGe5kFVlP4glTe3SOf
        LCzqcVCA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54214 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nFdPT-0002l3-B6; Thu, 03 Feb 2022 14:48:31 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nFdPS-006WhC-Or; Thu, 03 Feb 2022 14:48:30 +0000
In-Reply-To: <YfvrIf/FDddglaKE@shell.armlinux.org.uk>
References: <YfvrIf/FDddglaKE@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 3/5] net: dsa: b53: drop use of
 phylink_helper_basex_speed()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nFdPS-006WhC-Or@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 03 Feb 2022 14:48:30 +0000
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

