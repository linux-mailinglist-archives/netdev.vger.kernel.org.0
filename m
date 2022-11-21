Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B72F631F7F
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiKULId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiKULHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:07:00 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71832B482E
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:06:37 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id j16so18244212lfe.12
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QrnC6C9JHSD40BwwFaPwVjH6GOzvtXf9kxCHOCB8904=;
        b=WbvZZW60vAADtSEFlq6wlXlBwMNO8tFukvPkw2JQajbHCW8iRq/BWXafQEgD1m8+O7
         owf8ftkMdZQg2+XLOqnGgSTIcLQPyZuZNhZTJhqYxEC7zgYEkvv+8roCpiPUwBzdN3Ay
         E3/T6T1MvOAHkuLAY+WA3K2Nt3kR5+teHKZ7bA/AKJcvvLUj92XixXmKSGkyJNzPDhL3
         1OO9a9REzZnd7uxGuWL9iGcP9g1OfZ7VwNF0eeZwT/B3PBDPUQ5iF6u2eq9kyq7IDyr/
         Xa4xsUimHdK9I/lz5+hPjeBpSVMIuYnwxq+vDlosTYpQzzNetbjSPGL83Sf5byeSHMXs
         sh2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QrnC6C9JHSD40BwwFaPwVjH6GOzvtXf9kxCHOCB8904=;
        b=f6762AYvfl00nkrZH9cAXnFjc2UsIz1zbWpidR2DpGeF3Fr3THzm5CPM68JNN5vodY
         JNa/7bbeKN0AJJvix8ooUCL2VIE0J3CEDvMPewZXJ8TMQifWrPFcQ8KhWSDdu5RRgFea
         mY4nfHHXQ8MEQPbBTm7IBtSuOqawHTRRKtbqGH+HOgH1/zy7gHC1hjQ+YHSrKn+oQ0MV
         sc7iFuN3YvI7UGvMTZikhBBkMfMQ5N+2PWJ8kQgN83MGAQlro4MpgaElJD732+0vU9ab
         TmMImGni92WE7GVwx9ipbS3VXRG2BQftG0PEwpWeG8cpSEcKYrBP9SBw/b80JCYUGa97
         b5EA==
X-Gm-Message-State: ANoB5pl8JaaF0jUROkjIsMoaEZuxbNNU3G71s8xsZYg9dUPHOfNUBwwl
        bLeO3Dto7yjdekDNP9iYlh8oxA==
X-Google-Smtp-Source: AA0mqf6mdIymmDY3rXv6NZfMD+24uN1io5lLvkQfW4kAU6d3MO1sFYXi1Sy7gCvugvbmy23by5cKnw==
X-Received: by 2002:ac2:4e88:0:b0:4a6:fa2a:275b with SMTP id o8-20020ac24e88000000b004a6fa2a275bmr2702537lfr.87.1669028796696;
        Mon, 21 Nov 2022 03:06:36 -0800 (PST)
