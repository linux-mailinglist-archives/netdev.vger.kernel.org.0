Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C0F6DFC44
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 19:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjDLRHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 13:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjDLRHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 13:07:04 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1765E10CA
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 10:06:58 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-517c57386f6so515580a12.2
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 10:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681319217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bl/q3ahu5Bkb3irpxh7uWIDvMDi+ioe/v3wW/XN3NDg=;
        b=Xp22v0oFcp5f4b4T5Qg8PkGeILDp9MvhVFxaARLPcPhR3QoRdKvvHz0mmVs0qVFPru
         8frjaAremTyUm/woKk2rzLLSEFVrd9fqP8OB/SKox72lGamZZrqFpQtz/VLra+kpzcBD
         UIf2oPuvgjNr/ZOS2k+DfwOi1sFlfK0J5/i5sy4UOHtEK3Smd2V9JJGnrValJrlwNsZk
         z4OXi/CbCWbu/DDOYad4cDw+z1bWD/6DVIhJngCeYKUf1/CLkum2kSSftNfMHqluIxMK
         0QZyGq7oENrJ31gV0OMixa/EukWAyD+ocnngMfW0XhTmHC8srcGfKawh9543o4g+6AIR
         cqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681319217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bl/q3ahu5Bkb3irpxh7uWIDvMDi+ioe/v3wW/XN3NDg=;
        b=J9a0lH4D/vfg0ZtkvPYOqrlJEdcltfOroqOAAyuPd8grQYGLxqXx1AM6OxvEs8VK0j
         GsQ7G6IDWLHOiPRwONKljIN7nRB/k61j3pQ5rfwN24LEvEPCH42mCyBJkbLbok+i1MCP
         1PwRRuGylqw3IkcPVFoOOZwkUizJYDC3X/y+n7y+Zu5GKTfEdQ5KSjNQjTU9SKjzO62d
         lcFjpDI2xxSYPZdR1E1sEtrrPQVAi/Upks/Z+HPIiRsUa5B6g/ayNbjliBHQy4+Hqcpl
         eSz6gBz0l3Vt9npxqLywDepvo4tV/ByH+bdtr4SiCQiKHXYvipA2op3v7794px7fyOeA
         NDRQ==
X-Gm-Message-State: AAQBX9eQ37fIhYYWFTYcgyGohNzzKNB5jPhvykcGB0ViG/sInhIveSnu
        aU4weW+vvJcC47TfNWmPm3HIDA==
X-Google-Smtp-Source: AKy350YTAqLwxkoHwPIzj4y6fcjF1WPuF4FYRU9iAiFE9MrcuQ0Aksf7evAPKQkJB4hBrPQVNxrA+Q==
X-Received: by 2002:a05:6a00:179c:b0:63b:2102:a1c8 with SMTP id s28-20020a056a00179c00b0063b2102a1c8mr1474973pfg.12.1681319217432;
        Wed, 12 Apr 2023 10:06:57 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:1cd7:1135:5e45:5f77])
        by smtp.gmail.com with ESMTPSA id x5-20020aa79185000000b006260526cf0csm11969403pfa.116.2023.04.12.10.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 10:06:57 -0700 (PDT)
Date:   Wed, 12 Apr 2023 11:06:54 -0600
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v8 3/4] soc: ti: pruss: Add pruss_cfg_read()/update(),
 pruss_cfg_get_gpmux()/set_gpmux() APIs
Message-ID: <20230412170654.GC86761@p14s>
References: <20230412103012.1754161-1-danishanwar@ti.com>
 <20230412103012.1754161-4-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412103012.1754161-4-danishanwar@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 04:00:11PM +0530, MD Danish Anwar wrote:
