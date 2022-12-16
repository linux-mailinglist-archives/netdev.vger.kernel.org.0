Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB6E64E786
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 08:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiLPHGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 02:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiLPHFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 02:05:48 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA802656;
        Thu, 15 Dec 2022 23:05:46 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id 478D824E346;
        Fri, 16 Dec 2022 15:05:45 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 16 Dec
 2022 15:05:45 +0800
Received: from wyh-VirtualBox.starfivetech.com (171.223.208.138) by
 EXMBX173.cuchost.com (172.16.6.93) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Fri, 16 Dec 2022 15:05:44 +0800
From:   Yanhong Wang <yanhong.wang@starfivetech.com>
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
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: [PATCH v2 8/9] riscv: dts: starfive: jh7110: Add ethernet device node
Date:   Fri, 16 Dec 2022 15:06:31 +0800
Message-ID: <20221216070632.11444-9-yanhong.wang@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
References: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add JH7110 ethernet device node to support gmac driver for the JH7110
RISC-V SoC.

Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
---
 arch/riscv/boot/dts/starfive/jh7110.dtsi | 93 ++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/arch/riscv/boot/dts/starfive/jh7110.dtsi b/arch/riscv/boot/dts/starfive/jh7110.dtsi
index c22e8f1d2640..c6de6e3b1a25 100644
--- a/arch/riscv/boot/dts/starfive/jh7110.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110.dtsi
@@ -433,5 +433,98 @@
 			reg-shift = <2>;
 			status = "disabled";
 		};
+
+		stmmac_axi_setup: stmmac-axi-config {
+			snps,lpi_en;
+			snps,wr_osr_lmt = <4>;
+			snps,rd_osr_lmt = <4>;
+			snps,blen = <256 128 64 32 0 0 0>;
+		};
+
+		gmac0: ethernet@16030000 {
+			compatible = "starfive,jh7110-dwmac", "snps,dwmac-5.20";
+			reg = <0x0 0x16030000 0x0 0x10000>;
+			clocks = <&aoncrg JH7110_AONCLK_GMAC0_AXI>,
+				 <&aoncrg JH7110_AONCLK_GMAC0_AHB>,
+				 <&syscrg JH7110_SYSCLK_GMAC0_PTP>,
+				 <&aoncrg JH7110_AONCLK_GMAC0_TX>,
+				 <&syscrg JH7110_SYSCLK_GMAC0_GTXC>,
+				 <&syscrg JH7110_SYSCLK_GMAC0_GTXCLK>;
+			clock-names = "stmmaceth", "pclk", "ptp_ref",
+						"tx", "gtxc", "gtx";
+			resets = <&aoncrg JH7110_AONRST_GMAC0_AXI>,
+				 <&aoncrg JH7110_AONRST_GMAC0_AHB>;
+			reset-names = "stmmaceth", "ahb";
+			interrupts = <7>, <6>, <5>;
+			interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
+			phy-mode = "rgmii-id";
+			snps,multicast-filter-bins = <64>;
+			snps,perfect-filter-entries = <8>;
+			rx-fifo-depth = <2048>;
+			tx-fifo-depth = <2048>;
+			snps,fixed-burst;
+			snps,no-pbl-x8;
+			snps,force_thresh_dma_mode;
+			snps,axi-config = <&stmmac_axi_setup>;
+			snps,tso;
+			snps,en-tx-lpi-clockgating;
+			snps,txpbl = <16>;
+			snps,rxpbl = <16>;
+			status = "disabled";
+			phy-handle = <&phy0>;
+
+			mdio0: mdio {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "snps,dwmac-mdio";
+
+				phy0: ethernet-phy@0 {
+					reg = <0>;
+				};
+			};
+		};
+
+		gmac1: ethernet@16040000 {
+			compatible = "starfive,jh7110-dwmac", "snps,dwmac-5.20";
+			reg = <0x0 0x16040000 0x0 0x10000>;
+			clocks = <&syscrg JH7110_SYSCLK_GMAC1_AXI>,
+				 <&syscrg JH7110_SYSCLK_GMAC1_AHB>,
+				 <&syscrg JH7110_SYSCLK_GMAC1_PTP>,
+				 <&syscrg JH7110_SYSCLK_GMAC1_TX>,
+				 <&syscrg JH7110_SYSCLK_GMAC1_GTXC>,
+				 <&syscrg JH7110_SYSCLK_GMAC1_GTXCLK>;
+			clock-names = "stmmaceth", "pclk", "ptp_ref",
+					"tx", "gtxc", "gtx";
+			resets = <&syscrg JH7110_SYSRST_GMAC1_AXI>,
+				 <&syscrg JH7110_SYSRST_GMAC1_AHB>;
+			reset-names = "stmmaceth", "ahb";
+			interrupts = <78>, <77>, <76>;
+			interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
+			phy-mode = "rgmii-id";
+			snps,multicast-filter-bins = <64>;
+			snps,perfect-filter-entries = <8>;
+			rx-fifo-depth = <2048>;
+			tx-fifo-depth = <2048>;
+			snps,fixed-burst;
+			snps,no-pbl-x8;
+			snps,force_thresh_dma_mode;
+			snps,axi-config = <&stmmac_axi_setup>;
+			snps,tso;
+			snps,en-tx-lpi-clockgating;
+			snps,txpbl = <16>;
+			snps,rxpbl = <16>;
+			status = "disabled";
+			phy-handle = <&phy1>;
+
+			mdio1: mdio {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "snps,dwmac-mdio";
+
+				phy1: ethernet-phy@1 {
+					reg = <1>;
+				};
+			};
+		};
 	};
 };
-- 
2.17.1

