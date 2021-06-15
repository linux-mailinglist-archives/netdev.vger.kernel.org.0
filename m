Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C61E3A8966
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 21:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhFOTSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 15:18:09 -0400
Received: from mail-il1-f179.google.com ([209.85.166.179]:46028 "EHLO
        mail-il1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhFOTSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 15:18:03 -0400
Received: by mail-il1-f179.google.com with SMTP id b5so75780ilc.12;
        Tue, 15 Jun 2021 12:15:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pzmsEVG+BFh15mF6RX30K2WyDEugqeRNaUVN262FxvE=;
        b=bu4TMVwp/RYllsF3LRBLFJcYzTMrsDu5aI+v4LhzSAuFsGqiK2prVy2ZXZ92o83sfh
         RD+qJuEN6P0/C1B5yxZCQkSK6hNd/wQTlHE37fDrWnpCYHjkKfUhhNJO2E0ZAqwIzJGx
         QoPk9WhXFlNDJ4uK7oN7x7G1HLsu9Ky59aU/1qvdMWjpK5kHVhTTLlq9Vg9SjYaylk37
         OqWyVK0X1zl0YgUGkf14VVmS+xQkBd6e9AdFaRHLGsE8Sw2aFIa6AN6iggE5lYGh4ouH
         SeLEImB3o5MgX7Ra5F1fJ13UZ3Ja/SLdkMPQ3JGRA9X2e+TKKZZeSXtXFKDYaAJdBShA
         08Ow==
X-Gm-Message-State: AOAM5317mQrVbvsnOiVN5+e/fZIXFqZyqW0wmymAk3wwBKprObpYZs8A
        YG3NyJ/0a2B+CUE1iR02eaVH+3Y7LA==
X-Google-Smtp-Source: ABdhPJzVYNsNJTJ8+Hq2KQwlke8DmuE2Mnta9SrXOZv7JZ5cn3Mx6eZ0gJt1dLd/DmM1gKPEpdPHKg==
X-Received: by 2002:a05:6e02:1289:: with SMTP id y9mr801615ilq.88.1623784555446;
        Tue, 15 Jun 2021 12:15:55 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.248])
        by smtp.googlemail.com with ESMTPSA id r11sm9659921ilo.10.2021.06.15.12.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 12:15:53 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org,
        dmaengine@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-iio@vger.kernel.org, alsa-devel@alsa-project.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-watchdog@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Stephen Boyd <sboyd@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Vinod Koul <vkoul@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Lee Jones <lee.jones@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] dt-bindings: Drop redundant minItems/maxItems
Date:   Tue, 15 Jun 2021 13:15:43 -0600
Message-Id: <20210615191543.1043414-1-robh@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a property has an 'items' list, then a 'minItems' or 'maxItems' with the
same size as the list is redundant and can be dropped. Note that is DT
schema specific behavior and not standard json-schema behavior. The tooling
will fixup the final schema adding any unspecified minItems/maxItems.

This condition is partially checked with the meta-schema already, but
only if both 'minItems' and 'maxItems' are equal to the 'items' length.
An improved meta-schema is pending.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Kamal Dasu <kdasu.kdev@gmail.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/ata/nvidia,tegra-ahci.yaml          | 1 -
 .../devicetree/bindings/clock/allwinner,sun4i-a10-ccu.yaml  | 2 --
 .../devicetree/bindings/clock/qcom,gcc-apq8064.yaml         | 1 -
 Documentation/devicetree/bindings/clock/qcom,gcc-sdx55.yaml | 2 --
 .../devicetree/bindings/clock/qcom,gcc-sm8350.yaml          | 2 --
 .../devicetree/bindings/clock/sprd,sc9863a-clk.yaml         | 1 -
 .../devicetree/bindings/crypto/allwinner,sun8i-ce.yaml      | 2 --
 Documentation/devicetree/bindings/crypto/fsl-dcp.yaml       | 1 -
 .../display/allwinner,sun4i-a10-display-backend.yaml        | 6 ------
 .../bindings/display/allwinner,sun6i-a31-mipi-dsi.yaml      | 1 -
 .../bindings/display/allwinner,sun8i-a83t-dw-hdmi.yaml      | 4 ----
 .../bindings/display/allwinner,sun8i-a83t-hdmi-phy.yaml     | 2 --
 .../bindings/display/allwinner,sun8i-r40-tcon-top.yaml      | 2 --
 .../devicetree/bindings/display/bridge/cdns,mhdp8546.yaml   | 2 --
 .../bindings/display/rockchip/rockchip,dw-hdmi.yaml         | 2 --
 Documentation/devicetree/bindings/display/st,stm32-dsi.yaml | 2 --
 .../devicetree/bindings/display/st,stm32-ltdc.yaml          | 1 -
 .../devicetree/bindings/display/xlnx/xlnx,zynqmp-dpsub.yaml | 4 ----
 .../devicetree/bindings/dma/renesas,rcar-dmac.yaml          | 1 -
 .../devicetree/bindings/edac/amazon,al-mc-edac.yaml         | 2 --
 Documentation/devicetree/bindings/eeprom/at24.yaml          | 1 -
 Documentation/devicetree/bindings/example-schema.yaml       | 2 --
 Documentation/devicetree/bindings/gpu/brcm,bcm-v3d.yaml     | 1 -
 Documentation/devicetree/bindings/gpu/vivante,gc.yaml       | 1 -
 Documentation/devicetree/bindings/i2c/brcm,brcmstb-i2c.yaml | 1 -
 .../devicetree/bindings/i2c/marvell,mv64xxx-i2c.yaml        | 2 --
 .../devicetree/bindings/i2c/mellanox,i2c-mlxbf.yaml         | 1 -
 .../devicetree/bindings/iio/adc/amlogic,meson-saradc.yaml   | 1 -
 .../devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml     | 2 --
 .../bindings/interrupt-controller/fsl,irqsteer.yaml         | 1 -
 .../bindings/interrupt-controller/loongson,liointc.yaml     | 1 -
 Documentation/devicetree/bindings/iommu/arm,smmu-v3.yaml    | 1 -
 .../devicetree/bindings/iommu/renesas,ipmmu-vmsa.yaml       | 1 -
 .../devicetree/bindings/mailbox/st,stm32-ipcc.yaml          | 2 --
 .../devicetree/bindings/media/amlogic,gx-vdec.yaml          | 1 -
 Documentation/devicetree/bindings/media/i2c/adv7604.yaml    | 1 -
 .../devicetree/bindings/media/marvell,mmp2-ccic.yaml        | 1 -
 .../devicetree/bindings/media/qcom,sc7180-venus.yaml        | 1 -
 .../devicetree/bindings/media/qcom,sdm845-venus-v2.yaml     | 1 -
 .../devicetree/bindings/media/qcom,sm8250-venus.yaml        | 1 -
 Documentation/devicetree/bindings/media/renesas,drif.yaml   | 1 -
 .../bindings/memory-controllers/mediatek,smi-common.yaml    | 6 ++----
 .../bindings/memory-controllers/mediatek,smi-larb.yaml      | 1 -
 .../devicetree/bindings/mmc/allwinner,sun4i-a10-mmc.yaml    | 2 --
 Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml    | 1 -
 Documentation/devicetree/bindings/mmc/mtk-sd.yaml           | 2 --
 Documentation/devicetree/bindings/mmc/renesas,sdhi.yaml     | 2 --
 Documentation/devicetree/bindings/mmc/sdhci-am654.yaml      | 1 -
 Documentation/devicetree/bindings/mmc/sdhci-pxa.yaml        | 1 -
 .../devicetree/bindings/net/amlogic,meson-dwmac.yaml        | 2 --
 .../devicetree/bindings/net/brcm,bcm4908-enet.yaml          | 2 --
 Documentation/devicetree/bindings/net/can/bosch,m_can.yaml  | 2 --
 Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml     | 2 --
 Documentation/devicetree/bindings/net/snps,dwmac.yaml       | 2 --
 Documentation/devicetree/bindings/net/stm32-dwmac.yaml      | 1 -
 Documentation/devicetree/bindings/pci/brcm,stb-pcie.yaml    | 2 --
 Documentation/devicetree/bindings/pci/loongson.yaml         | 1 -
 .../devicetree/bindings/pci/mediatek-pcie-gen3.yaml         | 1 -
 .../devicetree/bindings/pci/microchip,pcie-host.yaml        | 2 --
 Documentation/devicetree/bindings/perf/arm,cmn.yaml         | 1 -
 .../devicetree/bindings/phy/brcm,bcm63xx-usbh-phy.yaml      | 1 -
 .../devicetree/bindings/phy/brcm,brcmstb-usb-phy.yaml       | 3 ---
 Documentation/devicetree/bindings/phy/brcm,sata-phy.yaml    | 1 -
 Documentation/devicetree/bindings/phy/mediatek,tphy.yaml    | 2 --
 .../devicetree/bindings/phy/phy-cadence-sierra.yaml         | 2 --
 .../devicetree/bindings/phy/phy-cadence-torrent.yaml        | 4 ----
 .../devicetree/bindings/phy/qcom,ipq806x-usb-phy-hs.yaml    | 1 -
 .../devicetree/bindings/phy/qcom,ipq806x-usb-phy-ss.yaml    | 1 -
 Documentation/devicetree/bindings/phy/qcom,qmp-phy.yaml     | 1 -
 Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml   | 2 --
 Documentation/devicetree/bindings/phy/renesas,usb2-phy.yaml | 2 --
 Documentation/devicetree/bindings/phy/renesas,usb3-phy.yaml | 1 -
 .../devicetree/bindings/pinctrl/actions,s500-pinctrl.yaml   | 1 -
 .../devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml    | 1 -
 .../devicetree/bindings/pwm/allwinner,sun4i-a10-pwm.yaml    | 1 -
 .../devicetree/bindings/remoteproc/st,stm32-rproc.yaml      | 2 --
 .../devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml     | 1 -
 .../devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml  | 1 -
 Documentation/devicetree/bindings/reset/fsl,imx-src.yaml    | 1 -
 .../devicetree/bindings/riscv/sifive-l2-cache.yaml          | 1 -
 .../devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml    | 1 -
 Documentation/devicetree/bindings/rtc/imxdi-rtc.yaml        | 1 -
 Documentation/devicetree/bindings/serial/fsl-lpuart.yaml    | 2 --
 Documentation/devicetree/bindings/serial/samsung_uart.yaml  | 1 -
 .../devicetree/bindings/soc/qcom/qcom,geni-se.yaml          | 1 -
 Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml      | 2 --
 .../bindings/sound/nvidia,tegra-audio-graph-card.yaml       | 1 -
 .../devicetree/bindings/sound/nvidia,tegra210-i2s.yaml      | 2 --
 Documentation/devicetree/bindings/sound/st,stm32-sai.yaml   | 3 ---
 .../devicetree/bindings/spi/amlogic,meson-gx-spicc.yaml     | 1 -
 .../devicetree/bindings/spi/brcm,spi-bcm-qspi.yaml          | 2 --
 .../bindings/thermal/allwinner,sun8i-a83t-ths.yaml          | 2 --
 Documentation/devicetree/bindings/thermal/qcom-tsens.yaml   | 1 -
 .../bindings/timer/allwinner,sun5i-a13-hstimer.yaml         | 1 -
 Documentation/devicetree/bindings/timer/arm,arch_timer.yaml | 1 -
 .../devicetree/bindings/timer/arm,arch_timer_mmio.yaml      | 2 --
 .../devicetree/bindings/timer/intel,ixp4xx-timer.yaml       | 1 -
 .../devicetree/bindings/usb/maxim,max3420-udc.yaml          | 2 --
 .../devicetree/bindings/usb/nvidia,tegra-xudc.yaml          | 4 ----
 Documentation/devicetree/bindings/usb/renesas,usbhs.yaml    | 3 ---
 .../devicetree/bindings/watchdog/st,stm32-iwdg.yaml         | 1 -
 101 files changed, 2 insertions(+), 163 deletions(-)

