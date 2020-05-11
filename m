Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CD51CE5EB
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731731AbgEKUou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729842AbgEKUou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:44:50 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C72DC061A0C;
        Mon, 11 May 2020 13:44:49 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u15so470331plm.2;
        Mon, 11 May 2020 13:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H23que+CXkKUGzeFhPrRWuoeoAo63avKzOHHRTX5SM0=;
        b=PMa6G8whDfYtKzqL6WMk9Ipphjk3NV6mndQAkrM/twVaCxZhjwGk70amhdJNjKwB+K
         qeyyahbsXY/LZU/DGa96yta1FssppUhfHifVnY59dQnZZu5wtTAIYnIdTjcbIPs1Bg1k
         vGPrTJa6ueXDYxGzOdwwHQdjXo/21kHalCx/SmcNN1pbQ3UfgrjmFBzXCoo5YTSeOrrc
         gHeZmfJZrVIQJidaogXE2Vz0ILxlAriaTAABI+zEiekMgi+4AjKQTDYQnpbAqC9N927G
         lbD0bA04c0IJdKHcjZL9NSy6m6G2DV8o60lwCeZ8R9a9V5cUn7La6omS17Wo7cIPnh/w
         r3JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H23que+CXkKUGzeFhPrRWuoeoAo63avKzOHHRTX5SM0=;
        b=Bbz3eRHRMfbDrjfMycwIpEkxOOR3CnQoF4EYXUtaLURc8A00CGbYhLMcNPP6uh+D6c
         Z6Cg+2Vq8Wdf6yvXfjdsjITYBAh3DTSt/0PlCwggpkuuZlWNgIATDW+24DoS9cTcBZEB
         lzwK/J0J0zaRvm+D730bXNaGVB5gduEccAiAuACoNMc5nO0KYhuJvTrZCGCFoMiIvU8g
         t8nVdHJFZbj77mcAoDuWL+CnPLginYrG3diI2eLOozK3oiVL/zEnd6At3EVY5GtfFFtL
         cfjGovIDiF7xtFsChUMFxqbhGZ93TiaW9dQIU7uygiwFSos3nqPUjuyi4/cXm/YDbqt8
         L42g==
X-Gm-Message-State: AOAM532NCvRmgk2PN3wEFVuQv02asIGL5OcUU4W9KTbY2P1EW5G+mOLW
        l1AcdlGodHdSkhv7rLC6bZg=
X-Google-Smtp-Source: ABdhPJxmy11PlRik4d8Ln2ph3C+Rh2d3KM6MaJ68hAfbh+wok73qzcGmp3vt9XuY9jEJ2t4AflsPKA==
X-Received: by 2002:a17:902:d693:: with SMTP id v19mr273489ply.66.1589229888547;
        Mon, 11 May 2020 13:44:48 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:9f0])
        by smtp.gmail.com with ESMTPSA id y29sm10265931pfq.162.2020.05.11.13.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 13:44:47 -0700 (PDT)
Date:   Mon, 11 May 2020 13:44:45 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, dccp@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v2 05/17] inet: Run SK_LOOKUP BPF program on
 socket lookup
Message-ID: <20200511204445.i7sessmtszox36xd@ast-mbp>
References: <20200511185218.1422406-1-jakub@cloudflare.com>
 <20200511185218.1422406-6-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511185218.1422406-6-jakub@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 08:52:06PM +0200, Jakub Sitnicki wrote:
> Run a BPF program before looking up a listening socket on the receive path.
> Program selects a listening socket to yield as result of socket lookup by
> calling bpf_sk_assign() helper and returning BPF_REDIRECT code.
> 
> Alternatively, program can also fail the lookup by returning with BPF_DROP,
> or let the lookup continue as usual with BPF_OK on return.
> 
> This lets the user match packets with listening sockets freely at the last
> possible point on the receive path, where we know that packets are destined
> for local delivery after undergoing policing, filtering, and routing.
> 
> With BPF code selecting the socket, directing packets destined to an IP
> range or to a port range to a single socket becomes possible.
> 
> Suggested-by: Marek Majkowski <marek@cloudflare.com>
> Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  include/net/inet_hashtables.h | 36 +++++++++++++++++++++++++++++++++++
>  net/ipv4/inet_hashtables.c    | 15 ++++++++++++++-
>  2 files changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> index 6072dfbd1078..3fcbc8f66f88 100644
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -422,4 +422,40 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>  
>  int inet_hash_connect(struct inet_timewait_death_row *death_row,
>  		      struct sock *sk);
> +
> +static inline struct sock *bpf_sk_lookup_run(struct net *net,
> +					     struct bpf_sk_lookup_kern *ctx)
> +{
> +	struct bpf_prog *prog;
> +	int ret = BPF_OK;
> +
> +	rcu_read_lock();
> +	prog = rcu_dereference(net->sk_lookup_prog);
> +	if (prog)
> +		ret = BPF_PROG_RUN(prog, ctx);
> +	rcu_read_unlock();
> +
> +	if (ret == BPF_DROP)
> +		return ERR_PTR(-ECONNREFUSED);
> +	if (ret == BPF_REDIRECT)
> +		return ctx->selected_sk;
> +	return NULL;
> +}
> +
> +static inline struct sock *inet_lookup_run_bpf(struct net *net, u8 protocol,
> +					       __be32 saddr, __be16 sport,
> +					       __be32 daddr, u16 dport)
> +{
> +	struct bpf_sk_lookup_kern ctx = {
> +		.family		= AF_INET,
> +		.protocol	= protocol,
> +		.v4.saddr	= saddr,
> +		.v4.daddr	= daddr,
> +		.sport		= sport,
> +		.dport		= dport,
> +	};
> +
> +	return bpf_sk_lookup_run(net, &ctx);
> +}
> +
>  #endif /* _INET_HASHTABLES_H */
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index ab64834837c8..f4d07285591a 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -307,9 +307,22 @@ struct sock *__inet_lookup_listener(struct net *net,
>  				    const int dif, const int sdif)
>  {
>  	struct inet_listen_hashbucket *ilb2;
> -	struct sock *result = NULL;
> +	struct sock *result, *reuse_sk;
>  	unsigned int hash2;
>  
> +	/* Lookup redirect from BPF */
> +	result = inet_lookup_run_bpf(net, hashinfo->protocol,
> +				     saddr, sport, daddr, hnum);
> +	if (IS_ERR(result))
> +		return NULL;
> +	if (result) {
> +		reuse_sk = lookup_reuseport(net, result, skb, doff,
> +					    saddr, sport, daddr, hnum);
> +		if (reuse_sk)
> +			result = reuse_sk;
> +		goto done;
> +	}
> +

The overhead is too high to do this all the time.
The feature has to be static_key-ed.

Also please add multi-prog support. Adding it later will cause
all sorts of compatibility issues. The semantics of multi-prog
needs to be thought through right now.
For example BPF_DROP or BPF_REDIRECT could terminate the prog_run_array
sequence of progs while BPF_OK could continue.
It's not ideal, but better than nothing.
Another option could be to execute all attached progs regardless
of return code, but don't let second prog override selected_sk blindly.
bpf_sk_assign() could get smarter.

Also please switch to bpf_link way of attaching. All system wide attachments
should be visible and easily debuggable via 'bpftool link show'.
Currently we're converting tc and xdp hooks to bpf_link. This new hook
should have it from the beginning.
