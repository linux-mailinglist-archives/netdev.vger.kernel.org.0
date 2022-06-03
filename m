Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DCD53CD54
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 18:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343975AbiFCQgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 12:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343968AbiFCQfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 12:35:52 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B160D2CDFF;
        Fri,  3 Jun 2022 09:35:49 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id n28so10865933edb.9;
        Fri, 03 Jun 2022 09:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ehXZdnyYhQGdFWJC4VGnIHkQy4QBmtpZ6LdmrEF0kKs=;
        b=K+WAfwU/ngrjgvC2OP5zpGacNsUc/k/WvO2zX9AsWAq0WG4hgiPbpROPoEZWaB/Hl0
         SyYiXHMJ1IMf37UGRk7w25J6H082YxYGD8usNPc2ZizIfy7g5UCxiS3ZR5AI8ybRhl+h
         MskLOIiMapwzluUhrWCvMPFKMMKZA4zzhh0B4Vwchm9hPBF8v4n3bI0oUkBxivIUna1h
         x9RITpAVIIc+S7pvd9hjUYu+Q40xo03vBbC26R9ckZVRbuEQiqIFa6mgj9xcm8pm19d5
         Wobl7EYgvoQ7aA3nphMtkmeJBg1frxNCp0t4ILvkceIMkcg/HBIf2rHzoxsEEJHZ3X3A
         NRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ehXZdnyYhQGdFWJC4VGnIHkQy4QBmtpZ6LdmrEF0kKs=;
        b=GGk6yzajhbGFntumYTlE6EkfbwFUFQGjs5JKQi+a5Jno4HO1PEmWl2sJh2Yi9zftRS
         1vuILqmi9eRtlSPAwVjHvldCX/pcAl9mJBaYGgXxsZMiZ2A18BkKvJ6orYrJG+tDAUJI
         1bL6xeXixUGAtHA26cUDjRSRw+vZHCLoGIT2xIt4pNOct2HZfzpNuM111JkUwrjr5dQs
         1m6sPp/52sD0MZqamE4leNAADI82zhqDgpQ5BisqXgE6GLdbHU+XAzP4+5dzyFIB5srN
         OHIGwdrhBzXm8xsIG7VbQKkJjkvmWP2DiQaB4fnZQwog+g3P3/MCr49bqdgln7CWvA/o
         J6QA==
X-Gm-Message-State: AOAM531Z9Wm8RKYxPC5uhKr3ExmVihwMaxNSGClXPf941hR6uDeVXizu
        eSNbQN1O63MAUSOct5AvC48=
X-Google-Smtp-Source: ABdhPJwir3sPXB/4KhHIbARo7v439Y/LK1tCuHGIf2ZJnNdNJNvHo/x3d80XUZleYQGtthQOTcBYUg==
X-Received: by 2002:a05:6402:1e92:b0:42d:dc34:e233 with SMTP id f18-20020a0564021e9200b0042ddc34e233mr11965467edf.386.1654274148266;
        Fri, 03 Jun 2022 09:35:48 -0700 (PDT)
Received: from debian.home (81-204-249-205.fixed.kpn.net. [81.204.249.205])
        by smtp.gmail.com with ESMTPSA id n13-20020a056402060d00b0042dd630eb2csm4106189edv.96.2022.06.03.09.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 09:35:47 -0700 (PDT)
From:   Johan Jonker <jbx6244@gmail.com>
To:     heiko@sntech.de
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] ARM: dts: rockchip: restyle emac nodes
Date:   Fri,  3 Jun 2022 18:35:39 +0200
Message-Id: <20220603163539.537-3-jbx6244@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220603163539.537-1-jbx6244@gmail.com>
References: <20220603163539.537-1-jbx6244@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The emac_rockchip.txt file is converted to YAML.
Phy nodes are now a subnode of mdio, so restyle
the emac nodes of rk3036/rk3066/rk3188.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
---

