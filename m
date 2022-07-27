Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCF5582E60
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 19:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241411AbiG0RMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 13:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiG0RLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 13:11:38 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3473A5071E
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:41:40 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id b21so13424775ljk.8
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EjrmIY6br0JwMML5I5IsH4l21ubS3Zd2UVsxfz0zrWQ=;
        b=jMMOnDuOyvT5MjTFryYduQK/RY48LBB89wkU1nKr3g22oGREE8Wlw5ovuddGmk1777
         C5oyCsNSgVwjzgaMVV3lrx/A9RSJXDUlw/6oRB6h95ewv0MRYNZ7JaiAXafHdi/AaMoR
         gwFiup9G4e394tdCjmRY8aQCKVjQndYSllXn3/tYsHVyAWsURSC+28LRzBtd1L9bG7tW
         YcSv/hu6PKMNjl/xVP/hN/HMu56kKFibCPKwO7n4NY8kpwTbTHQWwmbX1/BKLClzbw6G
         yiXqWnuj7YDnyDJ+zjd+XmiqP+SZbgUPMDOKgb7mr1M6reSluGSe2P2BR3fy+KXy9Km8
         e9bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EjrmIY6br0JwMML5I5IsH4l21ubS3Zd2UVsxfz0zrWQ=;
        b=x6zeO52I4dtMQUt2r2cqNJ8W9aV/88vD9lWXxHzsSSd3fMwowHav330o6iCPzY245i
         idkUOrkaeOuWFXFmnFJYm+6jWzn1rs6sst/R+wyd0GgzyyIjZI7+oz95BM2c4YYNExJK
         gB0CMtEnqldePVE1rNlfBX79euXhu8D40gW4OTOeeKU/dkgkoAX+pAfXOn/tu/qn3u2k
         DysRkxO1xAXeDolH1oXwIGAbAyJRREtuAwF4fdxBFju4Cuf6Esc/bwyQaO7FBKP5ttef
         VBIdr0j4LMtGxNz4C2r22QCVQDatyg/efbnHKKbMJDJhgeWz187DezYCZYhw8j0nW3Zf
         5c2A==
X-Gm-Message-State: AJIora9GSLpZas152YTPBnq+G/HJGPC+8FaZ2oYFHhdQocbJXnrZaPeQ
        XSkdegPxCsbGg0WdolOwhCX2Jg==
X-Google-Smtp-Source: AGRyM1tbxmt+m0wPQaDPBmSI4ZOiMzOv0P2lpYBxlI5htHP/NbFnJvzztwcBcIVithfgzBx/B6J3Aw==
X-Received: by 2002:a05:651c:1587:b0:25d:7844:5910 with SMTP id h7-20020a05651c158700b0025d78445910mr8508285ljq.325.1658940093266;
        Wed, 27 Jul 2022 09:41:33 -0700 (PDT)
Received: from krzk-bin.lan (78-26-46-173.network.trollfjord.no. [78.26.46.173])
        by smtp.gmail.com with ESMTPSA id i17-20020a2ea231000000b0025a67779931sm3872519ljm.57.2022.07.27.09.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 09:41:32 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Greer <mgreer@animalcreek.com>,
        Kalle Valo <kvalo@kernel.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Tony Lindgren <tony@atomide.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] dt-bindings: nfc: use spi-peripheral-props.yaml
Date:   Wed, 27 Jul 2022 18:41:29 +0200
Message-Id: <20220727164130.385411-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of listing directly properties typical for SPI peripherals,
reference the spi-peripheral-props.yaml schema.  This allows using all
properties typical for SPI-connected devices, even these which device
bindings author did not tried yet.

Remove the spi-* properties which now come via spi-peripheral-props.yaml
schema, except for the cases when device schema adds some constraints
like maximum frequency.

While changing additionalProperties->unevaluatedProperties, put it in
typical place, just before example DTS.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Technically, this depends on [1] merged to SPI tree, if we want to
preserve existing behavior of not allowing SPI CPHA and CPOL in each of
schemas in this patch.

If this patch comes independently via different tree, the SPI CPHA and
CPOL will be allowed for brief period of time, before [1] is merged.
This will not have negative impact, just DT schema checks will be
loosened for that period.

[1] https://lore.kernel.org/all/20220722191539.90641-2-krzysztof.kozlowski@linaro.org/
---
 Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml | 4 ++--
 Documentation/devicetree/bindings/net/nfc/st,st-nci.yaml   | 5 ++---
 Documentation/devicetree/bindings/net/nfc/st,st95hf.yaml   | 7 ++++---
 Documentation/devicetree/bindings/net/nfc/ti,trf7970a.yaml | 7 ++++---
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml b/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml
index 1bcaf6ba822c..a191a04e681c 100644
--- a/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml
@@ -58,7 +58,6 @@ properties:
 
   spi-cpha: true
   spi-cpol: true
-  spi-max-frequency: true
 
 required:
   - compatible
@@ -85,6 +84,7 @@ allOf:
           contains:
             const: marvell,nfc-spi
     then:
+      $ref: /schemas/spi/spi-peripheral-props.yaml#
       properties:
         break-control: false
         flow-control: false
@@ -108,7 +108,7 @@ allOf:
         spi-max-frequency: false
         reg: false
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |
diff --git a/Documentation/devicetree/bindings/net/nfc/st,st-nci.yaml b/Documentation/devicetree/bindings/net/nfc/st,st-nci.yaml
index ef1155038a2f..1dcbddbc5a74 100644
--- a/Documentation/devicetree/bindings/net/nfc/st,st-nci.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/st,st-nci.yaml
@@ -30,8 +30,6 @@ properties:
   reg:
     maxItems: 1
 
-  spi-max-frequency: true
-
   uicc-present:
     type: boolean
     description: |
@@ -55,10 +53,11 @@ then:
   properties:
     spi-max-frequency: false
 else:
+  $ref: /schemas/spi/spi-peripheral-props.yaml#
   required:
     - spi-max-frequency
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |
diff --git a/Documentation/devicetree/bindings/net/nfc/st,st95hf.yaml b/Documentation/devicetree/bindings/net/nfc/st,st95hf.yaml
index 963d9531a856..647569051ed8 100644
--- a/Documentation/devicetree/bindings/net/nfc/st,st95hf.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/st,st95hf.yaml
@@ -25,8 +25,6 @@ properties:
   st95hfvin-supply:
     description: ST95HF transceiver's Vin regulator supply
 
-  spi-max-frequency: true
-
 required:
   - compatible
   - enable-gpio
@@ -34,7 +32,10 @@ required:
   - reg
   - spi-max-frequency
 
-additionalProperties: false
+allOf:
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
+
+unevaluatedProperties: false
 
 examples:
   - |
diff --git a/Documentation/devicetree/bindings/net/nfc/ti,trf7970a.yaml b/Documentation/devicetree/bindings/net/nfc/ti,trf7970a.yaml
index 404c8df99364..9cc236ec42f2 100644
--- a/Documentation/devicetree/bindings/net/nfc/ti,trf7970a.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/ti,trf7970a.yaml
@@ -40,8 +40,6 @@ properties:
   reg:
     maxItems: 1
 
-  spi-max-frequency: true
-
   ti,enable-gpios:
     minItems: 1
     maxItems: 2
@@ -65,7 +63,10 @@ required:
   - ti,enable-gpios
   - vin-supply
 
-additionalProperties: false
+allOf:
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
+
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.34.1

