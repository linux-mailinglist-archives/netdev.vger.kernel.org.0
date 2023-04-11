Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED8C6DE33E
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjDKRzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjDKRzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:55:39 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5795161AC
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:55:23 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id la3so8453663plb.11
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681235723;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z+wspxn3j8gJu++FUxqZxSsWrkX6WZYur+w31HVIo5E=;
        b=jG8rRP3d4bbGoXxIrEK0OYEnK+b1IjcF+Cs+d6eaZYAX94ri9Pum9fa/+Jx/A8HxCF
         8yweRQp7oBFt+OYlXPYoxiHC0myTQjUhpLTLBRSfX1kjxW4TzvPfm6R+Abvncimgydpi
         8YVDIFQcJmYCOyu+hpFjn2i56NA8kajSGOLy100OrURts2D0nrWuQ35uox5L9Ui5Z8LC
         ClxFJKHQiV1SGHSKHUPJiHIO5HCZCvF/5PfhWRU0WHFeW6tNfTdtpPOrbHRdoeOq26mU
         Kfd758hRYmRMtOMzXvjfmG38HbHI2dWTnWiagWfNiLa73Ngxqqoln8Wg4TUWWzLNMs6Z
         ptVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681235723;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+wspxn3j8gJu++FUxqZxSsWrkX6WZYur+w31HVIo5E=;
        b=jU0fbPB1D4ypdVJIrkTpaLy5ugM9zEVcri/GQ0oTevS4yxq/jqMkQzCaQDyTxhcS+C
         Jr8QJUomyseHDEn7/yTFaXN0GQGM8Srul6ov46SefXsTSCXIpjlbAU+Ngia1NxTetzmQ
         ru34ZyQilsCvINtAg9qGbe81QhNDZ9VWdek/kAuVv6jJxZ3e0wetFdTgZK4RKfcN3jX+
         Ye5egIwjvQptxtkQpcCQZkmkOut3c7PDcKFzjoPdtE64Z8m3vVwV6aOxwCmn/DYiWkos
         eD9/0gvFVUG0dA7anfdLJSHndzIifrfly/AgHcNvAtk5QEWEXcN4UU6h8yB/UV6lWu16
         ASrQ==
X-Gm-Message-State: AAQBX9dGokK7i5YOu0Ng0hJmDCUiwr0xs9Jtnr9lJNIjd52fjkQCy6fr
        wRi6kzTlzkCGF3YEhXXVynMjsA==
X-Google-Smtp-Source: AKy350ZjzcTensJICOA4UuuuSXUEOa1haZjIESZWRdZ7Rh5k0GVM8LtE8IMxyCZ59c/F/5oquUzaxQ==
X-Received: by 2002:a17:902:e892:b0:199:4be8:be48 with SMTP id w18-20020a170902e89200b001994be8be48mr17406540plg.19.1681235722790;
        Tue, 11 Apr 2023 10:55:22 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:f795:eecb:467b:d183])
        by smtp.gmail.com with ESMTPSA id bg12-20020a1709028e8c00b001a50dcd10c8sm8601290plb.277.2023.04.11.10.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 10:55:22 -0700 (PDT)
Date:   Tue, 11 Apr 2023 11:55:19 -0600
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
Subject: Re: [PATCH v7 3/4] soc: ti: pruss: Add pruss_cfg_read()/update(),
 pruss_cfg_get_gpmux()/set_gpmux() APIs
Message-ID: <20230411175519.GD38361@p14s>
References: <20230404115336.599430-1-danishanwar@ti.com>
 <20230404115336.599430-4-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404115336.599430-4-danishanwar@ti.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 05:23:35PM +0530, MD Danish Anwar wrote:
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
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> ---
>  drivers/soc/ti/pruss.c           | 45 ++++++++++++++++
>  drivers/soc/ti/pruss.h           | 88 ++++++++++++++++++++++++++++++++
>  include/linux/remoteproc/pruss.h | 32 ++++++++++++
>  3 files changed, 165 insertions(+)
>  create mode 100644 drivers/soc/ti/pruss.h
> 
> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> index 7aa0f7171af1..0e37fe142615 100644
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
> + w
> + * Return: 0 on success, or an error code otherwise
> + */
> +int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux)
> +{
> +	int ret = 0;
> +	u32 val;
> +
> +	if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS || !mux)
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
> +		return -EINVAL;
> +
> +	return pruss_cfg_update(pruss, PRUSS_CFG_GPCFG(pru_id),
> +				PRUSS_GPCFG_PRU_MUX_SEL_MASK,
> +				(u32)mux << PRUSS_GPCFG_PRU_MUX_SEL_SHIFT);
> +}
> +EXPORT_SYMBOL_GPL(pruss_cfg_set_gpmux);
> +

These stay here.

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

Everything in pruss.h is ok.

> +#endif  /* _SOC_TI_PRUSS_H_ */
> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
> index 33f930e0a0ce..5641153459a7 100644
> --- a/include/linux/remoteproc/pruss.h
> +++ b/include/linux/remoteproc/pruss.h
> @@ -16,6 +16,24 @@
>  
>  #define PRU_RPROC_DRVNAME "pru-rproc"
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
> +	PRUSS_GP_MUX_SEL_ENDAT,
> +	PRUSS_GP_MUX_SEL_RESERVED,
> +	PRUSS_GP_MUX_SEL_SD,
> +	PRUSS_GP_MUX_SEL_MII2,
> +	PRUSS_GP_MUX_SEL_MAX,
> +};
> +
>  /**
>   * enum pruss_pru_id - PRU core identifiers
>   * @PRUSS_PRU0: PRU Core 0.
> @@ -78,6 +96,8 @@ int pruss_request_mem_region(struct pruss *pruss, enum pruss_mem mem_id,
>  			     struct pruss_mem_region *region);
>  int pruss_release_mem_region(struct pruss *pruss,
>  			     struct pruss_mem_region *region);
> +int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux);
> +int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux);
>  
>  #else
>  
> @@ -101,6 +121,18 @@ static inline int pruss_release_mem_region(struct pruss *pruss,
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

All of this goes in pruss_driver.h

>  #endif /* CONFIG_TI_PRUSS */
>  
>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
> -- 
> 2.25.1
> 
