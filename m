Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063D6678567
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjAWS4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbjAWS4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:56:24 -0500
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE71F30190
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 10:56:22 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:6083:1fd7:ba05:ea8d])
        by laurent.telenet-ops.be with bizsmtp
        id CJwJ2900C4604Ck01JwJ5g; Mon, 23 Jan 2023 19:56:21 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pK1zG-0076K7-G3;
        Mon, 23 Jan 2023 19:56:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pK1zO-00Ekh3-D7;
        Mon, 23 Jan 2023 19:56:18 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 01/12] dt-bindings: can: renesas,rcar-canfd: R-Car V3U is R-Car Gen4
Date:   Mon, 23 Jan 2023 19:56:03 +0100
Message-Id: <4dea4b7dd76d4f859ada85f97094b7adeef5169f.1674499048.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1674499048.git.geert+renesas@glider.be>
References: <cover.1674499048.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Despite the name, R-Car V3U is the first member of the R-Car Gen4
family.  Hence generalize this by introducing a family-specific
compatible value for R-Car Gen4.

While at it, replace "both channels" by "all channels", as the numbers
of channels may differ from two.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 .../bindings/net/can/renesas,rcar-canfd.yaml          | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
index 1eb98c9a1a2602bc..899efa8a0614e229 100644
--- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
@@ -28,6 +28,11 @@ properties:
               - renesas,r8a77995-canfd     # R-Car D3
           - const: renesas,rcar-gen3-canfd # R-Car Gen3 and RZ/G2
 
+      - items:
+          - enum:
+              - renesas,r8a779a0-canfd     # R-Car V3U
+          - const: renesas,rcar-gen4-canfd # R-Car Gen4
+
       - items:
           - enum:
               - renesas,r9a07g043-canfd    # RZ/G2UL and RZ/Five
@@ -35,8 +40,6 @@ properties:
               - renesas,r9a07g054-canfd    # RZ/V2L
           - const: renesas,rzg2l-canfd     # RZ/G2L family
 
-      - const: renesas,r8a779a0-canfd      # R-Car V3U
-
   reg:
     maxItems: 1
 
@@ -60,7 +63,7 @@ properties:
     $ref: /schemas/types.yaml#/definitions/flag
     description:
       The controller can operate in either CAN FD only mode (default) or
-      Classical CAN only mode.  The mode is global to both the channels.
+      Classical CAN only mode.  The mode is global to all channels.
       Specify this property to put the controller in Classical CAN only mode.
 
   assigned-clocks:
@@ -159,7 +162,7 @@ allOf:
         properties:
           compatible:
             contains:
-              const: renesas,r8a779a0-canfd
+              const: renesas,rcar-gen4-canfd
     then:
       patternProperties:
         "^channel[2-7]$": false
-- 
2.34.1

