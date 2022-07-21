Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A96557CF1B
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiGUPcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiGUPcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:32:39 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A91F8212C
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:32:16 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id u13so3371781lfn.5
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Atr8n4kwNDths2E9aDaStg9WSYmmytzFyNR7lUPKA94=;
        b=U3zrKJQ0kDhJ5Q9BYlrusJz/xFVRDur8ZeSn4VIBer1ZDRCj6gDLl13i9+t92wOlnG
         WsaDXaY/oKwsLzfDtDpQmnUOjL8OVSuO3JsVVrW5jwiiTXwSsb0RjerownlEJ9BNLkIF
         ez6KemhF9mOkOSWF+yrE8uT9aKIMUc0IolbQtih9ySBmPm8piAxXrGNeifiyYMyhnepd
         HHT0UJgW31V1l69DjtPrJtVpBwRY7fjJV9gDwcaXYNd2RQOyE3RMPJbyAUAKS50xZFrr
         A0gUC4Ui1+/cSGpWCVwuDrboQww9a/Kbw31OSMmHI3YwvRF6aRtJvt4gNCqly8ZgXvLW
         Znhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Atr8n4kwNDths2E9aDaStg9WSYmmytzFyNR7lUPKA94=;
        b=fmVbYZKWeXYGIOU+mAojiu7uyBwvAgxP3ZEyaI5+2lG40Yr+SqRROyDAuKYqdwOwmN
         i0jWe22j1P93UrUZ0uO5ynr1WDTsP5OJNcnDQPoB+/PZ7qFaWxCN/3PFaT2GlozFy0Ly
         mq+oVMR0QtLP79zaoc7IGTEgOmIdO+OkR3iYIWZGFKeIvMQvXc5OG6I9oV1/iNP5Lo1L
         z228Pp4oEZYQJaSfyu1XTOIznyGIkdOLYDGh0/SiZe+EeI1XGltzcJSOGn7jm+Uguthd
         r8iMA6o7VIQOlBU77VlLm7YBjJPj+OwGVaux6B3VhlV2wT4mlDCcoSCmahdrlglVIqo/
         AY7w==
X-Gm-Message-State: AJIora+mANT2RYddEVUecbpsayoRyJKAbvG+HFhP14LC03tm9TbiAC2o
        rOGv4UQJYC+w+uR0Ils+RuEKYw==
X-Google-Smtp-Source: AGRyM1seD4EpW1GLCdc5aKlaKcuO+ZYLZPvBK7x3FBqr7vfRa1iGqNXXvm15HkT86xxm2+tVLbD0HA==
X-Received: by 2002:ac2:5cb7:0:b0:48a:7002:1dc8 with SMTP id e23-20020ac25cb7000000b0048a70021dc8mr1354335lfq.273.1658417534675;
        Thu, 21 Jul 2022 08:32:14 -0700 (PDT)
