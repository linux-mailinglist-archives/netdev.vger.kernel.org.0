Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FF646D3AD
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 13:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbhLHMyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 07:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbhLHMyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 07:54:37 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07978C0617A2
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 04:51:06 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1muwPY-0003F6-Aq
        for netdev@vger.kernel.org; Wed, 08 Dec 2021 13:51:04 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 892336BFBF0
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 12:51:00 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4B6FB6BFBCB;
        Wed,  8 Dec 2021 12:50:58 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8220da74;
        Wed, 8 Dec 2021 12:50:57 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Evgeny Boger <boger@wirenboard.com>,
        Rob Herring <robh@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 2/8] dt-bindings: net: can: add support for Allwinner R40 CAN controller
Date:   Wed,  8 Dec 2021 13:50:49 +0100
Message-Id: <20211208125055.223141-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211208125055.223141-1-mkl@pengutronix.de>
References: <20211208125055.223141-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Evgeny Boger <boger@wirenboard.com>

Allwinner R40 (also known as A40i, T3, V40) has a CAN controller. The
controller is the same as in earlier A10 and A20 SoCs, but needs reset
line to be deasserted before use.

This patch Introduces new compatible for R40 CAN controller with
required resets property.

Link: https://lore.kernel.org/all/20211122104616.537156-2-boger@wirenboard.com
Signed-off-by: Evgeny Boger <boger@wirenboard.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/allwinner,sun4i-a10-can.yaml      | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/allwinner,sun4i-a10-can.yaml b/Documentation/devicetree/bindings/net/can/allwinner,sun4i-a10-can.yaml
index a95960ee3feb..c93fe9d3ea82 100644
--- a/Documentation/devicetree/bindings/net/can/allwinner,sun4i-a10-can.yaml
+++ b/Documentation/devicetree/bindings/net/can/allwinner,sun4i-a10-can.yaml
@@ -17,6 +17,7 @@ properties:
           - const: allwinner,sun7i-a20-can
           - const: allwinner,sun4i-a10-can
       - const: allwinner,sun4i-a10-can
+      - const: allwinner,sun8i-r40-can
 
   reg:
     maxItems: 1
@@ -27,6 +28,19 @@ properties:
   clocks:
     maxItems: 1
 
+  resets:
+    maxItems: 1
+
+if:
+  properties:
+    compatible:
+      contains:
+        const: allwinner,sun8i-r40-can
+
+then:
+  required:
+    - resets
+
 required:
   - compatible
   - reg
@@ -47,5 +61,15 @@ examples:
         interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
         clocks = <&ccu CLK_APB1_CAN>;
     };
+  - |
+    #define RST_BUS_CAN		68
+    #define CLK_BUS_CAN		91
+    can1: can@1c2bc00 {
+        compatible = "allwinner,sun8i-r40-can";
+        reg = <0x01c2bc00 0x400>;
+        interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&ccu CLK_BUS_CAN>;
+        resets = <&ccu RST_BUS_CAN>;
+    };
 
 ...
-- 
2.33.0


