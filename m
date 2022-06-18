Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F17550402
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 12:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiFRK3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 06:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbiFRK2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 06:28:47 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67301FCEA
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 03:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=s2Y0A4YihQjzM7hh87PjSf1NpHuf8S8hY9CTNF3FTvw=; b=CwmRIaUItdmdda3qvtJrCusOUU
        X8ZKzJhAxb9RRj7TPyVsubElloDKFA4VxHJe6cMKkQB14XKaNfEgBtm3j4Ele1P6fhjSQ+WfvQxjQ
        iwsNePYZhrqL7ET07JB5qx115Z0z6nVQs7LDWGbme84nz0XMxeLj9zxgbqjP4Liu6hRYcoOLqr55M
        ylmcFUx3w74668VOpxdUhoiA3kYH3uZoPFbDkxiogyCYLKdxwNKSz+ryYVf6JubUVySCcl1AzHnmu
        dQKROe/xO0PeKpIUtH/+v5+KPFtXbb2VVoEhpkLgxGGpKSgbjRfQLX+VeGQCFww3XDAcBMAN5VSzP
        Ok41VfRA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44606 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o2Vh5-0004B7-0y; Sat, 18 Jun 2022 11:28:43 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o2Vh4-0026C4-EI; Sat, 18 Jun 2022 11:28:42 +0100
In-Reply-To: <Yq2iMpbsux5wEM54@shell.armlinux.org.uk>
References: <Yq2iMpbsux5wEM54@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 3/4] net: phy: marvell: use mii_bmcr_encode_fixed()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o2Vh4-0026C4-EI@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Sat, 18 Jun 2022 11:28:42 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the newly introduced mii_bmcr_encode_fixed() to get the
BMCR value when setting loopback mode for the 88e1510.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index d777c8851ed6..a714150f5e8c 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1991,15 +1991,9 @@ static int m88e1510_loopback(struct phy_device *phydev, bool enable)
 	int err;
 
 	if (enable) {
-		u16 bmcr_ctl = 0, mscr2_ctl = 0;
+		u16 bmcr_ctl, mscr2_ctl = 0;
 
-		if (phydev->speed == SPEED_1000)
-			bmcr_ctl = BMCR_SPEED1000;
-		else if (phydev->speed == SPEED_100)
-			bmcr_ctl = BMCR_SPEED100;
-
-		if (phydev->duplex == DUPLEX_FULL)
-			bmcr_ctl |= BMCR_FULLDPLX;
+		bmcr_ctl = mii_bmcr_encode_fixed(phydev->speed, phydev->duplex);
 
 		err = phy_write(phydev, MII_BMCR, bmcr_ctl);
 		if (err < 0)
-- 
2.30.2

