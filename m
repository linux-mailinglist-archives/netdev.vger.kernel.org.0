Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7FF44C3E6
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 16:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhKJPFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 10:05:48 -0500
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:45810 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232395AbhKJPFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 10:05:10 -0500
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AADAFhf017710;
        Wed, 10 Nov 2021 16:01:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=selector1;
 bh=Sh0W/4ohStKFB2Xy24SvmA8j0+SruP92VNN5TAvdPDM=;
 b=4ioO9K5CklY1uultzOl+2wdStUShYa9KwjSsBeH8j+ws1/hc6fEjrrK2S9QoFI+x3nKT
 9TKyTlI8oUzXv2dzA8dD0RCFdvtmNC39IwzbyhfWHEVQzT2tHtbZL+D1Ir6i19UE2Mu3
 rL7pEWUsA7h0rQrPetRarCkcX3aZUyr0EqV6qgMzrA7eqvVLWdzEUlbJ6JRR15iweWC6
 ZelRPAeDuz56JphJbCkPRNC/ioWG5rdZo3VU1xvOQwl9YMCWcMaNDDd+D9IzD1ZJ1TZf
 eg4+EfFUEwtooNW2w9bh+Mu6POIfvoiQadGnf2juwF/X1+vGUUit+7n+93HVvDEMRjnT fA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3c7ufnfuf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Nov 2021 16:01:49 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 1E14810002A;
        Wed, 10 Nov 2021 16:01:49 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id F3764207568;
        Wed, 10 Nov 2021 16:01:48 +0100 (CET)
Received: from localhost (10.75.127.50) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 10 Nov 2021 16:01:48
 +0100
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
Subject: [PATCH v3 0/5] Update STMicroelectronics maintainers email
Date:   Wed, 10 Nov 2021 16:01:39 +0100
Message-ID: <20211110150144.18272-1-patrice.chotard@foss.st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.50]
X-ClientProxiedBy: SFHDAG1NODE2.st.com (10.75.127.2) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-10_05,2021-11-08_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patrice Chotard <patrice.chotard@foss.st.com>

Update maintainers name for some yaml files.
Update @st.com email address to @foss.st.com as @foss.st.com email
address is dedicated for upstream activities.

Changes in v3:
  _ fix typo in patch 2/3/4 commit message 
  _ resend to missing mailing list

Patrice Chotard (5):
  dt-bindings: timer: Update maintainers for st,stm32-timer
  dt-bindings: mfd: timers: Update maintainers for st,stm32-timers
  dt-bindings: media: Update maintainers for st,stm32-cec.yaml
  dt-bindings: media: Update maintainers for st,stm32-hwspinlock.yaml
  dt-bindings: treewide: Update @st.com email address to @foss.st.com

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

-- 
2.17.1