Received: from krzk-bin.NAT.warszawa.vectranet.pl (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id n1-20020a05651203e100b0049313f77755sm1991521lfq.213.2022.11.21.03.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 03:06:35 -0800 (PST)
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
Subject: [PATCH v2 7/9] dt-bindings: drop redundant part of title (beginning)
Date:   Mon, 21 Nov 2022 12:06:13 +0100
Message-Id: <20221121110615.97962-8-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Drop beginning "Devicetree bindings" in various forms:

  find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
    -exec sed -i -e 's/^title: [dD]evice[ -]\?[tT]ree [bB]indings\? for \([tT]he \)\?\(.*\)$/title: \u\2/' {} \;

  find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
    -exec sed -i -e 's/^title: [bB]indings\? for \([tT]he \)\?\(.*\)$/title: \u\2/' {} \;

  find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
    -exec sed -i -e 's/^title: [dD][tT] [bB]indings\? for \([tT]he \)\?\(.*\)$/title: \u\2/' {} \;

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml     | 2 +-
 Documentation/devicetree/bindings/clock/fixed-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/fixed-factor-clock.yaml | 2 +-
 Documentation/devicetree/bindings/clock/fixed-mmio-clock.yaml   | 2 +-
 Documentation/devicetree/bindings/clock/idt,versaclock5.yaml    | 2 +-
 Documentation/devicetree/bindings/clock/renesas,9series.yaml    | 2 +-
 Documentation/devicetree/bindings/clock/ti/ti,clksel.yaml       | 2 +-
 .../devicetree/bindings/display/bridge/ingenic,jz4780-hdmi.yaml | 2 +-
 .../devicetree/bindings/display/bridge/intel,keembay-dsi.yaml   | 2 +-
 .../devicetree/bindings/display/intel,keembay-display.yaml      | 2 +-
 .../devicetree/bindings/display/intel,keembay-msscam.yaml       | 2 +-
 Documentation/devicetree/bindings/display/msm/gmu.yaml          | 2 +-
 Documentation/devicetree/bindings/display/msm/gpu.yaml          | 2 +-
 .../devicetree/bindings/display/panel/olimex,lcd-olinuxino.yaml | 2 +-
 .../devicetree/bindings/gpu/host1x/nvidia,tegra210-nvdec.yaml   | 2 +-
 .../devicetree/bindings/gpu/host1x/nvidia,tegra210-nvenc.yaml   | 2 +-
 .../devicetree/bindings/gpu/host1x/nvidia,tegra210-nvjpg.yaml   | 2 +-
 .../devicetree/bindings/gpu/host1x/nvidia,tegra234-nvdec.yaml   | 2 +-
 Documentation/devicetree/bindings/i2c/i2c-gpio.yaml             | 2 +-
 Documentation/devicetree/bindings/i2c/ti,omap4-i2c.yaml         | 2 +-
 .../devicetree/bindings/iio/adc/sigma-delta-modulator.yaml      | 2 +-
 Documentation/devicetree/bindings/input/gpio-keys.yaml          | 2 +-
 Documentation/devicetree/bindings/input/microchip,cap11xx.yaml  | 2 +-
 .../devicetree/bindings/interrupt-controller/renesas,irqc.yaml  | 2 +-
 Documentation/devicetree/bindings/leds/backlight/qcom-wled.yaml | 2 +-
 Documentation/devicetree/bindings/leds/register-bit-led.yaml    | 2 +-
 Documentation/devicetree/bindings/leds/regulator-led.yaml       | 2 +-
 Documentation/devicetree/bindings/mips/ingenic/ingenic,cpu.yaml | 2 +-
 Documentation/devicetree/bindings/mmc/arasan,sdhci.yaml         | 2 +-
 Documentation/devicetree/bindings/net/ingenic,mac.yaml          | 2 +-
 Documentation/devicetree/bindings/power/supply/bq2415x.yaml     | 2 +-
 Documentation/devicetree/bindings/power/supply/bq24190.yaml     | 2 +-
 Documentation/devicetree/bindings/power/supply/bq24257.yaml     | 2 +-
 Documentation/devicetree/bindings/power/supply/bq24735.yaml     | 2 +-
 Documentation/devicetree/bindings/power/supply/bq25890.yaml     | 2 +-
 Documentation/devicetree/bindings/power/supply/isp1704.yaml     | 2 +-
 .../devicetree/bindings/power/supply/lltc,ltc294x.yaml          | 2 +-
 .../devicetree/bindings/power/supply/richtek,rt9455.yaml        | 2 +-
 Documentation/devicetree/bindings/power/supply/ti,lp8727.yaml   | 2 +-
 Documentation/devicetree/bindings/regulator/pwm-regulator.yaml  | 2 +-
 Documentation/devicetree/bindings/rng/ingenic,rng.yaml          | 2 +-
 Documentation/devicetree/bindings/rng/ingenic,trng.yaml         | 2 +-
 Documentation/devicetree/bindings/serial/8250_omap.yaml         | 2 +-
 Documentation/devicetree/bindings/serio/ps2-gpio.yaml           | 2 +-
 Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml       | 2 +-
 Documentation/devicetree/bindings/sound/qcom,wcd938x-sdw.yaml   | 2 +-
 Documentation/devicetree/bindings/sound/qcom,wcd938x.yaml       | 2 +-
 Documentation/devicetree/bindings/sound/qcom,wsa881x.yaml       | 2 +-
 Documentation/devicetree/bindings/sound/qcom,wsa883x.yaml       | 2 +-
 Documentation/devicetree/bindings/timer/ingenic,sysost.yaml     | 2 +-
 Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml    | 2 +-
 Documentation/devicetree/bindings/usb/realtek,rts5411.yaml      | 2 +-
 Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml         | 2 +-
 Documentation/devicetree/bindings/usb/ti,usb8041.yaml           | 2 +-
 54 files changed, 54 insertions(+), 54 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml b/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml
index 983033fe5b17..5e942bccf277 100644
--- a/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml
+++ b/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/adi,axi-clkgen.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for Analog Devices AXI clkgen pcore clock generator
+title: Analog Devices AXI clkgen pcore clock generator
 
 maintainers:
   - Lars-Peter Clausen <lars@metafoo.de>
diff --git a/Documentation/devicetree/bindings/clock/fixed-clock.yaml b/Documentation/devicetree/bindings/clock/fixed-clock.yaml
index b657ecd0ef1c..b0a4fb8256e2 100644
--- a/Documentation/devicetree/bindings/clock/fixed-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/fixed-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/fixed-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for simple fixed-rate clock sources
+title: Simple fixed-rate clock sources
 
 maintainers:
   - Michael Turquette <mturquette@baylibre.com>
diff --git a/Documentation/devicetree/bindings/clock/fixed-factor-clock.yaml b/Documentation/devicetree/bindings/clock/fixed-factor-clock.yaml
index 0b02378a3a0c..8f71ab300470 100644
--- a/Documentation/devicetree/bindings/clock/fixed-factor-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/fixed-factor-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/fixed-factor-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for simple fixed factor rate clock sources
+title: Simple fixed factor rate clock sources
 
 maintainers:
   - Michael Turquette <mturquette@baylibre.com>
diff --git a/Documentation/devicetree/bindings/clock/fixed-mmio-clock.yaml b/Documentation/devicetree/bindings/clock/fixed-mmio-clock.yaml
index 1453ac849a65..e22fc272d023 100644
--- a/Documentation/devicetree/bindings/clock/fixed-mmio-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/fixed-mmio-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/fixed-mmio-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for simple memory mapped IO fixed-rate clock sources
+title: Simple memory mapped IO fixed-rate clock sources
 
 description:
   This binding describes a fixed-rate clock for which the frequency can
diff --git a/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml b/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
index f9ba9864d8b5..61b246cf5e72 100644
--- a/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
+++ b/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/idt,versaclock5.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for IDT VersaClock 5 and 6 programmable I2C clock generators
+title: IDT VersaClock 5 and 6 programmable I2C clock generators
 
 description: |
   The IDT VersaClock 5 and VersaClock 6 are programmable I2C
diff --git a/Documentation/devicetree/bindings/clock/renesas,9series.yaml b/Documentation/devicetree/bindings/clock/renesas,9series.yaml
index 102eb95cb3fc..6b6cec3fba52 100644
--- a/Documentation/devicetree/bindings/clock/renesas,9series.yaml
+++ b/Documentation/devicetree/bindings/clock/renesas,9series.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/renesas,9series.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for Renesas 9-series I2C PCIe clock generators
+title: Renesas 9-series I2C PCIe clock generators
 
 description: |
   The Renesas 9-series are I2C PCIe clock generators providing
diff --git a/Documentation/devicetree/bindings/clock/ti/ti,clksel.yaml b/Documentation/devicetree/bindings/clock/ti/ti,clksel.yaml
index c56f911fff47..d525f96cf244 100644
--- a/Documentation/devicetree/bindings/clock/ti/ti,clksel.yaml
+++ b/Documentation/devicetree/bindings/clock/ti/ti,clksel.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/ti/ti,clksel.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for TI clksel clock
+title: TI clksel clock
 
 maintainers:
   - Tony Lindgren <tony@atomide.com>
diff --git a/Documentation/devicetree/bindings/display/bridge/ingenic,jz4780-hdmi.yaml b/Documentation/devicetree/bindings/display/bridge/ingenic,jz4780-hdmi.yaml
index 89490fdffeb0..0b27df429bdc 100644
--- a/Documentation/devicetree/bindings/display/bridge/ingenic,jz4780-hdmi.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/ingenic,jz4780-hdmi.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/display/bridge/ingenic,jz4780-hdmi.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bindings for Ingenic JZ4780 HDMI Transmitter
+title: Ingenic JZ4780 HDMI Transmitter
 
 maintainers:
   - H. Nikolaus Schaller <hns@goldelico.com>
diff --git a/Documentation/devicetree/bindings/display/bridge/intel,keembay-dsi.yaml b/Documentation/devicetree/bindings/display/bridge/intel,keembay-dsi.yaml
index dcb1336ee2a5..958a073f4ff7 100644
--- a/Documentation/devicetree/bindings/display/bridge/intel,keembay-dsi.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/intel,keembay-dsi.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/display/bridge/intel,keembay-dsi.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Devicetree bindings for Intel Keem Bay mipi dsi controller
+title: Intel Keem Bay mipi dsi controller
 
 maintainers:
   - Anitha Chrisanthus <anitha.chrisanthus@intel.com>
diff --git a/Documentation/devicetree/bindings/display/intel,keembay-display.yaml b/Documentation/devicetree/bindings/display/intel,keembay-display.yaml
index bc6622b010ca..2cf54ecc707a 100644
--- a/Documentation/devicetree/bindings/display/intel,keembay-display.yaml
+++ b/Documentation/devicetree/bindings/display/intel,keembay-display.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/display/intel,keembay-display.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Devicetree bindings for Intel Keem Bay display controller
+title: Intel Keem Bay display controller
 
 maintainers:
   - Anitha Chrisanthus <anitha.chrisanthus@intel.com>
diff --git a/Documentation/devicetree/bindings/display/intel,keembay-msscam.yaml b/Documentation/devicetree/bindings/display/intel,keembay-msscam.yaml
index a222b52d8b8f..cc7e1f318fe4 100644
--- a/Documentation/devicetree/bindings/display/intel,keembay-msscam.yaml
+++ b/Documentation/devicetree/bindings/display/intel,keembay-msscam.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/display/intel,keembay-msscam.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Devicetree bindings for Intel Keem Bay MSSCAM
+title: Intel Keem Bay MSSCAM
 
 maintainers:
   - Anitha Chrisanthus <anitha.chrisanthus@intel.com>
diff --git a/Documentation/devicetree/bindings/display/msm/gmu.yaml b/Documentation/devicetree/bindings/display/msm/gmu.yaml
index 67fdeeabae0c..ab14e81cb050 100644
--- a/Documentation/devicetree/bindings/display/msm/gmu.yaml
+++ b/Documentation/devicetree/bindings/display/msm/gmu.yaml
@@ -6,7 +6,7 @@
 $id: "http://devicetree.org/schemas/display/msm/gmu.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Devicetree bindings for the GMU attached to certain Adreno GPUs
+title: GMU attached to certain Adreno GPUs
 
 maintainers:
   - Rob Clark <robdclark@gmail.com>
diff --git a/Documentation/devicetree/bindings/display/msm/gpu.yaml b/Documentation/devicetree/bindings/display/msm/gpu.yaml
index ec4b1a75f46a..c5f49842dc7b 100644
--- a/Documentation/devicetree/bindings/display/msm/gpu.yaml
+++ b/Documentation/devicetree/bindings/display/msm/gpu.yaml
@@ -5,7 +5,7 @@
 $id: "http://devicetree.org/schemas/display/msm/gpu.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Devicetree bindings for the Adreno or Snapdragon GPUs
+title: Adreno or Snapdragon GPUs
 
 maintainers:
   - Rob Clark <robdclark@gmail.com>
diff --git a/Documentation/devicetree/bindings/display/panel/olimex,lcd-olinuxino.yaml b/Documentation/devicetree/bindings/display/panel/olimex,lcd-olinuxino.yaml
index 2329d9610f83..9f97598efdfa 100644
--- a/Documentation/devicetree/bindings/display/panel/olimex,lcd-olinuxino.yaml
+++ b/Documentation/devicetree/bindings/display/panel/olimex,lcd-olinuxino.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/display/panel/olimex,lcd-olinuxino.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for Olimex Ltd. LCD-OLinuXino bridge panel.
+title: Olimex Ltd. LCD-OLinuXino bridge panel.
 
 maintainers:
   - Stefan Mavrodiev <stefan@olimex.com>
diff --git a/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra210-nvdec.yaml b/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra210-nvdec.yaml
index 3cf862976448..ed9554c837ef 100644
--- a/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra210-nvdec.yaml
+++ b/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra210-nvdec.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/gpu/host1x/nvidia,tegra210-nvdec.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Device tree binding for NVIDIA Tegra NVDEC
+title: NVIDIA Tegra NVDEC
 
 description: |
   NVDEC is the hardware video decoder present on NVIDIA Tegra210
diff --git a/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra210-nvenc.yaml b/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra210-nvenc.yaml
index e63ae1a00818..8199e5fa8211 100644
--- a/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra210-nvenc.yaml
+++ b/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra210-nvenc.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/gpu/host1x/nvidia,tegra210-nvenc.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Device tree binding for NVIDIA Tegra NVENC
+title: NVIDIA Tegra NVENC
 
 description: |
   NVENC is the hardware video encoder present on NVIDIA Tegra210
diff --git a/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra210-nvjpg.yaml b/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra210-nvjpg.yaml
index 8647404d67e4..895fb346ac72 100644
--- a/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra210-nvjpg.yaml
+++ b/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra210-nvjpg.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/gpu/host1x/nvidia,tegra210-nvjpg.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Device tree binding for NVIDIA Tegra NVJPG
+title: NVIDIA Tegra NVJPG
 
 description: |
   NVJPG is the hardware JPEG decoder and encoder present on NVIDIA Tegra210
diff --git a/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra234-nvdec.yaml b/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra234-nvdec.yaml
index 7cc2dd525a96..4bdc19a2bccf 100644
--- a/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra234-nvdec.yaml
+++ b/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra234-nvdec.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/gpu/host1x/nvidia,tegra234-nvdec.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Device tree binding for NVIDIA Tegra234 NVDEC
+title: NVIDIA Tegra234 NVDEC
 
 description: |
   NVDEC is the hardware video decoder present on NVIDIA Tegra210
diff --git a/Documentation/devicetree/bindings/i2c/i2c-gpio.yaml b/Documentation/devicetree/bindings/i2c/i2c-gpio.yaml
index fd040284561f..e0d76d5eb103 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-gpio.yaml
+++ b/Documentation/devicetree/bindings/i2c/i2c-gpio.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/i2c/i2c-gpio.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bindings for GPIO bitbanged I2C
+title: GPIO bitbanged I2C
 
 maintainers:
   - Wolfram Sang <wsa@kernel.org>
diff --git a/Documentation/devicetree/bindings/i2c/ti,omap4-i2c.yaml b/Documentation/devicetree/bindings/i2c/ti,omap4-i2c.yaml
index db0843be91c5..781108ae1ce3 100644
--- a/Documentation/devicetree/bindings/i2c/ti,omap4-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/ti,omap4-i2c.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/i2c/ti,omap4-i2c.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bindings for I2C controllers on TI's OMAP and K3 SoCs
+title: I2C controllers on TI's OMAP and K3 SoCs
 
 maintainers:
   - Vignesh Raghavendra <vigneshr@ti.com>
diff --git a/Documentation/devicetree/bindings/iio/adc/sigma-delta-modulator.yaml b/Documentation/devicetree/bindings/iio/adc/sigma-delta-modulator.yaml
index 2287697f1f61..cab0d425eaa4 100644
--- a/Documentation/devicetree/bindings/iio/adc/sigma-delta-modulator.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/sigma-delta-modulator.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/iio/adc/sigma-delta-modulator.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Device-Tree bindings for sigma delta modulator
+title: Sigma delta modulator
 
 maintainers:
   - Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
diff --git a/Documentation/devicetree/bindings/input/gpio-keys.yaml b/Documentation/devicetree/bindings/input/gpio-keys.yaml
index 17ac9dff7972..159cd9d9fe57 100644
--- a/Documentation/devicetree/bindings/input/gpio-keys.yaml
+++ b/Documentation/devicetree/bindings/input/gpio-keys.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/gpio-keys.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Device-Tree bindings for GPIO attached keys
+title: GPIO attached keys
 
 maintainers:
   - Rob Herring <robh@kernel.org>
diff --git a/Documentation/devicetree/bindings/input/microchip,cap11xx.yaml b/Documentation/devicetree/bindings/input/microchip,cap11xx.yaml
index 96358b12f9b2..67d4d8f86a2d 100644
--- a/Documentation/devicetree/bindings/input/microchip,cap11xx.yaml
+++ b/Documentation/devicetree/bindings/input/microchip,cap11xx.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/input/microchip,cap11xx.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Device tree bindings for Microchip CAP11xx based capacitive touch sensors
+title: Microchip CAP11xx based capacitive touch sensors
 
 description: |
   The Microchip CAP1xxx Family of RightTouchTM multiple-channel capacitive
diff --git a/Documentation/devicetree/bindings/interrupt-controller/renesas,irqc.yaml b/Documentation/devicetree/bindings/interrupt-controller/renesas,irqc.yaml
index 62fd47c88275..95033cb514fb 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/renesas,irqc.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/renesas,irqc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/interrupt-controller/renesas,irqc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: DT bindings for the R-Mobile/R-Car/RZ/G interrupt controller
+title: R-Mobile/R-Car/RZ/G interrupt controller
 
 maintainers:
   - Geert Uytterhoeven <geert+renesas@glider.be>
diff --git a/Documentation/devicetree/bindings/leds/backlight/qcom-wled.yaml b/Documentation/devicetree/bindings/leds/backlight/qcom-wled.yaml
index 5ac8605a53b1..5f1849bdabba 100644
--- a/Documentation/devicetree/bindings/leds/backlight/qcom-wled.yaml
+++ b/Documentation/devicetree/bindings/leds/backlight/qcom-wled.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/leds/backlight/qcom-wled.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for Qualcomm Technologies, Inc. WLED driver
+title: Qualcomm Technologies, Inc. WLED driver
 
 maintainers:
   - Bjorn Andersson <bjorn.andersson@linaro.org>
diff --git a/Documentation/devicetree/bindings/leds/register-bit-led.yaml b/Documentation/devicetree/bindings/leds/register-bit-led.yaml
index 79b8fc0f9d23..ed26ec19ecbd 100644
--- a/Documentation/devicetree/bindings/leds/register-bit-led.yaml
+++ b/Documentation/devicetree/bindings/leds/register-bit-led.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/leds/register-bit-led.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Device Tree Bindings for Register Bit LEDs
+title: Register Bit LEDs
 
 maintainers:
   - Linus Walleij <linus.walleij@linaro.org>
diff --git a/Documentation/devicetree/bindings/leds/regulator-led.yaml b/Documentation/devicetree/bindings/leds/regulator-led.yaml
index 3e020d700c00..4ef7b96e9a08 100644
--- a/Documentation/devicetree/bindings/leds/regulator-led.yaml
+++ b/Documentation/devicetree/bindings/leds/regulator-led.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/leds/regulator-led.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Device Tree Bindings for Regulator LEDs
+title: Regulator LEDs
 
 maintainers:
   - Linus Walleij <linus.walleij@linaro.org>
diff --git a/Documentation/devicetree/bindings/mips/ingenic/ingenic,cpu.yaml b/Documentation/devicetree/bindings/mips/ingenic/ingenic,cpu.yaml
index b7e7fa715437..9265a27037cb 100644
--- a/Documentation/devicetree/bindings/mips/ingenic/ingenic,cpu.yaml
+++ b/Documentation/devicetree/bindings/mips/ingenic/ingenic,cpu.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mips/ingenic/ingenic,cpu.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bindings for Ingenic XBurst family CPUs
+title: Ingenic XBurst family CPUs
 
 maintainers:
   - 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
diff --git a/Documentation/devicetree/bindings/mmc/arasan,sdhci.yaml b/Documentation/devicetree/bindings/mmc/arasan,sdhci.yaml
index 83be9e93d221..4053de758db6 100644
--- a/Documentation/devicetree/bindings/mmc/arasan,sdhci.yaml
+++ b/Documentation/devicetree/bindings/mmc/arasan,sdhci.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/mmc/arasan,sdhci.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Device Tree Bindings for the Arasan SDHCI Controller
+title: Arasan SDHCI Controller
 
 maintainers:
   - Adrian Hunter <adrian.hunter@intel.com>
diff --git a/Documentation/devicetree/bindings/net/ingenic,mac.yaml b/Documentation/devicetree/bindings/net/ingenic,mac.yaml
index 93b3e991d209..bdea101c2f75 100644
--- a/Documentation/devicetree/bindings/net/ingenic,mac.yaml
+++ b/Documentation/devicetree/bindings/net/ingenic,mac.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/ingenic,mac.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bindings for MAC in Ingenic SoCs
+title: MAC in Ingenic SoCs
 
 maintainers:
   - 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
diff --git a/Documentation/devicetree/bindings/power/supply/bq2415x.yaml b/Documentation/devicetree/bindings/power/supply/bq2415x.yaml
index a3c00e078918..f7287ffd4b12 100644
--- a/Documentation/devicetree/bindings/power/supply/bq2415x.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq2415x.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/power/supply/bq2415x.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for TI bq2415x Li-Ion Charger
+title: TI bq2415x Li-Ion Charger
 
 maintainers:
   - Sebastian Reichel <sre@kernel.org>
diff --git a/Documentation/devicetree/bindings/power/supply/bq24190.yaml b/Documentation/devicetree/bindings/power/supply/bq24190.yaml
index 4884ec90e2b8..001c0ffb408d 100644
--- a/Documentation/devicetree/bindings/power/supply/bq24190.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq24190.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/power/supply/bq24190.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for TI BQ2419x Li-Ion Battery Charger
+title: TI BQ2419x Li-Ion Battery Charger
 
 maintainers:
   - Sebastian Reichel <sre@kernel.org>
diff --git a/Documentation/devicetree/bindings/power/supply/bq24257.yaml b/Documentation/devicetree/bindings/power/supply/bq24257.yaml
index c7406bef0fa8..cc45939d385b 100644
--- a/Documentation/devicetree/bindings/power/supply/bq24257.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq24257.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/power/supply/bq24257.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for bq24250, bq24251 and bq24257 Li-Ion Charger
+title: Bq24250, bq24251 and bq24257 Li-Ion Charger
 
 maintainers:
   - Sebastian Reichel <sre@kernel.org>
diff --git a/Documentation/devicetree/bindings/power/supply/bq24735.yaml b/Documentation/devicetree/bindings/power/supply/bq24735.yaml
index dd9176ce71b3..388ee16f8a1e 100644
--- a/Documentation/devicetree/bindings/power/supply/bq24735.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq24735.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/power/supply/bq24735.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for TI BQ24735 Li-Ion Battery Charger
+title: TI BQ24735 Li-Ion Battery Charger
 
 maintainers:
   - Sebastian Reichel <sre@kernel.org>
diff --git a/Documentation/devicetree/bindings/power/supply/bq25890.yaml b/Documentation/devicetree/bindings/power/supply/bq25890.yaml
index ee51b6335e72..dae27e93af09 100644
--- a/Documentation/devicetree/bindings/power/supply/bq25890.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq25890.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/power/supply/bq25890.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for bq25890, bq25892, bq25895 and bq25896 Li-Ion Charger
+title: Bq25890, bq25892, bq25895 and bq25896 Li-Ion Charger
 
 maintainers:
   - Sebastian Reichel <sre@kernel.org>
diff --git a/Documentation/devicetree/bindings/power/supply/isp1704.yaml b/Documentation/devicetree/bindings/power/supply/isp1704.yaml
index 7e3449ed70d4..fb3a812aa5a9 100644
--- a/Documentation/devicetree/bindings/power/supply/isp1704.yaml
+++ b/Documentation/devicetree/bindings/power/supply/isp1704.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/power/supply/isp1704.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for NXP ISP1704 USB Charger Detection
+title: NXP ISP1704 USB Charger Detection
 
 maintainers:
   - Sebastian Reichel <sre@kernel.org>
diff --git a/Documentation/devicetree/bindings/power/supply/lltc,ltc294x.yaml b/Documentation/devicetree/bindings/power/supply/lltc,ltc294x.yaml
index 109b41a0d56c..774582cd3a2c 100644
--- a/Documentation/devicetree/bindings/power/supply/lltc,ltc294x.yaml
+++ b/Documentation/devicetree/bindings/power/supply/lltc,ltc294x.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/power/supply/lltc,ltc294x.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for LTC2941, LTC2942, LTC2943 and LTC2944 battery fuel gauges
+title: LTC2941, LTC2942, LTC2943 and LTC2944 battery fuel gauges
 
 description: |
   All chips measure battery capacity.
diff --git a/Documentation/devicetree/bindings/power/supply/richtek,rt9455.yaml b/Documentation/devicetree/bindings/power/supply/richtek,rt9455.yaml
index bce15101318e..27bebc1757ba 100644
--- a/Documentation/devicetree/bindings/power/supply/richtek,rt9455.yaml
+++ b/Documentation/devicetree/bindings/power/supply/richtek,rt9455.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/power/supply/richtek,rt9455.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for Richtek rt9455 battery charger
+title: Richtek rt9455 battery charger
 
 maintainers:
   - Sebastian Reichel <sre@kernel.org>
diff --git a/Documentation/devicetree/bindings/power/supply/ti,lp8727.yaml b/Documentation/devicetree/bindings/power/supply/ti,lp8727.yaml
index 93654e732cda..ce6fbdba8f6b 100644
--- a/Documentation/devicetree/bindings/power/supply/ti,lp8727.yaml
+++ b/Documentation/devicetree/bindings/power/supply/ti,lp8727.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/power/supply/ti,lp8727.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for TI/National Semiconductor LP8727 Charger
+title: TI/National Semiconductor LP8727 Charger
 
 maintainers:
   - Sebastian Reichel <sre@kernel.org>
diff --git a/Documentation/devicetree/bindings/regulator/pwm-regulator.yaml b/Documentation/devicetree/bindings/regulator/pwm-regulator.yaml
index 82b6f2fde422..7e58471097f8 100644
--- a/Documentation/devicetree/bindings/regulator/pwm-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/pwm-regulator.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/regulator/pwm-regulator.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bindings for the Generic PWM Regulator
+title: Generic PWM Regulator
 
 maintainers:
   - Brian Norris <briannorris@chromium.org>
diff --git a/Documentation/devicetree/bindings/rng/ingenic,rng.yaml b/Documentation/devicetree/bindings/rng/ingenic,rng.yaml
index b2e4a6a7f93a..79a023cbfdba 100644
--- a/Documentation/devicetree/bindings/rng/ingenic,rng.yaml
+++ b/Documentation/devicetree/bindings/rng/ingenic,rng.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/rng/ingenic,rng.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bindings for RNG in Ingenic SoCs
+title: RNG in Ingenic SoCs
 
 maintainers:
   - 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
diff --git a/Documentation/devicetree/bindings/rng/ingenic,trng.yaml b/Documentation/devicetree/bindings/rng/ingenic,trng.yaml
index 044d9a065650..acaeb63caf24 100644
--- a/Documentation/devicetree/bindings/rng/ingenic,trng.yaml
+++ b/Documentation/devicetree/bindings/rng/ingenic,trng.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/rng/ingenic,trng.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bindings for DTRNG in Ingenic SoCs
+title: DTRNG in Ingenic SoCs
 
 maintainers:
   - 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
diff --git a/Documentation/devicetree/bindings/serial/8250_omap.yaml b/Documentation/devicetree/bindings/serial/8250_omap.yaml
index 7b34ec8fa90e..53dc1212ad2e 100644
--- a/Documentation/devicetree/bindings/serial/8250_omap.yaml
+++ b/Documentation/devicetree/bindings/serial/8250_omap.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/serial/8250_omap.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bindings for 8250 compliant UARTs on TI's OMAP2+ and K3 SoCs
+title: 8250 compliant UARTs on TI's OMAP2+ and K3 SoCs
 
 maintainers:
   - Vignesh Raghavendra <vigneshr@ti.com>
diff --git a/Documentation/devicetree/bindings/serio/ps2-gpio.yaml b/Documentation/devicetree/bindings/serio/ps2-gpio.yaml
index a63d9172346f..99848bc34f6e 100644
--- a/Documentation/devicetree/bindings/serio/ps2-gpio.yaml
+++ b/Documentation/devicetree/bindings/serio/ps2-gpio.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/serio/ps2-gpio.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bindings for GPIO based PS/2
+title: GPIO based PS/2
 
 maintainers:
   - Danilo Krummrich <danilokrummrich@dk-develop.de>
diff --git a/Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml b/Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
index 8ca19f2b0b3d..184e8ccbdd13 100644
--- a/Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
+++ b/Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/sound/qcom,wcd934x.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bindings for Qualcomm WCD9340/WCD9341 Audio Codec
+title: Qualcomm WCD9340/WCD9341 Audio Codec
 
 maintainers:
   - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
diff --git a/Documentation/devicetree/bindings/sound/qcom,wcd938x-sdw.yaml b/Documentation/devicetree/bindings/sound/qcom,wcd938x-sdw.yaml
index 49a267b306f6..b430dd3e1841 100644
--- a/Documentation/devicetree/bindings/sound/qcom,wcd938x-sdw.yaml
+++ b/Documentation/devicetree/bindings/sound/qcom,wcd938x-sdw.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/sound/qcom,wcd938x-sdw.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bindings for Qualcomm SoundWire Slave devices on WCD9380/WCD9385
+title: Qualcomm SoundWire Slave devices on WCD9380/WCD9385
 
 maintainers:
   - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
diff --git a/Documentation/devicetree/bindings/sound/qcom,wcd938x.yaml b/Documentation/devicetree/bindings/sound/qcom,wcd938x.yaml
index 51547190f709..cfb4b800789d 100644
--- a/Documentation/devicetree/bindings/sound/qcom,wcd938x.yaml
+++ b/Documentation/devicetree/bindings/sound/qcom,wcd938x.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/sound/qcom,wcd938x.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bindings for Qualcomm WCD9380/WCD9385 Audio Codec
+title: Qualcomm WCD9380/WCD9385 Audio Codec
 
 maintainers:
   - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
diff --git a/Documentation/devicetree/bindings/sound/qcom,wsa881x.yaml b/Documentation/devicetree/bindings/sound/qcom,wsa881x.yaml
index ea44d03e58ca..d702b489320f 100644
--- a/Documentation/devicetree/bindings/sound/qcom,wsa881x.yaml
+++ b/Documentation/devicetree/bindings/sound/qcom,wsa881x.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/sound/qcom,wsa881x.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bindings for Qualcomm WSA8810/WSA8815 Class-D Smart Speaker Amplifier
+title: Qualcomm WSA8810/WSA8815 Class-D Smart Speaker Amplifier
 
 maintainers:
   - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
diff --git a/Documentation/devicetree/bindings/sound/qcom,wsa883x.yaml b/Documentation/devicetree/bindings/sound/qcom,wsa883x.yaml
index 99f9c10bbc83..3a29f822132d 100644
--- a/Documentation/devicetree/bindings/sound/qcom,wsa883x.yaml
+++ b/Documentation/devicetree/bindings/sound/qcom,wsa883x.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/sound/qcom,wsa883x.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bindings for The Qualcomm WSA8830/WSA8832/WSA8835
+title: Qualcomm WSA8830/WSA8832/WSA8835
   smart speaker amplifier
 
 maintainers:
diff --git a/Documentation/devicetree/bindings/timer/ingenic,sysost.yaml b/Documentation/devicetree/bindings/timer/ingenic,sysost.yaml
index 98648bf9e151..bdc82d8bce0e 100644
--- a/Documentation/devicetree/bindings/timer/ingenic,sysost.yaml
+++ b/Documentation/devicetree/bindings/timer/ingenic,sysost.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/timer/ingenic,sysost.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bindings for SYSOST in Ingenic XBurst family SoCs
+title: SYSOST in Ingenic XBurst family SoCs
 
 maintainers:
   - 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml b/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml
index fd6e7c81426e..f6cb19efd98b 100644
--- a/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml
+++ b/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/usb/nvidia,tegra-xudc.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Device tree binding for NVIDIA Tegra XUSB device mode controller (XUDC)
+title: NVIDIA Tegra XUSB device mode controller (XUDC)
 
 description:
   The Tegra XUDC controller supports both USB 2.0 HighSpeed/FullSpeed and
diff --git a/Documentation/devicetree/bindings/usb/realtek,rts5411.yaml b/Documentation/devicetree/bindings/usb/realtek,rts5411.yaml
index 50f2b505bdeb..623d04a88a81 100644
--- a/Documentation/devicetree/bindings/usb/realtek,rts5411.yaml
+++ b/Documentation/devicetree/bindings/usb/realtek,rts5411.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/usb/realtek,rts5411.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for the Realtek RTS5411 USB 3.0 hub controller
+title: Realtek RTS5411 USB 3.0 hub controller
 
 maintainers:
   - Matthias Kaehlcke <mka@chromium.org>
diff --git a/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml b/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
index eedde385d299..f81ba3e90297 100644
--- a/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
+++ b/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/usb/ti,j721e-usb.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Bindings for the TI wrapper module for the Cadence USBSS-DRD controller
+title: TI wrapper module for the Cadence USBSS-DRD controller
 
 maintainers:
   - Roger Quadros <rogerq@kernel.org>
diff --git a/Documentation/devicetree/bindings/usb/ti,usb8041.yaml b/Documentation/devicetree/bindings/usb/ti,usb8041.yaml
index e04fbd8ab0b7..88ea6c952c66 100644
--- a/Documentation/devicetree/bindings/usb/ti,usb8041.yaml
+++ b/Documentation/devicetree/bindings/usb/ti,usb8041.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/usb/ti,usb8041.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Binding for the TI USB8041 USB 3.0 hub controller
+title: TI USB8041 USB 3.0 hub controller
 
 maintainers:
   - Alexander Stein <alexander.stein@ew.tq-group.com>
-- 
2.34.1

