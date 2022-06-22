Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69071554E20
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 17:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358494AbiFVPAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 11:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiFVPAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 11:00:20 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCFB3DDE6;
        Wed, 22 Jun 2022 08:00:17 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e63so14830414pgc.5;
        Wed, 22 Jun 2022 08:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NUInGvIaCWlBmCyU3f6jLXuI/R6odOMByfzoWikcb6k=;
        b=qKj3B6pJG5pUu4ic64fh4xm5fzzwN/rV7rBmQr1cmr5obfi3R7Tr7cElyP08nV2Vq1
         sPxZAm5o3+CTgLdF1njeSr92Iconj6ZffQCo2eTJyl2Pmi6FHqJICy1TspHOvGh5hM5s
         jPJxXM3b8qu3yIkROnljR+exmKIt4xvaYvC9T30zUEdHuA3h2iBOEg4u/KqPaJRCwXVa
         VYpY/YK9lQPiVHDI/ZP26o200+cMb/qIhwjsq7AQ6FJ7Y1qe/lpyN/hpvu3/9lhU7t0S
         WTKTahsVpnn1I93OC0CgfGMdzshYSxzKk51/CesIAJaz3BDIISf7t0buWjbHMeiGwfPA
         sl+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=NUInGvIaCWlBmCyU3f6jLXuI/R6odOMByfzoWikcb6k=;
        b=it7Cf/Hcf4Rl4G+jKJkHWKCngwwQNQPJTY9pcmKPo+VEEQTE9eMbD0E1GugskbnnxN
         J0aZ6zYtINU0u/P9TwO2OpSwIw0WfB03TFnVUPz4tMnaWODbJNUhSjjC9NK8l74qOwJZ
         tehOA36P0a7Lukb5Ah7vlw8oa+/pQVfNHVgRmdhjZ2zUPEA5Q3tgcoMZNG1yNSUIQO+T
         BWkVhEVdF5xt57o+fnlsed/q6qKfKZmTu9XcH2zmbcVV7WE+3YA9Xb4ZEzmDt4bhWAwR
         OVIY4B/ewc1ISJoGUzte2YMyK96irYnZ/opdV+tQzjOGjV7cIWQzkthgU66H/hfE7wta
         1fQg==
X-Gm-Message-State: AJIora/k685ZAlacQp+kImsCdfUST/3Ad96T6JD0MLUHWuS1WwSB72k8
        rR9IQoWNqCUAG4a5mQpSlOE=
X-Google-Smtp-Source: AGRyM1tRfN/NWoK1WHO5kIJN1aJDHAv2D6/YitDEjju3U1/sbEbNEtCgJ3jZlN28KP+Bk1j715kxYg==
X-Received: by 2002:a63:3817:0:b0:40c:c766:c935 with SMTP id f23-20020a633817000000b0040cc766c935mr3272635pga.481.1655910016650;
        Wed, 22 Jun 2022 08:00:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9-20020a639909000000b0040cfb5151fcsm3505438pge.74.2022.06.22.08.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 08:00:14 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 22 Jun 2022 08:00:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net-next 1/2] net: sfp: use hwmon_sanitize_name()
Message-ID: <20220622150013.GA1861763@roeck-us.net>
References: <20220622123543.3463209-1-michael@walle.cc>
 <20220622123543.3463209-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622123543.3463209-2-michael@walle.cc>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 02:35:42PM +0200, Michael Walle wrote:
> Instead of open-coding the bad characters replacement in the hwmon name,
> use the new hwmon_sanitize_name().
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Acked-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/net/phy/sfp.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 9a5d5a10560f..81a529c3dbe4 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -1290,7 +1290,7 @@ static const struct hwmon_chip_info sfp_hwmon_chip_info = {
>  static void sfp_hwmon_probe(struct work_struct *work)
>  {
>  	struct sfp *sfp = container_of(work, struct sfp, hwmon_probe.work);
> -	int err, i;
> +	int err;
>  
>  	/* hwmon interface needs to access 16bit registers in atomic way to
>  	 * guarantee coherency of the diagnostic monitoring data. If it is not
> @@ -1318,16 +1318,12 @@ static void sfp_hwmon_probe(struct work_struct *work)
>  		return;
>  	}
>  
> -	sfp->hwmon_name = kstrdup(dev_name(sfp->dev), GFP_KERNEL);
> -	if (!sfp->hwmon_name) {
> +	sfp->hwmon_name = hwmon_sanitize_name(dev_name(sfp->dev));
> +	if (IS_ERR(sfp->hwmon_name)) {
>  		dev_err(sfp->dev, "out of memory for hwmon name\n");
>  		return;
>  	}
>  
> -	for (i = 0; sfp->hwmon_name[i]; i++)
> -		if (hwmon_is_bad_char(sfp->hwmon_name[i]))
> -			sfp->hwmon_name[i] = '_';
> -
>  	sfp->hwmon_dev = hwmon_device_register_with_info(sfp->dev,
>  							 sfp->hwmon_name, sfp,
>  							 &sfp_hwmon_chip_info,
> -- 
> 2.30.2
> 
