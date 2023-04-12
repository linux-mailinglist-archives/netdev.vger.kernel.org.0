Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACAFA6DFC64
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 19:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjDLRNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 13:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjDLRNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 13:13:33 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468F63C31
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 10:13:23 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id g3so13472326pja.2
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 10:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681319603;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qa7vbSbDt/Y53bvYnOJVV8xd5sd6KIE54ET/WRFnZro=;
        b=kg0TWR1YX9X8s1FKB5JBeTdXQdCFt/+w8CKPczEyNPnKAM5+8C/4MLPFuKINiovq3i
         SNEKmGMvTwF2oeGGoPVTWd+7Gn4RIUU0dPSf67RDJIuqXCYruhec0zAig8qzA4dQ4xxh
         cuNXNG5Z8l+W5UI3d5rMihFt3fZFAe8u4dgNkwMR9kgwpLt1KedwwCU2m+gcA/wx08ux
         FtByYXan/73k8ox3I2lcEN4hDECNSzelBAqLt05VJa4Hzn0MFQ24YKYjYbdtukpjHVA9
         xU+iT5F68pKtrf8/sDYJOEvlV2tZFRTAA6DeEFkfPKVlvKPf6xJZlcJ56YqbJdexbXv4
         KqdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681319603;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qa7vbSbDt/Y53bvYnOJVV8xd5sd6KIE54ET/WRFnZro=;
        b=llXBbJ6Katf6WZWSaE7l4rr8u925LaaO4T5/s1S8k3uh+bUGSQHunIj2zuhsjqeIpt
         jmksetoAYnL8WNbjkhnx+GqzFQugRlEdKqJ3yljkBDz56CqW8VgVqEf6pQQnnM+QPqgM
         6cUMSUViz0YWXiUgx9Wy8mbBPg/UZF+EsVQruzh5fUOHdQZfiV41OHvcUPHplK00ys6F
         euZ3IAXXsH1ukvcyA/FoRM3C0JMtbp3GFJMgxtBl78W7iNHJVPzy51XDeeuATifTbw4c
         LUB3THGXWb5MnopOwzSiLagXBNcvA8iZyik0iXZ50jYiJkQCYqJ2aNddtHZBQfEE9r1T
         C2jg==
X-Gm-Message-State: AAQBX9c+Ps/6qFs/N+o1SLlKEEx4lldwSvFco+03bJoFxZp0+CVGInn9
        U+5wCiTUI6huWUkOkJCyPNBlzw==
X-Google-Smtp-Source: AKy350Ym3EbNIP/6NLrt2kc4p9UDhtX0kcA9uoQ/0MmuCPambyehODK4OFzEgBsCVDCQyGOftuRaqw==
X-Received: by 2002:a17:902:d2d0:b0:1a6:7632:2b1a with SMTP id n16-20020a170902d2d000b001a676322b1amr2338095plc.64.1681319602618;
        Wed, 12 Apr 2023 10:13:22 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:1cd7:1135:5e45:5f77])
        by smtp.gmail.com with ESMTPSA id s16-20020a170902b19000b001a4edbabad3sm1816273plr.230.2023.04.12.10.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 10:13:22 -0700 (PDT)
Date:   Wed, 12 Apr 2023 11:13:19 -0600
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
Subject: Re: [PATCH v8 4/4] soc: ti: pruss: Add helper functions to set GPI
 mode, MII_RT_event and XFR
Message-ID: <20230412171319.GD86761@p14s>
References: <20230412103012.1754161-1-danishanwar@ti.com>
 <20230412103012.1754161-5-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412103012.1754161-5-danishanwar@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 04:00:12PM +0530, MD Danish Anwar wrote:
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
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> ---
>  drivers/remoteproc/pru_rproc.c | 15 -------
>  drivers/soc/ti/pruss.c         | 74 ++++++++++++++++++++++++++++++++++
>  include/linux/pruss_driver.h   | 51 +++++++++++++++++++++++
>  3 files changed, 125 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/remoteproc/pru_rproc.c b/drivers/remoteproc/pru_rproc.c
> index 095f66130f48..54f5ce302e7a 100644
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
> index 34d513816a9d..90a625ab9cfc 100644
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

Same

> +	if (mode < 0 || mode > PRUSS_GPI_MODE_MAX)
> +		return -EINVAL;
> +

Same

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
> diff --git a/include/linux/pruss_driver.h b/include/linux/pruss_driver.h
> index c70e08c90165..2a139bfda452 100644
> --- a/include/linux/pruss_driver.h
> +++ b/include/linux/pruss_driver.h
> @@ -32,6 +32,33 @@ enum pruss_gp_mux_sel {
>  	PRUSS_GP_MUX_SEL_MAX,
>  };
>  
> +/*
> + * enum pruss_gpi_mode - PRUSS GPI configuration modes, used
> + *			 to program the PRUSS_GPCFG0/1 registers
> + */
> +enum pruss_gpi_mode {
> +	PRUSS_GPI_MODE_DIRECT = 0,

Not needed

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

Same

With the above:
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>

> +	PRU_TYPE_RTU,
> +	PRU_TYPE_TX_PRU,
> +	PRU_TYPE_MAX,
> +};
> +
>  /*
>   * enum pruss_mem - PRUSS memory range identifiers
>   */
> @@ -86,6 +113,11 @@ int pruss_release_mem_region(struct pruss *pruss,
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
> @@ -121,6 +153,25 @@ static inline int pruss_cfg_set_gpmux(struct pruss *pruss,
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
>  #endif /* CONFIG_TI_PRUSS */
>  
>  #endif	/* _PRUSS_DRIVER_H_ */
> -- 
> 2.34.1
> 
