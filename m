Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E443224DD4
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 22:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgGRUaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 16:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgGRUaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 16:30:14 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD82C0619D2;
        Sat, 18 Jul 2020 13:30:14 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id f12so14292175eja.9;
        Sat, 18 Jul 2020 13:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8UEibrkJeZq+Z+jyeu79uF6xh4H7FeZXreVOdNQb6iY=;
        b=fnYfoLBY1o2zvZMHQQ/k53U0S0AAE9JZKo3n/5ihnFDtU/r/hKHug6bAbktBRtJGCS
         oIluSjY4fUcPxEJ1S/456wn5QOTa32YAHAoVNnPtqZd6l+QEbjyIKrWXuYIe6lk8NqGv
         eh+WvlzRSIt4+32jcEnPM05gLevJMeQPq8zSRiF5YK0n8hWwkKTJnbXKJCa/4TZ5D0ov
         aOTaKqdTfHUWiYPoG+FznMTVHK/xTe3s9aHREjSinzflUTjxdGAQ58A8hFlCfoFYEKq7
         HxgjcTRkosu2gVe+rSZwzX4FGIWaCUbh2E3YWJ3OZftrCW5unxUYs1phoMzkrf596GkZ
         RiOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8UEibrkJeZq+Z+jyeu79uF6xh4H7FeZXreVOdNQb6iY=;
        b=KJ6HmhX8kHJ0ygyqQEpwPtzF6tHSc7jitnUt6tTTuPi7gAeStETJL6XRHtlSNRaTnQ
         R5ES5QA/3tu2fValnRtUPZmvkcCCCwHA5W/9FEM8jhzkeYhNyD+KeM9rKSJ/opr3ILTc
         fZ3ez1bMVan+cSuP/gnfhEeGf7CvsZTygy28NlKJSb87vDhTg5yjwsHZbPeZFxtpxgC8
         P0Z7p0dqqe+CnyKg5fasvkGkTrsaUYTumwL7FKA5B0LnhuxECoxo1erpBpJKUc3zsez8
         PISGv+IljnzXcUANVV+M/SxvPfQtkfqsM/4fFhCnUxz2j/c8s5UfztboJkLzwpmrzifi
         GnXQ==
X-Gm-Message-State: AOAM5318DEIrxDUDJxMt76iXNoq+yJCSXG71y4Ch81sTRVtSjBHxHYj0
        xHSBW61m2j6wNpZxUz2yvlA=
X-Google-Smtp-Source: ABdhPJwL50bVArFJaNBnVA4rsX62YFXj82hfkLLvrJPNmuWc5Bx+dPaWIUPyTyLBimrR0VDQmNKnLQ==
X-Received: by 2002:a17:906:f98e:: with SMTP id li14mr13956264ejb.174.1595104213263;
        Sat, 18 Jul 2020 13:30:13 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id cc9sm12447928edb.14.2020.07.18.13.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 13:30:12 -0700 (PDT)
Date:   Sat, 18 Jul 2020 23:30:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/4] net: Wrap ndo_do_ioctl() to prepare for DSA
 stacked ops
Message-ID: <20200718203010.6dg5chsor5rufkaa@skbuf>
References: <20200718030533.171556-1-f.fainelli@gmail.com>
 <20200718030533.171556-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200718030533.171556-2-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Fri, Jul 17, 2020 at 08:05:30PM -0700, Florian Fainelli wrote:
> In preparation for adding another layer of call into a DSA stacked ops
> singleton, wrap the ndo_do_ioctl() call into dev_do_ioctl().
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

I missed most of the context, but this looks interesting. Am I correct
in saying that this could save us from having to manually pass
phy_mii_ioctl() and that it could be generically handled here?

>  net/core/dev_ioctl.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index 547b587c1950..a213c703c90a 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -225,6 +225,22 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
>  	return 0;
>  }
>  
> +static int dev_do_ioctl(struct net_device *dev,
> +			struct ifreq *ifr, unsigned int cmd)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	int err = -EOPNOTSUPP;
> +
> +	if (ops->ndo_do_ioctl) {
> +		if (netif_device_present(dev))
> +			err = ops->ndo_do_ioctl(dev, ifr, cmd);
> +		else
> +			err = -ENODEV;
> +	}
> +
> +	return err;
> +}
> +
>  /*
>   *	Perform the SIOCxIFxxx calls, inside rtnl_lock()
>   */
> @@ -323,13 +339,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
>  		    cmd == SIOCSHWTSTAMP ||
>  		    cmd == SIOCGHWTSTAMP ||
>  		    cmd == SIOCWANDEV) {
> -			err = -EOPNOTSUPP;
> -			if (ops->ndo_do_ioctl) {
> -				if (netif_device_present(dev))
> -					err = ops->ndo_do_ioctl(dev, ifr, cmd);
> -				else
> -					err = -ENODEV;
> -			}
> +			err = dev_do_ioctl(dev, ifr, cmd);
>  		} else
>  			err = -EINVAL;
>  
> -- 
> 2.25.1
> 
