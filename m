Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE7631A971
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhBMBSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhBMBSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 20:18:36 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C5AC061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 17:17:56 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id e9so614367pjj.0
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 17:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3bluiYVJ12j1Z6pI0wbQjaKJ8fL8yQWgyJpziNlCyok=;
        b=s2LgSVPYzbqVXcTrvzul4Ock6l5LlykiryYYO9/I69FmBb9g/Vcqa90jH+1i4clnRr
         ewORaYCfVEPbQSEJDvBZAYVTRvZgaCgERi7+jNTmsWBzQxHOx7O2TUWL6txRfx9hoYcX
         puHoOYyypfWDKQcVzjJIGHpPD6wk8qV9Pe3kHNtpwY8udA+NUPBDwW5jXJAdeVjIi1Jk
         aIyJGBTArh1WDrn3veLHu95JdgXL3+oh2MFMDgGapleTGk5lqrtbN2uH1c/DWWb7kPDu
         IybKXUIUmUElQSrWmI76+8kjz32DJ/c4p3AZLiliDBIDeJrt4oibEstHsLH/TzZLc4OK
         1U3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3bluiYVJ12j1Z6pI0wbQjaKJ8fL8yQWgyJpziNlCyok=;
        b=T8HbJ5sjhExc2Ei0Rl0YdHg9Qg+3d2dnBzmd9eTPQbNWNnfmgNuML3UZh43pVz8RBc
         gDwNK5Qkbc/Serh7Z3I0oTg6/7Z7GF4wfaZgOvTlaGrAKHeG9bK55DN4YCRIPF1yoopX
         sEFT8lbTcMMVWy7biEg0j1udtL2e9VcX5v5UfVOdu5ATX8njjeM7+jWp0pZC2yvuaK2n
         M/JuvZtv+6o1Acc+JOlMMLuH/buWOgIEIi4BARoiQVhyRU3DBMAthfNDJpDtGyY0Gpeb
         HZNVB21iLYfzXMQsY1ovKvo7oQqdxOUpvmYEGMKlYqHnxxujJKh0c0RPakTJQEfXkZ5Y
         h58A==
X-Gm-Message-State: AOAM533CZrAwNgQvUO1o+7ssPe72iZLw6lQNMWRrxfbyC1QmVwKjyXGB
        kRSN0kdItE9KdwqJ7/wpNt03teGF9Us=
X-Google-Smtp-Source: ABdhPJyG/gq6jJfAYx5j/qsACQpVEejonKkvZ2YMG1wAwIixpydKWpyjfxuXKE/NEn90TxIn+Wec/Q==
X-Received: by 2002:a17:902:e812:b029:de:5af2:3d09 with SMTP id u18-20020a170902e812b02900de5af23d09mr5078318plg.33.1613179075691;
        Fri, 12 Feb 2021 17:17:55 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q139sm10088868pfc.2.2021.02.12.17.17.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 17:17:55 -0800 (PST)
Subject: Re: [PATCH net-next 2/2] net: phy: broadcom: Do not modify LED
 configuration for SFP module PHYs
To:     Robert Hancock <robert.hancock@calian.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20210213002825.2557444-1-robert.hancock@calian.com>
 <20210213002825.2557444-3-robert.hancock@calian.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f730a14f-0426-f009-87cf-7a4fbe4a3f6e@gmail.com>
Date:   Fri, 12 Feb 2021 17:17:53 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213002825.2557444-3-robert.hancock@calian.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/2021 4:28 PM, 'Robert Hancock' via BCM-KERNEL-FEEDBACK-LIST,PDL
wrote:
> bcm54xx_config_init was modifying the PHY LED configuration to enable link
> and activity indications. However, some SFP modules (such as Bel-Fuse
> SFP-1GBT-06) have no LEDs but use the LED outputs to control the SFP LOS
> signal, and modifying the LED settings will cause the LOS output to
> malfunction. Skip this configuration for PHYs which are bound to an SFP
> bus.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  drivers/net/phy/broadcom.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
> index 78542580f2b2..81a5721f732a 100644
> --- a/drivers/net/phy/broadcom.c
> +++ b/drivers/net/phy/broadcom.c
> @@ -12,6 +12,7 @@
>  
>  #include "bcm-phy-lib.h"
>  #include <linux/module.h>
> +#include <linux/netdevice.h>
>  #include <linux/phy.h>
>  #include <linux/brcmphy.h>
>  #include <linux/of.h>
> @@ -365,18 +366,25 @@ static int bcm54xx_config_init(struct phy_device *phydev)
>  
>  	bcm54xx_phydsp_config(phydev);
>  
> -	/* Encode link speed into LED1 and LED3 pair (green/amber).
> +	/* For non-SFP setups, encode link speed into LED1 and LED3 pair
> +	 * (green/amber).
>  	 * Also flash these two LEDs on activity. This means configuring
>  	 * them for MULTICOLOR and encoding link/activity into them.
> +	 * Don't do this for devices that may be on an SFP module, since
> +	 * some of these use the LED outputs to control the SFP LOS signal,
> +	 * and changing these settings will cause LOS to malfunction.
>  	 */
> -	val = BCM5482_SHD_LEDS1_LED1(BCM_LED_SRC_MULTICOLOR1) |
> -		BCM5482_SHD_LEDS1_LED3(BCM_LED_SRC_MULTICOLOR1);
> -	bcm_phy_write_shadow(phydev, BCM5482_SHD_LEDS1, val);
> -
> -	val = BCM_LED_MULTICOLOR_IN_PHASE |
> -		BCM5482_SHD_LEDS1_LED1(BCM_LED_MULTICOLOR_LINK_ACT) |
> -		BCM5482_SHD_LEDS1_LED3(BCM_LED_MULTICOLOR_LINK_ACT);
> -	bcm_phy_write_exp(phydev, BCM_EXP_MULTICOLOR, val);
> +	if (!phydev->sfp_bus &&
> +	    (!phydev->attached_dev || !phydev->attached_dev->sfp_bus)) {
> +		val = BCM5482_SHD_LEDS1_LED1(BCM_LED_SRC_MULTICOLOR1) |
> +			BCM5482_SHD_LEDS1_LED3(BCM_LED_SRC_MULTICOLOR1);
> +		bcm_phy_write_shadow(phydev, BCM5482_SHD_LEDS1, val);
> +
> +		val = BCM_LED_MULTICOLOR_IN_PHASE |
> +			BCM5482_SHD_LEDS1_LED1(BCM_LED_MULTICOLOR_LINK_ACT) |
> +			BCM5482_SHD_LEDS1_LED3(BCM_LED_MULTICOLOR_LINK_ACT);
> +		bcm_phy_write_exp(phydev, BCM_EXP_MULTICOLOR, val);

Not sure I can come up with a better solution but this should probably
be made conditional upon the specific SFP module, or a set of specific
SFP modules, whether we can convey those details via a Device Tree
property or by doing a SFP ID lookup.

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
