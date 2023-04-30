Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFEE6F29CD
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 19:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjD3RHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 13:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjD3RHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 13:07:14 -0400
Received: from synguard (unknown [212.29.212.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9252709;
        Sun, 30 Apr 2023 10:07:10 -0700 (PDT)
Received: from T14.siklu.local (T14.siklu.local [192.168.42.187])
        by synguard (Postfix) with ESMTP id 05BE04E4D0;
        Sun, 30 Apr 2023 20:07:07 +0300 (IDT)
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
        devicetree@vger.kernel.org, Shmuel Hazan <shmuel.h@siklu.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v4 3/3] dt-bindings: net: marvell,pp2: add extts docs
Date:   Sun, 30 Apr 2023 20:06:56 +0300
Message-Id: <20230430170656.137549-4-shmuel.h@siklu.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230430170656.137549-1-shmuel.h@siklu.com>
References: <20230430170656.137549-1-shmuel.h@siklu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
        HELO_NO_DOMAIN,RDNS_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some documentation and example for enabling extts on the marvell
mvpp2 TAI.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Shmuel Hazan <shmuel.h@siklu.com>
---
v3 -> v4: no changes.
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
2.40.1

