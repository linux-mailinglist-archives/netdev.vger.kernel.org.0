Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8055FBB15
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 21:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJKTHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 15:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJKTHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 15:07:02 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D23D5053A
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 12:06:59 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id j26so2581720ljg.13
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 12:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u3yCxlgQB512X9ob5aJS/z0CokvR7tPgP4XCG40BHqE=;
        b=Hz36Pc5KPd9FTHiuSAXPnPa3/eFQVuyM9GeEa90R53eVcseTvHuPbOsBKKY2jUOQ2z
         xjbHYQRypmucWn1AcYXTJA7u7IWIC/Uf18oN4cnq6mU8DwYXLRlBnHYfZ4RWmtOK0rK4
         nn2z28HzuEZm5pJhaK+Lz/4H4+GT1TRpEnXDu9HGdPdPANN+zEUJGDZQRvyI0Nh3rd3D
         RrOFMu+0sHHMolnNZ+wtvs//D6WPM7xZlYkiE7q7Mz8AMmu4mj6+n4pYxvsVDDpi2JoF
         kffq3o1pLxhnVXSodjNJiCbGmC8sZ+zWnR2eNFcYRzb9HkSF4VyyPpEIMSBy6BGAlNzl
         8kqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u3yCxlgQB512X9ob5aJS/z0CokvR7tPgP4XCG40BHqE=;
        b=h/5yHlEiIwQLIJpNm2xywxEOGHXQFq/NvIm6ZY5Su1PVlLu1bU3fh0foTMLk4hfkNP
         wTmAWu22k3IsyW4JZ5AODSokUDmNFpMud7Hief3yZRggSw8ZM53qpz6jT18uQP/i5/mB
         WXUhDuEC3538ybd9OE4XBh73Jty7nwqvuo29k9ErFEK9nNMPKLIp20OOq99layzUxZBv
         zl8OIfxHN+cWw4c+cUyEs0uwG56hRBN8xxSlZbQ8dVGyNpsMANgFbtaUmU9bGIyEvjTH
         idQ7YVsQL2G26Qu+Q3AWgIGFq1xyau44Twm5JzLCikLNDnqOQxuQ5PTDDYa6/Lnt0ppb
         Q/dQ==
X-Gm-Message-State: ACrzQf3kDV05UJ1SBYSj7gLC1O61aeBfYfYC61ixGydzan00ESxzDUGL
        JzMHbPq1jk1Fe9/v9QLcEyPj5w==
X-Google-Smtp-Source: AMsMyM5rMdNrdEkjLsPITCScXjidoHrYDycUXDd2xiQwlIigWhBpGQo0kf2L/k9iTiLNR8KxRsWIyw==
X-Received: by 2002:a05:651c:b23:b0:26f:b2b9:6976 with SMTP id b35-20020a05651c0b2300b0026fb2b96976mr3175606ljr.85.1665515217340;
        Tue, 11 Oct 2022 12:06:57 -0700 (PDT)
Received: from michal-H370M-DS3H.office.semihalf.net ([83.142.187.84])
        by smtp.googlemail.com with ESMTPSA id p9-20020a2eb7c9000000b00262fae1ffe6sm2270477ljo.110.2022.10.11.12.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 12:06:57 -0700 (PDT)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     devicetree@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com,
        =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
Subject: [PATCH v3 1/3] dt-bindings: net: marvell,pp2: convert to json-schema
Date:   Tue, 11 Oct 2022 21:06:11 +0200
Message-Id: <20221011190613.13008-2-mig@semihalf.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221011190613.13008-1-mig@semihalf.com>
References: <20221011190613.13008-1-mig@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the marvell,pp2 bindings from text to proper schema.

Move 'marvell,system-controller' and 'dma-coherent' properties from
port up to the controller node, to match what is actually done in DT.

Signed-off-by: Michał Grzelak <mig@semihalf.com>
---
 .../devicetree/bindings/net/marvell,pp2.yaml  | 286 ++++++++++++++++++
 .../devicetree/bindings/net/marvell-pp2.txt   | 141 ---------
 MAINTAINERS                                   |   2 +-
 3 files changed, 287 insertions(+), 142 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,pp2.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/marvell-pp2.txt

