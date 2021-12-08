Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C005D46D544
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhLHONg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhLHONf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:13:35 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AFEC061746;
        Wed,  8 Dec 2021 06:10:03 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id a9so4286014wrr.8;
        Wed, 08 Dec 2021 06:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cDVSf9iQJRZTk+rMfGSgba1WYOB+k/OuErDztpWNhDg=;
        b=qrXPPrGQqUcxjLgUqGRVImeZHexUmi7L34HBEkZwRGdqoL4A9IK7bLkyIdMyK2IK39
         +cVK6P96BnmJdKqo0E+BolwSYM5E1CmVUyaLEclP3HavybcGOUYGBLgVCuiM2H0SYQLh
         lstzvZS+BMJ6PvL0B/uNckY4q+LYbawYL6tokoOepyT4AeXYR4rtp/mQFy0rqJe4c+et
         8OtZE2GAMRRwcRg+eOnT0sQdG06VP3Y9+/l/qUxzefSA18b4t+0QkzEk7MtYK0OkJnhn
         meymvz9Ogbt/0JfF4u/9M6Q0uv9RXMagZPs2rKyPlekztXaTkWhvlNhtI+NV/qhBC0Kl
         /loA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cDVSf9iQJRZTk+rMfGSgba1WYOB+k/OuErDztpWNhDg=;
        b=b18IQittcRBP2XkE6IutTBYEe01hvqeqZFqoEvCBTblwF3DdDHLWPV1Y7RU3DvwgJq
         klI9KHGNc4fSDz7VFaAHLtyr30fihMG3skZGa99+d/jjrL6Q/Xg8UURE6DUDBf+F1nBA
         Aq86pyGL+wEG/yqWlM9q8eKJ9H7cXRkwOI1Lz6kSJMA5yth2e2zkAOZYd9ljui9vqMC3
         4zE+2tp6IOtR4aNSjaa/S3Kw5FrE26DwPPZBV2UIiX5o+eYv840+by/c0rGrr/lwwV9C
         SUsHxDpIm7vXVWbg1xoQVcSKcliB2b+cNMXYycU993//dzVjD1DlUNW4ZA8O43HhBt0w
         I1uw==
X-Gm-Message-State: AOAM532Q974rnvWYGu7St71HXEH2D/LyNIFI/7r1toFn+NawhaPhlqRT
        amor5f7TkPeoMMwBx1UihA0=
X-Google-Smtp-Source: ABdhPJyF/aJXSV5ioEx6qaNcTmrKlE3XqqJHivZXBbO2RCk92GAXrBGCtv+NHROw2ouYAiA87oM0zg==
X-Received: by 2002:a5d:522e:: with SMTP id i14mr57882894wra.43.1638972601682;
        Wed, 08 Dec 2021 06:10:01 -0800 (PST)
Received: from hamza-OptiPlex-7040 ([39.48.199.136])
        by smtp.gmail.com with ESMTPSA id z14sm2727184wrp.70.2021.12.08.06.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 06:10:01 -0800 (PST)
Date:   Wed, 8 Dec 2021 19:09:57 +0500
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     kabel@kernel.org, kuba@kernel.org, andrew@lunn.ch
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: error handling for serdes_power
 functions
Message-ID: <20211208140957.GA96979@hamza-OptiPlex-7040>
References: <20211207140647.6926a3e7@thinkpad>
 <20211208140413.96856-1-amhamza.mgc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208140413.96856-1-amhamza.mgc@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 07:04:13PM +0500, Ameer Hamza wrote:
> mv88e6390_serdes_power() and mv88e6393x_serdes_power() should return
> with EINVAL error if cmode is undefined.
> 
> Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/serdes.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
> index 33727439724a..f3dc1865f291 100644
> --- a/drivers/net/dsa/mv88e6xxx/serdes.c
> +++ b/drivers/net/dsa/mv88e6xxx/serdes.c
> @@ -830,7 +830,7 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
>  			   bool up)
>  {
>  	u8 cmode = chip->ports[port].cmode;
> -	int err = 0;
> +	int err;
>  
>  	switch (cmode) {
>  	case MV88E6XXX_PORT_STS_CMODE_SGMII:
> @@ -842,6 +842,8 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
>  	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
>  		err = mv88e6390_serdes_power_10g(chip, lane, up);
>  		break;
> +	default:
> +		return -EINVAL;
>  	}
>  
>  	if (!err && up)
> @@ -1507,7 +1509,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
>  			    bool on)
>  {
>  	u8 cmode = chip->ports[port].cmode;
> -	int err = 0;
> +	int err;
>  
>  	if (port != 0 && port != 9 && port != 10)
>  		return -EOPNOTSUPP;
> @@ -1541,6 +1543,8 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
>  	case MV88E6393X_PORT_STS_CMODE_10GBASER:
>  		err = mv88e6390_serdes_power_10g(chip, lane, on);
>  		break;
> +	default:
> +		return -EINVAL;
>  	}
>  
>  	if (err)
> -- 
> 2.25.1
>
Hi Marek,

I checked serdes.c and I found two methods mv88e6390_serdes_power() and
mv88e6390_serdes_power() that were not returning ENINVAL in case of
undefined cmode. Would be appreciated if  you can review the patch
please.

Best Regards,
Ameer Hamza.
