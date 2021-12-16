Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0888477D05
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241211AbhLPUGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhLPUGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:06:17 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65416C061574;
        Thu, 16 Dec 2021 12:06:17 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id x32so169472ybi.12;
        Thu, 16 Dec 2021 12:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t8UhrVoJO3ViO+xt8GYc82KoVVRaQTmxI1phwQt2po8=;
        b=Gy4obH8+fiqZASz9f3K4NtQ4IrVcufU6If0U6DMXPmDSq0ev/6W2AXPo0zlfXbPYVn
         kFkcGwj6VFHPjgxcQ3uI/ySUpYZAE7HiJxBARcx8B5gPH0EoXrBTbCoQ54tatAGsKbgA
         AeVznOtYpE+r8OShAD8E3i0jBAyNPGXIQM6scG030oIhxSvlcvgRJBLnCOlHufi0fSBw
         HVjw7rWwl5o48aYiv2VIwa+lI6Gcm3LvuiLtMepN3IidNkvHBFIH0sVeC8QT5rnoyRMf
         AzzRxQLB335YFV0WGmlnoVjoeSfvC4s0OcBA4tyRVHR0TR8uyYj3/FITf1ZeZfFAgsdr
         2AkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t8UhrVoJO3ViO+xt8GYc82KoVVRaQTmxI1phwQt2po8=;
        b=M/D0ucBX1C8VTE8jiDQGHs9iikQkVmNJXGYS2iB6KhQppgOhsb2UdvTxo6rMVYBJai
         vAb7RuheLlEdhoxQEV5S6DpSzal38vOpA8x2XeKWzHa++yOoe993noILxTuv9QBBiwZ4
         0e+jmpgv8a8gauYiyN5EIW9zJPDfn7/dm9TsLRWSq1fTrDOHpi9Dxc9NGTMnAxNvcAAb
         ci76X6ZNCfC2oAYu+nXEdNfJ7BawbCYRZo+ynPurtF/6g0KDddeDhkM/Ej844fbu0cZy
         HcKHHHcNEzLuIMo2PPw4Cp8Yxrrb//Q9Ext3vsPglr+zcJOp96fYRk0jhqY5NBWcyXAM
         OggQ==
X-Gm-Message-State: AOAM532/OefYGz5x+cRkyGITBAiCUXZVLzudxx5GMT4jr9jb0cgaN3hh
        ov8G4pSmClwSOgkW1spoxcL2K904MOyMcG0zqq9H941qbL+SXg==
X-Google-Smtp-Source: ABdhPJwprXxXuy7Y+Au9JsnehBKSdISoT2DfoLeUnkYT4zUVDw5i9y+Oqm5Xa9w4hk+dtbtt7amLmZn1JgHB6avm1Oo=
X-Received: by 2002:a25:e90a:: with SMTP id n10mr14918202ybd.180.1639685176580;
 Thu, 16 Dec 2021 12:06:16 -0800 (PST)
MIME-Version: 1.0
References: <20211215060102.3793196-1-song@kernel.org>
In-Reply-To: <20211215060102.3793196-1-song@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Dec 2021 12:06:05 -0800
Message-ID: <CAEf4BzaFYPWCycTx+pHefhRHgD2n1WPyy9-L9TDJ8rHyGTaQSQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/7] bpf_prog_pack allocator
To:     Song Liu <song@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Peter Ziljstra <peterz@infradead.org>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 10:01 PM Song Liu <song@kernel.org> wrote:
>
> Changes v1 => v2:
> 1. Use text_poke instead of writing through linear mapping. (Peter)
> 2. Avoid making changes to non-x86_64 code.
>
> Most BPF programs are small, but they consume a page each. For systems
> with busy traffic and many BPF programs, this could also add significant
> pressure to instruction TLB.
>
> This set tries to solve this problem with customized allocator that pack
> multiple programs into a huge page.
>
> Patches 1-5 prepare the work. Patch 6 contains key logic of the allocator.
> Patch 7 uses this allocator in x86_64 jit compiler.
>

There are test failures, please see [0]. But I was also wondering if
there could be an explicit selftest added to validate that all this
huge page machinery is actually activated and working as expected?

  [0] https://github.com/kernel-patches/bpf/runs/4530372387?check_suite_focus=true

> Song Liu (7):
>   x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
>   bpf: use bytes instead of pages for bpf_jit_[charge|uncharge]_modmem
>   bpf: use size instead of pages in bpf_binary_header
>   bpf: add a pointer of bpf_binary_header to bpf_prog
>   x86/alternative: introduce text_poke_jit
>   bpf: introduce bpf_prog_pack allocator
>   bpf, x86_64: use bpf_prog_pack allocator
>
>  arch/x86/Kconfig                     |   1 +
>  arch/x86/include/asm/text-patching.h |   1 +
>  arch/x86/kernel/alternative.c        |  28 ++++
>  arch/x86/net/bpf_jit_comp.c          |  93 ++++++++++--
>  include/linux/bpf.h                  |   4 +-
>  include/linux/filter.h               |  23 ++-
>  kernel/bpf/core.c                    | 213 ++++++++++++++++++++++++---
>  kernel/bpf/trampoline.c              |   6 +-
>  8 files changed, 328 insertions(+), 41 deletions(-)
>
> --
> 2.30.2
