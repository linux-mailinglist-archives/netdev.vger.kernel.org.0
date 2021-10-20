Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C703E434583
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 08:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhJTGxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 02:53:22 -0400
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:46114 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229591AbhJTGxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 02:53:16 -0400
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K4uMIC032519;
        Wed, 20 Oct 2021 08:50:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=selector1;
 bh=d4eDhb7LwUr1Kug0aDxGf6CJ3t+uXvLurRzDSaMbW7g=;
 b=OEn+f9/hZj3FzXfsnJPDeyg6v7rBprfMNT4KoFVtT3fsKLrcQ8SXFiokNvehuB7+bCK/
 LHTGAeNx5noKjMy+JXB8kGrYunskzqNKCwQWTv7+sfi1AunpeFPCaI0xHKx4NcC7NUOe
 t7/GUVbJVjl6dHdO/S/onUHU4psId1KUOF7LbqcfzcK3i5FGG20XC74bWyK1Vq1NRTut
 wryzcAqEkti2SMa0eCXfC/JcEOV2AUv/QFfcvXfGOhkuNTUApNM4Ah6SIs5DTwcpzwgG
 ggBJAuJ2kwlSZBo3uKoU/Ep4WEzW2gpgNaU5e3LBmZUTovDQTft+g8imm3SzIGFJH1XF Vg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 3bt22k3fgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 08:50:20 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 1EA0510002A;
        Wed, 20 Oct 2021 08:50:17 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id CAF27212311;
        Wed, 20 Oct 2021 08:50:17 +0200 (CEST)
Received: from localhost (10.75.127.46) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 20 Oct 2021 08:50:17
 +0200
From:   <patrice.chotard@foss.st.com>
To:     Rob Herring <robh+dt@kernel.org>,
        maxime coquelin <mcoquelin.stm32@gmail.com>,
        alexandre torgue <alexandre.torgue@foss.st.com>,
        michael turquette <mturquette@baylibre.com>,
        stephen boyd <sboyd@kernel.org>,
        herbert xu <herbert@gondor.apana.org.au>,
        "david s . miller" <davem@davemloft.net>,
        david airlie <airlied@linux.ie>,
        daniel vetter <daniel@ffwll.ch>,
        thierry reding <thierry.reding@gmail.com>,
        sam ravnborg <sam@ravnborg.org>,
        yannick fertre <yannick.fertre@foss.st.com>,
        "philippe cornu" <philippe.cornu@foss.st.com>,
        benjamin gaignard <benjamin.gaignard@linaro.org>,
        vinod koul <vkoul@kernel.org>,
        ohad ben-cohen <ohad@wizery.com>,
        bjorn andersson <bjorn.andersson@linaro.org>,
        baolin wang <baolin.wang7@gmail.com>,
        jonathan cameron <jic23@kernel.org>,
        "lars-peter clausen" <lars@metafoo.de>,
        olivier moysan <olivier.moysan@foss.st.com>,
        arnaud pouliquen <arnaud.pouliquen@foss.st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hugues Fruchet <hugues.fruchet@foss.st.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Lee Jones <lee.jones@linaro.org>,
        "Miquel Raynal" <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        "Alessandro Zummo" <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Jagan Teki <jagan@amarulasolutions.com>,
        "dillon min" <dillon.minfei@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Christophe Roullier <christophe.roullier@foss.st.com>,
        Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
        Ludovic Barre <ludovic.barre@foss.st.com>,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        pascal Paillet <p.paillet@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "Jose Abreu" <joabreu@synopsys.com>,
        Le Ray <erwan.leray@foss.st.com>
CC:     <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-clk@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <dmaengine@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-media@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-phy@lists.infradead.org>,
        <linux-gpio@vger.kernel.org>, <linux-rtc@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <linux-spi@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-watchdog@vger.kernel.org>
Subject: dt-bindings: treewide: Update @st.com email address to @foss.st.com
Date:   Wed, 20 Oct 2021 08:50:00 +0200
Message-ID: <20211020065000.21312-1-patrice.chotard@foss.st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.46]
X-ClientProxiedBy: SFHDAG1NODE3.st.com (10.75.127.3) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_02,2021-10-19_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patrice Chotard <patrice.chotard@foss.st.com>

