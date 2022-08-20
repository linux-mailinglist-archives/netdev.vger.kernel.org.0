Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF3B59AC6D
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 10:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343835AbiHTIJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 04:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343595AbiHTIJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 04:09:06 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAC32F64C;
        Sat, 20 Aug 2022 01:09:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660982914; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Cw+s+Ut4zFB2EFf5KX8jrEmghyXXyMk8ToPt/Sqil5andrBgX+SR/GSzNqHjtVteskjYjtCrP3NZIINPYC0OTHQiaITEmab6VnxB+rdttqduF0C+Lk9U6fo/K3JSgmdRW/tsNhpVG4f5nEaMLwClJU+vFxLEz9RWIuhWnb36Ego=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660982914; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=auj7qQ5/aix+HuhW0IHlBxdSquG9BXFzhbv1T/Lezro=; 
        b=E3Y/vw/9vhU+GHAF9imAixGYYKBaHal469qHMWfr3LSuTDqMWksUWCt+jGU4a+JMWj9C+jX34bznoIWB1UEbHl+6ikF9PdI2lZ3MMyB1A9LIaKm2d5l60bdIIUqNJPIMzA6nnrlHxqwtMMfbwdfJvSnIy0XF2l+xWG6VtZnn+fI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660982914;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=auj7qQ5/aix+HuhW0IHlBxdSquG9BXFzhbv1T/Lezro=;
        b=KUB3gvE9Y6QAnlhorBrrGMVtEvE+TYNfKA1DBlAgBZbN1umqwcQUmRM+K5Z9mEQB
        eLCpm6HKQaIcla+iOmmn0teKjOKQt4oHncCycW3STkbRWWbIHEA52+bG09x8lgWvxEC
        uiKUMECuZinvSPo7CoGofUeK0huJMm4ZII6yrfGo=
Received: from arinc9-PC.lan (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 166098291317911.246125532335668; Sat, 20 Aug 2022 01:08:33 -0700 (PDT)
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
Subject: [PATCH v4 4/6] dt-bindings: net: dsa: mediatek,mt7530: define port binding per switch
Date:   Sat, 20 Aug 2022 11:07:56 +0300
Message-Id: <20220820080758.9829-5-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220820080758.9829-1-arinc.unal@arinc9.com>
References: <20220820080758.9829-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define DSA port binding per switch model as each switch model requires
different values for certain properties.

Define reg property on $defs as it's the same for all switch models.

Remove unnecessary lines as they are already included from the referred
dsa.yaml.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 56 +++++++++++--------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 657e162a1c01..7c4374e16f96 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -130,38 +130,47 @@ properties:
       ethsys.
     maxItems: 1
 
-patternProperties:
-  "^(ethernet-)?ports$":
-    type: object
-
-    patternProperties:
-      "^(ethernet-)?port@[0-9]+$":
-        type: object
-        description: Ethernet switch ports
-
-        unevaluatedProperties: false
+required:
+  - compatible
+  - reg
 
-        properties:
-          reg:
-            description:
-              Port address described must be 5 or 6 for CPU port and from 0
-              to 5 for user ports.
+$defs:
+  dsa-port-reg:
+    properties:
+      reg:
+        description:
+          Port address described must be 5 or 6 for CPU port and from
+          0 to 5 for user ports.
 
-        allOf:
-          - $ref: dsa-port.yaml#
-          - if:
+  mt7530-dsa-port:
+    patternProperties:
+      "^(ethernet-)?ports$":
+        patternProperties:
+          "^(ethernet-)?port@[0-9]+$":
+            $ref: "#/$defs/dsa-port-reg"
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
+            $ref: "#/$defs/dsa-port-reg"
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
@@ -185,6 +194,7 @@ allOf:
           items:
             - const: mediatek,mt7530
     then:
+      $ref: "#/$defs/mt7530-dsa-port"
       required:
         - core-supply
         - io-supply
@@ -195,6 +205,7 @@ allOf:
           items:
             - const: mediatek,mt7531
     then:
+      $ref: "#/$defs/mt7531-dsa-port"
       properties:
         mediatek,mcm: false
 
@@ -204,6 +215,7 @@ allOf:
           items:
             - const: mediatek,mt7621
     then:
+      $ref: "#/$defs/mt7530-dsa-port"
       required:
         - mediatek,mcm
 
-- 
2.34.1

