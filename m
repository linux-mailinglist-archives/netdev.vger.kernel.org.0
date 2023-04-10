Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C196DC9C1
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 19:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjDJRJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 13:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbjDJRJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 13:09:34 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EC4213C
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 10:09:31 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id px4so2824056pjb.3
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 10:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681146571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/qMzLcyJA7tAXp1tU9NgIQftvKNUnbdSk4uhIyzQdXg=;
        b=aRyRJJOQxWN4G2mHZw3wX92LiwUgwbLbNJpMU6pXr6+HWBy2vFq2b2/I2j9g6RpyPz
         cGlLHgzluMcUMXg+5mK97nn8upV18SgSSz+09CXLpjXelc+BxSVaSL3F9fR8XaJ91YgD
         Ml2z7pxPh7zxL4FWiq7uqN/6prv+CvLnhihto+RYTwQe1+w/RynGF7Uf9SI9daB3CYjj
         Sxdm/zBtoA34EggZZVNyOnMQo0UgVjCgYrHtrepEhJHaAK2lJNis2LUGbMuQ734yUOBl
         0UqOGjDSY8uxY7w4RxpRdngcwa3ZQuDrYGjE30OjZZnMBMSfdTTQUqMkW+OCnvrWH59u
         b41w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681146571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/qMzLcyJA7tAXp1tU9NgIQftvKNUnbdSk4uhIyzQdXg=;
        b=oAHXtcgWJczjBuHWKOSDeuAyPy6EsNCaYJFiqIkJOGKV5KvKYK9+MBHtBQBSOJeZco
         wN80Sg4CrFydou26rSFOtkK00MhFELkvANOxSmWdZNYMVJZiQCxTtQsygMXCByhNkdFU
         4TfVWHcvC4gSHC9qvfeQ5shO96yMg/Y8whqRlQS3oDLw/RGfIXAJy8j3sGRIEI8xEHhl
         7TveR6QwWERVVlEl5OBG9dik2d1MEu/2y9Bo9BRbBDIEOkzXsns0IdCezU33+nGNFjZ8
         PyZJ8R9vUudBNHZl4uBw/ju5Z5m2ecxG7uIufuK6nUOG+xKcTW0PdZwKV4Ct4stAk4rg
         W/lw==
X-Gm-Message-State: AAQBX9eIZ9joVNHSSsULwxhBjrwaVeyNjQrXzOAi03hVSLWS+Jf01n5i
        6vR24IWjIJ5lKv+vVyqHzZVodA==
X-Google-Smtp-Source: AKy350bBNfrIDV8cxyDWxKg9zw5e5Ci36xNMs12c4lXqHzdILQOt602MGpS9B0xwJ84nnLbLIM3LMA==
X-Received: by 2002:a17:90b:1d8e:b0:246:681c:71fd with SMTP id pf14-20020a17090b1d8e00b00246681c71fdmr12582430pjb.6.1681146570979;
        Mon, 10 Apr 2023 10:09:30 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:cecd:b1ee:70ec:874])
        by smtp.gmail.com with ESMTPSA id d22-20020a631d56000000b00513468106d8sm7142726pgm.1.2023.04.10.10.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 10:09:30 -0700 (PDT)
Date:   Mon, 10 Apr 2023 11:09:27 -0600
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
Subject: Re: [PATCH v7 1/4] soc: ti: pruss: Add pruss_get()/put() API
Message-ID: <20230410170927.GA4129213@p14s>
References: <20230404115336.599430-1-danishanwar@ti.com>
 <20230404115336.599430-2-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404115336.599430-2-danishanwar@ti.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 05:23:33PM +0530, MD Danish Anwar wrote:
