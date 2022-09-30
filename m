Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B145F06C6
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 10:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbiI3IpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 04:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiI3IpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 04:45:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4792CB6D50
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 01:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664527508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=POEMDpnSjKp+ZQIh0/juiKLLmUTnramG9iN46SPV3UI=;
        b=du0c0XRptHddSU6tXbQzIcXjBm/w6ZMBi57/L1BUi3cQEyV9ErVAbN223S5G/YKI2glatr
        Lgtsz2CIDPJ7tMtssaf+B9SzBfyRdELnyMJicY8RRV1RRCOSL3ScKtU2ilE4mTnmvIpVEr
        Ah+xICSoPLVPf5EFA1f1HmF01SYKyj0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-261-928VsJBnP-epZNkuBUvpdg-1; Fri, 30 Sep 2022 04:45:06 -0400
X-MC-Unique: 928VsJBnP-epZNkuBUvpdg-1
Received: by mail-wm1-f69.google.com with SMTP id e3-20020a05600c218300b003b4e4582006so1089879wme.6
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 01:45:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=POEMDpnSjKp+ZQIh0/juiKLLmUTnramG9iN46SPV3UI=;
        b=OTawQUmtiGag4cBUWs5sif6zxCgqLf6OJuRaZ/XQ/LFlmYEgt+qnnUG+xBNdTeiNSZ
         z8ZAWWWYr2GJbqH32cnuOgNFm6Q7N4sz3OnHEeULwoKkvxhnNC9TFMe28vGDvdcaG8e1
         eMdVJn2IhdXGMeIpADg/swKoFZuj9hSVRxap1PIzzkhAwm/MTmKGodYaSUhwJMhxlFA6
         7tthqTnwoLP9KFMbRMiZ+gSgYdCSisGFxpciVFWzPSMyXI0+ZXgq2Lt0Xo1OnGdh7msR
         PB01m+GF4i/KAUPwSdYGg80QeMmw9O3t9KRs0z2AXt2xL2A89tr27O7rzRpwkaExmoq2
         S7Lw==
X-Gm-Message-State: ACrzQf2RtNGfM49AKL/URlwVB9EFEv89wRFTvF7r1HHwk9sjbdNghV8B
        /ZBPo9v20e6yB6j3hdhJQe4kqpYMK5jPXst2Ec1OHC93bku3FGSm7Lt/vVeSFIr8uusy6ZUKK93
        riUPLmDfziY2p6jUw
X-Received: by 2002:a05:600c:1549:b0:3b4:8fd7:af4 with SMTP id f9-20020a05600c154900b003b48fd70af4mr4938102wmg.100.1664527505513;
        Fri, 30 Sep 2022 01:45:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5GmTtoCh2XpdBafVwqYKZc1d9OHJgQkOJBRJaN5y82hWn7d1v94lKlKaVG3yLCK/3PUAJ21g==
X-Received: by 2002:a05:600c:1549:b0:3b4:8fd7:af4 with SMTP id f9-20020a05600c154900b003b48fd70af4mr4938087wmg.100.1664527505161;
        Fri, 30 Sep 2022 01:45:05 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-100-179.dyn.eolo.it. [146.241.100.179])
        by smtp.gmail.com with ESMTPSA id j19-20020a05600c1c1300b003a5ca627333sm7285158wms.8.2022.09.30.01.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 01:45:04 -0700 (PDT)
