Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF4A527275
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 17:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbiENPHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 11:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiENPHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 11:07:36 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18529BCA9;
        Sat, 14 May 2022 08:07:10 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E632AC0014;
        Sat, 14 May 2022 15:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652540829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oioTQWxtec+lTDMdLAC/e7vnn3p17HifwpG1OTnINv4=;
        b=AcgJ09xZ4e+zg7/UmOi0sFyCRaSdje5F0p8i1vR0nMZXkUsc1hrpzCBlrgQin7zodGmfNZ
        aTLoYQZ7Yba8rJrNiebFwg6t5+YH2rTM4HhH5sBCnTyBSIz0fctZYBFLbhdWyv2op3ah3b
        I9NrHXJp93o9cgpk/nwqPqgMFY3MxluYkhUWWWQNcm8SPCCP5LUpmx5YENva3W8xOgsJNz
        txhZsJHbsr1tIXFoT+0ukCmwzPy7GE+7fcdllhLgK0JMnStAl/PDy1EV+ZmVKrtUeojQFZ
        nsfUyvi8sZS/5KEDzonLXmasWbF2yv1ev2VkIC2CQZDjhtDmaH8ANh/BM4vIdg==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH net-next v2 5/5] ARM: dts: qcom: ipq4019: Add description for the IPQESS Ethernet controller
Date:   Sat, 14 May 2022 17:06:56 +0200
Message-Id: <20220514150656.122108-6-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Qualcomm IPQ4019 includes an internal 5 ports switch, which is
connected to the CPU through the internal IPQESS Ethernet controller.

This commit adds support for this internal interface, which is
internally connected to a modified version of the QCA8K Ethernet switch.

This Ethernet controller only support a specific internal interface mode
for connection to the switch.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V1->V2:
 - Added clock and resets

 arch/arm/boot/dts/qcom-ipq4019.dtsi | 46 +++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
index cac92dde040f..1afabee37fc6 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -38,6 +38,7 @@ aliases {
 		spi1 = &blsp1_spi2;
 		i2c0 = &blsp1_i2c3;
 		i2c1 = &blsp1_i2c4;
+		ethernet0 = &gmac;
 	};
 
 	cpus {
@@ -668,6 +669,51 @@ swport5: port@5 { /* MAC5 */
 			};
 		};
 
+		gmac: ethernet@c080000 {
+			compatible = "qcom,ipq4019-ess-edma";
+			reg = <0xc080000 0x8000>;
+			resets = <&gcc ESS_RESET>;
+			reset-names = "ess";
+			clocks = <&gcc GCC_ESS_CLK>;
+			clock-names = "ess";
+			interrupts = <GIC_SPI  65 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  66 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  67 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  68 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  69 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  70 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  71 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  72 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  73 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  74 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  75 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  76 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  77 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  78 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  79 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  80 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 240 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 241 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 242 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 243 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 244 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 245 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 246 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 247 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 248 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 249 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 250 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 251 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 252 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 253 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 254 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 255 IRQ_TYPE_EDGE_RISING>;
+
+			status = "disabled";
+
+			phy-mode = "internal";
+		};
+
 		mdio: mdio@90000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.36.1

