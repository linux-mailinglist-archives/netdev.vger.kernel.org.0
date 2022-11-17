Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586BE62DBCF
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240069AbiKQMmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbiKQMk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:40:59 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B34C74A87
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:39:34 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id d3so2560126ljl.1
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bs+cbToNQ7GqMflDK/0DQoPYMLrubSCpZvcxgqpblb0=;
        b=NV6Fe7Ag/ACtVZLOSFsp4jBB7du8WuiwRmihw/DKn5NgFVVFvifpEvLOuNaGFaXMka
         6Uxe67WLHpkiM/zfCbREERGsZw1KidkuHA214U9vZKJWAfdC8z6Gbfqk3Dsdpeb4iZu8
         2VU+I5swPtxisG2pqrMUJfgLSwZlhidJgz9sexwFi0rebqxaNV1gB/KbBPagupaOqFtg
         KrmqVW3/BGQUUQLQm2AgQhPRadP6pPRb+zkTrICFfo9IF9hpdXCy2Fd+1nfGQiHUChp0
         Wis2SytXyJxDkOlkxesiD9IHrlhhoXFcEtquKiDJ2Ol2FSIVAV/CvRe5jfAelp3qQfut
         NoQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bs+cbToNQ7GqMflDK/0DQoPYMLrubSCpZvcxgqpblb0=;
        b=m6QkjvgKtzECtSY057MBxYhS6gfomjaV8YmQDB8V1yyFfYjCRzs2Nk9Xs6PxknKtJe
         APqGDjRyFYV8Uj81MNlDp0O0UhvMEPVYf5gjlpta4myTZlA/BVSer0MXQWzSOeln5hlW
         vAAcGQqlWAPmEBhaxcANWpVzdALGASVtrDx6BC37QWIZw5rwUwxk0QW7xUdfqc5cN5PA
         6HKFyKLh/y0+xBahMCH5i3cAPSDLzH3VuMjG586ucJByiimF/xvxxkXSOBtaifRElYCs
         ZvoVgfljpzRRYN9a2kAJBaVaJr+UlPK8C/SkkoOaIsS0DBxKf5OTRsyv0DuK8/piOrDq
         SuEg==
X-Gm-Message-State: ANoB5pkG1s+uncl50hB/8PxG+cUEWQ+FNi6pH0jYtykfQ0A0IBlvoL3d
        3mQ0pVFHsMhTeeF0ObhvaFFgYA==
X-Google-Smtp-Source: AA0mqf5Y1kWcQ9jwxHIxafq7WGfsODfxhJIE7x3dpJ0ctyy211ujuXjh+wtq0VyJT9XpgaPoJkMThw==
X-Received: by 2002:a2e:9589:0:b0:277:7c00:e12b with SMTP id w9-20020a2e9589000000b002777c00e12bmr975226ljh.431.1668688755799;
        Thu, 17 Nov 2022 04:39:15 -0800 (PST)
