Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95615610428
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 23:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237171AbiJ0VMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 17:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236893AbiJ0VM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 17:12:27 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550E44D4D3
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:11:11 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id o4so4261651wrq.6
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=llYNiJFW58uMYnEOKGzriQ7rsSFiLYdO6s5x7YgEILw=;
        b=PRKt/9IKypKRZuLOg86jJ4LoLWnaXUby5vJiE7BuuAN4myfaKtx4cgV8WYXUNCGKt+
         LN7br3YbQcnp1nRAB16qJcRZIiCfHY/iS/iC0ygKzt4DEqtcVlxdODloWdBR9ljrqSoZ
         07Ixfj9FzkjUyKuwYkf6u7Q8Mv7laUOW4fmK2aax1aaWPmPhYnAXUm5DuPW0sHQtF++n
         rIRpv6PJzFI+YzO3IvInaQeDAUuXMkwknWM5L5ECJH2pA553DNIgWJFVDjqlcplqhS3R
         jmiVYzMob7cWonxqv0ww3fMq0/58m0et9oJWYWKwZsw65CEDbl20YKAFYk90jLH8xQch
         yizA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=llYNiJFW58uMYnEOKGzriQ7rsSFiLYdO6s5x7YgEILw=;
        b=wqIxL5R0f70qg4yWa90pnIPyhPJSc7YpDQ/M1YE04Rgua4FMIvE5BQC07z3az4ZNs8
         ng+BFMkTRj+ZLgOXuIHvvosk3vWeaKds2uuU16VMTTEQvXtTSisqyZGthgyEUI3Eku0r
         1iM9oLjevGtdNRxR4SC8NmB8JPSboNkjK4skPDflyUD6CsaMk60CgNpakUg6/TLGZ3rj
         xp77btEUyxOVJFA8Vrua7md0gezSMBffChJnRzEn9cnMYEbwtmVLzB3krSV41Avr/ryu
         vXsHQgBvG1V+QRYhJLrplNbzIrgOZs0FZ06bxyAlPwsRp6xrj1kQhcCJTqJPTawIPxT6
         TrWg==
X-Gm-Message-State: ACrzQf2C19MSqH8rzKavQATwQC4eE7L4vsDHQXiHJirIeCR6xo/2g1aC
        Mo36J2B8JrE0jkuyarvGj/Q=
X-Google-Smtp-Source: AMsMyM5HtEdUlKuKsJBQhawbW1qDiwAy4PNOjWAcyDQLG6K6w2gSpAqvdXAxD6GHN03SJIdCtfhfug==
X-Received: by 2002:a05:6000:184:b0:236:7685:7e6d with SMTP id p4-20020a056000018400b0023676857e6dmr13952285wrx.305.1666905069620;
        Thu, 27 Oct 2022 14:11:09 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b8ce:ec00:3539:4fbe:1050:1ad9? (dynamic-2a01-0c23-b8ce-ec00-3539-4fbe-1050-1ad9.c23.pool.telefonica.de. [2a01:c23:b8ce:ec00:3539:4fbe:1050:1ad9])
        by smtp.googlemail.com with ESMTPSA id c6-20020a5d5286000000b0022ca921dc67sm2015825wrv.88.2022.10.27.14.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 14:11:09 -0700 (PDT)
Message-ID: <67d3de52-54b6-e88f-f9b9-b87790d9c9a0@gmail.com>
Date:   Thu, 27 Oct 2022 23:09:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Denis Kirjanov <dkirjanov@suse.de>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
References: <4bca2d92-e966-81d7-d5a6-2c4240194ff4@suse.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next] phy: convert to boolean for the mac_managed_pm flag
In-Reply-To: <4bca2d92-e966-81d7-d5a6-2c4240194ff4@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.10.2022 17:05, Denis Kirjanov wrote:
> Signed-off-by: Dennis Kirjanov <dkirjanov@suse.de>

Commit message is missing.
It should be "net: phy:" instead of "phy:".
You state that you convert the flag to boolean but you convert only the users.

> ---
>  drivers/net/ethernet/freescale/fec_main.c | 2 +-
>  drivers/net/ethernet/realtek/r8169_main.c | 2 +-
>  drivers/net/usb/asix_devices.c            | 4 ++--

This should be separate patches.

>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 98d5cd313fdd..4d38a297ec00 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -2226,7 +2226,7 @@ static int fec_enet_mii_probe(struct net_device *ndev)
>  	fep->link = 0;
>  	fep->full_duplex = 0;
>  
> -	phy_dev->mac_managed_pm = 1;
> +	phy_dev->mac_managed_pm = true;
>  
Definition is: unsigned mac_managed_pm:1;
Therefore 1 is the correct value, why assigning a bool to a bitfield member?

>  	phy_attached_info(phy_dev);
>  
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index a73d061d9fcb..5bc1181f829b 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -5018,7 +5018,7 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>  		return -EUNATCH;
>  	}
>  
> -	tp->phydev->mac_managed_pm = 1;
> +	tp->phydev->mac_managed_pm = true;
>  
>  	phy_support_asym_pause(tp->phydev);
>  
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 11f60d32be82..02941d97d034 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -700,7 +700,7 @@ static int ax88772_init_phy(struct usbnet *dev)
>  	}
>  
>  	phy_suspend(priv->phydev);
> -	priv->phydev->mac_managed_pm = 1;
> +	priv->phydev->mac_managed_pm = true;
>  
>  	phy_attached_info(priv->phydev);
>  
> @@ -720,7 +720,7 @@ static int ax88772_init_phy(struct usbnet *dev)
>  		return -ENODEV;
>  	}
>  
> -	priv->phydev_int->mac_managed_pm = 1;
> +	priv->phydev_int->mac_managed_pm = true;
>  	phy_suspend(priv->phydev_int);
>  
>  	return 0;

