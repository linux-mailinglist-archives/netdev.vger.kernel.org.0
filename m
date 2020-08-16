Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A1B2458EF
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 20:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgHPSHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 14:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgHPSHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 14:07:05 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D9EC061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 11:07:05 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u20so7073801pfn.0
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 11:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ej3VZeyvhwOmNJYgLPNyMNYic/dGPYAN/hHPqLY5+ko=;
        b=Eia6f21Ikb453wQv2ngFsm/ISKSyFlRIcBOfMphWHoem2KhnJvKHeR4Z8BZyxLIap+
         yr5zBb6IDvoJDN1b3J33yethxiFvEQ8u4vkP35956rNFICPc2+lxVGGyitpNZrC2ZRgH
         3bbA1p1/DiGKkqVA2tVu7yqm8UveNdknUatPLE19LT/L7XP7wUR3OPFxTh8wXc55riXp
         vW+/6bSKtxcYTpKgfh2vDcTZXIM3Pe7y/MDDjqND83SjwBwWy782scppsr5d49ObSGkb
         3vskx8xMH4AuxAI5jFW1RGd3TTvJ68Y7CR6PZ/JnVckQRJDoi4n4cwkHG7iP1Q9Zd5fU
         iCUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ej3VZeyvhwOmNJYgLPNyMNYic/dGPYAN/hHPqLY5+ko=;
        b=jOiZTkqVn7Q9jgFVuPrRwSCC4pES9OkdIXve9LGE6Q+A3AVNbI7mCdHBgqCpMgqg4E
         jgWlf3yRNMO2mXWTalmuc68HGWzd/fS1XJynvEkqBnS5DXUmHL9Gv/RNn+/jvQ8OQ2wN
         +Vg8hnUdnFTGqs/YlCczffqvel4lN1l2SZ/Dqn18XeDz1+PWWWrzm+447Q1Reno0aOs4
         IwUmqJYlsaVDnHjBjSwnEu29iZgpK4xnAbSoeeDzafqDTviBltom1c0Tg4yT8KjdNwfK
         FInE1NqmhKK0n1sbmrmelv+Ys9bO3Q2i+AyzKD9z2fEfpKWTRSUmOQCCrbIeeglPfadC
         rolA==
X-Gm-Message-State: AOAM532fUE9sdQahfXKreA/aiRhp1THhQe1mYslg+JRG5DwG3a/reiHJ
        D6Zgp/T4VgXi4tAan3llevo=
X-Google-Smtp-Source: ABdhPJyG1kQQyOYtgkuw1BdJ9BEes48Ua7DFbDbGdeTQrGAvORMQCmIxnWiNnS6qloI/kazeEA0EoQ==
X-Received: by 2002:a63:e057:: with SMTP id n23mr7428767pgj.368.1597601225066;
        Sun, 16 Aug 2020 11:07:05 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id h19sm14344455pjv.41.2020.08.16.11.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2020 11:07:04 -0700 (PDT)
Subject: Re: [PATCH 3/3] net: lantiq: Use napi_complete_done()
To:     Hauke Mehrtens <hauke@hauke-m.de>, davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com
References: <20200815183314.404-1-hauke@hauke-m.de>
 <20200815183314.404-3-hauke@hauke-m.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <17761534-65b1-e575-5e00-55e6f7e3f7b7@gmail.com>
Date:   Sun, 16 Aug 2020 11:07:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200815183314.404-3-hauke@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/20 11:33 AM, Hauke Mehrtens wrote:
> Use napi_complete_done() and activate the interrupts when this function
> returns true. This way the generic NAPI code can take care of activating
> the interrupts.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/ethernet/lantiq_xrx200.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
> index f34e4dc8c661..674ffb2ecd9a 100644
> --- a/drivers/net/ethernet/lantiq_xrx200.c
> +++ b/drivers/net/ethernet/lantiq_xrx200.c
> @@ -229,10 +229,8 @@ static int xrx200_poll_rx(struct napi_struct *napi, int budget)
>  		}
>  	}
>  
> -	if (rx < budget) {
> -		napi_complete(&ch->napi);
> +	if (napi_complete_done(&ch->napi, rx))
>  		ltq_dma_enable_irq(&ch->dma);
> -	}
>  
>  	return rx;
>  }
> @@ -271,10 +269,8 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
>  	if (netif_queue_stopped(net_dev))
>  		netif_wake_queue(net_dev);
>  
> -	if (pkts < budget) {
> -		napi_complete(&ch->napi);
> +	if (napi_complete_done(&ch->napi, pkts))
>  		ltq_dma_enable_irq(&ch->dma);
> -	}
>  
>  	return pkts;
>  }
> 


This looks buggy to me.

Please look again to other implementations for a correct usage.

