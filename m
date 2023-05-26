Return-Path: <netdev+bounces-5516-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E74BB711F6E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 07:57:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1FF4281663
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 05:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE5573D87;
	Fri, 26 May 2023 05:57:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1F93C00
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:57:05 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C22512C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 22:57:03 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-96fab30d1e1so104770866b.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 22:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cilium-io.20221208.gappssmtp.com; s=20221208; t=1685080622; x=1687672622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nNIdMuQIYgzE1Jz9FBURvIpeHNJmM5cDxyczWDYYf7Q=;
        b=tfo3U1+PkxoGweL4ZVJvAX4pztA/4fMHVCXP4T7gwGVmdMx3e9QA6bg3+1uuSohmBv
         eOKaPEpE7ihgbgwn9DaFfCNeMbv6LARHBIgRl90TFIFeTNPg+LT1M1vbIOrcjlKpeniZ
         8fGWgc6IHzDxM99ME43vuU9t9v0XVJJ/hlOzQHBv7bM5WONsQ9h3Q0N8n8myLu5niWTQ
         EQn0KAU5nmo4EXgOFU1vFZJYXKxOX4ZplzFyTLUX1LbhfgNzjOdFYbvL+5m0qN9SpJl1
         KDWXQaxJ6I4+LyTzV5fYqtl5AaXGvsCumdSuxYOlEFNVlaoh+dsghDoSJKz8yNx2NzoM
         kyjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685080622; x=1687672622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nNIdMuQIYgzE1Jz9FBURvIpeHNJmM5cDxyczWDYYf7Q=;
        b=BeYMruapdRExM2kJYi9ze+Xe++yN6D0v1+m6Liue9QNDZLV4JUhB+OQk4oCgm79BqH
         eZ6XPivMt+Etoiv+sddOst3w7D3yh5L4+LqvkmRC8d02kRhl8eTmwnQbl3q+ApVJgQoC
         sTsd7hGBoKf9AZrEU2WlvngcKrdDga0cpnwVFmjOYe8iVmwd9U360sKLdxkL1lmaw1qC
         IzI6EYl9RKvJYGZIyxG46DZSa79BtlseQ7HlcbAEe/RvkarVO3VkUvzDUzyaqGtqyUl5
         0KECTA/3HKn2frQuIbfIC1yufDVc4FxPqwAf+MxxHr0/T1vAHUhWwhUjoxU7KiIf6DdR
         /tTQ==
X-Gm-Message-State: AC+VfDzqd1A4hSVn0dSQa2j/pi5Fi3na6T1wWiraD0CwGRsA2riSqsvC
	BImOEo3Z2I89MJB9w1xP7peDGk1HgJvsMdG+DGEexfkB9XvinPC/oxY=
X-Google-Smtp-Source: ACHHUZ5KmfhUXbrYS8TLJ0Gwz1Ss2f/i1r80Eo/oCUCBQp14qSa37S4MlUVGl6XYtrSRMYn4IOo3z2v4OMaDW4UATMI=
X-Received: by 2002:a17:907:3d9f:b0:966:4669:7e8d with SMTP id
 he31-20020a1709073d9f00b0096646697e8dmr3540030ejc.16.1685080621828; Thu, 25
 May 2023 22:57:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230525081923.8596-1-lmb@isovalent.com>
In-Reply-To: <20230525081923.8596-1-lmb@isovalent.com>
From: Joe Stringer <joe@cilium.io>
Date: Thu, 25 May 2023 22:56:50 -0700
Message-ID: <CADa=RywoZZ9cAVPqa88mRNc2g1gQF743oEiSw2vnVHEFrN956g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf, net: Support SO_REUSEPORT sockets with bpf_sk_assign
To: Lorenz Bauer <lmb@isovalent.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, 
	John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
	Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	David Ahern <dsahern@kernel.org>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	Joe Stringer <joe@wand.net.nz>, Joe Stringer <joe@cilium.io>, Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 1:19=E2=80=AFAM Lorenz Bauer <lmb@isovalent.com> wr=
ote:
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

Nice approach to fix this issue, wish I'd thought of it :)

I pulled this and tested out in a little-vm-helper environment with
kind and Cilium's examples/kubernetes/connectivity-check proxy suite,
as well as cilium-cli's connectivity tests and the L7 features seem to
be working as expected with SO_REUSEPORT.

Tested-by: Joe Stringer <joe@cilium.io>

I also glanced through the commit, and the various protocols seem to
be handled consistently at the very least, though I agree it'd be
simpler for review and bisecting if broken down into more incremental
changes.

