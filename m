Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9233A471823
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 05:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhLLEEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 23:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbhLLEEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 23:04:45 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AACAC061714;
        Sat, 11 Dec 2021 20:04:45 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so12238013pju.3;
        Sat, 11 Dec 2021 20:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=fwPc00DxbILRpITJ/8/4DHTLRDYQWyNby0uOPJMzK9U=;
        b=VTFAfQesyqrqEgD1td/tl2jclV5dZZFdLvNrgbOMTDe7xgjyrSrje08eWmIgh+axEl
         nHuxWxp07ue3bsYrkB+csDx/pVWnBBr6enwg1IRb+ZziqwQVCZHDfmc89bMEObZ6ZeAx
         IZ7xvhKcUbTNRL9g6ex9xmSzlQVEMrJGDqoaq+uzSpSnrGYa0F1mS6Yvw9QNJ+ZBmnbn
         Zk/r+yfVB1QZnYJZscpU+ArDFxGEsLd0Gi8dt+yxJwIyT8MXhuJDAy4G9T5zExo/I38e
         nR4nighL9utTfNRSKGLn5ZQdq0F8oN1Ym4WYOhAY0IZJQQcE4pq5WTfHx+at9YceDjaX
         23AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fwPc00DxbILRpITJ/8/4DHTLRDYQWyNby0uOPJMzK9U=;
        b=wHS6+28HwzOzjrmIdx56M3Yk24RRl9e2pSPLlErpjGmNzPvt1mM/JD8Nr7wxpbzhDv
         xVF4p4lvPrML/2ZWSvBsTmynuU/TVtPvLe6Hm5ckgyixo8hy4BZvwlZUyQINCRaJT3M4
         AQcslP/G8lLjMfuEx5Lt++v8kg652CDvoXN8Qx9cb2De+Q4Dv3UiiELGGSBnfRfgeZp+
         NnMbUZoDrwokewX0pot046erqzNd5GiBPvreaFjcjmlA/E5/87eh5Lyp7jGmCqV7disk
         bUKqob2mCGndTNU4OwX2kRpDnbL+fsy7mCYp1bZs0RbdlpOMMwIHAgjY6la3qZvVFDMl
         VPcQ==
X-Gm-Message-State: AOAM5307pjJxIa4CW3sTkXuquYCPkFC14z0Tw84vqSHOX060LuHsCV1E
        983LYPvpdJblYd0zka7fOqWVVb1EG5k=
X-Google-Smtp-Source: ABdhPJyANq7xaQDi1DlRPje/6ko1vrHJ1lencESli1WO4275n8oZvRScpbgZpmHh+/By1xQJJUQryw==
X-Received: by 2002:a17:90b:1185:: with SMTP id gk5mr34945410pjb.113.1639281884836;
        Sat, 11 Dec 2021 20:04:44 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:4964:df1f:902d:8530? ([2600:8802:b00:4a48:4964:df1f:902d:8530])
        by smtp.gmail.com with ESMTPSA id g17sm7885482pfv.136.2021.12.11.20.04.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 20:04:44 -0800 (PST)
Message-ID: <8ceaa6c1-9840-17b4-73f8-1a7f665e430f@gmail.com>
Date:   Sat, 11 Dec 2021 20:04:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [net-next RFC PATCH v4 15/15] net: dsa: qca8k: cache lo and hi
 for mdio write
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
 <20211211195758.28962-16-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211211195758.28962-16-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/2021 11:57 AM, Ansuel Smith wrote:
>  From Documentation, we can cache lo and hi the same way we do with the
> page. This massively reduce the mdio write as 3/4 of the time we only
> require to write the lo or hi part for a mdio write.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>   drivers/net/dsa/qca8k.c | 49 ++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 44 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 375a1d34e46f..b109a74031c6 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -94,6 +94,48 @@ qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
>   	*page = regaddr & 0x3ff;
>   }
>   
> +static u16 qca8k_current_lo = 0xffff;

Let's assume I have two qca8k switches in my system on the same or a 
different MDIO bus, is not the caching supposed to be a per-qca8k switch 
instance thing?

> +
> +static int
> +qca8k_set_lo(struct mii_bus *bus, int phy_id, u32 regnum, u16 lo)
> +{
> +	int ret;
> +
> +	if (lo == qca8k_current_lo) {
> +		// pr_info("SAME LOW");

Stray debugging left.

> +		return 0;
> +	}
> +
> +	ret = bus->write(bus, phy_id, regnum, lo);
> +	if (ret < 0)
> +		dev_err_ratelimited(&bus->dev,
> +				    "failed to write qca8k 32bit lo register\n");
> +
> +	qca8k_current_lo = lo;
> +	return 0;
> +}
> +
> +static u16 qca8k_current_hi = 0xffff;
> +
> +static int
> +qca8k_set_hi(struct mii_bus *bus, int phy_id, u32 regnum, u16 hi)
> +{
> +	int ret;
> +
> +	if (hi == qca8k_current_hi) {
> +		// pr_info("SAME HI");

Likewise
-- 
Florian
