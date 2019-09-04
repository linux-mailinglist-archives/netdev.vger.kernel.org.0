Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0FFDA803A
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 12:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbfIDKT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 06:19:56 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38925 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfIDKT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 06:19:56 -0400
Received: by mail-wm1-f65.google.com with SMTP id q12so1202621wmj.4;
        Wed, 04 Sep 2019 03:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZrAqSL59OLCEzE52HTekg7fPZUlax89btgET9BLQ71E=;
        b=bhdQaPS9cc30tOzD7DKX0HLVLg2l7AEj2darYht6/SLmp33LqXyhFhPhR8+xHsWcTR
         CPj5YkAX5Cyji3fF4H6GeRjSTB6xkrVe5vTbpNCg3UABvKRTSIikZyP5isZvuB3xzXq/
         1Aae6iVhoyFsAwI2m/NDBY7lB0dBOx+Vmx8KGXnDik7Vn2ufcnfP0CTIkJ4KRBYoiRFb
         +1tILqUkBVG/h8X4052yrUzqJQgJTjgl0io9qBmA5EnF0u8a7dC1tJjTDnbXWfW9v4yg
         ZGdahtqyRZPEatNPH9a/5EV3MDFd7COUWvQHEwoKIOUtzAY+aheRnrr2eki/oOGdO39u
         oBjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZrAqSL59OLCEzE52HTekg7fPZUlax89btgET9BLQ71E=;
        b=o8lX9rK0vufTIcDpNzZp6cVvhkNnukXbEn2cDOxlR+VVhyCYxoDhw6CBZXLFsS1wv7
         LXe7vpui5OmerzIcdO3E5UFvAdVAacSyRtJZbsvDZz0p4iIABRsZA9GLV+uvzK6tT1/g
         6uwshOI5xoiTQyik4hPYIJIeyIlTZnjrumNrIbs2RKAihM/4FnLLODHZdnwZowqrHzEU
         Es62z/SAIiTU9IrLxDXPJ+TbIPwddSDI5TrGtm9DJYSo8V5UlcknzYeqbKpMaxYk+iUQ
         ZwEuD6Oyuo/DMQ+nHB7VVODgNRW/p4c4kgRE4eBg7g5fGIr5hgOt4v5ROjTELTWU8zw1
         Ge2g==
X-Gm-Message-State: APjAAAX4UQgdhk/TscCDI1FACv3o8n0uv88jwIsaa3OKNQsG6gTzT/YY
        5z57LUOe5SEA54dXI3+ERpVwClGn
X-Google-Smtp-Source: APXvYqyvOLR5/S4HFyOVauqNl0jLDWv/prMfE+ba8C4Uavp1L+tmEg3kYirYTz8DGh4eMD4JDgmecA==
X-Received: by 2002:a1c:a942:: with SMTP id s63mr3712661wme.152.1567592393778;
        Wed, 04 Sep 2019 03:19:53 -0700 (PDT)
Received: from [192.168.8.147] (206.165.185.81.rev.sfr.net. [81.185.165.206])
        by smtp.gmail.com with ESMTPSA id x5sm17823427wrg.69.2019.09.04.03.19.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2019 03:19:52 -0700 (PDT)
Subject: Re: [PATCH net] net: sonic: remove dev_kfree_skb before return
 NETDEV_TX_BUSY
To:     Mao Wenan <maowenan@huawei.com>, tsbogend@alpha.franken.de,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20190904094211.117454-1-maowenan@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c4a4d1b0-d036-7af7-2b30-117f9fdee9ad@gmail.com>
Date:   Wed, 4 Sep 2019 12:19:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904094211.117454-1-maowenan@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/4/19 11:42 AM, Mao Wenan wrote:
> When dma_map_single is failed to map buffer, skb can't be freed
> before sonic driver return to stack with NETDEV_TX_BUSY, because
> this skb may be requeued to qdisc, it might trigger use-after-free.
> 
> Fixes: d9fb9f384292 ("*sonic/natsemi/ns83829: Move the National Semi-conductor drivers")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  drivers/net/ethernet/natsemi/sonic.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
> index d0a01e8f000a..248a8f22a33b 100644
> --- a/drivers/net/ethernet/natsemi/sonic.c
> +++ b/drivers/net/ethernet/natsemi/sonic.c
> @@ -233,7 +233,6 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
>  	laddr = dma_map_single(lp->device, skb->data, length, DMA_TO_DEVICE);
>  	if (!laddr) {
>  		printk(KERN_ERR "%s: failed to map tx DMA buffer.\n", dev->name);
> -		dev_kfree_skb(skb);
>  		return NETDEV_TX_BUSY;
>  	}
>  
> 

That is the wrong way to fix this bug.

What guarantee do we have that the mapping operation will succeed next time we attempt
the transmit (and the dma_map_single() operation) ?

NETDEV_TX_BUSY is very dangerous, this might trigger an infinite loop.

I would rather leave the dev_kfree_skb(skb), and return NETDEV_TX_OK

Also the printk(KERN_ERR ...) should be replaced by pr_err_ratelimited(...)

NETDEV_TX_BUSY really should only be used by drivers that call netif_tx_stop_queue()
at the wrong moment.
