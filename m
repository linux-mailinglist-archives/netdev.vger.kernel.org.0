Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D512DDB88
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 23:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732244AbgLQWfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 17:35:17 -0500
Received: from mail-oi1-f175.google.com ([209.85.167.175]:43417 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730152AbgLQWfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 17:35:16 -0500
Received: by mail-oi1-f175.google.com with SMTP id q25so732612oij.10;
        Thu, 17 Dec 2020 14:34:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9/tR8JUtmliEcmNgVzxtbo3jj9iZ0PGUJtoxqDrqNwk=;
        b=A7p4o0QKlEZItFYzQKyGzWnDh8TZauHW2NbTpuLrq9O1ZtfBato/58A46j9+s0ivoe
         Jyj/oZzmA2L/vPqdkLymvMw9J7pzIp9aGGNOenAupysEK1KblgStB8RpTDgfOSr6VFMu
         Kgs3Ngu3pzEDkiC7NzhvjPM7lhkJ3XSvJGXx5puyZrTVocZlAVUVo0+6pbTqAd2m5rwk
         YLaoVNg1YT7pEy8vTbu5otIahb4szjt+f9aWo4Kf5nzRIDVuUiRxQUQBX+6NdxoISaCy
         Z0jtngfU9/sLaBkkVzc+O700n78agIboU/zS7qh8jYYtHG+F3G/6MMlU7wKUT/h8Mhvu
         s5mA==
X-Gm-Message-State: AOAM533C4jczS6ERWWDvsentk6z1tvnGQ7pnvkk4bTe+cnJZvtA14gPW
        DUHHALQiFOmg+ySSeXFD+s6gRSnXXQ==
X-Google-Smtp-Source: ABdhPJwbH3zfFL2En0j1ycE9tE64O8bX7UVRnKUTb64MP3jQGjeb0J7R7nehT7Ef6+vY4hWTRYoM1A==
X-Received: by 2002:aca:5c08:: with SMTP id q8mr999355oib.54.1608244471575;
        Thu, 17 Dec 2020 14:34:31 -0800 (PST)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.googlemail.com with ESMTPSA id f25sm1514935oou.39.2020.12.17.14.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 14:34:30 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jingoo Han <jingoohan1@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] dt-bindings: Fix JSON pointers
Date:   Thu, 17 Dec 2020 16:34:29 -0600
Message-Id: <20201217223429.354283-1-robh@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The correct syntax for JSON pointers begins with a '/' after the '#'.
Without a '/', the string should be interpretted as a subschema
identifier. The jsonschema module currently doesn't handle subschema
identifiers and incorrectly allows JSON pointers to begin without a '/'.
Let's fix this before it becomes a problem when jsonschema module is
fixed.

Converted with:
perl -p -i -e 's/yaml#definitions/yaml#\/definitions/g' `find Documentation/devicetree/bindings/ -name "*.yaml"`

Cc: Maxime Ripard <mripard@kernel.org>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jingoo Han <jingoohan1@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/arm/idle-states.yaml  |  2 +-
 .../bus/allwinner,sun50i-a64-de2.yaml         |  2 +-
 .../bindings/bus/baikal,bt1-axi.yaml          |  2 +-
 .../bindings/connector/usb-connector.yaml     | 10 ++---
 .../devicetree/bindings/dma/dma-common.yaml   |  4 +-
 .../devicetree/bindings/dma/dma-router.yaml   |  2 +-
 .../devicetree/bindings/dma/ingenic,dma.yaml  |  2 +-
 .../bindings/dma/snps,dma-spear1340.yaml      | 10 ++---
 .../devicetree/bindings/eeprom/at24.yaml      |  4 +-
 .../devicetree/bindings/eeprom/at25.yaml      |  4 +-
 .../bindings/hwmon/moortec,mr75203.yaml       |  2 +-
 .../bindings/hwmon/sensirion,shtc1.yaml       |  4 +-
 .../devicetree/bindings/hwmon/ti,tmp513.yaml  |  2 +-
 .../bindings/iio/light/upisemi,us5182.yaml    |  2 +-
 .../iio/proximity/semtech,sx9310.yaml         |  6 +--
 .../devicetree/bindings/input/gpio-keys.yaml  | 12 +++---
 .../interrupt-controller/mti,gic.yaml         |  4 +-
 .../interrupt-controller/ti,pruss-intc.yaml   |  2 +-
 .../interrupt-controller/ti,sci-inta.yaml     |  2 +-
 .../bindings/leds/backlight/common.yaml       |  4 +-
 .../devicetree/bindings/leds/common.yaml      | 16 ++++----
 .../devicetree/bindings/leds/leds-lp55xx.yaml | 10 ++---
 .../net/allwinner,sun8i-a83t-emac.yaml        |  6 +--
 .../bindings/net/amlogic,meson-dwmac.yaml     |  2 +-
 .../devicetree/bindings/net/dsa/dsa.yaml      |  6 +--
 .../bindings/net/ethernet-controller.yaml     | 24 ++++++------
 .../devicetree/bindings/net/ethernet-phy.yaml | 20 +++++-----
 .../bindings/net/fsl,qoriq-mc-dpmac.yaml      |  2 +-
 .../devicetree/bindings/net/mdio.yaml         |  2 +-
 .../bindings/net/mediatek,star-emac.yaml      |  2 +-
 .../devicetree/bindings/net/qcom,ipa.yaml     |  2 +-
 .../devicetree/bindings/net/snps,dwmac.yaml   | 38 +++++++++----------
 .../bindings/net/socionext,uniphier-ave4.yaml |  2 +-
 .../bindings/net/ti,cpsw-switch.yaml          |  2 +-
 .../devicetree/bindings/net/ti,dp83867.yaml   | 12 +++---
 .../devicetree/bindings/net/ti,dp83869.yaml   |  8 ++--
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |  4 +-
 .../bindings/net/wireless/qcom,ath11k.yaml    |  2 +-
 .../devicetree/bindings/phy/ti,omap-usb2.yaml |  4 +-
 .../power/mediatek,power-controller.yaml      | 12 +++---
 .../bindings/power/supply/cw2015_battery.yaml |  2 +-
 .../devicetree/bindings/powerpc/sleep.yaml    |  2 +-
 .../devicetree/bindings/serial/8250.yaml      |  6 +--
 .../bindings/soc/ti/k3-ringacc.yaml           |  2 +-
 .../sound/allwinner,sun4i-a10-codec.yaml      |  2 +-
 .../bindings/sound/st,stm32-sai.yaml          |  4 +-
 46 files changed, 138 insertions(+), 138 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/idle-states.yaml b/Documentation/devicetree/bindings/arm/idle-states.yaml
