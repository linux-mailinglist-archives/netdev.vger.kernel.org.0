Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADB131A95F
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhBMBMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbhBMBMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 20:12:31 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFE3C061756;
        Fri, 12 Feb 2021 17:11:50 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id u18so111498ejf.6;
        Fri, 12 Feb 2021 17:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sy+Mukcly/l7cSwTS8YgeXy6/hBRK/ctSyJRCn7BLJQ=;
        b=jVpW1BMLOX5lAy3OgapblR7TkJ/Xh+w3ralCwnsnHyRW13eC5UjZPK5cq/hVUp7bS/
         sh9nMu/p4bStZnWpEnJFR8OcH/I4wwp3obU1YknCW3siBeMJmyuejkhqc17qJmBRaN/a
         aeGENSGknGwdExQbj+WxbTtxEbG3mXtuI3+xgG/KGMocpQvonzQ43a4WZlhx+4OcUZxD
         SAP5/Ia95Ue2SWuC0WAjeB1nGl5JHqOSMOr7B60yrh3qpsuenWQFU0q6scUcvInK+L8e
         kox0b/s44n0XW+HZuTPVqTbPUX8zinrReFXtDfsViLkR2r5B/Aq9XdDHypCg8Eq6Ss20
         8pcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sy+Mukcly/l7cSwTS8YgeXy6/hBRK/ctSyJRCn7BLJQ=;
        b=fAZnrVbfFXPTkazJ/IsUV79fJpwEiOrbCsoPrDX0rlX3OSQpmXHSztC0gJNCHCd3py
         XUtlk1KI7sGkHvJofH6TK8bEYs9uAQMt43TQxLNiRL/otLVjyWlRI9ksTTceWF3QLDzA
         4BPrUE7cY5+oXq7K0gkyODLCqf9W6kN5j2m+iEez1+C+6CoVrK5VcynXssH8DVHOBBkX
         W9raoNPqX7Tn5lOHAP29oan9Dc17Mtt7Brd3qeuB2+LGb6pel2rBMek02wkpU0LXuJa1
         n7J1VB0M/CIJP/EqGFCaamoqxr123wsg4Zbita00zfA7CFja0rFqooscyNePv/NDjIFK
         B+kg==
X-Gm-Message-State: AOAM5314W8jy13XN9Mq2FkG2cA0yjN50kvvJxyZccoyBVs5Ha0wy4X19
        VgpaGxtb1NxFKscWrwYTetelbuY0MKc=
X-Google-Smtp-Source: ABdhPJxhb83MG9U5RVWoM6vu/b8//ASfJOjd1ntsbIQZyhaTSDZztZmJ14c1KoTP5yjvv7gc6NK2zw==
X-Received: by 2002:a17:906:488:: with SMTP id f8mr5306319eja.311.1613178709604;
        Fri, 12 Feb 2021 17:11:49 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s15sm436627edw.23.2021.02.12.17.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 17:11:48 -0800 (PST)
Date:   Sat, 13 Feb 2021 03:11:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>, michael@walle.cc
Subject: Re: [PATCH net-next 2/3] net: phy: broadcom: Fix RXC/TXC auto
 disabling
Message-ID: <20210213011147.6jedwieopekiwxqd@skbuf>
References: <20210212205721.2406849-1-f.fainelli@gmail.com>
 <20210212205721.2406849-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212205721.2406849-3-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 12:57:20PM -0800, Florian Fainelli wrote:
> When support for optionally disabling the TXC was introduced, bit 2 was
> used to do that operation but the datasheet for 50610M from 2009 does
> not show bit 2 as being defined. Bit 8 is the one that allows automatic
> disabling of the RXC/TXC auto disabling during auto power down.
> 
> Fixes: 52fae0837153 ("tg3 / broadcom: Optionally disable TXC if no link")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  include/linux/brcmphy.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
> index da7bf9dfef5b..3dd8203cf780 100644
> --- a/include/linux/brcmphy.h
> +++ b/include/linux/brcmphy.h
> @@ -193,7 +193,7 @@
>  #define BCM54XX_SHD_SCR3		0x05
>  #define  BCM54XX_SHD_SCR3_DEF_CLK125	0x0001
>  #define  BCM54XX_SHD_SCR3_DLLAPD_DIS	0x0002
> -#define  BCM54XX_SHD_SCR3_TRDDAPD	0x0004
> +#define  BCM54XX_SHD_SCR3_TRDDAPD	0x0100
>  
>  /* 01010: Auto Power-Down */
>  #define BCM54XX_SHD_APD			0x0a
> -- 
> 2.25.1
> 

We may have a problem here, with the layout of the Spare Control 3
register not being as universal as we think.

Your finding may have been the same as Kevin Lo's from commit
b0ed0bbfb304 ("net: phy: broadcom: add support for BCM54811 PHY"),
therefore your change is making BCM54XX_SHD_SCR3_TRDDAPD ==
BCM54810_SHD_SCR3_TRDDAPD, so currently this if condition is redundant
and probably something else is wrong too:

	if (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY) {
		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810 ||
		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54811)
			val |= BCM54810_SHD_SCR3_TRDDAPD;
		else
			val |= BCM54XX_SHD_SCR3_TRDDAPD;
	}

I'm not sure what "TRDD" stands for, but my copy of the BCM5464R
datasheet shows both bits 2 as well as 8 as being reserved. I have
"CLK125 Output" in bit 0, "DLL Auto Power-Down" in bit 1, "SD/Energy
Detect Change" in bit 5, "TXC Disable" in bit 6, and that's about it.

But I think it doesn't matter what BCM5464R has, since this feature is
gated by PHY_BRCM_DIS_TXCRXC_NOENRGY.
