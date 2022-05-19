Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6A352DF08
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 23:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245066AbiESVOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 17:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbiESVOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 17:14:17 -0400
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711956A04E;
        Thu, 19 May 2022 14:14:15 -0700 (PDT)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-f18e6ff0f6so8236590fac.11;
        Thu, 19 May 2022 14:14:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LxgJ0WPMVmk2nku/9e7+IkyjOm1K2GpkGddzezuJOx0=;
        b=M9dU3VdTDsgaPIhfae91fY8q8JA8WnocGaq2qO11cO7VOK0Kmf1cc9ezJnyIIdlSUr
         HH9HJ1P/kxf+FU6VwyOC9nBjDhcpGZDkpOO380urPqpwOuPI2ZdFkCyePWdJ1v6sNymW
         QGz0UmbYbUeT4CTroXmS1NP9zDXE7XtYVD4tc7vsy/zavgPY/l78iz0yIQojdRUEX2lq
         hxc+bsrquPi2+f8ZiZzO3X/1+eXcTPCCp1jvnT5yEktJ4d3xVJcTtoE3TQZkjbHR4pVl
         YxLutBA0TnKoGr0GJ+eYjeF44MMjcMkQgTfHXnghOW/X6uKmRd34ggHEHsbXCCrm7Efk
         8xPw==
X-Gm-Message-State: AOAM5323CZAAMjFHPVIOgd0EjpDbKmNtkJfgXHi9UOte5Ma9wrq1D4hJ
        2IXGyz1j9x8QlH+E6jNmFLvEtV2ywA==
X-Google-Smtp-Source: ABdhPJxqd+goUrJIo+WvgR54Lvn7Cn5KV5+/HRaUb0gHTseGWHqxpGn2/l3xlDDk7Z9PQGssS6T1uw==
X-Received: by 2002:a05:6870:889d:b0:e6:170e:a37b with SMTP id m29-20020a056870889d00b000e6170ea37bmr4199509oam.38.1652994853853;
        Thu, 19 May 2022 14:14:13 -0700 (PDT)
