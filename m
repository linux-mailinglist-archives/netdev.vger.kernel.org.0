Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B064A450AE1
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236793AbhKORP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236835AbhKOROS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:14:18 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD42EC06121E;
        Mon, 15 Nov 2021 09:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZWqWmglAhpTjNuY3OWxZrnmPe0UYmnc6fFLUg64wrOU=; b=pEL6C7X4pF64tei5APlt7PXwkJ
        L/JC9XQ0eAEBHjYvcS/grGeDuM3zOHbUvGfpb041uY+cchuMmBl0Bx8TuPDbx8oLL89G/Wf2QeLpX
        CK1/9tvLmFAMezJjPZZd+p6tGD9mDwhxPTFcf/nIbkEUck2fx/FS9rL2UwFVC2TDIEs+emDZwpeAu
        SYbjoKWUfRnVGzR6N4Xw9iMBC7W+TeUowgZ8Xzqdn9xbBMq7kgP19/ccRUwKWUoGzwjtTTpatXYgh
        9S0nKjboKU0qRuqiRr02krXz697KdGdbX1zcN3a/Z5TclUrmzwdOpjHkXRmF2ngq5Puj5rk5F+ZR6
        bFEbSwvQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37376 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmfVl-0007th-G5; Mon, 15 Nov 2021 17:11:17 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmfVl-0075nP-14; Mon, 15 Nov 2021 17:11:17 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH net-next] net: document SMII and correct phylink's new
 validation mechanism
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmfVl-0075nP-14@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 15 Nov 2021 17:11:17 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SMII has not been documented in the kernel, but information on this PHY
interface mode has been recently found. Document it, and correct the
recently introduced phylink handling for this interface mode.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 Documentation/networking/phy.rst | 5 +++++
 drivers/net/phy/phylink.c        | 2 +-
 include/linux/phy.h              | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/phy.rst
index 571ba08386e7..d43da709bf40 100644
--- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -237,6 +237,11 @@ negotiation results.
 
 Some of the interface modes are described below:
 
+``PHY_INTERFACE_MODE_SMII``
+    This is serial MII, clocked at 125MHz, supporting 100M and 10M speeds.
+    Some details can be found in
+    https://opencores.org/ocsvn/smii/smii/trunk/doc/SMII.pdf
+
 ``PHY_INTERFACE_MODE_1000BASEX``
     This defines the 1000BASE-X single-lane serdes link as defined by the
     802.3 standard section 36.  The link operates at a fixed bit rate of
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 33462fdc7add..f7156b6868e7 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -336,6 +336,7 @@ void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 
 	case PHY_INTERFACE_MODE_REVRMII:
 	case PHY_INTERFACE_MODE_RMII:
+	case PHY_INTERFACE_MODE_SMII:
 	case PHY_INTERFACE_MODE_REVMII:
 	case PHY_INTERFACE_MODE_MII:
 		caps |= MAC_10HD | MAC_10FD;
@@ -385,7 +386,6 @@ void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 
 	case PHY_INTERFACE_MODE_NA:
 	case PHY_INTERFACE_MODE_MAX:
-	case PHY_INTERFACE_MODE_SMII:
 		break;
 	}
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 96e43fbb2dd8..1e57cdd95da3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -99,7 +99,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_RGMII_RXID: RGMII with Internal RX delay
  * @PHY_INTERFACE_MODE_RGMII_TXID: RGMII with Internal RX delay
  * @PHY_INTERFACE_MODE_RTBI: Reduced TBI
- * @PHY_INTERFACE_MODE_SMII: ??? MII
+ * @PHY_INTERFACE_MODE_SMII: Serial MII
  * @PHY_INTERFACE_MODE_XGMII: 10 gigabit media-independent interface
  * @PHY_INTERFACE_MODE_XLGMII:40 gigabit media-independent interface
  * @PHY_INTERFACE_MODE_MOCA: Multimedia over Coax
-- 
2.30.2

