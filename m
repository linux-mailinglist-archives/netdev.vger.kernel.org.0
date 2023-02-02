Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2BB68738A
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 04:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjBBDBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 22:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbjBBDBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 22:01:15 -0500
Received: from out28-101.mail.aliyun.com (out28-101.mail.aliyun.com [115.124.28.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56FD2123;
        Wed,  1 Feb 2023 19:01:04 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1776185|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0641746-0.000645032-0.93518;FP=7524860484847228407|1|1|10|0|-1|-1|-1;HT=ay29a033018047199;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=18;RT=18;SR=0;TI=SMTPD_---.R7sRqa-_1675306859;
Received: from sun-VirtualBox..(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.R7sRqa-_1675306859)
          by smtp.aliyun-inc.com;
          Thu, 02 Feb 2023 11:01:00 +0800
From:   Frank Sae <Frank.Sae@motor-comm.com>
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        yanhong.wang@starfivetech.com
Cc:     xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frank <Frank.Sae@motor-comm.com>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v5 1/5] dt-bindings: net: Add Motorcomm yt8xxx ethernet phy
Date:   Thu,  2 Feb 2023 11:00:33 +0800
Message-Id: <20230202030037.9075-2-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202030037.9075-1-Frank.Sae@motor-comm.com>
References: <20230202030037.9075-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Add a YAML binding document for the Motorcomm yt8xxx Ethernet phy.
 
Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>
---
 .../bindings/net/motorcomm,yt8xxx.yaml        | 117 ++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
 MAINTAINERS                                   |   1 +
 3 files changed, 120 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml

diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
new file mode 100644
index 000000000000..157e3bbcaf6f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
@@ -0,0 +1,117 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/motorcomm,yt8xxx.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MotorComm yt8xxx Ethernet PHY
+
+maintainers:
+  - Frank Sae <frank.sae@motor-comm.com>
+
+allOf:
+  - $ref: ethernet-phy.yaml#
+
+properties:
+  compatible:
+    enum:
+      - ethernet-phy-id4f51.e91a
+      - ethernet-phy-id4f51.e91b
+
+  rx-internal-delay-ps:
+    description: |
+      RGMII RX Clock Delay used only when PHY operates in RGMII mode with
+      internal delay (phy-mode is 'rgmii-id' or 'rgmii-rxid') in pico-seconds.
+    enum: [ 0, 150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500, 1650,
+            1800, 1900, 1950, 2050, 2100, 2200, 2250, 2350, 2500, 2650, 2800,
+            2950, 3100, 3250, 3400, 3550, 3700, 3850, 4000, 4150 ]
+    default: 1950
+
+  tx-internal-delay-ps:
+    description: |
+      RGMII TX Clock Delay used only when PHY operates in RGMII mode with
+      internal delay (phy-mode is 'rgmii-id' or 'rgmii-txid') in pico-seconds.
+    enum: [ 0, 150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500, 1650, 1800,
+            1950, 2100, 2250 ]
+    default: 1950
+
+  motorcomm,clk-out-frequency-hz:
+    description: clock output on clock output pin.
+    enum: [0, 25000000, 125000000]
+    default: 0
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
+      This configuration is mainly to adapt to VF2 with JH7110 SoC.
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
+unevaluatedProperties: false
+
+examples:
+  - |
+    mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        phy-mode = "rgmii-id";
+        ethernet-phy@4 {
+            /*  Only needed to make DT lint tools work. Do not copy/paste
+             *  into real DTS files.
+             */
+            compatible = "ethernet-phy-id4f51.e91a";
+
+            reg = <4>;
+            rx-internal-delay-ps = <2100>;
+            tx-internal-delay-ps = <150>;
+            motorcomm,clk-out-frequency-hz = <0>;
+            motorcomm,keep-pll-enabled;
+            motorcomm,auto-sleep-disabled;
+        };
+    };
+  - |
+    mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        phy-mode = "rgmii";
+        ethernet-phy@5 {
+            /*  Only needed to make DT lint tools work. Do not copy/paste
+             *  into real DTS files.
+             */
+            compatible = "ethernet-phy-id4f51.e91a";
+
+            reg = <5>;
+            motorcomm,clk-out-frequency-hz = <125000000>;
+            motorcomm,keep-pll-enabled;
+            motorcomm,auto-sleep-disabled;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 161766b1de50..99bb8594753c 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -847,6 +847,8 @@ patternProperties:
     description: Moortec Semiconductor Ltd.
   "^mosaixtech,.*":
     description: Mosaix Technologies, Inc.
+  "^motorcomm,.*":
+    description: MotorComm, Inc.
   "^motorola,.*":
     description: Motorola, Inc.
   "^moxa,.*":
diff --git a/MAINTAINERS b/MAINTAINERS
index 8cdba0580cb8..1da8c3b52108 100644
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

