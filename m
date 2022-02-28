Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2313F4C7C2D
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 22:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiB1Vir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 16:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiB1Viq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 16:38:46 -0500
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AB24E3A7;
        Mon, 28 Feb 2022 13:38:06 -0800 (PST)
Received: by mail-oi1-f179.google.com with SMTP id ay7so14489687oib.8;
        Mon, 28 Feb 2022 13:38:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fMROHLMr7zmz8Qsry/nXkPwUEpxrLG9HQDcEkq0wy+o=;
        b=lPkibSPmRz7wkhpVeC5uCywman5hiTGrmIbpox0db3Kq7KhJMYaqOHN2egCJCsvpdf
         cBZeE1Lh/sY0T/q8x2CHAGkm4Z9y8HxS4ptsSBjRq5XQ/y969Vap7LSvtCIiUuP7+dOZ
         eFRqEE6FAefEo7vZplyUQkNMo3eYhEAfkUFiNIRiz5t/3QK2kyXDtmgO/V7MuDwwyqxr
         BebTJRPXVTcRRccTpkuBH4ahA6rSJqZVsaEMxkhFxHoROpPj+pXgHNIUHRDTqO4xDikT
         lgV5mp+WugpUQtYvyhgsYc8XkaS+BSZZoBV/VgAOJcRQbpHVNyvB6kgnyI0sDk5s1DQZ
         sMSg==
X-Gm-Message-State: AOAM532QaYtCJJnwExeS4OtMsZUx9vS7P+BDQmebMjD480c1Sjl6QrI0
        fGGjW6tTCwNVb8fq/3VXYI9T0zDGgw==
X-Google-Smtp-Source: ABdhPJwo7JDLtvgSO4dkMvF1NtgFIIORRZ31YMxJPrKj3THbxeeEIkQp1RInNRvsSiD/R9szOqniAA==
X-Received: by 2002:aca:3444:0:b0:2d4:edde:ce55 with SMTP id b65-20020aca3444000000b002d4eddece55mr10233359oia.142.1646084284829;
        Mon, 28 Feb 2022 13:38:04 -0800 (PST)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id l1-20020a4aa781000000b0031cf8e00738sm5324838oom.1.2022.02.28.13.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 13:38:04 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee.jones@linaro.org>,
        Guenter Roeck <groeck@chromium.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH] dt-bindings: Another pass removing cases of 'allOf' containing a '$ref'
Date:   Mon, 28 Feb 2022 15:38:02 -0600
Message-Id: <20220228213802.1639658-1-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another pass at removing unnecessary use of 'allOf' with a '$ref'.

json-schema versions draft7 and earlier have a weird behavior in that
any keywords combined with a '$ref' are ignored (silently). The correct
form was to put a '$ref' under an 'allOf'. This behavior is now changed
in the 2019-09 json-schema spec and '$ref' can be mixed with other
keywords.

Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-input@vger.kernel.org
Cc: linux-leds@vger.kernel.org
Cc: linux-mtd@lists.infradead.org
Cc: netdev@vger.kernel.org
Cc: linux-phy@lists.infradead.org
Cc: linux-pm@vger.kernel.org
Cc: linux-remoteproc@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Cc: linux-spi@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../bindings/connector/usb-connector.yaml         |  3 +--
 .../bindings/display/brcm,bcm2711-hdmi.yaml       |  3 +--
 .../bindings/display/bridge/adi,adv7511.yaml      |  5 ++---
 .../bindings/display/bridge/synopsys,dw-hdmi.yaml |  5 ++---
 .../bindings/display/panel/display-timings.yaml   |  3 +--
 .../devicetree/bindings/display/ste,mcde.yaml     |  4 ++--
 .../devicetree/bindings/input/adc-joystick.yaml   |  9 ++++-----
 .../bindings/leds/cznic,turris-omnia-leds.yaml    |  3 +--
 .../devicetree/bindings/leds/leds-lp50xx.yaml     |  3 +--
 .../devicetree/bindings/mfd/google,cros-ec.yaml   | 12 ++++--------
 .../devicetree/bindings/mtd/nand-controller.yaml  |  8 +++-----
 .../bindings/mtd/rockchip,nand-controller.yaml    |  3 +--
 .../devicetree/bindings/net/ti,cpsw-switch.yaml   |  3 +--
 .../bindings/phy/phy-stm32-usbphyc.yaml           |  3 +--
 .../bindings/power/supply/sbs,sbs-manager.yaml    |  4 +---
 .../bindings/remoteproc/ti,k3-r5f-rproc.yaml      |  3 +--
 .../devicetree/bindings/soc/ti/ti,pruss.yaml      | 15 +++------------
 .../devicetree/bindings/sound/st,stm32-sai.yaml   |  3 +--
 .../devicetree/bindings/sound/tlv320adcx140.yaml  | 13 ++++++-------
 .../devicetree/bindings/spi/spi-controller.yaml   |  4 +---
 .../devicetree/bindings/usb/st,stusb160x.yaml     |  4 +---
 21 files changed, 39 insertions(+), 74 deletions(-)

