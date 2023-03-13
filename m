Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24206B6E30
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 04:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCMDrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 23:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjCMDq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 23:46:57 -0400
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D713BDA1;
        Sun, 12 Mar 2023 20:46:55 -0700 (PDT)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 830E324E1DB;
        Mon, 13 Mar 2023 11:46:54 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 13 Mar
 2023 11:46:54 +0800
Received: from starfive-sdk.starfivetech.com (171.223.208.138) by
 EXMBX162.cuchost.com (172.16.6.72) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Mon, 13 Mar 2023 11:46:53 +0800
From:   Samin Guo <samin.guo@starfivetech.com>
To:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Samin Guo <samin.guo@starfivetech.com>
Subject: [PATCH v6 8/8] riscv: dts: starfive: visionfive 2: Add configuration of gmac and phy
Date:   Mon, 13 Mar 2023 11:46:45 +0800
Message-ID: <20230313034645.5469-9-samin.guo@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230313034645.5469-1-samin.guo@starfivetech.com>
References: <20230313034645.5469-1-samin.guo@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS061.cuchost.com (172.16.6.21) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1.3B:
  v1.3B uses motorcomm YT8531(rgmii-id phy) x2, need delay and
  inverse configurations.
  The tx_clk of v1.3B uses an external clock and needs to be
  switched to an external clock source.

v1.2A:
  v1.2A gmac0 uses motorcomm YT8531(rgmii-id) PHY, and needs delay
  configurations.
  v1.2A gmac1 uses motorcomm YT8512(rmii) PHY, and needs to
  switch rx and rx to external clock sources.

Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
---
 .../jh7110-starfive-visionfive-2-v1.2a.dts    | 13 ++++++++
 .../jh7110-starfive-visionfive-2-v1.3b.dts    | 27 ++++++++++++++++
 .../jh7110-starfive-visionfive-2.dtsi         | 32 +++++++++++++++++++
 3 files changed, 72 insertions(+)

diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.2a.dts b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.2a.dts
index 4af3300f3cf3..205a13d8c8b1 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.2a.dts
+++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.2a.dts
@@ -11,3 +11,16 @@
 	model = "StarFive VisionFive 2 v1.2A";
 	compatible = "starfive,visionfive-2-v1.2a", "starfive,jh7110";
 };
+
+&gmac1 {
+	phy-mode = "rmii";
+	assigned-clocks = <&syscrg JH7110_SYSCLK_GMAC1_TX>,
+			  <&syscrg JH7110_SYSCLK_GMAC1_RX>;
+	assigned-clock-parents = <&syscrg JH7110_SYSCLK_GMAC1_RMII_RTX>,
+				 <&syscrg JH7110_SYSCLK_GMAC1_RMII_RTX>;
+};
+
+&phy0 {
+	rx-internal-delay-ps = <1900>;
+	tx-internal-delay-ps = <1350>;
+};
diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.3b.dts b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.3b.dts
index 9230cc3d8946..32fae0de9a44 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.3b.dts
+++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.3b.dts
@@ -11,3 +11,30 @@
 	model = "StarFive VisionFive 2 v1.3B";
 	compatible = "starfive,visionfive-2-v1.3b", "starfive,jh7110";
 };
+
+&gmac0 {
+	starfive,tx-use-rgmii-clk;
+	assigned-clocks = <&aoncrg JH7110_AONCLK_GMAC0_TX>;
+	assigned-clock-parents = <&aoncrg JH7110_AONCLK_GMAC0_RMII_RTX>;
+};
+
+&gmac1 {
+	starfive,tx-use-rgmii-clk;
+	assigned-clocks = <&syscrg JH7110_SYSCLK_GMAC1_TX>;
+	assigned-clock-parents = <&syscrg JH7110_SYSCLK_GMAC1_RMII_RTX>;
+};
+
+&phy0 {
+	motorcomm,tx-clk-adj-enabled;
+	motorcomm,tx-clk-100-inverted;
+	motorcomm,tx-clk-1000-inverted;
+	rx-internal-delay-ps = <1900>;
+	tx-internal-delay-ps = <1500>;
+};
+
+&phy1 {
+	motorcomm,tx-clk-adj-enabled;
+	motorcomm,tx-clk-100-inverted;
+	rx-internal-delay-ps = <0>;
+	tx-internal-delay-ps = <0>;
+};
diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
index 2a6d81609284..ce6664071f40 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
@@ -11,6 +11,8 @@
 
 / {
 	aliases {
+		ethernet0 = &gmac0;
+		ethernet1 = &gmac1;
 		i2c0 = &i2c0;
 		i2c2 = &i2c2;
 		i2c5 = &i2c5;
@@ -86,6 +88,36 @@
 	clock-frequency = <49152000>;
 };
 
+&gmac0 {
+	phy-handle = <&phy0>;
+	phy-mode = "rgmii-id";
+	status = "okay";
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "snps,dwmac-mdio";
+
+		phy0: ethernet-phy@0 {
+			reg = <0>;
+		};
+	};
+};
+
+&gmac1 {
+	phy-handle = <&phy1>;
+	phy-mode = "rgmii-id";
+	status = "okay";
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "snps,dwmac-mdio";
+
+		phy1: ethernet-phy@1 {
+			reg = <0>;
+		};
+	};
+};
+
 &i2c0 {
 	clock-frequency = <100000>;
 	i2c-sda-hold-time-ns = <300>;
-- 
2.17.1

