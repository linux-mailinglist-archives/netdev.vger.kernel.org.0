Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEEA3A8120
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhFONpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbhFONo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:44:28 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150C3C06175F;
        Tue, 15 Jun 2021 06:42:10 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g18so49218890edq.8;
        Tue, 15 Jun 2021 06:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1BN6ka8aYD/zipZHtQ3y56/ePjTmrvXl8aD7xLTdCHM=;
        b=OFuFU8EIEHlMX+bdiC8hzLdMYPzi+koN1mvMJpfbsfFGVTFYR64fyco94O6CEGxRFS
         NPnzgWa4fXXrfhLf0raCN0zdZ7DEZJDhIsOnmmwHUfoCunhipg7nxknQgVX3QDLlwbTu
         gDGdqe97LBE+dbaeRyycN1cOpH+EMr7sn/OqW8fIyPtLr/6rLYldAUsaHP9ufJAoTjMV
         VilUi8USscbt+3iMLC1bVh0Stno2POEU5seu/Z9ffyOxL6Wk+qhDYYe+EQ3FO2KEXwtX
         HEgXakuqEfn8hp4XEzmr4TFYIo342fqRjukiUg31Wjy8ENrxvflt1+rj+ClV7XLnX9Xq
         A/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1BN6ka8aYD/zipZHtQ3y56/ePjTmrvXl8aD7xLTdCHM=;
        b=O67rNXcDCYWakxszFE7mijJ/4SjWSYBfNwRV7cWuOqkhNL5yHf9pjYNIALtdeBhtyt
         Cak5DKk/2/svAxxZnViJXozc6xbVRWoDMPQLSso5aSFygrJWt6JMry5y71ntiT21R3h6
         yrDBenjCwHK/jeSrnB36ASV2hnh5FcayOLSDEJPIMUq5QTV/qgnZ7owOfsN9lmlm0GI1
         7uxed+fLDHnTzI2bspyVRQnqWAs1Ra/VLgiTE8Qnoh5ox/wCaXPQh9WNMYjLZWTao+FU
         ESdegdvaySqOI3CaOyidw3QeEdpSrYWqNz3Jvn0yRIYa/QRFwcmimYXEv3rO3OE1gSSj
         v4jA==
X-Gm-Message-State: AOAM530kHJrZ8gAq/LHCQn9nZ4wHI8qgU8DC7/N9ojUeo6t8XdKHzsK/
        7GzzlRgrH/GhjIkmAu10FBg=
X-Google-Smtp-Source: ABdhPJzekSNEtS5nzI5oHVfb9zc88FNEHzGJQvDBU+1BW/URxGutgBsgIo6L0AFtZkyDMl0BOXnzbg==
X-Received: by 2002:a05:6402:128d:: with SMTP id w13mr23597498edv.38.1623764528629;
        Tue, 15 Jun 2021 06:42:08 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id br21sm9985840ejb.124.2021.06.15.06.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 06:42:08 -0700 (PDT)
Date:   Tue, 15 Jun 2021 16:42:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: pcs: xpcs: Fix a less than zero u16
 comparision error
Message-ID: <20210615134206.ayjpjk2sqv7umjah@skbuf>
References: <20210615131601.57900-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615131601.57900-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some nitpicks, fix them if you'd like, ignore them if not:

s/comparision/comparison/

On Tue, Jun 15, 2021 at 02:16:01PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the check for the u16 variable val being less than zero is
> always false because val is unsigned. Fix this by using the int
> variable for the assignment and less than zero check.
> 
> Addresses-Coverity: ("Unsigned compared against 0")
> Fixes: f7380bba42fd ("net: pcs: xpcs: add support for NXP SJA1110")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/pcs/pcs-xpcs-nxp.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/pcs/pcs-xpcs-nxp.c b/drivers/net/pcs/pcs-xpcs-nxp.c
> index de99c37cf2ae..80430ca94fbf 100644
> --- a/drivers/net/pcs/pcs-xpcs-nxp.c
> +++ b/drivers/net/pcs/pcs-xpcs-nxp.c
> @@ -152,11 +152,11 @@ static int nxp_sja1110_pma_config(struct dw_xpcs *xpcs,
>  	/* Enable TX and RX PLLs and circuits.
>  	 * Release reset of PMA to enable data flow to/from PCS.
>  	 */
> -	val = xpcs_read(xpcs, MDIO_MMD_VEND2, SJA1110_POWERDOWN_ENABLE);
> -	if (val < 0)
> -		return val;
> +	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, SJA1110_POWERDOWN_ENABLE);
> +	if (ret < 0)
> +		return ret;
>  
> -	val &= ~(SJA1110_TXPLL_PD | SJA1110_TXPD | SJA1110_RXCH_PD |
> +	val = ret & ~(SJA1110_TXPLL_PD | SJA1110_TXPD | SJA1110_RXCH_PD |

You could have realigned the following 2 lines as well with the new
position of SJA1110_TXPLL_PD.

>  		 SJA1110_RXBIAS_PD | SJA1110_RESET_SER_EN |
>  		 SJA1110_RESET_SER | SJA1110_RESET_DES);
>  	val |= SJA1110_RXPKDETEN | SJA1110_RCVEN;
> -- 
> 2.31.1
> 

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
