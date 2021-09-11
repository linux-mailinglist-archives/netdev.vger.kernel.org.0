Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21406407912
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 17:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhIKPdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 11:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbhIKPdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 11:33:09 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBFEC061574;
        Sat, 11 Sep 2021 08:31:56 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id r21so4344867qtw.11;
        Sat, 11 Sep 2021 08:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=80zaMgwEHBiIV99va+5MB74Ht6CzF2LBSAiRi7q/BcI=;
        b=SOMB62NfQJ64CLffBoq6awSIkCDzuuxdgycDnnkjXKXU7Y7GE+572zX/G9BX/SWHCY
         DVRV9w0Wd1y+R+nSAd7ydMkWmbnIpeTIXMZcRTq3azkFKDHD9rWL3/GxfE7oRvwrpy6w
         ouefFMqEawlrU19nEhbxfMmZPbqpbu9FF/qhi/c5lMT2ZFGl0cBzC9eHZza9KG8Iu5fo
         LwuAKQwYeVccGEMHG6nXX4/+7C6uIGkre9ASomXUzFU+OSJavv0q6fNniVOyo/AL1gTd
         Wo2ACrvq2ULu/rrClaALm3ic83JqejGlZJbh2Lzldk+bdPvOf66ALcRD/YOAGVnxUFV/
         ISVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=80zaMgwEHBiIV99va+5MB74Ht6CzF2LBSAiRi7q/BcI=;
        b=iu3A5FXKvbsX3rE+J2SqmKbVmRS1nmW5PX6d9U+GHgFxKkBKzTCKfkly9aT9+Krj3q
         srVoUcGDdAUPEc3SArFGPGLMX7HG17n+1DqV4J5PRzJ0sWw8RT/CPbR0Ex4owkrYDz4R
         8FcLVUtApYEqzAC/8lTfT/mz/74b5EFT05BKAlUd/PjkqgxwxR+WgSwDSV5jgg1SWMe3
         ir0+rOVkGpbEq0vYb8toab3JMECEILiv4RNkDVS+FG1F19mby9HBYrTwbvJViaKhslBp
         zWI18ZD3vU8C8T8jDgRBn8QtR00YSmovoJ0faY8U2oG0RvmmU+7YF6IzLYeThARZFvyu
         /goQ==
X-Gm-Message-State: AOAM5305vklyXMRXJabkmFzrztWKRg/K1ETQJdhMI0IDBYUbfmuuV5w9
        t12DTRMeRZlGIzDtzDLNY8M=
X-Google-Smtp-Source: ABdhPJyTkI1kZ+yZibB0Gi2sBlD/aNzJng5zeG+BK26z/nVZwba/xoBtleokrCAuuo6IFiW+EJ+HIQ==
X-Received: by 2002:ac8:4e0c:: with SMTP id c12mr2650346qtw.173.1631374315675;
        Sat, 11 Sep 2021 08:31:55 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:5d28:4399:29b0:1090? ([2600:1700:dfe0:49f0:5d28:4399:29b0:1090])
        by smtp.gmail.com with ESMTPSA id e22sm1216759qtm.10.2021.09.11.08.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 08:31:55 -0700 (PDT)
Message-ID: <5ec1a416-45e5-4679-9aa4-aa96b7f738b0@gmail.com>
Date:   Sat, 11 Sep 2021 08:31:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] net: dsa: qca8k: fix kernel panic with legacy mdio
 mapping
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210911150731.16586-1-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210911150731.16586-1-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/11/2021 08:07, Ansuel Smith wrote:
> When the mdio legacy mapping is used the mii_bus priv registred by DSA

typo: registered

> refer to the dsa switch struct instead of the qca8k_priv struct and
> cause a kernel panic.

typo: causes

> Create dedicated function when the internal
> dedicated mdio driver is used to proprely handle the 2 different
> implementation.

typo: properly

> 
> Fixes: 759bafb8a322 ("net: dsa: qca8k: add support for internal phy and internal mdio")
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>   drivers/net/dsa/qca8k.c | 30 ++++++++++++++++++++++--------
>   1 file changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 1f63f50f73f1..a701323daf72 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -643,10 +643,8 @@ qca8k_mdio_busy_wait(struct mii_bus *bus, u32 reg, u32 mask)
>   }
>   
>   static int
> -qca8k_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
> +qca8k_mdio_write(struct mii_bus *bus, int phy, int regnum, u16 data)
>   {
> -	struct qca8k_priv *priv = salve_bus->priv;
> -	struct mii_bus *bus = priv->bus;
>   	u16 r1, r2, page;
>   	u32 val;
>   	int ret;
> @@ -682,10 +680,8 @@ qca8k_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
>   }
>   
>   static int
> -qca8k_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
> +qca8k_mdio_read(struct mii_bus *bus, int phy, int regnum)
>   {
> -	struct qca8k_priv *priv = salve_bus->priv;
> -	struct mii_bus *bus = priv->bus;
>   	u16 r1, r2, page;
>   	u32 val;
>   	int ret;
> @@ -726,6 +722,24 @@ qca8k_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
>   	return ret;
>   }
>   
> +static int
> +qca8k_internal_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
> +{
> +	struct qca8k_priv *priv = salve_bus->priv;

You are only moving code here but while at it, mind fixing that typo?

> +	struct mii_bus *bus = priv->bus;
> +
> +	return qca8k_mdio_write(bus, phy, regnum, data);
> +}
> +
> +static int
> +qca8k_internal_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
> +{
> +	struct qca8k_priv *priv = salve_bus->priv;
> +	struct mii_bus *bus = priv->bus;
> +
> +	return qca8k_mdio_read(bus, phy, regnum);
> +}
> +
>   static int
>   qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
>   {
> @@ -775,8 +789,8 @@ qca8k_mdio_register(struct qca8k_priv *priv, struct device_node *mdio)
>   
>   	bus->priv = (void *)priv;
>   	bus->name = "qca8k slave mii";
> -	bus->read = qca8k_mdio_read;
> -	bus->write = qca8k_mdio_write;
> +	bus->read = qca8k_internal_mdio_read;
> +	bus->write = qca8k_internal_mdio_write;
>   	snprintf(bus->id, MII_BUS_ID_SIZE, "qca8k-%d",
>   		 ds->index);
>   
> 

-- 
Florian
