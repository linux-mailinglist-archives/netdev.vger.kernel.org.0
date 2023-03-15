Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BFD6BAFED
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbjCOMIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCOMIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:08:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8331C2E0D8;
        Wed, 15 Mar 2023 05:07:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48A1361D42;
        Wed, 15 Mar 2023 12:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEC6C433D2;
        Wed, 15 Mar 2023 12:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678882054;
        bh=sgmMmhvI0/Dp036Wgs1Ke6kgrXhU8+5SUe5lgi+/8DQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kOhvlL35CAXqoue/F//cqZTBdbupgess90uesi0SzcucA8PEEFs17WFmB23hpbz8t
         aJ5LLChtZcDOZtUlOEgQJE6//7e42C5UovnJpJQ4PvO4F9n8qFUqes+2LBWfamj9lP
         YzkxopUOMxJEOKnEEKcP+y/DjcMOdyQ912a9V6ML62WjjXvBEOH3zLj39bLzbiDY8y
         v67ScRVM6LSQeIzsR9/PbgfOWfyCSIsEi5yulvbLg8uDA9w3A/HXOIvLr0VFBTbZQF
         S+QwbJ9Esokxt58NExYSQF5zlnQHoGcKqzMODj9hsV+y63syqf5mabdpr9Xl8hWC3i
         LKtecIye54+3A==
Message-ID: <91481d4f-2005-7b33-d3be-df09b7d27ef6@kernel.org>
Date:   Wed, 15 Mar 2023 14:07:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 3/5] soc: ti: pruss: Add pruss_cfg_read()/update() API
To:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>
Cc:     linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230313111127.1229187-1-danishanwar@ti.com>
 <20230313111127.1229187-4-danishanwar@ti.com>
Content-Language: en-US
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230313111127.1229187-4-danishanwar@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Danish,

