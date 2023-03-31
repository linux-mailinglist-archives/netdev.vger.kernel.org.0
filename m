Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEBF36D2149
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbjCaNOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbjCaNOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:14:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C841D921;
        Fri, 31 Mar 2023 06:14:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 95453CE2F67;
        Fri, 31 Mar 2023 13:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A232C4339B;
        Fri, 31 Mar 2023 13:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680268442;
        bh=fWp4pnTJD6ujYu6baXkTpEw8R10yq2a2e3WshWOsoi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O78v4MA3B5ozyLWWBY/eyfLNI8PD/9KVAWRL6xcOM3oULxFydgffux6ZeQ9XdprDx
         WVpVfY/BVACj0pL9whFW+cBK1Fgzk1990UZy5rEToMpQfhL0ksno/8iOHPHAsVjOIB
         azc5yCHyMuhIjJVpgCf8P18Mr4wMqCH0SFV8n7Pi9B6nqkAJ840+6nZ6294V1QQkc9
         jUCYEP6l52FGREetP7OpAVIsh/6kYbaiz3heUahpay9vTt1FgtneRJMTzFtKdduHs7
         UrbuSSSF98V+/NicwUizG4yAohcbMXCyac7+2o+g2Nn4Tb/IykZedsReT3YzU6q6LW
         fz3v+Baegr9UQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 net-next 09/10] dt-bindings: soc: mediatek: move dlm in a dedicated dts node
Date:   Fri, 31 Mar 2023 15:12:45 +0200
Message-Id: <6c169516bad15826a292d66923e49e28c9a64146.1680268101.git.lorenzo@kernel.org>
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

Since the dlm memory region is not part of the MT7986 RAM SoC, move dlm in
a deidicated syscon node.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../arm/mediatek/mediatek,mt7622-wed.yaml     | 12 +++--
 .../soc/mediatek/mediatek,mt7986-wo-dlm.yaml  | 46 +++++++++++++++++++
 2 files changed, 54 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-dlm.yaml

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
index e63fb22447c6..e4707880eca7 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
@@ -32,13 +32,11 @@ properties:
   memory-region:
     items:
       - description: firmware EMI region
-      - description: firmware DLM region
       - description: firmware CPU DATA region
 
   memory-region-names:
     items:
       - const: wo-emi
-      - const: wo-dlm
       - const: wo-data
 
   mediatek,wo-ccif:
@@ -53,6 +51,10 @@ properties:
     $ref: /schemas/types.yaml#/definitions/phandle
     description: mediatek wed-wo ilm interface.
 
+  mediatek,wo-dlm:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: mediatek wed-wo dlm interface.
+
 allOf:
   - if:
       properties:
@@ -66,6 +68,7 @@ allOf:
         mediatek,wo-ccif: false
         mediatek,wo-cpuboot: false
         mediatek,wo-ilm: false
+        mediatek,wo-dlm: false
 
 required:
   - compatible
@@ -100,10 +103,11 @@ examples:
         reg = <0 0x15010000 0 0x1000>;
         interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
 
-        memory-region = <&wo_emi>, <&wo_dlm>, <&wo_data>;
-        memory-region-names = "wo-emi", "wo-dlm", "wo-data";
+        memory-region = <&wo_emi>, <&wo_data>;
+        memory-region-names = "wo-emi", "wo-data";
         mediatek,wo-ccif = <&wo_ccif0>;
         mediatek,wo-cpuboot = <&wo_cpuboot>;
         mediatek,wo-ilm = <&wo_ilm>;
+        mediatek,wo-dlm = <&wo_dlm>;
       };
     };
diff --git a/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-dlm.yaml b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-dlm.yaml
new file mode 100644
index 000000000000..2b9c6a8ef918
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-dlm.yaml
@@ -0,0 +1,46 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/soc/mediatek/mediatek,mt7986-wo-dlm.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek Wireless Ethernet Dispatch (WED) WO DLM firmware interface for MT7986
+
+maintainers:
+  - Lorenzo Bianconi <lorenzo@kernel.org>
+  - Felix Fietkau <nbd@nbd.name>
+
+description:
+  The MediaTek wo-dlm (Data Lifecycle Management) provides a configuration
+  interface for WED WO firmware rx rings, including firmware I/O descriptor
+  ring, feedback command ring. WED WO controller is used to perform offload
+  rx packet processing (e.g. 802.11 aggregation packet reordering or rx
+  header translation) on MT7986 soc.
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - mediatek,mt7986-wo-dlm
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
+      syscon@151e8000 {
+        compatible = "mediatek,mt7986-wo-dlm", "syscon";
+        reg = <0 0x151e8000 0 0x2000>;
+      };
+    };
-- 
2.39.2

