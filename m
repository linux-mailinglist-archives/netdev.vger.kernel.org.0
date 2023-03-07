Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA4B6AD5E1
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 04:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjCGDrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 22:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjCGDri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 22:47:38 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC3E6BDF1;
        Mon,  6 Mar 2023 19:47:20 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id d7so13093435qtr.12;
        Mon, 06 Mar 2023 19:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678160813;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bGgWQRdFIzl1Y3g1dgV/zFO10xfrflw7I7b73eveKLY=;
        b=Jk1sjQ4XJF+U0eeqj2YaRbudxWApeNhC0bPeEUGU7IfLSPL42UhVRXb1Cg+5KfwyZX
         l9dkuFX3iFNJVmNhoIfv03nph8Ey83myh/tw/x0mSID1/m581bO7l0SfnNUc7QMtRhk7
         m4KU4xtYQ/Z/kvzAHQvq8mUMGKIfaT3mddqDqyXJDAnCO6aRelzsi4sDpQDHkoT5nBZv
         LyBGTO4WTyJdZX7rhjw8UwW87eKQTFYJDnWISoKTw8b2xssQqlW4qcBnmFwmfHYsQSqH
         qO4K6iZnscGyzb/rlgC2u2v8KdVm7YXcP7LhTC8bi/G5KP6Wi6AsTDsCgG1L45bZV+/J
         dpjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160813;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bGgWQRdFIzl1Y3g1dgV/zFO10xfrflw7I7b73eveKLY=;
        b=YWFQmxWMBuF+K8DHTZH38I+om01UNGAOGUcBDP0NpSS9M8sWuUyE1aQVqEvbg3ESb8
         kACPND5URzLNtCYhhhjAZocdJfs7IaY5sL/5DivxZ1zayHrYPUisWfptfaRz0pLPyRhd
         /nUCxbnVGY45cXjIX0AnGxgadMZqTbX0OK+zM+bGbRElJcYVhXxm9Rlp+OhRPqARWs1/
         HjVMb0Vz9WInO7O8UrRIBdzQ+R2eGR2b3Ym/jd8nyM+g86NQJoPLqgKYhuhbyz/Q/WLE
         YS+YOqFXo7Uh4SsVP3Lq00vlDx6r9z+hzo6Gc/A3Cyb2f1kxu9KXSxLNGskpj1gR1pI0
         ptyA==
X-Gm-Message-State: AO0yUKUgZqx1BQ7arwnHbvMwpE7iG5v+vzE6FEBjz+J4KuKNAI2AHx1n
        Lu6KLIpDqtxe0keMZchN6ZE=
X-Google-Smtp-Source: AK7set9PVaJBUrzneXIr1jxdEgyaaGEnL7v2KZxGmtvzFeNJdAyuN5S0K2SGI8b6p+ASHr18V/RpGQ==
X-Received: by 2002:a05:622a:1a0c:b0:3bf:df2e:a494 with SMTP id f12-20020a05622a1a0c00b003bfdf2ea494mr615544qtb.6.1678160812749;
        Mon, 06 Mar 2023 19:46:52 -0800 (PST)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id s15-20020ac85ecf000000b003afbf704c7csm8583252qtx.24.2023.03.06.19.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 19:46:52 -0800 (PST)
Message-ID: <84094771-7f98-0d8d-fe79-7c22e15a602d@gmail.com>
Date:   Mon, 6 Mar 2023 19:46:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] net: asix: fix modprobe "sysfs: cannot create duplicate
 filename"
Content-Language: en-US
To:     Grant Grundler <grundler@chromium.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Cc:     Anton Lundin <glance@acc.umu.se>,
        Eizan Miyamoto <eizan@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
