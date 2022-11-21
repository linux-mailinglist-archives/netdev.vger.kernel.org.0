Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E3F631F39
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiKULHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiKULGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:06:31 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3381CA4651
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:06:22 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id j4so18341840lfk.0
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6cQl5VT9qGOEyv1Wkd4Se/oOZdHIaApBjb033i0Wzug=;
        b=p6Rcbl2c7Oo7pdZgETuyWRk5Kaw3O7C60VrUHontFklkivQtglYx+vJqFdIHF2BZSy
         YRsUWShzf545pdeSZjFpzGMdFKTr1C9oOAJaYTG14m5fZAjJLd8E4tUUAwKfs3VjAnLJ
         KobxboSIWeRsOEqJiou6W0C729Ro8B7aW7+BNUyJLtCto1vDoKeVghpFSKw+yYa/yFvU
         03tmQW2clWZHdaKN5xR7VcgJVGArYUkjB4l42ee6TioRIS9tHaRcm3Mg5ejklriEyijo
         sQ/ltZrZc19gJPEoLd2IR16Mz/xMPO6vKGiGk8mPKF94gj1Z2BCg408FnHn5TJnZRHUq
         o5lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6cQl5VT9qGOEyv1Wkd4Se/oOZdHIaApBjb033i0Wzug=;
        b=kZ8I4r16v98mQDhOZC49SUncCcLn8q8vVLJ3e495gfvBbbudm2laGNDTuO+gFJQ+dL
         EegOAXDJSwJjF6C35lKWx62YQnpfHNy+wnssqYiSbYkNkWqh/1I982MYUidDSsblYD6v
         t2r8/GpAavK3OPStzH/OM2ab9EXVMF/1F8TVaqZKeC+CvnIg7LmhUlUzyGApzr9pHlYM
         kkF6ibXdTwz3kZJqgq8EgGc92Pkg2e9HcrMb0okLRyvYADycoVVcht1kh2KfviJbpWEy
         /s7FonsT5rqVnciOiE6zUrBz7GykBS8UKwPL1njqlBHfS1pwrR91RTKlLq+HUWUcYy7E
         YamQ==
X-Gm-Message-State: ANoB5pl4xe3MQFKFIBsmWCCo9198OlBmeQp7qNz6kZRc/tPQLg495Ei5
        uSeGKBO92MZjdHfNKSAs1aatLg==
X-Google-Smtp-Source: AA0mqf6+9eNVyVWlttTkN8fX2m7M2YqtBKR/HLjdeLd/H7pFS3ZEH1S3la30/B4csNqP2/LW1xgNeA==
X-Received: by 2002:a19:ca0b:0:b0:4b1:7972:627a with SMTP id a11-20020a19ca0b000000b004b17972627amr5418728lfg.101.1669028780104;
        Mon, 21 Nov 2022 03:06:20 -0800 (PST)
Received: from krzk-bin.NAT.warszawa.vectranet.pl (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id n1-20020a05651203e100b0049313f77755sm1991521lfq.213.2022.11.21.03.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 03:06:19 -0800 (PST)
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
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2 0/9] dt-bindings: cleanup titles
Date:   Mon, 21 Nov 2022 12:06:06 +0100
Message-Id: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
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

Changes since v1
================
1. "common parts" -> "Common Properties".
2. Capitalize titles in other patches doing manual fixups.
3. Drop change of quotes in common DMA bindings.
4. Drop also "schema" from titles in few files.
5. Add tags.

Merging
=======
Intention is to regenerate the commits with commands at the end of merge
window.  This should go then via Rob's tree.

Description
===========
The Devicetree bindings document does not have to say in the title that it is a
"Devicetree binding" or "schema', but instead just describe the hardware.  We
have several of such patterns, so when people copy existing bindings into new
ones, they make similar mistake.

Clean this stuff with:
1. Automated find+sed commands.
2. Manual updates to have something meaningful in the title.

Best regards,
Krzysztof