diff --git a/Documentation/devicetree/bindings/connector/usb-connector.yaml b/Documentation/devicetree/bindings/connector/usb-connector.yaml
index 7eb8659fa610..0420fa563532 100644
--- a/Documentation/devicetree/bindings/connector/usb-connector.yaml
+++ b/Documentation/devicetree/bindings/connector/usb-connector.yaml
@@ -104,8 +104,7 @@ properties:
       - "1.5A" and "3.0A", 5V 1.5A and 5V 3.0A respectively, as defined in USB
         Type-C Cable and Connector specification, when Power Delivery is not
         supported.
-    allOf:
-      - $ref: /schemas/types.yaml#/definitions/string
+    $ref: /schemas/types.yaml#/definitions/string
     enum:
       - default
       - 1.5A
diff --git a/Documentation/devicetree/bindings/display/brcm,bcm2711-hdmi.yaml b/Documentation/devicetree/bindings/display/brcm,bcm2711-hdmi.yaml
index a1d5a32660e0..a9d34dd7bbc5 100644
--- a/Documentation/devicetree/bindings/display/brcm,bcm2711-hdmi.yaml
+++ b/Documentation/devicetree/bindings/display/brcm,bcm2711-hdmi.yaml
@@ -72,8 +72,7 @@ properties:
       - const: hpd-removed
 
   ddc:
-    allOf:
-      - $ref: /schemas/types.yaml#/definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle
     description: >
       Phandle of the I2C controller used for DDC EDID probing
 
diff --git a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.yaml b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.yaml
index d3dd7a79b909..f08a01dfedf3 100644
--- a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.yaml
@@ -76,9 +76,8 @@ properties:
 
   adi,input-depth:
     description: Number of bits per color component at the input.
-    allOf:
-      - $ref: /schemas/types.yaml#/definitions/uint32
-      - enum: [ 8, 10, 12 ]
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [ 8, 10, 12 ]
 
   adi,input-colorspace:
     description: Input color space.
diff --git a/Documentation/devicetree/bindings/display/bridge/synopsys,dw-hdmi.yaml b/Documentation/devicetree/bindings/display/bridge/synopsys,dw-hdmi.yaml
index 9be44a682e67..b00246faea57 100644
--- a/Documentation/devicetree/bindings/display/bridge/synopsys,dw-hdmi.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/synopsys,dw-hdmi.yaml
@@ -26,9 +26,8 @@ properties:
   reg-io-width:
     description:
       Width (in bytes) of the registers specified by the reg property.
-    allOf:
-      - $ref: /schemas/types.yaml#/definitions/uint32
-      - enum: [1, 4]
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [1, 4]
     default: 1
 
   clocks:
diff --git a/Documentation/devicetree/bindings/display/panel/display-timings.yaml b/Documentation/devicetree/bindings/display/panel/display-timings.yaml
index 56903ded005e..6d30575819d3 100644
--- a/Documentation/devicetree/bindings/display/panel/display-timings.yaml
+++ b/Documentation/devicetree/bindings/display/panel/display-timings.yaml
@@ -31,8 +31,7 @@ properties:
 patternProperties:
   "^timing":
     type: object
