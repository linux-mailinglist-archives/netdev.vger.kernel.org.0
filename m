Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8D3582E66
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 19:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbiG0RMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 13:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241237AbiG0RLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 13:11:40 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BED51417
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:41:42 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id w15so19883991lft.11
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=noZsE9hzm+1k0IDbKYcJedBCS8keQWIZ5dwJ9Bh2iyA=;
        b=EvaFQ0LZE/erLTRglemqXFQcs3XLxjLrE10420FuIJORcU8P0nkjppHqEchtCoTdrV
         QP3EHReO5Zj5phUAfO0cxLHKN2bfz0WwIlTvjKlOSHBNTX60u8ZOyI3BJ6DA74rpJkT0
         8GE21IktCR/UbYLecNeeifL6SJcsv1OCP0KnhjoJWpm9vTJmfsOkimnmmVNmiKXSCjrq
         PCIvFb2Z/9iLYQZjt4s1MFE4W9GqIdaCKe3Bj9niregePX3wluJt/DkX3AeE/2dJiwmo
         OUqGp5MF42tU4cR9HJcR08KOXhPf/hL38/GwuPr2abMfrRWfMEMzEVdqiblUcsKeSAsU
         1shQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=noZsE9hzm+1k0IDbKYcJedBCS8keQWIZ5dwJ9Bh2iyA=;
        b=2r/jgJOWpA0fopiFSDc2g0GbLpbU7dtDPsgy8+He8ggegZEoJs4B1EbliAFUBZNy2I
         LsAZC/JcUdjBiaXWNnpaHhFKClZqgT2NHqT2ZHBLzQ1K2X8H8vPvIw15LJ1zrFivEWpe
         Ci3jp+pFzPvn56+/s5oj5Qy7vg9b6IWge7p3H08K7IoAZh3pz5pnStUwTmepGT/UfuQy
         hQsD5QbPJF1RwaZmwNvPdzmeaNp9HwWcOPUTj65HgIeI3zPxCLUCV9pO4bXD5YVdtFBm
         ujxI4fS4wz67+rKtULq8PVwpmTOztYntmYG3HEJOchodR2tmqpNdHTQ/SelzARa/3oMk
         ZwQQ==
X-Gm-Message-State: AJIora+XlpDvsJu6jALCnIZaWftglmpC+kwldy+M55Fikk5InPQqO4tw
        RC4h85MOBCZXeWZcM30IrY3zxQ==
X-Google-Smtp-Source: AGRyM1vOxShQJVI2IuMwmQBmBYBiblwWa0oXL7CXsC4l1qkEdcyTkrYB2g5dMB9y4tgZP27svG3sNw==
X-Received: by 2002:a05:6512:1107:b0:48a:87db:7d24 with SMTP id l7-20020a056512110700b0048a87db7d24mr6539653lfg.58.1658940094944;
        Wed, 27 Jul 2022 09:41:34 -0700 (PDT)
Received: from krzk-bin.lan (78-26-46-173.network.trollfjord.no. [78.26.46.173])
        by smtp.gmail.com with ESMTPSA id i17-20020a2ea231000000b0025a67779931sm3872519ljm.57.2022.07.27.09.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 09:41:34 -0700 (PDT)
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
Subject: [PATCH 2/2] dt-bindings: wireless: use spi-peripheral-props.yaml
Date:   Wed, 27 Jul 2022 18:41:30 +0200
Message-Id: <20220727164130.385411-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220727164130.385411-1-krzysztof.kozlowski@linaro.org>
References: <20220727164130.385411-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 .../net/wireless/microchip,wilc1000.yaml      |  7 ++--
 .../bindings/net/wireless/silabs,wfx.yaml     | 15 +++------
 .../bindings/net/wireless/ti,wlcore.yaml      | 32 +++++++++----------
 3 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
index 60de78f1bc7b..b3405f284580 100644
--- a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
@@ -20,8 +20,6 @@ properties:
 
   reg: true
 
-  spi-max-frequency: true
-
   interrupts:
     maxItems: 1
 
@@ -51,7 +49,10 @@ required:
   - compatible
   - interrupts
 
-additionalProperties: false
+allOf:
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
+
+unevaluatedProperties: false
 
 examples:
   - |
diff --git a/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml b/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
index 76199a67d628..b35d2f3ad1ad 100644
--- a/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
@@ -29,12 +29,6 @@ description: >
     Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml for more
     information.
 
-  For SPI:
-
-    In add of the properties below, please consult
-    Documentation/devicetree/bindings/spi/spi-controller.yaml for optional SPI
-    related properties.
-
 properties:
   compatible:
     items:
@@ -52,8 +46,6 @@ properties:
       bindings.
     maxItems: 1
 
-  spi-max-frequency: true
-
   interrupts:
     description: The interrupt line. Should be IRQ_TYPE_EDGE_RISING. When SPI is
       used, this property is required. When SDIO is used, the "in-band"
@@ -84,12 +76,15 @@ properties:
 
   mac-address: true
 
-additionalProperties: false
-
 required:
   - compatible
   - reg
 
+allOf:
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
+
+unevaluatedProperties: false
+
 examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
index d68bb2ec1f7e..e31456730e9f 100644
--- a/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
@@ -36,8 +36,6 @@ properties:
       This is required when connected via SPI, and optional when connected via
       SDIO.
 
-  spi-max-frequency: true
-
   interrupts:
     minItems: 1
     maxItems: 2
@@ -69,20 +67,22 @@ required:
   - compatible
   - interrupts
 
-if:
-  properties:
-    compatible:
-      contains:
-        enum:
-          - ti,wl1271
-          - ti,wl1273
-          - ti,wl1281
-          - ti,wl1283
-then:
-  required:
-    - ref-clock-frequency
-
-additionalProperties: false
+allOf:
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - ti,wl1271
+              - ti,wl1273
+              - ti,wl1281
+              - ti,wl1283
+    then:
+      required:
+        - ref-clock-frequency
+
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.34.1

