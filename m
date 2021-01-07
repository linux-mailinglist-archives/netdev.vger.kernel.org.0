Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0592ECD38
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbhAGJvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727811AbhAGJv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:28 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C012C061246
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:50:06 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kxRvg-0001PU-RB
        for netdev@vger.kernel.org; Thu, 07 Jan 2021 10:50:04 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id DDC155BBAF4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:49:09 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9825F5BBA43;
        Thu,  7 Jan 2021 09:49:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9deda679;
        Thu, 7 Jan 2021 09:49:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 18/19] dt-bindings: can: fsl,flexcan: add fsl,scu-index property to indicate a resource
Date:   Thu,  7 Jan 2021 10:48:59 +0100
Message-Id: <20210107094900.173046-19-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107094900.173046-1-mkl@pengutronix.de>
References: <20210107094900.173046-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

For SoCs with SCU support, need setup stop mode via SCU firmware, so this
property can help indicate a resource in SCU firmware.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Link: https://lore.kernel.org/r/20201106105627.31061-3-qiangqing.zhang@nxp.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../devicetree/bindings/net/can/fsl,flexcan.yaml      | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
index 0d2df30f19db..fe6a949a2eab 100644
--- a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
+++ b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
@@ -110,6 +110,16 @@ properties:
     description:
       Enable CAN remote wakeup.
 
+  fsl,scu-index:
+    description: |
+      The scu index of CAN instance.
+      For SoCs with SCU support, need setup stop mode via SCU firmware, so this
+      property can help indicate a resource. It supports up to 3 CAN instances
+      now.
+    $ref: /schemas/types.yaml#/definitions/uint8
+    minimum: 0
+    maximum: 2
+
 required:
   - compatible
   - reg
@@ -137,4 +147,5 @@ examples:
         clocks = <&clks 1>, <&clks 2>;
         clock-names = "ipg", "per";
         fsl,stop-mode = <&gpr 0x34 28>;
+        fsl,scu-index = /bits/ 8 <1>;
     };
-- 
2.29.2


