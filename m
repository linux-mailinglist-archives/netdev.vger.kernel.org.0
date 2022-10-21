Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE5C607C02
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 18:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiJUQTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 12:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiJUQTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 12:19:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC124285B5A;
        Fri, 21 Oct 2022 09:19:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0600A61F1C;
        Fri, 21 Oct 2022 16:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A22C433D6;
        Fri, 21 Oct 2022 16:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666369156;
        bh=Ja1c5TLvRUJZ5yA/TNCgNqMFbfeQ7091tgqg/zH5PCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i90H23GTaAwjaBybJSxB/AfvreN4Amdmd0mxiZpJe6V2aW2X63wiXcHCRTabE8e9r
         VqFB1vFiOfjJqLZ0qZJfMZ36UhISaBBudckZicN8/Hbs3r/miGmQqnKtPYTpQaIOGP
         KZ+fvqRf+WyOMYpDQxvVwBIFz3vlfa9QqH8ynrs3GbxGEh4Gs7cliVd6vgoWbRwlKE
         rUttoDfGbt6GTPuederwk+/C+TmRhSWuUx8eK/2VC5Hq/JwOLmQnSPWNgHsHMjcQ9a
         ZpXi9GEhrrDSaoZ3G5vs8OcJ3z9qj8iN2fwHLsjUhQ6sl4edDwFgMtAFgAJ8BPEfO9
         e8MI8v3XnE46w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
Subject: [PATCH net-next 2/6] dt-bindings: net: mediatek: add WED RX binding for MT7986 eth driver
Date:   Fri, 21 Oct 2022 18:18:32 +0200
Message-Id: <7a454984f0001a71964114b71f353cb47af95ee6.1666368566.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666368566.git.lorenzo@kernel.org>
References: <cover.1666368566.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the binding for the RX Wireless Ethernet Dispatch core on the
MT7986 ethernet driver used to offload traffic received by WLAN NIC and
forwarded to LAN/WAN one.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../arm/mediatek/mediatek,mt7622-wed.yaml     | 126 ++++++++++++++++++
 .../arm/mediatek/mediatek,mt7986-wo-boot.yaml |  45 +++++++
 .../arm/mediatek/mediatek,mt7986-wo-ccif.yaml |  49 +++++++
 .../arm/mediatek/mediatek,mt7986-wo-dlm.yaml  |  66 +++++++++
 4 files changed, 286 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
index 84fb0a146b6e..623f11df5545 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
@@ -29,6 +29,59 @@ properties:
   interrupts:
     maxItems: 1
 
+  mediatek,wocpu_emi:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    maxItems: 1
+    description:
+      Phandle to a node describing reserved memory used by mtk wed firmware
+      (see bindings/reserved-memory/reserved-memory.txt)
+
+  mediatek,wocpu_data:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    maxItems: 1
+    description:
+      Phandle to a node describing reserved memory used by mtk wed firmware
+      (see bindings/reserved-memory/reserved-memory.txt)
+
+  mediatek,wocpu_ilm:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    maxItems: 1
+    description:
+      Phandle to a node describing memory used by mtk wed firmware
+
+  mediatek,ap2woccif:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    maxItems: 1
+    description:
+      Phandle to the mediatek wed-wo controller.
+
+  mediatek,wocpu_boot:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    maxItems: 1
+    description:
+      Phandle to the mediatek wed-wo boot interface.
+
+  mediatek,wocpu_dlm:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    maxItems: 1
+    description:
+      Phandle to the mediatek wed-wo rx hw ring.
+
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: mediatek,mt7986-wed
+    then:
+      properties:
+        mediatek,wocpu_data: true
+        mediatek,wocpu_boot: true
+        mediatek,wocpu_emi: true
+        mediatek,wocpu_ilm: true
+        mediatek,ap2woccif: true
+        mediatek,wocpu_dlm: true
+
 required:
   - compatible
   - reg
@@ -49,3 +102,76 @@ examples:
         interrupts = <GIC_SPI 214 IRQ_TYPE_LEVEL_LOW>;
       };
     };