References: <20230307005028.2065800-1-grundler@chromium.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230307005028.2065800-1-grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/6/2023 4:50 PM, Grant Grundler wrote:
> "modprobe asix ; rmmod asix ; modprobe asix" fails with:
>     sysfs: cannot create duplicate filename \
>     	'/devices/virtual/mdio_bus/usb-003:004'
> 
> Issue was originally reported by Anton Lundin on 2022-06-22 14:16 UTC:
>     https://lore.kernel.org/netdev/20220623063649.GD23685@pengutronix.de/T/
> 
> Chrome OS team hit the same issue in Feb, 2023 when trying to find
> work arounds for other issues with AX88172 devices.
> 
> The use of devm_mdiobus_register() with usbnet devices results in the
> MDIO data being associated with the USB device. When the asix driver
> is unloaded, the USB device continues to exist and the corresponding
> "mdiobus_unregister()" is NOT called until the USB device is unplugged
> or unauthorized. So the next "modprobe asix" will fail because the MDIO
> phy sysfs attributes still exist.
> 
> The 'easy' (from a design PoV) fix is to use the non-devm variants of
> mdiobus_* functions and explicitly manage this use in the asix_bind
> and asix_unbind function calls. I've not explored trying to fix usbnet
> initialization so devm_* stuff will work.
> 
> Reported-by: Anton Lundin <glance@acc.umu.se>
> Tested-by: Eizan Miyamoto <eizan@chromium.org>
> Signed-off-by: Grant Grundler <grundler@chromium.org>

Should we have a Fixes: tag here? One more question below

> ---
>   drivers/net/usb/asix_devices.c | 32 ++++++++++++++++++++++++--------
>   1 file changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 30e87389aefa1..f0a87b933062a 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -640,8 +640,9 @@ static int asix_resume(struct usb_interface *intf)
>   static int ax88772_init_mdio(struct usbnet *dev)
>   {
>   	struct asix_common_private *priv = dev->driver_priv;
> +	int ret;
>   
> -	priv->mdio = devm_mdiobus_alloc(&dev->udev->dev);
> +	priv->mdio = mdiobus_alloc();
>   	if (!priv->mdio)
>   		return -ENOMEM;
>   
> @@ -653,7 +654,27 @@ static int ax88772_init_mdio(struct usbnet *dev)
>   	snprintf(priv->mdio->id, MII_BUS_ID_SIZE, "usb-%03d:%03d",
>   		 dev->udev->bus->busnum, dev->udev->devnum);
>   
> -	return devm_mdiobus_register(&dev->udev->dev, priv->mdio);
> +	ret = mdiobus_register(priv->mdio);
> +	if (ret) {
> +		netdev_err(dev->net, "Could not register MDIO bus (err %d)\n", ret);
> +		goto mdio_regerr;
> +	}
> +
> +	priv->phydev = mdiobus_get_phy(priv->mdio, priv->phy_addr);
> +	if (priv->phydev)
> +		return 0;

This was in ax88772_init_phy() before, why is this being moved here now?

> +
> +	netdev_err(dev->net, "Could not find PHY\n");
> +	mdiobus_unregister(priv->mdio);
> +mdio_regerr:
> +	mdiobus_free(priv->mdio);
> +	return ret;
> +}
> +
> +static void ax88772_release_mdio(struct asix_common_private *priv)
> +{
> +	mdiobus_unregister(priv->mdio);
> +	mdiobus_free(priv->mdio);
>   }
>   
>   static int ax88772_init_phy(struct usbnet *dev)
> @@ -661,12 +682,6 @@ static int ax88772_init_phy(struct usbnet *dev)
>   	struct asix_common_private *priv = dev->driver_priv;
>   	int ret;
>   
> -	priv->phydev = mdiobus_get_phy(priv->mdio, priv->phy_addr);
> -	if (!priv->phydev) {
> -		netdev_err(dev->net, "Could not find PHY\n");
> -		return -ENODEV;
> -	}
> -
>   	ret = phy_connect_direct(dev->net, priv->phydev, &asix_adjust_link,
>   				 PHY_INTERFACE_MODE_INTERNAL);
>   	if (ret) {
> @@ -805,6 +820,7 @@ static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
>   	struct asix_common_private *priv = dev->driver_priv;
>   
>   	phy_disconnect(priv->phydev);
> +	ax88772_release_mdio(priv);
>   	asix_rx_fixup_common_free(dev->driver_priv);
>   }
>   

-- 
Florian