diff --git a/Documentation/devicetree/bindings/ata/nvidia,tegra-ahci.yaml b/Documentation/devicetree/bindings/ata/nvidia,tegra-ahci.yaml
index a75e9a8f539a..3c7a2425f3e6 100644
--- a/Documentation/devicetree/bindings/ata/nvidia,tegra-ahci.yaml
+++ b/Documentation/devicetree/bindings/ata/nvidia,tegra-ahci.yaml
@@ -20,7 +20,6 @@ properties:
 
   reg:
     minItems: 2
-    maxItems: 3
     items:
       - description: AHCI registers
       - description: SATA configuration and IPFS registers
diff --git a/Documentation/devicetree/bindings/clock/allwinner,sun4i-a10-ccu.yaml b/Documentation/devicetree/bindings/clock/allwinner,sun4i-a10-ccu.yaml
index a27025cd3909..c4b7243ddcf2 100644
--- a/Documentation/devicetree/bindings/clock/allwinner,sun4i-a10-ccu.yaml
+++ b/Documentation/devicetree/bindings/clock/allwinner,sun4i-a10-ccu.yaml
@@ -51,7 +51,6 @@ properties:
 
   clocks:
     minItems: 2
-    maxItems: 4
     items:
       - description: High Frequency Oscillator (usually at 24MHz)
       - description: Low Frequency Oscillator (usually at 32kHz)
@@ -60,7 +59,6 @@ properties:
 
   clock-names:
     minItems: 2
-    maxItems: 4
     items:
       - const: hosc
       - const: losc
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-apq8064.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-apq8064.yaml
index eacccc88bbf6..8e2eac6cbfb9 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-apq8064.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-apq8064.yaml
@@ -46,7 +46,6 @@ properties:
 
   nvmem-cell-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: calib
       - const: calib_backup
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sdx55.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sdx55.yaml
index 1121b3934cb9..b0d1c65aa354 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sdx55.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sdx55.yaml
@@ -27,7 +27,6 @@ properties:
       - description: Sleep clock source
       - description: PLL test clock source (Optional clock)
     minItems: 2
-    maxItems: 3
 
   clock-names:
     items:
@@ -35,7 +34,6 @@ properties:
       - const: sleep_clk
       - const: core_bi_pll_test_se # Optional clock
     minItems: 2
-    maxItems: 3
 
   '#clock-cells':
     const: 1
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sm8350.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sm8350.yaml
index 78f35832aa41..1122700dcc2b 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sm8350.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sm8350.yaml
@@ -36,7 +36,6 @@ properties:
       - description: USB3 phy wrapper pipe clock source (Optional clock)
       - description: USB3 phy sec pipe clock source (Optional clock)
     minItems: 2
-    maxItems: 13
 
   clock-names:
     items:
@@ -54,7 +53,6 @@ properties:
       - const: usb3_phy_wrapper_gcc_usb30_pipe_clk # Optional clock
       - const: usb3_uni_phy_sec_gcc_usb30_pipe_clk # Optional clock
     minItems: 2
-    maxItems: 13
 
   '#clock-cells':
     const: 1
diff --git a/Documentation/devicetree/bindings/clock/sprd,sc9863a-clk.yaml b/Documentation/devicetree/bindings/clock/sprd,sc9863a-clk.yaml
index 4069e09cb62d..47e1ab08c95d 100644
--- a/Documentation/devicetree/bindings/clock/sprd,sc9863a-clk.yaml
+++ b/Documentation/devicetree/bindings/clock/sprd,sc9863a-clk.yaml
@@ -40,7 +40,6 @@ properties:
 
   clock-names:
     minItems: 1
-    maxItems: 4
     items:
       - const: ext-26m
       - const: ext-32k
diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
index 6ab07eba7778..00648f9d9278 100644
--- a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
@@ -30,7 +30,6 @@ properties:
       - description: Module clock
       - description: MBus clock
     minItems: 2
-    maxItems: 3
 
   clock-names:
     items:
@@ -38,7 +37,6 @@ properties:
       - const: mod
       - const: ram
     minItems: 2
-    maxItems: 3
 
   resets:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/crypto/fsl-dcp.yaml b/Documentation/devicetree/bindings/crypto/fsl-dcp.yaml
index a30bf38a4a49..99be01539fcd 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-dcp.yaml
+++ b/Documentation/devicetree/bindings/crypto/fsl-dcp.yaml
@@ -27,7 +27,6 @@ properties:
       - description: MXS DCP DCP interrupt
       - description: MXS DCP secure interrupt
     minItems: 2
-    maxItems: 3
 
   clocks:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-display-backend.yaml b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-display-backend.yaml
index 12a7df0e38b2..3d8ea3c2d8dd 100644
--- a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-display-backend.yaml
+++ b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-display-backend.yaml
@@ -26,14 +26,12 @@ properties:
 
   reg:
     minItems: 1
-    maxItems: 2
     items:
       - description: Display Backend registers
       - description: SAT registers
 
   reg-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: be
       - const: sat
@@ -43,7 +41,6 @@ properties:
 
   clocks:
     minItems: 3
-    maxItems: 4
     items:
       - description: The backend interface clock
       - description: The backend module clock
@@ -52,7 +49,6 @@ properties:
 
   clock-names:
     minItems: 3
-    maxItems: 4
     items:
       - const: ahb
       - const: mod
@@ -61,14 +57,12 @@ properties:
 
   resets:
     minItems: 1
-    maxItems: 2
     items:
       - description: The Backend reset line
       - description: The SAT reset line
 
   reset-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: be
       - const: sat
diff --git a/Documentation/devicetree/bindings/display/allwinner,sun6i-a31-mipi-dsi.yaml b/Documentation/devicetree/bindings/display/allwinner,sun6i-a31-mipi-dsi.yaml
index a738d7c12a97..bf0bdf54e5f9 100644
--- a/Documentation/devicetree/bindings/display/allwinner,sun6i-a31-mipi-dsi.yaml
+++ b/Documentation/devicetree/bindings/display/allwinner,sun6i-a31-mipi-dsi.yaml
@@ -24,7 +24,6 @@ properties:
 
   clocks:
     minItems: 1
