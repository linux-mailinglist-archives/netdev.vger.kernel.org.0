Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8271595D2C
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiHPNXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiHPNXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:23:01 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A645893516
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:23:00 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id fy5so18894990ejc.3
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc;
        bh=koboAnBgyp2l/0qNMq3WX56XqOWq+PYKfGOYn+D0qKE=;
        b=RkMnPesQ4BdYAejo9KknsYCaXBkY7IlsrAMeEiOSxlSB+GSnAUSItPs2ONEaBP0Vwe
         QUXt5AM4qtNdpJRk2G2ZgYddxyuYE0st8Tsek1bKJIKJQD2JRn8cPbXLM4gwSquipX34
         BHJxcbEoME4N4nUFSpT6yYIFnLTiZEVJh+ozfk8+W+e9TfvUI4utVOS315nWqs2PEVV7
         AE/x2cALIzlwR/ihwavBtbcw/26kpBDJG6ovUESFSsVrwlHY/uyDJTPh/jB9TBoiv7x6
         ef+VqwlrjbsHmhFpqt70/qTZ0a8nM1T8Hq7KsPJjcqiAL+NVVA3LDvnDKfv6tAe7NH/h
         cwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=koboAnBgyp2l/0qNMq3WX56XqOWq+PYKfGOYn+D0qKE=;
        b=ZCcd93QDVKqosI7cp2yK31NwYs8JxAa9J+8k9PDccn54Mr4dM6nFvw9qrttwJp8OFV
         HDgt75KCBdMZftrhRsFkPMGQM6p95PkUF6rRBNLXxFmMb+UXgh/LmbtnPBZWG7gcXUQ/
         1KNCPpDOQsU+FEXVUdvekNDhR/8XLgyjYvFd6hhHTBUVg/z36XgBPo0dGwv5NC5l8W2W
         9jfuIaQ8B29GkNqnjZ14ElA3WVRlMDOvQE9zljPpgBty9NXMCcDuERjezuvq/HB13zuE
         gFZG2cVJ0lD68eG3di0iDkA9N4lLJKi46kpmGQmwk28wsY/OCW2tvzgqqU5ESiVafaK3
         aq1w==
X-Gm-Message-State: ACgBeo3B82UrRS1OYUBV+xY1zT99he/q1ErNkhoybE3qOY+1o9elwDXZ
        AwAHETcfxD18YWWWuO/d+bE=
X-Google-Smtp-Source: AA6agR7JCyVhSOJ21UoIwGYNDvo73RgbsvGum/PbKORayRgE5PDv4JGg/a98IPg8LFLmxDnRX7gFDQ==
X-Received: by 2002:a17:906:8a42:b0:730:92dc:a831 with SMTP id gx2-20020a1709068a4200b0073092dca831mr13356027ejc.481.1660656179168;
        Tue, 16 Aug 2022 06:22:59 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c1cc:4400:b4c5:5676:e5f1:ad94? (dynamic-2a01-0c23-c1cc-4400-b4c5-5676-e5f1-ad94.c23.pool.telefonica.de. [2a01:c23:c1cc:4400:b4c5:5676:e5f1:ad94])
        by smtp.googlemail.com with ESMTPSA id s1-20020aa7c541000000b00445b5874249sm99025edr.62.2022.08.16.06.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 06:22:58 -0700 (PDT)
Message-ID: <ca814367-5147-67d1-8cdb-35f57c2cbb99@gmail.com>
Date:   Tue, 16 Aug 2022 15:22:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     wei.fang@nxp.com, andrew@lunn.ch, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     xiaoning.wang@nxp.com
References: <20220816194859.2369-1-wei.fang@nxp.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH V2 net-next] net: phy: realtek: add support for
 RTL8221F(D)(I)-VD-CG
In-Reply-To: <20220816194859.2369-1-wei.fang@nxp.com>
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

On 16.08.2022 21:48, wei.fang@nxp.com wrote:
> From: Clark Wang <xiaoning.wang@nxp.com>
> 
> RTL8221F(D)(I)-VD-CG is the pin-to-pin upgrade chip from
> RTL8221F(D)(I)-CG.

Here you talk about RTL8221, in the driver struct definition you say RTL8211.
You changed the naming already for v2. It would be time for you to clarify
which chip you actually mean.
RTL8221 is a 2.5Gbps PHY, however you don't handle this mode in your code.

> 
> Add new PHY ID for this chip.
> It does not support RTL8211F_PHYCR2 anymore, so remove the w/r operation
> of this register.
> 
> Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---
> V2 change:
> 1. Commit message changed, RTL8221 instead of RTL8821.
> 2. Add has_phycr2 to struct rtl821x_priv.
> ---
>  drivers/net/phy/realtek.c | 44 ++++++++++++++++++++++++++++-----------
>  1 file changed, 32 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index a5671ab896b3..3d99fd6664d7 100644
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
> @@ -78,6 +79,7 @@ MODULE_LICENSE("GPL");
>  struct rtl821x_priv {
>  	u16 phycr1;
>  	u16 phycr2;
> +	bool has_phycr2;
>  };
>  
>  static int rtl821x_read_page(struct phy_device *phydev)
> @@ -94,6 +96,7 @@ static int rtl821x_probe(struct phy_device *phydev)
>  {
>  	struct device *dev = &phydev->mdio.dev;
>  	struct rtl821x_priv *priv;
> +	u32 phy_id = phydev->drv->phy_id;
>  	int ret;
>  
>  	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> @@ -108,13 +111,16 @@ static int rtl821x_probe(struct phy_device *phydev)
>  	if (of_property_read_bool(dev->of_node, "realtek,aldps-enable"))
>  		priv->phycr1 |= RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF;
>  
> -	ret = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR2);
> -	if (ret < 0)
> -		return ret;
> +	priv->has_phycr2 = !(phy_id == RTL_8211FVD_PHYID);
> +	if (priv->has_phycr2) {
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
> @@ -400,12 +406,14 @@ static int rtl8211f_config_init(struct phy_device *phydev)
>  			val_rxdly ? "enabled" : "disabled");
>  	}
>  
> -	ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
> -			       RTL8211F_CLKOUT_EN, priv->phycr2);
> -	if (ret < 0) {
> -		dev_err(dev, "clkout configuration failed: %pe\n",
> -			ERR_PTR(ret));
> -		return ret;
> +	if (priv->has_phycr2) {
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
> @@ -923,6 +931,18 @@ static struct phy_driver realtek_drvs[] = {
>  		.resume		= rtl821x_resume,
>  		.read_page	= rtl821x_read_page,
>  		.write_page	= rtl821x_write_page,
> +	}, {
> +		PHY_ID_MATCH_EXACT(RTL_8211FVD_PHYID),
> +		.name		= "RTL8211F-VD Gigabit Ethernet",

This conflicts with RTL8221 in the commit message.

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

