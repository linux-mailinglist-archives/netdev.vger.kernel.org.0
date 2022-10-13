Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018295FDE85
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 18:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiJMQwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 12:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiJMQwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 12:52:34 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112C210A7CA
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 09:52:30 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id m19so3371736lfq.9
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 09:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O9B0wGWH8u1ifZVPrTj19MFgf6GVFCmbd3CdTcleljE=;
        b=KXNJ4w9Vb+kJ5s7TnRfNCFqWCM2p8IYcY/EAqz51EiNTPpaZDeAU3eEqa1xleu2U0a
         m3BIJwa6C+FvUtlCCuWUDU35BwJ9Q+91D2X2hnIOPIQOImIOAxbhK42Tn1IrKvuuU/qa
         XmBufDzEJ5LbeOnaNFeYmksT2CTVIfIeIQKRkiJAyOHNmt2YZnxZskHM+9ZCuXFyJcW6
         jSinq4aCbb5+Gh61Gai4asSLG7GWCa4YlYBnZc7AJR9fOu03WOvE7j2gOYv7xdKCeC9p
         b5IVL2Hg9unMPiZoMD3PmYpJ7XTnRxmbHj0fzc2afoU5BSjUcZc6eix23CRS+IVbG/jZ
         ba6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O9B0wGWH8u1ifZVPrTj19MFgf6GVFCmbd3CdTcleljE=;
        b=1hTGaCQ8QAnDrOxvgEMIYesuBBWzHE96Xs5pr6omeNduxjwaZxpt9YBvIeccmpjt5y
         3+aerUbDLzQO431p9VxVVaNVAzZLPp2fC1A7LdzLZuJLClEq7PZsz3VBn+48vlOGC/k6
         9HqlJ87W7M+wCY+aTSz4oZ/HRzzcGSNy+Ahjg3w9Csfi/reAtMP0ruQ3I5GNJdkwF/cn
         0LKXL4eUscMmdR/+oaVB6ryvoOom6Wv7fOmiQnR0ZpSN86jtFZEPZc6AlhI6akq/M6Ap
         OFntuiyopGNluCVM6e2OQFl37rEsichR/iEU4jtuXuhAhDoF9h7NNldiuNilL+UQDiHR
         A0vQ==
X-Gm-Message-State: ACrzQf2KUtqRjBxLA6Ip3Ct7GpAffyO5Mhy7OVSAZSx9y1S8cHYpX3l+
        LCEWqj6YuXDS77/JnOkbT9uMHA==
X-Google-Smtp-Source: AMsMyM6079O7PD7uU/UPzwzq20JYOIio06nKUX9b5TNG3uyAV0XuMCXYJKAQ3gCEKoKLJqEHdRxTGw==
X-Received: by 2002:ac2:551d:0:b0:4a2:7c75:6e37 with SMTP id j29-20020ac2551d000000b004a27c756e37mr208832lfk.398.1665679948154;
        Thu, 13 Oct 2022 09:52:28 -0700 (PDT)
Received: from fedora.. ([78.10.206.53])
        by smtp.gmail.com with ESMTPSA id k7-20020a2e9207000000b00262fae1ffe6sm540752ljg.110.2022.10.13.09.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 09:52:27 -0700 (PDT)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     devicetree@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com,
        =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
Subject: [PATCH v4 1/3] dt-bindings: net: marvell,pp2: convert to json-schema
Date:   Thu, 13 Oct 2022 18:51:32 +0200
Message-Id: <20221013165134.78234-2-mig@semihalf.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221013165134.78234-1-mig@semihalf.com>
References: <20221013165134.78234-1-mig@semihalf.com>
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

Rename all subnodes to match "^(ethernet-)?port@[0-9]+$" and deprecate
port-id in favour of 'reg'.

Signed-off-by: Michał Grzelak <mig@semihalf.com>
---
 .../devicetree/bindings/net/marvell,pp2.yaml  | 288 ++++++++++++++++++
 .../devicetree/bindings/net/marvell-pp2.txt   | 141 ---------
 MAINTAINERS                                   |   2 +-
 3 files changed, 289 insertions(+), 142 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,pp2.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/marvell-pp2.txt

diff --git a/Documentation/devicetree/bindings/net/marvell,pp2.yaml b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
new file mode 100644
index 000000000000..c4b27338d740
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
@@ -0,0 +1,288 @@
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
+    $ref: ethernet-controller.yaml#
+    unevaluatedProperties: false
+
+    properties:
+      reg:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description: ID of the port from the MAC point of view.
+
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
+      phys:
+        $ref: /schemas/phy/phy-consumer.yaml#/properties/phys
+        description: Generic PHY, providing serdes lanes.
+
+      port-id:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        deprecated: true
+        description: >
+          ID of the port from the MAC point of view.
+          Legacy binding for backward compatibility.
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
+      - reg
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
+additionalProperties: false
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
+        phys = <&cp0_comphy4 0>;
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
+        phy-mode = "2500base-x";
+        managed = "in-band-status";
+        phys = <&cp0_comphy5 2>;
+        sfp = <&sfp_eth3>;
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
2.37.3

