Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AA93E1715
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 16:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhHEOia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 10:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237990AbhHEOiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 10:38:24 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21607C0613D5
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 07:38:10 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id z5so7599712ybj.2
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 07:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=htbFxBlm5H2CaW5ZKJe0G5rdFCyGtiDV96Wm9JtZA8k=;
        b=2EZfifMtisGFV7qsYQnFlMMHfpUx3fKzzRU9JYSYcHy0l+qMXtPswv26az7nbilEeX
         mQhrBhXVoSbBiz/x7+sNTHoyvaSJM+xFCQbI1YfsO0o7zbPNUckKs0ISU+SaP5gkNinA
         KMFRT/lF7sIZ66gnbZQCGdy4/X7T1i+77Co1wuux2qnuQRuu2qUR9vI69Zsc2gN+6wCb
         ZsexZAWZSIPnqcO4xohxlaoEl8kBX817GxgTQHOKkTcNG+W9wIqk+/I5+q1I9498dl9y
         sLhbFChFmddxpwdquwsVoJe2aE4TuI2XtvZx1cI/5/T2fpuSBuIUzNDKKD310MBrqo9v
         qrJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=htbFxBlm5H2CaW5ZKJe0G5rdFCyGtiDV96Wm9JtZA8k=;
        b=ReYHzn+dsTT5gXzIqV5r51wS7phgfItQHMaKcAjFebbR7bcjg77LQZjV4/thfoBWIs
         /XM9df03V3ESEcQ25Gw+ufvE8aJrRuAl4K7WmSVrxj0srVxNV/FvCndF/2SMG7DgTdYO
         phkCtyL4fLYQWWB3WCAhv0eq7BMg66BtT634vgDG7hzTY2B6DH2MGnAinoqSdFJIC3JF
         Zz8M/p3NjUf9Y9FSkDwKv8zPgGcUdZjeDkpllpKU+uM3C+k3HbXOXA8IgTO7rsAtHEhG
         /nWmzw6XgNAfiR6yw8aUc68/naG1xanOfSilp/00HHvLMbCaWLiRo5dUMCz6bekY8Csf
         dtaA==
X-Gm-Message-State: AOAM5304VixhXs8FdoiHsMO8uZyqDIsBSXFk2QgV9nE4CZ25srV0Q92b
        E8KYWRMq0mNroIaPlQkUpDBfG4NBg7p3IDNWlNkguQ==
X-Google-Smtp-Source: ABdhPJzm3a+VuTBgwvmMqeSCazcLfpmsgdB9hmKK5+EBt4EAOCp1nVZeQqqs4e+HzA2y3oLajurjF8WgUOj/R2ao8Mo=
X-Received: by 2002:a5b:587:: with SMTP id l7mr4889157ybp.208.1628174289346;
 Thu, 05 Aug 2021 07:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <5afe26c6-7ab1-88ab-a3e0-eb007256a856@iogearbox.net>
 <20210728164741.350370-1-johan.almbladh@anyfinetworks.com>
 <1503e9c4-7150-3244-4710-7b6b2d59e0da@fb.com> <CAM1=_QTQeTp7LF-XdrOG_qjKpPJ-oQ24kKnG_7MDSbA7LX+uoA@mail.gmail.com>
 <CAEf4BzbYbSAqU91r8RzXWWR81mq9kwJ0=r8-1aRU1UaeDqxMeg@mail.gmail.com>
 <CAEf4BzZ1nNv12s-NJEayct5Yih_G6vNkEvFPst6dLcbhxWV_0g@mail.gmail.com>
 <CAM1=_QSKa7W9SL7oXWGEHLtWqCeFWp-jtGoqPp9=MxQwUGOjaQ@mail.gmail.com> <CAEf4BzaheF_v0Z8ZCAT7mn31xscdgooF8bqRYgCYP01GE7GuaQ@mail.gmail.com>
In-Reply-To: <CAEf4BzaheF_v0Z8ZCAT7mn31xscdgooF8bqRYgCYP01GE7GuaQ@mail.gmail.com>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Thu, 5 Aug 2021 16:37:58 +0200
Message-ID: <CAM1=_QQy=9gE=aULn5owSssh1H2Vu__X98xON6KGgC91BLkqJQ@mail.gmail.com>
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

