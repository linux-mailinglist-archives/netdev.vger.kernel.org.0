Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB2260FD17
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 18:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbiJ0Qb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 12:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235780AbiJ0Qb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 12:31:27 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1955F7F7;
        Thu, 27 Oct 2022 09:31:25 -0700 (PDT)
Received: from jupiter.universe (dyndsl-091-096-035-205.ewe-ip-backbone.de [91.96.35.205])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id AD76B6602395;
        Thu, 27 Oct 2022 17:31:23 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1666888283;
        bh=tNJIBKPU1noslMNdOTmfTOssBT36wHtENk08g0qT7PY=;
        h=From:To:Cc:Subject:Date:From;
        b=F4LnUtrde4AQGUth8pPLJ/X9TUpIgeHPAlMAxevseuUrpPCO7x0GjrEG4B2/SynV1
         35HkwAyPao8RjpKwOL1HpFVN5KIMMIYTXW3QfHz6ef4Y/psCCK7pQbnWIUkSSPMMGx
         rxrLfUig9lxJARuh0jW2bN6qgMp1/dVxawd9GUatllWamKctzgkBCSGn4IZVNAsieA
         xlWq6OnFK3oNQm/oKHkxOr5ffC2r8vZxggfmQjJCc6Bpi2xudAVUQYFH9PA1AIgU2U
         TrY9bvrrIPausH/tQEdbvd2OFECYL7GJT5C5B74eajeaJZWGzU2m7vNOE9VQpgqG5A
         KfC31Cez/aJhw==
Received: by jupiter.universe (Postfix, from userid 1000)
        id 057BF4801B9; Thu, 27 Oct 2022 18:31:21 +0200 (CEST)
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        kernel@collabora.com
Subject: [PATCHv2 1/1] dt-bindings: net: snps,dwmac: Document queue config subnodes
Date:   Thu, 27 Oct 2022 18:31:19 +0200
Message-Id: <20221027163119.107092-1-sebastian.reichel@collabora.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The queue configuration is referenced by snps,mtl-rx-config and
snps,mtl-tx-config. Some in-tree DTs and the example put the
referenced config nodes directly beneath the root node, but
most in-tree DTs put it as child node of the dwmac node.

This adds proper description for this setup, which has the
advantage of validating the queue configuration node content.

