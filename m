Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8EB36133B
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 21:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235190AbhDOT7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 15:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbhDOT7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 15:59:14 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94946C061574;
        Thu, 15 Apr 2021 12:58:51 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id o123so16796803pfb.4;
        Thu, 15 Apr 2021 12:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SbETF7lohgkuXHBXWamB8mVWkNu7c8UJtl6zbFx2I9c=;
        b=R3ni5C03p6m8q7hoxznqE+yua1HR7cUIHBCNjEm8eZgO4+slnNMqvvL/AP7zO0B8g0
         SExvUYTMtiWp/+5BhpslCB7P2tA460H6dZbw7LjzH/1F+7fLh0MgT2i910+snKn1MsSW
         YOl/zlmQh/DUc79JnVnhM7cFFxnyfnQWircBRClxEnfKSlxzE1vK07zWhq7lALqoE+UT
         kPz7FfVfNSzcgHvjqUrADoqYsowS40pQ7YFe3I4j/KT7bUmlmLcB9wgM1qEX3GG864qM
         vUoqLpfEWCbZFrm/EEjblnmiHPnw1GbyMChuwvUxU2tlrgqJyqJyBQYkUIfL86bOpkk/
         iYVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SbETF7lohgkuXHBXWamB8mVWkNu7c8UJtl6zbFx2I9c=;
        b=IunKEqGddWDO7EBWegZ0jwWiixcXH6+95HocmSwxh6EAr8tl9co+26KjG3vNmqzaPq
         qI7CqQ7A3a9NI/JfOrlIUYY6+Y4E3ujIrAkiLG6BIKxWtpJE7P9QD5H+jQf7jymzjWkS
         3onZy4MoFK+RNPkbab4I+mGCLoi4TulhuftJtuK/WeV4xT/MNUdnF3Bpa0SGbLrf5V86
         1oX9aR55dQvRX9dhLd2oivDM+CpEvGshLTNE1ZD2N7DXUv1/Y3hQdH8mt4TDLpXVRpC8
         VUOVHBZxWEI0WDpY4uud03Z68DkbuEuuuKei7NmSe1Kp+TR1rcR9yzFE+uKZzO676kao
         Nj7g==
X-Gm-Message-State: AOAM532AlAUZ7L5oPU9kuH3xT9/qg+HUAQ6ghRJam7WB2IVfDm8Sed+H
        HA1xJfSWWd1aLtmwZZEoYaw=
X-Google-Smtp-Source: ABdhPJzimemp+4lxqQc2C0WO26adQcOf+OO8m5CVuaR0BCU6cuTx7Ies7+CTkH7l3votAP6W/ThFfw==
X-Received: by 2002:a05:6a00:be2:b029:258:834c:cdc9 with SMTP id x34-20020a056a000be2b0290258834ccdc9mr2857919pfu.54.1618516731054;
        Thu, 15 Apr 2021 12:58:51 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u7sm3210496pjx.8.2021.04.15.12.58.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 12:58:50 -0700 (PDT)
Subject: Re: [PATCH v2 2/7] net: phy: micrel: KSZ8081 & KSZ9031: add loopback
 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
References: <20210415130738.19603-1-o.rempel@pengutronix.de>
 <20210415130738.19603-3-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2bf45888-98e5-7c3c-1732-05d685d59d54@gmail.com>
Date:   Thu, 15 Apr 2021 12:58:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415130738.19603-3-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2021 6:07 AM, Oleksij Rempel wrote:
> PHY loopback is needed for the ethernet controller self test support.
> This PHY was tested with the generic net sefltest in combination with
> FEC ethernet controller and SJA1105 switch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/micrel.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index a14a00328fa3..26066b1e02e5 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1311,6 +1311,7 @@ static struct phy_driver ksphy_driver[] = {
>  	.get_stats	= kszphy_get_stats,
>  	.suspend	= kszphy_suspend,
>  	.resume		= kszphy_resume,
> +	.set_loopback	= genphy_loopback,

The generic loopback is really generic and is defined by the 802.3
standard, we should just mandate that drivers implement a custom
loopback if the generic one cannot work. I would change the PHY library
to do something like this:

if (phydev->drv->set_loopback)
	ret = phydev->drv->set_loopback(phydev, ...)
else
	ret = genphy_loopback(phydev, ...)

This would enable many more drivers than that we currently have today.

>  }, {
>  	.phy_id		= PHY_ID_KSZ8061,
>  	.name		= "Micrel KSZ8061",
> @@ -1356,6 +1357,7 @@ static struct phy_driver ksphy_driver[] = {
>  	.get_stats	= kszphy_get_stats,
>  	.suspend	= genphy_suspend,
>  	.resume		= kszphy_resume,
> +	.set_loopback	= genphy_loopback,
>  }, {
>  	.phy_id		= PHY_ID_LAN8814,
>  	.phy_id_mask	= MICREL_PHY_ID_MASK,
> 

-- 
Florian
