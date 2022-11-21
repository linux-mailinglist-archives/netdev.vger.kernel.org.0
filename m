Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89091631FE4
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbiKULK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiKULJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:09:50 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E741B4F25
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:07:15 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id b3so18302442lfv.2
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vt/Wa0oZhOf8fgPaUT9nYutANNXrYJ1M3EC69Oc6bKY=;
        b=dkjpcM/pO1IKb6CkVrne1aMXK5pKU0cbTJhHKlkx02vkdPOtEnSa8DcY0ZNFQ/Aai2
         qH8lEQpCvc0P3JcOHif7m8xCUExRkW/i8XEAk8Xd4nF6WUgIbY7pTaOw296tyj9d0s5S
         49bYPkzl2sPqUHIasE8UjxvT6H2A4jv1BVUikormOKd/yX2YAHV4NTeUqY3JsiBuSZsv
         +9IxEfLYGIRpoF01ldIPFQS4uTCNTZT7q0WF2ueSIYt48kH9zXpMEhn2lViD/abJfvRE
         ZQuEKSQZMi0x8fDazXqUX1ZYHspCB+iO3RQZ9pNytp+96JUXrCzq0pmB0EWAToKjCK2P
         pNqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vt/Wa0oZhOf8fgPaUT9nYutANNXrYJ1M3EC69Oc6bKY=;
        b=vEXWewF/NV4NB/yeCeSInBlBnr0uk/g+Tm+F7vd7r0c9vEtwTteoWVffK7F1sc0fES
         foc+exuvRaEu5wecP30nhGjuIuT3bqmF/4e+h20XjDPGpE2KX3pe50q0J248d8cYDuId
         mw3PCoU8o3QqL3yW2f6BtsNU3h5iyFEQGdXBs1qLnTz1b7+Y45Vrn+ig+9wrA60UnUm9
         WE2LRhAkz+F/Han4kmo46U+b7q9+CLLGDPgBFBzDMVgGnokLh/Qlzsw/nOkRc70+Khz+
         AmTwd+Xh8MHJhKNjo6E7ACwEOI0CyKLJ16bbF2zO7Hb/bAzXb2tQJGjCpKDFv705I30F
         aStw==
X-Gm-Message-State: ANoB5pkdYjvfqDWWOeZjFMdGTj6+xQCVFiF0VdmG+KhaGmcsVPiA6Kky
        7y/1lEYNwoB+OcKvB0ymiJvLGQ==
X-Google-Smtp-Source: AA0mqf5nUBeMC8Y3mQrtIk7tF8Nu1KTg6JLn6oA018LE9kb9lE6jW7NgPef3dUXhGdN0anp1mO8BbA==
X-Received: by 2002:a05:6512:15a6:b0:4a2:3d2c:34ac with SMTP id bp38-20020a05651215a600b004a23d2c34acmr5515193lfb.41.1669028801206;
        Mon, 21 Nov 2022 03:06:41 -0800 (PST)
Received: from krzk-bin.NAT.warszawa.vectranet.pl (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id n1-20020a05651203e100b0049313f77755sm1991521lfq.213.2022.11.21.03.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 03:06:40 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-watchdog@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH v2 9/9] dt-bindings: drop redundant part of title (manual)
Date:   Mon, 21 Nov 2022 12:06:15 +0100
Message-Id: <20221121110615.97962-10-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
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

The Devicetree bindings document does not have to say in the title that
it is a "Devicetree binding" or a "schema", but instead just describe
the hardware.

