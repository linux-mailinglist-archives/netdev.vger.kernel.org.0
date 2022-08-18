Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88D25980A8
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 11:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238680AbiHRJRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 05:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234053AbiHRJRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 05:17:37 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EC5696F2;
        Thu, 18 Aug 2022 02:17:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660814225; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=QgoH4GrKf8HDFVt/8Fs49hY/kg92xp6tdS37jBQyJsqqB0MMmb5USLJbUX+udfCgdQtIXGj1JWac8WyadzODEa4kBbBXm8il0BuB0x47oxLel6+tRBbZEEfjKMM04QUbA5YTNtLrpZpDvK7udFK0GO712C5yARRwn45w+7u0tIY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660814225; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=wWNYVGiTjPtPc/6FPyJ0S/2bJSMkD8JLkLPy2T5896U=; 
        b=N0oaK/BSi6WvtURSkZPnN8btU9lc/NoZEgG63ywfAfAHZ2AZ+mml4DHVKp+Kz7QImtatYo2V6dX4/bHLbuG3TdeqqG/qWoFoY3X4S+BzGOjqpfDoBWNys6yIn+7vZEP80urLOzj66e74Ez99ByDCWwyHwWeUMtLSFjgsIHAwvIM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660814225;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=wWNYVGiTjPtPc/6FPyJ0S/2bJSMkD8JLkLPy2T5896U=;
        b=dlTHnTndnu4TosT6JgT8zIVfKRD+INelJZiD2aq5T8Yi+jpvPE9AJDvP76GawDW5
        H0jGH1Kch2CJwcCQm1zmAzJUq+XbmRVet8IPNdYN+w1/+Y2Tga6KXxK00fxg/o9ZIAy
        cyMmGRK9qCLPSfmc0jaCJ9Vm7LUqM6oOwCsbDNmo=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1660814224598289.3097465535868; Thu, 18 Aug 2022 02:17:04 -0700 (PDT)
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
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH v3 4/6] dt-bindings: net: dsa: mediatek,mt7530: define port binding per switch
Date:   Thu, 18 Aug 2022 12:16:25 +0300
Message-Id: <20220818091627.51878-5-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818091627.51878-1-arinc.unal@arinc9.com>
References: <20220818091627.51878-1-arinc.unal@arinc9.com>
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

Define DSA port binding per switch model as each switch model requires
different values for certain properties.

Remove unnecessary lines as they are already included from the referred
dsa.yaml.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 59 ++++++++++++-------
 1 file changed, 37 insertions(+), 22 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 657e162a1c01..b6c5cf4e706b 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -130,38 +130,50 @@ properties:
       ethsys.
     maxItems: 1
 
-patternProperties:
-  "^(ethernet-)?ports$":
-    type: object
+required:
+  - compatible
+  - reg
 
+$defs:
+  mt7530-dsa-port:
     patternProperties:
-      "^(ethernet-)?port@[0-9]+$":
-        type: object
-        description: Ethernet switch ports
-
-        unevaluatedProperties: false
-
-        properties:
-          reg:
-            description:
-              Port address described must be 5 or 6 for CPU port and from 0
-              to 5 for user ports.
-
-        allOf:
-          - $ref: dsa-port.yaml#
-          - if:
+      "^(ethernet-)?ports$":
+        patternProperties:
+          "^(ethernet-)?port@[0-9]+$":
+            properties:
+              reg:
+                description:
+                  Port address described must be 5 or 6 for CPU port and from
+                  0 to 5 for user ports.
+
+            if:
               properties:
                 label:
                   items:
                     - const: cpu
             then:
               required:
-                - reg
                 - phy-mode
 
-required:
-  - compatible
-  - reg
+  mt7531-dsa-port:
+    patternProperties:
+      "^(ethernet-)?ports$":
+        patternProperties:
+          "^(ethernet-)?port@[0-9]+$":
+            properties:
+              reg:
+                description:
+                  Port address described must be 5 or 6 for CPU port and from
+                  0 to 5 for user ports.
+
+            if:
+              properties:
+                label:
+                  items:
+                    - const: cpu
+            then:
+              required:
+                - phy-mode
 
 allOf:
   - $ref: dsa.yaml#
@@ -185,6 +197,7 @@ allOf:
           items:
             - const: mediatek,mt7530
     then:
+      $ref: "#/$defs/mt7530-dsa-port"
       required:
         - core-supply
         - io-supply
@@ -195,6 +208,7 @@ allOf:
           items:
             - const: mediatek,mt7531
     then:
+      $ref: "#/$defs/mt7531-dsa-port"
       properties:
         mediatek,mcm: false
 
@@ -204,6 +218,7 @@ allOf:
           items:
             - const: mediatek,mt7621
     then:
+      $ref: "#/$defs/mt7530-dsa-port"
       required:
         - mediatek,mcm
 
-- 
2.34.1

