Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B03C6DACBE
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 14:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240375AbjDGMu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 08:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239695AbjDGMu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 08:50:26 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E717FA5D5;
        Fri,  7 Apr 2023 05:50:24 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l15-20020a05600c4f0f00b003ef6d684102so21686407wmq.3;
        Fri, 07 Apr 2023 05:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680871823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ijOoimJYROvL2xKKNrDkLF9qZTzoSBmk/l6jvqUrH2Y=;
        b=mLxuJVp1lpNT8/fb6Y0avFEOu/NNjP1458DTL5fFs+veWRX5KSMi5bhZs3Y79jXDtO
         fBu8U37MIlltZGTFWK4EmLjGHUeZMVNmDzMINeUwJZqH/QOoiCmuk53a3O3PUntrI6Sf
         QJ2FlJv7FKM5O3bRE1GWsevV6SoTMOslaXTZF+M5wrbbamUZOUunAKQ73L90uU+Q6kvq
         650/qXUO0Vtexr0NeB45xwHjD1qMXVywj35h+ShGAIUxG8ha+2NE1P1mig4GxsK6RkA8
         pSqxXs98cwBnF47+RVQD0fCSgU8N9VxgEoHRHY5HieFkrj3PUyIJr8pSBvx7gp/fww1X
         O+SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680871823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ijOoimJYROvL2xKKNrDkLF9qZTzoSBmk/l6jvqUrH2Y=;
        b=Y2IgXMKgYstFbCSxP0UQwlRjZTRq8VqmlrRh69BOMWhu4EiCtzw+Bua7UOtMADzVDc
         qfXjg/LZQtznR4zQnAn4+nx8dBZbqNwL8Up4ePOLNLm5zcJi9ZVZU/Uaa6hCxY+JE3G0
         TybS1NXEYlrDrVDnkEF7Lca7ktr9pBuy4A751dEhEJs2jdOoIE6LTXX9NmYjICXYaYPL
         ZCLyHnioLKHGz2lBn7P7KVkxn/7tSM6p2lc4Z1Mc+M107n1dIaggZocygZTxj1GHMOge
         28xczQKR7CtecQlbCC5BVRDRkpg4XhAoIcnj65PG6qJy0Wt81A51KI31z7LpQTRZuuuH
         Q6mQ==
X-Gm-Message-State: AAQBX9eacBDO7eczffYihRtWjWG2Yhu+Pjn2EDCDDW9ylVEPX/ovyFj4
        JjEmSxIBuOTrvGd/jXqAPfU=
X-Google-Smtp-Source: AKy350Zk26UApNEGoDELJLQMWH/Qq3yPg/VheTn1EjnWyokM6oY6sX0P15HTgqQQ4ASurUEw52f7pw==
X-Received: by 2002:a05:600c:22cf:b0:3eb:3f2d:f237 with SMTP id 15-20020a05600c22cf00b003eb3f2df237mr1736688wmg.6.1680871823257;
        Fri, 07 Apr 2023 05:50:23 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id n37-20020a05600c3ba500b003f0652084b8sm8176596wms.20.2023.04.07.05.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 05:50:23 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 3/7] dt-bindings: net: dsa: mediatek,mt7530: add port bindings for MT7988
Date:   Fri,  7 Apr 2023 15:50:05 +0300
Message-Id: <20230407125008.42474-3-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230407125008.42474-1-arinc.unal@arinc9.com>
References: <20230407125008.42474-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

The switch on MT7988 has got only port 6 as a CPU port. The only phy-mode
to be used is internal. Add this.

Some bindings are incorrect for this switch now, so move them to more
specific places.

Address the incorrect information of which ports can be used as a user
port. Any port can be used as a user port.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 71 ++++++++++++-------
 1 file changed, 46 insertions(+), 25 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 7045a98d9593..922865a2aabf 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -152,30 +152,6 @@ properties:
       ethsys.
     maxItems: 1
 
-patternProperties:
-  "^(ethernet-)?ports$":
-    type: object
-
-    patternProperties:
-      "^(ethernet-)?port@[0-9]+$":
-        type: object
-
-        properties:
-          reg:
-            description:
-              Port address described must be 5 or 6 for CPU port and from 0 to 5
-              for user ports.
-
-        allOf:
-          - if:
-              required: [ ethernet ]
-            then:
-              properties:
-                reg:
-                  enum:
-                    - 5
-                    - 6
-
 required:
   - compatible
   - reg
@@ -186,9 +162,21 @@ $defs:
       "^(ethernet-)?ports$":
         patternProperties:
           "^(ethernet-)?port@[0-9]+$":
+            properties:
+              reg:
+                description:
+                  Port address described must be 5 or 6 for the CPU port. User
+                  ports can be 0 to 6.
+
             if:
               required: [ ethernet ]
             then:
+              properties:
+                reg:
+                  enum:
+                    - 5
+                    - 6
+
               if:
                 properties:
                   reg:
@@ -212,9 +200,21 @@ $defs:
       "^(ethernet-)?ports$":
         patternProperties:
           "^(ethernet-)?port@[0-9]+$":
+            properties:
+              reg:
+                description:
+                  Port address described must be 5 or 6 for the CPU port. User
+                  ports can be 0 to 6.
+
             if:
               required: [ ethernet ]
             then:
+              properties:
+                reg:
+                  enum:
+                    - 5
+                    - 6
+
               if:
                 properties:
                   reg:
@@ -235,6 +235,27 @@ $defs:
                       - 2500base-x
                       - sgmii
 
+  mt7988-dsa-port:
+    patternProperties:
+      "^(ethernet-)?ports$":
+        patternProperties:
+          "^(ethernet-)?port@[0-9]+$":
+            properties:
+              reg:
+                description:
+                  Port address described must be 6 for the CPU port. User ports
+                  can be 0 to 3, and 6.
+
+            if:
+              required: [ ethernet ]
+            then:
+              properties:
+                reg:
+                  const: 6
+
+                phy-mode:
+                  const: internal
+
 allOf:
   - $ref: dsa.yaml#/$defs/ethernet-ports
   - if:
@@ -285,7 +306,7 @@ allOf:
         compatible:
           const: mediatek,mt7988-switch
     then:
-      $ref: "#/$defs/mt7530-dsa-port"
+      $ref: "#/$defs/mt7988-dsa-port"
       properties:
         gpio-controller: false
         mediatek,mcm: false
-- 
2.37.2

