Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9887F564F06
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 09:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbiGDHu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 03:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbiGDHuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 03:50:52 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1F4DA1B4;
        Mon,  4 Jul 2022 00:50:50 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.92,243,1650898800"; 
   d="scan'208";a="126598607"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 04 Jul 2022 16:50:50 +0900
Received: from localhost.localdomain (unknown [10.226.92.214])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id A1EA5422FDEB;
        Mon,  4 Jul 2022 16:50:45 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 2/6] dt-bindings: can: nxp,sja1000: Document RZ/N1{D,S} support
Date:   Mon,  4 Jul 2022 08:50:28 +0100
Message-Id: <20220704075032.383700-3-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220704075032.383700-1-biju.das.jz@bp.renesas.com>
References: <20220704075032.383700-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add CAN binding documentation for Renesas RZ/N1 SoC.

The SJA1000 CAN controller on RZ/N1 SoC has some differences compared
to others like it has no clock divider register (CDR) support and it has
no HW loopback (HW doesn't see tx messages on rx), so introduced a new
compatible 'renesas,rzn1-sja1000' to handle these differences.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v2->v3:
 * Added reg-io-width is required property for renesas,rzn1-sja1000.
v1->v2:
 * Updated commit description.
 * Added an example for RZ/N1D SJA1000 usage
---
 .../bindings/net/can/nxp,sja1000.yaml         | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
index d34060226e4e..16786475eae3 100644
--- a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
+++ b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
@@ -19,6 +19,16 @@ allOf:
     then:
       required:
         - reg-io-width
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: renesas,rzn1-sja1000
+    then:
+      required:
+        - clocks
+        - clock-names
+        - reg-io-width
 
 properties:
   compatible:
@@ -27,6 +37,12 @@ properties:
         const: nxp,sja1000
       - description: Technologic Systems SJA1000 CAN Controller
         const: technologic,sja1000
+      - description: Renesas RZ/N1 SJA1000 CAN Controller
+        items:
+          - enum:
+              - renesas,r9a06g032-sja1000 # RZ/N1D
+              - renesas,r9a06g033-sja1000 # RZ/N1S
+          - const: renesas,rzn1-sja1000 # RZ/N1
 
   reg:
     maxItems: 1
@@ -34,6 +50,12 @@ properties:
   interrupts:
     maxItems: 1
 
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    const: can_clk
+
   reg-io-width:
     $ref: /schemas/types.yaml#/definitions/uint32
     description: I/O register width (in bytes) implemented by this device
@@ -101,3 +123,16 @@ examples:
             nxp,tx-output-config = <0x06>;
             nxp,external-clock-frequency = <24000000>;
     };
+
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/r9a06g032-sysctrl.h>
+
+    can@52104000 {
+            compatible = "renesas,r9a06g032-sja1000","renesas,rzn1-sja1000";
+            reg = <0x52104000 0x800>;
+            reg-io-width = <4>;
+            interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
+            clocks = <&sysctrl R9A06G032_HCLK_CAN0>;
+            clock-names = "can_clk";
+    };
-- 
2.25.1

