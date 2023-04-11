Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF646DE31D
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjDKRtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjDKRtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:49:45 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067544EF1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:49:42 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id ik20so8484604plb.3
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681235381;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jaebHLqve3sr3PjhNWP7eX3jN2UJi3CqLa3+FrX8x6s=;
        b=kA4FhnB8aG0ab2N8mylFWLmJfZnYWVGEzKp0pZXAocXC/y+0BsxCOp+cbv5mj68I4b
         mS/362UmBdA+MtafvCOJW8hiQsr9o1F5Sg55B58ZwTWoLUe/DACmSEG+Pg5G5G8h6iuV
         PsBgLSPzVrAQ1LAYXxko8L1iiU//KBkCDRrklc2rlqF9Ob4iEVT3yiKBVXgJ2CaVYI8V
         LCb/QgvQBRb910+kWXq3rk9bhfBBLbIHtao27XdO9tSeLNUlWPjGy/AVEHoSGnof56dw
         pXb5GGgtkZW34Vv+hOOXxcDQ8VHOquDAjN8hinsQl9q6qfkbWQoq2O71I3uZ3mCWyUAO
         6qJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681235381;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jaebHLqve3sr3PjhNWP7eX3jN2UJi3CqLa3+FrX8x6s=;
        b=fx/SnP9PWIdZc7qOxZQLtolijp3FQl1y6e5dqJGMbjQGujTKmwrLACA4I9KVykmfIT
         G+B7x9ficKTHf1uZKEUquXW1G4C6aYoZcUu/En5S4GNbXY842fl//2NcsXWUfSbMN26p
         SfyhT8RDEXMMogXBVlo1z7S+dUtnnMAmP4EaBVbsNnYbyf3zvPJJXuA9GclH+t6HcKX3
         qWHWsMXTEpIvUTxilMQYl4xkpFiMBgOJB5rKJdpcEsChBYiv6h1SNNeLzEMN65Ou9Efo
         ThKlKOODe8QRCH+HGk4uWTOqxAkdKmPecVRYHq6LSfar8/dbZLOaVYFCeHtUBtTeMiTK
         wxfQ==
X-Gm-Message-State: AAQBX9dIlMf7LY7rhIQInuh77V7RqPSbS6hKXlSjLECTuAgoqr7yRvls
        HHQVNG9oRjAEhYlpP5eIi8x3dQ==
X-Google-Smtp-Source: AKy350ZR3zysgzggrix4Kf++ZHjpsKtVeF09whw+wPV8LPhDGW9uk/3nyPygD/2zY7/UjM+B9SM8tw==
X-Received: by 2002:a05:6a20:49b0:b0:d8:bd6d:e122 with SMTP id fs48-20020a056a2049b000b000d8bd6de122mr3712989pzb.29.1681235381478;
        Tue, 11 Apr 2023 10:49:41 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:f795:eecb:467b:d183])
        by smtp.gmail.com with ESMTPSA id s21-20020aa78295000000b0062dc14ee2a7sm10099273pfm.211.2023.04.11.10.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 10:49:41 -0700 (PDT)
Date:   Tue, 11 Apr 2023 11:49:38 -0600
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
Message-ID: <20230411174938.GB38361@p14s>
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

Don't rename pruss_driver.h.  There is no point in having a file in the include
directory that contains a single struct declaration.

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

pruss_get() and pruss_put() stay here.

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

These go in pruss_driver.h

>  
>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
>  
> -- 
> 2.25.1
> 