index ea805c1e6b20..52bce5dbb11f 100644
--- a/Documentation/devicetree/bindings/arm/idle-states.yaml
+++ b/Documentation/devicetree/bindings/arm/idle-states.yaml
@@ -313,7 +313,7 @@ patternProperties:
           wakeup-latency-us by this duration.
 
       idle-state-name:
-        $ref: /schemas/types.yaml#definitions/string
+        $ref: /schemas/types.yaml#/definitions/string
         description:
           A string used as a descriptive name for the idle state.
 
diff --git a/Documentation/devicetree/bindings/bus/allwinner,sun50i-a64-de2.yaml b/Documentation/devicetree/bindings/bus/allwinner,sun50i-a64-de2.yaml
index 0503651cd214..863a287ebc7e 100644
--- a/Documentation/devicetree/bindings/bus/allwinner,sun50i-a64-de2.yaml
+++ b/Documentation/devicetree/bindings/bus/allwinner,sun50i-a64-de2.yaml
@@ -34,7 +34,7 @@ properties:
     description:
       The SRAM that needs to be claimed to access the display engine
       bus.
-    $ref: /schemas/types.yaml#definitions/phandle-array
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     maxItems: 1
 
   ranges: true
diff --git a/Documentation/devicetree/bindings/bus/baikal,bt1-axi.yaml b/Documentation/devicetree/bindings/bus/baikal,bt1-axi.yaml
index 0bee4694578a..4ac78b44e45e 100644
--- a/Documentation/devicetree/bindings/bus/baikal,bt1-axi.yaml
+++ b/Documentation/devicetree/bindings/bus/baikal,bt1-axi.yaml
@@ -46,7 +46,7 @@ properties:
     const: 1
 
   syscon:
-    $ref: /schemas/types.yaml#definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle
     description: Phandle to the Baikal-T1 System Controller DT node
 
   interrupts:
diff --git a/Documentation/devicetree/bindings/connector/usb-connector.yaml b/Documentation/devicetree/bindings/connector/usb-connector.yaml
index a84464b3e1f2..4286ed767a0a 100644
--- a/Documentation/devicetree/bindings/connector/usb-connector.yaml
+++ b/Documentation/devicetree/bindings/connector/usb-connector.yaml
@@ -37,7 +37,7 @@ properties:
     description: Size of the connector, should be specified in case of
       non-fullsize 'usb-a-connector' or 'usb-b-connector' compatible
       connectors.
-    $ref: /schemas/types.yaml#definitions/string
+    $ref: /schemas/types.yaml#/definitions/string
 
     enum:
       - mini
@@ -67,7 +67,7 @@ properties:
   power-role:
     description: Determines the power role that the Type C connector will
       support. "dual" refers to Dual Role Port (DRP).
-    $ref: /schemas/types.yaml#definitions/string
+    $ref: /schemas/types.yaml#/definitions/string
 
     enum:
       - source
@@ -76,7 +76,7 @@ properties:
 
   try-power-role:
     description: Preferred power role.
-    $ref: /schemas/types.yaml#definitions/string
+    $ref: /schemas/types.yaml#/definitions/string
 
     enum:
       - source
@@ -86,7 +86,7 @@ properties:
   data-role:
     description: Data role if Type C connector supports USB data. "dual" refers
       Dual Role Device (DRD).
-    $ref: /schemas/types.yaml#definitions/string
+    $ref: /schemas/types.yaml#/definitions/string
 
     enum:
       - host
@@ -105,7 +105,7 @@ properties:
         Type-C Cable and Connector specification, when Power Delivery is not
         supported.
     allOf:
-      - $ref: /schemas/types.yaml#definitions/string
+      - $ref: /schemas/types.yaml#/definitions/string
     enum:
       - default
       - 1.5A
diff --git a/Documentation/devicetree/bindings/dma/dma-common.yaml b/Documentation/devicetree/bindings/dma/dma-common.yaml
index 307b499e8968..ad06d36af208 100644
--- a/Documentation/devicetree/bindings/dma/dma-common.yaml
+++ b/Documentation/devicetree/bindings/dma/dma-common.yaml
@@ -38,12 +38,12 @@ properties:
       maxItems: 255
 
   dma-channels:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description:
       Number of DMA channels supported by the controller.
 
   dma-requests:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description:
       Number of DMA request signals supported by the controller.
 
diff --git a/Documentation/devicetree/bindings/dma/dma-router.yaml b/Documentation/devicetree/bindings/dma/dma-router.yaml
index 4cee5667b8a8..e72748496fd9 100644
--- a/Documentation/devicetree/bindings/dma/dma-router.yaml
+++ b/Documentation/devicetree/bindings/dma/dma-router.yaml
@@ -23,7 +23,7 @@ properties:
     pattern: "^dma-router(@.*)?$"
 
   dma-masters:
-    $ref: /schemas/types.yaml#definitions/phandle-array
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     description:
       Array of phandles to the DMA controllers the router can direct
       the signal to.
diff --git a/Documentation/devicetree/bindings/dma/ingenic,dma.yaml b/Documentation/devicetree/bindings/dma/ingenic,dma.yaml
index 00f19b3cac31..6a2043721b95 100644
--- a/Documentation/devicetree/bindings/dma/ingenic,dma.yaml
+++ b/Documentation/devicetree/bindings/dma/ingenic,dma.yaml
@@ -48,7 +48,7 @@ properties:
         ingenic,reserved-channels property.
 
   ingenic,reserved-channels:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: >
       Bitmask of channels to reserve for devices that need a specific
       channel. These channels will only be assigned when explicitely
diff --git a/Documentation/devicetree/bindings/dma/snps,dma-spear1340.yaml b/Documentation/devicetree/bindings/dma/snps,dma-spear1340.yaml
index ef1d6879c158..6b35089ac017 100644
--- a/Documentation/devicetree/bindings/dma/snps,dma-spear1340.yaml
+++ b/Documentation/devicetree/bindings/dma/snps,dma-spear1340.yaml
@@ -54,7 +54,7 @@ properties:
     maximum: 16
 
   dma-masters:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
       Number of DMA masters supported by the controller. In case if
       not specified the driver will try to auto-detect this and
@@ -63,7 +63,7 @@ properties:
     maximum: 4
 
   chan_allocation_order:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
       DMA channels allocation order specifier. Zero means ascending order
       (first free allocated), while one - descending (last free allocated).
