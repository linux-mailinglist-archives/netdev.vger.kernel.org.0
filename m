Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5355F2385
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 16:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJBOOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 10:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiJBON5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 10:13:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5440E399D0
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 07:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664720035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YcR7yHa1Pvun+bHKSHQCfeZvo6YDL105suD9PvKGu9Y=;
        b=beeyBVwRFO+4HnVLvsXQa3yi9Y2deE9gS3xi4IMkZ4oVji4haKHR24JoQFDdoRS2UrWhmC
        MAkNeQVPNgjqKfCRAXVikwCBW0D0PMYVLzBm7BUbIbIFs4BAajk5VXO5AkPXnQatXhvADk
        p6M3S1OLvCf3KPFWP9DPL4UmuPkIod8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-225-nle09cPbN92pKpyOvC63Pw-1; Sun, 02 Oct 2022 10:13:54 -0400
X-MC-Unique: nle09cPbN92pKpyOvC63Pw-1
Received: by mail-wm1-f69.google.com with SMTP id b5-20020a05600c4e0500b003b499f99aceso7639024wmq.1
        for <netdev@vger.kernel.org>; Sun, 02 Oct 2022 07:13:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=YcR7yHa1Pvun+bHKSHQCfeZvo6YDL105suD9PvKGu9Y=;
        b=PKIpzJVFkk86tPbxpViTXCHyZ1Su8R9bOMKRpqc1mqnePfl9KajQnC5hzikxgvEh3V
         UCC/4WtUpXl23P0TMiGtqlArIC8LEfe65ern7p/lJxN56gdwPiv9C/W8HAYi0HhDrVfh
         WjrR8X/tQCBhDB8ZDSXXSybzJyGAtEksXAH3ChX4iuCI1TfSZwtBvLfnpOF8L+cGWJz7
         6Jbl76gvwBJIsMdgOjr9gVM3C8NJmk4VRQp4PpgNXijWop6nIVd/Q2RwiW0eIxCv16QA
         LgibMOJNhfuzbeilncjQsTjgYg4tp362csq8fIHmI4ZzlEns94xx5HOtX8yF51pq5kue
         9+FQ==
X-Gm-Message-State: ACrzQf1/roCkt9El8K+R8+a1Vyl82jriXoIyaSUPGyh+26GLZ4FwY13C
        HkPL3HaoTVvQe7OLIfJ5zrAUIOtsJiElPaiLmmKh0uxFRSeyENnWwfZ84natuIwrXFD0/TCHdgh
        RIMkjX60bShFMmm8L
X-Received: by 2002:a05:600c:35c5:b0:3b4:bf50:f84a with SMTP id r5-20020a05600c35c500b003b4bf50f84amr4165900wmq.22.1664720032951;
        Sun, 02 Oct 2022 07:13:52 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM63EJ3LfceUGga/qAGllS0W3voDS7KutGgUC9KgBRB0E5w/vjJVckkIjbnCP9rS78xBxP9mrw==
X-Received: by 2002:a05:600c:35c5:b0:3b4:bf50:f84a with SMTP id r5-20020a05600c35c500b003b4bf50f84amr4165885wmq.22.1664720032703;
        Sun, 02 Oct 2022 07:13:52 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-71.dyn.eolo.it. [146.241.97.71])
        by smtp.gmail.com with ESMTPSA id z15-20020a7bc7cf000000b003a5537bb2besm8640882wmk.25.2022.10.02.07.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Oct 2022 07:13:52 -0700 (PDT)