Received: from krzk-bin.. (89-162-31-138.fiber.signal.no. [89.162.31.138])
        by smtp.gmail.com with ESMTPSA id a27-20020ac25e7b000000b0048a2995772asm504604lfr.73.2022.07.21.08.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 08:32:14 -0700 (PDT)
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
Subject: [PATCH 3/6] dt-bindings: iio: explicitly list SPI CPHA and CPOL
Date:   Thu, 21 Jul 2022 17:31:52 +0200
Message-Id: <20220721153155.245336-4-krzysztof.kozlowski@linaro.org>
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
 .../devicetree/bindings/iio/accel/adi,adxl345.yaml   | 10 ++++++++--
 .../devicetree/bindings/iio/adc/adi,ad7192.yaml      | 10 ++++++++--
 .../devicetree/bindings/iio/adc/adi,ad7292.yaml      |  5 ++++-
 .../devicetree/bindings/iio/adc/adi,ad7606.yaml      | 10 ++++++++--
 .../devicetree/bindings/iio/adc/adi,ad7768-1.yaml    | 10 ++++++++--
 .../bindings/iio/adc/microchip,mcp3201.yaml          | 12 ++++++++++--
 .../devicetree/bindings/iio/adc/ti,adc084s021.yaml   | 11 +++++++++--
 .../devicetree/bindings/iio/adc/ti,ads124s08.yaml    |  5 ++++-
 .../devicetree/bindings/iio/adc/ti,ads131e08.yaml    |  5 ++++-
 .../devicetree/bindings/iio/addac/adi,ad74413r.yaml  |  5 ++++-
 .../devicetree/bindings/iio/dac/adi,ad5592r.yaml     |  5 ++++-
 .../devicetree/bindings/iio/dac/adi,ad5755.yaml      | 10 ++++++++--
 .../devicetree/bindings/iio/dac/adi,ad5758.yaml      |  6 +++++-
 .../devicetree/bindings/iio/dac/adi,ad5766.yaml      |  5 ++++-
 .../devicetree/bindings/iio/dac/ti,dac082s085.yaml   |  9 +++++++--
 .../bindings/iio/gyroscope/adi,adxrs290.yaml         | 10 ++++++++--
 .../devicetree/bindings/iio/imu/adi,adis16460.yaml   | 12 +++++++++---
 .../devicetree/bindings/iio/imu/adi,adis16475.yaml   | 10 ++++++++--
 .../devicetree/bindings/iio/imu/adi,adis16480.yaml   | 11 +++++++++--
 .../bindings/iio/imu/invensense,icm42600.yaml        | 12 ++++++++++--
 .../bindings/iio/proximity/ams,as3935.yaml           |  5 ++++-
 .../devicetree/bindings/iio/resolver/adi,ad2s90.yaml | 10 ++++++++--
 .../bindings/iio/temperature/maxim,max31855k.yaml    |  6 +++++-
 .../bindings/iio/temperature/maxim,max31856.yaml     |  6 +++++-
 .../bindings/iio/temperature/maxim,max31865.yaml     |  6 +++++-
 25 files changed, 166 insertions(+), 40 deletions(-)

diff --git a/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml b/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
index 9bb039e2f533..0b498b9c9823 100644
--- a/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
+++ b/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
@@ -28,9 +28,15 @@ properties:
   reg:
     maxItems: 1
 
-  spi-cpha: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
 
-  spi-cpol: true
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
   spi-max-frequency: true
 
diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7192.yaml b/Documentation/devicetree/bindings/iio/adc/adi,ad7192.yaml
index 22b7ed3723f6..d533eb6e9233 100644
--- a/Documentation/devicetree/bindings/iio/adc/adi,ad7192.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7192.yaml
@@ -26,9 +26,15 @@ properties:
   reg:
     maxItems: 1
 
-  spi-cpol: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
 
-  spi-cpha: true
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
   spi-max-frequency: true
 
diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7292.yaml b/Documentation/devicetree/bindings/iio/adc/adi,ad7292.yaml
index a3e39a40c9b3..c0be5c87bd5c 100644
--- a/Documentation/devicetree/bindings/iio/adc/adi,ad7292.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7292.yaml
@@ -28,7 +28,10 @@ properties:
     description: |
       The regulator supply for ADC and DAC reference voltage.
 
-  spi-cpha: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
 
   spi-max-frequency: true
 
diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml b/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
index 73775174cf57..181358c90f8e 100644
--- a/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
@@ -29,9 +29,15 @@ properties:
   reg:
     maxItems: 1
 
-  spi-cpha: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
 
-  spi-cpol: true
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
   spi-max-frequency: true
 
diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7768-1.yaml b/Documentation/devicetree/bindings/iio/adc/adi,ad7768-1.yaml
index a85a28145ef6..6f9457f41ac3 100644
--- a/Documentation/devicetree/bindings/iio/adc/adi,ad7768-1.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7768-1.yaml
@@ -52,9 +52,15 @@ properties:
 
   spi-max-frequency: true
 
-  spi-cpol: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
 
