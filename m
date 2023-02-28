Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28776A61D7
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 22:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjB1Vyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 16:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjB1Vyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 16:54:44 -0500
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3543CF;
        Tue, 28 Feb 2023 13:54:36 -0800 (PST)
Received: by mail-oo1-f53.google.com with SMTP id x19-20020a4a3953000000b00525191358b6so1790461oog.12;
        Tue, 28 Feb 2023 13:54:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jKfNGlZp+r4J9eRssW5hTItNYGqPOs4HzskpLKN7BH4=;
        b=Q0AX4yUFgzCGqAfvtKxoKxgeFVTZXJqlCVQMsscJ58dTvjYSGfpQ3bRmx9ZMU5qNdi
         Docm6ikiewYRB+HAi4AbI8w5JvZPIl7E88T3rIByRrw9dvUm0KdwWBUaFc3uZQRPxViQ
         b8LKgVgLCduOe9mw4sfPcRfAFXTA2ir5cBz3KlIvUEV+LNJQXPAwcnZO2qnhQKJJ8FMN
         iqUbQaFu6ac7YZDVcLXSj7+9GXrlnZPt4xHZh2pt/f6F2XlenZeUjyyHDKAxVi6yPoNH
         nppwvN4h1SbhvS4gbL4l3KAymG9UTD81uJSqV5DUjdY2MmTDkbrMlkgwK14y+XOrBhKw
         c7dg==
X-Gm-Message-State: AO0yUKX/JA4CTye5yC09Fm9/rIOJ3OSBICsyvchwX9h3tr2+2/O57FIk
        1Jl0CJMO5h1so3YtseqKBA==
X-Google-Smtp-Source: AK7set9hWdO75jbVFAClD12UniJR30hewUR6rBL3OAAsbzLqTsU2Nbd758BLMUeTHpXXKqvZAqc8PQ==
X-Received: by 2002:a4a:b645:0:b0:51f:955a:ca37 with SMTP id f5-20020a4ab645000000b0051f955aca37mr1839395ooo.8.1677621275710;
        Tue, 28 Feb 2023 13:54:35 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id f8-20020a4aa688000000b0051fce47fd1bsm4167552oom.25.2023.02.28.13.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 13:54:35 -0800 (PST)
Received: (nullmailer pid 3944521 invoked by uid 1000);
        Tue, 28 Feb 2023 21:54:33 -0000
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     devicetree@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <rfoss@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Kalle Valo <kvalo@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Subject: [PATCH] dt-bindings: Fix SPI and I2C bus node names in examples
Date:   Tue, 28 Feb 2023 15:54:33 -0600
Message-Id: <20230228215433.3944508-1-robh@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SPI and I2C bus node names are expected to be "spi" or "i2c",
respectively, with nothing else, a unit-address, or a '-N' index. A
pattern of 'spi0' or 'i2c0' or similar has crept in. Fix all these
cases. Mostly scripted with the following commands:

git grep -l '\si2c[0-9] {' Documentation/devicetree/ | xargs sed -i -e 's/i2c[0-9] {/i2c {/'
git grep -l '\sspi[0-9] {' Documentation/devicetree/ | xargs sed -i -e 's/spi[0-9] {/spi {/'

With this, a few errors in examples were exposed and fixed.

