Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0C6336900
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhCKAhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhCKAgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 19:36:47 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E195C061574;
        Wed, 10 Mar 2021 16:36:47 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ci14so42469953ejc.7;
        Wed, 10 Mar 2021 16:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oqO3pJKn6a33Hep15t1WN1Js5VRntr+amAc96q9kneI=;
        b=jfIfOHMXcM6f2w4k4B1AZHiThdZgVkirdz3yiQKS+aLOjGy1qkXXOJm1if6pc8xcro
         /amdYa2m+UGYe4pWyZy0ORi1huLuPpjI1tmFDdB9ybuiZqVpwRYkunICh4SnscCfyB10
         F8iYYy1aBj/dK6ka67vADU+QStPc6mfF6OnnZYltT8kyH5gga07MBRGNsvRQypfjREIy
         U/o9xZVSeJ7x/K9+HGhJcJN1dSaqKS9CXpMNNUCHxdIlt0os45hmCKUCWzDqlUVmbPBw
         ZwTpHiEH7OMFrZunJWVpurRq78AJskyYVz6cFK38D9c7B/oSawBqLGH4tUYeUKPy+AI6
         n8Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oqO3pJKn6a33Hep15t1WN1Js5VRntr+amAc96q9kneI=;
        b=PQqDY/ooWe4mQ4gbr9jzuPBD+qQm9Rzpl7bBhey6fXGmr+5V3p4tu+vT7O1saIHDmQ
         9FA+OrPmbQNIHCCsIk7jjFfVkeLlzmhMG96Cv9b2lJ9hd+jQzxU3jgF5s0rg6OYwpnEb
         R18HUCthP8SGKZwF50IQrRg48l35rjEbg+F4aNKMa+ZFVFDkuDDuMV09qQIX6cmACKlD
         1g3SJvdBI5ccqlxq6iOtBELcl3WdMiVgtkNUJ2EJKvOATpxKvoB5FTY6t0kcuJolFhUP
         6g6H+aqrN2Lq0GBOVSX8jJGekg2+RAbLO8X0aiymopW7kXWOeGXttPvVmDS2XqU4X7/I
         YD3g==
X-Gm-Message-State: AOAM533x7IyFUGiUoamFel1kglbyHdUZ78CIM1TSk9TSmaAlnuBhazip
        NILSd8hZfh6DVUakiltL+Sg=
X-Google-Smtp-Source: ABdhPJzzl3KKRZNsgrJB42cLcqVrutE/Mw/Vnr1JdRAqHqqKHS25ZuAcCvBkzcKH8ALIhZZX3iVwgg==
X-Received: by 2002:a17:906:d9d1:: with SMTP id qk17mr528224ejb.52.1615423005848;
        Wed, 10 Mar 2021 16:36:45 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id k9sm414594edo.30.2021.03.10.16.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 16:36:45 -0800 (PST)
Date:   Thu, 11 Mar 2021 02:36:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Qualify phydev->dev_flags based
 on port
Message-ID: <20210311003644.tmfk6klpojrp66hg@skbuf>
References: <20210310221758.2969808-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310221758.2969808-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 02:17:58PM -0800, Florian Fainelli wrote:
> Similar to commit 92696286f3bb37ba50e4bd8d1beb24afb759a799 ("net:
> bcmgenet: Set phydev->dev_flags only for internal PHYs") we need to
> qualify the phydev->dev_flags based on whether the port is connected to
> an internal or external PHY otherwise we risk having a flags collision
> with a completely different interpretation depending on the driver.
> 
> Fixes: aa9aef77c761 ("net: dsa: bcm_sf2: communicate integrated PHY revision to PHY driver")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/dsa/bcm_sf2.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> index 1277e5f48b7f..321924a241f8 100644
> --- a/drivers/net/dsa/bcm_sf2.c
> +++ b/drivers/net/dsa/bcm_sf2.c
> @@ -643,7 +643,10 @@ static u32 bcm_sf2_sw_get_phy_flags(struct dsa_switch *ds, int port)
>  	 * in bits 15:8 and the patch level in bits 7:0 which is exactly what
>  	 * the REG_PHY_REVISION register layout is.
>  	 */
> -	return priv->hw_params.gphy_rev;
> +	if (priv->int_phy_mask & BIT(port))
> +		return priv->hw_params.gphy_rev;
> +	else
> +		return 0;
>  }
>  
>  static void bcm_sf2_sw_validate(struct dsa_switch *ds, int port,
> -- 
> 2.25.1
> 

Checkpatch probably tells you that "else" statements are not useful
after "return", but either way, this is good.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
