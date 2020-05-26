Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC18F1E3115
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404212AbgEZVWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403878AbgEZVWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 17:22:34 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97467C061A0F;
        Tue, 26 May 2020 14:22:34 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j21so10675805pgb.7;
        Tue, 26 May 2020 14:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J/Hxv10p1u+qdYRmsyZWQAn4qMOS/a3PxG600UXIWTM=;
        b=dz9YUIVqH0AWe3CohewOUedDHc7P0WRC48OTKi6Hn1G0XrQ342WdumVhThTSq6EJrZ
         QQGgkjgydftJloQ72YDRO1UFfU2WrkuXZBcPOF+MFIUuXYIvPUVNRpjcSVBYi90eAkxp
         zNJ7jJtIicPBE0o1Yv26fd9A3TR0159Ldl7JmPtYZJXXLae30HNMliuVOFzQo8fTAlwX
         qPC4F9i0QRas80NXbXP4LneUws9iIxkPebNke5rtjOtWjjT5EZcPcOKVYHAGr9sSZbCl
         CetiV/4zfVImEr6gUyCI8ty4chlbxynRC/2LxGZq1jxksDXouAe8LxN8Xs/dChjshSXW
         zV/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J/Hxv10p1u+qdYRmsyZWQAn4qMOS/a3PxG600UXIWTM=;
        b=CKp3aOSDVRuNivg5BWromxiVDPwUGnh7SkJfGnPpMuUFL5G5WtrrK43gvo+B8F2KOX
         uOvaMkiuoZQvtfkizGRn/V3A1E+/Xa9wdK/znHDv1ufvKEF6kq8xKdK3kIjebE0KZ1fh
         NhrRrbMus15eppUBam/jjI7Q8SDXBxFn3sLucSS5r6VQMjfojLaxaDb1JObPqNpkWiz2
         iuMSir50QIHS8diAAErKgH8ugxzS/Kes01GTyl4tgxL+E5UCbdJnq3zQpeOHPhqPP09Z
         U8ooEbmjLVxMk7kSqsB0r+iGx1E82YNnAG7/lY7kMqLo2l8nhQD6VnUbxJ02KENoPt4Q
         LN2w==
X-Gm-Message-State: AOAM533SD8Dfz6derpmYlvGyq/zkEzA8AAJT+46er/F7ot7WcZoHz2jE
        pbk+VxkhuyRb3w293gFeOOhFiKAQ
X-Google-Smtp-Source: ABdhPJw5ZHLNuABAPSQsUrd2hg1gAyB5GH2gzGn8cACgk+oCFvL/5+YqQQoh6lc3Dt2UDgsbjLEZow==
X-Received: by 2002:a62:e419:: with SMTP id r25mr736849pfh.82.1590528154133;
        Tue, 26 May 2020 14:22:34 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e13sm391669pfh.19.2020.05.26.14.22.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 14:22:33 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] net: phy: mscc-miim: read poll when high
 resolution timers are disabled
To:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        andrew@lunn.ch, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
References: <20200526162256.466885-1-antoine.tenart@bootlin.com>
 <20200526162256.466885-5-antoine.tenart@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e95bbdb6-a6db-be02-660e-7318b9bb5f01@gmail.com>
Date:   Tue, 26 May 2020 14:22:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200526162256.466885-5-antoine.tenart@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/26/2020 9:22 AM, Antoine Tenart wrote:
> The driver uses a read polling mechanism to check the status of the MDIO
> bus, to know if it is ready to accept next commands. This polling
> mechanism uses usleep_delay() under the hood between reads which is fine
> as long as high resolution timers are enabled. Otherwise the delays will
> end up to be much longer than expected.
> 
> This patch fixes this by using udelay() under the hood when
> CONFIG_HIGH_RES_TIMERS isn't enabled. This increases CPU usage.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> ---
>  drivers/net/phy/Kconfig          |  3 ++-
>  drivers/net/phy/mdio-mscc-miim.c | 22 +++++++++++++++++-----
>  2 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 2a32f26ead0b..047c27087b10 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -184,7 +184,8 @@ config MDIO_MSCC_MIIM
>  	depends on HAS_IOMEM
>  	help
>  	  This driver supports the MIIM (MDIO) interface found in the network
> -	  switches of the Microsemi SoCs
> +	  switches of the Microsemi SoCs; it is recommended to switch on
> +	  CONFIG_HIGH_RES_TIMERS
>  
>  config MDIO_MVUSB
>  	tristate "Marvell USB to MDIO Adapter"
> diff --git a/drivers/net/phy/mdio-mscc-miim.c b/drivers/net/phy/mdio-mscc-miim.c
> index aed9afa1e8f1..11f583fd4611 100644
> --- a/drivers/net/phy/mdio-mscc-miim.c
> +++ b/drivers/net/phy/mdio-mscc-miim.c
> @@ -39,13 +39,25 @@ struct mscc_miim_dev {
>  	void __iomem *phy_regs;
>  };
>  
> +/* When high resolution timers aren't built-in: we can't use usleep_range() as
> + * we would sleep way too long. Use udelay() instead.
> + */
> +#define mscc_readl_poll_timeout(addr, val, cond, delay_us, timeout_us)	\
> +({									\
> +	if (!IS_ENABLED(CONFIG_HIGH_RES_TIMERS))			\
> +		readl_poll_timeout_atomic(addr, val, cond, delay_us,	\
> +					  timeout_us);			\
> +	readl_poll_timeout(addr, val, cond, delay_us, timeout_us);	\
> +})
> +

I would make this a regular function which would not harm the compiler's
ability to optimize it, but would give you type checking. With that fixed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
