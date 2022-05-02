Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7523E5175EF
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 19:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352051AbiEBRhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 13:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386696AbiEBRhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 13:37:33 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A63D6268
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 10:34:02 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:cd2b:85eb:bdf:a9c3])
        by albert.telenet-ops.be with bizsmtp
        id RtZv2700E3SeZYW06tZv8w; Mon, 02 May 2022 19:34:00 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1nlZvn-002nnL-05; Mon, 02 May 2022 19:33:55 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1nlZvm-0038dN-Fn; Mon, 02 May 2022 19:33:54 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/2] dt-bindings: can: renesas,rcar-canfd: Make interrupt-names required
Date:   Mon,  2 May 2022 19:33:53 +0200
Message-Id: <a68e65955e0df4db60233d468f348203c2e7b940.1651512451.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651512451.git.geert+renesas@glider.be>
References: <cover.1651512451.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Renesas R-Car CAN FD Controller always uses two or more interrupts.
Make the interrupt-names properties a required property, to make it
easier to identify the individual interrupts.

Update the example accordingly.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml        | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
index 9fc137fafed98b8f..6f71fc96bc4e3156 100644
--- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
@@ -88,6 +88,7 @@ required:
   - compatible
   - reg
   - interrupts
+  - interrupt-names
   - clocks
   - clock-names
   - power-domains
@@ -136,7 +137,6 @@ then:
         - const: rstc_n
 
   required:
-    - interrupt-names
     - reset-names
 else:
   properties:
@@ -167,6 +167,7 @@ examples:
             reg = <0xe66c0000 0x8000>;
             interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
                          <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+            interrupt-names = "ch_int", "g_int";
             clocks = <&cpg CPG_MOD 914>,
                      <&cpg CPG_CORE R8A7795_CLK_CANFD>,
                      <&can_clk>;
-- 
2.25.1