On 13/03/2023 13:11, MD Danish Anwar wrote:
> From: Suman Anna <s-anna@ti.com>
> 
> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
> the PRUSS platform driver to read and program respectively a register
> within the PRUSS CFG sub-module represented by a syscon driver.
> 
> These APIs are internal to PRUSS driver. Various useful registers
> and macros for certain register bit-fields and their values have also
> been added.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> ---
>  drivers/soc/ti/pruss.c           | 39 ++++++++++++++
>  include/linux/remoteproc/pruss.h | 87 ++++++++++++++++++++++++++++++++
>  2 files changed, 126 insertions(+)
> 
> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> index c8053c0d735f..26d8129b515c 100644
> --- a/drivers/soc/ti/pruss.c
> +++ b/drivers/soc/ti/pruss.c
> @@ -164,6 +164,45 @@ int pruss_release_mem_region(struct pruss *pruss,
>  }
>  EXPORT_SYMBOL_GPL(pruss_release_mem_region);
>  
> +/**
> + * pruss_cfg_read() - read a PRUSS CFG sub-module register
> + * @pruss: the pruss instance handle
> + * @reg: register offset within the CFG sub-module
> + * @val: pointer to return the value in
> + *
> + * Reads a given register within the PRUSS CFG sub-module and
> + * returns it through the passed-in @val pointer
> + *
> + * Return: 0 on success, or an error code otherwise
> + */
> +static int pruss_cfg_read(struct pruss *pruss, unsigned int reg, unsigned int *val)
> +{
> +	if (IS_ERR_OR_NULL(pruss))
> +		return -EINVAL;
> +
> +	return regmap_read(pruss->cfg_regmap, reg, val);
> +}
> +
> +/**
> + * pruss_cfg_update() - configure a PRUSS CFG sub-module register
> + * @pruss: the pruss instance handle
> + * @reg: register offset within the CFG sub-module
> + * @mask: bit mask to use for programming the @val
> + * @val: value to write
> + *
> + * Programs a given register within the PRUSS CFG sub-module
> + *
> + * Return: 0 on success, or an error code otherwise
> + */
> +static int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
> +			    unsigned int mask, unsigned int val)
> +{
> +	if (IS_ERR_OR_NULL(pruss))
> +		return -EINVAL;
> +
> +	return regmap_update_bits(pruss->cfg_regmap, reg, mask, val);
> +}
> +
>  static void pruss_of_free_clk_provider(void *data)
>  {
>  	struct device_node *clk_mux_np = data;
> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
> index 33f930e0a0ce..12ef10b9fe9a 100644
> --- a/include/linux/remoteproc/pruss.h
> +++ b/include/linux/remoteproc/pruss.h
> @@ -10,12 +10,99 @@
>  #ifndef __LINUX_PRUSS_H
>  #define __LINUX_PRUSS_H
>  
> +#include <linux/bits.h>
>  #include <linux/device.h>
>  #include <linux/err.h>
>  #include <linux/types.h>
>  
>  #define PRU_RPROC_DRVNAME "pru-rproc"
>  
> +/*
> + * PRU_ICSS_CFG registers
> + * SYSCFG, ISRP, ISP, IESP, IECP, SCRP applicable on AMxxxx devices only
> + */
> +#define PRUSS_CFG_REVID		0x00
> +#define PRUSS_CFG_SYSCFG	0x04
> +#define PRUSS_CFG_GPCFG(x)	(0x08 + (x) * 4)
> +#define PRUSS_CFG_CGR		0x10
> +#define PRUSS_CFG_ISRP		0x14
> +#define PRUSS_CFG_ISP		0x18
> +#define PRUSS_CFG_IESP		0x1C
> +#define PRUSS_CFG_IECP		0x20
> +#define PRUSS_CFG_SCRP		0x24
> +#define PRUSS_CFG_PMAO		0x28
> +#define PRUSS_CFG_MII_RT	0x2C
> +#define PRUSS_CFG_IEPCLK	0x30
> +#define PRUSS_CFG_SPP		0x34
> +#define PRUSS_CFG_PIN_MX	0x40
> +
> +/* PRUSS_GPCFG register bits */
> +#define PRUSS_GPCFG_PRU_GPO_SH_SEL		BIT(25)
> +
> +#define PRUSS_GPCFG_PRU_DIV1_SHIFT		20
> +#define PRUSS_GPCFG_PRU_DIV1_MASK		GENMASK(24, 20)
> +
> +#define PRUSS_GPCFG_PRU_DIV0_SHIFT		15
> +#define PRUSS_GPCFG_PRU_DIV0_MASK		GENMASK(15, 19)
> +
> +#define PRUSS_GPCFG_PRU_GPO_MODE		BIT(14)
> +#define PRUSS_GPCFG_PRU_GPO_MODE_DIRECT		0
> +#define PRUSS_GPCFG_PRU_GPO_MODE_SERIAL		BIT(14)
> +
> +#define PRUSS_GPCFG_PRU_GPI_SB			BIT(13)
> +
> +#define PRUSS_GPCFG_PRU_GPI_DIV1_SHIFT		8
> +#define PRUSS_GPCFG_PRU_GPI_DIV1_MASK		GENMASK(12, 8)
> +
> +#define PRUSS_GPCFG_PRU_GPI_DIV0_SHIFT		3
> +#define PRUSS_GPCFG_PRU_GPI_DIV0_MASK		GENMASK(7, 3)
> +
> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE_POSITIVE	0
> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE_NEGATIVE	BIT(2)
> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE		BIT(2)
> +
> +#define PRUSS_GPCFG_PRU_GPI_MODE_MASK		GENMASK(1, 0)
> +#define PRUSS_GPCFG_PRU_GPI_MODE_SHIFT		0
> +
> +#define PRUSS_GPCFG_PRU_MUX_SEL_SHIFT		26
> +#define PRUSS_GPCFG_PRU_MUX_SEL_MASK		GENMASK(29, 26)
> +
> +/* PRUSS_MII_RT register bits */
> +#define PRUSS_MII_RT_EVENT_EN			BIT(0)
> +
> +/* PRUSS_SPP register bits */
> +#define PRUSS_SPP_XFER_SHIFT_EN			BIT(1)
> +#define PRUSS_SPP_PRU1_PAD_HP_EN		BIT(0)

Can we please move all the above definitions to private driver/soc/ti/pruss.h?
You can also add pruss_cfg_read and pruss_cfg_update there.

> +
> +/*
> + * enum pruss_gp_mux_sel - PRUSS GPI/O Mux modes for the
> + * PRUSS_GPCFG0/1 registers
> + *
> + * NOTE: The below defines are the most common values, but there
> + * are some exceptions like on 66AK2G, where the RESERVED and MII2
> + * values are interchanged. Also, this bit-field does not exist on
> + * AM335x SoCs
> + */
> +enum pruss_gp_mux_sel {
> +	PRUSS_GP_MUX_SEL_GP = 0,
> +	PRUSS_GP_MUX_SEL_ENDAT,
> +	PRUSS_GP_MUX_SEL_RESERVED,
> +	PRUSS_GP_MUX_SEL_SD,
> +	PRUSS_GP_MUX_SEL_MII2,
> +	PRUSS_GP_MUX_SEL_MAX,
> +};
> +
> +/*
> + * enum pruss_gpi_mode - PRUSS GPI configuration modes, used
> + *			 to program the PRUSS_GPCFG0/1 registers
> + */
> +enum pruss_gpi_mode {
> +	PRUSS_GPI_MODE_DIRECT = 0,
> +	PRUSS_GPI_MODE_PARALLEL,
> +	PRUSS_GPI_MODE_28BIT_SHIFT,
> +	PRUSS_GPI_MODE_MII,
> +};
> +
>  /**
>   * enum pruss_pru_id - PRU core identifiers
>   * @PRUSS_PRU0: PRU Core 0.

cheers,
-roger
