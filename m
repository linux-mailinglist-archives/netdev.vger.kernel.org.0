Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E721540F970
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbhIQNmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbhIQNmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 09:42:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02AFAC061574
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 06:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1o6zjNUhu+7zs3OQ4aurJe+o7cpg4pA4gudaPng/NEQ=; b=zVBaT3nxpLNGRrVyAF1GnYsOIt
        dNqTHPoKjBpvmafiuiyQ2be0adAUcGA/zMm5XKpIuzrUahoyaJOa27SS2LGIRTReJTAhyiHk0+4x3
        jG4FUpTkHof6qjKhPTYv2ovmEj5UUOylvtXQa5rEe2tFKcUOgJbn+xU4CjFNXX9/g7bNQD2O0NFkM
        wq19/N3evEsL6+sCXp+Sigqls4Gv9Kkv2/hE4f9P579XjnE0uh2mhFbq2XgdQUWXDvV9eYaxF7Bck
        jVD9oQcxmKU9+y84/iqflEiPiCPzJoPd69ci3CaaXIdARB1prrRUBWr1RXlGbh2hWyvgK4dgkgqy1
        o0UeAHyg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:48996 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mRE7D-0007l8-JD; Fri, 17 Sep 2021 14:41:18 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mRE7B-001xlF-UX; Fri, 17 Sep 2021 14:41:17 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH RESEND net-next] net: dpaa2-mac: add support for more ethtool 10G
 link modes
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mRE7B-001xlF-UX@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 17 Sep 2021 14:41:17 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phylink documentation says:
  Note that the PHY may be able to transform from one connection
  technology to another, so, eg, don't clear 1000BaseX just
  because the MAC is unable to BaseX mode. This is more about
  clearing unsupported speeds and duplex settings. The port modes
  should not be cleared; phylink_set_port_modes() will help with this.

So add the missing 10G modes.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Marek Behún <kabel@kernel.org>
Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
This was supposed to be merged for the previous merge window, and
further patches applied thereafter, but someone decided to mark it in
patchwork as needing further work presumably while the discussion was
still on-going. netdev patchwork really needs some way to inform
authors that the fate of their patch has been decided, other than just
the "applied" messages.

 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index ae6d382d8735..543c1f202420 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -140,6 +140,11 @@ static void dpaa2_mac_validate(struct phylink_config *config,
 	case PHY_INTERFACE_MODE_10GBASER:
 	case PHY_INTERFACE_MODE_USXGMII:
 		phylink_set(mask, 10000baseT_Full);
+		phylink_set(mask, 10000baseCR_Full);
+		phylink_set(mask, 10000baseSR_Full);
+		phylink_set(mask, 10000baseLR_Full);
+		phylink_set(mask, 10000baseLRM_Full);
+		phylink_set(mask, 10000baseER_Full);
 		if (state->interface == PHY_INTERFACE_MODE_10GBASER)
 			break;
 		phylink_set(mask, 5000baseT_Full);
-- 
2.30.2