Received: from krzk-bin.NAT.warszawa.vectranet.pl (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id u28-20020ac24c3c000000b004972b0bb426sm127855lfq.257.2022.11.17.04.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 04:39:15 -0800 (PST)
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
Subject: [RFC PATCH 6/9] dt-bindings: drop redundant part of title (end, part three)
Date:   Thu, 17 Nov 2022 13:38:47 +0100
Message-Id: <20221117123850.368213-7-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221117123850.368213-1-krzysztof.kozlowski@linaro.org>
References: <20221117123850.368213-1-krzysztof.kozlowski@linaro.org>
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
it is a "binding", but instead just describe the hardware.

Drop trailing "bindings" in various forms (also with trailling full
stop):

  find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
    -not -name 'trivial-devices.yaml' \
    -exec sed -i -e 's/^title: \(.*\) [bB]indings\?\.\?$/title: \1/' {} \;

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/arm/cci-control-port.yaml     | 2 +-
 Documentation/devicetree/bindings/arm/cpus.yaml                 | 2 +-
 .../devicetree/bindings/arm/keystone/ti,k3-sci-common.yaml      | 2 +-
 Documentation/devicetree/bindings/arm/sp810.yaml                | 2 +-
 Documentation/devicetree/bindings/arm/stm32/st,mlahb.yaml       | 2 +-
 .../devicetree/bindings/arm/stm32/st,stm32-syscon.yaml          | 2 +-
 .../devicetree/bindings/arm/tegra/nvidia,tegra194-cbb.yaml      | 2 +-
 .../devicetree/bindings/arm/tegra/nvidia,tegra234-cbb.yaml      | 2 +-
 Documentation/devicetree/bindings/arm/vexpress-config.yaml      | 2 +-
 Documentation/devicetree/bindings/arm/vexpress-sysreg.yaml      | 2 +-
 .../devicetree/bindings/ata/allwinner,sun4i-a10-ahci.yaml       | 2 +-
 .../devicetree/bindings/ata/allwinner,sun8i-r40-ahci.yaml       | 2 +-
 Documentation/devicetree/bindings/bus/ti-sysc.yaml              | 2 +-
 Documentation/devicetree/bindings/clock/fsl,plldig.yaml         | 2 +-
 Documentation/devicetree/bindings/clock/fsl,sai-clock.yaml      | 2 +-
 Documentation/devicetree/bindings/clock/imx8m-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/imx8qxp-lpcg.yaml       | 2 +-
 Documentation/devicetree/bindings/clock/imx8ulp-cgc-clock.yaml  | 2 +-
 Documentation/devicetree/bindings/clock/imx8ulp-pcc-clock.yaml  | 2 +-
 Documentation/devicetree/bindings/clock/imx93-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/intel,agilex.yaml       | 2 +-
 Documentation/devicetree/bindings/clock/intel,cgu-lgm.yaml      | 2 +-
 Documentation/devicetree/bindings/clock/intel,easic-n5x.yaml    | 2 +-
 Documentation/devicetree/bindings/clock/intel,stratix10.yaml    | 2 +-
 .../devicetree/bindings/clock/microchip,mpfs-clkcfg.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/milbeaut-clock.yaml     | 2 +-
 .../devicetree/bindings/clock/nuvoton,npcm845-clk.yaml          | 2 +-
 Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml        | 2 +-
 .../devicetree/bindings/clock/rockchip,rk3568-cru.yaml          | 2 +-
 .../devicetree/bindings/cpufreq/cpufreq-mediatek-hw.yaml        | 2 +-
 .../devicetree/bindings/cpufreq/qcom-cpufreq-nvmem.yaml         | 2 +-
 Documentation/devicetree/bindings/crypto/st,stm32-crc.yaml      | 2 +-
 Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml     | 2 +-
 Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml     | 2 +-
 Documentation/devicetree/bindings/display/arm,hdlcd.yaml        | 2 +-
 Documentation/devicetree/bindings/display/arm,malidp.yaml       | 2 +-
 .../devicetree/bindings/display/bridge/toshiba,tc358767.yaml    | 2 +-
 .../devicetree/bindings/display/bridge/toshiba,tc358775.yaml    | 2 +-
 .../devicetree/bindings/display/panel/display-timings.yaml      | 2 +-
 .../devicetree/bindings/display/panel/panel-timing.yaml         | 2 +-
 Documentation/devicetree/bindings/dma/st,stm32-dma.yaml         | 2 +-
 Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml      | 2 +-
 Documentation/devicetree/bindings/dma/st,stm32-mdma.yaml        | 2 +-
 Documentation/devicetree/bindings/edac/dmc-520.yaml             | 2 +-
 Documentation/devicetree/bindings/firmware/arm,scmi.yaml        | 2 +-
 Documentation/devicetree/bindings/firmware/arm,scpi.yaml        | 2 +-
 .../devicetree/bindings/firmware/qemu,fw-cfg-mmio.yaml          | 2 +-
 Documentation/devicetree/bindings/gpio/gpio-tpic2810.yaml       | 2 +-
 Documentation/devicetree/bindings/gpio/ti,omap-gpio.yaml        | 2 +-
 Documentation/devicetree/bindings/gpu/brcm,bcm-v3d.yaml         | 2 +-
 Documentation/devicetree/bindings/gpu/vivante,gc.yaml           | 2 +-
 .../devicetree/bindings/hwlock/st,stm32-hwspinlock.yaml         | 2 +-
 Documentation/devicetree/bindings/hwmon/moortec,mr75203.yaml    | 2 +-
 Documentation/devicetree/bindings/i2c/i2c-pxa.yaml              | 2 +-
 Documentation/devicetree/bindings/i2c/st,nomadik-i2c.yaml       | 2 +-
 Documentation/devicetree/bindings/i3c/i3c.yaml                  | 2 +-
 Documentation/devicetree/bindings/iio/adc/ingenic,adc.yaml      | 2 +-
 .../devicetree/bindings/iio/adc/motorola,cpcap-adc.yaml         | 2 +-
 Documentation/devicetree/bindings/iio/adc/nxp,imx8qxp-adc.yaml  | 2 +-
 Documentation/devicetree/bindings/iio/adc/nxp,lpc1850-adc.yaml  | 2 +-
 Documentation/devicetree/bindings/iio/adc/sprd,sc2720-adc.yaml  | 2 +-
 Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml     | 2 +-
 .../devicetree/bindings/iio/adc/x-powers,axp209-adc.yaml        | 2 +-
 Documentation/devicetree/bindings/iio/dac/nxp,lpc1850-dac.yaml  | 2 +-
 Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml     | 2 +-
 .../devicetree/bindings/iio/multiplexer/io-channel-mux.yaml     | 2 +-
 Documentation/devicetree/bindings/input/input.yaml              | 2 +-
 .../bindings/input/touchscreen/cypress,cy8ctma140.yaml          | 2 +-
 .../bindings/input/touchscreen/cypress,cy8ctma340.yaml          | 2 +-
 .../devicetree/bindings/input/touchscreen/edt-ft5x06.yaml       | 2 +-
 Documentation/devicetree/bindings/input/touchscreen/goodix.yaml | 2 +-
 .../devicetree/bindings/input/touchscreen/himax,hx83112b.yaml   | 2 +-
 .../devicetree/bindings/input/touchscreen/hycon,hy46xx.yaml     | 2 +-
 .../devicetree/bindings/input/touchscreen/imagis,ist3038c.yaml  | 2 +-
 .../devicetree/bindings/input/touchscreen/melfas,mms114.yaml    | 2 +-
 .../devicetree/bindings/input/touchscreen/mstar,msg2638.yaml    | 2 +-
 .../devicetree/bindings/input/touchscreen/ti,tsc2005.yaml       | 2 +-
 .../devicetree/bindings/input/touchscreen/touchscreen.yaml      | 2 +-
 .../devicetree/bindings/input/touchscreen/zinitix,bt400.yaml    | 2 +-
 .../devicetree/bindings/interrupt-controller/mrvl,intc.yaml     | 2 +-
 .../bindings/interrupt-controller/nuvoton,wpcm450-aic.yaml      | 2 +-
 Documentation/devicetree/bindings/ipmi/ipmi-ipmb.yaml           | 2 +-
 Documentation/devicetree/bindings/ipmi/ipmi-smic.yaml           | 2 +-
 .../devicetree/bindings/leds/backlight/gpio-backlight.yaml      | 2 +-
 .../devicetree/bindings/leds/backlight/led-backlight.yaml       | 2 +-
 .../devicetree/bindings/leds/backlight/pwm-backlight.yaml       | 2 +-
 .../devicetree/bindings/mailbox/qcom,apcs-kpss-global.yaml      | 2 +-
 Documentation/devicetree/bindings/mailbox/sprd-mailbox.yaml     | 2 +-
 Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml    | 2 +-
 Documentation/devicetree/bindings/media/marvell,mmp2-ccic.yaml  | 2 +-
 Documentation/devicetree/bindings/media/renesas,ceu.yaml        | 2 +-
 Documentation/devicetree/bindings/media/st,stm32-cec.yaml       | 2 +-
 Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml      | 2 +-
 Documentation/devicetree/bindings/media/st,stm32-dma2d.yaml     | 2 +-
 .../bindings/memory-controllers/calxeda-ddr-ctrlr.yaml          | 2 +-
 .../bindings/memory-controllers/st,stm32-fmc2-ebi.yaml          | 2 +-
 Documentation/devicetree/bindings/mfd/actions,atc260x.yaml      | 2 +-
 Documentation/devicetree/bindings/mfd/ene-kb3930.yaml           | 2 +-
 Documentation/devicetree/bindings/mfd/ene-kb930.yaml            | 2 +-
 Documentation/devicetree/bindings/mfd/fsl,imx8qxp-csr.yaml      | 2 +-
 Documentation/devicetree/bindings/mfd/qcom,pm8008.yaml          | 2 +-
 Documentation/devicetree/bindings/mfd/rohm,bd71815-pmic.yaml    | 2 +-
 Documentation/devicetree/bindings/mfd/rohm,bd71828-pmic.yaml    | 2 +-
 Documentation/devicetree/bindings/mfd/rohm,bd71837-pmic.yaml    | 2 +-
 Documentation/devicetree/bindings/mfd/rohm,bd71847-pmic.yaml    | 2 +-
 Documentation/devicetree/bindings/mfd/rohm,bd9576-pmic.yaml     | 2 +-
 Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml     | 2 +-
 Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml      | 2 +-
 Documentation/devicetree/bindings/mfd/st,stmfx.yaml             | 2 +-
 Documentation/devicetree/bindings/mfd/st,stpmic1.yaml           | 2 +-
 Documentation/devicetree/bindings/misc/olpc,xo1.75-ec.yaml      | 2 +-
 Documentation/devicetree/bindings/mmc/brcm,sdhci-brcmstb.yaml   | 2 +-
 .../devicetree/bindings/mmc/microchip,dw-sparx5-sdhci.yaml      | 2 +-
 Documentation/devicetree/bindings/mmc/mmc-pwrseq-emmc.yaml      | 2 +-
 Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.yaml    | 2 +-
 Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml    | 2 +-
 Documentation/devicetree/bindings/mmc/mtk-sd.yaml               | 2 +-
 Documentation/devicetree/bindings/mmc/sdhci-pxa.yaml            | 2 +-
 Documentation/devicetree/bindings/mmc/snps,dwcmshc-sdhci.yaml   | 2 +-
 Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.yaml     | 2 +-
 Documentation/devicetree/bindings/mtd/gpmi-nand.yaml            | 2 +-
 Documentation/devicetree/bindings/mtd/microchip,mchp48l640.yaml | 2 +-
 Documentation/devicetree/bindings/mtd/mxc-nand.yaml             | 2 +-
 .../devicetree/bindings/mtd/partitions/qcom,smem-part.yaml      | 2 +-
 Documentation/devicetree/bindings/mtd/st,stm32-fmc2-nand.yaml   | 2 +-
 Documentation/devicetree/bindings/mux/gpio-mux.yaml             | 2 +-
 Documentation/devicetree/bindings/mux/mux-consumer.yaml         | 2 +-
 Documentation/devicetree/bindings/mux/mux-controller.yaml       | 2 +-
 Documentation/devicetree/bindings/mux/reg-mux.yaml              | 2 +-
 Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml        | 2 +-
 Documentation/devicetree/bindings/net/can/bosch,m_can.yaml      | 2 +-
 Documentation/devicetree/bindings/net/can/can-transceiver.yaml  | 2 +-
 Documentation/devicetree/bindings/net/engleder,tsnep.yaml       | 2 +-
 Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml   | 2 +-
 Documentation/devicetree/bindings/net/mctp-i2c-controller.yaml  | 2 +-
 Documentation/devicetree/bindings/net/wireless/ieee80211.yaml   | 2 +-
 .../devicetree/bindings/nvmem/ingenic,jz4780-efuse.yaml         | 2 +-
 Documentation/devicetree/bindings/nvmem/qcom,qfprom.yaml        | 2 +-
 .../devicetree/bindings/nvmem/socionext,uniphier-efuse.yaml     | 2 +-
 Documentation/devicetree/bindings/nvmem/st,stm32-romem.yaml     | 2 +-
 Documentation/devicetree/bindings/opp/opp-v1.yaml               | 2 +-
 Documentation/devicetree/bindings/opp/opp-v2-kryo-cpu.yaml      | 2 +-
 Documentation/devicetree/bindings/opp/opp-v2.yaml               | 2 +-
 Documentation/devicetree/bindings/pci/qcom,pcie-ep.yaml         | 2 +-
 Documentation/devicetree/bindings/phy/fsl,imx8mq-usb-phy.yaml   | 2 +-
 Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml         | 2 +-
 .../devicetree/bindings/phy/intel,keembay-phy-usb.yaml          | 2 +-
 .../devicetree/bindings/phy/intel,phy-thunderbay-emmc.yaml      | 2 +-
 Documentation/devicetree/bindings/phy/marvell,mmp3-usb-phy.yaml | 2 +-
 Documentation/devicetree/bindings/phy/mediatek,dsi-phy.yaml     | 2 +-
 Documentation/devicetree/bindings/phy/mediatek,hdmi-phy.yaml    | 2 +-
 Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml     | 2 +-
 Documentation/devicetree/bindings/phy/phy-cadence-sierra.yaml   | 2 +-
 Documentation/devicetree/bindings/phy/phy-cadence-torrent.yaml  | 2 +-
 Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml    | 2 +-
 Documentation/devicetree/bindings/phy/phy-tegra194-p2u.yaml     | 2 +-
 Documentation/devicetree/bindings/phy/ti,phy-am654-serdes.yaml  | 2 +-
 Documentation/devicetree/bindings/phy/transmit-amplitude.yaml   | 2 +-
 Documentation/devicetree/bindings/pinctrl/intel,lgm-io.yaml     | 2 +-
 Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml       | 2 +-
 .../devicetree/bindings/power/supply/dlg,da9150-charger.yaml    | 2 +-
 .../devicetree/bindings/power/supply/dlg,da9150-fuel-gauge.yaml | 2 +-
 .../devicetree/bindings/power/supply/ingenic,battery.yaml       | 2 +-
 .../devicetree/bindings/power/supply/lltc,lt3651-charger.yaml   | 2 +-
 .../devicetree/bindings/power/supply/sc2731-charger.yaml        | 2 +-
 Documentation/devicetree/bindings/power/supply/sc27xx-fg.yaml   | 2 +-
 Documentation/devicetree/bindings/pwm/microchip,corepwm.yaml    | 2 +-
 .../devicetree/bindings/regulator/st,stm32-booster.yaml         | 2 +-
 .../devicetree/bindings/regulator/st,stm32-vrefbuf.yaml         | 2 +-
 .../devicetree/bindings/remoteproc/amlogic,meson-mx-ao-arc.yaml | 2 +-
 Documentation/devicetree/bindings/remoteproc/fsl,imx-rproc.yaml | 2 +-
 Documentation/devicetree/bindings/remoteproc/ingenic,vpu.yaml   | 2 +-
 Documentation/devicetree/bindings/remoteproc/mtk,scp.yaml       | 2 +-
 Documentation/devicetree/bindings/remoteproc/qcom,adsp.yaml     | 2 +-
 Documentation/devicetree/bindings/remoteproc/qcom,pil-info.yaml | 2 +-
 .../devicetree/bindings/remoteproc/renesas,rcar-rproc.yaml      | 2 +-
 .../devicetree/bindings/remoteproc/st,stm32-rproc.yaml          | 2 +-
 Documentation/devicetree/bindings/rng/intel,ixp46x-rng.yaml     | 2 +-
 .../devicetree/bindings/rng/silex-insight,ba431-rng.yaml        | 2 +-
 Documentation/devicetree/bindings/rng/st,stm32-rng.yaml         | 2 +-
 .../devicetree/bindings/rng/xiphera,xip8001b-trng.yaml          | 2 +-
 Documentation/devicetree/bindings/rtc/sa1100-rtc.yaml           | 2 +-
 Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml         | 2 +-
 Documentation/devicetree/bindings/serial/8250.yaml              | 2 +-
 Documentation/devicetree/bindings/serial/rs485.yaml             | 2 +-
 Documentation/devicetree/bindings/serial/st,stm32-uart.yaml     | 2 +-
 Documentation/devicetree/bindings/soc/qcom/qcom,aoss-qmp.yaml   | 2 +-
 Documentation/devicetree/bindings/soc/qcom/qcom,apr.yaml        | 2 +-
 Documentation/devicetree/bindings/soc/qcom/qcom,smem.yaml       | 2 +-
 Documentation/devicetree/bindings/soc/qcom/qcom,spm.yaml        | 2 +-
 Documentation/devicetree/bindings/soc/qcom/qcom-stats.yaml      | 2 +-
 Documentation/devicetree/bindings/soc/samsung/exynos-usi.yaml   | 2 +-
 Documentation/devicetree/bindings/sound/marvell,mmp-sspa.yaml   | 2 +-
 Documentation/devicetree/bindings/sound/qcom,lpass-cpu.yaml     | 2 +-
 Documentation/devicetree/bindings/sound/qcom,q6apm-dai.yaml     | 2 +-
 .../devicetree/bindings/sound/qcom,q6dsp-lpass-clocks.yaml      | 2 +-
 .../devicetree/bindings/sound/qcom,q6dsp-lpass-ports.yaml       | 2 +-
 Documentation/devicetree/bindings/spi/aspeed,ast2600-fmc.yaml   | 2 +-
 Documentation/devicetree/bindings/spi/marvell,mmp2-ssp.yaml     | 2 +-
 Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml        | 2 +-
 Documentation/devicetree/bindings/spi/st,stm32-spi.yaml         | 2 +-
 Documentation/devicetree/bindings/thermal/imx-thermal.yaml      | 2 +-
 Documentation/devicetree/bindings/thermal/imx8mm-thermal.yaml   | 2 +-
 Documentation/devicetree/bindings/thermal/sprd-thermal.yaml     | 2 +-
 Documentation/devicetree/bindings/thermal/st,stm32-thermal.yaml | 2 +-
 .../devicetree/bindings/thermal/thermal-cooling-devices.yaml    | 2 +-
 Documentation/devicetree/bindings/thermal/thermal-idle.yaml     | 2 +-
 Documentation/devicetree/bindings/thermal/thermal-sensor.yaml   | 2 +-
 Documentation/devicetree/bindings/thermal/thermal-zones.yaml    | 2 +-
 Documentation/devicetree/bindings/thermal/ti,am654-thermal.yaml | 2 +-
 Documentation/devicetree/bindings/thermal/ti,j72xx-thermal.yaml | 2 +-
 Documentation/devicetree/bindings/timer/mrvl,mmp-timer.yaml     | 2 +-
 Documentation/devicetree/bindings/timer/st,stm32-timer.yaml     | 2 +-
 Documentation/devicetree/bindings/usb/analogix,anx7411.yaml     | 2 +-
 Documentation/devicetree/bindings/usb/cdns,usb3.yaml            | 2 +-
 Documentation/devicetree/bindings/usb/dwc2.yaml                 | 2 +-
 Documentation/devicetree/bindings/usb/faraday,fotg210.yaml      | 2 +-
 Documentation/devicetree/bindings/usb/marvell,pxau2o-ehci.yaml  | 2 +-
 Documentation/devicetree/bindings/usb/nxp,isp1760.yaml          | 2 +-
 Documentation/devicetree/bindings/usb/richtek,rt1719.yaml       | 2 +-
 Documentation/devicetree/bindings/usb/st,stusb160x.yaml         | 2 +-
 Documentation/devicetree/bindings/virtio/virtio-device.yaml     | 2 +-
 Documentation/devicetree/bindings/watchdog/st,stm32-iwdg.yaml   | 2 +-
 223 files changed, 223 insertions(+), 223 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/cci-control-port.yaml b/Documentation/devicetree/bindings/arm/cci-control-port.yaml
index c9114866213f..c29d250a6d77 100644
--- a/Documentation/devicetree/bindings/arm/cci-control-port.yaml
+++ b/Documentation/devicetree/bindings/arm/cci-control-port.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/arm/cci-control-port.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: CCI Interconnect Bus Masters binding
+title: CCI Interconnect Bus Masters
 
 maintainers:
   - Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
diff --git a/Documentation/devicetree/bindings/arm/cpus.yaml b/Documentation/devicetree/bindings/arm/cpus.yaml
index 7dd84f8f8e4f..01b5a9c689a2 100644
--- a/Documentation/devicetree/bindings/arm/cpus.yaml
+++ b/Documentation/devicetree/bindings/arm/cpus.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/arm/cpus.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: ARM CPUs bindings
+title: ARM CPUs
 
 maintainers:
   - Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
diff --git a/Documentation/devicetree/bindings/arm/keystone/ti,k3-sci-common.yaml b/Documentation/devicetree/bindings/arm/keystone/ti,k3-sci-common.yaml
index 5cbcacaeb441..ff378d5cbd32 100644
--- a/Documentation/devicetree/bindings/arm/keystone/ti,k3-sci-common.yaml
+++ b/Documentation/devicetree/bindings/arm/keystone/ti,k3-sci-common.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/arm/keystone/ti,k3-sci-common.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Common K3 TI-SCI bindings
+title: Common K3 TI-SCI
 
 maintainers:
   - Nishanth Menon <nm@ti.com>
diff --git a/Documentation/devicetree/bindings/arm/sp810.yaml b/Documentation/devicetree/bindings/arm/sp810.yaml
index bc8e524aa90a..c9094e5ec565 100644
--- a/Documentation/devicetree/bindings/arm/sp810.yaml
+++ b/Documentation/devicetree/bindings/arm/sp810.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/arm/sp810.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: ARM Versatile Express SP810 System Controller bindings
+title: ARM Versatile Express SP810 System Controller
 
 maintainers:
   - Andre Przywara <andre.przywara@arm.com>
diff --git a/Documentation/devicetree/bindings/arm/stm32/st,mlahb.yaml b/Documentation/devicetree/bindings/arm/stm32/st,mlahb.yaml
index ecb28e90fd11..2297ad3f4774 100644
--- a/Documentation/devicetree/bindings/arm/stm32/st,mlahb.yaml
+++ b/Documentation/devicetree/bindings/arm/stm32/st,mlahb.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/arm/stm32/st,mlahb.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: STMicroelectronics STM32 ML-AHB interconnect bindings
+title: STMicroelectronics STM32 ML-AHB interconnect
 
 maintainers:
   - Fabien Dessenne <fabien.dessenne@foss.st.com>
diff --git a/Documentation/devicetree/bindings/arm/stm32/st,stm32-syscon.yaml b/Documentation/devicetree/bindings/arm/stm32/st,stm32-syscon.yaml
index 6f846d69c5e1..b2b156cc160a 100644
--- a/Documentation/devicetree/bindings/arm/stm32/st,stm32-syscon.yaml
+++ b/Documentation/devicetree/bindings/arm/stm32/st,stm32-syscon.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/arm/stm32/st,stm32-syscon.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: STMicroelectronics STM32 Platforms System Controller bindings
+title: STMicroelectronics STM32 Platforms System Controller
 
 maintainers:
   - Alexandre Torgue <alexandre.torgue@foss.st.com>
diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra194-cbb.yaml b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra194-cbb.yaml
index debb2b0c8013..dd3a4770c6a1 100644
--- a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra194-cbb.yaml
+++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra194-cbb.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/arm/tegra/nvidia,tegra194-cbb.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: NVIDIA Tegra194 CBB 1.0 bindings
+title: NVIDIA Tegra194 CBB 1.0
 
 maintainers:
   - Sumit Gupta <sumitg@nvidia.com>
diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra234-cbb.yaml b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra234-cbb.yaml
index 7b1fe50ffbe0..44184ee01449 100644
--- a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra234-cbb.yaml
+++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra234-cbb.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/arm/tegra/nvidia,tegra234-cbb.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: NVIDIA Tegra CBB 2.0 bindings
+title: NVIDIA Tegra CBB 2.0
 
 maintainers:
   - Sumit Gupta <sumitg@nvidia.com>
diff --git a/Documentation/devicetree/bindings/arm/vexpress-config.yaml b/Documentation/devicetree/bindings/arm/vexpress-config.yaml
index 09e1adf5ca7a..b74380da3198 100644
--- a/Documentation/devicetree/bindings/arm/vexpress-config.yaml
+++ b/Documentation/devicetree/bindings/arm/vexpress-config.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/arm/vexpress-config.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: ARM Versatile Express configuration bus bindings
+title: ARM Versatile Express configuration bus
 
 maintainers:
   - Andre Przywara <andre.przywara@arm.com>
diff --git a/Documentation/devicetree/bindings/arm/vexpress-sysreg.yaml b/Documentation/devicetree/bindings/arm/vexpress-sysreg.yaml
index f04db802a732..be6e3b542569 100644
--- a/Documentation/devicetree/bindings/arm/vexpress-sysreg.yaml
+++ b/Documentation/devicetree/bindings/arm/vexpress-sysreg.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/arm/vexpress-sysreg.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: ARM Versatile Express system registers bindings
+title: ARM Versatile Express system registers
 
 maintainers:
   - Andre Przywara <andre.przywara@arm.com>
diff --git a/Documentation/devicetree/bindings/ata/allwinner,sun4i-a10-ahci.yaml b/Documentation/devicetree/bindings/ata/allwinner,sun4i-a10-ahci.yaml
index cb530b46beff..2011bd03cdcd 100644
--- a/Documentation/devicetree/bindings/ata/allwinner,sun4i-a10-ahci.yaml
+++ b/Documentation/devicetree/bindings/ata/allwinner,sun4i-a10-ahci.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/ata/allwinner,sun4i-a10-ahci.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Allwinner A10 AHCI SATA Controller bindings
+title: Allwinner A10 AHCI SATA Controller
 
 maintainers:
   - Chen-Yu Tsai <wens@csie.org>
diff --git a/Documentation/devicetree/bindings/ata/allwinner,sun8i-r40-ahci.yaml b/Documentation/devicetree/bindings/ata/allwinner,sun8i-r40-ahci.yaml
index e6b42a113ff1..a2afe2ad6063 100644
--- a/Documentation/devicetree/bindings/ata/allwinner,sun8i-r40-ahci.yaml
+++ b/Documentation/devicetree/bindings/ata/allwinner,sun8i-r40-ahci.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/ata/allwinner,sun8i-r40-ahci.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Allwinner R40 AHCI SATA Controller bindings
+title: Allwinner R40 AHCI SATA Controller
 
 maintainers:
   - Chen-Yu Tsai <wens@csie.org>
diff --git a/Documentation/devicetree/bindings/bus/ti-sysc.yaml b/Documentation/devicetree/bindings/bus/ti-sysc.yaml
index fced4082b047..f089634f9466 100644
--- a/Documentation/devicetree/bindings/bus/ti-sysc.yaml
+++ b/Documentation/devicetree/bindings/bus/ti-sysc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/bus/ti-sysc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Texas Instruments interconnect target module binding
+title: Texas Instruments interconnect target module
 
 maintainers:
   - Tony Lindgren <tony@atomide.com>
diff --git a/Documentation/devicetree/bindings/clock/fsl,plldig.yaml b/Documentation/devicetree/bindings/clock/fsl,plldig.yaml
index 9ac716dfa602..88dd9c18db92 100644
--- a/Documentation/devicetree/bindings/clock/fsl,plldig.yaml
+++ b/Documentation/devicetree/bindings/clock/fsl,plldig.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/fsl,plldig.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: NXP QorIQ Layerscape LS1028A Display PIXEL Clock Binding
+title: NXP QorIQ Layerscape LS1028A Display PIXEL Clock
 
 maintainers:
   - Wen He <wen.he_1@nxp.com>
diff --git a/Documentation/devicetree/bindings/clock/fsl,sai-clock.yaml b/Documentation/devicetree/bindings/clock/fsl,sai-clock.yaml
index fc3bdfdc091a..3bca9d11c148 100644
--- a/Documentation/devicetree/bindings/clock/fsl,sai-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/fsl,sai-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/fsl,sai-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Freescale SAI bitclock-as-a-clock binding
+title: Freescale SAI bitclock-as-a-clock
 
 maintainers:
   - Michael Walle <michael@walle.cc>
diff --git a/Documentation/devicetree/bindings/clock/imx8m-clock.yaml b/Documentation/devicetree/bindings/clock/imx8m-clock.yaml
index 458c7645ee68..e4c4cadec501 100644
--- a/Documentation/devicetree/bindings/clock/imx8m-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx8m-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx8m-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: NXP i.MX8M Family Clock Control Module Binding
+title: NXP i.MX8M Family Clock Control Module
 
 maintainers:
   - Anson Huang <Anson.Huang@nxp.com>
diff --git a/Documentation/devicetree/bindings/clock/imx8qxp-lpcg.yaml b/Documentation/devicetree/bindings/clock/imx8qxp-lpcg.yaml
index cb80105b3c70..b207f95361b2 100644
--- a/Documentation/devicetree/bindings/clock/imx8qxp-lpcg.yaml
+++ b/Documentation/devicetree/bindings/clock/imx8qxp-lpcg.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx8qxp-lpcg.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: NXP i.MX8QXP LPCG (Low-Power Clock Gating) Clock bindings
+title: NXP i.MX8QXP LPCG (Low-Power Clock Gating) Clock
 
 maintainers:
   - Aisheng Dong <aisheng.dong@nxp.com>
diff --git a/Documentation/devicetree/bindings/clock/imx8ulp-cgc-clock.yaml b/Documentation/devicetree/bindings/clock/imx8ulp-cgc-clock.yaml
index 71f7186b135b..68a60cdc19af 100644
--- a/Documentation/devicetree/bindings/clock/imx8ulp-cgc-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx8ulp-cgc-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx8ulp-cgc-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: NXP i.MX8ULP Clock Generation & Control(CGC) Module Binding
+title: NXP i.MX8ULP Clock Generation & Control(CGC) Module
 
 maintainers:
   - Jacky Bai <ping.bai@nxp.com>
diff --git a/Documentation/devicetree/bindings/clock/imx8ulp-pcc-clock.yaml b/Documentation/devicetree/bindings/clock/imx8ulp-pcc-clock.yaml
index 00612725bf8b..d0b0792fe7ba 100644
--- a/Documentation/devicetree/bindings/clock/imx8ulp-pcc-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx8ulp-pcc-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx8ulp-pcc-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: NXP i.MX8ULP Peripheral Clock Controller(PCC) Module Binding
+title: NXP i.MX8ULP Peripheral Clock Controller(PCC) Module
 
 maintainers:
   - Jacky Bai <ping.bai@nxp.com>
diff --git a/Documentation/devicetree/bindings/clock/imx93-clock.yaml b/Documentation/devicetree/bindings/clock/imx93-clock.yaml
index 21a06194e4a3..ccb53c6b96c1 100644
--- a/Documentation/devicetree/bindings/clock/imx93-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx93-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/imx93-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: NXP i.MX93 Clock Control Module Binding
+title: NXP i.MX93 Clock Control Module
 
 maintainers:
   - Peng Fan <peng.fan@nxp.com>
diff --git a/Documentation/devicetree/bindings/clock/intel,agilex.yaml b/Documentation/devicetree/bindings/clock/intel,agilex.yaml
index cf5a9eb803e6..3745ba8dbd76 100644
--- a/Documentation/devicetree/bindings/clock/intel,agilex.yaml
+++ b/Documentation/devicetree/bindings/clock/intel,agilex.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/intel,agilex.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Intel SoCFPGA Agilex platform clock controller binding
+title: Intel SoCFPGA Agilex platform clock controller
 
 maintainers:
   - Dinh Nguyen <dinguyen@kernel.org>
diff --git a/Documentation/devicetree/bindings/clock/intel,cgu-lgm.yaml b/Documentation/devicetree/bindings/clock/intel,cgu-lgm.yaml
index f3e1a700a2ca..76609a390429 100644
--- a/Documentation/devicetree/bindings/clock/intel,cgu-lgm.yaml
+++ b/Documentation/devicetree/bindings/clock/intel,cgu-lgm.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/intel,cgu-lgm.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Intel Lightning Mountain SoC's Clock Controller(CGU) Binding
+title: Intel Lightning Mountain SoC's Clock Controller(CGU)
 
 maintainers:
   - Rahul Tanwar <rahul.tanwar@linux.intel.com>
diff --git a/Documentation/devicetree/bindings/clock/intel,easic-n5x.yaml b/Documentation/devicetree/bindings/clock/intel,easic-n5x.yaml
index 8f45976e946e..e000116a51a4 100644
--- a/Documentation/devicetree/bindings/clock/intel,easic-n5x.yaml
+++ b/Documentation/devicetree/bindings/clock/intel,easic-n5x.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/intel,easic-n5x.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Intel SoCFPGA eASIC N5X platform clock controller binding
+title: Intel SoCFPGA eASIC N5X platform clock controller
 
 maintainers:
   - Dinh Nguyen <dinguyen@kernel.org>
diff --git a/Documentation/devicetree/bindings/clock/intel,stratix10.yaml b/Documentation/devicetree/bindings/clock/intel,stratix10.yaml
index f506e3db9782..b4a8be213400 100644
--- a/Documentation/devicetree/bindings/clock/intel,stratix10.yaml
+++ b/Documentation/devicetree/bindings/clock/intel,stratix10.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/intel,stratix10.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Intel SoCFPGA Stratix10 platform clock controller binding
+title: Intel SoCFPGA Stratix10 platform clock controller
 
 maintainers:
   - Dinh Nguyen <dinguyen@kernel.org>
diff --git a/Documentation/devicetree/bindings/clock/microchip,mpfs-clkcfg.yaml b/Documentation/devicetree/bindings/clock/microchip,mpfs-clkcfg.yaml
index b2ce78722247..e4e1c31267d2 100644
--- a/Documentation/devicetree/bindings/clock/microchip,mpfs-clkcfg.yaml
+++ b/Documentation/devicetree/bindings/clock/microchip,mpfs-clkcfg.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/microchip,mpfs-clkcfg.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Microchip PolarFire Clock Control Module Binding
+title: Microchip PolarFire Clock Control Module
 
 maintainers:
   - Daire McNamara <daire.mcnamara@microchip.com>
diff --git a/Documentation/devicetree/bindings/clock/milbeaut-clock.yaml b/Documentation/devicetree/bindings/clock/milbeaut-clock.yaml
index 6d39344d2b70..0af1c569eb32 100644
--- a/Documentation/devicetree/bindings/clock/milbeaut-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/milbeaut-clock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/milbeaut-clock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Milbeaut SoCs Clock Controller Binding
+title: Milbeaut SoCs Clock Controller
 
 maintainers:
   - Taichi Sugaya <sugaya.taichi@socionext.com>
diff --git a/Documentation/devicetree/bindings/clock/nuvoton,npcm845-clk.yaml b/Documentation/devicetree/bindings/clock/nuvoton,npcm845-clk.yaml
index 771db2ddf026..b901ca13cd25 100644
--- a/Documentation/devicetree/bindings/clock/nuvoton,npcm845-clk.yaml
+++ b/Documentation/devicetree/bindings/clock/nuvoton,npcm845-clk.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/nuvoton,npcm845-clk.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Nuvoton NPCM8XX Clock Controller Binding
+title: Nuvoton NPCM8XX Clock Controller
 
 maintainers:
   - Tomer Maimon <tmaimon77@gmail.com>
diff --git a/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml b/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml
index fccb91e78e49..cf25ba0419e2 100644
--- a/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/qcom,rpmhcc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Technologies, Inc. RPMh Clocks Bindings
+title: Qualcomm Technologies, Inc. RPMh Clocks
 
 maintainers:
   - Taniya Das <tdas@codeaurora.org>
diff --git a/Documentation/devicetree/bindings/clock/rockchip,rk3568-cru.yaml b/Documentation/devicetree/bindings/clock/rockchip,rk3568-cru.yaml
index fc7546f521c5..f809c289445e 100644
--- a/Documentation/devicetree/bindings/clock/rockchip,rk3568-cru.yaml
+++ b/Documentation/devicetree/bindings/clock/rockchip,rk3568-cru.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/rockchip,rk3568-cru.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: ROCKCHIP rk3568 Family Clock Control Module Binding
+title: ROCKCHIP rk3568 Family Clock Control Module
 
 maintainers:
   - Elaine Zhang <zhangqing@rock-chips.com>
diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-mediatek-hw.yaml b/Documentation/devicetree/bindings/cpufreq/cpufreq-mediatek-hw.yaml
index 9cd42a64b13e..d0aecde2b89b 100644
--- a/Documentation/devicetree/bindings/cpufreq/cpufreq-mediatek-hw.yaml
+++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-mediatek-hw.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/cpufreq/cpufreq-mediatek-hw.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: MediaTek's CPUFREQ Bindings
+title: MediaTek's CPUFREQ
 
 maintainers:
   - Hector Yuan <hector.yuan@mediatek.com>
diff --git a/Documentation/devicetree/bindings/cpufreq/qcom-cpufreq-nvmem.yaml b/Documentation/devicetree/bindings/cpufreq/qcom-cpufreq-nvmem.yaml
index a11e1b867379..141f985d48e4 100644
--- a/Documentation/devicetree/bindings/cpufreq/qcom-cpufreq-nvmem.yaml
+++ b/Documentation/devicetree/bindings/cpufreq/qcom-cpufreq-nvmem.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/cpufreq/qcom-cpufreq-nvmem.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Technologies, Inc. NVMEM CPUFreq bindings
+title: Qualcomm Technologies, Inc. NVMEM CPUFreq
 
 maintainers:
   - Ilia Lin <ilia.lin@kernel.org>
diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-crc.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-crc.yaml
index b72e4858f9aa..50b2c2e0c3cd 100644
--- a/Documentation/devicetree/bindings/crypto/st,stm32-crc.yaml
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-crc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/crypto/st,stm32-crc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 CRC bindings
+title: STMicroelectronics STM32 CRC
 
 maintainers:
   - Lionel Debieve <lionel.debieve@foss.st.com>
diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
index ed23bf94a8e0..a34348d0e2d3 100644
--- a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/crypto/st,stm32-cryp.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 CRYP bindings
+title: STMicroelectronics STM32 CRYP
 
 maintainers:
   - Lionel Debieve <lionel.debieve@foss.st.com>
diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
index 10ba94792d95..4ccb335e8063 100644
--- a/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/crypto/st,stm32-hash.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 HASH bindings
+title: STMicroelectronics STM32 HASH
 
 maintainers:
   - Lionel Debieve <lionel.debieve@foss.st.com>
diff --git a/Documentation/devicetree/bindings/display/arm,hdlcd.yaml b/Documentation/devicetree/bindings/display/arm,hdlcd.yaml
index a2670258c48d..9a30e9005e8a 100644
--- a/Documentation/devicetree/bindings/display/arm,hdlcd.yaml
+++ b/Documentation/devicetree/bindings/display/arm,hdlcd.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/display/arm,hdlcd.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Arm HDLCD display controller binding
+title: Arm HDLCD display controller
 
 maintainers:
   - Liviu Dudau <Liviu.Dudau@arm.com>
diff --git a/Documentation/devicetree/bindings/display/arm,malidp.yaml b/Documentation/devicetree/bindings/display/arm,malidp.yaml
index 2a17ec6fc97c..91812573fd08 100644
--- a/Documentation/devicetree/bindings/display/arm,malidp.yaml
+++ b/Documentation/devicetree/bindings/display/arm,malidp.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/display/arm,malidp.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Arm Mali Display Processor (Mali-DP) binding
+title: Arm Mali Display Processor (Mali-DP)
 
 maintainers:
   - Liviu Dudau <Liviu.Dudau@arm.com>
diff --git a/Documentation/devicetree/bindings/display/bridge/toshiba,tc358767.yaml b/Documentation/devicetree/bindings/display/bridge/toshiba,tc358767.yaml
index ed280053ec62..140927884418 100644
--- a/Documentation/devicetree/bindings/display/bridge/toshiba,tc358767.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/toshiba,tc358767.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/display/bridge/toshiba,tc358767.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Toshiba TC358767 eDP bridge bindings
+title: Toshiba TC358767 eDP bridge
 
 maintainers:
   - Andrey Gusakov <andrey.gusakov@cogentembedded.com>
diff --git a/Documentation/devicetree/bindings/display/bridge/toshiba,tc358775.yaml b/Documentation/devicetree/bindings/display/bridge/toshiba,tc358775.yaml
index 10471c6c1ff9..d879c700594a 100644
--- a/Documentation/devicetree/bindings/display/bridge/toshiba,tc358775.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/toshiba,tc358775.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/display/bridge/toshiba,tc358775.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Toshiba TC358775 DSI to LVDS bridge bindings
+title: Toshiba TC358775 DSI to LVDS bridge
 
 maintainers:
   - Vinay Simha BN <simhavcs@gmail.com>
diff --git a/Documentation/devicetree/bindings/display/panel/display-timings.yaml b/Documentation/devicetree/bindings/display/panel/display-timings.yaml
index 6d30575819d3..dc5f7e36e30b 100644
--- a/Documentation/devicetree/bindings/display/panel/display-timings.yaml
+++ b/Documentation/devicetree/bindings/display/panel/display-timings.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/display/panel/display-timings.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: display timings bindings
+title: display timings
 
 maintainers:
   - Thierry Reding <thierry.reding@gmail.com>
diff --git a/Documentation/devicetree/bindings/display/panel/panel-timing.yaml b/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
index 229e3b36ee29..0d317e61edd8 100644
--- a/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
+++ b/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/display/panel/panel-timing.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: panel timing bindings
+title: panel timing
 
 maintainers:
   - Thierry Reding <thierry.reding@gmail.com>
diff --git a/Documentation/devicetree/bindings/dma/st,stm32-dma.yaml b/Documentation/devicetree/bindings/dma/st,stm32-dma.yaml
index 55faab6a468e..158c791d7caa 100644
--- a/Documentation/devicetree/bindings/dma/st,stm32-dma.yaml
+++ b/Documentation/devicetree/bindings/dma/st,stm32-dma.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/dma/st,stm32-dma.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 DMA Controller bindings
+title: STMicroelectronics STM32 DMA Controller
 
 description: |
   The STM32 DMA is a general-purpose direct memory access controller capable of
diff --git a/Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml b/Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml
index 1e1d8549b7ef..3e0b82d277ca 100644
--- a/Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml
+++ b/Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/dma/st,stm32-dmamux.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 DMA MUX (DMA request router) bindings
+title: STMicroelectronics STM32 DMA MUX (DMA request router)
 
 maintainers:
   - Amelie Delaunay <amelie.delaunay@foss.st.com>
diff --git a/Documentation/devicetree/bindings/dma/st,stm32-mdma.yaml b/Documentation/devicetree/bindings/dma/st,stm32-mdma.yaml
index 00cfa3913652..08a59bd69a2f 100644
--- a/Documentation/devicetree/bindings/dma/st,stm32-mdma.yaml
+++ b/Documentation/devicetree/bindings/dma/st,stm32-mdma.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/dma/st,stm32-mdma.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 MDMA Controller bindings
+title: STMicroelectronics STM32 MDMA Controller
 
 description: |
   The STM32 MDMA is a general-purpose direct memory access controller capable of
diff --git a/Documentation/devicetree/bindings/edac/dmc-520.yaml b/Documentation/devicetree/bindings/edac/dmc-520.yaml
index 3b6842e92d1b..84db3966662a 100644
--- a/Documentation/devicetree/bindings/edac/dmc-520.yaml
+++ b/Documentation/devicetree/bindings/edac/dmc-520.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/edac/dmc-520.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: ARM DMC-520 EDAC bindings
+title: ARM DMC-520 EDAC
 
 maintainers:
   - Lei Wang <lewan@microsoft.com>
diff --git a/Documentation/devicetree/bindings/firmware/arm,scmi.yaml b/Documentation/devicetree/bindings/firmware/arm,scmi.yaml
index 1c0388da6721..176796931a22 100644
--- a/Documentation/devicetree/bindings/firmware/arm,scmi.yaml
+++ b/Documentation/devicetree/bindings/firmware/arm,scmi.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/firmware/arm,scmi.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: System Control and Management Interface (SCMI) Message Protocol bindings
+title: System Control and Management Interface (SCMI) Message Protocol
 
 maintainers:
   - Sudeep Holla <sudeep.holla@arm.com>
diff --git a/Documentation/devicetree/bindings/firmware/arm,scpi.yaml b/Documentation/devicetree/bindings/firmware/arm,scpi.yaml
index 1f9322925e7c..241317239ffc 100644
--- a/Documentation/devicetree/bindings/firmware/arm,scpi.yaml
+++ b/Documentation/devicetree/bindings/firmware/arm,scpi.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/firmware/arm,scpi.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: System Control and Power Interface (SCPI) Message Protocol bindings
+title: System Control and Power Interface (SCPI) Message Protocol
 
 maintainers:
   - Sudeep Holla <sudeep.holla@arm.com>
diff --git a/Documentation/devicetree/bindings/firmware/qemu,fw-cfg-mmio.yaml b/Documentation/devicetree/bindings/firmware/qemu,fw-cfg-mmio.yaml
index fcf0011b8e6d..3faae3236665 100644
--- a/Documentation/devicetree/bindings/firmware/qemu,fw-cfg-mmio.yaml
+++ b/Documentation/devicetree/bindings/firmware/qemu,fw-cfg-mmio.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/firmware/qemu,fw-cfg-mmio.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: QEMU Firmware Configuration bindings
+title: QEMU Firmware Configuration
 
 maintainers:
   - Rob Herring <robh@kernel.org>
diff --git a/Documentation/devicetree/bindings/gpio/gpio-tpic2810.yaml b/Documentation/devicetree/bindings/gpio/gpio-tpic2810.yaml
index cb8a5c376e1e..157969bc4c46 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-tpic2810.yaml
+++ b/Documentation/devicetree/bindings/gpio/gpio-tpic2810.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/gpio/gpio-tpic2810.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: TPIC2810 GPIO controller bindings
+title: TPIC2810 GPIO controller
 
 maintainers:
   - Aswath Govindraju <a-govindraju@ti.com>
diff --git a/Documentation/devicetree/bindings/gpio/ti,omap-gpio.yaml b/Documentation/devicetree/bindings/gpio/ti,omap-gpio.yaml
index 7087e4a5013f..bd721c839059 100644
--- a/Documentation/devicetree/bindings/gpio/ti,omap-gpio.yaml
+++ b/Documentation/devicetree/bindings/gpio/ti,omap-gpio.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/gpio/ti,omap-gpio.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: OMAP GPIO controller bindings
+title: OMAP GPIO controller
 
 maintainers:
   - Grygorii Strashko <grygorii.strashko@ti.com>
diff --git a/Documentation/devicetree/bindings/gpu/brcm,bcm-v3d.yaml b/Documentation/devicetree/bindings/gpu/brcm,bcm-v3d.yaml
index 217c42874f41..dae55b8a267b 100644
--- a/Documentation/devicetree/bindings/gpu/brcm,bcm-v3d.yaml
+++ b/Documentation/devicetree/bindings/gpu/brcm,bcm-v3d.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/gpu/brcm,bcm-v3d.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Broadcom V3D GPU Bindings
+title: Broadcom V3D GPU
 
 maintainers:
   - Eric Anholt <eric@anholt.net>
diff --git a/Documentation/devicetree/bindings/gpu/vivante,gc.yaml b/Documentation/devicetree/bindings/gpu/vivante,gc.yaml
index 93e7244cdc0e..b1b10ea70ad9 100644
--- a/Documentation/devicetree/bindings/gpu/vivante,gc.yaml
+++ b/Documentation/devicetree/bindings/gpu/vivante,gc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/gpu/vivante,gc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Vivante GPU Bindings
+title: Vivante GPU
 
 description: Vivante GPU core devices
 
diff --git a/Documentation/devicetree/bindings/hwlock/st,stm32-hwspinlock.yaml b/Documentation/devicetree/bindings/hwlock/st,stm32-hwspinlock.yaml
index b18c616035a8..829d1fdf4c67 100644
--- a/Documentation/devicetree/bindings/hwlock/st,stm32-hwspinlock.yaml
+++ b/Documentation/devicetree/bindings/hwlock/st,stm32-hwspinlock.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/hwlock/st,stm32-hwspinlock.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 Hardware Spinlock bindings
+title: STMicroelectronics STM32 Hardware Spinlock
 
 maintainers:
   - Fabien Dessenne <fabien.dessenne@foss.st.com>
diff --git a/Documentation/devicetree/bindings/hwmon/moortec,mr75203.yaml b/Documentation/devicetree/bindings/hwmon/moortec,mr75203.yaml
index d0d549749208..ae4f68d4e696 100644
--- a/Documentation/devicetree/bindings/hwmon/moortec,mr75203.yaml
+++ b/Documentation/devicetree/bindings/hwmon/moortec,mr75203.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/hwmon/moortec,mr75203.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Moortec Semiconductor MR75203 PVT Controller bindings
+title: Moortec Semiconductor MR75203 PVT Controller
 
 maintainers:
   - Rahul Tanwar <rtanwar@maxlinear.com>
diff --git a/Documentation/devicetree/bindings/i2c/i2c-pxa.yaml b/Documentation/devicetree/bindings/i2c/i2c-pxa.yaml
index 015885dd02d3..31386a8d7684 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-pxa.yaml
+++ b/Documentation/devicetree/bindings/i2c/i2c-pxa.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/i2c/i2c-pxa.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Marvell MMP I2C controller bindings
+title: Marvell MMP I2C controller
 
 maintainers:
   - Rob Herring <robh+dt@kernel.org>
diff --git a/Documentation/devicetree/bindings/i2c/st,nomadik-i2c.yaml b/Documentation/devicetree/bindings/i2c/st,nomadik-i2c.yaml
index 42c5974ec7b0..16024415a4a7 100644
--- a/Documentation/devicetree/bindings/i2c/st,nomadik-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/st,nomadik-i2c.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/i2c/st,nomadik-i2c.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: ST Microelectronics Nomadik I2C Bindings
+title: ST Microelectronics Nomadik I2C
 
 description: The Nomadik I2C host controller began its life in the ST
   Microelectronics STn8800 SoC, and was then inherited into STn8810 and
diff --git a/Documentation/devicetree/bindings/i3c/i3c.yaml b/Documentation/devicetree/bindings/i3c/i3c.yaml
index 1f82fc923799..fdb4212149e7 100644
--- a/Documentation/devicetree/bindings/i3c/i3c.yaml
+++ b/Documentation/devicetree/bindings/i3c/i3c.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/i3c/i3c.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: I3C bus binding
+title: I3C bus
 
 maintainers:
   - Alexandre Belloni <alexandre.belloni@bootlin.com>
diff --git a/Documentation/devicetree/bindings/iio/adc/ingenic,adc.yaml b/Documentation/devicetree/bindings/iio/adc/ingenic,adc.yaml
index 698beb896f76..517e8b1fcb73 100644
--- a/Documentation/devicetree/bindings/iio/adc/ingenic,adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/ingenic,adc.yaml
@@ -5,7 +5,7 @@
 $id: "http://devicetree.org/schemas/iio/adc/ingenic,adc.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Ingenic JZ47xx ADC controller IIO bindings
+title: Ingenic JZ47xx ADC controller IIO
 
 maintainers:
   - Artur Rojek <contact@artur-rojek.eu>
diff --git a/Documentation/devicetree/bindings/iio/adc/motorola,cpcap-adc.yaml b/Documentation/devicetree/bindings/iio/adc/motorola,cpcap-adc.yaml
index a6cb857a232d..9ceb6f18c854 100644
--- a/Documentation/devicetree/bindings/iio/adc/motorola,cpcap-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/motorola,cpcap-adc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/iio/adc/motorola,cpcap-adc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Motorola CPCAP PMIC ADC binding
+title: Motorola CPCAP PMIC ADC
 
 maintainers:
   - Tony Lindgren <tony@atomide.com>
diff --git a/Documentation/devicetree/bindings/iio/adc/nxp,imx8qxp-adc.yaml b/Documentation/devicetree/bindings/iio/adc/nxp,imx8qxp-adc.yaml
index 9c59a20a6032..63369ba388e4 100644
--- a/Documentation/devicetree/bindings/iio/adc/nxp,imx8qxp-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/nxp,imx8qxp-adc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/iio/adc/nxp,imx8qxp-adc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: NXP IMX8QXP ADC bindings
+title: NXP IMX8QXP ADC
 
 maintainers:
   - Cai Huoqing <caihuoqing@baidu.com>
diff --git a/Documentation/devicetree/bindings/iio/adc/nxp,lpc1850-adc.yaml b/Documentation/devicetree/bindings/iio/adc/nxp,lpc1850-adc.yaml
index 43abb300fa3d..70b38038a080 100644
--- a/Documentation/devicetree/bindings/iio/adc/nxp,lpc1850-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/nxp,lpc1850-adc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/iio/adc/nxp,lpc1850-adc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: NXP LPC1850 ADC bindings
+title: NXP LPC1850 ADC
 
 maintainers:
   - Jonathan Cameron <jic23@kernel.org>
diff --git a/Documentation/devicetree/bindings/iio/adc/sprd,sc2720-adc.yaml b/Documentation/devicetree/bindings/iio/adc/sprd,sc2720-adc.yaml
index 44aa28b59197..8181cf9a8e07 100644
--- a/Documentation/devicetree/bindings/iio/adc/sprd,sc2720-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/sprd,sc2720-adc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/iio/adc/sprd,sc2720-adc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Spreadtrum SC27XX series PMICs ADC binding
+title: Spreadtrum SC27XX series PMICs ADC
 
 maintainers:
   - Baolin Wang <baolin.wang7@gmail.com>
diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
index 05265f381fde..1c340c95df16 100644
--- a/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/iio/adc/st,stm32-adc.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: STMicroelectronics STM32 ADC bindings
+title: STMicroelectronics STM32 ADC
 
 description: |
   STM32 ADC is a successive approximation analog-to-digital converter.
diff --git a/Documentation/devicetree/bindings/iio/adc/x-powers,axp209-adc.yaml b/Documentation/devicetree/bindings/iio/adc/x-powers,axp209-adc.yaml
index d6d3d8590171..d40689f233f2 100644
--- a/Documentation/devicetree/bindings/iio/adc/x-powers,axp209-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/x-powers,axp209-adc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/iio/adc/x-powers,axp209-adc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: X-Powers AXP ADC bindings
+title: X-Powers AXP ADC
 
 maintainers:
   - Chen-Yu Tsai <wens@csie.org>
diff --git a/Documentation/devicetree/bindings/iio/dac/nxp,lpc1850-dac.yaml b/Documentation/devicetree/bindings/iio/dac/nxp,lpc1850-dac.yaml
index 595f481c548e..9c8afe3f1b69 100644
--- a/Documentation/devicetree/bindings/iio/dac/nxp,lpc1850-dac.yaml
+++ b/Documentation/devicetree/bindings/iio/dac/nxp,lpc1850-dac.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/iio/dac/nxp,lpc1850-dac.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: NXP LPC1850 DAC bindings
+title: NXP LPC1850 DAC
 
 maintainers:
   - Jonathan Cameron <jic23@kernel.org>
diff --git a/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml b/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml
index 6adeda4087fc..0f1bf1110122 100644
--- a/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml
+++ b/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/iio/dac/st,stm32-dac.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: STMicroelectronics STM32 DAC bindings
+title: STMicroelectronics STM32 DAC
 
 description: |
   The STM32 DAC is a 12-bit voltage output digital-to-analog converter. The DAC
diff --git a/Documentation/devicetree/bindings/iio/multiplexer/io-channel-mux.yaml b/Documentation/devicetree/bindings/iio/multiplexer/io-channel-mux.yaml
index 611ad4444cf0..c55831b60ee6 100644
--- a/Documentation/devicetree/bindings/iio/multiplexer/io-channel-mux.yaml
+++ b/Documentation/devicetree/bindings/iio/multiplexer/io-channel-mux.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/iio/multiplexer/io-channel-mux.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: I/O channel multiplexer bindings
+title: I/O channel multiplexer
 
 maintainers:
   - Peter Rosin <peda@axentia.se>
diff --git a/Documentation/devicetree/bindings/input/input.yaml b/Documentation/devicetree/bindings/input/input.yaml
index 17512f4347fd..765c51090dfe 100644
--- a/Documentation/devicetree/bindings/input/input.yaml
+++ b/Documentation/devicetree/bindings/input/input.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/input.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Common input schema binding
+title: Common input schema
 
 maintainers:
   - Dmitry Torokhov <dmitry.torokhov@gmail.com>
diff --git a/Documentation/devicetree/bindings/input/touchscreen/cypress,cy8ctma140.yaml b/Documentation/devicetree/bindings/input/touchscreen/cypress,cy8ctma140.yaml
index 3225c8d1fdaf..86a6d18f952a 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/cypress,cy8ctma140.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/cypress,cy8ctma140.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/touchscreen/cypress,cy8ctma140.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Cypress CY8CTMA140 series touchscreen controller bindings
+title: Cypress CY8CTMA140 series touchscreen controller
 
 maintainers:
   - Linus Walleij <linus.walleij@linaro.org>
diff --git a/Documentation/devicetree/bindings/input/touchscreen/cypress,cy8ctma340.yaml b/Documentation/devicetree/bindings/input/touchscreen/cypress,cy8ctma340.yaml
index 762e56ee90cd..4dfbb93678b5 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/cypress,cy8ctma340.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/cypress,cy8ctma340.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/touchscreen/cypress,cy8ctma340.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Cypress CY8CTMA340 series touchscreen controller bindings
+title: Cypress CY8CTMA340 series touchscreen controller
 
 description: The Cypress CY8CTMA340 series (also known as "CYTTSP" after
   the marketing name Cypress TrueTouch Standard Product) touchscreens can
diff --git a/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.yaml b/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.yaml
index 46bc8c028fe6..ef4c841387bd 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/touchscreen/edt-ft5x06.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: FocalTech EDT-FT5x06 Polytouch Bindings
+title: FocalTech EDT-FT5x06 Polytouch
 
 description: |
              There are 5 variants of the chip for various touch panel sizes
diff --git a/Documentation/devicetree/bindings/input/touchscreen/goodix.yaml b/Documentation/devicetree/bindings/input/touchscreen/goodix.yaml
index 19ac9da421df..3d016b87c8df 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/goodix.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/goodix.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/touchscreen/goodix.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Goodix GT9xx series touchscreen controller Bindings
+title: Goodix GT9xx series touchscreen controller
 
 maintainers:
   - Dmitry Torokhov <dmitry.torokhov@gmail.com>
diff --git a/Documentation/devicetree/bindings/input/touchscreen/himax,hx83112b.yaml b/Documentation/devicetree/bindings/input/touchscreen/himax,hx83112b.yaml
index be2ba185c086..f42b23d532eb 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/himax,hx83112b.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/himax,hx83112b.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/touchscreen/himax,hx83112b.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Himax hx83112b touchscreen controller bindings
+title: Himax hx83112b touchscreen controller
 
 maintainers:
   - Job Noorman <job@noorman.info>
diff --git a/Documentation/devicetree/bindings/input/touchscreen/hycon,hy46xx.yaml b/Documentation/devicetree/bindings/input/touchscreen/hycon,hy46xx.yaml
index 942562f1e45b..874c0781c476 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/hycon,hy46xx.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/hycon,hy46xx.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/touchscreen/hycon,hy46xx.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Hycon HY46XX series touchscreen controller bindings
+title: Hycon HY46XX series touchscreen controller
 
 description: |
   There are 6 variants of the chip for various touch panel sizes and cover lens material
diff --git a/Documentation/devicetree/bindings/input/touchscreen/imagis,ist3038c.yaml b/Documentation/devicetree/bindings/input/touchscreen/imagis,ist3038c.yaml
index e3a2b871e50c..0d6b033fd5fb 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/imagis,ist3038c.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/imagis,ist3038c.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/touchscreen/imagis,ist3038c.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Imagis IST30XXC family touchscreen controller bindings
+title: Imagis IST30XXC family touchscreen controller
 
 maintainers:
   - Markuss Broks <markuss.broks@gmail.com>
diff --git a/Documentation/devicetree/bindings/input/touchscreen/melfas,mms114.yaml b/Documentation/devicetree/bindings/input/touchscreen/melfas,mms114.yaml
index 62366886fb3e..fdd02898e249 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/melfas,mms114.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/melfas,mms114.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/touchscreen/melfas,mms114.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Melfas MMS114 family touchscreen controller bindings
+title: Melfas MMS114 family touchscreen controller
 
 maintainers:
   - Linus Walleij <linus.walleij@linaro.org>
diff --git a/Documentation/devicetree/bindings/input/touchscreen/mstar,msg2638.yaml b/Documentation/devicetree/bindings/input/touchscreen/mstar,msg2638.yaml
index 3a42c23faf6f..bf0c27041a9b 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/mstar,msg2638.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/mstar,msg2638.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/touchscreen/mstar,msg2638.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: MStar msg2638 touchscreen controller Bindings
+title: MStar msg2638 touchscreen controller
 
 maintainers:
   - Vincent Knecht <vincent.knecht@mailoo.org>
diff --git a/Documentation/devicetree/bindings/input/touchscreen/ti,tsc2005.yaml b/Documentation/devicetree/bindings/input/touchscreen/ti,tsc2005.yaml
index 938aab016cc2..7187c390b2f5 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/ti,tsc2005.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/ti,tsc2005.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/touchscreen/ti,tsc2005.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Texas Instruments TSC2004 and TSC2005 touchscreen controller bindings
+title: Texas Instruments TSC2004 and TSC2005 touchscreen controller
 
 maintainers:
   - Marek Vasut <marex@denx.de>
diff --git a/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
index 4b5b212c772c..895592da9626 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/touchscreen/touchscreen.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Common touchscreen Bindings
+title: Common touchscreen
 
 maintainers:
   - Dmitry Torokhov <dmitry.torokhov@gmail.com>
diff --git a/Documentation/devicetree/bindings/input/touchscreen/zinitix,bt400.yaml b/Documentation/devicetree/bindings/input/touchscreen/zinitix,bt400.yaml
index b4e5ba7c0b49..b1507463a03e 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/zinitix,bt400.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/zinitix,bt400.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/input/touchscreen/zinitix,bt400.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Zinitix BT4xx and BT5xx series touchscreen controller bindings
+title: Zinitix BT4xx and BT5xx series touchscreen controller
 
 description: The Zinitix BT4xx and BT5xx series of touchscreen controllers
   are Korea-produced touchscreens with embedded microcontrollers. The
diff --git a/Documentation/devicetree/bindings/interrupt-controller/mrvl,intc.yaml b/Documentation/devicetree/bindings/interrupt-controller/mrvl,intc.yaml
index 5a583bf3dbc1..9acc21028413 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/mrvl,intc.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/mrvl,intc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/interrupt-controller/mrvl,intc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Marvell MMP/Orion Interrupt controller bindings
+title: Marvell MMP/Orion Interrupt controller
 
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
diff --git a/Documentation/devicetree/bindings/interrupt-controller/nuvoton,wpcm450-aic.yaml b/Documentation/devicetree/bindings/interrupt-controller/nuvoton,wpcm450-aic.yaml
index 9ce6804bdb99..2d6307a383ad 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/nuvoton,wpcm450-aic.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/nuvoton,wpcm450-aic.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/interrupt-controller/nuvoton,wpcm450-aic.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Nuvoton WPCM450 Advanced Interrupt Controller bindings
+title: Nuvoton WPCM450 Advanced Interrupt Controller
 
 maintainers:
   - Jonathan Neuschäfer <j.neuschaefer@gmx.net>
diff --git a/Documentation/devicetree/bindings/ipmi/ipmi-ipmb.yaml b/Documentation/devicetree/bindings/ipmi/ipmi-ipmb.yaml
index 71bc031c4fde..3f25cdb4e99b 100644
--- a/Documentation/devicetree/bindings/ipmi/ipmi-ipmb.yaml
+++ b/Documentation/devicetree/bindings/ipmi/ipmi-ipmb.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/ipmi/ipmi-ipmb.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: IPMI IPMB device bindings
+title: IPMI IPMB device
 
 description: IPMI IPMB device bindings
 
diff --git a/Documentation/devicetree/bindings/ipmi/ipmi-smic.yaml b/Documentation/devicetree/bindings/ipmi/ipmi-smic.yaml
index 898e3267893a..c1b4bf95ef99 100644
--- a/Documentation/devicetree/bindings/ipmi/ipmi-smic.yaml
+++ b/Documentation/devicetree/bindings/ipmi/ipmi-smic.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/ipmi/ipmi-smic.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: IPMI device bindings
+title: IPMI device
 
 description: IPMI device bindings
 
diff --git a/Documentation/devicetree/bindings/leds/backlight/gpio-backlight.yaml b/Documentation/devicetree/bindings/leds/backlight/gpio-backlight.yaml
index 3300451fcfd5..584030b6b0b9 100644
--- a/Documentation/devicetree/bindings/leds/backlight/gpio-backlight.yaml
+++ b/Documentation/devicetree/bindings/leds/backlight/gpio-backlight.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/leds/backlight/gpio-backlight.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: gpio-backlight bindings
+title: gpio-backlight
 
 maintainers:
   - Lee Jones <lee@kernel.org>
diff --git a/Documentation/devicetree/bindings/leds/backlight/led-backlight.yaml b/Documentation/devicetree/bindings/leds/backlight/led-backlight.yaml
index 0793d0adc4ec..d7b78198abc2 100644
--- a/Documentation/devicetree/bindings/leds/backlight/led-backlight.yaml
+++ b/Documentation/devicetree/bindings/leds/backlight/led-backlight.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/leds/backlight/led-backlight.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: led-backlight bindings
+title: led-backlight
 
 maintainers:
   - Lee Jones <lee@kernel.org>
diff --git a/Documentation/devicetree/bindings/leds/backlight/pwm-backlight.yaml b/Documentation/devicetree/bindings/leds/backlight/pwm-backlight.yaml
index 78fbe20a1758..5ec47a8c6568 100644
--- a/Documentation/devicetree/bindings/leds/backlight/pwm-backlight.yaml
+++ b/Documentation/devicetree/bindings/leds/backlight/pwm-backlight.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/leds/backlight/pwm-backlight.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: pwm-backlight bindings
+title: pwm-backlight
 
 maintainers:
   - Lee Jones <lee@kernel.org>
diff --git a/Documentation/devicetree/bindings/mailbox/qcom,apcs-kpss-global.yaml b/Documentation/devicetree/bindings/mailbox/qcom,apcs-kpss-global.yaml
index f24fd84b4b05..c71b7c065b82 100644
--- a/Documentation/devicetree/bindings/mailbox/qcom,apcs-kpss-global.yaml
+++ b/Documentation/devicetree/bindings/mailbox/qcom,apcs-kpss-global.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/mailbox/qcom,apcs-kpss-global.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Qualcomm APCS global block bindings
+title: Qualcomm APCS global block
 
 description:
   This binding describes the APCS "global" block found in various Qualcomm
diff --git a/Documentation/devicetree/bindings/mailbox/sprd-mailbox.yaml b/Documentation/devicetree/bindings/mailbox/sprd-mailbox.yaml
index 80feba82cbd6..bdfb4a8220c5 100644
--- a/Documentation/devicetree/bindings/mailbox/sprd-mailbox.yaml
+++ b/Documentation/devicetree/bindings/mailbox/sprd-mailbox.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/mailbox/sprd-mailbox.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Spreadtrum mailbox controller bindings
+title: Spreadtrum mailbox controller
 
 maintainers:
   - Orson Zhai <orsonzhai@gmail.com>
diff --git a/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml b/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml
index 2c8b47285aa3..0dfe05a04dd0 100644
--- a/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml
+++ b/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/mailbox/st,stm32-ipcc.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: STMicroelectronics STM32 IPC controller bindings
+title: STMicroelectronics STM32 IPC controller
 
 description:
   The IPCC block provides a non blocking signaling mechanism to post and
diff --git a/Documentation/devicetree/bindings/media/marvell,mmp2-ccic.yaml b/Documentation/devicetree/bindings/media/marvell,mmp2-ccic.yaml
index b39b84c5f012..605e34503e5b 100644
--- a/Documentation/devicetree/bindings/media/marvell,mmp2-ccic.yaml
+++ b/Documentation/devicetree/bindings/media/marvell,mmp2-ccic.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/media/marvell,mmp2-ccic.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Marvell MMP2 camera host interface bindings
+title: Marvell MMP2 camera host interface
 
 maintainers:
   - Lubomir Rintel <lkundrak@v3.sk>
diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.yaml b/Documentation/devicetree/bindings/media/renesas,ceu.yaml
index 50e0740af15a..d527fc42c3fd 100644
--- a/Documentation/devicetree/bindings/media/renesas,ceu.yaml
+++ b/Documentation/devicetree/bindings/media/renesas,ceu.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/media/renesas,ceu.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Renesas Capture Engine Unit (CEU) Bindings
+title: Renesas Capture Engine Unit (CEU)
 
 maintainers:
   - Jacopo Mondi <jacopo+renesas@jmondi.org>
diff --git a/Documentation/devicetree/bindings/media/st,stm32-cec.yaml b/Documentation/devicetree/bindings/media/st,stm32-cec.yaml
index 77144cc6f7db..7f545a587a39 100644
--- a/Documentation/devicetree/bindings/media/st,stm32-cec.yaml
+++ b/Documentation/devicetree/bindings/media/st,stm32-cec.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/media/st,stm32-cec.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 CEC bindings
+title: STMicroelectronics STM32 CEC
 
 maintainers:
   - Yannick Fertre <yannick.fertre@foss.st.com>
diff --git a/Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml b/Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml
index 9c1262a276b5..ef7a856aa1a1 100644
--- a/Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml
+++ b/Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/media/st,stm32-dcmi.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 Digital Camera Memory Interface (DCMI) binding
+title: STMicroelectronics STM32 Digital Camera Memory Interface (DCMI)
 
 maintainers:
   - Hugues Fruchet <hugues.fruchet@foss.st.com>
diff --git a/Documentation/devicetree/bindings/media/st,stm32-dma2d.yaml b/Documentation/devicetree/bindings/media/st,stm32-dma2d.yaml
index f97b4a246605..4afa4a24b868 100644
--- a/Documentation/devicetree/bindings/media/st,stm32-dma2d.yaml
+++ b/Documentation/devicetree/bindings/media/st,stm32-dma2d.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/media/st,stm32-dma2d.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 Chrom-Art Accelerator DMA2D binding
+title: STMicroelectronics STM32 Chrom-Art Accelerator DMA2D
 
 description:
   Chrom-ART Accelerator(DMA2D), graphical hardware accelerator
diff --git a/Documentation/devicetree/bindings/memory-controllers/calxeda-ddr-ctrlr.yaml b/Documentation/devicetree/bindings/memory-controllers/calxeda-ddr-ctrlr.yaml
index 96d563fd61f5..e42aa488704d 100644
--- a/Documentation/devicetree/bindings/memory-controllers/calxeda-ddr-ctrlr.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/calxeda-ddr-ctrlr.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/memory-controllers/calxeda-ddr-ctrlr.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Calxeda DDR memory controller binding
+title: Calxeda DDR memory controller
 
 description: |
   The Calxeda DDR memory controller is initialised and programmed by the
diff --git a/Documentation/devicetree/bindings/memory-controllers/st,stm32-fmc2-ebi.yaml b/Documentation/devicetree/bindings/memory-controllers/st,stm32-fmc2-ebi.yaml
index d71af02b7f16..e76ba767dfd2 100644
--- a/Documentation/devicetree/bindings/memory-controllers/st,stm32-fmc2-ebi.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/st,stm32-fmc2-ebi.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/memory-controllers/st,stm32-fmc2-ebi.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics Flexible Memory Controller 2 (FMC2) Bindings
+title: STMicroelectronics Flexible Memory Controller 2 (FMC2)
 
 description: |
   The FMC2 functional block makes the interface with: synchronous and
diff --git a/Documentation/devicetree/bindings/mfd/actions,atc260x.yaml b/Documentation/devicetree/bindings/mfd/actions,atc260x.yaml
index dd43a0c766f3..c3a368a0fe93 100644
--- a/Documentation/devicetree/bindings/mfd/actions,atc260x.yaml
+++ b/Documentation/devicetree/bindings/mfd/actions,atc260x.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mfd/actions,atc260x.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Actions Semi ATC260x Power Management IC bindings
+title: Actions Semi ATC260x Power Management IC
 
 maintainers:
   - Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
diff --git a/Documentation/devicetree/bindings/mfd/ene-kb3930.yaml b/Documentation/devicetree/bindings/mfd/ene-kb3930.yaml
index 08af356f5d27..9b11b6e2bbf7 100644
--- a/Documentation/devicetree/bindings/mfd/ene-kb3930.yaml
+++ b/Documentation/devicetree/bindings/mfd/ene-kb3930.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mfd/ene-kb3930.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: ENE KB3930 Embedded Controller bindings
+title: ENE KB3930 Embedded Controller
 
 description: |
   This binding describes the ENE KB3930 Embedded Controller attached to an
diff --git a/Documentation/devicetree/bindings/mfd/ene-kb930.yaml b/Documentation/devicetree/bindings/mfd/ene-kb930.yaml
index 7c0a42390f18..02c111def5de 100644
--- a/Documentation/devicetree/bindings/mfd/ene-kb930.yaml
+++ b/Documentation/devicetree/bindings/mfd/ene-kb930.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mfd/ene-kb930.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: ENE KB930 Embedded Controller bindings
+title: ENE KB930 Embedded Controller
 
 description: |
   This binding describes the ENE KB930 Embedded Controller attached to an
diff --git a/Documentation/devicetree/bindings/mfd/fsl,imx8qxp-csr.yaml b/Documentation/devicetree/bindings/mfd/fsl,imx8qxp-csr.yaml
index f09577105b50..20067002cc4a 100644
--- a/Documentation/devicetree/bindings/mfd/fsl,imx8qxp-csr.yaml
+++ b/Documentation/devicetree/bindings/mfd/fsl,imx8qxp-csr.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mfd/fsl,imx8qxp-csr.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Freescale i.MX8qm/qxp Control and Status Registers Module Bindings
+title: Freescale i.MX8qm/qxp Control and Status Registers Module
 
 maintainers:
   - Liu Ying <victor.liu@nxp.com>
diff --git a/Documentation/devicetree/bindings/mfd/qcom,pm8008.yaml b/Documentation/devicetree/bindings/mfd/qcom,pm8008.yaml
index ec3138c1bbfc..e6a2387d8650 100644
--- a/Documentation/devicetree/bindings/mfd/qcom,pm8008.yaml
+++ b/Documentation/devicetree/bindings/mfd/qcom,pm8008.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mfd/qcom,pm8008.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Technologies, Inc. PM8008 PMIC bindings
+title: Qualcomm Technologies, Inc. PM8008 PMIC
 
 maintainers:
   - Guru Das Srinagesh <gurus@codeaurora.org>
diff --git a/Documentation/devicetree/bindings/mfd/rohm,bd71815-pmic.yaml b/Documentation/devicetree/bindings/mfd/rohm,bd71815-pmic.yaml
index fbface720678..5fbb94d2e4fa 100644
--- a/Documentation/devicetree/bindings/mfd/rohm,bd71815-pmic.yaml
+++ b/Documentation/devicetree/bindings/mfd/rohm,bd71815-pmic.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mfd/rohm,bd71815-pmic.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: ROHM BD71815 Power Management Integrated Circuit bindings
+title: ROHM BD71815 Power Management Integrated Circuit
 
 maintainers:
   - Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
diff --git a/Documentation/devicetree/bindings/mfd/rohm,bd71828-pmic.yaml b/Documentation/devicetree/bindings/mfd/rohm,bd71828-pmic.yaml
index 8380166d176c..d15ea8e9acad 100644
--- a/Documentation/devicetree/bindings/mfd/rohm,bd71828-pmic.yaml
+++ b/Documentation/devicetree/bindings/mfd/rohm,bd71828-pmic.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mfd/rohm,bd71828-pmic.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: ROHM BD71828 Power Management Integrated Circuit bindings
+title: ROHM BD71828 Power Management Integrated Circuit
 
 maintainers:
   - Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
diff --git a/Documentation/devicetree/bindings/mfd/rohm,bd71837-pmic.yaml b/Documentation/devicetree/bindings/mfd/rohm,bd71837-pmic.yaml
index 3bfdd33702ad..4aca765caee2 100644
--- a/Documentation/devicetree/bindings/mfd/rohm,bd71837-pmic.yaml
+++ b/Documentation/devicetree/bindings/mfd/rohm,bd71837-pmic.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mfd/rohm,bd71837-pmic.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: ROHM BD71837 Power Management Integrated Circuit bindings
+title: ROHM BD71837 Power Management Integrated Circuit
 
 maintainers:
   - Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
diff --git a/Documentation/devicetree/bindings/mfd/rohm,bd71847-pmic.yaml b/Documentation/devicetree/bindings/mfd/rohm,bd71847-pmic.yaml
index 5d531051a153..e6491729715f 100644
--- a/Documentation/devicetree/bindings/mfd/rohm,bd71847-pmic.yaml
+++ b/Documentation/devicetree/bindings/mfd/rohm,bd71847-pmic.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mfd/rohm,bd71847-pmic.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: ROHM BD71847 and BD71850 Power Management Integrated Circuit bindings
+title: ROHM BD71847 and BD71850 Power Management Integrated Circuit
 
 maintainers:
   - Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
diff --git a/Documentation/devicetree/bindings/mfd/rohm,bd9576-pmic.yaml b/Documentation/devicetree/bindings/mfd/rohm,bd9576-pmic.yaml
index 6483860da955..34ff0a322f3a 100644
--- a/Documentation/devicetree/bindings/mfd/rohm,bd9576-pmic.yaml
+++ b/Documentation/devicetree/bindings/mfd/rohm,bd9576-pmic.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mfd/rohm,bd9576-pmic.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: ROHM BD9576MUF and BD9573MUF Power Management Integrated Circuit bindings
+title: ROHM BD9576MUF and BD9573MUF Power Management Integrated Circuit
 
 maintainers:
   - Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
diff --git a/Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml b/Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml
index d950dd5d48bd..27329c5dc38e 100644
--- a/Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml
+++ b/Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mfd/st,stm32-lptimer.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 Low-Power Timers bindings
+title: STMicroelectronics STM32 Low-Power Timers
 
 description: |
   The STM32 Low-Power Timer (LPTIM) is a 16-bit timer that provides several
diff --git a/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml b/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml
index e2c3c3b44abb..f84e09a5743b 100644
--- a/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml
+++ b/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mfd/st,stm32-timers.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 Timers bindings
+title: STMicroelectronics STM32 Timers
 
 description: |
   This hardware block provides 3 types of timer along with PWM functionality:
diff --git a/Documentation/devicetree/bindings/mfd/st,stmfx.yaml b/Documentation/devicetree/bindings/mfd/st,stmfx.yaml
index b4d54302582f..76551c90b128 100644
--- a/Documentation/devicetree/bindings/mfd/st,stmfx.yaml
+++ b/Documentation/devicetree/bindings/mfd/st,stmfx.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mfd/st,stmfx.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectonics Multi-Function eXpander (STMFX) bindings
+title: STMicroelectonics Multi-Function eXpander (STMFX)
 
 description: ST Multi-Function eXpander (STMFX) is a slave controller using I2C for
                communication with the main MCU. Its main features are GPIO expansion,
diff --git a/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml b/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
index 426658ad81d4..9573e4af949e 100644
--- a/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
+++ b/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mfd/st,stpmic1.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectonics STPMIC1 Power Management IC bindings
+title: STMicroelectonics STPMIC1 Power Management IC
 
 description: STMicroelectronics STPMIC1 Power Management IC
 
diff --git a/Documentation/devicetree/bindings/misc/olpc,xo1.75-ec.yaml b/Documentation/devicetree/bindings/misc/olpc,xo1.75-ec.yaml
index b3c45c046ba5..e99342f268a6 100644
--- a/Documentation/devicetree/bindings/misc/olpc,xo1.75-ec.yaml
+++ b/Documentation/devicetree/bindings/misc/olpc,xo1.75-ec.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/misc/olpc,xo1.75-ec.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: OLPC XO-1.75 Embedded Controller bindings
+title: OLPC XO-1.75 Embedded Controller
 
 description: |
   This binding describes the Embedded Controller acting as a SPI bus master
diff --git a/Documentation/devicetree/bindings/mmc/brcm,sdhci-brcmstb.yaml b/Documentation/devicetree/bindings/mmc/brcm,sdhci-brcmstb.yaml
index dead421e17d6..c028039bc477 100644
--- a/Documentation/devicetree/bindings/mmc/brcm,sdhci-brcmstb.yaml
+++ b/Documentation/devicetree/bindings/mmc/brcm,sdhci-brcmstb.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mmc/brcm,sdhci-brcmstb.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Broadcom BRCMSTB/BMIPS SDHCI Controller binding
+title: Broadcom BRCMSTB/BMIPS SDHCI Controller
 
 maintainers:
   - Al Cooper <alcooperx@gmail.com>
diff --git a/Documentation/devicetree/bindings/mmc/microchip,dw-sparx5-sdhci.yaml b/Documentation/devicetree/bindings/mmc/microchip,dw-sparx5-sdhci.yaml
index 69ff065c9a39..fa6cfe092fc9 100644
--- a/Documentation/devicetree/bindings/mmc/microchip,dw-sparx5-sdhci.yaml
+++ b/Documentation/devicetree/bindings/mmc/microchip,dw-sparx5-sdhci.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mmc/microchip,dw-sparx5-sdhci.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Microchip Sparx5 Mobile Storage Host Controller Binding
+title: Microchip Sparx5 Mobile Storage Host Controller
 
 allOf:
   - $ref: "mmc-controller.yaml"
diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-emmc.yaml b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-emmc.yaml
index 1fc7e620f328..911a5996e099 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-emmc.yaml
+++ b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-emmc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mmc/mmc-pwrseq-emmc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Simple eMMC hardware reset provider binding
+title: Simple eMMC hardware reset provider
 
 maintainers:
   - Ulf Hansson <ulf.hansson@linaro.org>
diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.yaml b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.yaml
index 9e2396751030..3397dbff88c2 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.yaml
+++ b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mmc/mmc-pwrseq-sd8787.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Marvell SD8787 power sequence provider binding
+title: Marvell SD8787 power sequence provider
 
 maintainers:
   - Ulf Hansson <ulf.hansson@linaro.org>
diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml
index 226fb191913d..64e3644eefeb 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml
+++ b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mmc/mmc-pwrseq-simple.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Simple MMC power sequence provider binding
+title: Simple MMC power sequence provider
 
 maintainers:
   - Ulf Hansson <ulf.hansson@linaro.org>
diff --git a/Documentation/devicetree/bindings/mmc/mtk-sd.yaml b/Documentation/devicetree/bindings/mmc/mtk-sd.yaml
index 8ed94a12a03b..7a649ebc688c 100644
--- a/Documentation/devicetree/bindings/mmc/mtk-sd.yaml
+++ b/Documentation/devicetree/bindings/mmc/mtk-sd.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mmc/mtk-sd.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: MTK MSDC Storage Host Controller Binding
+title: MTK MSDC Storage Host Controller
 
 maintainers:
   - Chaotian Jing <chaotian.jing@mediatek.com>
diff --git a/Documentation/devicetree/bindings/mmc/sdhci-pxa.yaml b/Documentation/devicetree/bindings/mmc/sdhci-pxa.yaml
index 1c87f4218e18..3d46c2525787 100644
--- a/Documentation/devicetree/bindings/mmc/sdhci-pxa.yaml
+++ b/Documentation/devicetree/bindings/mmc/sdhci-pxa.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mmc/sdhci-pxa.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Marvell PXA SDHCI v2/v3 bindings
+title: Marvell PXA SDHCI v2/v3
 
 maintainers:
   - Ulf Hansson <ulf.hansson@linaro.org>
diff --git a/Documentation/devicetree/bindings/mmc/snps,dwcmshc-sdhci.yaml b/Documentation/devicetree/bindings/mmc/snps,dwcmshc-sdhci.yaml
index 51ba44cad842..a43eb837f8da 100644
--- a/Documentation/devicetree/bindings/mmc/snps,dwcmshc-sdhci.yaml
+++ b/Documentation/devicetree/bindings/mmc/snps,dwcmshc-sdhci.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mmc/snps,dwcmshc-sdhci.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Synopsys Designware Mobile Storage Host Controller Binding
+title: Synopsys Designware Mobile Storage Host Controller
 
 maintainers:
   - Ulf Hansson <ulf.hansson@linaro.org>
diff --git a/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.yaml b/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.yaml
index ae6d6fca79e2..8443b7493169 100644
--- a/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.yaml
+++ b/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mmc/synopsys-dw-mshc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Synopsys Designware Mobile Storage Host Controller Binding
+title: Synopsys Designware Mobile Storage Host Controller
 
 allOf:
   - $ref: "synopsys-dw-mshc-common.yaml#"
diff --git a/Documentation/devicetree/bindings/mtd/gpmi-nand.yaml b/Documentation/devicetree/bindings/mtd/gpmi-nand.yaml
index 849aeae319a9..8487089b6e16 100644
--- a/Documentation/devicetree/bindings/mtd/gpmi-nand.yaml
+++ b/Documentation/devicetree/bindings/mtd/gpmi-nand.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mtd/gpmi-nand.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Freescale General-Purpose Media Interface (GPMI) binding
+title: Freescale General-Purpose Media Interface (GPMI)
 
 maintainers:
   - Han Xu <han.xu@nxp.com>
diff --git a/Documentation/devicetree/bindings/mtd/microchip,mchp48l640.yaml b/Documentation/devicetree/bindings/mtd/microchip,mchp48l640.yaml
index 8cc2a7ceb5fb..70d7888d04c2 100644
--- a/Documentation/devicetree/bindings/mtd/microchip,mchp48l640.yaml
+++ b/Documentation/devicetree/bindings/mtd/microchip,mchp48l640.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/mtd/microchip,mchp48l640.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Microchip 48l640 (and similar) serial EERAM bindings
+title: Microchip 48l640 (and similar) serial EERAM
 
 maintainers:
   - Heiko Schocher <hs@denx.de>
diff --git a/Documentation/devicetree/bindings/mtd/mxc-nand.yaml b/Documentation/devicetree/bindings/mtd/mxc-nand.yaml
index 66da1b476ab7..7f6f7c9596c4 100644
--- a/Documentation/devicetree/bindings/mtd/mxc-nand.yaml
+++ b/Documentation/devicetree/bindings/mtd/mxc-nand.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mtd/mxc-nand.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Freescale's mxc_nand binding
+title: Freescale's mxc_nand
 
 maintainers:
   - Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
diff --git a/Documentation/devicetree/bindings/mtd/partitions/qcom,smem-part.yaml b/Documentation/devicetree/bindings/mtd/partitions/qcom,smem-part.yaml
index dc07909af023..94adcc1cc333 100644
--- a/Documentation/devicetree/bindings/mtd/partitions/qcom,smem-part.yaml
+++ b/Documentation/devicetree/bindings/mtd/partitions/qcom,smem-part.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mtd/partitions/qcom,smem-part.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm SMEM NAND flash partition parser binding
+title: Qualcomm SMEM NAND flash partition parser
 
 maintainers:
   - Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
diff --git a/Documentation/devicetree/bindings/mtd/st,stm32-fmc2-nand.yaml b/Documentation/devicetree/bindings/mtd/st,stm32-fmc2-nand.yaml
index eab8ea3da1fa..64301a798a63 100644
--- a/Documentation/devicetree/bindings/mtd/st,stm32-fmc2-nand.yaml
+++ b/Documentation/devicetree/bindings/mtd/st,stm32-fmc2-nand.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mtd/st,stm32-fmc2-nand.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics Flexible Memory Controller 2 (FMC2) Bindings
+title: STMicroelectronics Flexible Memory Controller 2 (FMC2)
 
 maintainers:
   - Christophe Kerello <christophe.kerello@foss.st.com>
diff --git a/Documentation/devicetree/bindings/mux/gpio-mux.yaml b/Documentation/devicetree/bindings/mux/gpio-mux.yaml
index ee4de9fbaf4d..b597c1f2c577 100644
--- a/Documentation/devicetree/bindings/mux/gpio-mux.yaml
+++ b/Documentation/devicetree/bindings/mux/gpio-mux.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mux/gpio-mux.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: GPIO-based multiplexer controller bindings
+title: GPIO-based multiplexer controller
 
 maintainers:
   - Peter Rosin <peda@axentia.se>
diff --git a/Documentation/devicetree/bindings/mux/mux-consumer.yaml b/Documentation/devicetree/bindings/mux/mux-consumer.yaml
index d3d854967359..9e2d78a78e40 100644
--- a/Documentation/devicetree/bindings/mux/mux-consumer.yaml
+++ b/Documentation/devicetree/bindings/mux/mux-consumer.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mux/mux-consumer.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Common multiplexer controller consumer bindings
+title: Common multiplexer controller consumer
 
 maintainers:
   - Peter Rosin <peda@axentia.se>
diff --git a/Documentation/devicetree/bindings/mux/mux-controller.yaml b/Documentation/devicetree/bindings/mux/mux-controller.yaml
index c855fbad3884..8b943082a241 100644
--- a/Documentation/devicetree/bindings/mux/mux-controller.yaml
+++ b/Documentation/devicetree/bindings/mux/mux-controller.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mux/mux-controller.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Common multiplexer controller provider bindings
+title: Common multiplexer controller provider
 
 maintainers:
   - Peter Rosin <peda@axentia.se>
diff --git a/Documentation/devicetree/bindings/mux/reg-mux.yaml b/Documentation/devicetree/bindings/mux/reg-mux.yaml
index dfd9ea582bb7..dc4be092fc2f 100644
--- a/Documentation/devicetree/bindings/mux/reg-mux.yaml
+++ b/Documentation/devicetree/bindings/mux/reg-mux.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mux/reg-mux.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Generic register bitfield-based multiplexer controller bindings
+title: Generic register bitfield-based multiplexer controller
 
 maintainers:
   - Peter Rosin <peda@axentia.se>
diff --git a/Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml b/Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
index e5af53508e25..c99034f053e8 100644
--- a/Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
+++ b/Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/brcm,bcmgenet.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Broadcom BCM7xxx Ethernet Controller (GENET) binding
+title: Broadcom BCM7xxx Ethernet Controller (GENET)
 
 maintainers:
   - Doug Berger <opendmb@gmail.com>
diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
index 26aa0830eea1..67879aab623b 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/can/bosch,m_can.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Bosch MCAN controller Bindings
+title: Bosch MCAN controller
 
 description: Bosch MCAN controller for CAN bus
 
diff --git a/Documentation/devicetree/bindings/net/can/can-transceiver.yaml b/Documentation/devicetree/bindings/net/can/can-transceiver.yaml
index d1ef1fe6ab29..d422b3921ffa 100644
--- a/Documentation/devicetree/bindings/net/can/can-transceiver.yaml
+++ b/Documentation/devicetree/bindings/net/can/can-transceiver.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/can/can-transceiver.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: CAN transceiver Bindings
+title: CAN transceiver
 
 description: CAN transceiver generic properties bindings
 
diff --git a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
index a6921e805e37..4116667133ce 100644
--- a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
+++ b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/engleder,tsnep.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: TSN endpoint Ethernet MAC binding
+title: TSN endpoint Ethernet MAC
 
 maintainers:
   - Gerhard Engleder <gerhard@engleder-embedded.com>
diff --git a/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml b/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
index 600240281e8c..6e0763898d3a 100644
--- a/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/fsl,qoriq-mc-dpmac.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: DPAA2 MAC bindings
+title: DPAA2 MAC
 
 maintainers:
   - Ioana Ciornei <ioana.ciornei@nxp.com>
diff --git a/Documentation/devicetree/bindings/net/mctp-i2c-controller.yaml b/Documentation/devicetree/bindings/net/mctp-i2c-controller.yaml
index afd11c9422fa..8438af53c5c3 100644
--- a/Documentation/devicetree/bindings/net/mctp-i2c-controller.yaml
+++ b/Documentation/devicetree/bindings/net/mctp-i2c-controller.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/mctp-i2c-controller.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: MCTP I2C transport binding
+title: MCTP I2C transport
 
 maintainers:
   - Matt Johnston <matt@codeconstruct.com.au>
diff --git a/Documentation/devicetree/bindings/net/wireless/ieee80211.yaml b/Documentation/devicetree/bindings/net/wireless/ieee80211.yaml
index d58e1571df9b..e68ed9423150 100644
--- a/Documentation/devicetree/bindings/net/wireless/ieee80211.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/ieee80211.yaml
@@ -6,7 +6,7 @@
 $id: http://devicetree.org/schemas/net/wireless/ieee80211.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Common IEEE 802.11 Binding
+title: Common IEEE 802.11
 
 maintainers:
   - Lorenzo Bianconi <lorenzo@kernel.org>
diff --git a/Documentation/devicetree/bindings/nvmem/ingenic,jz4780-efuse.yaml b/Documentation/devicetree/bindings/nvmem/ingenic,jz4780-efuse.yaml
index bf84768228f5..fe2cd7f1afba 100644
--- a/Documentation/devicetree/bindings/nvmem/ingenic,jz4780-efuse.yaml
+++ b/Documentation/devicetree/bindings/nvmem/ingenic,jz4780-efuse.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/nvmem/ingenic,jz4780-efuse.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Ingenic JZ EFUSE driver bindings
+title: Ingenic JZ EFUSE driver
 
 maintainers:
   - PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
diff --git a/Documentation/devicetree/bindings/nvmem/qcom,qfprom.yaml b/Documentation/devicetree/bindings/nvmem/qcom,qfprom.yaml
index 2eab2f46cb65..8e89b15b535f 100644
--- a/Documentation/devicetree/bindings/nvmem/qcom,qfprom.yaml
+++ b/Documentation/devicetree/bindings/nvmem/qcom,qfprom.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/nvmem/qcom,qfprom.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Technologies Inc, QFPROM Efuse bindings
+title: Qualcomm Technologies Inc, QFPROM Efuse
 
 maintainers:
   - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
diff --git a/Documentation/devicetree/bindings/nvmem/socionext,uniphier-efuse.yaml b/Documentation/devicetree/bindings/nvmem/socionext,uniphier-efuse.yaml
index 2578e39deda9..73a0c658dbfd 100644
--- a/Documentation/devicetree/bindings/nvmem/socionext,uniphier-efuse.yaml
+++ b/Documentation/devicetree/bindings/nvmem/socionext,uniphier-efuse.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/nvmem/socionext,uniphier-efuse.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Socionext UniPhier eFuse bindings
+title: Socionext UniPhier eFuse
 
 maintainers:
   - Keiji Hayashibara <hayashibara.keiji@socionext.com>
diff --git a/Documentation/devicetree/bindings/nvmem/st,stm32-romem.yaml b/Documentation/devicetree/bindings/nvmem/st,stm32-romem.yaml
index 16f4cad2fa55..172597cc5c63 100644
--- a/Documentation/devicetree/bindings/nvmem/st,stm32-romem.yaml
+++ b/Documentation/devicetree/bindings/nvmem/st,stm32-romem.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/nvmem/st,stm32-romem.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 Factory-programmed data bindings
+title: STMicroelectronics STM32 Factory-programmed data
 
 description: |
   This represents STM32 Factory-programmed read only non-volatile area: locked
diff --git a/Documentation/devicetree/bindings/opp/opp-v1.yaml b/Documentation/devicetree/bindings/opp/opp-v1.yaml
index d585d536a3fb..07e26c267815 100644
--- a/Documentation/devicetree/bindings/opp/opp-v1.yaml
+++ b/Documentation/devicetree/bindings/opp/opp-v1.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/opp/opp-v1.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Generic OPP (Operating Performance Points) v1 Bindings
+title: Generic OPP (Operating Performance Points) v1
 
 maintainers:
   - Viresh Kumar <viresh.kumar@linaro.org>
diff --git a/Documentation/devicetree/bindings/opp/opp-v2-kryo-cpu.yaml b/Documentation/devicetree/bindings/opp/opp-v2-kryo-cpu.yaml
index a202b6c6561d..60cf3cbde4c5 100644
--- a/Documentation/devicetree/bindings/opp/opp-v2-kryo-cpu.yaml
+++ b/Documentation/devicetree/bindings/opp/opp-v2-kryo-cpu.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/opp/opp-v2-kryo-cpu.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Technologies, Inc. NVMEM OPP bindings
+title: Qualcomm Technologies, Inc. NVMEM OPP
 
 maintainers:
   - Ilia Lin <ilia.lin@kernel.org>
diff --git a/Documentation/devicetree/bindings/opp/opp-v2.yaml b/Documentation/devicetree/bindings/opp/opp-v2.yaml
index 2f05920fce79..6972d76233aa 100644
--- a/Documentation/devicetree/bindings/opp/opp-v2.yaml
+++ b/Documentation/devicetree/bindings/opp/opp-v2.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/opp/opp-v2.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Generic OPP (Operating Performance Points) Bindings
+title: Generic OPP (Operating Performance Points)
 
 maintainers:
   - Viresh Kumar <viresh.kumar@linaro.org>
diff --git a/Documentation/devicetree/bindings/pci/qcom,pcie-ep.yaml b/Documentation/devicetree/bindings/pci/qcom,pcie-ep.yaml
index 977c976ea799..8d7eb51edcb4 100644
--- a/Documentation/devicetree/bindings/pci/qcom,pcie-ep.yaml
+++ b/Documentation/devicetree/bindings/pci/qcom,pcie-ep.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/pci/qcom,pcie-ep.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm PCIe Endpoint Controller binding
+title: Qualcomm PCIe Endpoint Controller
 
 maintainers:
   - Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
diff --git a/Documentation/devicetree/bindings/phy/fsl,imx8mq-usb-phy.yaml b/Documentation/devicetree/bindings/phy/fsl,imx8mq-usb-phy.yaml
index 5ba9570ad7bf..e6f9f5540cc3 100644
--- a/Documentation/devicetree/bindings/phy/fsl,imx8mq-usb-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/fsl,imx8mq-usb-phy.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/phy/fsl,imx8mq-usb-phy.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Freescale i.MX8MQ USB3 PHY binding
+title: Freescale i.MX8MQ USB3 PHY
 
 maintainers:
   - Li Jun <jun.li@nxp.com>
diff --git a/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml b/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
index 4d91e2f4f247..ff9f9ca0f19c 100644
--- a/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
+++ b/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/phy/fsl,lynx-28g.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Freescale Lynx 28G SerDes PHY binding
+title: Freescale Lynx 28G SerDes PHY
 
 maintainers:
   - Ioana Ciornei <ioana.ciornei@nxp.com>
diff --git a/Documentation/devicetree/bindings/phy/intel,keembay-phy-usb.yaml b/Documentation/devicetree/bindings/phy/intel,keembay-phy-usb.yaml
index 52815b6c2b88..5cee4c85ff8b 100644
--- a/Documentation/devicetree/bindings/phy/intel,keembay-phy-usb.yaml
+++ b/Documentation/devicetree/bindings/phy/intel,keembay-phy-usb.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/phy/intel,keembay-phy-usb.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Intel Keem Bay USB PHY bindings
+title: Intel Keem Bay USB PHY
 
 maintainers:
   - Wan Ahmad Zainie <wan.ahmad.zainie.wan.mohamad@intel.com>
diff --git a/Documentation/devicetree/bindings/phy/intel,phy-thunderbay-emmc.yaml b/Documentation/devicetree/bindings/phy/intel,phy-thunderbay-emmc.yaml
index b09e5ba5e127..361ffc35b16b 100644
--- a/Documentation/devicetree/bindings/phy/intel,phy-thunderbay-emmc.yaml
+++ b/Documentation/devicetree/bindings/phy/intel,phy-thunderbay-emmc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/phy/intel,phy-thunderbay-emmc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Intel Thunder Bay eMMC PHY bindings
+title: Intel Thunder Bay eMMC PHY
 
 maintainers:
   - Srikandan Nandhini <nandhini.srikandan@intel.com>
diff --git a/Documentation/devicetree/bindings/phy/marvell,mmp3-usb-phy.yaml b/Documentation/devicetree/bindings/phy/marvell,mmp3-usb-phy.yaml
index c97043eaa8fb..be13113f7b47 100644
--- a/Documentation/devicetree/bindings/phy/marvell,mmp3-usb-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/marvell,mmp3-usb-phy.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/phy/marvell,mmp3-usb-phy.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Marvell MMP3 USB PHY bindings
+title: Marvell MMP3 USB PHY
 
 maintainers:
   - Lubomir Rintel <lkundrak@v3.sk>
diff --git a/Documentation/devicetree/bindings/phy/mediatek,dsi-phy.yaml b/Documentation/devicetree/bindings/phy/mediatek,dsi-phy.yaml
index 9c2a7345955d..26f2b887cfc1 100644
--- a/Documentation/devicetree/bindings/phy/mediatek,dsi-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/mediatek,dsi-phy.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/phy/mediatek,dsi-phy.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: MediaTek MIPI Display Serial Interface (DSI) PHY binding
+title: MediaTek MIPI Display Serial Interface (DSI) PHY
 
 maintainers:
   - Chun-Kuang Hu <chunkuang.hu@kernel.org>
diff --git a/Documentation/devicetree/bindings/phy/mediatek,hdmi-phy.yaml b/Documentation/devicetree/bindings/phy/mediatek,hdmi-phy.yaml
index 0d94950b84ca..6cfdaadec085 100644
--- a/Documentation/devicetree/bindings/phy/mediatek,hdmi-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/mediatek,hdmi-phy.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/phy/mediatek,hdmi-phy.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: MediaTek High Definition Multimedia Interface (HDMI) PHY binding
+title: MediaTek High Definition Multimedia Interface (HDMI) PHY
 
 maintainers:
   - Chun-Kuang Hu <chunkuang.hu@kernel.org>
diff --git a/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml b/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
index 74cc32c1d2e8..3e62b5d4da61 100644
--- a/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/phy/mediatek,ufs-phy.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: MediaTek Universal Flash Storage (UFS) M-PHY binding
+title: MediaTek Universal Flash Storage (UFS) M-PHY
 
 maintainers:
   - Stanley Chu <stanley.chu@mediatek.com>
diff --git a/Documentation/devicetree/bindings/phy/phy-cadence-sierra.yaml b/Documentation/devicetree/bindings/phy/phy-cadence-sierra.yaml
index a9e227d8b076..6a09472740ed 100644
--- a/Documentation/devicetree/bindings/phy/phy-cadence-sierra.yaml
+++ b/Documentation/devicetree/bindings/phy/phy-cadence-sierra.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/phy/phy-cadence-sierra.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Cadence Sierra PHY binding
+title: Cadence Sierra PHY
 
 description:
   This binding describes the Cadence Sierra PHY. Sierra PHY supports multilink
diff --git a/Documentation/devicetree/bindings/phy/phy-cadence-torrent.yaml b/Documentation/devicetree/bindings/phy/phy-cadence-torrent.yaml
index 2fec9e54ad0e..2ad1faadda2a 100644
--- a/Documentation/devicetree/bindings/phy/phy-cadence-torrent.yaml
+++ b/Documentation/devicetree/bindings/phy/phy-cadence-torrent.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/phy/phy-cadence-torrent.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Cadence Torrent SD0801 PHY binding
+title: Cadence Torrent SD0801 PHY
 
 description:
   This binding describes the Cadence SD0801 PHY (also known as Torrent PHY)
diff --git a/Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml b/Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml
index 801993813b18..5b4c915cc9e5 100644
--- a/Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml
+++ b/Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/phy/phy-stm32-usbphyc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 USB HS PHY controller binding
+title: STMicroelectronics STM32 USB HS PHY controller
 
 description:
 
diff --git a/Documentation/devicetree/bindings/phy/phy-tegra194-p2u.yaml b/Documentation/devicetree/bindings/phy/phy-tegra194-p2u.yaml
index 4dc5205d893b..445b2467f4f6 100644
--- a/Documentation/devicetree/bindings/phy/phy-tegra194-p2u.yaml
+++ b/Documentation/devicetree/bindings/phy/phy-tegra194-p2u.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/phy/phy-tegra194-p2u.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: NVIDIA Tegra194 & Tegra234 P2U binding
+title: NVIDIA Tegra194 & Tegra234 P2U
 
 maintainers:
   - Thierry Reding <treding@nvidia.com>
diff --git a/Documentation/devicetree/bindings/phy/ti,phy-am654-serdes.yaml b/Documentation/devicetree/bindings/phy/ti,phy-am654-serdes.yaml
index 62dcb84c08aa..738c92bb7518 100644
--- a/Documentation/devicetree/bindings/phy/ti,phy-am654-serdes.yaml
+++ b/Documentation/devicetree/bindings/phy/ti,phy-am654-serdes.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/phy/ti,phy-am654-serdes.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: TI AM654 SERDES binding
+title: TI AM654 SERDES
 
 description:
   This binding describes the TI AM654 SERDES. AM654 SERDES can be configured
diff --git a/Documentation/devicetree/bindings/phy/transmit-amplitude.yaml b/Documentation/devicetree/bindings/phy/transmit-amplitude.yaml
index 51492fe738ec..617f3c0b3dfb 100644
--- a/Documentation/devicetree/bindings/phy/transmit-amplitude.yaml
+++ b/Documentation/devicetree/bindings/phy/transmit-amplitude.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/phy/transmit-amplitude.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Common PHY and network PCS transmit amplitude property binding
+title: Common PHY and network PCS transmit amplitude property
 
 description:
   Binding describing the peak-to-peak transmit amplitude for common PHYs
diff --git a/Documentation/devicetree/bindings/pinctrl/intel,lgm-io.yaml b/Documentation/devicetree/bindings/pinctrl/intel,lgm-io.yaml
index b42548350188..ca0fef6e535e 100644
--- a/Documentation/devicetree/bindings/pinctrl/intel,lgm-io.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/intel,lgm-io.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/pinctrl/intel,lgm-io.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Intel Lightning Mountain SoC pinmux & GPIO controller binding
+title: Intel Lightning Mountain SoC pinmux & GPIO controller
 
 maintainers:
   - Rahul Tanwar <rahul.tanwar@linux.intel.com>
diff --git a/Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml b/Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml
index 301db7daf870..2fd2178d1fa5 100644
--- a/Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml
+++ b/Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/power/avs/qcom,cpr.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Core Power Reduction (CPR) bindings
+title: Qualcomm Core Power Reduction (CPR)
 
 maintainers:
   - Niklas Cassel <nks@flawful.org>
diff --git a/Documentation/devicetree/bindings/power/supply/dlg,da9150-charger.yaml b/Documentation/devicetree/bindings/power/supply/dlg,da9150-charger.yaml
index b289388952bf..85bebebb285b 100644
--- a/Documentation/devicetree/bindings/power/supply/dlg,da9150-charger.yaml
+++ b/Documentation/devicetree/bindings/power/supply/dlg,da9150-charger.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/power/supply/dlg,da9150-charger.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Dialog Semiconductor DA9150 Charger Power Supply bindings
+title: Dialog Semiconductor DA9150 Charger Power Supply
 
 maintainers:
   - Sebastian Reichel <sre@kernel.org>
diff --git a/Documentation/devicetree/bindings/power/supply/dlg,da9150-fuel-gauge.yaml b/Documentation/devicetree/bindings/power/supply/dlg,da9150-fuel-gauge.yaml
index d47caf59d204..7cc94b872937 100644
--- a/Documentation/devicetree/bindings/power/supply/dlg,da9150-fuel-gauge.yaml
+++ b/Documentation/devicetree/bindings/power/supply/dlg,da9150-fuel-gauge.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/power/supply/dlg,da9150-fuel-gauge.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Dialog Semiconductor DA9150 Fuel-Gauge Power Supply bindings
+title: Dialog Semiconductor DA9150 Fuel-Gauge Power Supply
 
 maintainers:
   - Sebastian Reichel <sre@kernel.org>
diff --git a/Documentation/devicetree/bindings/power/supply/ingenic,battery.yaml b/Documentation/devicetree/bindings/power/supply/ingenic,battery.yaml
index 42fcfc026972..741022b4449d 100644
--- a/Documentation/devicetree/bindings/power/supply/ingenic,battery.yaml
+++ b/Documentation/devicetree/bindings/power/supply/ingenic,battery.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/power/supply/ingenic,battery.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Ingenic JZ47xx battery bindings
+title: Ingenic JZ47xx battery
 
 maintainers:
   - Artur Rojek <contact@artur-rojek.eu>
diff --git a/Documentation/devicetree/bindings/power/supply/lltc,lt3651-charger.yaml b/Documentation/devicetree/bindings/power/supply/lltc,lt3651-charger.yaml
index 76cedf95a12c..d26ed5eabe28 100644
--- a/Documentation/devicetree/bindings/power/supply/lltc,lt3651-charger.yaml
+++ b/Documentation/devicetree/bindings/power/supply/lltc,lt3651-charger.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/power/supply/lltc,lt3651-charger.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Analog Devices LT3651 Charger Power Supply bindings
+title: Analog Devices LT3651 Charger Power Supply
 
 maintainers:
   - Sebastian Reichel <sre@kernel.org>
diff --git a/Documentation/devicetree/bindings/power/supply/sc2731-charger.yaml b/Documentation/devicetree/bindings/power/supply/sc2731-charger.yaml
index 735f7d372ae1..a846a4d14ca9 100644
--- a/Documentation/devicetree/bindings/power/supply/sc2731-charger.yaml
+++ b/Documentation/devicetree/bindings/power/supply/sc2731-charger.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/power/supply/sc2731-charger.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Spreadtrum SC2731 PMICs battery charger binding
+title: Spreadtrum SC2731 PMICs battery charger
 
 maintainers:
   - Sebastian Reichel <sre@kernel.org>
diff --git a/Documentation/devicetree/bindings/power/supply/sc27xx-fg.yaml b/Documentation/devicetree/bindings/power/supply/sc27xx-fg.yaml
index d90a838a1744..de43e45a43b7 100644
--- a/Documentation/devicetree/bindings/power/supply/sc27xx-fg.yaml
+++ b/Documentation/devicetree/bindings/power/supply/sc27xx-fg.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/power/supply/sc27xx-fg.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Spreadtrum SC27XX PMICs Fuel Gauge Unit Power Supply Bindings
+title: Spreadtrum SC27XX PMICs Fuel Gauge Unit Power Supply
 
 maintainers:
   - Sebastian Reichel <sre@kernel.org>
diff --git a/Documentation/devicetree/bindings/pwm/microchip,corepwm.yaml b/Documentation/devicetree/bindings/pwm/microchip,corepwm.yaml
index cd8e9a8907f8..70d563d44c35 100644
--- a/Documentation/devicetree/bindings/pwm/microchip,corepwm.yaml
+++ b/Documentation/devicetree/bindings/pwm/microchip,corepwm.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/pwm/microchip,corepwm.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Microchip IP corePWM controller bindings
+title: Microchip IP corePWM controller
 
 maintainers:
   - Conor Dooley <conor.dooley@microchip.com>
diff --git a/Documentation/devicetree/bindings/regulator/st,stm32-booster.yaml b/Documentation/devicetree/bindings/regulator/st,stm32-booster.yaml
index 38bdaef4fa39..c82f6f885d97 100644
--- a/Documentation/devicetree/bindings/regulator/st,stm32-booster.yaml
+++ b/Documentation/devicetree/bindings/regulator/st,stm32-booster.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/regulator/st,stm32-booster.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 booster for ADC analog input switches bindings
+title: STMicroelectronics STM32 booster for ADC analog input switches
 
 maintainers:
   - Fabrice Gasnier <fabrice.gasnier@foss.st.com>
diff --git a/Documentation/devicetree/bindings/regulator/st,stm32-vrefbuf.yaml b/Documentation/devicetree/bindings/regulator/st,stm32-vrefbuf.yaml
index a5a27ee0a9e6..c1bf1f90490a 100644
--- a/Documentation/devicetree/bindings/regulator/st,stm32-vrefbuf.yaml
+++ b/Documentation/devicetree/bindings/regulator/st,stm32-vrefbuf.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/regulator/st,stm32-vrefbuf.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 Voltage reference buffer bindings
+title: STMicroelectronics STM32 Voltage reference buffer
 
 description: |
   Some STM32 devices embed a voltage reference buffer which can be used as
diff --git a/Documentation/devicetree/bindings/remoteproc/amlogic,meson-mx-ao-arc.yaml b/Documentation/devicetree/bindings/remoteproc/amlogic,meson-mx-ao-arc.yaml
index d892d29a656b..11cb42a3fdd1 100644
--- a/Documentation/devicetree/bindings/remoteproc/amlogic,meson-mx-ao-arc.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/amlogic,meson-mx-ao-arc.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/remoteproc/amlogic,meson-mx-ao-arc.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Amlogic Meson AO ARC Remote Processor bindings
+title: Amlogic Meson AO ARC Remote Processor
 
 description:
   Amlogic Meson6, Meson8, Meson8b and Meson8m2 SoCs embed an ARC core
diff --git a/Documentation/devicetree/bindings/remoteproc/fsl,imx-rproc.yaml b/Documentation/devicetree/bindings/remoteproc/fsl,imx-rproc.yaml
index ad3b8d4ccd91..ae2eab4452dd 100644
--- a/Documentation/devicetree/bindings/remoteproc/fsl,imx-rproc.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/fsl,imx-rproc.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/remoteproc/fsl,imx-rproc.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: NXP i.MX Co-Processor Bindings
+title: NXP i.MX Co-Processor
 
 description:
   This binding provides support for ARM Cortex M4 Co-processor found on some NXP iMX SoCs.
diff --git a/Documentation/devicetree/bindings/remoteproc/ingenic,vpu.yaml b/Documentation/devicetree/bindings/remoteproc/ingenic,vpu.yaml
index aaaaabad46ea..85b1e43cab08 100644
--- a/Documentation/devicetree/bindings/remoteproc/ingenic,vpu.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/ingenic,vpu.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/remoteproc/ingenic,vpu.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Ingenic Video Processing Unit bindings
+title: Ingenic Video Processing Unit
 
 description:
   Inside the Video Processing Unit (VPU) of the recent JZ47xx SoCs from
diff --git a/Documentation/devicetree/bindings/remoteproc/mtk,scp.yaml b/Documentation/devicetree/bindings/remoteproc/mtk,scp.yaml
index 7e091eaffc18..895415772d1d 100644
--- a/Documentation/devicetree/bindings/remoteproc/mtk,scp.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/mtk,scp.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/remoteproc/mtk,scp.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Mediatek SCP Bindings
+title: Mediatek SCP
 
 maintainers:
   - Tinghan Shen <tinghan.shen@mediatek.com>
diff --git a/Documentation/devicetree/bindings/remoteproc/qcom,adsp.yaml b/Documentation/devicetree/bindings/remoteproc/qcom,adsp.yaml
index db9e0f0c2bea..c1d9cbc359b4 100644
--- a/Documentation/devicetree/bindings/remoteproc/qcom,adsp.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/qcom,adsp.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/remoteproc/qcom,adsp.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm ADSP Peripheral Image Loader binding
+title: Qualcomm ADSP Peripheral Image Loader
 
 maintainers:
   - Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
diff --git a/Documentation/devicetree/bindings/remoteproc/qcom,pil-info.yaml b/Documentation/devicetree/bindings/remoteproc/qcom,pil-info.yaml
index a7711e3c998c..22219d16df20 100644
--- a/Documentation/devicetree/bindings/remoteproc/qcom,pil-info.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/qcom,pil-info.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/remoteproc/qcom,pil-info.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm peripheral image loader relocation info binding
+title: Qualcomm peripheral image loader relocation info
 
 maintainers:
   - Bjorn Andersson <bjorn.andersson@linaro.org>
diff --git a/Documentation/devicetree/bindings/remoteproc/renesas,rcar-rproc.yaml b/Documentation/devicetree/bindings/remoteproc/renesas,rcar-rproc.yaml
index a7d25fa920e5..7e0275d31a3c 100644
--- a/Documentation/devicetree/bindings/remoteproc/renesas,rcar-rproc.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/renesas,rcar-rproc.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/remoteproc/renesas,rcar-rproc.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Renesas R-Car remote processor controller bindings
+title: Renesas R-Car remote processor controller
 
 maintainers:
   - Julien Massot <julien.massot@iot.bzh>
diff --git a/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml b/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
index da50f0e99fe2..66b1e3efdaa3 100644
--- a/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/remoteproc/st,stm32-rproc.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: STMicroelectronics STM32 remote processor controller bindings
+title: STMicroelectronics STM32 remote processor controller
 
 description:
   This document defines the binding for the remoteproc component that loads and
diff --git a/Documentation/devicetree/bindings/rng/intel,ixp46x-rng.yaml b/Documentation/devicetree/bindings/rng/intel,ixp46x-rng.yaml
index 067e71e8ebe8..9f7590ce6b3d 100644
--- a/Documentation/devicetree/bindings/rng/intel,ixp46x-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/intel,ixp46x-rng.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/rng/intel,ixp46x-rng.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Intel IXP46x RNG bindings
+title: Intel IXP46x RNG
 
 description: |
   The Intel IXP46x has a random number generator at a fixed physical
diff --git a/Documentation/devicetree/bindings/rng/silex-insight,ba431-rng.yaml b/Documentation/devicetree/bindings/rng/silex-insight,ba431-rng.yaml
index 48ab82abf50e..4673d6160ad9 100644
--- a/Documentation/devicetree/bindings/rng/silex-insight,ba431-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/silex-insight,ba431-rng.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/rng/silex-insight,ba431-rng.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Silex Insight BA431 RNG bindings
+title: Silex Insight BA431 RNG
 
 description: |
   The BA431 hardware random number generator is an IP that is FIPS-140-2/3
diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
index fcd86f822a9c..187b172d0cca 100644
--- a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/rng/st,stm32-rng.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 RNG bindings
+title: STMicroelectronics STM32 RNG
 
 description: |
   The STM32 hardware random number generator is a simple fixed purpose
diff --git a/Documentation/devicetree/bindings/rng/xiphera,xip8001b-trng.yaml b/Documentation/devicetree/bindings/rng/xiphera,xip8001b-trng.yaml
index 1e17e55762f1..d83132291170 100644
--- a/Documentation/devicetree/bindings/rng/xiphera,xip8001b-trng.yaml
+++ b/Documentation/devicetree/bindings/rng/xiphera,xip8001b-trng.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/rng/xiphera,xip8001b-trng.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Xiphera XIP8001B-trng bindings
+title: Xiphera XIP8001B-trng
 
 maintainers:
   - Atte Tommiska <atte.tommiska@xiphera.com>
diff --git a/Documentation/devicetree/bindings/rtc/sa1100-rtc.yaml b/Documentation/devicetree/bindings/rtc/sa1100-rtc.yaml
index 482e5af215b3..b04b87ef6f33 100644
--- a/Documentation/devicetree/bindings/rtc/sa1100-rtc.yaml
+++ b/Documentation/devicetree/bindings/rtc/sa1100-rtc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/rtc/sa1100-rtc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Marvell Real Time Clock controller bindings
+title: Marvell Real Time Clock controller
 
 allOf:
   - $ref: rtc.yaml#
diff --git a/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml b/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml
index 764717ce1873..9e66ed33cda4 100644
--- a/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml
+++ b/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/rtc/st,stm32-rtc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 Real Time Clock Bindings
+title: STMicroelectronics STM32 Real Time Clock
 
 maintainers:
   - Gabriel Fernandez <gabriel.fernandez@foss.st.com>
diff --git a/Documentation/devicetree/bindings/serial/8250.yaml b/Documentation/devicetree/bindings/serial/8250.yaml
index 6258f5f59b19..34b8e59aa9d4 100644
--- a/Documentation/devicetree/bindings/serial/8250.yaml
+++ b/Documentation/devicetree/bindings/serial/8250.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/serial/8250.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: UART (Universal Asynchronous Receiver/Transmitter) bindings
+title: UART (Universal Asynchronous Receiver/Transmitter)
 
 maintainers:
   - devicetree@vger.kernel.org
diff --git a/Documentation/devicetree/bindings/serial/rs485.yaml b/Documentation/devicetree/bindings/serial/rs485.yaml
index 90a1bab40f05..789763cf427a 100644
--- a/Documentation/devicetree/bindings/serial/rs485.yaml
+++ b/Documentation/devicetree/bindings/serial/rs485.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/serial/rs485.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: RS485 serial communications Bindings
+title: RS485 serial communications
 
 description: The RTS signal is capable of automatically controlling line
   direction for the built-in half-duplex mode. The properties described
diff --git a/Documentation/devicetree/bindings/serial/st,stm32-uart.yaml b/Documentation/devicetree/bindings/serial/st,stm32-uart.yaml
index 333dc42722d2..85876c668f6d 100644
--- a/Documentation/devicetree/bindings/serial/st,stm32-uart.yaml
+++ b/Documentation/devicetree/bindings/serial/st,stm32-uart.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 maintainers:
   - Erwan Le Ray <erwan.leray@foss.st.com>
 
-title: STMicroelectronics STM32 USART bindings
+title: STMicroelectronics STM32 USART
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,aoss-qmp.yaml b/Documentation/devicetree/bindings/soc/qcom/qcom,aoss-qmp.yaml
index da232f8d20d2..b666bd5c992a 100644
--- a/Documentation/devicetree/bindings/soc/qcom/qcom,aoss-qmp.yaml
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,aoss-qmp.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/soc/qcom/qcom,aoss-qmp.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Always-On Subsystem side channel binding
+title: Qualcomm Always-On Subsystem side channel
 
 maintainers:
   - Bjorn Andersson <bjorn.andersson@linaro.org>
diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,apr.yaml b/Documentation/devicetree/bindings/soc/qcom/qcom,apr.yaml
index f47491aab3b1..669bcb5b39ea 100644
--- a/Documentation/devicetree/bindings/soc/qcom/qcom,apr.yaml
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,apr.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/soc/qcom/qcom,apr.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Qualcomm APR/GPR (Asynchronous/Generic Packet Router) binding
+title: Qualcomm APR/GPR (Asynchronous/Generic Packet Router)
 
 maintainers:
   - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,smem.yaml b/Documentation/devicetree/bindings/soc/qcom/qcom,smem.yaml
index 4149cf2b66be..497614ddf005 100644
--- a/Documentation/devicetree/bindings/soc/qcom/qcom,smem.yaml
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,smem.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/soc/qcom/qcom,smem.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Qualcomm Shared Memory Manager binding
+title: Qualcomm Shared Memory Manager
 
 maintainers:
   - Andy Gross <agross@kernel.org>
diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,spm.yaml b/Documentation/devicetree/bindings/soc/qcom/qcom,spm.yaml
index 38818c37c3ea..aca3d40bcccb 100644
--- a/Documentation/devicetree/bindings/soc/qcom/qcom,spm.yaml
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,spm.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/soc/qcom/qcom,spm.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Qualcomm Subsystem Power Manager binding
+title: Qualcomm Subsystem Power Manager
 
 maintainers:
   - Andy Gross <agross@kernel.org>
diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom-stats.yaml b/Documentation/devicetree/bindings/soc/qcom/qcom-stats.yaml
index 48eda4d0d391..7ab8cfff18c1 100644
--- a/Documentation/devicetree/bindings/soc/qcom/qcom-stats.yaml
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom-stats.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/soc/qcom/qcom-stats.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Technologies, Inc. (QTI) Stats bindings
+title: Qualcomm Technologies, Inc. (QTI) Stats
 
 maintainers:
   - Maulik Shah <mkshah@codeaurora.org>
diff --git a/Documentation/devicetree/bindings/soc/samsung/exynos-usi.yaml b/Documentation/devicetree/bindings/soc/samsung/exynos-usi.yaml
index 60b49562ff69..a6836904a4f8 100644
--- a/Documentation/devicetree/bindings/soc/samsung/exynos-usi.yaml
+++ b/Documentation/devicetree/bindings/soc/samsung/exynos-usi.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/soc/samsung/exynos-usi.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Samsung's Exynos USI (Universal Serial Interface) binding
+title: Samsung's Exynos USI (Universal Serial Interface)
 
 maintainers:
   - Sam Protsenko <semen.protsenko@linaro.org>
diff --git a/Documentation/devicetree/bindings/sound/marvell,mmp-sspa.yaml b/Documentation/devicetree/bindings/sound/marvell,mmp-sspa.yaml
index 81f266d66ec5..7d7c297138b5 100644
--- a/Documentation/devicetree/bindings/sound/marvell,mmp-sspa.yaml
+++ b/Documentation/devicetree/bindings/sound/marvell,mmp-sspa.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/sound/marvell,mmp-sspa.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Marvel SSPA Digital Audio Interface Bindings
+title: Marvel SSPA Digital Audio Interface
 
 maintainers:
   - Lubomir Rintel <lkundrak@v3.sk>
diff --git a/Documentation/devicetree/bindings/sound/qcom,lpass-cpu.yaml b/Documentation/devicetree/bindings/sound/qcom,lpass-cpu.yaml
index ef18a572a1ff..c87d9f81a261 100644
--- a/Documentation/devicetree/bindings/sound/qcom,lpass-cpu.yaml
+++ b/Documentation/devicetree/bindings/sound/qcom,lpass-cpu.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/sound/qcom,lpass-cpu.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Technologies Inc. LPASS CPU dai driver bindings
+title: Qualcomm Technologies Inc. LPASS CPU dai driver
 
 maintainers:
   - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
diff --git a/Documentation/devicetree/bindings/sound/qcom,q6apm-dai.yaml b/Documentation/devicetree/bindings/sound/qcom,q6apm-dai.yaml
index 24f7bf2bfd95..f8ad1b76cc62 100644
--- a/Documentation/devicetree/bindings/sound/qcom,q6apm-dai.yaml
+++ b/Documentation/devicetree/bindings/sound/qcom,q6apm-dai.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/sound/qcom,q6apm-dai.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Qualcomm Audio Process Manager Digital Audio Interfaces binding
+title: Qualcomm Audio Process Manager Digital Audio Interfaces
 
 maintainers:
   - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
diff --git a/Documentation/devicetree/bindings/sound/qcom,q6dsp-lpass-clocks.yaml b/Documentation/devicetree/bindings/sound/qcom,q6dsp-lpass-clocks.yaml
index fd567d20417d..1cb7c48c6d36 100644
--- a/Documentation/devicetree/bindings/sound/qcom,q6dsp-lpass-clocks.yaml
+++ b/Documentation/devicetree/bindings/sound/qcom,q6dsp-lpass-clocks.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/sound/qcom,q6dsp-lpass-clocks.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Qualcomm DSP LPASS Clock Controller binding
+title: Qualcomm DSP LPASS Clock Controller
 
 maintainers:
   - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
diff --git a/Documentation/devicetree/bindings/sound/qcom,q6dsp-lpass-ports.yaml b/Documentation/devicetree/bindings/sound/qcom,q6dsp-lpass-ports.yaml
index e53fc0960a14..b99442c41365 100644
--- a/Documentation/devicetree/bindings/sound/qcom,q6dsp-lpass-ports.yaml
+++ b/Documentation/devicetree/bindings/sound/qcom,q6dsp-lpass-ports.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/sound/qcom,q6dsp-lpass-ports.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Qualcomm DSP LPASS(Low Power Audio SubSystem) Audio Ports binding
+title: Qualcomm DSP LPASS(Low Power Audio SubSystem) Audio Ports
 
 maintainers:
   - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
diff --git a/Documentation/devicetree/bindings/spi/aspeed,ast2600-fmc.yaml b/Documentation/devicetree/bindings/spi/aspeed,ast2600-fmc.yaml
index fa8f4ac20985..e6c817de3449 100644
--- a/Documentation/devicetree/bindings/spi/aspeed,ast2600-fmc.yaml
+++ b/Documentation/devicetree/bindings/spi/aspeed,ast2600-fmc.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/spi/aspeed,ast2600-fmc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Aspeed SMC controllers bindings
+title: Aspeed SMC controllers
 
 maintainers:
   - Chin-Ting Kuo <chin-ting_kuo@aspeedtech.com>
diff --git a/Documentation/devicetree/bindings/spi/marvell,mmp2-ssp.yaml b/Documentation/devicetree/bindings/spi/marvell,mmp2-ssp.yaml
index 0abcac385e7c..5f4f6b5615d0 100644
--- a/Documentation/devicetree/bindings/spi/marvell,mmp2-ssp.yaml
+++ b/Documentation/devicetree/bindings/spi/marvell,mmp2-ssp.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/spi/marvell,mmp2-ssp.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: PXA2xx SSP SPI Controller bindings
+title: PXA2xx SSP SPI Controller
 
 maintainers:
   - Lubomir Rintel <lkundrak@v3.sk>
diff --git a/Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml b/Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml
index 6ec6f556182f..1eb17f7a4d86 100644
--- a/Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml
+++ b/Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/spi/st,stm32-qspi.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 Quad Serial Peripheral Interface (QSPI) bindings
+title: STMicroelectronics STM32 Quad Serial Peripheral Interface (QSPI)
 
 maintainers:
   - Christophe Kerello <christophe.kerello@foss.st.com>
diff --git a/Documentation/devicetree/bindings/spi/st,stm32-spi.yaml b/Documentation/devicetree/bindings/spi/st,stm32-spi.yaml
index 3d64bed266ac..1cda15f91cc3 100644
--- a/Documentation/devicetree/bindings/spi/st,stm32-spi.yaml
+++ b/Documentation/devicetree/bindings/spi/st,stm32-spi.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/spi/st,stm32-spi.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 SPI Controller bindings
+title: STMicroelectronics STM32 SPI Controller
 
 description: |
   The STM32 SPI controller is used to communicate with external devices using
diff --git a/Documentation/devicetree/bindings/thermal/imx-thermal.yaml b/Documentation/devicetree/bindings/thermal/imx-thermal.yaml
index 16b57f57d103..b22c8b59d5c7 100644
--- a/Documentation/devicetree/bindings/thermal/imx-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/imx-thermal.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/thermal/imx-thermal.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: NXP i.MX Thermal Binding
+title: NXP i.MX Thermal
 
 maintainers:
   - Shawn Guo <shawnguo@kernel.org>
diff --git a/Documentation/devicetree/bindings/thermal/imx8mm-thermal.yaml b/Documentation/devicetree/bindings/thermal/imx8mm-thermal.yaml
index 89c54e08ee61..4ed90d61749f 100644
--- a/Documentation/devicetree/bindings/thermal/imx8mm-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/imx8mm-thermal.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/thermal/imx8mm-thermal.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: NXP i.MX8M Mini Thermal Binding
+title: NXP i.MX8M Mini Thermal
 
 maintainers:
   - Anson Huang <Anson.Huang@nxp.com>
diff --git a/Documentation/devicetree/bindings/thermal/sprd-thermal.yaml b/Documentation/devicetree/bindings/thermal/sprd-thermal.yaml
index 6d65a3cf2af2..76aaa004c8ac 100644
--- a/Documentation/devicetree/bindings/thermal/sprd-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/sprd-thermal.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/thermal/sprd-thermal.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Spreadtrum thermal sensor controller bindings
+title: Spreadtrum thermal sensor controller
 
 maintainers:
   - Orson Zhai <orsonzhai@gmail.com>
diff --git a/Documentation/devicetree/bindings/thermal/st,stm32-thermal.yaml b/Documentation/devicetree/bindings/thermal/st,stm32-thermal.yaml
index bee41cff5142..ab043084f667 100644
--- a/Documentation/devicetree/bindings/thermal/st,stm32-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/st,stm32-thermal.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/thermal/st,stm32-thermal.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 digital thermal sensor (DTS) binding
+title: STMicroelectronics STM32 digital thermal sensor (DTS)
 
 maintainers:
   - Pascal Paillet <p.paillet@foss.st.com>
diff --git a/Documentation/devicetree/bindings/thermal/thermal-cooling-devices.yaml b/Documentation/devicetree/bindings/thermal/thermal-cooling-devices.yaml
index 850a9841b110..7f16968afca2 100644
--- a/Documentation/devicetree/bindings/thermal/thermal-cooling-devices.yaml
+++ b/Documentation/devicetree/bindings/thermal/thermal-cooling-devices.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/thermal/thermal-cooling-devices.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Thermal cooling device binding
+title: Thermal cooling device
 
 maintainers:
   - Amit Kucheria <amitk@kernel.org>
diff --git a/Documentation/devicetree/bindings/thermal/thermal-idle.yaml b/Documentation/devicetree/bindings/thermal/thermal-idle.yaml
index cc938d7ad1f3..4cf547eca7da 100644
--- a/Documentation/devicetree/bindings/thermal/thermal-idle.yaml
+++ b/Documentation/devicetree/bindings/thermal/thermal-idle.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/thermal/thermal-idle.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Thermal idle cooling device binding
+title: Thermal idle cooling device
 
 maintainers:
   - Daniel Lezcano <daniel.lezcano@linaro.org>
diff --git a/Documentation/devicetree/bindings/thermal/thermal-sensor.yaml b/Documentation/devicetree/bindings/thermal/thermal-sensor.yaml
index 4bd345c71eb8..57565b3fb07c 100644
--- a/Documentation/devicetree/bindings/thermal/thermal-sensor.yaml
+++ b/Documentation/devicetree/bindings/thermal/thermal-sensor.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/thermal/thermal-sensor.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Thermal sensor binding
+title: Thermal sensor
 
 maintainers:
   - Amit Kucheria <amitk@kernel.org>
diff --git a/Documentation/devicetree/bindings/thermal/thermal-zones.yaml b/Documentation/devicetree/bindings/thermal/thermal-zones.yaml
index 8d2c6d74b605..8581821fa4e1 100644
--- a/Documentation/devicetree/bindings/thermal/thermal-zones.yaml
+++ b/Documentation/devicetree/bindings/thermal/thermal-zones.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/thermal/thermal-zones.yaml#
 $schema: http://devicetree.org/meta-schemas/base.yaml#
 
-title: Thermal zone binding
+title: Thermal zone
 
 maintainers:
   - Amit Kucheria <amitk@kernel.org>
diff --git a/Documentation/devicetree/bindings/thermal/ti,am654-thermal.yaml b/Documentation/devicetree/bindings/thermal/ti,am654-thermal.yaml
index ea14de80ec75..7ed0abe9290f 100644
--- a/Documentation/devicetree/bindings/thermal/ti,am654-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/ti,am654-thermal.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/thermal/ti,am654-thermal.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Texas Instruments AM654 VTM (DTS) binding
+title: Texas Instruments AM654 VTM (DTS)
 
 maintainers:
   - Keerthy <j-keerthy@ti.com>
diff --git a/Documentation/devicetree/bindings/thermal/ti,j72xx-thermal.yaml b/Documentation/devicetree/bindings/thermal/ti,j72xx-thermal.yaml
index c74f124ebfc0..04886744b289 100644
--- a/Documentation/devicetree/bindings/thermal/ti,j72xx-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/ti,j72xx-thermal.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/thermal/ti,j72xx-thermal.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Texas Instruments J72XX VTM (DTS) binding
+title: Texas Instruments J72XX VTM (DTS)
 
 maintainers:
   - Keerthy <j-keerthy@ti.com>
diff --git a/Documentation/devicetree/bindings/timer/mrvl,mmp-timer.yaml b/Documentation/devicetree/bindings/timer/mrvl,mmp-timer.yaml
index 1fbc260a0cbd..1ee4aab695d3 100644
--- a/Documentation/devicetree/bindings/timer/mrvl,mmp-timer.yaml
+++ b/Documentation/devicetree/bindings/timer/mrvl,mmp-timer.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/timer/mrvl,mmp-timer.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Marvell MMP Timer bindings
+title: Marvell MMP Timer
 
 maintainers:
   - Daniel Lezcano <daniel.lezcano@linaro.org>
diff --git a/Documentation/devicetree/bindings/timer/st,stm32-timer.yaml b/Documentation/devicetree/bindings/timer/st,stm32-timer.yaml
index 937aa8a56366..9ec11537620a 100644
--- a/Documentation/devicetree/bindings/timer/st,stm32-timer.yaml
+++ b/Documentation/devicetree/bindings/timer/st,stm32-timer.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/timer/st,stm32-timer.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 general-purpose 16 and 32 bits timers bindings
+title: STMicroelectronics STM32 general-purpose 16 and 32 bits timers
 
 maintainers:
   - Fabrice Gasnier <fabrice.gasnier@foss.st.com>
diff --git a/Documentation/devicetree/bindings/usb/analogix,anx7411.yaml b/Documentation/devicetree/bindings/usb/analogix,anx7411.yaml
index 0e72c08e6566..e4d893369d57 100644
--- a/Documentation/devicetree/bindings/usb/analogix,anx7411.yaml
+++ b/Documentation/devicetree/bindings/usb/analogix,anx7411.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/usb/analogix,anx7411.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Analogix ANX7411 Type-C controller bindings
+title: Analogix ANX7411 Type-C controller
 
 maintainers:
   - Xin Ji <xji@analogixsemi.com>
diff --git a/Documentation/devicetree/bindings/usb/cdns,usb3.yaml b/Documentation/devicetree/bindings/usb/cdns,usb3.yaml
index dc9d6ed0781d..cae46c4982ad 100644
--- a/Documentation/devicetree/bindings/usb/cdns,usb3.yaml
+++ b/Documentation/devicetree/bindings/usb/cdns,usb3.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/usb/cdns,usb3.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Cadence USBSS-DRD controller bindings
+title: Cadence USBSS-DRD controller
 
 maintainers:
   - Pawel Laszczak <pawell@cadence.com>
diff --git a/Documentation/devicetree/bindings/usb/dwc2.yaml b/Documentation/devicetree/bindings/usb/dwc2.yaml
index 1ab85489a3f8..371ba93f3ce5 100644
--- a/Documentation/devicetree/bindings/usb/dwc2.yaml
+++ b/Documentation/devicetree/bindings/usb/dwc2.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/usb/dwc2.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: DesignWare HS OTG USB 2.0 controller Bindings
+title: DesignWare HS OTG USB 2.0 controller
 
 maintainers:
   - Rob Herring <robh@kernel.org>
diff --git a/Documentation/devicetree/bindings/usb/faraday,fotg210.yaml b/Documentation/devicetree/bindings/usb/faraday,fotg210.yaml
index c69bbfbcf733..84b3b69256b1 100644
--- a/Documentation/devicetree/bindings/usb/faraday,fotg210.yaml
+++ b/Documentation/devicetree/bindings/usb/faraday,fotg210.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/usb/faraday,fotg210.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Faraday Technology FOTG210 HS OTG USB 2.0 controller Bindings
+title: Faraday Technology FOTG210 HS OTG USB 2.0 controller
 
 maintainers:
   - Linus Walleij <linus.walleij@linaro.org>
diff --git a/Documentation/devicetree/bindings/usb/marvell,pxau2o-ehci.yaml b/Documentation/devicetree/bindings/usb/marvell,pxau2o-ehci.yaml
index 3cf93dd45eb7..a0246aa1f236 100644
--- a/Documentation/devicetree/bindings/usb/marvell,pxau2o-ehci.yaml
+++ b/Documentation/devicetree/bindings/usb/marvell,pxau2o-ehci.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/usb/marvell,pxau2o-ehci.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Marvell PXA/MMP EHCI bindings
+title: Marvell PXA/MMP EHCI
 
 maintainers:
   - Lubomir Rintel <lkundrak@v3.sk>
diff --git a/Documentation/devicetree/bindings/usb/nxp,isp1760.yaml b/Documentation/devicetree/bindings/usb/nxp,isp1760.yaml
index f238848ad094..e2743a4b9520 100644
--- a/Documentation/devicetree/bindings/usb/nxp,isp1760.yaml
+++ b/Documentation/devicetree/bindings/usb/nxp,isp1760.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/usb/nxp,isp1760.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: NXP ISP1760 family controller bindings
+title: NXP ISP1760 family controller
 
 maintainers:
   - Sebastian Siewior <bigeasy@linutronix.de>
diff --git a/Documentation/devicetree/bindings/usb/richtek,rt1719.yaml b/Documentation/devicetree/bindings/usb/richtek,rt1719.yaml
index 65a93f7738d5..e3e87e4d3292 100644
--- a/Documentation/devicetree/bindings/usb/richtek,rt1719.yaml
+++ b/Documentation/devicetree/bindings/usb/richtek,rt1719.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/usb/richtek,rt1719.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Richtek RT1719 sink-only Type-C PD controller bindings
+title: Richtek RT1719 sink-only Type-C PD controller
 
 maintainers:
   - ChiYuan Huang <cy_huang@richtek.com>
diff --git a/Documentation/devicetree/bindings/usb/st,stusb160x.yaml b/Documentation/devicetree/bindings/usb/st,stusb160x.yaml
index b8974807b666..ffcd9897ea38 100644
--- a/Documentation/devicetree/bindings/usb/st,stusb160x.yaml
+++ b/Documentation/devicetree/bindings/usb/st,stusb160x.yaml
@@ -4,7 +4,7 @@
 $id: "http://devicetree.org/schemas/usb/st,stusb160x.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: STMicroelectronics STUSB160x Type-C controller bindings
+title: STMicroelectronics STUSB160x Type-C controller
 
 maintainers:
   - Amelie Delaunay <amelie.delaunay@foss.st.com>
diff --git a/Documentation/devicetree/bindings/virtio/virtio-device.yaml b/Documentation/devicetree/bindings/virtio/virtio-device.yaml
index 1778ea9b5aa5..8c6919ba9497 100644
--- a/Documentation/devicetree/bindings/virtio/virtio-device.yaml
+++ b/Documentation/devicetree/bindings/virtio/virtio-device.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/virtio/virtio-device.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Virtio device bindings
+title: Virtio device
 
 maintainers:
   - Viresh Kumar <viresh.kumar@linaro.org>
diff --git a/Documentation/devicetree/bindings/watchdog/st,stm32-iwdg.yaml b/Documentation/devicetree/bindings/watchdog/st,stm32-iwdg.yaml
index 39736449ba64..a8e266f80c20 100644
--- a/Documentation/devicetree/bindings/watchdog/st,stm32-iwdg.yaml
+++ b/Documentation/devicetree/bindings/watchdog/st,stm32-iwdg.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/watchdog/st,stm32-iwdg.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: STMicroelectronics STM32 Independent WatchDoG (IWDG) bindings
+title: STMicroelectronics STM32 Independent WatchDoG (IWDG)
 
 maintainers:
   - Yannick Fertre <yannick.fertre@foss.st.com>
-- 
2.34.1

