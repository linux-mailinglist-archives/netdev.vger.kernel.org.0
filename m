Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7394791AD
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 17:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238361AbhLQQnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 11:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235796AbhLQQnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 11:43:23 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05E6C061574;
        Fri, 17 Dec 2021 08:43:22 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id y68so8218157ybe.1;
        Fri, 17 Dec 2021 08:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PEi6Hg+qpmCegDUptK8uXeraoYtQySx5+iFXDlrrumM=;
        b=V8ibWEWEQ4BIx84gCk1TKVkRlql7baDM5YjzIiRhH/x+Do49q+tWWQDHPDloNsSgzS
         NNKOxJ8ghcKv6LgElON+Bcwz1RahvLrwlcsXxpUa7UpriD/gLcK6hgCAeMPOuqiFN1uY
         0HAzPoTkCRu+dF+KCL5gBxlAnYNyPcqfuJjB8x3Rd7pW+dCt8+sFwfXmCiz31Dm1VgSC
         VrqohetlqlEyIlj0YwaKBYe+aqds251A6c7kMRX/nais2ickyKXBbnnTSpeQmB9oyd/g
         DALT4dCnnI0UJPLkGvJcM0hwkg/PYueeCjEvsUWvDrgvLdH9QlCLxf3rgh1ciZ18+Wjk
         8BlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PEi6Hg+qpmCegDUptK8uXeraoYtQySx5+iFXDlrrumM=;
        b=iUoFfY5mekUAV6eG8peqyyArhFwlH0NgrnBc2ivtnOTehtL097oh6o/2djz+qoHUCM
         0BmiWj4MEF7WV3e4vFWpIPINgg5TFDWHjzzrgIkk2VuQFx2AFj3Ju6+ZmJrNv/jz/lh6
         a2XhJl2IInUSMFAoA/HwpgLK3cMYeQKKSLK57BY/1mYePxhMBWhip+qSDBUR47yCMcrJ
         CyvOgjcwfUfBOKDT0jVgvUcaiHBPj1oM1zG2IFsMqq6OmiUbw9sL7BGLv1gJZPWi/jwC
         MOlV5U2laE6iDtcArOMAKY104BR+P6+gjYCF6yzvTrI0OxyhxdFqopPplyykIM73oq1h
         PK1g==
X-Gm-Message-State: AOAM532eOxRdb6WjNyyadhhrUKI6YhZW2xolpFD+bTWs9VBFRiwsFseK
        Y/5CH14HngpflQzig7iTRxzO/MHp0eXyiBPVc1c=
X-Google-Smtp-Source: ABdhPJzC9ELVuCk0Ucd+qF84sdX3qBQOw0u/JzlnEMqw6tA3GDiL/eXCMkOwTPX0mSip9sY2S28ZuaKmK7dtw7bzMds=
X-Received: by 2002:a25:e90a:: with SMTP id n10mr5296330ybd.180.1639759402213;
 Fri, 17 Dec 2021 08:43:22 -0800 (PST)
MIME-Version: 1.0
References: <20211215060102.3793196-1-song@kernel.org> <CAEf4BzaFYPWCycTx+pHefhRHgD2n1WPyy9-L9TDJ8rHyGTaQSQ@mail.gmail.com>
 <DC857926-ECDA-4DF0-8058-C53DD15226AE@fb.com> <CAEf4BzbfqSGHCbG6-EC=DLd=yFCwDiKEFWMtG4hbY78dm2OA=Q@mail.gmail.com>
In-Reply-To: <CAEf4BzbfqSGHCbG6-EC=DLd=yFCwDiKEFWMtG4hbY78dm2OA=Q@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Dec 2021 08:43:11 -0800
Message-ID: <CAEf4Bzb3sbf5Ddq4FaBsZpyiqhoFD+PxxbZHP6ips6h01EuNYg@mail.gmail.com>
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

On Fri, Dec 17, 2021 at 8:42 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Dec 16, 2021 at 5:53 PM Song Liu <songliubraving@fb.com> wrote:
> >
> >
> >
> > > On Dec 16, 2021, at 12:06 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Tue, Dec 14, 2021 at 10:01 PM Song Liu <song@kernel.org> wrote:
> > >>
> > >> Changes v1 => v2:
> > >> 1. Use text_poke instead of writing through linear mapping. (Peter)
> > >> 2. Avoid making changes to non-x86_64 code.
> > >>
> > >> Most BPF programs are small, but they consume a page each. For systems
> > >> with busy traffic and many BPF programs, this could also add significant
> > >> pressure to instruction TLB.
> > >>
> > >> This set tries to solve this problem with customized allocator that pack
> > >> multiple programs into a huge page.
> > >>
> > >> Patches 1-5 prepare the work. Patch 6 contains key logic of the allocator.
> > >> Patch 7 uses this allocator in x86_64 jit compiler.
> > >>
> > >
> > > There are test failures, please see [0]. But I was also wondering if
> > > there could be an explicit selftest added to validate that all this
> > > huge page machinery is actually activated and working as expected?
> >
> > We can enable some debug option that dumps the page table. Then from the
> > page table, we can confirm the programs are running on a huge page. This
> > only works on x86_64 though. WDYT?
> >
>
> I don't know what exactly is involved, so it's hard to say. Ideally
> whatever we do doesn't complicate our CI setup. Can we use BPF tracing
> magic to check this from inside the kernel somehow?
>

But I don't feel strongly about this, if it's hard to detect, it's
fine to not have a specific test (especially that it's very
architecture-specific)

> > Thanks,
> > Song
> >
> >
> > >
> > >  [0] https://github.com/kernel-patches/bpf/runs/4530372387?check_suite_focus=true
> > >
> > >> Song Liu (7):
> > >>  x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
> > >>  bpf: use bytes instead of pages for bpf_jit_[charge|uncharge]_modmem
> > >>  bpf: use size instead of pages in bpf_binary_header
> > >>  bpf: add a pointer of bpf_binary_header to bpf_prog
> > >>  x86/alternative: introduce text_poke_jit
> > >>  bpf: introduce bpf_prog_pack allocator
> > >>  bpf, x86_64: use bpf_prog_pack allocator
> > >>
> > >> arch/x86/Kconfig                     |   1 +
> > >> arch/x86/include/asm/text-patching.h |   1 +
> > >> arch/x86/kernel/alternative.c        |  28 ++++
> > >> arch/x86/net/bpf_jit_comp.c          |  93 ++++++++++--
> > >> include/linux/bpf.h                  |   4 +-
> > >> include/linux/filter.h               |  23 ++-
> > >> kernel/bpf/core.c                    | 213 ++++++++++++++++++++++++---
> > >> kernel/bpf/trampoline.c              |   6 +-
> > >> 8 files changed, 328 insertions(+), 41 deletions(-)
> > >>
> > >> --
> > >> 2.30.2
> >