Signed-off-by: Rob Herring <robh@kernel.org>
---
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Cc: Robert Foss <rfoss@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Lee Jones <lee@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-clk@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-gpio@vger.kernel.org
Cc: linux-i2c@vger.kernel.org
Cc: linux-leds@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-can@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Cc: linux-usb@vger.kernel.org
---
 .../bindings/auxdisplay/holtek,ht16k33.yaml       |  2 +-
 .../bindings/chrome/google,cros-ec-typec.yaml     |  2 +-
 .../chrome/google,cros-kbd-led-backlight.yaml     |  2 +-
 .../devicetree/bindings/clock/ti,lmk04832.yaml    |  2 +-
 .../bindings/display/bridge/analogix,anx7625.yaml |  2 +-
 .../bindings/display/bridge/anx6345.yaml          |  2 +-
 .../bindings/display/bridge/lontium,lt8912b.yaml  |  2 +-
 .../bindings/display/bridge/nxp,ptn3460.yaml      |  2 +-
 .../bindings/display/bridge/ps8640.yaml           |  2 +-
 .../bindings/display/bridge/sil,sii9234.yaml      |  2 +-
 .../bindings/display/bridge/ti,dlpc3433.yaml      |  2 +-
 .../bindings/display/bridge/toshiba,tc358762.yaml |  2 +-
 .../bindings/display/bridge/toshiba,tc358768.yaml |  2 +-
 .../bindings/display/panel/nec,nl8048hl11.yaml    |  2 +-
 .../bindings/display/solomon,ssd1307fb.yaml       |  4 ++--
 .../devicetree/bindings/eeprom/at25.yaml          |  2 +-
 .../bindings/extcon/extcon-usbc-cros-ec.yaml      |  2 +-
 .../bindings/extcon/extcon-usbc-tusb320.yaml      |  2 +-
 .../devicetree/bindings/gpio/gpio-pca9570.yaml    |  2 +-
 .../devicetree/bindings/gpio/gpio-pca95xx.yaml    |  8 ++++----
 .../bindings/i2c/google,cros-ec-i2c-tunnel.yaml   |  2 +-
 .../bindings/leds/cznic,turris-omnia-leds.yaml    |  2 +-
 .../devicetree/bindings/leds/issi,is31fl319x.yaml |  2 +-
 .../devicetree/bindings/leds/leds-aw2013.yaml     |  2 +-
 .../devicetree/bindings/leds/leds-rt4505.yaml     |  2 +-
 .../devicetree/bindings/leds/ti,tca6507.yaml      |  2 +-
 .../bindings/media/i2c/aptina,mt9p031.yaml        |  2 +-
 .../bindings/media/i2c/aptina,mt9v111.yaml        |  2 +-
 .../devicetree/bindings/media/i2c/imx219.yaml     |  2 +-
 .../devicetree/bindings/media/i2c/imx258.yaml     |  4 ++--
 .../devicetree/bindings/media/i2c/mipi-ccs.yaml   |  2 +-
 .../bindings/media/i2c/ovti,ov5648.yaml           |  2 +-
 .../bindings/media/i2c/ovti,ov772x.yaml           |  2 +-
 .../bindings/media/i2c/ovti,ov8865.yaml           |  2 +-
 .../bindings/media/i2c/ovti,ov9282.yaml           |  2 +-
 .../bindings/media/i2c/rda,rda5807.yaml           |  2 +-
 .../bindings/media/i2c/sony,imx214.yaml           |  2 +-
 .../bindings/media/i2c/sony,imx274.yaml           |  2 +-
 .../bindings/media/i2c/sony,imx334.yaml           |  2 +-
 .../bindings/media/i2c/sony,imx335.yaml           |  2 +-
 .../bindings/media/i2c/sony,imx412.yaml           |  2 +-
 .../devicetree/bindings/mfd/actions,atc260x.yaml  |  2 +-
 .../devicetree/bindings/mfd/google,cros-ec.yaml   |  6 +++---
 .../devicetree/bindings/mfd/ti,tps65086.yaml      |  2 +-
 .../devicetree/bindings/mfd/x-powers,axp152.yaml  |  4 ++--
 .../devicetree/bindings/net/asix,ax88796c.yaml    |  2 +-
 .../bindings/net/can/microchip,mcp251xfd.yaml     |  2 +-
 .../bindings/net/dsa/microchip,ksz.yaml           |  2 +-
 .../bindings/net/nfc/samsung,s3fwrn5.yaml         |  2 +-
 .../bindings/net/vertexcom-mse102x.yaml           |  2 +-
 .../bindings/net/wireless/ti,wlcore.yaml          | 10 ++++++++--
 .../devicetree/bindings/pinctrl/pinmux-node.yaml  |  2 +-
 .../bindings/pinctrl/starfive,jh7100-pinctrl.yaml |  2 +-
 .../devicetree/bindings/power/supply/bq2415x.yaml |  2 +-
 .../devicetree/bindings/power/supply/bq24190.yaml |  2 +-
 .../devicetree/bindings/power/supply/bq24257.yaml |  4 ++--
 .../devicetree/bindings/power/supply/bq24735.yaml |  2 +-
 .../devicetree/bindings/power/supply/bq2515x.yaml |  2 +-
 .../devicetree/bindings/power/supply/bq25890.yaml |  2 +-
 .../devicetree/bindings/power/supply/bq25980.yaml |  2 +-
 .../devicetree/bindings/power/supply/bq27xxx.yaml | 15 ++++++++-------
 .../bindings/power/supply/lltc,ltc294x.yaml       |  2 +-
 .../bindings/power/supply/ltc4162-l.yaml          |  2 +-
 .../bindings/power/supply/maxim,max14656.yaml     |  2 +-
 .../bindings/power/supply/maxim,max17040.yaml     |  4 ++--
 .../bindings/power/supply/maxim,max17042.yaml     |  2 +-
 .../bindings/power/supply/richtek,rt9455.yaml     |  2 +-
 .../bindings/power/supply/ti,lp8727.yaml          |  2 +-
 .../bindings/regulator/active-semi,act8865.yaml   |  2 +-
 .../regulator/google,cros-ec-regulator.yaml       |  2 +-
 .../bindings/regulator/nxp,pf8x00-regulator.yaml  |  2 +-
 .../devicetree/bindings/sound/everest,es8316.yaml |  2 +-
 .../devicetree/bindings/sound/tas2562.yaml        |  2 +-
 .../devicetree/bindings/sound/tas2770.yaml        |  2 +-
 .../devicetree/bindings/sound/tas27xx.yaml        |  2 +-
 .../devicetree/bindings/sound/tas5805m.yaml       |  2 +-
 .../devicetree/bindings/sound/tlv320adcx140.yaml  |  2 +-
 .../devicetree/bindings/sound/zl38060.yaml        |  2 +-
 .../devicetree/bindings/usb/maxim,max33359.yaml   |  2 +-
 .../bindings/usb/maxim,max3420-udc.yaml           |  2 +-
 .../bindings/usb/mediatek,mt6360-tcpc.yaml        |  2 +-
 .../devicetree/bindings/usb/richtek,rt1711h.yaml  |  2 +-
 .../devicetree/bindings/usb/richtek,rt1719.yaml   |  2 +-
 .../devicetree/bindings/usb/st,stusb160x.yaml     |  2 +-
 .../devicetree/bindings/usb/ti,hd3ss3220.yaml     |  2 +-
 .../devicetree/bindings/usb/ti,tps6598x.yaml      |  2 +-
 86 files changed, 110 insertions(+), 103 deletions(-)

diff --git a/Documentation/devicetree/bindings/auxdisplay/holtek,ht16k33.yaml b/Documentation/devicetree/bindings/auxdisplay/holtek,ht16k33.yaml
index fc4873deb76f..286e726cd052 100644
--- a/Documentation/devicetree/bindings/auxdisplay/holtek,ht16k33.yaml
+++ b/Documentation/devicetree/bindings/auxdisplay/holtek,ht16k33.yaml
@@ -72,7 +72,7 @@ examples:
     #include <dt-bindings/interrupt-controller/irq.h>
     #include <dt-bindings/input/input.h>
     #include <dt-bindings/leds/common.h>
