Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166DC591B9E
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 17:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239897AbiHMPps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 11:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239901AbiHMPpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 11:45:42 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF532FFE4;
        Sat, 13 Aug 2022 08:45:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660405501; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ErqpvuYoieUM4bDr40iitvrnhevKZD1muIBJaJW10Cvzxuvzfeaab4OIRdOIlzAWGlaXSVad4cFrChjbEys+XdiRoCZtgz6wnoBgE2Sl/Bi4JYDSMvvaaXMpvDfA4Cw9HdzRge8DW7VtMqzmpI6KWu7duCg+NWit3QjyKYzLNqQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660405501; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=2jeVUYQX9J/2owiK6eAWTqPnBtbCS5zQ8DbyaccFKw4=; 
        b=dgyzKOuqGpcvUgaeqi8tLo9TqVzFnNp5sfyuvARuehEijDND8GpMGGAMz7qrywxcROGC72cj0AiD8bsi28I7gRWM902Mes0/jV3wCQbf1oY2eoV+ZxbcVRtnKnJPjJ6oNrp4qUVoXciwLzvBVsnW+ZX8Q/9memcs8OihdMLJKrs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660405501;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=2jeVUYQX9J/2owiK6eAWTqPnBtbCS5zQ8DbyaccFKw4=;
        b=HIhGksqYfYrSyXo1fZDr2KdRk1HnkOVjwFMiLGaNpe6G3o+wZP4G2wf6kcvHvhfl
        rqIOt/5yM0gDAVmUPHVC8OpuZ5vOgH1BADx7n5oPP+Lj5LJNuF0aLGXZkdVTFMM843s
        PQLbrJWGgmfOT1u50KrebK6zKfktkSQhZnr7kEMo=
Received: from arinc9-PC.lan (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1660405500648584.308589731525; Sat, 13 Aug 2022 08:45:00 -0700 (PDT)
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
Subject: [PATCH v2 4/7] dt-bindings: net: dsa: mediatek,mt7530: define port binding per compatible
Date:   Sat, 13 Aug 2022 18:44:12 +0300
Message-Id: <20220813154415.349091-5-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220813154415.349091-1-arinc.unal@arinc9.com>
References: <20220813154415.349091-1-arinc.unal@arinc9.com>
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

Define DSA port binding under each compatible device as each device
requires different values for certain properties.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 116 +++++++++++++-----
 1 file changed, 87 insertions(+), 29 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index cc87f48d4d07..ff51a2f6875f 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -130,35 +130,6 @@ properties:
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
-              properties:
-                label:
-                  items:
-                    - const: cpu
-            then:
-              required:
-                - reg
-                - phy-mode
-
 required:
   - compatible
   - reg
@@ -189,6 +160,35 @@ allOf:
         - core-supply
         - io-supply
 
+      patternProperties:
+        "^(ethernet-)?ports$":
+          type: object
+
+          patternProperties:
+            "^(ethernet-)?port@[0-9]+$":
+              type: object
+              description: Ethernet switch ports
+
+              unevaluatedProperties: false
+
+              properties:
+                reg:
+                  description:
+                    Port address described must be 5 or 6 for CPU port and from
+                    0 to 5 for user ports.
+
+              allOf:
+                - $ref: dsa-port.yaml#
+                - if:
+                    properties:
+                      label:
+                        items:
+                          - const: cpu
+                  then:
+                    required:
+                      - reg
+                      - phy-mode
+
   - if:
       properties:
         compatible:
@@ -198,6 +198,35 @@ allOf:
       properties:
         mediatek,mcm: false
 
+      patternProperties:
+        "^(ethernet-)?ports$":
+          type: object
+
+          patternProperties:
+            "^(ethernet-)?port@[0-9]+$":
+              type: object
+              description: Ethernet switch ports
+
+              unevaluatedProperties: false
+
+              properties:
+                reg:
+                  description:
+                    Port address described must be 5 or 6 for CPU port and from
+                    0 to 5 for user ports.
+
+              allOf:
+                - $ref: dsa-port.yaml#
+                - if:
+                    properties:
+                      label:
+                        items:
+                          - const: cpu
+                  then:
+                    required:
+                      - reg
+                      - phy-mode
+
   - if:
       properties:
         compatible:
@@ -207,6 +236,35 @@ allOf:
       required:
         - mediatek,mcm
 
+      patternProperties:
+        "^(ethernet-)?ports$":
+          type: object
+
+          patternProperties:
+            "^(ethernet-)?port@[0-9]+$":
+              type: object
+              description: Ethernet switch ports
+
+              unevaluatedProperties: false
+
+              properties:
+                reg:
+                  description:
+                    Port address described must be 5 or 6 for CPU port and from
+                    0 to 5 for user ports.
+
+              allOf:
+                - $ref: dsa-port.yaml#
+                - if:
+                    properties:
+                      label:
+                        items:
+                          - const: cpu
+                  then:
+                    required:
+                      - reg
+                      - phy-mode
+
 unevaluatedProperties: false
 
 examples:
-- 
2.34.1

