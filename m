Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD21B51FE00
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbiEINYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235590AbiEINY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:24:28 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839192B1647;
        Mon,  9 May 2022 06:20:31 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3AF49240008;
        Mon,  9 May 2022 13:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652102430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5TqukQDustwopZChQ9uAX4m82W6G6iDDmCRkcXYQ+YY=;
        b=Lyhw80ALp8nS93sRwsPmNowKYtgteCgBTc/mpoeNvrO+mdu4rcH8qcmrv2a0xdK+HxXc/f
        lvwYc7hj6M/fU1hDDUm3Sv24Uqru6OTHxASw4zENPKe1AgoiLnlmv6ufGvmIUKDxyRj6f3
        TH04bHiPkcGEqQpfz64FRsV0fz94xvGYqXxrkGnIB1LxlnYywN+oKeICrIv2Dr2S+LgAvw
        Xj3xQTsX0VcPl5MYJP4Q6zVSvSd+gpNRsAPdo9h76yhv0ODZMR9Dh2lEXsuyRCjRRfBIko
        TktLdoziVQPVIAQM1cM03J+TkgtCGu9qrk5WSXTeyL9VCV801q/szbQHBYb5pw==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v4 03/12] dt-bindings: net: pcs: add bindings for Renesas RZ/N1 MII converter
Date:   Mon,  9 May 2022 15:18:51 +0200
Message-Id: <20220509131900.7840-4-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220509131900.7840-1-clement.leger@bootlin.com>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

This MII converter can be found on the RZ/N1 processor family. The MII
converter ports are declared as subnodes which are then referenced by
users of the PCS driver such as the switch.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 .../bindings/net/pcs/renesas,rzn1-miic.yaml   | 162 ++++++++++++++++++
 include/dt-bindings/net/pcs-rzn1-miic.h       |  33 ++++
 2 files changed, 195 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
 create mode 100644 include/dt-bindings/net/pcs-rzn1-miic.h

