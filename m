Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5319658F35A
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 21:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiHJTzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 15:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiHJTy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 15:54:59 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DED78C460
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 12:54:58 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z2so20486542edc.1
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 12:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc;
        bh=Sjs1Wb5wykw96COcUKAT3pNmcBuygh7DFR9ieVBr2xA=;
        b=UIbw4f9qBDcJQsqLSDUK2LzEVsfDfeuF08EdFUKHU9Wa48UFIERfii8/VYa0EG9hl8
         VatUTEhRnWFYpOE85w0DHAIIIHEo7iMRIWE0AxKIbZi7325bXl5+31EMzDIx8v8bdJYf
         VHnxGtGWUgMKlhYxE1Q563wrt0FSqiyRxxSOrg3BX9wJtrRShM7mNm/dNOA0A2YAOWON
         1hYLueANKZHWN+kDdUEPRHnRilD4S+24YK3pz1Xy4d9uCM0v2F1n9gcPXFTHQYAsFJ8O
         bIVI1AA4dSvFujJXWHrtyINg3wxy569wO56RT5PEOTA8ZKOrRf7Lm7wAIjEPUY9Ym0GM
         EcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Sjs1Wb5wykw96COcUKAT3pNmcBuygh7DFR9ieVBr2xA=;
        b=u0MsGqkozY3BZ24oqXO9fxGrCTMailQIXsqLlk2pedHmb9wb54ZI9XDSIrfPyFhn5y
         S01V+A0OUc6lpY8pPD0TgbYCVBmgWzZjfybn0Mqhv3OtIIvK8BaJCBTcaB1ddrQvqv5I
         XhYJIHwN+oLQb/nn9QEkc1KueVemz7XkrPcETIp+AtxnRe8j/Dy2nXrv4CBAX3kicWYd
         zmS3bu0eBedQIFmTywq++D6mrav6MRBF3lMQX5RSbHf37dwvoYkqgBgiGiyt4EtLEdMz
         L1EeFCl7u5w2YAvCHZDU6vpRjzsKqnAVEfMVEB/UCcYeWXaEME+i+Rj5PtKhaiDS+1j3
         dQzw==
X-Gm-Message-State: ACgBeo18xDvtVVkjmQhGGEBtpaQa9eSv8uE5o96dUFgoq/5us2S4CrR9
        wmLnJM9ugDhtlLYSI3gIIjA=
X-Google-Smtp-Source: AA6agR56jsyPeDMOL69d+a0ilz3wgalvIc+oXHLhWT7dD+79siLRvw4OjZb7Gj+fWdTydlIGE6HeVw==
X-Received: by 2002:aa7:dc17:0:b0:441:e5fc:7f91 with SMTP id b23-20020aa7dc17000000b00441e5fc7f91mr7322820edu.301.1660161296554;
        Wed, 10 Aug 2022 12:54:56 -0700 (PDT)
Received: from ?IPV6:2a01:c22:73fb:200:4036:270f:5f94:a9f5? (dynamic-2a01-0c22-73fb-0200-4036-270f-5f94-a9f5.c22.pool.telefonica.de. [2a01:c22:73fb:200:4036:270f:5f94:a9f5])
        by smtp.googlemail.com with ESMTPSA id o11-20020aa7d3cb000000b004417eeff836sm2825239edr.53.2022.08.10.12.54.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 12:54:55 -0700 (PDT)
Message-ID: <910fdffd-53b5-8b9a-1ba5-496ddddb9230@gmail.com>
Date:   Wed, 10 Aug 2022 21:54:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     wei.fang@nxp.com, andrew@lunn.ch, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     xiaoning.wang@nxp.com
References: <20220810173733.795897-1-wei.fang@nxp.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phy: realtek: add support for
 RTL8821F(D)(I)-VD-CG
In-Reply-To: <20220810173733.795897-1-wei.fang@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.08.2022 19:37, wei.fang@nxp.com wrote:
> From: Clark Wang <xiaoning.wang@nxp.com>
> 
> RTL8821F(D)(I)-VD-CG is the pin-to-pin upgrade chip from
> RTL8821F(D)(I)-CG.
> 

Don't you mean 8211 instead of 8821 here?