-  spi-cpha: true
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
   "#io-channel-cells":
     const: 1
diff --git a/Documentation/devicetree/bindings/iio/adc/microchip,mcp3201.yaml b/Documentation/devicetree/bindings/iio/adc/microchip,mcp3201.yaml
index fcc1ba53b20d..b880354567e3 100644
--- a/Documentation/devicetree/bindings/iio/adc/microchip,mcp3201.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/microchip,mcp3201.yaml
@@ -33,8 +33,16 @@ properties:
     maxItems: 1
 
   spi-max-frequency: true
-  spi-cpha: true
-  spi-cpol: true
+
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
+
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
   vref-supply:
     description: External reference.
diff --git a/Documentation/devicetree/bindings/iio/adc/ti,adc084s021.yaml b/Documentation/devicetree/bindings/iio/adc/ti,adc084s021.yaml
index 1a113b30a414..07e1d54e93fe 100644
--- a/Documentation/devicetree/bindings/iio/adc/ti,adc084s021.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/ti,adc084s021.yaml
@@ -24,8 +24,15 @@ properties:
   vref-supply:
     description: External reference, needed to establish input scaling
 
-  spi-cpol: true
-  spi-cpha: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
+
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
   "#io-channel-cells":
     const: 1
diff --git a/Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml b/Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml
index 9f5e96439c01..74be1b4a4c27 100644
--- a/Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml
@@ -20,7 +20,10 @@ properties:
 
   spi-max-frequency: true
 
-  spi-cpha: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
 
   reset-gpios:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/iio/adc/ti,ads131e08.yaml b/Documentation/devicetree/bindings/iio/adc/ti,ads131e08.yaml
index e0670e3fbb72..b05426a4cae5 100644
--- a/Documentation/devicetree/bindings/iio/adc/ti,ads131e08.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/ti,ads131e08.yaml
@@ -30,7 +30,10 @@ properties:
 
   spi-max-frequency: true
 
-  spi-cpha: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
 
   clocks:
     description: |
diff --git a/Documentation/devicetree/bindings/iio/addac/adi,ad74413r.yaml b/Documentation/devicetree/bindings/iio/addac/adi,ad74413r.yaml
index baa65a521bad..5f5354601a0f 100644
--- a/Documentation/devicetree/bindings/iio/addac/adi,ad74413r.yaml
+++ b/Documentation/devicetree/bindings/iio/addac/adi,ad74413r.yaml
@@ -39,7 +39,10 @@ properties:
   spi-max-frequency:
     maximum: 1000000
 
-  spi-cpol: true
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
   interrupts:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/iio/dac/adi,ad5592r.yaml b/Documentation/devicetree/bindings/iio/dac/adi,ad5592r.yaml
index 30194880f457..7f094e31bddc 100644
--- a/Documentation/devicetree/bindings/iio/dac/adi,ad5592r.yaml
+++ b/Documentation/devicetree/bindings/iio/dac/adi,ad5592r.yaml
@@ -21,7 +21,10 @@ properties:
   spi-max-frequency:
     maximum: 30000000
 
-  spi-cpol: true
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
   "#address-cells":
     const: 1
diff --git a/Documentation/devicetree/bindings/iio/dac/adi,ad5755.yaml b/Documentation/devicetree/bindings/iio/dac/adi,ad5755.yaml
index f866b88e1440..11cec9c991c0 100644
--- a/Documentation/devicetree/bindings/iio/dac/adi,ad5755.yaml
+++ b/Documentation/devicetree/bindings/iio/dac/adi,ad5755.yaml
@@ -22,8 +22,14 @@ properties:
     maxItems: 1
 
   spi-cpha:
-    description: Either this or spi-cpol but not both.
-  spi-cpol: true
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
+
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
   spi-max-frequency: true
 
