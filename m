Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474666DE328
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjDKRvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjDKRvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:51:47 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDC86A59
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:51:41 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-632384298b3so4336728b3a.0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681235501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qbuj7VpjZ04yn+wg2bJaslUI/L4vbCkU/bi684VY7gU=;
        b=rGqy3gXENEdQs9vwdi5+0tC3AYSczqHIF80RMZjqiYEC8liJHBMqz38foZT4QOZJHf
         2BEiKR+utiGB6SNIy6QKcFABt+CjNDhFonLiW1GEKifNs6KbEhLK6JWn31aUy4f3Wo+D
         QMb2xGdP6Dp1s7JEKq1KNQK6mqlh9kA+DwQ8hv3wnqjGQOdJZ3lcOwmQL/R2eTNJPIx0
         BlSKSjOV1coNnS5G1X/RQy1xv5DeH1pkC1fKohcn8IyExr2IRswySVeMImOJDLCUhuHv
         KU2K9SCdluLLdPipsRNPlljEcsGuKcbaQiUN7iFtd89VoQbxmejkjCcyXpnzEi4VwbtB
         PqmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681235501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qbuj7VpjZ04yn+wg2bJaslUI/L4vbCkU/bi684VY7gU=;
        b=p3V6j1NVMu8Suz2aheSLrNnDdz4OhEq5bW9fbsEfuM4GWDyl4a0PambES7skkN5WZK
         E84UJxuV+R+K6oYr8eiQTUAP1sD+oEWlpne0xKUw/G7GrMSdKkTAL0ZUoR9wtu2jxmq6
         AAnnyCdKf9H8hPnBCqlkH3rGHcCqMx/QVpi5ohVcpWt38+kkvlz19Le2eotDalTD9+4Y
         0x7t5hlNa3NADqAP/ReGs4tM/ZcMVTqSyG4PPk+mWrs+2O0/+HgWGuDIuhCbqkUpt4BV
         +JrB7B8QZvI/1iuUpEkyLkfpJeLg3ZsZDwmdlBDAdRBUcupQgAL29fJWSZAOi7rEvNm4
         JYuw==
X-Gm-Message-State: AAQBX9dj/yYMFum863pGK4GsngjuscSPFWzJmsliOGU/UI+4JJ/DIDI/
        a4qmyVilNp7HaxMgueCbLTfsrQ==
X-Google-Smtp-Source: AKy350YEP9DijctCtVBhRuMX8F/0ocKY2aSATqLaLy16Q+DL1r+vUkiiec1juOtOMmYHlgtGSQUC1A==
X-Received: by 2002:a62:ab14:0:b0:625:524b:9712 with SMTP id p20-20020a62ab14000000b00625524b9712mr41711pff.2.1681235500775;
        Tue, 11 Apr 2023 10:51:40 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:f795:eecb:467b:d183])
        by smtp.gmail.com with ESMTPSA id s21-20020a056a00195500b006243e706195sm10084448pfk.196.2023.04.11.10.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 10:51:40 -0700 (PDT)
Date:   Tue, 11 Apr 2023 11:51:37 -0600
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
Subject: Re: [PATCH v7 2/4] soc: ti: pruss: Add
 pruss_{request,release}_mem_region() API
Message-ID: <20230411175137.GC38361@p14s>
References: <20230404115336.599430-1-danishanwar@ti.com>
 <20230404115336.599430-3-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404115336.599430-3-danishanwar@ti.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 05:23:34PM +0530, MD Danish Anwar wrote:
> From: "Andrew F. Davis" <afd@ti.com>
> 
> Add two new API - pruss_request_mem_region() & pruss_release_mem_region(),
> to the PRUSS platform driver to allow client drivers to acquire and release
> the common memory resources present within a PRU-ICSS subsystem. This
> allows the client drivers to directly manipulate the respective memories,
> as per their design contract with the associated firmware.
> 
> Co-developed-by: Suman Anna <s-anna@ti.com>
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Signed-off-by: Andrew F. Davis <afd@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Reviewed-by: Roger Quadros <rogerq@kernel.org>
> Acked-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> ---
>  drivers/soc/ti/pruss.c           | 77 ++++++++++++++++++++++++++++++++
>  include/linux/pruss_internal.h   | 27 +++--------
>  include/linux/remoteproc/pruss.h | 39 ++++++++++++++++
>  3 files changed, 121 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> index 28b77d715903..7aa0f7171af1 100644
> --- a/drivers/soc/ti/pruss.c
> +++ b/drivers/soc/ti/pruss.c
> @@ -92,6 +92,82 @@ void pruss_put(struct pruss *pruss)
>  }
>  EXPORT_SYMBOL_GPL(pruss_put);
>  
> +/**
> + * pruss_request_mem_region() - request a memory resource
> + * @pruss: the pruss instance
> + * @mem_id: the memory resource id
> + * @region: pointer to memory region structure to be filled in
> + *
> + * This function allows a client driver to request a memory resource,
> + * and if successful, will let the client driver own the particular
> + * memory region until released using the pruss_release_mem_region()
> + * API.
> + *
> + * Return: 0 if requested memory region is available (in such case pointer to
> + * memory region is returned via @region), an error otherwise
> + */
> +int pruss_request_mem_region(struct pruss *pruss, enum pruss_mem mem_id,
> +			     struct pruss_mem_region *region)
> +{
> +	if (!pruss || !region || mem_id >= PRUSS_MEM_MAX)
> +		return -EINVAL;
> +
> +	mutex_lock(&pruss->lock);
> +
> +	if (pruss->mem_in_use[mem_id]) {
> +		mutex_unlock(&pruss->lock);
> +		return -EBUSY;
> +	}
> +
> +	*region = pruss->mem_regions[mem_id];
> +	pruss->mem_in_use[mem_id] = region;
> +
> +	mutex_unlock(&pruss->lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pruss_request_mem_region);
> +
> +/**
> + * pruss_release_mem_region() - release a memory resource
> + * @pruss: the pruss instance
> + * @region: the memory region to release
> + *
> + * This function is the complimentary function to
> + * pruss_request_mem_region(), and allows the client drivers to
> + * release back a memory resource.
> + *
> + * Return: 0 on success, an error code otherwise
> + */
> +int pruss_release_mem_region(struct pruss *pruss,
> +			     struct pruss_mem_region *region)
> +{
> +	int id;
> +
> +	if (!pruss || !region)
> +		return -EINVAL;
> +
> +	mutex_lock(&pruss->lock);
> +
> +	/* find out the memory region being released */
> +	for (id = 0; id < PRUSS_MEM_MAX; id++) {
> +		if (pruss->mem_in_use[id] == region)
> +			break;
> +	}
> +
> +	if (id == PRUSS_MEM_MAX) {
> +		mutex_unlock(&pruss->lock);
> +		return -EINVAL;
> +	}
> +
> +	pruss->mem_in_use[id] = NULL;
> +
> +	mutex_unlock(&pruss->lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pruss_release_mem_region);
> +

These stay here.

>  static void pruss_of_free_clk_provider(void *data)
>  {
>  	struct device_node *clk_mux_np = data;
> @@ -294,6 +370,7 @@ static int pruss_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	pruss->dev = dev;
> +	mutex_init(&pruss->lock);
>  
>  	child = of_get_child_by_name(np, "memories");
>  	if (!child) {
> diff --git a/include/linux/pruss_internal.h b/include/linux/pruss_internal.h
> index 8f91cb164054..cf5287fa01df 100644
> --- a/include/linux/pruss_internal.h
> +++ b/include/linux/pruss_internal.h
> @@ -9,37 +9,18 @@
>  #ifndef _PRUSS_INTERNAL_H_
>  #define _PRUSS_INTERNAL_H_
>  
> +#include <linux/mutex.h>
>  #include <linux/remoteproc/pruss.h>
>  #include <linux/types.h>
>  
> -/*
> - * enum pruss_mem - PRUSS memory range identifiers
> - */
> -enum pruss_mem {
> -	PRUSS_MEM_DRAM0 = 0,
> -	PRUSS_MEM_DRAM1,
> -	PRUSS_MEM_SHRD_RAM2,
> -	PRUSS_MEM_MAX,
> -};
> -
> -/**
> - * struct pruss_mem_region - PRUSS memory region structure
> - * @va: kernel virtual address of the PRUSS memory region
> - * @pa: physical (bus) address of the PRUSS memory region
> - * @size: size of the PRUSS memory region
> - */
> -struct pruss_mem_region {
> -	void __iomem *va;
> -	phys_addr_t pa;
> -	size_t size;
> -};
> -

These stay here.

>  /**
>   * struct pruss - PRUSS parent structure
>   * @dev: pruss device pointer
>   * @cfg_base: base iomap for CFG region
>   * @cfg_regmap: regmap for config region
>   * @mem_regions: data for each of the PRUSS memory regions
> + * @mem_in_use: to indicate if memory resource is in use
> + * @lock: mutex to serialize access to resources
>   * @core_clk_mux: clk handle for PRUSS CORE_CLK_MUX
>   * @iep_clk_mux: clk handle for PRUSS IEP_CLK_MUX
>   */
> @@ -48,6 +29,8 @@ struct pruss {
>  	void __iomem *cfg_base;
>  	struct regmap *cfg_regmap;
>  	struct pruss_mem_region mem_regions[PRUSS_MEM_MAX];
> +	struct pruss_mem_region *mem_in_use[PRUSS_MEM_MAX];
> +	struct mutex lock; /* PRU resource lock */
>  	struct clk *core_clk_mux;
>  	struct clk *iep_clk_mux;
>  };
> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
> index 93a98cac7829..33f930e0a0ce 100644
> --- a/include/linux/remoteproc/pruss.h
> +++ b/include/linux/remoteproc/pruss.h
> @@ -44,6 +44,28 @@ enum pru_ctable_idx {
>  	PRU_C31,
>  };
>  
> +/*
> + * enum pruss_mem - PRUSS memory range identifiers
> + */
> +enum pruss_mem {
> +	PRUSS_MEM_DRAM0 = 0,
> +	PRUSS_MEM_DRAM1,
> +	PRUSS_MEM_SHRD_RAM2,
> +	PRUSS_MEM_MAX,
> +};
> +
> +/**
> + * struct pruss_mem_region - PRUSS memory region structure
> + * @va: kernel virtual address of the PRUSS memory region
> + * @pa: physical (bus) address of the PRUSS memory region
> + * @size: size of the PRUSS memory region
> + */
> +struct pruss_mem_region {
> +	void __iomem *va;
> +	phys_addr_t pa;
> +	size_t size;
> +};
> +
>  struct device_node;
>  struct rproc;
>  struct pruss;
> @@ -52,6 +74,10 @@ struct pruss;
>  
>  struct pruss *pruss_get(struct rproc *rproc);
>  void pruss_put(struct pruss *pruss);
> +int pruss_request_mem_region(struct pruss *pruss, enum pruss_mem mem_id,
> +			     struct pruss_mem_region *region);
> +int pruss_release_mem_region(struct pruss *pruss,
> +			     struct pruss_mem_region *region);
>  
>  #else
>  
> @@ -62,6 +88,19 @@ static inline struct pruss *pruss_get(struct rproc *rproc)
>  
>  static inline void pruss_put(struct pruss *pruss) { }
>  
> +static inline int pruss_request_mem_region(struct pruss *pruss,
> +					   enum pruss_mem mem_id,
> +					   struct pruss_mem_region *region)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline int pruss_release_mem_region(struct pruss *pruss,
> +					   struct pruss_mem_region *region)
> +{
> +	return -EOPNOTSUPP;
> +}
> +

These go in pruss_driver.h

>  #endif /* CONFIG_TI_PRUSS */
>  
>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
> -- 
> 2.25.1
> 