Manual updates to various binding titles, including capitalizing them.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 Documentation/devicetree/bindings/clock/cirrus,cs2000-cp.yaml   | 2 +-
 Documentation/devicetree/bindings/clock/fsl,scu-clk.yaml        | 2 +-
 .../devicetree/bindings/clock/qcom,dispcc-sc8280xp.yaml         | 2 +-
 Documentation/devicetree/bindings/example-schema.yaml           | 2 +-
 Documentation/devicetree/bindings/input/fsl,scu-key.yaml        | 2 +-
 Documentation/devicetree/bindings/input/matrix-keymap.yaml      | 2 +-
 Documentation/devicetree/bindings/leds/issi,is31fl319x.yaml     | 2 +-
 Documentation/devicetree/bindings/net/asix,ax88178.yaml         | 2 +-
 Documentation/devicetree/bindings/net/microchip,lan95xx.yaml    | 2 +-
 Documentation/devicetree/bindings/nvmem/fsl,scu-ocotp.yaml      | 2 +-
 Documentation/devicetree/bindings/opp/opp-v2-qcom-level.yaml    | 2 +-
 Documentation/devicetree/bindings/pci/pci-ep.yaml               | 2 +-
 Documentation/devicetree/bindings/phy/calxeda-combophy.yaml     | 2 +-
 Documentation/devicetree/bindings/pinctrl/fsl,scu-pinctrl.yaml  | 2 +-
 Documentation/devicetree/bindings/pinctrl/pincfg-node.yaml      | 2 +-
 Documentation/devicetree/bindings/pinctrl/pinmux-node.yaml      | 2 +-
 Documentation/devicetree/bindings/power/fsl,scu-pd.yaml         | 2 +-
 Documentation/devicetree/bindings/riscv/cpus.yaml               | 2 +-
 Documentation/devicetree/bindings/rtc/fsl,scu-rtc.yaml          | 2 +-
 Documentation/devicetree/bindings/spi/omap-spi.yaml             | 2 +-
 Documentation/devicetree/bindings/thermal/fsl,scu-thermal.yaml  | 2 +-
 Documentation/devicetree/bindings/usb/usb-device.yaml           | 2 +-
 Documentation/devicetree/bindings/watchdog/fsl,scu-wdt.yaml     | 2 +-
 23 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/cirrus,cs2000-cp.yaml b/Documentation/devicetree/bindings/clock/cirrus,cs2000-cp.yaml
index 82836086cac1..d416c374e853 100644
--- a/Documentation/devicetree/bindings/clock/cirrus,cs2000-cp.yaml
+++ b/Documentation/devicetree/bindings/clock/cirrus,cs2000-cp.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/cirrus,cs2000-cp.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding CIRRUS LOGIC Fractional-N Clock Synthesizer & Clock Multiplier
+title: CIRRUS LOGIC Fractional-N Clock Synthesizer & Clock Multiplier
 
 maintainers:
   - Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
diff --git a/Documentation/devicetree/bindings/clock/fsl,scu-clk.yaml b/Documentation/devicetree/bindings/clock/fsl,scu-clk.yaml
index f2c48460a399..36d4cfc3c2f8 100644
--- a/Documentation/devicetree/bindings/clock/fsl,scu-clk.yaml
+++ b/Documentation/devicetree/bindings/clock/fsl,scu-clk.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/fsl,scu-clk.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: i.MX SCU Client Device Node - Clock bindings based on SCU Message Protocol
+title: i.MX SCU Client Device Node - Clock Controller Based on SCU Message Protocol
 
 maintainers:
   - Abel Vesa <abel.vesa@nxp.com>
diff --git a/Documentation/devicetree/bindings/clock/qcom,dispcc-sc8280xp.yaml b/Documentation/devicetree/bindings/clock/qcom,dispcc-sc8280xp.yaml
index 28c13237059f..3cb996b2c9d5 100644
--- a/Documentation/devicetree/bindings/clock/qcom,dispcc-sc8280xp.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,dispcc-sc8280xp.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/qcom,dispcc-sc8280xp.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Display Clock & Reset Controller Binding for SC8280XP
+title: Qualcomm Display Clock & Reset Controller on SC8280XP
 
 maintainers:
   - Bjorn Andersson <bjorn.andersson@linaro.org>
