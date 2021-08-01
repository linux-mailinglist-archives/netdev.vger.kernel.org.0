Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC063DCAA7
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 09:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhHAHxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 03:53:39 -0400
Received: from smtp-32.italiaonline.it ([213.209.10.32]:54075 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230384AbhHAHxh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Aug 2021 03:53:37 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([82.60.87.158])
        by smtp-32.iol.local with ESMTPA
        id A6Hkmg1OnPvRTA6Homr9aK; Sun, 01 Aug 2021 09:53:29 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1627804409; bh=qt4FEE3brlR/uksNPiuCgHR6+AlPK42DviVypi6/vjw=;
        h=From;
        b=URgl4IT+wSJhS1cwkEQdxMLGn4ZAggw4LLUMdBZJg1yL7Q8u5nbqux+gvJRWrydoM
         7tdlDN+DlAdMTLSyfoBJ9605uHVruXW0hKqNj8N5TPjSBldjdkHbc7+ILOb8tndt4D
         Do8lGwxWP9Y17uCql3TT4bzWpqCiQ+4nMLHT+wqJlRpsFA5nOABYXUQKg9+jvHNkNi
         LNWlSF5yrLkdg4i14HsoSdV9VdZpmzx8c6czDyxdho8UMRgsLptbu/8IH37tCbSlhO
         2t1tSkuf3xVnhdfViUYrX9NWDigZrP29iNLsOEuTmRrOyqEb2KL5AmfQUAFaOzeCIy
         sjc4zMY+XuQog==
X-CNFS-Analysis: v=2.4 cv=NqgUz+RJ c=1 sm=1 tr=0 ts=610652f9 cx=a_exe
 a=Hc/BMeSBGyun2kpB8NmEvQ==:117 a=Hc/BMeSBGyun2kpB8NmEvQ==:17 a=gEfo2CItAAAA:8
 a=p_hF36_8n4bHhE57Z5sA:9 a=ze7PrmZgi6OtnpWq:21 a=-WPxczYJxTHMubw5:21
 a=sptkURWiP4Gy88Gu7hUp:22
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v4] dt-bindings: net: can: c_can: convert to json-schema
Date:   Sun,  1 Aug 2021 09:53:22 +0200
Message-Id: <20210801075322.30269-1-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
X-CMAE-Envelope: MS4xfOTeqYMyrK11azOIlp/p7KrRZi4IoGq/hiTgPDPwX+FuGrLyyvDRARMGdudGPv4Dlr0VNh2/hON47VT3Q3er+Zimh6L4r3FI/oIT7/cp9llwenkXjEcc
 J1CGjoy797bt+nLgm3zHBw6MC2c8KyroCg4PYOu3siceJfdZXgoKpL3Zvz6JmHtwStkIyiZksdkIWdvpYyOC25tqnaYbn9rYdsccxEthRdy9h7vN3ecUdtcp
 EzC4aPynf3cHSGiNmpo6wqyw9JSphwsxfmuVvzA62p25IwNrQVv+JfQcZq0j6NsQc2Q51dz3Ud3ebnK9xpsKYIxCmg6+4HdStI1E46pbv/Ebo9QHWZ+Rs6JB
 rNorbGK3veuKobtTIY87Gr0Lb7HMMuTBKZxuS+tkKOHpYpXmwP9CNBl7IBOjqapgYjSaYLL8tDyKCdTT7Im8fSd54LFpGAC8CUGDEIpnbIGZa116oIqXXz4J
 Rw4fz832ynB5vb60VZNmEtcxkLECrMDU5DyEK1XVXxwT8xdxKdsV4i0Vb9Y=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Bosch C_CAN/D_CAN controller device tree binding
documentation to json-schema.

Document missing properties.
Remove "ti,hwmods" as it is no longer used in TI dts.
Make "clocks" required as it is used in all dts.
Correct nodename in the example.

Signed-off-by: Dario Binacchi <dariobin@libero.it>

---

Changes in v4:
 - Fix 'syscon-raminit' property to pass checks.
 - Drop 'status' property from CAN node of examples.
 - Replace CAN node of examples (compatible = "bosch,d_can")  with a
   recent version taken from socfpga.dtsi dts.
 - Update the 'interrupts' property due to the examples updating.
 - Add 'resets' property due to the examples updating.

Changes in v3:
 - Add type (phandle-array) and size (maxItems: 2) to syscon-raminit
   property.

Changes in v2:
 - Drop Documentation references.

 .../bindings/net/can/bosch,c_can.yaml         | 94 +++++++++++++++++++
 .../devicetree/bindings/net/can/c_can.txt     | 65 -------------
 2 files changed, 94 insertions(+), 65 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/c_can.txt

