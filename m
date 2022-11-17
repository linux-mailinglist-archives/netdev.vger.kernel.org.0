Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A03D62DB8A
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240029AbiKQMlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240233AbiKQMkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:40:20 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11109748C7
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:39:22 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id a29so2545678lfj.9
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tfsai1tPXL9tuN31ng9KjomCjwWoQpYvXq5XPjRbstc=;
        b=cIHyAOUDjQhArkFlfwHywYR3eb6JhlGnTdProwcDXmWq2ygrcytlRJ04pPzHAF3eT1
         e7NPD0oAULbh9LFapMA+kD2DNm3YOp2foI96SFAEspfFHI2XFFLmC/0gPyK0VePu8XbO
         E9/j5W/x/ZV/ZU/MxC2u29ZAwXoMPDibuh+hCF8XSqaRqjrzELMvGQJojpF8NLJ05cWj
         +HAlZ2/yzXaQPPYnwPYGz3pdBMksKL26Resln8ysbibHyqWVfMLP4/AnU/VHGPMTM8ER
         JaG4dZADeC6D3BASj2siWbA5/kXtl65jP5duQkXg9Kd/0OuDunnIMncAPp/3mJiEDhg/
         wItw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tfsai1tPXL9tuN31ng9KjomCjwWoQpYvXq5XPjRbstc=;
        b=CI+z2eTEt44hDr5rSIqRMwY2h6VVeweYZ/YCMv9ZWBwq7kYttKDmfeVFXjxvOxsdIr
         yAt8ImZBz2Q9CrRmpTqB63skIFZ53Vl0QBIg660K72ai5dKoGcV2aXQHMptHNoBmFXgP
         C84M8BCOBds1XVxia2hSEjPBaIDfCqJU7sqKMjCpnRXvI33fMxFqPRpDnt5kD5Woscf+
         LRcRiyAaYroi6DbNQreAqoBI1skoDTIjyTg3k8MPDE4MZxyNgRBkiVeEJ5wvNtG887da
         NXsMPa/zGy0rMlqJTTfkIyM5hht2I1SgXsOMouc6GL8STp8NR5IuoApqWvWyZsL9jmpc
         Oi6Q==
X-Gm-Message-State: ANoB5pmJJhc/N0SqTbtt9oWkI9QaS891tYqH95fe4ENugbkm/ztOmqC1
        nFO5Tc1MulDRSFZ2RGcDbPavyg==
X-Google-Smtp-Source: AA0mqf4DPy30WUtR32YtYBJ7HSbXcDUn4YbfrRP9zSubsZw9puGGcinXI4ay1HSqCD+BjZ3t1AeNxg==
X-Received: by 2002:a19:7402:0:b0:492:e5b6:6eb4 with SMTP id v2-20020a197402000000b00492e5b66eb4mr860006lfe.593.1668688761579;
        Thu, 17 Nov 2022 04:39:21 -0800 (PST)
