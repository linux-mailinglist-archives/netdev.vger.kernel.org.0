Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D882619F02
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbiKDRmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiKDRmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:42:00 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85DD45EC5;
        Fri,  4 Nov 2022 10:41:58 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9DF38FF806;
        Fri,  4 Nov 2022 17:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667583717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VaqNhcCsyEJ16B0InYJGOoRmdP2AVgx3prsDz04/DPs=;
        b=dOvUd4KMYt0JtypuMUATyfgaHXv5q1W2lsfwvWb3q3Zd6lal1OpVL2OU9HCNXDJg8UpSU8
        ihhiDLEsBNOqfbYMhCpOYNp4ag6oEJf0kkNQF1G6M/HancA2Jjmjgv9jtHZX9LTjrZGgp1
        pRsslRjByYSB2C8u7FlpEZYLfmDPNHG1l539o7mMWjTs/OrS8/Nlw7bfbLX8KXSNjtRII8
        97KAcrOHtNAcpQela0gn6ZS7sIuS7A/fyl+6tsSepbggWuXJtQ7NWFy0V33naq+S31vkfl
        5Cg8m/79TQ1PFxmwYFzOQo2mNyXJAE9QnkkjmiawI0UY5RcjLi9+bC7/iv/4Ow==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH net-next v8 1/5] net: dt-bindings: Introduce the Qualcomm IPQESS Ethernet controller
Date:   Fri,  4 Nov 2022 18:41:47 +0100
Message-Id: <20221104174151.439008-2-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
References: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the DT binding for the IPQESS Ethernet Controller. This is a simple
controller, only requiring the phy-mode, interrupts, clocks, and
possibly a MAC address setting.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
V7->V8:
 - No changes
V6->V7:
 - Fixed a typo (firts -> first)
V5->V6:
 - Fixed the $id that used the wrong compatible
 - Force passing all the per-queue interrupts
V4->V5:
 - Remove stray quotes arount the ref property
 - Rename the binding to match the compatible string
V3->V4:
 - Fix a binding typo in the compatible string
V2->V3:
 - Cleanup on reset and clock names
V1->V2:
 - Fixed the example
 - Added reset and clocks
 - Removed generic ethernet attributes

 .../bindings/net/qcom,ipq4019-ess-edma.yaml   | 94 +++++++++++++++++++
 1 file changed, 94 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq4019-ess-edma.yaml

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-ess-edma.yaml b/Documentation/devicetree/bindings/net/qcom,ipq4019-ess-edma.yaml
new file mode 100644
index 000000000000..a16e707a4694
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qcom,ipq4019-ess-edma.yaml
@@ -0,0 +1,94 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/qcom,ipq4019-ess-edma.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm IPQ ESS EDMA Ethernet Controller
+
+maintainers:
+  - Maxime Chevallier <maxime.chevallier@bootlin.com>
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    const: qcom,ipq4019-ess-edma
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 32
+    description: One interrupt per tx and rx queue, the first 16 are rx queues
+                 and the last 16 are the tx queues
+
+  clocks:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - resets
+  - phy-mode
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/qcom,gcc-ipq4019.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    gmac: ethernet@c080000 {
+        compatible = "qcom,ipq4019-ess-edma";
+        reg = <0xc080000 0x8000>;
+        resets = <&gcc ESS_RESET>;
+        clocks = <&gcc GCC_ESS_CLK>;
+        interrupts = <GIC_SPI  65 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  66 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  67 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  68 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  69 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  70 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  71 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  72 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  73 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  74 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  75 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  76 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  77 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  78 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  79 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  80 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 240 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 241 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 242 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 243 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 244 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 245 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 246 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 247 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 248 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 249 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 250 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 251 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 252 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 253 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 254 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 255 IRQ_TYPE_EDGE_RISING>;
+
+        phy-mode = "internal";
+        fixed-link {
+            speed = <1000>;
+            full-duplex;
+            pause;
+        };
+    };
+
+...
-- 
2.37.3