Received: from xps15.. (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.googlemail.com with ESMTPSA id c206-20020acab3d7000000b00325cda1ffbbsm146366oif.58.2022.05.19.14.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 14:14:12 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Peter Rosin <peda@axentia.se>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sebastian Reichel <sre@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Maxime Ripard <mripard@kernel.org>
Cc:     dri-devel@lists.freedesktop.org, linux-gpio@vger.kernel.org,
        linux-input@vger.kernel.org, chrome-platform@lists.linux.dev,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
Subject: [PATCH] dt-bindings: Fix properties without any type
Date:   Thu, 19 May 2022 16:14:11 -0500
Message-Id: <20220519211411.2200720-1-robh@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the schema tools can extract type information for all
properties (in order to decode dtb files), finding properties missing
any type definition is fairly trivial though not yet automated.

Fix the various property schemas which are missing a type. Most of these
tend to be device specific properties which don't have a vendor prefix.
A vendor prefix is how we normally ensure a type is defined.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../arm/hisilicon/controller/hip04-bootwrapper.yaml       | 5 +++--
 .../bindings/display/bridge/toshiba,tc358768.yaml         | 1 +
 .../devicetree/bindings/display/panel/panel-timing.yaml   | 5 +++++
 .../bindings/display/panel/raydium,rm67191.yaml           | 1 +
 .../bindings/display/panel/samsung,s6e8aa0.yaml           | 1 +
 .../devicetree/bindings/gpio/fairchild,74hc595.yaml       | 1 +
 .../devicetree/bindings/input/google,cros-ec-keyb.yaml    | 1 +
 .../devicetree/bindings/input/matrix-keymap.yaml          | 4 ++++
 Documentation/devicetree/bindings/media/i2c/adv7604.yaml  | 3 ++-
 Documentation/devicetree/bindings/mux/reg-mux.yaml        | 8 ++++++--
 Documentation/devicetree/bindings/net/cdns,macb.yaml      | 1 +
 Documentation/devicetree/bindings/net/ingenic,mac.yaml    | 1 +
 .../devicetree/bindings/net/ti,davinci-mdio.yaml          | 1 +
 .../devicetree/bindings/net/wireless/ti,wlcore.yaml       | 2 ++
 .../devicetree/bindings/pci/snps,dw-pcie-ep.yaml          | 6 ++++--
 Documentation/devicetree/bindings/pci/snps,dw-pcie.yaml   | 2 ++
 .../devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml    | 2 ++
 Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml | 1 +
 .../devicetree/bindings/power/supply/battery.yaml         | 7 ++++++-
 .../devicetree/bindings/power/supply/charger-manager.yaml | 1 +
 Documentation/devicetree/bindings/rng/st,stm32-rng.yaml   | 1 +
 Documentation/devicetree/bindings/serial/8250.yaml        | 1 +
 .../devicetree/bindings/sound/audio-graph-card2.yaml      | 3 +++
 .../devicetree/bindings/sound/imx-audio-hdmi.yaml         | 3 +++
 Documentation/devicetree/bindings/usb/smsc,usb3503.yaml   | 1 +
 25 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/hisilicon/controller/hip04-bootwrapper.yaml b/Documentation/devicetree/bindings/arm/hisilicon/controller/hip04-bootwrapper.yaml
index 7378159e61df..483caf0ce25b 100644
--- a/Documentation/devicetree/bindings/arm/hisilicon/controller/hip04-bootwrapper.yaml
+++ b/Documentation/devicetree/bindings/arm/hisilicon/controller/hip04-bootwrapper.yaml
@@ -17,14 +17,15 @@ properties:
       - const: hisilicon,hip04-bootwrapper
 
   boot-method:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
     description: |
       Address and size of boot method.
       [0]: bootwrapper physical address
       [1]: bootwrapper size
       [2]: relocation physical address
       [3]: relocation size
-    minItems: 1
-    maxItems: 2
+    minItems: 2
+    maxItems: 4
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.yaml b/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.yaml
index 3bd670b8e5cd..0b6f5bef120f 100644
--- a/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.yaml
@@ -58,6 +58,7 @@ properties:
 
             properties:
               data-lines:
+                $ref: /schemas/types.yaml#/definitions/uint32
                 enum: [ 16, 18, 24 ]
 
       port@1:
diff --git a/Documentation/devicetree/bindings/display/panel/panel-timing.yaml b/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
index 7749de95ee40..229e3b36ee29 100644
--- a/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
+++ b/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
@@ -146,6 +146,7 @@ properties:
       Horizontal sync pulse.
       0 selects active low, 1 selects active high.
       If omitted then it is not used by the hardware
+    $ref: /schemas/types.yaml#/definitions/uint32
     enum: [0, 1]
 
   vsync-active:
@@ -153,6 +154,7 @@ properties:
       Vertical sync pulse.
       0 selects active low, 1 selects active high.
       If omitted then it is not used by the hardware
+    $ref: /schemas/types.yaml#/definitions/uint32
     enum: [0, 1]
 
   de-active:
@@ -160,6 +162,7 @@ properties:
       Data enable.
       0 selects active low, 1 selects active high.
       If omitted then it is not used by the hardware
+    $ref: /schemas/types.yaml#/definitions/uint32
     enum: [0, 1]
 
   pixelclk-active:
@@ -169,6 +172,7 @@ properties:
       sample data on rising edge.
       Use 1 to drive pixel data on rising edge and
       sample data on falling edge
+    $ref: /schemas/types.yaml#/definitions/uint32
     enum: [0, 1]
 
   syncclk-active:
@@ -179,6 +183,7 @@ properties:
       sample sync on rising edge of pixel clock.
       Use 1 to drive sync on rising edge and
       sample sync on falling edge of pixel clock
+    $ref: /schemas/types.yaml#/definitions/uint32
     enum: [0, 1]
 
   interlaced:
diff --git a/Documentation/devicetree/bindings/display/panel/raydium,rm67191.yaml b/Documentation/devicetree/bindings/display/panel/raydium,rm67191.yaml
index 745dd247c409..617aa8c8c03a 100644
--- a/Documentation/devicetree/bindings/display/panel/raydium,rm67191.yaml
+++ b/Documentation/devicetree/bindings/display/panel/raydium,rm67191.yaml
@@ -24,6 +24,7 @@ properties:
 
   dsi-lanes:
     description: Number of DSI lanes to be used must be <3> or <4>
+    $ref: /schemas/types.yaml#/definitions/uint32
     enum: [3, 4]
 
   v3p3-supply:
diff --git a/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa0.yaml b/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa0.yaml
index ca959451557e..1cdc91b3439f 100644
--- a/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa0.yaml
+++ b/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa0.yaml
@@ -36,6 +36,7 @@ properties:
 
   init-delay:
     description: delay after initialization sequence [ms]
+    $ref: /schemas/types.yaml#/definitions/uint32
 
   panel-width-mm:
     description: physical panel width [mm]
diff --git a/Documentation/devicetree/bindings/gpio/fairchild,74hc595.yaml b/Documentation/devicetree/bindings/gpio/fairchild,74hc595.yaml
index 5fe19fa5f67c..a99e7842ca17 100644
--- a/Documentation/devicetree/bindings/gpio/fairchild,74hc595.yaml
+++ b/Documentation/devicetree/bindings/gpio/fairchild,74hc595.yaml
@@ -26,6 +26,7 @@ properties:
     const: 2
 
   registers-number:
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: Number of daisy-chained shift registers
 
   enable-gpios:
diff --git a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
index e8f137abb03c..aa61fe64be63 100644
--- a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
+++ b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
@@ -31,6 +31,7 @@ properties:
     type: boolean
 
   function-row-physmap:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
     minItems: 1
     maxItems: 15
     description: |
diff --git a/Documentation/devicetree/bindings/input/matrix-keymap.yaml b/Documentation/devicetree/bindings/input/matrix-keymap.yaml
index 6699d5e32dca..9f703bb51e12 100644
--- a/Documentation/devicetree/bindings/input/matrix-keymap.yaml
+++ b/Documentation/devicetree/bindings/input/matrix-keymap.yaml
@@ -27,6 +27,10 @@ properties:
       column and linux key-code. The 32-bit big endian cell is packed as:
           row << 24 | column << 16 | key-code
 
+  linux,no-autorepeat:
+    type: boolean
+    description: Disable keyrepeat
+
   keypad,num-rows:
     $ref: /schemas/types.yaml#/definitions/uint32
     description: Number of row lines connected to the keypad controller.
diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.yaml b/Documentation/devicetree/bindings/media/i2c/adv7604.yaml
index c19d8391e2d5..7589d377c686 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7604.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/adv7604.yaml
@@ -60,7 +60,8 @@ properties:
       enables hot-plug detection.
 
   default-input:
-    maxItems: 1
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [ 0, 1 ]
     description:
       Select which input is selected after reset.
 
diff --git a/Documentation/devicetree/bindings/mux/reg-mux.yaml b/Documentation/devicetree/bindings/mux/reg-mux.yaml
index 60d5746eb39d..e2f6b11f1254 100644
--- a/Documentation/devicetree/bindings/mux/reg-mux.yaml
+++ b/Documentation/devicetree/bindings/mux/reg-mux.yaml
@@ -25,8 +25,12 @@ properties:
     const: 1
 
   mux-reg-masks:
-    description: an array of register offset and pre-shifted bitfield mask
-      pairs, each describing a single mux control.
+    $ref: /schemas/types.yaml#/definitions/uint32-matrix
+    items:
+      items:
+        - description: register offset
+        - description: pre-shifted bitfield mask
+    description: Each entry describes a single mux control.
 
   idle-states: true
 
diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
index 6cd3d853dcba..59fe2789fa44 100644
--- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
+++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
@@ -129,6 +129,7 @@ patternProperties:
       reset-gpios: true
 
       magic-packet:
+        type: boolean
         description:
           Indicates that the hardware supports waking up via magic packet.
 
diff --git a/Documentation/devicetree/bindings/net/ingenic,mac.yaml b/Documentation/devicetree/bindings/net/ingenic,mac.yaml
index 8e52b2e683b8..93b3e991d209 100644
--- a/Documentation/devicetree/bindings/net/ingenic,mac.yaml
+++ b/Documentation/devicetree/bindings/net/ingenic,mac.yaml
@@ -37,6 +37,7 @@ properties:
     const: stmmaceth
 
   mode-reg:
+    $ref: /schemas/types.yaml#/definitions/phandle
     description: An extra syscon register that control ethernet interface and timing delay
 
   rx-clk-delay-ps:
diff --git a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
index 6f44f9516c36..a339202c5e8e 100644
--- a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
@@ -34,6 +34,7 @@ properties:
     maxItems: 1
 
   bus_freq:
+    $ref: /schemas/types.yaml#/definitions/uint32
     maximum: 2500000
     description: MDIO Bus frequency
 
diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
index 8dd164d10290..d68bb2ec1f7e 100644
--- a/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
@@ -54,9 +54,11 @@ properties:
 
 
   ref-clock-frequency:
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: Reference clock frequency.
 
   tcxo-clock-frequency:
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: TCXO clock frequency.
 
   clock-xtal:
diff --git a/Documentation/devicetree/bindings/pci/snps,dw-pcie-ep.yaml b/Documentation/devicetree/bindings/pci/snps,dw-pcie-ep.yaml
index e59059ab5be0..b78535040f04 100644
--- a/Documentation/devicetree/bindings/pci/snps,dw-pcie-ep.yaml
+++ b/Documentation/devicetree/bindings/pci/snps,dw-pcie-ep.yaml
@@ -55,13 +55,15 @@ properties:
       Translation Unit) registers.
 
   num-ib-windows:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    maximum: 256
     description: number of inbound address translation windows