Received: from krzk-bin.NAT.warszawa.vectranet.pl (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id u28-20020ac24c3c000000b004972b0bb426sm127855lfq.257.2022.11.17.04.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 04:39:21 -0800 (PST)
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
        linux-watchdog@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [RFC PATCH 9/9] dt-bindings: drop redundant part of title (manual)
Date:   Thu, 17 Nov 2022 13:38:50 +0100
Message-Id: <20221117123850.368213-10-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221117123850.368213-1-krzysztof.kozlowski@linaro.org>
References: <20221117123850.368213-1-krzysztof.kozlowski@linaro.org>
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
it is a "Devicetree binding", but instead just describe the hardware.

Manual updates to various binding titles.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/clock/cirrus,cs2000-cp.yaml   | 2 +-
 Documentation/devicetree/bindings/clock/fsl,scu-clk.yaml        | 2 +-
 .../devicetree/bindings/clock/qcom,dispcc-sc8280xp.yaml         | 2 +-
 Documentation/devicetree/bindings/input/fsl,scu-key.yaml        | 2 +-
 Documentation/devicetree/bindings/input/matrix-keymap.yaml      | 2 +-
 Documentation/devicetree/bindings/leds/issi,is31fl319x.yaml     | 2 +-
 Documentation/devicetree/bindings/net/asix,ax88178.yaml         | 2 +-
 Documentation/devicetree/bindings/net/microchip,lan95xx.yaml    | 2 +-
 Documentation/devicetree/bindings/nvmem/fsl,scu-ocotp.yaml      | 2 +-
 Documentation/devicetree/bindings/opp/opp-v2-qcom-level.yaml    | 2 +-
 Documentation/devicetree/bindings/phy/calxeda-combophy.yaml     | 2 +-
 Documentation/devicetree/bindings/pinctrl/fsl,scu-pinctrl.yaml  | 2 +-
 Documentation/devicetree/bindings/power/fsl,scu-pd.yaml         | 2 +-
 Documentation/devicetree/bindings/riscv/cpus.yaml               | 2 +-
 Documentation/devicetree/bindings/rtc/fsl,scu-rtc.yaml          | 2 +-
 Documentation/devicetree/bindings/spi/omap-spi.yaml             | 2 +-
 Documentation/devicetree/bindings/thermal/fsl,scu-thermal.yaml  | 2 +-
 Documentation/devicetree/bindings/usb/usb-device.yaml           | 2 +-
 Documentation/devicetree/bindings/watchdog/fsl,scu-wdt.yaml     | 2 +-
 19 files changed, 19 insertions(+), 19 deletions(-)

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
index f2c48460a399..e617b6835bd0 100644
--- a/Documentation/devicetree/bindings/clock/fsl,scu-clk.yaml
+++ b/Documentation/devicetree/bindings/clock/fsl,scu-clk.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/fsl,scu-clk.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: i.MX SCU Client Device Node - Clock bindings based on SCU Message Protocol
+title: i.MX SCU Client Device Node - Clock Controller based on SCU Message Protocol
 
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
diff --git a/Documentation/devicetree/bindings/input/fsl,scu-key.yaml b/Documentation/devicetree/bindings/input/fsl,scu-key.yaml
index e6266d188266..67cf76bf554b 100644
--- a/Documentation/devicetree/bindings/input/fsl,scu-key.yaml
+++ b/Documentation/devicetree/bindings/input/fsl,scu-key.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/fsl,scu-key.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: i.MX SCU Client Device Node - SCU key bindings based on SCU Message Protocol
+title: i.MX SCU Client Device Node - SCU key based on SCU Message Protocol
 
 maintainers:
   - Dong Aisheng <aisheng.dong@nxp.com>
diff --git a/Documentation/devicetree/bindings/input/matrix-keymap.yaml b/Documentation/devicetree/bindings/input/matrix-keymap.yaml
index 6699d5e32dca..05d447e57384 100644
--- a/Documentation/devicetree/bindings/input/matrix-keymap.yaml
+++ b/Documentation/devicetree/bindings/input/matrix-keymap.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/matrix-keymap.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Common key matrices binding for matrix-connected key boards
+title: Common key matrices on matrix-connected key boards
 
 maintainers:
   - Olof Johansson <olof@lixom.net>
diff --git a/Documentation/devicetree/bindings/leds/issi,is31fl319x.yaml b/Documentation/devicetree/bindings/leds/issi,is31fl319x.yaml
index 940333f2d69c..66e2c3617d68 100644
--- a/Documentation/devicetree/bindings/leds/issi,is31fl319x.yaml
+++ b/Documentation/devicetree/bindings/leds/issi,is31fl319x.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/leds/issi,is31fl319x.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: ISSI LED controllers bindings for IS31FL319{0,1,3,6,9}
+title: ISSI LED controllers for IS31FL319{0,1,3,6,9}
 
 maintainers:
   - Vincent Knecht <vincent.knecht@mailoo.org>
diff --git a/Documentation/devicetree/bindings/net/asix,ax88178.yaml b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
index a81dbc4792f6..2e74bdb74208 100644
--- a/Documentation/devicetree/bindings/net/asix,ax88178.yaml
+++ b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/asix,ax88178.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: The device tree bindings for the USB Ethernet controllers
+title: ASIX AX88172/AX88772 USB Ethernet controllers
 
 maintainers:
   - Oleksij Rempel <o.rempel@pengutronix.de>
diff --git a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
index 3715c5f8f0e0..da2065d6c37e 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/microchip,lan95xx.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: The device tree bindings for the USB Ethernet controllers
+title: Microchip SMSC9500/LAN9530/LAN9730 USB Ethernet controllers
 
 maintainers:
   - Oleksij Rempel <o.rempel@pengutronix.de>
diff --git a/Documentation/devicetree/bindings/nvmem/fsl,scu-ocotp.yaml b/Documentation/devicetree/bindings/nvmem/fsl,scu-ocotp.yaml
index 682688299b26..b443b5228470 100644
--- a/Documentation/devicetree/bindings/nvmem/fsl,scu-ocotp.yaml
+++ b/Documentation/devicetree/bindings/nvmem/fsl,scu-ocotp.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/nvmem/fsl,scu-ocotp.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: i.MX SCU Client Device Node - OCOTP bindings based on SCU Message Protocol
+title: i.MX SCU Client Device Node - OCOTP based on SCU Message Protocol
 
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
index 45ea565ce238..297af8350299 100644
--- a/Documentation/devicetree/bindings/pinctrl/fsl,scu-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/fsl,scu-pinctrl.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/pinctrl/fsl,scu-pinctrl.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: i.MX SCU Client Device Node - Pinctrl bindings based on SCU Message Protocol
+title: i.MX SCU Client Device Node - Pinctrl based on SCU Message Protocol
 
 maintainers:
   - Dong Aisheng <aisheng.dong@nxp.com>
diff --git a/Documentation/devicetree/bindings/power/fsl,scu-pd.yaml b/Documentation/devicetree/bindings/power/fsl,scu-pd.yaml
index 1f72b18ca0fc..6bcd39f93268 100644
--- a/Documentation/devicetree/bindings/power/fsl,scu-pd.yaml
+++ b/Documentation/devicetree/bindings/power/fsl,scu-pd.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/power/fsl,scu-pd.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: i.MX SCU Client Device Node - Power domain bindings based on SCU Message Protocol
+title: i.MX SCU Client Device Node - Power domain based on SCU Message Protocol
 
 maintainers:
   - Dong Aisheng <aisheng.dong@nxp.com>
diff --git a/Documentation/devicetree/bindings/riscv/cpus.yaml b/Documentation/devicetree/bindings/riscv/cpus.yaml
index 2bf91829c8de..37de07c8291f 100644
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
index 8c102b70d735..00f7b12e2899 100644
--- a/Documentation/devicetree/bindings/rtc/fsl,scu-rtc.yaml
+++ b/Documentation/devicetree/bindings/rtc/fsl,scu-rtc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/rtc/fsl,scu-rtc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: i.MX SCU Client Device Node - RTC bindings based on SCU Message Protocol
+title: i.MX SCU Client Device Node - RTC based on SCU Message Protocol
 
 maintainers:
   - Dong Aisheng <aisheng.dong@nxp.com>
diff --git a/Documentation/devicetree/bindings/spi/omap-spi.yaml b/Documentation/devicetree/bindings/spi/omap-spi.yaml
index 9952199cae11..e0fd744e809b 100644
--- a/Documentation/devicetree/bindings/spi/omap-spi.yaml
+++ b/Documentation/devicetree/bindings/spi/omap-spi.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/spi/omap-spi.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: SPI controller bindings for OMAP and K3 SoCs
+title: SPI controller on OMAP and K3 SoCs
 
 maintainers:
   - Aswath Govindraju <a-govindraju@ti.com>
diff --git a/Documentation/devicetree/bindings/thermal/fsl,scu-thermal.yaml b/Documentation/devicetree/bindings/thermal/fsl,scu-thermal.yaml
index f9e4b3c8d0ee..d574a0c649f5 100644
--- a/Documentation/devicetree/bindings/thermal/fsl,scu-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/fsl,scu-thermal.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/thermal/fsl,scu-thermal.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: i.MX SCU Client Device Node - Thermal bindings based on SCU Message Protocol
+title: i.MX SCU Client Device Node - Thermal based on SCU Message Protocol
 
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
index f84c45d687d7..092e258544ec 100644
--- a/Documentation/devicetree/bindings/watchdog/fsl,scu-wdt.yaml
+++ b/Documentation/devicetree/bindings/watchdog/fsl,scu-wdt.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/watchdog/fsl,scu-wdt.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: i.MX SCU Client Device Node - Watchdog bindings based on SCU Message Protocol
+title: i.MX SCU Client Device Node - Watchdog based on SCU Message Protocol
 
 maintainers:
   - Dong Aisheng <aisheng.dong@nxp.com>
-- 
2.34.1