-    allOf:
-      - $ref: panel-timing.yaml#
+    $ref: panel-timing.yaml#
 
 additionalProperties: false
 
diff --git a/Documentation/devicetree/bindings/display/ste,mcde.yaml b/Documentation/devicetree/bindings/display/ste,mcde.yaml
index de0c678b3c29..564ea845c82e 100644
--- a/Documentation/devicetree/bindings/display/ste,mcde.yaml
+++ b/Documentation/devicetree/bindings/display/ste,mcde.yaml
@@ -58,8 +58,8 @@ patternProperties:
   "^dsi@[0-9a-f]+$":
     description: subnodes for the three DSI host adapters
     type: object
-    allOf:
-      - $ref: dsi-controller.yaml#
+    $ref: dsi-controller.yaml#
+
     properties:
       compatible:
         const: ste,mcde-dsi
diff --git a/Documentation/devicetree/bindings/input/adc-joystick.yaml b/Documentation/devicetree/bindings/input/adc-joystick.yaml
index 721878d5b7af..2ee04e03bc22 100644
--- a/Documentation/devicetree/bindings/input/adc-joystick.yaml
+++ b/Documentation/devicetree/bindings/input/adc-joystick.yaml
@@ -61,11 +61,10 @@ patternProperties:
         description: EV_ABS specific event code generated by the axis.
 
       abs-range:
-        allOf:
-          - $ref: /schemas/types.yaml#/definitions/uint32-array
-          - items:
-              - description: minimum value
-              - description: maximum value
+        $ref: /schemas/types.yaml#/definitions/uint32-array
+        items:
+          - description: minimum value
+          - description: maximum value
         description: >
           Minimum and maximum values produced by the axis.
           For an ABS_X axis this will be the left-most and right-most
diff --git a/Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml b/Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml
index c7ed2871da06..9362b1ef9e88 100644
--- a/Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml
+++ b/Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml
@@ -32,8 +32,7 @@ properties:
 patternProperties:
   "^multi-led@[0-9a-b]$":
     type: object
-    allOf:
-      - $ref: leds-class-multicolor.yaml#
+    $ref: leds-class-multicolor.yaml#
     description:
       This node represents one of the RGB LED devices on Turris Omnia.
       No subnodes need to be added for subchannels since this controller only
diff --git a/Documentation/devicetree/bindings/leds/leds-lp50xx.yaml b/Documentation/devicetree/bindings/leds/leds-lp50xx.yaml
index c192b5feadc7..f12fe5b53f30 100644
--- a/Documentation/devicetree/bindings/leds/leds-lp50xx.yaml
+++ b/Documentation/devicetree/bindings/leds/leds-lp50xx.yaml
@@ -55,8 +55,7 @@ properties:
 patternProperties:
   '^multi-led@[0-9a-f]$':
     type: object
-    allOf:
-      - $ref: leds-class-multicolor.yaml#
+    $ref: leds-class-multicolor.yaml#
     properties:
       reg:
         minItems: 1
diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
index d1f53bd449f7..a52f3a82283c 100644
--- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
+++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
@@ -38,18 +38,14 @@ properties:
     description:
       This property specifies the delay in usecs between the
       assertion of the CS and the first clock pulse.
-    allOf:
-      - $ref: /schemas/types.yaml#/definitions/uint32
-      - default: 0
-      - minimum: 0
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 0
 
   google,cros-ec-spi-msg-delay:
     description:
       This property specifies the delay in usecs between messages.
-    allOf:
-      - $ref: /schemas/types.yaml#/definitions/uint32
-      - default: 0
-      - minimum: 0
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 0
 
   google,has-vbc-nvram:
     description:
diff --git a/Documentation/devicetree/bindings/mtd/nand-controller.yaml b/Documentation/devicetree/bindings/mtd/nand-controller.yaml
index bd217e6f5018..0714f614550d 100644
--- a/Documentation/devicetree/bindings/mtd/nand-controller.yaml
+++ b/Documentation/devicetree/bindings/mtd/nand-controller.yaml
@@ -58,8 +58,7 @@ patternProperties:
           Contains the native Ready/Busy IDs.
 
       nand-ecc-engine:
