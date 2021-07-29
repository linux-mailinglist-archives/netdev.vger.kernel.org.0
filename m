Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B06C3DAF71
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 00:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhG2Ws6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 18:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhG2Ws5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 18:48:57 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDCCC061765;
        Thu, 29 Jul 2021 15:48:52 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id q15so12776955ybu.2;
        Thu, 29 Jul 2021 15:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=99Ji5/UBimbE6aiTdthNgCmMvKz/ftf4KJlcqh3mGnQ=;
        b=vQKSVHIVdSsZZJmsu0oKY7tfSzC42cjMNM6co8J/Sl45C/WU0KB5dOmkTzEmdqV6zg
         h8WPFhwg85+aTHD7nAG4eBPMeyFts1AyMAgbKLLYginIJ/wrNm+4vdgnJW5xQyJyrFQz
         Mndz0xkFsqrKjy/sG11GlAxwCBp0tB1vQP8QUU92J4MHdNR1unNQzyR2lRywgkpcq3Wc
         K1Hk02gg6HIJacE8LhN+c9JLHVug8ayYE5HzS5F1BqImoPrk2bAD77C6w2otD8kzWSaT
         ewHk0gekseuP2XtqlhGhRe4lEchrWu2fqBt5vpMtCe2dxztrW9R3ebPV78WVkwtRqfyV
         cdlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=99Ji5/UBimbE6aiTdthNgCmMvKz/ftf4KJlcqh3mGnQ=;
        b=p3teFNbPLcjEERgEu1xmFJ9YteBJL8F+xIEZiGUX67UHxBQDDdth4mpN96VIH2nJ6X
         zySTvxk+RnTvosYszqBSF5zdB3KVkkGoZxIerquOYnjZLgh08e9XYH8Hd+VlB9mIzrS9
         /uDLo2SWhqEqVQG3Q0URMh76aevMplj1JbT9m/50H1MOAyzWUXDrl+7V0sz13B4knP8j
         yOfUjjtqXICWmRYFB+E2fpAlAE30oTMq/htguNw9eni6M1EyAoBDKy91wkbaTRc1+nRp
         auF9QG54Y9hgpzREdRX9weuFNKz40ox9KVIqITSZKCFwODSYVPDJS+UX0ha9rtq71kOm
         5NyQ==
X-Gm-Message-State: AOAM531agOhGRCHx+A8SJhIGDtjMMfjjRL/IaCDf7O+FJ+UauhFJT51C
        +HQnMwzxKVqsfJzwcMFrVudB2D42F/XCo+MqnCc=
X-Google-Smtp-Source: ABdhPJwMPz/qcDPqH8BgFEgUHKGh9tnc5qyOOXCau4Cz6i/14IYfd44O8Rz4pHfXV19eqPwhK70Z4G8gYeiG0z+Z5PY=
X-Received: by 2002:a25:d691:: with SMTP id n139mr1462960ybg.27.1627598931955;
 Thu, 29 Jul 2021 15:48:51 -0700 (PDT)
MIME-Version: 1.0
References: <5afe26c6-7ab1-88ab-a3e0-eb007256a856@iogearbox.net>
 <20210728164741.350370-1-johan.almbladh@anyfinetworks.com>
 <1503e9c4-7150-3244-4710-7b6b2d59e0da@fb.com> <CAM1=_QTQeTp7LF-XdrOG_qjKpPJ-oQ24kKnG_7MDSbA7LX+uoA@mail.gmail.com>
 <CAEf4BzbYbSAqU91r8RzXWWR81mq9kwJ0=r8-1aRU1UaeDqxMeg@mail.gmail.com>
In-Reply-To: <CAEf4BzbYbSAqU91r8RzXWWR81mq9kwJ0=r8-1aRU1UaeDqxMeg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Jul 2021 15:48:40 -0700
Message-ID: <CAEf4BzZ1nNv12s-NJEayct5Yih_G6vNkEvFPst6dLcbhxWV_0g@mail.gmail.com>
Subject: Re: [PATCH] bpf: Fix off-by-one in tail call count limiting
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 3:29 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jul 29, 2021 at 2:38 PM Johan Almbladh
> <johan.almbladh@anyfinetworks.com> wrote:
> >
> > On Wed, Jul 28, 2021 at 9:13 PM Yonghong Song <yhs@fb.com> wrote:
> > > I also checked arm/arm64 jit. I saw the following comments:
> > >
> > >          /* if (tail_call_cnt > MAX_TAIL_CALL_CNT)
> > >           *      goto out;
> > >           * tail_call_cnt++;
> > >           */
> > >
> > > Maybe we have this MAX_TAIL_CALL_CNT + 1 issue
> > > for arm/arm64 jit?
> >
> > That wouldn't be unreasonable. I don't have an arm or arm64 setup
> > available right now, but I can try to test it in qemu.
>
> On a brief check, there seems to be quite a mess in terms of the code
> and comments.
>
> E.g., in arch/x86/net/bpf_jit_comp32.c:
>
>         /*
>          * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
>          *     goto out;
>          */
>
>                             ^^^^ here comment is wrong
>
>         [...]
>
>         /* cmp edx,hi */
>         EMIT3(0x83, add_1reg(0xF8, IA32_EBX), hi);
>         EMIT2(IA32_JNE, 3);
>         /* cmp ecx,lo */
>         EMIT3(0x83, add_1reg(0xF8, IA32_ECX), lo);
>
>         /* ja out */
>         EMIT2(IA32_JAE, jmp_label(jmp_label1, 2));
>
>         ^^^ JAE is >=, right? But the comment says JA.
>
>
> As for arch/x86/net/bpf_jit_comp.c, both comment and the code seem to
> do > MAX_TAIL_CALL_CNT, but you are saying JIT is correct. What am I
> missing?
>
> Can you please check all the places where MAX_TAIL_CALL_CNT is used
> throughout the code? Let's clean this up in one go.
>
> Also, given it's so easy to do this off-by-one error, can you please
> add a negative test validating that 33 tail calls are not allowed? I
> assume we have a positive test that allows exactly MAX_TAIL_CALL_CNT,
> but please double-check that as well.

Ok, I see that you've added this in your bpf tests patch set. Please
consider, additionally, implementing a similar test as part of
selftests/bpf (specifically in test_progs). We run test_progs
continuously in CI for every incoming patch/patchset, so it has much
higher chances of capturing any regressions.

I'm also thinking that this MAX_TAIL_CALL_CNT change should probably
go into the bpf-next tree. First, this off-by-one behavior was around
for a while and it doesn't cause serious issues, even if abused. But
on the other hand, it will make your tail call tests fail, when
applied into bpf-next without your change. So I think we should apply
both into bpf-next.

On a related topic, please don't forget to include the target kernel
tree for your patches: [PATCH bpf] or [PATCH bpf-next].


>
> I also wonder if it would make sense to convert these
> internal-but-sort-of-advertised constants like MAX_TAIL_CALL_CNT and
> BPF_COMPLEXITY_LIMIT_INSNS into enums so that they can be "discovered"
> from BTF. This should be discussed/attempted outside of this fix,
> though. Just bringing it up here.
