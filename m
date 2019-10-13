Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A958D5800
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 22:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbfJMUPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 16:15:14 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34558 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbfJMUPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 16:15:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id y135so13076987wmc.1
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 13:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zfuQueDQ92bm/wt/Dmh/sDnEV5fC0wxWwEzInnZAamM=;
        b=SW8CthOzAZbT3wbqa1Fw8x5UdZUZTRyTHh3Ox+n8NNfGaOqTwwROyhiJL89cUACagK
         pMIOLE/FfzSjfvJ0FxR7MWVd4wCz8inFo167RhCsEt6hWtaLMu0PTgIDKThkEfX9Hy7i
         vu0jqJIJBFtBjhIhFAUEDjbc3eHn+2afqLTYIbyToQwXLsgdgQOTEdxk9SnrJMrSCNCU
         zmlgULlr6ftvxZwVXlZuQ4nQpoivGOo5hU4TTPRcjtHgG8kbYyLUmCKashGCJFNH9jtI
         AVOKemwbhJekqvr5NrLA7uiblwYXn1Ag3MS15xu2Cvr5Yy1Rj+8EZzhyBuJHwn920+qZ
         N4jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zfuQueDQ92bm/wt/Dmh/sDnEV5fC0wxWwEzInnZAamM=;
        b=FbHTfL/ijmjm8gRrU6C6qlcZJFUXqPCxzIUYg03mJoL47X8VGv79GdhVMfLV0VkBp0
         rFpL6gVkKGJB/9oF9K0vu3NFIWD5lvxcvdex6kzIm5F0hCWTAGMhCHbPtTbu6dTRuUkZ
         lzaxZRUdO1NqHwTYfj3W6B00wbsGl8rVp4bx5p+6KSpoQfz5C8+rEC1p9g0F0ouX2TKE
         FhFTSD+oUJnZ3ggJYDuTWrGSdZsV8nqKL4ibJ+smZh6mur1Y42ezNMTP8xeNsKXewdgI
         Pv+tXVZWuPC9ZLKQp4yOAZfFLXm8z1jwzhWy90eAvpH5AGuPaBvmPycAvxFgTfLgrM1B
         3tRw==
X-Gm-Message-State: APjAAAW0sM0412iv5JNfnsNySetyoCxN3W0Ux3C/D41AE5Lh9/yqoVza
        1Q4FFcVEcGWI8jhDW9azHFw=
X-Google-Smtp-Source: APXvYqzxGDJn0ud9j28WgPSiACvKotsGPhM4KgYXbvISwz+3JzTTG/NGqYYAwrq+G46kafqs/Sy8XQ==
X-Received: by 2002:a1c:99cd:: with SMTP id b196mr12405675wme.105.1570997711495;
        Sun, 13 Oct 2019 13:15:11 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:b4c9:d479:abed:f9ff? (p200300EA8F266400B4C9D479ABEDF9FF.dip0.t-ipconnect.de. [2003:ea:8f26:6400:b4c9:d479:abed:f9ff])
        by smtp.googlemail.com with ESMTPSA id f3sm14688050wrq.53.2019.10.13.13.15.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Oct 2019 13:15:10 -0700 (PDT)
Subject: Re: [PATCH V3 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Sean Nyekjaer <sean.nyekjaer@prevas.dk>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
References: <20191013193403.1921-1-marex@denx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <61012315-cbe0-c738-2e8d-0080ec382af9@gmail.com>
Date:   Sun, 13 Oct 2019 22:15:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191013193403.1921-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.10.2019 21:34, Marek Vasut wrote:
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
> Cc: Sean Nyekjaer <sean.nyekjaer@prevas.dk>
> Cc: Tristram Ha <Tristram.Ha@microchip.com>
> Cc: Woojung Huh <woojung.huh@microchip.com>
> Fixes: 9d162ed69f51 ("net: phy: micrel: add support for KSZ8795")

The Fixes tag has to be the first one. And patch still misses
the "net" annotation. For an example just see other fix submissions
on the mailing list.

> ---
> NOTE: It was also suggested to populate phydev->dev_flags to discern
>       the PHY from the switch, this does not work for setups where
>       the switch is used as a PHY without a DSA driver. Checking the
>       BMSR Bit 0 for Extended Capability Register works for both DSA
>       and non-DSA usecase.
> V2: Move phy_id check into ksz8051_match_phy_device() and
>     ksz8795_match_phy_device() and drop phy_id{,_mask} from the
>     ksphy_driver[] list to avoid matching on other PHY IDs.
> V3: Pull the logic behind discerning the KSZ8051 PHY and KSZ87xx switch
>     into common ksz8051_ksz8795_match_phy_device() function. Add Fixes
>     tag.
> ---
>  drivers/net/phy/micrel.c | 40 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 2fea5541c35a..a0444e28c6e7 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -341,6 +341,35 @@ static int ksz8041_config_aneg(struct phy_device *phydev)
>  	return genphy_config_aneg(phydev);
>  }
>  
> +static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
> +					    const u32 ksz_phy_id)
> +{
> +	int ret;
> +
> +	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != ksz_phy_id)
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
> +	ret &= BMSR_ERCAP;
> +	if (ksz_phy_id == PHY_ID_KSZ8051)
> +		return ret;
> +	else
> +		return !ret;
> +}
> +
> +static int ksz8051_match_phy_device(struct phy_device *phydev)
> +{
> +	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ8051);
> +}
> +
>  static int ksz8081_config_init(struct phy_device *phydev)
>  {
>  	/* KSZPHY_OMSO_FACTORY_TEST is set at de-assertion of the reset line
> @@ -364,6 +393,11 @@ static int ksz8061_config_init(struct phy_device *phydev)
>  	return kszphy_config_init(phydev);
>  }
>  
> +static int ksz8795_match_phy_device(struct phy_device *phydev)
> +{
> +	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ8795);
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

