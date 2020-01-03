Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7346712FE10
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgACUn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:43:27 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46250 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgACUn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:43:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=o2EnKkdbDiIL6+imtSdoloS2mmzxz3oqnytOT6OFrpc=; b=Gn0nEm/i7da1YfwomgQ3GKltN4
        M8LpunRhO8mtkp6gX3ZQVL2WXnlSWcToW/fvhUYa8/mDXx3SMetlKs48i3w5NOT0RhNKfe7qznxS8
        H3scTAmONOlvVd0aH0oy10TECvwM7Exxq0ZEjuuiMk98bC72ORWULy8wRaKtrIN8lxA4oifA8P++D
        ECQDcMmzuCXyaMqdu8WLRiY7qgvB0eTedF9uYMPTpC8rXcmzo+Dhrg3MSIfxzWu3f8yc+U2QYfrBb
        3DTNEDcT1thP1KWXKeFMvmR/zQIHdj3zlwiJ8/XZfnxHbmg0lhED1/vmxhD5rk5fSBe7VgRzHQ5WL
        LW2t5M2A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:46978 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1inTmw-0004CL-M4; Fri, 03 Jan 2020 20:43:18 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1inTmv-0001T6-Lv; Fri, 03 Jan 2020 20:43:17 +0000
In-Reply-To: <20200103204241.GB18808@shell.armlinux.org.uk>
References: <20200103204241.GB18808@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/2] net: phy: add PHY_INTERFACE_MODE_10GBASER
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1inTmv-0001T6-Lv@rmk-PC.armlinux.org.uk>
Date:   Fri, 03 Jan 2020 20:43:17 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent discussion has revealed that the use of PHY_INTERFACE_MODE_10GKR
is incorrect. Add a 10GBASE-R definition, document both the -R and -KR
versions, and the fact that 10GKR was used incorrectly.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 Documentation/networking/phy.rst | 18 ++++++++++++++++++
 include/linux/phy.h              | 12 ++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/phy.rst
index e0a7c7af6525..1e4735cc0553 100644
--- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -267,6 +267,24 @@ negotiation results.
     duplex, pause or other settings.  This is dependent on the MAC and/or
     PHY behaviour.
 
+``PHY_INTERFACE_MODE_10GBASER``
+    This is the IEEE 802.3 Clause 49 defined 10GBASE-R protocol used with
+    various different mediums. Please refer to the IEEE standard for a
+    definition of this.
+
+    Note: 10GBASE-R is just one protocol that can be used with XFI and SFI.
+    XFI and SFI permit multiple protocols over a single SERDES lane, and
+    also defines the electrical characteristics of the signals with a host
+    compliance board plugged into the host XFP/SFP connector. Therefore,
+    XFI and SFI are not PHY interface types in their own right.
+
+``PHY_INTERFACE_MODE_10GKR``
+    This is the IEEE 802.3 Clause 49 defined 10GBASE-R with Clause 73
+    autonegotiation. Please refer to the IEEE standard for further
+    information.
+
+    Note: due to legacy usage, some 10GBASE-R usage incorrectly makes
+    use of this definition.
 
 Pause frames / flow control
 ===========================
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 30e599c454db..5932bb8e9c35 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -100,9 +100,11 @@ typedef enum {
 	PHY_INTERFACE_MODE_2500BASEX,
 	PHY_INTERFACE_MODE_RXAUI,
 	PHY_INTERFACE_MODE_XAUI,
-	/* 10GBASE-KR, XFI, SFI - single lane 10G Serdes */
-	PHY_INTERFACE_MODE_10GKR,
+	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
+	PHY_INTERFACE_MODE_10GBASER,
 	PHY_INTERFACE_MODE_USXGMII,
+	/* 10GBASE-KR - with Clause 73 AN */
+	PHY_INTERFACE_MODE_10GKR,
 	PHY_INTERFACE_MODE_MAX,
 } phy_interface_t;
 
@@ -176,10 +178,12 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "rxaui";
 	case PHY_INTERFACE_MODE_XAUI:
 		return "xaui";
-	case PHY_INTERFACE_MODE_10GKR:
-		return "10gbase-kr";
+	case PHY_INTERFACE_MODE_10GBASER:
+		return "10gbase-r";
 	case PHY_INTERFACE_MODE_USXGMII:
 		return "usxgmii";
+	case PHY_INTERFACE_MODE_10GKR:
+		return "10gbase-kr";
 	default:
 		return "unknown";
 	}
-- 
2.20.1

