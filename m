Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06DA3B9650
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 21:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbhGATDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 15:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbhGATDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 15:03:42 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18685C061762;
        Thu,  1 Jul 2021 12:01:11 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id h4so7001143pgp.5;
        Thu, 01 Jul 2021 12:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zuuuKETYTTaSFfx3LmdO74kAIcVPtY1K3CKJhQJ0z4Q=;
        b=f3AxasF9oZPjccbYZnsq+cyvBw/7hU0StYGfkeCJEqFBTQ5l9K0Uuf9UU7bipsqBoF
         fwBGIp0+4UYd8GMNzxv6AoGqjgr1JEpESfEFFJIleh3LLGU5t1mwDsv537lFDWqeRVxq
         kd01C4JDm79TUWQfK+rF3iyf5M1eg/CouVAoV/TPTBOCPzuIJHsjdtSFSzEffA8Awwll
         Ne34IcLUkbu1dq+aj/RLCd5OZIOwtD94r5F1Z6sFHEQY4FdtDEyxBn8B6t8abHIC+FzL
         47kYp2SH2wOsDv0V6DaTk+O/uncf3l/i0VO8kHzt4gPCZb6ixLeiwS0bJvwBHy3J+3g9
         NIAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zuuuKETYTTaSFfx3LmdO74kAIcVPtY1K3CKJhQJ0z4Q=;
        b=Osm986opySeHCNJa59X4AoRYwWmf7q1SgnhIB2Qhu4CyaRXE/vO+sKsseHZju4Bk3s
         dPtYP8/zghTwFUG6exll9BZ/wOZDShETc151GCktbohX0ddlHeDzgPhfBNGY+h+ojqYJ
         W1R2YI48y1i57sXDZtWofFtDwVjxoqjQzbouAnDmebgSEg0Qf+NkExgy7Jfy9yKnpeGG
         XmdqzuWvqd0NLaRa9AHJTDwe7AxgCMDtGrcEr6i/wuLl2D6vu+XpkUH/xiCDh03z6pTq
         qCUccMoCJHm93XxAf1j+TUDVz1+eKa3roSEoEhaJDTBfnZMusJh7uF+XkI3iHXJbJKLY
         vvkA==
X-Gm-Message-State: AOAM5320UUi+pvoe8uAQepcwJWsqNSxo+CBjlj7GZng7OkwR9uV9UrUL
        PA1fMG4L1rvWR9r8fUYzy+ohYA7jDCqk4g==
X-Google-Smtp-Source: ABdhPJz/eUSEWo0QVh5j7rnqa8Zby+3Kv0kHgJgigDcoRLfXSRVvqtrOiWWBdN9Ifr1MQ4y2KfB7Dw==
X-Received: by 2002:aa7:9ed1:0:b029:2f2:fb20:bac3 with SMTP id r17-20020aa79ed10000b02902f2fb20bac3mr1474827pfq.6.1625166070073;
        Thu, 01 Jul 2021 12:01:10 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i18sm761753pfa.37.2021.07.01.12.01.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 12:01:09 -0700 (PDT)
Subject: Re: [PATCH net-next v1 1/1] net: usb: asix: ax88772: suspend PHY on
 driver probe
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210629044305.32322-1-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <931f10ca-2d81-8264-950c-8d29c18a7b35@gmail.com>
Date:   Thu, 1 Jul 2021 12:01:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210629044305.32322-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/21 9:43 PM, Oleksij Rempel wrote:
> After probe/bind sequence is the PHY in active state, even if interface
> is stopped. As result, on some systems like Samsung Exynos5250 SoC based Arndale
> board, the ASIX PHY will be able to negotiate the link but fail to
> transmit the data.
> 
> To handle it, suspend the PHY on probe.

Very unusual, could not the PHY be attached/connected to a ndo_open()
time like what most drivers do?

> 
> Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/net/usb/asix_devices.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index aec97b021a73..2c115216420a 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -701,6 +701,7 @@ static int ax88772_init_phy(struct usbnet *dev)
>  		return ret;
>  	}
>  
> +	phy_suspend(priv->phydev);
>  	priv->phydev->mac_managed_pm = 1;
>  
>  	phy_attached_info(priv->phydev);
> 


-- 
Florian
