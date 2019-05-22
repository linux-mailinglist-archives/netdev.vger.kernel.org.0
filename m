Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9924C26FBF
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731509AbfEVT6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:58:43 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46496 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729564AbfEVT6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:58:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id r7so3626871wrr.13;
        Wed, 22 May 2019 12:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g1DmrJlOLku8E3I8oZwgTYcADUuj7Aq6P5SSPkrvsoo=;
        b=KahAeuoY6RPMjOeOSjxdHwH78OBfIeVDAuHsN1cyR/4SrtUU7pR9GOGCKHUAoGWJCI
         qgMBveRGFAej90StDrhHQzQKYdS15NV50m8hDD6PzId0JjHxafeNAdPq46nK+eHJiTR/
         pIhD7ke+VVHOOpQiVn4AEmSOvwMEApWpN36N4QJWQF/05xAvTD2YxqOviIRQxKTJJk6S
         /rrJdEPhCY3QUyDlWU6XSBl936wX7gUOZvyAQCjkeu5X7tUbSoPJjpTh4HfxjRr+iNcu
         w/Sfa4ZDAgqNlVnE2NzijbwMmXtd1k3W0R6ZHk14Xr/TaiYDNUQ4wX8a1i+wKjKCvvZt
         O2vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g1DmrJlOLku8E3I8oZwgTYcADUuj7Aq6P5SSPkrvsoo=;
        b=PIs9DDAVKLtH0O68FygrSSPLefyGHi0iGXmnvnmmPcljX/nuwCC+HazJQMuGQYxaEr
         4BeHGSHpy5VZW/YBurE7M+VMJq/9KFgVJAHcFb+HfuPfAMD+iDZKm/7+oWuhAxBL+1fY
         dTvH5JOscHzKyyouTBlUH+7xYYd722gzG4AUn4u347NwBKtUyEdlLBfkR7CTPW4qu5BZ
         T8m+8rpDqS6zuI9TN0Ld1RlXg98Zp+wjJZFoPpuMjiiRN3wsa84J+e+pyL7eTh3WqN3e
         IZcCXiqq5N9Q7kias8EioR4FkOJFkceqfbVmg0ILgu3J06DD4Ffn07k+DI3v+am+4cFg
         IsgQ==
X-Gm-Message-State: APjAAAXggKQ5adRcya5OjJhIl8KdCMOU+txUBBCjB9TkOhZgo1BxQfHi
        dN1L3jmZivR8AVW5VSsnCwFqi6hM
X-Google-Smtp-Source: APXvYqzeJaVgpDVaeK6cbzvhz3KyzXjThTUPOYvRGfCdDwJqXeHidd/sGH+/GZkbjODnwb9Mf0mVkA==
X-Received: by 2002:adf:8385:: with SMTP id 5mr41014547wre.194.1558555119239;
        Wed, 22 May 2019 12:58:39 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:3029:8954:1431:dc1e? (p200300EA8BD45700302989541431DC1E.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:3029:8954:1431:dc1e])
        by smtp.googlemail.com with ESMTPSA id j82sm9102066wmj.40.2019.05.22.12.58.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 12:58:38 -0700 (PDT)
Subject: [PATCH net-next 2/2] net: phy: aquantia: add USXGMII support
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <110a1e45-56a7-a646-7b63-f39fe3083c28@gmail.com>
Message-ID: <2c68bdb1-9b53-ce0b-74d3-c7ea2d9e7ac0@gmail.com>
Date:   Wed, 22 May 2019 21:58:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <110a1e45-56a7-a646-7b63-f39fe3083c28@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far we didn't support mode USXGMII, and in order to not break the
two Freescale boards mode XGMII was accepted for the AQR107 family
even though it doesn't support XGMII. Add USXGMII support to the
Aquantia PHY driver and change the phy connection type for the two
boards.

As an additional note: Even though the handle is named aqr106
there seem to be LS1046A boards with an AQR107.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts | 2 +-
 drivers/net/phy/aquantia_main.c                   | 6 +++++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
index 4223a2352..c2ce1a611 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
@@ -139,7 +139,7 @@
 
 	ethernet@f0000 { /* 10GEC1 */
 		phy-handle = <&aqr105_phy>;
-		phy-connection-type = "xgmii";
+		phy-connection-type = "usxgmii";
 	};
 
 	mdio@fc000 {
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
index 6a6514d0e..f927a8a25 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
@@ -147,7 +147,7 @@
 
 	ethernet@f0000 { /* 10GEC1 */
 		phy-handle = <&aqr106_phy>;
-		phy-connection-type = "xgmii";
+		phy-connection-type = "usxgmii";
 	};
 
 	ethernet@f2000 { /* 10GEC2 */
diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 0fedd28fd..3f24c42a8 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -27,6 +27,7 @@
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_MASK	GENMASK(7, 3)
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_KR	0
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_XFI	2
+#define MDIO_PHYXS_VEND_IF_STATUS_TYPE_USXGMII	3
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_SGMII	6
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_OCSGMII	10
 
@@ -360,6 +361,9 @@ static int aqr107_read_status(struct phy_device *phydev)
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_XFI:
 		phydev->interface = PHY_INTERFACE_MODE_10GKR;
 		break;
+	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_USXGMII:
+		phydev->interface = PHY_INTERFACE_MODE_USXGMII;
+		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_SGMII:
 		phydev->interface = PHY_INTERFACE_MODE_SGMII;
 		break;
@@ -487,7 +491,7 @@ static int aqr107_config_init(struct phy_device *phydev)
 	/* Check that the PHY interface type is compatible */
 	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
-	    phydev->interface != PHY_INTERFACE_MODE_XGMII &&
+	    phydev->interface != PHY_INTERFACE_MODE_USXGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_10GKR)
 		return -ENODEV;
 
-- 
2.21.0


