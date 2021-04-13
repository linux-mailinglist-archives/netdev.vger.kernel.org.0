Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97ACF35E1C6
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344552AbhDMOo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344179AbhDMOoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 10:44:55 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21BDC061756
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:44:34 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id m13so17198361oiw.13
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=llYxHF9JWq5cIc9MQYpQy6ZUmRsZr/uSJsot9W2Sx9E=;
        b=Urpwv1SIdVvt7fFVLhSaiB1StEQWLOULP5k3Gj/O4rqyFg368GXR2Cl5qPeLfo3hLL
         oDHNrLEdaTNyS4KM0wc9n6GZ6GQHbK95bL2Z2m7XDUIunly0gn5SSHPJIuU334WwbfS0
         J1rHtY4xXaA3vYor5/ADBIiCWGrj61MU4U9s8cC5x0NNnjUCVRr3MU+BCtj1kfMbojAX
         JUOevJDcTDyS5Wbk/xwC/9b0zomiMdv0XSgeYilcWPllUu1hBN6uLV2CMXBay4PW6ut8
         xAa+7zjEkTbaqY1bMROtS9mSTWulP4kf6X89BAoWPHzlPtNxitHO/FBEvEru3e3+QkK/
         5m5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=llYxHF9JWq5cIc9MQYpQy6ZUmRsZr/uSJsot9W2Sx9E=;
        b=ddmA4tUioSs3hnX9QKMx0dUy6jJUQFdMon/XxtZiUUqkrcztHBSy/DZHCsAOlqW1ol
         gklQzl7OHxWbVT2UVIEHYuZAZeDyYbcy6RZv6/NMB3ZcE0PQ6/pmENxODYzJLF/td/gg
         pAl2S+D+FK5tPUyxTGYPI1Emt08XV4u6OMFmMGbMRXhKRacmoCcduruSh9W3cIG2ipGn
         rSciLu2e4422BTPMqnJErRJsCWaZHU1s7oVp9CICykj9BVGZNSRYBKvRjCjd/KaWwpOZ
         w7KjJcDcK4futEQPUiDx+lDz5AAZlKKFFJ0TngmDWwDPP2vjzvvTFk/Stv+/M1wWibGv
         /K1w==
X-Gm-Message-State: AOAM531g3EIRDMdvBDGfbkGl07p0xLwxr/gmikTibn47dHB9B+Kdu5RD
        jcT5ftI4IDja8VCnGbx34Fw=
X-Google-Smtp-Source: ABdhPJy5IxK5rkSlC3K+TyiyOjyJQQoXDkczdjRXH6rU4ba+rfDzKOWN4wx0/2CCmx7BLEsBvto3rw==
X-Received: by 2002:a05:6808:bcc:: with SMTP id o12mr257571oik.93.1618325073658;
        Tue, 13 Apr 2021 07:44:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h8sm1095826oib.55.2021.04.13.07.44.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 07:44:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH net] gro: ensure frag0 meets IP header alignment
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <20210413124136.2750358-1-eric.dumazet@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <d8ee9acd-250e-177b-777e-99bdf62e39c7@roeck-us.net>
Date:   Tue, 13 Apr 2021 07:44:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210413124136.2750358-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/21 5:41 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> After commit 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head")
> Guenter Roeck reported one failure in his tests using sh architecture.
> 
> After much debugging, we have been able to spot silent unaligned accesses
> in inet_gro_receive()
> 
> The issue at hand is that upper networking stacks assume their header
> is word-aligned. Low level drivers are supposed to reserve NET_IP_ALIGN
> bytes before the Ethernet header to make that happen.
> 
> This patch hardens skb_gro_reset_offset() to not allow frag0 fast-path
> if the fragment is not properly aligned.
> 
> Some arches like x86, arm64 and powerpc do not care and define NET_IP_ALIGN
> as 0, this extra check will be a NOP for them.
> 
> Note that if frag0 is not used, GRO will call pskb_may_pull()
> as many times as needed to pull network and transport headers.
> 
> Fixes: 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head")
> Fixes: 78a478d0efd9 ("gro: Inline skb_gro_header and cache frag0 virtual address")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>

Nice catch.

Tested-by: Guenter Roeck <linux@roeck-us.net>

.... and thanks a lot for tracking this down!

Guenter

> ---
>  net/core/dev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index af8c1ea040b9364b076e2d72f04dc3de2d7e2f11..1f79b9aa9a3f2392fddd1401f95ad098b5e03204 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5924,7 +5924,8 @@ static void skb_gro_reset_offset(struct sk_buff *skb)
>  	NAPI_GRO_CB(skb)->frag0_len = 0;
>  
>  	if (!skb_headlen(skb) && pinfo->nr_frags &&
> -	    !PageHighMem(skb_frag_page(frag0))) {
> +	    !PageHighMem(skb_frag_page(frag0)) &&
> +	    (!NET_IP_ALIGN || !(skb_frag_off(frag0) & 3))) {
>  		NAPI_GRO_CB(skb)->frag0 = skb_frag_address(frag0);
>  		NAPI_GRO_CB(skb)->frag0_len = min_t(unsigned int,
>  						    skb_frag_size(frag0),
> 

