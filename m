Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED0A6DFC26
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 19:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbjDLRBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 13:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbjDLRBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 13:01:34 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0487EEC
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 10:01:14 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j8so10607677pjy.4
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 10:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681318872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pfUsMfkrejVXr5qJizoytRX5TpIEEU2cEnidL9qtDPI=;
        b=wYiC7zU09HzT5NwU6kVUFeXU5eGu/ear7WFELkED0oHU9+asu/YX8c1hxHuOwY/5Yt
         r/ADbqytIgvlGPpgtJdPDa68WehaZFMZimJjpGObFMQrIt+3x7S4yPNH4b9q/z54xyne
         o7mu2G/EZHJsTfs2zimGZccO1A31Kum5g18LB3viozu0AmZiNqI4VRaCqgG1eLeTyBt7
         OQdC12oBUak1lSXsvUOZMIRIyzBoqIwNxqC+8+cYhNv2r6PzkvzHY2lhVy45vvjuZ/K+
         g6b8t48tnMa4Gc0Ztj/TllWL+3PtpB53HArPqnMtE2BxLgD9jPBEvfWRkcHHS6qEVEYC
         545w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681318872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pfUsMfkrejVXr5qJizoytRX5TpIEEU2cEnidL9qtDPI=;
        b=Vqcq4N6T2NridQOdvkC4A+4iqPzNL42aykrmGvpvYJKHJCUJ6inePuhxHkzw0+dQaU
         L3KipamLOjAMGPkPZPsaL6uYqTeEAxbpY6Q1Sel4yPv4jHhRw+GfEW5rDVPixBq/tmzl
         Uochpx0gQ8A2hifYrrlyXQAx56UeLYygxx75hoxuLwLVFunP9Hko4yRsBWJcPsb/qJRn
         7A2vxeCeZvR7zH+VAj83HpSmgYcIIiIzZQ67fgaVGsFOnLjAyovEndZ+psf97Mn45Zv2
         Fjew6jK27CZhy2iPaO9CNYKhsOISyhiN7ZfsDm0p+OlBOx2NHOKla+axBzsUoq8XsGYC
         dX1A==
X-Gm-Message-State: AAQBX9eKViAgZYGgpyGZMHLYzbk8XbGTX3fMzYDjbP5FNwSH/aBgm93X
        ohTnoZsNS8Psb42Iet1pk1r0nQ==
X-Google-Smtp-Source: AKy350bMg24lIg9DtnYv9P2T+iChkvOJJYeIXN0OleXUmzE+GwTjGgC/2dfRuQ61VwWLyEJ8A+ReCw==
X-Received: by 2002:a17:902:e749:b0:1a6:61b5:9e78 with SMTP id p9-20020a170902e74900b001a661b59e78mr5729967plf.20.1681318872311;
        Wed, 12 Apr 2023 10:01:12 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:1cd7:1135:5e45:5f77])
        by smtp.gmail.com with ESMTPSA id p6-20020a1709026b8600b001a04ff0e2eesm11749209plk.58.2023.04.12.10.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 10:01:11 -0700 (PDT)
Date:   Wed, 12 Apr 2023 11:01:09 -0600
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
Subject: Re: [PATCH v8 2/4] soc: ti: pruss: Add
 pruss_{request,release}_mem_region() API
Message-ID: <20230412170109.GB86761@p14s>
References: <20230412103012.1754161-1-danishanwar@ti.com>
 <20230412103012.1754161-3-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412103012.1754161-3-danishanwar@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 04:00:10PM +0530, MD Danish Anwar wrote:
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
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> ---
>  drivers/soc/ti/pruss.c       | 77 ++++++++++++++++++++++++++++++++++++
>  include/linux/pruss_driver.h | 22 +++++++++++
>  2 files changed, 99 insertions(+)
>

Acked-by: Mathieu Poirier <mathieu.poirier@linaro.org>

> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> index 3fac92df8790..8ada3758b31a 100644
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
> diff --git a/include/linux/pruss_driver.h b/include/linux/pruss_driver.h
> index cb40c2b31045..c8f2e53b911b 100644
> --- a/include/linux/pruss_driver.h
> +++ b/include/linux/pruss_driver.h
> @@ -9,6 +9,7 @@
>  #ifndef _PRUSS_DRIVER_H_
>  #define _PRUSS_DRIVER_H_
>  
> +#include <linux/mutex.h>
>  #include <linux/remoteproc/pruss.h>
>  #include <linux/types.h>
>  #include <linux/err.h>
> @@ -41,6 +42,8 @@ struct pruss_mem_region {
>   * @cfg_base: base iomap for CFG region
>   * @cfg_regmap: regmap for config region
>   * @mem_regions: data for each of the PRUSS memory regions
> + * @mem_in_use: to indicate if memory resource is in use
> + * @lock: mutex to serialize access to resources
>   * @core_clk_mux: clk handle for PRUSS CORE_CLK_MUX
>   * @iep_clk_mux: clk handle for PRUSS IEP_CLK_MUX
>   */
> @@ -49,6 +52,8 @@ struct pruss {
>  	void __iomem *cfg_base;
>  	struct regmap *cfg_regmap;
>  	struct pruss_mem_region mem_regions[PRUSS_MEM_MAX];
> +	struct pruss_mem_region *mem_in_use[PRUSS_MEM_MAX];
> +	struct mutex lock; /* PRU resource lock */
>  	struct clk *core_clk_mux;
>  	struct clk *iep_clk_mux;
>  };
> @@ -57,6 +62,10 @@ struct pruss {
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
> @@ -67,6 +76,19 @@ static inline struct pruss *pruss_get(struct rproc *rproc)
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
>  #endif	/* _PRUSS_DRIVER_H_ */
> -- 
> 2.34.1
> 