-    maxItems: 1
     deprecated: true
 
   num-ob-windows:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    maximum: 256
     description: number of outbound address translation windows
-    maxItems: 1
     deprecated: true
 
 required:
diff --git a/Documentation/devicetree/bindings/pci/snps,dw-pcie.yaml b/Documentation/devicetree/bindings/pci/snps,dw-pcie.yaml
index a5345c494744..c90e5e2d25f6 100644
--- a/Documentation/devicetree/bindings/pci/snps,dw-pcie.yaml
+++ b/Documentation/devicetree/bindings/pci/snps,dw-pcie.yaml
@@ -68,6 +68,8 @@ properties:
       Translation Unit) registers.
 
   num-viewport:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    maximum: 256
     description: |
       number of view ports configured in hardware. If a platform
       does not specify it, the driver autodetects it.
diff --git a/Documentation/devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml b/Documentation/devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml
index 53e963e090f2..533b4cfe33d2 100644
--- a/Documentation/devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml
@@ -120,6 +120,7 @@ patternProperties:
       input-schmitt-disable: true
 
       input-polarity-invert:
+        type: boolean
         description:
           Enable or disable pin input polarity inversion.
 
@@ -132,6 +133,7 @@ patternProperties:
       output-low: true
 
       output-polarity-invert:
+        type: boolean
         description:
           Enable or disable pin output polarity inversion.
 
diff --git a/Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml b/Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml
index 3301fa0c2653..301db7daf870 100644
--- a/Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml
+++ b/Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml
@@ -51,6 +51,7 @@ properties:
       supported by the CPR power domain.
 
   acc-syscon:
+    $ref: /schemas/types.yaml#/definitions/phandle
     description: A phandle to the syscon used for writing ACC settings.
 
   nvmem-cells:
diff --git a/Documentation/devicetree/bindings/power/supply/battery.yaml b/Documentation/devicetree/bindings/power/supply/battery.yaml
index d56ac484fec5..491488e7b970 100644
--- a/Documentation/devicetree/bindings/power/supply/battery.yaml
+++ b/Documentation/devicetree/bindings/power/supply/battery.yaml
@@ -85,8 +85,13 @@ properties:
     description: battery factory internal resistance
 
   resistance-temp-table:
+    $ref: /schemas/types.yaml#/definitions/uint32-matrix
+    items:
+      items:
+        - description: the temperature in degree Celsius
+        - description: battery internal resistance percent
     description: |
-      An array providing the temperature in degree Celsius
+      A table providing the temperature in degree Celsius
       and corresponding battery internal resistance percent, which is used to
       look up the resistance percent according to current temperature to get an
       accurate batterty internal resistance in different temperatures.
