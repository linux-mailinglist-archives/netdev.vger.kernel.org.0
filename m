Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9DA3D76B5
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbhG0NbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:31:01 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:3045 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236828AbhG0Naj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:30:39 -0400
X-IronPort-AV: E=Sophos;i="5.84,273,1620658800"; 
   d="scan'208";a="88920763"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 27 Jul 2021 22:30:37 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id B90284270492;
        Tue, 27 Jul 2021 22:30:33 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH v4 1/3] dt-bindings: net: can: renesas,rcar-canfd: Document RZ/G2L SoC
Date:   Tue, 27 Jul 2021 14:30:20 +0100
Message-Id: <20210727133022.634-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727133022.634-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210727133022.634-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add CANFD binding documentation for Renesas RZ/G2L SoC.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../bindings/net/can/renesas,rcar-canfd.yaml  | 69 +++++++++++++++++--
 1 file changed, 63 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
index 0b33ba9ccb47..546c6e6d2fb0 100644
--- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
@@ -30,13 +30,15 @@ properties:
               - renesas,r8a77995-canfd     # R-Car D3
           - const: renesas,rcar-gen3-canfd # R-Car Gen3 and RZ/G2
 
+      - items:
+          - enum:
+              - renesas,r9a07g044-canfd    # RZ/G2{L,LC}
+          - const: renesas,rzg2l-canfd     # RZ/G2L family
+
   reg:
     maxItems: 1
 
-  interrupts:
-    items:
-      - description: Channel interrupt
-      - description: Global interrupt
+  interrupts: true
 
   clocks:
     maxItems: 3
@@ -50,8 +52,7 @@ properties:
   power-domains:
     maxItems: 1
 
-  resets:
-    maxItems: 1
+  resets: true
 
   renesas,no-can-fd:
     $ref: /schemas/types.yaml#/definitions/flag
@@ -91,6 +92,62 @@ required:
   - channel0
   - channel1
 
+if:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - renesas,rzg2l-canfd
+then:
+  properties:
+    interrupts:
+      items:
+        - description: CAN global error interrupt
+        - description: CAN receive FIFO interrupt
+        - description: CAN0 error interrupt
+        - description: CAN0 transmit interrupt
+        - description: CAN0 transmit/receive FIFO receive completion interrupt
+        - description: CAN1 error interrupt
+        - description: CAN1 transmit interrupt
+        - description: CAN1 transmit/receive FIFO receive completion interrupt
+
+    interrupt-names:
+      items:
+        - const: g_err
+        - const: g_recc
+        - const: ch0_err
+        - const: ch0_rec
+        - const: ch0_trx
+        - const: ch1_err
+        - const: ch1_rec
+        - const: ch1_trx
+
+    resets:
+      maxItems: 2
+
+    reset-names:
+      items:
+        - const: rstp_n
+        - const: rstc_n
+
+  required:
+    - interrupt-names
+    - reset-names
+else:
+  properties:
+    interrupts:
+      items:
+        - description: Channel interrupt
+        - description: Global interrupt
+
+    interrupt-names:
+      items:
+        - const: ch_int
+        - const: g_int
+
+    resets:
+      maxItems: 1
+
 unevaluatedProperties: false
 
 examples:
-- 
2.17.1