The example is also updated to use the sub-node style, incl.
the axi bus configuration node, which got the same treatment
as the queues config in 5361660af6d3 ("dt-bindings: net: snps,dwmac:
Document stmmac-axi-config subnode").

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
Changes since PATCHv1:
 * https://lore.kernel.org/all/20221021171055.85888-1-sebastian.reichel@collabora.com/
 * add logic to make booleans that are actually enums mutually exclusive
 * fix type of "snps,send_slope", "snps,idle_slope", "snps,high_credit" and "snps,low_credit"
 * add missing 'additionalProperties: false' in rx-queues-config -> "^queue[0-9]$"
 * add missing 'additionalProperties: false' in tx-queues-config -> "^queue[0-9]$"
 * update example to follow the sub-node style
---
 .../devicetree/bindings/net/snps,dwmac.yaml   | 345 ++++++++++++++----
 1 file changed, 264 insertions(+), 81 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 13b984076af5..e88a86623fce 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -167,56 +167,238 @@ properties:
   snps,mtl-rx-config:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
-      Multiple RX Queues parameters. Phandle to a node that can
-      contain the following properties
-        * snps,rx-queues-to-use, number of RX queues to be used in the
-          driver
-        * Choose one of these RX scheduling algorithms
-          * snps,rx-sched-sp, Strict priority
-          * snps,rx-sched-wsp, Weighted Strict priority
-        * For each RX queue
-          * Choose one of these modes
-            * snps,dcb-algorithm, Queue to be enabled as DCB
-            * snps,avb-algorithm, Queue to be enabled as AVB
-          * snps,map-to-dma-channel, Channel to map
-          * Specifiy specific packet routing
-            * snps,route-avcp, AV Untagged Control packets
-            * snps,route-ptp, PTP Packets
-            * snps,route-dcbcp, DCB Control Packets
-            * snps,route-up, Untagged Packets
-            * snps,route-multi-broad, Multicast & Broadcast Packets
-          * snps,priority, bitmask of the tagged frames priorities assigned to
-            the queue
+      Multiple RX Queues parameters. Phandle to a node that
+      implements the 'rx-queues-config' object described in
+      this binding.
+
+  rx-queues-config:
+    type: object
+    properties:
+      snps,rx-queues-to-use:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description: number of RX queues to be used in the driver
+      snps,rx-sched-sp:
+        type: boolean
+        description: Strict priority
+      snps,rx-sched-wsp:
+        type: boolean
+        description: Weighted Strict priority
+    allOf:
+      - if:
+          required:
+            - snps,rx-sched-sp
+        then:
+          properties:
+            snps,rx-sched-wsp: false
+      - if:
+          required:
+            - snps,rx-sched-wsp
+        then:
+          properties:
+            snps,rx-sched-sp: false
+    patternProperties:
+      "^queue[0-9]$":
+        description: Each subnode represents a queue.
+        type: object
+        properties:
+          snps,dcb-algorithm:
+            type: boolean
+            description: Queue to be enabled as DCB
+          snps,avb-algorithm:
+            type: boolean
+            description: Queue to be enabled as AVB
+          snps,map-to-dma-channel:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: DMA channel id to map
+          snps,route-avcp:
+            type: boolean
+            description: AV Untagged Control packets
+          snps,route-ptp:
+            type: boolean
+            description: PTP Packets
+          snps,route-dcbcp:
+            type: boolean
+            description: DCB Control Packets
+          snps,route-up:
+            type: boolean
+            description: Untagged Packets
+          snps,route-multi-broad:
+            type: boolean
+            description: Multicast & Broadcast Packets
+          snps,priority:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: Bitmask of the tagged frames priorities assigned to the queue
+        allOf:
+          - if:
+              required:
+                - snps,dcb-algorithm
+            then:
+              properties:
+                snps,avb-algorithm: false
+          - if:
+              required:
+                - snps,avb-algorithm
+            then:
+              properties:
+                snps,dcb-algorithm: false
+          - if:
+              required:
+                - snps,route-avcp
+            then:
+              properties:
+                snps,route-ptp: false
+                snps,route-dcbcp: false
+                snps,route-up: false
+                snps,route-multi-broad: false
+          - if:
+              required:
+                - snps,route-ptp
+            then:
+              properties:
+                snps,route-avcp: false
+                snps,route-dcbcp: false
+                snps,route-up: false
+                snps,route-multi-broad: false
+          - if:
+              required:
+                - snps,route-dcbcp
+            then:
+              properties:
+                snps,route-avcp: false
+                snps,route-ptp: false
+                snps,route-up: false
+                snps,route-multi-broad: false
+          - if:
+              required:
+                - snps,route-up
+            then:
+              properties:
+                snps,route-avcp: false
+                snps,route-ptp: false
+                snps,route-dcbcp: false
+                snps,route-multi-broad: false
+          - if:
+              required:
+                - snps,route-multi-broad
+            then:
+              properties:
+                snps,route-avcp: false
+                snps,route-ptp: false
+                snps,route-dcbcp: false
+                snps,route-up: false
+        additionalProperties: false
+    additionalProperties: false
 
   snps,mtl-tx-config:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
-      Multiple TX Queues parameters. Phandle to a node that can
-      contain the following properties
-        * snps,tx-queues-to-use, number of TX queues to be used in the
-          driver
-        * Choose one of these TX scheduling algorithms
-          * snps,tx-sched-wrr, Weighted Round Robin
-          * snps,tx-sched-wfq, Weighted Fair Queuing
-          * snps,tx-sched-dwrr, Deficit Weighted Round Robin
-          * snps,tx-sched-sp, Strict priority
-        * For each TX queue
-          * snps,weight, TX queue weight (if using a DCB weight
-            algorithm)
-          * Choose one of these modes
-            * snps,dcb-algorithm, TX queue will be working in DCB
-            * snps,avb-algorithm, TX queue will be working in AVB
-              [Attention] Queue 0 is reserved for legacy traffic
-                          and so no AVB is available in this queue.
-          * Configure Credit Base Shaper (if AVB Mode selected)
-            * snps,send_slope, enable Low Power Interface
-            * snps,idle_slope, unlock on WoL
-            * snps,high_credit, max write outstanding req. limit
-            * snps,low_credit, max read outstanding req. limit
-          * snps,priority, bitmask of the priorities assigned to the queue.
-            When a PFC frame is received with priorities matching the bitmask,
-            the queue is blocked from transmitting for the pause time specified
-            in the PFC frame.
+      Multiple TX Queues parameters. Phandle to a node that
+      implements the 'tx-queues-config' object described in
+      this binding.
+
+  tx-queues-config:
+    type: object
+    properties:
+      snps,tx-queues-to-use:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description: number of TX queues to be used in the driver
+      snps,tx-sched-wrr:
+        type: boolean
+        description: Weighted Round Robin
+      snps,tx-sched-wfq:
+        type: boolean
+        description: Weighted Fair Queuing
+      snps,tx-sched-dwrr:
+        type: boolean
+        description: Deficit Weighted Round Robin
+      snps,tx-sched-sp:
+        type: boolean
+        description: Strict priority
+    allOf:
+      - if:
+          required:
+            - snps,tx-sched-wrr
+        then:
+          properties:
+            snps,tx-sched-wfq: false
+            snps,tx-sched-dwrr: false
+            snps,tx-sched-sp: false
+      - if:
+          required:
+            - snps,tx-sched-wfq
+        then:
+          properties:
+            snps,tx-sched-wrr: false
+            snps,tx-sched-dwrr: false
+            snps,tx-sched-sp: false
+      - if:
+          required:
+            - snps,tx-sched-dwrr
+        then:
+          properties:
+            snps,tx-sched-wrr: false
+            snps,tx-sched-wfq: false
+            snps,tx-sched-sp: false
+      - if:
+          required:
+            - snps,tx-sched-sp
+        then:
+          properties:
+            snps,tx-sched-wrr: false
+            snps,tx-sched-wfq: false
+            snps,tx-sched-dwrr: false
+    patternProperties:
+      "^queue[0-9]$":
+        description: Each subnode represents a queue.
+        type: object
+        properties:
+          snps,weight:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: TX queue weight (if using a DCB weight algorithm)
+          snps,dcb-algorithm:
+            type: boolean
+            description: TX queue will be working in DCB
+          snps,avb-algorithm:
+            type: boolean
+            description:
+              TX queue will be working in AVB.
+              Queue 0 is reserved for legacy traffic and so no AVB is
+              available in this queue.
+          snps,send_slope:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: enable Low Power Interface
+          snps,idle_slope:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: unlock on WoL
+          snps,high_credit:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: max write outstanding req. limit
+          snps,low_credit:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: max read outstanding req. limit
+          snps,priority:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description:
+              Bitmask of the tagged frames priorities assigned to the queue.
+              When a PFC frame is received with priorities matching the bitmask,
+              the queue is blocked from transmitting for the pause time specified
+              in the PFC frame.
+        allOf:
+          - if:
+              required:
+                - snps,dcb-algorithm
+            then:
+              properties:
+                snps,avb-algorithm: false
+          - if:
+              required:
+                - snps,avb-algorithm
+            then:
+              properties:
+                snps,dcb-algorithm: false
+                snps,weight: false
+        additionalProperties: false
+    additionalProperties: false
 
   snps,reset-gpio:
     deprecated: true
@@ -463,41 +645,6 @@ additionalProperties: true
 
 examples:
   - |
-    stmmac_axi_setup: stmmac-axi-config {
-        snps,wr_osr_lmt = <0xf>;
-        snps,rd_osr_lmt = <0xf>;
-        snps,blen = <256 128 64 32 0 0 0>;
-    };
-
-    mtl_rx_setup: rx-queues-config {
-        snps,rx-queues-to-use = <1>;
-        snps,rx-sched-sp;
-        queue0 {
-            snps,dcb-algorithm;
-            snps,map-to-dma-channel = <0x0>;
-            snps,priority = <0x0>;
-        };
-    };
-
-    mtl_tx_setup: tx-queues-config {
-        snps,tx-queues-to-use = <2>;
-        snps,tx-sched-wrr;
-        queue0 {
-            snps,weight = <0x10>;
-            snps,dcb-algorithm;
-            snps,priority = <0x0>;
-        };
-
-        queue1 {
-            snps,avb-algorithm;
-            snps,send_slope = <0x1000>;
-            snps,idle_slope = <0x1000>;
-            snps,high_credit = <0x3E800>;
-            snps,low_credit = <0xFFC18000>;
-            snps,priority = <0x1>;
-        };
-    };
-
     gmac0: ethernet@e0800000 {
         compatible = "snps,dwxgmac-2.10", "snps,dwxgmac";
         reg = <0xe0800000 0x8000>;
@@ -516,6 +663,42 @@ examples:
         snps,axi-config = <&stmmac_axi_setup>;
         snps,mtl-rx-config = <&mtl_rx_setup>;
         snps,mtl-tx-config = <&mtl_tx_setup>;
+
+        stmmac_axi_setup: stmmac-axi-config {
+            snps,wr_osr_lmt = <0xf>;
+            snps,rd_osr_lmt = <0xf>;
+            snps,blen = <256 128 64 32 0 0 0>;
+        };
+
+        mtl_rx_setup: rx-queues-config {
+            snps,rx-queues-to-use = <1>;
+            snps,rx-sched-sp;
+            queue0 {
+                snps,dcb-algorithm;
+                snps,map-to-dma-channel = <0x0>;
+                snps,priority = <0x0>;
+            };
+        };
+
+        mtl_tx_setup: tx-queues-config {
+            snps,tx-queues-to-use = <2>;
+            snps,tx-sched-wrr;
+            queue0 {
+                snps,weight = <0x10>;
+                snps,dcb-algorithm;
+                snps,priority = <0x0>;
+            };
+
+            queue1 {
+                snps,avb-algorithm;
+                snps,send_slope = <0x1000>;
+                snps,idle_slope = <0x1000>;
+                snps,high_credit = <0x3E800>;
+                snps,low_credit = <0xFFC18000>;
+                snps,priority = <0x1>;
+            };
+        };
+
         mdio0 {
             #address-cells = <1>;
             #size-cells = <0>;
-- 
2.35.1

