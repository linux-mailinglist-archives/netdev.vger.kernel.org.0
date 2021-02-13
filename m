Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5611831AAEA
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 11:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhBMKnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 05:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhBMKn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 05:43:28 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E905C061574;
        Sat, 13 Feb 2021 02:42:48 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id bl23so3507934ejb.5;
        Sat, 13 Feb 2021 02:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=IUwXx4gXsOoZDX6P+xo+OQhFRPlkQf0kZxEOt2js0VY=;
        b=egkpYsmfJHxov4IjfdHCheqitQe6m6IkmTxXL/qRoHu1wl5DbVIm0BlV+M+sUKctyT
         TG4pv8Rx1TgO7wYrtOGhVfK3zBu7k4K3KSPOxTed+gm59aq3WC284iCOP2NyQSKSHhpy
         zeCjB6PJ3UVRoI66uyZjPcPmLvXu+DyJ5kQ+wT1xk7LjUnifZZ8+RJ6T3Pk52VybWb42
         UCasErEHxomYyWET9ZMyL3mUHg1y7kOQd5Znvi2/ws6y/wDEeQ36nrc0Rx4BNBuyt6Wt
         SGFTMRiw8rH1ioxBTWrzuuUMnoaguEoCn41Cw2ywZDC5pSTy449X+oiVe9F//J0FQqvb
         1fXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=IUwXx4gXsOoZDX6P+xo+OQhFRPlkQf0kZxEOt2js0VY=;
        b=qFPKyNjTrX+xFBf1aGl8Qj06mT1kvpbtgUue/FntYjriWAmI1obW65RzfIH+jr5dyt
         IdaC0MzJ06orzSFM60gYp6X4ORNDJ3mLHmUaPuut4fETyAVBGiUuxdHskAHjw862qcbe
         BjkoGyo3ZfZevc8+gOZ49xhAh2C3ZGEKBtpHJqRgozax0eyRGZ56mlHm/sDg8k0ycjB7
         G0I8h+kUjgjrrCggGBpG3m/Skhuza+XaIrn4RYHCAi2fOYirT5ntBgGAM3/4b8yZ4LeC
         7K712trrDw161cnhkyN+vWjjbqyrS7PDSNlPn69zsWg2JoA6enMXGXjUBADfyCCVcYgL
         Q7sA==
X-Gm-Message-State: AOAM5301PgvXqkGBiqJMIVhXmn9K8LRr3WdxSlxwFM3qD6KCe3NRSfE9
        ZJe1tSM6K6muJMuwI1mjYrY=
X-Google-Smtp-Source: ABdhPJxgTtX/IGOeE4dc1pIVzN3A9zFGaQ1mrdj7mvAwKHTvEHTF740W71Id5cgVd5RQvp/XvUPSpw==
X-Received: by 2002:a17:906:3499:: with SMTP id g25mr7174739ejb.367.1613212966946;
        Sat, 13 Feb 2021 02:42:46 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id p2sm7459863ejg.45.2021.02.13.02.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 02:42:46 -0800 (PST)
Date:   Sat, 13 Feb 2021 12:42:45 +0200
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
Subject: Re: [PATCH net-next v2 3/3] net: phy: broadcom: Allow BCM54210E to
 configure APD
Message-ID: <20210213104245.uti4qb2u2r5nblef@skbuf>
References: <20210213034632.2420998-1-f.fainelli@gmail.com>
 <20210213034632.2420998-4-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210213034632.2420998-4-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 07:46:32PM -0800, Florian Fainelli wrote:
> BCM54210E/BCM50212E has been verified to work correctly with the
> auto-power down configuration done by bcm54xx_adjust_rxrefclk(), add it
> to the list of PHYs working.
> 
> While we are at it, provide an appropriate name for the bit we are
> changing which disables the RXC and TXC during auto-power down when
> there is no energy on the cable.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/phy/broadcom.c | 8 +++++---
>  include/linux/brcmphy.h    | 2 +-
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
> index 3ce266ab521b..91fbd26c809e 100644
> --- a/drivers/net/phy/broadcom.c
> +++ b/drivers/net/phy/broadcom.c
> @@ -193,6 +193,7 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
>  	if (BRCM_PHY_MODEL(phydev) != PHY_ID_BCM57780 &&
>  	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610 &&
>  	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610M &&
> +	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54210E &&
>  	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54810 &&
>  	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54811)
>  		return;
> @@ -227,9 +228,10 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
>  		val |= BCM54XX_SHD_SCR3_DLLAPD_DIS;
>  
>  	if (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY) {
> -		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810 ||
> -		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54811)
> -			val |= BCM54810_SHD_SCR3_TRDDAPD;
> +		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54210E ||
> +		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810 ||
> +		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54210E)
> +			val |= BCM54XX_SHD_SCR3_RXCTXC_DIS;
>  		else
>  			val |= BCM54XX_SHD_SCR3_TRDDAPD;
>  	}
> diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
> index 844dcfe789a2..16597d3fa011 100644
> --- a/include/linux/brcmphy.h
> +++ b/include/linux/brcmphy.h
> @@ -193,6 +193,7 @@
>  #define  BCM54XX_SHD_SCR3_DEF_CLK125	0x0001
>  #define  BCM54XX_SHD_SCR3_DLLAPD_DIS	0x0002
>  #define  BCM54XX_SHD_SCR3_TRDDAPD	0x0004
> +#define  BCM54XX_SHD_SCR3_RXCTXC_DIS	0x0100

Curiously enough, my BCM5464R datasheet does say:

The TXC and RXC outputs can be disabled during auto-power down by setting the “1000BASE-T/100BASE-TX/10BASE-T
Spare Control 3 Register (Address 1Ch, Shadow Value 00101),” bit 8 =1.

but when I go to the definition of the register, bit 8 is hidden. Odd.

How can I ensure that the auto power down feature is doing something?

>  
>  /* 01010: Auto Power-Down */
>  #define BCM54XX_SHD_APD			0x0a
> @@ -253,7 +254,6 @@
>  #define BCM54810_EXP_BROADREACH_LRE_MISC_CTL_EN	(1 << 0)
>  #define BCM54810_SHD_CLK_CTL			0x3
>  #define BCM54810_SHD_CLK_CTL_GTXCLK_EN		(1 << 9)
> -#define BCM54810_SHD_SCR3_TRDDAPD		0x0100
>  
>  /* BCM54612E Registers */
>  #define BCM54612E_EXP_SPARE0		(MII_BCM54XX_EXP_SEL_ETC + 0x34)
> -- 
> 2.25.1
> 
