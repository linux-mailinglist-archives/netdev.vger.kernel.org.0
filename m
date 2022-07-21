Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A6857CF08
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbiGUPcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiGUPcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:32:14 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF297B7BC
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:32:11 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id o7so3343774lfq.9
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BQPsNrymYWigYAjbaDXSls9HO34dMn+jNyqBAMGHkhE=;
        b=klI60USk54N1ownski2MYVS3xKr8/dbLGBfThTwKmpoSlp9gA0BGnWpC9utJG4uA5m
         2CCtvMBNtdFNqB8IgxA0+GaosllXfWigQdxOdCu1XVk+1Rts1gdQNd6u6Ma9NPPIWTj5
         1IbT841W++hJJgq+y9PLiXuvfn5+N8yp5NMHbm82xVvIT4Aljr+GFPAzq1vQ0O9QITX2
         WUQ9oP14M7KrpxoJi8E70tMDMjKr4WbxJEVDe/+CpKHJBhLE/xVIUJ6IUAu4k0UzhuT7
         9j6bDJ2xgCoJ8bGPTZ+H0krYG6U7lCMEZjjwdEjTtPBudunXg8aRjFQ/Zciv9euVnpOp
         O93w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BQPsNrymYWigYAjbaDXSls9HO34dMn+jNyqBAMGHkhE=;
        b=OFXwcfLYyMsvea3GmaZXviiTdI35zZglxJrdoblzV7M8q4H9DQuEBgDQUq8sP2J6BX
         iFTT9CGFdnq4ks1vUQfrme+5YU79K4SwTzQnCY/xBtbUJO6zpj21/6iJgDVbOj4h0iWu
         UUtCIP5/V3yPGDU9NU5lpQuQ6xuGKN3qAdqwZ4Bv5hpSPbyhkpv1J08ZXfkTG5qw43j8
         p/Nk6ia+Fuo+FBjyDcgQ1Rjk4jps9rfLoZUZD4bwccvNE3wdw07AOcFLhB0mIzqECJrX
         o4V+dwpFZUuHmH040gf9Vx4DvOw10XooHqP+Zo586W/nNODpK24YjQf24WZt+Yj3ZWRP
         VoOQ==
X-Gm-Message-State: AJIora/oLAgi1meXxUEWfQYfmlLB12VV0JQIrWfP7uT1FKCCJyIdvTjf
        U7YMtJFczAiYX/ovn372pd+/1w==
X-Google-Smtp-Source: AGRyM1u0E04Ew60hmcTsh0czeXohs6Fb3/eaGE8jGFnsE2y7hLGkSmza1WWiq5qyBWVL95BtnaBBXg==
X-Received: by 2002:a05:6512:10c3:b0:48a:b6d:41d with SMTP id k3-20020a05651210c300b0048a0b6d041dmr22990192lfg.679.1658417529272;
        Thu, 21 Jul 2022 08:32:09 -0700 (PDT)
Received: from krzk-bin.. (89-162-31-138.fiber.signal.no. [89.162.31.138])
        by smtp.gmail.com with ESMTPSA id a27-20020ac25e7b000000b0048a2995772asm504604lfr.73.2022.07.21.08.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 08:32:08 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Markuss Broks <markuss.broks@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Tomislav Denis <tomislav.denis@avl.com>,
        Cosmin Tanislav <cosmin.tanislav@analog.com>,
        Nishant Malpani <nish.malpani25@gmail.com>,
        Dragos Bogdan <dragos.bogdan@analog.com>,
        Nuno Sa <nuno.sa@analog.com>,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Marek Belisko <marek@goldelico.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Christian Eggers <ceggers@arri.de>,
        Beniamin Bia <beniamin.bia@analog.com>,
        Stefan Popa <stefan.popa@analog.com>,
        Oskar Andero <oskar.andero@gmail.com>,
        =?UTF-8?q?M=C3=A5rten=20Lindahl?= <martenli@axis.com>,
        Dan Murphy <dmurphy@ti.com>, Sean Nyekjaer <sean@geanix.com>,
        Cristian Pop <cristian.pop@analog.com>,
        Lukas Wunner <lukas@wunner.de>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Matheus Tavares <matheus.bernardino@usp.br>,
        Sankar Velliangiri <navin@linumiz.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Stefan Wahren <stefan.wahren@in-tech.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-fbdev@vger.kernel.org, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 1/6] dt-bindings: panel: explicitly list SPI CPHA and CPOL
Date:   Thu, 21 Jul 2022 17:31:50 +0200
Message-Id: <20220721153155.245336-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220721153155.245336-1-krzysztof.kozlowski@linaro.org>
References: <20220721153155.245336-1-krzysztof.kozlowski@linaro.org>
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

