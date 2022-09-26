Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E505EB5B1
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 01:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiIZXYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 19:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiIZXXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 19:23:49 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1BA5F22D
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 16:22:10 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id j16so13251967lfg.1
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 16:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=t56urIscvFJHkMdgK8GyeLx8hCpBBiz1juQj5RJ6tas=;
        b=nZqeKyQKJk0RkNuDQP3jEIrt94JeErwhPfz1ODisyVi2yWI3M44lKGfSpY2Uo6RRPp
         Q5cKkWF0AoOHCtzu7XiNjFaPx83dSwIk+oK97VsmcMTRxcGSehcNg9qa192nd6appINF
         EWiukKNev5GLXZzNHa4h6I/AczVyRb2TMnG0sbaOHSeYEwMPgaW8y5ihBmiCYn7Q+3aw
         G6e6K2QZCoEpAwCRIBjpqTRs9x3aQJY41Ywy1iCZV+rP9nADE0mWTvJCWiig0NEW8Bc4
         w3KD8yM54j2wzR1e6xJiMiMLmqBpIYsj4pV/9vr6kNxHBbl2qgX++fylw6psXxgFU83O
         95qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=t56urIscvFJHkMdgK8GyeLx8hCpBBiz1juQj5RJ6tas=;
        b=tekB3BRyf9kQTk2hju5GviiU5ZKETkI1bOv44Aq3cXquqEQCJS1pyPyLk688S09qac
         dQ5bcDCoTsgpUWIKpXM6dA2dVPgAUrYWA1j+Y7ANSNvsQoSKl15G616DIV9UetW2unky
         4+WIo2vEnsWrTX4PZw2oc8QhQhLOQC37uoB6ovz0bJMTW7NZBbnuKSA0P12Aom0nn7c/
         T8DMo+9daBPDng/718I7AtsjcU5/5Lbz+UOURu7fD34we5v6ntkqfOJ+7ERvmXtlEAFe
         fxbSurvTGpK6Vb0JFU8ZqyIkP/QlSKCOp/VATEJzmpvppLamQBJewVmOI/XWs9NyKCRy
         pTmw==
X-Gm-Message-State: ACrzQf0fp9YLqh95P6vndm73nduY9BQ0TGmhcuwWbhKUG82qABpDDKQM
        7o7GQDbOST3zmOyfofHz+cvSjg==
X-Google-Smtp-Source: AMsMyM5kM7tn1Vzl5tVNmXzKN0gpESg7IKXrqsj8aMrFBZtLB/qdPO2pT02eMgBsSgfLvo85dfXRFQ==
X-Received: by 2002:a05:6512:3d17:b0:497:9e34:94f2 with SMTP id d23-20020a0565123d1700b004979e3494f2mr9377721lfv.285.1664234528583;
        Mon, 26 Sep 2022 16:22:08 -0700 (PDT)
Received: from michal-H370M-DS3H.office.semihalf.net ([83.142.187.84])
        by smtp.googlemail.com with ESMTPSA id g6-20020a19e046000000b004978e51b691sm2661320lfj.266.2022.09.26.16.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 16:22:08 -0700 (PDT)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     devicetree@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com,
        =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
Subject: [PATCH v2] dt-bindings: net: marvell,pp2: convert to json-schema
Date:   Tue, 27 Sep 2022 01:21:36 +0200
Message-Id: <20220926232136.38567-1-mig@semihalf.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the marvell,pp2 bindings from text to proper schema.

Move 'marvell,system-controller' and 'dma-coherent' properties from
port up to the controller node, to match what is actually done in DT.

Signed-off-by: Michał Grzelak <mig@semihalf.com>
---
 .../devicetree/bindings/net/marvell,pp2.yaml  | 241 ++++++++++++++++++
 .../devicetree/bindings/net/marvell-pp2.txt   | 141 ----------
 MAINTAINERS                                   |   2 +-
 3 files changed, 242 insertions(+), 142 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,pp2.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/marvell-pp2.txt