Message-ID: <82d7338e085c156f044ec7bc55c7d78418439963.camel@redhat.com>
Subject: Re: [PATCH net-next] gro: add support of (hw)gro packets to gro
 stack
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>
Date:   Fri, 30 Sep 2022 10:45:03 +0200
In-Reply-To: <20220930014458.1219217-1-eric.dumazet@gmail.com>
References: <20220930014458.1219217-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-09-29 at 18:44 -0700, Eric Dumazet wrote:
> From: Coco Li <lixiaoyan@google.com>
> 
> Current GRO stack only supports incoming packets containing
> one frame/MSS.
> 
> This patch changes GRO to accept packets that are already GRO.
> 
> HW-GRO (aka RSC for some vendors) is very often limited in presence
> of interleaved packets. Linux SW GRO stack can complete the job
> and provide larger GRO packets, thus reducing rate of ACK packets
> and cpu overhead.
> 
> This also means BIG TCP can be used, even if HW-GRO/RSC was
> able to cook ~64 KB GRO packets.
> 
> Co-Developed-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> ---
>  net/core/gro.c         | 13 +++++++++----
>  net/ipv4/tcp_offload.c |  7 ++++++-
>  2 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/net/core/gro.c b/net/core/gro.c
> index b4190eb084672fb4f2be8b437eccb4e8507ff63f..d8e159c4bdf553508cd123bee4f5251908ede9fe 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -160,6 +160,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
>  	unsigned int gro_max_size;
>  	unsigned int new_truesize;
>  	struct sk_buff *lp;
> +	int segs;
>  
>  	/* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
>  	gro_max_size = READ_ONCE(p->dev->gro_max_size);
> @@ -175,6 +176,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
>  			return -E2BIG;
>  	}
>  
> +	segs = NAPI_GRO_CB(skb)->count;
>  	lp = NAPI_GRO_CB(p)->last;
>  	pinfo = skb_shinfo(lp);
>  
> @@ -265,7 +267,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
>  	lp = p;
>  
>  done:
> -	NAPI_GRO_CB(p)->count++;
> +	NAPI_GRO_CB(p)->count += segs;
>  	p->data_len += len;
>  	p->truesize += delta_truesize;
>  	p->len += len;
> @@ -496,8 +498,10 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
>  		BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
>  					 sizeof(u32))); /* Avoid slow unaligned acc */
>  		*(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;
> -		NAPI_GRO_CB(skb)->flush = skb_is_gso(skb) || skb_has_frag_list(skb);
> +		NAPI_GRO_CB(skb)->flush = skb_has_frag_list(skb);
>  		NAPI_GRO_CB(skb)->is_atomic = 1;
> +		NAPI_GRO_CB(skb)->count = max_t(u16, 1,
> +						skb_shinfo(skb)->gso_segs);
>  
>  		/* Setup for GRO checksum validation */
>  		switch (skb->ip_summed) {
> @@ -545,10 +549,10 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
>  	else
>  		gro_list->count++;
>  
> -	NAPI_GRO_CB(skb)->count = 1;
>  	NAPI_GRO_CB(skb)->age = jiffies;
>  	NAPI_GRO_CB(skb)->last = skb;
> -	skb_shinfo(skb)->gso_size = skb_gro_len(skb);
> +	if (!skb_is_gso(skb))
> +		skb_shinfo(skb)->gso_size = skb_gro_len(skb);
>  	list_add(&skb->list, &gro_list->list);
>  	ret = GRO_HELD;
>  
> @@ -660,6 +664,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
>  
>  	skb->encapsulation = 0;
>  	skb_shinfo(skb)->gso_type = 0;
> +	skb_shinfo(skb)->gso_size = 0;
>  	if (unlikely(skb->slow_gro)) {
>  		skb_orphan(skb);
>  		skb_ext_reset(skb);
> diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> index a844a0d38482d916251f3aca4555c75c9770820c..0223bbfe9568064b47bc6227d342a4d25c9edfa7 100644
> --- a/net/ipv4/tcp_offload.c
> +++ b/net/ipv4/tcp_offload.c
> @@ -255,7 +255,12 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
>  
>  	mss = skb_shinfo(p)->gso_size;
>  
> -	flush |= (len - 1) >= mss;
> +	if (skb_is_gso(skb)) {
> +		flush |= (mss != skb_shinfo(skb)->gso_size);
> +		flush |= ((skb_gro_len(p) % mss) != 0);

If I read correctly, the '(skb_gro_len(p) % mss) != 0' codition can be
true only if 'p' was an HW GRO packet (or at least a gso packet before
entering the GRO engine), am I correct? In that case 'p' staged into
the GRO hash up to the next packet (skb), just to be flushed.

Should the above condition be instead:

		flush |= ((skb_gro_len(skb) % mss) != 0);
?

And possibly use that condition while initializing
NAPI_GRO_CB(skb)->flush in dev_gro_receive() ?

> +	} else {
> +		flush |= (len - 1) >= mss;
> +	}
>  	flush |= (ntohl(th2->seq) + skb_gro_len(p)) ^ ntohl(th->seq);
>  #ifdef CONFIG_TLS_DEVICE
>  	flush |= p->decrypted ^ skb->decrypted;

I could not find a NIC doing HW GRO for UDP, so I guess we don't need
something similar in udp_offload, right?

Thanks!

Paolo

