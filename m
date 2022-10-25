Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFB660CDFA
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 15:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiJYNw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 09:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbiJYNw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 09:52:57 -0400
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EB510EA37;
        Tue, 25 Oct 2022 06:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1666705976;
  x=1698241976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rZHmFgjcazxqwtYJzLa034yI7Wo6fNrsnbUI/2ByXLQ=;
  b=oRIF3L3PZe/d1n+ZRsvttgJISWfIYUGzs0Qm2BJ1AkTrutcr8bF8i/ei
   ud25nGS800xji7JSC9TTvBUb/SWdE4vT80JVSa/IGHp6NlzjP1IN/BJq8
   4T52KJchD9GRRIlZlsoOu15Zdu1WdB1jRpvpSVSCHEEUS0+bJAeWD9NHk
   qC1v3ef5+74PJ9kq3sVURZxr1mCVncLU1toWnuleNzI8VZvODgN4tjLtZ
   P/fRsMkvb+Os5livge6FwwXlMChC3hEyXiqHuvNj68DnqMmdFBt5yJ6fZ
   ouON2RFayNZA1ttBA5ocVVm6O59WPltbkfLjUZbcubFIi9EES89jWk7lR
   w==;
From:   Camel Guo <camel.guo@axis.com>
To:     Andrew Lunn <andrew@lunn.ch>, Camel Guo <camel.guo@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Rob Herring <robh@kernel.org>,
        <kernel@axis.com>
Subject: [RFC net-next 1/2] dt-bindings: net: dsa: add bindings for GSW Series switches
Date:   Tue, 25 Oct 2022 15:52:40 +0200
Message-ID: <20221025135243.4038706-2-camel.guo@axis.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221025135243.4038706-1-camel.guo@axis.com>
References: <20221025135243.4038706-1-camel.guo@axis.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,TO_EQ_FM_DIRECT_MX,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation and an example for Maxlinear's GSW Series Ethernet
switches.

Signed-off-by: Camel Guo <camel.guo@axis.com>
---
 .../devicetree/bindings/net/dsa/mxl,gsw.yaml  | 140 ++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
 MAINTAINERS                                   |   6 +
 3 files changed, 148 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml b/Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml
new file mode 100644
index 000000000000..8e124b7ec58c
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml
@@ -0,0 +1,140 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/mxl,gsw.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Maxlinear GSW Series Switch Device Tree Bindings
+
+allOf:
+  - $ref: dsa.yaml#
+
+maintainers:
+  - Camel Guo <camel.guo@axis.com>
+
+description:
+  The Maxlinear's GSW Series Ethernet Switch is a highly integrated, low-power,
+  non-blocking Gigabit Ethernet Switch.
+
+properties:
+  compatible:
+    oneOf:
+      - enum:
+          - mxl,gsw145-mdio
+
+  reg:
+    maxItems: 1
+
+  mdio:
+    type: object
+
+    description:
+      Container of ethernet phy devices on the MDIO bus of GSW switch
+
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    allOf:
+      - $ref: "http://devicetree.org/schemas/net/ethernet-phy.yaml#"
+
+required:
+  - compatible
+  - reg
+  - mdio
+
+additionalProperties: true
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+
+    mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        switch@0 {
+            compatible = "mxl,gsw145-mdio";
+            #address-cells = <1>;
+            #size-cells = <0>;
+            reg = <0x0>;
+
+            ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                    reg = <0>;
+                    label = "lan0";
+                    phy-mode = "internal";
+                    phy-handle = <&phy0>;
+                };
+
+                port@1 {
+                    reg = <1>;
+                    label = "lan1";
+                    phy-mode = "internal";
+                    phy-handle = <&phy1>;
+                };
+
+                port@2 {
+                    reg = <2>;
+                    label = "lan2";
+                    phy-mode = "internal";
+                    phy-handle = <&phy2>;
+                    status = "disabled";
+                };
+
+                port@3 {
+                    reg = <3>;
+                    label = "lan3";
+                    phy-mode = "internal";
+                    phy-handle = <&phy3>;
+                    status = "disabled";
+                };
+
+                port@4 {
+                    reg = <4>;
+                    label = "lan4";
+                    phy-mode = "sgmii";
+                    status = "disabled";
+                };
+
+                port@5 {
+                    reg = <5>;
+                    label = "cpu";
+                    ethernet = <&eth0>;
+                    phy-mode = "rgmii-id";
+
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                        pause;
+                    };
+                };
+            };
+
+            mdio {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                phy0: ethernet-phy@0 {
+                    reg = <0>;
+                };
+
+                phy1: ethernet-phy@1 {
+                    reg = <1>;
+                };
+
+                phy2: ethernet-phy@2 {
+                    reg = <2>;
+                };
+
+                phy3: ethernet-phy@3 {
+                    reg = <3>;
+                };
+            };
+        };
+    };
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 6e323a380294..1d209115692c 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -863,6 +863,8 @@ patternProperties:
     deprecated: true
   "^mxicy,.*":
     description: Macronix International Co., Ltd.
+  "^mxl,.*":
+    description: MaxLinear, Inc.
   "^myir,.*":
     description: MYIR Tech Limited
   "^national,.*":
diff --git a/MAINTAINERS b/MAINTAINERS
index 657b223ed6b0..df88faabdb53 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12585,6 +12585,12 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/phy/mxl-gpy.c
 
+MAXLINEAR GSW1XX SERIES ETHERNET SWITCH DRIVER
+M:	Camel Guo <camel.guo@axis.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml
+
 MCBA MICROCHIP CAN BUS ANALYZER TOOL DRIVER
 R:	Yasushi SHOJI <yashi@spacecubics.com>
 L:	linux-can@vger.kernel.org
-- 
2.30.2

