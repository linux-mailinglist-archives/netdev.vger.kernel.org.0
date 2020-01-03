Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 419F512F8D2
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 14:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgACNgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 08:36:49 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52094 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbgACNgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 08:36:49 -0500
Received: by mail-wm1-f68.google.com with SMTP id d73so8417316wmd.1
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 05:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uDh6E/hSzOz1GXifNMIF1Z9q43Ut2Ls+y1mjcF6NzCE=;
        b=J9jcFu2v1BHhCGxjdtS++++HKAQWKpfhtZJ4xEgjM1iM5qGMLbwXb+2my3eHn6pUkz
         nndF2auEjoI03cqWYMb2Nyiw1LW0GyY7j+T6sWzZIbXfU22RACBY79BrIOKbDx23aYFi
         UCHjsYjmgQkM7RLqwdbHXfEtX4YoJnvWkU2Gyn+4T/xm5Xbu0GKPKm9GlPJ7SMoKXbR0
         7QJPAtQ2dks+y/qujyeWJRU0N0ZPaUmygxSed84kETVh+9DJ045K+hTKoPqAsjBzcsfd
         miGmMImdbk3rPvU8pUxvbGvTbba52k6hMLeXrd6jDJV2RTDF2DnrmNpabcmXu2Qu2/oo
         cyVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uDh6E/hSzOz1GXifNMIF1Z9q43Ut2Ls+y1mjcF6NzCE=;
        b=ij/9j5odyIVo3ItmrP5GaMPw9yFwLKk/HrOpCBMZQobF9HIc2P/TqZpDgPCF8SWvXP
         fcao0CLIWPQUhWBUIWc0FXJ1JEJKzFWYc6LH8jCMzbPooJxBXgqu44MH7GpNzjpEgsPp
         e3A7b7uhyfE87v/eJ5nTFGR05nSP6cdZb4eEIMUH5WjR/AaWPDJEpxL6l1wEf3GatkxZ
         9k/Eu7LYm6VjBt1OZqFek+i/WSSDgp3movKljlUi/URGgum80N0z9kOux2N1stYfnna5
         sE198TqPNPZlF6to8Saf9zwOa6PIokjOxl39j8OzZTY5W9ExMStr7jWobinextX6vW2b
         jfHw==
X-Gm-Message-State: APjAAAVdvvH5zjgJQ3RSFGgW3q3wQ9DCVXRp/mTYMikvmPQvR0O2Y1pj
        QZfyVFXnfAKFFmfcs+KVssA=
X-Google-Smtp-Source: APXvYqy2IwqEyJFB32JKTGqARoEuAttP3ghpSBeLn6WgueCYxbbf1aQ+9SBEknGhpdMfm4RnPVld4w==
X-Received: by 2002:a1c:6707:: with SMTP id b7mr20588529wmc.54.1578058607390;
        Fri, 03 Jan 2020 05:36:47 -0800 (PST)
Received: from [192.168.8.147] (165.171.185.81.rev.sfr.net. [81.185.171.165])
        by smtp.gmail.com with ESMTPSA id b17sm58366434wrp.49.2020.01.03.05.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2020 05:36:46 -0800 (PST)
Subject: Re: [PATCH] net: Google gve: Remove dma_wmb() before ringing doorbell
To:     Liran Alon <liran.alon@oracle.com>, csully@google.com,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     sagis@google.com, jonolson@google.com, yangchun@google.com,
        lrizzo@google.com, adisuresh@google.com,
        Si-Wei Liu <si-wei.liu@oracle.com>
References: <20200103130108.70593-1-liran.alon@oracle.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b9172cbc-de9d-5926-0021-7a276b9f304f@gmail.com>
Date:   Fri, 3 Jan 2020 05:36:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200103130108.70593-1-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/3/20 5:01 AM, Liran Alon wrote:
> Current code use dma_wmb() to ensure Tx descriptors are visible
> to device before writing to doorbell.
> 
> However, these dma_wmb() are wrong and unnecessary. Therefore,
> they should be removed.
> 
> iowrite32be() called from gve_tx_put_doorbell() internally executes
> dma_wmb()/wmb() on relevant architectures. E.g. On ARM, iowrite32be()
> calls __iowmb() which translates to wmb() and only then executes
> __raw_writel(). However on x86, iowrite32be() will call writel()
> which just writes to memory because writes to UC memory is guaranteed
> to be globally visible only after previous writes to WB memory are
> globally visible.

This part about x86 is confusing.

writel() has the needed barrier (compared to writel_relaxed() which has no such barrier)

The UC vs WB memory sounds irrelevant.

> 
> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  drivers/net/ethernet/google/gve/gve_tx.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
> index f4889431f9b7..d0244feb0301 100644
> --- a/drivers/net/ethernet/google/gve/gve_tx.c
> +++ b/drivers/net/ethernet/google/gve/gve_tx.c
> @@ -487,10 +487,6 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
>  		 * may have added descriptors without ringing the doorbell.
>  		 */
>  
> -		/* Ensure tx descs from a prior gve_tx are visible before
> -		 * ringing doorbell.
> -		 */
> -		dma_wmb();
>  		gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
>  		return NETDEV_TX_BUSY;
>  	}
> @@ -505,8 +501,6 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
>  	if (!netif_xmit_stopped(tx->netdev_txq) && netdev_xmit_more())
>  		return NETDEV_TX_OK;
>  
> -	/* Ensure tx descs are visible before ringing doorbell */
> -	dma_wmb();
>  	gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
>  	return NETDEV_TX_OK;
>  }
> 

This seems strange to care about TX but not RX ?

gve_rx_write_doorbell() also uses iowrite32be()

