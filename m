Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA24516F883
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 08:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgBZH2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 02:28:08 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40162 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgBZH2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 02:28:08 -0500
Received: by mail-wr1-f68.google.com with SMTP id t3so1624488wru.7;
        Tue, 25 Feb 2020 23:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ddjl8EDbhMbAtnqngI6RiTBP48+D/nMFpIcQwuofslY=;
        b=V7m0jjUViSFT0qDE4Frwn1P3Qb37gVs4z3K7BUqGQEHA6H+xw0L+6woSTtJ9uGzpko
         FO8pmxSE/JJto9rUq7MJN/OSPav7IjjHLaOjJ3RDwEW+yzyNmvq+ppMvu7x5pUbP6BGY
         umhOhi1LCSfslVYSHfiEbFVF2G2Kxb6MwzHWL1Idizv71jaXry2HGbmnYr+4+iRY1y+0
         sU4ObzVhcr3qvFHt281ngR2eG6y6vMRywczJTR1ccrjYIH7tR2KPm+YpF5d2sFBDu1Nk
         Iy1HAfwOaVHgYV28GPGDdKZC+OADnfSax9GDX9dNhAMWtItvzIVJnq5Sbn91ESP1TyV3
         D+lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ddjl8EDbhMbAtnqngI6RiTBP48+D/nMFpIcQwuofslY=;
        b=kM41+H6ayQTU7Z2Ilwo/xZn674IojTE2aiECQBquDitUZuyhhEcxsiNotrE1hQTfoD
         4Pp6+8Y004IAnrknC8sw3+LIjU8jgImmJLfCRbY6wfyiJifrjJ2b3XQhy44j0+cQCEP7
         dX8+YA7zsgvTkG866f4woKGT4vxOIztk8iAKOO4+w2bSEGIcUPeE12bN8ofsWZmeXNEk
         6jqneVvVVEDQE5+JlUj8w3c/PQ6A6MSOHUjRx1jc2or554O6a+yVNaTvMCDSCpgqBFlN
         JoR9ZPAzJjTmEtcspRDjlVKMhAp3GZyAf6YW6jCRoSZ5uVg5kJTdS7SIselx3/GOrutR
         YI4g==
X-Gm-Message-State: APjAAAWXSDsiQLUkkZkmC4myKMibwhXqMSpx5Q6Si5WD3ohUihrpPfsF
        2SjptqYQjOlBsFyGYZtyPFvT+ACU
X-Google-Smtp-Source: APXvYqzonWono6/3OpIDSPmky5FrOb1OYMy68R1OVnoovK6y8l++ZaGF1mc7daRPKH5TBWekP9yo4g==
X-Received: by 2002:a5d:5506:: with SMTP id b6mr3586994wrv.94.1582702085880;
        Tue, 25 Feb 2020 23:28:05 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:e467:10a7:6ccf:340e? (p200300EA8F296000E46710A76CCF340E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:e467:10a7:6ccf:340e])
        by smtp.googlemail.com with ESMTPSA id u23sm1756963wmu.14.2020.02.25.23.28.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 23:28:05 -0800 (PST)
Subject: Re: [RFC PATCH 1/2] net: phy: let the driver register its own IRQ
 handler
To:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
References: <20200225230819.7325-1-michael@walle.cc>
 <20200225230819.7325-2-michael@walle.cc>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3c7e1064-845e-d193-24ad-965211bf1e9a@gmail.com>
Date:   Wed, 26 Feb 2020 08:27:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200225230819.7325-2-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.02.2020 00:08, Michael Walle wrote:
> There are more and more PHY drivers which has more than just the PHY
> link change interrupts. For example, temperature thresholds or PTP
> interrupts.
> 
> At the moment it is not possible to correctly handle interrupts for PHYs
> which has a clear-on-read interrupt status register. It is also likely
> that the current approach of the phylib isn't working for all PHYs out
> there.
> 
> Therefore, this patch let the PHY driver register its own interrupt
> handler. To notify the phylib about a link change, the interrupt handler
> has to call the new function phy_drv_interrupt().
> 

We have phy_driver callback handle_interrupt for custom interrupt
handlers. Any specific reason why you can't use it for your purposes?

> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/phy/phy.c        | 15 +++++++++++++++
>  drivers/net/phy/phy_device.c |  6 ++++--
>  include/linux/phy.h          |  2 ++
>  3 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index d76e038cf2cb..f25aacbcf1d9 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -942,6 +942,21 @@ void phy_mac_interrupt(struct phy_device *phydev)
>  }
>  EXPORT_SYMBOL(phy_mac_interrupt);
>  
> +/**
> + * phy_drv_interrupt - PHY drivers says the link has changed
> + * @phydev: phy_device struct with changed link
> + *
> + * The PHY driver may implement his own interrupt handler. It will call this
> + * function to notify us about a link change. Trigger the state machine and
> + * work a work queue.
> + */

This function would duplicate phy_mac_interrupt().

> +void phy_drv_interrupt(struct phy_device *phydev)
> +{
> +	/* Trigger a state machine change */
> +	phy_trigger_machine(phydev);
> +}
> +EXPORT_SYMBOL(phy_drv_interrupt);
> +
>  static void mmd_eee_adv_to_linkmode(unsigned long *advertising, u16 eee_adv)
>  {
>  	linkmode_zero(advertising);
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 6a5056e0ae77..6d8c94e61251 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -965,7 +965,8 @@ int phy_connect_direct(struct net_device *dev, struct phy_device *phydev,
>  		return rc;
>  
>  	phy_prepare_link(phydev, handler);
> -	if (phy_interrupt_is_valid(phydev))
> +	if (phy_interrupt_is_valid(phydev) &&
> +	    phydev->drv->flags & PHY_HAS_OWN_IRQ_HANDLER)
>  		phy_request_interrupt(phydev);

Here most likely a ! is missing. because as-is you would break
current phylib interrupt mode. Where in the PHY driver (in which
callback) do you want to register your own interrupt handler?

>  
>  	return 0;
> @@ -2411,7 +2412,8 @@ EXPORT_SYMBOL(phy_validate_pause);
>  
>  static bool phy_drv_supports_irq(struct phy_driver *phydrv)
>  {
> -	return phydrv->config_intr && phydrv->ack_interrupt;
> +	return ((phydrv->config_intr && phydrv->ack_interrupt) ||
> +		phydrv->flags & PHY_HAS_OWN_IRQ_HANDLER);
>  }
>  
>  /**
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index c570e162e05e..46f73b94fd60 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -75,6 +75,7 @@ extern const int phy_10gbit_features_array[1];
>  
>  #define PHY_IS_INTERNAL		0x00000001
>  #define PHY_RST_AFTER_CLK_EN	0x00000002
> +#define PHY_HAS_OWN_IRQ_HANDLER	0x00000004
>  #define MDIO_DEVICE_IS_PHY	0x80000000
>  
>  /* Interface Mode definitions */
> @@ -1235,6 +1236,7 @@ int phy_drivers_register(struct phy_driver *new_driver, int n,
>  void phy_state_machine(struct work_struct *work);
>  void phy_queue_state_machine(struct phy_device *phydev, unsigned long jiffies);
>  void phy_mac_interrupt(struct phy_device *phydev);
> +void phy_drv_interrupt(struct phy_device *phydev);
>  void phy_start_machine(struct phy_device *phydev);
>  void phy_stop_machine(struct phy_device *phydev);
>  void phy_ethtool_ksettings_get(struct phy_device *phydev,
> 

