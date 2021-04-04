Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6D235384F
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 16:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhDDOJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 10:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhDDOJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 10:09:28 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36FDC061756;
        Sun,  4 Apr 2021 07:09:23 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id k8so8783135wrc.3;
        Sun, 04 Apr 2021 07:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KaLjoMTJs+V7O/0droUw15vxLGVtPQgDn+xESZ/hCEc=;
        b=tq7OABs750SH+ulUbQfaB841KmjFOVm54KtAp+7yVb5R9jYXNR+4Ma6PYcJlg1WhNZ
         uqXQgzZQl8y8BMfkVn5GSUgn1P55AVunKpJP0lpUePpjQX5ltHKjWbs1oK9GRqGlQi0+
         llUGoNN+m8Jnd/aWAOuCGWE64EQlw3e6tIkW5WDjOjQAqr3VXGLP6NgUwFrYwmgKWKgn
         PJlTt/Jxf0O+5KB6xHxI4glnC0QaBRaIitd/eD94mqIgPvCJ7ePVzSy0sS6Zm24UzJ0/
         ZQm39q1hf33Oqc5QW5QWvVH6TAJ1N8eVclPus2QcYDjzW1SFGbaF29rwAT31Dvc6xodN
         K/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KaLjoMTJs+V7O/0droUw15vxLGVtPQgDn+xESZ/hCEc=;
        b=Rm9gd+mbNLLzwGz+Wey14YhXaRm5OgASjgfgXqYi6+ZbtwY8NQDfRkY9mzlRxjYMAe
         H7ddkrZ6t0mijRnFo7SmOxXoU7aQgx/WCanDfzNcurovxG6LXseg5MYrGjEpXuxsabRf
         yKwHYqXQZ7WIxCjJh9u3H8lxi0/N9R9M+joHwnsCSCFw/QvvYm3RJ91OIO/5siP3g0h8
         oeQcC7Pc8Sr/AJVDNvPfkUqQFu8fMiZZ8jStMmwDMGZBh+8ZlbPiA02M+Jz2c41FfXnG
         Db/5UyeWyV5FPf8N1tDreIann8pkDVy0YmVlqGeY4kgq90Ddut1hWRiWdYDo+R4C4qGY
         vf+g==
X-Gm-Message-State: AOAM533b0gCXDWGPorw1QSlFrTeEUY/uVL75QyToA18+QtRWIkZutcrG
        vfS2GkIGGg0kuK9VpqiaogcK8XsF0jVw4A==
X-Google-Smtp-Source: ABdhPJyrVng+8BqGipMSJOA4uqdo5oICwUORWqws0Q9Tkire93WwVWc+znv5YhLs2V1K+whXEsLOUw==
X-Received: by 2002:a05:6000:14f:: with SMTP id r15mr522940wrx.166.1617545362323;
        Sun, 04 Apr 2021 07:09:22 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:4523:8396:f5be:75e8? (p200300ea8f1fbb0045238396f5be75e8.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:4523:8396:f5be:75e8])
        by smtp.googlemail.com with ESMTPSA id k13sm28720690wri.27.2021.04.04.07.09.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Apr 2021 07:09:21 -0700 (PDT)
To:     Joakim Zhang <qiangqing.zhang@nxp.com>, andrew@lunn.ch,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, christian.melki@t2data.com
References: <20210404100701.6366-1-qiangqing.zhang@nxp.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: fix PHY possibly unwork after MDIO bus resume
 back
Message-ID: <97e486f8-372a-896f-6549-67b8fb34e623@gmail.com>
Date:   Sun, 4 Apr 2021 16:09:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210404100701.6366-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.04.2021 12:07, Joakim Zhang wrote:
> commit 4c0d2e96ba055 ("net: phy: consider that suspend2ram may cut
> off PHY power") invokes phy_init_hw() when MDIO bus resume, it will
> soft reset PHY if PHY driver implements soft_reset callback.
> commit 764d31cacfe4 ("net: phy: micrel: set soft_reset callback to
> genphy_soft_reset for KSZ8081") adds soft_reset for KSZ8081. After these
> two patches, I found i.MX6UL 14x14 EVK which connected to KSZ8081RNB doesn't
> work any more when system resume back, MAC driver is fec_main.c.
> 
> It's obvious that initializing PHY hardware when MDIO bus resume back
> would introduce some regression when PHY implements soft_reset. When I

Why is this obvious? Please elaborate on why a soft reset should break
something.

> am debugging, I found PHY works fine if MAC doesn't support suspend/resume
> or phy_stop()/phy_start() doesn't been called during suspend/resume. This
> let me realize, PHY state machine phy_state_machine() could do something
> breaks the PHY.
> 
> As we known, MAC resume first and then MDIO bus resume when system
> resume back from suspend. When MAC resume, usually it will invoke
> phy_start() where to change PHY state to PHY_UP, then trigger the stat> machine to run now. In phy_state_machine(), it will start/config
> auto-nego, then change PHY state to PHY_NOLINK, what to next is
> periodically check PHY link status. When MDIO bus resume, it will
> initialize PHY hardware, including soft_reset, what would soft_reset
> affect seems various from different PHYs. For KSZ8081RNB, when it in
> PHY_NOLINK state and then perform a soft reset, it will never complete
> auto-nego.

Why? That would need to be checked in detail. Maybe chip errata
documentation provides a hint.

> 
> This patch changes PHY state to PHY_UP when MDIO bus resume back, it
> should be reasonable after PHY hardware re-initialized. Also give state
> machine a chance to start/config auto-nego again.
> 

If the MAC driver calls phy_stop() on suspend, then phydev->suspended
is true and mdio_bus_phy_may_suspend() returns false. As a consequence
phydev->suspended_by_mdio_bus is false and mdio_bus_phy_resume()
skips the PHY hw initialization.
Please also note that mdio_bus_phy_suspend() calls phy_stop_machine()
that sets the state to PHY_UP.

Having said that the current argumentation isn't convincing. I'm not
aware of such issues on other systems, therefore it's likely that
something is system-dependent.

Please check the exact call sequence on your system, maybe it
provides a hint.

> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  drivers/net/phy/phy_device.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index cc38e326405a..312a6f662481 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -306,6 +306,13 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
>  	ret = phy_resume(phydev);
>  	if (ret < 0)
>  		return ret;
> +
> +	/* PHY state could be changed to PHY_NOLINK from MAC controller resume
> +	 * rounte with phy_start(), here change to PHY_UP after re-initializing
> +	 * PHY hardware, let PHY state machine to start/config auto-nego again.
> +	 */
> +	phydev->state = PHY_UP;
> +
>  no_resume:
>  	if (phydev->attached_dev && phydev->adjust_link)
>  		phy_start_machine(phydev);
> 

