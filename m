Return-Path: <netdev+bounces-5332-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84743710D2C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:24:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B4DF281375
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2877910795;
	Thu, 25 May 2023 13:24:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11894FBE5
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 13:24:35 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7365E7
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 06:24:33 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f606e111d3so55125e9.1
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 06:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685021072; x=1687613072;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cJE2Y+9lHKdGfQARiSKxGndvrD8wTcpfzxVhMA8TopU=;
        b=YiF+QeExMQxuNZllkEbjao6wMWMhEVzx3YUS3ZCR+T5Z2ViGeXLDrlgSwESrKLz4XQ
         aHC36izj9qACsxIgCo1nJDvqof44tKuHXIkY4kMj3RL7juxIvC7mFQrH6i1cUU7b8BrD
         Io4wq4+XN+bmjjD0soDHYJ9NIDAYY3aUCLSrnFNj4uMSnImFW/vOejV5JXLMM/pp7EJp
         sYWnIaQW3BDRzeONo50RoHpiggh6qlgQNYUcj5w+dS4gssm5oB7LTIUIZhfDspsPxQ5c
         arukdP3Z6mDo9glEQxRMdshI8016mULKUSggLbucCMYpclqFvItsXNBoomXocgU7GeYp
         Q3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685021072; x=1687613072;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cJE2Y+9lHKdGfQARiSKxGndvrD8wTcpfzxVhMA8TopU=;
        b=hGDRu14wFTQC16/w/70CbEkS+xtIZh133vuKDHgrGwkJ6HnouMf/bcTTDxhxDLqH3m
         CxeX7JkjcVEHFV3VKKeHQbeHdr3OA+kov8eF/7p1xVHXiyGMjrjtfNX+6rMmGeLXGWDF
         QCAFCQlZvtC7zsqfvVJauZCOxu8boE6WzsZ4AtF2RIK20xuZurQaVv9/c0+++ndZ1iUC
         Q2ghfjl9OQs4hW3tUR6InRMAOnGigXQlj4dyu9OUw4HAjdlyfaYW6Jgm1kD+7YOLbP2Z
         Uw3AxRAGYdsUEIw64cD2ilBIYS+27ZQNKL7vOtE+D3mZJ8VVGOR+KsnHSJ9TU7LlV3f0
         wZdw==
X-Gm-Message-State: AC+VfDxDKEG6uvzuFBXYf/DEj9G8Oljet2KbpcqKoxsweLI+WSnCxY9q
	Ud7fws5ALylCRVod3buclwNuWyo1cg2lERRVitERCA==
X-Google-Smtp-Source: ACHHUZ4Z0j2Nxi6xWsZl7nLei6HQfuzqIW/xvulwwCVcsoBQeSDRrx4VHDdQSD2O4FHODE6va2MYGq8ssJeMeT0CGbQ=
X-Received: by 2002:a05:600c:1c1b:b0:3f6:f4b:d4a6 with SMTP id
 j27-20020a05600c1c1b00b003f60f4bd4a6mr134629wms.7.1685021072117; Thu, 25 May
 2023 06:24:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230525081923.8596-1-lmb@isovalent.com>
In-Reply-To: <20230525081923.8596-1-lmb@isovalent.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 25 May 2023 15:24:20 +0200
Message-ID: <CANn89iJx74gR7Xuahd0S3pLXYC8EX6+JRkbt6T_bemMX-8zyig@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf, net: Support SO_REUSEPORT sockets with bpf_sk_assign
To: Lorenz Bauer <lmb@isovalent.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, 
	John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
	Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	David Ahern <dsahern@kernel.org>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	Joe Stringer <joe@wand.net.nz>, Joe Stringer <joe@cilium.io>, Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 10:19=E2=80=AFAM Lorenz Bauer <lmb@isovalent.com> w=
