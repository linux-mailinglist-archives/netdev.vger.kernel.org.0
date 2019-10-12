Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94119D5287
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 22:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbfJLU6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 16:58:23 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40350 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729611AbfJLU6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 16:58:23 -0400
Received: by mail-wm1-f66.google.com with SMTP id b24so13171316wmj.5
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 13:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z4vpdTKqOmyS/yHqbyW/os5oPPWV4xWFlcqi76kW4eA=;
        b=HeRy907MWA4ASg7VrWoPTXIA5/R0YLmI0RGnUkuQ+Oqh0sgswxYoQ6Kq3FF83AI/y5
         pVfuGsyZAF7dRVUi5xUL7HgJzRIBm0pZUGFZdh+FBAJQS2z/+icoeXu2WBbPzf7BZT12
         vzJyktURRT8ZVq2U/au7cdDUPb+pZtHLFSCUCa/OX2nBWNWL/eY+51EBzqML/VwOttXc
         gNHjG6M4ZdsAr8DoAnL/dJE3M9iuwjLJHNfm9QuR20YgCZP0vPR6/ujqRr+m+UMNX+Po
         ctGyQ13twAnHGEMNlH21A0bk4Ij0QtRgZ3FwNRhLC1pykpkQzhya2JIqpj8OhhWdr4jP
         Km5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z4vpdTKqOmyS/yHqbyW/os5oPPWV4xWFlcqi76kW4eA=;
        b=PD6Sb3D7AtjCGKtOYx+A+NzQlnj3fuLFs8XKbQsX2ixATbTzYPLig6a63F3cYhPTuI
         xr9C34RcYSH8aT+gARTd7GbkIF0BjhL2KIaiz/SiMJ778IqG5qXLztZ6gqPPBvioohdX
         PY0wG1PQFiUC4nVq2eAagN+dvSjZcxEXzAppBo+1oDyMvn1/vmhtirvygv6y71//dTuX
         TSU9MIhOGDOHO7uEEyb5mOCW3b8WHVZXK5qzoobqCr0ZiOGm+KwS/zZRpgaEUUZKzKer
         DsNq1eX6Qk/7ywnXDwrk/9sQQn0VbxHuxGeEtkifBFLOqgeYj90mryiIbWRhM/ky5XEL
         Oy3A==
X-Gm-Message-State: APjAAAVp59GWUkTwVpkAX8FrlTFD+HoMQ5FR7G6nkJ40SzpoMhgO7vUP
        baemtwtcfMxEQhTgUt55Jho=
X-Google-Smtp-Source: APXvYqw2WRy4H/GiT7GuM77TtozWf2pccQ6pb9Pk6/NkGZw3DsISZbk515YO8r55f9d/vP8upaF7eg==
X-Received: by 2002:a1c:f31a:: with SMTP id q26mr8765350wmq.68.1570913900641;
        Sat, 12 Oct 2019 13:58:20 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:e99d:61ad:136:d387? (p200300EA8F266400E99D61AD0136D387.dip0.t-ipconnect.de. [2003:ea:8f26:6400:e99d:61ad:136:d387])
        by smtp.googlemail.com with ESMTPSA id h63sm24023948wmf.15.2019.10.12.13.58.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Oct 2019 13:58:19 -0700 (PDT)
