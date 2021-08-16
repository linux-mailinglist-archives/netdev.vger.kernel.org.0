Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB7D3ECF3B
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 09:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhHPHSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 03:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbhHPHSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 03:18:20 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6549C061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 00:17:49 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id r4so8098455ybp.4
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 00:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x/Um4v6+H1Vc3XRDP9shvIUiFu/lHKw2741uCC45oPQ=;
        b=nsD1b7lgFyQOvCYz92rNf3KVvo/H/cUFVX26tJMlVruFAi0XLZKPpNKgYsx5Dt4Fdp
         n5OhB5Gy5i0pFtvtSLgZ5ik9bDO1+f/jEQ0bBnsiMcN8wo/VkFVGgXUm3AZMlKjG/3YU
         bZanvNqjrvxAeicMxNIXKQhdhxXz+VNhhLjv9Av6KgkX0V2qJhSmF5/4OjYl6x2eP4eb
         PRvRthLtEwWIDeC9Ba7dE0LIr1z4adbckfBDi5LfhqfRexkDxg8nH8khGrUc7thm8aKE
         SWl2ZH9XSAvKycHXqc0r9NnXA7/qtowkY6+xzD4f9JZvz8BDXLi8CdFZ0hNA7UM1U0rM
         K1RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x/Um4v6+H1Vc3XRDP9shvIUiFu/lHKw2741uCC45oPQ=;
        b=oVwhRljAul5FqUOFUh0oN8D2G5a6LVuqX7IdJvJUOMrd22TeLjx8wgZ7baA9coHvJM
         TVyp3traj547HGNhXIaf4EdsV+y2n65rcIoU88cCm82s80BL9LzIhxA7iMR4fmFr0q4s
         453GEmXSPz1YNw1PgG/zEGCWzvn81Ci0Ls48AFFxlZCeO2XJpvA4RMg+FhFxemqAmln2
         6MHDWIiA6j1rxV0OzKsuT62H+FDPpVEoJPtGoYYQPxjnMD7mM+IQvUoUJK+7UNxyC91/
         xSaaa9Z4a1yCDpEpacgaWjuZQSBpAbebzrVG3E6YB72fisvXXneNfFIGH0SqFU8Nmrcl
         P3HQ==
X-Gm-Message-State: AOAM533gvCIG7eCFIamtHaQ0ldeCWcPcuDLcuBUsg1AotuQIunAJJYbO
        tI11z55Hg4j/P/EKExLhVmSctUYjwHsWiIE32Z9Yaw==
X-Google-Smtp-Source: ABdhPJzirGjYBB8YzqRlXB6XwsmXDEp+1CRFhcnCLW1p6gwIk+G8P+WY5vuJEu8ZzJxOQiagqN1kXilmhLKpYFrVQnw=
X-Received: by 2002:a25:918c:: with SMTP id w12mr18817285ybl.226.1629098269008;
 Mon, 16 Aug 2021 00:17:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210809093437.876558-1-johan.almbladh@anyfinetworks.com> <CAO5pjwTWrC0_dzTbTHFPSqDwA56aVH+4KFGVqdq8=ASs0MqZGQ@mail.gmail.com>
In-Reply-To: <CAO5pjwTWrC0_dzTbTHFPSqDwA56aVH+4KFGVqdq8=ASs0MqZGQ@mail.gmail.com>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Mon, 16 Aug 2021 09:17:55 +0200
Message-ID: <CAM1=_QSMPF6s==K8rwD2=uGUjze-=S=iQuaKmFz28zM1nXUcRA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/7] Fix MAX_TAIL_CALL_CNT handling in eBPF JITs
To:     Paul Chaignon <paul.chaignon@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, illusionist.neo@gmail.com,
        zlim.lnx@gmail.com, Paul Burton <paulburton@kernel.org>,
        naveen.n.rao@linux.ibm.com, sandipan@linux.ibm.com,
        Luke Nelson <luke.r.nels@gmail.com>, bjorn@kernel.org,
        Ilya Leoshkevich <iii@linux.ibm.com>, hca@linux.ibm.com,
        gor@linux.ibm.com, "David S. Miller" <davem@davemloft.net>,
        udknight@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 6:37 PM Paul Chaignon <paul.chaignon@gmail.com> wrote:
> On Mon, Aug 09, 2021 at 11:34:30AM +0200, Johan Almbladh wrote:
> > A new test of tail call count limiting revealed that the interpreter
> > did in fact allow up to MAX_TAIL_CALL_CNT + 1 tail calls, whereas the
> > x86 JITs stopped at the intended MAX_TAIL_CALL_CNT. The interpreter was
> > fixed in commit b61a28cf11d61f512172e673b8f8c4a6c789b425 ("bpf: Fix
> > off-by-one in tail call count limiting"). This patch set fixes all
> > arch-specific JITs except for RISC-V.
>
> I'm a bit surprised by this because I had previously tested the tail
> call limit of several JIT compilers and found it to be 33 (i.e.,
> allowing chains of up to 34 programs). I've just extended a test program
> I had to validate this again on the x86-64 JIT and found a limit of 33
> tail calls again [1].

Hmm, that was surprising. I have been working on a MIPS32 JIT, and as
a part of that I have been extending the in-kernel test suite in
lib/test_bpf.c. The additional tests include a suite for testing tail
calls and associated error paths. The tests were merged to bpf-next
[1].

The tail call limit test is a very simple BPF program that increments
R1, sets R0 to R1, and then calls itself again with a tail call. Since
the program is called with R1=0, the return value R0 will then be 1 +
number of tail calls executed. When I ran this on x86 I got the
following result.

Interpreter: 34
x86_64 JIT: 33
i386 JIT: 33

So, the interpreter and the x86 JITs had different behaviours. It was
then decided to change the interpreter to allow 32 tail calls to match
the behaviour of the x86 JITs [2]. As a follow up on that, I tested
the other JITs except RISC-V in the same way, and found that they too
allowed one more tail call than the now-updated [3] interpreter. This
patch set updates the behaviour of those JITs as well.

[1] https://lore.kernel.org/bpf/20210809091829.810076-1-johan.almbladh@anyfinetworks.com/
[2] https://lore.kernel.org/bpf/5afe26c6-7ab1-88ab-a3e0-eb007256a856@iogearbox.net/
[3] b61a28cf1 ("bpf: Fix off-by-one in tail call count limiting")

> Also note we had previously changed the RISC-V and MIPS JITs to allow up
> to 33 tail calls [2, 3], for consistency with other JITs and with the
> interpreter. We had decided to increase these two to 33 rather than
> decrease the other JITs to 32 for backward compatibility, though that
> probably doesn't matter much as I'd expect few people to actually use 33
> tail calls :-)

Right, the backwards compatibility aspect is a valid point. I don't
think anyone would be near that limit though, :-) but still.

Whether the limit is 32 or 33 really doesn't matter. My only concern
here is that the limit should be the same across all JIT
implementations and the interpreter. We could instead change the x86
JITs and revert the interpreter change to let the limit be 33, if that
would be a better solution.

> 1 - https://github.com/pchaigno/tail-call-bench/commit/ae7887482985b4b1745c9b2ef7ff9ae506c82886
> 2 - 96bc4432 ("bpf, riscv: Limit to 33 tail calls")
> 3 - e49e6f6d ("bpf, mips: Limit to 33 tail calls")
>
> >
> > For each of the affected JITs, the incorrect behaviour was verified
> > by running the test_bpf test suite in QEMU. After the fixes, the JITs
> > pass the tail call count limiting test.
>
> If you are referring to test_tailcall_3 and its associated BPF program
> tailcall3, then as far as I can tell, it checks that 33 tail calls are
> allowed. The counter is incremented before each tail call except the
> first one. The last tail call is rejected because we reach the limit, so
> a counter value of 33 (as checked in the test code) means we've
> successfully executed 33 tail calls.

My test setup can build for all architectures included in this patch
set and some more, and then boot the kernel in QEMU with a
statically-linked busybox as userspace. I can easily run the kernel's
BPF test suite on all those architectures, but since I don't have a
full-fledged userspace I have not been able to run the selftests in
the same way.

We need to be able to determine what the tail call limit actually is
for the different implementations. I don't understand why you get
different results when testing from userspace compared to testing the
JIT itself. Either one of the tests is faulty, or there is some other
mechanism at play here.

Johan

> >
> > I have not been able to test the RISC-V JITs due to the lack of a
> > working toolchain and QEMU setup. It is likely that the RISC-V JITs
> > have the off-by-one behaviour too. I have not verfied any of the NIC JITs.
> >
> > Link: https://lore.kernel.org/bpf/20210728164741.350370-1-johan.almbladh@anyfinetworks.com/
> >
> > Johan Almbladh (7):
> >   arm: bpf: Fix off-by-one in tail call count limiting
> >   arm64: bpf: Fix off-by-one in tail call count limiting
> >   powerpc: bpf: Fix off-by-one in tail call count limiting
> >   s390: bpf: Fix off-by-one in tail call count limiting
> >   sparc: bpf: Fix off-by-one in tail call count limiting
> >   mips: bpf: Fix off-by-one in tail call count limiting
> >   x86: bpf: Fix comments on tail call count limiting
> >
> >  arch/arm/net/bpf_jit_32.c         | 6 +++---
> >  arch/arm64/net/bpf_jit_comp.c     | 4 ++--
> >  arch/mips/net/ebpf_jit.c          | 4 ++--
> >  arch/powerpc/net/bpf_jit_comp32.c | 4 ++--
> >  arch/powerpc/net/bpf_jit_comp64.c | 4 ++--
> >  arch/s390/net/bpf_jit_comp.c      | 6 +++---
> >  arch/sparc/net/bpf_jit_comp_64.c  | 2 +-
> >  arch/x86/net/bpf_jit_comp32.c     | 6 +++---
> >  8 files changed, 18 insertions(+), 18 deletions(-)
> >
> > --
> > 2.25.1
> >
