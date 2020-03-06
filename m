Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E51C517C900
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 00:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgCFXsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 18:48:54 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:57002 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbgCFXsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 18:48:03 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 026Nm04d071139;
        Fri, 6 Mar 2020 17:48:00 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583538480;
        bh=TlYK0/QnPc6+wYd+1RhUkQESkHbuAQhUymrxi4oE+N8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=tArIL4aHRaPl51kikTSkI7G1hOO5tG/0OO0yzVqRkz7H2+9YKO/a/DwaqCeTN/0I7
         PWTP/GEyPV5KvNzi1ybKiZ9q+8JsdX/a2eo/6swMbW+xsl9QMgziYwtaZ5OTbBcVvz
         gLwdfFmr4SQU9adqmF8QXhHnYesN5z+Uet5kqdEA=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 026Nm0ir124773;
        Fri, 6 Mar 2020 17:48:00 -0600
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 6 Mar
 2020 17:48:00 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 6 Mar 2020 17:48:00 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 026NlxYN027954;
        Fri, 6 Mar 2020 17:47:59 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Rob Herring <robh+dt@kernel.org>, Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        <devicetree@vger.kernel.org>
CC:     Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 7/9] arm64: dts: k3-am654-base-board: add mcu cpsw nuss pinmux and phy defs
Date:   Sat, 7 Mar 2020 01:47:32 +0200
Message-ID: <20200306234734.15014-8-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306234734.15014-1-grygorii.strashko@ti.com>
References: <20200306234734.15014-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AM654 EVM base board has TI DP83867 PHY connected to external CPSW NUSS
Port 1 in rgmii-rxid mode.

Hence, add pinmux and Ethernet PHY configuration for TI am654 SoC Gigabit
Ethernet two ports Switch subsystem (CPSW NUSS).

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../arm64/boot/dts/ti/k3-am654-base-board.dts | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am654-base-board.dts b/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
index 1700996800eb..2f3d3316a1cf 100644
--- a/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
@@ -7,6 +7,7 @@
 
 #include "k3-am654.dtsi"
 #include <dt-bindings/input/input.h>
+#include <dt-bindings/net/ti-dp83867.h>
 
 / {
 	compatible =  "ti,am654-evm", "ti,am654";
@@ -95,7 +96,30 @@
 	wkup_pca554_default: wkup_pca554_default {
 		pinctrl-single,pins = <
 			AM65X_WKUP_IOPAD(0x0034, PIN_INPUT, 7) /* (T1) MCU_OSPI1_CLK.WKUP_GPIO0_25 */
+		>;
+	};
+
+	mcu_cpsw_pins_default: mcu_cpsw_pins_default {
+		pinctrl-single,pins = <
+			AM65X_WKUP_IOPAD(0x0058, PIN_OUTPUT, 0) /* (N4) MCU_RGMII1_TX_CTL */
+			AM65X_WKUP_IOPAD(0x005c, PIN_INPUT, 0) /* (N5) MCU_RGMII1_RX_CTL */
+			AM65X_WKUP_IOPAD(0x0060, PIN_OUTPUT, 0) /* (M2) MCU_RGMII1_TD3 */
+			AM65X_WKUP_IOPAD(0x0064, PIN_OUTPUT, 0) /* (M3) MCU_RGMII1_TD2 */
+			AM65X_WKUP_IOPAD(0x0068, PIN_OUTPUT, 0) /* (M4) MCU_RGMII1_TD1 */
+			AM65X_WKUP_IOPAD(0x006c, PIN_OUTPUT, 0) /* (M5) MCU_RGMII1_TD0 */
+			AM65X_WKUP_IOPAD(0x0078, PIN_INPUT, 0) /* (L2) MCU_RGMII1_RD3 */
+			AM65X_WKUP_IOPAD(0x007c, PIN_INPUT, 0) /* (L5) MCU_RGMII1_RD2 */
+			AM65X_WKUP_IOPAD(0x0080, PIN_INPUT, 0) /* (M6) MCU_RGMII1_RD1 */
+			AM65X_WKUP_IOPAD(0x0084, PIN_INPUT, 0) /* (L6) MCU_RGMII1_RD0 */
+			AM65X_WKUP_IOPAD(0x0070, PIN_INPUT, 0) /* (N1) MCU_RGMII1_TXC */
+			AM65X_WKUP_IOPAD(0x0074, PIN_INPUT, 0) /* (M1) MCU_RGMII1_RXC */
+		>;
+	};
 
+	mcu_mdio_pins_default: mcu_mdio1_pins_default {
+		pinctrl-single,pins = <
+			AM65X_WKUP_IOPAD(0x008c, PIN_OUTPUT, 0) /* (L1) MCU_MDIO0_MDC */
+			AM65X_WKUP_IOPAD(0x0088, PIN_INPUT, 0) /* (L4) MCU_MDIO0_MDIO */
 		>;
 	};
 };
@@ -419,3 +443,21 @@
 		data-lanes = <1 2>;
 	};
 };
+
+&mcu_cpsw {
+	pinctrl-names = "default";
+	pinctrl-0 = <&mcu_cpsw_pins_default &mcu_mdio_pins_default>;
+};
+
+&davinci_mdio {
+	phy0: ethernet-phy@0 {
+		reg = <0>;
+		ti,rx-internal-delay = <DP83867_RGMIIDCTL_2_00_NS>;
+		ti,fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
+	};
+};
+
+&cpsw_port1 {
+	phy-mode = "rgmii-rxid";
+	phy-handle = <&phy0>;
+};
-- 
2.17.1

