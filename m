Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C7F26D87F
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 12:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgIQKKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 06:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbgIQKKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 06:10:39 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DF7C06174A;
        Thu, 17 Sep 2020 03:10:39 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id b22so1520503lfs.13;
        Thu, 17 Sep 2020 03:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FQdxnzFRF8w408R2EqIrB/+ghDevgj/VHmIDuzUiaME=;
        b=LtP4o/ZY7yOXWp5koODtkK0fMRBhdcr9aPsj7K9asNGiTcl8ptAewNLbZKkox7kL6X
         JySKYViV7IrUwlgUT505NKMS4f6luQFn9IvT719gSLct9IHawazLHrsokasFg1/gvRD9
         EByUWMw1ip+fFNRsry0+8JMN3NOANxq4bgB05zDWuhQ8nEen61YhMR2+uDRlacU7bczO
         yombie/4gPTNywJI1hbWM9zxRVEmh8VkbK3cxTQoMhfKKwvFlayHFyn8etDWl4+GDqGO
         H3CPQ4uipNiRDhhGxxYKJ43dCFd50LmHGvfgEgREDD8tFymcl2BE9TQEYdO4bcSb0vLa
         0Rbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FQdxnzFRF8w408R2EqIrB/+ghDevgj/VHmIDuzUiaME=;
        b=MbnfOXRtWkP5f75MJZu+PfNJETgAdcgZPpe7QQDH13y7nWLcD2/hOJAO+/FqLtaqVl
         NZfcnHZDnMaqUC+SMn3/7jK5mDDbvxyYy5Fay9OwXb7xjHyrEH7yaaowsemRVDbDqMiq
         qtkDT5ZATxf6uYyd/K5a4r2CCEDbmlIDIr8HDAUG1gtnB0+QDlUs5caq5FXIt5U4m2Mq
         1LH7h8lHH1RA+oTIyawSgA+mMAf9f55ZpV5DBINjTEpJ4e2VRxarCQN3IAlJ/2Sue/7+
         P5p8UuTv2IiFDQef/sW0ilkfFkiXqqSm0P5QOILruPdXr/kl6KEDEFQVyNjpgt4fH7+W
         ANGA==
X-Gm-Message-State: AOAM5317hSS0PvnM/i8twPsueWeS2Md3fmzTz0aX2t6lCUOEvcpN8ybG
        MsayWeuODLuYDjZcNk1oBCcBDixbTr8feQ==
X-Google-Smtp-Source: ABdhPJwA+Tle2tcD/KC5ITtEgfM6S0L5pFzkzdsXjRw84le3/xJ2tt4uBtzBMAnNZD6s25GgBBEQLw==
X-Received: by 2002:ac2:51a8:: with SMTP id f8mr9879799lfk.472.1600337437743;
        Thu, 17 Sep 2020 03:10:37 -0700 (PDT)
Received: from mobilestation ([95.79.141.114])
        by smtp.gmail.com with ESMTPSA id h22sm5990523ljl.101.2020.09.17.03.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 03:10:37 -0700 (PDT)
Date:   Thu, 17 Sep 2020 13:10:35 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Willy Liu <willy.liu@realtek.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ryankao@realtek.com,
        Kyle Evans <kevans@FreeBSD.org>,
        Joe Hershberger <joe.hershberger@ni.com>,
        Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH] net: phy: realtek: fix rtl8211e rx/tx delay config
Message-ID: <20200917101035.uwajg4m524g4lz5o@mobilestation>
References: <1600307253-3538-1-git-send-email-willy.liu@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600307253-3538-1-git-send-email-willy.liu@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Willy,
Thanks for the patch. My comments are below.

I've Cc'ed the U-boot/FreeBSD, who might be also interested in the solution
you've provided.

On Thu, Sep 17, 2020 at 09:47:33AM +0800, Willy Liu wrote:
> RGMII RX Delay and TX Delay settings will not applied if Force TX RX Delay
> Control bit is not set.
> Register bit for configuration pins:
> 13 = force Tx RX Delay controlled by bit12 bit11
> 12 = Tx Delay
> 11 = Rx Delay

