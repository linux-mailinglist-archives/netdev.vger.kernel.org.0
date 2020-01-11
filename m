Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF54138425
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 00:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731753AbgAKX7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 18:59:33 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38881 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731744AbgAKX7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 18:59:33 -0500
Received: by mail-io1-f67.google.com with SMTP id c16so1525745iom.5;
        Sat, 11 Jan 2020 15:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=XkRa2c5lpI0xCBJoXBExT0zgcXl8GNzholzO2EUeKDw=;
        b=LPMA0gqjzFdj2YsjspBdUkWs9haP1+QHvB0KWqwlYzIZxuKyeAwO+NLjfdD7B4A4l9
         OKQg9zNoEIkC/yE967ojzLg4UusN6jcFRNMYXJhFOTgjr1RamLjD7pwaYLjb8k0LEekx
         Xz9b0FJqU/rI4G7s2zfW2funo0jRMLx3sww98gIR35+opkqzuwZFRJKsa1kaVcJ+eutT
         xlgv/uDHx5i8z291Hudz+PR5HdAQx2rPBBlfAm2aacPt4zrTICHQSU/uHMDjHOyos9Ar
         NRAITjlLXJ7p52qNEVKxv8SzF9BCP8pkp243dT1ejoWJAb1wzd+7netCTcqDJqlxdw2N
         2+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=XkRa2c5lpI0xCBJoXBExT0zgcXl8GNzholzO2EUeKDw=;
        b=ioEtuYZw8uAYcN+WXmQomWRaukuDWzE6CDAIWdT4ommYA7EUjFGpQsaVNFOj7GUuhV
         gyVGIQ8F352xnN/UBOTrl2V1jebJRkV7h1uBGeFeL9nbV2nE+QJvgS7O9q0sSoRj/qh5
         eF13CQpB9HHhIBNXCtdbQaLE0T+0p0xi83uEAKjKB/xz8McNwM7barBItHWDmAP80TrR
         ei1FOoQ2qsO27qvVXTkPPSQix5VT+y3I8z4AG0qVTEbJaymd4V4Gv+FlosIitXf3Qwzn
         tceTOdl3+tr1Ru5SezB4cVrCFXrjdx2P6GkOFYnT8XH7BX6/ZEoSYNIprFujFMqrB6TS
         bWfA==
X-Gm-Message-State: APjAAAV7Iz3sTvH2EzWRgUpHwtKYg1K1yOwJAn2p9jO1jtaFn+KxrLxD
        tNTpMNkC/ZhBS8K31tQyeAM=
X-Google-Smtp-Source: APXvYqyWBN/fzYEWGOK/ntYcKuYNq/EGOj+zUri/H7BVtCJHWhEa1/plAqdiTUtjLAw1FEMofJjrmA==
X-Received: by 2002:a5e:cb4d:: with SMTP id h13mr7488684iok.92.1578787172007;
        Sat, 11 Jan 2020 15:59:32 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u8sm1610316iol.55.2020.01.11.15.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 15:59:31 -0800 (PST)
Date:   Sat, 11 Jan 2020 15:59:23 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5e1a615bedf9c_1e7f2b0c859c45c01f@john-XPS-13-9370.notmuch>
In-Reply-To: <20200110105027.257877-6-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-6-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v2 05/11] bpf, sockmap: Allow inserting listening
 TCP sockets into sockmap
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> In order for sockmap type to become a generic collection for storing TCP
> sockets we need to loosen the checks during map update, while tightening
> the checks in redirect helpers.
> 
> Currently sockmap requires the TCP socket to be in established state (or
> transitioning out of SYN_RECV into established state when done from BPF),
> which prevents inserting listening sockets.
> 
> Change the update pre-checks so that the socket can also be in listening
> state. If the state is not white-listed, return -EINVAL to be consistent
> with REUSEPORT_SOCKARRY map type.
> 
> Since it doesn't make sense to redirect with sockmap to listening sockets,
> add appropriate socket state checks to BPF redirect helpers too.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  net/core/sock_map.c                     | 46 ++++++++++++++++++++-----
>  tools/testing/selftests/bpf/test_maps.c |  6 +---
>  2 files changed, 39 insertions(+), 13 deletions(-)
> 
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index eb114ee419b6..99daea502508 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -396,6 +396,23 @@ static bool sock_map_sk_is_suitable(const struct sock *sk)
>  	       sk->sk_protocol == IPPROTO_TCP;
>  }
>  
> +/* Is sock in a state that allows inserting into the map?
> + * SYN_RECV is needed for updates on BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB.
> + */
> +static bool sock_map_update_okay(const struct sock *sk)
> +{
> +	return (1 << sk->sk_state) & (TCPF_ESTABLISHED |
> +				      TCPF_SYN_RECV |
> +				      TCPF_LISTEN);
> +}
> +
> +/* Is sock in a state that allows redirecting into it? */
> +static bool sock_map_redirect_okay(const struct sock *sk)
> +{
> +	return (1 << sk->sk_state) & (TCPF_ESTABLISHED |
> +				      TCPF_SYN_RECV);
> +}
> +
>  static int sock_map_update_elem(struct bpf_map *map, void *key,
>  				void *value, u64 flags)
>  {
> @@ -413,11 +430,14 @@ static int sock_map_update_elem(struct bpf_map *map, void *key,
>  		ret = -EINVAL;
>  		goto out;
>  	}
> -	if (!sock_map_sk_is_suitable(sk) ||
> -	    sk->sk_state != TCP_ESTABLISHED) {
> +	if (!sock_map_sk_is_suitable(sk)) {
>  		ret = -EOPNOTSUPP;
>  		goto out;
>  	}
> +	if (!sock_map_update_okay(sk)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}

I nit but seeing we need a v3 anyways. How about consolidating
this state checks into sock_map_sk_is_suitable() so we don't have
multiple if branches or this '|| TCP_ESTABLISHED' like we do now.

>  
>  	sock_map_sk_acquire(sk);
>  	ret = sock_map_update_common(map, idx, sk, flags);
> @@ -433,6 +453,7 @@ BPF_CALL_4(bpf_sock_map_update, struct bpf_sock_ops_kern *, sops,
>  	WARN_ON_ONCE(!rcu_read_lock_held());
>  
>  	if (likely(sock_map_sk_is_suitable(sops->sk) &&
> +		   sock_map_update_okay(sops->sk) &&
>  		   sock_map_op_okay(sops)))
>  		return sock_map_update_common(map, *(u32 *)key, sops->sk,
>  					      flags);
> @@ -454,13 +475,17 @@ BPF_CALL_4(bpf_sk_redirect_map, struct sk_buff *, skb,
>  	   struct bpf_map *, map, u32, key, u64, flags)
>  {
>  	struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
> +	struct sock *sk;
>  
>  	if (unlikely(flags & ~(BPF_F_INGRESS)))
>  		return SK_DROP;
> -	tcb->bpf.flags = flags;
> -	tcb->bpf.sk_redir = __sock_map_lookup_elem(map, key);
> -	if (!tcb->bpf.sk_redir)
> +
> +	sk = __sock_map_lookup_elem(map, key);
> +	if (!sk || !sock_map_redirect_okay(sk))
>  		return SK_DROP;

unlikely(!sock_map_redirect_okay)? Or perhaps unlikely the entire case,
if (unlikely(!sk || !sock_map_redirect_okay(sk)). I think users should
know if the sk is a valid sock or not and this is just catching the
error case. Any opinion?

Otherwise looks good.
