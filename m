Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB05A649DE2
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiLLLcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbiLLLbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A286A18E
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:31:10 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1Y-0000eN-Df
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:31:08 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E12D013CC58
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:57 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8B98813CBFA;
        Mon, 12 Dec 2022 11:30:55 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 47c134c5;
        Mon, 12 Dec 2022 11:30:48 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 28/39] dt-bindings: can: renesas,rcar-canfd: Fix number of channels for R-Car V3U
Date:   Mon, 12 Dec 2022 12:30:34 +0100
Message-Id: <20221212113045.222493-29-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212113045.222493-1-mkl@pengutronix.de>
References: <20221212113045.222493-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

According to the bindings, only two channels are supported.
However, R-Car V3U supports eight, leading to "make dtbs" failures:

        arch/arm64/boot/dts/renesas/r8a779a0-falcon.dtb: can@e6660000: Unevaluated properties are not allowed ('channel2', 'channel3', 'channel4', 'channel5', 'channel6', 'channel7' were unexpected)

Update the number of channels to 8 on R-Car V3U.
While at it, prevent adding more properties to the channel nodes, as
they must contain no other properties than a status property.

Fixes: d6254d52d70de530 ("dt-bindings: can: renesas,rcar-canfd: Document r8a779a0 support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/all/7d41d72cd7db2e90bae069ce57dbb672f17500ae.1670431681.git.geert+renesas@glider.be
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../bindings/net/can/renesas,rcar-canfd.yaml  | 133 ++++++++++--------
 1 file changed, 72 insertions(+), 61 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
index 8347053a96dc..1eb98c9a1a26 100644
--- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
@@ -9,9 +9,6 @@ title: Renesas R-Car CAN FD Controller
 maintainers:
   - Fabrizio Castro <fabrizio.castro.jz@renesas.com>
 
-allOf:
-  - $ref: can-controller.yaml#
-
 properties:
   compatible:
     oneOf:
@@ -77,12 +74,13 @@ properties:
     description: Maximum frequency of the CANFD clock.
 
 patternProperties:
-  "^channel[01]$":
+  "^channel[0-7]$":
     type: object
     description:
-      The controller supports two channels and each is represented as a child
-      node.  Each child node supports the "status" property only, which
-      is used to enable/disable the respective channel.
+      The controller supports multiple channels and each is represented as a
+      child node.  Each channel can be enabled/disabled individually.
+
+    additionalProperties: false
 
 required:
   - compatible
@@ -98,60 +96,73 @@ required:
   - channel0
   - channel1
 
-if:
-  properties:
-    compatible:
-      contains:
-        enum:
-          - renesas,rzg2l-canfd
-then:
-  properties:
-    interrupts:
-      items:
-        - description: CAN global error interrupt
-        - description: CAN receive FIFO interrupt
-        - description: CAN0 error interrupt
-        - description: CAN0 transmit interrupt
-        - description: CAN0 transmit/receive FIFO receive completion interrupt
-        - description: CAN1 error interrupt
-        - description: CAN1 transmit interrupt
-        - description: CAN1 transmit/receive FIFO receive completion interrupt
-
-    interrupt-names:
-      items:
-        - const: g_err
-        - const: g_recc
-        - const: ch0_err
-        - const: ch0_rec
-        - const: ch0_trx
-        - const: ch1_err
-        - const: ch1_rec
-        - const: ch1_trx
-
-    resets:
-      maxItems: 2
-
-    reset-names:
-      items:
-        - const: rstp_n
-        - const: rstc_n
-
-  required:
-    - reset-names
-else:
-  properties:
-    interrupts:
-      items:
-        - description: Channel interrupt
-        - description: Global interrupt
-
-    interrupt-names:
-      items:
-        - const: ch_int
-        - const: g_int
-
-    resets:
-      maxItems: 1
+allOf:
+  - $ref: can-controller.yaml#
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - renesas,rzg2l-canfd
+    then:
+      properties:
+        interrupts:
+          items:
+            - description: CAN global error interrupt
+            - description: CAN receive FIFO interrupt
+            - description: CAN0 error interrupt
+            - description: CAN0 transmit interrupt
+            - description: CAN0 transmit/receive FIFO receive completion interrupt
+            - description: CAN1 error interrupt
+            - description: CAN1 transmit interrupt
+            - description: CAN1 transmit/receive FIFO receive completion interrupt
+
+        interrupt-names:
+          items:
+            - const: g_err
+            - const: g_recc
+            - const: ch0_err
+            - const: ch0_rec
+            - const: ch0_trx
+            - const: ch1_err
+            - const: ch1_rec
+            - const: ch1_trx
+
+        resets:
+          maxItems: 2
+
+        reset-names:
+          items:
+            - const: rstp_n
+            - const: rstc_n
+
+      required:
+        - reset-names
+    else:
+      properties:
+        interrupts:
+          items:
+            - description: Channel interrupt
+            - description: Global interrupt
+
+        interrupt-names:
+          items:
+            - const: ch_int
+            - const: g_int
+
+        resets:
+          maxItems: 1
+
+  - if:
+      not:
+        properties:
+          compatible:
+            contains:
+              const: renesas,r8a779a0-canfd
+    then:
+      patternProperties:
+        "^channel[2-7]$": false
 
 unevaluatedProperties: false
 
-- 
2.35.1


