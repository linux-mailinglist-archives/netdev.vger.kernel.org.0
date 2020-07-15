Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D27220B56
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 13:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731838AbgGOLLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 07:11:48 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:14909 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729801AbgGOLKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 07:10:34 -0400
X-IronPort-AV: E=Sophos;i="5.75,355,1589209200"; 
   d="scan'208";a="51981973"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 15 Jul 2020 20:10:32 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 5930840065C3;
        Wed, 15 Jul 2020 20:10:27 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Zhang Rui <rui.zhang@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Magnus Damm <magnus.damm@gmail.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 13/20] arm64: dts: renesas: r8a774e1: Add I2C and IIC-DVFS support
Date:   Wed, 15 Jul 2020 12:09:03 +0100
Message-Id: <1594811350-14066-14-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the I2C[0-6] and IIC Bus Interface for DVFS (IIC for DVFS)
devices nodes to the r8a774e1 device tree.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
---
 arch/arm64/boot/dts/renesas/r8a774e1.dtsi | 119 +++++++++++++++++++++-
 1 file changed, 116 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
index 7650152b695b..e221c03bdd87 100644
--- a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
@@ -607,22 +607,135 @@
 			status = "disabled";
 		};
 
+		i2c0: i2c@e6500000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "renesas,i2c-r8a774e1",
+				     "renesas,rcar-gen3-i2c";
+			reg = <0 0xe6500000 0 0x40>;
+			interrupts = <GIC_SPI 287 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 931>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			resets = <&cpg 931>;
+			dmas = <&dmac1 0x91>, <&dmac1 0x90>,
+			       <&dmac2 0x91>, <&dmac2 0x90>;
+			dma-names = "tx", "rx", "tx", "rx";
+			i2c-scl-internal-delay-ns = <110>;
+			status = "disabled";
+		};
+
+		i2c1: i2c@e6508000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "renesas,i2c-r8a774e1",
+				     "renesas,rcar-gen3-i2c";
+			reg = <0 0xe6508000 0 0x40>;
+			interrupts = <GIC_SPI 288 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 930>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			resets = <&cpg 930>;
+			dmas = <&dmac1 0x93>, <&dmac1 0x92>,
+			       <&dmac2 0x93>, <&dmac2 0x92>;
+			dma-names = "tx", "rx", "tx", "rx";
+			i2c-scl-internal-delay-ns = <6>;
+			status = "disabled";
+		};
+
 		i2c2: i2c@e6510000 {
-			reg = <0 0xe6510000 0 0x40>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			compatible = "renesas,i2c-r8a774e1",
+				     "renesas,rcar-gen3-i2c";
+			reg = <0 0xe6510000 0 0x40>;
+			interrupts = <GIC_SPI 286 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 929>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			resets = <&cpg 929>;
+			dmas = <&dmac1 0x95>, <&dmac1 0x94>,
+			       <&dmac2 0x95>, <&dmac2 0x94>;
+			dma-names = "tx", "rx", "tx", "rx";
+			i2c-scl-internal-delay-ns = <6>;
 			status = "disabled";
+		};
 
-			/* placeholder */
+		i2c3: i2c@e66d0000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "renesas,i2c-r8a774e1",
+				     "renesas,rcar-gen3-i2c";
+			reg = <0 0xe66d0000 0 0x40>;
+			interrupts = <GIC_SPI 290 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 928>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			resets = <&cpg 928>;
+			dmas = <&dmac0 0x97>, <&dmac0 0x96>;
+			dma-names = "tx", "rx";
+			i2c-scl-internal-delay-ns = <110>;
+			status = "disabled";
 		};
 
 		i2c4: i2c@e66d8000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
+			compatible = "renesas,i2c-r8a774e1",
+				     "renesas,rcar-gen3-i2c";
 			reg = <0 0xe66d8000 0 0x40>;
+			interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 927>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			resets = <&cpg 927>;
+			dmas = <&dmac0 0x99>, <&dmac0 0x98>;
+			dma-names = "tx", "rx";
+			i2c-scl-internal-delay-ns = <110>;
 			status = "disabled";
+		};
 
-			/* placeholder */
+		i2c5: i2c@e66e0000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "renesas,i2c-r8a774e1",
+				     "renesas,rcar-gen3-i2c";
+			reg = <0 0xe66e0000 0 0x40>;
+			interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 919>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			resets = <&cpg 919>;
+			dmas = <&dmac0 0x9b>, <&dmac0 0x9a>;
+			dma-names = "tx", "rx";
+			i2c-scl-internal-delay-ns = <110>;
+			status = "disabled";
+		};
+
+		i2c6: i2c@e66e8000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "renesas,i2c-r8a774e1",
+				     "renesas,rcar-gen3-i2c";
+			reg = <0 0xe66e8000 0 0x40>;
+			interrupts = <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 918>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			resets = <&cpg 918>;
+			dmas = <&dmac0 0x9d>, <&dmac0 0x9c>;
+			dma-names = "tx", "rx";
+			i2c-scl-internal-delay-ns = <6>;
+			status = "disabled";
+		};
+
+		i2c_dvfs: i2c@e60b0000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "renesas,iic-r8a774e1",
+				     "renesas,rcar-gen3-iic",
+				     "renesas,rmobile-iic";
+			reg = <0 0xe60b0000 0 0x425>;
+			interrupts = <GIC_SPI 173 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 926>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			resets = <&cpg 926>;
+			dmas = <&dmac0 0x11>, <&dmac0 0x10>;
+			dma-names = "tx", "rx";
+			status = "disabled";
 		};
 
 		hscif0: serial@e6540000 {
-- 
2.17.1

