Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0BB5FF57E
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 23:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiJNVds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 17:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiJNVdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 17:33:42 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B1B1DD890
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 14:33:40 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id d6so9114190lfs.10
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 14:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wbrIhm/AmB1rz/cuApJvSIYA4825L6AV/ptNDaFUuOo=;
        b=L+IRdYp5whthBudWQlQolIEPKp4W57CIUnrvpl5e/4J6c8pDSJCV6P4wcQ4eTvbrFV
         I7D6FQL4LQw8ugEUP6BgGGqD2XZNsLP9yBxLiNDvSJBnxcrjbmCyfvO/tYjghJLgDG4W
         xdJwnYuAqGqWQ8ctqDt+cHKg+ZiezUld+S0NhxTSowG+KkTWZPmtFwp54CkbyIUjAtQr
         hrXIp1QWhDHxKmcbEkVlwt1KafntU2zQ3x+7zzrLf0Es01c4W6OmwwE8gpecSa/vvt5o
         /jEUxMH6/wR9WtpCdvNY+pvLPkdbIyMte2ZbitObZIcoRHSahHzWtVseiouw/sjSp9fu
         +L5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wbrIhm/AmB1rz/cuApJvSIYA4825L6AV/ptNDaFUuOo=;
        b=tu8j+pI/pcYcW5XnJFqAm3nmIRBn2jA6v1z5DphDnyvalepmGX5yPaOsYIjzmuGtRz
         FbzjkiQ/bIK7udQv6Q1+trOQbuqGAMlh5OUc6uZHrhDp4fox7UCSD8bt9uEsCdpJgjLT
         tkIFVI1gEm0bOzqoTdxu65jt54m69FONvJrat/6Hwa8ccV3k6+NDvch6WvGgo2KsWQea
         6R2PjxPiyQgCWYnPWyKMCYBSs0naE13UJ0eMkl6IR/XGk7awF6K/tO+T1z9ttX1uj0ac
         8Zwg0pntxCpObUIzTKwX33OrFVtR2/O/ECQZ9QzhGdZYRU5yWbAFOuAxHri4f6pCLWPk
         0rhg==
X-Gm-Message-State: ACrzQf3ij76XubNMiDDDhJUw1kTEiTc3/fwpFXN8NwOb952sxLqpGeAF
        1IwXvOt/QuWUTMmM33+nIftJGQ==
X-Google-Smtp-Source: AMsMyM4mPUV+ti1mLN4Z4g93XkSuzbtjc3KoKVbvbRPo4Fw6ub9XSf3NS50mmOuGoHQtvXxUJG7/qw==
X-Received: by 2002:a05:6512:2a92:b0:4a1:d2c9:c2d0 with SMTP id dt18-20020a0565122a9200b004a1d2c9c2d0mr2503099lfb.278.1665783218416;
        Fri, 14 Oct 2022 14:33:38 -0700 (PDT)
Received: from fedora.. ([78.10.207.24])
        by smtp.gmail.com with ESMTPSA id d4-20020ac24c84000000b00494978b0caesm494036lfl.276.2022.10.14.14.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:33:38 -0700 (PDT)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     devicetree@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com,
        =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
Subject: [PATCH v5 1/3] dt-bindings: net: marvell,pp2: convert to json-schema
Date:   Fri, 14 Oct 2022 23:32:52 +0200
Message-Id: <20221014213254.30950-2-mig@semihalf.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221014213254.30950-1-mig@semihalf.com>
References: <20221014213254.30950-1-mig@semihalf.com>
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

Rename all subnodes to match "^(ethernet-)?port@[0-2]$" and deprecate
port-id in favour of 'reg'.

Signed-off-by: Michał Grzelak <mig@semihalf.com>
---
 .../devicetree/bindings/net/marvell,pp2.yaml  | 305 ++++++++++++++++++
 .../devicetree/bindings/net/marvell-pp2.txt   | 141 --------
 MAINTAINERS                                   |   2 +-
 3 files changed, 306 insertions(+), 142 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,pp2.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/marvell-pp2.txt