diff --git a/Documentation/devicetree/bindings/example-schema.yaml b/Documentation/devicetree/bindings/example-schema.yaml
index 8e1a8b19d429..dfcf4c27d44a 100644
--- a/Documentation/devicetree/bindings/example-schema.yaml
+++ b/Documentation/devicetree/bindings/example-schema.yaml
@@ -11,7 +11,7 @@ $id: http://devicetree.org/schemas/example-schema.yaml#
 # $schema is the meta-schema this schema should be validated with.
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: An example schema annotated with jsonschema details
+title: An Example Device
 
 maintainers:
   - Rob Herring <robh@kernel.org>
diff --git a/Documentation/devicetree/bindings/input/fsl,scu-key.yaml b/Documentation/devicetree/bindings/input/fsl,scu-key.yaml
index e6266d188266..e5a3c355ee1f 100644
--- a/Documentation/devicetree/bindings/input/fsl,scu-key.yaml
+++ b/Documentation/devicetree/bindings/input/fsl,scu-key.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/fsl,scu-key.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: i.MX SCU Client Device Node - SCU key bindings based on SCU Message Protocol
+title: i.MX SCU Client Device Node - SCU Key Based on SCU Message Protocol
 
 maintainers:
   - Dong Aisheng <aisheng.dong@nxp.com>
diff --git a/Documentation/devicetree/bindings/input/matrix-keymap.yaml b/Documentation/devicetree/bindings/input/matrix-keymap.yaml
index 6699d5e32dca..4d6dbe91646d 100644
--- a/Documentation/devicetree/bindings/input/matrix-keymap.yaml
+++ b/Documentation/devicetree/bindings/input/matrix-keymap.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/matrix-keymap.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Common key matrices binding for matrix-connected key boards
+title: Common Key Matrices on Matrix-connected Key Boards
 
 maintainers:
   - Olof Johansson <olof@lixom.net>
diff --git a/Documentation/devicetree/bindings/leds/issi,is31fl319x.yaml b/Documentation/devicetree/bindings/leds/issi,is31fl319x.yaml
index 940333f2d69c..eebe372ea463 100644
--- a/Documentation/devicetree/bindings/leds/issi,is31fl319x.yaml
+++ b/Documentation/devicetree/bindings/leds/issi,is31fl319x.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/leds/issi,is31fl319x.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: ISSI LED controllers bindings for IS31FL319{0,1,3,6,9}
+title: ISSI LED Controllers for IS31FL319{0,1,3,6,9}
 
 maintainers:
   - Vincent Knecht <vincent.knecht@mailoo.org>
diff --git a/Documentation/devicetree/bindings/net/asix,ax88178.yaml b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
index a81dbc4792f6..768504ccbf74 100644
--- a/Documentation/devicetree/bindings/net/asix,ax88178.yaml
+++ b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/asix,ax88178.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: The device tree bindings for the USB Ethernet controllers
+title: ASIX AX88172/AX88772 USB Ethernet Controllers
 
 maintainers:
   - Oleksij Rempel <o.rempel@pengutronix.de>
diff --git a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
index 3715c5f8f0e0..0b97e14d947f 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/microchip,lan95xx.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: The device tree bindings for the USB Ethernet controllers
+title: Microchip SMSC9500/LAN9530/LAN9730 USB Ethernet Controllers
 
 maintainers:
   - Oleksij Rempel <o.rempel@pengutronix.de>
diff --git a/Documentation/devicetree/bindings/nvmem/fsl,scu-ocotp.yaml b/Documentation/devicetree/bindings/nvmem/fsl,scu-ocotp.yaml
index 682688299b26..f0a49283649d 100644
--- a/Documentation/devicetree/bindings/nvmem/fsl,scu-ocotp.yaml
+++ b/Documentation/devicetree/bindings/nvmem/fsl,scu-ocotp.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/nvmem/fsl,scu-ocotp.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: i.MX SCU Client Device Node - OCOTP bindings based on SCU Message Protocol
+title: i.MX SCU Client Device Node - OCOTP Based on SCU Message Protocol
 
 maintainers:
   - Dong Aisheng <aisheng.dong@nxp.com>
