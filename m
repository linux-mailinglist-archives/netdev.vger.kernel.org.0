Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBC93DE0A3
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhHBU21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhHBU20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 16:28:26 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36CBC06175F;
        Mon,  2 Aug 2021 13:28:15 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id s48so7416348ybi.7;
        Mon, 02 Aug 2021 13:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5OBdrYHCR2iz+DqSPSaNd9BA4JxRK6omLxbpsNsVOGQ=;
        b=cwsFRWRq8c3YWrIkGPxrp0CbLgM/2iwdRE4/q3TcBtIe1i/DdANGMROPuKKgiNpFuK
         UZDXXczVsYCm2PCvPI4yipeY8HM2uwFb3bsjdJQqVNJEukYEtOxWaFsIE0nYnJ4ABcYg
         pDT6gbaRD/PHXe7laGsf8tdgJd05soXNgkIEOY0F7yj2GRaYmruREB3pxzMB6Dw1GQ3J
         NbUOvxQzH/EtHyD8OpbW4D1lTzBlu+ajqCQlAFBgAgKJQ3+Hnwb8tfQ9bJzYXPsB3rCy
         jVk2AZYlxdao1cWjvpClgPPkQkJouaHxDSTRqJ9py3P/lGW0d74jeFH7mI1bE0w/aToY
         chVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5OBdrYHCR2iz+DqSPSaNd9BA4JxRK6omLxbpsNsVOGQ=;
        b=DMfRWmTZv7fr7EMWoUz7g3uWeCv0NbaK/WUXFkANJV0hzSYtAGdjCuTNUyMLg/O9Yf
         N86zLNSCipqUOFHpUpv5UAWDKi7nSiLT2jnXjd/OXzMCs3Jn32lm6kwadQTd5GYhtEfn
         bOMwEd3pxID/SCCxwk/R2OxmkZ37BZDxMN8h//FuScpBkLMHAX/rglPxaCKsVzHq9jPe
         WaHLFrSdAbnXELr4AHkHOI++p5LVIvYoufPfr73+LRgXtpgdIe6No1Z1wdaWIIG5d6u3
         2tc630EX4OhB6qTXna1AZEz6jny20AzCrmQ2qmyMeG1q9MSYlH8uVqkMnIU8nX7ib1dD
         FjqQ==
X-Gm-Message-State: AOAM530GZ0MvhEwA9AQ/FWKYXEy4JL9Wsu+mPqZxdk7ETsFtF0ZZgRPl
        o9xKjE8fJgfLmqa5xKP56zmSCvXSqQZUaumPosw=
X-Google-Smtp-Source: ABdhPJyv/KWy5Quy3JvOq/XJ1uaiM/9WxvM3x6FhZCP2LA4GSiXCZG2p2p7fVrgyamJ59XQeIRB9aoc0ZLsRIsolK+0=
X-Received: by 2002:a25:6148:: with SMTP id v69mr22494287ybb.510.1627936094999;
 Mon, 02 Aug 2021 13:28:14 -0700 (PDT)
MIME-Version: 1.0
References: <5afe26c6-7ab1-88ab-a3e0-eb007256a856@iogearbox.net>
 <20210728164741.350370-1-johan.almbladh@anyfinetworks.com>
 <1503e9c4-7150-3244-4710-7b6b2d59e0da@fb.com> <CAM1=_QTQeTp7LF-XdrOG_qjKpPJ-oQ24kKnG_7MDSbA7LX+uoA@mail.gmail.com>
 <CAEf4BzbYbSAqU91r8RzXWWR81mq9kwJ0=r8-1aRU1UaeDqxMeg@mail.gmail.com>
 <CAEf4BzZ1nNv12s-NJEayct5Yih_G6vNkEvFPst6dLcbhxWV_0g@mail.gmail.com> <CAM1=_QSKa7W9SL7oXWGEHLtWqCeFWp-jtGoqPp9=MxQwUGOjaQ@mail.gmail.com>
In-Reply-To: <CAM1=_QSKa7W9SL7oXWGEHLtWqCeFWp-jtGoqPp9=MxQwUGOjaQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Aug 2021 13:28:03 -0700
Message-ID: <CAEf4BzaheF_v0Z8ZCAT7mn31xscdgooF8bqRYgCYP01GE7GuaQ@mail.gmail.com>
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

