Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410AB6C6866
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 13:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjCWMdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 08:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbjCWMdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 08:33:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8153E12858
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 05:33:04 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pfK7b-00081j-6X; Thu, 23 Mar 2023 13:32:47 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pfK7Y-00699f-Aw; Thu, 23 Mar 2023 13:32:44 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pfK7X-00Fn7U-Kh; Thu, 23 Mar 2023 13:32:43 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v1] ARM: dts: stm32: prtt1c: Add PoDL PSE regulator nodes
Date:   Thu, 23 Mar 2023 13:32:42 +0100
Message-Id: <20230323123242.3763673-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces Power over Data Line (PoDL) Power Source
Equipment (PSE) regulator nodes to the PRTT1C devicetree. The addition
of these nodes enables support for PoDL in PRTT1C devices, allowing
power delivery and data transmission over a single twisted pair.

The new PoDL PSE regulator nodes provide voltage capability information
of the current board design, which can be used as a hint for system
administrators when configuring and managing power settings. This
update enhances the versatility and simplifies the power management of
PRTT1C devices while ensuring compatibility with connected Powered
Devices (PDs).

After applying this patch, the power delivery can be controlled from
user space with a patched [1] ethtool version using the following commands:
  ethtool --set-pse t1l2 podl-pse-admin-control enable
to enable power delivery, and
  ethtool --show-pse t1l2
to display the PoDL PSE settings.

By integrating PoDL PSE support into the PRTT1C devicetree, users can
benefit from streamlined power and data connections in their
deployments, improving overall system efficiency and reducing cabling
complexity.

[1] https://lore.kernel.org/all/20230317093024.1051999-1-o.rempel@pengutronix.de/

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 arch/arm/boot/dts/stm32mp151a-prtt1c.dts | 32 ++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm/boot/dts/stm32mp151a-prtt1c.dts b/arch/arm/boot/dts/stm32mp151a-prtt1c.dts
index 58bb05a8c685..ca0d3329cfd7 100644
--- a/arch/arm/boot/dts/stm32mp151a-prtt1c.dts
+++ b/arch/arm/boot/dts/stm32mp151a-prtt1c.dts
@@ -23,6 +23,18 @@ clock_sja1105: clock-sja1105 {
 		clock-frequency = <25000000>;
 	};
 
+	pse_t1l1: ethernet-pse-1 {
+		compatible = "podl-pse-regulator";
+		pse-supply = <&reg_t1l1>;
+		#pse-cells = <0>;
+	};
+
+	pse_t1l2: ethernet-pse-2 {
+		compatible = "podl-pse-regulator";
+		pse-supply = <&reg_t1l2>;
+		#pse-cells = <0>;
+	};
+
 	mdio0: mdio {
 		compatible = "virtual,mdio-gpio";
 		#address-cells = <1>;
@@ -32,6 +44,24 @@ mdio0: mdio {
 
 	};
 
+	reg_t1l1: regulator-pse-t1l1 {
+		compatible = "regulator-fixed";
+		regulator-name = "pse-t1l1";
+		regulator-min-microvolt = <12000000>;
+		regulator-max-microvolt = <12000000>;
+		gpio = <&gpiog 13 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+	};
+
+	reg_t1l2: regulator-pse-t1l2 {
+		compatible = "regulator-fixed";
+		regulator-name = "pse-t1l2";
+		regulator-min-microvolt = <12000000>;
+		regulator-max-microvolt = <12000000>;
+		gpio = <&gpiog 14 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+	};
+
 	wifi_pwrseq: wifi-pwrseq {
 		compatible = "mmc-pwrseq-simple";
 		reset-gpios = <&gpiod 8 GPIO_ACTIVE_LOW>;
@@ -92,6 +122,7 @@ t1l1_phy: ethernet-phy@7 {
 		reset-gpios = <&gpiog 12 GPIO_ACTIVE_LOW>;
 		reset-assert-us = <10>;
 		reset-deassert-us = <35>;
+		pses = <&pse_t1l1>;
 	};
 
 	/* TI DP83TD510E */
@@ -102,6 +133,7 @@ t1l2_phy: ethernet-phy@10 {
 		reset-gpios = <&gpiog 11 GPIO_ACTIVE_LOW>;
 		reset-assert-us = <10>;
 		reset-deassert-us = <35>;
+		pses = <&pse_t1l2>;
 	};
 
 	/* Micrel KSZ9031 */
-- 
2.30.2