diff --git a/Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml b/Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
new file mode 100644
index 000000000000..c3f5f772c885
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
@@ -0,0 +1,162 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/pcs/renesas,rzn1-miic.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Renesas RZ/N1 MII converter
+
+maintainers:
+  - Clément Léger <clement.leger@bootlin.com>
+
+description: |
+  This MII converter is present on the Renesas RZ/N1 SoC family. It is
+  responsible to do MII passthrough or convert it to RMII/RGMII.
+
+properties:
+  '#address-cells':
+    const: 1
+
+  '#size-cells':
+    const: 0
+
+  compatible:
+    items:
+      - enum:
+          - renesas,r9a06g032-miic
+      - const: renesas,rzn1-miic
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: MII reference clock
+      - description: RGMII reference clock
+      - description: RMII reference clock
+      - description: AHB clock used for the MII converter register interface
+
+  renesas,miic-switch-portin:
+    description: MII Switch PORTIN configuration. This value should use one of
+      the values defined in dt-bindings/net/pcs-rzn1-miic.h.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [1, 2]
+
+  power-domains:
+    maxItems: 1
+
+patternProperties:
+  "^mii-conv@[0-9]+$":
+    type: object
+    description: MII converter port
+
+    properties:
+      reg:
+        description: MII Converter port number.
+        enum: [1, 2, 3, 4, 5]
+
+      renesas,miic-input:
+        description: Converter input port configuration. This value should use
+          one of the values defined in dt-bindings/net/pcs-rzn1-miic.h.
+        $ref: /schemas/types.yaml#/definitions/uint32
+
+    required:
+      - reg
+      - renesas,miic-input
+
+    additionalProperties: false
+
+    allOf:
+      - if:
+          properties:
+            reg:
+              const: 1
+        then:
+          properties:
+            renesas,miic-input:
+              enum: [0]
+      - if:
+          properties:
+            reg:
+              const: 2
+        then:
+          properties:
+            renesas,miic-input:
+              enum: [1, 11]
+      - if:
+          properties:
+            reg:
+              const: 3
+        then:
+          properties:
+            renesas,miic-input:
+              enum: [7, 10]
+      - if:
+          properties:
+            reg:
+              const: 4
+        then:
+          properties:
+            renesas,miic-input:
+              enum: [4, 6, 9, 13]
+      - if:
+          properties:
+            reg:
+              const: 5
+        then:
+          properties:
+            renesas,miic-input:
+              enum: [3, 5, 8, 12]
+
+required:
+  - '#address-cells'
+  - '#size-cells'
+  - compatible
+  - reg
+  - clocks
+  - power-domains
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/net/pcs-rzn1-miic.h>
+    #include <dt-bindings/clock/r9a06g032-sysctrl.h>
+
+    eth-miic@44030000 {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      compatible = "renesas,r9a06g032-miic", "renesas,rzn1-miic";
+      reg = <0x44030000 0x10000>;
+      clocks = <&sysctrl R9A06G032_CLK_MII_REF>,
+              <&sysctrl R9A06G032_CLK_RGMII_REF>,
+              <&sysctrl R9A06G032_CLK_RMII_REF>,
+              <&sysctrl R9A06G032_HCLK_SWITCH_RG>;
+      renesas,miic-switch-portin = <MIIC_GMAC2_PORT>;
+      power-domains = <&sysctrl>;
+
+      mii_conv1: mii-conv@1 {
+        renesas,miic-input = <MIIC_GMAC1_PORT>;
+        reg = <1>;
+      };
+
+      mii_conv2: mii-conv@2 {
+        renesas,miic-input = <MIIC_SWITCH_PORTD>;
+        reg = <2>;
+      };
+
+      mii_conv3: mii-conv@3 {
+        renesas,miic-input = <MIIC_SWITCH_PORTC>;
+        reg = <3>;
+      };
+
+      mii_conv4: mii-conv@4 {
+        renesas,miic-input = <MIIC_SWITCH_PORTB>;
+        reg = <4>;
+      };
+
+      mii_conv5: mii-conv@5 {
+        renesas,miic-input = <MIIC_SWITCH_PORTA>;
+        reg = <5>;
+      };
+    };
diff --git a/include/dt-bindings/net/pcs-rzn1-miic.h b/include/dt-bindings/net/pcs-rzn1-miic.h
new file mode 100644
index 000000000000..784782eaec9e
--- /dev/null
+++ b/include/dt-bindings/net/pcs-rzn1-miic.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+/*
+ * Copyright (C) 2022 Schneider-Electric
+ *
+ * Clément Léger <clement.leger@bootlin.com>
+ */
+
+#ifndef _DT_BINDINGS_PCS_RZN1_MIIC
+#define _DT_BINDINGS_PCS_RZN1_MIIC
+
+/*
+ * Reefer to the datasheet [1] section 8.2.1, Internal Connection of Ethernet
+ * Ports to check the available combination
+ *
+ * [1] REN_r01uh0750ej0140-rzn1-introduction_MAT_20210228.pdf
+ */
+
+#define MIIC_GMAC1_PORT			0
+#define MIIC_GMAC2_PORT			1
+#define MIIC_RTOS_PORT			2
+#define MIIC_SERCOS_PORTA		3
+#define MIIC_SERCOS_PORTB		4
+#define MIIC_ETHERCAT_PORTA		5
+#define MIIC_ETHERCAT_PORTB		6
+#define MIIC_ETHERCAT_PORTC		7
+#define MIIC_SWITCH_PORTA		8
+#define MIIC_SWITCH_PORTB		9
+#define MIIC_SWITCH_PORTC		10
+#define MIIC_SWITCH_PORTD		11
+#define MIIC_HSR_PORTA			12
+#define MIIC_HSR_PORTB			13
+
+#endif
-- 
2.36.0

