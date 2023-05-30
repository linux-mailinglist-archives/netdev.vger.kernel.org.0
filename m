Return-Path: <netdev+bounces-6513-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D824A716BD2
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:02:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36A02281192
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A58352A9D5;
	Tue, 30 May 2023 18:01:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9358C1EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:01:58 +0000 (UTC)
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4846810E
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:01:56 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-64d41763796so3532385b3a.2
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685469716; x=1688061716;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YPgCVSt7y6PxCp5yFXWC0Ze5j97m39HzqRTPJj/Rzok=;
        b=daMwRswKWcVI6vkSACEgbPUEyKMlDDFTw7qTWFO6GhkgaARvzkvSNeqAkkLvh+7NEJ
         k7KYx0E0p7UrDSsMy9CQTmAMWYNldLV7A6bXRXTgx3riiJen71Asg23l30NtowF0/ENt
         NXXLYNVuT8ozbjKv3BXymBX5uXIJA146twdALkzwJJqPzUNjZG0hKmZLGJyfVfHcnNF2
         2f53fDGDLfQ33UGGwjFYKpP8BSPrCO59dWldHozIna77uZGIKhKi2GwmCzy7DN9GW3Ss
         DrmzIAgyHZE12V+GDWunHqNxtpNSlKrLrA2LPAJoVsQs1CG6etN3+6Ex0tScBW5ySWiZ
         4+YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685469716; x=1688061716;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YPgCVSt7y6PxCp5yFXWC0Ze5j97m39HzqRTPJj/Rzok=;
        b=LEJIz4m2Lcwx4XncfxbjLQKZm5rBzS+ZXjNycQUB8FrtryVK/dVN/L9EkWs9gedrwS
         VC7cusKAZaOaddFC1eQ/TsqnFIU9bkZt2HtAyD5GOU0itdKJ6eCDgD9Ng4zRuhG91Vwi
         zzdIK1wjXlTgaqUEUGN5sMi8j5op3ebuBXgCdEsus11XqThds5mFV5L0tVkoKAJa4juu
         M0BRjIsIuM5yUU++Qev1GIZxPYgt51z+YdSpQHdjCaXZxBecNJU/WK/OBv69O7S3q8ck
         VF6v9V4RgWtmZpYTDOyJooZIDcIpdJerXFAkgXUZKeF7GD301MF8RK03QVUqR0IkbNSj
         ND8Q==
X-Gm-Message-State: AC+VfDyBy8iD0h/y1ylcGFLU4VkWuiAZyNayY1X0cUhT+pLmMrNFphTn
	z3s6gAXKGw1iWLa7UYj7Oxg=
X-Google-Smtp-Source: ACHHUZ75PD1VjKogOGJhNInG9Dwd8LON7kuTaE0qj5uRmI1FzCfCZ/Zo3SCUjoRKbmkyZBTkgtjiGA==
X-Received: by 2002:a17:903:11c5:b0:1ac:3e56:41b1 with SMTP id q5-20020a17090311c500b001ac3e5641b1mr3796614plh.30.1685469715500;
        Tue, 30 May 2023 11:01:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b4-20020a170902d50400b001ae6e270d8bsm10567274plg.131.2023.05.30.11.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 11:01:54 -0700 (PDT)
Message-ID: <38ee4669-e4b6-2d4e-2617-6ac000bb4815@gmail.com>
Date: Tue, 30 May 2023 11:01:47 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC/RFTv3 13/24] net: genet: Fixup EEE
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Oleksij Rempel <linux@rempel-privat.de>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <20230331005518.2134652-14-andrew@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230331005518.2134652-14-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 3/30/23 17:55, Andrew Lunn wrote:
> The enabling/disabling of EEE in the MAC should happen as a result of
> auto negotiation. So move the enable/disable into bcmgenet_mii_setup()
> which gets called by phylib when there is a change in link status.
> 
> bcmgenet_set_eee() now just writes the LTI timer value to the
> hardware.  Everything else is passed to phylib, so it can correctly
> setup the PHY.
> 
> bcmgenet_get_eee() relies on phylib doing most of the work, the MAC
> driver just adds the LTI timer value from hardware.
> 
> The call to bcmgenet_eee_enable_set() in the resume function has been
> removed. There is both unconditional calls to phy_init_hw() and
> genphy_config_aneg, and a call to phy_resume(). As a result, the PHY
> is going to perform auto-neg, and then it completes
> bcmgenet_mii_setup() will be called, which will set the hardware to
> the correct EEE mode.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>   .../net/ethernet/broadcom/genet/bcmgenet.c    | 42 +++++--------------
>   .../net/ethernet/broadcom/genet/bcmgenet.h    |  3 +-
>   drivers/net/ethernet/broadcom/genet/bcmmii.c  |  1 +
>   3 files changed, 12 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index d937daa8ee88..035486304e31 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -1272,19 +1272,21 @@ static void bcmgenet_get_ethtool_stats(struct net_device *dev,
>   	}
>   }
>   
> -static void bcmgenet_eee_enable_set(struct net_device *dev, bool enable)
> +void bcmgenet_eee_enable_set(struct net_device *dev, bool eee_active)

Replacing the argument name here is a bit of noise in reviewing the 
patch, and it does not fundamentally change the behavior or semantics IMHO.

