Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CAA2EB630
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbhAEX2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbhAEX2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 18:28:36 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314F4C0617AA
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 15:27:35 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id n25so943141pgb.0
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 15:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y0oAcHw7B8AOrMn14qEmbPdedEj6fnICk95LQ64N4xc=;
        b=vRkjyHVtIV/zSvYPxyp60g5MFjSBs7l8jYc0DiGKGH5oMkl8kaG4PGaSwzXGwNZiHB
         IaP+24myWNa2qo+RV0oyfk+X1jQVrdptVwoTnlRiDFXTnfWwQwEwSm0YMQJUzEvwIjjy
         /G492gJ8YQgpv1aD2zwoHi6LALDvLtbrV6sFGlpIkH1bJyCPlehzGLo4XI1lprEwaZ1k
         PtZdfWnHZ0GA4on0LSO9udZnx9023IGYgNS5TZMRJIDH1q358DkopWbhsohg3rZJ6nOc
         LvQkmuovHOv3qJv9/SaNPYyZ5IbPT7YZBrw/HwOwHya4KRuvIozcrW3pt66zzAjVVRGd
         9kkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y0oAcHw7B8AOrMn14qEmbPdedEj6fnICk95LQ64N4xc=;
        b=qF9r37pkDX1pXNKULWRMSX4V9xR2et5AtIg7G/fu79aUrsc+jLll6g128reeuAYb+M
         mmdlGOZ4eDQuHjB2PJTlIVYtwiIIYktdisuIb+DYg4RMr8T3lr+2uz7sdli8GgjECmuQ
         GY/dOjkpSnv927xoC1xWTIXFB2ZYL3N7aO1BxhgoZNaDg3dftHZF+1AqkODKSuDS/WtG
         DvKg1dei+yrovTFVivojttsa+SSi7Dbar+BDHHwKym3Oo/gaOnfC9pGoeAaJjmetjHD0
         N92/3/Oa1c45F3gs//IenBZNwHqTggOOt9XFck+WTKS8VJU40CNezgSyJVHeMMXGwLmP
         kRYw==
X-Gm-Message-State: AOAM53094dHAiXetimsblrjpNXxxaFH6FaCDRwO5yqb15JiVI8kD5+Mn
        Hm3f5Gma6votoCuFvkXyna2t8Q==
X-Google-Smtp-Source: ABdhPJyxMdrDeR24Ej+HNB73Hk0k0kWC69h/j/+uMSrCUKxQ/Qgp+Rc8AS9rydNUJJU6Plv/NAUA+w==
X-Received: by 2002:aa7:85d8:0:b029:19e:610e:1974 with SMTP id z24-20020aa785d80000b029019e610e1974mr1425585pfn.21.1609889254026;
        Tue, 05 Jan 2021 15:27:34 -0800 (PST)
Received: from xps15 (S0106889e681aac74.cg.shawcable.net. [68.147.0.187])
        by smtp.gmail.com with ESMTPSA id gw7sm279696pjb.36.2021.01.05.15.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 15:27:33 -0800 (PST)
Date:   Tue, 5 Jan 2021 16:27:29 -0700
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-usb@vger.kernel.org, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        dri-devel@lists.freedesktop.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-ide@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        netdev@vger.kernel.org, linux-clk@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Marc Zyngier <maz@kernel.org>, linux-riscv@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Chen-Yu Tsai <wens@csie.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-serial@vger.kernel.org, linux-input@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, linux-media@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org, Jens Axboe <axboe@kernel.dk>,
        Stephen Boyd <sboyd@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <jic23@kernel.org>, s-anna@ti.com,
        paul@crapouillou.net
Subject: Re: [PATCH] dt-bindings: Add missing array size constraints
Message-ID: <20210105232729.GA2864340@xps15>
References: <20210104230253.2805217-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104230253.2805217-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding Suman and Paul - guys please have a look.

