Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536005A0B56
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239846AbiHYIYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240022AbiHYIYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:24:34 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5DAA5C4D;
        Thu, 25 Aug 2022 01:24:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661415827; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=WveFGbUJ8HFRqfC8Rs4r7zqNTDtZuNL4DsaxJ9Lcka6/r5lktmSF5nUiFPQqpWPcNDS3P+Vh70QeGWjBbWNUvaWcR5H9g65kIwXP2+yUzTlBqck0Wl0NwfOp0jXDwC0KsCaVs3gGZZzx2VoX8Fnfd/7rWQvMMZ1hwx7rFIgWQ30=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1661415827; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=WvQp7bofDc+fmpM/tGQGKX7I9TFzZ3zUHUUzYvkJ6AQ=; 
        b=QAuKLdHpp/IDvBj4IH7U0ju7pA59m7cQOuH6pF5eCzMJdrszLH2BeCiOD+iattujCjIJ0GUxH3vp8/ahWoZZ+e4vdKQO1eXAmsChj/R8jyCRCTat7l/S3xXsiWAlhyf8mywwmwTK2w0iBfPqsidZ2M1SB733GZsYlNwJiL1y6W4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1661415827;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=WvQp7bofDc+fmpM/tGQGKX7I9TFzZ3zUHUUzYvkJ6AQ=;
        b=YvB4hsneKkf+RiFfnFHgFZCezZFXhNS80tp6iYXSonONhV0OAZCuid/6t9G8+5cW
        jU8A22KEnfM5a0L4Z8UBvPzf2dRaoirROfkagY+H3HRBn1QjWawaZvRQviwXk20H9X0
        mqmT0cCbn4DAxtSVS4ig7/osLQ/xgnWW2CkeEG9o=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1661415824124307.4653486511912; Thu, 25 Aug 2022 01:23:44 -0700 (PDT)
From:   =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH v6 5/6] dt-bindings: net: dsa: mediatek,mt7530: define phy-mode per switch
Date:   Thu, 25 Aug 2022 11:23:00 +0300
Message-Id: <20220825082301.409450-6-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220825082301.409450-1-arinc.unal@arinc9.com>
References: <20220825082301.409450-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define acceptable phy-mode values for the CPU ports of mt7530 and mt7531
switches. Remove relevant information from the description of the binding.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 73 ++++++++++++++++---
 1 file changed, 62 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index e81b3dce874b..fe8ecaf60240 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -49,17 +49,6 @@ description: |
   * mt7621: phy-mode = "rgmii-txid";
   * mt7623: phy-mode = "rgmii";
 
-  CPU-Ports need a phy-mode property:
-    Allowed values on mt7530 and mt7621:
-      - "rgmii"
-      - "trgmii"
-    On mt7531:
-      - "1000base-x"
-      - "2500base-x"
-      - "rgmii"
-      - "sgmii"
-
-
 properties:
   compatible:
     oneOf:
@@ -164,6 +153,65 @@ required:
   - compatible
   - reg
 
+$defs:
+  mt7530-dsa-port:
+    patternProperties:
+      "^(ethernet-)?ports$":
+        patternProperties:
+          "^(ethernet-)?port@[0-9]+$":
+            if:
+              properties:
+                label:
+                  const: cpu
+            then:
+              if:
+                properties:
+                  reg:
+                    const: 5
+              then:
+                properties:
+                  phy-mode:
+                    enum:
+                      - gmii
+                      - mii
+                      - rgmii
+              else:
+                properties:
+                  phy-mode:
+                    enum:
+                      - rgmii
+                      - trgmii
+
+  mt7531-dsa-port:
+    patternProperties:
+      "^(ethernet-)?ports$":
+        patternProperties:
+          "^(ethernet-)?port@[0-9]+$":
+            if:
+              properties:
+                label:
+                  const: cpu
+            then:
+              if:
+                properties:
+                  reg:
+                    const: 5
+              then:
+                properties:
+                  phy-mode:
+                    enum:
+                      - 1000base-x
+                      - 2500base-x
+                      - rgmii
+                      - sgmii
+              else:
+                properties:
+                  phy-mode:
+                    enum:
+                      - 1000base-x
+                      - 2500base-x
+                      - sgmii
+
 allOf:
   - $ref: dsa.yaml#
   - if:
@@ -185,6 +233,7 @@ allOf:
         compatible:
           const: mediatek,mt7530
     then:
+      $ref: "#/$defs/mt7530-dsa-port"
       required:
         - core-supply
         - io-supply
@@ -194,6 +243,7 @@ allOf:
         compatible:
           const: mediatek,mt7531
     then:
+      $ref: "#/$defs/mt7531-dsa-port"
       properties:
         mediatek,mcm: false
 
@@ -202,6 +252,7 @@ allOf:
         compatible:
           const: mediatek,mt7621
     then:
+      $ref: "#/$defs/mt7530-dsa-port"
       required:
         - mediatek,mcm
 
-- 
2.34.1