diff --git a/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
new file mode 100644
index 000000000000..9f1028fe58d5
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
@@ -0,0 +1,94 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/bosch,c_can.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Bosch C_CAN/D_CAN controller Device Tree Bindings
+
+description: Bosch C_CAN/D_CAN controller for CAN bus
+
+maintainers:
+  - Dario Binacchi <dariobin@libero.it>
+
+allOf:
+  - $ref: can-controller.yaml#
+
+properties:
+  compatible:
+    oneOf:
+      - enum:
+          - bosch,c_can
+          - bosch,d_can
+          - ti,dra7-d_can
+          - ti,am3352-d_can
+      - items:
+          - enum:
+              - ti,am4372-d_can
+          - const: ti,am3352-d_can
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    minItems: 1
+    maxItems: 4
+
+  power-domains:
+    description: |
+      Should contain a phandle to a PM domain provider node and an args
+      specifier containing the DCAN device id value. It's mandatory for
+      Keystone 2 66AK2G SoCs only.
+    maxItems: 1
+
+  clocks:
+    description: |
+      CAN functional clock phandle.
+    maxItems: 1
+
+  clock-names:
+    maxItems: 1
+
+  syscon-raminit:
+    description: |
+      Handle to system control region that contains the RAMINIT register,
+      register offset to the RAMINIT register and the CAN instance number (0
+      offset).
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      items:
+        - description: The phandle to the system control region.
+        - description: The register offset.
+        - description: The CAN instance number.
+
+  resets:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/reset/altr,rst-mgr.h>
+
+    can@ffc00000 {
+       compatible = "bosch,d_can";
+       reg = <0xffc00000 0x1000>;
+       interrupts = <0 131 4>, <0 132 4>, <0 133 4>, <0 134 4>;
+       clocks = <&can0_clk>;
+       resets = <&rst CAN0_RESET>;
+    };
+  - |
+    can@0 {
+        compatible = "ti,am3352-d_can";
+        reg = <0x0 0x2000>;
+        clocks = <&dcan1_fck>;
+        clock-names = "fck";
+        syscon-raminit = <&scm_conf 0x644 1>;
+        interrupts = <55>;
+    };
diff --git a/Documentation/devicetree/bindings/net/can/c_can.txt b/Documentation/devicetree/bindings/net/can/c_can.txt
deleted file mode 100644
index 366479806acb..000000000000
--- a/Documentation/devicetree/bindings/net/can/c_can.txt
+++ /dev/null
@@ -1,65 +0,0 @@
-Bosch C_CAN/D_CAN controller Device Tree Bindings
--------------------------------------------------
-
-Required properties:
-- compatible		: Should be "bosch,c_can" for C_CAN controllers and
-			  "bosch,d_can" for D_CAN controllers.
-			  Can be "ti,dra7-d_can", "ti,am3352-d_can" or
-			  "ti,am4372-d_can".
-- reg			: physical base address and size of the C_CAN/D_CAN
-			  registers map
-- interrupts		: property with a value describing the interrupt
-			  number
-
-The following are mandatory properties for DRA7x, AM33xx and AM43xx SoCs only:
-- ti,hwmods		: Must be "d_can<n>" or "c_can<n>", n being the
-			  instance number
-
-The following are mandatory properties for Keystone 2 66AK2G SoCs only:
-- power-domains		: Should contain a phandle to a PM domain provider node
-			  and an args specifier containing the DCAN device id
-			  value. This property is as per the binding,
-			  Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
-- clocks		: CAN functional clock phandle. This property is as per the
-			  binding,
-			  Documentation/devicetree/bindings/clock/ti,sci-clk.yaml
-
-Optional properties:
-- syscon-raminit	: Handle to system control region that contains the
-			  RAMINIT register, register offset to the RAMINIT
-			  register and the CAN instance number (0 offset).
-
-Note: "ti,hwmods" field is used to fetch the base address and irq
-resources from TI, omap hwmod data base during device registration.
-Future plan is to migrate hwmod data base contents into device tree
-blob so that, all the required data will be used from device tree dts
-file.
-
-Example:
-
-Step1: SoC common .dtsi file
-
-	dcan1: d_can@481d0000 {
-		compatible = "bosch,d_can";
-		reg = <0x481d0000 0x2000>;
-		interrupts = <55>;
-		interrupt-parent = <&intc>;
-		status = "disabled";
-	};
-
-(or)
-
-	dcan1: d_can@481d0000 {
-		compatible = "bosch,d_can";
-		ti,hwmods = "d_can1";
-		reg = <0x481d0000 0x2000>;
-		interrupts = <55>;
-		interrupt-parent = <&intc>;
-		status = "disabled";
-	};
-
-Step 2: board specific .dts file
-
-	&dcan1 {
-		status = "okay";
-	};
-- 
2.17.1