On Mon, Jan 04, 2021 at 04:02:53PM -0700, Rob Herring wrote:
> DT properties which can have multiple entries need to specify what the
> entries are and define how many entries there can be. In the case of
> only a single entry, just 'maxItems: 1' is sufficient.
> 
> Add the missing entry constraints. These were found with a modified
> meta-schema. Unfortunately, there are a few cases where the size
> constraints are not defined such as common bindings, so the meta-schema
> can't be part of the normal checks.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Chen-Yu Tsai <wens@csie.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-ide@vger.kernel.org
> Cc: linux-clk@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-gpio@vger.kernel.org
> Cc: linux-iio@vger.kernel.org
> Cc: linux-input@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: linux-mmc@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-remoteproc@vger.kernel.org
> Cc: linux-riscv@lists.infradead.org
> Cc: linux-serial@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-spi@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> ---
>  .../socionext,uniphier-system-cache.yaml      |  4 ++--
>  .../bindings/ata/sata_highbank.yaml           |  1 +
>  .../bindings/clock/canaan,k210-clk.yaml       |  1 +
>  .../bindings/display/brcm,bcm2711-hdmi.yaml   |  1 +
>  .../bindings/display/brcm,bcm2835-hdmi.yaml   |  1 +
>  .../display/panel/jdi,lt070me05000.yaml       |  1 +
>  .../display/panel/mantix,mlaf057we51-x.yaml   |  3 ++-
>  .../display/panel/novatek,nt36672a.yaml       |  1 +
>  .../devicetree/bindings/dsp/fsl,dsp.yaml      |  2 +-
>  .../devicetree/bindings/eeprom/at25.yaml      |  3 +--
>  .../bindings/extcon/extcon-ptn5150.yaml       |  2 ++
>  .../bindings/gpio/gpio-pca95xx.yaml           |  1 +
>  .../bindings/iio/adc/adi,ad7768-1.yaml        |  2 ++
>  .../bindings/iio/adc/aspeed,ast2400-adc.yaml  |  1 +
>  .../bindings/iio/adc/lltc,ltc2496.yaml        |  2 +-
>  .../bindings/iio/adc/qcom,spmi-vadc.yaml      |  1 +
>  .../bindings/iio/adc/st,stm32-adc.yaml        |  2 ++
>  .../iio/magnetometer/asahi-kasei,ak8975.yaml  |  1 +
>  .../iio/potentiometer/adi,ad5272.yaml         |  1 +
>  .../input/touchscreen/elan,elants_i2c.yaml    |  1 +
>  .../interrupt-controller/fsl,intmux.yaml      |  2 +-
>  .../interrupt-controller/st,stm32-exti.yaml   |  2 ++
>  .../allwinner,sun4i-a10-video-engine.yaml     |  1 +
>  .../devicetree/bindings/media/i2c/imx219.yaml |  1 +
>  .../memory-controllers/exynos-srom.yaml       |  2 ++
>  .../bindings/misc/fsl,dpaa2-console.yaml      |  1 +
>  .../bindings/mmc/mmc-controller.yaml          |  2 ++
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |  1 +
>  .../bindings/net/ti,k3-am654-cpts.yaml        |  1 +
>  .../phy/allwinner,sun4i-a10-usb-phy.yaml      |  2 ++
>  .../phy/allwinner,sun50i-a64-usb-phy.yaml     |  2 ++
>  .../phy/allwinner,sun50i-h6-usb-phy.yaml      |  2 ++
>  .../phy/allwinner,sun5i-a13-usb-phy.yaml      |  2 ++
>  .../phy/allwinner,sun6i-a31-usb-phy.yaml      |  2 ++
>  .../phy/allwinner,sun8i-a23-usb-phy.yaml      |  2 ++
>  .../phy/allwinner,sun8i-a83t-usb-phy.yaml     |  2 ++
>  .../phy/allwinner,sun8i-h3-usb-phy.yaml       |  2 ++
>  .../phy/allwinner,sun8i-r40-usb-phy.yaml      |  2 ++
>  .../phy/allwinner,sun8i-v3s-usb-phy.yaml      |  2 ++
>  .../phy/allwinner,sun9i-a80-usb-phy.yaml      | 19 ++++++++-----------
>  .../phy/socionext,uniphier-ahci-phy.yaml      |  2 +-
>  .../phy/socionext,uniphier-pcie-phy.yaml      |  2 +-
>  .../phy/socionext,uniphier-usb3hs-phy.yaml    |  2 +-
>  .../phy/socionext,uniphier-usb3ss-phy.yaml    |  2 +-
>  .../bindings/phy/ti,phy-gmii-sel.yaml         |  2 +-
>  .../pinctrl/aspeed,ast2400-pinctrl.yaml       |  3 +--
>  .../pinctrl/aspeed,ast2500-pinctrl.yaml       |  4 ++--
>  .../bindings/power/supply/bq25980.yaml        |  1 +
>  .../bindings/remoteproc/ingenic,vpu.yaml      |  2 +-
>  .../remoteproc/ti,omap-remoteproc.yaml        |  3 +++
>  .../bindings/riscv/sifive-l2-cache.yaml       |  1 +
>  .../bindings/serial/renesas,hscif.yaml        |  2 ++
>  .../bindings/serial/renesas,scif.yaml         |  2 ++
>  .../bindings/serial/renesas,scifa.yaml        |  2 ++
>  .../bindings/serial/renesas,scifb.yaml        |  2 ++
>  .../sound/allwinner,sun4i-a10-codec.yaml      |  1 +
>  .../bindings/sound/google,sc7180-trogdor.yaml |  1 +
>  .../bindings/sound/samsung,aries-wm8994.yaml  |  3 +++
>  .../bindings/sound/samsung,midas-audio.yaml   |  2 ++
>  .../devicetree/bindings/sound/tas2562.yaml    |  2 ++
>  .../devicetree/bindings/sound/tas2770.yaml    |  2 ++
>  .../bindings/sound/tlv320adcx140.yaml         |  1 +
>  .../devicetree/bindings/spi/renesas,rspi.yaml |  2 ++
>  .../devicetree/bindings/sram/sram.yaml        |  2 ++
>  .../timer/allwinner,sun4i-a10-timer.yaml      |  2 ++
>  .../bindings/timer/intel,ixp4xx-timer.yaml    |  2 +-
>  .../usb/allwinner,sun4i-a10-musb.yaml         |  2 +-
>  .../bindings/usb/brcm,usb-pinmap.yaml         |  3 +++
>  .../devicetree/bindings/usb/generic-ehci.yaml |  1 +
>  .../devicetree/bindings/usb/generic-ohci.yaml |  1 +
>  .../devicetree/bindings/usb/ingenic,musb.yaml |  2 +-
>  .../bindings/usb/renesas,usbhs.yaml           |  1 +
>  .../devicetree/bindings/usb/ti,j721e-usb.yaml |  3 ++-
>  .../bindings/usb/ti,keystone-dwc3.yaml        |  2 ++
>  74 files changed, 118 insertions(+), 33 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/socionext/socionext,uniphier-system-cache.yaml b/Documentation/devicetree/bindings/arm/socionext/socionext,uniphier-system-cache.yaml
> index 2e765bb3e6f6..7ca5375f278f 100644
> --- a/Documentation/devicetree/bindings/arm/socionext/socionext,uniphier-system-cache.yaml
> +++ b/Documentation/devicetree/bindings/arm/socionext/socionext,uniphier-system-cache.yaml
> @@ -30,8 +30,8 @@ properties:
>        Interrupts can be used to notify the completion of cache operations.
>        The number of interrupts should match to the number of CPU cores.
>        The specified interrupts correspond to CPU0, CPU1, ... in this order.
> -      minItems: 1
> -      maxItems: 4
> +    minItems: 1
> +    maxItems: 4
>  
>    cache-unified: true
>  
> diff --git a/Documentation/devicetree/bindings/ata/sata_highbank.yaml b/Documentation/devicetree/bindings/ata/sata_highbank.yaml
> index 5e2a2394e600..ce75d77e9289 100644
> --- a/Documentation/devicetree/bindings/ata/sata_highbank.yaml
> +++ b/Documentation/devicetree/bindings/ata/sata_highbank.yaml
> @@ -61,6 +61,7 @@ properties:
>      maxItems: 8
>  
>    calxeda,sgpio-gpio:
> +    maxItems: 3
>      description: |
>        phandle-gpio bank, bit offset, and default on or off, which indicates
>        that the driver supports SGPIO indicator lights using the indicated
> diff --git a/Documentation/devicetree/bindings/clock/canaan,k210-clk.yaml b/Documentation/devicetree/bindings/clock/canaan,k210-clk.yaml
> index 565ca468cb44..7f5cf4001f76 100644
> --- a/Documentation/devicetree/bindings/clock/canaan,k210-clk.yaml
> +++ b/Documentation/devicetree/bindings/clock/canaan,k210-clk.yaml
> @@ -22,6 +22,7 @@ properties:
>      const: canaan,k210-clk
>  
>    clocks:
> +    maxItems: 1
>      description:
>        Phandle of the SoC 26MHz fixed-rate oscillator clock.
>  
> diff --git a/Documentation/devicetree/bindings/display/brcm,bcm2711-hdmi.yaml b/Documentation/devicetree/bindings/display/brcm,bcm2711-hdmi.yaml
> index 7ce06f9f9f8e..767edc0a7978 100644
> --- a/Documentation/devicetree/bindings/display/brcm,bcm2711-hdmi.yaml
> +++ b/Documentation/devicetree/bindings/display/brcm,bcm2711-hdmi.yaml
> @@ -60,6 +60,7 @@ properties:
>        Phandle of the I2C controller used for DDC EDID probing
>  
>    hpd-gpios:
> +    maxItems: 1
>      description: >
>        The GPIO pin for the HDMI hotplug detect (if it doesn't appear
>        as an interrupt/status bit in the HDMI controller itself)
> diff --git a/Documentation/devicetree/bindings/display/brcm,bcm2835-hdmi.yaml b/Documentation/devicetree/bindings/display/brcm,bcm2835-hdmi.yaml
> index f54b4e4808f0..031e35e76db2 100644
> --- a/Documentation/devicetree/bindings/display/brcm,bcm2835-hdmi.yaml
> +++ b/Documentation/devicetree/bindings/display/brcm,bcm2835-hdmi.yaml
> @@ -37,6 +37,7 @@ properties:
>        Phandle of the I2C controller used for DDC EDID probing
>  
>    hpd-gpios:
> +    maxItems: 1
>      description: >
>        The GPIO pin for the HDMI hotplug detect (if it doesn't appear
>        as an interrupt/status bit in the HDMI controller itself)
> diff --git a/Documentation/devicetree/bindings/display/panel/jdi,lt070me05000.yaml b/Documentation/devicetree/bindings/display/panel/jdi,lt070me05000.yaml
> index b8b9435e464c..4f92365e888a 100644
> --- a/Documentation/devicetree/bindings/display/panel/jdi,lt070me05000.yaml
> +++ b/Documentation/devicetree/bindings/display/panel/jdi,lt070me05000.yaml
> @@ -30,6 +30,7 @@ properties:
>        power supply for LCM (1.8V)
>  
>    dcdc-en-gpios:
> +    maxItems: 1
>      description: |
>        phandle of the gpio for power ic line
>        Power IC supply enable, High active
> diff --git a/Documentation/devicetree/bindings/display/panel/mantix,mlaf057we51-x.yaml b/Documentation/devicetree/bindings/display/panel/mantix,mlaf057we51-x.yaml
> index 51f423297ec8..aa5a0dc391a4 100644
> --- a/Documentation/devicetree/bindings/display/panel/mantix,mlaf057we51-x.yaml
> +++ b/Documentation/devicetree/bindings/display/panel/mantix,mlaf057we51-x.yaml
> @@ -37,7 +37,8 @@ properties:
>  
>    reset-gpios: true
>  
> -  'mantix,tp-rstn-gpios':
> +  mantix,tp-rstn-gpios:
> +    maxItems: 1
>      description: second reset line that triggers DSI config load
>  
>    backlight: true
> diff --git a/Documentation/devicetree/bindings/display/panel/novatek,nt36672a.yaml b/Documentation/devicetree/bindings/display/panel/novatek,nt36672a.yaml
> index 2f5df1d235ae..ef4c0a24512d 100644
> --- a/Documentation/devicetree/bindings/display/panel/novatek,nt36672a.yaml
> +++ b/Documentation/devicetree/bindings/display/panel/novatek,nt36672a.yaml
> @@ -30,6 +30,7 @@ properties:
>        panel. The novatek,nt36672a compatible shall always be provided as a fallback.
>  
>    reset-gpios:
> +    maxItems: 1
>      description: phandle of gpio for reset line - This should be 8mA, gpio
>        can be configured using mux, pinctrl, pinctrl-names (active high)
>  
> diff --git a/Documentation/devicetree/bindings/dsp/fsl,dsp.yaml b/Documentation/devicetree/bindings/dsp/fsl,dsp.yaml
> index 4cc011230153..7afc9f2be13a 100644
> --- a/Documentation/devicetree/bindings/dsp/fsl,dsp.yaml
> +++ b/Documentation/devicetree/bindings/dsp/fsl,dsp.yaml
> @@ -21,7 +21,7 @@ properties:
>        - fsl,imx8mp-dsp
>  
>    reg:
> -    description: Should contain register location and length
> +    maxItems: 1
>  
>    clocks:
>      items:
> diff --git a/Documentation/devicetree/bindings/eeprom/at25.yaml b/Documentation/devicetree/bindings/eeprom/at25.yaml
> index 121a601db22e..6a2dc8b3ed14 100644
> --- a/Documentation/devicetree/bindings/eeprom/at25.yaml
> +++ b/Documentation/devicetree/bindings/eeprom/at25.yaml
> @@ -39,8 +39,7 @@ properties:
>            - const: atmel,at25
>  
>    reg:
> -    description:
> -      Chip select number.
> +    maxItems: 1
>  
>    spi-max-frequency: true
>  
> diff --git a/Documentation/devicetree/bindings/extcon/extcon-ptn5150.yaml b/Documentation/devicetree/bindings/extcon/extcon-ptn5150.yaml
> index 4b0f414486d2..d5cfa32ea52d 100644
> --- a/Documentation/devicetree/bindings/extcon/extcon-ptn5150.yaml
> +++ b/Documentation/devicetree/bindings/extcon/extcon-ptn5150.yaml
> @@ -19,6 +19,7 @@ properties:
>      const: nxp,ptn5150
>  
>    int-gpios:
> +    maxItems: 1
>      deprecated: true
>      description:
>        GPIO pin (input) connected to the PTN5150's INTB pin.
> @@ -31,6 +32,7 @@ properties:
>      maxItems: 1
>  
>    vbus-gpios:
> +    maxItems: 1
>      description:
>        GPIO pin (output) used to control VBUS. If skipped, no such control
>        takes place.
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-pca95xx.yaml b/Documentation/devicetree/bindings/gpio/gpio-pca95xx.yaml
> index f5ee23c2df60..57cdcfd4ff3c 100644
> --- a/Documentation/devicetree/bindings/gpio/gpio-pca95xx.yaml
> +++ b/Documentation/devicetree/bindings/gpio/gpio-pca95xx.yaml
> @@ -81,6 +81,7 @@ properties:
>      const: 2
>  
>    reset-gpios:
> +    maxItems: 1
>      description:
>        GPIO specification for the RESET input. This is an active low signal to
>        the PCA953x.  Not valid for Maxim MAX732x devices.
> diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7768-1.yaml b/Documentation/devicetree/bindings/iio/adc/adi,ad7768-1.yaml
> index 924477dfb833..a85a28145ef6 100644
> --- a/Documentation/devicetree/bindings/iio/adc/adi,ad7768-1.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7768-1.yaml
> @@ -40,6 +40,7 @@ properties:
>        ADC reference voltage supply
>  
>    adi,sync-in-gpios:
> +    maxItems: 1
>      description:
>        Enables synchronization of multiple devices that require simultaneous
>        sampling. A pulse is always required if the configuration is changed
> @@ -76,6 +77,7 @@ patternProperties:
>  
>      properties:
>        reg:
> +        maxItems: 1
>          description: |
>            The channel number.
>  
> diff --git a/Documentation/devicetree/bindings/iio/adc/aspeed,ast2400-adc.yaml b/Documentation/devicetree/bindings/iio/adc/aspeed,ast2400-adc.yaml
> index 7f534a933e92..a726b6c2ab65 100644
> --- a/Documentation/devicetree/bindings/iio/adc/aspeed,ast2400-adc.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/aspeed,ast2400-adc.yaml
> @@ -23,6 +23,7 @@ properties:
>      maxItems: 1
>  
>    clocks:
> +    maxItems: 1
>      description:
>        Input clock used to derive the sample clock. Expected to be the
>        SoC's APB clock.
> diff --git a/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml b/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml
> index 2716d4e95329..0bd2fc0356c8 100644
> --- a/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml
> @@ -20,7 +20,7 @@ properties:
>      description: Power supply for the reference voltage
>  
>    reg:
> -    description: spi chipselect number according to the usual spi bindings
> +    maxItems: 1
>  
>    spi-max-frequency:
>      description: maximal spi bus frequency supported
> diff --git a/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.yaml b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.yaml
> index 95cc705b961b..74a4a9d95798 100644
> --- a/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.yaml
> @@ -68,6 +68,7 @@ patternProperties:
>  
>      properties:
>        reg:
> +        maxItems: 1
>          description: |
>            ADC channel number.
>            See include/dt-bindings/iio/qcom,spmi-vadc.h
> diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
> index 28417b31b558..6364ede9bb5f 100644
> --- a/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
> @@ -41,6 +41,8 @@ properties:
>      maxItems: 2
>  
>    clocks:
> +    minItems: 1
> +    maxItems: 2
>      description: |
>        Core can use up to two clocks, depending on part used:
>          - "adc" clock: for the analog circuitry, common to all ADCs.
> diff --git a/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml b/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml
> index a25590a16ba7..a0a1ffe017df 100644
> --- a/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml
> +++ b/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml
> @@ -47,6 +47,7 @@ properties:
>      description: an optional 3x3 mounting rotation matrix.
>  
>    reset-gpios:
> +    maxItems: 1
>      description: |
>        an optional pin needed for AK09911 to set the reset state. This should
>        be usually active low
> diff --git a/Documentation/devicetree/bindings/iio/potentiometer/adi,ad5272.yaml b/Documentation/devicetree/bindings/iio/potentiometer/adi,ad5272.yaml
> index 1aee9f9be951..0ebb6725a1af 100644
> --- a/Documentation/devicetree/bindings/iio/potentiometer/adi,ad5272.yaml
> +++ b/Documentation/devicetree/bindings/iio/potentiometer/adi,ad5272.yaml
> @@ -25,6 +25,7 @@ properties:
>      maxItems: 1
>  
>    reset-gpios:
> +    maxItems: 1
>      description:
>        Active low signal to the AD5272 RESET input.
>  
> diff --git a/Documentation/devicetree/bindings/input/touchscreen/elan,elants_i2c.yaml b/Documentation/devicetree/bindings/input/touchscreen/elan,elants_i2c.yaml
> index a792d6377b1d..a9b53c2e6f0a 100644
> --- a/Documentation/devicetree/bindings/input/touchscreen/elan,elants_i2c.yaml
> +++ b/Documentation/devicetree/bindings/input/touchscreen/elan,elants_i2c.yaml
> @@ -29,6 +29,7 @@ properties:
>      description: touchscreen can be used as a wakeup source.
>  
>    reset-gpios:
> +    maxItems: 1
>      description: reset gpio the chip is connected to.
>  
>    vcc33-supply:
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/fsl,intmux.yaml b/Documentation/devicetree/bindings/interrupt-controller/fsl,intmux.yaml
> index 43c6effbb5bd..1d6e0f64a807 100644
> --- a/Documentation/devicetree/bindings/interrupt-controller/fsl,intmux.yaml
> +++ b/Documentation/devicetree/bindings/interrupt-controller/fsl,intmux.yaml
> @@ -31,7 +31,7 @@ properties:
>        The 1st cell is hw interrupt number, the 2nd cell is channel index.
>  
>    clocks:
> -    description: ipg clock.
> +    maxItems: 1
>  
>    clock-names:
>      const: ipg
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/st,stm32-exti.yaml b/Documentation/devicetree/bindings/interrupt-controller/st,stm32-exti.yaml
> index 2a5b29567926..6d3e68eb2e8b 100644
> --- a/Documentation/devicetree/bindings/interrupt-controller/st,stm32-exti.yaml
> +++ b/Documentation/devicetree/bindings/interrupt-controller/st,stm32-exti.yaml
> @@ -36,6 +36,8 @@ properties:
>        Reference to a phandle of a hardware spinlock provider node.
>  
>    interrupts:
> +    minItems: 1
> +    maxItems: 96
>      description:
>        Interrupts references to primary interrupt controller
>  
> diff --git a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml
> index 2f7058f7760c..c34303b87a5b 100644
> --- a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml
> +++ b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml
> @@ -53,6 +53,7 @@ properties:
>      maxItems: 1
>  
>    memory-region:
> +    maxItems: 1
>      description:
>        CMA pool to use for buffers allocation instead of the default
>        CMA pool.
> diff --git a/Documentation/devicetree/bindings/media/i2c/imx219.yaml b/Documentation/devicetree/bindings/media/i2c/imx219.yaml
> index dfc4d29a4f04..184d33bd3828 100644
> --- a/Documentation/devicetree/bindings/media/i2c/imx219.yaml
> +++ b/Documentation/devicetree/bindings/media/i2c/imx219.yaml
> @@ -40,6 +40,7 @@ properties:
>        Digital core voltage supply, 1.2 volts
>  
>    reset-gpios:
> +    maxItems: 1
>      description: |-
>        Reference to the GPIO connected to the xclr pin, if any.
>        Must be released (set high) after all supplies are applied.
> diff --git a/Documentation/devicetree/bindings/memory-controllers/exynos-srom.yaml b/Documentation/devicetree/bindings/memory-controllers/exynos-srom.yaml
> index 637e24f0f73b..c6e44f47ce7c 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/exynos-srom.yaml
> +++ b/Documentation/devicetree/bindings/memory-controllers/exynos-srom.yaml
> @@ -28,6 +28,8 @@ properties:
>      const: 1
>  
>    ranges:
> +    minItems: 1
> +    maxItems: 4
>      description: |
>        Reflects the memory layout with four integer values per bank. Format:
>        <bank-number> 0 <parent address of bank> <size>
> diff --git a/Documentation/devicetree/bindings/misc/fsl,dpaa2-console.yaml b/Documentation/devicetree/bindings/misc/fsl,dpaa2-console.yaml
> index 271a3eafc054..8cc951feb7df 100644
> --- a/Documentation/devicetree/bindings/misc/fsl,dpaa2-console.yaml
> +++ b/Documentation/devicetree/bindings/misc/fsl,dpaa2-console.yaml
> @@ -15,6 +15,7 @@ properties:
>      const: "fsl,dpaa2-console"
>  
>    reg:
> +    maxItems: 1
>      description: A standard property. Specifies the region where the MCFBA
>                  (MC firmware base address) register can be found.
>  
> diff --git a/Documentation/devicetree/bindings/mmc/mmc-controller.yaml b/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
> index 186f04ba9357..df4ee4c778ae 100644
> --- a/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
> +++ b/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
> @@ -40,6 +40,7 @@ properties:
>        There is no card detection available; polling must be used.
>  
>    cd-gpios:
> +    maxItems: 1
>      description:
>        The card detection will be done using the GPIO provided.
>  
> @@ -104,6 +105,7 @@ properties:
>        line. Not used in combination with eMMC or SDIO.
>  
>    wp-gpios:
> +    maxItems: 1
>      description:
>        GPIO to use for the write-protect detection.
>  
> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> index c47b58f3e3f6..097c5cc6c853 100644
> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> @@ -66,6 +66,7 @@ properties:
>    dma-coherent: true
>  
>    clocks:
> +    maxItems: 1
>      description: CPSW2G NUSS functional clock
>  
>    clock-names:
> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
> index 9b7117920d90..2a42a27fb911 100644
> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
> @@ -59,6 +59,7 @@ properties:
>        - const: cpts
>  
>    clocks:
> +    maxItems: 1
>      description: CPTS reference clock
>  
>    clock-names:
> diff --git a/Documentation/devicetree/bindings/phy/allwinner,sun4i-a10-usb-phy.yaml b/Documentation/devicetree/bindings/phy/allwinner,sun4i-a10-usb-phy.yaml
> index 94ac23687b7e..77606c899fe2 100644
> --- a/Documentation/devicetree/bindings/phy/allwinner,sun4i-a10-usb-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/allwinner,sun4i-a10-usb-phy.yaml
> @@ -51,9 +51,11 @@ properties:
>        - const: usb2_reset
>  
>    usb0_id_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG ID pin
>  
>    usb0_vbus_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG VBUS detect pin
>  
>    usb0_vbus_power-supply:
> diff --git a/Documentation/devicetree/bindings/phy/allwinner,sun50i-a64-usb-phy.yaml b/Documentation/devicetree/bindings/phy/allwinner,sun50i-a64-usb-phy.yaml
> index fd6e126fcf18..078af52b16ed 100644
> --- a/Documentation/devicetree/bindings/phy/allwinner,sun50i-a64-usb-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/allwinner,sun50i-a64-usb-phy.yaml
> @@ -50,9 +50,11 @@ properties:
>        - const: usb1_reset
>  
>    usb0_id_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG ID pin
>  
>    usb0_vbus_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG VBUS detect pin
>  
>    usb0_vbus_power-supply:
> diff --git a/Documentation/devicetree/bindings/phy/allwinner,sun50i-h6-usb-phy.yaml b/Documentation/devicetree/bindings/phy/allwinner,sun50i-h6-usb-phy.yaml
> index 7670411002c9..e632140722a2 100644
> --- a/Documentation/devicetree/bindings/phy/allwinner,sun50i-h6-usb-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/allwinner,sun50i-h6-usb-phy.yaml
> @@ -50,9 +50,11 @@ properties:
>        - const: usb3_reset
>  
>    usb0_id_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG ID pin
>  
>    usb0_vbus_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG VBUS detect pin
>  
>    usb0_vbus_power-supply:
> diff --git a/Documentation/devicetree/bindings/phy/allwinner,sun5i-a13-usb-phy.yaml b/Documentation/devicetree/bindings/phy/allwinner,sun5i-a13-usb-phy.yaml
> index 9b319381d1ad..5bad9b06e2e7 100644
> --- a/Documentation/devicetree/bindings/phy/allwinner,sun5i-a13-usb-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/allwinner,sun5i-a13-usb-phy.yaml
> @@ -45,9 +45,11 @@ properties:
>        - const: usb1_reset
>  
>    usb0_id_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG ID pin
>  
>    usb0_vbus_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG VBUS detect pin
>  
>    usb0_vbus_power-supply:
> diff --git a/Documentation/devicetree/bindings/phy/allwinner,sun6i-a31-usb-phy.yaml b/Documentation/devicetree/bindings/phy/allwinner,sun6i-a31-usb-phy.yaml
> index b0ed01bbf3db..922b4665e00d 100644
> --- a/Documentation/devicetree/bindings/phy/allwinner,sun6i-a31-usb-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/allwinner,sun6i-a31-usb-phy.yaml
> @@ -54,9 +54,11 @@ properties:
>        - const: usb2_reset
>  
>    usb0_id_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG ID pin
>  
>    usb0_vbus_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG VBUS detect pin
>  
>    usb0_vbus_power-supply:
> diff --git a/Documentation/devicetree/bindings/phy/allwinner,sun8i-a23-usb-phy.yaml b/Documentation/devicetree/bindings/phy/allwinner,sun8i-a23-usb-phy.yaml
> index b0674406f8aa..a94019efc2f3 100644
> --- a/Documentation/devicetree/bindings/phy/allwinner,sun8i-a23-usb-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/allwinner,sun8i-a23-usb-phy.yaml
> @@ -50,9 +50,11 @@ properties:
>        - const: usb1_reset
>  
>    usb0_id_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG ID pin
>  
>    usb0_vbus_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG VBUS detect pin
>  
>    usb0_vbus_power-supply:
> diff --git a/Documentation/devicetree/bindings/phy/allwinner,sun8i-a83t-usb-phy.yaml b/Documentation/devicetree/bindings/phy/allwinner,sun8i-a83t-usb-phy.yaml
> index 48dc9c834a9b..33f3ddc0492d 100644
> --- a/Documentation/devicetree/bindings/phy/allwinner,sun8i-a83t-usb-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/allwinner,sun8i-a83t-usb-phy.yaml
> @@ -56,9 +56,11 @@ properties:
>        - const: usb2_reset
>  
>    usb0_id_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG ID pin
>  
>    usb0_vbus_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG VBUS detect pin
>  
>    usb0_vbus_power-supply:
> diff --git a/Documentation/devicetree/bindings/phy/allwinner,sun8i-h3-usb-phy.yaml b/Documentation/devicetree/bindings/phy/allwinner,sun8i-h3-usb-phy.yaml
> index 60c344585276..f80431060803 100644
> --- a/Documentation/devicetree/bindings/phy/allwinner,sun8i-h3-usb-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/allwinner,sun8i-h3-usb-phy.yaml
> @@ -62,9 +62,11 @@ properties:
>        - const: usb3_reset
>  
>    usb0_id_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG ID pin
>  
>    usb0_vbus_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG VBUS detect pin
>  
>    usb0_vbus_power-supply:
> diff --git a/Documentation/devicetree/bindings/phy/allwinner,sun8i-r40-usb-phy.yaml b/Documentation/devicetree/bindings/phy/allwinner,sun8i-r40-usb-phy.yaml
> index a2bb36790fbd..d947e50a49d2 100644
> --- a/Documentation/devicetree/bindings/phy/allwinner,sun8i-r40-usb-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/allwinner,sun8i-r40-usb-phy.yaml
> @@ -56,9 +56,11 @@ properties:
>        - const: usb2_reset
>  
>    usb0_id_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG ID pin
>  
>    usb0_vbus_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG VBUS detect pin
>  
>    usb0_vbus_power-supply:
> diff --git a/Documentation/devicetree/bindings/phy/allwinner,sun8i-v3s-usb-phy.yaml b/Documentation/devicetree/bindings/phy/allwinner,sun8i-v3s-usb-phy.yaml
> index eadfd0c9493c..a2836c296cc4 100644
> --- a/Documentation/devicetree/bindings/phy/allwinner,sun8i-v3s-usb-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/allwinner,sun8i-v3s-usb-phy.yaml
> @@ -42,9 +42,11 @@ properties:
>      const: usb0_reset
>  
>    usb0_id_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG ID pin
>  
>    usb0_vbus_det-gpios:
> +    maxItems: 1
>      description: GPIO to the USB OTG VBUS detect pin
>  
>    usb0_vbus_power-supply:
> diff --git a/Documentation/devicetree/bindings/phy/allwinner,sun9i-a80-usb-phy.yaml b/Documentation/devicetree/bindings/phy/allwinner,sun9i-a80-usb-phy.yaml
> index ded7d6f0a119..2eb493fa64fd 100644
> --- a/Documentation/devicetree/bindings/phy/allwinner,sun9i-a80-usb-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/allwinner,sun9i-a80-usb-phy.yaml
> @@ -22,7 +22,8 @@ properties:
>  
>    clocks:
>      anyOf:
> -      - description: Main PHY Clock
> +      - maxItems: 1
> +        description: Main PHY Clock
>  
>        - items:
>            - description: Main PHY clock
> @@ -39,20 +40,16 @@ properties:
>            - const: hsic_480M
>  
>    resets:
> -    anyOf:
> +    minItems: 1
> +    items:
>        - description: Normal USB PHY reset
> -
> -      - items:
> -          - description: Normal USB PHY reset
> -          - description: HSIC Reset
> +      - description: HSIC Reset
>  
>    reset-names:
> -    oneOf:
> +    minItems: 1
> +    items:
>        - const: phy
> -
> -      - items:
> -          - const: phy
> -          - const: hsic
> +      - const: hsic
>  
>    phy_type:
>      const: hsic
> diff --git a/Documentation/devicetree/bindings/phy/socionext,uniphier-ahci-phy.yaml b/Documentation/devicetree/bindings/phy/socionext,uniphier-ahci-phy.yaml
> index 34756347a14e..745c525ce6b9 100644
> --- a/Documentation/devicetree/bindings/phy/socionext,uniphier-ahci-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/socionext,uniphier-ahci-phy.yaml
> @@ -20,7 +20,7 @@ properties:
>        - socionext,uniphier-pxs3-ahci-phy
>  
>    reg:
> -    description: PHY register region (offset and length)
> +    maxItems: 1
>  
>    "#phy-cells":
>      const: 0
> diff --git a/Documentation/devicetree/bindings/phy/socionext,uniphier-pcie-phy.yaml b/Documentation/devicetree/bindings/phy/socionext,uniphier-pcie-phy.yaml
> index a06831fd64b9..3e0566899041 100644
> --- a/Documentation/devicetree/bindings/phy/socionext,uniphier-pcie-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/socionext,uniphier-pcie-phy.yaml
> @@ -21,7 +21,7 @@ properties:
>        - socionext,uniphier-pxs3-pcie-phy
>  
>    reg:
> -    description: PHY register region (offset and length)
> +    maxItems: 1
>  
>    "#phy-cells":
>      const: 0
> diff --git a/Documentation/devicetree/bindings/phy/socionext,uniphier-usb3hs-phy.yaml b/Documentation/devicetree/bindings/phy/socionext,uniphier-usb3hs-phy.yaml
> index 6fa5caab1487..a681cbc3b4ef 100644
> --- a/Documentation/devicetree/bindings/phy/socionext,uniphier-usb3hs-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/socionext,uniphier-usb3hs-phy.yaml
> @@ -24,7 +24,7 @@ properties:
>        - socionext,uniphier-pxs3-usb3-hsphy
>  
>    reg:
> -    description: PHY register region (offset and length)
> +    maxItems: 1
>  
>    "#phy-cells":
>      const: 0
> diff --git a/Documentation/devicetree/bindings/phy/socionext,uniphier-usb3ss-phy.yaml b/Documentation/devicetree/bindings/phy/socionext,uniphier-usb3ss-phy.yaml
> index 9d46715ed036..41c0dd68ee25 100644
> --- a/Documentation/devicetree/bindings/phy/socionext,uniphier-usb3ss-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/socionext,uniphier-usb3ss-phy.yaml
> @@ -25,7 +25,7 @@ properties:
>        - socionext,uniphier-pxs3-usb3-ssphy
>  
>    reg:
> -    description: PHY register region (offset and length)
> +    maxItems: 1
>  
>    "#phy-cells":
>      const: 0
> diff --git a/Documentation/devicetree/bindings/phy/ti,phy-gmii-sel.yaml b/Documentation/devicetree/bindings/phy/ti,phy-gmii-sel.yaml
> index bcec422d7734..ff8a6d9eb153 100644
> --- a/Documentation/devicetree/bindings/phy/ti,phy-gmii-sel.yaml
> +++ b/Documentation/devicetree/bindings/phy/ti,phy-gmii-sel.yaml
> @@ -55,7 +55,7 @@ properties:
>        - ti,am654-phy-gmii-sel
>  
>    reg:
> -    description: Address and length of the register set for the device
> +    maxItems: 1
>  
>    '#phy-cells': true
>  
> diff --git a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2400-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2400-pinctrl.yaml
> index 54631dc1adb0..91be5720d094 100644
> --- a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2400-pinctrl.yaml
> +++ b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2400-pinctrl.yaml
> @@ -23,8 +23,7 @@ properties:
>    compatible:
>      const: aspeed,ast2400-pinctrl
>    reg:
> -    description: |
> -      A hint for the memory regions associated with the pin-controller
> +    maxItems: 2
>  
>  patternProperties:
>    '^.*$':
> diff --git a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml
> index a90c0fe0495f..40e9e8d4be5a 100644
> --- a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml
> +++ b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml
> @@ -24,8 +24,8 @@ properties:
>    compatible:
>      const: aspeed,ast2500-pinctrl
>    reg:
> -    description: |
> -      A hint for the memory regions associated with the pin-controller
> +    maxItems: 2
> +
>    aspeed,external-nodes:
>      minItems: 2
>      maxItems: 2
> diff --git a/Documentation/devicetree/bindings/power/supply/bq25980.yaml b/Documentation/devicetree/bindings/power/supply/bq25980.yaml
> index f6b3dd4093ca..06eca6667f67 100644
> --- a/Documentation/devicetree/bindings/power/supply/bq25980.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/bq25980.yaml
> @@ -70,6 +70,7 @@ properties:
>      description: Enables bypass mode at boot time
>  
>    interrupts:
> +    maxItems: 1
>      description: |
>        Indicates that the device state has changed.
>  
> diff --git a/Documentation/devicetree/bindings/remoteproc/ingenic,vpu.yaml b/Documentation/devicetree/bindings/remoteproc/ingenic,vpu.yaml
> index c019f9fbe916..d0aa91bbf5e5 100644
> --- a/Documentation/devicetree/bindings/remoteproc/ingenic,vpu.yaml
> +++ b/Documentation/devicetree/bindings/remoteproc/ingenic,vpu.yaml
> @@ -44,7 +44,7 @@ properties:
>        - const: vpu
>  
>    interrupts:
> -    description: VPU hardware interrupt
> +    maxItems: 1
>  
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml b/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
> index 084960a8f17a..1a1159097a2a 100644
> --- a/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
> +++ b/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
> @@ -70,10 +70,13 @@ properties:
>        the firmware image.
>  
>    clocks:
> +    maxItems: 1
>      description: |
>        Main functional clock for the remote processor
>  
>    resets:
> +    minItems: 1
> +    maxItems: 2
>      description: |
>        Reset handles for the remote processor
>  
> diff --git a/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml b/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
> index efc0198eeb74..2ece8630dc68 100644
> --- a/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
> +++ b/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
> @@ -63,6 +63,7 @@ properties:
>    next-level-cache: true
>  
>    memory-region:
> +    maxItems: 1
>      description: |
>        The reference to the reserved-memory for the L2 Loosely Integrated Memory region.
>        The reserved memory node should be defined as per the bindings in reserved-memory.txt.
> diff --git a/Documentation/devicetree/bindings/serial/renesas,hscif.yaml b/Documentation/devicetree/bindings/serial/renesas,hscif.yaml
> index c139c5edb93e..69533347aa57 100644
> --- a/Documentation/devicetree/bindings/serial/renesas,hscif.yaml
> +++ b/Documentation/devicetree/bindings/serial/renesas,hscif.yaml
> @@ -81,6 +81,8 @@ properties:
>      maxItems: 1
>  
>    dmas:
> +    minItems: 2
> +    maxItems: 4
>      description:
>        Must contain a list of pairs of references to DMA specifiers, one for
>        transmission, and one for reception.
> diff --git a/Documentation/devicetree/bindings/serial/renesas,scif.yaml b/Documentation/devicetree/bindings/serial/renesas,scif.yaml
> index 672158906c33..22d76829f7ae 100644
> --- a/Documentation/devicetree/bindings/serial/renesas,scif.yaml
> +++ b/Documentation/devicetree/bindings/serial/renesas,scif.yaml
> @@ -120,6 +120,8 @@ properties:
>      maxItems: 1
>  
>    dmas:
> +    minItems: 2
> +    maxItems: 4
>      description:
>        Must contain a list of pairs of references to DMA specifiers, one for
>        transmission, and one for reception.
> diff --git a/Documentation/devicetree/bindings/serial/renesas,scifa.yaml b/Documentation/devicetree/bindings/serial/renesas,scifa.yaml
> index dbffb9534835..3c67d3202e1b 100644
> --- a/Documentation/devicetree/bindings/serial/renesas,scifa.yaml
> +++ b/Documentation/devicetree/bindings/serial/renesas,scifa.yaml
> @@ -55,6 +55,8 @@ properties:
>      maxItems: 1
>  
>    dmas:
> +    minItems: 2
> +    maxItems: 4
>      description:
>        Must contain a list of pairs of references to DMA specifiers, one for
>        transmission, and one for reception.
> diff --git a/Documentation/devicetree/bindings/serial/renesas,scifb.yaml b/Documentation/devicetree/bindings/serial/renesas,scifb.yaml
> index 147f8a37e02a..d5571c7a4424 100644
> --- a/Documentation/devicetree/bindings/serial/renesas,scifb.yaml
> +++ b/Documentation/devicetree/bindings/serial/renesas,scifb.yaml
> @@ -55,6 +55,8 @@ properties:
>      maxItems: 1
>  
>    dmas:
> +    minItems: 2
> +    maxItems: 4
>      description:
>        Must contain a list of pairs of references to DMA specifiers, one for
>        transmission, and one for reception.
> diff --git a/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-codec.yaml b/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-codec.yaml
> index dd47fef9854d..559aff13ae23 100644
> --- a/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-codec.yaml
> +++ b/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-codec.yaml
> @@ -88,6 +88,7 @@ properties:
>      description: Phandle to the codec analog controls in the PRCM
>  
>    allwinner,pa-gpios:
> +    maxItems: 1
>      description: GPIO to enable the external amplifier
>  
>  required:
> diff --git a/Documentation/devicetree/bindings/sound/google,sc7180-trogdor.yaml b/Documentation/devicetree/bindings/sound/google,sc7180-trogdor.yaml
> index 5095b780e2c7..837e3faa63a9 100644
> --- a/Documentation/devicetree/bindings/sound/google,sc7180-trogdor.yaml
> +++ b/Documentation/devicetree/bindings/sound/google,sc7180-trogdor.yaml
> @@ -55,6 +55,7 @@ patternProperties:
>          maxItems: 1
>  
>        reg:
> +        maxItems: 1
>          description: dai link address.
>  
>        cpu:
> diff --git a/Documentation/devicetree/bindings/sound/samsung,aries-wm8994.yaml b/Documentation/devicetree/bindings/sound/samsung,aries-wm8994.yaml
> index 1c6947294825..5fff586dc802 100644
> --- a/Documentation/devicetree/bindings/sound/samsung,aries-wm8994.yaml
> +++ b/Documentation/devicetree/bindings/sound/samsung,aries-wm8994.yaml
> @@ -62,12 +62,15 @@ properties:
>      description: Supply for the micbias on the headset mic
>  
>    earpath-sel-gpios:
> +    maxItems: 1
>      description: GPIO for switching between tv-out and mic paths
>  
>    headset-detect-gpios:
> +    maxItems: 1
>      description: GPIO for detection of headset insertion
>  
>    headset-key-gpios:
> +    maxItems: 1
>      description: GPIO for detection of headset key press
>  
>    io-channels:
> diff --git a/Documentation/devicetree/bindings/sound/samsung,midas-audio.yaml b/Documentation/devicetree/bindings/sound/samsung,midas-audio.yaml
> index 578928e67e5c..095775c598fa 100644
> --- a/Documentation/devicetree/bindings/sound/samsung,midas-audio.yaml
> +++ b/Documentation/devicetree/bindings/sound/samsung,midas-audio.yaml
> @@ -53,9 +53,11 @@ properties:
>      description: Supply for the micbias on the Sub microphone
>  
>    fm-sel-gpios:
> +    maxItems: 1
>      description: GPIO pin for FM selection
>  
>    lineout-sel-gpios:
> +    maxItems: 1
>      description: GPIO pin for line out selection
>  
>  required:
> diff --git a/Documentation/devicetree/bindings/sound/tas2562.yaml b/Documentation/devicetree/bindings/sound/tas2562.yaml
> index 27f7132ba2ef..acd4bbe69731 100644
> --- a/Documentation/devicetree/bindings/sound/tas2562.yaml
> +++ b/Documentation/devicetree/bindings/sound/tas2562.yaml
> @@ -36,10 +36,12 @@ properties:
>         I2C address of the device can be one of these 0x4c, 0x4d, 0x4e or 0x4f
>  
>    shut-down-gpios:
> +    maxItems: 1
>      description: GPIO used to control the state of the device.
>      deprecated: true
>  
>    shutdown-gpios:
> +    maxItems: 1
>      description: GPIO used to control the state of the device.
>  
>    interrupts:
> diff --git a/Documentation/devicetree/bindings/sound/tas2770.yaml b/Documentation/devicetree/bindings/sound/tas2770.yaml
> index 07e7f9951d2e..027bebf4e8cf 100644
> --- a/Documentation/devicetree/bindings/sound/tas2770.yaml
> +++ b/Documentation/devicetree/bindings/sound/tas2770.yaml
> @@ -27,9 +27,11 @@ properties:
>         I2C address of the device can be between 0x41 to 0x48.
>  
>    reset-gpio:
> +    maxItems: 1
>      description: GPIO used to reset the device.
>  
>    shutdown-gpios:
> +    maxItems: 1
>      description: GPIO used to control the state of the device.
>  
>    interrupts:
> diff --git a/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml b/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
> index df18be9d7b15..54d64785aad2 100644
> --- a/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
> +++ b/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
> @@ -35,6 +35,7 @@ properties:
>        I2C addresss of the device can be one of these 0x4c, 0x4d, 0x4e or 0x4f
>  
>    reset-gpios:
> +    maxItems: 1
>      description: |
>        GPIO used for hardware reset.
>  
> diff --git a/Documentation/devicetree/bindings/spi/renesas,rspi.yaml b/Documentation/devicetree/bindings/spi/renesas,rspi.yaml
> index 10e83cb17e8d..8397f60d80a2 100644
> --- a/Documentation/devicetree/bindings/spi/renesas,rspi.yaml
> +++ b/Documentation/devicetree/bindings/spi/renesas,rspi.yaml
> @@ -68,6 +68,8 @@ properties:
>      maxItems: 1
>  
>    dmas:
> +    minItems: 2
> +    maxItems: 4
>      description:
>        Must contain a list of pairs of references to DMA specifiers, one for
>        transmission, and one for reception.
> diff --git a/Documentation/devicetree/bindings/sram/sram.yaml b/Documentation/devicetree/bindings/sram/sram.yaml
> index 19d116ff9ddc..2a62bb204bbe 100644
> --- a/Documentation/devicetree/bindings/sram/sram.yaml
> +++ b/Documentation/devicetree/bindings/sram/sram.yaml
> @@ -35,6 +35,7 @@ properties:
>      maxItems: 1
>  
>    clocks:
> +    maxItems: 1
>      description:
>        A list of phandle and clock specifier pair that controls the single
>        SRAM clock.
> @@ -46,6 +47,7 @@ properties:
>      const: 1
>  
>    ranges:
> +    maxItems: 1
>      description:
>        Should translate from local addresses within the sram to bus addresses.
>  
> diff --git a/Documentation/devicetree/bindings/timer/allwinner,sun4i-a10-timer.yaml b/Documentation/devicetree/bindings/timer/allwinner,sun4i-a10-timer.yaml
> index d918cee100ac..1c7cf32e7ac2 100644
> --- a/Documentation/devicetree/bindings/timer/allwinner,sun4i-a10-timer.yaml
> +++ b/Documentation/devicetree/bindings/timer/allwinner,sun4i-a10-timer.yaml
> @@ -22,6 +22,8 @@ properties:
>      maxItems: 1
>  
>    interrupts:
> +    minItems: 2
> +    maxItems: 6
>      description:
>        List of timers interrupts
>  
> diff --git a/Documentation/devicetree/bindings/timer/intel,ixp4xx-timer.yaml b/Documentation/devicetree/bindings/timer/intel,ixp4xx-timer.yaml
> index 1a721d8af67a..a8de99b0c0f9 100644
> --- a/Documentation/devicetree/bindings/timer/intel,ixp4xx-timer.yaml
> +++ b/Documentation/devicetree/bindings/timer/intel,ixp4xx-timer.yaml
> @@ -18,7 +18,7 @@ properties:
>        - const: intel,ixp4xx-timer
>  
>    reg:
> -    description: Should contain registers location and length
> +    maxItems: 1
>  
>    interrupts:
>      minItems: 1
> diff --git a/Documentation/devicetree/bindings/usb/allwinner,sun4i-a10-musb.yaml b/Documentation/devicetree/bindings/usb/allwinner,sun4i-a10-musb.yaml
> index d9207bf9d894..0f520f17735e 100644
> --- a/Documentation/devicetree/bindings/usb/allwinner,sun4i-a10-musb.yaml
> +++ b/Documentation/devicetree/bindings/usb/allwinner,sun4i-a10-musb.yaml
> @@ -39,7 +39,7 @@ properties:
>      maxItems: 1
>  
>    phys:
> -    description: PHY specifier for the OTG PHY
> +    maxItems: 1
>  
>    phy-names:
>      const: usb
> diff --git a/Documentation/devicetree/bindings/usb/brcm,usb-pinmap.yaml b/Documentation/devicetree/bindings/usb/brcm,usb-pinmap.yaml
> index ffa148b9eaa8..d4618d15ecc1 100644
> --- a/Documentation/devicetree/bindings/usb/brcm,usb-pinmap.yaml
> +++ b/Documentation/devicetree/bindings/usb/brcm,usb-pinmap.yaml
> @@ -22,6 +22,8 @@ properties:
>      description: Interrupt for signals mirrored to out-gpios.
>  
>    in-gpios:
> +    minItems: 1
> +    maxItems: 2
>      description: Array of one or two GPIO pins used for input signals.
>  
>    brcm,in-functions:
> @@ -33,6 +35,7 @@ properties:
>      description: Array of enable and mask pairs, one per gpio in-gpios.
>  
>    out-gpios:
> +    maxItems: 1
>      description: Array of one GPIO pin used for output signals.
>  
>    brcm,out-functions:
> diff --git a/Documentation/devicetree/bindings/usb/generic-ehci.yaml b/Documentation/devicetree/bindings/usb/generic-ehci.yaml
> index 247ef00381ea..f76b25f7fc7a 100644
> --- a/Documentation/devicetree/bindings/usb/generic-ehci.yaml
> +++ b/Documentation/devicetree/bindings/usb/generic-ehci.yaml
> @@ -83,6 +83,7 @@ properties:
>        Phandle of a companion.
>  
>    phys:
> +    maxItems: 1
>      description: PHY specifier for the USB PHY
>  
>    phy-names:
> diff --git a/Documentation/devicetree/bindings/usb/generic-ohci.yaml b/Documentation/devicetree/bindings/usb/generic-ohci.yaml
> index 2178bcc401bc..8e2bd61f2075 100644
> --- a/Documentation/devicetree/bindings/usb/generic-ohci.yaml
> +++ b/Documentation/devicetree/bindings/usb/generic-ohci.yaml
> @@ -71,6 +71,7 @@ properties:
>        Overrides the detected port count
>  
>    phys:
> +    maxItems: 1
>      description: PHY specifier for the USB PHY
>  
>    phy-names:
> diff --git a/Documentation/devicetree/bindings/usb/ingenic,musb.yaml b/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
> index 678396eeeb78..f506225a4d57 100644
> --- a/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
> +++ b/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
> @@ -40,7 +40,7 @@ properties:
>        - const: mc
>  
>    phys:
> -    description: PHY specifier for the USB PHY
> +    maxItems: 1
>  
>    usb-role-switch:
>      type: boolean
> diff --git a/Documentation/devicetree/bindings/usb/renesas,usbhs.yaml b/Documentation/devicetree/bindings/usb/renesas,usbhs.yaml
> index 54c361d4a7af..e67223d90bb7 100644
> --- a/Documentation/devicetree/bindings/usb/renesas,usbhs.yaml
> +++ b/Documentation/devicetree/bindings/usb/renesas,usbhs.yaml
> @@ -68,6 +68,7 @@ properties:
>        Integer to use BUSWAIT register.
>  
>    renesas,enable-gpio:
> +    maxItems: 1
>      description: |
>        gpio specifier to check GPIO determining if USB function should be
>        enabled.
> diff --git a/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml b/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
> index 388245b91a55..adce36e48bc9 100644
> --- a/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
> +++ b/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
> @@ -15,13 +15,14 @@ properties:
>        - const: ti,j721e-usb
>  
>    reg:
> -    description: module registers
> +    maxItems: 1
>  
>    power-domains:
>      description:
>        PM domain provider node and an args specifier containing
>        the USB device id value. See,
>        Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
> +    maxItems: 1
>  
>    clocks:
>      description: Clock phandles to usb2_refclk and lpm_clk
> diff --git a/Documentation/devicetree/bindings/usb/ti,keystone-dwc3.yaml b/Documentation/devicetree/bindings/usb/ti,keystone-dwc3.yaml
> index c1b19fc5d0a2..91ef374faba8 100644
> --- a/Documentation/devicetree/bindings/usb/ti,keystone-dwc3.yaml
> +++ b/Documentation/devicetree/bindings/usb/ti,keystone-dwc3.yaml
> @@ -43,12 +43,14 @@ properties:
>      maxItems: 2
>  
>    power-domains:
> +    maxItems: 1
>      description: Should contain a phandle to a PM domain provider node
>        and an args specifier containing the USB device id
>        value. This property is as per the binding,
>        Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
>  
>    phys:
> +    maxItems: 1
>      description:
>        PHY specifier for the USB3.0 PHY. Some SoCs need the USB3.0 PHY
>        to be turned on before the controller.
> -- 
> 2.27.0
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
