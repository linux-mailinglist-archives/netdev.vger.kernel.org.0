Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364532823E0
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 13:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgJCLhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 07:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgJCLhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 07:37:20 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DFBC0613D0;
        Sat,  3 Oct 2020 04:37:20 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id l4so530064ota.7;
        Sat, 03 Oct 2020 04:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1gfLsRRQHZKUAZIkPlx6rV9sBkRfmLoX57IjEcejUQY=;
        b=VdaLVkpz56hrOncBzhbawES1+479EuQ31sUuchYTkfUvDkc8h+KptBNU8fDx0JxBng
         MA00tF1ciTZL1mnNYdgt5Ec9K6isll8MLt9xCTj5aX9msJiPnCu4sVIQt9s05TKq7wer
         iwZ1n+s8GQ2E429s4iLMfoeRjLr+ybuVRJdxRbiaojC0rRN3NHNkzQUztLSOUp98IO3f
         fdmxdTyVdAtgn3bOdkexoZBc27+DxKDD9hFp9fXSUjnqTezpbvP/QfiGJykkr++5Sz8+
         B2LzfKjnLVax5s007IJcgs3zUINkpvyknQKXiXkch/OEk9x4pDi08ONS1wsGjAtOl8rH
         S2Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :reply-to:references:mime-version:content-disposition:in-reply-to
         :user-agent;
        bh=1gfLsRRQHZKUAZIkPlx6rV9sBkRfmLoX57IjEcejUQY=;
        b=P5SI7Dkk3PXzU+eCkA2N0mm5QuSqn8VnsgqncpjE3aDouEphoZABbs+I4k/B2xDaUP
         ARJ6hOPUnej9p3T5eBTEwN31/+Sjn0PUi8yWsKOVj3GBpAXjUhUu9DEOy4q7dcWRb4qI
         l2ULtLyAN+RNv05xv1SQuqLTNREtKNR64k78+T6BWGVZo42OWty4Pbm30gVtQANIixK0
         Oq63eloqbTlQw4HWbXD32+VY34kKFN0ndmZaEctEac4Lx7VBNlSMnjwoWLMcxURXidjB
         af581FLMPZQeOXrKOQGwkQJHtc6TGnxGdOrRpA8skx8CuG4DJWF95Wkc/g1upc9tT3zL
         5k0g==
X-Gm-Message-State: AOAM530+otRA1X0Wk1iI/gBOF8BnwiKKA7owhMpU++U2c/0WTK3jFCPy
        tJytAqMqV190D7+t0kVbqw==
X-Google-Smtp-Source: ABdhPJwAgMiLpR0yKKHR1P3q0geamkrRzZK7pXUx+ZuUnNkIlwnZSf119UlnceaHgBdKUronzw47vg==
X-Received: by 2002:a05:6830:20d8:: with SMTP id z24mr5091420otq.3.1601725039286;
        Sat, 03 Oct 2020 04:37:19 -0700 (PDT)
Received: from serve.minyard.net ([47.184.170.156])
        by smtp.gmail.com with ESMTPSA id 38sm551996ota.42.2020.10.03.04.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 04:37:18 -0700 (PDT)
Sender: Corey Minyard <tcminyard@gmail.com>
Received: from minyard.net (unknown [IPv6:2001:470:b8f6:1b:2913:2eaa:6640:99ab])
        by serve.minyard.net (Postfix) with ESMTPSA id 75B4D18003B;
        Sat,  3 Oct 2020 11:37:16 +0000 (UTC)
Date:   Sat, 3 Oct 2020 06:37:15 -0500
From:   Corey Minyard <minyard@acm.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Lee Jones <lee.jones@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vinod Koul <vkoul@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-spi@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Another round of adding missing
 'additionalProperties'