Message-ID: <57ac3460731bc73c849bfde39537123c446cc995.camel@redhat.com>
Subject: Re: [PATCH v2 net-next] gro: add support of (hw)gro packets to gro
 stack
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>
Date:   Sun, 02 Oct 2022 16:13:51 +0200
In-Reply-To: <20220930220905.2019461-1-eric.dumazet@gmail.com>
References: <20220930220905.2019461-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-09-30 at 15:09 -0700, Eric Dumazet wrote:
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
> This also means BIG TCP can still be used, even if HW-GRO/RSC was
> able to cook ~64 KB GRO packets.
> 
> v2: fix logic in tcp_gro_receive()
> 
>     Only support TCP for the moment (Paolo)
> 
> Co-Developed-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> ---
>  net/core/gro.c         | 18 ++++++++++++++----
>  net/ipv4/tcp_offload.c | 17 +++++++++++++++--
>  2 files changed, 29 insertions(+), 6 deletions(-)
> 
> diff --git a/net/core/gro.c b/net/core/gro.c
> index b4190eb084672fb4f2be8b437eccb4e8507ff63f..bc9451743307bc380cca96ae6995aa0a3b83d185 100644
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
> @@ -496,8 +498,15 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
>  		BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
>  					 sizeof(u32))); /* Avoid slow unaligned acc */
>  		*(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;
> -		NAPI_GRO_CB(skb)->flush = skb_is_gso(skb) || skb_has_frag_list(skb);
> +		NAPI_GRO_CB(skb)->flush = skb_has_frag_list(skb);
>  		NAPI_GRO_CB(skb)->is_atomic = 1;
> +		NAPI_GRO_CB(skb)->count = 1;
> +		if (unlikely(skb_is_gso(skb))) {
> +			NAPI_GRO_CB(skb)->count = skb_shinfo(skb)->gso_segs;
> +			/* Only support TCP at the moment. */
> +			if (!skb_is_gso_tcp(skb))
> +				NAPI_GRO_CB(skb)->flush = 1;
> +		}
>  
>  		/* Setup for GRO checksum validation */
>  		switch (skb->ip_summed) {
> @@ -545,10 +554,10 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
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
> @@ -660,6 +669,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
>  
>  	skb->encapsulation = 0;
>  	skb_shinfo(skb)->gso_type = 0;
> +	skb_shinfo(skb)->gso_size = 0;
>  	if (unlikely(skb->slow_gro)) {
>  		skb_orphan(skb);
>  		skb_ext_reset(skb);
> diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> index a844a0d38482d916251f3aca4555c75c9770820c..45dda788938704c3f762256266d9ea29b6ded4a5 100644
> --- a/net/ipv4/tcp_offload.c
> +++ b/net/ipv4/tcp_offload.c
> @@ -255,7 +255,15 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
>  
>  	mss = skb_shinfo(p)->gso_size;
>  
> -	flush |= (len - 1) >= mss;
> +	/* If skb is a GRO packet, make sure its gso_size matches prior packet mss.
> +	 * If it is a single frame, do not aggregate it if its length
> +	 * is bigger than our mss.
> +	 */
> +	if (unlikely(skb_is_gso(skb)))
> +		flush |= (mss != skb_shinfo(skb)->gso_size);
> +	else
> +		flush |= (len - 1) >= mss;
> +
>  	flush |= (ntohl(th2->seq) + skb_gro_len(p)) ^ ntohl(th->seq);
>  #ifdef CONFIG_TLS_DEVICE
>  	flush |= p->decrypted ^ skb->decrypted;
> @@ -269,7 +277,12 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
>  	tcp_flag_word(th2) |= flags & (TCP_FLAG_FIN | TCP_FLAG_PSH);
>  
>  out_check_final:
> -	flush = len < mss;
> +	/* Force a flush if last segment is smaller than mss. */
> +	if (unlikely(skb_is_gso(skb)))
> +		flush = len != NAPI_GRO_CB(skb)->count * skb_shinfo(skb)->gso_size;
> +	else
> +		flush = len < mss;
> +
>  	flush |= (__force int)(flags & (TCP_FLAG_URG | TCP_FLAG_PSH |
>  					TCP_FLAG_RST | TCP_FLAG_SYN |
>  					TCP_FLAG_FIN));

LGTM, thanks!

Acked-by: Paolo Abeni <pabeni@redhat.com>

