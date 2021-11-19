Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABFE45674D
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 02:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbhKSBNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 20:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233951AbhKSBNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 20:13:00 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B62C061574;
        Thu, 18 Nov 2021 17:09:59 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id y13so35113869edd.13;
        Thu, 18 Nov 2021 17:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CmT5W4mUSX3ou/RnZCbEFUfEfCqiS+e0spJI+DO08qA=;
        b=Mow62kIpCIoNVxA4RBVVKAIpVKadaBGwq27pOhtSgU7I4KiqMDNSq8mVejyDjOltBU
         ozCPzXco/ZPFm6Px/1vKo6TV8tzQH3nSVxphkABKBgq+rr3Uvd313sFtVMq/Lqfhb96r
         xeQvhdPzWmWyZlDOtADaKnR8g15DnoeNG4KKr/hU5AM7rnGhavtNs6X1uJTVIID7BFlp
         2Zm7E/ClrO5ntw878mSsvyQp3oxepzciZaQ4au5hoMvuI1A+OdTNGatQs7wtBC0Xh1N7
         hB9JvS76AZoD+v5IZbrnaMRw8ikIg7ZLocsWYfWfODzdIy7/VYvPMMUbuTu8/ydA90l2
         6gfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CmT5W4mUSX3ou/RnZCbEFUfEfCqiS+e0spJI+DO08qA=;
        b=xagD68japKYzADbqdwvbl/ftr16Fnu3/qDkI6iDzqjBlKmSje0rbD8gG3QiFVnI1nG
         McahbOTBKNyRRR7M1yl8H0OcAQbvfNKZAI0dp5OZaQxz556mKPlfRQ4v8C0I/QcagIx9
         Vn9N7I8TS47OEfiFKhTmt2GmG+ptyYYiO2Kxne2kvFjSx+8BRo9Oo1k/lxlBGT3Rsk0e
         uOOQ2HGaJQ6QUtm9CqGTZeR6kiD/FRyQiEgPAwE4nvuz1N4kx6jdZxzfI36fkBePUvK9
         KXvzDexTR72I6w0TtpIYoRtXd10EwNjKI+TNGu+XY+j/K/HCL8FdTfAzbD2bd9ghPvo0
         cnQQ==
X-Gm-Message-State: AOAM532CqwI1BGCt273IUdT+2E8yOwGnr99pemonNtwweLUnuwrnDZWO
        i+OeFuI+ExE3WYRC9jNyMCbLq5f7PQI=
X-Google-Smtp-Source: ABdhPJz6lRMSP9QP4zAPGjD6Z8zDGqlOW80H2XeCu1gi4PwhK3IIfv4XQrmAIM2WbD2lm55wq1+xSw==
X-Received: by 2002:a17:907:d89:: with SMTP id go9mr2465272ejc.330.1637284198546;
        Thu, 18 Nov 2021 17:09:58 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id n1sm707377edf.45.2021.11.18.17.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 17:09:58 -0800 (PST)
Date:   Fri, 19 Nov 2021 03:09:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 07/19] net: dsa: qca8k: set regmap init as
 mandatory for regmap conversion
Message-ID: <20211119010957.n2aziuq5ijrgsxuo@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-8-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117210451.26415-8-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:04:39PM +0100, Ansuel Smith wrote:
> In preparation for regmap conversion, make regmap init mandatory and
> fail if any error occurs.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Huh. Odd that someone would initialize a regmap in a driver and then
proceed to not use it for anything. Looks like it's been sitting there
since 6b93fb46480a ("net-next: dsa: add new driver for qca8xxx family").

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/qca8k.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index ee04b48875e7..792b999da37c 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1110,6 +1110,14 @@ qca8k_setup(struct dsa_switch *ds)
>  	int cpu_port, ret, i;
>  	u32 mask;
>  
> +	/* Start by setting up the register mapping */
> +	priv->regmap = devm_regmap_init(ds->dev, NULL, priv,
> +					&qca8k_regmap_config);
> +	if (IS_ERR(priv->regmap)) {
> +		dev_err(priv->dev, "regmap initialization failed");
> +		return PTR_ERR(priv->regmap);
> +	}
> +
>  	/* Check the detected switch id */
>  	ret = qca8k_read_switch_id(priv);
>  	if (ret)
> @@ -1126,12 +1134,6 @@ qca8k_setup(struct dsa_switch *ds)
>  	if (ret)
>  		return ret;
>  
> -	/* Start by setting up the register mapping */
> -	priv->regmap = devm_regmap_init(ds->dev, NULL, priv,
> -					&qca8k_regmap_config);
> -	if (IS_ERR(priv->regmap))
> -		dev_warn(priv->dev, "regmap initialization failed");
> -
>  	ret = qca8k_setup_mdio_bus(priv);
>  	if (ret)
>  		return ret;
> -- 
> 2.32.0
> 
