Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7302C368AC0
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240249AbhDWBwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240151AbhDWBwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:52:49 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14576C061574;
        Thu, 22 Apr 2021 18:52:14 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g16so19744755pfq.5;
        Thu, 22 Apr 2021 18:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hTqeOoCxpmP+/VpBMHvIwM6ctbQfsuJAmHPb75r8utw=;
        b=uRTlOmJYnj3BKHWQdK4Zx05P2L/OrJXrcgtmTL6Z2WO/HFNVRKkRr//ZXQaD2HUsBl
         Xa4yO5qpS2lOEo4A1FM3SGSWQhJEfwtIgHDM8Xi/5rWlVKTZl/7havR8xUKvcGiQaWdV
         ahMrLM3ASAaL9I8Jk7ci6JfJAewGjcobUrGYDV8X17KATKe7Xo+1k5QA+Y02quPC/Vq/
         Bqp9BMbvHkxkmd8Ragi1INRjV5sLf+ReinpHYvaGNiYE10DjVd9mQ6zNCRq/a21IEgKS
         vreHv0ziTXns0m8n34mWA7swZwCItO65JI8i8g2t9If/1fMGUCVoNgevgkWD0HiFWaKq
         3Dyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hTqeOoCxpmP+/VpBMHvIwM6ctbQfsuJAmHPb75r8utw=;
        b=Pgx7YqIiOeh+Ey09NG5HO5EnIvybNW5vZioh+8qgFzibBYpDDm4aTVm9j5PvEOri2p
         gDb16+eeqvImGQud2ROfiKa6dM4SdiLRYs3PocB0/pkP0NZQxxCerxV13EYvRJ5KzQjy
         FP7dUlS+F2zCp8vpCH7cZVN1T1RKCBDbObPTsVYBQy1PWkw2auvy9v9EWxwgQ4dI2R13
         tkcjAfA4JMlXlSKF/hFgYfuaa8y9ZQSJ9gUJ8CVSXxiw2kVZLt3XOHTxkLyiSteVyI/O
         rwJcYOuRoTXfBs51qZA7PTvUAtpznrOx2uN92SHksvB2crDJADhRmYZQiA+EpF+rjYuV
         xQiA==
X-Gm-Message-State: AOAM532ZyGX+sA+T9tCMRGSvwND7mFBLbN4PXTRIXpKpQ09f9tLaTRdE
        WQITJ1/IIdifh0rw7WWJwADpGtTJpjc=
X-Google-Smtp-Source: ABdhPJzyC8KaGdFuiC+qSklSghjKjeN5KwifZKxtReNWozv6hjrULdZkPFdNDKbGUMzKCvJu6dulrw==
X-Received: by 2002:a63:e541:: with SMTP id z1mr1564175pgj.59.1619142733188;
        Thu, 22 Apr 2021 18:52:13 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n50sm3099672pfv.69.2021.04.22.18.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 18:52:12 -0700 (PDT)
Subject: Re: [PATCH 01/14] drivers: net: dsa: qca8k: handle error with
 set_page
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-2-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e2a3fc19-d7ee-3552-e443-ba0190fa4b08@gmail.com>
Date:   Thu, 22 Apr 2021 18:52:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210423014741.11858-2-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/2021 6:47 PM, Ansuel Smith wrote:
> Better handle function qca8k_set_page. The original code requires a
> deleay of 5us and set the current page only if the bus write has not
> failed.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index cdaf9f85a2cb..a6d35b825c0e 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -133,9 +133,12 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
>  	if (page == qca8k_current_page)
>  		return;
>  
> -	if (bus->write(bus, 0x18, 0, page) < 0)
> +	if (bus->write(bus, 0x18, 0, page)) {
>  		dev_err_ratelimited(&bus->dev,
>  				    "failed to set qca8k page\n");
> +		return;
> +	}

An improvement would be to propagate the return value to the two callers
which themselves do allow an error to be propagated no? If you cannot
set the page you are pretty much toast.
-- 
Florian
