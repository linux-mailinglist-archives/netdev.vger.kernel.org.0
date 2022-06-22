Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59273554E25
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 17:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358610AbiFVPAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 11:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243581AbiFVPAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 11:00:41 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8C33CA58;
        Wed, 22 Jun 2022 08:00:40 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id x1-20020a17090abc8100b001ec7f8a51f5so12959623pjr.0;
        Wed, 22 Jun 2022 08:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JsXlyqBaPp3xCgQddd3jvwlzgLQX53awFd5+l4wF4us=;
        b=XicE5zXOG/2frJTDCOIvWvarGdV9iCuf5WuWdhJ0xXUVeeCZVbCunlCROKPvZb0L8d
         QGSXduTbpjGQAZSO+wXS2p5IGQKqLlUEz3o12ZvaFOXua+H5Od6VT3HhFC+oJ1x8+5BW
         efXXKLQzslXhwtRYiTs0VFQew8VK/rSYr17EocEHxuNdpMYzPjGuafb0isnaNpnphGJ7
         rbhS3G+7dNfyP97Dpv5gMhBX5BZYYiWADdhJRm3Z6iXeeo4pYvuC/opx1SqpN9nFM7Pc
         pYql5z9OYimaCzdvNF4BCWNB4SMXHb/ezjpC2JiesFw++M+vp7UghufAwyIDjG0pAMLA
         a2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=JsXlyqBaPp3xCgQddd3jvwlzgLQX53awFd5+l4wF4us=;
        b=uVwg0MvFkLNmvSH4lAcdA/L6llMzujzYr6j2rXdLuUkmvNK3FpPQaBMVZH2u/Pcizf
         WF2OJqYk7Uot5s9s83yHVS9ZHjuKAsIilrqdRl3c60n69qf//MXY4Rx7QEGAnCti/xiz
         AOIxtTKYPFV3JIl04N2eLq0WuOCa2Gx21+DB5SJ8ZsH1SJp7CuNZ8oDQ/JVZWTrg5VKN
         ghgULifABkd5vO2OXuUOjXk4kVCnfrE1kCWJnqO2vz7NGNwKaEq4arRNPw1SWIlAhw7d
         cjx7hpfCTCIVw0jBW6Y912cAIY7Yusq88Uc+5PG0Ex5TZ7x+EuSrmZhFUOzB2uDw01lP
         z8NA==
X-Gm-Message-State: AJIora/CFwBSiVM4bTlEm4+3QZZvcJgzziw7/NIBURnSL81osS3x3NSY
        BCf+vZzSOt097Yiklgj687o=
X-Google-Smtp-Source: AGRyM1sNgcUVO4vcOjxoGA4pqoliJo7GsGQU2V+HOeOFa8vgNPUraJ5aDfVCdv8YhxOAIyvrcU3GnQ==
X-Received: by 2002:a17:903:240e:b0:168:ea13:f9e0 with SMTP id e14-20020a170903240e00b00168ea13f9e0mr34925985plo.6.1655910039574;
        Wed, 22 Jun 2022 08:00:39 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b21-20020a170902d89500b0015e8d4eb2cdsm12838968plz.279.2022.06.22.08.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 08:00:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 22 Jun 2022 08:00:37 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: phy: nxp-tja11xx: use
 devm_hwmon_sanitize_name()
Message-ID: <20220622150037.GB1861763@roeck-us.net>
References: <20220622123543.3463209-1-michael@walle.cc>
 <20220622123543.3463209-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622123543.3463209-3-michael@walle.cc>
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

On Wed, Jun 22, 2022 at 02:35:43PM +0200, Michael Walle wrote:
> Instead of open-coding the bad characters replacement in the hwmon name,
> use the new devm_hwmon_sanitize_name().
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Acked-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/net/phy/nxp-tja11xx.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
> index 9944cc501806..2a8195c50d14 100644
> --- a/drivers/net/phy/nxp-tja11xx.c
> +++ b/drivers/net/phy/nxp-tja11xx.c
> @@ -444,15 +444,10 @@ static int tja11xx_hwmon_register(struct phy_device *phydev,
>  				  struct tja11xx_priv *priv)
>  {
>  	struct device *dev = &phydev->mdio.dev;
> -	int i;
> -
> -	priv->hwmon_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
> -	if (!priv->hwmon_name)
> -		return -ENOMEM;
>  
> -	for (i = 0; priv->hwmon_name[i]; i++)
> -		if (hwmon_is_bad_char(priv->hwmon_name[i]))
> -			priv->hwmon_name[i] = '_';
> +	priv->hwmon_name = devm_hwmon_sanitize_name(dev, dev_name(dev));
> +	if (IS_ERR(priv->hwmon_name))
> +		return PTR_ERR(priv->hwmon_name);
>  
>  	priv->hwmon_dev =
>  		devm_hwmon_device_register_with_info(dev, priv->hwmon_name,
> -- 
> 2.30.2
> 
