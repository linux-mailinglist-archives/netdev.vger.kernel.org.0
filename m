Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417B82008A9
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 14:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733069AbgFSM1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 08:27:02 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:59931 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733036AbgFSMZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 08:25:24 -0400
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 3A7D024000F;
        Fri, 19 Jun 2020 12:25:22 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        foss@0leil.net, antoine.tenart@bootlin.com
Subject: [PATCH net-next v3 8/8] MIPS: dts: ocelot: describe the load/save GPIO
Date:   Fri, 19 Jun 2020 14:23:00 +0200
Message-Id: <20200619122300.2510533-9-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619122300.2510533-1-antoine.tenart@bootlin.com>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Quentin Schulz <quentin.schulz@bootlin.com>

This patch adds a description of the load/save GPIN pin, used in the
VSC8584 PHY for timestamping operations. The related pinctrl description
is also added.

Signed-off-by: Quentin Schulz <quentin.schulz@bootlin.com>
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 arch/mips/boot/dts/mscc/ocelot_pcb120.dts | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/mips/boot/dts/mscc/ocelot_pcb120.dts b/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
index 33991fd209f5..897de5025d7f 100644
--- a/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
+++ b/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
@@ -3,6 +3,7 @@
 
 /dts-v1/;
 
+#include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/phy/phy-ocelot-serdes.h>
 #include "ocelot.dtsi"
@@ -25,6 +26,11 @@ phy_int_pins: phy_int_pins {
 		pins = "GPIO_4";
 		function = "gpio";
 	};
+
+	phy_load_save_pins: phy_load_save_pins {
+		pins = "GPIO_10";
+		function = "ptp2";
+	};
 };
 
 &mdio0 {
@@ -34,27 +40,31 @@ &mdio0 {
 &mdio1 {
 	status = "okay";
 	pinctrl-names = "default";
-	pinctrl-0 = <&miim1>, <&phy_int_pins>;
+	pinctrl-0 = <&miim1>, <&phy_int_pins>, <&phy_load_save_pins>;
 
 	phy7: ethernet-phy@0 {
 		reg = <0>;
 		interrupts = <4 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-parent = <&gpio>;
+		load-save-gpios = <&gpio 10 GPIO_ACTIVE_HIGH>;
 	};
 	phy6: ethernet-phy@1 {
 		reg = <1>;
 		interrupts = <4 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-parent = <&gpio>;
+		load-save-gpios = <&gpio 10 GPIO_ACTIVE_HIGH>;
 	};
 	phy5: ethernet-phy@2 {
 		reg = <2>;
 		interrupts = <4 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-parent = <&gpio>;
+		load-save-gpios = <&gpio 10 GPIO_ACTIVE_HIGH>;
 	};
 	phy4: ethernet-phy@3 {
 		reg = <3>;
 		interrupts = <4 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-parent = <&gpio>;
+		load-save-gpios = <&gpio 10 GPIO_ACTIVE_HIGH>;
 	};
 };
 
-- 
2.26.2

