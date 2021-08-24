Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551693F6AF7
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235155AbhHXVZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbhHXVZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:25:15 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D3FC061757;
        Tue, 24 Aug 2021 14:24:31 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id r4so43744018ybp.4;
        Tue, 24 Aug 2021 14:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iGmoKfRn9uvcO/AgNrT0LvDHi5pOKnSc6KAdJO0Ad+U=;
        b=WZIjJR/C9kbKypOz2aqNiJaFZa355EsrCv9RaiMwnotRypEtqEYD9atK2/lGeR6i/R
         hGmmBMtJ389U50LRjRivh+r7eSZiVBqFrsfz251ahF0POUtPzq2B2jQtBk1p+X57gjgf
         6+GgMOPxb54fdH+262UGJVR9tyoET85rqAU79FxjGqMbkrCwSan6IoQhrMTAyWDjsuqR
         Cm+xvwfRnamMrlOx0KFlaAUaf8kx29MNM26TkXotKIQOVPIfxFC/XFnR0kMM9pWlc8+Q
         9op5gkDx87R5Ws2X1om9Jo3RxAHKr16v/hIXwv3/23/OtSMef+U3xIXdJdDse279mj+2
         f1UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iGmoKfRn9uvcO/AgNrT0LvDHi5pOKnSc6KAdJO0Ad+U=;
        b=hHbylZ1JSdaY/3TjtBxpbh4zl+7hSbj5ZVEQ4fL71nmJED4J2MlN+8tPJBK64mCA7s
         tB90ZFtno/IS0ZS0l57epaiPQRG32pAR5B+DUE/k6MnS59cYEVVQvumll8CWsdaqAA9h
         sLr0GJ2W8P/RG7BVdBE+QHCIh4csmF1JBKZe/1KqJvQgL+iksJRx991eF7vEqEHs3qKC
         3OYgk7LZvmhkBdg85AX+qkNh0fRlVVZQz85VgoTgjWw5PW2BdPzQusjBXNh2BT9WfH+y
         Y9Vq1mdh6cG5vf1arEKWCnr6DiV3avffas58OKsauNMho3d4N6tN7uUmDaRfdeP5Y/N3
         dPvg==
X-Gm-Message-State: AOAM530Rlw6L/yZIpyLO2SSRmRxU8t+DYmg52ulMMstDMmWr8AGkTrBS
        ioNKNgrZ/BeC9TM+au390lFd8JILcbsRMOuxzjA=
X-Google-Smtp-Source: ABdhPJye3AduW2snf25fJigr8aVXrfyh96n25vFnKfu4ZNZpr6rqyzeiQH3KceWZhZ8c0I+3GfJ8sIBWxyAYNVoiAeQ=
X-Received: by 2002:a25:ac7:: with SMTP id 190mr14067724ybk.260.1629840270231;
 Tue, 24 Aug 2021 14:24:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210821025837.1614098-1-davemarchevsky@fb.com>
 <20210821025837.1614098-3-davemarchevsky@fb.com> <CAEf4BzYEOzfmwi8n8K_W_6Pc+gC081ncmRCAq8Fz0vr=y7eMcg@mail.gmail.com>
 <CAADnVQLUWHO0EhLhMVATc9-z11H7ROF6DCmJ=sW+-iP1baeWWg@mail.gmail.com>
 <CAEf4Bza30Rkg02AzmG7Mw5AyE1wykPBuH6f_fXAQXLu2qH2POA@mail.gmail.com>
 <CAADnVQ+Kxei6_q4PWQ57zVr86gKqu=4s07Y1Kwy9SNz__PWYdQ@mail.gmail.com>
 <CAEf4BzbU6xt49+VYSDGoXonOMdB3SPDdh_sr2pTeUC66sT3kPw@mail.gmail.com> <CAADnVQL_6XNoUaO_J43OSfyirjRRLUgK7B18BVopd49suUJt6A@mail.gmail.com>