Changed V2:
  use phy
---
 arch/arm/boot/dts/rk3036-evb.dts        | 16 ++++++++++------
 arch/arm/boot/dts/rk3036-kylin.dts      | 16 ++++++++++------
 arch/arm/boot/dts/rk3036.dtsi           |  2 --
 arch/arm/boot/dts/rk3066a-marsboard.dts | 17 ++++++++++-------
 arch/arm/boot/dts/rk3066a-rayeager.dts  | 15 ++++++++++-----
 arch/arm/boot/dts/rk3188-radxarock.dts  | 19 +++++++++++--------
 arch/arm/boot/dts/rk3xxx.dtsi           |  2 --
 7 files changed, 51 insertions(+), 36 deletions(-)

diff --git a/arch/arm/boot/dts/rk3036-evb.dts b/arch/arm/boot/dts/rk3036-evb.dts
index 2a7e6624e..9fd4d9db9 100644
--- a/arch/arm/boot/dts/rk3036-evb.dts
+++ b/arch/arm/boot/dts/rk3036-evb.dts
@@ -15,16 +15,20 @@
 };
 
 &emac {
-	pinctrl-names = "default";
-	pinctrl-0 = <&emac_xfer>, <&emac_mdio>;
 	phy = <&phy0>;
-	phy-reset-gpios = <&gpio2 RK_PC6 GPIO_ACTIVE_LOW>; /* PHY_RST */
 	phy-reset-duration = <10>; /* millisecond */
-
+	phy-reset-gpios = <&gpio2 RK_PC6 GPIO_ACTIVE_LOW>; /* PHY_RST */
+	pinctrl-names = "default";
+	pinctrl-0 = <&emac_xfer>, <&emac_mdio>;
 	status = "okay";
 
-	phy0: ethernet-phy@0 {
-		reg = <0>;
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		phy0: ethernet-phy@0 {
+			reg = <0>;
+		};
 	};
 };
 
diff --git a/arch/arm/boot/dts/rk3036-kylin.dts b/arch/arm/boot/dts/rk3036-kylin.dts
index e817eba8c..67e1e0413 100644
--- a/arch/arm/boot/dts/rk3036-kylin.dts
+++ b/arch/arm/boot/dts/rk3036-kylin.dts
@@ -80,16 +80,20 @@
 };
 
 &emac {
-	pinctrl-names = "default";
-	pinctrl-0 = <&emac_xfer>, <&emac_mdio>;
 	phy = <&phy0>;
-	phy-reset-gpios = <&gpio2 RK_PC6 GPIO_ACTIVE_LOW>; /* PHY_RST */
 	phy-reset-duration = <10>; /* millisecond */
-
+	phy-reset-gpios = <&gpio2 RK_PC6 GPIO_ACTIVE_LOW>; /* PHY_RST */
+	pinctrl-names = "default";
+	pinctrl-0 = <&emac_xfer>, <&emac_mdio>;
 	status = "okay";
 
-	phy0: ethernet-phy@0 {
-		reg = <0>;
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		phy0: ethernet-phy@0 {
+			reg = <0>;
+		};
 	};
 };
 
diff --git a/arch/arm/boot/dts/rk3036.dtsi b/arch/arm/boot/dts/rk3036.dtsi
index e240b89b0..78686fc72 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -228,8 +228,6 @@
 		compatible = "rockchip,rk3036-emac";
 		reg = <0x10200000 0x4000>;
 		interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
-		#address-cells = <1>;
-		#size-cells = <0>;
 		rockchip,grf = <&grf>;
 		clocks = <&cru HCLK_MAC>, <&cru SCLK_MACREF>, <&cru SCLK_MAC>;
 		clock-names = "hclk", "macref", "macclk";