diff --git a/Documentation/devicetree/bindings/opp/opp-v2-qcom-level.yaml b/Documentation/devicetree/bindings/opp/opp-v2-qcom-level.yaml
index df8442fb11f0..b9ce2e099ce9 100644
--- a/Documentation/devicetree/bindings/opp/opp-v2-qcom-level.yaml
+++ b/Documentation/devicetree/bindings/opp/opp-v2-qcom-level.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/opp/opp-v2-qcom-level.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm OPP bindings to describe OPP nodes.
+title: Qualcomm OPP
 
 maintainers:
   - Niklas Cassel <nks@flawful.org>
diff --git a/Documentation/devicetree/bindings/pci/pci-ep.yaml b/Documentation/devicetree/bindings/pci/pci-ep.yaml
index ccec51ab5247..d1eef4825207 100644
--- a/Documentation/devicetree/bindings/pci/pci-ep.yaml
+++ b/Documentation/devicetree/bindings/pci/pci-ep.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/pci/pci-ep.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: PCI Endpoint Controller Schema
+title: PCI Endpoint Controller
 
 description: |
   Common properties for PCI Endpoint Controller Nodes.
diff --git a/Documentation/devicetree/bindings/phy/calxeda-combophy.yaml b/Documentation/devicetree/bindings/phy/calxeda-combophy.yaml
index 41ee16e21f8d..d05a7c793035 100644
--- a/Documentation/devicetree/bindings/phy/calxeda-combophy.yaml
+++ b/Documentation/devicetree/bindings/phy/calxeda-combophy.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/phy/calxeda-combophy.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Calxeda Highbank Combination PHYs binding for SATA
+title: Calxeda Highbank Combination PHYs for SATA
 
 description: |
   The Calxeda Combination PHYs connect the SoC to the internal fabric
diff --git a/Documentation/devicetree/bindings/pinctrl/fsl,scu-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/fsl,scu-pinctrl.yaml
index 45ea565ce238..fcd729afeee1 100644
--- a/Documentation/devicetree/bindings/pinctrl/fsl,scu-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/fsl,scu-pinctrl.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/pinctrl/fsl,scu-pinctrl.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: i.MX SCU Client Device Node - Pinctrl bindings based on SCU Message Protocol
+title: i.MX SCU Client Device Node - Pinctrl Based on SCU Message Protocol
 
 maintainers:
   - Dong Aisheng <aisheng.dong@nxp.com>
diff --git a/Documentation/devicetree/bindings/pinctrl/pincfg-node.yaml b/Documentation/devicetree/bindings/pinctrl/pincfg-node.yaml
index f5a121311f61..be81ed22a036 100644
--- a/Documentation/devicetree/bindings/pinctrl/pincfg-node.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/pincfg-node.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/pinctrl/pincfg-node.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Generic pin configuration node schema
+title: Generic Pin Configuration Node
 
 maintainers:
   - Linus Walleij <linus.walleij@linaro.org>
diff --git a/Documentation/devicetree/bindings/pinctrl/pinmux-node.yaml b/Documentation/devicetree/bindings/pinctrl/pinmux-node.yaml
index 551df3d9b809..008c3ab7f1bb 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinmux-node.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/pinmux-node.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/pinctrl/pinmux-node.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Generic pin multiplexing node schema
+title: Generic Pin Multiplexing Node
 
 maintainers:
   - Linus Walleij <linus.walleij@linaro.org>
diff --git a/Documentation/devicetree/bindings/power/fsl,scu-pd.yaml b/Documentation/devicetree/bindings/power/fsl,scu-pd.yaml
index 1f72b18ca0fc..407b7cfec783 100644
--- a/Documentation/devicetree/bindings/power/fsl,scu-pd.yaml
+++ b/Documentation/devicetree/bindings/power/fsl,scu-pd.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/power/fsl,scu-pd.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: i.MX SCU Client Device Node - Power domain bindings based on SCU Message Protocol
+title: i.MX SCU Client Device Node - Power Domain Based on SCU Message Protocol
 
 maintainers:
   - Dong Aisheng <aisheng.dong@nxp.com>