>   {
>   	struct bcmgenet_priv *priv = netdev_priv(dev);
> -	u32 off = priv->hw_params->tbuf_offset + TBUF_ENERGY_CTRL;
> +	u32 off;
>   	u32 reg;
>   
> -	if (enable && !priv->clk_eee_enabled) {
> +	off = priv->hw_params->tbuf_offset + TBUF_ENERGY_CTRL;
> +
> +	if (eee_active && !priv->clk_eee_enabled) {
>   		clk_prepare_enable(priv->clk_eee);
>   		priv->clk_eee_enabled = true;
>   	}
>   
>   	reg = bcmgenet_umac_readl(priv, UMAC_EEE_CTRL);
> -	if (enable)
> +	if (eee_active)
>   		reg |= EEE_EN;
>   	else
>   		reg &= ~EEE_EN;
> @@ -1292,7 +1294,7 @@ static void bcmgenet_eee_enable_set(struct net_device *dev, bool enable)
>   
>   	/* Enable EEE and switch to a 27Mhz clock automatically */
>   	reg = bcmgenet_readl(priv->base + off);
> -	if (enable)
> +	if (eee_active)
>   		reg |= TBUF_EEE_EN | TBUF_PM_EN;
>   	else
>   		reg &= ~(TBUF_EEE_EN | TBUF_PM_EN);
> @@ -1300,25 +1302,21 @@ static void bcmgenet_eee_enable_set(struct net_device *dev, bool enable)
>   
>   	/* Do the same for thing for RBUF */
>   	reg = bcmgenet_rbuf_readl(priv, RBUF_ENERGY_CTRL);
> -	if (enable)
> +	if (eee_active)
>   		reg |= RBUF_EEE_EN | RBUF_PM_EN;
>   	else
>   		reg &= ~(RBUF_EEE_EN | RBUF_PM_EN);
>   	bcmgenet_rbuf_writel(priv, reg, RBUF_ENERGY_CTRL);
>   
> -	if (!enable && priv->clk_eee_enabled) {
> +	if (!eee_active && priv->clk_eee_enabled) {
>   		clk_disable_unprepare(priv->clk_eee);
>   		priv->clk_eee_enabled = false;
>   	}
> -
> -	priv->eee.eee_enabled = enable;
> -	priv->eee.eee_active = enable;
>   }
>   
>   static int bcmgenet_get_eee(struct net_device *dev, struct ethtool_eee *e)
>   {
>   	struct bcmgenet_priv *priv = netdev_priv(dev);
> -	struct ethtool_eee *p = &priv->eee;
>   
>   	if (GENET_IS_V1(priv))
>   		return -EOPNOTSUPP;
> @@ -1326,8 +1324,6 @@ static int bcmgenet_get_eee(struct net_device *dev, struct ethtool_eee *e)
>   	if (!dev->phydev)
>   		return -ENODEV;
>   
> -	e->eee_enabled = p->eee_enabled;
> -	e->eee_active = p->eee_active;
>   	e->tx_lpi_timer = bcmgenet_umac_readl(priv, UMAC_EEE_LPI_TIMER);
>   
>   	return phy_ethtool_get_eee(dev->phydev, e);
> @@ -1336,8 +1332,6 @@ static int bcmgenet_get_eee(struct net_device *dev, struct ethtool_eee *e)
>   static int bcmgenet_set_eee(struct net_device *dev, struct ethtool_eee *e)
>   {
>   	struct bcmgenet_priv *priv = netdev_priv(dev);
> -	struct ethtool_eee *p = &priv->eee;
> -	int ret = 0;
>   
>   	if (GENET_IS_V1(priv))
>   		return -EOPNOTSUPP;
> @@ -1345,20 +1339,7 @@ static int bcmgenet_set_eee(struct net_device *dev, struct ethtool_eee *e)
>   	if (!dev->phydev)
>   		return -ENODEV;
>   
> -	p->eee_enabled = e->eee_enabled;
> -
> -	if (!p->eee_enabled) {
> -		bcmgenet_eee_enable_set(dev, false);
> -	} else {
> -		ret = phy_init_eee(dev->phydev, false);
> -		if (ret) {
> -			netif_err(priv, hw, dev, "EEE initialization failed\n");
> -			return ret;
> -		}
> -
> -		bcmgenet_umac_writel(priv, e->tx_lpi_timer, UMAC_EEE_LPI_TIMER);
> -		bcmgenet_eee_enable_set(dev, true);
> -	}
> +	bcmgenet_umac_writel(priv, e->tx_lpi_timer, UMAC_EEE_LPI_TIMER);
>   
>   	return phy_ethtool_set_eee(dev->phydev, e);
>   }
> @@ -4278,9 +4259,6 @@ static int bcmgenet_resume(struct device *d)
>   	if (!device_may_wakeup(d))
>   		phy_resume(dev->phydev);
>   
> -	if (priv->eee.eee_enabled)
> -		bcmgenet_eee_enable_set(dev, true);
> -
>   	bcmgenet_netif_start(dev);
>   
>   	netif_device_attach(dev);
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
> index 946f6e283c4e..8c9643ec738c 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
> @@ -644,8 +644,6 @@ struct bcmgenet_priv {
>   	bool wol_active;
>   
>   	struct bcmgenet_mib_counters mib;
> -
> -	struct ethtool_eee eee;
>   };
>   
>   #define GENET_IO_MACRO(name, offset)					\
> @@ -703,4 +701,5 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
>   void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
>   			       enum bcmgenet_power_mode mode);
>   
> +void bcmgenet_eee_enable_set(struct net_device *dev, bool eee_active);
>   #endif /* __BCMGENET_H__ */
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
> index be042905ada2..6c39839762a7 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
> @@ -100,6 +100,7 @@ void bcmgenet_mii_setup(struct net_device *dev)
>   
>   	if (phydev->link) {
>   		bcmgenet_mac_config(dev);
> +		bcmgenet_eee_enable_set(dev, phydev->eee_active);

That part is a real bug fix, I do have a tentative patch that I should 
be able to submit to 'net' soon after I finish testing a few things with 
it. Thanks Andrew!
-- 
Florian