-    maxItems: 2
     items:
       - description: Bus Clock
       - description: Module Clock
diff --git a/Documentation/devicetree/bindings/display/allwinner,sun8i-a83t-dw-hdmi.yaml b/Documentation/devicetree/bindings/display/allwinner,sun8i-a83t-dw-hdmi.yaml
index 907fb47cc84a..5d42d36608d9 100644
--- a/Documentation/devicetree/bindings/display/allwinner,sun8i-a83t-dw-hdmi.yaml
+++ b/Documentation/devicetree/bindings/display/allwinner,sun8i-a83t-dw-hdmi.yaml
@@ -46,7 +46,6 @@ properties:
 
   clocks:
     minItems: 3
-    maxItems: 6
     items:
       - description: Bus Clock
       - description: Register Clock
@@ -57,7 +56,6 @@ properties:
 
   clock-names:
     minItems: 3
-    maxItems: 6
     items:
       - const: iahb
       - const: isfr
@@ -68,14 +66,12 @@ properties:
 
   resets:
     minItems: 1
-    maxItems: 2
     items:
       - description: HDMI Controller Reset
       - description: HDCP Reset
 
   reset-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: ctrl
       - const: hdcp
diff --git a/Documentation/devicetree/bindings/display/allwinner,sun8i-a83t-hdmi-phy.yaml b/Documentation/devicetree/bindings/display/allwinner,sun8i-a83t-hdmi-phy.yaml
index 501cec16168c..a97366aaf924 100644
--- a/Documentation/devicetree/bindings/display/allwinner,sun8i-a83t-hdmi-phy.yaml
+++ b/Documentation/devicetree/bindings/display/allwinner,sun8i-a83t-hdmi-phy.yaml
@@ -27,7 +27,6 @@ properties:
 
   clocks:
     minItems: 2
-    maxItems: 4
     items:
       - description: Bus Clock
       - description: Module Clock
@@ -36,7 +35,6 @@ properties:
 
   clock-names:
     minItems: 2
-    maxItems: 4
     items:
       - const: bus
       - const: mod
diff --git a/Documentation/devicetree/bindings/display/allwinner,sun8i-r40-tcon-top.yaml b/Documentation/devicetree/bindings/display/allwinner,sun8i-r40-tcon-top.yaml
index ec21e8bf2767..61ef7b337218 100644
--- a/Documentation/devicetree/bindings/display/allwinner,sun8i-r40-tcon-top.yaml
+++ b/Documentation/devicetree/bindings/display/allwinner,sun8i-r40-tcon-top.yaml
@@ -48,7 +48,6 @@ properties:
 
   clocks:
     minItems: 2
-    maxItems: 6
     items:
       - description: The TCON TOP interface clock
       - description: The TCON TOP TV0 clock
@@ -59,7 +58,6 @@ properties:
 
   clock-names:
     minItems: 2
-    maxItems: 6
     items:
       - const: bus
       - const: tcon-tv0
diff --git a/Documentation/devicetree/bindings/display/bridge/cdns,mhdp8546.yaml b/Documentation/devicetree/bindings/display/bridge/cdns,mhdp8546.yaml
index 63427878715e..9a3208a15137 100644
--- a/Documentation/devicetree/bindings/display/bridge/cdns,mhdp8546.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/cdns,mhdp8546.yaml
@@ -18,7 +18,6 @@ properties:
 
   reg:
     minItems: 1
-    maxItems: 2
     items:
       - description:
           Register block of mhdptx apb registers up to PHY mapped area (AUX_CONFIG_P).
@@ -29,7 +28,6 @@ properties:
 
   reg-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: mhdptx
       - const: j721e-intg
diff --git a/Documentation/devicetree/bindings/display/rockchip/rockchip,dw-hdmi.yaml b/Documentation/devicetree/bindings/display/rockchip/rockchip,dw-hdmi.yaml
index 75cd9c686e98..da3b889ad8fc 100644
--- a/Documentation/devicetree/bindings/display/rockchip/rockchip,dw-hdmi.yaml
+++ b/Documentation/devicetree/bindings/display/rockchip/rockchip,dw-hdmi.yaml
@@ -29,7 +29,6 @@ properties:
 
   clocks:
     minItems: 2
-    maxItems: 5
     items:
       - {}
       - {}
@@ -41,7 +40,6 @@ properties:
 
   clock-names:
     minItems: 2
-    maxItems: 5
     items:
       - {}
       - {}
diff --git a/Documentation/devicetree/bindings/display/st,stm32-dsi.yaml b/Documentation/devicetree/bindings/display/st,stm32-dsi.yaml
index 679daed4124e..ed310bbe3afe 100644
--- a/Documentation/devicetree/bindings/display/st,stm32-dsi.yaml
+++ b/Documentation/devicetree/bindings/display/st,stm32-dsi.yaml
@@ -29,7 +29,6 @@ properties:
       - description: DSI bus clock
       - description: Pixel clock
     minItems: 2
-    maxItems: 3
 
   clock-names:
     items:
@@ -37,7 +36,6 @@ properties:
       - const: ref
       - const: px_clk
     minItems: 2
-    maxItems: 3
 
   resets:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/display/st,stm32-ltdc.yaml b/Documentation/devicetree/bindings/display/st,stm32-ltdc.yaml
index d54f9ca207af..4ae3d75492d3 100644
--- a/Documentation/devicetree/bindings/display/st,stm32-ltdc.yaml
+++ b/Documentation/devicetree/bindings/display/st,stm32-ltdc.yaml
@@ -22,7 +22,6 @@ properties:
       - description: events interrupt line.
       - description: errors interrupt line.
     minItems: 1
-    maxItems: 2
 
   clocks:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/display/xlnx/xlnx,zynqmp-dpsub.yaml b/Documentation/devicetree/bindings/display/xlnx/xlnx,zynqmp-dpsub.yaml
index 403d57977ee7..d88bd93f4b80 100644
--- a/Documentation/devicetree/bindings/display/xlnx/xlnx,zynqmp-dpsub.yaml
+++ b/Documentation/devicetree/bindings/display/xlnx/xlnx,zynqmp-dpsub.yaml
@@ -65,7 +65,6 @@ properties:
       The APB clock and at least one video clock are mandatory, the audio clock
       is optional.
     minItems: 2
-    maxItems: 4
     items:
       - description: dp_apb_clk is the APB clock
       - description: dp_aud_clk is the Audio clock
@@ -78,13 +77,11 @@ properties:
   clock-names:
     oneOf:
       - minItems: 2
-        maxItems: 3
         items:
           - const: dp_apb_clk
           - enum: [ dp_vtc_pixel_clk_in, dp_live_video_in_clk ]
           - enum: [ dp_vtc_pixel_clk_in, dp_live_video_in_clk ]
       - minItems: 3
-        maxItems: 4
         items:
           - const: dp_apb_clk
           - const: dp_aud_clk
@@ -116,7 +113,6 @@ properties:
     maxItems: 2
   phy-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: dp-phy0
       - const: dp-phy1
diff --git a/Documentation/devicetree/bindings/dma/renesas,rcar-dmac.yaml b/Documentation/devicetree/bindings/dma/renesas,rcar-dmac.yaml
index 7f2a54bc732d..d8142cbd13d3 100644
--- a/Documentation/devicetree/bindings/dma/renesas,rcar-dmac.yaml
+++ b/Documentation/devicetree/bindings/dma/renesas,rcar-dmac.yaml
@@ -52,7 +52,6 @@ properties:
 
   interrupt-names:
     minItems: 9
-    maxItems: 17
     items:
       - const: error
       - pattern: "^ch([0-9]|1[0-5])$"
diff --git a/Documentation/devicetree/bindings/edac/amazon,al-mc-edac.yaml b/Documentation/devicetree/bindings/edac/amazon,al-mc-edac.yaml
index 57e5270a0741..4cfc3a187004 100644
--- a/Documentation/devicetree/bindings/edac/amazon,al-mc-edac.yaml
+++ b/Documentation/devicetree/bindings/edac/amazon,al-mc-edac.yaml
@@ -30,14 +30,12 @@ properties:
 
   interrupts:
     minItems: 1
-    maxItems: 2
     items:
       - description: uncorrectable error interrupt
       - description: correctable error interrupt
 
   interrupt-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: ue
       - const: ce
diff --git a/Documentation/devicetree/bindings/eeprom/at24.yaml b/Documentation/devicetree/bindings/eeprom/at24.yaml
index 021d8ae42da3..914a423ec449 100644
--- a/Documentation/devicetree/bindings/eeprom/at24.yaml
+++ b/Documentation/devicetree/bindings/eeprom/at24.yaml
@@ -32,7 +32,6 @@ properties:
     oneOf:
       - allOf:
           - minItems: 1
-            maxItems: 2
             items:
               - pattern: "^(atmel|catalyst|microchip|nxp|ramtron|renesas|rohm|st),(24(c|cs|lc|mac)[0-9]+|spd)$"
               - pattern: "^atmel,(24(c|cs|mac)[0-9]+|spd)$"
