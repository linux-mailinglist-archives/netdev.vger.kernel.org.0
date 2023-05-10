Return-Path: <netdev+bounces-1568-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 292356FE50D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B4EB1C20E3C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FE0146BC;
	Wed, 10 May 2023 20:30:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0248618C08
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:30:24 +0000 (UTC)
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7D159CA;
	Wed, 10 May 2023 13:30:22 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 34AKTrGj028822;
	Wed, 10 May 2023 15:29:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1683750593;
	bh=s5ETgWj9H97D/+/gjxuFIP1WU78+qx7k7HI1RNaFw4E=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=pjeCtfQyrlgajzq8k/sRU5fqbbPUahdP6i0IW0hQXSvC3E7Xl/eCxelMFmNW6Tl3Z
	 zJQKKCmSOfaCrhx4go0t0oV//qW9GEFmk08E1C+gHvLwiCeXDUJqxCD+VOC8TPC2XW
	 dap6aaEmRQvEZJ51fWZsNWFrUbGfRO+B1tsADyVI=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 34AKTrMe026213
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 10 May 2023 15:29:53 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 10
 May 2023 15:29:53 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 10 May 2023 15:29:53 -0500
Received: from a0498204.dal.design.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
	by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 34AKTqDH003872;
	Wed, 10 May 2023 15:29:53 -0500
From: Judith Mendez <jm@ti.com>
To: <linux-can@vger.kernel.org>,
        Chandrasekar Ramakrishnan
	<rcsekar@samsung.com>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde
	<mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Schuyler Patton <spatton@ti.com>,
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof
 Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley
	<conor+dt@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v5 1/2] dt-bindings: net: can: Add poll-interval for MCAN
Date: Wed, 10 May 2023 15:29:51 -0500
Message-ID: <20230510202952.27111-2-jm@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230510202952.27111-1-jm@ti.com>
References: <20230510202952.27111-1-jm@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On AM62x SoC, MCANs on MCU domain do not have hardware interrupt
routed to A53 Linux, instead they will use software interrupt by
hrtimer.

To enable timer polling method, interrupts should be
optional so remove interrupts property from required section and
add an example for MCAN node with timer polling enabled.

Signed-off-by: Judith Mendez <jm@ti.com>
---
 .../bindings/net/can/bosch,m_can.yaml         | 20 +++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
index 67879aab623b..bb518c831f7b 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
@@ -122,8 +122,6 @@ required:
   - compatible
   - reg
   - reg-names
-  - interrupts
-  - interrupt-names
   - clocks
   - clock-names
   - bosch,mram-cfg
@@ -132,6 +130,7 @@ additionalProperties: false
 
 examples:
   - |
+    // Example with interrupts
     #include <dt-bindings/clock/imx6sx-clock.h>
     can@20e8000 {
       compatible = "bosch,m_can";
@@ -149,4 +148,21 @@ examples:
       };
     };
 
+  - |
+    // Example with timer polling
+    #include <dt-bindings/clock/imx6sx-clock.h>
+    can@20e8000 {
+      compatible = "bosch,m_can";
+      reg = <0x020e8000 0x4000>, <0x02298000 0x4000>;
+      reg-names = "m_can", "message_ram";
+      clocks = <&clks IMX6SX_CLK_CANFD>,
+               <&clks IMX6SX_CLK_CANFD>;
+      clock-names = "hclk", "cclk";
+      bosch,mram-cfg = <0x0 0 0 32 0 0 0 1>;
+
+      can-transceiver {
+        max-bitrate = <5000000>;
+      };
+    };
+
 ...
-- 
2.17.1


