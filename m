Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9A93FBF14
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 00:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238941AbhH3Wop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 18:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbhH3Wop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 18:44:45 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4AEC061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 15:43:50 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id b6so24535177wrh.10
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 15:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=icDw/9BeG4AjgaRuj4Vr/S4hCHv51JQFMxFQ6y59uac=;
        b=I7txyrcbS/ul1e6uH/Xl6JjW+t2CWkeVknDuVQIqLJODXDMB+kpeRndMoTpiniDtPT
         hYGK22cCgPE4l1MU5gGY9a+yX+XH4xFQ6Dr2k56sJ35loayCCV8uf+DPktKfx4oWJ059
         xpV9/JhmMbJxCuJkGG1QpkqbqgK51eeitT9h//SrzXMSn14wJSclR/5Ox05SKkUWTJ/a
         uygdirN+bRHMUNQQJDnUUigBLGsyLpFi4GRCQkqNBG1li6TBQ+gsziFe1tfjUlAsl4vH
         IqvrNfwToFHPlalsGh2njTDuyjnop7wGOvpAtU/AguVHk3pLm/AP/2WDyySGL3JE+gRA
         ELyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=icDw/9BeG4AjgaRuj4Vr/S4hCHv51JQFMxFQ6y59uac=;
        b=X8x8Sa7gXAQwcvjuGY0AdWF0ZsFh+hhKsCybVzfeTXnIYTb0/Fy3QSIayTs1Ci0Ix+
         Y9kV3vSYPdJDkBXE9PZ4N/Pkk3QimFKcqjzKFf1UPdw3Zz+Q9FFMESR2e0owiEA653Sd
         nUSonO1eockj/Jk6MtlHje+yANGLc6gs9PFB1vvYlGH0Ls+ct2JWpId/PVZ3dy91aJtB
         tF2DWRWxTPPetM03Q9PRARPkfld0C9Wo8ULHifuOrB4zRj05tCduBJmde6/H66JpvZKA
         yMA5fj71x6avB0qn93KtOcwm7HrgN3YlfICKnMfLTfZyHNw41EDqH6UaOxboCG5yr0Up
         wnpQ==
X-Gm-Message-State: AOAM532ChVtuu0b99+Kf0euBjAeQkICnboBfRWpcnLnk31N96IsR+8Ye
        tZ+oRR6JeCN5xq9UlZ+5dXk=
X-Google-Smtp-Source: ABdhPJw5lBQIwJ8qG6YlpOYuwjKo4j/T4uMK1bl0HIOB1Mm3u6w8EINBj5V83J7+pAfPa4SGJh1a8g==
X-Received: by 2002:adf:9003:: with SMTP id h3mr10821841wrh.75.1630363429067;
        Mon, 30 Aug 2021 15:43:49 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id v5sm16206389wrw.44.2021.08.30.15.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 15:43:48 -0700 (PDT)
Date:   Tue, 31 Aug 2021 01:43:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 4/5 v2] net: dsa: rtl8366rb: Support flood
 control
Message-ID: <20210830224347.3ihtdgs56enz2ju3@skbuf>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-5-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210830214859.403100-5-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 11:48:58PM +0200, Linus Walleij wrote:
> Now that we have implemented bridge flag handling we can easily
> support flood (storm) control as well so let's do it.
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - New patch
> ---
>  drivers/net/dsa/rtl8366rb.c | 38 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
> index 2cadd3e57e8b..4cb0e336ce6b 100644
> --- a/drivers/net/dsa/rtl8366rb.c
> +++ b/drivers/net/dsa/rtl8366rb.c
> @@ -149,6 +149,11 @@
>  
>  #define RTL8366RB_VLAN_INGRESS_CTRL2_REG	0x037f
>  
> +#define RTL8366RB_STORM_BC_CTRL			0x03e0
> +#define RTL8366RB_STORM_MC_CTRL			0x03e1
> +#define RTL8366RB_STORM_UNDA_CTRL		0x03e2
> +#define RTL8366RB_STORM_UNMC_CTRL		0x03e3
> +
>  /* LED control registers */
>  #define RTL8366RB_LED_BLINKRATE_REG		0x0430
>  #define RTL8366RB_LED_BLINKRATE_MASK		0x0007
> @@ -1158,7 +1163,8 @@ rtl8366rb_port_pre_bridge_flags(struct dsa_switch *ds, int port,
>  				struct netlink_ext_ack *extack)
>  {
>  	/* We support enabling/disabling learning */
> -	if (flags.mask & ~(BR_LEARNING))
> +	if (flags.mask & ~(BR_LEARNING | BR_BCAST_FLOOD |
> +                           BR_MCAST_FLOOD | BR_FLOOD))

Spaces instead of tabs here?

>  		return -EINVAL;
>  
>  	return 0;
> @@ -1180,6 +1186,36 @@ rtl8366rb_port_bridge_flags(struct dsa_switch *ds, int port,
>  			return ret;
>  	}
>  
> +	if (flags.mask & BR_BCAST_FLOOD) {
> +		ret = regmap_update_bits(smi->map, RTL8366RB_STORM_BC_CTRL,
> +					 BIT(port),
> +					 (flags.val & BR_BCAST_FLOOD) ? BIT(port) : 0);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (flags.mask & BR_MCAST_FLOOD) {
> +		ret = regmap_update_bits(smi->map, RTL8366RB_STORM_MC_CTRL,
> +					 BIT(port),
> +					 (flags.val & BR_MCAST_FLOOD) ? BIT(port) : 0);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* Enable/disable both types of unicast floods */
> +	if (flags.mask & BR_FLOOD) {
> +		ret = regmap_update_bits(smi->map, RTL8366RB_STORM_UNDA_CTRL,
> +					 BIT(port),
> +					 (flags.val & BR_FLOOD) ? BIT(port) : 0);
> +		if (ret)
> +			return ret;
> +		ret = regmap_update_bits(smi->map, RTL8366RB_STORM_UNMC_CTRL,
> +					 BIT(port),
> +					 (flags.val & BR_FLOOD) ? BIT(port) : 0);
> +		if (ret)
> +			return ret;

UNDA and UNMC?

> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 2.31.1
> 