-    i2c1 {
+    i2c {
             #address-cells = <1>;
             #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml b/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
index defcf1e12aa1..3b0548c34791 100644
--- a/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
+++ b/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
@@ -41,7 +41,7 @@ additionalProperties: false
 
 examples:
   - |+
-    spi0 {
+    spi {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/chrome/google,cros-kbd-led-backlight.yaml b/Documentation/devicetree/bindings/chrome/google,cros-kbd-led-backlight.yaml
index 40244d003c32..c94ab8f9e0b8 100644
--- a/Documentation/devicetree/bindings/chrome/google,cros-kbd-led-backlight.yaml
+++ b/Documentation/devicetree/bindings/chrome/google,cros-kbd-led-backlight.yaml
@@ -20,7 +20,7 @@ additionalProperties: false
 
 examples:
   - |
-    spi0 {
+    spi {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/clock/ti,lmk04832.yaml b/Documentation/devicetree/bindings/clock/ti,lmk04832.yaml
index 73d17830f165..13d7b3d03d84 100644
--- a/Documentation/devicetree/bindings/clock/ti,lmk04832.yaml
+++ b/Documentation/devicetree/bindings/clock/ti,lmk04832.yaml
@@ -160,7 +160,7 @@ examples:
         };
     };
 
-    spi0 {
+    spi {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/display/bridge/analogix,anx7625.yaml b/Documentation/devicetree/bindings/display/bridge/analogix,anx7625.yaml
index 4590186c4a0b..27026c78cd9b 100644
--- a/Documentation/devicetree/bindings/display/bridge/analogix,anx7625.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/analogix,anx7625.yaml
@@ -134,7 +134,7 @@ examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
 
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/display/bridge/anx6345.yaml b/Documentation/devicetree/bindings/display/bridge/anx6345.yaml
index 9bf2cbcea69f..514f58852990 100644
--- a/Documentation/devicetree/bindings/display/bridge/anx6345.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/anx6345.yaml
@@ -61,7 +61,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/display/bridge/lontium,lt8912b.yaml b/Documentation/devicetree/bindings/display/bridge/lontium,lt8912b.yaml
index 674891ee2f8e..f201ae4af4fb 100644
--- a/Documentation/devicetree/bindings/display/bridge/lontium,lt8912b.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/lontium,lt8912b.yaml
@@ -67,7 +67,7 @@ examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
 
-    i2c4 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/display/bridge/nxp,ptn3460.yaml b/Documentation/devicetree/bindings/display/bridge/nxp,ptn3460.yaml
index 107dd138e6c6..0f61291d4268 100644
--- a/Documentation/devicetree/bindings/display/bridge/nxp,ptn3460.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/nxp,ptn3460.yaml
@@ -71,7 +71,7 @@ examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
 
-    i2c1 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/display/bridge/ps8640.yaml b/Documentation/devicetree/bindings/display/bridge/ps8640.yaml
index 28811aff2c5a..5856450c5da7 100644
--- a/Documentation/devicetree/bindings/display/bridge/ps8640.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/ps8640.yaml
@@ -73,7 +73,7 @@ additionalProperties: false
 examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/display/bridge/sil,sii9234.yaml b/Documentation/devicetree/bindings/display/bridge/sil,sii9234.yaml
index f88ddfe4818b..176181d25530 100644
--- a/Documentation/devicetree/bindings/display/bridge/sil,sii9234.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/sil,sii9234.yaml
@@ -71,7 +71,7 @@ examples:
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/interrupt-controller/irq.h>
 
-    i2c1 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/display/bridge/ti,dlpc3433.yaml b/Documentation/devicetree/bindings/display/bridge/ti,dlpc3433.yaml
index 542193d77cdf..d3f84d220723 100644
--- a/Documentation/devicetree/bindings/display/bridge/ti,dlpc3433.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/ti,dlpc3433.yaml
@@ -83,7 +83,7 @@ examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
 
-    i2c1 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/display/bridge/toshiba,tc358762.yaml b/Documentation/devicetree/bindings/display/bridge/toshiba,tc358762.yaml
index a412a1da950f..81ca3cbc7abe 100644
--- a/Documentation/devicetree/bindings/display/bridge/toshiba,tc358762.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/toshiba,tc358762.yaml
@@ -51,7 +51,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c1 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.yaml b/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.yaml
index 0b6f5bef120f..779d8c57f854 100644
--- a/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.yaml
@@ -87,7 +87,7 @@ examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
 
-    i2c1 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/display/panel/nec,nl8048hl11.yaml b/Documentation/devicetree/bindings/display/panel/nec,nl8048hl11.yaml
index 3b09b359023e..accf933d6e46 100644
--- a/Documentation/devicetree/bindings/display/panel/nec,nl8048hl11.yaml
+++ b/Documentation/devicetree/bindings/display/panel/nec,nl8048hl11.yaml
@@ -41,7 +41,7 @@ examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
 
-    spi0 {
+    spi {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/display/solomon,ssd1307fb.yaml b/Documentation/devicetree/bindings/display/solomon,ssd1307fb.yaml
index 669f70b1b4c4..8bd58913804a 100644
--- a/Documentation/devicetree/bindings/display/solomon,ssd1307fb.yaml
+++ b/Documentation/devicetree/bindings/display/solomon,ssd1307fb.yaml
@@ -226,7 +226,7 @@ unevaluatedProperties: false
 
 examples:
   - |
-    i2c1 {
+    i2c {
             #address-cells = <1>;
             #size-cells = <0>;
 
@@ -239,7 +239,7 @@ examples:
 
             ssd1306_i2c: oled@3d {
                     compatible = "solomon,ssd1306";
-                    reg = <0x3c>;
+                    reg = <0x3d>;
                     pwms = <&pwm 4 3000>;
                     reset-gpios = <&gpio2 7>;
                     solomon,com-lrremap;
diff --git a/Documentation/devicetree/bindings/eeprom/at25.yaml b/Documentation/devicetree/bindings/eeprom/at25.yaml
index 0f5a8ef996d3..11e2a95a7bcb 100644
--- a/Documentation/devicetree/bindings/eeprom/at25.yaml
+++ b/Documentation/devicetree/bindings/eeprom/at25.yaml
@@ -122,7 +122,7 @@ unevaluatedProperties: false
 examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
-    spi0 {
+    spi {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/extcon/extcon-usbc-cros-ec.yaml b/Documentation/devicetree/bindings/extcon/extcon-usbc-cros-ec.yaml
index 2e5b39881449..e00c8072bae9 100644
--- a/Documentation/devicetree/bindings/extcon/extcon-usbc-cros-ec.yaml
+++ b/Documentation/devicetree/bindings/extcon/extcon-usbc-cros-ec.yaml
@@ -34,7 +34,7 @@ additionalProperties: false
 
 examples:
   - |
-    spi0 {
+    spi {
         #address-cells = <1>;
         #size-cells = <0>;
         cros-ec@0 {
diff --git a/Documentation/devicetree/bindings/extcon/extcon-usbc-tusb320.yaml b/Documentation/devicetree/bindings/extcon/extcon-usbc-tusb320.yaml
index 71a9f2e5d0dc..126107dd57b1 100644
--- a/Documentation/devicetree/bindings/extcon/extcon-usbc-tusb320.yaml
+++ b/Documentation/devicetree/bindings/extcon/extcon-usbc-tusb320.yaml
@@ -30,7 +30,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
         tusb320@61 {
diff --git a/Documentation/devicetree/bindings/gpio/gpio-pca9570.yaml b/Documentation/devicetree/bindings/gpio/gpio-pca9570.yaml
index 48bf414aa50e..5b0134304e51 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-pca9570.yaml
+++ b/Documentation/devicetree/bindings/gpio/gpio-pca9570.yaml
@@ -34,7 +34,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/gpio/gpio-pca95xx.yaml b/Documentation/devicetree/bindings/gpio/gpio-pca95xx.yaml
index 1b70e9f308f3..fa116148ee90 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-pca95xx.yaml
+++ b/Documentation/devicetree/bindings/gpio/gpio-pca95xx.yaml
@@ -151,7 +151,7 @@ examples:
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/interrupt-controller/irq.h>
 
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
@@ -177,7 +177,7 @@ examples:
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
 
-    i2c1 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
@@ -203,7 +203,7 @@ examples:
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
 
-    i2c2 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
@@ -221,7 +221,7 @@ examples:
     };
 
   - |
-    i2c3 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml b/Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml
index cf523615f5e3..ab151c9db219 100644
--- a/Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml
+++ b/Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml
@@ -39,7 +39,7 @@ unevaluatedProperties: false
 
 examples:
   - |
-    spi0 {
+    spi {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml b/Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml
index 14bebe1ad8f8..34ef5215c150 100644
--- a/Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml
+++ b/Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml
@@ -58,7 +58,7 @@ examples:
 
     #include <dt-bindings/leds/common.h>
 
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/leds/issi,is31fl319x.yaml b/Documentation/devicetree/bindings/leds/issi,is31fl319x.yaml
index d1b01bae9f63..3c0431c51159 100644
--- a/Documentation/devicetree/bindings/leds/issi,is31fl319x.yaml
+++ b/Documentation/devicetree/bindings/leds/issi,is31fl319x.yaml
@@ -165,7 +165,7 @@ examples:
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/leds/common.h>
 
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/leds/leds-aw2013.yaml b/Documentation/devicetree/bindings/leds/leds-aw2013.yaml
index 6c3ea0f06cef..08f3e1cfc1b1 100644
--- a/Documentation/devicetree/bindings/leds/leds-aw2013.yaml
+++ b/Documentation/devicetree/bindings/leds/leds-aw2013.yaml
@@ -54,7 +54,7 @@ examples:
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/leds/common.h>
 
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/leds/leds-rt4505.yaml b/Documentation/devicetree/bindings/leds/leds-rt4505.yaml
index cb71fec173c1..bfd0e240f7d6 100644
--- a/Documentation/devicetree/bindings/leds/leds-rt4505.yaml
+++ b/Documentation/devicetree/bindings/leds/leds-rt4505.yaml
@@ -39,7 +39,7 @@ examples:
   - |
     #include <dt-bindings/leds/common.h>
 
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/leds/ti,tca6507.yaml b/Documentation/devicetree/bindings/leds/ti,tca6507.yaml
index 9ce5c0f16e17..4b1575e4f180 100644
--- a/Documentation/devicetree/bindings/leds/ti,tca6507.yaml
+++ b/Documentation/devicetree/bindings/leds/ti,tca6507.yaml
@@ -87,7 +87,7 @@ examples:
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/leds/common.h>
 
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/media/i2c/aptina,mt9p031.yaml b/Documentation/devicetree/bindings/media/i2c/aptina,mt9p031.yaml
index 1d6af1bf9a6b..be00de2f2d58 100644
--- a/Documentation/devicetree/bindings/media/i2c/aptina,mt9p031.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/aptina,mt9p031.yaml
@@ -82,7 +82,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.yaml b/Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.yaml
index e53b8d65f381..088022f88010 100644
--- a/Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.yaml
@@ -55,7 +55,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/media/i2c/imx219.yaml b/Documentation/devicetree/bindings/media/i2c/imx219.yaml
index 5fc96944b448..07d088cf66e0 100644
--- a/Documentation/devicetree/bindings/media/i2c/imx219.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/imx219.yaml
@@ -83,7 +83,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/media/i2c/imx258.yaml b/Documentation/devicetree/bindings/media/i2c/imx258.yaml
index cde0f7383b2a..80d24220baa0 100644
--- a/Documentation/devicetree/bindings/media/i2c/imx258.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/imx258.yaml
@@ -84,7 +84,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
@@ -111,7 +111,7 @@ examples:
     };
 
   - |
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/media/i2c/mipi-ccs.yaml b/Documentation/devicetree/bindings/media/i2c/mipi-ccs.yaml
index edde4201116f..f8ace8cbccdb 100644
--- a/Documentation/devicetree/bindings/media/i2c/mipi-ccs.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/mipi-ccs.yaml
@@ -106,7 +106,7 @@ examples:
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/media/video-interfaces.h>
 
-    i2c2 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/media/i2c/ovti,ov5648.yaml b/Documentation/devicetree/bindings/media/i2c/ovti,ov5648.yaml
index 61e4e9cf8783..1f497679168c 100644
--- a/Documentation/devicetree/bindings/media/i2c/ovti,ov5648.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/ovti,ov5648.yaml
@@ -81,7 +81,7 @@ examples:
     #include <dt-bindings/clock/sun8i-v3s-ccu.h>
     #include <dt-bindings/gpio/gpio.h>
 
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/media/i2c/ovti,ov772x.yaml b/Documentation/devicetree/bindings/media/i2c/ovti,ov772x.yaml
index 161e6d598e1c..5d24edba8f99 100644
--- a/Documentation/devicetree/bindings/media/i2c/ovti,ov772x.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/ovti,ov772x.yaml
@@ -107,7 +107,7 @@ examples:
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/media/video-interfaces.h>
 
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
         ov772x: camera@21 {
diff --git a/Documentation/devicetree/bindings/media/i2c/ovti,ov8865.yaml b/Documentation/devicetree/bindings/media/i2c/ovti,ov8865.yaml
index 6bac326dceaf..8a70e23ba6ab 100644
--- a/Documentation/devicetree/bindings/media/i2c/ovti,ov8865.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/ovti,ov8865.yaml
@@ -82,7 +82,7 @@ examples:
     #include <dt-bindings/clock/sun8i-a83t-ccu.h>
     #include <dt-bindings/gpio/gpio.h>
 
-    i2c2 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/media/i2c/ovti,ov9282.yaml b/Documentation/devicetree/bindings/media/i2c/ovti,ov9282.yaml
index 0c4654e70d46..79a7658f6d05 100644
--- a/Documentation/devicetree/bindings/media/i2c/ovti,ov9282.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/ovti,ov9282.yaml
@@ -78,7 +78,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/media/i2c/rda,rda5807.yaml b/Documentation/devicetree/bindings/media/i2c/rda,rda5807.yaml
index f50e54a722eb..34a05df786ce 100644
--- a/Documentation/devicetree/bindings/media/i2c/rda,rda5807.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/rda,rda5807.yaml
@@ -50,7 +50,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/media/i2c/sony,imx214.yaml b/Documentation/devicetree/bindings/media/i2c/sony,imx214.yaml
index c9760f895b3e..e2470dd5920c 100644
--- a/Documentation/devicetree/bindings/media/i2c/sony,imx214.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/sony,imx214.yaml
@@ -97,7 +97,7 @@ examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
 
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/media/i2c/sony,imx274.yaml b/Documentation/devicetree/bindings/media/i2c/sony,imx274.yaml
index 4271fc3cc623..b397a730ee94 100644
--- a/Documentation/devicetree/bindings/media/i2c/sony,imx274.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/sony,imx274.yaml
@@ -52,7 +52,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/media/i2c/sony,imx334.yaml b/Documentation/devicetree/bindings/media/i2c/sony,imx334.yaml
index f5055b9db693..592cbcebc8ea 100644
--- a/Documentation/devicetree/bindings/media/i2c/sony,imx334.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/sony,imx334.yaml
@@ -65,7 +65,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/media/i2c/sony,imx335.yaml b/Documentation/devicetree/bindings/media/i2c/sony,imx335.yaml
index cf2ca2702cc9..a167dcdb3a32 100644
--- a/Documentation/devicetree/bindings/media/i2c/sony,imx335.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/sony,imx335.yaml
@@ -66,7 +66,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/media/i2c/sony,imx412.yaml b/Documentation/devicetree/bindings/media/i2c/sony,imx412.yaml
index 60dc25ff2b9e..d9b7815650fd 100644
--- a/Documentation/devicetree/bindings/media/i2c/sony,imx412.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/sony,imx412.yaml
@@ -77,7 +77,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/mfd/actions,atc260x.yaml b/Documentation/devicetree/bindings/mfd/actions,atc260x.yaml
index c3a368a0fe93..6811246c5771 100644
--- a/Documentation/devicetree/bindings/mfd/actions,atc260x.yaml
+++ b/Documentation/devicetree/bindings/mfd/actions,atc260x.yaml
@@ -129,7 +129,7 @@ required:
 examples:
   - |
     #include <dt-bindings/interrupt-controller/arm-gic.h>
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
index cdf1d719efe9..8caa48f4570e 100644
--- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
+++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
@@ -246,7 +246,7 @@ examples:
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/interrupt-controller/irq.h>
 
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
@@ -263,7 +263,7 @@ examples:
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/interrupt-controller/irq.h>
 
-    spi0 {
+    spi {
         #address-cells = <1>;
         #size-cells = <0>;
 
@@ -296,7 +296,7 @@ examples:
 
   # Example for FPMCU
   - |
-    spi0 {
+    spi {
       #address-cells = <0x1>;
       #size-cells = <0x0>;
 
diff --git a/Documentation/devicetree/bindings/mfd/ti,tps65086.yaml b/Documentation/devicetree/bindings/mfd/ti,tps65086.yaml
index 3fdd9cb5b347..bd36a07c1721 100644
--- a/Documentation/devicetree/bindings/mfd/ti,tps65086.yaml
+++ b/Documentation/devicetree/bindings/mfd/ti,tps65086.yaml
@@ -95,7 +95,7 @@ required:
 examples:
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/mfd/x-powers,axp152.yaml b/Documentation/devicetree/bindings/mfd/x-powers,axp152.yaml
index b7a8747d5fa0..24d03996b93a 100644
--- a/Documentation/devicetree/bindings/mfd/x-powers,axp152.yaml
+++ b/Documentation/devicetree/bindings/mfd/x-powers,axp152.yaml
@@ -299,7 +299,7 @@ additionalProperties: false
 
 examples:
   - |
-      i2c0 {
+      i2c {
           #address-cells = <1>;
           #size-cells = <0>;
 
@@ -315,7 +315,7 @@ examples:
   - |
       #include <dt-bindings/interrupt-controller/irq.h>
 
-      i2c0 {
+      i2c {
           #address-cells = <1>;
           #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/net/asix,ax88796c.yaml b/Documentation/devicetree/bindings/net/asix,ax88796c.yaml
index 164d1ff9e83c..6b849a4349c0 100644
--- a/Documentation/devicetree/bindings/net/asix,ax88796c.yaml
+++ b/Documentation/devicetree/bindings/net/asix,ax88796c.yaml
@@ -58,7 +58,7 @@ examples:
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
     #include <dt-bindings/gpio/gpio.h>
-    spi0 {
+    spi {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/net/can/microchip,mcp251xfd.yaml b/Documentation/devicetree/bindings/net/can/microchip,mcp251xfd.yaml
index fce84aecae77..2a98b26630cb 100644
--- a/Documentation/devicetree/bindings/net/can/microchip,mcp251xfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/microchip,mcp251xfd.yaml
@@ -62,7 +62,7 @@ examples:
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/interrupt-controller/irq.h>
 
-    spi0 {
+    spi {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index a4b53434c85c..e51be1ac0362 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -67,7 +67,7 @@ examples:
         };
     };
 
-    spi0 {
+    spi {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
index 41c9760227cd..12baee45752c 100644
--- a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
@@ -69,7 +69,7 @@ examples:
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/interrupt-controller/irq.h>
 
-    i2c4 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml b/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
index 6a71f694cb55..1a2fec4857f5 100644
--- a/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
+++ b/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
@@ -55,7 +55,7 @@ additionalProperties: false
 examples:
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
-    spi0 {
+    spi {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
index f799a1e52173..75c9489f319b 100644
--- a/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
@@ -89,7 +89,7 @@ examples:
     #include <dt-bindings/interrupt-controller/irq.h>
 
     // For wl12xx family:
-    spi1 {
+    spi {
         #address-cells = <1>;
         #size-cells = <0>;
 
@@ -104,8 +104,11 @@ examples:
         };
     };
 
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+
     // For wl18xx family:
-    spi2 {
+    spi {
         #address-cells = <1>;
         #size-cells = <0>;
 
@@ -118,6 +121,9 @@ examples:
         };
     };
 
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+
     // SDIO example:
     mmc3 {
         vmmc-supply = <&wlan_en_reg>;
diff --git a/Documentation/devicetree/bindings/pinctrl/pinmux-node.yaml b/Documentation/devicetree/bindings/pinctrl/pinmux-node.yaml
index 008c3ab7f1bb..ca9d246d46fe 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinmux-node.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/pinmux-node.yaml
@@ -31,7 +31,7 @@ description: |
     };
   };
   state_1_node_a {
-    spi0 {
+    spi {
       function = "spi0";
       groups = "spi0pins";
     };
diff --git a/Documentation/devicetree/bindings/pinctrl/starfive,jh7100-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/starfive,jh7100-pinctrl.yaml
index 69c0dd9998ea..d78c3cd0c295 100644
--- a/Documentation/devicetree/bindings/pinctrl/starfive,jh7100-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/starfive,jh7100-pinctrl.yaml
@@ -293,7 +293,7 @@ examples:
             pinctrl-names = "default";
         };
 
-        i2c0 {
+        i2c {
             pinctrl-0 = <&i2c0_pins_default>;
             pinctrl-names = "default";
         };
diff --git a/Documentation/devicetree/bindings/power/supply/bq2415x.yaml b/Documentation/devicetree/bindings/power/supply/bq2415x.yaml
index f7287ffd4b12..13822346e708 100644
--- a/Documentation/devicetree/bindings/power/supply/bq2415x.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq2415x.yaml
@@ -77,7 +77,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/power/supply/bq24190.yaml b/Documentation/devicetree/bindings/power/supply/bq24190.yaml
index 001c0ffb408d..d3ebc9de8c0b 100644
--- a/Documentation/devicetree/bindings/power/supply/bq24190.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq24190.yaml
@@ -75,7 +75,7 @@ examples:
       charge-term-current-microamp = <128000>;
     };
 
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/power/supply/bq24257.yaml b/Documentation/devicetree/bindings/power/supply/bq24257.yaml
index cc45939d385b..eb064bbf876c 100644
--- a/Documentation/devicetree/bindings/power/supply/bq24257.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq24257.yaml
@@ -84,7 +84,7 @@ examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/interrupt-controller/irq.h>
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
@@ -104,7 +104,7 @@ examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/interrupt-controller/irq.h>
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/power/supply/bq24735.yaml b/Documentation/devicetree/bindings/power/supply/bq24735.yaml
index 388ee16f8a1e..af41e7ccd784 100644
--- a/Documentation/devicetree/bindings/power/supply/bq24735.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq24735.yaml
@@ -77,7 +77,7 @@ examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
 
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/power/supply/bq2515x.yaml b/Documentation/devicetree/bindings/power/supply/bq2515x.yaml
index 1a1b240034ef..845822c87f2a 100644
--- a/Documentation/devicetree/bindings/power/supply/bq2515x.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq2515x.yaml
@@ -73,7 +73,7 @@ examples:
       constant-charge-voltage-max-microvolt = <4000000>;
     };
     #include <dt-bindings/gpio/gpio.h>
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/power/supply/bq25890.yaml b/Documentation/devicetree/bindings/power/supply/bq25890.yaml
index dae27e93af09..0ad302ab2bcc 100644
--- a/Documentation/devicetree/bindings/power/supply/bq25890.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq25890.yaml
@@ -102,7 +102,7 @@ unevaluatedProperties: false
 examples:
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/power/supply/bq25980.yaml b/Documentation/devicetree/bindings/power/supply/bq25980.yaml
index b687b8bcd705..b70ce8d7f86c 100644
--- a/Documentation/devicetree/bindings/power/supply/bq25980.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq25980.yaml
@@ -95,7 +95,7 @@ examples:
     };
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/interrupt-controller/irq.h>
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/power/supply/bq27xxx.yaml b/Documentation/devicetree/bindings/power/supply/bq27xxx.yaml
index 347d4433adc5..309ea33b5b25 100644
--- a/Documentation/devicetree/bindings/power/supply/bq27xxx.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq27xxx.yaml
@@ -75,15 +75,16 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    bat: battery {
+      compatible = "simple-battery";
+      voltage-min-design-microvolt = <3200000>;
+      energy-full-design-microwatt-hours = <5290000>;
+      charge-full-design-microamp-hours = <1430000>;
+    };
+
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
-      bat: battery {
-        compatible = "simple-battery";
-        voltage-min-design-microvolt = <3200000>;
-        energy-full-design-microwatt-hours = <5290000>;
-        charge-full-design-microamp-hours = <1430000>;
-      };
 
       bq27510g3: fuel-gauge@55 {
         compatible = "ti,bq27510g3";
diff --git a/Documentation/devicetree/bindings/power/supply/lltc,ltc294x.yaml b/Documentation/devicetree/bindings/power/supply/lltc,ltc294x.yaml
index 774582cd3a2c..e68a97cb49fe 100644
--- a/Documentation/devicetree/bindings/power/supply/lltc,ltc294x.yaml
+++ b/Documentation/devicetree/bindings/power/supply/lltc,ltc294x.yaml
@@ -54,7 +54,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
       battery@64 {
diff --git a/Documentation/devicetree/bindings/power/supply/ltc4162-l.yaml b/Documentation/devicetree/bindings/power/supply/ltc4162-l.yaml
index cfffaeef8b09..29d536541152 100644
--- a/Documentation/devicetree/bindings/power/supply/ltc4162-l.yaml
+++ b/Documentation/devicetree/bindings/power/supply/ltc4162-l.yaml
@@ -54,7 +54,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
       charger: battery-charger@68 {
diff --git a/Documentation/devicetree/bindings/power/supply/maxim,max14656.yaml b/Documentation/devicetree/bindings/power/supply/maxim,max14656.yaml
index 711066b8cdb9..b444b799848e 100644
--- a/Documentation/devicetree/bindings/power/supply/maxim,max14656.yaml
+++ b/Documentation/devicetree/bindings/power/supply/maxim,max14656.yaml
@@ -32,7 +32,7 @@ additionalProperties: false
 examples:
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/power/supply/maxim,max17040.yaml b/Documentation/devicetree/bindings/power/supply/maxim,max17040.yaml
index 3a529326ecbd..2627cd3eed83 100644
--- a/Documentation/devicetree/bindings/power/supply/maxim,max17040.yaml
+++ b/Documentation/devicetree/bindings/power/supply/maxim,max17040.yaml
@@ -68,7 +68,7 @@ unevaluatedProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
@@ -82,7 +82,7 @@ examples:
     };
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/power/supply/maxim,max17042.yaml b/Documentation/devicetree/bindings/power/supply/maxim,max17042.yaml
index 64a0edb7bc47..085e2504d0dc 100644
--- a/Documentation/devicetree/bindings/power/supply/maxim,max17042.yaml
+++ b/Documentation/devicetree/bindings/power/supply/maxim,max17042.yaml
@@ -69,7 +69,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/power/supply/richtek,rt9455.yaml b/Documentation/devicetree/bindings/power/supply/richtek,rt9455.yaml
index 27bebc1757ba..07e38be39f1b 100644
--- a/Documentation/devicetree/bindings/power/supply/richtek,rt9455.yaml
+++ b/Documentation/devicetree/bindings/power/supply/richtek,rt9455.yaml
@@ -68,7 +68,7 @@ additionalProperties: false
 examples:
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/power/supply/ti,lp8727.yaml b/Documentation/devicetree/bindings/power/supply/ti,lp8727.yaml
index ce6fbdba8f6b..3a9e4310b433 100644
--- a/Documentation/devicetree/bindings/power/supply/ti,lp8727.yaml
+++ b/Documentation/devicetree/bindings/power/supply/ti,lp8727.yaml
@@ -61,7 +61,7 @@ additionalProperties: false
 examples:
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/regulator/active-semi,act8865.yaml b/Documentation/devicetree/bindings/regulator/active-semi,act8865.yaml
index e8bf09faafb8..afe1abc2d727 100644
--- a/Documentation/devicetree/bindings/regulator/active-semi,act8865.yaml
+++ b/Documentation/devicetree/bindings/regulator/active-semi,act8865.yaml
@@ -90,7 +90,7 @@ examples:
   - |
     #include <dt-bindings/regulator/active-semi,8865-regulator.h>
 
-    i2c1 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/regulator/google,cros-ec-regulator.yaml b/Documentation/devicetree/bindings/regulator/google,cros-ec-regulator.yaml
index 0921f012c901..0c6032de593a 100644
--- a/Documentation/devicetree/bindings/regulator/google,cros-ec-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/google,cros-ec-regulator.yaml
@@ -32,7 +32,7 @@ unevaluatedProperties: false
 
 examples:
   - |
-    spi0 {
+    spi {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/regulator/nxp,pf8x00-regulator.yaml b/Documentation/devicetree/bindings/regulator/nxp,pf8x00-regulator.yaml
index aabf50f5b39e..e094c40a7072 100644
--- a/Documentation/devicetree/bindings/regulator/nxp,pf8x00-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/nxp,pf8x00-regulator.yaml
@@ -109,7 +109,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c1 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/sound/everest,es8316.yaml b/Documentation/devicetree/bindings/sound/everest,es8316.yaml
index d9f8f0c7f6bb..9f2b111818ea 100644
--- a/Documentation/devicetree/bindings/sound/everest,es8316.yaml
+++ b/Documentation/devicetree/bindings/sound/everest,es8316.yaml
@@ -40,7 +40,7 @@ unevaluatedProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
       es8316: codec@11 {
diff --git a/Documentation/devicetree/bindings/sound/tas2562.yaml b/Documentation/devicetree/bindings/sound/tas2562.yaml
index 1085592cefcc..a5bb561bfcfb 100644
--- a/Documentation/devicetree/bindings/sound/tas2562.yaml
+++ b/Documentation/devicetree/bindings/sound/tas2562.yaml
@@ -66,7 +66,7 @@ unevaluatedProperties: false
 examples:
   - |
    #include <dt-bindings/gpio/gpio.h>
-   i2c0 {
+   i2c {
      #address-cells = <1>;
      #size-cells = <0>;
      codec: codec@4c {
diff --git a/Documentation/devicetree/bindings/sound/tas2770.yaml b/Documentation/devicetree/bindings/sound/tas2770.yaml
index 982949ba8a4b..26088adb9dc2 100644
--- a/Documentation/devicetree/bindings/sound/tas2770.yaml
+++ b/Documentation/devicetree/bindings/sound/tas2770.yaml
@@ -68,7 +68,7 @@ unevaluatedProperties: false
 examples:
   - |
    #include <dt-bindings/gpio/gpio.h>
-   i2c0 {
+   i2c {
      #address-cells = <1>;
      #size-cells = <0>;
      codec: codec@41 {
diff --git a/Documentation/devicetree/bindings/sound/tas27xx.yaml b/Documentation/devicetree/bindings/sound/tas27xx.yaml
index 0957dd435bb4..8cba01316855 100644
--- a/Documentation/devicetree/bindings/sound/tas27xx.yaml
+++ b/Documentation/devicetree/bindings/sound/tas27xx.yaml
@@ -61,7 +61,7 @@ unevaluatedProperties: false
 examples:
   - |
    #include <dt-bindings/gpio/gpio.h>
-   i2c0 {
+   i2c {
      #address-cells = <1>;
      #size-cells = <0>;
      codec: codec@38 {
diff --git a/Documentation/devicetree/bindings/sound/tas5805m.yaml b/Documentation/devicetree/bindings/sound/tas5805m.yaml
index 3aade02d8a96..63edf52f061c 100644
--- a/Documentation/devicetree/bindings/sound/tas5805m.yaml
+++ b/Documentation/devicetree/bindings/sound/tas5805m.yaml
@@ -39,7 +39,7 @@ properties:
 
 examples:
   - |
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
         tas5805m: tas5805m@2c {
diff --git a/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml b/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
index 6b8214071115..c16e1760cf85 100644
--- a/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
+++ b/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
@@ -192,7 +192,7 @@ additionalProperties: false
 examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
       codec: codec@4c {
diff --git a/Documentation/devicetree/bindings/sound/zl38060.yaml b/Documentation/devicetree/bindings/sound/zl38060.yaml
index 2c5c02e34573..8bd201e573aa 100644
--- a/Documentation/devicetree/bindings/sound/zl38060.yaml
+++ b/Documentation/devicetree/bindings/sound/zl38060.yaml
@@ -56,7 +56,7 @@ unevaluatedProperties: false
 examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
-    spi0 {
+    spi {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/usb/maxim,max33359.yaml b/Documentation/devicetree/bindings/usb/maxim,max33359.yaml
index 8e513a6af378..3cb631ea7079 100644
--- a/Documentation/devicetree/bindings/usb/maxim,max33359.yaml
+++ b/Documentation/devicetree/bindings/usb/maxim,max33359.yaml
@@ -40,7 +40,7 @@ examples:
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
     #include <dt-bindings/usb/pd.h>
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/usb/maxim,max3420-udc.yaml b/Documentation/devicetree/bindings/usb/maxim,max3420-udc.yaml
index 1d893d3d3432..8e0f4ecc010d 100644
--- a/Documentation/devicetree/bindings/usb/maxim,max3420-udc.yaml
+++ b/Documentation/devicetree/bindings/usb/maxim,max3420-udc.yaml
@@ -52,7 +52,7 @@ examples:
   - |
       #include <dt-bindings/gpio/gpio.h>
       #include <dt-bindings/interrupt-controller/irq.h>
-      spi0 {
+      spi {
             #address-cells = <1>;
             #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/usb/mediatek,mt6360-tcpc.yaml b/Documentation/devicetree/bindings/usb/mediatek,mt6360-tcpc.yaml
index c72257c19220..6cad7ae2c70d 100644
--- a/Documentation/devicetree/bindings/usb/mediatek,mt6360-tcpc.yaml
+++ b/Documentation/devicetree/bindings/usb/mediatek,mt6360-tcpc.yaml
@@ -43,7 +43,7 @@ examples:
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
     #include <dt-bindings/usb/pd.h>
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/usb/richtek,rt1711h.yaml b/Documentation/devicetree/bindings/usb/richtek,rt1711h.yaml
index 1999f614c89b..dd864b25a148 100644
--- a/Documentation/devicetree/bindings/usb/richtek,rt1711h.yaml
+++ b/Documentation/devicetree/bindings/usb/richtek,rt1711h.yaml
@@ -51,7 +51,7 @@ examples:
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
     #include <dt-bindings/usb/pd.h>
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/usb/richtek,rt1719.yaml b/Documentation/devicetree/bindings/usb/richtek,rt1719.yaml
index e3e87e4d3292..8b9bd2cc58e9 100644
--- a/Documentation/devicetree/bindings/usb/richtek,rt1719.yaml
+++ b/Documentation/devicetree/bindings/usb/richtek,rt1719.yaml
@@ -48,7 +48,7 @@ required:
 examples:
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
-    i2c0 {
+    i2c {
       #address-cells = <1>;
       #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/usb/st,stusb160x.yaml b/Documentation/devicetree/bindings/usb/st,stusb160x.yaml
index ffcd9897ea38..f6840cd5750d 100644
--- a/Documentation/devicetree/bindings/usb/st,stusb160x.yaml
+++ b/Documentation/devicetree/bindings/usb/st,stusb160x.yaml
@@ -56,7 +56,7 @@ additionalProperties: false
 examples:
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
-    i2c4 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/usb/ti,hd3ss3220.yaml b/Documentation/devicetree/bindings/usb/ti,hd3ss3220.yaml
index a1cffb70c621..54c6586cb56d 100644
--- a/Documentation/devicetree/bindings/usb/ti,hd3ss3220.yaml
+++ b/Documentation/devicetree/bindings/usb/ti,hd3ss3220.yaml
@@ -51,7 +51,7 @@ additionalProperties: false
 
 examples:
   - |
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
diff --git a/Documentation/devicetree/bindings/usb/ti,tps6598x.yaml b/Documentation/devicetree/bindings/usb/ti,tps6598x.yaml
index 348a715d61f4..7dfa34d11b0e 100644
--- a/Documentation/devicetree/bindings/usb/ti,tps6598x.yaml
+++ b/Documentation/devicetree/bindings/usb/ti,tps6598x.yaml
@@ -43,7 +43,7 @@ additionalProperties: true
 examples:
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
-    i2c0 {
+    i2c {
         #address-cells = <1>;
         #size-cells = <0>;
 
-- 
2.39.2

