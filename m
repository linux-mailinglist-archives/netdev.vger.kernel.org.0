Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358156E7E29
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbjDSPYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbjDSPYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:24:08 -0400
X-Greylist: delayed 503 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Apr 2023 08:23:28 PDT
Received: from synguard (unknown [212.29.212.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A3749DB;
        Wed, 19 Apr 2023 08:23:28 -0700 (PDT)
Received: from dali.siklu.local (dali.siklu.local [192.168.42.30])
        by synguard (Postfix) with ESMTP id 81FB64DFC8;
        Wed, 19 Apr 2023 18:14:59 +0300 (IDT)
From:   Shmuel Hazan <shmuel.h@siklu.com>
To:     Russell King <linux@armlinux.org.uk>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, Shmuel Hazan <shmuel.h@siklu.com>
Subject: [PATCH v3 3/3] dt-bindings: net: marvell,pp2: add extts docs
Date:   Wed, 19 Apr 2023 18:14:57 +0300
Message-Id: <20230419151457.22411-4-shmuel.h@siklu.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230419151457.22411-1-shmuel.h@siklu.com>
References: <20230419151457.22411-1-shmuel.h@siklu.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
        HELO_NO_DOMAIN,RDNS_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some documentation and example for enabling extts on the marvell
mvpp2 TAI.

Signed-off-by: Shmuel Hazan <shmuel.h@siklu.com>
---
 .../devicetree/bindings/net/marvell,pp2.yaml   | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/marvell,pp2.yaml b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
index 4eadafc43d4f..5e4fc9c5dc92 100644
--- a/Documentation/devicetree/bindings/net/marvell,pp2.yaml
+++ b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
@@ -31,6 +31,21 @@ properties:
   "#size-cells":
     const: 0
 
+  pinctrl-0: true
+  pinctrl-1: true
+
+  pinctrl-names:
+    description:
+      When present, must have one state named "default",
+      and may contain a second name named "extts". The former
+      state sets up pins for ordinary operation without extts
+      support whereas the latter state will enable receiving
+      external timestamp events.
+    minItems: 1
+    items:
+      - const: default
+      - const: extts
+
   clocks:
     minItems: 2
     items:
@@ -241,6 +256,9 @@ examples:
                  <&cp0_clk 1 5>, <&cp0_clk 1 6>, <&cp0_clk 1 18>;
         clock-names = "pp_clk", "gop_clk", "mg_clk", "mg_core_clk", "axi_clk";
         marvell,system-controller = <&cp0_syscon0>;
+        pinctrl-names = "default", "extts";
+        pinctrl-0 = <&cp1_mpp6_gpio>;
+        pinctrl-1 = <&cp1_mpp6_ptp>;
 
         ethernet-port@0 {
             interrupts = <ICU_GRP_NSR 39 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.40.0