diff --git a/arch/arm/boot/dts/rk3066a-marsboard.dts b/arch/arm/boot/dts/rk3066a-marsboard.dts
index a66d915aa..8beecd628 100644
--- a/arch/arm/boot/dts/rk3066a-marsboard.dts
+++ b/arch/arm/boot/dts/rk3066a-marsboard.dts
@@ -150,18 +150,21 @@
 #include "tps65910.dtsi"
 
 &emac {
-	status = "okay";
-
 	phy = <&phy0>;
 	phy-supply = <&vcc_rmii>;
-
 	pinctrl-names = "default";
 	pinctrl-0 = <&emac_xfer>, <&emac_mdio>, <&phy_int>;
+	status = "okay";
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
 
-	phy0: ethernet-phy@0 {
-		reg = <0>;
-		interrupt-parent = <&gpio1>;
-		interrupts = <RK_PD2 IRQ_TYPE_LEVEL_LOW>;
+		phy0: ethernet-phy@0 {
+			reg = <0>;
+			interrupt-parent = <&gpio1>;
+			interrupts = <RK_PD2 IRQ_TYPE_LEVEL_LOW>;
+		};
 	};
 };
 
diff --git a/arch/arm/boot/dts/rk3066a-rayeager.dts b/arch/arm/boot/dts/rk3066a-rayeager.dts
index 12b2e59ae..9aeef36ca 100644
--- a/arch/arm/boot/dts/rk3066a-rayeager.dts
+++ b/arch/arm/boot/dts/rk3066a-rayeager.dts
@@ -142,15 +142,20 @@
 };
 
 &emac {
-	pinctrl-names = "default";
-	pinctrl-0 = <&emac_xfer>, <&emac_mdio>, <&rmii_rst>;
 	phy = <&phy0>;
 	phy-supply = <&vcc_rmii>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&emac_xfer>, <&emac_mdio>, <&rmii_rst>;
 	status = "okay";
 
-	phy0: ethernet-phy@0 {
-		reg = <0>;
-		reset-gpios = <&gpio1 RK_PD6 GPIO_ACTIVE_LOW>;
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		phy0: ethernet-phy@0 {
+			reg = <0>;
+			reset-gpios = <&gpio1 RK_PD6 GPIO_ACTIVE_LOW>;
+		};
 	};
 };
 
diff --git a/arch/arm/boot/dts/rk3188-radxarock.dts b/arch/arm/boot/dts/rk3188-radxarock.dts
index 36c0945f4..bb0942d3e 100644
--- a/arch/arm/boot/dts/rk3188-radxarock.dts
+++ b/arch/arm/boot/dts/rk3188-radxarock.dts
@@ -126,18 +126,21 @@
 };
 
 &emac {
-	status = "okay";
-
+	phy = <&phy0>;
+	phy-supply = <&vcc_rmii>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&emac_xfer>, <&emac_mdio>, <&phy_int>;
+	status = "okay";
 
-	phy = <&phy0>;
-	phy-supply = <&vcc_rmii>;
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
 
-	phy0: ethernet-phy@0 {
-		reg = <0>;
-		interrupt-parent = <&gpio3>;
-		interrupts = <RK_PD2 IRQ_TYPE_LEVEL_LOW>;
+		phy0: ethernet-phy@0 {
+			reg = <0>;
+			interrupt-parent = <&gpio3>;
+			interrupts = <RK_PD2 IRQ_TYPE_LEVEL_LOW>;
+		};
 	};
 };
 
diff --git a/arch/arm/boot/dts/rk3xxx.dtsi b/arch/arm/boot/dts/rk3xxx.dtsi
index 616a828e0..bf285091a 100644
--- a/arch/arm/boot/dts/rk3xxx.dtsi
+++ b/arch/arm/boot/dts/rk3xxx.dtsi
@@ -186,8 +186,6 @@
 		compatible = "snps,arc-emac";
 		reg = <0x10204000 0x3c>;
 		interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
-		#address-cells = <1>;
-		#size-cells = <0>;
 
 		rockchip,grf = <&grf>;
 
-- 
2.20.1

