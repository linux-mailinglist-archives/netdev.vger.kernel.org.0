Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A9B585AC3
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 16:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbiG3O2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 10:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbiG3O1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 10:27:51 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972E2FD18;
        Sat, 30 Jul 2022 07:27:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1659191238; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=f03rhROaXVDtoGcqF8PH7ku5ZvTJvzwMVAgWIY+C021f5wTuX8u+RKDk3J+bm02SAZ+/qCPR1+yhTBLfdpAYxVxxsbxABjaZDO4VPlcSOBy3gm5l9i/QvpAv9IkG5UqfxvuGqsD+O3SB31Tf/wIn5WiYbT1WJcdq6FtJaRHrt/Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1659191238; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=pqvQ2aweDe3c5fU2tkE7jlk+Hh/ZhCL0vQoiicn2OoQ=; 
        b=LjI9BeZjVvn1rrbqJ7mdj+ITZCRjVoaODl/3t7VC0FrwglaMu5eeZFXeClxPaHPIgfrpeY/ezKXfciE616QLPjzALT7uJPMiAYe+YtnVDpFMdUrmLY95TV8DlyDy6LJX4H/0t3swgnnnNpy8/fGtcahtVQsUocZtDXPMHOFmWxU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1659191238;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=pqvQ2aweDe3c5fU2tkE7jlk+Hh/ZhCL0vQoiicn2OoQ=;
        b=cSKhbQ3NvpHKGn1b29U8XmOYEpfGOl9XM9kAWUiS2PA+VH4a06NJhaxQXknTusuQ
        yydjSZTWU8JEuHoA0hOHE657c2+Mz134PBkTVPhSugq9JUPzKSBuKTUsyPYQjHafFdI
        Ccvip/JEGxnf2kge0GQJzK2JfyrVTZc1diusZ2G4=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1659191236549576.702841552793; Sat, 30 Jul 2022 07:27:16 -0700 (PDT)
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
Subject: [PATCH 4/4] dt-bindings: net: dsa: mediatek,mt7530: update json-schema
Date:   Sat, 30 Jul 2022 17:26:27 +0300
Message-Id: <20220730142627.29028-5-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220730142627.29028-1-arinc.unal@arinc9.com>
References: <20220730142627.29028-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the json-schema for compatible devices.

- Define acceptable phy-mode values for CPU port of each compatible device.
- Remove requiring the "reg" property since the referred dsa-port.yaml
already does that.
- Require mediatek,mcm for the described MT7621 SoCs as the compatible
string is only used for MT7530 which is a part of the multi-chip module.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 220 +++++++++++++++---
 1 file changed, 191 insertions(+), 29 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index a88e650e910b..a37a14fba9f6 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -135,35 +135,6 @@ properties:
       the ethsys.
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
@@ -187,10 +158,201 @@ allOf:
           items:
             - const: mediatek,mt7530
     then:
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
+                    allOf:
+                      - if:
+                          properties:
+                            reg:
+                              const: 5
+                        then:
+                          properties:
+                            phy-mode:
+                              enum:
+                                - gmii
+                                - mii
+                                - rgmii
+
+                      - if:
+                          properties:
+                            reg:
+                              const: 6
+                        then:
+                          properties:
+                            phy-mode:
+                              enum:
+                                - rgmii
+                                - trgmii
+
+                    properties:
+                      reg:
+                        enum:
+                          - 5
+                          - 6
+
+                    required:
+                      - phy-mode
+
       required:
         - core-supply
         - io-supply
 
+  - if:
+      properties:
+        compatible:
+          items:
+            - const: mediatek,mt7531
+    then:
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
+                    allOf:
+                      - if:
+                          properties:
+                            reg:
+                              const: 5
+                        then:
+                          properties:
+                            phy-mode:
+                              enum:
+                                - 1000base-x
+                                - 2500base-x
+                                - rgmii
+                                - sgmii
+
+                      - if:
+                          properties:
+                            reg:
+                              const: 6
+                        then:
+                          properties:
+                            phy-mode:
+                              enum:
+                                - 1000base-x
+                                - 2500base-x
+                                - sgmii
+
+                    properties:
+                      reg:
+                        enum:
+                          - 5
+                          - 6
+
+                    required:
+                      - phy-mode
+
+  - if:
+      properties:
+        compatible:
+          items:
+            - const: mediatek,mt7621
+    then:
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
+                    allOf:
+                      - if:
+                          properties:
+                            reg:
+                              const: 5
+                        then:
+                          properties:
+                            phy-mode:
+                              enum:
+                                - gmii
+                                - mii
+                                - rgmii
+
+                      - if:
+                          properties:
+                            reg:
+                              const: 6
+                        then:
+                          properties:
+                            phy-mode:
+                              enum:
+                                - rgmii
+                                - trgmii
+
+                    properties:
+                      reg:
+                        enum:
+                          - 5
+                          - 6
+
+                    required:
+                      - phy-mode
+
+      required:
+        - mediatek,mcm
+
 unevaluatedProperties: false
 
 examples:
-- 
2.34.1

