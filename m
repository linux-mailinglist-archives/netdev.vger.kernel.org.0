Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C35BEF362F
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbfKGRux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:50:53 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37831 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729830AbfKGRux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 12:50:53 -0500
Received: by mail-lj1-f194.google.com with SMTP id l20so3263355lje.4;
        Thu, 07 Nov 2019 09:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TS2GxsNifqJ6d4IJfMFJvqs88Utf5kw6eXVlmLfxw8E=;
        b=B2riYz8aX6d2hWVoZ5vkGep7e1ZqRuniZw138ShPV0MKxduvt9v7230ANasFRpUH/8
         RbClvchkghrotL6M8uZhJFzmwnerZkg7IMe0m4Au63WoA55jaA39/Yc5Yt82Fr5VGqDu
         oBRjQU0BMaWc2Xts4XR+/tmXsuxRmoB1tw1fBVkWim6hIS3uLmJugpdq0yPoFcgFAFbH
         ROYnPZOvilzo1XtwiSX6KCGsa85QC/Pid9rXuW+ID9vn43bSmSR260acnJo+prCzWM9o
         YeU7SkPZ8fdkyf3m+llXkhtpSPedRrjrSXcHnGhZ0KyhA8bWW1pdt2DrzGINoCdR7Mlm
         ALHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TS2GxsNifqJ6d4IJfMFJvqs88Utf5kw6eXVlmLfxw8E=;
        b=gV8cPGmYF+4K0hlbgrwRUIQvssbVzwU/cY/l0YMpGj09dtLza4P61Z6cQViDVJ1tnl
         jHmG1OKGwi6rL1x3HYWow6xGQmSDGnryB8KGXi/Z1Rri6ctqGucq3nF6OxCYQKX9HSz2
         2v1i6DrYq+A04t4cLomYLSPAJ/lnu4bGM2LzyvRpKFAGc9O1wbCh/YvvdEh56NAgOhDF
         WpdGbmtQRhLqQANiesmn3azPxsVbO0godnU8dQFm6dolho4gJ6lyDv35SjctjDYQNG+u
         6hHhLzErXuX8KTNhUhfYDK9KpjGb7Bt9YhSUxx0ZFRWS3OfgcQ6Vp/om8Fs1Ul/+XpKb
         IAYg==
X-Gm-Message-State: APjAAAWg3KgiC+AeVSkYyrDqbLNgG0CYSXJ4Vn3HBJVZ0nttbTopzQV1
        d67foSt97/eSVYZLLpPBnIfc9foNcDU+PMlrV0g=
X-Google-Smtp-Source: APXvYqwEYlV4HpkxC4HQnrrPEDlqBsf1aEhYpof3jk1qw3qphCJJhHqCdntXBvyYDBVhN5JsyUbzm8GLRyMYfbgJtdw=
X-Received: by 2002:a2e:8508:: with SMTP id j8mr3341799lji.136.1573149050357;
 Thu, 07 Nov 2019 09:50:50 -0800 (PST)
MIME-Version: 1.0
References: <20191107054644.1285697-1-ast@kernel.org> <20191107054644.1285697-3-ast@kernel.org>
 <EE50EB7D-8FB0-4D37-A3F1-3439981A6141@fb.com>
In-Reply-To: <EE50EB7D-8FB0-4D37-A3F1-3439981A6141@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 7 Nov 2019 09:50:39 -0800
Message-ID: <CAADnVQJsnVmTNxj1QbEbHCsvyvL348R08cZ6ChZK8EGnpc2BfQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 02/17] bpf: Add bpf_arch_text_poke() helper
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 9:20 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Nov 6, 2019, at 9:46 PM, Alexei Starovoitov <ast@kernel.org> wrote:
> >
> > Add bpf_arch_text_poke() helper that is used by BPF trampoline logic to patch
> > nops/calls in kernel text into calls into BPF trampoline and to patch
> > calls/nops inside BPF programs too.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> > arch/x86/net/bpf_jit_comp.c | 51 +++++++++++++++++++++++++++++++++++++
> > include/linux/bpf.h         |  8 ++++++
> > kernel/bpf/core.c           |  6 +++++
> > 3 files changed, 65 insertions(+)
> >
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index 0399b1f83c23..8631d3bd637f 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -9,9 +9,11 @@
> > #include <linux/filter.h>
> > #include <linux/if_vlan.h>
> > #include <linux/bpf.h>
> > +#include <linux/memory.h>
> > #include <asm/extable.h>
> > #include <asm/set_memory.h>
> > #include <asm/nospec-branch.h>
> > +#include <asm/text-patching.h>
> >
> > static u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
> > {
> > @@ -487,6 +489,55 @@ static int emit_call(u8 **pprog, void *func, void *ip)
> >       return 0;
> > }
> >
> > +int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
> > +                    void *old_addr, void *new_addr)
> > +{
> > +     u8 old_insn[NOP_ATOMIC5] = {};
> > +     u8 new_insn[NOP_ATOMIC5] = {};
> > +     u8 *prog;
> > +     int ret;
> > +
> > +     if (!is_kernel_text((long)ip))
> > +             /* BPF trampoline in modules is not supported */
> > +             return -EINVAL;
> > +
> > +     if (old_addr) {
> > +             prog = old_insn;
> > +             ret = emit_call(&prog, old_addr, (void *)ip);
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +     if (old_addr) {
>                 ^ should be new_addr?
> > +             prog = new_insn;
> > +             ret = emit_call(&prog, old_addr, (void *)ip);
>                                         ^^^ and here?
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +     ret = -EBUSY;
> > +     mutex_lock(&text_mutex);
> > +     switch (t) {
> > +     case BPF_MOD_NOP_TO_CALL:
> > +             if (memcmp(ip, ideal_nops, 5))
>
> Maybe use X86_CALL_SIZE instead of 5? And the five more "5" below?

ohh. yes. of course. I had it fixed.
NOP_ATOMIC5 above is incorrect as well. I had it fixed too.
Looks like I've lost another squash commit last night.
Sorry about that.
