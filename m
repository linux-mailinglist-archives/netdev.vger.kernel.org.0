Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23D13CF744
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 11:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbhGTJRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 05:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbhGTJRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 05:17:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F260C061574
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 02:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=saBdbQhCv4PYpSofz2Ge/dluX7RsHKzWvdua1d2owT4=; b=0Iec1pzfrkLuWVvWvwY62DLs46
        Tzbm6eTAhYnDl45ahbjG6C33/pCtyDH4S5RhOq+1LhkWqGJ6e1NeHIJ61rxTeT13MWHhje0F84wfO
        YFEeJdtApD+gRuX4W1tEUp9dDIMapuhzLlzONeEvZkyCpSSOC1TVJGLEzvihX90vIOcVk9Ur3nHBn
        nOxrRW8BeSsKnHNgJeHvsavjiI03UltGmvekioT7JDY5lfzCloK6gqd+ZajODLJsnOo98vQXsHZbO
        rAJbnC4RmMMQL2Hxx/Xofy4fE6kwvCcKhG3h1LZ3aeqPmAzC8NwmtXbDVOPirEOtxwBy0dQJD0NUv
        G4jXbTgg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53326 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1m5mVT-00068u-Rh; Tue, 20 Jul 2021 10:57:43 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1m5mVT-00032g-Km; Tue, 20 Jul 2021 10:57:43 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: dpaa2-mac: add support for more ethtool 10G
 link modes
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1m5mVT-00032g-Km@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 20 Jul 2021 10:57:43 +0100
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
2.20.1

