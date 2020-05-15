Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D941D5353
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgEOPJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:09:49 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:2033 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727873AbgEOPJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:09:46 -0400
X-IronPort-AV: E=Sophos;i="5.73,395,1583161200"; 
   d="scan'208";a="46974816"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 16 May 2020 00:09:44 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id DC75140065C1;
        Sat, 16 May 2020 00:09:40 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 03/17] ARM: dts: r8a7742: Add I2C and IIC support
Date:   Fri, 15 May 2020 16:08:43 +0100
Message-Id: <1589555337-5498-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the I2C[0-3] and IIC[0-3] devices nodes to the R8A7742 device tree.

Automatic transmission for PMIC control is not available on IIC3 hence
compatible string "renesas,rcar-gen2-iic" and "renesas,rmobile-iic" is
not added to iic3 node.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
---
 arch/arm/boot/dts/r8a7742.dtsi | 122 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7742.dtsi b/arch/arm/boot/dts/r8a7742.dtsi
index 305d808..f28c32d 100644
--- a/arch/arm/boot/dts/r8a7742.dtsi
+++ b/arch/arm/boot/dts/r8a7742.dtsi
@@ -359,6 +359,128 @@
 			ranges = <0 0 0xe6300000 0x40000>;
 		};
 
+		i2c0: i2c@e6508000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "renesas,i2c-r8a7742",
+				     "renesas,rcar-gen2-i2c";
+			reg = <0 0xe6508000 0 0x40>;
+			interrupts = <GIC_SPI 287 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 931>;
+			power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
+			resets = <&cpg 931>;
+			i2c-scl-internal-delay-ns = <110>;
+			status = "disabled";
+		};
+
+		i2c1: i2c@e6518000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "renesas,i2c-r8a7742",
+				     "renesas,rcar-gen2-i2c";
+			reg = <0 0xe6518000 0 0x40>;
+			interrupts = <GIC_SPI 288 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 930>;
+			power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
+			resets = <&cpg 930>;
+			i2c-scl-internal-delay-ns = <6>;
+			status = "disabled";
+		};
+
+		i2c2: i2c@e6530000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "renesas,i2c-r8a7742",
+				     "renesas,rcar-gen2-i2c";
+			reg = <0 0xe6530000 0 0x40>;
+			interrupts = <GIC_SPI 286 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 929>;
+			power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
+			resets = <&cpg 929>;
+			i2c-scl-internal-delay-ns = <6>;
+			status = "disabled";
+		};
+
+		i2c3: i2c@e6540000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "renesas,i2c-r8a7742",
+				     "renesas,rcar-gen2-i2c";
+			reg = <0 0xe6540000 0 0x40>;
+			interrupts = <GIC_SPI 290 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 928>;
+			power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
+			resets = <&cpg 928>;
+			i2c-scl-internal-delay-ns = <110>;
+			status = "disabled";
+		};
+
+		iic0: i2c@e6500000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "renesas,iic-r8a7742",
+				     "renesas,rcar-gen2-iic",
+				     "renesas,rmobile-iic";
+			reg = <0 0xe6500000 0 0x425>;
+			interrupts = <GIC_SPI 174 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 318>;
+			dmas = <&dmac0 0x61>, <&dmac0 0x62>,
+			       <&dmac1 0x61>, <&dmac1 0x62>;
+			dma-names = "tx", "rx", "tx", "rx";
+			power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
+			resets = <&cpg 318>;
+			status = "disabled";
+		};
+
+		iic1: i2c@e6510000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "renesas,iic-r8a7742",
+				     "renesas,rcar-gen2-iic",
+				     "renesas,rmobile-iic";
+			reg = <0 0xe6510000 0 0x425>;
+			interrupts = <GIC_SPI 175 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 323>;
+			dmas = <&dmac0 0x65>, <&dmac0 0x66>,
+			       <&dmac1 0x65>, <&dmac1 0x66>;
+			dma-names = "tx", "rx", "tx", "rx";
+			power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
+			resets = <&cpg 323>;
+			status = "disabled";
+		};
+
+		iic2: i2c@e6520000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "renesas,iic-r8a7742",
+				     "renesas,rcar-gen2-iic",
+				     "renesas,rmobile-iic";
+			reg = <0 0xe6520000 0 0x425>;
+			interrupts = <GIC_SPI 176 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 300>;
+			dmas = <&dmac0 0x69>, <&dmac0 0x6a>,
+			       <&dmac1 0x69>, <&dmac1 0x6a>;
+			dma-names = "tx", "rx", "tx", "rx";
+			power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
+			resets = <&cpg 300>;
+			status = "disabled";
+		};
+
+		iic3: i2c@e60b0000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "renesas,iic-r8a7742";
+			reg = <0 0xe60b0000 0 0x425>;
+			interrupts = <GIC_SPI 173 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 926>;
+			dmas = <&dmac0 0x77>, <&dmac0 0x78>,
+			       <&dmac1 0x77>, <&dmac1 0x78>;
+			dma-names = "tx", "rx", "tx", "rx";
+			power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
+			resets = <&cpg 926>;
+			status = "disabled";
+		};
+
 		dmac0: dma-controller@e6700000 {
 			compatible = "renesas,dmac-r8a7742",
 				     "renesas,rcar-dmac";
-- 
2.7.4

