Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70913147384
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 23:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgAWWFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 17:05:12 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37160 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbgAWWFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 17:05:11 -0500
Received: by mail-wr1-f65.google.com with SMTP id w15so5019148wru.4;
        Thu, 23 Jan 2020 14:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j9l2lUNEgC3uCWE9qlaj3kgcT1oYJLaipyq8aFv9F14=;
        b=rE/IFdm7j39ezBy8ojPUVMvJVVNmQdON1spIWG2VzV1+eLS4doZbPYQD2n19fRQ6mB
         8WFVqxzrllTXmpXAumFMgt40EDOOEfEckfzy+mr7UDIMip6lSp1CIvf6Cok7ZO73seAe
         Ux8C2AUBLibXoSBc0ESsyrm60rYyeIVy6QO7h7cKZzI+W0BqPz2S4SaPstj2eEvVre5H
         argn8T74ikw9/UOjcKF4vrAvQch39V16CL4Wtm9xvUvXrg8p3hTbxGyb7vRzWaJHsOSR
         qU0m2ObgVhwRy77mzVfXQEZRk8ocR4foatk92OyhX0VzEcT4vGPaXwJFW65sYPJTyd1O
         z1Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=j9l2lUNEgC3uCWE9qlaj3kgcT1oYJLaipyq8aFv9F14=;
        b=hKSrMG3yusPBku2Ksla+d4sUus/RWi9Sag39lNjjEG8GJLTSvpNhYfQ42gWVk4GNL0
         Yvd+sSdia/kW3KAHn+no9iHMH0ipk/xlAR30oqjLClfu6AoM60Ezl7/cfiKqAT5WaPC8
         otJtVMZoVBELB8LZoc1t4yxwrTJRCVao10OeNFx+nnbyG3xedzFd/eZxSc8AqCZOEtKB
         ZBkV1RdbE+Czdis7Bn9wj0EzDjOqGZkBLUjrNjdNN0E/vzflb4S0xxTEVIR/KdJRwNJs
         AefhLOG+qh/+1Uuy8WPa/pdTz00nJeVeJC3kZD2NjKf850vwqTu/+1P+OJicR/E7pKd5
         EUpw==
X-Gm-Message-State: APjAAAVa98dDCzYgIDfd6mL5KQs13n+mu+wA7RH/06j6494KnnjrzLe4
        yor2Om8mZEdnNoQa5AQXaeSMGngo
X-Google-Smtp-Source: APXvYqwyECFRlyTuvh0a/a0sX4wpfpiw2FBvyVgEITEUcQH2qCBgcv2IfiK1j8cCNf89bKJOqCbGDA==
X-Received: by 2002:adf:fa87:: with SMTP id h7mr239315wrr.172.1579817108569;
        Thu, 23 Jan 2020 14:05:08 -0800 (PST)
Received: from [10.67.49.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n1sm4481499wrw.52.2020.01.23.14.05.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 14:05:07 -0800 (PST)
Subject: Re: [PATCH net] net: bcmgenet: Use netif_tx_napi_add() for TX NAPI
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20200123174934.29500-1-f.fainelli@gmail.com>
From:   Doug Berger <opendmb@gmail.com>
Autocrypt: addr=opendmb@gmail.com; prefer-encrypt=mutual; keydata=
 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
 rQQYjNSD8+NSdOsIpGNCZ9xhWw==
Message-ID: <abbd691d-592f-f58d-215b-0f40da485e76@gmail.com>
Date:   Thu, 23 Jan 2020 14:05:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200123174934.29500-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/20 9:49 AM, Florian Fainelli wrote:
> Before commit 7587935cfa11 ("net: bcmgenet: move NAPI initialization to
> ring initialization") moved the code, this used to be
> netif_tx_napi_add(), but we lost that small semantic change in the
> process, restore that.
> 
> Fixes: 7587935cfa11 ("net: bcmgenet: move NAPI initialization to ring initialization")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index 120fa05a39ff..0a8624be44a9 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -2164,8 +2164,8 @@ static void bcmgenet_init_tx_ring(struct bcmgenet_priv *priv,
>  				  DMA_END_ADDR);
>  
>  	/* Initialize Tx NAPI */
> -	netif_napi_add(priv->dev, &ring->napi, bcmgenet_tx_poll,
> -		       NAPI_POLL_WEIGHT);
> +	netif_tx_napi_add(priv->dev, &ring->napi, bcmgenet_tx_poll,
> +			  NAPI_POLL_WEIGHT);
>  }
>  
>  /* Initialize a RDMA ring */
> 

Acked-by: Doug Berger <opendmb@gmail.com>

Thanks Florian!
