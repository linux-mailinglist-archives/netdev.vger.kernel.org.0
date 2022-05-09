Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6395051F63C
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbiEIH6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236563AbiEIHxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:53:06 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8063201B3
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 00:49:12 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id p189so7861669wmp.3
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 00:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zTaVkhFaCPYCczWcQ3UIpvV8zmzZn3hB54zbZQSdmG4=;
        b=1DemtbvsRKtrhV3ePwedVSa4B6ZoyqXgD8J6jeaNE+U7pHBpMoZkYswymkl3R+QtPC
         v6781QcDXuR2Vd6m5X8WXhiQ8kFXOL6HVYCt9XlOA0oYxEqbhwT4ErSXlX0NeIT/Lrif
         MTfBZCPJVeT+Of6w2Km68jO2N1GGLmZgsKYxMXBrJkhwoPEYRemJnoWp8AlyjXhpp1yS
         O1S/ckT6MCH73GhyuQR/uo4yYgg0FLubgZbmIEHlauLRA/LYykhTpj9GY03VVw9C/Mjk
         2bM/NsNHjg6saLcO+OGmRXztU7DtK6IVRoHzvexneF8yDdKSqdinD2QoEfpPmyhCfB2u
         s1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zTaVkhFaCPYCczWcQ3UIpvV8zmzZn3hB54zbZQSdmG4=;
        b=nxGbObg8LPjil5TyIbKMQSI7w8hPk/hjBTgHCKX4scEN902EJ7duhLgubayWqbdelB
         d62WXYVKOfLvpbfOpDB0TmJwadnwrd65p/tGe8kaSPCTnFyInDsGWdZtFCkpM2yIm1Lm
         1XQ4Poy1Kc4r34SFZEBeXdGsx5bcSwQQFoBp/Zs5gWwGaVLei3UmA1Y128LEGtClvqxj
         5BDbn+hEdF+zBsz1KPPk/FmD3xVpUyCRVjahUIwFyksteCQhGrT+4Y7rTDR1dkIYp7ou
         DKT/2fEgM4+K0iQ79NJrEvJidCyTvbfbX8lkujVUity/6pEGeAdQzoO48CvnZLTOMjae
         AJeQ==
X-Gm-Message-State: AOAM530wY8++N5ZhxRB/lfNeeBbIKMkLa0OTGHFX+hPpLTowdoU9e4F1
        LmAOCqFsLRLIGGYiOQCSnVDueQ==
X-Google-Smtp-Source: ABdhPJxQckEVugqpsah7Dbi8JOUeJ6p80TG34ZBuqw6yeCfFRMA5KFoFE/sun4z2Jhb4d+BrpE4+nw==
X-Received: by 2002:a05:600c:3490:b0:394:5616:ac78 with SMTP id a16-20020a05600c349000b003945616ac78mr14892739wmq.80.1652082551264;
        Mon, 09 May 2022 00:49:11 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id bw22-20020a0560001f9600b0020c5253d8d8sm11784768wrb.36.2022.05.09.00.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 00:49:10 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     alexandre.torgue@foss.st.com, andrew@lunn.ch, broonie@kernel.org,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, joabreu@synopsys.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        lgirdwood@gmail.com, linux@armlinux.org.uk, pabeni@redhat.com,
        peppe.cavallaro@st.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 5/6] arm64: dts: allwinner: move phy regulator in PHY node
Date:   Mon,  9 May 2022 07:48:56 +0000
Message-Id: <20220509074857.195302-6-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220509074857.195302-1-clabbe@baylibre.com>
References: <20220509074857.195302-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that PHY core can handle regulators, move regulator handle in PHY
node.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-a64-nanopi-a64.dts   | 2 +-
 .../boot/dts/allwinner/sun50i-a64-oceanic-5205-5inmfd.dts | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts    | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-a64-pine64.dts       | 2 +-
 .../boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts    | 2 +-
 .../boot/dts/allwinner/sun50i-h5-libretech-all-h5-cc.dts  | 2 +-
 .../boot/dts/allwinner/sun50i-h5-nanopi-neo-plus2.dts     | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts   | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-r1s-h5.dts | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts  | 2 +-
 .../arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts | 2 +-
 .../boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts   | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts   | 2 +-
 .../boot/dts/allwinner/sun50i-h6-pine-h64-model-b.dts     | 8 ++++----
 arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64.dts      | 2 +-
 17 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts
index 997a19372683..f44345e0f749 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts
@@ -107,7 +107,6 @@ &emac {
 	pinctrl-0 = <&rgmii_pins>;
 	phy-mode = "rgmii-id";
 	phy-handle = <&ext_rgmii_phy>;
-	phy-supply = <&reg_dc1sw>;
 	status = "okay";
 };
 
@@ -134,6 +133,7 @@ &mdio {
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		phy-supply = <&reg_dc1sw>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-nanopi-a64.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-nanopi-a64.dts
index e47ff06a6fa9..9923d8fb3289 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-nanopi-a64.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-nanopi-a64.dts
@@ -82,7 +82,6 @@ &emac {
 	pinctrl-0 = <&rgmii_pins>;
 	phy-mode = "rgmii";
 	phy-handle = <&ext_rgmii_phy>;
-	phy-supply = <&reg_dcdc1>;
 	status = "okay";
 };
 
@@ -106,6 +105,7 @@ &mdio {
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <7>;
+		phy-supply = <&reg_dcdc1>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-oceanic-5205-5inmfd.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-oceanic-5205-5inmfd.dts
index 577f9e1d08a1..ec511efee942 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-oceanic-5205-5inmfd.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-oceanic-5205-5inmfd.dts
@@ -30,7 +30,6 @@ &emac {
 	pinctrl-0 = <&rgmii_pins>;
 	phy-mode = "rgmii";
 	phy-handle = <&ext_rgmii_phy>;
-	phy-supply = <&reg_dc1sw>;
 	allwinner,tx-delay-ps = <600>;
 	status = "okay";
 };
@@ -55,6 +54,7 @@ &mdio {
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		phy-supply = <&reg_dc1sw>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts
index bfb806cf6d7a..c172cc4291b7 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts
@@ -104,7 +104,6 @@ &emac {
 	pinctrl-0 = <&rgmii_pins>;
 	phy-mode = "rgmii";
 	phy-handle = <&ext_rgmii_phy>;
-	phy-supply = <&reg_dcdc1>;
 	allwinner,tx-delay-ps = <600>;
 	status = "okay";
 };
@@ -124,6 +123,7 @@ &mdio {
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		phy-supply = <&reg_dcdc1>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts
index c519d9fa6967..3f9622f141b6 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts
@@ -122,7 +122,6 @@ &emac {
 	pinctrl-0 = <&rgmii_pins>;
 	phy-mode = "rgmii-id";
 	phy-handle = <&ext_rgmii_phy>;
-	phy-supply = <&reg_gmac_3v3>;
 	status = "okay";
 };
 
@@ -141,6 +140,7 @@ &mdio {
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		phy-supply = <&reg_gmac_3v3>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64.dts
index 2accb5ddf783..70039380d454 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64.dts
@@ -83,7 +83,6 @@ &emac {
 	pinctrl-0 = <&rmii_pins>;
 	phy-mode = "rmii";
 	phy-handle = <&ext_rmii_phy1>;
-	phy-supply = <&reg_dc1sw>;
 	status = "okay";
 
 };
@@ -111,6 +110,7 @@ &mdio {
 	ext_rmii_phy1: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		phy-supply = <&reg_dc1sw>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
index 5e66ce1a334f..716a8c1faef2 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
@@ -81,7 +81,6 @@ &emac {
 	pinctrl-0 = <&rgmii_pins>;
 	phy-mode = "rgmii-txid";
 	phy-handle = <&ext_rgmii_phy>;
-	phy-supply = <&reg_dc1sw>;
 	status = "okay";
 };
 
@@ -100,6 +99,7 @@ &mdio {
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		phy-supply = <&reg_dc1sw>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-libretech-all-h5-cc.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-libretech-all-h5-cc.dts
index 6e30a564c87f..4e3dae6ee3a4 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-libretech-all-h5-cc.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-libretech-all-h5-cc.dts
@@ -34,7 +34,6 @@ &codec {
 &emac {
 	pinctrl-names = "default";
 	pinctrl-0 = <&emac_rgmii_pins>;
-	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
 	phy-mode = "rgmii-id";
 	/delete-property/ allwinner,leds-active-low;
@@ -45,6 +44,7 @@ &external_mdio {
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		phy-supply = <&reg_gmac_3v3>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo-plus2.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo-plus2.dts
index 4c3921ac236c..e07142b0cddf 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo-plus2.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo-plus2.dts
@@ -94,7 +94,6 @@ &ehci3 {
 &emac {
 	pinctrl-names = "default";
 	pinctrl-0 = <&emac_rgmii_pins>;
-	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
 	phy-mode = "rgmii-id";
 	status = "okay";
@@ -104,6 +103,7 @@ &external_mdio {
 	ext_rgmii_phy: ethernet-phy@7 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <7>;
+		phy-supply = <&reg_gmac_3v3>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts
index 05486cccee1c..77940e90bd36 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts
@@ -73,7 +73,6 @@ &ehci3 {
 &emac {
 	pinctrl-names = "default";
 	pinctrl-0 = <&emac_rgmii_pins>;
-	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
 	phy-mode = "rgmii-id";
 	status = "okay";
@@ -83,6 +82,7 @@ &external_mdio {
 	ext_rgmii_phy: ethernet-phy@7 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <7>;
+		phy-supply = <&reg_gmac_3v3>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-r1s-h5.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-r1s-h5.dts
index 55b369534a08..7280bcbc0f40 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-r1s-h5.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-r1s-h5.dts
@@ -125,7 +125,6 @@ &ehci2 {
 &emac {
 	pinctrl-names = "default";
 	pinctrl-0 = <&emac_rgmii_pins>;
-	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
 	phy-mode = "rgmii-id";
 	status = "okay";
@@ -135,6 +134,7 @@ &external_mdio {
 	ext_rgmii_phy: ethernet-phy@7 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <7>;
+		phy-supply = <&reg_gmac_3v3>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts
index 1010c1b22d2e..95bc670a4b8e 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts
@@ -121,7 +121,6 @@ &ehci3 {
 &emac {
 	pinctrl-names = "default";
 	pinctrl-0 = <&emac_rgmii_pins>;
-	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
 	phy-mode = "rgmii-id";
 	status = "okay";
@@ -131,6 +130,7 @@ &external_mdio {
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		phy-supply = <&reg_gmac_3v3>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts
index 74e0444af19b..8b4403ca610f 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts
@@ -122,7 +122,6 @@ &ehci3 {
 &emac {
 	pinctrl-names = "default";
 	pinctrl-0 = <&emac_rgmii_pins>;
-	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
 	phy-mode = "rgmii-id";
 	status = "okay";
@@ -132,6 +131,7 @@ &external_mdio {
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		phy-supply = <&reg_gmac_3v3>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts
index 7ec5ac850a0d..74d2a60ce113 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts
@@ -67,7 +67,6 @@ &ehci1 {
 &emac {
 	pinctrl-names = "default";
 	pinctrl-0 = <&emac_rgmii_pins>;
-	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
 	phy-mode = "rgmii-id";
 	status = "okay";
@@ -77,6 +76,7 @@ &external_mdio {
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		phy-supply = <&reg_gmac_3v3>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts
index 6249e9e02928..ecfb99c07f69 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts
@@ -99,7 +99,6 @@ &emac {
 	pinctrl-0 = <&ext_rgmii_pins>;
 	phy-mode = "rgmii-id";
 	phy-handle = <&ext_rgmii_phy>;
-	phy-supply = <&reg_aldo2>;
 	status = "okay";
 };
 
@@ -122,6 +121,7 @@ &mdio {
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		phy-supply = <&reg_aldo2>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64-model-b.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64-model-b.dts
index 686f58e77004..6594d2e5284a 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64-model-b.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64-model-b.dts
@@ -18,12 +18,12 @@ wifi_pwrseq: wifi_pwrseq {
 	};
 };
 
-&hdmi_connector {
-	/delete-property/ ddc-en-gpios;
+&ext_rgmii_phy {
+	phy-supply = <&reg_aldo2>;
 };
 
-&emac {
-	phy-supply = <&reg_aldo2>;
+&hdmi_connector {
+	/delete-property/ ddc-en-gpios;
 };
 
 &mmc1 {
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64.dts
index 1ffd68f43f87..dae637720432 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64.dts
@@ -102,7 +102,6 @@ &emac {
 	pinctrl-0 = <&ext_rgmii_pins>;
 	phy-mode = "rgmii-id";
 	phy-handle = <&ext_rgmii_phy>;
-	phy-supply = <&reg_gmac_3v3>;
 	allwinner,rx-delay-ps = <200>;
 	allwinner,tx-delay-ps = <200>;
 	status = "okay";
@@ -127,6 +126,7 @@ &mdio {
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		phy-supply = <&reg_gmac_3v3>;
 	};
 };
 
-- 
2.35.1