On Mon, Aug 2, 2021 at 10:28 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Aug 1, 2021 at 1:38 AM Johan Almbladh
> <johan.almbladh@anyfinetworks.com> wrote:
> >
> > On Fri, Jul 30, 2021 at 12:48 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Thu, Jul 29, 2021 at 3:29 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Thu, Jul 29, 2021 at 2:38 PM Johan Almbladh
> > > > <johan.almbladh@anyfinetworks.com> wrote:
> > > > >
> > > > > On Wed, Jul 28, 2021 at 9:13 PM Yonghong Song <yhs@fb.com> wrote:
> > > > > > I also checked arm/arm64 jit. I saw the following comments:
> > > > > >
> > > > > >          /* if (tail_call_cnt > MAX_TAIL_CALL_CNT)
> > > > > >           *      goto out;
> > > > > >           * tail_call_cnt++;
> > > > > >           */
> > > > > >
> > > > > > Maybe we have this MAX_TAIL_CALL_CNT + 1 issue
> > > > > > for arm/arm64 jit?
> > > > >
> > > > > That wouldn't be unreasonable. I don't have an arm or arm64 setup
> > > > > available right now, but I can try to test it in qemu.
> > > >
> > > > On a brief check, there seems to be quite a mess in terms of the code
> > > > and comments.
> > > >
> > > > E.g., in arch/x86/net/bpf_jit_comp32.c:
> > > >
> > > >         /*
> > > >          * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
> > > >          *     goto out;
> > > >          */
> > > >
> > > >                             ^^^^ here comment is wrong
> > > >
> > > >         [...]
> > > >
> > > >         /* cmp edx,hi */
> > > >         EMIT3(0x83, add_1reg(0xF8, IA32_EBX), hi);
> > > >         EMIT2(IA32_JNE, 3);
> > > >         /* cmp ecx,lo */
> > > >         EMIT3(0x83, add_1reg(0xF8, IA32_ECX), lo);
> > > >
> > > >         /* ja out */
> > > >         EMIT2(IA32_JAE, jmp_label(jmp_label1, 2));
> > > >
> > > >         ^^^ JAE is >=, right? But the comment says JA.
> > > >
> > > >
> > > > As for arch/x86/net/bpf_jit_comp.c, both comment and the code seem to
> > > > do > MAX_TAIL_CALL_CNT, but you are saying JIT is correct. What am I
> > > > missing?
> > > >
> > > > Can you please check all the places where MAX_TAIL_CALL_CNT is used
> > > > throughout the code? Let's clean this up in one go.
> > > >
> > > > Also, given it's so easy to do this off-by-one error, can you please
> > > > add a negative test validating that 33 tail calls are not allowed? I
> > > > assume we have a positive test that allows exactly MAX_TAIL_CALL_CNT,
> > > > but please double-check that as well.
> > >
> > > Ok, I see that you've added this in your bpf tests patch set. Please
> > > consider, additionally, implementing a similar test as part of
> > > selftests/bpf (specifically in test_progs). We run test_progs
> > > continuously in CI for every incoming patch/patchset, so it has much
> > > higher chances of capturing any regressions.
> > >
> > > I'm also thinking that this MAX_TAIL_CALL_CNT change should probably
> > > go into the bpf-next tree. First, this off-by-one behavior was around
> > > for a while and it doesn't cause serious issues, even if abused. But
> > > on the other hand, it will make your tail call tests fail, when
> > > applied into bpf-next without your change. So I think we should apply
> > > both into bpf-next.
> >
> > I can confirm that the off-by-one behaviour is present on arm. Below
> > is the test output running on qemu. Test #4 calls itself recursively
> > and increments a counter each time, so the correct result should be 1
> > + MAX_TAIL_CALL_CNT.
> >
> > test_bpf: #0 Tail call leaf jited:1 71 PASS
> > test_bpf: #1 Tail call 2 jited:1 134 PASS
> > test_bpf: #2 Tail call 3 jited:1 164 PASS
> > test_bpf: #3 Tail call 4 jited:1 257 PASS
> > test_bpf: #4 Tail call error path, max count reached jited:1 ret 34 != 33 FAIL
> > test_bpf: #5 Tail call error path, NULL target jited:1 114 PASS
> > test_bpf: #6 Tail call error path, index out of range jited:1 112 PASS
> > test_bpf: test_tail_calls: Summary: 6 PASSED, 1 FAILED, [7/7 JIT'ed]
> >
> > The MAX_TAIL_CALL_CNT constant is referenced in the following JITs.
> >
> > arch/arm64/net/bpf_jit_comp.c
> > arch/arm/net/bpf_jit_32.c
> > arch/mips/net/ebpf_jit.c
> > arch/powerpc/net/bpf_jit_comp32.c
> > arch/powerpc/net/bpf_jit_comp64.c
> > arch/riscv/net/bpf_jit_comp32.c
> > arch/riscv/net/bpf_jit_comp64.c
> > arch/s390/net/bpf_jit_comp.c
> > arch/sparc/net/bpf_jit_comp_64.c
> > arch/x86/net/bpf_jit_comp32.c
> > arch/x86/net/bpf_jit_comp.c
> >
> > The x86 JITs all pass the test, even though the comments are wrong.
> > The comments can easily be fixed of course. For JITs that have the
> > off-by-one behaviour, an easy fix would be to change all occurrences
> > of MAX_TAIL_CALL_CNT to MAX_TAIL_CALL_CNT - 1. We must first know
> > which JITs affected though.
>
> If you are going to fix ARM, please send a fix to comments for x86 as well.
>
> >
> > The fix is easy but setting up the test is hard. It took me quite some
> > time to get the qemu/arm setup up and running. If the same has to be
> > done for arm64, mips64, powerpc, powerpc64, riscv32, risc64, sparc and
> > s390, I will need some help with this. If someone already has a
> > working setup for any of the systems, the test can be performed on
> > that.
> >
>
> Unfortunately, I myself have only x86-64 setup. libbpf
> CI/kernel-patches CI we use to run all tests are running selftests
> against x86-64 only as well. There was temporarily halted effort to
> add s390x support as well, but it's not done yet. No one yet
> volunteered to set up any other platforms and I don't know if that's
> possible and how hard it would be to do within Github Actions platform
> we are currently using.
>
> So in short, I understand the challenges of testing all those
> platforms and I don't really expect any single person to do all that
> work. I've applied your fix, please follow up with ARM and comment
> fixes.

Thanks! I will fix the ARM JIT and the comments, then submit an
updated patch set for the test suite with changes after Yonghong's
review.

My current test setup can easily cross-compile the kernel with busybox
as userspace. However, getting it to run on QEMU has required some
amount of detective work. Every platforms seems to be different in
terms of what to boot (vmlinux, zImage, bzImage), how to boot it (dtb,
bios, uBoot requirements) and QEMU vs Kconfig settings. Currently I
can run i386, x86_64, MIPS, MIPS64 and ARM under QEMU. I can verify
and if needed fix the JIT on some of the other platforms as well, if I
can get it to run on QEMU with a reasonable effort. However, I cannot
build for RISC-V since I don't have a toolchain for that. I build my
toolchains with crosstool-ng using libmusl, and the latter does not
currently support RISC-V.

As a side note, I think having a QEMU-compatible defconfig for each
platform would make it easier to test arch-specific code. It could
also be a first step towards fully automated arch-specific CI.

Sorry for being a bit slow to respond. I am currently travelling with
only sporadic access to e-mail.

>
> > Or perhaps there is a better way to do this? If I implement a similar
> > test in selftest/bpf, that would trigger the CI when the patch is
> > submitted and we will see which JITs we need to fix.
>
> The other nice benefit of implementing this in selftest/bpf, besides
> continuous testing, is that you write it in C, which allows you to
> express much more complicated logic more easily.
>
> >
> > > On a related topic, please don't forget to include the target kernel
> > > tree for your patches: [PATCH bpf] or [PATCH bpf-next].
> >
> > I'll add that! All patches I sent related to this are for the bpf-next tree.
> >
> > Johan
