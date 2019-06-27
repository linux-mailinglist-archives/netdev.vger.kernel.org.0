Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E1E585C2
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfF0Pcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:32:35 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:41523 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfF0Pcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:32:33 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 9CB531BF216;
        Thu, 27 Jun 2019 15:32:30 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v4 12/13] ARM: dts: sunxi: Switch to the generic PHY properties
Date:   Thu, 27 Jun 2019 17:31:54 +0200
Message-Id: <ac9cd760ebc21be94078bc6d9aa8974bdd4cffde.1561649505.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.e80da8845680a45c2e07d5f17280fdba84555b8a.1561649505.git-series.maxime.ripard@bootlin.com>
References: <cover.e80da8845680a45c2e07d5f17280fdba84555b8a.1561649505.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DWMAC specific properties to manage the PHY have been superseeded by
the generic PHY properties. Let's move to it.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 arch/arm/boot/dts/sun6i-a31-hummingbird.dts       |  6 +++---
 arch/arm/boot/dts/sun6i-a31s-sinovoip-bpi-m2.dts  |  6 +++---
 arch/arm/boot/dts/sun7i-a20-hummingbird.dts       |  9 ++++-----
 arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts |  8 ++++----
 4 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/arm/boot/dts/sun6i-a31-hummingbird.dts b/arch/arm/boot/dts/sun6i-a31-hummingbird.dts
index 09832b4e8fc8..2652d737fe7c 100644
--- a/arch/arm/boot/dts/sun6i-a31-hummingbird.dts
+++ b/arch/arm/boot/dts/sun6i-a31-hummingbird.dts
@@ -155,13 +155,13 @@
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy = <&phy1>;
 	phy-mode = "rgmii";
-	snps,reset-gpio = <&pio 0 21 GPIO_ACTIVE_HIGH>;
-	snps,reset-active-low;
-	snps,reset-delays-us = <0 10000 30000>;
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
 		reg = <1>;
+		reset-gpios = <&pio 0 21 GPIO_ACTIVE_LOW>;
+		reset-assert-us = <10000>;
+		reset-deassert-us = <30000>;
 	};
 };
 
diff --git a/arch/arm/boot/dts/sun6i-a31s-sinovoip-bpi-m2.dts b/arch/arm/boot/dts/sun6i-a31s-sinovoip-bpi-m2.dts
index 8e724c52feff..7899712400b2 100644
--- a/arch/arm/boot/dts/sun6i-a31s-sinovoip-bpi-m2.dts
+++ b/arch/arm/boot/dts/sun6i-a31s-sinovoip-bpi-m2.dts
@@ -95,13 +95,13 @@
 	phy = <&phy1>;
 	phy-mode = "rgmii";
 	phy-supply = <&reg_dldo1>;
-	snps,reset-gpio = <&pio 0 21 GPIO_ACTIVE_HIGH>; /* PA21 */
-	snps,reset-active-low;
-	snps,reset-delays-us = <0 10000 30000>;
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
 		reg = <1>;
+		reset-gpios = <&pio 0 21 GPIO_ACTIVE_LOW>; /* PA21 */
+		reset-assert-us = <10000>;
+		reset-deassert-us = <30000>;
 	};
 };
 
diff --git a/arch/arm/boot/dts/sun7i-a20-hummingbird.dts b/arch/arm/boot/dts/sun7i-a20-hummingbird.dts
index fd0153f65685..b01d91d025ec 100644
--- a/arch/arm/boot/dts/sun7i-a20-hummingbird.dts
+++ b/arch/arm/boot/dts/sun7i-a20-hummingbird.dts
@@ -103,15 +103,14 @@
 	phy = <&phy1>;
 	phy-mode = "rgmii";
 	phy-supply = <&reg_gmac_vdd>;
-	/* phy reset config */
-	snps,reset-gpio = <&pio 0 17 GPIO_ACTIVE_HIGH>; /* PA17 */
-	snps,reset-active-low;
-	/* wait 1s after reset, otherwise fail to read phy id */
-	snps,reset-delays-us = <0 10000 1000000>;
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
 		reg = <1>;
+		reset-gpios = <&pio 0 17 GPIO_ACTIVE_LOW>; /* PA17 */
+		reset-assert-us = <10000>;
+		/* wait 1s after reset, otherwise fail to read phy id */
+		reset-deassert-us = <1000000>;
 	};
 };
 
diff --git a/arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts b/arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts
index c34a83f666c7..ca12cee27072 100644
--- a/arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts
+++ b/arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts
@@ -108,14 +108,14 @@
 	phy = <&phy3>;
 	phy-mode = "rgmii";
 	phy-supply = <&reg_vcc3v3>;
-
-	snps,reset-gpio = <&pio 0 17 GPIO_ACTIVE_HIGH>;
-	snps,reset-active-low;
-	snps,reset-delays-us = <0 10000 1000000>;
 	status = "okay";
 
 	phy3: ethernet-phy@3 {
 		reg = <3>;
+		reset-gpios = <&pio 0 17 GPIO_ACTIVE_LOW>; /* PA17 */
+		reset-assert-us = <10000>;
+		/* wait 1s after reset, otherwise fail to read phy id */
+		reset-deassert-us = <1000000>;
 	};
 };
 
-- 
git-series 0.9.1
