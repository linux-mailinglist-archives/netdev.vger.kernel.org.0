Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4477624DB1
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 23:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiKJWl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 17:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKJWl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 17:41:57 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A2849B4B;
        Thu, 10 Nov 2022 14:41:56 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d20so2749727plr.10;
        Thu, 10 Nov 2022 14:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e4Qs9bEMZ3gDq4us7OrdRRiLVNWHDOmZfbfm48tPnck=;
        b=qbRnu/4LZoqDMzfN1T1kE9YREn4aOucC9lhaWV9gbrwXT7sX/dmca+ETwg9QN60uej
         p8/Lw/7Tfa456Y3swGCmPC7MqQ9wuo3x4IukSs7pmsB4ZnVsmSs6tCcwu9jjzAnodbID
         5z6W2WyndMTL55lQSd6SEjmbeOvJ014Xw6UZzuJqQT+N0mn2hlEUwKTU3depJF9O3/yy
         dxi0S3JnQZrzAGrA6eUWxlA+OBuyUHzpwHeNquZ6sfczJiRhHbx2YxTizx5S/KCtX6y3
         o6jTHlJzo9M4Vm8OAmn/VAOTw2r0tZWDzXdgIMx8zflLzC5EOviXDk7Wu/i/68YDy2Ch
         f8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e4Qs9bEMZ3gDq4us7OrdRRiLVNWHDOmZfbfm48tPnck=;
        b=NF81mlpqs9W/awISe20nct9Wxkzr0pKkCmr8LbBq0fowwV7WCApUSGnWmck/QrCSKj
         SyacJ+50R3VXWCu/N24PNwKE23xRAFoB/V3OX1ofxIrUJdUAsrqI2+CMCQlwDc333yxa
         vBfQhRyC0pYF5C9Hqf5QvdgJac4U9Frv6w0S1VBCZLX2Fai2GxhTYdvhIEcx39a5/WVk
         o4XFwI0GUkIRTp0syp8JTaFJC5aBQwV/ilmVXC1vYGgVX9Wrx8yuKzvOTntoicxOGpvM
         4ZA11zng4PDxcpA1tbmvxHGgEIhtJqOhxOcKDAQWQOm7aUfvq2eE3jt8gMBEgSGnHU61
         h8XA==
X-Gm-Message-State: ACrzQf195ICPz7ZTbXFKvUQh1jKEKuEf5NMkLXw998mdBq/8r80DgEYs
        WntnwT1T48KCcA0rm33FuZI=
X-Google-Smtp-Source: AMsMyM4nyW6+yaR60JXHJABSjQGw+eHKUCsaYHz+iJNpbD3jbsh6paIIOlj4vz9grbTk8YBdFHZ+aw==
X-Received: by 2002:a17:902:8211:b0:183:7f67:25d7 with SMTP id x17-20020a170902821100b001837f6725d7mr2346968pln.164.1668120115608;
        Thu, 10 Nov 2022 14:41:55 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:2eb5:1c59:61e8:a36d])
        by smtp.gmail.com with ESMTPSA id d17-20020a170902ced100b001868ed86a95sm188133plg.174.2022.11.10.14.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 14:41:54 -0800 (PST)
Date:   Thu, 10 Nov 2022 14:41:51 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Balamanikandan Gunasundar 
        <balamanikandan.gunasundar@microchip.com>
Cc:     ludovic.desroches@microchip.com, ulf.hansson@linaro.org,
        nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        3chas3@gmail.com, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH] mmc: atmel-mci: Convert to gpio descriptors
Message-ID: <Y21+L01BcPQ35FYi@google.com>
References: <20221109043845.16617-1-balamanikandan.gunasundar@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109043845.16617-1-balamanikandan.gunasundar@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Balamanikandan,

On Wed, Nov 09, 2022 at 10:08:45AM +0530, Balamanikandan Gunasundar wrote:
> Replace the legacy GPIO APIs with gpio descriptor consumer interface.
> 
> To maintain backward compatibility, we rely on the "cd-inverted"
> property to manage the invertion flag instead of GPIO property.
> 
> Signed-off-by: Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>
> ---
>  drivers/mmc/host/atmel-mci.c | 79 ++++++++++++++++++------------------
>  include/linux/atmel-mci.h    |  4 +-
>  2 files changed, 41 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 67b2cd166e56..1df90966e104 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -19,7 +19,8 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> -#include <linux/of_gpio.h>
> +#include <linux/irq.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/platform_device.h>
>  #include <linux/scatterlist.h>
>  #include <linux/seq_file.h>
> @@ -389,8 +390,8 @@ struct atmel_mci_slot {
>  #define ATMCI_CARD_NEED_INIT	1
>  #define ATMCI_SHUTDOWN		2
>  
> -	int			detect_pin;
> -	int			wp_pin;
> +	struct gpio_desc        *detect_pin;
> +	struct gpio_desc	*wp_pin;
>  	bool			detect_is_active_high;
>  
>  	struct timer_list	detect_timer;
> @@ -638,7 +639,11 @@ atmci_of_init(struct platform_device *pdev)
>  			pdata->slot[slot_id].bus_width = 1;
>  
>  		pdata->slot[slot_id].detect_pin =
> -			of_get_named_gpio(cnp, "cd-gpios", 0);
> +			devm_gpiod_get_from_of_node(&pdev->dev, cnp,
> +						    "cd-gpios",
> +						    0, GPIOD_IN, "cd-gpios");

As I mentioned in another email, please use devm_fwnode_gpiod_get()
instead of devm_gpiod_get_from_of_node() which is going away.

> +		if (IS_ERR(pdata->slot[slot_id].detect_pin))
> +			pdata->slot[slot_id].detect_pin = NULL;

I think it would be much better if we had proper error handling and did
something like:

		err = PTR_ERR_OR_ZERO(pdata->slot[slot_id].detect_pin);
		if (err) {
			if (err != -ENOENT)
				return ERR_PTR(err);
			pdata->slot[slot_id].detect_pin = NULL;
		}

This will help with proper deferral handling.

>  
>  		pdata->slot[slot_id].detect_is_active_high =
>  			of_property_read_bool(cnp, "cd-inverted");

Instead of doing gpiod_set_value_raw() below I would recommend handling
it here via gpiod_is_active_low() and gpiod_toggle_active_low() and
removing the flag from atmel_mci_slot structure.


> @@ -647,7 +652,11 @@ atmci_of_init(struct platform_device *pdev)
>  			of_property_read_bool(cnp, "non-removable");
>  
>  		pdata->slot[slot_id].wp_pin =
> -			of_get_named_gpio(cnp, "wp-gpios", 0);
> +			devm_gpiod_get_from_of_node(&pdev->dev, cnp,
> +						    "wp-gpios",
> +						    0, GPIOD_IN, "wp-gpios");
> +		if (IS_ERR(pdata->slot[slot_id].wp_pin))
> +			pdata->slot[slot_id].wp_pin = NULL;
>  	}
>  
>  	return pdata;
> @@ -1511,8 +1520,8 @@ static int atmci_get_ro(struct mmc_host *mmc)
>  	int			read_only = -ENOSYS;
>  	struct atmel_mci_slot	*slot = mmc_priv(mmc);
>  
> -	if (gpio_is_valid(slot->wp_pin)) {
> -		read_only = gpio_get_value(slot->wp_pin);
> +	if (slot->wp_pin) {
> +		read_only = gpiod_get_value(slot->wp_pin);

Consider using "cansleep" variants.

Thanks.

-- 
Dmitry