rote:
>
> Currently the bpf_sk_assign helper in tc BPF context refuses SO_REUSEPORT
> sockets. This means we can't use the helper to steer traffic to Envoy, wh=
ich
> configures SO_REUSEPORT on its sockets. In turn, we're blocked from remov=
ing
> TPROXY from our setup.
>
> The reason that bpf_sk_assign refuses such sockets is that the bpf_sk_loo=
kup
> helpers don't execute SK_REUSEPORT programs. Instead, one of the
> reuseport sockets is selected by hash. This could cause dispatch to the
> "wrong" socket:
>
>     sk =3D bpf_sk_lookup_tcp(...) // select SO_REUSEPORT by hash
>     bpf_sk_assign(skb, sk) // SK_REUSEPORT wasn't executed
>
> Fixing this isn't as simple as invoking SK_REUSEPORT from the lookup
> helpers unfortunately. In the tc context, L2 headers are at the start
> of the skb, while SK_REUSEPORT expects L3 headers instead.
>
> Instead, we execute the SK_REUSEPORT program when the assigned socket
> is pulled out of the skb, further up the stack. This creates some
> trickiness with regards to refcounting as bpf_sk_assign will put both
> refcounted and RCU freed sockets in skb->sk. reuseport sockets are RCU
> freed. We can infer that the sk_assigned socket is RCU freed if the
> reuseport lookup succeeds, but convincing yourself of this fact isn't
> straight forward. Therefore we defensively check refcounting on the
> sk_assign sock even though it's probably not required in practice.
>
> Fixes: 8e368dc ("bpf: Fix use of sk->sk_reuseport from sk_assign")
> Fixes: cf7fbe6 ("bpf: Add socket assign support")
> Co-developed-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Lorenz Bauer <lmb@isovalent.com>
> Cc: Joe Stringer <joe@cilium.io>
> Link: https://lore.kernel.org/bpf/CACAyw98+qycmpQzKupquhkxbvWK4OFyDuuLMBN=
ROnfWMZxUWeA@mail.gmail.com/
> ---
>  include/net/inet6_hashtables.h | 36 +++++++++++++++++++++++++++++-----
>  include/net/inet_hashtables.h  | 27 +++++++++++++++++++++++--
>  include/net/sock.h             |  7 +++++--
>  include/uapi/linux/bpf.h       |  3 ---
>  net/core/filter.c              |  2 --
>  net/ipv4/inet_hashtables.c     | 15 +++++++-------
>  net/ipv4/udp.c                 | 23 +++++++++++++++++++---
>  net/ipv6/inet6_hashtables.c    | 19 +++++++++---------
>  net/ipv6/udp.c                 | 23 +++++++++++++++++++---
>  tools/include/uapi/linux/bpf.h |  3 ---
>  10 files changed, 119 insertions(+), 39 deletions(-)


> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index e7391bf310a7..920131e4a65d 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -332,10 +332,10 @@ static inline int compute_score(struct sock *sk, st=
ruct net *net,
>         return score;
>  }
>
> -static inline struct sock *lookup_reuseport(struct net *net, struct sock=
 *sk,
> -                                           struct sk_buff *skb, int doff=
,
> -                                           __be32 saddr, __be16 sport,
> -                                           __be32 daddr, unsigned short =
hnum)
> +struct sock *inet_lookup_reuseport(struct net *net, struct sock *sk,
> +                                  struct sk_buff *skb, int doff,
> +                                  __be32 saddr, __be16 sport,
> +                                  __be32 daddr, unsigned short hnum)
>  {
>         struct sock *reuse_sk =3D NULL;
>         u32 phash;
> @@ -346,6 +346,7 @@ static inline struct sock *lookup_reuseport(struct ne=
t *net, struct sock *sk,
>         }
>         return reuse_sk;
>  }
> +EXPORT_SYMBOL_GPL(inet_lookup_reuseport);
>
>  /*
>   * Here are some nice properties to exploit here. The BSD API
> @@ -369,8 +370,8 @@ static struct sock *inet_lhash2_lookup(struct net *ne=
t,
>         sk_nulls_for_each_rcu(sk, node, &ilb2->nulls_head) {
>                 score =3D compute_score(sk, net, hnum, daddr, dif, sdif);
>                 if (score > hiscore) {
> -                       result =3D lookup_reuseport(net, sk, skb, doff,
> -                                                 saddr, sport, daddr, hn=
um);
> +                       result =3D inet_lookup_reuseport(net, sk, skb, do=
ff,
> +                                                      saddr, sport, dadd=
r, hnum);
>                         if (result)
>                                 return result;
>

Please split in a series.

First a patch renaming lookup_reuseport() to inet_lookup_reuseport()
and inet6_lookup_reuseport()
(cleanup, no change in behavior)

This would ease review and future bug hunting quite a bit.

