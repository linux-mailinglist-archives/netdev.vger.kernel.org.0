Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04707206AAF
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388666AbgFXDgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388577AbgFXDgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 23:36:50 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB96C061573;
        Tue, 23 Jun 2020 20:36:49 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id e11so803714ilr.4;
        Tue, 23 Jun 2020 20:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AKh1TNe6BSCcWuzmNyBvkzZPOCmie0Lz76Lc1B+GrLo=;
        b=F9pkpSxyueB/tfqgtc9jbqIEJQpQo/CjCMyWkQtYsUrQ0rFCPHR+Rv3XqzwVnlQ8nn
         6FUtYPOcoDpEWZbKI9E/Riun6vB3Dgkl36KmuhC1FWKLRr/ZGXiIUWcWpDGLTRjY5n+b
         TX9r1Lg2EQHPcsvvA4oDRsLpTo4rgIF4qW1u5DUNjGuwM4X6kqRxDcay26VnHJUWm+pv
         vpkik6kQMaqqCkP7LRYFxdfeO4KiJos/2kt0uE4od6DrGCyvuQsrvdGzqvFvAnLKROTV
         dTbScrQBJFWnZTDWuvwBwou+nYEmbfZBAzEj64dcM1gF4GGVHQREsexXAOSA2tB/Yii5
         edXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AKh1TNe6BSCcWuzmNyBvkzZPOCmie0Lz76Lc1B+GrLo=;
        b=PgLdoPhcdmN0gAl4reAXUmISNB66n0rVaOoMEFqnMLK+wdy8i1E7IZXIfxzsOyHmJh
         dEaMNBA/4+N9yMBrFNc8GSdHhsfun/8G3Mat21mNsno3UOQWUZUaalcFQcGBJxp1jK67
         T8znNUWL/XznYrlmE5IeH0yxO8uWBlXXUeKUwkOLN8cTM+S8IsCPjPXX8Qor2GY/5sCI
         C7mAzUAHBQ9TsEhXZnaEb2ZPOUscQw6yTJePZ1XZx132V6xUUre470idTOKdW1BpQSqP
         boua4CP6UuriQXz9+j7CpHvKo0vp/PXEypfC4vKQUUP6WmPOwvRr8vJCeNoHw1hbcv68
         dM2Q==
X-Gm-Message-State: AOAM530MJCLqmi4uGRSigT3StEtZBBJdDL1vi5Wmf3Kpkrb+eshjVHmn
        Ljj2Ku0Fxtp2uxIHTDbXCQQcSzjZ
X-Google-Smtp-Source: ABdhPJwNd5yaAgx32DNu4HaPaL20EI1XjDBGktCdPTNW6whrNgi8/9oN5As/TxuTJSj7+yf5mTYpHA==
X-Received: by 2002:a92:404d:: with SMTP id n74mr26122109ila.0.1592969808495;
        Tue, 23 Jun 2020 20:36:48 -0700 (PDT)
Received: from [192.168.1.2] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.googlemail.com with ESMTPSA id m2sm3549263iln.1.2020.06.23.20.36.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 20:36:47 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] net: phy: call phy_disable_interrupts() in
 phy_init_hw()
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200624112516.7fcd6677@xhacker.debian>
 <20200624112624.200306ac@xhacker.debian>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <996affa7-9f78-73c4-8f86-9bcd337191c4@gmail.com>
Date:   Tue, 23 Jun 2020 20:36:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200624112624.200306ac@xhacker.debian>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 2020-06-23 à 20:26, Jisheng Zhang a écrit :
> Call phy_disable_interrupts() in phy_init_hw() to "have a defined init
> state as we don't know in which state the PHY is if the PHY driver is
> loaded. We shouldn't assume that it's the chip power-on defaults, BIOS
> or boot loader could have changed this. Or in case of dual-boot
> systems the other OS could leave the PHY in whatever state." as pointed
> out by Heiner.
> 
> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> ---
>  drivers/net/phy/phy_device.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 04946de74fa0..f17d397ba689 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1090,10 +1090,13 @@ int phy_init_hw(struct phy_device *phydev)
>  	if (ret < 0)
>  		return ret;
>  
> -	if (phydev->drv->config_init)
> +	if (phydev->drv->config_init) {
>  		ret = phydev->drv->config_init(phydev);
> +		if (ret < 0)
> +			return ret;
> +	}
>  
> -	return ret;
> +	return phy_disable_interrupts(phydev);

Not sure if the order makes sense here, it may seem more natural for a
driver writer to have interrupts disabled first and then config_init
called (which could enable interrupts not related to link management
like thermal events etc.)
-- 
Florian
