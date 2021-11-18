Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF804561F2
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhKRSKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhKRSKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 13:10:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95417C061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Hp3d1Eb76xj+eIbQf7jC32aXQhU5l7M+Jkz+szJjcr0=; b=YKCCFNZiZSXMAOyek3+7fAEdCQ
        ZOiz22T5NbZKIJkB6e+CjO4InxAbsnTC4i+nUnsRb6DXp6m/ewa8A5thFYfVEcZkdDTiWicCBv/sK
        iPIa/JdQvm5q0DiQE9plevYuMcgYkW0mNkQyjN9lciKIpTjy8vuWtETfaEjcHtbc9qHH9V9V+kJQ7
        iHTH91ownHD28OezzTc6a1aKp97F9HEK6Xx8p15wWHolrJPYMdSOjStfayErj9nrStl9OrmPtgyN0
        MQqhz1tLeFj4GqKNzV+kJ6Bi/loMe8WNgjnMdk8/Wn0d1iHsq167KAmm+QH1xamHf79qUbj4XctfB
        86hA7KzQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53030 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mnloR-0003D7-9v; Thu, 18 Nov 2021 18:07:07 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mnloQ-008LYK-Rp; Thu, 18 Nov 2021 18:07:06 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phylink: add 1000base-KX to
 phylink_caps_to_linkmodes()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mnloQ-008LYK-Rp@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 18 Nov 2021 18:07:06 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1000base-KX was missed in phylink_caps_to_linkmodes(), add it. This
will be necessary to convert stmmac with xpcs to ensure we don't drop
any supported linkmodes.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f7156b6868e7..da17b874a5e7 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -197,6 +197,7 @@ static void phylink_caps_to_linkmodes(unsigned long *linkmodes,
 
 	if (caps & MAC_1000FD) {
 		__set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, linkmodes);
+		__set_bit(ETHTOOL_LINK_MODE_1000baseKX_Full_BIT, linkmodes);
 		__set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT, linkmodes);
 		__set_bit(ETHTOOL_LINK_MODE_1000baseT1_Full_BIT, linkmodes);
 	}
-- 
2.30.2