The spi-cpha and spi-cpol properties are device specific and should be
accepted only if device really needs them.  Explicitly list them in
device bindings in preparation of their removal from generic
spi-peripheral-props.yaml schema.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../bindings/display/panel/lgphilips,lb035q02.yaml   | 10 ++++++++++
 .../bindings/display/panel/samsung,ld9040.yaml       | 10 ++++++++++
 .../bindings/display/panel/samsung,lms380kf01.yaml   | 12 +++++++++---
 .../bindings/display/panel/samsung,lms397kf04.yaml   | 12 +++++++++---
 .../bindings/display/panel/samsung,s6d27a1.yaml      | 12 +++++++++---
 .../bindings/display/panel/sitronix,st7789v.yaml     | 10 ++++++++++
 .../devicetree/bindings/display/panel/tpo,td.yaml    | 10 ++++++++++
 7 files changed, 67 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/display/panel/lgphilips,lb035q02.yaml b/Documentation/devicetree/bindings/display/panel/lgphilips,lb035q02.yaml
index 5e4e0e552c2f..0bd7bbad5b94 100644
--- a/Documentation/devicetree/bindings/display/panel/lgphilips,lb035q02.yaml
+++ b/Documentation/devicetree/bindings/display/panel/lgphilips,lb035q02.yaml
@@ -21,6 +21,16 @@ properties:
   enable-gpios: true
   port: true
 
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
+
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
+
 required:
   - compatible
   - enable-gpios
diff --git a/Documentation/devicetree/bindings/display/panel/samsung,ld9040.yaml b/Documentation/devicetree/bindings/display/panel/samsung,ld9040.yaml
index d525165d6d63..ee6a61549916 100644
--- a/Documentation/devicetree/bindings/display/panel/samsung,ld9040.yaml
+++ b/Documentation/devicetree/bindings/display/panel/samsung,ld9040.yaml
@@ -42,6 +42,16 @@ properties:
   panel-height-mm:
     description: physical panel height [mm]
 
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
+
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
+
 required:
   - compatible
   - reg
diff --git a/Documentation/devicetree/bindings/display/panel/samsung,lms380kf01.yaml b/Documentation/devicetree/bindings/display/panel/samsung,lms380kf01.yaml
index 251f0c7115aa..7f010cb4aa20 100644
--- a/Documentation/devicetree/bindings/display/panel/samsung,lms380kf01.yaml
+++ b/Documentation/devicetree/bindings/display/panel/samsung,lms380kf01.yaml
@@ -43,9 +43,15 @@ properties:
 
   backlight: true
 
-  spi-cpha: true
-
-  spi-cpol: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
+
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
   spi-max-frequency:
     maximum: 1200000
diff --git a/Documentation/devicetree/bindings/display/panel/samsung,lms397kf04.yaml b/Documentation/devicetree/bindings/display/panel/samsung,lms397kf04.yaml
index cd62968426fb..794da8b45896 100644
--- a/Documentation/devicetree/bindings/display/panel/samsung,lms397kf04.yaml
+++ b/Documentation/devicetree/bindings/display/panel/samsung,lms397kf04.yaml
@@ -33,9 +33,15 @@ properties:
 
   backlight: true
 
-  spi-cpha: true
-
-  spi-cpol: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
+
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
   spi-max-frequency:
     description: inherited as a SPI client node, the datasheet specifies
diff --git a/Documentation/devicetree/bindings/display/panel/samsung,s6d27a1.yaml b/Documentation/devicetree/bindings/display/panel/samsung,s6d27a1.yaml
index 26e3c820a2f7..468111b1a1b4 100644
--- a/Documentation/devicetree/bindings/display/panel/samsung,s6d27a1.yaml
+++ b/Documentation/devicetree/bindings/display/panel/samsung,s6d27a1.yaml
@@ -41,9 +41,15 @@ properties:
 
   backlight: true
 
-  spi-cpha: true
-
-  spi-cpol: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
+
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
   spi-max-frequency:
     maximum: 1200000
diff --git a/Documentation/devicetree/bindings/display/panel/sitronix,st7789v.yaml b/Documentation/devicetree/bindings/display/panel/sitronix,st7789v.yaml
index 9e1d707c2ace..0eea7de51689 100644
--- a/Documentation/devicetree/bindings/display/panel/sitronix,st7789v.yaml
+++ b/Documentation/devicetree/bindings/display/panel/sitronix,st7789v.yaml
@@ -23,6 +23,16 @@ properties:
   backlight: true
   port: true
 
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
+
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
+
 required:
   - compatible
   - reg
diff --git a/Documentation/devicetree/bindings/display/panel/tpo,td.yaml b/Documentation/devicetree/bindings/display/panel/tpo,td.yaml
index f902a9d74141..9b0e8659d6bd 100644
--- a/Documentation/devicetree/bindings/display/panel/tpo,td.yaml
+++ b/Documentation/devicetree/bindings/display/panel/tpo,td.yaml
@@ -28,6 +28,16 @@ properties:
   backlight: true
   port: true
 
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
+
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
+
 required:
   - compatible
   - port
-- 
2.34.1