Not all @st.com email address are concerned, only people who have
a specific @foss.st.com email will see their entry updated.
For some people, who left the company, remove their email.

Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
---
 Documentation/devicetree/bindings/arm/sti.yaml                | 2 +-
 Documentation/devicetree/bindings/arm/stm32/st,mlahb.yaml     | 4 ++--
 .../devicetree/bindings/arm/stm32/st,stm32-syscon.yaml        | 4 ++--
 Documentation/devicetree/bindings/arm/stm32/stm32.yaml        | 2 +-
 Documentation/devicetree/bindings/clock/st,stm32mp1-rcc.yaml  | 2 +-
 Documentation/devicetree/bindings/crypto/st,stm32-crc.yaml    | 2 +-
 Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml   | 2 +-
 Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml   | 2 +-
 .../devicetree/bindings/display/bridge/snps,dw-mipi-dsi.yaml  | 2 +-
 .../devicetree/bindings/display/panel/orisetech,otm8009a.yaml | 2 +-
 .../devicetree/bindings/display/panel/raydium,rm68200.yaml    | 2 +-
 Documentation/devicetree/bindings/display/st,stm32-dsi.yaml   | 4 ++--
 Documentation/devicetree/bindings/display/st,stm32-ltdc.yaml  | 4 ++--
 Documentation/devicetree/bindings/dma/st,stm32-dma.yaml       | 2 +-
 Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml    | 2 +-
 Documentation/devicetree/bindings/dma/st,stm32-mdma.yaml      | 2 +-
 .../devicetree/bindings/hwlock/st,stm32-hwspinlock.yaml       | 3 +--
 Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml       | 2 +-
 .../devicetree/bindings/iio/adc/sigma-delta-modulator.yaml    | 2 +-
 Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml   | 2 +-
 .../devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml       | 4 ++--
 Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml   | 2 +-
 .../bindings/interrupt-controller/st,stm32-exti.yaml          | 4 ++--
 Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml  | 4 ++--
 Documentation/devicetree/bindings/media/st,stm32-cec.yaml     | 3 +--
 Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml    | 2 +-
 .../bindings/memory-controllers/st,stm32-fmc2-ebi.yaml        | 2 +-
 Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml   | 2 +-
 Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml    | 3 +--
 Documentation/devicetree/bindings/mfd/st,stmfx.yaml           | 2 +-
 Documentation/devicetree/bindings/mfd/st,stpmic1.yaml         | 2 +-
 Documentation/devicetree/bindings/mtd/st,stm32-fmc2-nand.yaml | 2 +-
 Documentation/devicetree/bindings/net/snps,dwmac.yaml         | 2 +-
 Documentation/devicetree/bindings/net/stm32-dwmac.yaml        | 4 ++--
 Documentation/devicetree/bindings/nvmem/st,stm32-romem.yaml   | 2 +-
 Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml  | 2 +-
 .../devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml         | 2 +-
 .../devicetree/bindings/regulator/st,stm32-booster.yaml       | 2 +-
 .../devicetree/bindings/regulator/st,stm32-vrefbuf.yaml       | 2 +-
 .../devicetree/bindings/regulator/st,stm32mp1-pwr-reg.yaml    | 2 +-
 .../devicetree/bindings/remoteproc/st,stm32-rproc.yaml        | 4 ++--
 Documentation/devicetree/bindings/rng/st,stm32-rng.yaml       | 2 +-
 Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml       | 2 +-
 Documentation/devicetree/bindings/serial/st,stm32-uart.yaml   | 2 +-
 Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml   | 2 +-
 Documentation/devicetree/bindings/sound/st,stm32-i2s.yaml     | 2 +-
 Documentation/devicetree/bindings/sound/st,stm32-sai.yaml     | 2 +-
 Documentation/devicetree/bindings/sound/st,stm32-spdifrx.yaml | 2 +-
 Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml      | 4 ++--
 Documentation/devicetree/bindings/spi/st,stm32-spi.yaml       | 4 ++--
 .../devicetree/bindings/thermal/st,stm32-thermal.yaml         | 2 +-
 Documentation/devicetree/bindings/timer/st,stm32-timer.yaml   | 3 ++-
 Documentation/devicetree/bindings/usb/st,stusb160x.yaml       | 2 +-
 Documentation/devicetree/bindings/watchdog/st,stm32-iwdg.yaml | 4 ++--
 54 files changed, 67 insertions(+), 69 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/sti.yaml b/Documentation/devicetree/bindings/arm/sti.yaml
index b1f28d16d3fb..a41cd8764885 100644
--- a/Documentation/devicetree/bindings/arm/sti.yaml
+++ b/Documentation/devicetree/bindings/arm/sti.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: ST STi Platforms Device Tree Bindings
 
 maintainers:
-  - Patrice Chotard <patrice.chotard@st.com>
+  - Patrice Chotard <patrice.chotard@foss.st.com>
 
 properties:
   $nodename:
diff --git a/Documentation/devicetree/bindings/arm/stm32/st,mlahb.yaml b/Documentation/devicetree/bindings/arm/stm32/st,mlahb.yaml
index 8e711bd202fd..ecb28e90fd11 100644
--- a/Documentation/devicetree/bindings/arm/stm32/st,mlahb.yaml
+++ b/Documentation/devicetree/bindings/arm/stm32/st,mlahb.yaml
@@ -7,8 +7,8 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: STMicroelectronics STM32 ML-AHB interconnect bindings
 
 maintainers:
-  - Fabien Dessenne <fabien.dessenne@st.com>
-  - Arnaud Pouliquen <arnaud.pouliquen@st.com>
+  - Fabien Dessenne <fabien.dessenne@foss.st.com>
+  - Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
 
 description: |
   These bindings describe the STM32 SoCs ML-AHB interconnect bus which connects
diff --git a/Documentation/devicetree/bindings/arm/stm32/st,stm32-syscon.yaml b/Documentation/devicetree/bindings/arm/stm32/st,stm32-syscon.yaml
index 149afb5df5af..6f846d69c5e1 100644
--- a/Documentation/devicetree/bindings/arm/stm32/st,stm32-syscon.yaml
+++ b/Documentation/devicetree/bindings/arm/stm32/st,stm32-syscon.yaml
@@ -7,8 +7,8 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: STMicroelectronics STM32 Platforms System Controller bindings
 
 maintainers:
-  - Alexandre Torgue <alexandre.torgue@st.com>
-  - Christophe Roullier <christophe.roullier@st.com>
+  - Alexandre Torgue <alexandre.torgue@foss.st.com>
+  - Christophe Roullier <christophe.roullier@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/arm/stm32/stm32.yaml b/Documentation/devicetree/bindings/arm/stm32/stm32.yaml
index 9a77ab74be99..e33fbb62b430 100644
--- a/Documentation/devicetree/bindings/arm/stm32/stm32.yaml
+++ b/Documentation/devicetree/bindings/arm/stm32/stm32.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 Platforms Device Tree Bindings
 
 maintainers:
-  - Alexandre Torgue <alexandre.torgue@st.com>
+  - Alexandre Torgue <alexandre.torgue@foss.st.com>
 
 properties:
   $nodename:
diff --git a/Documentation/devicetree/bindings/clock/st,stm32mp1-rcc.yaml b/Documentation/devicetree/bindings/clock/st,stm32mp1-rcc.yaml
index 8b1ecb2ecdd5..a0ae4867ed27 100644
--- a/Documentation/devicetree/bindings/clock/st,stm32mp1-rcc.yaml
+++ b/Documentation/devicetree/bindings/clock/st,stm32mp1-rcc.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Reset Clock Controller Binding
 
 maintainers:
-  - Gabriel Fernandez <gabriel.fernandez@st.com>
+  - Gabriel Fernandez <gabriel.fernandez@foss.st.com>
 
 description: |
   The RCC IP is both a reset and a clock controller.
diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-crc.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-crc.yaml
index cee624c14f07..b72e4858f9aa 100644
--- a/Documentation/devicetree/bindings/crypto/st,stm32-crc.yaml
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-crc.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 CRC bindings
 
 maintainers:
-  - Lionel Debieve <lionel.debieve@st.com>
+  - Lionel Debieve <lionel.debieve@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
index a4574552502a..ed23bf94a8e0 100644
--- a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 CRYP bindings
 
 maintainers:
-  - Lionel Debieve <lionel.debieve@st.com>
+  - Lionel Debieve <lionel.debieve@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
index 6dd658f0912c..10ba94792d95 100644
--- a/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 HASH bindings
 
 maintainers:
-  - Lionel Debieve <lionel.debieve@st.com>
+  - Lionel Debieve <lionel.debieve@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/display/bridge/snps,dw-mipi-dsi.yaml b/Documentation/devicetree/bindings/display/bridge/snps,dw-mipi-dsi.yaml
index 3c3e51af154b..11fd68a70dca 100644
--- a/Documentation/devicetree/bindings/display/bridge/snps,dw-mipi-dsi.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/snps,dw-mipi-dsi.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Synopsys DesignWare MIPI DSI host controller
 
 maintainers:
-  - Philippe CORNU <philippe.cornu@st.com>
+  - Philippe CORNU <philippe.cornu@foss.st.com>
 
 description: |
   This document defines device tree properties for the Synopsys DesignWare MIPI
diff --git a/Documentation/devicetree/bindings/display/panel/orisetech,otm8009a.yaml b/Documentation/devicetree/bindings/display/panel/orisetech,otm8009a.yaml
index 4b6dda6dbc0f..17cbd0ad32bf 100644
--- a/Documentation/devicetree/bindings/display/panel/orisetech,otm8009a.yaml
+++ b/Documentation/devicetree/bindings/display/panel/orisetech,otm8009a.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Orise Tech OTM8009A 3.97" 480x800 TFT LCD panel (MIPI-DSI video mode)
 
 maintainers:
-  - Philippe CORNU <philippe.cornu@st.com>
+  - Philippe CORNU <philippe.cornu@foss.st.com>
 
 description: |
              The Orise Tech OTM8009A is a 3.97" 480x800 TFT LCD panel connected using
diff --git a/Documentation/devicetree/bindings/display/panel/raydium,rm68200.yaml b/Documentation/devicetree/bindings/display/panel/raydium,rm68200.yaml
index 39477793d289..e8ce2315631a 100644
--- a/Documentation/devicetree/bindings/display/panel/raydium,rm68200.yaml
+++ b/Documentation/devicetree/bindings/display/panel/raydium,rm68200.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Raydium Semiconductor Corporation RM68200 5.5" 720p MIPI-DSI TFT LCD panel
 
 maintainers:
-  - Philippe CORNU <philippe.cornu@st.com>
+  - Philippe CORNU <philippe.cornu@foss.st.com>
 
 description: |
   The Raydium Semiconductor Corporation RM68200 is a 5.5" 720x1280 TFT LCD
diff --git a/Documentation/devicetree/bindings/display/st,stm32-dsi.yaml b/Documentation/devicetree/bindings/display/st,stm32-dsi.yaml
index ed310bbe3afe..ce1ef93cce93 100644
--- a/Documentation/devicetree/bindings/display/st,stm32-dsi.yaml
+++ b/Documentation/devicetree/bindings/display/st,stm32-dsi.yaml
@@ -7,8 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 DSI host controller
 
 maintainers:
-  - Philippe Cornu <philippe.cornu@st.com>
-  - Yannick Fertre <yannick.fertre@st.com>
+  - Philippe Cornu <philippe.cornu@foss.st.com>
+  - Yannick Fertre <yannick.fertre@foss.st.com>
 
 description:
   The STMicroelectronics STM32 DSI controller uses the Synopsys DesignWare MIPI-DSI host controller.
diff --git a/Documentation/devicetree/bindings/display/st,stm32-ltdc.yaml b/Documentation/devicetree/bindings/display/st,stm32-ltdc.yaml
index 4ae3d75492d3..01e2da23790b 100644
--- a/Documentation/devicetree/bindings/display/st,stm32-ltdc.yaml
+++ b/Documentation/devicetree/bindings/display/st,stm32-ltdc.yaml
@@ -7,8 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 lcd-tft display controller
 
 maintainers:
-  - Philippe Cornu <philippe.cornu@st.com>
-  - Yannick Fertre <yannick.fertre@st.com>
+  - Philippe Cornu <philippe.cornu@foss.st.com>
+  - Yannick Fertre <yannick.fertre@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/dma/st,stm32-dma.yaml b/Documentation/devicetree/bindings/dma/st,stm32-dma.yaml
index 4bf676fd25dc..55faab6a468e 100644
--- a/Documentation/devicetree/bindings/dma/st,stm32-dma.yaml
+++ b/Documentation/devicetree/bindings/dma/st,stm32-dma.yaml
@@ -50,7 +50,7 @@ description: |
 
 
 maintainers:
-  - Amelie Delaunay <amelie.delaunay@st.com>
+  - Amelie Delaunay <amelie.delaunay@foss.st.com>
 
 allOf:
   - $ref: "dma-controller.yaml#"
diff --git a/Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml b/Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml
index c8d2b51d8410..f751796531c9 100644
--- a/Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml
+++ b/Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 DMA MUX (DMA request router) bindings
 
 maintainers:
-  - Amelie Delaunay <amelie.delaunay@st.com>
+  - Amelie Delaunay <amelie.delaunay@foss.st.com>
 
 allOf:
   - $ref: "dma-router.yaml#"
diff --git a/Documentation/devicetree/bindings/dma/st,stm32-mdma.yaml b/Documentation/devicetree/bindings/dma/st,stm32-mdma.yaml
index c30be840be1c..87b4afd2cf62 100644
--- a/Documentation/devicetree/bindings/dma/st,stm32-mdma.yaml
+++ b/Documentation/devicetree/bindings/dma/st,stm32-mdma.yaml
@@ -50,7 +50,7 @@ description: |
        if no HW ack signal is used by the MDMA client
 
 maintainers:
-  - Amelie Delaunay <amelie.delaunay@st.com>
+  - Amelie Delaunay <amelie.delaunay@foss.st.com>
 
 allOf:
   - $ref: "dma-controller.yaml#"
diff --git a/Documentation/devicetree/bindings/hwlock/st,stm32-hwspinlock.yaml b/Documentation/devicetree/bindings/hwlock/st,stm32-hwspinlock.yaml
index 47cf9c8d97e9..b18c616035a8 100644
--- a/Documentation/devicetree/bindings/hwlock/st,stm32-hwspinlock.yaml
+++ b/Documentation/devicetree/bindings/hwlock/st,stm32-hwspinlock.yaml
@@ -7,8 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 Hardware Spinlock bindings
 
 maintainers:
-  - Benjamin Gaignard <benjamin.gaignard@st.com>
-  - Fabien Dessenne <fabien.dessenne@st.com>
+  - Fabien Dessenne <fabien.dessenne@foss.st.com>
 
 properties:
   "#hwlock-cells":
diff --git a/Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml b/Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml
index d747f4990ad8..c07289a643d8 100644
--- a/Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: I2C controller embedded in STMicroelectronics STM32 I2C platform
 
 maintainers:
-  - Pierre-Yves MORDRET <pierre-yves.mordret@st.com>
+  - Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>
 
 allOf:
   - $ref: /schemas/i2c/i2c-controller.yaml#
diff --git a/Documentation/devicetree/bindings/iio/adc/sigma-delta-modulator.yaml b/Documentation/devicetree/bindings/iio/adc/sigma-delta-modulator.yaml
index a390343d0c2a..2287697f1f61 100644
--- a/Documentation/devicetree/bindings/iio/adc/sigma-delta-modulator.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/sigma-delta-modulator.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Device-Tree bindings for sigma delta modulator
 
 maintainers:
-  - Arnaud Pouliquen <arnaud.pouliquen@st.com>
+  - Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
index a58334c3bb76..a055c78cc047 100644
--- a/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
@@ -19,7 +19,7 @@ description: |
   Each STM32 ADC block can have up to 3 ADC instances.
 
 maintainers:
-  - Fabrice Gasnier <fabrice.gasnier@st.com>
+  - Fabrice Gasnier <fabrice.gasnier@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
index 733351dee252..7c260f209687 100644
--- a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
@@ -7,8 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 DFSDM ADC device driver
 
 maintainers:
-  - Fabrice Gasnier <fabrice.gasnier@st.com>
-  - Olivier Moysan <olivier.moysan@st.com>
+  - Fabrice Gasnier <fabrice.gasnier@foss.st.com>
+  - Olivier Moysan <olivier.moysan@foss.st.com>
 
 description: |
   STM32 DFSDM ADC is a sigma delta analog-to-digital converter dedicated to
diff --git a/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml b/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml
index 393f7005941a..6adeda4087fc 100644
--- a/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml
+++ b/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml
@@ -15,7 +15,7 @@ description: |
   current.
 
 maintainers:
-  - Fabrice Gasnier <fabrice.gasnier@st.com>
+  - Fabrice Gasnier <fabrice.gasnier@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/interrupt-controller/st,stm32-exti.yaml b/Documentation/devicetree/bindings/interrupt-controller/st,stm32-exti.yaml
index 6d3e68eb2e8b..d19c881b4abc 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/st,stm32-exti.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/st,stm32-exti.yaml
@@ -7,8 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STM32 External Interrupt Controller Device Tree Bindings
 
 maintainers:
-  - Alexandre Torgue <alexandre.torgue@st.com>
-  - Ludovic Barre <ludovic.barre@st.com>
+  - Alexandre Torgue <alexandre.torgue@foss.st.com>
+  - Ludovic Barre <ludovic.barre@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml b/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml
index b15da9ba90b2..8eb4bf52ea27 100644
--- a/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml
+++ b/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml
@@ -13,8 +13,8 @@ description:
   channels (N) can be read from a dedicated register.
 
 maintainers:
-  - Fabien Dessenne <fabien.dessenne@st.com>
-  - Arnaud Pouliquen <arnaud.pouliquen@st.com>
+  - Fabien Dessenne <fabien.dessenne@foss.st.com>
+  - Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/media/st,stm32-cec.yaml b/Documentation/devicetree/bindings/media/st,stm32-cec.yaml
index d75019c093a4..77144cc6f7db 100644
--- a/Documentation/devicetree/bindings/media/st,stm32-cec.yaml
+++ b/Documentation/devicetree/bindings/media/st,stm32-cec.yaml
@@ -7,8 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 CEC bindings
 
 maintainers:
-  - Benjamin Gaignard <benjamin.gaignard@st.com>
-  - Yannick Fertre <yannick.fertre@st.com>
+  - Yannick Fertre <yannick.fertre@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml b/Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml
index 41e1d0cd80e5..9c1262a276b5 100644
--- a/Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml
+++ b/Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 Digital Camera Memory Interface (DCMI) binding
 
 maintainers:
-  - Hugues Fruchet <hugues.fruchet@st.com>
+  - Hugues Fruchet <hugues.fruchet@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/memory-controllers/st,stm32-fmc2-ebi.yaml b/Documentation/devicetree/bindings/memory-controllers/st,stm32-fmc2-ebi.yaml
index cba74205846a..6b516d3895af 100644
--- a/Documentation/devicetree/bindings/memory-controllers/st,stm32-fmc2-ebi.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/st,stm32-fmc2-ebi.yaml
@@ -19,7 +19,7 @@ description: |
   Select. The FMC2 performs only one access at a time to an external device.
 
 maintainers:
-  - Christophe Kerello <christophe.kerello@st.com>
+  - Christophe Kerello <christophe.kerello@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml b/Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml
index 8bcea8dd7d90..ec7f0190f46e 100644
--- a/Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml
+++ b/Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml
@@ -17,7 +17,7 @@ description: |
      - simple counter from IN1 input signal.
 
 maintainers:
-  - Fabrice Gasnier <fabrice.gasnier@st.com>
+  - Fabrice Gasnier <fabrice.gasnier@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml b/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml
index dace35362a7a..10b330d42901 100644
--- a/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml
+++ b/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml
@@ -17,8 +17,7 @@ description: |
       programmable prescaler.
 
 maintainers:
-  - Benjamin Gaignard <benjamin.gaignard@st.com>
-  - Fabrice Gasnier <fabrice.gasnier@st.com>
+  - Fabrice Gasnier <fabrice.gasnier@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/mfd/st,stmfx.yaml b/Documentation/devicetree/bindings/mfd/st,stmfx.yaml
index 19e9afb385ac..b2a4e4aa7ff6 100644
--- a/Documentation/devicetree/bindings/mfd/st,stmfx.yaml
+++ b/Documentation/devicetree/bindings/mfd/st,stmfx.yaml
@@ -12,7 +12,7 @@ description: ST Multi-Function eXpander (STMFX) is a slave controller using I2C
                through VDD) and resistive touchscreen controller.
 
 maintainers:
-  - Amelie Delaunay <amelie.delaunay@st.com>
+  - Amelie Delaunay <amelie.delaunay@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml b/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
index 305123e74a58..426658ad81d4 100644
--- a/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
+++ b/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
@@ -9,7 +9,7 @@ title: STMicroelectonics STPMIC1 Power Management IC bindings
 description: STMicroelectronics STPMIC1 Power Management IC
 
 maintainers:
-  - pascal Paillet <p.paillet@st.com>
+  - pascal Paillet <p.paillet@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/mtd/st,stm32-fmc2-nand.yaml b/Documentation/devicetree/bindings/mtd/st,stm32-fmc2-nand.yaml
index 29c5ef24ac6a..eab8ea3da1fa 100644
--- a/Documentation/devicetree/bindings/mtd/st,stm32-fmc2-nand.yaml
+++ b/Documentation/devicetree/bindings/mtd/st,stm32-fmc2-nand.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics Flexible Memory Controller 2 (FMC2) Bindings
 
 maintainers:
-  - Christophe Kerello <christophe.kerello@st.com>
+  - Christophe Kerello <christophe.kerello@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 42689b7d03a2..a5c55127cc44 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Synopsys DesignWare MAC Device Tree Bindings
 
 maintainers:
-  - Alexandre Torgue <alexandre.torgue@st.com>
+  - Alexandre Torgue <alexandre.torgue@foss.st.com>
   - Giuseppe Cavallaro <peppe.cavallaro@st.com>
   - Jose Abreu <joabreu@synopsys.com>
 
diff --git a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
index d3f05d5934d5..577f4e284425 100644
--- a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
@@ -8,8 +8,8 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: STMicroelectronics STM32 / MCU DWMAC glue layer controller
 
 maintainers:
-  - Alexandre Torgue <alexandre.torgue@st.com>
-  - Christophe Roullier <christophe.roullier@st.com>
+  - Alexandre Torgue <alexandre.torgue@foss.st.com>
+  - Christophe Roullier <christophe.roullier@foss.st.com>
 
 description:
   This file documents platform glue layer for stmmac.
diff --git a/Documentation/devicetree/bindings/nvmem/st,stm32-romem.yaml b/Documentation/devicetree/bindings/nvmem/st,stm32-romem.yaml
index 0b80ce22a2f8..a48c8fa56bce 100644
--- a/Documentation/devicetree/bindings/nvmem/st,stm32-romem.yaml
+++ b/Documentation/devicetree/bindings/nvmem/st,stm32-romem.yaml
@@ -13,7 +13,7 @@ description: |
   internal vref (VREFIN_CAL), unique device ID...
 
 maintainers:
-  - Fabrice Gasnier <fabrice.gasnier@st.com>
+  - Fabrice Gasnier <fabrice.gasnier@foss.st.com>
 
 allOf:
   - $ref: "nvmem.yaml#"
diff --git a/Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml b/Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml
index 3329f1d33a4f..7bae8dff3ef6 100644
--- a/Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml
+++ b/Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml
@@ -24,7 +24,7 @@ description:
   |_ UTMI switch_______|          OTG controller
 
 maintainers:
-  - Amelie Delaunay <amelie.delaunay@st.com>
+  - Amelie Delaunay <amelie.delaunay@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml
index dfee6d38a701..ac88e01ec430 100644
--- a/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml
@@ -8,7 +8,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STM32 GPIO and Pin Mux/Config controller
 
 maintainers:
-  - Alexandre TORGUE <alexandre.torgue@st.com>
+  - Alexandre TORGUE <alexandre.torgue@foss.st.com>
 
 description: |
   STMicroelectronics's STM32 MCUs intregrate a GPIO and Pin mux/config hardware