diff --git a/Documentation/devicetree/bindings/net/marvell,pp2.yaml b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
new file mode 100644
index 000000000000..24c6aeb46814
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
@@ -0,0 +1,286 @@
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
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
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
+
+  marvell,system-controller:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: a phandle to the system controller.
+
+patternProperties:
+  '^(ethernet-)?port@[0-9]+$':
+    type: object
+    description: subnode for each ethernet port.
+
+    properties:
+      interrupts:
+        minItems: 1
+        maxItems: 10
+        description: interrupt(s) for the port
+
+      interrupt-names:
+        minItems: 1
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
+      reg:
+        description: ID of the port from the MAC point of view.
+
+      port-id:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description: >
+          ID of the port from the MAC point of view.
+          Legacy binding for backward compatibility.
+
+      phy:
+        $ref: /schemas/types.yaml#/definitions/phandle
+        description: >
+          a phandle to a phy node defining the PHY address
+          (as the reg property, a single integer).
+
+      phy-mode:
+        $ref: ethernet-controller.yaml#/properties/phy-mode
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
+      - reg
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
+      properties:
+        reg:
+          items:
+            - description: Packet Processor registers
+            - description: Networking interfaces registers
+            - description: CM3 address space used for TX Flow Control
+
+        clocks:
+          minItems: 5
+
+        clock-names:
+          minItems: 5
+
+      patternProperties:
+        '^(ethernet-)?port@[0-9]+$':
+          required:
+            - gop-port-id
+
+      required:
+        - marvell,system-controller
+    else:
+      properties:
+        reg:
+          items:
+            - description: Packet Processor registers
+            - description: LMS registers
+            - description: Register area per eth0
+            - description: Register area per eth1
+
+        clocks:
+          maxItems: 2
+
+        clock-names:
+          maxItems: 2
+
+      patternProperties:
+        '^(ethernet-)?port@[0-9]+$':
+          properties:
+            gop-port-id: false
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
+      #address-cells = <1>;
+      #size-cells = <0>;
+      compatible = "marvell,armada-375-pp2";
+      reg = <0xf0000 0xa000>,
+            <0xc0000 0x3060>,
+            <0xc4000 0x100>,
+            <0xc5000 0x100>;
+      clocks = <&gateclk 3>, <&gateclk 19>;
+      clock-names = "pp_clk", "gop_clk";
+
+      ethernet-port@0 {
+        interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
+        reg = <0>;
+        port-id = <0>; /* For backward compatibility. */
+        phy = <&phy0>;
+        phy-mode = "rgmii-id";
+      };
+
+      ethernet-port@1 {
+        interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
+        reg = <1>;
+        port-id = <1>; /* For backward compatibility. */
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
+    ethernet@0 {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      compatible = "marvell,armada-7k-pp22";
+      reg = <0x0 0x100000>, <0x129000 0xb000>, <0x220000 0x800>;
+      clocks = <&cp0_clk 1 3>, <&cp0_clk 1 9>,
+               <&cp0_clk 1 5>, <&cp0_clk 1 6>, <&cp0_clk 1 18>;
+      clock-names = "pp_clk", "gop_clk", "mg_clk", "mg_core_clk", "axi_clk";
+      marvell,system-controller = <&cp0_syscon0>;
+
+      ethernet-port@0 {
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
+        reg = <0>;
+        port-id = <0>; /* For backward compatibility. */
+        gop-port-id = <0>;
+      };
+
+      ethernet-port@1 {
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
+        reg = <1>;
+        port-id = <1>; /* For backward compatibility. */
+        gop-port-id = <2>;
+      };
+
+      ethernet-port@2 {
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
+        reg = <2>;
+        port-id = <2>; /* For backward compatibility. */
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
index e68a0804394d..51da1b56d87e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12292,7 +12292,7 @@ M:	Marcin Wojtas <mw@semihalf.com>
 M:	Russell King <linux@armlinux.org.uk>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/marvell-pp2.txt
+F:	Documentation/devicetree/bindings/net/marvell,pp2.yaml
 F:	drivers/net/ethernet/marvell/mvpp2/
 
 MARVELL MWIFIEX WIRELESS DRIVER
-- 
2.25.1

