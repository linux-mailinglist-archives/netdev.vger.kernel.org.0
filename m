Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD513BDCBE
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 20:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhGFSLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 14:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbhGFSLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 14:11:02 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1BCC061768
        for <netdev@vger.kernel.org>; Tue,  6 Jul 2021 11:08:23 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id n99-20020a9d206c0000b029045d4f996e62so22493182ota.4
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 11:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rFh4HQBpaw9ewOD7eKuJ7KI9YAzHhN8tlxJ6LopMKHs=;
        b=Sz6rE6fIxKghlltcLCE+UXPsQefAUgPvTMscjeRzq2kl6NTGV49umux5xM0XcDuF3f
         KuSKKfkZ8nSISGEXHz3w1v+CP9bxuRJkim+LBmkXAMBhskBSVWy4R8UYC7L1pwY+g7hz
         Zg3WKG3mRVhsusU5VFmdXh5UPocqhZf4lahEU95r9tDGNbsVfHF1Q4HkA+YZfm/i81fd
         v0xNi9dJEaEvf856OdG6fjSc31APYItT+IUiPzbg0w9QbfcYoXqLRo58SwLlUHuXr/Qb
         gjgu5RAVRwk/bKL57rYJjqGIxVt7qPeDusZUEamQ36NdV7/ZYwdc/uo7wSJkJLcpf0tD
         jOXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rFh4HQBpaw9ewOD7eKuJ7KI9YAzHhN8tlxJ6LopMKHs=;
        b=KjZjibMyZXGkz9u7stOtsoe/2j1RJhqT1mwcgx/HQuivbOR4dBQ4fklKhaT6cAYV07
         yNDV5JrNveAQ2CYO+IHv6LFGAcp1wMVPigOscdcTxo5wABoMDXaWX+zVky9w0/NSjw92
         cUyoHLAKBcS60MqyBv1asK9JdzxSdo8DUksiYClL7qTlJmSctUqhSBOnNcuZS5oitzr1
         VUEy6uzzpGjuqDz14Z0KRw4n/fuFiXZMiYjaJEpYf+GoZidDa0L3FczpLi86Ggnzj+Xo
         wMCxUY3nK3GGWucDeE5Xk4SCQBECoHAbrxJA7clk37wOd63cKCl3qoSM6LucKW6lone0
         orYg==
X-Gm-Message-State: AOAM5308P8z+P85J2kA361YSmsE9cBcMxQLLLNcY87Z6OuGKxQFY23cB
        lYVUT2yW1gr8acA5hyLnyau2JA==
X-Google-Smtp-Source: ABdhPJwwC8pa+wbm0v5SSaX+DFJoQ7jJmXTjdD3iH0933Y2rw8Y2+zYlxp2w0qjcBNkHXGnjSvRJ6w==
X-Received: by 2002:a9d:3d3:: with SMTP id f77mr16276146otf.43.1625594902170;
        Tue, 06 Jul 2021 11:08:22 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id 68sm497113otd.74.2021.07.06.11.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 11:08:21 -0700 (PDT)
Date:   Tue, 6 Jul 2021 13:08:18 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Cc:     kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-sunxi@lists.linux.dev,
        linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
        dmaengine@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-fpga@vger.kernel.org, linux-input@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-i3c@lists.infradead.org,
        industrypack-devel@lists.sourceforge.net,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-ntb@googlegroups.com,
        linux-pci@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-scsi@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-arm-msm@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-staging@lists.linux.dev,
        greybus-dev@lists.linaro.org, target-devel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 4/4] bus: Make remove callback return void
Message-ID: <YOSb1+yeVeLxiSRc@yoga>
References: <20210706154803.1631813-1-u.kleine-koenig@pengutronix.de>
 <20210706154803.1631813-5-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706154803.1631813-5-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 06 Jul 10:48 CDT 2021, Uwe Kleine-K?nig wrote:

> The driver core ignores the return value of this callback because there
> is only little it can do when a device disappears.
> 
> This is the final bit of a long lasting cleanup quest where several
> buses were converted to also return void from their remove callback.
> Additionally some resource leaks were fixed that were caused by drivers
> returning an error code in the expectation that the driver won't go
> away.
> 
> With struct bus_type::remove returning void it's prevented that newly
> implemented buses return an ignored error code and so don't anticipate
> wrong expectations for driver authors.
> 

Thanks for doing this!

Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org> (rpmsg and apr)

[..]
> diff --git a/drivers/rpmsg/rpmsg_core.c b/drivers/rpmsg/rpmsg_core.c
> index c1404d3dae2c..7f6fac618ab2 100644
> --- a/drivers/rpmsg/rpmsg_core.c
> +++ b/drivers/rpmsg/rpmsg_core.c
> @@ -530,7 +530,7 @@ static int rpmsg_dev_probe(struct device *dev)
>  	return err;
>  }
>  
> -static int rpmsg_dev_remove(struct device *dev)
> +static void rpmsg_dev_remove(struct device *dev)
>  {
>  	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
>  	struct rpmsg_driver *rpdrv = to_rpmsg_driver(rpdev->dev.driver);
> @@ -546,8 +546,6 @@ static int rpmsg_dev_remove(struct device *dev)
>  
>  	if (rpdev->ept)
>  		rpmsg_destroy_ept(rpdev->ept);
> -
> -	return err;

This leaves err assigned but never used, but I don't mind following up
with a patch cleaning that up after this has landed.

>  }
>  
>  static struct bus_type rpmsg_bus = {

Regards,
Bjorn