diff --git a/Documentation/devicetree/bindings/example-schema.yaml b/Documentation/devicetree/bindings/example-schema.yaml
index a97f39109f8d..ff6ec65145cf 100644
--- a/Documentation/devicetree/bindings/example-schema.yaml
+++ b/Documentation/devicetree/bindings/example-schema.yaml
@@ -91,7 +91,6 @@ properties:
   interrupts:
     # Either 1 or 2 interrupts can be present
     minItems: 1
-    maxItems: 2
     items:
       - description: tx or combined interrupt
       - description: rx interrupt
@@ -105,7 +104,6 @@ properties:
   interrupt-names:
     # minItems must be specified here because the default would be 2
     minItems: 1
-    maxItems: 2
     items:
       - const: tx irq
       - const: rx irq
diff --git a/Documentation/devicetree/bindings/gpu/brcm,bcm-v3d.yaml b/Documentation/devicetree/bindings/gpu/brcm,bcm-v3d.yaml
index 9d72264fa90a..e6485f7b046f 100644
--- a/Documentation/devicetree/bindings/gpu/brcm,bcm-v3d.yaml
+++ b/Documentation/devicetree/bindings/gpu/brcm,bcm-v3d.yaml
@@ -34,7 +34,6 @@ properties:
       - enum: [ bridge, gca ]
       - enum: [ bridge, gca ]
     minItems: 2
-    maxItems: 4
 
   interrupts:
     items:
diff --git a/Documentation/devicetree/bindings/gpu/vivante,gc.yaml b/Documentation/devicetree/bindings/gpu/vivante,gc.yaml
index 3ed172629974..93e7244cdc0e 100644
--- a/Documentation/devicetree/bindings/gpu/vivante,gc.yaml
+++ b/Documentation/devicetree/bindings/gpu/vivante,gc.yaml
@@ -36,7 +36,6 @@ properties:
       - description: AHB/slave interface clock (only required if GPU can gate
           slave interface independently)
     minItems: 1
-    maxItems: 4
 
   clock-names:
     items:
diff --git a/Documentation/devicetree/bindings/i2c/brcm,brcmstb-i2c.yaml b/Documentation/devicetree/bindings/i2c/brcm,brcmstb-i2c.yaml
index edbca2476128..7070c04469ed 100644
--- a/Documentation/devicetree/bindings/i2c/brcm,brcmstb-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/brcm,brcmstb-i2c.yaml
@@ -21,7 +21,6 @@ properties:
 
   reg:
     minItems: 1
-    maxItems: 2
     items:
       - description: BSC register range
       - description: Auto-I2C register range
diff --git a/Documentation/devicetree/bindings/i2c/marvell,mv64xxx-i2c.yaml b/Documentation/devicetree/bindings/i2c/marvell,mv64xxx-i2c.yaml
index eb72dd571def..f771c09aabfc 100644
--- a/Documentation/devicetree/bindings/i2c/marvell,mv64xxx-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/marvell,mv64xxx-i2c.yaml
@@ -43,14 +43,12 @@ properties:
 
   clocks:
     minItems: 1
-    maxItems: 2
     items:
       - description: Reference clock for the I2C bus
       - description: Bus clock (Only for Armada 7K/8K)
 
   clock-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: core
       - const: reg
diff --git a/Documentation/devicetree/bindings/i2c/mellanox,i2c-mlxbf.yaml b/Documentation/devicetree/bindings/i2c/mellanox,i2c-mlxbf.yaml
index d2b401d062b9..93198d5d43a6 100644
--- a/Documentation/devicetree/bindings/i2c/mellanox,i2c-mlxbf.yaml
+++ b/Documentation/devicetree/bindings/i2c/mellanox,i2c-mlxbf.yaml
@@ -20,7 +20,6 @@ properties:
 
   reg:
     minItems: 3
-    maxItems: 4
     items:
       - description: Smbus block registers
       - description: Cause master registers
diff --git a/Documentation/devicetree/bindings/iio/adc/amlogic,meson-saradc.yaml b/Documentation/devicetree/bindings/iio/adc/amlogic,meson-saradc.yaml
index 3be8955587e4..7e8328e9ce13 100644
--- a/Documentation/devicetree/bindings/iio/adc/amlogic,meson-saradc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/amlogic,meson-saradc.yaml
@@ -41,7 +41,6 @@ properties:
 
   clock-names:
     minItems: 2
-    maxItems: 4
     items:
       - const: clkin
       - const: core
diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
index 1e7894e524f9..733351dee252 100644
--- a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
@@ -38,14 +38,12 @@ properties:
           dfsdm clock can also feed CLKOUT, when CLKOUT is used.
       - description: audio clock can be used as an alternate to feed CLKOUT.
     minItems: 1
-    maxItems: 2
 
   clock-names:
     items:
       - const: dfsdm
       - const: audio
     minItems: 1
-    maxItems: 2
 
   "#address-cells":
     const: 1
diff --git a/Documentation/devicetree/bindings/interrupt-controller/fsl,irqsteer.yaml b/Documentation/devicetree/bindings/interrupt-controller/fsl,irqsteer.yaml
index 3b11a1a15398..bcb5e20fa9ca 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/fsl,irqsteer.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/fsl,irqsteer.yaml
@@ -35,7 +35,6 @@ properties:
       - description: output interrupt 6
       - description: output interrupt 7
     minItems: 1
-    maxItems: 8
 
   clocks:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/interrupt-controller/loongson,liointc.yaml b/Documentation/devicetree/bindings/interrupt-controller/loongson,liointc.yaml
index 067165c4b836..edf26452dc72 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/loongson,liointc.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/loongson,liointc.yaml
@@ -50,7 +50,6 @@ properties:
       - const: int2
       - const: int3
     minItems: 1
-    maxItems: 4
 
   '#interrupt-cells':
     const: 2
diff --git a/Documentation/devicetree/bindings/iommu/arm,smmu-v3.yaml b/Documentation/devicetree/bindings/iommu/arm,smmu-v3.yaml
index 5951c6f98c74..e87bfbcc6913 100644
--- a/Documentation/devicetree/bindings/iommu/arm,smmu-v3.yaml
+++ b/Documentation/devicetree/bindings/iommu/arm,smmu-v3.yaml
@@ -38,7 +38,6 @@ properties:
           If provided, then the combined interrupt will be used in preference to
           any others.
       - minItems: 2
-        maxItems: 4
         items:
           - const: eventq     # Event Queue not empty
           - const: gerror     # Global Error activated
diff --git a/Documentation/devicetree/bindings/iommu/renesas,ipmmu-vmsa.yaml b/Documentation/devicetree/bindings/iommu/renesas,ipmmu-vmsa.yaml
index dda44976acc1..02c69a95c332 100644
--- a/Documentation/devicetree/bindings/iommu/renesas,ipmmu-vmsa.yaml
+++ b/Documentation/devicetree/bindings/iommu/renesas,ipmmu-vmsa.yaml
@@ -49,7 +49,6 @@ properties:
 
   interrupts:
     minItems: 1
-    maxItems: 2
     description:
       Specifiers for the MMU fault interrupts. Not required for cache IPMMUs.
     items:
diff --git a/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml b/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml
index 3b7ab61a144f..b15da9ba90b2 100644
--- a/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml
+++ b/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml
@@ -32,7 +32,6 @@ properties:
       - description: tx channel free
       - description: wakeup source
     minItems: 2
-    maxItems: 3
 
   interrupt-names:
     items:
@@ -40,7 +39,6 @@ properties:
       - const: tx
       - const: wakeup
     minItems: 2
-    maxItems: 3
 
   wakeup-source: true
 
diff --git a/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml b/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml
index b902495d278b..5044c4bb94e0 100644
--- a/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml
+++ b/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml
@@ -67,7 +67,6 @@ properties:
 
   clock-names:
     minItems: 4
-    maxItems: 5
     items:
       - const: dos_parser
       - const: dos
diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.yaml b/Documentation/devicetree/bindings/media/i2c/adv7604.yaml
index df634b0c1f8c..de15cebe2955 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7604.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/adv7604.yaml
@@ -30,7 +30,6 @@ properties:
 
   reg-names:
     minItems: 1
-    maxItems: 13
     items:
       - const: main
       - enum: [ avlink, cec, infoframe, esdp, dpp, afe, rep, edid, hdmi, test, cp, vdp ]
diff --git a/Documentation/devicetree/bindings/media/marvell,mmp2-ccic.yaml b/Documentation/devicetree/bindings/media/marvell,mmp2-ccic.yaml
index c14c7d827b00..b39b84c5f012 100644
--- a/Documentation/devicetree/bindings/media/marvell,mmp2-ccic.yaml
+++ b/Documentation/devicetree/bindings/media/marvell,mmp2-ccic.yaml
@@ -43,7 +43,6 @@ properties:
 
   clocks:
     minItems: 1
-    maxItems: 3
     items:
       - description: AXI bus interface clock
       - description: Peripheral clock
