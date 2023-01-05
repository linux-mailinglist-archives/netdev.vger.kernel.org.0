Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446CE65E615
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 08:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjAEHaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 02:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjAEHaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 02:30:08 -0500
Received: from out29-201.mail.aliyun.com (out29-201.mail.aliyun.com [115.124.29.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A8453737;
        Wed,  4 Jan 2023 23:30:06 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08715363|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.219216-0.0011304-0.779654;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047212;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=17;RT=17;SR=0;TI=SMTPD_---.QktmAsD_1672903802;
Received: from sun-VirtualBox..(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.QktmAsD_1672903802)
          by smtp.aliyun-inc.com;
          Thu, 05 Jan 2023 15:30:03 +0800
From:   Frank <Frank.Sae@motor-comm.com>
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frank <Frank.Sae@motor-comm.com>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v1 1/3] dt-bindings: net: Add Motorcomm yt8xxx ethernet phy Driver bindings
Date:   Thu,  5 Jan 2023 15:30:22 +0800
Message-Id: <20230105073024.8390-2-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a YAML binding document for the Motorcom yt8xxx Ethernet phy driver.

Signed-off-by: Frank <Frank.Sae@motor-comm.com>
---
 .../bindings/net/motorcomm,yt8xxx.yaml        | 180 ++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
 MAINTAINERS                                   |   1 +
 3 files changed, 183 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml

diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
new file mode 100644
index 000000000000..337a562d864c
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
@@ -0,0 +1,180 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/motorcomm,yt8xxx.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MotorComm yt8xxx Ethernet PHY
+
+maintainers:
+  - frank <frank.sae@motor-comm.com>
+
+description: |
+  Bindings for MotorComm yt8xxx PHYs.
+  yt8511 will be supported later.
+
+allOf:
+  - $ref: ethernet-phy.yaml#
+
+properties:
+  motorcomm,clk-out-frequency:
+    description: clock output in Hertz on clock output pin.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [0, 25000000, 125000000]
+    default: 0
+
+  motorcomm,rx-delay-basic:
+    description: |
+      Tristate, setup the basic RGMII RX Clock delay of PHY.
+      This basic delay is fixed at 2ns (1000Mbps) or 8ns (100Mbps、10Mbps).
+      This basic delay usually auto set by hardware according to the voltage
+      of RXD0 pin (low = 0, turn off;   high = 1, turn on).
+      If not exist, this delay is controlled by hardware.
+      0: turn off;   1: turn on.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [0, 1]
+
+  motorcomm,rx-delay-additional-ps:
+    description: |
+      Setup the additional RGMII RX Clock delay of PHY defined in pico seconds.
+      RGMII RX Clock Delay = rx-delay-basic + rx-delay-additional-ps.
+    enum:
+      - 0
+      - 150
+      - 300
+      - 450
+      - 600
+      - 750
+      - 900
+      - 1050
+      - 1200
+      - 1350
+      - 1500
+      - 1650
+      - 1800
+      - 1950
+      - 2100
+      - 2250
+
+  motorcomm,tx-delay-ge-ps:
+    description: |
+      Setup PHY's RGMII TX Clock delay defined in pico seconds when the speed
+      is 1000Mbps.
+    enum:
+      - 0
+      - 150
+      - 300
+      - 450
+      - 600
+      - 750
+      - 900
+      - 1050
+      - 1200
+      - 1350
+      - 1500
+      - 1650
+      - 1800
+      - 1950
+      - 2100
+      - 2250
+
+  motorcomm,tx-delay-fe-ps:
+    description: |
+      Setup PHY's RGMII TX Clock delay  defined in pico seconds when the speed
+      is 100Mbps or 10Mbps.
+    enum:
+      - 0
+      - 150
+      - 300
+      - 450
+      - 600
+      - 750
+      - 900
+      - 1050
+      - 1200
+      - 1350
+      - 1500
+      - 1650
+      - 1800
+      - 1950
+      - 2100
+      - 2250
+
+  motorcomm,keep-pll-enabled:
+    description: |
+      If set, keep the PLL enabled even if there is no link. Useful if you
+      want to use the clock output without an ethernet link.
+    type: boolean
+
+  motorcomm,auto-sleep-disabled:
+    description: |
+      If set, PHY will not enter sleep mode and close AFE after unplug cable
+      for a timer.
+    type: boolean
+
+  motorcomm,tx-clk-adj-enabled:
+    description: |
+      Useful if you want to use tx-clk-xxxx-inverted to adj the delay of tx clk.
+    type: boolean
+
+  motorcomm,tx-clk-10-inverted:
+    description: |
+      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
+      Transmit PHY Clock delay train configuration when speed is 10Mbps.
+    type: boolean
+
+  motorcomm,tx-clk-100-inverted:
+    description: |
+      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
+      Transmit PHY Clock delay train configuration when speed is 100Mbps.
+    type: boolean
+
+  motorcomm,tx-clk-1000-inverted:
+    description: |
+      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
+      Transmit PHY Clock delay train configuration when speed is 1000Mbps.
+    type: boolean
+
+  motorcomm,sds-tx-amplitude:
+    description: |
+      Setup the tx driver amplitude control of SerDes. Higher amplitude is
+      helpful for long distance.
+      0: low;   1: middle;   2: high.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [0, 1, 2]
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    ethernet {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        ethernet-phy@5 {
+            reg = <5>;
+
+            motorcomm,clk-out-frequency = <0>;
+            #motorcomm,rx-delay-basic = <1>;
+            motorcomm,rx-delay-additional-ps = <0>;
+            motorcomm,tx-delay-fe-ps = <2250>;
+            motorcomm,tx-delay-ge-ps = <150>;
+
+            motorcomm,keep-pll-enabled;
+            motorcomm,auto-sleep-disabled;
+            motorcomm,sds-tx-amplitude = <1>;
+        };
+    };
+  - |
+    ethernet {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        phy-mode = "rgmii-id";
+        ethernet-phy@5 {
+            reg = <5>;
+
+            motorcomm,clk-out-frequency = <125000000>;
+
+            motorcomm,keep-pll-enabled;
+            motorcomm,auto-sleep-disabled;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 70ffb3780621..8d19157e85b7 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -845,6 +845,8 @@ patternProperties:
     description: Moortec Semiconductor Ltd.
   "^mosaixtech,.*":
     description: Mosaix Technologies, Inc.
+  "^motorcomm,.*":
+    description: MotorComm, Inc.
   "^motorola,.*":
     description: Motorola, Inc.
   "^moxa,.*":
diff --git a/MAINTAINERS b/MAINTAINERS
index 7f0b7181e60a..a1e714980154 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14161,6 +14161,7 @@ M:	Peter Geis <pgwipeout@gmail.com>
 M:	Frank <Frank.Sae@motor-comm.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
 F:	drivers/net/phy/motorcomm.c
 
 MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
-- 
2.34.1

