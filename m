Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A203757C964
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 12:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbiGUKxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 06:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiGUKxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 06:53:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 02CB480536
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 03:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658400819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ARxTIvH7raxfDuwN2p7MJyR92MyK8AZRi5FaA3nLrIg=;
        b=D4CFMFjj5q0rDxdoaBi+hLi4dA4GdK5fZYy4NcMW+SUKn7lzkM6Eq0Cz02xiqRSrXBd6GR
        bajVh15sjcHqqtdWyMCUjTstUyK4sQBZnXT7nvtBSWRJBUhTAmLxAAnE4F3+t0tORmOUm8
        sdUQXTUBISMUHAe+NKAISVsgPhRtm7Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-8lyNt-r3NuCpGa-G1W35kQ-1; Thu, 21 Jul 2022 06:53:36 -0400
X-MC-Unique: 8lyNt-r3NuCpGa-G1W35kQ-1
Received: by mail-wm1-f72.google.com with SMTP id 189-20020a1c02c6000000b003a2d01897e4so837439wmc.9
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 03:53:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ARxTIvH7raxfDuwN2p7MJyR92MyK8AZRi5FaA3nLrIg=;
        b=6zMqXMZ06iTrEH+jEJGVV3MQL54RPxD5kPDBzO1JMYC/oxbl9/a7vRoqFYptqQkrTS
         3seSpcMPQXN2PvS5ZI75Bsu6kTha19wtsmTW5Xtmo2dJLn3YlsBtedUTdVAcSLw0QCuc
         BZ/4az+Ea+hWkGDPQSzkFX7+4lLI90cQQM4/decnK9KPVPjUEilVQsYamKmxfhyUUTUd
         1uhs8tvQpyRHzvnpEdUyVzm8ULNyOv3FaxdHhD4rQLojeU0XXcgJQ3MrHzQRH6wTyhgx
         3csFrCsA/Za3IUCgRupUuEIFo+t3LtOhikM2j3roVRGDX0TjmUMvQA14Vlom4oFI8crK
         eL2g==
X-Gm-Message-State: AJIora93FE8A5gMbKSU79+LyS8hGANPUuMNlvCyGXPBzmaBdSMED+Pe0
        ZoVpNLvMXs0N+rtq0K9adlXuJtxc8k22EIOWWwv4V41C/yGLkV50QeOTZolbZGyqwbol417ZypN
        CyH2FT4IiMsMr/1K6
X-Received: by 2002:a05:600c:4f08:b0:3a1:99ed:4f1f with SMTP id l8-20020a05600c4f0800b003a199ed4f1fmr7700231wmq.199.1658400814583;
        Thu, 21 Jul 2022 03:53:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u81oKihT2+Bv77arSnX0sUvT1p+qIjisU4b9MGZsIeTiWTKPPHZ6SkXquDzXL6PCxfWc2Vew==
X-Received: by 2002:a05:600c:4f08:b0:3a1:99ed:4f1f with SMTP id l8-20020a05600c4f0800b003a199ed4f1fmr7700216wmq.199.1658400814333;
        Thu, 21 Jul 2022 03:53:34 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id t7-20020a0560001a4700b0021e53a148d3sm1490517wry.62.2022.07.21.03.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 03:53:33 -0700 (PDT)
Message-ID: <084d3496bfb35de821d2ba42a22fd43ff6087921.camel@redhat.com>
Subject: Re: [PATCH net-next v2 5/7] tcp: allow tls to decrypt directly from
 the tcp rcv queue
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, borisp@nvidia.com,
        john.fastabend@gmail.com, maximmi@nvidia.com, tariqt@nvidia.com,
        vfedorenko@novek.ru, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Date:   Thu, 21 Jul 2022 12:53:32 +0200
In-Reply-To: <20220719231129.1870776-6-kuba@kernel.org>
References: <20220719231129.1870776-1-kuba@kernel.org>
         <20220719231129.1870776-6-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-19 at 16:11 -0700, Jakub Kicinski wrote:
> Expose TCP rx queue accessor and cleanup, so that TLS can
> decrypt directly from the TCP queue. The expectation
> is that the caller can access the skb returned from
> tcp_recv_skb() and up to inq bytes worth of data (some
> of which may be in ->next skbs) and then call
> tcp_read_done() when data has been consumed.
> The socket lock must be held continuously across
> those two operations.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: yoshfuji@linux-ipv6.org
> CC: dsahern@kernel.org
> ---
>  include/net/tcp.h |  2 ++
>  net/ipv4/tcp.c    | 44 +++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 8e48dc56837b..90340d66b731 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -673,6 +673,8 @@ void tcp_get_info(struct sock *, struct tcp_info *);
>  int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
>  		  sk_read_actor_t recv_actor);
>  int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor);
> +struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off);
> +void tcp_read_done(struct sock *sk, size_t len);
>  
>  void tcp_initialize_rcv_mss(struct sock *sk);
>  
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 96b6e9c22068..155251a6c5a6 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1625,7 +1625,7 @@ static void tcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
>  	__kfree_skb(skb);
>  }
>  
> -static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
> +struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
>  {
>  	struct sk_buff *skb;
>  	u32 offset;
> @@ -1648,6 +1648,7 @@ static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
>  	}
>  	return NULL;
>  }
> +EXPORT_SYMBOL(tcp_recv_skb);
>  
>  /*
>   * This routine provides an alternative to tcp_recvmsg() for routines
> @@ -1778,6 +1779,47 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
>  }
>  EXPORT_SYMBOL(tcp_read_skb);
>  
> +void tcp_read_done(struct sock *sk, size_t len)
> +{
> +	struct tcp_sock *tp = tcp_sk(sk);
> +	u32 seq = tp->copied_seq;
> +	struct sk_buff *skb;
> +	size_t left;
> +	u32 offset;
> +
> +	if (sk->sk_state == TCP_LISTEN)
> +		return;
> +
> +	left = len;
> +	while (left && (skb = tcp_recv_skb(sk, seq, &offset)) != NULL) {
> +		int used;
> +
> +		used = min_t(size_t, skb->len - offset, left);
> +		seq += used;
> +		left -= used;
> +
> +		if (skb->len > offset + used)
> +			break;
> +
> +		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
> +			tcp_eat_recv_skb(sk, skb);
> +			++seq;
> +			break;
> +		}
> +		tcp_eat_recv_skb(sk, skb);
> +	}
> +	WRITE_ONCE(tp->copied_seq, seq);
> +
> +	tcp_rcv_space_adjust(sk);
> +
> +	/* Clean up data we have read: This will do ACK frames. */
> +	if (left != len) {
> +		tcp_recv_skb(sk, seq, &offset);

I *think* tcp_recv_skb() is not needed here, the consumed skb has been
removed in the above loop. AFAICS tcp_read_sock() needs it because the
recv_actor can release and re-acquire the socket lock just after the
previous tcp_recv_skb() call. 

I guess that retpoline overhead is a concern, to avoid calling
tcp_read_sock() with a dummy recv_actor?

Paolo