diff --git a/Documentation/devicetree/bindings/media/qcom,sc7180-venus.yaml b/Documentation/devicetree/bindings/media/qcom,sc7180-venus.yaml
index 04013e5dd044..90b4af2c9724 100644
--- a/Documentation/devicetree/bindings/media/qcom,sc7180-venus.yaml
+++ b/Documentation/devicetree/bindings/media/qcom,sc7180-venus.yaml
@@ -30,7 +30,6 @@ properties:
 
   power-domain-names:
     minItems: 2
-    maxItems: 3
     items:
       - const: venus
       - const: vcodec0
diff --git a/Documentation/devicetree/bindings/media/qcom,sdm845-venus-v2.yaml b/Documentation/devicetree/bindings/media/qcom,sdm845-venus-v2.yaml
index 04b9af4db191..177bf81544b1 100644
--- a/Documentation/devicetree/bindings/media/qcom,sdm845-venus-v2.yaml
+++ b/Documentation/devicetree/bindings/media/qcom,sdm845-venus-v2.yaml
@@ -30,7 +30,6 @@ properties:
 
   power-domain-names:
     minItems: 3
-    maxItems: 4
     items:
       - const: venus
       - const: vcodec0
diff --git a/Documentation/devicetree/bindings/media/qcom,sm8250-venus.yaml b/Documentation/devicetree/bindings/media/qcom,sm8250-venus.yaml
index 7b81bd7f2399..ebf8f3d866a5 100644
--- a/Documentation/devicetree/bindings/media/qcom,sm8250-venus.yaml
+++ b/Documentation/devicetree/bindings/media/qcom,sm8250-venus.yaml
@@ -30,7 +30,6 @@ properties:
 
   power-domain-names:
     minItems: 2
-    maxItems: 3
     items:
       - const: venus
       - const: vcodec0
diff --git a/Documentation/devicetree/bindings/media/renesas,drif.yaml b/Documentation/devicetree/bindings/media/renesas,drif.yaml
index 9cd56ff2c316..817a6d566738 100644
--- a/Documentation/devicetree/bindings/media/renesas,drif.yaml
+++ b/Documentation/devicetree/bindings/media/renesas,drif.yaml
@@ -78,7 +78,6 @@ properties:
 
   dma-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: rx
       - const: rx
diff --git a/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-common.yaml b/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-common.yaml
index a08a32340987..e87e4382807c 100644
--- a/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-common.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-common.yaml
@@ -53,14 +53,12 @@ properties:
       apb and smi are mandatory. the async is only for generation 1 smi HW.
       gals(global async local sync) also is optional, see below.
     minItems: 2
-    maxItems: 4
     items:
       - description: apb is Advanced Peripheral Bus clock, It's the clock for
           setting the register.
       - description: smi is the clock for transfer data and command.
-      - description: async is asynchronous clock, it help transform the smi
-          clock into the emi clock domain.
-      - description: gals0 is the path0 clock of gals.
+      - description: Either asynchronous clock to help transform the smi clock
+          into the emi clock domain on Gen1 h/w, or the path0 clock of gals.
       - description: gals1 is the path1 clock of gals.
 
   clock-names:
diff --git a/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.yaml b/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.yaml
index 7ed7839ff0a7..2353f6cf3c80 100644
--- a/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.yaml
@@ -37,7 +37,6 @@ properties:
     description: |
       apb and smi are mandatory. gals(global async local sync) is optional.
     minItems: 2
-    maxItems: 3
     items:
       - description: apb is Advanced Peripheral Bus clock, It's the clock for
           setting the register.
diff --git a/Documentation/devicetree/bindings/mmc/allwinner,sun4i-a10-mmc.yaml b/Documentation/devicetree/bindings/mmc/allwinner,sun4i-a10-mmc.yaml
index e75b3a8ba816..4f62ad6ce50c 100644
--- a/Documentation/devicetree/bindings/mmc/allwinner,sun4i-a10-mmc.yaml
+++ b/Documentation/devicetree/bindings/mmc/allwinner,sun4i-a10-mmc.yaml
@@ -64,7 +64,6 @@ properties:
 
   clocks:
     minItems: 2
-    maxItems: 4
     items:
       - description: Bus Clock
       - description: Module Clock
@@ -73,7 +72,6 @@ properties:
 
   clock-names:
     minItems: 2
-    maxItems: 4
     items:
       - const: ahb
       - const: mmc
diff --git a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
index 369471814496..b5baf439fbac 100644
--- a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
+++ b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
@@ -116,7 +116,6 @@ properties:
 
   pinctrl-names:
     minItems: 1
-    maxItems: 4
     items:
       - const: default
       - const: state_100mhz
diff --git a/Documentation/devicetree/bindings/mmc/mtk-sd.yaml b/Documentation/devicetree/bindings/mmc/mtk-sd.yaml
index 8648d48dbbfd..4e553fd0349f 100644
--- a/Documentation/devicetree/bindings/mmc/mtk-sd.yaml
+++ b/Documentation/devicetree/bindings/mmc/mtk-sd.yaml
@@ -38,7 +38,6 @@ properties:
     description:
       Should contain phandle for the clock feeding the MMC controller.
     minItems: 2
-    maxItems: 8
     items:
       - description: source clock (required).
       - description: HCLK which used for host (required).
@@ -51,7 +50,6 @@ properties:
 
   clock-names:
     minItems: 2
-    maxItems: 8
     items:
       - const: source
       - const: hclk
diff --git a/Documentation/devicetree/bindings/mmc/renesas,sdhi.yaml b/Documentation/devicetree/bindings/mmc/renesas,sdhi.yaml
index 1118b6fa93c9..677989bc5924 100644
--- a/Documentation/devicetree/bindings/mmc/renesas,sdhi.yaml
+++ b/Documentation/devicetree/bindings/mmc/renesas,sdhi.yaml
@@ -75,7 +75,6 @@ properties:
 
   clock-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: core
       - const: cd
@@ -107,7 +106,6 @@ properties:
 
   pinctrl-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: default
       - const: state_uhs
diff --git a/Documentation/devicetree/bindings/mmc/sdhci-am654.yaml b/Documentation/devicetree/bindings/mmc/sdhci-am654.yaml
index 3a79e39253d2..94a96174f99a 100644
--- a/Documentation/devicetree/bindings/mmc/sdhci-am654.yaml
+++ b/Documentation/devicetree/bindings/mmc/sdhci-am654.yaml
@@ -45,7 +45,6 @@ properties:
 
   clock-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: clk_ahb
       - const: clk_xin
diff --git a/Documentation/devicetree/bindings/mmc/sdhci-pxa.yaml b/Documentation/devicetree/bindings/mmc/sdhci-pxa.yaml
index aa12480648a5..1c87f4218e18 100644
--- a/Documentation/devicetree/bindings/mmc/sdhci-pxa.yaml
+++ b/Documentation/devicetree/bindings/mmc/sdhci-pxa.yaml
@@ -57,7 +57,6 @@ properties:
 
   clock-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: io
       - const: core
diff --git a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
index 0467441d7037..608e1d62bed5 100644
--- a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
@@ -43,7 +43,6 @@ allOf:
       properties:
         clocks:
           minItems: 3
-          maxItems: 4
           items:
             - description: GMAC main clock
             - description: First parent clock of the internal mux
@@ -52,7 +51,6 @@ allOf:
 
         clock-names:
           minItems: 3
-          maxItems: 4
           items:
             - const: stmmaceth
             - const: clkin0
diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
index 2f46e45dcd60..a93d2f165899 100644
--- a/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
+++ b/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
@@ -23,14 +23,12 @@ properties:
 
   interrupts:
     minItems: 1
-    maxItems: 2
     items:
       - description: RX interrupt
       - description: TX interrupt
 
   interrupt-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: rx
       - const: tx
diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
index 798fa5fb7bb2..f84e31348d80 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
@@ -30,14 +30,12 @@ properties:
       - description: interrupt line0
       - description: interrupt line1
     minItems: 1
-    maxItems: 2
 
   interrupt-names:
     items:
       - const: int0
       - const: int1
     minItems: 1
-    maxItems: 2
 
   clocks:
     items:
diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
index d730fe5a4355..d159ac78cec1 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
@@ -48,14 +48,12 @@ properties:
 
   clocks:
     minItems: 1
-    maxItems: 2
     items:
       - description: switch's main clock
       - description: dividing of the switch core clock
 
   clock-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: sw_switch
       - const: sw_switch_mdiv
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 2edd8bea993e..5d4b028e5620 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -82,7 +82,6 @@ properties:
 
   interrupts:
     minItems: 1
-    maxItems: 3
     items:
       - description: Combined signal for various interrupt events
       - description: The interrupt to manage the remote wake-up packet detection
@@ -90,7 +89,6 @@ properties:
 
   interrupt-names:
     minItems: 1
-    maxItems: 3
     items:
       - const: macirq
       - const: eth_wake_irq
diff --git a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
index 27eb6066793f..19c7bd482a51 100644
--- a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
@@ -46,7 +46,6 @@ properties:
 
   clocks:
     minItems: 3