diff --git a/Documentation/devicetree/bindings/riscv/cpus.yaml b/Documentation/devicetree/bindings/riscv/cpus.yaml
index 83ad177a9043..c6720764e765 100644
--- a/Documentation/devicetree/bindings/riscv/cpus.yaml
+++ b/Documentation/devicetree/bindings/riscv/cpus.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/riscv/cpus.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: RISC-V bindings for 'cpus' DT nodes
+title: RISC-V CPUs
 
 maintainers:
   - Paul Walmsley <paul.walmsley@sifive.com>
diff --git a/Documentation/devicetree/bindings/rtc/fsl,scu-rtc.yaml b/Documentation/devicetree/bindings/rtc/fsl,scu-rtc.yaml
index 8c102b70d735..dd1b1abf1e1b 100644
--- a/Documentation/devicetree/bindings/rtc/fsl,scu-rtc.yaml
+++ b/Documentation/devicetree/bindings/rtc/fsl,scu-rtc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/rtc/fsl,scu-rtc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: i.MX SCU Client Device Node - RTC bindings based on SCU Message Protocol
+title: i.MX SCU Client Device Node - RTC Based on SCU Message Protocol
 
 maintainers:
   - Dong Aisheng <aisheng.dong@nxp.com>
diff --git a/Documentation/devicetree/bindings/spi/omap-spi.yaml b/Documentation/devicetree/bindings/spi/omap-spi.yaml
index 9952199cae11..352affa4b7f8 100644
--- a/Documentation/devicetree/bindings/spi/omap-spi.yaml
+++ b/Documentation/devicetree/bindings/spi/omap-spi.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/spi/omap-spi.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: SPI controller bindings for OMAP and K3 SoCs
+title: SPI Controller on OMAP and K3 SoCs
 
 maintainers:
   - Aswath Govindraju <a-govindraju@ti.com>
diff --git a/Documentation/devicetree/bindings/thermal/fsl,scu-thermal.yaml b/Documentation/devicetree/bindings/thermal/fsl,scu-thermal.yaml
index f9e4b3c8d0ee..3721c8c8ec64 100644
--- a/Documentation/devicetree/bindings/thermal/fsl,scu-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/fsl,scu-thermal.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/thermal/fsl,scu-thermal.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: i.MX SCU Client Device Node - Thermal bindings based on SCU Message Protocol
+title: i.MX SCU Client Device Node - Thermal Based on SCU Message Protocol
 
 maintainers:
   - Dong Aisheng <aisheng.dong@nxp.com>
diff --git a/Documentation/devicetree/bindings/usb/usb-device.yaml b/Documentation/devicetree/bindings/usb/usb-device.yaml
index b77960a7a37b..7a771125ec76 100644
--- a/Documentation/devicetree/bindings/usb/usb-device.yaml
+++ b/Documentation/devicetree/bindings/usb/usb-device.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/usb/usb-device.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: The device tree bindings for the Generic USB Device
+title: Generic USB Device
 
 maintainers:
   - Greg Kroah-Hartman <gregkh@linuxfoundation.org>
diff --git a/Documentation/devicetree/bindings/watchdog/fsl,scu-wdt.yaml b/Documentation/devicetree/bindings/watchdog/fsl,scu-wdt.yaml
index f84c45d687d7..47701248cd8d 100644
--- a/Documentation/devicetree/bindings/watchdog/fsl,scu-wdt.yaml
+++ b/Documentation/devicetree/bindings/watchdog/fsl,scu-wdt.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/watchdog/fsl,scu-wdt.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: i.MX SCU Client Device Node - Watchdog bindings based on SCU Message Protocol
+title: i.MX SCU Client Device Node - Watchdog Based on SCU Message Protocol
 
 maintainers:
   - Dong Aisheng <aisheng.dong@nxp.com>
-- 
2.34.1

