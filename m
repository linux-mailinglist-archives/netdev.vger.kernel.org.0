Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E8051B04B
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378583AbiEDVWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378561AbiEDVWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:22:33 -0400
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6EB51580;
        Wed,  4 May 2022 14:18:55 -0700 (PDT)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-e93bbb54f9so2472278fac.12;
        Wed, 04 May 2022 14:18:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=S5KOsETtEM/tlLh5aE4TllMhkuOxHv7tKaCHP6S4dRs=;
        b=meSoVHFyMu9XzuL5NYYuF/42g3MrcFOvn/6Blo8+9ojSM8x1iGh/FtVc4t3KJt7Crc
         Y5OAEByzofLzVTFIGNEdJGRHGugIa/CiNpoDezNpXgGItMKMn8sh95q+YiGEZtqYcbNf
         d2yLJe/fDXZG0o1Ri9X5xiaBW5N2H8jlt/rYvu6+l2g2HkDqKnUZmbezNQo2Eju8TT4p
         Y0/Irem2qPk+TkOEq9EAzWeG4wrVVVlC27DcEwprzenxJgdlxD5W2ubW+l16kssI00/1
         ZliX2s0ScWKyZgmvgL13y8QDZCfC5X8JkmhsKMllMQZQop/OeIrgZ7/xUoTQc6pRcGzy
         YCog==
X-Gm-Message-State: AOAM531oiZOyMyoNLGQ6c1u+vWrNsSPrkTLKe9eXuXWLSHAXNW+yfJ6z
        wnwuwrb7dEG3ohpmw2d2Tg==
X-Google-Smtp-Source: ABdhPJx70C27VXLkiWuEEIrWSrTpQJyJY8Bcpnd3QFecXI5OFZqDfycowXXO+amY4bM1axvVUtwzWg==
X-Received: by 2002:a05:6870:7a8:b0:e5:d471:1e82 with SMTP id en40-20020a05687007a800b000e5d4711e82mr785288oab.138.1651699135188;
        Wed, 04 May 2022 14:18:55 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id m1-20020a056808024100b00325cda1ff88sm15372oie.7.2022.05.04.14.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 14:18:54 -0700 (PDT)
Received: (nullmailer pid 2242697 invoked by uid 1000);
        Wed, 04 May 2022 21:18:52 -0000
Date:   Wed, 4 May 2022 16:18:52 -0500
From:   Rob Herring <robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Zhang Rui <rui.zhang@intel.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Vinod Koul <vkoul@kernel.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-clk@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        netdev@vger.kernel.org, Dario Binacchi <dariobin@libero.it>,
        Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anson Huang <Anson.Huang@nxp.com>,
        Richard Weinberger <richard@nod.at>,
        Chen-Yu Tsai <wens@csie.org>, linux-mtd@lists.infradead.org,
        linux-can@vger.kernel.org, linux-iio@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Brown <broonie@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        alsa-devel@alsa-project.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-serial@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-phy@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Abel Vesa <abel.vesa@nxp.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-rtc@vger.kernel.org, Jonathan Hunter <jonathanh@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <mripard@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-mmc@vger.kernel.org,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Drop redundant 'maxItems/minItems' in
 if/then schemas
Message-ID: <YnLtvA9hWMSIfSP7@robh.at.kernel.org>
References: <20220503162738.3827041-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220503162738.3827041-1-robh@kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 03 May 2022 11:27:38 -0500, Rob Herring wrote:
> Another round of removing redundant minItems/maxItems when 'items' list is
> specified. This time it is in if/then schemas as the meta-schema was
> failing to check this case.
> 
> If a property has an 'items' list, then a 'minItems' or 'maxItems' with the
> same size as the list is redundant and can be dropped. Note that is DT
> schema specific behavior and not standard json-schema behavior. The tooling
> will fixup the final schema adding any unspecified minItems/maxItems.
> 
> Cc: Abel Vesa <abel.vesa@nxp.com>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Jonathan Hunter <jonathanh@nvidia.com>
> Cc: Miquel Raynal <miquel.raynal@bootlin.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Vignesh Raghavendra <vigneshr@ti.com>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: Chen-Yu Tsai <wens@csie.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: "Niklas Söderlund" <niklas.soderlund@ragnatech.se>
> Cc: Anson Huang <Anson.Huang@nxp.com>
> Cc: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
> Cc: Han Xu <han.xu@nxp.com>
> Cc: Dario Binacchi <dariobin@libero.it>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Cc: linux-clk@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-iio@vger.kernel.org
> Cc: linux-mmc@vger.kernel.org
> Cc: linux-mtd@lists.infradead.org
> Cc: linux-can@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-phy@lists.infradead.org
> Cc: linux-rtc@vger.kernel.org
> Cc: linux-serial@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../bindings/clock/imx8m-clock.yaml           |  4 ----
>  .../bindings/display/bridge/renesas,lvds.yaml |  4 ----
>  .../bindings/display/renesas,du.yaml          | 23 -------------------
>  .../bindings/iio/adc/st,stm32-adc.yaml        |  2 --
>  .../bindings/mmc/nvidia,tegra20-sdhci.yaml    |  7 +-----
>  .../devicetree/bindings/mtd/gpmi-nand.yaml    |  2 --
>  .../bindings/net/can/bosch,c_can.yaml         |  3 ---
>  .../bindings/phy/brcm,sata-phy.yaml           | 10 ++++----
>  .../bindings/rtc/allwinner,sun6i-a31-rtc.yaml | 10 --------
>  .../bindings/serial/samsung_uart.yaml         |  4 ----
>  .../sound/allwinner,sun4i-a10-i2s.yaml        |  1 -
>  .../bindings/sound/ti,j721e-cpb-audio.yaml    |  2 --
>  .../bindings/thermal/rcar-gen3-thermal.yaml   |  1 -
>  13 files changed, 5 insertions(+), 68 deletions(-)
> 

Applied, thanks!