diff --git a/Documentation/devicetree/bindings/power/supply/charger-manager.yaml b/Documentation/devicetree/bindings/power/supply/charger-manager.yaml
index c863cfa67865..fbb2204769aa 100644
--- a/Documentation/devicetree/bindings/power/supply/charger-manager.yaml
+++ b/Documentation/devicetree/bindings/power/supply/charger-manager.yaml
@@ -36,6 +36,7 @@ properties:
 
   cm-poll-mode:
     description: polling mode
+    $ref: /schemas/types.yaml#/definitions/uint32
     default: 0
     enum:
       - 0 # disabled
diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
index 9a6e4eaf4d3c..fcd86f822a9c 100644
--- a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
@@ -27,6 +27,7 @@ properties:
     maxItems: 1
 
   clock-error-detect:
+    type: boolean
     description: If set enable the clock detection management
 
 required:
diff --git a/Documentation/devicetree/bindings/serial/8250.yaml b/Documentation/devicetree/bindings/serial/8250.yaml
index 3bab2f27b970..5f6b113d378f 100644
--- a/Documentation/devicetree/bindings/serial/8250.yaml
+++ b/Documentation/devicetree/bindings/serial/8250.yaml
@@ -138,6 +138,7 @@ properties:
     description: The current active speed of the UART.
 
   reg-offset:
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
       Offset to apply to the mapbase from the start of the registers.
 
diff --git a/Documentation/devicetree/bindings/sound/audio-graph-card2.yaml b/Documentation/devicetree/bindings/sound/audio-graph-card2.yaml
index f7e94b1e0e4b..7416067c945e 100644
--- a/Documentation/devicetree/bindings/sound/audio-graph-card2.yaml
+++ b/Documentation/devicetree/bindings/sound/audio-graph-card2.yaml
@@ -24,10 +24,13 @@ properties:
       connection's sink, the second being the connection's source.
     $ref: /schemas/types.yaml#/definitions/non-unique-string-array
   multi:
+    type: object
     description: Multi-CPU/Codec node
   dpcm:
+    type: object
     description: DPCM node
   codec2codec:
+    type: object
     description: Codec to Codec node
 
 required:
diff --git a/Documentation/devicetree/bindings/sound/imx-audio-hdmi.yaml b/Documentation/devicetree/bindings/sound/imx-audio-hdmi.yaml
index d5474f83ac2c..e7e7bb65c366 100644
--- a/Documentation/devicetree/bindings/sound/imx-audio-hdmi.yaml
+++ b/Documentation/devicetree/bindings/sound/imx-audio-hdmi.yaml
@@ -20,9 +20,11 @@ properties:
     description: User specified audio sound card name
 
   audio-cpu:
+    $ref: /schemas/types.yaml#/definitions/phandle
     description: The phandle of an CPU DAI controller
 
   hdmi-out:
+    type: boolean
     description: |
       This is a boolean property. If present, the transmitting function
       of HDMI will be enabled, indicating there's a physical HDMI out
@@ -30,6 +32,7 @@ properties:
       block, such as an HDMI encoder or display-controller.
 
   hdmi-in:
+    type: boolean
     description: |
       This is a boolean property. If present, the receiving function of
       HDMI will be enabled, indicating there is a physical HDMI in
diff --git a/Documentation/devicetree/bindings/usb/smsc,usb3503.yaml b/Documentation/devicetree/bindings/usb/smsc,usb3503.yaml
index b9e219829801..321b6f166197 100644
--- a/Documentation/devicetree/bindings/usb/smsc,usb3503.yaml
+++ b/Documentation/devicetree/bindings/usb/smsc,usb3503.yaml
@@ -45,6 +45,7 @@ properties:
       property if all ports have to be enabled.
 
   initial-mode:
+    $ref: /schemas/types.yaml#/definitions/uint32
     enum: [1, 2]
     description: >
       Specifies initial mode. 1 for Hub mode, 2 for standby mode.
-- 
2.34.1

