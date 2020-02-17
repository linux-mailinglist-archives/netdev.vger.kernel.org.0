Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9817F1616EE
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 17:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbgBQQDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 11:03:18 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38554 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgBQQDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 11:03:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rbW9+vAfXrPZvdejZEfPXADprAL9Rw8CTJhNk9FA5Ks=; b=nZEnzdjl5xpHu5/rfdNxQobhaD
        9mVvzCgFiIcxP0Ap1OqP0MGseHcwFczMdzTftboUhNSjM4g2kiSbV1NuV/8Wm8+5f9W+0AmO/Mwxn
        5tbJ7E8zaA+Riu9OvM/VJ3WyxWv6Bp9567F7TAg5hwHpi8mbvQoDIFM80W4SylNq/W8+bTEbXS8Pw
        kFggSkwlNgxoHWU3J9QO9/K+2/XS7mAA5p37be7zxKa0zxsK8oNO9/dfttren2vhyTR8E11KdyhKr
        D9l6ETtndLj/4STRMtb0CQDPwsz1IEX+SbX1ldoGZ77bOoAJuyxM6ATJivAciQIrfIweHsV5fuoqR
        M8tr/twg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:40700 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j3irY-0001km-2K; Mon, 17 Feb 2020 16:03:12 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j3irX-0006JO-FW; Mon, 17 Feb 2020 16:03:11 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: phy: allow bcm84881 to be a module
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j3irX-0006JO-FW@rmk-PC.armlinux.org.uk>
Date:   Mon, 17 Feb 2020 16:03:11 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the phylib module loading issue has been resolved, we can
allow this PHY driver to be built as a module.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---

This is a result of:

7d49a32a66d2 ("net: phy: ensure that phy IDs are correctly typed")
d2ed49cf6c13 ("mod_devicetable: fix PHY module format")

merged during the last cycle. Given that the bcm84881 driver is so
new, I'm not sure whether it's really important enough for -rc and
backporting to 5.5-stable or just queue it in net-next. My feeling
is that it's fairly low priority, and not important enough to
justify backporting to 5.5-stable unless someone really wants this
PHY driver to be modular. Therefore, I'm opting for net-next for
this posting.

 drivers/net/phy/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 9dabe03a668c..edb1cb8a228e 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -326,8 +326,8 @@ config BROADCOM_PHY
 	  BCM5481, BCM54810 and BCM5482 PHYs.
 
 config BCM84881_PHY
-	bool "Broadcom BCM84881 PHY"
-	depends on PHYLIB=y
+	tristate "Broadcom BCM84881 PHY"
+	depends on PHYLIB
 	---help---
 	  Support the Broadcom BCM84881 PHY.
 
-- 
2.20.1