@@ -71,7 +71,7 @@ properties:
     enum: [0, 1]
 
   chan_priority:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
       DMA channels priority order. Zero means ascending channels priority
       so the very first channel has the highest priority. While 1 means
@@ -80,7 +80,7 @@ properties:
     enum: [0, 1]
 
   block_size:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: Maximum block size supported by the DMA controller.
     enum: [3, 7, 15, 31, 63, 127, 255, 511, 1023, 2047, 4095]
 
@@ -139,7 +139,7 @@ properties:
         default: 256
 
   snps,dma-protection-control:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
       Bits one-to-one passed to the AHB HPROT[3:1] bus. Each bit setting
       indicates the following features: bit 0 - privileged mode,
diff --git a/Documentation/devicetree/bindings/eeprom/at24.yaml b/Documentation/devicetree/bindings/eeprom/at24.yaml
index 6edfa705b486..d5117c638b75 100644
--- a/Documentation/devicetree/bindings/eeprom/at24.yaml
+++ b/Documentation/devicetree/bindings/eeprom/at24.yaml
@@ -131,7 +131,7 @@ properties:
     default: 1
 
   read-only:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       Disables writes to the eeprom.
 
@@ -141,7 +141,7 @@ properties:
       Total eeprom size in bytes.
 
   no-read-rollover:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       Indicates that the multi-address eeprom does not automatically roll
       over reads to the next slave address. Please consult the manual of
diff --git a/Documentation/devicetree/bindings/eeprom/at25.yaml b/Documentation/devicetree/bindings/eeprom/at25.yaml
index 744973637678..121a601db22e 100644
--- a/Documentation/devicetree/bindings/eeprom/at25.yaml
+++ b/Documentation/devicetree/bindings/eeprom/at25.yaml
@@ -45,13 +45,13 @@ properties:
   spi-max-frequency: true
 
   pagesize:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     enum: [1, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072]
     description:
       Size of the eeprom page.
 
   size:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description:
       Total eeprom size in bytes.
 
diff --git a/Documentation/devicetree/bindings/hwmon/moortec,mr75203.yaml b/Documentation/devicetree/bindings/hwmon/moortec,mr75203.yaml
index 6f3e3c01f717..b79f069a04c2 100644
--- a/Documentation/devicetree/bindings/hwmon/moortec,mr75203.yaml
+++ b/Documentation/devicetree/bindings/hwmon/moortec,mr75203.yaml
@@ -32,7 +32,7 @@ properties:
       PVT controller has 5 VM (voltage monitor) sensors.
       vm-map defines CPU core to VM instance mapping. A
       value of 0xff means that VM sensor is unused.
-    $ref: /schemas/types.yaml#definitions/uint8-array
+    $ref: /schemas/types.yaml#/definitions/uint8-array
     maxItems: 5
 
   clocks:
diff --git a/Documentation/devicetree/bindings/hwmon/sensirion,shtc1.yaml b/Documentation/devicetree/bindings/hwmon/sensirion,shtc1.yaml
index c523a1beb2b7..7d49478d9668 100644
--- a/Documentation/devicetree/bindings/hwmon/sensirion,shtc1.yaml
+++ b/Documentation/devicetree/bindings/hwmon/sensirion,shtc1.yaml
@@ -29,12 +29,12 @@ properties:
     const: 0x70
 
   sensirion,blocking-io:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       If set, the driver hold the i2c bus until measurement is finished.
 
   sensirion,low-precision:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       If set, the sensor aquire data with low precision (not recommended).
       The driver aquire data with high precision by default.
diff --git a/Documentation/devicetree/bindings/hwmon/ti,tmp513.yaml b/Documentation/devicetree/bindings/hwmon/ti,tmp513.yaml
index c17e5d3ee3f1..8020d739a078 100644
--- a/Documentation/devicetree/bindings/hwmon/ti,tmp513.yaml
+++ b/Documentation/devicetree/bindings/hwmon/ti,tmp513.yaml
@@ -61,7 +61,7 @@ properties:
       Array of three(TMP513) or two(TMP512) n-Factor value for each remote
       temperature channel.
       See datasheet Table 11 for n-Factor range list and value interpretation.
-    $ref: /schemas/types.yaml#definitions/uint32-array
+    $ref: /schemas/types.yaml#/definitions/uint32-array
     minItems: 2
     maxItems: 3
     items:
