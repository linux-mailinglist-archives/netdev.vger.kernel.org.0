Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887EE3CF8AC
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 13:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237135AbhGTKep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 06:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbhGTKep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 06:34:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCE6C061574
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 04:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OjhbxZ2wMt3+iz56cTftWyFMbWmmFmJS0Pd9W0SeQMI=; b=PqeBNL6dBE1zKR6eR4kaJn57iN
        QgA3Gdk8ZFLfWh2VbAQ9SWpQfAP7rFiVdNzD4GmANmRjeKhZUKhd23w8Kz/3UgvQo0WZOwrB9gzJ4
        KqEP7Z19h+QX/0y8OGaUdzEAR2BKpV3U+nN9N7wVjGBBIJjDwyJK1HeOXIXAMYHSgDxhJcG+6bYk9
        hxTt2goLITenwiOK4QI/YQ2PBXdwRruW0zWpLjMj+6LSZnBepqzyzfQXV6oBAhlNMJnlM98bHi0sc
        fw4uINvjqqvouq3vVNMU0P11ca3isQ950D+oJTBp5B+XUkcjp0xLOAS83cokGn8FgDLtpd0DXH8wZ
        UEFqsOgw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53936 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1m5nib-0006Ey-57; Tue, 20 Jul 2021 12:15:21 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1m5nia-0003Ml-Um; Tue, 20 Jul 2021 12:15:20 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phylink: add phy change pause mode debug
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1m5nia-0003Ml-Um@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 20 Jul 2021 12:15:20 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Augment the phy link debug prints with the pause state.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index eb29ef53d971..728eab380fd3 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -942,10 +942,11 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 
 	phylink_run_resolve(pl);
 
-	phylink_dbg(pl, "phy link %s %s/%s/%s\n", up ? "up" : "down",
+	phylink_dbg(pl, "phy link %s %s/%s/%s/%s\n", up ? "up" : "down",
 		    phy_modes(phydev->interface),
 		    phy_speed_to_str(phydev->speed),
-		    phy_duplex_to_str(phydev->duplex));
+		    phy_duplex_to_str(phydev->duplex),
+		    phylink_pause_to_str(pl->phy_state.pause));
 }
 
 static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
-- 
2.20.1

