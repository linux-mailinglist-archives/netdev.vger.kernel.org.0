Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6ED46CB059
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 23:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbjC0VFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 17:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjC0VE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 17:04:57 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB743589
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 14:04:38 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so10353614pjl.4
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 14:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679951072;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b3BlSIi0ORzZ5YgJoiJ2zZR40sarw+gdRjnKYSAtweI=;
        b=XVYLZAn82SNr8CHuqtmYkJkZke6Dwb9mmza6Tr6duyH2uLzwFpsGEuLJlDCtwLBXeM
         x4PC/Mn0BYOjv/ucNuYuqrQ+ALj9Kk5QnKKlYKeLQkFSjyW0gNE+CHsaY6Fu5qsGsEY3
         7sKht3oXlqDQGZoEfa0KPUbVpsIWayJfA0314uNadYqL7zK4B/ICYj+rRom7DohcVLAt
         3Kqhjc23jPUEKaW0NXYCGLrs533jGLTo2xuYyw4+eIgy8kL5o//6nSL1k1IYq0zE/ppK
         DelojTwVDNIRSYtuH/5P43ctd4w5cm/yqW5FTDK3t0dJn1gq/JXN8FSrhNrrfj5P2n8V
         ih4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679951072;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b3BlSIi0ORzZ5YgJoiJ2zZR40sarw+gdRjnKYSAtweI=;
        b=dtda45hiRBTW+rfUlBW6/QBVeT7GvGMV4I5Fj7gCQDu5pVnt7SlZJhF5x/JY7egL/Q
         LyMwNRFwMpTY2aPMfP8GdRlpHjf+tTlS76pSDrZsTAo77x3xkxlxaJFMulN5gKmgQAGC
         1rRBqUSX8GQaxNdntGWZeonmLHtEgO2HwNzqzkoa26Cpj7GsQO3+svpFAeiR7hRS/zIh
         ZDXd19/jP5JJUo031nveQ2+e7n46j4sB9hsuBL8xGY/HU1B4i7yRW75q51PR4784F31Q
         uGk6exo9uvlKdbo8W4bp8cN/6z+qhHcSC96GpQcUqi85O3HHHsQya2Y5yBqw4Smh5IJR
         LlhA==
X-Gm-Message-State: AO0yUKXgrCrgpWI+P9a+422e2SZab2t4sLGryd/dBehMsGl0ak0u/y9K
        vtg2kgG5tygXNZbvHzXLIETDgQ==
X-Google-Smtp-Source: AK7set+9TmZNqzYd+qlWo/KxKxwystgsk67yWtkfaeiArceRtBW2JX+3k+aWeo8cfu/+upasRFTHJw==
X-Received: by 2002:a05:6a20:3b26:b0:da:1b99:34f0 with SMTP id c38-20020a056a203b2600b000da1b9934f0mr11987345pzh.39.1679951072029;
        Mon, 27 Mar 2023 14:04:32 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:ad52:968f:ad4a:52d2])
        by smtp.gmail.com with ESMTPSA id 25-20020aa79159000000b0062bc045bf4fsm6212065pfi.19.2023.03.27.14.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 14:04:31 -0700 (PDT)
Date:   Mon, 27 Mar 2023 15:04:29 -0600
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
Subject: Re: [PATCH v5 5/5] soc: ti: pruss: Add helper functions to get/set
 PRUSS_CFG_GPMUX
Message-ID: <20230327210429.GD3158115@p14s>
References: <20230323062451.2925996-1-danishanwar@ti.com>
 <20230323062451.2925996-6-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323062451.2925996-6-danishanwar@ti.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 11:54:51AM +0530, MD Danish Anwar wrote:
> From: Tero Kristo <t-kristo@ti.com>
> 
> Add two new helper functions pruss_cfg_get_gpmux() & pruss_cfg_set_gpmux()
> to get and set the GP MUX mode for programming the PRUSS internal wrapper
> mux functionality as needed by usecases.
> 
> Co-developed-by: Suman Anna <s-anna@ti.com>
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> Reviewed-by: Roger Quadros <rogerq@kernel.org>
> ---
>  drivers/soc/ti/pruss.c           | 44 ++++++++++++++++++++++++++++++++
>  include/linux/remoteproc/pruss.h | 30 ++++++++++++++++++++++
>  2 files changed, 74 insertions(+)
> 
> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> index ac415442e85b..3aa3c38c6c79 100644
> --- a/drivers/soc/ti/pruss.c
> +++ b/drivers/soc/ti/pruss.c
> @@ -239,6 +239,50 @@ int pruss_cfg_xfr_enable(struct pruss *pruss, enum pru_type pru_type,
>  }
>  EXPORT_SYMBOL_GPL(pruss_cfg_xfr_enable);
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
> +	u32 val;
> +
> +	if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
> +		return -EINVAL;
> +
> +	ret = pruss_cfg_read(pruss, PRUSS_CFG_GPCFG(pru_id), &val);
> +	if (!ret)
> +		*mux = (u8)((val & PRUSS_GPCFG_PRU_MUX_SEL_MASK) >>
> +			    PRUSS_GPCFG_PRU_MUX_SEL_SHIFT);

What happens if @mux is NULL?

Thanks,
Mathieu


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
>  static void pruss_of_free_clk_provider(void *data)
>  {
>  	struct device_node *clk_mux_np = data;
> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
> index bb001f712980..42f1586c62ac 100644
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
>  /*
>   * enum pruss_gpi_mode - PRUSS GPI configuration modes, used
>   *			 to program the PRUSS_GPCFG0/1 registers
> @@ -110,6 +128,8 @@ int pruss_cfg_gpimode(struct pruss *pruss, enum pruss_pru_id pru_id,
>  int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable);
>  int pruss_cfg_xfr_enable(struct pruss *pruss, enum pru_type pru_type,
>  			 bool enable);
> +int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux);
> +int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux);
>  
>  #else
>  
> @@ -152,6 +172,16 @@ static inline int pruss_cfg_xfr_enable(struct pruss *pruss,
>  	return ERR_PTR(-EOPNOTSUPP);
>  }
>  
> +static inline int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +static inline int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
>  #endif /* CONFIG_TI_PRUSS */
>  
>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
> -- 
> 2.25.1
> 