diff --git a/Documentation/devicetree/bindings/regulator/st,stm32-booster.yaml b/Documentation/devicetree/bindings/regulator/st,stm32-booster.yaml
index 9f1c70381b82..df0191b1ceba 100644
--- a/Documentation/devicetree/bindings/regulator/st,stm32-booster.yaml
+++ b/Documentation/devicetree/bindings/regulator/st,stm32-booster.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 booster for ADC analog input switches bindings
 
 maintainers:
-  - Fabrice Gasnier <fabrice.gasnier@st.com>
+  - Fabrice Gasnier <fabrice.gasnier@foss.st.com>
 
 description: |
   Some STM32 devices embed a 3.3V booster supplied by Vdda, that can be used
diff --git a/Documentation/devicetree/bindings/regulator/st,stm32-vrefbuf.yaml b/Documentation/devicetree/bindings/regulator/st,stm32-vrefbuf.yaml
index 3cd4a254e4cb..836d4156d54c 100644
--- a/Documentation/devicetree/bindings/regulator/st,stm32-vrefbuf.yaml
+++ b/Documentation/devicetree/bindings/regulator/st,stm32-vrefbuf.yaml
@@ -12,7 +12,7 @@ description: |
   components through the dedicated VREF+ pin.
 
 maintainers:
-  - Fabrice Gasnier <fabrice.gasnier@st.com>
+  - Fabrice Gasnier <fabrice.gasnier@foss.st.com>
 
 allOf:
   - $ref: "regulator.yaml#"
diff --git a/Documentation/devicetree/bindings/regulator/st,stm32mp1-pwr-reg.yaml b/Documentation/devicetree/bindings/regulator/st,stm32mp1-pwr-reg.yaml
index e6322bc3e447..bd07b9c81570 100644
--- a/Documentation/devicetree/bindings/regulator/st,stm32mp1-pwr-reg.yaml
+++ b/Documentation/devicetree/bindings/regulator/st,stm32mp1-pwr-reg.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STM32MP1 PWR voltage regulators
 
 maintainers:
-  - Pascal Paillet <p.paillet@st.com>
+  - Pascal Paillet <p.paillet@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml b/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
index 1e6225677e00..b587c97c282b 100644
--- a/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
@@ -11,8 +11,8 @@ description:
   boots firmwares on the ST32MP family chipset.
 
 maintainers:
-  - Fabien Dessenne <fabien.dessenne@st.com>
-  - Arnaud Pouliquen <arnaud.pouliquen@st.com>
+  - Fabien Dessenne <fabien.dessenne@foss.st.com>
+  - Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
index 82bb2e97e889..9a6e4eaf4d3c 100644
--- a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
@@ -11,7 +11,7 @@ description: |
   IP and is fully separated from other crypto functions.
 
 maintainers:
-  - Lionel Debieve <lionel.debieve@st.com>
+  - Lionel Debieve <lionel.debieve@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml b/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml
index 5456604b1c14..2359f541b770 100644
--- a/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml
+++ b/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 Real Time Clock Bindings
 
 maintainers:
-  - Gabriel Fernandez <gabriel.fernandez@st.com>
+  - Gabriel Fernandez <gabriel.fernandez@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/serial/st,stm32-uart.yaml b/Documentation/devicetree/bindings/serial/st,stm32-uart.yaml
index f50f4ca893a0..333dc42722d2 100644
--- a/Documentation/devicetree/bindings/serial/st,stm32-uart.yaml
+++ b/Documentation/devicetree/bindings/serial/st,stm32-uart.yaml
@@ -5,7 +5,7 @@ $id: http://devicetree.org/schemas/serial/st,stm32-uart.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
 maintainers:
-  - Erwan Le Ray <erwan.leray@st.com>
+  - Erwan Le Ray <erwan.leray@foss.st.com>
 
 title: STMicroelectronics STM32 USART bindings
 
diff --git a/Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml b/Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml
index 0d87e2c86a42..963a871e74da 100644
--- a/Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml
+++ b/Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: CS42L51 audio codec DT bindings
 
 maintainers:
-  - Olivier Moysan <olivier.moysan@st.com>
+  - Olivier Moysan <olivier.moysan@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/sound/st,stm32-i2s.yaml b/Documentation/devicetree/bindings/sound/st,stm32-i2s.yaml
index 6feb5a09c184..d3966ae04ad0 100644
--- a/Documentation/devicetree/bindings/sound/st,stm32-i2s.yaml
+++ b/Documentation/devicetree/bindings/sound/st,stm32-i2s.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 SPI/I2S Controller
 
 maintainers:
-  - Olivier Moysan <olivier.moysan@st.com>
+  - Olivier Moysan <olivier.moysan@foss.st.com>
 
 description:
   The SPI/I2S block supports I2S/PCM protocols when configured on I2S mode.
diff --git a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
index f97132400bb6..1538d11ce9a8 100644
--- a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
+++ b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 Serial Audio Interface (SAI)
 
 maintainers:
-  - Olivier Moysan <olivier.moysan@st.com>
+  - Olivier Moysan <olivier.moysan@foss.st.com>
 
 description:
   The SAI interface (Serial Audio Interface) offers a wide set of audio