-        allOf:
-          - $ref: /schemas/types.yaml#/definitions/phandle
+        $ref: /schemas/types.yaml#/definitions/phandle
         description: |
           A phandle on the hardware ECC engine if any. There are
           basically three possibilities:
@@ -79,9 +78,8 @@ patternProperties:
         description: Do not use any ECC correction.
 
       nand-ecc-placement:
-        allOf:
-          - $ref: /schemas/types.yaml#/definitions/string
-          - enum: [ oob, interleaved ]
+        $ref: /schemas/types.yaml#/definitions/string
+        enum: [ oob, interleaved ]
         description:
           Location of the ECC bytes. This location is unknown by default
           but can be explicitly set to "oob", if all ECC bytes are
diff --git a/Documentation/devicetree/bindings/mtd/rockchip,nand-controller.yaml b/Documentation/devicetree/bindings/mtd/rockchip,nand-controller.yaml
index 0922536b1811..d681a4676f06 100644
--- a/Documentation/devicetree/bindings/mtd/rockchip,nand-controller.yaml
+++ b/Documentation/devicetree/bindings/mtd/rockchip,nand-controller.yaml
@@ -96,8 +96,7 @@ patternProperties:
 
       rockchip,boot-ecc-strength:
         enum: [16, 24, 40, 60, 70]
-        allOf:
-          - $ref: /schemas/types.yaml#/definitions/uint32
+        $ref: /schemas/types.yaml#/definitions/uint32
         description: |
           If specified it indicates that a different BCH/ECC setting is
           supported by the boot ROM.
diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
index 07a00f53adbf..31bf825c6598 100644
--- a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
+++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
@@ -88,8 +88,7 @@ properties:
         type: object
         description: CPSW external ports
 
-        allOf:
-          - $ref: ethernet-controller.yaml#
+        $ref: ethernet-controller.yaml#
 
         properties:
           reg:
diff --git a/Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml b/Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml
index 267b695215b6..dc287d428e49 100644
--- a/Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml
+++ b/Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml
@@ -76,8 +76,7 @@ patternProperties:
 
       connector:
         type: object
-        allOf:
-          - $ref: ../connector/usb-connector.yaml
+        $ref: /schemas/connector/usb-connector.yaml
         properties:
           vbus-supply: true
 
diff --git a/Documentation/devicetree/bindings/power/supply/sbs,sbs-manager.yaml b/Documentation/devicetree/bindings/power/supply/sbs,sbs-manager.yaml
index 72e8f274c791..99f506d6b0a0 100644
--- a/Documentation/devicetree/bindings/power/supply/sbs,sbs-manager.yaml
+++ b/Documentation/devicetree/bindings/power/supply/sbs,sbs-manager.yaml
@@ -46,9 +46,7 @@ additionalProperties: false
 patternProperties:
   "^i2c@[1-4]$":
     type: object
-
-    allOf:
-      - $ref: /schemas/i2c/i2c-controller.yaml#
+    $ref: /schemas/i2c/i2c-controller.yaml#
 
 examples:
   - |
diff --git a/Documentation/devicetree/bindings/remoteproc/ti,k3-r5f-rproc.yaml b/Documentation/devicetree/bindings/remoteproc/ti,k3-r5f-rproc.yaml
index 0868154a0364..fb9605f0655b 100644
--- a/Documentation/devicetree/bindings/remoteproc/ti,k3-r5f-rproc.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/ti,k3-r5f-rproc.yaml
@@ -95,8 +95,7 @@ patternProperties:
       addresses. Cache and memory access settings are provided through a
       Memory Protection Unit (MPU), programmable only from the R5Fs.
 
-    allOf:
-      - $ref: /schemas/arm/keystone/ti,k3-sci-common.yaml#
+    $ref: /schemas/arm/keystone/ti,k3-sci-common.yaml#
 
     properties:
       compatible:
diff --git a/Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml b/Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml
index 9d128b9e7deb..64461d432004 100644
--- a/Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml
+++ b/Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml
@@ -281,10 +281,7 @@ patternProperties:
       PRUSS INTC Node. Each PRUSS has a single interrupt controller instance
       that is common to all the PRU cores. This should be represented as an
       interrupt-controller node.
-
-    allOf:
-      - $ref: /schemas/interrupt-controller/ti,pruss-intc.yaml#
-
+    $ref: /schemas/interrupt-controller/ti,pruss-intc.yaml#
     type: object
 
   mdio@[a-f0-9]+$:
@@ -292,10 +289,7 @@ patternProperties:
       MDIO Node. Each PRUSS has an MDIO module that can be used to control
       external PHYs. The MDIO module used within the PRU-ICSS is an instance of
       the MDIO Controller used in TI Davinci SoCs.
-
-    allOf:
-      - $ref: /schemas/net/ti,davinci-mdio.yaml#
-
+    $ref: /schemas/net/ti,davinci-mdio.yaml#
     type: object
 
   "^(pru|rtu|txpru)@[0-9a-f]+$":
@@ -305,10 +299,7 @@ patternProperties:
       inactive by using the standard DT string property, "status". The ICSSG IP
       present on K3 SoCs have additional auxiliary PRU cores with slightly
       different IP integration.
-
-    allOf:
-      - $ref: /schemas/remoteproc/ti,pru-rproc.yaml#
-
+    $ref: /schemas/remoteproc/ti,pru-rproc.yaml#
     type: object
 
 required:
diff --git a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
index d4fc8fdcb72f..b3dbcba33e41 100644
--- a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
+++ b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
@@ -115,8 +115,7 @@ patternProperties:
           By default, custom protocol is assumed, meaning that protocol is
           configured according to protocol defined in related DAI link node,
           such as i2s, left justified, right justified, dsp and pdm protocols.
-        allOf:
-          - $ref: /schemas/types.yaml#/definitions/flag
+        $ref: /schemas/types.yaml#/definitions/flag
 
       "#clock-cells":
         description: Configure the SAI device as master clock provider.
diff --git a/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml b/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
index d77c8283526d..2ad17b361db0 100644
--- a/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
+++ b/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
@@ -176,13 +176,12 @@ patternProperties:
        4 - Drive weak low and active high
        5 - Drive Hi-Z and active high
 
-    allOf:
-      - $ref: /schemas/types.yaml#/definitions/uint32-array
-      - minItems: 2
-        maxItems: 2
-        items:
-          maximum: 15
-        default: [2, 2]
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    minItems: 2
+    maxItems: 2
+    items:
+      maximum: 15
+    default: [2, 2]
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/spi/spi-controller.yaml b/Documentation/devicetree/bindings/spi/spi-controller.yaml
index 36b72518f565..6d0511a8727f 100644
--- a/Documentation/devicetree/bindings/spi/spi-controller.yaml
+++ b/Documentation/devicetree/bindings/spi/spi-controller.yaml
@@ -93,9 +93,7 @@ properties:
 patternProperties:
   "^.*@[0-9a-f]+$":
     type: object
-
-    allOf:
-      - $ref: spi-peripheral-props.yaml
+    $ref: spi-peripheral-props.yaml
 
     required:
       - compatible
diff --git a/Documentation/devicetree/bindings/usb/st,stusb160x.yaml b/Documentation/devicetree/bindings/usb/st,stusb160x.yaml
index ead1571e0e43..b5a8c9814dd3 100644
--- a/Documentation/devicetree/bindings/usb/st,stusb160x.yaml
+++ b/Documentation/devicetree/bindings/usb/st,stusb160x.yaml
@@ -32,9 +32,7 @@ properties:
 
   connector:
     type: object
-
-    allOf:
-      - $ref: ../connector/usb-connector.yaml
+    $ref: /schemas/connector/usb-connector.yaml#
 
     properties:
       compatible:
-- 
2.32.0

