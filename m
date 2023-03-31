Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4736D2143
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbjCaNOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjCaNOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:14:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EA320C1F;
        Fri, 31 Mar 2023 06:13:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CA62B82F6C;
        Fri, 31 Mar 2023 13:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D59C433EF;
        Fri, 31 Mar 2023 13:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680268431;
        bh=EPYHZ8tZ9OKv8lK5Q0XeiNsOLRPnw/R2yxzVXTgnTqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGsugcbk1J4ACNuQHPhzp+WllX6tzk0z75JdIM31NXpukcJbSSyH7zwefpJqsdXcw
         iikWnbjXwDqhe3+WIQS6SzcHl5e5v4dq+kF7cG12J0+qF6+hD/8ARyQ1c0UTexiYKq
         Zp/xMXtRezNakgSeyeG3QKLNtgMDHEhj8X4qHnzOKoGUKEJ10xGeTbx7R6rmEHQata
         hnv7sGqSTcSHZV73HOqlGF1O6XnZl1dv8ndlrM+DfU/4R7P2U1+p7Kl2LF2HMWwObz
         RmoO7J4eT4K9iqtsDC8P9lNxqq7hT8W3b9otDOxLJHSSGKcBfBDhk/W29Crsh0HLVF
         3tZL9fq1KU+5w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 net-next 06/10] dt-bindings: soc: mediatek: move ilm in a dedicated dts node
Date:   Fri, 31 Mar 2023 15:12:42 +0200
Message-Id: <18109725ba14d2fe5c00e627b064b38b5c8f2223.1680268101.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680268101.git.lorenzo@kernel.org>
References: <cover.1680268101.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the ilm memory region is not part of the MT7986 RAM SoC, move ilm
in a deidicated syscon node.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../arm/mediatek/mediatek,mt7622-wed.yaml     | 14 +++---
 .../soc/mediatek/mediatek,mt7986-wo-ilm.yaml  | 45 +++++++++++++++++++
 2 files changed, 53 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-ilm.yaml

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
index 7f6638d43854..e63fb22447c6 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
@@ -32,14 +32,12 @@ properties:
   memory-region:
     items:
       - description: firmware EMI region
-      - description: firmware ILM region
       - description: firmware DLM region
       - description: firmware CPU DATA region
 
   memory-region-names:
     items:
       - const: wo-emi
-      - const: wo-ilm
       - const: wo-dlm
       - const: wo-data
 
@@ -51,6 +49,10 @@ properties:
     $ref: /schemas/types.yaml#/definitions/phandle
     description: mediatek wed-wo cpuboot controller interface.
 
+  mediatek,wo-ilm:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: mediatek wed-wo ilm interface.
+
 allOf:
   - if:
       properties:
@@ -63,6 +65,7 @@ allOf:
         memory-region: false
         mediatek,wo-ccif: false
         mediatek,wo-cpuboot: false
+        mediatek,wo-ilm: false
 
 required:
   - compatible
@@ -97,11 +100,10 @@ examples:
         reg = <0 0x15010000 0 0x1000>;
         interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
 
-        memory-region = <&wo_emi>, <&wo_ilm>, <&wo_dlm>,
-                        <&wo_data>;
-        memory-region-names = "wo-emi", "wo-ilm", "wo-dlm",
-                              "wo-data";
+        memory-region = <&wo_emi>, <&wo_dlm>, <&wo_data>;
+        memory-region-names = "wo-emi", "wo-dlm", "wo-data";
         mediatek,wo-ccif = <&wo_ccif0>;
         mediatek,wo-cpuboot = <&wo_cpuboot>;
+        mediatek,wo-ilm = <&wo_ilm>;
       };
     };
diff --git a/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-ilm.yaml b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-ilm.yaml
new file mode 100644
index 000000000000..2a3775cd941e
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-ilm.yaml
@@ -0,0 +1,45 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/soc/mediatek/mediatek,mt7986-wo-ilm.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek Wireless Ethernet Dispatch (WED) WO ILM firmware interface for MT7986
+
+maintainers:
+  - Lorenzo Bianconi <lorenzo@kernel.org>
+  - Felix Fietkau <nbd@nbd.name>
+
+description:
+  The MediaTek wo-ilm (Information Lifecycle Management) provides a configuration
+  interface for WiFi critical data used by WED WO firmware. WED WO controller is
+  used to perform offload rx packet processing (e.g. 802.11 aggregation packet
+  reordering or rx header translation) on MT7986 soc.
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - mediatek,mt7986-wo-ilm
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
+      syscon@151e0000 {
+        compatible = "mediatek,mt7986-wo-ilm", "syscon";
+        reg = <0 0x151e0000 0 0x8000>;
+      };
+    };
-- 
2.39.2

