Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBC9254128
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 10:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgH0Is4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 04:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgH0Is4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 04:48:56 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997CDC061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 01:48:55 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id bo3so6557514ejb.11
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 01:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UPa6DuIbbKBA3/Upa+iNPRrifZuPdrNH0xaYLzyzBOw=;
        b=NZVpZaQTbW1e9AxIT0rfBGyUOx4f3Jd5L0O86X8j+9vnoXkY6Ldhzn4RP8Q1h9G002
         x5rmT9ti0HTR3lx9rNkyFujELqMMWO+4gDW+mM2i4bxBgBj8AB+4kSsdQQ+B6TbIsajD
         EPEc+6X0XleLM7SZY/z1bOh0M3bQikUE4bZ6zFypky82+ZG2+8A3/UlT7JcsgpZnhH6f
         Kgpm4QFuLwDbJuTUff/dEu/Nhc0REviHGbmCdPqpTISe8wjSY5giLDW4wju4t9d45KKz
         Jhtp5QwjEot3X5NSmURGPPpF2SOHwnNgtlDLHBE6j9OjRFCCQCdFg9ofBw9Fl0En0kqc
         cR9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UPa6DuIbbKBA3/Upa+iNPRrifZuPdrNH0xaYLzyzBOw=;
        b=l/Xb3M8N8+C1KPDSYKLQ8gg0l7/zgoCqZNFJdJvUcMZfG77760t0d2LSP9z0ReyhO6
         N0KcHsbC/nCwjYR9DkPXmTDC+MwvY12bPGDP2lnVbqjYIqCw2Xj7EodNBxdTwVUYsCJl
         dtm1jz561AAX7JJkbJ7J8VIVxZPI1BYGn1rzYLNBwVenGe+nez8pcdilnVvktA/V8Gnb
         tab6tuzBhDjOyeA4Jyt00sBN7Nh7ADmVniufhY/2vjIKTjz4vPTzq5rYlw9oiL8JLzgq
         F7V6d90oUfesA6BKNCm0LHWLzDVWSbrHimq9g611OgYXLIPP+Vb8igVy9Dhvnvd9Nvkw
         cT8g==
X-Gm-Message-State: AOAM530/L5/NvbTRI1I10i5PRHUYI3rkKK3uwzffW+EcGWb/Hnv9Gt2E
        MHXjlsZv475zyINmHr1E/rg=
X-Google-Smtp-Source: ABdhPJxR8xx0twnPah855FS1JUCbKw1EX70jzQfAZZz5S9+khg7bHGQ1Vcq9opDWDgXZi0uLqbtMsw==
X-Received: by 2002:a17:906:edc5:: with SMTP id sb5mr11426149ejb.369.1598518134145;
        Thu, 27 Aug 2020 01:48:54 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:88d6:516:4510:4c1f? (p200300ea8f23570088d6051645104c1f.dip0.t-ipconnect.de. [2003:ea:8f23:5700:88d6:516:4510:4c1f])
        by smtp.googlemail.com with ESMTPSA id r21sm1355298ejz.51.2020.08.27.01.48.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 01:48:53 -0700 (PDT)
Subject: Re: [PATCHi v2] net: mdiobus: fix device unregistering in
 mdiobus_register
To:     Sascha Hauer <s.hauer@pengutronix.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de
References: <20200827070618.26754-1-s.hauer@pengutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3f9daa3c-8a16-734b-da7b-e0721ddf992c@gmail.com>
Date:   Thu, 27 Aug 2020 10:48:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200827070618.26754-1-s.hauer@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.08.2020 09:06, Sascha Hauer wrote:
> After device_register has been called the device structure may not be
> freed anymore, put_device() has to be called instead. This gets violated
> when device_register() or any of the following steps before the mdio
> bus is fully registered fails. In this case the caller will call
> mdiobus_free() which then directly frees the mdio bus structure.
> 
> Set bus->state to MDIOBUS_UNREGISTERED right before calling
> device_register(). With this mdiobus_free() calls put_device() instead
> as it ought to be.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
> 
> Changes since v1:
> - set bus->state before calling device_register(), not afterwards
> 
>  drivers/net/phy/mdio_bus.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 0af20faad69d..9434b04a11c8 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -534,6 +534,8 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>  	bus->dev.groups = NULL;
>  	dev_set_name(&bus->dev, "%s", bus->id);
>  
> +	bus->state = MDIOBUS_UNREGISTERED;
> +
>  	err = device_register(&bus->dev);
>  	if (err) {
>  		pr_err("mii_bus %s failed to register\n", bus->id);
> 
LGTM. Just two points:
1. Subject has a typo (PATCHi). And it should be [PATCH net v2], because it's
   something for the stable branch.
2. A "Fixes" tag is needed.
