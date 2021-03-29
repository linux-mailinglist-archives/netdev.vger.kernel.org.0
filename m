Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63D434D8DE
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhC2UKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbhC2UKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 16:10:09 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408BFC061574;
        Mon, 29 Mar 2021 13:10:09 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id c17so12281653ilj.7;
        Mon, 29 Mar 2021 13:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=seG0rkzsqAfL2aB6DVsNkevIwPI+oKLa0SvPDUaYAK8=;
        b=mpmIlPqPLFB16ZjPDvUZF3/YOW/4+tPrFdgEIWB1P23ey4jeBgUvDLiFuV8g8E1YvP
         93R8kGclQPJRIzAW6uVmXWjo1SnNBP8uYd5pFv0u3f9iES2J1XAimi4JhFglDL0RIX+O
         pOB0g/KiHR0JVAO2NsdQpVe2wcryWDiD+x8ACpBerurSmphzvNb8ZkKSNXgA8WZiMpX+
         nw5ebjkQKvCd8HSGVja7a9oeQ9ct2BZoB9FFgds4kQn9EC8G9XWjzJF5LmtLlOxpVziC
         yZ/GVVzvI1gxFWEPSh1a+jR8GCnuCeI7W/KzkpSvJNj2WDKwCdhFOcGjDgSllaSp6yx4
         2rOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=seG0rkzsqAfL2aB6DVsNkevIwPI+oKLa0SvPDUaYAK8=;
        b=hgtvcMvIZjqsfEEZoHcTm5RTac2fWRfy3X8HBXIJNm/a3NZLF7830iTeeEYjjMdJ+8
         0WdV6Uk9yDxs/JhGfGHaTPrmtDr48DXkcJhP+A2PGwLUJ6fEdfRZJ5x9KIMuhlXmBKYQ
         FZ/u3gbvbbeT+lyegviK3HkDliRWWZI6zp6VVTcSubftb4SUf3Ul319rahNQRFVE6+9f
         U581oDq/vBUYQO5m7Mx4eBmjYWk8ZxU6uCY0uYNklheBkTytnBusDwyAFKGYwtbRy/N2
         CEEUuh6hvVj5Hl+myVC1D37gAw/Rb+PK+qijZ6SvNt//VgSAdB1n4bteEoCyx+swUYO8
         qO9Q==
X-Gm-Message-State: AOAM533yKz3k9M/NxjmOulb4auUwxtp0+yH6b2KiXyXDCIu4vEDv6Y30
        H1MMYuskhJsUSfgIRuZ6Aj8=
X-Google-Smtp-Source: ABdhPJwg4Znj8X8G4Lqw57A1Jy5YEdP/kWq5pil3OgEBuQYkkYR4OWXqyrANZX+yf1EFUKBaXORb7g==
X-Received: by 2002:a05:6e02:1a2f:: with SMTP id g15mr22426393ile.176.1617048608701;
        Mon, 29 Mar 2021 13:10:08 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id d7sm9991550ion.39.2021.03.29.13.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 13:10:08 -0700 (PDT)
Date:   Mon, 29 Mar 2021 13:09:59 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60623417fe3b_401fb20857@john-XPS-13-9370.notmuch>
In-Reply-To: <20210328202013.29223-8-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
 <20210328202013.29223-8-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v7 07/13] sock_map: introduce BPF_SK_SKB_VERDICT
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Reusing BPF_SK_SKB_STREAM_VERDICT is possible but its name is
> confusing and more importantly we still want to distinguish them
> from user-space. So we can just reuse the stream verdict code but
> introduce a new type of eBPF program, skb_verdict. Users are not
> allowed to set stream_verdict and skb_verdict at the same time.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

[...]

> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 656eceab73bc..a045812d7c78 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -697,7 +697,7 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
>  	rcu_assign_sk_user_data(sk, NULL);
>  	if (psock->progs.stream_parser)
>  		sk_psock_stop_strp(sk, psock);
> -	else if (psock->progs.stream_verdict)
> +	else if (psock->progs.stream_verdict || psock->progs.skb_verdict)
>  		sk_psock_stop_verdict(sk, psock);
>  	write_unlock_bh(&sk->sk_callback_lock);
>  
> @@ -1024,6 +1024,8 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
>  	}
>  	skb_set_owner_r(skb, sk);
>  	prog = READ_ONCE(psock->progs.stream_verdict);
> +	if (!prog)
> +		prog = READ_ONCE(psock->progs.skb_verdict);

Trying to think through this case. User attachs skb_verdict program
to map, then updates map with a bunch of TCP sockets. The above
code will run the skb_verdict program with the TCP socket as far as
I can tell.

This is OK because there really is no difference, other than by name,
between a skb_verdict and a stream_verdict program? Do we want something
to block adding TCP sockets to maps with stream_verdict programs? It
feels a bit odd in its current state to me.

>  	if (likely(prog)) {
>  		skb_dst_drop(skb);
>  		skb_bpf_redirect_clear(skb);
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index e564fdeaada1..c46709786a49 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -155,6 +155,8 @@ static void sock_map_del_link(struct sock *sk,
>  				strp_stop = true;
>  			if (psock->saved_data_ready && stab->progs.stream_verdict)
>  				verdict_stop = true;
> +			if (psock->saved_data_ready && stab->progs.skb_verdict)
> +				verdict_stop = true;
>  			list_del(&link->list);
>  			sk_psock_free_link(link);
>  		}
> @@ -227,7 +229,7 @@ static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
>  static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
>  			 struct sock *sk)
>  {
> -	struct bpf_prog *msg_parser, *stream_parser, *stream_verdict;
> +	struct bpf_prog *msg_parser, *stream_parser, *stream_verdict, *skb_verdict;
>  	struct sk_psock *psock;
>  	int ret;
>  
> @@ -256,6 +258,15 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
>  		}
>  	}
>  
> +	skb_verdict = READ_ONCE(progs->skb_verdict);
> +	if (skb_verdict) {
> +		skb_verdict = bpf_prog_inc_not_zero(skb_verdict);
> +		if (IS_ERR(skb_verdict)) {
> +			ret = PTR_ERR(skb_verdict);
> +			goto out_put_msg_parser;
> +		}
> +	}
> +
>  	psock = sock_map_psock_get_checked(sk);
>  	if (IS_ERR(psock)) {
>  		ret = PTR_ERR(psock);
> @@ -265,6 +276,7 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
>  	if (psock) {
>  		if ((msg_parser && READ_ONCE(psock->progs.msg_parser)) ||
>  		    (stream_parser  && READ_ONCE(psock->progs.stream_parser)) ||
> +		    (skb_verdict && READ_ONCE(psock->progs.skb_verdict)) ||
>  		    (stream_verdict && READ_ONCE(psock->progs.stream_verdict))) {
>  			sk_psock_put(sk, psock);
>  			ret = -EBUSY;

Do we need another test here,

   (skb_verdict && READ_ONCE(psock->progs.stream_verdict)

this way we return EBUSY and avoid having both stream_verdict and
skb_verdict attached on the same map?

From commit msg:
 "Users are not allowed to set stream_verdict and skb_verdict at
  the same time."

> @@ -296,6 +308,9 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
>  	} else if (!stream_parser && stream_verdict && !psock->saved_data_ready) {
>  		psock_set_prog(&psock->progs.stream_verdict, stream_verdict);
>  		sk_psock_start_verdict(sk,psock);
> +	} else if (!stream_verdict && skb_verdict && !psock->saved_data_ready) {
> +		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
> +		sk_psock_start_verdict(sk, psock);

Thanks,
John