diff --git a/Documentation/devicetree/bindings/iio/dac/adi,ad5758.yaml b/Documentation/devicetree/bindings/iio/dac/adi,ad5758.yaml
index fd4edca34a28..4efcc2c7eaf8 100644
--- a/Documentation/devicetree/bindings/iio/dac/adi,ad5758.yaml
+++ b/Documentation/devicetree/bindings/iio/dac/adi,ad5758.yaml
@@ -17,7 +17,11 @@ properties:
     maxItems: 1
 
   spi-max-frequency: true
-  spi-cpha: true
+
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
 
   adi,dc-dc-mode:
     $ref: /schemas/types.yaml#/definitions/uint32
diff --git a/Documentation/devicetree/bindings/iio/dac/adi,ad5766.yaml b/Documentation/devicetree/bindings/iio/dac/adi,ad5766.yaml
index a8f7720d1e3e..ceea30f3af55 100644
--- a/Documentation/devicetree/bindings/iio/dac/adi,ad5766.yaml
+++ b/Documentation/devicetree/bindings/iio/dac/adi,ad5766.yaml
@@ -30,7 +30,10 @@ properties:
   spi-max-frequency:
     maximum: 1000000
 
-  spi-cpol: true
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
   reset-gpios:
     description: GPIO spec for the RESET pin. As the line is active low, it
diff --git a/Documentation/devicetree/bindings/iio/dac/ti,dac082s085.yaml b/Documentation/devicetree/bindings/iio/dac/ti,dac082s085.yaml
index b0157050f1ee..31e909eca988 100644
--- a/Documentation/devicetree/bindings/iio/dac/ti,dac082s085.yaml
+++ b/Documentation/devicetree/bindings/iio/dac/ti,dac082s085.yaml
@@ -25,10 +25,15 @@ properties:
   reg:
     maxItems: 1
 
-  spi-cpha: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
+
   spi-cpol:
+    type: boolean
     description:
-      Must be either spi-cpha, or spi-cpol but not both.
+      The device requires inverse clock polarity (CPOL) mode.
 
   vref-supply:
     description: Needed to provide output scaling.
diff --git a/Documentation/devicetree/bindings/iio/gyroscope/adi,adxrs290.yaml b/Documentation/devicetree/bindings/iio/gyroscope/adi,adxrs290.yaml
index 662ec59ca0af..5462efc1b87f 100644
--- a/Documentation/devicetree/bindings/iio/gyroscope/adi,adxrs290.yaml
+++ b/Documentation/devicetree/bindings/iio/gyroscope/adi,adxrs290.yaml
@@ -24,9 +24,15 @@ properties:
   spi-max-frequency:
     maximum: 5000000
 
-  spi-cpol: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
 
-  spi-cpha: true
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
   interrupts:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/iio/imu/adi,adis16460.yaml b/Documentation/devicetree/bindings/iio/imu/adi,adis16460.yaml
index 340be256f283..f28833915f2b 100644
--- a/Documentation/devicetree/bindings/iio/imu/adi,adis16460.yaml
+++ b/Documentation/devicetree/bindings/iio/imu/adi,adis16460.yaml
@@ -21,9 +21,15 @@ properties:
   reg:
     maxItems: 1
 
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
 
   spi-max-frequency: true
 
diff --git a/Documentation/devicetree/bindings/iio/imu/adi,adis16475.yaml b/Documentation/devicetree/bindings/iio/imu/adi,adis16475.yaml
index a7574210175a..5ae163819a24 100644
--- a/Documentation/devicetree/bindings/iio/imu/adi,adis16475.yaml
+++ b/Documentation/devicetree/bindings/iio/imu/adi,adis16475.yaml
@@ -40,9 +40,15 @@ properties:
   reg:
     maxItems: 1
 
-  spi-cpha: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
 
-  spi-cpol: true
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
   spi-max-frequency:
     maximum: 2000000