-    maxItems: 5
     items:
       - description: GMAC main clock
       - description: MAC TX clock
diff --git a/Documentation/devicetree/bindings/pci/brcm,stb-pcie.yaml b/Documentation/devicetree/bindings/pci/brcm,stb-pcie.yaml
index f90557f6deb8..b9589a0daa5c 100644
--- a/Documentation/devicetree/bindings/pci/brcm,stb-pcie.yaml
+++ b/Documentation/devicetree/bindings/pci/brcm,stb-pcie.yaml
@@ -25,14 +25,12 @@ properties:
 
   interrupts:
     minItems: 1
-    maxItems: 2
     items:
       - description: PCIe host controller
       - description: builtin MSI controller
 
   interrupt-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: pcie
       - const: msi
diff --git a/Documentation/devicetree/bindings/pci/loongson.yaml b/Documentation/devicetree/bindings/pci/loongson.yaml
index 81bae060cbde..82bc6c486ca3 100644
--- a/Documentation/devicetree/bindings/pci/loongson.yaml
+++ b/Documentation/devicetree/bindings/pci/loongson.yaml
@@ -24,7 +24,6 @@ properties:
 
   reg:
     minItems: 1
-    maxItems: 2
     items:
       - description: CFG0 standard config space register
       - description: CFG1 extended config space register
diff --git a/Documentation/devicetree/bindings/pci/mediatek-pcie-gen3.yaml b/Documentation/devicetree/bindings/pci/mediatek-pcie-gen3.yaml
index e7b1f9892da4..742206dbd965 100644
--- a/Documentation/devicetree/bindings/pci/mediatek-pcie-gen3.yaml
+++ b/Documentation/devicetree/bindings/pci/mediatek-pcie-gen3.yaml
@@ -70,7 +70,6 @@ properties:
 
   reset-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: phy
       - const: mac
diff --git a/Documentation/devicetree/bindings/pci/microchip,pcie-host.yaml b/Documentation/devicetree/bindings/pci/microchip,pcie-host.yaml
index 04251d71f56b..fb95c276a986 100644
--- a/Documentation/devicetree/bindings/pci/microchip,pcie-host.yaml
+++ b/Documentation/devicetree/bindings/pci/microchip,pcie-host.yaml
@@ -26,14 +26,12 @@ properties:
 
   interrupts:
     minItems: 1
-    maxItems: 2
     items:
       - description: PCIe host controller
       - description: builtin MSI controller
 
   interrupt-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: pcie
       - const: msi
diff --git a/Documentation/devicetree/bindings/perf/arm,cmn.yaml b/Documentation/devicetree/bindings/perf/arm,cmn.yaml
index e4fcc0de25e2..42424ccbdd0c 100644
--- a/Documentation/devicetree/bindings/perf/arm,cmn.yaml
+++ b/Documentation/devicetree/bindings/perf/arm,cmn.yaml
@@ -21,7 +21,6 @@ properties:
 
   interrupts:
     minItems: 1
-    maxItems: 4
     items:
       - description: Overflow interrupt for DTC0
       - description: Overflow interrupt for DTC1
diff --git a/Documentation/devicetree/bindings/phy/brcm,bcm63xx-usbh-phy.yaml b/Documentation/devicetree/bindings/phy/brcm,bcm63xx-usbh-phy.yaml
index 9a2e779e6d38..0f0bcde9eb88 100644
--- a/Documentation/devicetree/bindings/phy/brcm,bcm63xx-usbh-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/brcm,bcm63xx-usbh-phy.yaml
@@ -28,7 +28,6 @@ properties:
 
   clock-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: usbh
       - const: usb_ref
diff --git a/Documentation/devicetree/bindings/phy/brcm,brcmstb-usb-phy.yaml b/Documentation/devicetree/bindings/phy/brcm,brcmstb-usb-phy.yaml
index 5f9e91bfb5ff..43a4b880534c 100644
--- a/Documentation/devicetree/bindings/phy/brcm,brcmstb-usb-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/brcm,brcmstb-usb-phy.yaml
@@ -22,7 +22,6 @@ properties:
 
   reg:
     minItems: 1
-    maxItems: 6
     items:
       - description: the base CTRL register
       - description: XHCI EC register
@@ -33,7 +32,6 @@ properties:
 
   reg-names:
     minItems: 1
-    maxItems: 6
     items:
       - const: ctrl
       - const: xhci_ec
@@ -51,7 +49,6 @@ properties:
 
   clock-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: sw_usb
       - const: sw_usb3
diff --git a/Documentation/devicetree/bindings/phy/brcm,sata-phy.yaml b/Documentation/devicetree/bindings/phy/brcm,sata-phy.yaml
index 04edda504ab6..cb1aa325336f 100644
--- a/Documentation/devicetree/bindings/phy/brcm,sata-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/brcm,sata-phy.yaml
@@ -35,7 +35,6 @@ properties:
 
   reg-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: phy
       - const: phy-ctrl
diff --git a/Documentation/devicetree/bindings/phy/mediatek,tphy.yaml b/Documentation/devicetree/bindings/phy/mediatek,tphy.yaml
index b8a7651a3d9a..ef9d9d4e6875 100644
--- a/Documentation/devicetree/bindings/phy/mediatek,tphy.yaml
+++ b/Documentation/devicetree/bindings/phy/mediatek,tphy.yaml
@@ -131,7 +131,6 @@ patternProperties:
 
       clocks:
         minItems: 1
-        maxItems: 2
         items:
           - description: Reference clock, (HS is 48Mhz, SS/P is 24~27Mhz)
           - description: Reference clock of analog phy
@@ -141,7 +140,6 @@ patternProperties:
 
       clock-names:
         minItems: 1
-        maxItems: 2
         items:
           - const: ref
           - const: da_ref
diff --git a/Documentation/devicetree/bindings/phy/phy-cadence-sierra.yaml b/Documentation/devicetree/bindings/phy/phy-cadence-sierra.yaml
index 84383e2e0b34..e71b32c9c0d1 100644
--- a/Documentation/devicetree/bindings/phy/phy-cadence-sierra.yaml
+++ b/Documentation/devicetree/bindings/phy/phy-cadence-sierra.yaml
@@ -31,14 +31,12 @@ properties:
 
   resets:
     minItems: 1
-    maxItems: 2
     items:
       - description: Sierra PHY reset.
       - description: Sierra APB reset. This is optional.
 
   reset-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: sierra_reset
       - const: sierra_apb
diff --git a/Documentation/devicetree/bindings/phy/phy-cadence-torrent.yaml b/Documentation/devicetree/bindings/phy/phy-cadence-torrent.yaml
index 320a232c7208..bd9ae11c9994 100644
--- a/Documentation/devicetree/bindings/phy/phy-cadence-torrent.yaml
+++ b/Documentation/devicetree/bindings/phy/phy-cadence-torrent.yaml
@@ -52,28 +52,24 @@ properties:
 
   reg:
     minItems: 1
-    maxItems: 2
     items:
       - description: Offset of the Torrent PHY configuration registers.
       - description: Offset of the DPTX PHY configuration registers.
 
   reg-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: torrent_phy
       - const: dptx_phy
 
   resets:
     minItems: 1
-    maxItems: 2
     items:
       - description: Torrent PHY reset.
       - description: Torrent APB reset. This is optional.
 
   reset-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: torrent_reset
       - const: torrent_apb
diff --git a/Documentation/devicetree/bindings/phy/qcom,ipq806x-usb-phy-hs.yaml b/Documentation/devicetree/bindings/phy/qcom,ipq806x-usb-phy-hs.yaml
index 17f132ce5516..35296c588e78 100644
--- a/Documentation/devicetree/bindings/phy/qcom,ipq806x-usb-phy-hs.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,ipq806x-usb-phy-hs.yaml
@@ -30,7 +30,6 @@ properties:
 
   clock-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: ref
       - const: xo
diff --git a/Documentation/devicetree/bindings/phy/qcom,ipq806x-usb-phy-ss.yaml b/Documentation/devicetree/bindings/phy/qcom,ipq806x-usb-phy-ss.yaml
index 17fd7f6b83bb..6cf5c6c06072 100644
--- a/Documentation/devicetree/bindings/phy/qcom,ipq806x-usb-phy-ss.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,ipq806x-usb-phy-ss.yaml
@@ -30,7 +30,6 @@ properties:
 
   clock-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: ref
       - const: xo
diff --git a/Documentation/devicetree/bindings/phy/qcom,qmp-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,qmp-phy.yaml
index 7808ec8bc712..a2de5202eb5e 100644
--- a/Documentation/devicetree/bindings/phy/qcom,qmp-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,qmp-phy.yaml
@@ -49,7 +49,6 @@ properties:
 
   reg:
     minItems: 1
-    maxItems: 2
     items:
       - description: Address and length of PHY's common serdes block.
       - description: Address and length of PHY's DP_COM control block.
diff --git a/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml
index 9f9cf07b7d45..930da598c969 100644
--- a/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml
@@ -36,7 +36,6 @@ properties:
 
   clocks:
     minItems: 2
