Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4A46CB037
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 22:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjC0U75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 16:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjC0U7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 16:59:55 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEAF12F
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 13:59:52 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so13115631pjp.1
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 13:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679950792;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uG/5wcDW+jLGbvb1fCE7bHB6/XtxbvifgcwRAVEJYi4=;
        b=ycBvad2Dx5zKzGBEIS1WZwXbjxoyNagbqYrk/KL+Jd+Fr/juDTLbx3Pc9XN905n7gI
         VQBVHRjY3sy1rPMuQ/QytvclS20looFDbLGenJdg/B4yENyay1oASx0Zd1Ee3B2CwwWW
         4WkcLDmd7x3A0pNyGSOSbpEcgAi5bPH/SKQAbz4EfWG+6DSQ071QiqceOU5HJXTkqYFT
         5Vkgi8ZRUm4LhhllfBMyx7Mwr4SggPgZA7GUi4YQSKOpCA6KiDSa/udL87uMUx4kAwvc
         TtmU1ASAbMDoCWhwvgsEl1Gg7arAc0v1XVguqjH42xlYLLdvtRdjbDqf6gLjt7pKACoQ
         LmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679950792;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uG/5wcDW+jLGbvb1fCE7bHB6/XtxbvifgcwRAVEJYi4=;
        b=MlVKTlJXl1LIJVJluoVcISm2r8VN5n9mSvJc2MMwXiEeSlOCCGZ1zm/LEPQNYA2xZS
         AECMaAP6o+wmvgPFx3VPiuSTbAVqT/q9QRh+xK5jb0SMP0s6zZ1Qap0dMgHbpsDqK9CC
         a9Eg9+r5eWSFSOrmypBJ2cYegJGltvaIcQ8qngYWpwN6pZLfqVbbbxsZpJKPQHxwMytG
         LOvXuEJehN+mGRPeRvXrD68+/A9Vg8H48UQV+O/PEb6jaGUgz1wKQUagZr4fnEjjUs3h
         JGAE4ANEWynvp0SlvrqxtvdJqWPU1qZVwWgwm7t3saFLnQvxueplr18peeJbgiOzf41N
         ir4g==
X-Gm-Message-State: AO0yUKUdkhQtuPfghkXzD3f71YkA1d24nB+Gu0VdmSnuIMz2s459IcgE
        WUtdOdYcRBvcz7wGyucO6TDf6Q==
X-Google-Smtp-Source: AK7set9i6RdM+/nS0UZXf5xpBIi9+7RTu/f1JtTBiUjLYdX/roJr8T0EX+OplleFlQM8CaMWy1LRFA==
X-Received: by 2002:a05:6a20:ba83:b0:db:b960:d319 with SMTP id fb3-20020a056a20ba8300b000dbb960d319mr12660514pzb.12.1679950792228;
        Mon, 27 Mar 2023 13:59:52 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:ad52:968f:ad4a:52d2])
        by smtp.gmail.com with ESMTPSA id c26-20020aa781da000000b0062d7fa4b618sm2778708pfn.175.2023.03.27.13.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 13:59:51 -0700 (PDT)
Date:   Mon, 27 Mar 2023 14:59:49 -0600
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
Subject: Re: [PATCH v5 2/5] soc: ti: pruss: Add
 pruss_{request,release}_mem_region() API
Message-ID: <20230327205949.GB3158115@p14s>
References: <20230323062451.2925996-1-danishanwar@ti.com>
 <20230323062451.2925996-3-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323062451.2925996-3-danishanwar@ti.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 11:54:48AM +0530, MD Danish Anwar wrote:
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
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> Reviewed-by: Roger Quadros <rogerq@kernel.org>

Acked-by: Mathieu Poirier <mathieu.poirier@linaro.org>

> ---
>  drivers/soc/ti/pruss.c           | 77 ++++++++++++++++++++++++++++++++
>  include/linux/pruss_internal.h   | 27 +++--------
>  include/linux/remoteproc/pruss.h | 39 ++++++++++++++++
>  3 files changed, 121 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> index 6c2bb02a521d..126b672b9b30 100644
> --- a/drivers/soc/ti/pruss.c
> +++ b/drivers/soc/ti/pruss.c
> @@ -88,6 +88,82 @@ void pruss_put(struct pruss *pruss)
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
>  static void pruss_of_free_clk_provider(void *data)
>  {
>  	struct device_node *clk_mux_np = data;
> @@ -290,6 +366,7 @@ static int pruss_probe(struct platform_device *pdev)
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
>  #endif /* CONFIG_TI_PRUSS */
>  
>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
> -- 
> 2.25.1
> 