> From: Tero Kristo <t-kristo@ti.com>
> 
> Add two new get and put API, pruss_get() and pruss_put() to the
> PRUSS platform driver to allow client drivers to request a handle
> to a PRUSS device. This handle will be used by client drivers to
> request various operations of the PRUSS platform driver through
> additional API that will be added in the following patches.
> 
> The pruss_get() function returns the pruss handle corresponding
> to a PRUSS device referenced by a PRU remoteproc instance. The
> pruss_put() is the complimentary function to pruss_get().
> 
> Co-developed-by: Suman Anna <s-anna@ti.com>
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Reviewed-by: Roger Quadros <rogerq@kernel.org>
> Reviewed-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> ---
>  drivers/remoteproc/pru_rproc.c                |  2 +-
>  drivers/soc/ti/pruss.c                        | 64 ++++++++++++++++++-
>  .../{pruss_driver.h => pruss_internal.h}      |  7 +-
>  include/linux/remoteproc/pruss.h              | 19 ++++++
>  4 files changed, 87 insertions(+), 5 deletions(-)
>  rename include/linux/{pruss_driver.h => pruss_internal.h} (90%)
>

Throughout this patchset an API to access resources required by the PRUSS
is added to pruss.c but all the function declarations are added to
remoteproc/pruss.h.  Is this something you were asked to do or is this how the
original implementation was?

Other than pruss_get() nothing in there is related to the remoteproc
subsystem, the bulk of the work is all about PRUSS.

In my opinion all the function declaration should go in pruss_driver.h, which
should stay as it is and not made internal.  The code looks good now but it
needs to be added where it belongs.

Thanks,
Mathieu

