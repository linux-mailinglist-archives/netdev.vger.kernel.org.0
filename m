Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3329759F80D
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 12:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbiHXKoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 06:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236840AbiHXKoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 06:44:19 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923A68287C;
        Wed, 24 Aug 2022 03:44:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661337829; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=iR51oLPt+GlmEdRfsJmc4+kzTTF8HpS/s9K3rlpCkzl9MBAOeg2Sbu7X1/IM1/1241p+bNlVoVemU+a2ddJnyilNeVI5cns9QzYwT8oJ3DbVEiSNznYSVozXccFXn4rOgrJZhMR9ah5JuZbT796sHPVmHDsjFEhmn5908iWEO9E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1661337829; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=PqDAR68ha3p7OFhv0uUyatEsf2p9t1Rodd58LZPmYK0=; 
        b=YRB4s6GICaG8jRH/FDHM8nm0Bn2YJYbnOOBRblm671pzmJJvf2PgChYcMC+C/0oXuTPNQl7KzQvBxZdHa5mZ/hsreRkBHD0rWaN4bxHu8dAW1r78rL2lz+KdWvmvms8RhRxQlst2ypoiuXot8MahKP98r+pw93ojv3n81ef3slk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1661337829;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=PqDAR68ha3p7OFhv0uUyatEsf2p9t1Rodd58LZPmYK0=;
        b=dLJ9r2Yd7D0e9nZnwDDOx7L0xQ7SYm8JhICoKU7rBqbkyLgaHpKXQ1UpEuYESRz2
        AEgnn4W16v9pjN4lAGhd2ywXkVwI0zCq9japmyf3iDbHhOBUSCBTWmvmI4fUmZh7up/
        IDiMv6sHPjo7O/5Ht8c8U7dVUXSBimTwvkEI5bhA=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1661337827365608.7276053298348; Wed, 24 Aug 2022 03:43:47 -0700 (PDT)
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
Subject: [PATCH v5 5/7] dt-bindings: net: dsa: mediatek,mt7530: define port binding per switch
Date:   Wed, 24 Aug 2022 13:40:38 +0300
Message-Id: <20220824104040.17527-6-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220824104040.17527-1-arinc.unal@arinc9.com>
References: <20220824104040.17527-1-arinc.unal@arinc9.com>
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

Define reg property on $defs as it's the same for all switch models.

Remove unnecessary lines as they are already included from the referred
dsa.yaml.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 55 +++++++++++--------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 8dfc307e6e1b..a6003db87113 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -127,37 +127,45 @@ properties:
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
+          Port address described must be 5 or 6 for CPU port and from 0 to 5 for
+          user ports.
 
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
                   const: cpu
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
+                  const: cpu
+            then:
+              required:
+                - phy-mode
 
 allOf:
   - $ref: dsa.yaml#
@@ -180,6 +188,7 @@ allOf:
         compatible:
           const: mediatek,mt7530
     then:
+      $ref: "#/$defs/mt7530-dsa-port"
       required:
         - core-supply
         - io-supply
@@ -189,6 +198,7 @@ allOf:
         compatible:
           const: mediatek,mt7531
     then:
+      $ref: "#/$defs/mt7531-dsa-port"
       properties:
         mediatek,mcm: false
 
@@ -197,6 +207,7 @@ allOf:
         compatible:
           const: mediatek,mt7621
     then:
+      $ref: "#/$defs/mt7530-dsa-port"
       required:
         - mediatek,mcm
 
-- 
2.34.1

