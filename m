Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33598450A4C
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 17:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhKOQ7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 11:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhKOQ7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 11:59:09 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31918C061570
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 08:56:12 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so343088pjb.1
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 08:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6CYW2tFTzVdRHssNmv7sHrogTIFxEBRrawEEJJ4nn60=;
        b=L+yrRi/L/pUQjxiYiTQQcqhrZKmevOMXIohm4/uUkx+NM8chfhxu5CPz7LDNZnv2Bo
         qmQ7LhDZihTa4kjSQzMJUAU3b7IQJFKSe8K4p6WEqQYGIvnZOnF0xf+g+Kimuq+kf1qW
         3DXEkfquHzqjQSrIkdqfd7m/0eJkeDr+BM3aQ/nX3SW3URoK13TB3xPB7Ekry3ncDEww
         GhRewRu8bPdNU+vWi6XDP9hdW2okwN6QOCnoMbpEv3t9pqEmByahyPSPx6rYVJMxDqAw
         xY57mbDElnmRaPf/kyV1eJ8joyOLiyjRm5kBIuAGvkLPQPfsXQSwVY1IWGG3eGXhu3Jg
         ltgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6CYW2tFTzVdRHssNmv7sHrogTIFxEBRrawEEJJ4nn60=;
        b=6Gf5jyZ4H0/nU+UMukTIKkx01sBiplPytof2gTMGOBcBFUs5EkmlYcU6fjF/b+rKae
         wH6VGg1uovopw34v6Tr6CJNeSZYxqbTw1K+nSri5HU+/w/sI2cT88yRsCxv96zF5EvYP
         73mhOOVIZ8qxmmelqUDSRz8cfbXgG6eF4b+mwtrW/wbrkSiL9c6ks37aYwCXhpratHWV
         yyy7W+WvcaXe1ZbhzDCARMHV4rRw61KABtGz32ZeGsF83Kdhpi6vnlbTEb4s/iDPsMQJ
         yuZzr0p0RY5EFbj2xr0OMbGdo9mxT876KkZZAyEHyHv5G/HBaLMweJy6ZO14yzc0Csyd
         oCXg==
X-Gm-Message-State: AOAM531x/5ewX3/UVKL+X1Jf6Efa4PAqQprEMiGjXreOKbi8jcIQoE3v
        tiLR8XAK5H5JDIErSVZRCIE=
X-Google-Smtp-Source: ABdhPJyKg/cQlSkHa+m4u3XySq9zfrVObIrQSbcr2qYE3V9F9yCPCV1AXjk0A76iOkw/X4FwSYDFdA==
X-Received: by 2002:a17:902:eec5:b0:143:982a:85c with SMTP id h5-20020a170902eec500b00143982a085cmr36915447plb.66.1636995371705;
        Mon, 15 Nov 2021 08:56:11 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id f16sm12697306pgi.28.2021.11.15.08.56.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 08:56:11 -0800 (PST)
Subject: Re: [RFC net-next] net: guard drivers against shared skbs
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, hawk@kernel.org,
        syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
References: <20211115163205.1116673-1-kuba@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <88391a1a-b8e4-96ca-7d80-df5c6674796d@gmail.com>
Date:   Mon, 15 Nov 2021 08:56:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211115163205.1116673-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/15/21 8:32 AM, Jakub Kicinski wrote:
> Commit d8873315065f ("net: add IFF_SKB_TX_SHARED flag to priv_flags")
> introduced IFF_SKB_TX_SHARED to protect drivers which are not ready
> for getting shared skbs from pktgen sending such frames.
> 
> Some drivers dutifully clear the flag but most don't, even though
> they modify the skb or call skb helpers which expect private skbs.
> 
> syzbot has also discovered more sources of shared skbs than just
> pktgen (e.g. llc).
> 
> I think defaulting to opt-in is doing more harm than good, those
> who care about fast pktgen should inspect their drivers and opt-in.
> It's far too risky to enable this flag in ether_setup().
> 
> Reported-by: syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/dummy.c | 1 +
>  net/core/dev.c      | 4 ++++
>  net/ethernet/eth.c  | 1 -
>  3 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
> index f82ad7419508..530eaaee2d25 100644
> --- a/drivers/net/dummy.c
> +++ b/drivers/net/dummy.c
> @@ -123,6 +123,7 @@ static void dummy_setup(struct net_device *dev)
>  	dev->flags |= IFF_NOARP;
>  	dev->flags &= ~IFF_MULTICAST;
>  	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
> +	dev->priv_flags |= IFF_TX_SKB_SHARING;
>  	dev->features	|= NETIF_F_SG | NETIF_F_FRAGLIST;
>  	dev->features	|= NETIF_F_GSO_SOFTWARE;
>  	dev->features	|= NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_LLTX;
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 15ac064b5562..476a826bb4f0 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3661,6 +3661,10 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
>  	if (unlikely(!skb))
>  		goto out_null;
>  
> +	if (unlikely(skb_shared(skb)) &&
> +	    !(dev->priv_flags & IFF_TX_SKB_SHARING))
> +		goto out_kfree_skb;


So this will break llc, right ?

I am sad we are adding so much tests in fast path.
