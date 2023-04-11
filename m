Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E386DE346
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjDKR5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjDKR5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:57:12 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B34D59CA
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:57:11 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id jx2-20020a17090b46c200b002469a9ff94aso6996682pjb.3
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681235830;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXbDM1ImhdsbAlX5z/W3cgh/RDeLJTPqUHcpprXXqrI=;
        b=Pe50bdhimru+N/2HOljtZmyOoxclKuA8dwD8vHMj/wTGm2q+w6oqit4YahOasjbSha
         AMbONG0/q2aUcdmelgB9qgZ1iwUAmwsiiXC1x7I3jdHtRlYE6cz+vvfq2yB/6ZUVp8Gl
         MEysICPLawzNdU6WcAZ2PpjMCi7/uwmAdt8PZHuW6NgeGBpRfeqBnQ/swpi+zcnx0iC+
         24wHa5d31Kn6QfGldVxQrQQ20PZsRNVJj4yfBGLeNwmK3NOaSxs1NnlD0lYVKhJC1s+h
         hNYmqVJU0gg01GaWFc1JaNe+gOleUte9vINUNhzY6WhovauG7H+/+BoF3wWE6NVBZxM9
         AhnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681235830;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXbDM1ImhdsbAlX5z/W3cgh/RDeLJTPqUHcpprXXqrI=;
        b=dHbkJ7in3niv0AWxNLkoNZJ7YdCMDjYO1QxJHrTusiYmB0WqUlP5eAptbaPTMyVUP7
         XF8q5AgRhm5WVUBBhrH43hsfrHhVVqmar1Kc021rsERkc3qEdBR3x3KR5uczA1VglI1P
         09nr9E/mzt4FZQ1TJbFk4mzm2YnTz2967LmAaNiYLeZE3+fdLdw9K/t21i7vTclr/Q3U
         MggYdf/moINo3PB5yWwTwC7+TUDf7dTFXmLJCjCtbk6roTURPy59wZTZCp0bVxGNtp+v
         RyhyRYi9EUyLBHfRGLJHbxmGvL7a8ipQOOf8g86XkLuNxdWc3wjaxpSru32Af/h70JGe
         BeXQ==
X-Gm-Message-State: AAQBX9fJVOKPI8ULN0n0Qw23CZsIXh0u+XacSW30OzpW0iFGOE6ZLpmI
        4v67PiO6fb+SGLXqf5o+JXjGGA==
X-Google-Smtp-Source: AKy350ZN9Il+nr1BgDR94DewMoio2CPd0j/HHP3oUqhd0/9J/DasM1Br0S+P8KV0fQblKMu/Th/CVw==
X-Received: by 2002:a17:902:788f:b0:1a6:6afc:2d67 with SMTP id q15-20020a170902788f00b001a66afc2d67mr37276pll.61.1681235830196;
        Tue, 11 Apr 2023 10:57:10 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:f795:eecb:467b:d183])
        by smtp.gmail.com with ESMTPSA id d3-20020a170902854300b001a1a9a639c2sm5501289plo.134.2023.04.11.10.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 10:57:09 -0700 (PDT)
Date:   Tue, 11 Apr 2023 11:57:07 -0600
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
Subject: Re: [PATCH v7 4/4] soc: ti: pruss: Add helper functions to set GPI
 mode, MII_RT_event and XFR
Message-ID: <20230411175707.GE38361@p14s>
References: <20230404115336.599430-1-danishanwar@ti.com>
 <20230404115336.599430-5-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404115336.599430-5-danishanwar@ti.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 05:23:36PM +0530, MD Danish Anwar wrote:
> From: Suman Anna <s-anna@ti.com>
> 
> The PRUSS CFG module is represented as a syscon node and is currently
> managed by the PRUSS platform driver. Add easy accessor functions to set
> GPI mode, MII_RT event enable/disable and XFR (XIN XOUT) enable/disable
> to enable the PRUSS Ethernet usecase. These functions reuse the generic
> pruss_cfg_update() API function.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Reviewed-by: Roger Quadros <rogerq@kernel.org>
> Reviewed-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> ---
>  drivers/remoteproc/pru_rproc.c   | 15 -------
>  drivers/soc/ti/pruss.c           | 74 ++++++++++++++++++++++++++++++++
>  include/linux/remoteproc/pruss.h | 51 ++++++++++++++++++++++
>  3 files changed, 125 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/remoteproc/pru_rproc.c b/drivers/remoteproc/pru_rproc.c
> index 4ddd5854d56e..a88861737dec 100644
> --- a/drivers/remoteproc/pru_rproc.c
> +++ b/drivers/remoteproc/pru_rproc.c
> @@ -81,21 +81,6 @@ enum pru_iomem {
>  	PRU_IOMEM_MAX,
>  };
>  
> -/**
> - * enum pru_type - PRU core type identifier
> - *
> - * @PRU_TYPE_PRU: Programmable Real-time Unit
> - * @PRU_TYPE_RTU: Auxiliary Programmable Real-Time Unit
> - * @PRU_TYPE_TX_PRU: Transmit Programmable Real-Time Unit
> - * @PRU_TYPE_MAX: just keep this one at the end
> - */
> -enum pru_type {
> -	PRU_TYPE_PRU = 0,
> -	PRU_TYPE_RTU,
> -	PRU_TYPE_TX_PRU,
> -	PRU_TYPE_MAX,
> -};
> -
>  /**
>   * struct pru_private_data - device data for a PRU core
>   * @type: type of the PRU core (PRU, RTU, Tx_PRU)
> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> index 0e37fe142615..64a1880ba4ee 100644
> --- a/drivers/soc/ti/pruss.c
> +++ b/drivers/soc/ti/pruss.c
> @@ -213,6 +213,80 @@ int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux)
>  }
>  EXPORT_SYMBOL_GPL(pruss_cfg_set_gpmux);
>  
> +/**
> + * pruss_cfg_gpimode() - set the GPI mode of the PRU
> + * @pruss: the pruss instance handle
> + * @pru_id: id of the PRU core within the PRUSS
> + * @mode: GPI mode to set
> + *
> + * Sets the GPI mode for a given PRU by programming the
> + * corresponding PRUSS_CFG_GPCFGx register
> + *
> + * Return: 0 on success, or an error code otherwise
> + */
> +int pruss_cfg_gpimode(struct pruss *pruss, enum pruss_pru_id pru_id,
> +		      enum pruss_gpi_mode mode)
> +{
> +	if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
> +		return -EINVAL;
> +
> +	if (mode < 0 || mode > PRUSS_GPI_MODE_MAX)
> +		return -EINVAL;
> +
> +	return pruss_cfg_update(pruss, PRUSS_CFG_GPCFG(pru_id),
> +				PRUSS_GPCFG_PRU_GPI_MODE_MASK,
> +				mode << PRUSS_GPCFG_PRU_GPI_MODE_SHIFT);
> +}
> +EXPORT_SYMBOL_GPL(pruss_cfg_gpimode);
> +
> +/**
> + * pruss_cfg_miirt_enable() - Enable/disable MII RT Events
> + * @pruss: the pruss instance
> + * @enable: enable/disable
> + *
> + * Enable/disable the MII RT Events for the PRUSS.
> + *
> + * Return: 0 on success, or an error code otherwise
> + */
> +int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable)
> +{
> +	u32 set = enable ? PRUSS_MII_RT_EVENT_EN : 0;
> +
> +	return pruss_cfg_update(pruss, PRUSS_CFG_MII_RT,
> +				PRUSS_MII_RT_EVENT_EN, set);
> +}
> +EXPORT_SYMBOL_GPL(pruss_cfg_miirt_enable);
> +
> +/**
> + * pruss_cfg_xfr_enable() - Enable/disable XIN XOUT shift functionality
> + * @pruss: the pruss instance
> + * @pru_type: PRU core type identifier
> + * @enable: enable/disable
> + *
> + * Return: 0 on success, or an error code otherwise
> + */
> +int pruss_cfg_xfr_enable(struct pruss *pruss, enum pru_type pru_type,
> +			 bool enable)
> +{
> +	u32 mask, set;
> +
> +	switch (pru_type) {
> +	case PRU_TYPE_PRU:
> +		mask = PRUSS_SPP_XFER_SHIFT_EN;
> +		break;
> +	case PRU_TYPE_RTU:
> +		mask = PRUSS_SPP_RTU_XFR_SHIFT_EN;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	set = enable ? mask : 0;
> +
> +	return pruss_cfg_update(pruss, PRUSS_CFG_SPP, mask, set);
> +}
> +EXPORT_SYMBOL_GPL(pruss_cfg_xfr_enable);
> +
>  static void pruss_of_free_clk_provider(void *data)
>  {
>  	struct device_node *clk_mux_np = data;
> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
> index 5641153459a7..b68ab8735247 100644
> --- a/include/linux/remoteproc/pruss.h
> +++ b/include/linux/remoteproc/pruss.h
> @@ -34,6 +34,33 @@ enum pruss_gp_mux_sel {
>  	PRUSS_GP_MUX_SEL_MAX,
>  };
>  
> +/*
> + * enum pruss_gpi_mode - PRUSS GPI configuration modes, used
> + *			 to program the PRUSS_GPCFG0/1 registers
> + */
> +enum pruss_gpi_mode {
> +	PRUSS_GPI_MODE_DIRECT = 0,
> +	PRUSS_GPI_MODE_PARALLEL,
> +	PRUSS_GPI_MODE_28BIT_SHIFT,
> +	PRUSS_GPI_MODE_MII,
> +	PRUSS_GPI_MODE_MAX,
> +};
> +
> +/**
> + * enum pru_type - PRU core type identifier
> + *
> + * @PRU_TYPE_PRU: Programmable Real-time Unit
> + * @PRU_TYPE_RTU: Auxiliary Programmable Real-Time Unit
> + * @PRU_TYPE_TX_PRU: Transmit Programmable Real-Time Unit
> + * @PRU_TYPE_MAX: just keep this one at the end
> + */
> +enum pru_type {
> +	PRU_TYPE_PRU = 0,
> +	PRU_TYPE_RTU,
> +	PRU_TYPE_TX_PRU,
> +	PRU_TYPE_MAX,
> +};
> +

These go in pruss_driver.h

>  /**
>   * enum pruss_pru_id - PRU core identifiers
>   * @PRUSS_PRU0: PRU Core 0.
> @@ -98,6 +125,11 @@ int pruss_release_mem_region(struct pruss *pruss,
>  			     struct pruss_mem_region *region);
>  int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux);
>  int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux);
> +int pruss_cfg_gpimode(struct pruss *pruss, enum pruss_pru_id pru_id,
> +		      enum pruss_gpi_mode mode);
> +int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable);
> +int pruss_cfg_xfr_enable(struct pruss *pruss, enum pru_type pru_type,
> +			 bool enable);
>  
>  #else
>  
> @@ -133,6 +165,25 @@ static inline int pruss_cfg_set_gpmux(struct pruss *pruss,
>  	return ERR_PTR(-EOPNOTSUPP);
>  }
>  
> +static inline int pruss_cfg_gpimode(struct pruss *pruss,
> +				    enum pruss_pru_id pru_id,
> +				    enum pruss_gpi_mode mode)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +static inline int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +static inline int pruss_cfg_xfr_enable(struct pruss *pruss,
> +				       enum pru_type pru_type,
> +				       bool enable);
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +

So do these.

Thanks,
Mathieu

>  #endif /* CONFIG_TI_PRUSS */
>  
>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
> -- 
> 2.25.1
> 
