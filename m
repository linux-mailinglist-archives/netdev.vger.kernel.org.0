Return-Path: <netdev+bounces-9781-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F9AF72A8D5
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 05:37:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E14D2281AC5
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3727D5386;
	Sat, 10 Jun 2023 03:37:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244971847;
	Sat, 10 Jun 2023 03:37:50 +0000 (UTC)
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EADC4;
	Fri,  9 Jun 2023 20:37:49 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b1b66a8fd5so27040001fa.0;
        Fri, 09 Jun 2023 20:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686368267; x=1688960267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0x7R8VVA4vLkv9Rby6vo0luiqm3mpTBGzVgZHdxl4ws=;
        b=jlvs4fz58SeqT+S2VakKT4dKuwnxl4G/Bmyk9BsdAMEb8Ekk4SEvNQXVlHFlC7g6ra
         TUVD/DF5jkUDlylpqHfF+GRWJj6tdXuy2wZNKt9lVqRCz1JbSP8rREtZJun/4h31o6/g
         k2Z67F44Uu0rQSvgvrXklwNRl9ZO0qzsTWHwVfsBPD6/LMeVzDsitzlfk/cVeSqETLNT
         OboPKFTLNG2DHOKBs02tVKQmUOdG5/t24YSi/p3gGs9DfFuHN8nIRVaEKJPrf3wHjFyU
         4bMFecFui/bp5fWXlRZDbH+N/4HMRrSnlWWCQ4OrcTKG1GkTyIJpNju9sJAR+4jJq54f
         LhnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686368267; x=1688960267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0x7R8VVA4vLkv9Rby6vo0luiqm3mpTBGzVgZHdxl4ws=;
        b=YUILN8fGxsD/YtEfbUVWe2S/1VAU1NojjG7Etqv5qFS1vgm9Q+B248jt9RnuB7NRPC
         2pNDDM6dCRlskIPq2T4j8aft+FdrNCg++azUc3XsI/FL2zey0VawyP4YWxx5AJgiv/+P
         Z1z1tlKcPZVhRktvRwTsvFMbAgFKwl4jFOZbr4gNbWS0emHvNO91Rlk7TQNR4GE48Iih
         yMywllFnHoS7zSuocZ7OCJvaLyEb1W7cQCokRVPPxZinTK6cNw43RGbPLw5Bcq8TAIwI
         /QqelysUnDemOmL+MJNVmfOArhOUMJye4jh72YG8mxt3hswX4xn8/UFm7fHbejIDpbCl
         8zEQ==
X-Gm-Message-State: AC+VfDzuAm7rjkX7Ts3sCJeNgu4g8GEdTvMUw0iLcw5Syzwhr/f0LVZW
	Y1Brb6nognmTLgv1zH/HLrfTEo6ugdkAeJvB54LcdfrpS0s=
X-Google-Smtp-Source: ACHHUZ548OlaFV+egNkLGD/DOYl5NZK1pOjq0Rj+PWBbnT2P50S5bXoW8K/FdNjMB99qwoaeFKTxbuounul4TIX1nyc=
X-Received: by 2002:a2e:9ad1:0:b0:2a7:974d:a461 with SMTP id
 p17-20020a2e9ad1000000b002a7974da461mr254401ljj.34.1686368267204; Fri, 09 Jun
 2023 20:37:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAADnVQKLZ77pU7EAWPWzL=sCbJgUtZ3u-=Ma-Gf3T3kryYnh_w@mail.gmail.com>
 <20230610022721.2950602-1-prankgup@fb.com>
In-Reply-To: <20230610022721.2950602-1-prankgup@fb.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 9 Jun 2023 20:37:35 -0700
Message-ID: <CAADnVQJyQKbrZ+djWP-zgotYzzftv0TERFsi9VfuaDnmenyd3g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API
 for multi-progs
To: Prankur gupta <prankgup@fb.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Daniel Xu <dxu@dxuuu.xyz>, 
	Joe Stringer <joe@cilium.io>, John Fastabend <john.fastabend@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Network Development <netdev@vger.kernel.org>, Nikolay Aleksandrov <razor@blackwall.org>, 
	Stanislav Fomichev <sdf@google.com>, Timo Beckers <timo@incline.eu>, 
	=?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>, 
	prankur.07@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 8:03=E2=80=AFPM Prankur gupta <prankgup@fb.com> wrot=
e:
>
> >>
> >> Me, Daniel, Timo are arguing that there are real situations where you
> >> have to be first or need to die.
> >
> > afaik out of all xdp and tc progs there is not a single prog in the fb =
fleet
> > that has to be first.
> > fb's ddos and firewall don't have to be first.
> > cilium and datadog progs don't have to be first either.
> > The race between cilium and datadog was not the race to the first posit=
ion,
> > but the conflict due to the same prio.
> > In all cases, I'm aware, prog owners care a lot about ordering,
> > but never about strict first.
>
> One usecase which we actively use in Meta(fb) fleet is avoiding double wr=
iter for
> cgroup/sockops bpf programs. For ex: we can have multiple BPF programs se=
tting
> skops->reply field resulting in stepping on each other for ex: for ECN ca=
llback
> one program can set it 1 and other can set it to 0.
> We do that by creating a pre-func and post-func before
> executing sockops BPF program in our custom built chainer.
>
> We want these functions to be executed first and last respectively which =
actually
> makes the above functionality useful for us.
>
> Hypothetical usecase for cgroup/sockops - Middle BPF programs will not se=
t skops->reply
> and the final BPF program based on results from each of the middle
> BPF program can set the appropriate reply to skops->reply, thus making su=
re all the middle
> programs executed and the final reply is correct.

cgroup progs are more complicated than a simple list of progs in tc/xdp.
It is not really possible for the kernel to guarantee absolute last and fir=
st
in a hierarchy of cgroups. In theory that's possible within a cgroup,
but not when children and parents are involved and progs can be
attached anywhere in the hierarchy and we need to keep
uapi of BPF_F_ALLOW_OVERRIDE, BPF_F_ALLOW_MULTI intact.
The absolute first/last is not the answer for this skops issue.
A different solution is necessary.