diff --git a/Documentation/devicetree/bindings/sound/st,stm32-spdifrx.yaml b/Documentation/devicetree/bindings/sound/st,stm32-spdifrx.yaml
index b7f7dc452231..837e830c47ac 100644
--- a/Documentation/devicetree/bindings/sound/st,stm32-spdifrx.yaml
+++ b/Documentation/devicetree/bindings/sound/st,stm32-spdifrx.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 S/PDIF receiver (SPDIFRX)
 
 maintainers:
-  - Olivier Moysan <olivier.moysan@st.com>
+  - Olivier Moysan <olivier.moysan@foss.st.com>
 
 description: |
   The SPDIFRX peripheral, is designed to receive an S/PDIF flow compliant with
diff --git a/Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml b/Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml
index 983c4e54c0be..6ec6f556182f 100644
--- a/Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml
+++ b/Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml
@@ -7,8 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 Quad Serial Peripheral Interface (QSPI) bindings
 
 maintainers:
-  - Christophe Kerello <christophe.kerello@st.com>
-  - Patrice Chotard <patrice.chotard@st.com>
+  - Christophe Kerello <christophe.kerello@foss.st.com>
+  - Patrice Chotard <patrice.chotard@foss.st.com>
 
 allOf:
   - $ref: "spi-controller.yaml#"
diff --git a/Documentation/devicetree/bindings/spi/st,stm32-spi.yaml b/Documentation/devicetree/bindings/spi/st,stm32-spi.yaml
index 2d9af4c506bb..3d64bed266ac 100644
--- a/Documentation/devicetree/bindings/spi/st,stm32-spi.yaml
+++ b/Documentation/devicetree/bindings/spi/st,stm32-spi.yaml
@@ -13,8 +13,8 @@ description: |
   from 4 to 32-bit data size.
 
 maintainers:
-  - Erwan Leray <erwan.leray@st.com>
-  - Fabrice Gasnier <fabrice.gasnier@st.com>
+  - Erwan Leray <erwan.leray@foss.st.com>
+  - Fabrice Gasnier <fabrice.gasnier@foss.st.com>
 
 allOf:
   - $ref: "spi-controller.yaml#"
diff --git a/Documentation/devicetree/bindings/thermal/st,stm32-thermal.yaml b/Documentation/devicetree/bindings/thermal/st,stm32-thermal.yaml
index c0f59c56003d..bee41cff5142 100644
--- a/Documentation/devicetree/bindings/thermal/st,stm32-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/st,stm32-thermal.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 digital thermal sensor (DTS) binding
 
 maintainers:
-  - David Hernandez Sanchez <david.hernandezsanchez@st.com>
+  - Pascal Paillet <p.paillet@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/timer/st,stm32-timer.yaml b/Documentation/devicetree/bindings/timer/st,stm32-timer.yaml
index 176aa3c9baf8..937aa8a56366 100644
--- a/Documentation/devicetree/bindings/timer/st,stm32-timer.yaml
+++ b/Documentation/devicetree/bindings/timer/st,stm32-timer.yaml
@@ -7,7 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 general-purpose 16 and 32 bits timers bindings
 
 maintainers:
-  - Benjamin Gaignard <benjamin.gaignard@st.com>
+  - Fabrice Gasnier <fabrice.gasnier@foss.st.com>
+  - Patrice Chotard <patrice.chotard@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/usb/st,stusb160x.yaml b/Documentation/devicetree/bindings/usb/st,stusb160x.yaml
index 9a51efa9d101..ead1571e0e43 100644
--- a/Documentation/devicetree/bindings/usb/st,stusb160x.yaml
+++ b/Documentation/devicetree/bindings/usb/st,stusb160x.yaml
@@ -7,7 +7,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: STMicroelectronics STUSB160x Type-C controller bindings
 
 maintainers:
-  - Amelie Delaunay <amelie.delaunay@st.com>
+  - Amelie Delaunay <amelie.delaunay@foss.st.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/watchdog/st,stm32-iwdg.yaml b/Documentation/devicetree/bindings/watchdog/st,stm32-iwdg.yaml
index 481bf91f988a..39736449ba64 100644
--- a/Documentation/devicetree/bindings/watchdog/st,stm32-iwdg.yaml
+++ b/Documentation/devicetree/bindings/watchdog/st,stm32-iwdg.yaml
@@ -7,8 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: STMicroelectronics STM32 Independent WatchDoG (IWDG) bindings
 
 maintainers:
-  - Yannick Fertre <yannick.fertre@st.com>
-  - Christophe Roullier <christophe.roullier@st.com>
+  - Yannick Fertre <yannick.fertre@foss.st.com>
+  - Christophe Roullier <christophe.roullier@foss.st.com>
 
 allOf:
   - $ref: "watchdog.yaml#"
-- 
2.17.1

