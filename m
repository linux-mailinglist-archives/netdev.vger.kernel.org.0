Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86004792A5
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 18:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239781AbhLQRRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 12:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239776AbhLQRRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 12:17:02 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB53C06173E;
        Fri, 17 Dec 2021 09:17:01 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id e136so8426610ybc.4;
        Fri, 17 Dec 2021 09:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S80qCg3X3ROAaj+j76pTG6rtJ32t22ZToJrUxmnJV3Q=;
        b=ZUjdxL96NGSLLnMFUnctHGQCiY9oVfqs4Rvpf6+HOZ9PusvcI/izLMTMJNu0JoRQDD
         vhITLRk70lB0niJ/RBCOWwWNmZ2wMyMiXTEMmXKnx9M85Ynlo27VeU8WtEhLxN58eVoK
         mHq+XNdLVQ+jEz6q5VPyruaa0P4T3AhRw8q5abn/HaDY+2gAJAZVEBQlfJK10bDhRbcW
         gTfF3ZCpmdxqXgxB5dEKHYJy0xSUJMZrb8kU3y+ZZ2Dt2c6b4UmSJF/dQE73ebr7DN+z
         VxN+KZil1iBKAfRbSV6nesQm9mmAKpGiZDHHGL1wjJI86QX21D5HxvnDYqjN+YGsAPA2
         Zhhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S80qCg3X3ROAaj+j76pTG6rtJ32t22ZToJrUxmnJV3Q=;
        b=I++2Qf7QTylvIXANtGwOc6NVl9/MbV+QOhqR929dT4mvLYHpz2xCRMAGpttWcncU7P
         co5KF7qGXIVScd10LvScwd7T3iDjvAU8dHMOwE/aLWjkCIAiFVR65SpYZ0QBiUCYXf0F
         KXeKgVbTCDj3tXQZ9C1fcf4JSDNE75/IAqg25ae4w8WOiLojNQoisGqNbo8lbl0r0U1a
         vns3ZaQcll0rTHnfneUvGgDMn7iv/Ff4lAcdNaLmTJvIAco16wlcRZtYRBJZfkuSqGti
         3LVukyAv4cMvfGbPYECxoniPSy1xNoL/hkXmvaaME8qxUSZsBeMzclP7YsZikq5uLcCi
         zRfw==
X-Gm-Message-State: AOAM531acB3gOevvFvBRb6WzPYpQ/qekzf9EZz/okbW7GrJeGm5XLgfT
        AQCKspldjlGiQN8Yqf8REzmT1iSQLK9VFeQr5SM=
X-Google-Smtp-Source: ABdhPJwn6gbDzzoy3xqfqebPniO8nKwW/AXMAMyYCisSEHhhcpkA4lH9jIotRL83u902glyiBTbuoIOnkjZEWanOcqI=
X-Received: by 2002:a25:4ed4:: with SMTP id c203mr5996465ybb.529.1639761420653;
 Fri, 17 Dec 2021 09:17:00 -0800 (PST)
MIME-Version: 1.0
References: <20211215060102.3793196-1-song@kernel.org> <CAEf4BzaFYPWCycTx+pHefhRHgD2n1WPyy9-L9TDJ8rHyGTaQSQ@mail.gmail.com>
 <DC857926-ECDA-4DF0-8058-C53DD15226AE@fb.com> <CAEf4BzbfqSGHCbG6-EC=DLd=yFCwDiKEFWMtG4hbY78dm2OA=Q@mail.gmail.com>
 <CAEf4Bzb3sbf5Ddq4FaBsZpyiqhoFD+PxxbZHP6ips6h01EuNYg@mail.gmail.com> <5AD9F449-6462-4501-9D1D-407956103DD4@fb.com>
In-Reply-To: <5AD9F449-6462-4501-9D1D-407956103DD4@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Dec 2021 09:16:49 -0800
Message-ID: <CAEf4BzZy3TrBoEuGZqzT99YEwwNjTbhp5GY0BW0gXxGzxf8jFQ@mail.gmail.com>
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

