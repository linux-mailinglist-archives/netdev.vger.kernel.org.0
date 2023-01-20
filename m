Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245DC67518E
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjATJtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjATJtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:49:23 -0500
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415143CE39;
        Fri, 20 Jan 2023 01:49:20 -0800 (PST)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1pInzo-0002mL-W5; Fri, 20 Jan 2023 10:47:41 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     broonie@kernel.org, miquel.raynal@bootlin.com, richard@nod.at,
        vigneshr@ti.com, jic23@kernel.org, tudor.ambarus@microchip.com,
        pratyush@kernel.org, sanju.mehta@amd.com,
        chin-ting_kuo@aspeedtech.com, clg@kaod.org, kdasu.kdev@gmail.com,
        f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        eajames@linux.ibm.com, olteanv@gmail.com, han.xu@nxp.com,
        john.garry@huawei.com, shawnguo@kernel.org, s.hauer@pengutronix.de,
        narmstrong@baylibre.com, khilman@baylibre.com,
        matthias.bgg@gmail.com, haibo.chen@nxp.com,
        linus.walleij@linaro.org, daniel@zonque.org,
        haojian.zhuang@gmail.com, robert.jarzmik@free.fr,
        agross@kernel.org, bjorn.andersson@linaro.org,
        krzysztof.kozlowski@linaro.org, andi@etezian.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        wens@csie.org, jernej.skrabec@gmail.com, samuel@sholland.org,
        masahisa.kojima@linaro.org, jaswinder.singh@linaro.org,
        rostedt@goodmis.org, mingo@redhat.com, l.stelmach@samsung.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alex.aring@gmail.com, stefan@datenfreihafen.org,
        kvalo@kernel.org, thierry.reding@gmail.com, jonathanh@nvidia.com,
        skomatineni@nvidia.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com, j.neuschaefer@gmx.net,
        vireshk@kernel.org, rmfrfs@gmail.com, johan@kernel.org,
        elder@kernel.org, gregkh@linuxfoundation.org,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Cc:     git@amd.com, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@jms.id.au, andrew@aj.id.au,
        radu_nicolae.pirea@upb.ro, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, claudiu.beznea@microchip.com,
        bcm-kernel-feedback-list@broadcom.com, fancer.lancer@gmail.com,
        kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        jbrunet@baylibre.com, martin.blumenstingl@googlemail.com,
        avifishman70@gmail.com, tmaimon77@gmail.com, tali.perry1@gmail.com,
        venture@google.com, yuenn@google.com, benjaminfair@google.com,
        yogeshgaur.83@gmail.com, konrad.dybcio@somainline.org,
        alim.akhtar@samsung.com, ldewangan@nvidia.com,
        michal.simek@amd.com, linux-aspeed@lists.ozlabs.org,
        openbmc@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-sunxi@lists.linux.dev, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org, linux-wpan@vger.kernel.org,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-mtd@lists.infradead.org, lars@metafoo.de,
        Michael.Hennerich@analog.com, linux-iio@vger.kernel.org,
        michael@walle.cc, palmer@dabbelt.com,
        linux-riscv@lists.infradead.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, greybus-dev@lists.linaro.org,
        linux-staging@lists.linux.dev, amitrkcian2002@gmail.com
Subject: Re: [PATCH v2 02/13] spi: Replace all spi->chip_select and spi->cs_gpiod
 references with function call
Date:   Fri, 20 Jan 2023 10:47:37 +0100
Message-ID: <3658396.MHq7AAxBmi@diego>
In-Reply-To: <20230119185342.2093323-3-amit.kumar-mahapatra@amd.com>
References: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
 <20230119185342.2093323-3-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Donnerstag, 19. Januar 2023, 19:53:31 CET schrieb Amit Kumar Mahapatra:
> Supporting multi-cs in spi drivers would require the chip_select & cs_gpiod
> members of struct spi_device to be an array. But changing the type of these
> members to array would break the spi driver functionality. To make the
> transition smoother introduced four new APIs to get/set the
> spi->chip_select & spi->cs_gpiod and replaced all spi->chip_select and
> spi->cs_gpiod references with get or set API calls.
> While adding multi-cs support in further patches the chip_select & cs_gpiod
> members of the spi_device structure would be converted to arrays & the
> "idx" parameter of the APIs would be used as array index i.e.,
> spi->chip_select[idx] & spi->cs_gpiod[idx] respectively.
> 
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
> ---