+
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/reset/ti-syscon.h>
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+      reserved-memory {
+        #address-cells = <2>;
+        #size-cells = <2>;
+        wocpu0_emi: wocpu0_emi@4fd00000 {
+          reg = <0 0x4fd00000 0 0x40000>;
+          no-map;
+        };
+
+        wocpu_data: wocpu_data@4fd80000 {
+          reg = <0 0x4fd80000 0 0x240000>;
+          no-map;
+        };
+      };
+
+      ethsys: syscon@15000000 {
+        #address-cells = <1>;
+        #size-cells = <1>;
+        compatible = "mediatek,mt7986-ethsys", "syscon";
+        reg = <0 0x15000000 0 0x1000>;
+
+        #clock-cells = <1>;
+        #reset-cells = <1>;
+        ethsysrst: reset-controller {
+          compatible = "ti,syscon-reset";
+          #reset-cells = <1>;
+          ti,reset-bits = <0x34 4 0x34 4 0x34 4 (ASSERT_SET | DEASSERT_CLEAR | STATUS_SET)>;
+        };
+      };
+
+      wocpu0_ilm: wocpu0_ilm@151e0000 {
+        compatible = "mediatek,wocpu0_ilm";
+        reg = <0 0x151e0000 0 0x8000>;
+      };
+
+      cpu_boot: wocpu_boot@15194000 {
+        compatible = "mediatek,wocpu_boot", "syscon";
+        reg = <0 0x15194000 0 0x1000>;
+      };
+
+      ap2woccif0: ap2woccif@151a5000 {
+        compatible = "mediatek,ap2woccif", "syscon";
+        reg = <0 0x151a5000 0 0x1000>;
+        interrupts = <GIC_SPI 211 IRQ_TYPE_LEVEL_HIGH>;
+      };
+
+      wocpu0_dlm: wocpu_dlm@151e8000 {
+        compatible = "mediatek,wocpu_dlm";
+        reg = <0 0x151e8000 0 0x2000>;
+        resets = <&ethsysrst 0>;
+        reset-names = "wocpu_rst";
+      };
+
+      wed1: wed@1020a000 {
+        compatible = "mediatek,mt7986-wed","syscon";
+        reg = <0 0x15010000 0 0x1000>;
+        interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
+
+        mediatek,wocpu_data = <&wocpu_data>;
+        mediatek,ap2woccif = <&ap2woccif0>;
+        mediatek,wocpu_ilm = <&wocpu0_ilm>;
+        mediatek,wocpu_dlm = <&wocpu0_dlm>;
+        mediatek,wocpu_emi = <&wocpu_emi>;
+        mediatek,wocpu_boot = <&cpu_boot>;
+      };
+    };
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml
new file mode 100644
index 000000000000..dc8fdb706960
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml
@@ -0,0 +1,45 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-boot.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: MediaTek WED WO boot controller interface for MT7986
+
+maintainers:
+  - Lorenzo Bianconi <lorenzo@kernel.org>
+  - Felix Fietkau <nbd@nbd.name>
+
+description:
+  The mediatek wo-boot provides a configuration interface for WED WO
+  boot controller on MT7986 soc.
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - mediatek,wocpu_boot
+      - const: syscon
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+      cpu_boot: wocpu_boot@15194000 {
+        compatible = "mediatek,wocpu_boot", "syscon";
+        reg = <0 0x15194000 0 0x1000>;
+      };
+    };
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml
new file mode 100644
index 000000000000..8fea86425983
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml
@@ -0,0 +1,49 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-ccif.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: MediaTek WED WO Controller for MT7986
+
+maintainers:
+  - Lorenzo Bianconi <lorenzo@kernel.org>
+  - Felix Fietkau <nbd@nbd.name>
+
+description:
+  The mediatek WO-ccif provides a configuration interface for WED WO
+  controller on MT7986 soc.
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - mediatek,ap2woccif
+      - const: syscon
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+      ap2woccif0: ap2woccif@151a5000 {
+        compatible = "mediatek,ap2woccif", "syscon";
+        reg = <0 0x151a5000 0 0x1000>;
+        interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
+      };
+    };
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml
new file mode 100644
index 000000000000..529343c57e4b
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml
@@ -0,0 +1,66 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-dlm.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: MediaTek WED WO hw rx ring interface for MT7986
+
+maintainers:
+  - Lorenzo Bianconi <lorenzo@kernel.org>
+  - Felix Fietkau <nbd@nbd.name>
+
+description:
+  The mediatek WO-dlm provides a configuration interface for WED WO
+  rx ring on MT7986 soc.
+
+properties:
+  compatible:
+    const: mediatek,wocpu_dlm
+
+  reg:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - resets
+  - reset-names
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/reset/ti-syscon.h>
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      ethsys: syscon@15000000 {
+        #address-cells = <1>;
+        #size-cells = <1>;
+        compatible = "mediatek,mt7986-ethsys", "syscon";
+        reg = <0 0x15000000 0 0x1000>;
+
+        #clock-cells = <1>;
+        #reset-cells = <1>;
+        ethsysrst: reset-controller {
+          compatible = "ti,syscon-reset";
+          #reset-cells = <1>;
+          ti,reset-bits = <0x34 4 0x34 4 0x34 4 (ASSERT_SET | DEASSERT_CLEAR | STATUS_SET)>;
+        };
+      };
+
+      wocpu0_dlm: wocpu_dlm@151e8000 {
+        compatible = "mediatek,wocpu_dlm";
+        reg = <0 0x151e8000 0 0x2000>;
+        resets = <&ethsysrst 0>;
+        reset-names = "wocpu_rst";
+      };
+    };
-- 
2.37.3

