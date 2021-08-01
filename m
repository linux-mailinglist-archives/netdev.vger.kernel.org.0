Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6393DCAC7
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 10:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhHAIiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 04:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbhHAIiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 04:38:14 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38733C06175F
        for <netdev@vger.kernel.org>; Sun,  1 Aug 2021 01:38:07 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id z18so8747631ybg.8
        for <netdev@vger.kernel.org>; Sun, 01 Aug 2021 01:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5QPw9P2mHV9SRfT9mFBRbmYkfKR2e0ffmj5E33flEDU=;
        b=fr5te08v4BiKoAZXFuSi6iHSmfbPoJvM0I4sZcgP8kAIXE2rwccSqE+mq+hUYXS9WX
         rn67NXwWrL33Qs9Qv7fKyleo6igmub3IvhpePIIMkIvekbEpyz2BYj5P5ETdofv83Pap
         y3iK0stfzhBrn8q8YdYINp4o7cxbH80R8XLVrNQ8TDxVa5wPUzaWdbf8dpRy0ZgGzQuv
         mzHf0WA53AqDGrZLuzumq3apLbRcbxkN8xYUrrEwtis4fUa1YFq1VPhruVF/pubIzTSb
         jDGaRwxKwnrbD7o0GSu1l2HmIgyl2o9KQzbZ61Mase5M5GPI4ZtpN4IDeyrbQjMUApCs
         H5BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5QPw9P2mHV9SRfT9mFBRbmYkfKR2e0ffmj5E33flEDU=;
        b=g51bcG6HG4vU52+fteroFtHqhOeoTTqO+IJ8IPrbnw0MHsfkRrNFUhWq10VnXl5art
         ew+gGx7krSLmueiEMqoc1Msp4Jndn1ODRCuWtFGnrt4xhK2TIm6cWbJwo8mSd7sUlHsa
         bAX3vj44O6Sa851mdFvo73r60E6C0xE5DGL92WWYLIgXcH6jlBHw3T+iYbKeawPe6zNV
         jYVsoT4fXYdG/u0v+p8CXeQ0iyaMxz9BTnxZjvj2ItkdEZ6Am5kE54fzgxeoEcYqNIjg
         SNnPtuNl5xsYCxZthK1f6N3odhvTtC13k2ThUMCfa4W+6PLEj4FUApIB/IMi73zJfdud
         kovQ==
X-Gm-Message-State: AOAM530fk9fsxOiwhjRsc5IVmaUu94YEhjILfPRUBw3YE5VXEOTzJro+
        m1lFhRKgSO5wmhm/VaDUz0XhfnaawWCM0QHX2SoPEw==
X-Google-Smtp-Source: ABdhPJy9082yDOS4ZoXkiJpr15XRYBklxa1rQNuoGQ8lFEVJ3U+oW0T16URjqvQrEntsthwYzphVjWrv7AETBeHpMjM=
X-Received: by 2002:a25:e910:: with SMTP id n16mr13455255ybd.226.1627807086456;
 Sun, 01 Aug 2021 01:38:06 -0700 (PDT)
MIME-Version: 1.0
References: <5afe26c6-7ab1-88ab-a3e0-eb007256a856@iogearbox.net>
 <20210728164741.350370-1-johan.almbladh@anyfinetworks.com>
 <1503e9c4-7150-3244-4710-7b6b2d59e0da@fb.com> <CAM1=_QTQeTp7LF-XdrOG_qjKpPJ-oQ24kKnG_7MDSbA7LX+uoA@mail.gmail.com>
 <CAEf4BzbYbSAqU91r8RzXWWR81mq9kwJ0=r8-1aRU1UaeDqxMeg@mail.gmail.com> <CAEf4BzZ1nNv12s-NJEayct5Yih_G6vNkEvFPst6dLcbhxWV_0g@mail.gmail.com>
