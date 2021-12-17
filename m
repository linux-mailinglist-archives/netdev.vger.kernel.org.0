Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF434791AA
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 17:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239216AbhLQQmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 11:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235796AbhLQQmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 11:42:45 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92C8C061574;
        Fri, 17 Dec 2021 08:42:44 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id 131so8079085ybc.7;
        Fri, 17 Dec 2021 08:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NuomcOiylsxyCYewcBs5cwYFl3sDS7oGrjyGq07kCFk=;
        b=SSnBoElEP/qVPmxVCiWiNQZDq2JNIj3TlSMHtYw2hV0V0NB2c6JcjJREuJb2GAV25A
         sI7FwCRusa61jOHFfYOX+OfL2sbWAuzVpBcQHJNpNaioYi7qHi71hCzETw96Duq5NahM
         KWKm034T8GzX9AIG3pwo4yS3bs8mfpCen0m2iFYYxVOLgV7h5EMsyQSlsoY+KbT3FSUD
         CLA2yWG3bKvmo5wGSPJRAFeVIGyYYA7l8SBo7ShQospFoYcHJq/BQxoKv9I5UoD3LZPN
         d22BElorS9ncNWv0eLlt6BpCF5IaY4f/2P8gS+41QThl602pncEyccj2eO6TIVyPNXb2
         GIiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NuomcOiylsxyCYewcBs5cwYFl3sDS7oGrjyGq07kCFk=;
        b=g+iFhyZKtZfmftfhH5S5FcJKALVBaAQQwCiTwdE6i+JOLMNLy1SD1Rdog4ZRPZUu/c
         OlVjRchM8bcgaUUvWPa8q2FLTRKkzmSxhguaXs6k0y4TMGYenfSkUgoU9cu31bBJ6gcE
         m7ookyYtkAmdXetPa6YGwL9yJ6mEyYQOMh1Ool5b+/K3xvl6uCsSiNNPhyHRBecKScMX
         0/aeLXzY3eW/QKY7Lawwn7jYxx7ny8rglrr5stSLWZk8yI+ARxJiRn1ccI7DcbgQGkXC
         oXTQqLYrfSk0U6aDDk3SUd804+WzPdYqGdQF3xJdRnaNkbClS+vlhIK0seVZZ/GE302p
         1CkA==
X-Gm-Message-State: AOAM533+rKj7EiXZaMRL0QORhwnuGqvLh4kHXY9y5kVjbGBTWwUiynSQ
        qt7GScJeAV+/mIGh9RDYfjO8PzMSIOUbD8r4D28=
X-Google-Smtp-Source: ABdhPJzRSCbDsa0g1flE49MkbM7YNoYsL6KFhNDq/vehQIv2zVgY6SpZ9O7tbAcbWqU6Rwdi8G5fJUd8z23UOCgldww=
X-Received: by 2002:a25:3c9:: with SMTP id 192mr5483302ybd.766.1639759363594;
 Fri, 17 Dec 2021 08:42:43 -0800 (PST)
MIME-Version: 1.0
References: <20211215060102.3793196-1-song@kernel.org> <CAEf4BzaFYPWCycTx+pHefhRHgD2n1WPyy9-L9TDJ8rHyGTaQSQ@mail.gmail.com>
 <DC857926-ECDA-4DF0-8058-C53DD15226AE@fb.com>
In-Reply-To: <DC857926-ECDA-4DF0-8058-C53DD15226AE@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Dec 2021 08:42:32 -0800
Message-ID: <CAEf4BzbfqSGHCbG6-EC=DLd=yFCwDiKEFWMtG4hbY78dm2OA=Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/7] bpf_prog_pack allocator
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Ziljstra <peterz@infradead.org>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 5:53 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Dec 16, 2021, at 12:06 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Dec 14, 2021 at 10:01 PM Song Liu <song@kernel.org> wrote:
> >>
> >> Changes v1 => v2:
> >> 1. Use text_poke instead of writing through linear mapping. (Peter)
> >> 2. Avoid making changes to non-x86_64 code.
> >>
> >> Most BPF programs are small, but they consume a page each. For systems
> >> with busy traffic and many BPF programs, this could also add significant
> >> pressure to instruction TLB.
> >>
> >> This set tries to solve this problem with customized allocator that pack
> >> multiple programs into a huge page.
> >>
> >> Patches 1-5 prepare the work. Patch 6 contains key logic of the allocator.
> >> Patch 7 uses this allocator in x86_64 jit compiler.
> >>
> >
> > There are test failures, please see [0]. But I was also wondering if
> > there could be an explicit selftest added to validate that all this
> > huge page machinery is actually activated and working as expected?
>
> We can enable some debug option that dumps the page table. Then from the
> page table, we can confirm the programs are running on a huge page. This
> only works on x86_64 though. WDYT?
>

I don't know what exactly is involved, so it's hard to say. Ideally
whatever we do doesn't complicate our CI setup. Can we use BPF tracing
magic to check this from inside the kernel somehow?

> Thanks,
> Song
>
>
> >
> >  [0] https://github.com/kernel-patches/bpf/runs/4530372387?check_suite_focus=true
> >
> >> Song Liu (7):
> >>  x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
> >>  bpf: use bytes instead of pages for bpf_jit_[charge|uncharge]_modmem
> >>  bpf: use size instead of pages in bpf_binary_header
> >>  bpf: add a pointer of bpf_binary_header to bpf_prog
> >>  x86/alternative: introduce text_poke_jit
> >>  bpf: introduce bpf_prog_pack allocator
> >>  bpf, x86_64: use bpf_prog_pack allocator
> >>
> >> arch/x86/Kconfig                     |   1 +
> >> arch/x86/include/asm/text-patching.h |   1 +
> >> arch/x86/kernel/alternative.c        |  28 ++++
> >> arch/x86/net/bpf_jit_comp.c          |  93 ++++++++++--
> >> include/linux/bpf.h                  |   4 +-
> >> include/linux/filter.h               |  23 ++-
> >> kernel/bpf/core.c                    | 213 ++++++++++++++++++++++++---
> >> kernel/bpf/trampoline.c              |   6 +-
> >> 8 files changed, 328 insertions(+), 41 deletions(-)
> >>
> >> --
> >> 2.30.2
>