> diff --git a/drivers/remoteproc/pru_rproc.c b/drivers/remoteproc/pru_rproc.c
> index b76db7fa693d..4ddd5854d56e 100644
> --- a/drivers/remoteproc/pru_rproc.c
> +++ b/drivers/remoteproc/pru_rproc.c
> @@ -19,7 +19,7 @@
>  #include <linux/of_device.h>
>  #include <linux/of_irq.h>
>  #include <linux/remoteproc/pruss.h>
> -#include <linux/pruss_driver.h>
> +#include <linux/pruss_internal.h>
>  #include <linux/remoteproc.h>
>  
>  #include "remoteproc_internal.h"
> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> index 6882c86b3ce5..28b77d715903 100644
> --- a/drivers/soc/ti/pruss.c
> +++ b/drivers/soc/ti/pruss.c
> @@ -6,6 +6,7 @@
>   * Author(s):
>   *	Suman Anna <s-anna@ti.com>
>   *	Andrew F. Davis <afd@ti.com>
> + *	Tero Kristo <t-kristo@ti.com>
>   */
>  
>  #include <linux/clk-provider.h>
> @@ -16,8 +17,9 @@
>  #include <linux/of_address.h>
>  #include <linux/of_device.h>
>  #include <linux/pm_runtime.h>
> -#include <linux/pruss_driver.h>
> +#include <linux/pruss_internal.h>
>  #include <linux/regmap.h>
> +#include <linux/remoteproc.h>
>  #include <linux/slab.h>
>  
>  /**
> @@ -30,6 +32,66 @@ struct pruss_private_data {
>  	bool has_core_mux_clock;
>  };
>  
> +/**
> + * pruss_get() - get the pruss for a given PRU remoteproc
> + * @rproc: remoteproc handle of a PRU instance
> + *
> + * Finds the parent pruss device for a PRU given the @rproc handle of the
> + * PRU remote processor. This function increments the pruss device's refcount,
> + * so always use pruss_put() to decrement it back once pruss isn't needed
> + * anymore.
> + *
> + * This API doesn't check if @rproc is valid or not. It is expected the caller
> + * will have done a pru_rproc_get() on @rproc, before calling this API to make
> + * sure that @rproc is valid.
> + *
> + * Return: pruss handle on success, and an ERR_PTR on failure using one
> + * of the following error values
> + *    -EINVAL if invalid parameter
> + *    -ENODEV if PRU device or PRUSS device is not found
> + */
> +struct pruss *pruss_get(struct rproc *rproc)
> +{
> +	struct pruss *pruss;
> +	struct device *dev;
> +	struct platform_device *ppdev;
> +
> +	if (IS_ERR_OR_NULL(rproc))
> +		return ERR_PTR(-EINVAL);
> +
> +	dev = &rproc->dev;
> +
> +	/* make sure it is PRU rproc */
> +	if (!dev->parent || !is_pru_rproc(dev->parent))
> +		return ERR_PTR(-ENODEV);
> +
> +	ppdev = to_platform_device(dev->parent->parent);
> +	pruss = platform_get_drvdata(ppdev);
> +	if (!pruss)
> +		return ERR_PTR(-ENODEV);
> +
> +	get_device(pruss->dev);
> +
> +	return pruss;
> +}
> +EXPORT_SYMBOL_GPL(pruss_get);
> +
> +/**
> + * pruss_put() - decrement pruss device's usecount
> + * @pruss: pruss handle
> + *
> + * Complimentary function for pruss_get(). Needs to be called
> + * after the PRUSS is used, and only if the pruss_get() succeeds.
> + */
> +void pruss_put(struct pruss *pruss)
> +{
> +	if (IS_ERR_OR_NULL(pruss))
> +		return;
> +
> +	put_device(pruss->dev);
> +}
> +EXPORT_SYMBOL_GPL(pruss_put);
> +
>  static void pruss_of_free_clk_provider(void *data)
>  {
>  	struct device_node *clk_mux_np = data;
> diff --git a/include/linux/pruss_driver.h b/include/linux/pruss_internal.h
> similarity index 90%
> rename from include/linux/pruss_driver.h
> rename to include/linux/pruss_internal.h
> index ecfded30ed05..8f91cb164054 100644
> --- a/include/linux/pruss_driver.h
> +++ b/include/linux/pruss_internal.h
> @@ -6,9 +6,10 @@
>   *	Suman Anna <s-anna@ti.com>
>   */
>  
> -#ifndef _PRUSS_DRIVER_H_
> -#define _PRUSS_DRIVER_H_
> +#ifndef _PRUSS_INTERNAL_H_
> +#define _PRUSS_INTERNAL_H_
>  
> +#include <linux/remoteproc/pruss.h>
>  #include <linux/types.h>
>  
>  /*
> @@ -51,4 +52,4 @@ struct pruss {
>  	struct clk *iep_clk_mux;
>  };
>  
> -#endif	/* _PRUSS_DRIVER_H_ */
> +#endif	/* _PRUSS_INTERNAL_H_ */
> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
> index 039b50d58df2..93a98cac7829 100644
> --- a/include/linux/remoteproc/pruss.h
> +++ b/include/linux/remoteproc/pruss.h
> @@ -4,12 +4,14 @@
>   *
>   * Copyright (C) 2015-2022 Texas Instruments Incorporated - http://www.ti.com
>   *	Suman Anna <s-anna@ti.com>
> + *	Tero Kristo <t-kristo@ti.com>
>   */
>  
>  #ifndef __LINUX_PRUSS_H
>  #define __LINUX_PRUSS_H
>  
>  #include <linux/device.h>
> +#include <linux/err.h>
>  #include <linux/types.h>
>  
>  #define PRU_RPROC_DRVNAME "pru-rproc"
> @@ -44,6 +46,23 @@ enum pru_ctable_idx {
>  
>  struct device_node;
>  struct rproc;
> +struct pruss;
> +
> +#if IS_ENABLED(CONFIG_TI_PRUSS)
> +
> +struct pruss *pruss_get(struct rproc *rproc);
> +void pruss_put(struct pruss *pruss);
> +
> +#else
> +
> +static inline struct pruss *pruss_get(struct rproc *rproc)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +static inline void pruss_put(struct pruss *pruss) { }
> +
> +#endif /* CONFIG_TI_PRUSS */
>  
>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
>  
> -- 
> 2.25.1
> 
