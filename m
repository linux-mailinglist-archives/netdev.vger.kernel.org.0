Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6CA6CB032
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 22:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbjC0U6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 16:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjC0U6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 16:58:48 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE412117
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 13:58:45 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso10353548pjb.2
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 13:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679950725;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eH1CJX04q2BHUR5TJOFKJGoWhDyShBC0LXQUgI8ky8M=;
        b=J3o54tF0lNEkesTpP5H1LlTIpmJlYC/zA8uXtDj4vzg1d1dSPjT3iSz0JcuXDw63lZ
         BAuLhmRwwfAi3TYxK/P1vfWLXL5TxZRAj4LjqE6kSg3uT776Z9kjGD1bcXR/5wTlbvJj
         sYXbAy2/1dUNBNmrNsLIjz9O8Yar7App3XBwpxXyuXcDH28vBiHRSVW2RcRwBb/3nZaF
         okREhu68L83ulgoPoH/KyCSVqCuwKfdGq4nMEcmTc2DzrBrkGICpvy+veFdr/1iThqc3
         2ouszMCDmMIHCK3u6Aq7EW9UBbulDhd9WXfyHuYDt/y/P2l6DGrgQXiZ6mwQXFs5/kVZ
         OvFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679950725;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eH1CJX04q2BHUR5TJOFKJGoWhDyShBC0LXQUgI8ky8M=;
        b=ACSiHwPF1H9kScFW5/a6XhrDk/3Y7Boj/KgaeJDQtYXJaXnJNQh82/8XyEf7j2DmzE
         OhAEobcNPLVJ5c/W2XbuCln/uYjXK4ju+MJSQfY9Dyyw6tJAbAu4IF2onH89a1t6cYOT
         Kn+xk3kt40OKjVjDfHjX1EeKZLscvf1YSNgmD7n+oprkJZjyYsyess3rQuw5aowp9tfj
         l/Q0u2XiwfWqrzh7Ioi3cNpaL59CnhzlFD9Y4lvZnlwff7D1qPYSChqCpc5gOylZ8uVO
         Hrq07zU1ummpBm/lTIVfyvB1lunlSmCGW74LNyl269nFCRPhsND9jlCgLzDWER/g47qA
         cMGQ==
X-Gm-Message-State: AO0yUKXdEo1i34B3n3ZSYSWWV8NPWq8D2NA08wU4seOD34grHvnqTtro
        R0t6nTOTcgGpqCax5JfYhsNVnw==
X-Google-Smtp-Source: AK7set+nDTrsfcNlBKMWgUMp0C+CrZ+copoRG2Tzs6C6eZzeKaYjFY9667WrepMwzomNCv3HfVYCKA==
X-Received: by 2002:a05:6a20:4ca3:b0:dd:44a8:9d2c with SMTP id fq35-20020a056a204ca300b000dd44a89d2cmr11207157pzb.47.1679950724652;
        Mon, 27 Mar 2023 13:58:44 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:ad52:968f:ad4a:52d2])
        by smtp.gmail.com with ESMTPSA id y18-20020a62b512000000b0062d8c855ee9sm1909108pfe.149.2023.03.27.13.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 13:58:44 -0700 (PDT)
Date:   Mon, 27 Mar 2023 14:58:41 -0600
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
Subject: Re: [PATCH v5 1/5] soc: ti: pruss: Add pruss_get()/put() API
Message-ID: <20230327205841.GA3158115@p14s>
References: <20230323062451.2925996-1-danishanwar@ti.com>
 <20230323062451.2925996-2-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323062451.2925996-2-danishanwar@ti.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Danish

On Thu, Mar 23, 2023 at 11:54:47AM +0530, MD Danish Anwar wrote:
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
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> Reviewed-by: Roger Quadros <rogerq@kernel.org>
> ---
>  drivers/remoteproc/pru_rproc.c                |  2 +-
>  drivers/soc/ti/pruss.c                        | 60 ++++++++++++++++++-
>  .../{pruss_driver.h => pruss_internal.h}      |  7 ++-
>  include/linux/remoteproc/pruss.h              | 19 ++++++
>  4 files changed, 83 insertions(+), 5 deletions(-)
>  rename include/linux/{pruss_driver.h => pruss_internal.h} (90%)
> 
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
> index 6882c86b3ce5..6c2bb02a521d 100644
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
> @@ -30,6 +32,62 @@ struct pruss_private_data {
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

There is no guarantee that @rproc is valid without calling rproc_get_by_handle()
or pru_rproc_get().

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