Message-ID: <20201003113715.GG3674@minyard.net>
Reply-To: minyard@acm.org
References: <20201002234143.3570746-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002234143.3570746-1-robh@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 06:41:43PM -0500, Rob Herring wrote:
> Another round of wack-a-mole. The json-schema default is additional
> unknown properties are allowed, but for DT all properties should be
> defined.
> 
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Shawn Guo <shawnguo@kernel.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Baolin Wang <baolin.wang7@gmail.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: linux-clk@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-spi@vger.kernel.org
> Cc: linux-gpio@vger.kernel.org
> Cc: linux-hwmon@vger.kernel.org
> Cc: linux-iio@vger.kernel.org
> Cc: openipmi-developer@lists.sourceforge.net
> Cc: linux-leds@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: linux-rockchip@lists.infradead.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> Cc: linux-mips@vger.kernel.org
> Cc: linux-mmc@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-remoteproc@vger.kernel.org
> Cc: linux-serial@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> 
> I'll take this thru the DT tree.
> 
>  .../arm/bcm/raspberrypi,bcm2835-firmware.yaml |  2 ++
>  .../arm/mediatek/mediatek,pericfg.yaml        |  2 ++
>  .../devicetree/bindings/arm/pmu.yaml          |  2 ++
>  .../devicetree/bindings/arm/primecell.yaml    |  3 +++
>  .../bindings/arm/samsung/sysreg.yaml          |  2 ++
>  .../arm/tegra/nvidia,tegra20-pmc.yaml         |  2 ++
>  .../bindings/bus/mti,mips-cdmm.yaml           |  2 ++
>  .../bus/socionext,uniphier-system-bus.yaml    |  7 +++++++
>  .../bindings/clock/arm,syscon-icst.yaml       |  2 ++
>  .../bindings/clock/idt,versaclock5.yaml       | 20 ++++++++++---------
>  .../bindings/clock/imx6q-clock.yaml           |  2 ++
>  .../bindings/clock/imx6sl-clock.yaml          |  2 ++
>  .../bindings/clock/imx6sll-clock.yaml         |  2 ++
>  .../bindings/clock/imx6sx-clock.yaml          |  2 ++
>  .../bindings/clock/imx6ul-clock.yaml          |  2 ++
>  .../bindings/clock/intel,cgu-lgm.yaml         |  2 ++
>  .../bindings/clock/qcom,gcc-sm8250.yaml       |  2 ++
>  .../bindings/clock/sprd,sc9863a-clk.yaml      |  2 ++
>  .../bindings/clock/ti,am654-ehrpwm-tbclk.yaml |  2 ++
>  .../bindings/display/bridge/ite,it6505.yaml   |  5 +++++
>  .../bindings/display/bridge/lvds-codec.yaml   |  3 +++
>  .../devicetree/bindings/display/msm/gmu.yaml  |  2 ++
>  .../devicetree/bindings/edac/dmc-520.yaml     |  2 ++
>  .../devicetree/bindings/fsi/ibm,fsi2spi.yaml  |  2 ++
>  .../gpio/socionext,uniphier-gpio.yaml         |  2 ++
>  .../bindings/hwmon/adi,axi-fan-control.yaml   |  2 ++
>  .../devicetree/bindings/hwmon/adt7475.yaml    |  2 ++
>  .../bindings/iio/accel/kionix,kxsd9.yaml      |  4 ++++
>  .../bindings/iio/adc/maxim,max1238.yaml       |  2 ++
>  .../bindings/iio/adc/maxim,max1363.yaml       |  2 ++
>  .../bindings/iio/adc/qcom,spmi-vadc.yaml      |  4 ++++
>  .../bindings/iio/adc/samsung,exynos-adc.yaml  |  2 ++
>  .../bindings/iio/adc/ti,ads8688.yaml          |  4 ++++
>  .../bindings/iio/amplifiers/adi,hmc425a.yaml  |  2 ++
>  .../bindings/iio/imu/invensense,icm42600.yaml |  6 ++++++
>  .../bindings/iio/light/amstaos,tsl2563.yaml   |  2 ++
>  .../bindings/iio/light/dynaimage,al3010.yaml  |  2 ++
>  .../bindings/iio/light/dynaimage,al3320a.yaml |  2 ++
>  .../bindings/iio/light/sharp,gp2ap002.yaml    |  2 ++
>  .../iio/magnetometer/asahi-kasei,ak8975.yaml  |  2 ++
>  .../iio/proximity/vishay,vcnl3020.yaml        |  2 ++
>  .../interrupt-controller/ingenic,intc.yaml    |  2 ++
>  .../loongson,pch-msi.yaml                     |  2 ++
>  .../loongson,pch-pic.yaml                     |  2 ++
>  .../devicetree/bindings/ipmi/ipmi-smic.yaml   |  2 ++
>  .../devicetree/bindings/leds/leds-lp55xx.yaml |  8 ++++++++
>  .../bindings/media/i2c/chrontel,ch7322.yaml   |  2 ++
>  .../bindings/media/i2c/imi,rdacm2x-gmsl.yaml  |  2 ++
>  .../bindings/media/nxp,imx8mq-vpu.yaml        |  2 ++
>  .../bindings/media/qcom,msm8916-venus.yaml    |  2 ++
>  .../bindings/media/qcom,msm8996-venus.yaml    |  2 ++
>  .../bindings/media/qcom,sc7180-venus.yaml     |  2 ++
>  .../bindings/media/qcom,sdm845-venus-v2.yaml  |  2 ++
>  .../bindings/media/qcom,sdm845-venus.yaml     |  2 ++
>  .../bindings/memory-controllers/fsl/mmdc.yaml |  2 ++
>  .../memory-controllers/st,stm32-fmc2-ebi.yaml |  2 ++
>  .../bindings/mfd/gateworks-gsc.yaml           |  2 ++
>  .../bindings/mfd/xylon,logicvc.yaml           | 14 +++++++++++--
>  .../bindings/mips/ingenic/ingenic,cpu.yaml    |  6 ++++--
>  .../bindings/mips/loongson/rs780e-acpi.yaml   |  2 ++
>  .../bindings/mmc/mmc-pwrseq-emmc.yaml         |  2 ++
>  .../bindings/mmc/mmc-pwrseq-sd8787.yaml       |  2 ++
>  .../bindings/mmc/mmc-pwrseq-simple.yaml       |  2 ++
>  .../devicetree/bindings/net/qcom,ipa.yaml     |  2 ++
>  .../bindings/net/realtek-bluetooth.yaml       |  4 +++-
>  .../net/wireless/microchip,wilc1000.yaml      |  4 ++++
>  .../devicetree/bindings/pci/rcar-pci-ep.yaml  |  2 ++
>  .../phy/amlogic,meson-g12a-usb2-phy.yaml      |  2 ++
>  .../bindings/phy/qcom,ipq806x-usb-phy-hs.yaml |  2 ++
>  .../bindings/phy/qcom,ipq806x-usb-phy-ss.yaml |  2 ++
>  .../bindings/phy/qcom,qusb2-phy.yaml          |  1 +
>  .../bindings/phy/qcom-usb-ipq4019-phy.yaml    |  2 ++
>  .../bindings/pinctrl/cirrus,lochnagar.yaml    |  2 ++
>  .../pinctrl/socionext,uniphier-pinctrl.yaml   |  2 ++
>  .../power/amlogic,meson-sec-pwrc.yaml         |  2 ++
>  .../bindings/power/domain-idle-state.yaml     |  2 ++
>  .../bindings/power/mti,mips-cpc.yaml          |  2 ++
>  .../bindings/power/supply/cw2015_battery.yaml |  2 ++
>  .../bindings/power/supply/rohm,bd99954.yaml   |  8 ++++++++
>  .../bindings/regulator/silergy,sy8827n.yaml   |  2 ++
>  .../bindings/remoteproc/qcom,pil-info.yaml    |  2 ++
>  .../bindings/serial/samsung_uart.yaml         |  2 ++
>  .../serial/socionext,uniphier-uart.yaml       |  2 ++
>  .../devicetree/bindings/serial/sprd-uart.yaml |  2 ++
>  .../bindings/soc/qcom/qcom,geni-se.yaml       |  1 +
>  .../bindings/sound/amlogic,g12a-toacodec.yaml |  2 ++
>  .../bindings/sound/amlogic,gx-sound-card.yaml |  2 ++
>  .../bindings/sound/amlogic,t9015.yaml         |  2 ++
>  .../bindings/sound/cirrus,cs42l51.yaml        |  2 ++
>  .../devicetree/bindings/sound/fsl,easrc.yaml  |  2 ++
>  .../bindings/sound/intel,keembay-i2s.yaml     |  2 ++
>  .../bindings/sound/nvidia,tegra186-dspk.yaml  |  2 ++
>  .../sound/nvidia,tegra210-admaif.yaml         |  2 ++
>  .../bindings/sound/nvidia,tegra210-dmic.yaml  |  2 ++
>  .../bindings/sound/nvidia,tegra210-i2s.yaml   |  2 ++
>  .../bindings/sound/rockchip,rk3328-codec.yaml |  2 ++
>  .../bindings/sound/tlv320adcx140.yaml         |  2 ++
>  .../bindings/thermal/rcar-thermal.yaml        |  5 +++++
>  .../bindings/thermal/sprd-thermal.yaml        |  4 ++++
>  .../bindings/thermal/thermal-idle.yaml        |  2 ++
>  .../bindings/thermal/thermal-zones.yaml       |  2 ++
>  .../devicetree/bindings/timer/cdns,ttc.yaml   |  2 ++
>  .../bindings/usb/nvidia,tegra-xudc.yaml       |  2 ++
>  .../devicetree/bindings/usb/qcom,dwc3.yaml    |  2 ++
>  .../devicetree/bindings/usb/ti,j721e-usb.yaml | 18 +++++++++++++++++
>  105 files changed, 285 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/bcm/raspberrypi,bcm2835-firmware.yaml b/Documentation/devicetree/bindings/arm/bcm/raspberrypi,bcm2835-firmware.yaml
> index 6834f5e8df5f..9fdb319dcf19 100644
> --- a/Documentation/devicetree/bindings/arm/bcm/raspberrypi,bcm2835-firmware.yaml
> +++ b/Documentation/devicetree/bindings/arm/bcm/raspberrypi,bcm2835-firmware.yaml
> @@ -54,6 +54,8 @@ required:
>    - compatible
>    - mboxes
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      firmware {
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
> index 1af30174b2d0..8723dfe34bab 100644
> --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
> @@ -47,6 +47,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      pericfg@10003000 {
> diff --git a/Documentation/devicetree/bindings/arm/pmu.yaml b/Documentation/devicetree/bindings/arm/pmu.yaml
> index 97df36d301c9..693ef3f185a8 100644
> --- a/Documentation/devicetree/bindings/arm/pmu.yaml
> +++ b/Documentation/devicetree/bindings/arm/pmu.yaml
> @@ -93,4 +93,6 @@ properties:
>  required:
>    - compatible
>  
> +additionalProperties: false
> +
>  ...
> diff --git a/Documentation/devicetree/bindings/arm/primecell.yaml b/Documentation/devicetree/bindings/arm/primecell.yaml
> index 5aae37f1c563..e15fe00aafb2 100644
> --- a/Documentation/devicetree/bindings/arm/primecell.yaml
> +++ b/Documentation/devicetree/bindings/arm/primecell.yaml
> @@ -33,4 +33,7 @@ properties:
>      contains:
>        const: apb_pclk
>      additionalItems: true
> +
> +additionalProperties: true
> +
>  ...
> diff --git a/Documentation/devicetree/bindings/arm/samsung/sysreg.yaml b/Documentation/devicetree/bindings/arm/samsung/sysreg.yaml
> index 3b7811804cb4..2ac789058eee 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/sysreg.yaml
> +++ b/Documentation/devicetree/bindings/arm/samsung/sysreg.yaml
> @@ -32,6 +32,8 @@ properties:
>    reg:
>      maxItems: 1
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      syscon@10010000 {
> diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.yaml b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.yaml
> index b71a20af5f70..43fd2f8927d0 100644
> --- a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.yaml
> +++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.yaml
> @@ -308,6 +308,8 @@ required:
>    - clocks
>    - '#clock-cells'
>  
> +additionalProperties: false
> +
>  dependencies:
>    "nvidia,suspend-mode": ["nvidia,core-pwr-off-time", "nvidia,cpu-pwr-off-time"]
>    "nvidia,core-pwr-off-time": ["nvidia,core-pwr-good-time"]
> diff --git a/Documentation/devicetree/bindings/bus/mti,mips-cdmm.yaml b/Documentation/devicetree/bindings/bus/mti,mips-cdmm.yaml
> index 9cc2d5f1beef..6a7b26b049f1 100644
> --- a/Documentation/devicetree/bindings/bus/mti,mips-cdmm.yaml
> +++ b/Documentation/devicetree/bindings/bus/mti,mips-cdmm.yaml
> @@ -26,6 +26,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      cdmm@1bde8000 {
> diff --git a/Documentation/devicetree/bindings/bus/socionext,uniphier-system-bus.yaml b/Documentation/devicetree/bindings/bus/socionext,uniphier-system-bus.yaml
> index a0c6c5d2b70f..49df13fc2f89 100644
> --- a/Documentation/devicetree/bindings/bus/socionext,uniphier-system-bus.yaml
> +++ b/Documentation/devicetree/bindings/bus/socionext,uniphier-system-bus.yaml
> @@ -57,6 +57,11 @@ properties:
>        "ranges" property should provide a "reasonable" default that is known to
>        work. The software should initialize the bus controller according to it.
>  
> +patternProperties:
> +  "^.*@[1-5],[1-9a-f][0-9a-f]+$":
> +    description: Devices attached to chip selects
> +    type: object
> +
>  required:
>    - compatible
>    - reg
> @@ -64,6 +69,8 @@ required:
>    - "#size-cells"
>    - ranges
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      // In this example,
> diff --git a/Documentation/devicetree/bindings/clock/arm,syscon-icst.yaml b/Documentation/devicetree/bindings/clock/arm,syscon-icst.yaml
> index 444aeea27db8..eb241587efd1 100644
> --- a/Documentation/devicetree/bindings/clock/arm,syscon-icst.yaml
> +++ b/Documentation/devicetree/bindings/clock/arm,syscon-icst.yaml
> @@ -89,6 +89,8 @@ required:
>    - compatible
>    - clocks
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      vco1: clock {
> diff --git a/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml b/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
> index 28c6461b9a9a..2ac1131fd922 100644
> --- a/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
> +++ b/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
> @@ -50,6 +50,15 @@ properties:
>    '#clock-cells':
>      const: 1
>  
> +  clock-names:
> +    minItems: 1
> +    maxItems: 2
> +    items:
> +      enum: [ xin, clkin ]
> +  clocks:
> +    minItems: 1
> +    maxItems: 2
> +
>  patternProperties:
>    "^OUT[1-4]$":
>      type: object
> @@ -93,19 +102,12 @@ allOf:
>            maxItems: 1
>      else:
>        # Devices without builtin crystal
> -      properties:
> -        clock-names:
> -          minItems: 1
> -          maxItems: 2
> -          items:
> -            enum: [ xin, clkin ]
> -        clocks:
> -          minItems: 1
> -          maxItems: 2
>        required:
>          - clock-names
>          - clocks
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clk/versaclock.h>
> diff --git a/Documentation/devicetree/bindings/clock/imx6q-clock.yaml b/Documentation/devicetree/bindings/clock/imx6q-clock.yaml
> index 92a8e545e212..4f4637eddb8b 100644
> --- a/Documentation/devicetree/bindings/clock/imx6q-clock.yaml
> +++ b/Documentation/devicetree/bindings/clock/imx6q-clock.yaml
> @@ -57,6 +57,8 @@ required:
>    - interrupts
>    - '#clock-cells'
>  
> +additionalProperties: false
> +
>  examples:
>    # Clock Control Module node:
>    - |
> diff --git a/Documentation/devicetree/bindings/clock/imx6sl-clock.yaml b/Documentation/devicetree/bindings/clock/imx6sl-clock.yaml
> index c97bf95b4150..b83c8f43d664 100644
> --- a/Documentation/devicetree/bindings/clock/imx6sl-clock.yaml
> +++ b/Documentation/devicetree/bindings/clock/imx6sl-clock.yaml
> @@ -33,6 +33,8 @@ required:
>    - interrupts
>    - '#clock-cells'
>  
> +additionalProperties: false
> +
>  examples:
>    # Clock Control Module node:
>    - |
> diff --git a/Documentation/devicetree/bindings/clock/imx6sll-clock.yaml b/Documentation/devicetree/bindings/clock/imx6sll-clock.yaml
> index de48924be191..484894a4b23f 100644
> --- a/Documentation/devicetree/bindings/clock/imx6sll-clock.yaml
> +++ b/Documentation/devicetree/bindings/clock/imx6sll-clock.yaml
> @@ -49,6 +49,8 @@ required:
>    - clocks
>    - clock-names
>  
> +additionalProperties: false
> +
>  examples:
>    # Clock Control Module node:
>    - |
> diff --git a/Documentation/devicetree/bindings/clock/imx6sx-clock.yaml b/Documentation/devicetree/bindings/clock/imx6sx-clock.yaml
> index e50cddee43c3..e6c795657c24 100644
> --- a/Documentation/devicetree/bindings/clock/imx6sx-clock.yaml
> +++ b/Documentation/devicetree/bindings/clock/imx6sx-clock.yaml
> @@ -53,6 +53,8 @@ required:
>    - clocks
>    - clock-names
>  
> +additionalProperties: false
> +
>  examples:
>    # Clock Control Module node:
>    - |
> diff --git a/Documentation/devicetree/bindings/clock/imx6ul-clock.yaml b/Documentation/devicetree/bindings/clock/imx6ul-clock.yaml
> index 36ce7667c972..6a51a3f51cd9 100644
> --- a/Documentation/devicetree/bindings/clock/imx6ul-clock.yaml
> +++ b/Documentation/devicetree/bindings/clock/imx6ul-clock.yaml
> @@ -49,6 +49,8 @@ required:
>    - clocks
>    - clock-names
>  
> +additionalProperties: false
> +
>  examples:
>    # Clock Control Module node:
>    - |
> diff --git a/Documentation/devicetree/bindings/clock/intel,cgu-lgm.yaml b/Documentation/devicetree/bindings/clock/intel,cgu-lgm.yaml
> index 6dc1414bfb7f..f3e1a700a2ca 100644
> --- a/Documentation/devicetree/bindings/clock/intel,cgu-lgm.yaml
> +++ b/Documentation/devicetree/bindings/clock/intel,cgu-lgm.yaml
> @@ -33,6 +33,8 @@ required:
>    - reg
>    - '#clock-cells'
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      cgu: clock-controller@e0200000 {
> diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sm8250.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sm8250.yaml
> index a5766ff89082..80bd6caf5bc9 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,gcc-sm8250.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sm8250.yaml
> @@ -56,6 +56,8 @@ required:
>    - '#reset-cells'
>    - '#power-domain-cells'
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/qcom,rpmh.h>
> diff --git a/Documentation/devicetree/bindings/clock/sprd,sc9863a-clk.yaml b/Documentation/devicetree/bindings/clock/sprd,sc9863a-clk.yaml
> index c6d091518650..4069e09cb62d 100644
> --- a/Documentation/devicetree/bindings/clock/sprd,sc9863a-clk.yaml
> +++ b/Documentation/devicetree/bindings/clock/sprd,sc9863a-clk.yaml
> @@ -73,6 +73,8 @@ else:
>      The 'reg' property for the clock node is also required if there is a sub
>      range of registers for the clocks.
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      ap_clk: clock-controller@21500000 {
> diff --git a/Documentation/devicetree/bindings/clock/ti,am654-ehrpwm-tbclk.yaml b/Documentation/devicetree/bindings/clock/ti,am654-ehrpwm-tbclk.yaml
> index 869b18ac88d7..6b419a9878f3 100644
> --- a/Documentation/devicetree/bindings/clock/ti,am654-ehrpwm-tbclk.yaml
> +++ b/Documentation/devicetree/bindings/clock/ti,am654-ehrpwm-tbclk.yaml
> @@ -26,6 +26,8 @@ required:
>    - "#clock-cells"
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      ehrpwm_tbclk: syscon@4140 {
> diff --git a/Documentation/devicetree/bindings/display/bridge/ite,it6505.yaml b/Documentation/devicetree/bindings/display/bridge/ite,it6505.yaml
> index 2c500166c65d..efbb3d0117dc 100644
> --- a/Documentation/devicetree/bindings/display/bridge/ite,it6505.yaml
> +++ b/Documentation/devicetree/bindings/display/bridge/ite,it6505.yaml
> @@ -31,6 +31,9 @@ properties:
>    compatible:
>      const: ite,it6505
>  
> +  reg:
> +    maxItems: 1
> +
>    ovdd-supply:
>      maxItems: 1
>      description: I/O voltage
> @@ -63,6 +66,8 @@ required:
>    - reset-gpios
>    - extcon
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/display/bridge/lvds-codec.yaml b/Documentation/devicetree/bindings/display/bridge/lvds-codec.yaml
> index 68951d56ebba..e8fa8e901c9f 100644
> --- a/Documentation/devicetree/bindings/display/bridge/lvds-codec.yaml
> +++ b/Documentation/devicetree/bindings/display/bridge/lvds-codec.yaml
> @@ -83,6 +83,9 @@ required:
>    - compatible
>    - ports
>  
> +additionalProperties: false
> +
> +
>  examples:
>    - |
>      lvds-encoder {
> diff --git a/Documentation/devicetree/bindings/display/msm/gmu.yaml b/Documentation/devicetree/bindings/display/msm/gmu.yaml
> index 53056dd02597..fe55611d2603 100644
> --- a/Documentation/devicetree/bindings/display/msm/gmu.yaml
> +++ b/Documentation/devicetree/bindings/display/msm/gmu.yaml
> @@ -89,6 +89,8 @@ required:
>    - iommus
>    - operating-points-v2
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/qcom,gpucc-sdm845.h>
> diff --git a/Documentation/devicetree/bindings/edac/dmc-520.yaml b/Documentation/devicetree/bindings/edac/dmc-520.yaml
> index 9272d2bd8634..3b6842e92d1b 100644
> --- a/Documentation/devicetree/bindings/edac/dmc-520.yaml
> +++ b/Documentation/devicetree/bindings/edac/dmc-520.yaml
> @@ -49,6 +49,8 @@ required:
>    - interrupts
>    - interrupt-names
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      dmc0: dmc@200000 {
> diff --git a/Documentation/devicetree/bindings/fsi/ibm,fsi2spi.yaml b/Documentation/devicetree/bindings/fsi/ibm,fsi2spi.yaml
> index b26d4b4be743..e2ca0b000471 100644
> --- a/Documentation/devicetree/bindings/fsi/ibm,fsi2spi.yaml
> +++ b/Documentation/devicetree/bindings/fsi/ibm,fsi2spi.yaml
> @@ -28,6 +28,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      fsi2spi@1c00 {
> diff --git a/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml b/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml
> index c58ff9a94f45..1a54db04f29d 100644
> --- a/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml
> +++ b/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml
> @@ -64,6 +64,8 @@ required:
>    - gpio-ranges
>    - socionext,interrupt-ranges
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml b/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml
> index 7898b9dba5a5..6747b870f297 100644
> --- a/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml
> +++ b/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml
> @@ -44,6 +44,8 @@ required:
>    - interrupts
>    - pulses-per-revolution
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      fpga_axi: fpga-axi {
> diff --git a/Documentation/devicetree/bindings/hwmon/adt7475.yaml b/Documentation/devicetree/bindings/hwmon/adt7475.yaml
> index dfa821c0aacc..ad0ec9f35bd8 100644
> --- a/Documentation/devicetree/bindings/hwmon/adt7475.yaml
> +++ b/Documentation/devicetree/bindings/hwmon/adt7475.yaml
> @@ -65,6 +65,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c {
> diff --git a/Documentation/devicetree/bindings/iio/accel/kionix,kxsd9.yaml b/Documentation/devicetree/bindings/iio/accel/kionix,kxsd9.yaml
> index d61ab4fa3d71..390b87242fcb 100644
> --- a/Documentation/devicetree/bindings/iio/accel/kionix,kxsd9.yaml
> +++ b/Documentation/devicetree/bindings/iio/accel/kionix,kxsd9.yaml
> @@ -29,10 +29,14 @@ properties:
>    mount-matrix:
>      description: an optional 3x3 mounting rotation matrix.
>  
> +  spi-max-frequency: true
> +
>  required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      # include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/iio/adc/maxim,max1238.yaml b/Documentation/devicetree/bindings/iio/adc/maxim,max1238.yaml
> index cccd3033a55b..50bcd72ac9d6 100644
> --- a/Documentation/devicetree/bindings/iio/adc/maxim,max1238.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/maxim,max1238.yaml
> @@ -62,6 +62,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c {
> diff --git a/Documentation/devicetree/bindings/iio/adc/maxim,max1363.yaml b/Documentation/devicetree/bindings/iio/adc/maxim,max1363.yaml
> index 48377549c39a..e04f09f35601 100644
> --- a/Documentation/devicetree/bindings/iio/adc/maxim,max1363.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/maxim,max1363.yaml
> @@ -36,6 +36,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c {
> diff --git a/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.yaml b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.yaml
> index 0ca992465a21..7f4f827c57a7 100644
> --- a/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.yaml
> @@ -48,6 +48,8 @@ properties:
>      description:
>        End of conversion interrupt.
>  
> +  io-channel-ranges: true
> +
>  required:
>    - compatible
>    - reg
> @@ -232,6 +234,8 @@ allOf:
>                enum: [ 1, 2, 4, 8, 16 ]
>                default: 1
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      spmi_bus {
> diff --git a/Documentation/devicetree/bindings/iio/adc/samsung,exynos-adc.yaml b/Documentation/devicetree/bindings/iio/adc/samsung,exynos-adc.yaml
> index cc3c8ea6a894..16d76482b4ff 100644
> --- a/Documentation/devicetree/bindings/iio/adc/samsung,exynos-adc.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/samsung,exynos-adc.yaml
> @@ -107,6 +107,8 @@ allOf:
>            items:
>              - const: adc
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      adc: adc@12d10000 {
> diff --git a/Documentation/devicetree/bindings/iio/adc/ti,ads8688.yaml b/Documentation/devicetree/bindings/iio/adc/ti,ads8688.yaml
> index 97fe6cbb2efa..a0af4b24877f 100644
> --- a/Documentation/devicetree/bindings/iio/adc/ti,ads8688.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/ti,ads8688.yaml
> @@ -25,10 +25,14 @@ properties:
>      description: Optional external reference.  If not supplied, assume
>        REFSEL input tied low to enable the internal reference.
>  
> +  spi-max-frequency: true
> +
>  required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      spi {
> diff --git a/Documentation/devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml b/Documentation/devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml
> index 5342360e96b1..a557761d8016 100644
> --- a/Documentation/devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml
> +++ b/Documentation/devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml
> @@ -33,6 +33,8 @@ required:
>    - compatible
>    - ctrl-gpios
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/iio/imu/invensense,icm42600.yaml b/Documentation/devicetree/bindings/iio/imu/invensense,icm42600.yaml
> index abd8d25e1136..4c1c083d0e92 100644
> --- a/Documentation/devicetree/bindings/iio/imu/invensense,icm42600.yaml
> +++ b/Documentation/devicetree/bindings/iio/imu/invensense,icm42600.yaml
> @@ -47,11 +47,17 @@ properties:
>    vddio-supply:
>      description: Regulator that provides power to the bus
>  
> +  spi-max-frequency: true
> +  spi-cpha: true
> +  spi-cpol: true
> +
>  required:
>    - compatible
>    - reg
>    - interrupts
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/iio/light/amstaos,tsl2563.yaml b/Documentation/devicetree/bindings/iio/light/amstaos,tsl2563.yaml
> index e201a06d8fdc..60e76bc035a5 100644
> --- a/Documentation/devicetree/bindings/iio/light/amstaos,tsl2563.yaml
> +++ b/Documentation/devicetree/bindings/iio/light/amstaos,tsl2563.yaml
> @@ -32,6 +32,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c {
> diff --git a/Documentation/devicetree/bindings/iio/light/dynaimage,al3010.yaml b/Documentation/devicetree/bindings/iio/light/dynaimage,al3010.yaml
> index f671edda6641..a3a979553e32 100644
> --- a/Documentation/devicetree/bindings/iio/light/dynaimage,al3010.yaml
> +++ b/Documentation/devicetree/bindings/iio/light/dynaimage,al3010.yaml
> @@ -26,6 +26,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/iio/light/dynaimage,al3320a.yaml b/Documentation/devicetree/bindings/iio/light/dynaimage,al3320a.yaml
> index 497300239d93..8249be99cff9 100644
> --- a/Documentation/devicetree/bindings/iio/light/dynaimage,al3320a.yaml
> +++ b/Documentation/devicetree/bindings/iio/light/dynaimage,al3320a.yaml
> @@ -26,6 +26,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/iio/light/sharp,gp2ap002.yaml b/Documentation/devicetree/bindings/iio/light/sharp,gp2ap002.yaml
> index 12aa16f24772..f8a932be0d10 100644
> --- a/Documentation/devicetree/bindings/iio/light/sharp,gp2ap002.yaml
> +++ b/Documentation/devicetree/bindings/iio/light/sharp,gp2ap002.yaml
> @@ -61,6 +61,8 @@ required:
>    - sharp,proximity-far-hysteresis
>    - sharp,proximity-close-hysteresis
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml b/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml
> index f0b336ac39c9..a25590a16ba7 100644
> --- a/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml
> +++ b/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml
> @@ -55,6 +55,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/iio/proximity/vishay,vcnl3020.yaml b/Documentation/devicetree/bindings/iio/proximity/vishay,vcnl3020.yaml
> index 51dba64037f6..fbd3a2e32280 100644
> --- a/Documentation/devicetree/bindings/iio/proximity/vishay,vcnl3020.yaml
> +++ b/Documentation/devicetree/bindings/iio/proximity/vishay,vcnl3020.yaml
> @@ -47,6 +47,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c {
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/ingenic,intc.yaml b/Documentation/devicetree/bindings/interrupt-controller/ingenic,intc.yaml
> index 02a3cf470518..0a046be8d1cd 100644
> --- a/Documentation/devicetree/bindings/interrupt-controller/ingenic,intc.yaml
> +++ b/Documentation/devicetree/bindings/interrupt-controller/ingenic,intc.yaml
> @@ -49,6 +49,8 @@ required:
>    - "#interrupt-cells"
>    - interrupt-controller
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      intc: interrupt-controller@10001000 {
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/loongson,pch-msi.yaml b/Documentation/devicetree/bindings/interrupt-controller/loongson,pch-msi.yaml
> index 1b256d9dd92a..1f6fd73d4624 100644
> --- a/Documentation/devicetree/bindings/interrupt-controller/loongson,pch-msi.yaml
> +++ b/Documentation/devicetree/bindings/interrupt-controller/loongson,pch-msi.yaml
> @@ -46,6 +46,8 @@ required:
>    - loongson,msi-base-vec
>    - loongson,msi-num-vecs
>  
> +additionalProperties: true #fixme
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/loongson,pch-pic.yaml b/Documentation/devicetree/bindings/interrupt-controller/loongson,pch-pic.yaml
> index a6dcbb2971a9..fdd6a38a31db 100644
> --- a/Documentation/devicetree/bindings/interrupt-controller/loongson,pch-pic.yaml
> +++ b/Documentation/devicetree/bindings/interrupt-controller/loongson,pch-pic.yaml
> @@ -41,6 +41,8 @@ required:
>    - interrupt-controller
>    - '#interrupt-cells'
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/ipmi/ipmi-smic.yaml b/Documentation/devicetree/bindings/ipmi/ipmi-smic.yaml
> index 58fa76ee6176..898e3267893a 100644
> --- a/Documentation/devicetree/bindings/ipmi/ipmi-smic.yaml
> +++ b/Documentation/devicetree/bindings/ipmi/ipmi-smic.yaml
> @@ -49,6 +49,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      smic@fff3a000 {

For IPMI:

Reviewd-by: Corey Minyard <cminyard@mvista.com>

> diff --git a/Documentation/devicetree/bindings/leds/leds-lp55xx.yaml b/Documentation/devicetree/bindings/leds/leds-lp55xx.yaml
> index b1bb3feb0f4d..cd877e817ad1 100644
> --- a/Documentation/devicetree/bindings/leds/leds-lp55xx.yaml
> +++ b/Documentation/devicetree/bindings/leds/leds-lp55xx.yaml
> @@ -58,6 +58,12 @@ properties:
>        - 2 # D1~6 with VOUT, D7~9 with VDD
>        - 3 # D1~9 are connected to VOUT
>  
> +  '#address-cells':
> +    const: 1
> +
> +  '#size-cells':
> +    const: 0
> +
>  patternProperties:
>    "(^led@[0-9a-f]$|led)":
>      type: object
> @@ -98,6 +104,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>     #include <dt-bindings/leds/common.h>
> diff --git a/Documentation/devicetree/bindings/media/i2c/chrontel,ch7322.yaml b/Documentation/devicetree/bindings/media/i2c/chrontel,ch7322.yaml
> index daa2869377c5..63e5b89d2e0b 100644
> --- a/Documentation/devicetree/bindings/media/i2c/chrontel,ch7322.yaml
> +++ b/Documentation/devicetree/bindings/media/i2c/chrontel,ch7322.yaml
> @@ -49,6 +49,8 @@ required:
>    - reg
>    - interrupts
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/media/i2c/imi,rdacm2x-gmsl.yaml b/Documentation/devicetree/bindings/media/i2c/imi,rdacm2x-gmsl.yaml
> index 107c862a7fc7..3dc06c628e64 100644
> --- a/Documentation/devicetree/bindings/media/i2c/imi,rdacm2x-gmsl.yaml
> +++ b/Documentation/devicetree/bindings/media/i2c/imi,rdacm2x-gmsl.yaml
> @@ -119,6 +119,8 @@ required:
>    - reg
>    - port
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c@e66d8000 {
> diff --git a/Documentation/devicetree/bindings/media/nxp,imx8mq-vpu.yaml b/Documentation/devicetree/bindings/media/nxp,imx8mq-vpu.yaml
> index a2d1cd77c1e2..762be3f96ce9 100644
> --- a/Documentation/devicetree/bindings/media/nxp,imx8mq-vpu.yaml
> +++ b/Documentation/devicetree/bindings/media/nxp,imx8mq-vpu.yaml
> @@ -55,6 +55,8 @@ required:
>    - clocks
>    - clock-names
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>          #include <dt-bindings/clock/imx8mq-clock.h>
> diff --git a/Documentation/devicetree/bindings/media/qcom,msm8916-venus.yaml b/Documentation/devicetree/bindings/media/qcom,msm8916-venus.yaml
> index f9606df02d70..59ab16ad12f1 100644
> --- a/Documentation/devicetree/bindings/media/qcom,msm8916-venus.yaml
> +++ b/Documentation/devicetree/bindings/media/qcom,msm8916-venus.yaml
> @@ -92,6 +92,8 @@ required:
>    - video-decoder
>    - video-encoder
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>          #include <dt-bindings/interrupt-controller/arm-gic.h>
> diff --git a/Documentation/devicetree/bindings/media/qcom,msm8996-venus.yaml b/Documentation/devicetree/bindings/media/qcom,msm8996-venus.yaml
> index fa0dc6c47f1d..199f45217b4a 100644
> --- a/Documentation/devicetree/bindings/media/qcom,msm8996-venus.yaml
> +++ b/Documentation/devicetree/bindings/media/qcom,msm8996-venus.yaml
> @@ -119,6 +119,8 @@ required:
>    - video-decoder
>    - video-encoder
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>          #include <dt-bindings/interrupt-controller/arm-gic.h>
> diff --git a/Documentation/devicetree/bindings/media/qcom,sc7180-venus.yaml b/Documentation/devicetree/bindings/media/qcom,sc7180-venus.yaml
> index 55f2d67ae34e..3cec6dae1139 100644
> --- a/Documentation/devicetree/bindings/media/qcom,sc7180-venus.yaml
> +++ b/Documentation/devicetree/bindings/media/qcom,sc7180-venus.yaml
> @@ -108,6 +108,8 @@ required:
>    - video-decoder
>    - video-encoder
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>          #include <dt-bindings/interrupt-controller/arm-gic.h>
> diff --git a/Documentation/devicetree/bindings/media/qcom,sdm845-venus-v2.yaml b/Documentation/devicetree/bindings/media/qcom,sdm845-venus-v2.yaml
> index 157dff8057e9..55f5d439fa61 100644
> --- a/Documentation/devicetree/bindings/media/qcom,sdm845-venus-v2.yaml
> +++ b/Documentation/devicetree/bindings/media/qcom,sdm845-venus-v2.yaml
> @@ -103,6 +103,8 @@ required:
>    - video-core0
>    - video-core1
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>          #include <dt-bindings/interrupt-controller/arm-gic.h>
> diff --git a/Documentation/devicetree/bindings/media/qcom,sdm845-venus.yaml b/Documentation/devicetree/bindings/media/qcom,sdm845-venus.yaml
> index 084e45e2df62..680f37726fdf 100644
> --- a/Documentation/devicetree/bindings/media/qcom,sdm845-venus.yaml
> +++ b/Documentation/devicetree/bindings/media/qcom,sdm845-venus.yaml
> @@ -120,6 +120,8 @@ required:
>    - video-core0
>    - video-core1
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>          #include <dt-bindings/interrupt-controller/arm-gic.h>
> diff --git a/Documentation/devicetree/bindings/memory-controllers/fsl/mmdc.yaml b/Documentation/devicetree/bindings/memory-controllers/fsl/mmdc.yaml
> index 68484136a510..71547eee9919 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/fsl/mmdc.yaml
> +++ b/Documentation/devicetree/bindings/memory-controllers/fsl/mmdc.yaml
> @@ -33,6 +33,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/imx6qdl-clock.h>
> diff --git a/Documentation/devicetree/bindings/memory-controllers/st,stm32-fmc2-ebi.yaml b/Documentation/devicetree/bindings/memory-controllers/st,stm32-fmc2-ebi.yaml
> index 70eaf739036b..cba74205846a 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/st,stm32-fmc2-ebi.yaml
> +++ b/Documentation/devicetree/bindings/memory-controllers/st,stm32-fmc2-ebi.yaml
> @@ -194,6 +194,8 @@ required:
>    - clocks
>    - ranges
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/arm-gic.h>
> diff --git a/Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml b/Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml
> index 9b6eb50606e8..95e47f317ed2 100644
> --- a/Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml
> +++ b/Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml
> @@ -144,6 +144,8 @@ required:
>    - "#address-cells"
>    - "#size-cells"
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/mfd/xylon,logicvc.yaml b/Documentation/devicetree/bindings/mfd/xylon,logicvc.yaml
> index abc9937506e0..8a1a6625c782 100644
> --- a/Documentation/devicetree/bindings/mfd/xylon,logicvc.yaml
> +++ b/Documentation/devicetree/bindings/mfd/xylon,logicvc.yaml
> @@ -26,6 +26,12 @@ properties:
>    reg:
>      maxItems: 1
>  
> +  '#address-cells':
> +    const: 1
> +
> +  '#size-cells':
> +    const: 1
> +
>  select:
>    properties:
>      compatible:
> @@ -36,15 +42,19 @@ select:
>    required:
>      - compatible
>  
> +patternProperties:
> +  "^gpio@[0-9a-f]+$":
> +    $ref: /schemas/gpio/xylon,logicvc-gpio.yaml#
> +
>  required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      logicvc: logicvc@43c00000 {
>        compatible = "xylon,logicvc-3.02.a", "syscon", "simple-mfd";
>        reg = <0x43c00000 0x6000>;
> -      #address-cells = <1>;
> -      #size-cells = <1>;
>      };
> diff --git a/Documentation/devicetree/bindings/mips/ingenic/ingenic,cpu.yaml b/Documentation/devicetree/bindings/mips/ingenic/ingenic,cpu.yaml
> index 16fa03d65ad5..6df1a9470d8f 100644
> --- a/Documentation/devicetree/bindings/mips/ingenic/ingenic,cpu.yaml
> +++ b/Documentation/devicetree/bindings/mips/ingenic/ingenic,cpu.yaml
> @@ -32,12 +32,16 @@ properties:
>    clocks:
>      maxItems: 1
>  
> +  device_type: true
> +
>  required:
>    - device_type
>    - compatible
>    - reg
>    - clocks
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/jz4780-cgu.h>
> @@ -52,7 +56,6 @@ examples:
>                  reg = <0>;
>  
>                  clocks = <&cgu JZ4780_CLK_CPU>;
> -                clock-names = "cpu";
>          };
>  
>          cpu1: cpu@1 {
> @@ -61,7 +64,6 @@ examples:
>                  reg = <1>;
>  
>                  clocks = <&cgu JZ4780_CLK_CORE1>;
> -                clock-names = "cpu";
>          };
>      };
>  ...
> diff --git a/Documentation/devicetree/bindings/mips/loongson/rs780e-acpi.yaml b/Documentation/devicetree/bindings/mips/loongson/rs780e-acpi.yaml
> index d317897e1115..7c0f9022202c 100644
> --- a/Documentation/devicetree/bindings/mips/loongson/rs780e-acpi.yaml
> +++ b/Documentation/devicetree/bindings/mips/loongson/rs780e-acpi.yaml
> @@ -23,6 +23,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      isa@0 {
> diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-emmc.yaml b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-emmc.yaml
> index 77f746f57284..1fc7e620f328 100644
> --- a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-emmc.yaml
> +++ b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-emmc.yaml
> @@ -36,6 +36,8 @@ required:
>    - compatible
>    - reset-gpios
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.yaml b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.yaml
> index a68820d31d50..e0169a285aa2 100644
> --- a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.yaml
> +++ b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.yaml
> @@ -28,6 +28,8 @@ required:
>    - powerdown-gpios
>    - reset-gpios
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml
> index 449215444723..06bbd8590544 100644
> --- a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml
> +++ b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml
> @@ -50,6 +50,8 @@ properties:
>  required:
>    - compatible
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index 8594f114f016..4d8464b2676d 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -144,6 +144,8 @@ oneOf:
>    - required:
>        - memory-region
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>          #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
> index c488f24ed38f..4f485df69ac3 100644
> --- a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
> +++ b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
> @@ -37,6 +37,8 @@ properties:
>  required:
>    - compatible
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> @@ -49,6 +51,6 @@ examples:
>          bluetooth {
>              compatible = "realtek,rtl8723bs-bt";
>              device-wake-gpios = <&r_pio 0 5 GPIO_ACTIVE_HIGH>; /* PL5 */
> -            host-wakeup-gpios = <&r_pio 0 6 GPIO_ACTIVE_HIGH>; /* PL6 */
> +            host-wake-gpios = <&r_pio 0 6 GPIO_ACTIVE_HIGH>; /* PL6 */
>          };
>      };
> diff --git a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
> index 2c320eb2a8c4..6c35682377e6 100644
> --- a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
> @@ -18,6 +18,8 @@ properties:
>    compatible:
>      const: microchip,wilc1000
>  
> +  reg: true
> +
>    spi-max-frequency: true
>  
>    interrupts:
> @@ -34,6 +36,8 @@ required:
>    - compatible
>    - interrupts
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      spi {
> diff --git a/Documentation/devicetree/bindings/pci/rcar-pci-ep.yaml b/Documentation/devicetree/bindings/pci/rcar-pci-ep.yaml
> index aa483c7f27fd..53d5952b7e57 100644
> --- a/Documentation/devicetree/bindings/pci/rcar-pci-ep.yaml
> +++ b/Documentation/devicetree/bindings/pci/rcar-pci-ep.yaml
> @@ -55,6 +55,8 @@ required:
>    - clock-names
>    - max-functions
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/r8a774c0-cpg-mssr.h>
> diff --git a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml b/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml
> index 0d2557bb0bcc..399ebde45409 100644
> --- a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml
> @@ -63,6 +63,8 @@ then:
>    required:
>      - power-domains
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      phy@36000 {
> diff --git a/Documentation/devicetree/bindings/phy/qcom,ipq806x-usb-phy-hs.yaml b/Documentation/devicetree/bindings/phy/qcom,ipq806x-usb-phy-hs.yaml
> index 23887ebe08fd..17f132ce5516 100644
> --- a/Documentation/devicetree/bindings/phy/qcom,ipq806x-usb-phy-hs.yaml
> +++ b/Documentation/devicetree/bindings/phy/qcom,ipq806x-usb-phy-hs.yaml
> @@ -42,6 +42,8 @@ required:
>    - clocks
>    - clock-names
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/qcom,gcc-ipq806x.h>
> diff --git a/Documentation/devicetree/bindings/phy/qcom,ipq806x-usb-phy-ss.yaml b/Documentation/devicetree/bindings/phy/qcom,ipq806x-usb-phy-ss.yaml
> index fa30c24b4405..17fd7f6b83bb 100644
> --- a/Documentation/devicetree/bindings/phy/qcom,ipq806x-usb-phy-ss.yaml
> +++ b/Documentation/devicetree/bindings/phy/qcom,ipq806x-usb-phy-ss.yaml
> @@ -60,6 +60,8 @@ required:
>    - clocks
>    - clock-names
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/qcom,gcc-ipq806x.h>
> diff --git a/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml
> index ccda92859eca..d457fb6a4779 100644
> --- a/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml
> @@ -158,6 +158,7 @@ required:
>    - vdda-phy-dpdm-supply
>    - resets
>  
> +additionalProperties: false
>  
>  examples:
>    - |
> diff --git a/Documentation/devicetree/bindings/phy/qcom-usb-ipq4019-phy.yaml b/Documentation/devicetree/bindings/phy/qcom-usb-ipq4019-phy.yaml
> index 1118fe69b611..3e7191b168fb 100644
> --- a/Documentation/devicetree/bindings/phy/qcom-usb-ipq4019-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/qcom-usb-ipq4019-phy.yaml
> @@ -36,6 +36,8 @@ required:
>    - reset-names
>    - "#phy-cells"
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/qcom,gcc-ipq4019.h>
> diff --git a/Documentation/devicetree/bindings/pinctrl/cirrus,lochnagar.yaml b/Documentation/devicetree/bindings/pinctrl/cirrus,lochnagar.yaml
> index 420d74856032..a07dd197176a 100644
> --- a/Documentation/devicetree/bindings/pinctrl/cirrus,lochnagar.yaml
> +++ b/Documentation/devicetree/bindings/pinctrl/cirrus,lochnagar.yaml
> @@ -188,3 +188,5 @@ required:
>    - gpio-ranges
>    - pinctrl-0
>    - pinctrl-names
> +
> +additionalProperties: false
> diff --git a/Documentation/devicetree/bindings/pinctrl/socionext,uniphier-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/socionext,uniphier-pinctrl.yaml
> index f8a93d8680f9..502480a19f49 100644
> --- a/Documentation/devicetree/bindings/pinctrl/socionext,uniphier-pinctrl.yaml
> +++ b/Documentation/devicetree/bindings/pinctrl/socionext,uniphier-pinctrl.yaml
> @@ -28,6 +28,8 @@ properties:
>  required:
>    - compatible
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      // The UniPhier pinctrl should be a subnode of a "syscon" compatible node.
> diff --git a/Documentation/devicetree/bindings/power/amlogic,meson-sec-pwrc.yaml b/Documentation/devicetree/bindings/power/amlogic,meson-sec-pwrc.yaml
> index bc4e037f3f73..5dae04d2936c 100644
> --- a/Documentation/devicetree/bindings/power/amlogic,meson-sec-pwrc.yaml
> +++ b/Documentation/devicetree/bindings/power/amlogic,meson-sec-pwrc.yaml
> @@ -27,6 +27,8 @@ required:
>    - compatible
>    - "#power-domain-cells"
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      secure-monitor {
> diff --git a/Documentation/devicetree/bindings/power/domain-idle-state.yaml b/Documentation/devicetree/bindings/power/domain-idle-state.yaml
> index dfba1af9abe5..6a12efdf436a 100644
> --- a/Documentation/devicetree/bindings/power/domain-idle-state.yaml
> +++ b/Documentation/devicetree/bindings/power/domain-idle-state.yaml
> @@ -50,6 +50,8 @@ patternProperties:
>        - exit-latency-us
>        - min-residency-us
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>  
> diff --git a/Documentation/devicetree/bindings/power/mti,mips-cpc.yaml b/Documentation/devicetree/bindings/power/mti,mips-cpc.yaml
> index ccdeaece169e..be447ccfdcb8 100644
> --- a/Documentation/devicetree/bindings/power/mti,mips-cpc.yaml
> +++ b/Documentation/devicetree/bindings/power/mti,mips-cpc.yaml
> @@ -26,6 +26,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      cpc@1bde0000 {
> diff --git a/Documentation/devicetree/bindings/power/supply/cw2015_battery.yaml b/Documentation/devicetree/bindings/power/supply/cw2015_battery.yaml
> index 2036977ecc2f..ee92e6a076ac 100644
> --- a/Documentation/devicetree/bindings/power/supply/cw2015_battery.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/cw2015_battery.yaml
> @@ -52,6 +52,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c {
> diff --git a/Documentation/devicetree/bindings/power/supply/rohm,bd99954.yaml b/Documentation/devicetree/bindings/power/supply/rohm,bd99954.yaml
> index 7e0f73a898c7..9852d2febf65 100644
> --- a/Documentation/devicetree/bindings/power/supply/rohm,bd99954.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/rohm,bd99954.yaml
> @@ -112,6 +112,12 @@ properties:
>  #     threshold, and the current is below this setting (7 in above chart)
>  #   See also Documentation/devicetree/bindings/power/supply/battery.txt
>  
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
>    monitored-battery:
>      description:
>        phandle of battery characteristics devicetree node
> @@ -137,6 +143,8 @@ properties:
>  required:
>    - compatible
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c {
> diff --git a/Documentation/devicetree/bindings/regulator/silergy,sy8827n.yaml b/Documentation/devicetree/bindings/regulator/silergy,sy8827n.yaml
> index 15983cdc7c28..b222adabc7b4 100644
> --- a/Documentation/devicetree/bindings/regulator/silergy,sy8827n.yaml
> +++ b/Documentation/devicetree/bindings/regulator/silergy,sy8827n.yaml
> @@ -31,6 +31,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c {
> diff --git a/Documentation/devicetree/bindings/remoteproc/qcom,pil-info.yaml b/Documentation/devicetree/bindings/remoteproc/qcom,pil-info.yaml
> index 87c52316ddbd..9282837d64ba 100644
> --- a/Documentation/devicetree/bindings/remoteproc/qcom,pil-info.yaml
> +++ b/Documentation/devicetree/bindings/remoteproc/qcom,pil-info.yaml
> @@ -25,6 +25,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      imem@146bf000 {
> diff --git a/Documentation/devicetree/bindings/serial/samsung_uart.yaml b/Documentation/devicetree/bindings/serial/samsung_uart.yaml
> index 96414ac65d06..21ee627b2ced 100644
> --- a/Documentation/devicetree/bindings/serial/samsung_uart.yaml
> +++ b/Documentation/devicetree/bindings/serial/samsung_uart.yaml
> @@ -68,6 +68,8 @@ required:
>    - interrupts
>    - reg
>  
> +additionalProperties: false
> +
>  allOf:
>    - if:
>        properties:
> diff --git a/Documentation/devicetree/bindings/serial/socionext,uniphier-uart.yaml b/Documentation/devicetree/bindings/serial/socionext,uniphier-uart.yaml
> index 09a30300850c..d490c7c4b967 100644
> --- a/Documentation/devicetree/bindings/serial/socionext,uniphier-uart.yaml
> +++ b/Documentation/devicetree/bindings/serial/socionext,uniphier-uart.yaml
> @@ -32,6 +32,8 @@ required:
>    - interrupts
>    - clocks
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      aliases {
> diff --git a/Documentation/devicetree/bindings/serial/sprd-uart.yaml b/Documentation/devicetree/bindings/serial/sprd-uart.yaml
> index e66b2e92a7fc..09f6283f3cae 100644
> --- a/Documentation/devicetree/bindings/serial/sprd-uart.yaml
> +++ b/Documentation/devicetree/bindings/serial/sprd-uart.yaml
> @@ -56,6 +56,8 @@ required:
>    - reg
>    - interrupts
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/arm-gic.h>
> diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml b/Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml
> index bd04fdb57414..84671950ca0d 100644
> --- a/Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml
> +++ b/Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml
> @@ -173,6 +173,7 @@ patternProperties:
>        - compatible
>        - interrupts
>  
> +additionalProperties: false
>  
>  examples:
>    - |
> diff --git a/Documentation/devicetree/bindings/sound/amlogic,g12a-toacodec.yaml b/Documentation/devicetree/bindings/sound/amlogic,g12a-toacodec.yaml
> index b4b3828c40af..3c3891d17238 100644
> --- a/Documentation/devicetree/bindings/sound/amlogic,g12a-toacodec.yaml
> +++ b/Documentation/devicetree/bindings/sound/amlogic,g12a-toacodec.yaml
> @@ -37,6 +37,8 @@ required:
>    - reg
>    - resets
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/reset/amlogic,meson-g12a-audio-reset.h>
> diff --git a/Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml b/Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml
> index fb374c659be1..db61f0731a20 100644
> --- a/Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml
> +++ b/Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml
> @@ -84,6 +84,8 @@ required:
>    - model
>    - dai-link-0
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      sound {
> diff --git a/Documentation/devicetree/bindings/sound/amlogic,t9015.yaml b/Documentation/devicetree/bindings/sound/amlogic,t9015.yaml
> index 04014e658c90..c7613ea728d4 100644
> --- a/Documentation/devicetree/bindings/sound/amlogic,t9015.yaml
> +++ b/Documentation/devicetree/bindings/sound/amlogic,t9015.yaml
> @@ -42,6 +42,8 @@ required:
>    - clock-names
>    - resets
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/g12a-clkc.h>
> diff --git a/Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml b/Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml
> index 5bcb643c288f..0d87e2c86a42 100644
> --- a/Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml
> +++ b/Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml
> @@ -46,6 +46,8 @@ required:
>    - reg
>    - "#sound-dai-cells"
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/sound/fsl,easrc.yaml b/Documentation/devicetree/bindings/sound/fsl,easrc.yaml
> index 32d547af9ce7..bdde68a1059c 100644
> --- a/Documentation/devicetree/bindings/sound/fsl,easrc.yaml
> +++ b/Documentation/devicetree/bindings/sound/fsl,easrc.yaml
> @@ -74,6 +74,8 @@ required:
>    - fsl,asrc-rate
>    - fsl,asrc-format
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/imx8mn-clock.h>
> diff --git a/Documentation/devicetree/bindings/sound/intel,keembay-i2s.yaml b/Documentation/devicetree/bindings/sound/intel,keembay-i2s.yaml
> index 2e0bbc1c868a..6cbdd8857ea2 100644
> --- a/Documentation/devicetree/bindings/sound/intel,keembay-i2s.yaml
> +++ b/Documentation/devicetree/bindings/sound/intel,keembay-i2s.yaml
> @@ -52,6 +52,8 @@ required:
>    - clock-names
>    - interrupts
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>       #include <dt-bindings/interrupt-controller/arm-gic.h>
> diff --git a/Documentation/devicetree/bindings/sound/nvidia,tegra186-dspk.yaml b/Documentation/devicetree/bindings/sound/nvidia,tegra186-dspk.yaml
> index 2f2fcffa65cb..ed2fb32fcdd4 100644
> --- a/Documentation/devicetree/bindings/sound/nvidia,tegra186-dspk.yaml
> +++ b/Documentation/devicetree/bindings/sound/nvidia,tegra186-dspk.yaml
> @@ -64,6 +64,8 @@ required:
>    - assigned-clock-parents
>    - sound-name-prefix
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include<dt-bindings/clock/tegra186-clock.h>
> diff --git a/Documentation/devicetree/bindings/sound/nvidia,tegra210-admaif.yaml b/Documentation/devicetree/bindings/sound/nvidia,tegra210-admaif.yaml
> index 41c77f45d2fd..c028b259e822 100644
> --- a/Documentation/devicetree/bindings/sound/nvidia,tegra210-admaif.yaml
> +++ b/Documentation/devicetree/bindings/sound/nvidia,tegra210-admaif.yaml
> @@ -81,6 +81,8 @@ required:
>    - dmas
>    - dma-names
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      admaif@702d0000 {
> diff --git a/Documentation/devicetree/bindings/sound/nvidia,tegra210-dmic.yaml b/Documentation/devicetree/bindings/sound/nvidia,tegra210-dmic.yaml
> index 8689d9f18c11..2a3207b550e7 100644
> --- a/Documentation/devicetree/bindings/sound/nvidia,tegra210-dmic.yaml
> +++ b/Documentation/devicetree/bindings/sound/nvidia,tegra210-dmic.yaml
> @@ -64,6 +64,8 @@ required:
>    - assigned-clocks
>    - assigned-clock-parents
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include<dt-bindings/clock/tegra210-car.h>
> diff --git a/Documentation/devicetree/bindings/sound/nvidia,tegra210-i2s.yaml b/Documentation/devicetree/bindings/sound/nvidia,tegra210-i2s.yaml
> index 9bbf18153d63..dfc1bf7b7722 100644
> --- a/Documentation/devicetree/bindings/sound/nvidia,tegra210-i2s.yaml
> +++ b/Documentation/devicetree/bindings/sound/nvidia,tegra210-i2s.yaml
> @@ -82,6 +82,8 @@ required:
>    - assigned-clocks
>    - assigned-clock-parents
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include<dt-bindings/clock/tegra210-car.h>
> diff --git a/Documentation/devicetree/bindings/sound/rockchip,rk3328-codec.yaml b/Documentation/devicetree/bindings/sound/rockchip,rk3328-codec.yaml
> index 5b85ad5e4834..75b3b33b5f1f 100644
> --- a/Documentation/devicetree/bindings/sound/rockchip,rk3328-codec.yaml
> +++ b/Documentation/devicetree/bindings/sound/rockchip,rk3328-codec.yaml
> @@ -53,6 +53,8 @@ required:
>    - rockchip,grf
>    - "#sound-dai-cells"
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml b/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
> index f578f17f3e04..1bff53d37118 100644
> --- a/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
> +++ b/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
> @@ -138,6 +138,8 @@ required:
>    - compatible
>    - reg
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/thermal/rcar-thermal.yaml b/Documentation/devicetree/bindings/thermal/rcar-thermal.yaml
> index 0994693d240f..7e9557ac0e4a 100644
> --- a/Documentation/devicetree/bindings/thermal/rcar-thermal.yaml
> +++ b/Documentation/devicetree/bindings/thermal/rcar-thermal.yaml
> @@ -59,6 +59,9 @@ properties:
>    resets:
>      maxItems: 1
>  
> +  "#thermal-sensor-cells":
> +    const: 0
> +
>  if:
>    properties:
>      compatible:
> @@ -79,6 +82,8 @@ else:
>      - power-domains
>      - resets
>  
> +additionalProperties: false
> +
>  examples:
>    # Example (non interrupt support)
>    - |
> diff --git a/Documentation/devicetree/bindings/thermal/sprd-thermal.yaml b/Documentation/devicetree/bindings/thermal/sprd-thermal.yaml
> index af2ff930646a..6d65a3cf2af2 100644
> --- a/Documentation/devicetree/bindings/thermal/sprd-thermal.yaml
> +++ b/Documentation/devicetree/bindings/thermal/sprd-thermal.yaml
> @@ -68,6 +68,8 @@ patternProperties:
>        - nvmem-cells
>        - nvmem-cell-names
>  
> +    additionalProperties: false
> +
>  required:
>    - compatible
>    - reg
> @@ -79,6 +81,8 @@ required:
>    - "#address-cells"
>    - "#size-cells"
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>          ap_thm0: thermal@32200000 {
> diff --git a/Documentation/devicetree/bindings/thermal/thermal-idle.yaml b/Documentation/devicetree/bindings/thermal/thermal-idle.yaml
> index a832d427e9d5..6278ccf16f3f 100644
> --- a/Documentation/devicetree/bindings/thermal/thermal-idle.yaml
> +++ b/Documentation/devicetree/bindings/thermal/thermal-idle.yaml
> @@ -44,6 +44,8 @@ properties:
>  required:
>    - '#cooling-cells'
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/thermal/thermal.h>
> diff --git a/Documentation/devicetree/bindings/thermal/thermal-zones.yaml b/Documentation/devicetree/bindings/thermal/thermal-zones.yaml
> index 3ec9cc87ec50..164f71598c59 100644
> --- a/Documentation/devicetree/bindings/thermal/thermal-zones.yaml
> +++ b/Documentation/devicetree/bindings/thermal/thermal-zones.yaml
> @@ -218,6 +218,8 @@ patternProperties:
>        - trips
>      additionalProperties: false
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/arm-gic.h>
> diff --git a/Documentation/devicetree/bindings/timer/cdns,ttc.yaml b/Documentation/devicetree/bindings/timer/cdns,ttc.yaml
> index c532b60b9c63..8615353f69b4 100644
> --- a/Documentation/devicetree/bindings/timer/cdns,ttc.yaml
> +++ b/Documentation/devicetree/bindings/timer/cdns,ttc.yaml
> @@ -36,6 +36,8 @@ required:
>    - interrupts
>    - clocks
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      ttc0: ttc0@f8001000 {
> diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml b/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml
> index 196589c93373..e60e590dbe12 100644
> --- a/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml
> +++ b/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml
> @@ -155,6 +155,8 @@ allOf:
>          clock-names:
>            maxItems: 4
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/tegra210-car.h>
> diff --git a/Documentation/devicetree/bindings/usb/qcom,dwc3.yaml b/Documentation/devicetree/bindings/usb/qcom,dwc3.yaml
> index dac10848dd7f..2cf525d21e05 100644
> --- a/Documentation/devicetree/bindings/usb/qcom,dwc3.yaml
> +++ b/Documentation/devicetree/bindings/usb/qcom,dwc3.yaml
> @@ -121,6 +121,8 @@ required:
>    - interrupts
>    - interrupt-names
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/qcom,gcc-sdm845.h>
> diff --git a/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml b/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
> index 484fc1091d7c..388245b91a55 100644
> --- a/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
> +++ b/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
> @@ -46,6 +46,22 @@ properties:
>        VBUS pin of the SoC via a 1/3 voltage divider.
>      type: boolean
>  
> +  assigned-clocks:
> +    maxItems: 1
> +
> +  assigned-clock-parents:
> +    maxItems: 1
> +
> +  '#address-cells':
> +    const: 2
> +
> +  '#size-cells':
> +    const: 2
> +
> +patternProperties:
> +  "^usb@":
> +    type: object
> +
>  required:
>    - compatible
>    - reg
> @@ -53,6 +69,8 @@ required:
>    - clocks
>    - clock-names
>  
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/soc/ti,sci_pm_domain.h>
> -- 
> 2.25.1
> 
