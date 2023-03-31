Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453196D213D
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbjCaNNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbjCaNNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:13:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC391A941;
        Fri, 31 Mar 2023 06:13:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CCBC62904;
        Fri, 31 Mar 2023 13:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C94AC433D2;
        Fri, 31 Mar 2023 13:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680268419;
        bh=/usCdjjdk5pmrYcvc63cZkA8n8A5vCGCRoBFREfreXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktSReE20BLiQkThthcOvaMG8Ftq8Tm2tVd77CqL7hM0MJeeqpOQm8tHPOeJUcUt/T
         FQkfjyaZ4qfcY4d8fZK/Wn9lFaQI7jwcflu23RroSreQuilgq8pjKyMVt2EyDOQx4k
         cVRa0n9VMgMQ2AbpHO9+UDncIpV9dRHea8FHXc5pcWwCFO0Ub5sdJdakB3UfbgHgEe
         EiLdsdBF3byCBRNEptkccpmo6pNYM4PjFz7KAxIXhrC0sx1DFBHbdgUEIMASZQ5h7B
         sOHV6WLWm1bm4qaT18JkijydAfAY+LeIj8sYcL2mozHUeY8R21eQiiJCZxlqQ4Tgsq
         79ihvOLSw+oWQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 net-next 03/10] dt-bindings: soc: mediatek: move cpuboot in a dedicated dts node
Date:   Fri, 31 Mar 2023 15:12:39 +0200
Message-Id: <62ef3b737de26c3b7f553e1a35a12c36e290773e.1680268101.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680268101.git.lorenzo@kernel.org>
References: <cover.1680268101.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the cpuboot memory region is not part of the MT7986 RAM SoC,
move cpuboot in a deidicated syscon node.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../arm/mediatek/mediatek,mt7622-wed.yaml     | 12 +++--
 .../mediatek/mediatek,mt7986-wo-cpuboot.yaml  | 45 +++++++++++++++++++
 2 files changed, 53 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-cpuboot.yaml

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
index 5c223cb063d4..7f6638d43854 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
@@ -35,7 +35,6 @@ properties:
       - description: firmware ILM region
       - description: firmware DLM region
       - description: firmware CPU DATA region
-      - description: firmware BOOT region
 
   memory-region-names:
     items:
@@ -43,12 +42,15 @@ properties:
       - const: wo-ilm
       - const: wo-dlm
       - const: wo-data
-      - const: wo-boot
 
   mediatek,wo-ccif:
     $ref: /schemas/types.yaml#/definitions/phandle
     description: mediatek wed-wo controller interface.
 
+  mediatek,wo-cpuboot:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: mediatek wed-wo cpuboot controller interface.
+
 allOf:
   - if:
       properties:
@@ -60,6 +62,7 @@ allOf:
         memory-region-names: false
         memory-region: false
         mediatek,wo-ccif: false
+        mediatek,wo-cpuboot: false
 
 required:
   - compatible
@@ -95,9 +98,10 @@ examples:
         interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
 
         memory-region = <&wo_emi>, <&wo_ilm>, <&wo_dlm>,
-                        <&wo_data>, <&wo_boot>;
+                        <&wo_data>;
         memory-region-names = "wo-emi", "wo-ilm", "wo-dlm",
-                              "wo-data", "wo-boot";
+                              "wo-data";
         mediatek,wo-ccif = <&wo_ccif0>;
+        mediatek,wo-cpuboot = <&wo_cpuboot>;
       };
     };
diff --git a/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-cpuboot.yaml b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-cpuboot.yaml
new file mode 100644
index 000000000000..1b45c8a86989
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-cpuboot.yaml
@@ -0,0 +1,45 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/soc/mediatek/mediatek,mt7986-wo-cpuboot.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek Wireless Ethernet Dispatch (WED) WO Boot firmware interface for MT7986
+
+maintainers:
+  - Lorenzo Bianconi <lorenzo@kernel.org>
+  - Felix Fietkau <nbd@nbd.name>
+
+description:
+  The MediaTek wo-cpuboot provides a configuration interface for WED WO
+  controller boot firmware. WED is used to perform offload rx packet
+  processing (e.g. 802.11 aggregation packet reordering or rx header
+  translation) on MT7986 soc.
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - mediatek,mt7986-wo-cpuboot
+      - const: syscon
+
+  reg:
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
+
+      syscon@15194000 {
+        compatible = "mediatek,mt7986-wo-cpuboot", "syscon";
+        reg = <0 0x15194000 0 0x1000>;
+      };
+    };
-- 
2.39.2