diff --git a/Documentation/devicetree/bindings/net/marvell,pp2.yaml b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
new file mode 100644
index 000000000000..6faa4c87dfc6
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
@@ -0,0 +1,241 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/marvell,pp2.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Marvell CN913X / Marvell Armada 375, 7K, 8K Ethernet Controller
+
+maintainers:
+  - Marcin Wojtas <mw@semihalf.com>
+  - Russell King <linux@armlinux.org>
+
+description: |
+  Marvell Armada 375 Ethernet Controller (PPv2.1)
+  Marvell Armada 7K/8K Ethernet Controller (PPv2.2)
+  Marvell CN913X Ethernet Controller (PPv2.3)
+
+properties:
+  compatible:
+    enum:
+      - marvell,armada-375-pp2
+      - marvell,armada-7k-pp22
+
+  reg:
+    minItems: 3
+    maxItems: 4
+    description: |
+      For "marvell,armada-375-pp2", must contain the following register sets:
+        - common controller registers
+        - LMS registers
+        - one register area per Ethernet port
+      For "marvell,armada-7k-pp22" used by 7K/8K and CN913X, must contain the following register sets:
+        - packet processor registers
+        - networking interfaces registers
+        - CM3 address space used for TX Flow Control
+
+  clocks:
+    minItems: 2
+    items:
+      - description: main controller clock
+      - description: GOP clock
+      - description: MG clock
+      - description: MG Core clock
+      - description: AXI clock
+
+  clock-names:
+    minItems: 2
+    items:
+      - const: pp_clk
+      - const: gop_clk
+      - const: mg_clk
+      - const: mg_core_clk
+      - const: axi_clk
+
+  dma-coherent: true
+  '#size-cells': true
+  '#address-cells': true
+
+  marvell,system-controller:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: a phandle to the system controller.
+
+patternProperties:
+  '^eth[0-9a-f]*(@.*)?$':
+    type: object
+    properties:
+      interrupts:
+        minItems: 1
+        maxItems: 10
+        description: interrupt(s) for the port
+
+      interrupt-names:
+        items:
+          - const: hif0
+          - const: hif1
+          - const: hif2
+          - const: hif3
+          - const: hif4
+          - const: hif5
+          - const: hif6
+          - const: hif7
+          - const: hif8
+          - const: link
+
+        description: >
+          if more than a single interrupt for is given, must be the
+          name associated to the interrupts listed. Valid names are:
+          "hifX", with X in [0..8], and "link". The names "tx-cpu0",
+          "tx-cpu1", "tx-cpu2", "tx-cpu3" and "rx-shared" are supported
+          for backward compatibility but shouldn't be used for new
+          additions.
+
+      port-id:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description: ID of the port from the MAC point of view.
+
+      phy:
+        $ref: /schemas/types.yaml#/definitions/phandle
+        description: >
+          a phandle to a phy node defining the PHY address
+          (as the reg property, a single integer).
+
+      phy-mode:
+        $ref: "ethernet-controller.yaml#/properties/phy-mode"
+
+      marvell,loopback:
+        $ref: /schemas/types.yaml#/definitions/flag
+        description: port is loopback mode.
+
+      gop-port-id:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description: >
+          only for marvell,armada-7k-pp22, ID of the port from the
+          GOP (Group Of Ports) point of view. This ID is used to index the
+          per-port registers in the second register area.
+
+    required:
+      - interrupts
+      - port-id
+      - phy-mode
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+  - if:
+      properties:
+        compatible:
+          const: marvell,armada-7k-pp22
+    then:
+      patternProperties:
+        '^eth[0-9a-f]*(@.*)?$':
+          required:
+            - gop-port-id
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    // For Armada 375 variant
+    #include <dt-bindings/interrupt-controller/mvebu-icu.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    ethernet@f0000 {
+      compatible = "marvell,armada-375-pp2";
+      reg = <0xf0000 0xa000>,
+            <0xc0000 0x3060>,
+            <0xc4000 0x100>,
+            <0xc5000 0x100>;
+      clocks = <&gateclk 3>, <&gateclk 19>;
+      #address-cells = <1>;
+      #size-cells = <0>;
+      clock-names = "pp_clk", "gop_clk";
+
+      eth0: eth0@c4000 {
+        reg = <0xc4000>;
+        interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
+        port-id = <0>;
+        phy = <&phy0>;
+        phy-mode = "gmii";
+      };
+
+      eth1: eth1@c5000 {
+        reg = <0xc5000>;
+        interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
+        port-id = <1>;
+        phy = <&phy3>;
+        phy-mode = "gmii";
+      };
+    };
+
+  - |
+    // For Armada 7k/8k and Cn913x variants
+    #include <dt-bindings/interrupt-controller/mvebu-icu.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    cpm_ethernet: ethernet@0 {
+      compatible = "marvell,armada-7k-pp22";
+      reg = <0x0 0x100000>, <0x129000 0xb000>, <0x220000 0x800>;
+      clocks = <&cpm_syscon0 1 3>, <&cpm_syscon0 1 9>,
+               <&cpm_syscon0 1 5>, <&cpm_syscon0 1 6>, <&cpm_syscon0 1 18>;
+      clock-names = "pp_clk", "gop_clk", "mg_clk", "mg_core_clk", "axi_clk";
+
+      eth00: eth0 {
+        interrupts = <ICU_GRP_NSR 39 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 43 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 47 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 51 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 55 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 59 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 63 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 67 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 71 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 129 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "hif0", "hif1", "hif2", "hif3", "hif4",
+                          "hif5", "hif6", "hif7", "hif8", "link";
+        phy-mode = "10gbase-r";
+        port-id = <0>;
+        gop-port-id = <0>;
+      };
+
+      eth01: eth1 {
+        interrupts = <ICU_GRP_NSR 40 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 44 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 48 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 52 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 56 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 60 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 64 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 68 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 72 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 128 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "hif0", "hif1", "hif2", "hif3", "hif4",
+                          "hif5", "hif6", "hif7", "hif8", "link";
+        phy-mode = "rgmii-id";
+        port-id = <1>;
+        gop-port-id = <2>;
+      };
+
+      eth02: eth2 {
+        interrupts = <ICU_GRP_NSR 41 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 45 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 49 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 53 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 57 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 61 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 65 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 69 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 73 IRQ_TYPE_LEVEL_HIGH>,
+                     <ICU_GRP_NSR 127 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "hif0", "hif1", "hif2", "hif3", "hif4",
+                          "hif5", "hif6", "hif7", "hif8", "link";
+        phy-mode = "gmii";
+        port-id = <2>;
+        gop-port-id = <3>;
+      };
+    };
diff --git a/Documentation/devicetree/bindings/net/marvell-pp2.txt b/Documentation/devicetree/bindings/net/marvell-pp2.txt
deleted file mode 100644
index ce15c173f43f..000000000000
--- a/Documentation/devicetree/bindings/net/marvell-pp2.txt
+++ /dev/null
@@ -1,141 +0,0 @@
-* Marvell Armada 375 Ethernet Controller (PPv2.1)
-  Marvell Armada 7K/8K Ethernet Controller (PPv2.2)
-  Marvell CN913X Ethernet Controller (PPv2.3)
-
-Required properties:
-
-- compatible: should be one of:
-    "marvell,armada-375-pp2"
-    "marvell,armada-7k-pp2"
-- reg: addresses and length of the register sets for the device.
-  For "marvell,armada-375-pp2", must contain the following register
-  sets:
-	- common controller registers
-	- LMS registers
-	- one register area per Ethernet port
-  For "marvell,armada-7k-pp2" used by 7K/8K and CN913X, must contain the following register
-  sets:
-	- packet processor registers
-	- networking interfaces registers
-	- CM3 address space used for TX Flow Control
-
-- clocks: pointers to the reference clocks for this device, consequently:
-	- main controller clock (for both armada-375-pp2 and armada-7k-pp2)
-	- GOP clock (for both armada-375-pp2 and armada-7k-pp2)
-	- MG clock (only for armada-7k-pp2)
-	- MG Core clock (only for armada-7k-pp2)
-	- AXI clock (only for armada-7k-pp2)
-- clock-names: names of used clocks, must be "pp_clk", "gop_clk", "mg_clk",
-  "mg_core_clk" and "axi_clk" (the 3 latter only for armada-7k-pp2).
-
-The ethernet ports are represented by subnodes. At least one port is
-required.
-
-Required properties (port):
-
-- interrupts: interrupt(s) for the port
-- port-id: ID of the port from the MAC point of view
-- gop-port-id: only for marvell,armada-7k-pp2, ID of the port from the
-  GOP (Group Of Ports) point of view. This ID is used to index the
-  per-port registers in the second register area.
-- phy-mode: See ethernet.txt file in the same directory
-
-Optional properties (port):
-
-- marvell,loopback: port is loopback mode
-- phy: a phandle to a phy node defining the PHY address (as the reg
-  property, a single integer).
-- interrupt-names: if more than a single interrupt for is given, must be the
-                   name associated to the interrupts listed. Valid names are:
-                   "hifX", with X in [0..8], and "link". The names "tx-cpu0",
-                   "tx-cpu1", "tx-cpu2", "tx-cpu3" and "rx-shared" are supported
-                   for backward compatibility but shouldn't be used for new
-                   additions.
-- marvell,system-controller: a phandle to the system controller.
-
-Example for marvell,armada-375-pp2:
-
-ethernet@f0000 {
-	compatible = "marvell,armada-375-pp2";
-	reg = <0xf0000 0xa000>,
-	      <0xc0000 0x3060>,
-	      <0xc4000 0x100>,
-	      <0xc5000 0x100>;
-	clocks = <&gateclk 3>, <&gateclk 19>;
-	clock-names = "pp_clk", "gop_clk";
-
-	eth0: eth0@c4000 {
-		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
-		port-id = <0>;
-		phy = <&phy0>;
-		phy-mode = "gmii";
-	};
-
-	eth1: eth1@c5000 {
-		interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
-		port-id = <1>;
-		phy = <&phy3>;
-		phy-mode = "gmii";
-	};
-};
-
-Example for marvell,armada-7k-pp2:
-
-cpm_ethernet: ethernet@0 {
-	compatible = "marvell,armada-7k-pp22";
-	reg = <0x0 0x100000>, <0x129000 0xb000>, <0x220000 0x800>;
-	clocks = <&cpm_syscon0 1 3>, <&cpm_syscon0 1 9>,
-		 <&cpm_syscon0 1 5>, <&cpm_syscon0 1 6>, <&cpm_syscon0 1 18>;
-	clock-names = "pp_clk", "gop_clk", "mg_clk", "mg_core_clk", "axi_clk";
-
-	eth0: eth0 {
-		interrupts = <ICU_GRP_NSR 39 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 43 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 47 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 51 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 55 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 59 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 63 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 67 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 71 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 129 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "hif0", "hif1", "hif2", "hif3", "hif4",
-				  "hif5", "hif6", "hif7", "hif8", "link";
-		port-id = <0>;
-		gop-port-id = <0>;
-	};
-
-	eth1: eth1 {
-		interrupts = <ICU_GRP_NSR 40 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 44 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 48 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 52 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 56 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 60 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 64 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 68 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 72 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 128 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "hif0", "hif1", "hif2", "hif3", "hif4",
-				  "hif5", "hif6", "hif7", "hif8", "link";
-		port-id = <1>;
-		gop-port-id = <2>;
-	};
-
-	eth2: eth2 {
-		interrupts = <ICU_GRP_NSR 41 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 45 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 49 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 53 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 57 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 61 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 65 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 69 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 73 IRQ_TYPE_LEVEL_HIGH>,
-			     <ICU_GRP_NSR 127 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "hif0", "hif1", "hif2", "hif3", "hif4",
-				  "hif5", "hif6", "hif7", "hif8", "link";
-		port-id = <2>;
-		gop-port-id = <3>;
-	};
-};
diff --git a/MAINTAINERS b/MAINTAINERS
index 9ae989b32ebb..3d8e64bf7ae6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12191,7 +12191,7 @@ M:	Marcin Wojtas <mw@semihalf.com>
 M:	Russell King <linux@armlinux.org.uk>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/marvell-pp2.txt
+F:	Documentation/devicetree/bindings/net/marvell,pp2.yaml
 F:	drivers/net/ethernet/marvell/mvpp2/
 
 MARVELL MWIFIEX WIRELESS DRIVER
-- 
Changelog:
v1->v2:
* move 'properties' to the front of the file
* remove blank line after 'properties'
* move 'compatible' to the front of 'properties'
* move 'clocks', 'clock-names' and 'reg' definitions to 'properties' 
* substitute all occurences of 'marvell,armada-7k-pp2' with
  'marvell,armada-7k-pp22'
* add properties:#size-cells and properties:#address-cells 
* specify list in 'interrupt-names'
* remove blank lines after 'patternProperties'
* remove '^interrupt' and '^#.*-cells$' patterns
* remove blank line after 'allOf'
* remove first 'if-then-else' block from 'allOf'
* negate the condition in allOf:if schema
* delete 'interrupt-controller' from section 'examples'
* delete '#interrupt-cells' from section 'examples'
2.34.1

