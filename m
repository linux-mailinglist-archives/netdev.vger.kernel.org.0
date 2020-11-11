Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7BE2AF17C
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgKKNFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbgKKNFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:05:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F16C0617A7
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:05:14 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kcpoG-000306-I2; Wed, 11 Nov 2020 14:05:12 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        devicetree@vger.kernel.org
Subject: [net v2 4/4] dt-bindings: can: fsl,flexcan.yaml: fix fsl,stop-mode
Date:   Wed, 11 Nov 2020 14:05:07 +0100
Message-Id: <20201111130507.1560881-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201111130507.1560881-1-mkl@pengutronix.de>
References: <[net v2 0/4] arm: imx: flexcan: fix yaml bindings and DTs>
 <20201111130507.1560881-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fsl,stop-mode property is a phandle-array and should consist of one phandle
and two 32 bit integers, e.g.:

    fsl,stop-mode = <&gpr 0x34 28>;

This patch fixes the following errors, which shows up during a dtbs_check:

arch/arm/boot/dts/imx6dl-apf6dev.dt.yaml: can@2090000: fsl,stop-mode: [[1, 52, 28]] is too short
    From schema: Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml

Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: devicetree@vger.kernel.org
Reported-by: Rob Herring <robh+dt@kernel.org>
Fixes: e5ab9aa7e49b ("dt-bindings: can: flexcan: convert fsl,*flexcan bindings to yaml")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../devicetree/bindings/net/can/fsl,flexcan.yaml      | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
index 04127714e704..7eca1bf034e6 100644
--- a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
+++ b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
@@ -86,11 +86,12 @@ properties:
       req_bit is the bit offset of CAN stop request.
     $ref: /schemas/types.yaml#/definitions/phandle-array
     items:
-      - description: The 'gpr' is the phandle to general purpose register node.
-      - description: The 'req_gpr' is the gpr register offset of CAN stop request.
-        maximum: 0xff
-      - description: The 'req_bit' is the bit offset of CAN stop request.
-        maximum: 0x1f
+      items:
+        - description: The 'gpr' is the phandle to general purpose register node.
+        - description: The 'req_gpr' is the gpr register offset of CAN stop request.
+          maximum: 0xff
+        - description: The 'req_bit' is the bit offset of CAN stop request.
+          maximum: 0x1f
 
   fsl,clk-source:
     description: |
-- 
2.28.0