-    maxItems: 3
     items:
       - description: phy config clock
       - description: 19.2 MHz ref clk
@@ -44,7 +43,6 @@ properties:
 
   clock-names:
     minItems: 2
-    maxItems: 3
     items:
       - const: cfg_ahb
       - const: ref
diff --git a/Documentation/devicetree/bindings/phy/renesas,usb2-phy.yaml b/Documentation/devicetree/bindings/phy/renesas,usb2-phy.yaml
index 0f358d5b84ef..d5dc5a3cdceb 100644
--- a/Documentation/devicetree/bindings/phy/renesas,usb2-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/renesas,usb2-phy.yaml
@@ -39,7 +39,6 @@ properties:
 
   clock-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: fck
       - const: usb_x1
@@ -61,7 +60,6 @@ properties:
 
   resets:
     minItems: 1
-    maxItems: 2
     items:
       - description: reset of USB 2.0 host side
       - description: reset of USB 2.0 peripheral side
diff --git a/Documentation/devicetree/bindings/phy/renesas,usb3-phy.yaml b/Documentation/devicetree/bindings/phy/renesas,usb3-phy.yaml
index f3ef738a3ff6..b8483f9edbfc 100644
--- a/Documentation/devicetree/bindings/phy/renesas,usb3-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/renesas,usb3-phy.yaml
@@ -33,7 +33,6 @@ properties:
     # If you want to use the ssc, the clock-frequency of usb_extal
     # must not be 0.
     minItems: 2
-    maxItems: 3
     items:
       - const: usb3-if # The funcional clock
       - const: usb3s_clk # The usb3's external clock
diff --git a/Documentation/devicetree/bindings/pinctrl/actions,s500-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/actions,s500-pinctrl.yaml
index ccdd9e3820d7..3f94f6944740 100644
--- a/Documentation/devicetree/bindings/pinctrl/actions,s500-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/actions,s500-pinctrl.yaml
@@ -26,7 +26,6 @@ properties:
       - description: PAD Pull Control + PAD Schmitt Trigger Enable + PAD Control
       - description: PAD Drive Capacity Select
     minItems: 1
-    maxItems: 4
 
   clocks:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml b/Documentation/devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml
index d30f85cc395e..f005abac7079 100644
--- a/Documentation/devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml
+++ b/Documentation/devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml
@@ -37,7 +37,6 @@ properties:
 
   clock-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: vpu
       - const: vapb
diff --git a/Documentation/devicetree/bindings/pwm/allwinner,sun4i-a10-pwm.yaml b/Documentation/devicetree/bindings/pwm/allwinner,sun4i-a10-pwm.yaml
index 7dcab2bf8128..54a7700df08f 100644
--- a/Documentation/devicetree/bindings/pwm/allwinner,sun4i-a10-pwm.yaml
+++ b/Documentation/devicetree/bindings/pwm/allwinner,sun4i-a10-pwm.yaml
@@ -37,7 +37,6 @@ properties:
 
   clocks:
     minItems: 1
-    maxItems: 2
     items:
       - description: Module Clock
       - description: Bus Clock
diff --git a/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml b/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
index 64afdcfb613d..1e6225677e00 100644
--- a/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
@@ -72,7 +72,6 @@ properties:
             - from local to remote, where ACK from the remote means that communnication
               as been stopped on the remote side.
     minItems: 1
-    maxItems: 4
 
   mbox-names:
     items:
@@ -81,7 +80,6 @@ properties:
       - const: shutdown
       - const: detach
     minItems: 1
-    maxItems: 4
 
   memory-region:
     description:
diff --git a/Documentation/devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml b/Documentation/devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml
index 6070456a7b67..f399743b631b 100644
--- a/Documentation/devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml
@@ -57,7 +57,6 @@ properties:
 
   memory-region:
     minItems: 2
-    maxItems: 8
     description: |
       phandle to the reserved memory nodes to be associated with the remoteproc
       device. There should be at least two reserved memory nodes defined. The
diff --git a/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml b/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
index 73400bc6e91d..75161f191ac3 100644
--- a/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
@@ -116,7 +116,6 @@ properties:
       list, in the specified order, each representing the corresponding
       internal RAM memory region.
     minItems: 1
-    maxItems: 3
     items:
       - const: l2ram
       - const: l1pram
diff --git a/Documentation/devicetree/bindings/reset/fsl,imx-src.yaml b/Documentation/devicetree/bindings/reset/fsl,imx-src.yaml
index 27c5e34a3ac6..b11ac533f914 100644
--- a/Documentation/devicetree/bindings/reset/fsl,imx-src.yaml
+++ b/Documentation/devicetree/bindings/reset/fsl,imx-src.yaml
@@ -59,7 +59,6 @@ properties:
       - description: SRC interrupt
       - description: CPU WDOG interrupts out of SRC
     minItems: 1
-    maxItems: 2
 
   '#reset-cells':
     const: 1
diff --git a/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml b/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
index 23b227614366..1d38ff76d18f 100644
--- a/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
+++ b/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
@@ -56,7 +56,6 @@ properties:
 
   interrupts:
     minItems: 3
-    maxItems: 4
     items:
       - description: DirError interrupt
       - description: DataError interrupt
diff --git a/Documentation/devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml b/Documentation/devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml
index b1b0ee769b71..beeb90e55727 100644
--- a/Documentation/devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml
+++ b/Documentation/devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml
@@ -32,7 +32,6 @@ properties:
 
   interrupts:
     minItems: 1
-    maxItems: 2
     items:
       - description: RTC Alarm 0
       - description: RTC Alarm 1
diff --git a/Documentation/devicetree/bindings/rtc/imxdi-rtc.yaml b/Documentation/devicetree/bindings/rtc/imxdi-rtc.yaml
index 06bd737821c1..4807c95a663c 100644
--- a/Documentation/devicetree/bindings/rtc/imxdi-rtc.yaml
+++ b/Documentation/devicetree/bindings/rtc/imxdi-rtc.yaml
@@ -21,7 +21,6 @@ properties:
       - description: rtc alarm interrupt
       - description: dryice security violation interrupt
     minItems: 1
-    maxItems: 2
 
   clocks:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/serial/fsl-lpuart.yaml b/Documentation/devicetree/bindings/serial/fsl-lpuart.yaml
index bd21060d26e0..a90c971b4f1f 100644
--- a/Documentation/devicetree/bindings/serial/fsl-lpuart.yaml
+++ b/Documentation/devicetree/bindings/serial/fsl-lpuart.yaml
@@ -36,14 +36,12 @@ properties:
       - description: ipg clock
       - description: baud clock
     minItems: 1
-    maxItems: 2
 
   clock-names:
     items:
       - const: ipg
       - const: baud
     minItems: 1
-    maxItems: 2
 
   dmas:
     items:
diff --git a/Documentation/devicetree/bindings/serial/samsung_uart.yaml b/Documentation/devicetree/bindings/serial/samsung_uart.yaml
index 97ec8a093bf3..3ec3822bd114 100644
--- a/Documentation/devicetree/bindings/serial/samsung_uart.yaml
+++ b/Documentation/devicetree/bindings/serial/samsung_uart.yaml
@@ -44,7 +44,6 @@ properties:
   clock-names:
     description: N = 0 is allowed for SoCs without internal baud clock mux.
     minItems: 2
-    maxItems: 5
     items:
       - const: uart
       - pattern: '^clk_uart_baud[0-3]$'
diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml b/Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml
index 84671950ca0d..4663c2bcad50 100644
--- a/Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml
@@ -164,7 +164,6 @@ patternProperties:
 
       interrupts:
         minItems: 1
-        maxItems: 2
         items:
           - description: UART core irq
           - description: Wakeup irq (RX GPIO)
diff --git a/Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml b/Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml
index dbc62821c60b..9790617af1bc 100644
--- a/Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml
+++ b/Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml
@@ -100,7 +100,6 @@ patternProperties:
     properties:
       reg:
         minItems: 2 # On AM437x one of two PRUSS units don't contain Shared RAM.
-        maxItems: 3
         items:
           - description: Address and size of the Data RAM0.
           - description: Address and size of the Data RAM1.
@@ -111,7 +110,6 @@ patternProperties:
 
       reg-names:
         minItems: 2
-        maxItems: 3
         items:
           - const: dram0
           - const: dram1
diff --git a/Documentation/devicetree/bindings/sound/nvidia,tegra-audio-graph-card.yaml b/Documentation/devicetree/bindings/sound/nvidia,tegra-audio-graph-card.yaml
index 249970952202..5bdd30a8a404 100644
--- a/Documentation/devicetree/bindings/sound/nvidia,tegra-audio-graph-card.yaml
+++ b/Documentation/devicetree/bindings/sound/nvidia,tegra-audio-graph-card.yaml
@@ -28,7 +28,6 @@ properties:
     minItems: 2
 
   clock-names:
-    minItems: 2
     items:
       - const: pll_a
       - const: plla_out0