> Add new PHY ID for this chip.
> It does not support RTL8211F_PHYCR2 anymore, so remove the w/r operation
> of this register.
> 
> Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
> ---
>  drivers/net/phy/realtek.c | 48 +++++++++++++++++++++++++++++----------
>  1 file changed, 36 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index a5671ab896b3..bfde22dc85f5 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -70,6 +70,7 @@
>  #define RTLGEN_SPEED_MASK			0x0630
>  
>  #define RTL_GENERIC_PHYID			0x001cc800
> +#define RTL_8211FVD_PHYID			0x001cc878
>  
>  MODULE_DESCRIPTION("Realtek PHY driver");
>  MODULE_AUTHOR("Johnson Leung");
> @@ -80,6 +81,11 @@ struct rtl821x_priv {
>  	u16 phycr2;
>  };
>  
> +static bool is_rtl8211fvd(u32 phy_id)

Better add a has_phycr2 to struct rtl821x_priv. Then you have:

if (priv->has_phycr2)
	do_something_with(priv->phycr2);

> +{
> +	return phy_id == RTL_8211FVD_PHYID;
> +}
> +
>  static int rtl821x_read_page(struct phy_device *phydev)
>  {
>  	return __phy_read(phydev, RTL821x_PAGE_SELECT);
> @@ -94,6 +100,7 @@ static int rtl821x_probe(struct phy_device *phydev)
>  {
>  	struct device *dev = &phydev->mdio.dev;
>  	struct rtl821x_priv *priv;
> +	u32 phy_id = phydev->drv->phy_id;
>  	int ret;
>  
>  	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> @@ -108,13 +115,15 @@ static int rtl821x_probe(struct phy_device *phydev)
>  	if (of_property_read_bool(dev->of_node, "realtek,aldps-enable"))
>  		priv->phycr1 |= RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF;
>  
> -	ret = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR2);
> -	if (ret < 0)
> -		return ret;
> +	if (!is_rtl8211fvd(phy_id)) {
> +		ret = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR2);
> +		if (ret < 0)
> +			return ret;
>  
> -	priv->phycr2 = ret & RTL8211F_CLKOUT_EN;
> -	if (of_property_read_bool(dev->of_node, "realtek,clkout-disable"))
> -		priv->phycr2 &= ~RTL8211F_CLKOUT_EN;
> +		priv->phycr2 = ret & RTL8211F_CLKOUT_EN;
> +		if (of_property_read_bool(dev->of_node, "realtek,clkout-disable"))
> +			priv->phycr2 &= ~RTL8211F_CLKOUT_EN;
> +	}
>  
>  	phydev->priv = priv;
>  
> @@ -333,6 +342,7 @@ static int rtl8211f_config_init(struct phy_device *phydev)
>  {
>  	struct rtl821x_priv *priv = phydev->priv;
>  	struct device *dev = &phydev->mdio.dev;
> +	u32 phy_id = phydev->drv->phy_id;
>  	u16 val_txdly, val_rxdly;
>  	int ret;
>  
> @@ -400,12 +410,14 @@ static int rtl8211f_config_init(struct phy_device *phydev)
>  			val_rxdly ? "enabled" : "disabled");
>  	}
>  
> -	ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
> -			       RTL8211F_CLKOUT_EN, priv->phycr2);
> -	if (ret < 0) {
> -		dev_err(dev, "clkout configuration failed: %pe\n",
> -			ERR_PTR(ret));
> -		return ret;
> +	if (!is_rtl8211fvd(phy_id)) {
> +		ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
> +				       RTL8211F_CLKOUT_EN, priv->phycr2);
> +		if (ret < 0) {
> +			dev_err(dev, "clkout configuration failed: %pe\n",
> +				ERR_PTR(ret));
> +			return ret;
> +		}
>  	}
>  
>  	return genphy_soft_reset(phydev);
> @@ -923,6 +935,18 @@ static struct phy_driver realtek_drvs[] = {
>  		.resume		= rtl821x_resume,
>  		.read_page	= rtl821x_read_page,
>  		.write_page	= rtl821x_write_page,
> +	}, {
> +		PHY_ID_MATCH_EXACT(RTL_8211FVD_PHYID),
> +		.name		= "RTL8211F-VD Gigabit Ethernet",
> +		.probe		= rtl821x_probe,
> +		.config_init	= &rtl8211f_config_init,
> +		.read_status	= rtlgen_read_status,
> +		.config_intr	= &rtl8211f_config_intr,
> +		.handle_interrupt = rtl8211f_handle_interrupt,
> +		.suspend	= genphy_suspend,
> +		.resume		= rtl821x_resume,
> +		.read_page	= rtl821x_read_page,
> +		.write_page	= rtl821x_write_page,
>  	}, {
>  		.name		= "Generic FE-GE Realtek PHY",
>  		.match_phy_device = rtlgen_match_phy_device,

And by the way, net-next is closed currently.
