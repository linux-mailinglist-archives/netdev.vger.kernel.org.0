Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5EC64E77C
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 08:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiLPHFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 02:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiLPHFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 02:05:47 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF7A13F5D;
        Thu, 15 Dec 2022 23:05:43 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 9958224E205;
        Fri, 16 Dec 2022 15:05:42 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 16 Dec
 2022 15:05:42 +0800
Received: from wyh-VirtualBox.starfivetech.com (171.223.208.138) by
 EXMBX173.cuchost.com (172.16.6.93) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Fri, 16 Dec 2022 15:05:41 +0800
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
Subject: [PATCH v2 5/9] dt-bindings: net: motorcomm: add support for Motorcomm YT8531
Date:   Fri, 16 Dec 2022 15:06:28 +0800
Message-ID: <20221216070632.11444-6-yanhong.wang@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
References: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Motorcomm Technology YT8531 10/100/1000 Ethernet PHY.
The document describe details of clock delay train configuration.

Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
---
 .../bindings/net/motorcomm,yt8531.yaml        | 111 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 2 files changed, 112 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8531.yaml

diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8531.yaml b/Documentation/devicetree/bindings/net/motorcomm,yt8531.yaml
new file mode 100644
index 000000000000..c5b8a09a78bb
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/motorcomm,yt8531.yaml
@@ -0,0 +1,111 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/motorcomm,yt8531.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Motorcomm YT8531 Gigabit Ethernet PHY
+
+maintainers:
+  - Yanhong Wang <yanhong.wang@starfivetech.com>
+
+select:
+  properties:
+    $nodename:
+      pattern: "^ethernet-phy(@[a-f0-9]+)?$"
+
+  required:
+    - $nodename
+
+properties:
+  $nodename:
+    pattern: "^ethernet-phy(@[a-f0-9]+)?$"
+
+  reg:
+    minimum: 0
+    maximum: 31
+    description:
+      The ID number for the PHY.
+
+  rxc_dly_en:
+    description: |
+      RGMII Receive PHY Clock Delay defined with fixed 2ns.This is used for
+      PHY that have configurable RX internal delays. If this property set
+      to 1, then automatically add 2ns delay pad for Receive PHY clock.
+    enum: [0, 1]
+    default: 0
+
+  rx_delay_sel:
+    description: |
+      This is supplement to rxc_dly_en property,and it can
+      be specified in 150ps(pico seconds) steps. The effective
+      delay is: 150ps * N.
+    minimum: 0
+    maximum: 15
+    default: 0
+
+  tx_delay_sel_fe:
+    description: |
+      RGMII Transmit PHY Clock Delay defined in pico seconds.This is used for
+      PHY's that have configurable TX internal delays when speed is 100Mbps
+      or 10Mbps. It can be specified in 150ps steps, the effective delay
+      is: 150ps * N.
+    minimum: 0
+    maximum: 15
+    default: 15
+
+  tx_delay_sel:
+    description: |
+      RGMII Transmit PHY Clock Delay defined in pico seconds.This is used for
+      PHY's that have configurable TX internal delays when speed is 1000Mbps.
+      It can be specified in 150ps steps, the effective delay is: 150ps * N.
+    minimum: 0
+    maximum: 15
+    default: 1
+
+  tx_inverted_10:
+    description: |
+      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
+      Transmit PHY Clock delay train configuration when speed is 10Mbps.
+      0: original   1: inverted
+    enum: [0, 1]
+    default: 0
+
+  tx_inverted_100:
+    description: |
+      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
+      Transmit PHY Clock delay train configuration when speed is 100Mbps.
+      0: original   1: inverted
+    enum: [0, 1]
+    default: 0
+
+  tx_inverted_1000:
+    description: |
+      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
+      Transmit PHY Clock delay train configuration when speed is 1000Mbps.
+      0: original   1: inverted
+    enum: [0, 1]
+    default: 0
+
+required:
+  - reg
+
+additionalProperties: true
+
+examples:
+  - |
+    ethernet {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet-phy@0 {
+            reg = <0>;
+
+            rxc_dly_en = <1>;
+            tx_delay_sel_fe = <5>;
+            tx_delay_sel = <0xa>;
+            tx_inverted_10 = <0x1>;
+            tx_inverted_100 = <0x1>;
+            tx_inverted_1000 = <0x1>;
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 166b0009f63c..1ff68b8524d2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19609,6 +19609,7 @@ F:	include/dt-bindings/clock/starfive*
 STARFIVE DWMAC GLUE LAYER
 M:	Yanhong Wang <yanhong.wang@starfivetech.com>
 S:	Maintained
+F:	Documentation/devicetree/bindings/net/motorcomm,yt8531.yaml
 F:	Documentation/devicetree/bindings/net/starfive,jh71x0-dwmac.yaml
 
 STARFIVE PINCTRL DRIVER
-- 
2.17.1