diff --git a/Documentation/devicetree/bindings/sound/nvidia,tegra210-i2s.yaml b/Documentation/devicetree/bindings/sound/nvidia,tegra210-i2s.yaml
index 38e52e7dbb40..63370709c768 100644
--- a/Documentation/devicetree/bindings/sound/nvidia,tegra210-i2s.yaml
+++ b/Documentation/devicetree/bindings/sound/nvidia,tegra210-i2s.yaml
@@ -34,7 +34,6 @@ properties:
 
   clocks:
     minItems: 1
-    maxItems: 2
     items:
       - description: I2S bit clock
       - description:
@@ -48,7 +47,6 @@ properties:
 
   clock-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: i2s
       - const: sync_input
diff --git a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
index f2443b651282..06e83461705c 100644
--- a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
+++ b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
@@ -26,7 +26,6 @@ properties:
       - description: Base address and size of SAI common register set.
       - description: Base address and size of SAI identification register set.
     minItems: 1
-    maxItems: 2
 
   ranges:
     maxItems: 1
@@ -81,14 +80,12 @@ patternProperties:
           - description: sai_ck clock feeding the internal clock generator.
           - description: MCLK clock from a SAI set as master clock provider.
         minItems: 1
-        maxItems: 2
 
       clock-names:
         items:
           - const: sai_ck
           - const: MCLK
         minItems: 1
-        maxItems: 2
 
       dmas:
         maxItems: 1
diff --git a/Documentation/devicetree/bindings/spi/amlogic,meson-gx-spicc.yaml b/Documentation/devicetree/bindings/spi/amlogic,meson-gx-spicc.yaml
index e3fb553d9180..4d46c49ec32b 100644
--- a/Documentation/devicetree/bindings/spi/amlogic,meson-gx-spicc.yaml
+++ b/Documentation/devicetree/bindings/spi/amlogic,meson-gx-spicc.yaml
@@ -35,7 +35,6 @@ properties:
 
   clocks:
     minItems: 1
-    maxItems: 2
     items:
       - description: controller register bus clock
       - description: baud rate generator and delay control clock
diff --git a/Documentation/devicetree/bindings/spi/brcm,spi-bcm-qspi.yaml b/Documentation/devicetree/bindings/spi/brcm,spi-bcm-qspi.yaml
index 6ee19d49fd3c..ec5873919170 100644
--- a/Documentation/devicetree/bindings/spi/brcm,spi-bcm-qspi.yaml
+++ b/Documentation/devicetree/bindings/spi/brcm,spi-bcm-qspi.yaml
@@ -56,7 +56,6 @@ properties:
 
   reg-names:
     minItems: 1
-    maxItems: 5
     items:
       - const: mspi
       - const: bspi
@@ -71,7 +70,6 @@ properties:
   interrupt-names:
     oneOf:
       - minItems: 1
-        maxItems: 7
         items:
           - const: mspi_done
           - const: mspi_halted
diff --git a/Documentation/devicetree/bindings/thermal/allwinner,sun8i-a83t-ths.yaml b/Documentation/devicetree/bindings/thermal/allwinner,sun8i-a83t-ths.yaml
index bf97d1fb33e7..6e0b110153b0 100644
--- a/Documentation/devicetree/bindings/thermal/allwinner,sun8i-a83t-ths.yaml
+++ b/Documentation/devicetree/bindings/thermal/allwinner,sun8i-a83t-ths.yaml
@@ -23,14 +23,12 @@ properties:
 
   clocks:
     minItems: 1
-    maxItems: 2
     items:
       - description: Bus Clock
       - description: Module Clock
 
   clock-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: bus
       - const: mod
diff --git a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
index 0242fd91b622..0b3b6af7bd5b 100644
--- a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
+++ b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
@@ -77,7 +77,6 @@ properties:
 
   nvmem-cell-names:
     minItems: 1
-    maxItems: 2
     items:
       - const: calib
       - enum:
diff --git a/Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.yaml b/Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.yaml
index b6a6d03a08b2..2ecac754e1cd 100644
--- a/Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.yaml
+++ b/Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.yaml
@@ -24,7 +24,6 @@ properties:
 
   interrupts:
     minItems: 2
-    maxItems: 4
     items:
       - description: Timer 0 Interrupt
       - description: Timer 1 Interrupt
diff --git a/Documentation/devicetree/bindings/timer/arm,arch_timer.yaml b/Documentation/devicetree/bindings/timer/arm,arch_timer.yaml
index 7f5e3af58255..df8ce87fd54b 100644
--- a/Documentation/devicetree/bindings/timer/arm,arch_timer.yaml
+++ b/Documentation/devicetree/bindings/timer/arm,arch_timer.yaml
@@ -35,7 +35,6 @@ properties:
 
   interrupts:
     minItems: 1
-    maxItems: 5
     items:
       - description: secure timer irq
       - description: non-secure timer irq
diff --git a/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml b/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
index d83a1f97f911..cd2176cad53a 100644
--- a/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
+++ b/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
@@ -71,14 +71,12 @@ patternProperties:
 
       interrupts:
         minItems: 1
-        maxItems: 2
         items:
           - description: physical timer irq
           - description: virtual timer irq
 
       reg:
         minItems: 1
-        maxItems: 2
         items:
           - description: 1st view base address
           - description: 2nd optional view base address
diff --git a/Documentation/devicetree/bindings/timer/intel,ixp4xx-timer.yaml b/Documentation/devicetree/bindings/timer/intel,ixp4xx-timer.yaml
index a8de99b0c0f9..f32575d4b5aa 100644
--- a/Documentation/devicetree/bindings/timer/intel,ixp4xx-timer.yaml
+++ b/Documentation/devicetree/bindings/timer/intel,ixp4xx-timer.yaml
@@ -22,7 +22,6 @@ properties:
 
   interrupts:
     minItems: 1
-    maxItems: 2
     items:
       - description: Timer 1 interrupt
       - description: Timer 2 interrupt
diff --git a/Documentation/devicetree/bindings/usb/maxim,max3420-udc.yaml b/Documentation/devicetree/bindings/usb/maxim,max3420-udc.yaml
index 4241d38d5864..1d893d3d3432 100644
--- a/Documentation/devicetree/bindings/usb/maxim,max3420-udc.yaml
+++ b/Documentation/devicetree/bindings/usb/maxim,max3420-udc.yaml
@@ -30,14 +30,12 @@ properties:
       - description: usb irq from max3420
       - description: vbus detection irq
     minItems: 1
-    maxItems: 2
 
   interrupt-names:
     items:
       - const: udc
       - const: vbus
     minItems: 1
-    maxItems: 2
 
   spi-max-frequency:
     maximum: 26000000
diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml b/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml
index e60e590dbe12..8428415896ce 100644
--- a/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml
+++ b/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml
@@ -25,7 +25,6 @@ properties:
 
   reg:
     minItems: 2
-    maxItems: 3
     items:
       - description: XUSB device controller registers
       - description: XUSB device PCI Config registers
@@ -33,7 +32,6 @@ properties:
 
   reg-names:
     minItems: 2
-    maxItems: 3
     items:
       - const: base
       - const: fpci
@@ -45,7 +43,6 @@ properties:
 
   clocks:
     minItems: 4
-    maxItems: 5
     items:
       - description: Clock to enable core XUSB dev clock.
       - description: Clock to enable XUSB super speed clock.
@@ -55,7 +52,6 @@ properties:
 
   clock-names:
     minItems: 4
-    maxItems: 5
     items:
       - const: dev
       - const: ss
diff --git a/Documentation/devicetree/bindings/usb/renesas,usbhs.yaml b/Documentation/devicetree/bindings/usb/renesas,usbhs.yaml
index e67223d90bb7..ad73339ffe1d 100644
--- a/Documentation/devicetree/bindings/usb/renesas,usbhs.yaml
+++ b/Documentation/devicetree/bindings/usb/renesas,usbhs.yaml
@@ -53,7 +53,6 @@ properties:
 
   clocks:
     minItems: 1
-    maxItems: 3
     items:
       - description: USB 2.0 host
       - description: USB 2.0 peripheral
@@ -86,7 +85,6 @@ properties:
 
   dma-names:
     minItems: 2
-    maxItems: 4
     items:
       - const: ch0
       - const: ch1
@@ -100,7 +98,6 @@ properties:
 
   resets:
     minItems: 1
-    maxItems: 2
     items:
       - description: USB 2.0 host
       - description: USB 2.0 peripheral
diff --git a/Documentation/devicetree/bindings/watchdog/st,stm32-iwdg.yaml b/Documentation/devicetree/bindings/watchdog/st,stm32-iwdg.yaml
index 3f1ba1d6c6b5..481bf91f988a 100644
--- a/Documentation/devicetree/bindings/watchdog/st,stm32-iwdg.yaml
+++ b/Documentation/devicetree/bindings/watchdog/st,stm32-iwdg.yaml
@@ -27,7 +27,6 @@ properties:
       - description: Low speed clock
       - description: Optional peripheral clock
     minItems: 1
-    maxItems: 2
 
   clock-names:
     items:
-- 
2.27.0