> From: Suman Anna <s-anna@ti.com>
> 
> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
> the PRUSS platform driver to read and program respectively a register
> within the PRUSS CFG sub-module represented by a syscon driver. These
> APIs are internal to PRUSS driver.
> 
> Add two new helper functions pruss_cfg_get_gpmux() & pruss_cfg_set_gpmux()
> to get and set the GP MUX mode for programming the PRUSS internal wrapper
> mux functionality as needed by usecases.
> 
> Various useful registers and macros for certain register bit-fields and
> their values have also been added.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Reviewed-by: Roger Quadros <rogerq@kernel.org>
> Reviewed-by: Tony Lindgren <tony@atomide.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> ---
>  drivers/soc/ti/pruss.c       | 45 ++++++++++++++++++
>  drivers/soc/ti/pruss.h       | 88 ++++++++++++++++++++++++++++++++++++
>  include/linux/pruss_driver.h | 32 +++++++++++++
>  3 files changed, 165 insertions(+)
>  create mode 100644 drivers/soc/ti/pruss.h
> 
> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> index 8ada3758b31a..34d513816a9d 100644
> --- a/drivers/soc/ti/pruss.c
> +++ b/drivers/soc/ti/pruss.c
> @@ -21,6 +21,7 @@
>  #include <linux/regmap.h>
>  #include <linux/remoteproc.h>
>  #include <linux/slab.h>
> +#include "pruss.h"
>  
>  /**
>   * struct pruss_private_data - PRUSS driver private data
> @@ -168,6 +169,50 @@ int pruss_release_mem_region(struct pruss *pruss,
>  }
>  EXPORT_SYMBOL_GPL(pruss_release_mem_region);
>  
> +/**
> + * pruss_cfg_get_gpmux() - get the current GPMUX value for a PRU device
> + * @pruss: pruss instance
> + * @pru_id: PRU identifier (0-1)
> + * @mux: pointer to store the current mux value into
> + *
> + * Return: 0 on success, or an error code otherwise
> + */
> +int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux)
> +{
> +	int ret = 0;

Variable initialization is not needed.

> +	u32 val;
> +
> +	if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS || !mux)

If @pru_id is an enum, how can it be smaller than 0?

