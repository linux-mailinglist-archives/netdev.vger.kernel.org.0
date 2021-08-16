Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477313ED362
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 13:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236388AbhHPLtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 07:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236435AbhHPLtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 07:49:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F88C061796
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 04:48:52 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mFb6j-0004bs-L5; Mon, 16 Aug 2021 13:48:45 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mFb6i-0004ZR-QQ; Mon, 16 Aug 2021 13:48:44 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, David Jander <david@protonic.nl>
Subject: [PATCH v1 2/3] dt-bindings: can: fsl,flexcan: enable termination-* bindings
Date:   Mon, 16 Aug 2021 13:48:39 +0200
Message-Id: <20210816114840.17502-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210816114840.17502-1-o.rempel@pengutronix.de>
References: <20210816114840.17502-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable termination-* binding and provide validation example for it.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 .../bindings/net/can/fsl,flexcan.yaml          | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
index 55bff1586b6f..ef31696eb642 100644
--- a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
+++ b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
@@ -119,6 +119,9 @@ properties:
     minimum: 0
     maximum: 2
 
+  termination-gpios: true
+  termination-ohms: true
+
 required:
   - compatible
   - reg
@@ -148,3 +151,18 @@ examples:
         fsl,stop-mode = <&gpr 0x34 28>;
         fsl,scu-index = /bits/ 8 <1>;
     };
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/gpio/gpio.h>
+
+    can@2090000 {
+        compatible = "fsl,imx6q-flexcan";
+        reg = <0x02090000 0x4000>;
+        interrupts = <0 110 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&clks 1>, <&clks 2>;
+        clock-names = "ipg", "per";
+        fsl,stop-mode = <&gpr 0x34 28>;
+        fsl,scu-index = /bits/ 8 <1>;
+        termination-gpios = <&gpio1 0 GPIO_ACTIVE_LOW>;
+        termination-ohms = /bits/ 16 <150>;
+    };
-- 
2.30.2

