Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938B72534D3
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgHZQ0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbgHZQ0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:26:50 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9462EC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:26:49 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id oz20so3710937ejb.5
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wrLEhyykKZ2RpiQ6L58VSvcplY5mu1P0J6ujk43nyVg=;
        b=O/9hiAd9Q3zSDZYibQJ99Fnto4G86/S8cP/GMk/Lv2v7zlSNjJHyOVFW1F0klVqJSJ
         YhSRDeGhB6fTNien1Zq2UxSQ+osqYjxLFhdpSP+OD4hAc/BUzZoZS3/7WOBN9+OrOKs/
         IGyTe5RT6CCOd/UjyEsaBfsV/FxvpCpfmdsIbcK+Zn964dZI4nmjv9UHFEnNaP8QArd9
         8M3Nk/LPUxDWYLuL5ydbTwbxjlpzgz+xOwGgVknDA0FUHXNF6GWsUVOoGx6djtt/ZUyD
         uwK4rLEfUAhRZskjMchQ1K6a7Bi2iLFMR2tKjnnD5WCL7etJjUJk/e9N7vHDmis6tBfc
         vwLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wrLEhyykKZ2RpiQ6L58VSvcplY5mu1P0J6ujk43nyVg=;
        b=UIcw/5WqYlAY2yjwdbG/dzwVfeU9KXSUdbtSySThUfYKq1SSnzvc7yjQMIPEOlUnfh
         FhBGf8AOW3HGmRKCSH/qxTt8cEpv6xhBE4NL1JkMDSoltZYJQh/sWxVDgYJ3u4dtgJ4T
         5Ntw3TM54AHq+86ABhaW1mN/CsMhwK3o1RkhwKQ816PVvTGVH4cn0O9hKSDbi49m7Uth
         3QIE6N1j5XmmvxNegfqDAbwoPo9zFB8B92OKZ4wwUn26nUYT72zTr1t853rtolTLW5po
         VZftvL5L+olQeGsmtLX5vB/yTFNF6rsx6HXK9iArT0Xaf24N2PPYu0GRC+NyMngvWY+4
         wgkg==
X-Gm-Message-State: AOAM530gHsLeH48MyBdy0UBIWyZ0k936j1jfQGcfXxcavNOvUEwa2f4p
        7MSXb7FgOyeXTC363RHOmrQ=
X-Google-Smtp-Source: ABdhPJwQ+K7vw4yf1eJvmUcwa4TizNOb1OSmc4AglHhknphfrUj+8zslgthJAeqdxf9zKxcRyFYEpg==
X-Received: by 2002:a17:906:b09a:: with SMTP id x26mr2656071ejy.162.1598459208260;
        Wed, 26 Aug 2020 09:26:48 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:9d4:6f74:3951:c887? ([2003:ea:8f23:5700:9d4:6f74:3951:c887])
        by smtp.googlemail.com with ESMTPSA id eb5sm1653060ejc.94.2020.08.26.09.26.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 09:26:47 -0700 (PDT)
Subject: Re: [PATCH] net: mdiobus: fix device unregistering in
 mdiobus_register
To:     Sascha Hauer <s.hauer@pengutronix.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de
References: <20200826095141.5156-1-s.hauer@pengutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7a1f68b7-c23b-11e2-befc-105b995da89f@gmail.com>
Date:   Wed, 26 Aug 2020 18:26:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826095141.5156-1-s.hauer@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.08.2020 11:51, Sascha Hauer wrote:
> __mdiobus_register() can fail between calling device_register() and
> setting bus->state to MDIOBUS_REGISTERED. When this happens the caller
> will call mdiobus_free() which then frees the mdio bus structure. This
> is not allowed as the embedded struct device is already registered, thus
> must be freed dropping the reference count using put_device(). To
> accomplish this set bus->state to MDIOBUS_UNREGISTERED after having
> registered the device. With this mdiobus_free() correctly calls
> put_device() instead of freeing the mdio bus structure directly.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/net/phy/mdio_bus.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 0af20faad69d..85cbaab4a591 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -540,6 +540,8 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>  		return -EINVAL;
>  	}
>  
> +	bus->state = MDIOBUS_UNREGISTERED;
> +
>  	mutex_init(&bus->mdio_lock);
>  	mutex_init(&bus->shared_lock);
>  
> 
I see the point. If we bail out after having called device_register()
then put_device() has to be called. This however isn't done by
mdiobus_free() if state is MDIOBUS_ALLOCATED. So I think the idea is
right. However we have to call put_device() even if device_register()
fails, therefore setting state to MDIOBUS_UNREGISTERED should be
moved to before calling device_register().