diff --git a/Documentation/devicetree/bindings/iio/light/upisemi,us5182.yaml b/Documentation/devicetree/bindings/iio/light/upisemi,us5182.yaml
index 4a9b2827cf7b..de5882cb3360 100644
--- a/Documentation/devicetree/bindings/iio/light/upisemi,us5182.yaml
+++ b/Documentation/devicetree/bindings/iio/light/upisemi,us5182.yaml
@@ -45,7 +45,7 @@ properties:
     default: 0x16
 
   upisemi,continuous:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description: |
       This chip has two power modes: one-shot (chip takes one measurement and
       then shuts itself down) and continuous (chip takes continuous
diff --git a/Documentation/devicetree/bindings/iio/proximity/semtech,sx9310.yaml b/Documentation/devicetree/bindings/iio/proximity/semtech,sx9310.yaml
index ccfb163f3d34..5de0bb2180e6 100644
--- a/Documentation/devicetree/bindings/iio/proximity/semtech,sx9310.yaml
+++ b/Documentation/devicetree/bindings/iio/proximity/semtech,sx9310.yaml
@@ -72,7 +72,7 @@ properties:
       - finest
 
   semtech,startup-sensor:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     enum: [0, 1, 2, 3]
     default: 0
     description:
@@ -81,7 +81,7 @@ properties:
       compensation.
 
   semtech,proxraw-strength:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     enum: [0, 2, 4, 8]
     default: 2
     description:
@@ -89,7 +89,7 @@ properties:
       represent 1-1/N.
 
   semtech,avg-pos-strength:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     enum: [0, 16, 64, 128, 256, 512, 1024, 4294967295]
     default: 16
     description:
diff --git a/Documentation/devicetree/bindings/input/gpio-keys.yaml b/Documentation/devicetree/bindings/input/gpio-keys.yaml
index 6966ab009fa3..060a309ff8e7 100644
--- a/Documentation/devicetree/bindings/input/gpio-keys.yaml
+++ b/Documentation/devicetree/bindings/input/gpio-keys.yaml
@@ -34,13 +34,13 @@ patternProperties:
 
         linux,code:
           description: Key / Axis code to emit.
-          $ref: /schemas/types.yaml#definitions/uint32
+          $ref: /schemas/types.yaml#/definitions/uint32
 
         linux,input-type:
           description:
             Specify event type this button/key generates. If not specified defaults to
             <1> == EV_KEY.
-          $ref: /schemas/types.yaml#definitions/uint32
+          $ref: /schemas/types.yaml#/definitions/uint32
 
           default: 1
 
@@ -56,12 +56,12 @@ patternProperties:
 
             linux,input-value = <0xffffffff>; /* -1 */
 
-          $ref: /schemas/types.yaml#definitions/uint32
+          $ref: /schemas/types.yaml#/definitions/uint32
 
         debounce-interval:
           description:
             Debouncing interval time in milliseconds. If not specified defaults to 5.
-          $ref: /schemas/types.yaml#definitions/uint32
+          $ref: /schemas/types.yaml#/definitions/uint32
 
           default: 5
 
@@ -79,7 +79,7 @@ patternProperties:
               EV_ACT_ANY        - both asserted and deasserted
               EV_ACT_ASSERTED   - asserted
               EV_ACT_DEASSERTED - deasserted
-          $ref: /schemas/types.yaml#definitions/uint32
+          $ref: /schemas/types.yaml#/definitions/uint32
           enum: [0, 1, 2]
 
         linux,can-disable:
@@ -118,7 +118,7 @@ then:
     poll-interval:
       description:
         Poll interval time in milliseconds
-      $ref: /schemas/types.yaml#definitions/uint32
+      $ref: /schemas/types.yaml#/definitions/uint32
 
   required:
     - poll-interval
diff --git a/Documentation/devicetree/bindings/interrupt-controller/mti,gic.yaml b/Documentation/devicetree/bindings/interrupt-controller/mti,gic.yaml
index 039e08af98bb..91bb3c2307a7 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/mti,gic.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/mti,gic.yaml
@@ -42,7 +42,7 @@ properties:
       Specifies the list of CPU interrupt vectors to which the GIC may not
       route interrupts. This property is ignored if the CPU is started in EIC
       mode.
-    $ref: /schemas/types.yaml#definitions/uint32-array
+    $ref: /schemas/types.yaml#/definitions/uint32-array
     minItems: 1
     maxItems: 6
     uniqueItems: true
@@ -56,7 +56,7 @@ properties:
       It accepts two values: the 1st is the starting interrupt and the 2nd is
       the size of the reserved range. If not specified, the driver will
       allocate the last (2 * number of VPEs in the system).
-    $ref: /schemas/types.yaml#definitions/uint32-array
+    $ref: /schemas/types.yaml#/definitions/uint32-array
     items:
       - minimum: 0
         maximum: 254
diff --git a/Documentation/devicetree/bindings/interrupt-controller/ti,pruss-intc.yaml b/Documentation/devicetree/bindings/interrupt-controller/ti,pruss-intc.yaml
index 1c4c009dedd0..c2ce215501a5 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/ti,pruss-intc.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/ti,pruss-intc.yaml
@@ -80,7 +80,7 @@ properties:
       mapping is provided.
 
   ti,irqs-reserved:
-    $ref: /schemas/types.yaml#definitions/uint8
+    $ref: /schemas/types.yaml#/definitions/uint8
     description: |
       Bitmask of host interrupts between 0 and 7 (corresponding to PRUSS INTC
       output interrupts 2 through 9) that are not connected to the Arm interrupt
diff --git a/Documentation/devicetree/bindings/interrupt-controller/ti,sci-inta.yaml b/Documentation/devicetree/bindings/interrupt-controller/ti,sci-inta.yaml
index b5af12011499..3d89668573e8 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/ti,sci-inta.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/ti,sci-inta.yaml
@@ -76,7 +76,7 @@ properties:
             "limit" specifies the limit for translation
 
   ti,unmapped-event-sources:
-    $ref: /schemas/types.yaml#definitions/phandle-array
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     description:
       Array of phandles to DMA controllers where the unmapped events originate.
 
diff --git a/Documentation/devicetree/bindings/leds/backlight/common.yaml b/Documentation/devicetree/bindings/leds/backlight/common.yaml
index bc817f77d2b1..702ba350d869 100644
--- a/Documentation/devicetree/bindings/leds/backlight/common.yaml
+++ b/Documentation/devicetree/bindings/leds/backlight/common.yaml
@@ -22,7 +22,7 @@ properties:
       The default brightness that should be applied to the LED by the operating
       system on start-up. The brightness should not exceed the brightness the
       LED can provide.
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
 
   max-brightness:
     description:
@@ -31,6 +31,6 @@ properties:
       on the brightness apart from what the driver says, as it could happen
       that a LED can be made so bright that it gets damaged or causes damage
       due to restrictions in a specific system, such as mounting conditions.
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
 
 additionalProperties: true
diff --git a/Documentation/devicetree/bindings/leds/common.yaml b/Documentation/devicetree/bindings/leds/common.yaml
index f1211e7045f1..b1f363747a62 100644
--- a/Documentation/devicetree/bindings/leds/common.yaml
+++ b/Documentation/devicetree/bindings/leds/common.yaml
@@ -27,21 +27,21 @@ properties:
       List of device current outputs the LED is connected to. The outputs are
       identified by the numbers that must be defined in the LED device binding
       documentation.
-    $ref: /schemas/types.yaml#definitions/uint32-array
+    $ref: /schemas/types.yaml#/definitions/uint32-array
 
   function:
     description:
       LED function. Use one of the LED_FUNCTION_* prefixed definitions
       from the header include/dt-bindings/leds/common.h. If there is no
       matching LED_FUNCTION available, add a new one.
-    $ref: /schemas/types.yaml#definitions/string
+    $ref: /schemas/types.yaml#/definitions/string
 
   color:
     description:
       Color of the LED. Use one of the LED_COLOR_ID_* prefixed definitions from
       the header include/dt-bindings/leds/common.h. If there is no matching
       LED_COLOR_ID available, add a new one.
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     minimum: 0
     maximum: 9
 
@@ -49,7 +49,7 @@ properties:
     description:
       Integer to be used when more than one instance of the same function is
       needed, differing only with an ordinal number.
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
 
   label:
     description:
@@ -66,7 +66,7 @@ properties:
       produced where the LED momentarily turns off (or on). The "keep" setting
       will keep the LED at whatever its current state is, without producing a
       glitch.
-    $ref: /schemas/types.yaml#definitions/string
+    $ref: /schemas/types.yaml#/definitions/string
     enum:
       - on
       - off
@@ -77,7 +77,7 @@ properties:
     description:
       This parameter, if present, is a string defining the trigger assigned to
       the LED.
-    $ref: /schemas/types.yaml#definitions/string
+    $ref: /schemas/types.yaml#/definitions/string
 
     enum:
         # LED will act as a back-light, controlled by the framebuffer system
@@ -109,7 +109,7 @@ properties:
           brightness and duration (in ms).  The exact format is
           described in:
           Documentation/devicetree/bindings/leds/leds-trigger-pattern.txt
-    $ref: /schemas/types.yaml#definitions/uint32-matrix
+    $ref: /schemas/types.yaml#/definitions/uint32-matrix
     items:
       minItems: 2
       maxItems: 2
@@ -143,7 +143,7 @@ properties:
       the device tree and be referenced by a phandle and a set of phandle
       arguments. A length of arguments should be specified by the
       #trigger-source-cells property in the source node.
-    $ref: /schemas/types.yaml#definitions/phandle-array
+    $ref: /schemas/types.yaml#/definitions/phandle-array
 
   # Required properties for flash LED child nodes:
   flash-max-microamp:
diff --git a/Documentation/devicetree/bindings/leds/leds-lp55xx.yaml b/Documentation/devicetree/bindings/leds/leds-lp55xx.yaml
index 58e974793a79..f552cd143d5b 100644
--- a/Documentation/devicetree/bindings/leds/leds-lp55xx.yaml
+++ b/Documentation/devicetree/bindings/leds/leds-lp55xx.yaml
@@ -35,7 +35,7 @@ properties:
     description: I2C slave address
 
   clock-mode:
-    $ref: /schemas/types.yaml#definitions/uint8
+    $ref: /schemas/types.yaml#/definitions/uint8
     description: |
       Input clock mode
     enum:
@@ -49,7 +49,7 @@ properties:
       GPIO attached to the chip's enable pin
 
   pwr-sel:
-    $ref: /schemas/types.yaml#definitions/uint8
+    $ref: /schemas/types.yaml#/definitions/uint8
     description: |
       LP8501 specific property. Power selection for output channels.
     enum:
@@ -70,14 +70,14 @@ patternProperties:
     $ref: common.yaml#
     properties:
       led-cur:
-        $ref: /schemas/types.yaml#definitions/uint8
+        $ref: /schemas/types.yaml#/definitions/uint8
         description: |
           Current setting at each LED channel (mA x10, 0 if LED is not connected)
         minimum: 0
         maximum: 255
 
       max-cur:
-        $ref: /schemas/types.yaml#definitions/uint8
+        $ref: /schemas/types.yaml#/definitions/uint8
         description: Maximun current at each LED channel.
 
       reg:
@@ -97,7 +97,7 @@ patternProperties:
           - 8 # LED output D9
 
       chan-name:
-        $ref: /schemas/types.yaml#definitions/string
+        $ref: /schemas/types.yaml#/definitions/string
         description: name of channel
 
 required:
diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
index c7c9ad4e3f9f..7f2578d48e3f 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
@@ -38,7 +38,7 @@ properties:
     const: stmmaceth
 
   syscon:
-    $ref: /schemas/types.yaml#definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle
     description:
       Phandle to the device containing the EMAC or GMAC clock
       register
@@ -114,7 +114,7 @@ allOf:
     then:
       properties:
         allwinner,leds-active-low:
-          $ref: /schemas/types.yaml#definitions/flag
+          $ref: /schemas/types.yaml#/definitions/flag
           description:
             EPHY LEDs are active low.
 
@@ -126,7 +126,7 @@ allOf:
               const: allwinner,sun8i-h3-mdio-mux
 
             mdio-parent-bus:
-              $ref: /schemas/types.yaml#definitions/phandle
+              $ref: /schemas/types.yaml#/definitions/phandle
               description:
                 Phandle to EMAC MDIO.
 
diff --git a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
index 6b057b117aa0..1f133f4a2924 100644
--- a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
@@ -60,7 +60,7 @@ allOf:
             - const: timing-adjustment
 
         amlogic,tx-delay-ns:
-          $ref: /schemas/types.yaml#definitions/uint32
+          $ref: /schemas/types.yaml#/definitions/uint32
           description:
             The internal RGMII TX clock delay (provided by this driver) in
             nanoseconds. Allowed values are 0ns, 2ns, 4ns, 6ns.
diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 8e044631bcf7..8a3494db4d8d 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -54,7 +54,7 @@ patternProperties:
             description:
               Describes the label associated with this port, which will become
               the netdev name
-            $ref: /schemas/types.yaml#definitions/string
+            $ref: /schemas/types.yaml#/definitions/string
 
           link:
             description:
@@ -62,13 +62,13 @@ patternProperties:
               port is used as the outgoing port towards the phandle ports. The
               full routing information must be given, not just the one hop
               routes to neighbouring switches
-            $ref: /schemas/types.yaml#definitions/phandle-array
+            $ref: /schemas/types.yaml#/definitions/phandle-array
 
           ethernet:
             description:
               Should be a phandle to a valid Ethernet device node.  This host
               device is what the switch port is connected to
-            $ref: /schemas/types.yaml#definitions/phandle
+            $ref: /schemas/types.yaml#/definitions/phandle
 
           phy-handle: true
 
diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index cc93063a8f39..0965f6515f9e 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -16,7 +16,7 @@ properties:
   local-mac-address:
     description:
       Specifies the MAC address that was assigned to the network device.
-    $ref: /schemas/types.yaml#definitions/uint8-array
+    $ref: /schemas/types.yaml#/definitions/uint8-array
     items:
       - minItems: 6
         maxItems: 6
@@ -27,20 +27,20 @@ properties:
       program; should be used in cases where the MAC address assigned
       to the device by the boot program is different from the
       local-mac-address property.
-    $ref: /schemas/types.yaml#definitions/uint8-array
+    $ref: /schemas/types.yaml#/definitions/uint8-array
     items:
       - minItems: 6
         maxItems: 6
 
   max-frame-size:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description:
       Maximum transfer unit (IEEE defined MTU), rather than the
       maximum frame size (there\'s contradiction in the Devicetree
       Specification).
 
   max-speed:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description:
       Specifies maximum speed in Mbit/s supported by the device.
 
@@ -101,7 +101,7 @@ properties:
     $ref: "#/properties/phy-connection-type"
 
   phy-handle:
-    $ref: /schemas/types.yaml#definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle
     description:
       Specifies a reference to a node representing a PHY device.
 
@@ -114,7 +114,7 @@ properties:
     deprecated: true
 
   rx-fifo-depth:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description:
       The size of the controller\'s receive fifo in bytes. This is used
       for components that can have configurable receive fifo sizes,
@@ -129,12 +129,12 @@ properties:
       If this property is present then the MAC applies the RX delay.
 
   sfp:
-    $ref: /schemas/types.yaml#definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle
     description:
       Specifies a reference to a node representing a SFP cage.
 
   tx-fifo-depth:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description:
       The size of the controller\'s transmit fifo in bytes. This
       is used for components that can have configurable fifo sizes.
@@ -150,7 +150,7 @@ properties:
     description:
       Specifies the PHY management type. If auto is set and fixed-link
       is not specified, it uses MDIO for management.
-    $ref: /schemas/types.yaml#definitions/string
+    $ref: /schemas/types.yaml#/definitions/string
     default: auto
     enum:
       - auto
@@ -198,17 +198,17 @@ properties:
             speed:
               description:
                 Link speed.
-              $ref: /schemas/types.yaml#definitions/uint32
+              $ref: /schemas/types.yaml#/definitions/uint32
               enum: [10, 100, 1000]
 
             full-duplex:
-              $ref: /schemas/types.yaml#definitions/flag
+              $ref: /schemas/types.yaml#/definitions/flag
               description:
                 Indicates that full-duplex is used. When absent, half
                 duplex is assumed.
 
             asym-pause:
-              $ref: /schemas/types.yaml#definitions/flag
+              $ref: /schemas/types.yaml#/definitions/flag
               description:
                 Indicates that asym_pause should be enabled.
 
diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 6dd72faebd89..2766fe45bb98 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -78,57 +78,57 @@ properties:
       Maximum PHY supported speed in Mbits / seconds.
 
   broken-turn-around:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       If set, indicates the PHY device does not correctly release
       the turn around line low at end of the control phase of the
       MDIO transaction.
 
   enet-phy-lane-swap:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       If set, indicates the PHY will swap the TX/RX lanes to
       compensate for the board being designed with the lanes
       swapped.
 
   eee-broken-100tx:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       Mark the corresponding energy efficient ethernet mode as
       broken and request the ethernet to stop advertising it.
 
   eee-broken-1000t:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       Mark the corresponding energy efficient ethernet mode as
       broken and request the ethernet to stop advertising it.
 
   eee-broken-10gt:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       Mark the corresponding energy efficient ethernet mode as
       broken and request the ethernet to stop advertising it.
 
   eee-broken-1000kx:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       Mark the corresponding energy efficient ethernet mode as
       broken and request the ethernet to stop advertising it.
 
   eee-broken-10gkx4:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       Mark the corresponding energy efficient ethernet mode as
       broken and request the ethernet to stop advertising it.
 
   eee-broken-10gkr:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       Mark the corresponding energy efficient ethernet mode as
       broken and request the ethernet to stop advertising it.
 
   phy-is-integrated:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       If set, indicates that the PHY is integrated into the same
       physical package as the Ethernet MAC. If needed, muxers
@@ -158,7 +158,7 @@ properties:
       this property is missing the delay will be skipped.
 
   sfp:
-    $ref: /schemas/types.yaml#definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle
     description:
       Specifies a reference to a node representing a SFP cage.
 
diff --git a/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml b/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
index 2159b7d1f537..7f620a71a972 100644
--- a/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
@@ -31,7 +31,7 @@ properties:
   phy-mode: true
 
   pcs-handle:
-    $ref: /schemas/types.yaml#definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle
     description:
       A reference to a node representing a PCS PHY device found on
       the internal MDIO bus.
diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
index e811e0fd851c..08e15fb1584f 100644
--- a/Documentation/devicetree/bindings/net/mdio.yaml
+++ b/Documentation/devicetree/bindings/net/mdio.yaml
@@ -70,7 +70,7 @@ patternProperties:
           The ID number for the device.
 
       broken-turn-around:
-        $ref: /schemas/types.yaml#definitions/flag
+        $ref: /schemas/types.yaml#/definitions/flag
         description:
           If set, indicates the MDIO device does not correctly release
           the turn around line low at end of the control phase of the
diff --git a/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml b/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
index 0bbd598704e9..e6a5ff208253 100644
--- a/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
@@ -42,7 +42,7 @@ properties:
       - const: trans
 
   mediatek,pericfg:
-    $ref: /schemas/types.yaml#definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle
     description:
       Phandle to the device containing the PERICFG register range. This is used
       to control the MII mode.
diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index 4d8464b2676d..d0cbbcf1b0e5 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -114,7 +114,7 @@ properties:
       validating firwmare used by the GSI.
 
   modem-remoteproc:
-    $ref: /schemas/types.yaml#definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle
     description:
       This defines the phandle to the remoteproc node representing
       the modem subsystem.  This is requied so the IPA driver can
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 11a6fdb657c9..b2f6083f556a 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -126,7 +126,7 @@ properties:
       in a different mode than the PHY in order to function.
 
   snps,axi-config:
-    $ref: /schemas/types.yaml#definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle
     description:
       AXI BUS Mode parameters. Phandle to a node that can contain the
       following properties
@@ -141,7 +141,7 @@ properties:
         * snps,rb, rebuild INCRx Burst
 
   snps,mtl-rx-config:
-    $ref: /schemas/types.yaml#definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle
     description:
       Multiple RX Queues parameters. Phandle to a node that can
       contain the following properties
@@ -164,7 +164,7 @@ properties:
           * snps,priority, RX queue priority (Range 0x0 to 0xF)
 
   snps,mtl-tx-config:
-    $ref: /schemas/types.yaml#definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle
     description:
       Multiple TX Queues parameters. Phandle to a node that can
       contain the following properties
@@ -198,7 +198,7 @@ properties:
 
   snps,reset-active-low:
     deprecated: true
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       Indicates that the PHY Reset is active low
 
@@ -208,55 +208,55 @@ properties:
       Triplet of delays. The 1st cell is reset pre-delay in micro
       seconds. The 2nd cell is reset pulse in micro seconds. The 3rd
       cell is reset post-delay in micro seconds.
-    $ref: /schemas/types.yaml#definitions/uint32-array
+    $ref: /schemas/types.yaml#/definitions/uint32-array
     minItems: 3
     maxItems: 3
 
   snps,aal:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       Use Address-Aligned Beats
 
   snps,fixed-burst:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       Program the DMA to use the fixed burst mode
 
   snps,mixed-burst:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       Program the DMA to use the mixed burst mode
 
   snps,force_thresh_dma_mode:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       Force DMA to use the threshold mode for both tx and rx
 
   snps,force_sf_dma_mode:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       Force DMA to use the Store and Forward mode for both tx and
       rx. This flag is ignored if force_thresh_dma_mode is set.
 
   snps,en-tx-lpi-clockgating:
-    $ref: /schemas/types.yaml#definitions/flag
+    $ref: /schemas/types.yaml#/definitions/flag
     description:
       Enable gating of the MAC TX clock during TX low-power mode
 
   snps,multicast-filter-bins:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description:
       Number of multicast filter hash bins supported by this device
       instance
 
   snps,perfect-filter-entries:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description:
       Number of perfect filter entries supported by this device
       instance
 
   snps,ps-speed:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description:
       Port selection speed that can be passed to the core when PCS
       is supported. For example, this is used in case of SGMII and
@@ -307,25 +307,25 @@ allOf:
         snps,pbl:
           description:
             Programmable Burst Length (tx and rx)
-          $ref: /schemas/types.yaml#definitions/uint32
+          $ref: /schemas/types.yaml#/definitions/uint32
           enum: [2, 4, 8]
 
         snps,txpbl:
           description:
             Tx Programmable Burst Length. If set, DMA tx will use this
             value rather than snps,pbl.
-          $ref: /schemas/types.yaml#definitions/uint32
+          $ref: /schemas/types.yaml#/definitions/uint32
           enum: [2, 4, 8]
 
         snps,rxpbl:
           description:
             Rx Programmable Burst Length. If set, DMA rx will use this
             value rather than snps,pbl.
-          $ref: /schemas/types.yaml#definitions/uint32
+          $ref: /schemas/types.yaml#/definitions/uint32
           enum: [2, 4, 8]
 
         snps,no-pbl-x8:
-          $ref: /schemas/types.yaml#definitions/flag
+          $ref: /schemas/types.yaml#/definitions/flag
           description:
             Don\'t multiply the pbl/txpbl/rxpbl values by 8. For core
             rev < 3.50, don\'t multiply the values by 4.
@@ -351,7 +351,7 @@ allOf:
     then:
       properties:
         snps,tso:
-          $ref: /schemas/types.yaml#definitions/flag
+          $ref: /schemas/types.yaml#/definitions/flag
           description:
             Enables the TSO feature otherwise it will be managed by
             MAC HW capability register.
diff --git a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
index cbacc04fc9e6..8a03a24a2019 100644
--- a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
+++ b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
@@ -64,7 +64,7 @@ properties:
       - const: ether    # for others
 
   socionext,syscon-phy-mode:
-    $ref: /schemas/types.yaml#definitions/phandle-array
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     description:
       A phandle to syscon with one argument that configures phy mode.
       The argument is the ID of MAC instance.
diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
index dadeb8f811c0..07a00f53adbf 100644
--- a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
+++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
@@ -70,7 +70,7 @@ properties:
   pinctrl-names: true
 
   syscon:
-    $ref: /schemas/types.yaml#definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle
     description:
       Phandle to the system control device node which provides access to
       efuse IO range with MAC addresses
diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.yaml b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
index 4050a3608658..047d757e8d82 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83867.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
@@ -47,31 +47,31 @@ properties:
         takes precedence.
 
   tx-fifo-depth:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
        Transmitt FIFO depth see dt-bindings/net/ti-dp83867.h for values
 
   rx-fifo-depth:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
        Receive FIFO depth see dt-bindings/net/ti-dp83867.h for values
 
   ti,clk-output-sel:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
       Muxing option for CLK_OUT pin.  See dt-bindings/net/ti-dp83867.h
       for applicable values. The CLK_OUT pin can also be disabled by this
       property.  When omitted, the PHY's default will be left as is.
 
   ti,rx-internal-delay:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
       RGMII Receive Clock Delay - see dt-bindings/net/ti-dp83867.h
       for applicable values. Required only if interface type is
       PHY_INTERFACE_MODE_RGMII_ID or PHY_INTERFACE_MODE_RGMII_RXID.
 
   ti,tx-internal-delay:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
       RGMII Transmit Clock Delay - see dt-bindings/net/ti-dp83867.h
       for applicable values. Required only if interface type is
@@ -101,7 +101,7 @@ properties:
 
   ti,fifo-depth:
     deprecated: true
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
       Transmitt FIFO depth- see dt-bindings/net/ti-dp83867.h for applicable
       values.
diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
index c3235f08e326..70a1209cb13b 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83869.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
@@ -44,22 +44,22 @@ properties:
        to a maximum value (70 ohms).
 
   tx-fifo-depth:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
        Transmitt FIFO depth see dt-bindings/net/ti-dp83869.h for values
 
   rx-fifo-depth:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
        Receive FIFO depth see dt-bindings/net/ti-dp83869.h for values
 
   ti,clk-output-sel:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
        Muxing option for CLK_OUT pin see dt-bindings/net/ti-dp83869.h for values.
 
   ti,op-mode:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
        Operational mode for the PHY.  If this is not set then the operational
        mode is set by the straps. see dt-bindings/net/ti-dp83869.h for values
diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 227270cbf892..c47b58f3e3f6 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -119,12 +119,12 @@ properties:
             description: label associated with this port
 
           ti,mac-only:
-            $ref: /schemas/types.yaml#definitions/flag
+            $ref: /schemas/types.yaml#/definitions/flag
             description:
               Specifies the port works in mac-only mode.
 
           ti,syscon-efuse:
-            $ref: /schemas/types.yaml#definitions/phandle-array
+            $ref: /schemas/types.yaml#/definitions/phandle-array
             description:
               Phandle to the system control device node which provides access
               to efuse IO range with MAC addresses
diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
index 6af999191559..85c2f699d602 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
@@ -136,7 +136,7 @@ properties:
       - const: tcl2host-status-ring
 
   qcom,rproc:
-    $ref: /schemas/types.yaml#definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle
     description:
       DT entry of q6v5-wcss remoteproc driver.
       Phandle to a node that can contain the following properties
diff --git a/Documentation/devicetree/bindings/phy/ti,omap-usb2.yaml b/Documentation/devicetree/bindings/phy/ti,omap-usb2.yaml
index 83d5d0aceb04..cbbf5e8b1197 100644
--- a/Documentation/devicetree/bindings/phy/ti,omap-usb2.yaml
+++ b/Documentation/devicetree/bindings/phy/ti,omap-usb2.yaml
@@ -44,13 +44,13 @@ properties:
       - const: refclk
 
   syscon-phy-power:
-    $ref: /schemas/types.yaml#definitions/phandle-array
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     description:
       phandle/offset pair. Phandle to the system control module and
       register offset to power on/off the PHY.
 
   ctrl-module:
-    $ref: /schemas/types.yaml#definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle
     description:
       (deprecated) phandle of the control module used by PHY driver
       to power on the PHY. Use syscon-phy-power instead.
diff --git a/Documentation/devicetree/bindings/power/mediatek,power-controller.yaml b/Documentation/devicetree/bindings/power/mediatek,power-controller.yaml
index fd12bafe3548..d14cb9bac849 100644
--- a/Documentation/devicetree/bindings/power/mediatek,power-controller.yaml
+++ b/Documentation/devicetree/bindings/power/mediatek,power-controller.yaml
@@ -83,11 +83,11 @@ patternProperties:
           SUSBSYS clocks.
 
       mediatek,infracfg:
-        $ref: /schemas/types.yaml#definitions/phandle
+        $ref: /schemas/types.yaml#/definitions/phandle
         description: phandle to the device containing the INFRACFG register range.
 
       mediatek,smi:
-        $ref: /schemas/types.yaml#definitions/phandle
+        $ref: /schemas/types.yaml#/definitions/phandle
         description: phandle to the device containing the SMI register range.
 
     patternProperties:
@@ -131,11 +131,11 @@ patternProperties:
               SUSBSYS clocks.
 
           mediatek,infracfg:
-            $ref: /schemas/types.yaml#definitions/phandle
+            $ref: /schemas/types.yaml#/definitions/phandle
             description: phandle to the device containing the INFRACFG register range.
 
           mediatek,smi:
-            $ref: /schemas/types.yaml#definitions/phandle
+            $ref: /schemas/types.yaml#/definitions/phandle
             description: phandle to the device containing the SMI register range.
 
         patternProperties:
@@ -179,11 +179,11 @@ patternProperties:
                   SUSBSYS clocks.
 
               mediatek,infracfg:
-                $ref: /schemas/types.yaml#definitions/phandle
+                $ref: /schemas/types.yaml#/definitions/phandle
                 description: phandle to the device containing the INFRACFG register range.
 
               mediatek,smi:
-                $ref: /schemas/types.yaml#definitions/phandle
+                $ref: /schemas/types.yaml#/definitions/phandle
                 description: phandle to the device containing the SMI register range.
 
             required:
diff --git a/Documentation/devicetree/bindings/power/supply/cw2015_battery.yaml b/Documentation/devicetree/bindings/power/supply/cw2015_battery.yaml
index ee92e6a076ac..5fcdf5801536 100644
--- a/Documentation/devicetree/bindings/power/supply/cw2015_battery.yaml
+++ b/Documentation/devicetree/bindings/power/supply/cw2015_battery.yaml
@@ -27,7 +27,7 @@ properties:
       of this binary blob is kept secret by CellWise. The only way to obtain
       it is to mail two batteries to a test facility of CellWise and receive
       back a test report with the binary blob.
-    $ref: /schemas/types.yaml#definitions/uint8-array
+    $ref: /schemas/types.yaml#/definitions/uint8-array
     minItems: 64
     maxItems: 64
 
diff --git a/Documentation/devicetree/bindings/powerpc/sleep.yaml b/Documentation/devicetree/bindings/powerpc/sleep.yaml
index 6494c7d08b93..1b0936a5beec 100644
--- a/Documentation/devicetree/bindings/powerpc/sleep.yaml
+++ b/Documentation/devicetree/bindings/powerpc/sleep.yaml
@@ -42,6 +42,6 @@ select: true
 
 properties:
   sleep:
-    $ref: /schemas/types.yaml#definitions/phandle-array
+    $ref: /schemas/types.yaml#/definitions/phandle-array
 
 additionalProperties: true
diff --git a/Documentation/devicetree/bindings/serial/8250.yaml b/Documentation/devicetree/bindings/serial/8250.yaml
index c1d4c196f005..f54cae9ff7b2 100644
--- a/Documentation/devicetree/bindings/serial/8250.yaml
+++ b/Documentation/devicetree/bindings/serial/8250.yaml
@@ -126,7 +126,7 @@ properties:
     maxItems: 1
 
   current-speed:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: The current active speed of the UART.
 
   reg-offset:
@@ -154,7 +154,7 @@ properties:
       Set to indicate that the port does not implement loopback test mode.
 
   fifo-size:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: The fifo size of the UART.
 
   auto-flow-control:
@@ -165,7 +165,7 @@ properties:
       property.
 
   tx-threshold:
-    $ref: /schemas/types.yaml#definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
       Specify the TX FIFO low water indication for parts with programmable
       TX FIFO thresholds.
diff --git a/Documentation/devicetree/bindings/soc/ti/k3-ringacc.yaml b/Documentation/devicetree/bindings/soc/ti/k3-ringacc.yaml
index c3c595e235a8..ddea3d41971d 100644
--- a/Documentation/devicetree/bindings/soc/ti/k3-ringacc.yaml
+++ b/Documentation/devicetree/bindings/soc/ti/k3-ringacc.yaml
@@ -55,7 +55,7 @@ properties:
     description: TI-SCI RM subtype for GP ring range
 
   ti,sci:
-    $ref: /schemas/types.yaml#definitions/phandle-array
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     description: phandle on TI-SCI compatible System controller node
 
   ti,sci-dev-id:
diff --git a/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-codec.yaml b/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-codec.yaml
index be390accdd07..dd47fef9854d 100644
--- a/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-codec.yaml
+++ b/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-codec.yaml
@@ -57,7 +57,7 @@ properties:
       A list of the connections between audio components.  Each entry
       is a pair of strings, the first being the connection's sink, the
       second being the connection's source.
-    $ref: /schemas/types.yaml#definitions/non-unique-string-array
+    $ref: /schemas/types.yaml#/definitions/non-unique-string-array
     minItems: 2
     maxItems: 18
     items:
diff --git a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
index 6ad48c7681c1..f2443b651282 100644
--- a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
+++ b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
@@ -106,7 +106,7 @@ patternProperties:
           Must contain the phandle and index of the SAI sub-block providing
           the synchronization.
         allOf:
-          - $ref: /schemas/types.yaml#definitions/phandle-array
+          - $ref: /schemas/types.yaml#/definitions/phandle-array
           - maxItems: 1
 
       st,iec60958:
@@ -117,7 +117,7 @@ patternProperties:
           configured according to protocol defined in related DAI link node,
           such as i2s, left justified, right justified, dsp and pdm protocols.
         allOf:
-          - $ref: /schemas/types.yaml#definitions/flag
+          - $ref: /schemas/types.yaml#/definitions/flag
 
       "#clock-cells":
         description: Configure the SAI device as master clock provider.
-- 
2.25.1

