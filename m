Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7216D910A
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbjDFIC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235705AbjDFICU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:02:20 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452A47A87;
        Thu,  6 Apr 2023 01:02:18 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id n19-20020a05600c501300b003f064936c3eso2477778wmr.0;
        Thu, 06 Apr 2023 01:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680768137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LCcdE7dUEXb8lwbE7KvuyXGuIt74Tuf6bSVVO3NCHnI=;
        b=UrCyNSmLCpUhTtLbClX53/JZ14Vonr35xOfoaooPfPxC6OfEPYPGvjEHfkOA+OJ4Ro
         QjpW/sVm/Q8YC4uCHfg8yljsqJw+73p4zoG0ywI4JgYqanIYdzRc9IQc//NZ59pZ2GVd
         L5xPLrXXu9KO3Yxu5sPlMAYtX9NzPZKZXaNGEw+lq756gkwFjKk94xE4xVBRLMeVrM19
         KzguntSeG6P7x2VggjkcNbi2gLbDD2czRaKrPICtTNgf5XwWWA3roZPgse6qNvN66l3r
         uI9bOAnap95CvaNnKSfiYcVVUyndPoC+kGXBiARbHBU9VzqAPP6v2V9maP5tTSeg0v/5
         74jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680768137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LCcdE7dUEXb8lwbE7KvuyXGuIt74Tuf6bSVVO3NCHnI=;
        b=xIo31odI/mc73Luc9aJURsgDh1OPHDFwsd0zjk8aHqO2cm2gG+CWNrBoZxSqdxFDQk
         ZHn1aEyOtmxDvgNhh4139FV/IcvBDmAAQ4KMRp1HniNaE8AN5V0mteBi/1vjU5UbU7+l
         7rqjnzyR67Bbml7NzPDxfM2OvUKvltlqy1B1asxtPPDQk48rSuZhLLoN+Rz05sba4gyP
         l703Tp4njYeqWoaLxIcq6W/jYaPufLuXHKGAiPiZEccjJW5Sezbtq7mOXs8BuP0ot6rD
         0md6YwvUtkVHiiDlyFKep7/xl/suYjgeCbe2KjX8z6VKG7OYnk4d1S+OoKvX8d8DicX+
         jusA==
X-Gm-Message-State: AAQBX9dUf0FOg+cOPbUkYBqXdSi2Uz+CNccK5HqIN+YvKUZ+0Rz8E9r1
        0KvWdseI00DnszEG11moRmY=
X-Google-Smtp-Source: AKy350asArPyeyaBI5v416dwhtFXcF3RCqZCSobCIiySV4LcN5vzjJwxz0eGo4Fa58lOsn2mzDPf1A==
X-Received: by 2002:a7b:c416:0:b0:3ee:6d55:8b73 with SMTP id k22-20020a7bc416000000b003ee6d558b73mr6893176wmi.29.1680768136558;
        Thu, 06 Apr 2023 01:02:16 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id s9-20020a7bc389000000b003ef64affec7sm826993wmj.22.2023.04.06.01.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:02:15 -0700 (PDT)
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
Subject: [PATCH 3/7] dt-bindings: net: dsa: mediatek,mt7530: add port bindings for MT7988
Date:   Thu,  6 Apr 2023 11:01:37 +0300
Message-Id: <20230406080141.22924-3-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230406080141.22924-1-arinc.unal@arinc9.com>
References: <20230406080141.22924-1-arinc.unal@arinc9.com>
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
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 63 ++++++++++++++-----
 1 file changed, 46 insertions(+), 17 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 7045a98d9593..605888ce2bc6 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -160,22 +160,6 @@ patternProperties:
       "^(ethernet-)?port@[0-9]+$":
         type: object
 
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
@@ -186,9 +170,21 @@ $defs:
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
@@ -212,9 +208,21 @@ $defs:
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
@@ -235,6 +243,27 @@ $defs:
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
@@ -285,7 +314,7 @@ allOf:
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