On Fri, Dec 17, 2021 at 9:13 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Dec 17, 2021, at 8:43 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Dec 17, 2021 at 8:42 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> >>
> >> On Thu, Dec 16, 2021 at 5:53 PM Song Liu <songliubraving@fb.com> wrote:
> >>>
> >>>
> >>>
> >>>> On Dec 16, 2021, at 12:06 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >>>>
> >>>> On Tue, Dec 14, 2021 at 10:01 PM Song Liu <song@kernel.org> wrote:
> >>>>>
> >>>>> Changes v1 => v2:
> >>>>> 1. Use text_poke instead of writing through linear mapping. (Peter)
> >>>>> 2. Avoid making changes to non-x86_64 code.
> >>>>>
> >>>>> Most BPF programs are small, but they consume a page each. For systems
> >>>>> with busy traffic and many BPF programs, this could also add significant
> >>>>> pressure to instruction TLB.
> >>>>>
> >>>>> This set tries to solve this problem with customized allocator that pack
> >>>>> multiple programs into a huge page.
> >>>>>
> >>>>> Patches 1-5 prepare the work. Patch 6 contains key logic of the allocator.
> >>>>> Patch 7 uses this allocator in x86_64 jit compiler.
> >>>>>
> >>>>
> >>>> There are test failures, please see [0]. But I was also wondering if
> >>>> there could be an explicit selftest added to validate that all this
> >>>> huge page machinery is actually activated and working as expected?
> >>>
> >>> We can enable some debug option that dumps the page table. Then from the
> >>> page table, we can confirm the programs are running on a huge page. This
> >>> only works on x86_64 though. WDYT?
> >>>
> >>
> >> I don't know what exactly is involved, so it's hard to say. Ideally
> >> whatever we do doesn't complicate our CI setup. Can we use BPF tracing
> >> magic to check this from inside the kernel somehow?
> >>
> >
> > But I don't feel strongly about this, if it's hard to detect, it's
> > fine to not have a specific test (especially that it's very
> > architecture-specific)
>
> It will be more or less architecture-specific, as we need somehow walk
> the page table (with debug option or with BPF iterator). I will try
> something.

If BPF iterator approach works, that would be great!

>
> Thanks,
> Song
>
>
> >
> >>> Thanks,
> >>> Song
> >>>
> >>>
> >>>>
> >>>> [0] https://github.com/kernel-patches/bpf/runs/4530372387?check_suite_focus=true
> >>>>
> >>>>> Song Liu (7):
> >>>>> x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
> >>>>> bpf: use bytes instead of pages for bpf_jit_[charge|uncharge]_modmem
> >>>>> bpf: use size instead of pages in bpf_binary_header
> >>>>> bpf: add a pointer of bpf_binary_header to bpf_prog
> >>>>> x86/alternative: introduce text_poke_jit
> >>>>> bpf: introduce bpf_prog_pack allocator
> >>>>> bpf, x86_64: use bpf_prog_pack allocator
> >>>>>
> >>>>> arch/x86/Kconfig                     |   1 +
> >>>>> arch/x86/include/asm/text-patching.h |   1 +
> >>>>> arch/x86/kernel/alternative.c        |  28 ++++
> >>>>> arch/x86/net/bpf_jit_comp.c          |  93 ++++++++++--
> >>>>> include/linux/bpf.h                  |   4 +-
> >>>>> include/linux/filter.h               |  23 ++-
> >>>>> kernel/bpf/core.c                    | 213 ++++++++++++++++++++++++---
> >>>>> kernel/bpf/trampoline.c              |   6 +-
> >>>>> 8 files changed, 328 insertions(+), 41 deletions(-)
> >>>>>
> >>>>> --
> >>>>> 2.30.2
> >>>
>