Subject: Re: [PATCH V2 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
References: <20191010194622.28742-1-marex@denx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <84cb8eca-2eea-6f54-16c7-fa7b95655e2e@gmail.com>
Date:   Sat, 12 Oct 2019 22:58:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191010194622.28742-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.10.2019 21:46, Marek Vasut wrote:
> The KSZ8051 PHY and the KSZ8794/KSZ8795/KSZ8765 switch share exactly the
> same PHY ID. Since KSZ8051 is higher in the ksphy_driver[] list of PHYs
> in the micrel PHY driver, it is used even with the KSZ87xx switch. This
> is wrong, since the KSZ8051 configures registers of the PHY which are
> not present on the simplified KSZ87xx switch PHYs and misconfigures
> other registers of the KSZ87xx switch PHYs.
> 
> Fortunatelly, it is possible to tell apart the KSZ8051 PHY from the
> KSZ87xx switch by checking the Basic Status register Bit 0, which is
> read-only and indicates presence of the Extended Capability Registers.
> The KSZ8051 PHY has those registers while the KSZ87xx switch does not.
> 
> This patch implements simple check for the presence of this bit for
> both the KSZ8051 PHY and KSZ87xx switch, to let both use the correct
> PHY driver instance.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: George McCollister <george.mccollister@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Tristram Ha <Tristram.Ha@microchip.com>
> Cc: Woojung Huh <woojung.huh@microchip.com>
> ---
> NOTE: It was also suggested to populate phydev->dev_flags to discern
>       the PHY from the switch, this does not work for setups where
>       the switch is used as a PHY without a DSA driver. Checking the
>       BMSR Bit 0 for Extended Capability Register works for both DSA
>       and non-DSA usecase.
> V2: Move phy_id check into ksz8051_match_phy_device() and
>     ksz8795_match_phy_device() and drop phy_id{,_mask} from the
>     ksphy_driver[] list to avoid matching on other PHY IDs.
> ---
>  drivers/net/phy/micrel.c | 40 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 2fea5541c35a..028a4a177790 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -341,6 +341,25 @@ static int ksz8041_config_aneg(struct phy_device *phydev)
>  	return genphy_config_aneg(phydev);
>  }
>  
> +static int ksz8051_match_phy_device(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != PHY_ID_KSZ8051)
> +		return 0;
> +
> +	ret = phy_read(phydev, MII_BMSR);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* KSZ8051 PHY and KSZ8794/KSZ8795/KSZ8765 switch share the same
> +	 * exact PHY ID. However, they can be told apart by the extended
> +	 * capability registers presence. The KSZ8051 PHY has them while
> +	 * the switch does not.
> +	 */
> +	return ret & BMSR_ERCAP;
> +}
> +
>  static int ksz8081_config_init(struct phy_device *phydev)
>  {
>  	/* KSZPHY_OMSO_FACTORY_TEST is set at de-assertion of the reset line
> @@ -364,6 +383,21 @@ static int ksz8061_config_init(struct phy_device *phydev)
>  	return kszphy_config_init(phydev);
>  }
>  
> +static int ksz8795_match_phy_device(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != PHY_ID_KSZ8795)
> +		return 0;
> +
> +	ret = phy_read(phydev, MII_BMSR);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* See comment in ksz8051_match_phy_device() for details. */
> +	return !(ret & BMSR_ERCAP);
> +}
> +
>  static int ksz9021_load_values_from_of(struct phy_device *phydev,
>  				       const struct device_node *of_node,
>  				       u16 reg,
> @@ -1017,8 +1051,6 @@ static struct phy_driver ksphy_driver[] = {
>  	.suspend	= genphy_suspend,
>  	.resume		= genphy_resume,
>  }, {
> -	.phy_id		= PHY_ID_KSZ8051,
> -	.phy_id_mask	= MICREL_PHY_ID_MASK,
>  	.name		= "Micrel KSZ8051",
>  	/* PHY_BASIC_FEATURES */
>  	.driver_data	= &ksz8051_type,
> @@ -1029,6 +1061,7 @@ static struct phy_driver ksphy_driver[] = {
>  	.get_sset_count = kszphy_get_sset_count,
>  	.get_strings	= kszphy_get_strings,
>  	.get_stats	= kszphy_get_stats,
> +	.match_phy_device = ksz8051_match_phy_device,
>  	.suspend	= genphy_suspend,
>  	.resume		= genphy_resume,
>  }, {
> @@ -1141,13 +1174,12 @@ static struct phy_driver ksphy_driver[] = {
>  	.suspend	= genphy_suspend,
>  	.resume		= genphy_resume,
>  }, {
> -	.phy_id		= PHY_ID_KSZ8795,
> -	.phy_id_mask	= MICREL_PHY_ID_MASK,
>  	.name		= "Micrel KSZ8795",
>  	/* PHY_BASIC_FEATURES */
>  	.config_init	= kszphy_config_init,
>  	.config_aneg	= ksz8873mll_config_aneg,
>  	.read_status	= ksz8873mll_read_status,
> +	.match_phy_device = ksz8795_match_phy_device,
>  	.suspend	= genphy_suspend,
>  	.resume		= genphy_resume,
>  }, {
> 

Patch needs to be annotated as "net-next".
See https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt

Apart from that:
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