In-Reply-To: <CAADnVQL_6XNoUaO_J43OSfyirjRRLUgK7B18BVopd49suUJt6A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 24 Aug 2021 14:24:18 -0700
Message-ID: <CAEf4BzZf84FWnrz7zimcW0tw-k1im6kaJJ+g6ypzushXEb3oeA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] bpf: add bpf_trace_vprintk helper
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Dave Marchevsky <davemarchevsky@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Florent Revest <revest@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 2:00 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 24, 2021 at 11:24 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Aug 24, 2021 at 11:17 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Aug 24, 2021 at 11:02 AM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Tue, Aug 24, 2021 at 10:57 AM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Mon, Aug 23, 2021 at 9:50 PM Andrii Nakryiko
> > > > > <andrii.nakryiko@gmail.com> wrote:
> > > > > >
> > > > > > On Fri, Aug 20, 2021 at 7:59 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
> > > > > > >
> > > > > > > This helper is meant to be "bpf_trace_printk, but with proper vararg
> > > > > >
> > > > > > We have bpf_snprintf() and bpf_seq_printf() names for other BPF
> > > > > > helpers using the same approach. How about we call this one simply
> > > > > > `bpf_printf`? It will be in line with other naming, it is logical BPF
> > > > > > equivalent of user-space printf (which outputs to stderr, which in BPF
> > > > > > land is /sys/kernel/debug/tracing/trace_pipe). And it will be logical
> > > > > > to have a nice and short BPF_PRINTF() convenience macro provided by
> > > > > > libbpf.
> > > > > >
> > > > > > > support". Follow bpf_snprintf's example and take a u64 pseudo-vararg
> > > > > > > array. Write to dmesg using the same mechanism as bpf_trace_printk.
> > > > > >
> > > > > > Are you sure about the dmesg part?... bpf_trace_printk is outputting
> > > > > > into /sys/kernel/debug/tracing/trace_pipe.
> > > > >
> > > > > Actually I like bpf_trace_vprintk() name, since it makes it obvious that
> > > >
> > > > It's the inconsistency with bpf_snprintf() and bpf_seq_printf() that's
> > > > mildly annoying (it's f at the end, and no v- prefix). Maybe
> > > > bpf_trace_printf() then? Or is it too close to bpf_trace_printk()?
> > >
> > > bpf_trace_printf could be ok, but see below.
> > >
> > > > But
> > > > either way you would be using BPF_PRINTF() macro for this. And we can
> > > > make that macro use bpf_trace_printk() transparently for <3 args, so
> > > > that new macro works on old kernels.
> > >
> > > Cannot we change the existing bpf_printk() macro to work on old and new kernels?
> >
> > Only if we break backwards compatibility. And I only know how to
> > detect the presence of new helper with CO-RE, which automatically
> > makes any BPF program using this macro CO-RE-dependent, which might
> > not be what users want (vmlinux BTF is still not universally
> > available). If I could do something like that without breaking change
> > and without CO-RE, I'd update bpf_printk() to use `const char *fmt`
> > for format string a long time ago. But adding CO-RE dependency for
> > bpf_printk() seems like a no-go.
>
> I see. Naming is the hardest.
> I think Dave's current choice of lower case bpf_vprintk() macro and
> bpf_trace_vprintk()
> helper fits the existing bpf_printk/bpf_trace_printk the best.
> Yes, it's inconsistent with BPF_SEQ_PRINTF/BPF_SNPRINTF,
> but consistent with trace_printk. Whichever way we go it will be inconsistent.
> Stylistically I like the lower case macro, since it doesn't scream at me.

Ok, it's fine. Even more so because we don't need a new macro, we can
just extend the existing bpf_printk() macro to automatically pick
bpf_trace_printk() if more than 3 arguments is provided.

Dave, you'll have to solve a bit of a puzzle macro-wise, but it's
possible to use either bpf_trace_printk() or bpf_trace_vprintk()
transparently for the user.

The only downside is that for <3 args, for backwards compatibility,
we'd have to stick to

char ___fmt[] = fmt;

vs more efficient

static const char ___fmt[] = fmt;

But I'm thinking it might be time to finally make this improvement. We
can also allow users to fallback to less efficient ways for really old
kernels with some extra flag, like so

#ifdef BPF_NO_GLOBAL_DATA
char ___fmt[] = fmt;
#else
static const char ___fmt[] = fmt;
#end

Thoughts?