Krzysztof Kozlowski (9):
  dt-bindings: drop redundant part of title of shared bindings
  dt-bindings: memory-controllers: ti,gpmc-child: drop redundant part of
    title
  dt-bindings: clock: st,stm32mp1-rcc: add proper title
  dt-bindings: drop redundant part of title (end)
  dt-bindings: drop redundant part of title (end, part two)
  dt-bindings: drop redundant part of title (end, part three)
  dt-bindings: drop redundant part of title (beginning)
  dt-bindings: clock: drop redundant part of title
  dt-bindings: drop redundant part of title (manual)

 Documentation/devicetree/bindings/arm/bcm/bcm2835.yaml          | 2 +-
 Documentation/devicetree/bindings/arm/bcm/brcm,bcm11351.yaml    | 2 +-
 Documentation/devicetree/bindings/arm/bcm/brcm,bcm21664.yaml    | 2 +-
 Documentation/devicetree/bindings/arm/bcm/brcm,bcm23550.yaml    | 2 +-
 Documentation/devicetree/bindings/arm/bcm/brcm,bcm4708.yaml     | 2 +-
 Documentation/devicetree/bindings/arm/bcm/brcm,bcmbca.yaml      | 2 +-
 Documentation/devicetree/bindings/arm/bcm/brcm,cygnus.yaml      | 2 +-
 Documentation/devicetree/bindings/arm/bcm/brcm,hr2.yaml         | 2 +-
 Documentation/devicetree/bindings/arm/bcm/brcm,ns2.yaml         | 2 +-
 Documentation/devicetree/bindings/arm/bcm/brcm,nsp.yaml         | 2 +-
 Documentation/devicetree/bindings/arm/bcm/brcm,stingray.yaml    | 2 +-
 Documentation/devicetree/bindings/arm/bcm/brcm,vulcan-soc.yaml  | 2 +-
 Documentation/devicetree/bindings/arm/cci-control-port.yaml     | 2 +-
 Documentation/devicetree/bindings/arm/cpus.yaml                 | 2 +-
 .../devicetree/bindings/arm/firmware/linaro,optee-tz.yaml       | 2 +-
 Documentation/devicetree/bindings/arm/hisilicon/hisilicon.yaml  | 2 +-
 .../devicetree/bindings/arm/keystone/ti,k3-sci-common.yaml      | 2 +-
 Documentation/devicetree/bindings/arm/keystone/ti,sci.yaml      | 2 +-
 Documentation/devicetree/bindings/arm/marvell/armada-7k-8k.yaml | 2 +-
 Documentation/devicetree/bindings/arm/mrvl/mrvl.yaml            | 2 +-
 Documentation/devicetree/bindings/arm/mstar/mstar.yaml          | 2 +-
 Documentation/devicetree/bindings/arm/npcm/npcm.yaml            | 2 +-
 Documentation/devicetree/bindings/arm/nxp/lpc32xx.yaml          | 2 +-
 Documentation/devicetree/bindings/arm/socionext/milbeaut.yaml   | 2 +-
 Documentation/devicetree/bindings/arm/socionext/uniphier.yaml   | 2 +-
 Documentation/devicetree/bindings/arm/sp810.yaml                | 2 +-
 Documentation/devicetree/bindings/arm/sprd/sprd.yaml            | 2 +-
 Documentation/devicetree/bindings/arm/stm32/st,mlahb.yaml       | 2 +-
 .../devicetree/bindings/arm/stm32/st,stm32-syscon.yaml          | 2 +-
 Documentation/devicetree/bindings/arm/stm32/stm32.yaml          | 2 +-
 .../bindings/arm/sunxi/allwinner,sun6i-a31-cpuconfig.yaml       | 2 +-
 .../devicetree/bindings/arm/sunxi/allwinner,sun9i-a80-prcm.yaml | 2 +-
 .../bindings/arm/tegra/nvidia,tegra-ccplex-cluster.yaml         | 2 +-
 .../devicetree/bindings/arm/tegra/nvidia,tegra194-cbb.yaml      | 2 +-
 .../devicetree/bindings/arm/tegra/nvidia,tegra234-cbb.yaml      | 2 +-
 Documentation/devicetree/bindings/arm/ti/k3.yaml                | 2 +-
 Documentation/devicetree/bindings/arm/ti/ti,davinci.yaml        | 2 +-
 Documentation/devicetree/bindings/arm/vexpress-config.yaml      | 2 +-
 Documentation/devicetree/bindings/arm/vexpress-sysreg.yaml      | 2 +-
 .../devicetree/bindings/ata/allwinner,sun4i-a10-ahci.yaml       | 2 +-
 .../devicetree/bindings/ata/allwinner,sun8i-r40-ahci.yaml       | 2 +-
 Documentation/devicetree/bindings/bus/ti-sysc.yaml              | 2 +-
 Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml     | 2 +-
 Documentation/devicetree/bindings/clock/calxeda.yaml            | 2 +-
 Documentation/devicetree/bindings/clock/cirrus,cs2000-cp.yaml   | 2 +-
 Documentation/devicetree/bindings/clock/fixed-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/fixed-factor-clock.yaml | 2 +-
 Documentation/devicetree/bindings/clock/fixed-mmio-clock.yaml   | 2 +-
 Documentation/devicetree/bindings/clock/fsl,plldig.yaml         | 2 +-
 Documentation/devicetree/bindings/clock/fsl,sai-clock.yaml      | 2 +-
 Documentation/devicetree/bindings/clock/fsl,scu-clk.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/idt,versaclock5.yaml    | 2 +-
 Documentation/devicetree/bindings/clock/imx1-clock.yaml         | 2 +-
 Documentation/devicetree/bindings/clock/imx21-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/imx23-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/imx25-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/imx27-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/imx28-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/imx31-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/imx35-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/imx5-clock.yaml         | 2 +-
 Documentation/devicetree/bindings/clock/imx6q-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/imx6sl-clock.yaml       | 2 +-
 Documentation/devicetree/bindings/clock/imx6sll-clock.yaml      | 2 +-
 Documentation/devicetree/bindings/clock/imx6sx-clock.yaml       | 2 +-
 Documentation/devicetree/bindings/clock/imx6ul-clock.yaml       | 2 +-
 Documentation/devicetree/bindings/clock/imx7d-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/imx7ulp-pcc-clock.yaml  | 2 +-
 Documentation/devicetree/bindings/clock/imx7ulp-scg-clock.yaml  | 2 +-
 Documentation/devicetree/bindings/clock/imx8m-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/imx8qxp-lpcg.yaml       | 2 +-
 Documentation/devicetree/bindings/clock/imx8ulp-cgc-clock.yaml  | 2 +-
 Documentation/devicetree/bindings/clock/imx8ulp-pcc-clock.yaml  | 2 +-
 Documentation/devicetree/bindings/clock/imx93-clock.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/imxrt1050-clock.yaml    | 2 +-
 Documentation/devicetree/bindings/clock/ingenic,cgu.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/intel,agilex.yaml       | 2 +-
 Documentation/devicetree/bindings/clock/intel,cgu-lgm.yaml      | 2 +-
 Documentation/devicetree/bindings/clock/intel,easic-n5x.yaml    | 2 +-
 Documentation/devicetree/bindings/clock/intel,stratix10.yaml    | 2 +-
 .../devicetree/bindings/clock/microchip,mpfs-clkcfg.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/milbeaut-clock.yaml     | 2 +-
 .../devicetree/bindings/clock/nuvoton,npcm845-clk.yaml          | 2 +-
 .../devicetree/bindings/clock/qcom,dispcc-sc8280xp.yaml         | 2 +-
 Documentation/devicetree/bindings/clock/qcom,gcc.yaml           | 2 +-
 Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/renesas,9series.yaml    | 2 +-
 .../devicetree/bindings/clock/renesas,versaclock7.yaml          | 2 +-
 .../devicetree/bindings/clock/rockchip,rk3568-cru.yaml          | 2 +-
 Documentation/devicetree/bindings/clock/st,stm32mp1-rcc.yaml    | 2 +-
 Documentation/devicetree/bindings/clock/ti,lmk04832.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/ti,sci-clk.yaml         | 2 +-
 Documentation/devicetree/bindings/clock/ti/ti,clksel.yaml       | 2 +-
 Documentation/devicetree/bindings/cpu/idle-states.yaml          | 2 +-
 .../devicetree/bindings/cpufreq/cpufreq-mediatek-hw.yaml        | 2 +-
 .../devicetree/bindings/cpufreq/qcom-cpufreq-nvmem.yaml         | 2 +-
 Documentation/devicetree/bindings/crypto/st,stm32-crc.yaml      | 2 +-
 Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml     | 2 +-
 Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml     | 2 +-
 Documentation/devicetree/bindings/display/arm,hdlcd.yaml        | 2 +-
 Documentation/devicetree/bindings/display/arm,malidp.yaml       | 2 +-
 Documentation/devicetree/bindings/display/bridge/anx6345.yaml   | 2 +-
 .../devicetree/bindings/display/bridge/chrontel,ch7033.yaml     | 2 +-
 .../devicetree/bindings/display/bridge/ingenic,jz4780-hdmi.yaml | 2 +-
 .../devicetree/bindings/display/bridge/intel,keembay-dsi.yaml   | 2 +-
 .../devicetree/bindings/display/bridge/ite,it6505.yaml          | 2 +-
 .../devicetree/bindings/display/bridge/ite,it66121.yaml         | 2 +-
 Documentation/devicetree/bindings/display/bridge/ps8640.yaml    | 2 +-
 .../devicetree/bindings/display/bridge/toshiba,tc358767.yaml    | 2 +-
 .../devicetree/bindings/display/bridge/toshiba,tc358775.yaml    | 2 +-
 Documentation/devicetree/bindings/display/ingenic,ipu.yaml      | 2 +-
 Documentation/devicetree/bindings/display/ingenic,lcd.yaml      | 2 +-
 .../devicetree/bindings/display/intel,keembay-display.yaml      | 2 +-
 .../devicetree/bindings/display/intel,keembay-msscam.yaml       | 2 +-
 .../devicetree/bindings/display/mediatek/mediatek,cec.yaml      | 2 +-
 .../devicetree/bindings/display/mediatek/mediatek,dsi.yaml      | 2 +-
 .../devicetree/bindings/display/mediatek/mediatek,hdmi-ddc.yaml | 2 +-
 .../devicetree/bindings/display/mediatek/mediatek,hdmi.yaml     | 2 +-
 Documentation/devicetree/bindings/display/msm/gmu.yaml          | 2 +-
 Documentation/devicetree/bindings/display/msm/gpu.yaml          | 2 +-
 .../devicetree/bindings/display/panel/display-timings.yaml      | 2 +-
 .../devicetree/bindings/display/panel/ilitek,ili9163.yaml       | 2 +-
 .../devicetree/bindings/display/panel/olimex,lcd-olinuxino.yaml | 2 +-
 Documentation/devicetree/bindings/display/panel/panel-lvds.yaml | 2 +-
 .../devicetree/bindings/display/panel/panel-timing.yaml         | 2 +-
 .../devicetree/bindings/display/panel/visionox,rm69299.yaml     | 2 +-
 Documentation/devicetree/bindings/dma/dma-common.yaml           | 2 +-
 Documentation/devicetree/bindings/dma/dma-controller.yaml       | 2 +-
 Documentation/devicetree/bindings/dma/dma-router.yaml           | 2 +-
 Documentation/devicetree/bindings/dma/ingenic,dma.yaml          | 2 +-
 Documentation/devicetree/bindings/dma/st,stm32-dma.yaml         | 2 +-
 Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml      | 2 +-
 Documentation/devicetree/bindings/dma/st,stm32-mdma.yaml        | 2 +-
 Documentation/devicetree/bindings/dma/ti/k3-bcdma.yaml          | 2 +-
 Documentation/devicetree/bindings/dma/ti/k3-pktdma.yaml         | 2 +-
 Documentation/devicetree/bindings/dma/ti/k3-udma.yaml           | 2 +-
 .../devicetree/bindings/dma/xilinx/xlnx,zynqmp-dpdma.yaml       | 2 +-
 Documentation/devicetree/bindings/edac/dmc-520.yaml             | 2 +-
 Documentation/devicetree/bindings/eeprom/microchip,93lc46b.yaml | 2 +-
 Documentation/devicetree/bindings/example-schema.yaml           | 2 +-
 Documentation/devicetree/bindings/firmware/arm,scmi.yaml        | 2 +-
 Documentation/devicetree/bindings/firmware/arm,scpi.yaml        | 2 +-
 .../devicetree/bindings/firmware/qemu,fw-cfg-mmio.yaml          | 2 +-
 Documentation/devicetree/bindings/gpio/gpio-tpic2810.yaml       | 2 +-
 Documentation/devicetree/bindings/gpio/ti,omap-gpio.yaml        | 2 +-
 Documentation/devicetree/bindings/gpu/brcm,bcm-v3d.yaml         | 2 +-
 .../devicetree/bindings/gpu/host1x/nvidia,tegra210-nvdec.yaml   | 2 +-
 .../devicetree/bindings/gpu/host1x/nvidia,tegra210-nvenc.yaml   | 2 +-
 .../devicetree/bindings/gpu/host1x/nvidia,tegra210-nvjpg.yaml   | 2 +-
 .../devicetree/bindings/gpu/host1x/nvidia,tegra234-nvdec.yaml   | 2 +-
 Documentation/devicetree/bindings/gpu/vivante,gc.yaml           | 2 +-
 .../devicetree/bindings/hwlock/st,stm32-hwspinlock.yaml         | 2 +-
 Documentation/devicetree/bindings/hwmon/moortec,mr75203.yaml    | 2 +-
 Documentation/devicetree/bindings/i2c/i2c-gpio.yaml             | 2 +-
 Documentation/devicetree/bindings/i2c/i2c-pxa.yaml              | 2 +-
 Documentation/devicetree/bindings/i2c/ingenic,i2c.yaml          | 2 +-
 Documentation/devicetree/bindings/i2c/st,nomadik-i2c.yaml       | 2 +-
 Documentation/devicetree/bindings/i2c/ti,omap4-i2c.yaml         | 2 +-
 Documentation/devicetree/bindings/i3c/i3c.yaml                  | 2 +-
 Documentation/devicetree/bindings/iio/adc/adc.yaml              | 2 +-
 .../devicetree/bindings/iio/adc/allwinner,sun8i-a33-ths.yaml    | 2 +-
 Documentation/devicetree/bindings/iio/adc/ingenic,adc.yaml      | 2 +-
 .../devicetree/bindings/iio/adc/motorola,cpcap-adc.yaml         | 2 +-
 Documentation/devicetree/bindings/iio/adc/nxp,imx8qxp-adc.yaml  | 2 +-
 Documentation/devicetree/bindings/iio/adc/nxp,lpc1850-adc.yaml  | 2 +-
 .../devicetree/bindings/iio/adc/sigma-delta-modulator.yaml      | 2 +-
 Documentation/devicetree/bindings/iio/adc/sprd,sc2720-adc.yaml  | 2 +-
 Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml     | 2 +-
 Documentation/devicetree/bindings/iio/adc/ti,palmas-gpadc.yaml  | 2 +-
 .../devicetree/bindings/iio/adc/x-powers,axp209-adc.yaml        | 2 +-
 Documentation/devicetree/bindings/iio/dac/nxp,lpc1850-dac.yaml  | 2 +-
 Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml     | 2 +-
 .../devicetree/bindings/iio/multiplexer/io-channel-mux.yaml     | 2 +-
 Documentation/devicetree/bindings/input/fsl,scu-key.yaml        | 2 +-
 Documentation/devicetree/bindings/input/gpio-keys.yaml          | 2 +-
 Documentation/devicetree/bindings/input/input.yaml              | 2 +-
 Documentation/devicetree/bindings/input/matrix-keymap.yaml      | 2 +-
 Documentation/devicetree/bindings/input/microchip,cap11xx.yaml  | 2 +-
 .../devicetree/bindings/input/pine64,pinephone-keyboard.yaml    | 2 +-
 .../devicetree/bindings/input/touchscreen/chipone,icn8318.yaml  | 2 +-
 .../bindings/input/touchscreen/cypress,cy8ctma140.yaml          | 2 +-
 .../bindings/input/touchscreen/cypress,cy8ctma340.yaml          | 2 +-
 .../devicetree/bindings/input/touchscreen/edt-ft5x06.yaml       | 2 +-
 Documentation/devicetree/bindings/input/touchscreen/goodix.yaml | 2 +-
 .../devicetree/bindings/input/touchscreen/himax,hx83112b.yaml   | 2 +-
 .../devicetree/bindings/input/touchscreen/hycon,hy46xx.yaml     | 2 +-
 .../devicetree/bindings/input/touchscreen/imagis,ist3038c.yaml  | 2 +-
 .../devicetree/bindings/input/touchscreen/melfas,mms114.yaml    | 2 +-
 .../devicetree/bindings/input/touchscreen/mstar,msg2638.yaml    | 2 +-
 .../devicetree/bindings/input/touchscreen/pixcir,pixcir_ts.yaml | 2 +-
 .../devicetree/bindings/input/touchscreen/silead,gsl1680.yaml   | 2 +-
 .../devicetree/bindings/input/touchscreen/ti,tsc2005.yaml       | 2 +-
 .../devicetree/bindings/input/touchscreen/touchscreen.yaml      | 2 +-
 .../devicetree/bindings/input/touchscreen/zinitix,bt400.yaml    | 2 +-
 .../devicetree/bindings/interrupt-controller/ingenic,intc.yaml  | 2 +-
 .../devicetree/bindings/interrupt-controller/mrvl,intc.yaml     | 2 +-
 .../bindings/interrupt-controller/nuvoton,wpcm450-aic.yaml      | 2 +-
 .../bindings/interrupt-controller/realtek,rtl-intc.yaml         | 2 +-
 .../devicetree/bindings/interrupt-controller/renesas,irqc.yaml  | 2 +-
 Documentation/devicetree/bindings/ipmi/ipmi-ipmb.yaml           | 2 +-
 Documentation/devicetree/bindings/ipmi/ipmi-smic.yaml           | 2 +-
 .../devicetree/bindings/leds/backlight/gpio-backlight.yaml      | 2 +-
 .../devicetree/bindings/leds/backlight/led-backlight.yaml       | 2 +-
 .../devicetree/bindings/leds/backlight/pwm-backlight.yaml       | 2 +-
 Documentation/devicetree/bindings/leds/backlight/qcom-wled.yaml | 2 +-
 Documentation/devicetree/bindings/leds/issi,is31fl319x.yaml     | 2 +-
 Documentation/devicetree/bindings/leds/register-bit-led.yaml    | 2 +-
 Documentation/devicetree/bindings/leds/regulator-led.yaml       | 2 +-
 .../devicetree/bindings/mailbox/qcom,apcs-kpss-global.yaml      | 2 +-
 Documentation/devicetree/bindings/mailbox/sprd-mailbox.yaml     | 2 +-
 Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml    | 2 +-
 .../devicetree/bindings/media/i2c/dongwoon,dw9768.yaml          | 2 +-
 Documentation/devicetree/bindings/media/i2c/ov8856.yaml         | 2 +-
 Documentation/devicetree/bindings/media/i2c/ovti,ov02a10.yaml   | 2 +-
 Documentation/devicetree/bindings/media/i2c/ovti,ov5640.yaml    | 2 +-
 Documentation/devicetree/bindings/media/i2c/ovti,ov5648.yaml    | 2 +-
 Documentation/devicetree/bindings/media/i2c/ovti,ov8865.yaml    | 2 +-
 Documentation/devicetree/bindings/media/i2c/st,st-vgxy61.yaml   | 2 +-
 Documentation/devicetree/bindings/media/marvell,mmp2-ccic.yaml  | 2 +-
 Documentation/devicetree/bindings/media/renesas,ceu.yaml        | 2 +-
 Documentation/devicetree/bindings/media/st,stm32-cec.yaml       | 2 +-
 Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml      | 2 +-
 Documentation/devicetree/bindings/media/st,stm32-dma2d.yaml     | 2 +-
 .../devicetree/bindings/media/video-interface-devices.yaml      | 2 +-
 Documentation/devicetree/bindings/media/video-interfaces.yaml   | 2 +-
 .../bindings/memory-controllers/calxeda-ddr-ctrlr.yaml          | 2 +-
 .../bindings/memory-controllers/ingenic,nemc-peripherals.yaml   | 2 +-
 .../devicetree/bindings/memory-controllers/ingenic,nemc.yaml    | 2 +-
 .../bindings/memory-controllers/st,stm32-fmc2-ebi.yaml          | 2 +-
 .../devicetree/bindings/memory-controllers/ti,gpmc-child.yaml   | 2 +-
 .../devicetree/bindings/memory-controllers/ti,gpmc.yaml         | 2 +-
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
 Documentation/devicetree/bindings/mips/ingenic/devices.yaml     | 2 +-
 Documentation/devicetree/bindings/mips/ingenic/ingenic,cpu.yaml | 2 +-
 .../devicetree/bindings/mips/lantiq/lantiq,dma-xway.yaml        | 2 +-
 Documentation/devicetree/bindings/mips/loongson/devices.yaml    | 2 +-
 Documentation/devicetree/bindings/misc/olpc,xo1.75-ec.yaml      | 2 +-
 Documentation/devicetree/bindings/mmc/arasan,sdhci.yaml         | 2 +-
 Documentation/devicetree/bindings/mmc/brcm,sdhci-brcmstb.yaml   | 2 +-
 Documentation/devicetree/bindings/mmc/ingenic,mmc.yaml          | 2 +-
 .../devicetree/bindings/mmc/microchip,dw-sparx5-sdhci.yaml      | 2 +-
 Documentation/devicetree/bindings/mmc/mmc-controller.yaml       | 2 +-
 Documentation/devicetree/bindings/mmc/mmc-pwrseq-emmc.yaml      | 2 +-
 Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.yaml    | 2 +-
 Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml    | 2 +-
 Documentation/devicetree/bindings/mmc/mtk-sd.yaml               | 2 +-
 Documentation/devicetree/bindings/mmc/sdhci-pxa.yaml            | 2 +-
 Documentation/devicetree/bindings/mmc/snps,dwcmshc-sdhci.yaml   | 2 +-
 Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.yaml     | 2 +-
 Documentation/devicetree/bindings/mtd/gpmi-nand.yaml            | 2 +-
 Documentation/devicetree/bindings/mtd/ingenic,nand.yaml         | 2 +-
 Documentation/devicetree/bindings/mtd/microchip,mchp48l640.yaml | 2 +-
 Documentation/devicetree/bindings/mtd/mxc-nand.yaml             | 2 +-
 Documentation/devicetree/bindings/mtd/nand-chip.yaml            | 2 +-
 Documentation/devicetree/bindings/mtd/nand-controller.yaml      | 2 +-
 .../devicetree/bindings/mtd/partitions/qcom,smem-part.yaml      | 2 +-
 Documentation/devicetree/bindings/mtd/st,stm32-fmc2-nand.yaml   | 2 +-
 Documentation/devicetree/bindings/mux/gpio-mux.yaml             | 2 +-
 Documentation/devicetree/bindings/mux/mux-consumer.yaml         | 2 +-
 Documentation/devicetree/bindings/mux/mux-controller.yaml       | 2 +-
 Documentation/devicetree/bindings/mux/reg-mux.yaml              | 2 +-
 Documentation/devicetree/bindings/net/asix,ax88178.yaml         | 2 +-
 .../devicetree/bindings/net/bluetooth/bluetooth-controller.yaml | 2 +-
 Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml        | 2 +-
 .../devicetree/bindings/net/can/allwinner,sun4i-a10-can.yaml    | 2 +-
 Documentation/devicetree/bindings/net/can/bosch,c_can.yaml      | 2 +-
 Documentation/devicetree/bindings/net/can/bosch,m_can.yaml      | 2 +-
 Documentation/devicetree/bindings/net/can/can-controller.yaml   | 2 +-
 Documentation/devicetree/bindings/net/can/can-transceiver.yaml  | 2 +-
 Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml     | 2 +-
 Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml    | 2 +-
 Documentation/devicetree/bindings/net/dsa/dsa-port.yaml         | 2 +-
 Documentation/devicetree/bindings/net/dsa/dsa.yaml              | 2 +-
 .../devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml       | 2 +-
 .../devicetree/bindings/net/dsa/microchip,lan937x.yaml          | 2 +-
 Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml      | 2 +-
 Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml      | 2 +-
 Documentation/devicetree/bindings/net/engleder,tsnep.yaml       | 2 +-
 Documentation/devicetree/bindings/net/ethernet-controller.yaml  | 2 +-
 Documentation/devicetree/bindings/net/ethernet-phy.yaml         | 2 +-
 Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml   | 2 +-
 Documentation/devicetree/bindings/net/ingenic,mac.yaml          | 2 +-
 Documentation/devicetree/bindings/net/mctp-i2c-controller.yaml  | 2 +-
 Documentation/devicetree/bindings/net/mdio.yaml                 | 2 +-
 Documentation/devicetree/bindings/net/microchip,lan95xx.yaml    | 2 +-
 Documentation/devicetree/bindings/net/wireless/esp,esp8089.yaml | 2 +-
 Documentation/devicetree/bindings/net/wireless/ieee80211.yaml   | 2 +-
 .../devicetree/bindings/net/wireless/mediatek,mt76.yaml         | 2 +-
 .../devicetree/bindings/net/wireless/microchip,wilc1000.yaml    | 2 +-
 Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml   | 2 +-
 Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml | 2 +-
 Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml  | 2 +-
 Documentation/devicetree/bindings/nvmem/fsl,scu-ocotp.yaml      | 2 +-
 .../devicetree/bindings/nvmem/ingenic,jz4780-efuse.yaml         | 2 +-
 Documentation/devicetree/bindings/nvmem/qcom,qfprom.yaml        | 2 +-
 Documentation/devicetree/bindings/nvmem/qcom,spmi-sdam.yaml     | 2 +-
 .../devicetree/bindings/nvmem/socionext,uniphier-efuse.yaml     | 2 +-
 Documentation/devicetree/bindings/nvmem/st,stm32-romem.yaml     | 2 +-
 Documentation/devicetree/bindings/opp/opp-v1.yaml               | 2 +-
 Documentation/devicetree/bindings/opp/opp-v2-base.yaml          | 2 +-
 Documentation/devicetree/bindings/opp/opp-v2-kryo-cpu.yaml      | 2 +-
 Documentation/devicetree/bindings/opp/opp-v2-qcom-level.yaml    | 2 +-
 Documentation/devicetree/bindings/opp/opp-v2.yaml               | 2 +-
 Documentation/devicetree/bindings/pci/pci-ep.yaml               | 2 +-
 Documentation/devicetree/bindings/pci/qcom,pcie-ep.yaml         | 2 +-
 Documentation/devicetree/bindings/phy/brcm,ns2-pcie-phy.yaml    | 2 +-
 Documentation/devicetree/bindings/phy/calxeda-combophy.yaml     | 2 +-
 Documentation/devicetree/bindings/phy/fsl,imx8mq-usb-phy.yaml   | 2 +-
 Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml         | 2 +-
 Documentation/devicetree/bindings/phy/ingenic,phy-usb.yaml      | 2 +-
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
 Documentation/devicetree/bindings/phy/qcom,usb-hs-phy.yaml      | 2 +-
 Documentation/devicetree/bindings/phy/ti,phy-am654-serdes.yaml  | 2 +-
 Documentation/devicetree/bindings/phy/ti,phy-gmii-sel.yaml      | 2 +-
 Documentation/devicetree/bindings/phy/transmit-amplitude.yaml   | 2 +-
 Documentation/devicetree/bindings/pinctrl/fsl,scu-pinctrl.yaml  | 2 +-
 Documentation/devicetree/bindings/pinctrl/ingenic,pinctrl.yaml  | 2 +-
 Documentation/devicetree/bindings/pinctrl/intel,lgm-io.yaml     | 2 +-
 Documentation/devicetree/bindings/pinctrl/pincfg-node.yaml      | 2 +-
 Documentation/devicetree/bindings/pinctrl/pinmux-node.yaml      | 2 +-
 Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml       | 2 +-
 Documentation/devicetree/bindings/power/domain-idle-state.yaml  | 2 +-
 Documentation/devicetree/bindings/power/fsl,scu-pd.yaml         | 2 +-
 .../devicetree/bindings/power/reset/restart-handler.yaml        | 2 +-
 .../devicetree/bindings/power/reset/xlnx,zynqmp-power.yaml      | 2 +-
 Documentation/devicetree/bindings/power/supply/bq2415x.yaml     | 2 +-
 Documentation/devicetree/bindings/power/supply/bq24190.yaml     | 2 +-
 Documentation/devicetree/bindings/power/supply/bq24257.yaml     | 2 +-
 Documentation/devicetree/bindings/power/supply/bq24735.yaml     | 2 +-
 Documentation/devicetree/bindings/power/supply/bq25890.yaml     | 2 +-
 .../devicetree/bindings/power/supply/dlg,da9150-charger.yaml    | 2 +-
 .../devicetree/bindings/power/supply/dlg,da9150-fuel-gauge.yaml | 2 +-
 .../devicetree/bindings/power/supply/ingenic,battery.yaml       | 2 +-
 Documentation/devicetree/bindings/power/supply/isp1704.yaml     | 2 +-
 .../devicetree/bindings/power/supply/lltc,lt3651-charger.yaml   | 2 +-
 .../devicetree/bindings/power/supply/lltc,ltc294x.yaml          | 2 +-
 .../devicetree/bindings/power/supply/maxim,ds2760.yaml          | 2 +-
 .../devicetree/bindings/power/supply/maxim,max14656.yaml        | 2 +-
 .../devicetree/bindings/power/supply/richtek,rt9455.yaml        | 2 +-
 .../devicetree/bindings/power/supply/sc2731-charger.yaml        | 2 +-
 Documentation/devicetree/bindings/power/supply/sc27xx-fg.yaml   | 2 +-
 Documentation/devicetree/bindings/power/supply/ti,lp8727.yaml   | 2 +-
 Documentation/devicetree/bindings/pwm/microchip,corepwm.yaml    | 2 +-
 Documentation/devicetree/bindings/regulator/pwm-regulator.yaml  | 2 +-
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
 .../devicetree/bindings/reserved-memory/shared-dma-pool.yaml    | 2 +-
 Documentation/devicetree/bindings/reset/ti,sci-reset.yaml       | 2 +-
 Documentation/devicetree/bindings/reset/ti,tps380x-reset.yaml   | 2 +-
 Documentation/devicetree/bindings/riscv/cpus.yaml               | 2 +-
 Documentation/devicetree/bindings/rng/ingenic,rng.yaml          | 2 +-
 Documentation/devicetree/bindings/rng/ingenic,trng.yaml         | 2 +-
 Documentation/devicetree/bindings/rng/intel,ixp46x-rng.yaml     | 2 +-
 .../devicetree/bindings/rng/silex-insight,ba431-rng.yaml        | 2 +-
 Documentation/devicetree/bindings/rng/st,stm32-rng.yaml         | 2 +-
 .../devicetree/bindings/rng/xiphera,xip8001b-trng.yaml          | 2 +-
 Documentation/devicetree/bindings/rtc/epson,rx8900.yaml         | 2 +-
 Documentation/devicetree/bindings/rtc/fsl,scu-rtc.yaml          | 2 +-
 Documentation/devicetree/bindings/rtc/ingenic,rtc.yaml          | 2 +-
 Documentation/devicetree/bindings/rtc/renesas,rzn1-rtc.yaml     | 2 +-
 Documentation/devicetree/bindings/rtc/rtc.yaml                  | 2 +-
 Documentation/devicetree/bindings/rtc/sa1100-rtc.yaml           | 2 +-
 Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml         | 2 +-
 Documentation/devicetree/bindings/serial/8250.yaml              | 2 +-
 Documentation/devicetree/bindings/serial/8250_omap.yaml         | 2 +-
 Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml | 2 +-
 Documentation/devicetree/bindings/serial/ingenic,uart.yaml      | 2 +-
 Documentation/devicetree/bindings/serial/rs485.yaml             | 2 +-
 Documentation/devicetree/bindings/serial/serial.yaml            | 2 +-
 Documentation/devicetree/bindings/serial/st,stm32-uart.yaml     | 2 +-
 Documentation/devicetree/bindings/serio/ps2-gpio.yaml           | 2 +-
 Documentation/devicetree/bindings/soc/mediatek/mtk-svs.yaml     | 2 +-
 Documentation/devicetree/bindings/soc/qcom/qcom,aoss-qmp.yaml   | 2 +-
 Documentation/devicetree/bindings/soc/qcom/qcom,apr.yaml        | 2 +-
 Documentation/devicetree/bindings/soc/qcom/qcom,smem.yaml       | 2 +-
 Documentation/devicetree/bindings/soc/qcom/qcom,spm.yaml        | 2 +-
 Documentation/devicetree/bindings/soc/qcom/qcom-stats.yaml      | 2 +-
 Documentation/devicetree/bindings/soc/samsung/exynos-usi.yaml   | 2 +-
 Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml     | 2 +-
 Documentation/devicetree/bindings/sound/audio-graph-port.yaml   | 2 +-
 Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml     | 2 +-
 Documentation/devicetree/bindings/sound/ingenic,aic.yaml        | 2 +-
 Documentation/devicetree/bindings/sound/ingenic,codec.yaml      | 2 +-
 Documentation/devicetree/bindings/sound/marvell,mmp-sspa.yaml   | 2 +-
 Documentation/devicetree/bindings/sound/qcom,lpass-cpu.yaml     | 2 +-
 .../devicetree/bindings/sound/qcom,lpass-rx-macro.yaml          | 2 +-
 .../devicetree/bindings/sound/qcom,lpass-tx-macro.yaml          | 2 +-
 .../devicetree/bindings/sound/qcom,lpass-va-macro.yaml          | 2 +-
 .../devicetree/bindings/sound/qcom,lpass-wsa-macro.yaml         | 2 +-
 Documentation/devicetree/bindings/sound/qcom,q6apm-dai.yaml     | 2 +-
 .../devicetree/bindings/sound/qcom,q6dsp-lpass-clocks.yaml      | 2 +-
 .../devicetree/bindings/sound/qcom,q6dsp-lpass-ports.yaml       | 2 +-
 Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml       | 2 +-
 Documentation/devicetree/bindings/sound/qcom,wcd938x-sdw.yaml   | 2 +-
 Documentation/devicetree/bindings/sound/qcom,wcd938x.yaml       | 2 +-
 Documentation/devicetree/bindings/sound/qcom,wsa881x.yaml       | 2 +-
 Documentation/devicetree/bindings/sound/qcom,wsa883x.yaml       | 2 +-
 Documentation/devicetree/bindings/sound/realtek,rt1015p.yaml    | 2 +-
 Documentation/devicetree/bindings/sound/realtek,rt5682s.yaml    | 2 +-
 Documentation/devicetree/bindings/sound/ti,src4xxx.yaml         | 2 +-
 .../devicetree/bindings/soundwire/soundwire-controller.yaml     | 2 +-
 Documentation/devicetree/bindings/spi/aspeed,ast2600-fmc.yaml   | 2 +-
 Documentation/devicetree/bindings/spi/ingenic,spi.yaml          | 2 +-
 Documentation/devicetree/bindings/spi/marvell,mmp2-ssp.yaml     | 2 +-
 Documentation/devicetree/bindings/spi/omap-spi.yaml             | 2 +-
 Documentation/devicetree/bindings/spi/spi-controller.yaml       | 2 +-
 Documentation/devicetree/bindings/spi/spi-gpio.yaml             | 2 +-
 Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml        | 2 +-
 Documentation/devicetree/bindings/spi/st,stm32-spi.yaml         | 2 +-
 Documentation/devicetree/bindings/thermal/fsl,scu-thermal.yaml  | 2 +-
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
 Documentation/devicetree/bindings/timer/ingenic,sysost.yaml     | 2 +-
 Documentation/devicetree/bindings/timer/ingenic,tcu.yaml        | 2 +-
 Documentation/devicetree/bindings/timer/mrvl,mmp-timer.yaml     | 2 +-
 Documentation/devicetree/bindings/timer/st,stm32-timer.yaml     | 2 +-
 Documentation/devicetree/bindings/usb/analogix,anx7411.yaml     | 2 +-
 Documentation/devicetree/bindings/usb/cdns,usb3.yaml            | 2 +-
 Documentation/devicetree/bindings/usb/dwc2.yaml                 | 2 +-
 Documentation/devicetree/bindings/usb/faraday,fotg210.yaml      | 2 +-
 Documentation/devicetree/bindings/usb/ingenic,musb.yaml         | 2 +-
 Documentation/devicetree/bindings/usb/marvell,pxau2o-ehci.yaml  | 2 +-
 Documentation/devicetree/bindings/usb/maxim,max33359.yaml       | 2 +-
 Documentation/devicetree/bindings/usb/mediatek,mt6360-tcpc.yaml | 2 +-
 Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml    | 2 +-
 Documentation/devicetree/bindings/usb/nxp,isp1760.yaml          | 2 +-
 Documentation/devicetree/bindings/usb/realtek,rts5411.yaml      | 2 +-
 Documentation/devicetree/bindings/usb/richtek,rt1719.yaml       | 2 +-
 Documentation/devicetree/bindings/usb/st,stusb160x.yaml         | 2 +-
 Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml         | 2 +-
 Documentation/devicetree/bindings/usb/ti,tps6598x.yaml          | 2 +-
 Documentation/devicetree/bindings/usb/ti,usb8041.yaml           | 2 +-
 Documentation/devicetree/bindings/usb/usb-device.yaml           | 2 +-
 Documentation/devicetree/bindings/usb/willsemi,wusb3801.yaml    | 2 +-
 Documentation/devicetree/bindings/virtio/virtio-device.yaml     | 2 +-
 Documentation/devicetree/bindings/watchdog/fsl,scu-wdt.yaml     | 2 +-
 Documentation/devicetree/bindings/watchdog/st,stm32-iwdg.yaml   | 2 +-
 Documentation/devicetree/bindings/watchdog/watchdog.yaml        | 2 +-
 476 files changed, 476 insertions(+), 476 deletions(-)

-- 
2.34.1

