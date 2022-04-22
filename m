Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD84050BF9C
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 20:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbiDVSMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 14:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237303AbiDVSGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 14:06:49 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1E1B245E;
        Fri, 22 Apr 2022 11:03:52 -0700 (PDT)
Received: from relay2-d.mail.gandi.net (unknown [217.70.183.194])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 15A6BC49D4;
        Fri, 22 Apr 2022 18:03:38 +0000 (UTC)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C57784000D;
        Fri, 22 Apr 2022 18:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650650596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=loZEYdhbLh05kEj+SfWEXqAWNslES1rqU6WiBkJyWCY=;
        b=gZ54Xw4E2YxcgCYuiYoziAzsNShsmCvxhLBDcJS/IPRFtpDGScixLyGE5bPV81RpT3tRnA
        einY2FJMJWcGEk9Z9vcDo/p1zXilfwgsUsLMaCOVQ/oDwIyVwaB1ylEwjotH0viwFqiesW
        urZoDNZaOmOKdEe/hoT+bJBRw2WYd0K8zwku1gd2hCFBIjG/ADjnYiTTM7cJV7W2N6HSZy
        mVBbH1ccb5kgJAjfoDxDoRvRxxtk/RxuVA4aaI2Oxqq4IXfNWdAQKW2lLgVJOWuTn2Mxnd
        /yvmXqhonKr6iNbKZMYtK0dwn+xkw5I3S9KYG4U1gygJfRzwKOxXNwOfmwKYYQ==
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
Subject: [PATCH net-next 4/5] net: dt-bindings: Introduce the Qualcomm IPQESS Ethernet controller
Date:   Fri, 22 Apr 2022 20:03:04 +0200
Message-Id: <20220422180305.301882-5-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220422180305.301882-1-maxime.chevallier@bootlin.com>
References: <20220422180305.301882-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the DT binding for the IPQESS Ethernet Controller. This is a simple
controller, only requiring the phy-mode, interrupts, clocks, and
possibly a MAC address setting.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 .../devicetree/bindings/net/qcom,ipqess.yaml  | 94 +++++++++++++++++++
 1 file changed, 94 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipqess.yaml

diff --git a/Documentation/devicetree/bindings/net/qcom,ipqess.yaml b/Documentation/devicetree/bindings/net/qcom,ipqess.yaml
new file mode 100644
index 000000000000..8fec5633692f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qcom,ipqess.yaml
@@ -0,0 +1,94 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/qcom,ipqess.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm IPQ ESS EDMA Ethernet Controller Device Tree Bindings
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+maintainers:
+  - Maxime Chevallier <maxime.chevallier@bootlin.com>
+
+properties:
+  compatible:
+    const: qcom,ipq4019e-ess-edma
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    minItems: 2
+    maxItems: 32
+    description: One interrupt per tx and rx queue, with up to 16 queues.
+
+  clocks:
+    maxItems: 1
+
+  phy-mode: true
+
+  fixed-link: true
+
+  mac-address: true
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - phy-mode
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    gmac: ethernet@c080000 {
+        compatible = "qcom,ipq4019-ess-edma";
+        reg = <0xc080000 0x8000>;
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
+        status = "okay";
+
+        phy-mode = "internal";
+        fixed-link {
+            speed = <1000>;
+            full-duplex;
+            pause;
+            asym-pause;
+        };
+    };
+
+...
-- 
2.35.1

