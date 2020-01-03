Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D6412F7D5
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 12:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgACLwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 06:52:32 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40028 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbgACLwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 06:52:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PhGka1SHr5ATbkwxsjCrY/MmFiWjNb6F53a2r/6YVz8=; b=FJF/nsMwgrRIRkbEgS99N80qKP
        GjtSjmWQW7rmdKknb8Slsqn3VRkUdLaRlbsDfpAPTkzkdy7eeEphxyF1VGTHL0z2iWOA2HW7IvN4V
        bQZ7cy2sW3vc5DvJ7SMrnUsCdtGnidLrYKU8b4vjuNZshtJyBuZm0cUqOnIQ+ZJ9lt1cFZQ3An5oi
        wc0zeFREveso5odulaLQ4fXr0Rcxt49vaAbMPhCVfHone6pizKZyWZf56aBYicVCKIT8cWOEkz9Ky
        LTdK6+CK0Gxxi/mhanJKOZW/fBmBpkn0f8ZyU8xuzKkK1ZECTpyv6Oves/ah7b1q2S4XKz7LTxwET
        u/9pj95Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:44896 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1inLV9-0001s6-Kn; Fri, 03 Jan 2020 11:52:23 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1inLV8-0006gD-P7; Fri, 03 Jan 2020 11:52:22 +0000
In-Reply-To: <20200103115125.GC25745@shell.armlinux.org.uk>
References: <20200103115125.GC25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: phy: add PHY_INTERFACE_MODE_10GBASER
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1inLV8-0006gD-P7@rmk-PC.armlinux.org.uk>
Date:   Fri, 03 Jan 2020 11:52:22 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent discussion has revealed that the use of PHY_INTERFACE_MODE_10GKR
is incorrect. Add a 10GBASE-R definition, document both the -R and -KR
versions, and the fact that 10GKR was used incorrectly.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 Documentation/networking/phy.rst | 18 ++++++++++++++++++
 include/linux/phy.h              | 12 ++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/phy.rst
index e0a7c7af6525..6af94dadf132 100644
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
+    also define the electrical characteristics of the signals with a host
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