> +		return -EINVAL;
> +
> +	ret = pruss_cfg_read(pruss, PRUSS_CFG_GPCFG(pru_id), &val);
> +	if (!ret)
> +		*mux = (u8)((val & PRUSS_GPCFG_PRU_MUX_SEL_MASK) >>
> +			    PRUSS_GPCFG_PRU_MUX_SEL_SHIFT);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(pruss_cfg_get_gpmux);
> +
> +/**
> + * pruss_cfg_set_gpmux() - set the GPMUX value for a PRU device
> + * @pruss: pruss instance
> + * @pru_id: PRU identifier (0-1)
> + * @mux: new mux value for PRU
> + *
> + * Return: 0 on success, or an error code otherwise
> + */
> +int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux)
> +{
> +	if (mux >= PRUSS_GP_MUX_SEL_MAX ||
> +	    pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)

Same

> +		return -EINVAL;
> +
> +	return pruss_cfg_update(pruss, PRUSS_CFG_GPCFG(pru_id),
> +				PRUSS_GPCFG_PRU_MUX_SEL_MASK,
> +				(u32)mux << PRUSS_GPCFG_PRU_MUX_SEL_SHIFT);
> +}
> +EXPORT_SYMBOL_GPL(pruss_cfg_set_gpmux);
> +
>  static void pruss_of_free_clk_provider(void *data)
>  {
>  	struct device_node *clk_mux_np = data;
> diff --git a/drivers/soc/ti/pruss.h b/drivers/soc/ti/pruss.h
> new file mode 100644
> index 000000000000..6c55987e0e55
> --- /dev/null
> +++ b/drivers/soc/ti/pruss.h
> @@ -0,0 +1,88 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * PRU-ICSS Subsystem user interfaces
> + *
> + * Copyright (C) 2015-2023 Texas Instruments Incorporated - http://www.ti.com
> + *	MD Danish Anwar <danishanwar@ti.com>
> + */
> +
> +#ifndef _SOC_TI_PRUSS_H_
> +#define _SOC_TI_PRUSS_H_
> +
> +#include <linux/bits.h>
> +#include <linux/regmap.h>
> +
> +/*
> + * PRU_ICSS_CFG registers
> + * SYSCFG, ISRP, ISP, IESP, IECP, SCRP applicable on AMxxxx devices only
> + */
> +#define PRUSS_CFG_REVID         0x00
> +#define PRUSS_CFG_SYSCFG        0x04
> +#define PRUSS_CFG_GPCFG(x)      (0x08 + (x) * 4)
> +#define PRUSS_CFG_CGR           0x10
> +#define PRUSS_CFG_ISRP          0x14
> +#define PRUSS_CFG_ISP           0x18
> +#define PRUSS_CFG_IESP          0x1C
> +#define PRUSS_CFG_IECP          0x20
> +#define PRUSS_CFG_SCRP          0x24
> +#define PRUSS_CFG_PMAO          0x28
> +#define PRUSS_CFG_MII_RT        0x2C
> +#define PRUSS_CFG_IEPCLK        0x30
> +#define PRUSS_CFG_SPP           0x34
> +#define PRUSS_CFG_PIN_MX        0x40
> +
> +/* PRUSS_GPCFG register bits */
> +#define PRUSS_GPCFG_PRU_GPI_MODE_MASK           GENMASK(1, 0)
> +#define PRUSS_GPCFG_PRU_GPI_MODE_SHIFT          0
> +
> +#define PRUSS_GPCFG_PRU_MUX_SEL_SHIFT           26
> +#define PRUSS_GPCFG_PRU_MUX_SEL_MASK            GENMASK(29, 26)
> +
> +/* PRUSS_MII_RT register bits */
> +#define PRUSS_MII_RT_EVENT_EN                   BIT(0)
> +
> +/* PRUSS_SPP register bits */
> +#define PRUSS_SPP_XFER_SHIFT_EN                 BIT(1)
> +#define PRUSS_SPP_PRU1_PAD_HP_EN                BIT(0)
> +#define PRUSS_SPP_RTU_XFR_SHIFT_EN              BIT(3)
> +
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
> +#endif  /* _SOC_TI_PRUSS_H_ */
> diff --git a/include/linux/pruss_driver.h b/include/linux/pruss_driver.h
> index c8f2e53b911b..c70e08c90165 100644
> --- a/include/linux/pruss_driver.h
> +++ b/include/linux/pruss_driver.h
> @@ -14,6 +14,24 @@
>  #include <linux/types.h>
>  #include <linux/err.h>
>  
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

Initialization not needed

> +	PRUSS_GP_MUX_SEL_ENDAT,
> +	PRUSS_GP_MUX_SEL_RESERVED,
> +	PRUSS_GP_MUX_SEL_SD,
> +	PRUSS_GP_MUX_SEL_MII2,
> +	PRUSS_GP_MUX_SEL_MAX,
> +};
> +
>  /*
>   * enum pruss_mem - PRUSS memory range identifiers
>   */
> @@ -66,6 +84,8 @@ int pruss_request_mem_region(struct pruss *pruss, enum pruss_mem mem_id,
>  			     struct pruss_mem_region *region);
>  int pruss_release_mem_region(struct pruss *pruss,
>  			     struct pruss_mem_region *region);
> +int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux);
> +int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux);
>  
>  #else
>  
> @@ -89,6 +109,18 @@ static inline int pruss_release_mem_region(struct pruss *pruss,
>  	return -EOPNOTSUPP;
>  }
>  
> +static inline int pruss_cfg_get_gpmux(struct pruss *pruss,
> +				      enum pruss_pru_id pru_id, u8 *mux)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +static inline int pruss_cfg_set_gpmux(struct pruss *pruss,
> +				      enum pruss_pru_id pru_id, u8 mux)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
>  #endif /* CONFIG_TI_PRUSS */
>  
>  #endif	/* _PRUSS_DRIVER_H_ */
> -- 
> 2.34.1
> 
