Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5424209B4
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 13:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbhJDLFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 07:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbhJDLFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 07:05:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6FCC061746
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 04:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RB9wDNb8lcxQSe3VmHtj7UcFMN5ii7UPxbkP97QY1PE=; b=fyQfmI/c6FiGFsjBDxrCwieR1F
        PJEmXuspM6g5BzRDeIOBpymmsQLzlKJhZAWzQnvlZXxuk7MTCn00POvxKH0wb8NnyAk7vuO8BC9EW
        vP2ywqVhVS/f8QMuLdrjrpYeBdEjdAF+qRwA0sVEKevPQYmFy8Beh4GjbpMibgrBvACPkCSbabeQq
        HfsvhFUNJOZjAPI0yaZyg/Wej6gRNO/4cCGj0DfludLb5nri3eHh6DmfZq5D+Jdhn4KvxXCwxVuc1
        rsEDXQwYlCGX4oL/F177umDtl3HEutmwXx1TCPQiK84c7aGtJ5ziIfLJJTmbaJhP0VJvOBGvgn9wW
        Xrj3dTog==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42618 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mXLks-0007VS-3H; Mon, 04 Oct 2021 12:03:34 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mXLkr-000pdB-MI; Mon, 04 Oct 2021 12:03:33 +0100
In-Reply-To: <YVrfTBYg7cHLzNXM@shell.armlinux.org.uk>
References: <YVrfTBYg7cHLzNXM@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>
Subject: [PATCH net-next 2/2] net: ethernet: use phylink_set_10g_modes()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mXLkr-000pdB-MI@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 04 Oct 2021 12:03:33 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update three drivers to use the new phylink_set_10g_modes() helper:
Cadence macb, Freescale DPAA2 and Marvell PP2.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/cadence/macb_main.c         | 7 +------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 7 +------
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c  | 7 +------
 3 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index e2730b3e1a57..b58297aeb793 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -547,13 +547,8 @@ static void macb_validate(struct phylink_config *config,
 	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
 	    (state->interface == PHY_INTERFACE_MODE_NA ||
 	     state->interface == PHY_INTERFACE_MODE_10GBASER)) {
-		phylink_set(mask, 10000baseCR_Full);
-		phylink_set(mask, 10000baseER_Full);
+		phylink_set_10g_modes(mask);
 		phylink_set(mask, 10000baseKR_Full);
-		phylink_set(mask, 10000baseLR_Full);
-		phylink_set(mask, 10000baseLRM_Full);
-		phylink_set(mask, 10000baseSR_Full);
-		phylink_set(mask, 10000baseT_Full);
 		if (state->interface != PHY_INTERFACE_MODE_NA)
 			goto out;
 	}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 543c1f202420..ef8f0a055024 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -139,12 +139,7 @@ static void dpaa2_mac_validate(struct phylink_config *config,
 	case PHY_INTERFACE_MODE_NA:
 	case PHY_INTERFACE_MODE_10GBASER:
 	case PHY_INTERFACE_MODE_USXGMII:
-		phylink_set(mask, 10000baseT_Full);
-		phylink_set(mask, 10000baseCR_Full);
-		phylink_set(mask, 10000baseSR_Full);
-		phylink_set(mask, 10000baseLR_Full);
-		phylink_set(mask, 10000baseLRM_Full);
-		phylink_set(mask, 10000baseER_Full);
+		phylink_set_10g_modes(mask);
 		if (state->interface == PHY_INTERFACE_MODE_10GBASER)
 			break;
 		phylink_set(mask, 5000baseT_Full);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d5c92e43f89e..34b997aa6c66 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6301,12 +6301,7 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 	case PHY_INTERFACE_MODE_XAUI:
 	case PHY_INTERFACE_MODE_NA:
 		if (mvpp2_port_supports_xlg(port)) {
-			phylink_set(mask, 10000baseT_Full);
-			phylink_set(mask, 10000baseCR_Full);
-			phylink_set(mask, 10000baseSR_Full);
-			phylink_set(mask, 10000baseLR_Full);
-			phylink_set(mask, 10000baseLRM_Full);
-			phylink_set(mask, 10000baseER_Full);
+			phylink_set_10g_modes(mask);
 			phylink_set(mask, 10000baseKR_Full);
 		}
 		if (state->interface != PHY_INTERFACE_MODE_NA)
-- 
2.30.2

