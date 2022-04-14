Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E32B500D49
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243210AbiDNM1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243193AbiDNM1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:27:15 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06ED2DD43;
        Thu, 14 Apr 2022 05:24:47 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2ACBB40002;
        Thu, 14 Apr 2022 12:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649939085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GW6fHP12CGCUnj3fBoY6K+7JAZmoGfpnGpnZe2LXKhs=;
        b=Ee5dVQLCwmatzyF91lmKjLw2a2jDivZ0p8D2V55PS6DQ7rDqN1npB+0V15AqSg1U/ltb0C
        gi9m9ETzVnPegosBKauQizQHiNZIHj9DvZr2fOAYPEupy8icb1+kjpuZbmCimknDRGlLKi
        2k/tE9u/3CNSObHDmhD40AFDdwaRK8umUl3WK+RfNtjCnshXsHaOzgjUu/tkjve5GnxxOA
        Zwiafn3JM7iWYLGo0+Ur1eafR6f+/Mm3wZ+XU45hMoEz/RtRUFVzYkB78vLs2WGCtfxjTh
        HjZ6a7a7owrF6up127ogvauEz/coJlUVpFaOW/F55+gtYXAzh3t6KhRP4I4DPA==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
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
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 03/12] dt-bindings: net: pcs: add bindings for Renesas RZ/N1 MII converter
Date:   Thu, 14 Apr 2022 14:22:41 +0200
Message-Id: <20220414122250.158113-4-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220414122250.158113-1-clement.leger@bootlin.com>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 .../bindings/net/pcs/renesas,rzn1-miic.yaml   | 95 +++++++++++++++++++
 include/dt-bindings/net/pcs-rzn1-miic.h       | 19 ++++
 2 files changed, 114 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
 create mode 100644 include/dt-bindings/net/pcs-rzn1-miic.h

diff --git a/Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml b/Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
new file mode 100644
index 000000000000..ccb25ce6cbde
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
@@ -0,0 +1,95 @@
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
+  compatible:
+      const: renesas,rzn1-miic
+
+  reg:
+    maxItems: 1
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+  clocks:
+    items:
+      - description: MII reference clock
+      - description: RGMII reference clock
+      - description: RMII reference clock
+      - description: AHB clock used for the MII converter register interface
+
+  renesas,miic-cfg-mode:
+    description: MII mux configuration mode. This value should use one of the
+                 value defined in dt-bindings/net/pcs-rzn1-miic.h.
+    $ref: /schemas/types.yaml#/definitions/uint32
+  
+patternProperties:
+  "^mii-conv@[0-4]$":
+    type: object
+    description: MII converter port
+
+    properties:
+      reg:
+        maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - renesas,miic-cfg-mode
+  - "#address-cells"
+  - "#size-cells"
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/net/pcs-rzn1-miic.h>
+    #include <dt-bindings/clock/r9a06g032-sysctrl.h>
+
+    eth-miic@44030000 {
+      compatible = "renesas,rzn1-miic";
+      #address-cells = <1>;
+      #size-cells = <0>;
+      reg = <0x44030000 0x10000>;
+      clocks = <&sysctrl R9A06G032_CLK_MII_REF>,
+              <&sysctrl R9A06G032_CLK_RGMII_REF>,
+              <&sysctrl R9A06G032_CLK_RMII_REF>,
+              <&sysctrl R9A06G032_HCLK_SWITCH_RG>;
+      renesas,miic-cfg-mode = <MIIC_MUX_MAC2_MAC1_SWD_SWC_SWB_SWA>;
+
+      mii_conv0: mii-conv@0 {
+        reg = <0>;
+      };
+
+      mii_conv1: mii-conv@1 {
+        reg = <1>;
+      };
+
+      mii_conv2: mii-conv@2 {
+        reg = <2>;
+      };
+
+      mii_conv3: mii-conv@3 {
+        reg = <3>;
+      };
+
+      mii_conv4: mii-conv@4 {
+        reg = <4>;
+      };
+    };
\ No newline at end of file
diff --git a/include/dt-bindings/net/pcs-rzn1-miic.h b/include/dt-bindings/net/pcs-rzn1-miic.h
new file mode 100644
index 000000000000..c5a0f382967b
--- /dev/null
+++ b/include/dt-bindings/net/pcs-rzn1-miic.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
+ * Ports to check the meaning of these values.
+ *
+ * [1] REN_r01uh0750ej0140-rzn1-introduction_MAT_20210228.pdf
+ */
+#define MIIC_MUX_MAC2_MAC1_SWD_SWC_SWB_SWA	0x13
+
+#endif
-- 
2.34.1