This is a very useful information, but it contradicts a bit to what knowledge
we've currently got about that magical register. Current code in U-boot does
the delays configuration by means of another bits:
https://elixir.bootlin.com/u-boot/v2020.10-rc4/source/drivers/net/phy/realtek.c

Could you provide a full register layout, so we'd know for sure what that
register really does and finally close the question for good?

> 
> Fixes: f81dadbcf7fd ("net: phy: realtek: Add rtl8211e rx/tx delays config")
> Signed-off-by: Willy Liu <willy.liu@realtek.com>
> ---
>  drivers/net/phy/realtek.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>  mode change 100644 => 100755 drivers/net/phy/realtek.c
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> old mode 100644
> new mode 100755
> index 95dbe5e..3fddd57
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -32,9 +32,9 @@
>  #define RTL8211F_TX_DELAY			BIT(8)
>  #define RTL8211F_RX_DELAY			BIT(3)
>  

> -#define RTL8211E_TX_DELAY			BIT(1)
> -#define RTL8211E_RX_DELAY			BIT(2)
> -#define RTL8211E_MODE_MII_GMII			BIT(3)
> +#define RTL8211E_CTRL_DELAY			BIT(13)
> +#define RTL8211E_TX_DELAY			BIT(12)
> +#define RTL8211E_RX_DELAY			BIT(11)

So, what do BIT(1) and BIT(2) control then? Could you explain?

>  
>  #define RTL8201F_ISR				0x1e
>  #define RTL8201F_IER				0x13
> @@ -249,13 +249,13 @@ static int rtl8211e_config_init(struct phy_device *phydev)
>  		val = 0;
>  		break;
>  	case PHY_INTERFACE_MODE_RGMII_ID:
> -		val = RTL8211E_TX_DELAY | RTL8211E_RX_DELAY;
> +		val = RTL8211E_CTRL_DELAY | RTL8211E_TX_DELAY | RTL8211E_RX_DELAY;
>  		break;
>  	case PHY_INTERFACE_MODE_RGMII_RXID:
> -		val = RTL8211E_RX_DELAY;
> +		val = RTL8211E_CTRL_DELAY | RTL8211E_RX_DELAY;
>  		break;
>  	case PHY_INTERFACE_MODE_RGMII_TXID:
> -		val = RTL8211E_TX_DELAY;
> +		val = RTL8211E_CTRL_DELAY | RTL8211E_TX_DELAY;
>  		break;
>  	default: /* the rest of the modes imply leaving delays as is. */
>  		return 0;
> @@ -265,9 +265,8 @@ static int rtl8211e_config_init(struct phy_device *phydev)
>  	 * 0xa4 extension page (0x7) layout. It can be used to disable/enable
>  	 * the RX/TX delays otherwise controlled by RXDLY/TXDLY pins. It can
>  	 * also be used to customize the whole configuration register:

> -	 * 8:6 = PHY Address, 5:4 = Auto-Negotiation, 3 = Interface Mode Select,
> -	 * 2 = RX Delay, 1 = TX Delay, 0 = SELRGV (see original PHY datasheet
> -	 * for details).
> +	 * 13 = Force Tx RX Delay controlled by bit12 bit11,
> +	 * 12 = RX Delay, 11 = TX Delay

Here you've removed the register layout description and replaced it with just three
bits info. So from now the text above doesn't really corresponds to what follows.

I might have forgotten something, but AFAIR that register bits state mapped
well to what was available on the corresponding external pins. So if you've got
a sacred knowledge what configs are really hidden behind that register, please
open it up. This in-code comment would be a good place to provide the full
register description.

-Sergey

>  	 */
>  	oldpage = phy_select_page(phydev, 0x7);
>  	if (oldpage < 0)
> @@ -277,7 +276,8 @@ static int rtl8211e_config_init(struct phy_device *phydev)
>  	if (ret)
>  		goto err_restore_page;
>  
> -	ret = __phy_modify(phydev, 0x1c, RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
> +	ret = __phy_modify(phydev, 0x1c, RTL8211E_CTRL_DELAY
> +			   | RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
>  			   val);
>  
>  err_restore_page:
> -- 
> 1.9.1
> 