> diff --git a/drivers/spi/spi-rockchip-sfc.c b/drivers/spi/spi-rockchip-sfc.c
> index bd87d3c92dd3..246e81453ec3 100644
> --- a/drivers/spi/spi-rockchip-sfc.c
> +++ b/drivers/spi/spi-rockchip-sfc.c
> @@ -346,7 +346,7 @@ static int rockchip_sfc_xfer_setup(struct rockchip_sfc *sfc,
>  
>  	/* set the Controller */
>  	ctrl |= SFC_CTRL_PHASE_SEL_NEGETIVE;
> -	cmd |= mem->spi->chip_select << SFC_CMD_CS_SHIFT;
> +	cmd |= spi_get_chipselect(mem->spi, 0) << SFC_CMD_CS_SHIFT;
>  
>  	dev_dbg(sfc->dev, "sfc addr.nbytes=%x(x%d) dummy.nbytes=%x(x%d)\n",
>  		op->addr.nbytes, op->addr.buswidth,
> diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
> index 79242dc5272d..adc5638eff4b 100644
> --- a/drivers/spi/spi-rockchip.c
> +++ b/drivers/spi/spi-rockchip.c
> @@ -246,28 +246,30 @@ static void rockchip_spi_set_cs(struct spi_device *spi, bool enable)
>  	bool cs_asserted = spi->mode & SPI_CS_HIGH ? enable : !enable;
>  
>  	/* Return immediately for no-op */
> -	if (cs_asserted == rs->cs_asserted[spi->chip_select])
> +	if (cs_asserted == rs->cs_asserted[spi_get_chipselect(spi, 0)])
>  		return;
>  
>  	if (cs_asserted) {
>  		/* Keep things powered as long as CS is asserted */
>  		pm_runtime_get_sync(rs->dev);
>  
> -		if (spi->cs_gpiod)
> +		if (spi_get_csgpiod(spi, 0))
>  			ROCKCHIP_SPI_SET_BITS(rs->regs + ROCKCHIP_SPI_SER, 1);
>  		else
> -			ROCKCHIP_SPI_SET_BITS(rs->regs + ROCKCHIP_SPI_SER, BIT(spi->chip_select));
> +			ROCKCHIP_SPI_SET_BITS(rs->regs + ROCKCHIP_SPI_SER,
> +					      BIT(spi_get_chipselect(spi, 0)));
>  	} else {
> -		if (spi->cs_gpiod)
> +		if (spi_get_csgpiod(spi, 0))
>  			ROCKCHIP_SPI_CLR_BITS(rs->regs + ROCKCHIP_SPI_SER, 1);
>  		else
> -			ROCKCHIP_SPI_CLR_BITS(rs->regs + ROCKCHIP_SPI_SER, BIT(spi->chip_select));
> +			ROCKCHIP_SPI_CLR_BITS(rs->regs + ROCKCHIP_SPI_SER,
> +					      BIT(spi_get_chipselect(spi, 0)));
>  
>  		/* Drop reference from when we first asserted CS */
>  		pm_runtime_put(rs->dev);
>  	}
>  
> -	rs->cs_asserted[spi->chip_select] = cs_asserted;
> +	rs->cs_asserted[spi_get_chipselect(spi, 0)] = cs_asserted;
>  }
>  
>  static void rockchip_spi_handle_err(struct spi_controller *ctlr,
> @@ -541,7 +543,7 @@ static int rockchip_spi_config(struct rockchip_spi *rs,
>  	if (spi->mode & SPI_LSB_FIRST)
>  		cr0 |= CR0_FBM_LSB << CR0_FBM_OFFSET;
>  	if (spi->mode & SPI_CS_HIGH)
> -		cr0 |= BIT(spi->chip_select) << CR0_SOI_OFFSET;
> +		cr0 |= BIT(spi_get_chipselect(spi, 0)) << CR0_SOI_OFFSET;
>  
>  	if (xfer->rx_buf && xfer->tx_buf)
>  		cr0 |= CR0_XFM_TR << CR0_XFM_OFFSET;
> @@ -724,7 +726,7 @@ static int rockchip_spi_setup(struct spi_device *spi)
>  	struct rockchip_spi *rs = spi_controller_get_devdata(spi->controller);
>  	u32 cr0;
>  
> -	if (!spi->cs_gpiod && (spi->mode & SPI_CS_HIGH) && !rs->cs_high_supported) {
> +	if (!spi_get_csgpiod(spi, 0) && (spi->mode & SPI_CS_HIGH) && !rs->cs_high_supported) {
>  		dev_warn(&spi->dev, "setup: non GPIO CS can't be active-high\n");
>  		return -EINVAL;
>  	}
> @@ -735,10 +737,10 @@ static int rockchip_spi_setup(struct spi_device *spi)
>  
>  	cr0 &= ~(0x3 << CR0_SCPH_OFFSET);
>  	cr0 |= ((spi->mode & 0x3) << CR0_SCPH_OFFSET);
> -	if (spi->mode & SPI_CS_HIGH && spi->chip_select <= 1)
> -		cr0 |= BIT(spi->chip_select) << CR0_SOI_OFFSET;
> -	else if (spi->chip_select <= 1)
> -		cr0 &= ~(BIT(spi->chip_select) << CR0_SOI_OFFSET);
> +	if (spi->mode & SPI_CS_HIGH && spi_get_chipselect(spi, 0) <= 1)
> +		cr0 |= BIT(spi_get_chipselect(spi, 0)) << CR0_SOI_OFFSET;
> +	else if (spi_get_chipselect(spi, 0) <= 1)
> +		cr0 &= ~(BIT(spi_get_chipselect(spi, 0)) << CR0_SOI_OFFSET);
>  
>  	writel_relaxed(cr0, rs->regs + ROCKCHIP_SPI_CTRLR0);

for the two Rockchip drivers
Acked-by: Heiko Stuebner <heiko@sntech.de>


