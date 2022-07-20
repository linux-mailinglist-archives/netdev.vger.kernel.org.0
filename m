Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC5557B281
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240597AbiGTIMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240436AbiGTIMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:12:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43066B778
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:11:41 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oE4nz-0000pw-Nm
        for netdev@vger.kernel.org; Wed, 20 Jul 2022 10:11:39 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id F0E08B58EB
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:10:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4AECFB58CC;
        Wed, 20 Jul 2022 08:10:39 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 37a186b8;
        Wed, 20 Jul 2022 08:10:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Biju Das <biju.das.jz@bp.renesas.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 08/29] dt-bindings: can: nxp,sja1000: Document RZ/N1{D,S} support
Date:   Wed, 20 Jul 2022 10:10:13 +0200
Message-Id: <20220720081034.3277385-9-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720081034.3277385-1-mkl@pengutronix.de>
References: <20220720081034.3277385-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

Add CAN binding documentation for Renesas RZ/N1 SoC.

The SJA1000 CAN controller on RZ/N1 SoC has some differences compared
to others like it has no clock divider register (CDR) support and it has
no HW loopback (HW doesn't see tx messages on rx), so introduced a new
compatible 'renesas,rzn1-sja1000' to handle these differences.

Link: https://lore.kernel.org/all/20220710115248.190280-3-biju.das.jz@bp.renesas.com
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../bindings/net/can/nxp,sja1000.yaml         | 39 +++++++++++++++++--
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
index ca9bfdfa50ab..b1327c5b86cf 100644
--- a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
+++ b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
@@ -11,9 +11,15 @@ maintainers:
 
 properties:
   compatible:
-    enum:
-      - nxp,sja1000
-      - technologic,sja1000
+    oneOf:
+      - enum:
+          - nxp,sja1000
+          - technologic,sja1000
+      - items:
+          - enum:
+              - renesas,r9a06g032-sja1000 # RZ/N1D
+              - renesas,r9a06g033-sja1000 # RZ/N1S
+          - const: renesas,rzn1-sja1000 # RZ/N1
 
   reg:
     maxItems: 1
@@ -21,6 +27,9 @@ properties:
   interrupts:
     maxItems: 1
 
+  clocks:
+    maxItems: 1
+
   reg-io-width:
     $ref: /schemas/types.yaml#/definitions/uint32
     description: I/O register width (in bytes) implemented by this device
@@ -82,10 +91,20 @@ allOf:
       properties:
         compatible:
           contains:
-            const: technologic,sja1000
+            enum:
+              - technologic,sja1000
+              - renesas,rzn1-sja1000
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
 
 unevaluatedProperties: false
 
@@ -99,3 +118,15 @@ examples:
         nxp,tx-output-config = <0x06>;
         nxp,external-clock-frequency = <24000000>;
     };
+
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/r9a06g032-sysctrl.h>
+
+    can@52104000 {
+        compatible = "renesas,r9a06g032-sja1000", "renesas,rzn1-sja1000";
+        reg = <0x52104000 0x800>;
+        reg-io-width = <4>;
+        interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&sysctrl R9A06G032_HCLK_CAN0>;
+    };
-- 
2.35.1