In-Reply-To: <CAEf4BzZ1nNv12s-NJEayct5Yih_G6vNkEvFPst6dLcbhxWV_0g@mail.gmail.com>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Sun, 1 Aug 2021 10:37:55 +0200
Message-ID: <CAM1=_QSKa7W9SL7oXWGEHLtWqCeFWp-jtGoqPp9=MxQwUGOjaQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: Fix off-by-one in tail call count limiting
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Fri, Jul 30, 2021 at 12:48 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jul 29, 2021 at 3:29 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Jul 29, 2021 at 2:38 PM Johan Almbladh
> > <johan.almbladh@anyfinetworks.com> wrote:
> > >
> > > On Wed, Jul 28, 2021 at 9:13 PM Yonghong Song <yhs@fb.com> wrote:
> > > > I also checked arm/arm64 jit. I saw the following comments:
> > > >
> > > >          /* if (tail_call_cnt > MAX_TAIL_CALL_CNT)
> > > >           *      goto out;
> > > >           * tail_call_cnt++;
> > > >           */
> > > >
> > > > Maybe we have this MAX_TAIL_CALL_CNT + 1 issue
> > > > for arm/arm64 jit?
> > >
> > > That wouldn't be unreasonable. I don't have an arm or arm64 setup
> > > available right now, but I can try to test it in qemu.
> >
> > On a brief check, there seems to be quite a mess in terms of the code
> > and comments.
> >
> > E.g., in arch/x86/net/bpf_jit_comp32.c:
> >
> >         /*
> >          * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
> >          *     goto out;
> >          */
> >
> >                             ^^^^ here comment is wrong
> >
> >         [...]
> >
> >         /* cmp edx,hi */
> >         EMIT3(0x83, add_1reg(0xF8, IA32_EBX), hi);
> >         EMIT2(IA32_JNE, 3);
> >         /* cmp ecx,lo */
> >         EMIT3(0x83, add_1reg(0xF8, IA32_ECX), lo);
> >
> >         /* ja out */
> >         EMIT2(IA32_JAE, jmp_label(jmp_label1, 2));
> >
> >         ^^^ JAE is >=, right? But the comment says JA.
> >
> >
> > As for arch/x86/net/bpf_jit_comp.c, both comment and the code seem to
> > do > MAX_TAIL_CALL_CNT, but you are saying JIT is correct. What am I
> > missing?
> >
> > Can you please check all the places where MAX_TAIL_CALL_CNT is used
> > throughout the code? Let's clean this up in one go.
> >
> > Also, given it's so easy to do this off-by-one error, can you please
> > add a negative test validating that 33 tail calls are not allowed? I
> > assume we have a positive test that allows exactly MAX_TAIL_CALL_CNT,
> > but please double-check that as well.
>
> Ok, I see that you've added this in your bpf tests patch set. Please
> consider, additionally, implementing a similar test as part of
> selftests/bpf (specifically in test_progs). We run test_progs
> continuously in CI for every incoming patch/patchset, so it has much
> higher chances of capturing any regressions.
>
> I'm also thinking that this MAX_TAIL_CALL_CNT change should probably
> go into the bpf-next tree. First, this off-by-one behavior was around
> for a while and it doesn't cause serious issues, even if abused. But
> on the other hand, it will make your tail call tests fail, when
> applied into bpf-next without your change. So I think we should apply
> both into bpf-next.

I can confirm that the off-by-one behaviour is present on arm. Below
is the test output running on qemu. Test #4 calls itself recursively
and increments a counter each time, so the correct result should be 1
+ MAX_TAIL_CALL_CNT.

test_bpf: #0 Tail call leaf jited:1 71 PASS
test_bpf: #1 Tail call 2 jited:1 134 PASS
test_bpf: #2 Tail call 3 jited:1 164 PASS
test_bpf: #3 Tail call 4 jited:1 257 PASS
test_bpf: #4 Tail call error path, max count reached jited:1 ret 34 != 33 FAIL
test_bpf: #5 Tail call error path, NULL target jited:1 114 PASS
test_bpf: #6 Tail call error path, index out of range jited:1 112 PASS
test_bpf: test_tail_calls: Summary: 6 PASSED, 1 FAILED, [7/7 JIT'ed]

The MAX_TAIL_CALL_CNT constant is referenced in the following JITs.

arch/arm64/net/bpf_jit_comp.c
arch/arm/net/bpf_jit_32.c
arch/mips/net/ebpf_jit.c
arch/powerpc/net/bpf_jit_comp32.c
arch/powerpc/net/bpf_jit_comp64.c
arch/riscv/net/bpf_jit_comp32.c
arch/riscv/net/bpf_jit_comp64.c
arch/s390/net/bpf_jit_comp.c
arch/sparc/net/bpf_jit_comp_64.c
arch/x86/net/bpf_jit_comp32.c
arch/x86/net/bpf_jit_comp.c

The x86 JITs all pass the test, even though the comments are wrong.
The comments can easily be fixed of course. For JITs that have the
off-by-one behaviour, an easy fix would be to change all occurrences
of MAX_TAIL_CALL_CNT to MAX_TAIL_CALL_CNT - 1. We must first know
which JITs affected though.

The fix is easy but setting up the test is hard. It took me quite some
time to get the qemu/arm setup up and running. If the same has to be
done for arm64, mips64, powerpc, powerpc64, riscv32, risc64, sparc and
s390, I will need some help with this. If someone already has a
working setup for any of the systems, the test can be performed on
that.

Or perhaps there is a better way to do this? If I implement a similar
test in selftest/bpf, that would trigger the CI when the patch is
submitted and we will see which JITs we need to fix.

> On a related topic, please don't forget to include the target kernel
> tree for your patches: [PATCH bpf] or [PATCH bpf-next].

I'll add that! All patches I sent related to this are for the bpf-next tree.

Johan