diff --git a/Documentation/devicetree/bindings/net/marvell,pp2.yaml b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
new file mode 100644
index 000000000000..4eadafc43d4f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
@@ -0,0 +1,305 @@
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
+  '^(ethernet-)?port@[0-2]$':
+    type: object
+    description: subnode for each ethernet port.
+    $ref: ethernet-controller.yaml#
+    unevaluatedProperties: false
+
+    properties:
+      reg:
+        description: ID of the port from the MAC point of view.
+        maximum: 2
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
+        minItems: 1
+        maxItems: 2
+        description: >
+          Generic PHY, providing SerDes connectivity. For most modes,
+          one lane is sufficient, but some (e.g. RXAUI) may require two.
+
+      phy-mode:
+        enum:
+          - gmii
+          - sgmii
+          - rgmii-id
+          - 1000base-x
+          - 2500base-x
+          - 5gbase-r
+          - rxaui
+          - 10gbase-r
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
+      - phy-mode
+      - port-id
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
+        '^(ethernet-)?port@[0-2]$':
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
+        '^(ethernet-)?port@[0-1]$':
+          properties:
+            reg:
+              maximum: 1
+
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
+        #address-cells = <1>;
+        #size-cells = <0>;
+        compatible = "marvell,armada-375-pp2";
+        reg = <0xf0000 0xa000>,
+              <0xc0000 0x3060>,
+              <0xc4000 0x100>,
+              <0xc5000 0x100>;
+        clocks = <&gateclk 3>, <&gateclk 19>;
+        clock-names = "pp_clk", "gop_clk";
+
+        ethernet-port@0 {
+            interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
+            reg = <0>;
+            port-id = <0>; /* For backward compatibility. */
+            phy = <&phy0>;
+            phy-mode = "rgmii-id";
+        };
+
+        ethernet-port@1 {
+            interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
+            reg = <1>;
+            port-id = <1>; /* For backward compatibility. */
+            phy = <&phy3>;
+            phy-mode = "gmii";
+        };
+    };
+
+  - |
+    // For Armada 7k/8k and Cn913x variants
+    #include <dt-bindings/interrupt-controller/mvebu-icu.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    ethernet@0 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        compatible = "marvell,armada-7k-pp22";
+        reg = <0x0 0x100000>, <0x129000 0xb000>, <0x220000 0x800>;
+        clocks = <&cp0_clk 1 3>, <&cp0_clk 1 9>,
+                 <&cp0_clk 1 5>, <&cp0_clk 1 6>, <&cp0_clk 1 18>;
+        clock-names = "pp_clk", "gop_clk", "mg_clk", "mg_core_clk", "axi_clk";
+        marvell,system-controller = <&cp0_syscon0>;
+
+        ethernet-port@0 {
+            interrupts = <ICU_GRP_NSR 39 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 43 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 47 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 51 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 55 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 59 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 63 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 67 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 71 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 129 IRQ_TYPE_LEVEL_HIGH>;
+            interrupt-names = "hif0", "hif1", "hif2", "hif3", "hif4",
+                              "hif5", "hif6", "hif7", "hif8", "link";
+            phy-mode = "10gbase-r";
+            phys = <&cp0_comphy4 0>;
+            reg = <0>;
+            port-id = <0>; /* For backward compatibility. */
+            gop-port-id = <0>;
+        };
+
+        ethernet-port@1 {
+            interrupts = <ICU_GRP_NSR 40 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 44 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 48 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 52 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 56 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 60 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 64 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 68 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 72 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 128 IRQ_TYPE_LEVEL_HIGH>;
+            interrupt-names = "hif0", "hif1", "hif2", "hif3", "hif4",
+                              "hif5", "hif6", "hif7", "hif8", "link";
+            phy-mode = "rgmii-id";
+            reg = <1>;
+            port-id = <1>; /* For backward compatibility. */
+            gop-port-id = <2>;
+        };
+
+        ethernet-port@2 {
+            interrupts = <ICU_GRP_NSR 41 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 45 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 49 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 53 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 57 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 61 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 65 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 69 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 73 IRQ_TYPE_LEVEL_HIGH>,
+                         <ICU_GRP_NSR 127 IRQ_TYPE_LEVEL_HIGH>;
+            interrupt-names = "hif0", "hif1", "hif2", "hif3", "hif4",
+                              "hif5", "hif6", "hif7", "hif8", "link";
+            phy-mode = "2500base-x";
+            managed = "in-band-status";
+            phys = <&cp0_comphy5 2>;
+            sfp = <&sfp_eth3>;
+            reg = <2>;
+            port-id = <2>; /* For backward compatibility. */
+            gop-port-id = <3>;
+        };
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

