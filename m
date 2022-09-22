Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E6A5E6DC5
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 23:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiIVVM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 17:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiIVVM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 17:12:28 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0110CDDD85
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:12:26 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id q17so12451166lji.11
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=2S+/oKnfHdDIYqLjVn/Rkfx1GqFf5yjAipGXLfP6Fxs=;
        b=ozphB0OkpBKMWYB5Pwfi2PiDhLSHZILHN+LRmYRHSeXjOFb85qcZAqLiWmgErRolUI
         nvN/3QmvqteedfofcOxq5c3zqCh1YkY3R/bwCX0xnvUqgq3hquT8QZZDznft//Vw4WXn
         QH0+bpd5HWD9scvTT54xPdXcdoaIpFtHPO+HtmXC2PIOTp1tyzrf4PC4Ddl4Q0zUBGn+
         3ZQ7DVFr7TAun3FmkL06WNbxW3SzeMWaZwc3p2a3d01ymsKLeG8O7hJhLP6AEjGYJEXT
         asaDks9dZqc6TFARVdY0LPyXUUAec1IJclLRj64Xgf1A6H9VFmCoX7YlLZyLE4XCXfIA
         ookA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=2S+/oKnfHdDIYqLjVn/Rkfx1GqFf5yjAipGXLfP6Fxs=;
        b=NDRfN4qM0hZAgDGK1xoMPYc/ovBeLbBq9f3H1oQO2entadXbbVQX0cO9BdK+VyZGer
         /Z7GiyawjLGGLb55do4tglkY6lkuJ0h90LGrsK+VKCOJEvSM9WVCVD1zv/rbCs0PGiD3
         LQYz+sZ0ZKGo8gJf1a8qkpmy/gRpfSdCvtyHjFYJzXipbhCEX1nXctV5uiT6zOhQPw4p
         AUtJY9LaAA19D/fLaamrk4bXlMibySNTA3wmrM5DFB2W+Mr4gRQhTryYghghiHg1HUt+
         Xqvu75qcpQfxsO++ss1ufzMiREsQ+SOna+07/t3oR4QDZDQfEHUSjeWaGi5QT0T0EpdH
         zjKA==
X-Gm-Message-State: ACrzQf2+k79vFB0gdGMXyMhS3dxrOVSny+NSAkguxzO65DbKX3k0gWgJ
        sEzmNZRg226VQ0tEIzdpVM7qqw==
X-Google-Smtp-Source: AMsMyM5eu8xowk9yECmQb+WAPEAwr9Ps6hcX6wfyaRoItrC6li5nAwZoci5YQpJyc4CXBugJBz2r/A==
X-Received: by 2002:a2e:3909:0:b0:26c:2ea4:1a79 with SMTP id g9-20020a2e3909000000b0026c2ea41a79mr1727061lja.401.1663881144241;
        Thu, 22 Sep 2022 14:12:24 -0700 (PDT)
Received: from michal-H370M-DS3H.office.semihalf.net ([83.142.187.84])
        by smtp.googlemail.com with ESMTPSA id v8-20020a2ea448000000b0026ad1da0dc3sm1064433ljn.122.2022.09.22.14.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 14:12:23 -0700 (PDT)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     devicetree@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com,
        =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
Subject: [net-next PATCH] dt-bindings: net: marvell,pp2: convert to json-schema
Date:   Thu, 22 Sep 2022 23:10:26 +0200
Message-Id: <20220922211026.34462-1-mig@semihalf.com>
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
 .../devicetree/bindings/net/marvell,pp2.yaml  | 292 ++++++++++++++++++
 .../devicetree/bindings/net/marvell-pp2.txt   | 141 ---------
 MAINTAINERS                                   |   2 +-
 3 files changed, 293 insertions(+), 142 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,pp2.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/marvell-pp2.txt

diff --git a/Documentation/devicetree/bindings/net/marvell,pp2.yaml b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
new file mode 100644
index 000000000000..b4589594a0cc
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
@@ -0,0 +1,292 @@
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
+patternProperties:
+
+  '^interrupt': true
+  '^#.*-cells$': true
+
+  '^eth[0-9a-f]*(@.*)?$':
+    type: object
+    properties:
+
+      interrupts:
+        minItems: 1
+        maxItems: 10
+        description: interrupt(s) for the port
+
+      interrupt-names:
+        minItems: 1
+        maxItems: 10
+
+        items:
+          oneOf:
+            - pattern: "^hif[0-8]$"
+            - pattern: "^tx-cpu[0-3]$"
+              deprecated: true
+            - const: link
+            - const: rx-shared
+              deprecated: true
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
+      phy-mode:
+        $ref: "ethernet-controller.yaml#/properties/phy-mode"
+
+      marvell,loopback:
+        $ref: /schemas/types.yaml#/definitions/flag
+        description: port is loopback mode.
+
+      phy:
+        $ref: /schemas/types.yaml#/definitions/phandle
+        description: >
+          a phandle to a phy node defining the PHY address
+          (as the reg property, a single integer).
+
+    required:
+      - interrupts
+      - port-id
+      - phy-mode
+
+properties:
+
+  dma-coherent: true
+
+  compatible:
+    enum:
+      - marvell,armada-375-pp2
+      - marvell,armada-7k-pp2
+
+  reg:
+    minItems: 3
+    maxItems: 4
+
+  marvell,system-controller:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: a phandle to the system controller.
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+
+allOf:
+
+  - $ref: ethernet-controller.yaml#
+
+  - if:
+      not:
+        patternProperties:
+          '^eth[0-9a-f]*(@.*)?$':
+            properties:
+              interrupts:
+                maxItems: 1
+
+    then:
+      patternProperties:
+        '^eth[0-9a-f]*(@.*)?$':
+          required:
+            - interrupt-names
+
+  - if:
+      properties:
+        compatible:
+          const: marvell,armada-375-pp2
+
+    then:
+      properties:
+
+        clocks:
+          items:
+            - description: main controller clock
+            - description: GOP clock
+
+        clock-names:
+          minItems: 2
+          maxItems: 2
+          items:
+            enum:
+              - pp_clk
+              - gop_clk
+
+        reg:
+          description: |
+            For "marvell,armada-375-pp2", must contain the following register sets:
+              - common controller registers
+              - LMS registers
+              - one register area per Ethernet port
+
+    else:
+
+      patternProperties:
+        '^eth[0-9a-f]*(@.*)?$':
+          properties:
+            gop-port-id:
+              $ref: /schemas/types.yaml#/definitions/uint32
+              description: >
+                only for marvell,armada-7k-pp2, ID of the port from the
+                GOP (Group Of Ports) point of view. This ID is used to index the
+                per-port registers in the second register area.
+
+          required:
+            - gop-port-id
+
+      properties:
+
+        clocks:
+          items:
+            - description: main controller clock
+            - description: GOP clock
+            - description: MG clock
+            - description: MG Core clock
+            - description: AXI clock
+
+        clock-names:
+          minItems: 5
+          maxItems: 5
+          items:
+            enum:
+              - gop_clk
+              - pp_clk
+              - mg_clk
+              - mg_core_clk
+              - axi_clk
+
+        reg:
+          description: |
+            For "marvell,armada-7k-pp2" used by 7K/8K and CN913X, must contain the following register sets:
+              - packet processor registers
+              - networking interfaces registers
+              - CM3 address space used for TX Flow Control
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
+      interrupt-controller;
+      #interrupt-cells = <3>;
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
+      interrupt-controller;
+      #interrupt-cells = <3>;
+      compatible = "marvell,armada-7k-pp2";
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
7FED8E4C2F58949CA919EEE5AAFD24434A5ECFEF

