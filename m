Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53E14EDE8D
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239735AbiCaQRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239681AbiCaQRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:17:00 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E667D1F1254;
        Thu, 31 Mar 2022 09:15:11 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b15so28767145edn.4;
        Thu, 31 Mar 2022 09:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xjEyY3Y7idT2/xjZtTf3oO9KclkwZrkmMKAiZwZLsWQ=;
        b=dqaf3H8pyJfqFWTnZGb7f7uCrEARjp8BxDSW24tcsT69J+NlH/EcQMF91tT7hBRJW7
         eqOrkAsYEweGdXeAIcvlGVBV2u37BFdjYlQsY4yBwK5QhNsv9NkPLWP8QDMop+ZgxYy4
         gU1+pIzf7ed7vK3EDnG4+g1eheaFKEK4k6heGdZWhaiLDVNwnxw1rxzQuWpY4mCXrI3v
         ZlTaJHudv1Jliq5ZkQz8Tacroum5bOq4VxglFzzePVXvNG95n8T4uDSnxygD7dySVCPw
         D5hz+ICtMJYyxUFhb7jMBqq5/WceTNE2/a3G2oYFfr6DSiMTL9qk3aF1oIRw10EfMPcb
         fF5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xjEyY3Y7idT2/xjZtTf3oO9KclkwZrkmMKAiZwZLsWQ=;
        b=KKRlDovbaB8lIhRRstMtoZlrCxneI6xmQQz+DEAE9iOCMc4ssYkjkOdnf/fTRn4uDy
         KajIOf/XEpEVoOQIFz8Bo5tOpuvZGYRLlyHjwUcJURgffoXe7hFt2a3JcJcJWz6KmNtQ
         +l8P3LyuMECqndsnuEDT+us93+FNOfh4dorSQPQbGq2oiqHqZMtTY+U/C7vmIabSvMoV
         gptpjTf/iSZ2yHWQwOiiB/xJr6F83l5UYoPKA7fYFF54V6cITUAl7DYdzOwXs9+s9OmG
         iAA64niLYYV6M6vpXwVP6ucm/mHMHTJeObI1Rkdb8nE3Uq27LNuUh0WcUvpANK9wNc8O
         t8hw==
X-Gm-Message-State: AOAM531C8KEITN5ni9ITDVbvkrF5FqBKq7xz24Tq76gztmh7xrJVUmdM
        yHLq7HVi4glZtBL+3vSzWFk=
X-Google-Smtp-Source: ABdhPJzXn3NJfsGVHSbXv3mgVWGnaMYgEFt6COE/RUp0EjdFoSNUhzEGELqshVrSMgw/HosvsoiNHg==
X-Received: by 2002:a05:6402:270b:b0:419:3383:7a9f with SMTP id y11-20020a056402270b00b0041933837a9fmr17248675edd.191.1648743310371;
        Thu, 31 Mar 2022 09:15:10 -0700 (PDT)
Received: from debian.home (81-204-249-205.fixed.kpn.net. [81.204.249.205])
        by smtp.gmail.com with ESMTPSA id g4-20020a170906520400b006e0b798a0b8sm7600302ejm.94.2022.03.31.09.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 09:15:09 -0700 (PDT)
From:   Johan Jonker <jbx6244@gmail.com>
To:     heiko@sntech.de
Cc:     robh+dt@kernel.org, krzk+dt@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 3/3] ARM: dts: rockchip: restyle emac nodes
Date:   Thu, 31 Mar 2022 18:14:59 +0200
Message-Id: <20220331161459.16499-3-jbx6244@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220331161459.16499-1-jbx6244@gmail.com>
References: <20220331161459.16499-1-jbx6244@gmail.com>
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
 arch/arm/boot/dts/rk3036-evb.dts        | 16 ++++++++++------
 arch/arm/boot/dts/rk3036-kylin.dts      | 16 ++++++++++------
 arch/arm/boot/dts/rk3036.dtsi           |  2 --
 arch/arm/boot/dts/rk3066a-marsboard.dts | 19 +++++++++++--------
 arch/arm/boot/dts/rk3066a-rayeager.dts  | 15 ++++++++++-----
 arch/arm/boot/dts/rk3188-radxarock.dts  | 19 +++++++++++--------
 arch/arm/boot/dts/rk3xxx.dtsi           |  2 --
 7 files changed, 52 insertions(+), 37 deletions(-)

diff --git a/arch/arm/boot/dts/rk3036-evb.dts b/arch/arm/boot/dts/rk3036-evb.dts
index 2a7e6624e..095e0821a 100644
--- a/arch/arm/boot/dts/rk3036-evb.dts
+++ b/arch/arm/boot/dts/rk3036-evb.dts
@@ -15,16 +15,20 @@
 };
 
 &emac {
+	phy-handle = <&phy0>;
+	phy-reset-duration = <10>; /* millisecond */
+	phy-reset-gpios = <&gpio2 RK_PC6 GPIO_ACTIVE_LOW>; /* PHY_RST */
 	pinctrl-names = "default";
 	pinctrl-0 = <&emac_xfer>, <&emac_mdio>;
-	phy = <&phy0>;
-	phy-reset-gpios = <&gpio2 RK_PC6 GPIO_ACTIVE_LOW>; /* PHY_RST */
-	phy-reset-duration = <10>; /* millisecond */
-
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
index e817eba8c..24c70e925 100644
--- a/arch/arm/boot/dts/rk3036-kylin.dts
+++ b/arch/arm/boot/dts/rk3036-kylin.dts
@@ -80,16 +80,20 @@
 };
 
 &emac {
+	phy-handle = <&phy0>;
+	phy-reset-duration = <10>; /* millisecond */
+	phy-reset-gpios = <&gpio2 RK_PC6 GPIO_ACTIVE_LOW>; /* PHY_RST */
 	pinctrl-names = "default";
 	pinctrl-0 = <&emac_xfer>, <&emac_mdio>;
-	phy = <&phy0>;
-	phy-reset-gpios = <&gpio2 RK_PC6 GPIO_ACTIVE_LOW>; /* PHY_RST */
-	phy-reset-duration = <10>; /* millisecond */
-
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
index a66d915aa..e70ba3ccf 100644
--- a/arch/arm/boot/dts/rk3066a-marsboard.dts
+++ b/arch/arm/boot/dts/rk3066a-marsboard.dts
@@ -150,18 +150,21 @@
 #include "tps65910.dtsi"
 
 &emac {
-	status = "okay";
-
-	phy = <&phy0>;
+	phy-handle = <&phy0>;
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
index 12b2e59ae..600ada0d8 100644
--- a/arch/arm/boot/dts/rk3066a-rayeager.dts
+++ b/arch/arm/boot/dts/rk3066a-rayeager.dts
@@ -142,15 +142,20 @@
 };
 
 &emac {
+	phy-handle = <&phy0>;
+	phy-supply = <&vcc_rmii>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&emac_xfer>, <&emac_mdio>, <&rmii_rst>;
-	phy = <&phy0>;
-	phy-supply = <&vcc_rmii>;
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
index 36c0945f4..e5ed0642d 100644
--- a/arch/arm/boot/dts/rk3188-radxarock.dts
+++ b/arch/arm/boot/dts/rk3188-radxarock.dts
@@ -126,18 +126,21 @@
 };
 
 &emac {
-	status = "okay";
-
+	phy-handle = <&phy0>;
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

