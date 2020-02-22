Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15B5E169015
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 16:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgBVP7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 10:59:02 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:54036 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbgBVP7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 10:59:01 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01MFwwdC094152;
        Sat, 22 Feb 2020 09:58:58 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582387138;
        bh=FZIbChqraScWDQp84GWjNyufMYe6dLz98wNOtdVdA9w=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=agovbtnVY0axeM52R6T3EureLxertyc9nLmKiwf6Zxk8VpSXEYfuKzIKvkWCwiT9q
         b9Gm17lLgojwIpR+dd2ps7RhNK3eL3hGesu5/oMI8F+FgWlxN3miNxhK/mw5Rvrvfi
         wis79zlHdgHXNgGoX6OZLza1zyVbBvFXmQ2wecSI=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01MFwwjw077271;
        Sat, 22 Feb 2020 09:58:58 -0600
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Sat, 22
 Feb 2020 09:58:58 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Sat, 22 Feb 2020 09:58:58 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01MFwvGb076957;
        Sat, 22 Feb 2020 09:58:57 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Roger Quadros <rogerq@ti.com>, Tero Kristo <t-kristo@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
CC:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 9/9] arm64: dts: ti: k3-j721e-common-proc-board: add mcu cpsw nuss pinmux and phy defs
Date:   Sat, 22 Feb 2020 17:57:52 +0200
Message-ID: <20200222155752.22021-10-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200222155752.22021-1-grygorii.strashko@ti.com>
References: <20200222155752.22021-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TI J721E EVM base board has TI DP83867 PHY connected to external CPSW
NUSS Port 1 in rgmii-rxid mode.

Hence, add pinmux and Ethernet PHY configuration for TI j721e SoC MCU
Gigabit Ethernet subsystem (MCU CPSW2G NUSS).

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../dts/ti/k3-j721e-common-proc-board.dts     | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
index 7a5c3d4adadd..98e5e17e3ff7 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
@@ -8,6 +8,7 @@
 #include "k3-j721e-som-p0.dtsi"
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/input.h>
+#include <dt-bindings/net/ti-dp83867.h>
 
 / {
 	chosen {
@@ -128,6 +129,30 @@
 			J721E_WKUP_IOPAD(0x38, PIN_INPUT, 0) /* (A23) MCU_OSPI1_LBCLKO */
 		>;
 	};
+
+	mcu_cpsw_pins_default: mcu_cpsw_pins_default {
+		pinctrl-single,pins = <
+			J721E_WKUP_IOPAD(0x0058, PIN_OUTPUT, 0) /* MCU_RGMII1_TX_CTL */
+			J721E_WKUP_IOPAD(0x005c, PIN_INPUT, 0) /* MCU_RGMII1_RX_CTL */
+			J721E_WKUP_IOPAD(0x0060, PIN_OUTPUT, 0) /* MCU_RGMII1_TD3 */
+			J721E_WKUP_IOPAD(0x0064, PIN_OUTPUT, 0) /* MCU_RGMII1_TD2 */
+			J721E_WKUP_IOPAD(0x0068, PIN_OUTPUT, 0) /* MCU_RGMII1_TD1 */
+			J721E_WKUP_IOPAD(0x006c, PIN_OUTPUT, 0) /* MCU_RGMII1_TD0 */
+			J721E_WKUP_IOPAD(0x0078, PIN_INPUT, 0) /* MCU_RGMII1_RD3 */
+			J721E_WKUP_IOPAD(0x007c, PIN_INPUT, 0) /* MCU_RGMII1_RD2 */
+			J721E_WKUP_IOPAD(0x0080, PIN_INPUT, 0) /* MCU_RGMII1_RD1 */
+			J721E_WKUP_IOPAD(0x0084, PIN_INPUT, 0) /* MCU_RGMII1_RD0 */
+			J721E_WKUP_IOPAD(0x0070, PIN_INPUT, 0) /* MCU_RGMII1_TXC */
+			J721E_WKUP_IOPAD(0x0074, PIN_INPUT, 0) /* MCU_RGMII1_RXC */
+		>;
+	};
+
+	mcu_mdio_pins_default: mcu_mdio1_pins_default {
+		pinctrl-single,pins = <
+			J721E_WKUP_IOPAD(0x008c, PIN_OUTPUT, 0) /* MCU_MDIO0_MDC */
+			J721E_WKUP_IOPAD(0x0088, PIN_INPUT, 0) /* MCU_MDIO0_MDIO */
+		>;
+	};
 };
 
 &wkup_uart0 {
@@ -429,3 +454,21 @@
 		#gpio-cells = <2>;
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