On Sun, Aug 1, 2021 at 1:38 AM Johan Almbladh
<johan.almbladh@anyfinetworks.com> wrote:
>
> On Fri, Jul 30, 2021 at 12:48 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Jul 29, 2021 at 3:29 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Thu, Jul 29, 2021 at 2:38 PM Johan Almbladh
> > > <johan.almbladh@anyfinetworks.com> wrote:
> > > >
> > > > On Wed, Jul 28, 2021 at 9:13 PM Yonghong Song <yhs@fb.com> wrote:
> > > > > I also checked arm/arm64 jit. I saw the following comments:
> > > > >
> > > > >          /* if (tail_call_cnt > MAX_TAIL_CALL_CNT)
> > > > >           *      goto out;
> > > > >           * tail_call_cnt++;
> > > > >           */
> > > > >
> > > > > Maybe we have this MAX_TAIL_CALL_CNT + 1 issue
> > > > > for arm/arm64 jit?
> > > >
> > > > That wouldn't be unreasonable. I don't have an arm or arm64 setup
> > > > available right now, but I can try to test it in qemu.
> > >
> > > On a brief check, there seems to be quite a mess in terms of the code
> > > and comments.
> > >
> > > E.g., in arch/x86/net/bpf_jit_comp32.c:
> > >
> > >         /*
> > >          * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
> > >          *     goto out;
> > >          */
> > >
> > >                             ^^^^ here comment is wrong
> > >
> > >         [...]
> > >
> > >         /* cmp edx,hi */
> > >         EMIT3(0x83, add_1reg(0xF8, IA32_EBX), hi);
> > >         EMIT2(IA32_JNE, 3);
> > >         /* cmp ecx,lo */
> > >         EMIT3(0x83, add_1reg(0xF8, IA32_ECX), lo);
> > >
> > >         /* ja out */
> > >         EMIT2(IA32_JAE, jmp_label(jmp_label1, 2));
> > >
> > >         ^^^ JAE is >=, right? But the comment says JA.
> > >
> > >
> > > As for arch/x86/net/bpf_jit_comp.c, both comment and the code seem to
> > > do > MAX_TAIL_CALL_CNT, but you are saying JIT is correct. What am I
> > > missing?
> > >
> > > Can you please check all the places where MAX_TAIL_CALL_CNT is used
> > > throughout the code? Let's clean this up in one go.
> > >
> > > Also, given it's so easy to do this off-by-one error, can you please
> > > add a negative test validating that 33 tail calls are not allowed? I
> > > assume we have a positive test that allows exactly MAX_TAIL_CALL_CNT,
> > > but please double-check that as well.
> >
> > Ok, I see that you've added this in your bpf tests patch set. Please
> > consider, additionally, implementing a similar test as part of
> > selftests/bpf (specifically in test_progs). We run test_progs
> > continuously in CI for every incoming patch/patchset, so it has much
> > higher chances of capturing any regressions.
> >
> > I'm also thinking that this MAX_TAIL_CALL_CNT change should probably
> > go into the bpf-next tree. First, this off-by-one behavior was around
> > for a while and it doesn't cause serious issues, even if abused. But
> > on the other hand, it will make your tail call tests fail, when
> > applied into bpf-next without your change. So I think we should apply
> > both into bpf-next.
>
> I can confirm that the off-by-one behaviour is present on arm. Below
> is the test output running on qemu. Test #4 calls itself recursively
> and increments a counter each time, so the correct result should be 1
> + MAX_TAIL_CALL_CNT.
>
> test_bpf: #0 Tail call leaf jited:1 71 PASS
> test_bpf: #1 Tail call 2 jited:1 134 PASS
> test_bpf: #2 Tail call 3 jited:1 164 PASS
> test_bpf: #3 Tail call 4 jited:1 257 PASS
> test_bpf: #4 Tail call error path, max count reached jited:1 ret 34 != 33 FAIL
> test_bpf: #5 Tail call error path, NULL target jited:1 114 PASS
> test_bpf: #6 Tail call error path, index out of range jited:1 112 PASS
> test_bpf: test_tail_calls: Summary: 6 PASSED, 1 FAILED, [7/7 JIT'ed]
>
> The MAX_TAIL_CALL_CNT constant is referenced in the following JITs.
>
> arch/arm64/net/bpf_jit_comp.c
> arch/arm/net/bpf_jit_32.c
> arch/mips/net/ebpf_jit.c
> arch/powerpc/net/bpf_jit_comp32.c
> arch/powerpc/net/bpf_jit_comp64.c
> arch/riscv/net/bpf_jit_comp32.c
> arch/riscv/net/bpf_jit_comp64.c
> arch/s390/net/bpf_jit_comp.c
> arch/sparc/net/bpf_jit_comp_64.c
> arch/x86/net/bpf_jit_comp32.c
> arch/x86/net/bpf_jit_comp.c
>
> The x86 JITs all pass the test, even though the comments are wrong.
> The comments can easily be fixed of course. For JITs that have the
> off-by-one behaviour, an easy fix would be to change all occurrences
> of MAX_TAIL_CALL_CNT to MAX_TAIL_CALL_CNT - 1. We must first know
> which JITs affected though.

If you are going to fix ARM, please send a fix to comments for x86 as well.

>
> The fix is easy but setting up the test is hard. It took me quite some
> time to get the qemu/arm setup up and running. If the same has to be
> done for arm64, mips64, powerpc, powerpc64, riscv32, risc64, sparc and
> s390, I will need some help with this. If someone already has a
> working setup for any of the systems, the test can be performed on
> that.
>

Unfortunately, I myself have only x86-64 setup. libbpf
CI/kernel-patches CI we use to run all tests are running selftests
against x86-64 only as well. There was temporarily halted effort to
add s390x support as well, but it's not done yet. No one yet
volunteered to set up any other platforms and I don't know if that's
possible and how hard it would be to do within Github Actions platform
we are currently using.

So in short, I understand the challenges of testing all those
platforms and I don't really expect any single person to do all that
work. I've applied your fix, please follow up with ARM and comment
fixes.

> Or perhaps there is a better way to do this? If I implement a similar
> test in selftest/bpf, that would trigger the CI when the patch is
> submitted and we will see which JITs we need to fix.

The other nice benefit of implementing this in selftest/bpf, besides
continuous testing, is that you write it in C, which allows you to
express much more complicated logic more easily.

>
> > On a related topic, please don't forget to include the target kernel
> > tree for your patches: [PATCH bpf] or [PATCH bpf-next].
>
> I'll add that! All patches I sent related to this are for the bpf-next tree.
>
> Johan