diff --git a/Documentation/devicetree/bindings/iio/imu/adi,adis16480.yaml b/Documentation/devicetree/bindings/iio/imu/adi,adis16480.yaml
index dd29dc6c4c19..dab503b54ad0 100644
--- a/Documentation/devicetree/bindings/iio/imu/adi,adis16480.yaml
+++ b/Documentation/devicetree/bindings/iio/imu/adi,adis16480.yaml
@@ -49,8 +49,15 @@ properties:
 
   spi-max-frequency: true
 
-  spi-cpha: true
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
 
   reset-gpios:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/iio/imu/invensense,icm42600.yaml b/Documentation/devicetree/bindings/iio/imu/invensense,icm42600.yaml
index 4c1c083d0e92..9fe3c5993601 100644
--- a/Documentation/devicetree/bindings/iio/imu/invensense,icm42600.yaml
+++ b/Documentation/devicetree/bindings/iio/imu/invensense,icm42600.yaml
@@ -48,8 +48,16 @@ properties:
     description: Regulator that provides power to the bus
 
   spi-max-frequency: true
-  spi-cpha: true
-  spi-cpol: true
+
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
+
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/iio/proximity/ams,as3935.yaml b/Documentation/devicetree/bindings/iio/proximity/ams,as3935.yaml
index 7fcba5d6d508..1245a4134256 100644
--- a/Documentation/devicetree/bindings/iio/proximity/ams,as3935.yaml
+++ b/Documentation/devicetree/bindings/iio/proximity/ams,as3935.yaml
@@ -23,7 +23,10 @@ properties:
   spi-max-frequency:
     maximum: 2000000
 
-  spi-cpha: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
 
   interrupts:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/iio/resolver/adi,ad2s90.yaml b/Documentation/devicetree/bindings/iio/resolver/adi,ad2s90.yaml
index 81e4bdfc17c4..38c0acb96dd6 100644
--- a/Documentation/devicetree/bindings/iio/resolver/adi,ad2s90.yaml
+++ b/Documentation/devicetree/bindings/iio/resolver/adi,ad2s90.yaml
@@ -29,9 +29,15 @@ properties:
       most 2 * 600ns, so the max frequency should be 1 / (2 * 6e-7), which gives
       roughly 830000Hz.
 
-  spi-cpol: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
 
-  spi-cpha: true
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
 additionalProperties: false
 
diff --git a/Documentation/devicetree/bindings/iio/temperature/maxim,max31855k.yaml b/Documentation/devicetree/bindings/iio/temperature/maxim,max31855k.yaml
index 9969bac66aa1..9bbff1a5c0a7 100644
--- a/Documentation/devicetree/bindings/iio/temperature/maxim,max31855k.yaml
+++ b/Documentation/devicetree/bindings/iio/temperature/maxim,max31855k.yaml
@@ -33,7 +33,11 @@ properties:
     maxItems: 1
 
   spi-max-frequency: true
-  spi-cpha: true
+
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/iio/temperature/maxim,max31856.yaml b/Documentation/devicetree/bindings/iio/temperature/maxim,max31856.yaml
index 873b34766676..44e53f0c84ba 100644
--- a/Documentation/devicetree/bindings/iio/temperature/maxim,max31856.yaml
+++ b/Documentation/devicetree/bindings/iio/temperature/maxim,max31856.yaml
@@ -20,7 +20,11 @@ properties:
     maxItems: 1
 
   spi-max-frequency: true
-  spi-cpha: true
+
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
 
   thermocouple-type:
     $ref: /schemas/types.yaml#/definitions/uint32
diff --git a/Documentation/devicetree/bindings/iio/temperature/maxim,max31865.yaml b/Documentation/devicetree/bindings/iio/temperature/maxim,max31865.yaml
index aafb33b16549..f1b6b151ebc9 100644
--- a/Documentation/devicetree/bindings/iio/temperature/maxim,max31865.yaml
+++ b/Documentation/devicetree/bindings/iio/temperature/maxim,max31865.yaml
@@ -26,7 +26,11 @@ properties:
     type: boolean
 
   spi-max-frequency: true
-  spi-cpha: true
+
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
 
 required:
   - compatible
-- 
2.34.1

