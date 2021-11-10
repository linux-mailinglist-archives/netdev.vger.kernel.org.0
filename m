Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC7544C9C7
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbhKJTzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:55:18 -0500
Received: from mail-ot1-f42.google.com ([209.85.210.42]:42742 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbhKJTzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 14:55:13 -0500
Received: by mail-ot1-f42.google.com with SMTP id g91-20020a9d12e4000000b0055ae68cfc3dso5552929otg.9;
        Wed, 10 Nov 2021 11:52:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=idiDHIx887w76Be1+DoMm+DC/fAFpYxmnW+2ngUk+Lw=;
        b=m4Vqk05zTxHyFixvFVmEGMt+tV7fRmMdMBpeTOs59FcS6Cz4nSO12032DDju2qwfQU
         w4St6Q70ycx3TBbgCK03oXROCFjpgkal8PQ5OM68BSOkNmHN2bVrJTwNRJ6DxH1z6eAO
         u5NaReC6b+PJAnmn/+sJmqcGtjAkdVws0xh3Eymxeh1Q3pFv1GBWSNybyaW0fcxsSWzK
         hDzr8BAFY2o2kEaJMJTRyy5XIefBfNc1NvEVaFWyW41kmVs848aGdpvDox/qFHhMqs0i
         dYL5zlxbpJ4OYfmYyqLFy2svPRxU0xBOcKT4FwWwTtfiXb+UH3DAdyvwdXebnlbVEr5l
         e99w==
X-Gm-Message-State: AOAM532fMk3KKFKLKypp+m3FO5lFU8eXy13K7RuVj7XtTHQ5kQKna6dC
        fwd5E7iY/bqsAviZzy8d3A==
X-Google-Smtp-Source: ABdhPJybq9LO3rX5SokDCkXN9j6OMCOI/V0Dfx02D+RWZ3KXqjzTHAnpYpaSp6MZwgVF6u6l3jseFQ==
X-Received: by 2002:a9d:7586:: with SMTP id s6mr1448044otk.158.1636573944136;
        Wed, 10 Nov 2021 11:52:24 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id k4sm168568oij.54.2021.11.10.11.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 11:52:23 -0800 (PST)
Received: (nullmailer pid 1856875 invoked by uid 1000);
        Wed, 10 Nov 2021 19:52:20 -0000
Date:   Wed, 10 Nov 2021 13:52:20 -0600
From:   Rob Herring <robh@kernel.org>
To:     patrice.chotard@foss.st.com
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        linux-clk@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        benjamin gaignard <benjamin.gaignard@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        ohad ben-cohen <ohad@wizery.com>,
        Mark Brown <broonie@kernel.org>,
        Ludovic Barre <ludovic.barre@foss.st.com>,
        philippe cornu <philippe.cornu@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
        Amit Kucheria <amitk@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jagan Teki <jagan@amarulasolutions.com>,
        linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
        thierry reding <thierry.reding@gmail.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Christophe Roullier <christophe.roullier@foss.st.com>,
        yannick fertre <yannick.fertre@foss.st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        bjorn andersson <bjorn.andersson@linaro.org>,
        linux-rtc@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        dillon min <dillon.minfei@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        baolin wang <baolin.wang7@gmail.com>,
        arnaud pouliquen <arnaud.pouliquen@foss.st.com>,
        linux-phy@lists.infradead.org, daniel vetter <daniel@ffwll.ch>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-watchdog@vger.kernel.org,
        Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
        david airlie <airlied@linux.ie>, devicetree@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        olivier moysan <olivier.moysan@foss.st.com>,
        Rob Herring <robh+dt@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        dri-devel@lists.freedesktop.org, Zhang Rui <rui.zhang@intel.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Matt Mackall <mpm@selenic.com>,
        sam ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        jonathan cameron <jic23@kernel.org>,
        stephen boyd <sboyd@kernel.org>,
        alexandre torgue <alexandre.torgue@foss.st.com>,
        michael turquette <mturquette@baylibre.com>,
        linux-usb@vger.kernel.org, vinod koul <vkoul@kernel.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-spi@vger.kernel.org,
        Hugues Fruchet <hugues.fruchet@foss.st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "david s . miller" <davem@davemloft.net>,
        linux-remoteproc@vger.kernel.org,
        herbert xu <herbert@gondor.apana.org.au>,
        Le Ray <erwan.leray@foss.st.com>,
        pascal Paillet <p.paillet@foss.st.com>,
        Marek Vasut <marex@denx.de>,
        maxime coquelin <mcoquelin.stm32@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Paul Cercueil <paul@crapouillou.net>,
        linux-iio@vger.kernel.org,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        lars-peter clausen <lars@metafoo.de>,
        dmaengine@vger.kernel.org, linux-gpio@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v3 5/5] dt-bindings: treewide: Update @st.com email
 address to @foss.st.com
Message-ID: <YYwi9P3b4tBmFVyv@robh.at.kernel.org>
References: <20211110150144.18272-1-patrice.chotard@foss.st.com>
 <20211110150144.18272-6-patrice.chotard@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110150144.18272-6-patrice.chotard@foss.st.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Nov 2021 16:01:44 +0100, patrice.chotard@foss.st.com wrote:
> From: Patrice Chotard <patrice.chotard@foss.st.com>
> 
> Not all @st.com email address are concerned, only people who have
> a specific @foss.st.com email will see their entry updated.
> For some people, who left the company, remove their email.
> 
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
> Cc: Fabien Dessenne <fabien.dessenne@foss.st.com>
> Cc: Christophe Roullier <christophe.roullier@foss.st.com>
> Cc: Gabriel Fernandez <gabriel.fernandez@foss.st.com>
> Cc: Lionel Debieve <lionel.debieve@foss.st.com>
> Cc: Amelie Delaunay <amelie.delaunay@foss.st.com>
> Cc: Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>
> Cc: Ludovic Barre <ludovic.barre@foss.st.com>
> Cc: Christophe Kerello <christophe.kerello@foss.st.com>
> Cc: pascal Paillet <p.paillet@foss.st.com>
> Cc: Erwan Le Ray <erwan.leray@foss.st.com>
> Cc: Philippe CORNU <philippe.cornu@foss.st.com>
> Cc: Yannick Fertre <yannick.fertre@foss.st.com>
> Cc: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
> Cc: Olivier Moysan <olivier.moysan@foss.st.com>
> Cc: Hugues Fruchet <hugues.fruchet@foss.st.com>
> Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
> Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> Acked-by: Mark Brown <broonie@kernel.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Acked-By: Vinod Koul <vkoul@kernel.org>
> Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  Documentation/devicetree/bindings/arm/sti.yaml                | 2 +-
>  Documentation/devicetree/bindings/arm/stm32/st,mlahb.yaml     | 4 ++--
>  .../devicetree/bindings/arm/stm32/st,stm32-syscon.yaml        | 4 ++--
>  Documentation/devicetree/bindings/arm/stm32/stm32.yaml        | 2 +-
>  Documentation/devicetree/bindings/clock/st,stm32mp1-rcc.yaml  | 2 +-
>  Documentation/devicetree/bindings/crypto/st,stm32-crc.yaml    | 2 +-
>  Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml   | 2 +-
>  Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml   | 2 +-
>  .../devicetree/bindings/display/bridge/snps,dw-mipi-dsi.yaml  | 2 +-
>  .../devicetree/bindings/display/panel/orisetech,otm8009a.yaml | 2 +-
>  .../devicetree/bindings/display/panel/raydium,rm68200.yaml    | 2 +-
>  Documentation/devicetree/bindings/display/st,stm32-dsi.yaml   | 4 ++--
>  Documentation/devicetree/bindings/display/st,stm32-ltdc.yaml  | 4 ++--
>  Documentation/devicetree/bindings/dma/st,stm32-dma.yaml       | 2 +-
>  Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml    | 2 +-
>  Documentation/devicetree/bindings/dma/st,stm32-mdma.yaml      | 2 +-
>  .../devicetree/bindings/hwlock/st,stm32-hwspinlock.yaml       | 2 +-
>  Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml       | 2 +-
>  .../devicetree/bindings/iio/adc/sigma-delta-modulator.yaml    | 2 +-
>  Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml   | 2 +-
>  .../devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml       | 4 ++--
>  Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml   | 2 +-
>  .../bindings/interrupt-controller/st,stm32-exti.yaml          | 4 ++--
>  Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml  | 4 ++--
>  Documentation/devicetree/bindings/media/st,stm32-cec.yaml     | 2 +-
>  Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml    | 2 +-
>  .../bindings/memory-controllers/st,stm32-fmc2-ebi.yaml        | 2 +-
>  Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml   | 2 +-
>  Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml    | 2 +-
>  Documentation/devicetree/bindings/mfd/st,stmfx.yaml           | 2 +-
>  Documentation/devicetree/bindings/mfd/st,stpmic1.yaml         | 2 +-
>  Documentation/devicetree/bindings/mtd/st,stm32-fmc2-nand.yaml | 2 +-
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml         | 2 +-
>  Documentation/devicetree/bindings/net/stm32-dwmac.yaml        | 4 ++--
>  Documentation/devicetree/bindings/nvmem/st,stm32-romem.yaml   | 2 +-
>  Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml  | 2 +-
>  .../devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml         | 2 +-
>  .../devicetree/bindings/regulator/st,stm32-booster.yaml       | 2 +-
>  .../devicetree/bindings/regulator/st,stm32-vrefbuf.yaml       | 2 +-
>  .../devicetree/bindings/regulator/st,stm32mp1-pwr-reg.yaml    | 2 +-
>  .../devicetree/bindings/remoteproc/st,stm32-rproc.yaml        | 4 ++--
>  Documentation/devicetree/bindings/rng/st,stm32-rng.yaml       | 2 +-
>  Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml       | 2 +-
>  Documentation/devicetree/bindings/serial/st,stm32-uart.yaml   | 2 +-
>  Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml   | 2 +-
>  Documentation/devicetree/bindings/sound/st,stm32-i2s.yaml     | 2 +-
>  Documentation/devicetree/bindings/sound/st,stm32-sai.yaml     | 2 +-
>  Documentation/devicetree/bindings/sound/st,stm32-spdifrx.yaml | 2 +-
>  Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml      | 4 ++--
>  Documentation/devicetree/bindings/spi/st,stm32-spi.yaml       | 4 ++--
>  .../devicetree/bindings/thermal/st,stm32-thermal.yaml         | 2 +-
>  Documentation/devicetree/bindings/usb/st,stusb160x.yaml       | 2 +-
>  Documentation/devicetree/bindings/watchdog/st,stm32-iwdg.yaml | 4 ++--
>  53 files changed, 65 insertions(+), 65 deletions(-)
> 

Applied, thanks!
