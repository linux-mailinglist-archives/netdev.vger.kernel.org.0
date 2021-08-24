Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420583F6B00
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbhHXV3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbhHXV3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:29:48 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4E1C061757;
        Tue, 24 Aug 2021 14:29:03 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id a5so13060772plh.5;
        Tue, 24 Aug 2021 14:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R4j615OZaMu2Chi/1Ezy9Ev2hUd100VaJBKaj5Pnvng=;
        b=WZ7qvbgdmoeN3nuzDmPSfajhG7GNqQunszLjPajQ/geEvwTTA6Q2FoTUpYnK3WsaSI
         r1hjX7z7OdUyZX7C4NP3VZkEzi9DDth+Lh5NRlv5q3xEtnZcP3YNAX82RUdhuAVCZQhw
         oSFxXfRPZLUHsxrkLMAF1n8baGFq0lCR+qO/fW2N3fKPJI7skzcbq9lbjeI4KvLQwT3W
         O53kIq3Qj1RmZeopU2IXyPARjh3fgIDZgKNFlZmH/WslQCbwxTkuLX9Ebnj4Sefnxn8N
         rYBmu24Y0S08PFVclZEcXUnAJ9hQtEoHUN4eKGQ7L5L0T+B6dONI/1/AenhpPDAIoAXo
         5EUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R4j615OZaMu2Chi/1Ezy9Ev2hUd100VaJBKaj5Pnvng=;
        b=RjAvnnZ1pVj09RaqvLVpCt1V+0nVIXNIjJmuvaGrNrX42GTZyaZQ9f8J4tgfRp9lCN
         dPwxR3Nd6iSUeaBqa1v7G4cmOxLWlP1su8inS7m2mqakeyiM0bxGAOqFJIcNRBTD+G4s
         GG7+9thbi6VbhFDS9VFU4ORS4ORP3WyQdP/naqIl467+vwLGpW4dOYWFQbCOWhVEO59r
         rSSgmgMvUX48wrIp6+8reQMqVis9C2cKacegn9ugv0HIQjuONhZpWP24PD8FUO7v+4SN
         mGGm8pZOsVZhCLaYe89BIh1pEMwOORVJVOQO1KlxojBi1DbAS/Vm9vPchtEpmBgHMpss
         fJQA==
X-Gm-Message-State: AOAM5322FI7F1JCEv+G/aJo5DcX5ORpqDHjUx8WeKmfMk8LK4NDnpVxt
        WrtHxzHN8nvWJ1zPobwBaRLWxvoFq57SNW/zAIw=
X-Google-Smtp-Source: ABdhPJwL+QMcCwxBwlme63E9hugypiaghoBFJfpg78sfqxpzlM5ctspsVO8yO7dvdcDL/pEeGDguRauhBcj+UduC1gI=
X-Received: by 2002:a17:90a:6009:: with SMTP id y9mr6558517pji.93.1629840543001;
 Tue, 24 Aug 2021 14:29:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210821025837.1614098-1-davemarchevsky@fb.com>
 <20210821025837.1614098-3-davemarchevsky@fb.com> <CAEf4BzYEOzfmwi8n8K_W_6Pc+gC081ncmRCAq8Fz0vr=y7eMcg@mail.gmail.com>
 <CAADnVQLUWHO0EhLhMVATc9-z11H7ROF6DCmJ=sW+-iP1baeWWg@mail.gmail.com>
 <CAEf4Bza30Rkg02AzmG7Mw5AyE1wykPBuH6f_fXAQXLu2qH2POA@mail.gmail.com>
 <CAADnVQ+Kxei6_q4PWQ57zVr86gKqu=4s07Y1Kwy9SNz__PWYdQ@mail.gmail.com>
 <CAEf4BzbU6xt49+VYSDGoXonOMdB3SPDdh_sr2pTeUC66sT3kPw@mail.gmail.com>
 <CAADnVQL_6XNoUaO_J43OSfyirjRRLUgK7B18BVopd49suUJt6A@mail.gmail.com> <CAEf4BzZf84FWnrz7zimcW0tw-k1im6kaJJ+g6ypzushXEb3oeA@mail.gmail.com>
In-Reply-To: <CAEf4BzZf84FWnrz7zimcW0tw-k1im6kaJJ+g6ypzushXEb3oeA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 24 Aug 2021 14:28:52 -0700
Message-ID: <CAADnVQLV7UGpxiNEphZKodMzdVheAaw1pmLechupevBifBF0OA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] bpf: add bpf_trace_vprintk helper
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Tue, Aug 24, 2021 at 2:24 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Aug 24, 2021 at 2:00 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Aug 24, 2021 at 11:24 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Tue, Aug 24, 2021 at 11:17 AM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Tue, Aug 24, 2021 at 11:02 AM Andrii Nakryiko
> > > > <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > On Tue, Aug 24, 2021 at 10:57 AM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, Aug 23, 2021 at 9:50 PM Andrii Nakryiko
> > > > > > <andrii.nakryiko@gmail.com> wrote:
> > > > > > >
> > > > > > > On Fri, Aug 20, 2021 at 7:59 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
> > > > > > > >
> > > > > > > > This helper is meant to be "bpf_trace_printk, but with proper vararg
> > > > > > >
> > > > > > > We have bpf_snprintf() and bpf_seq_printf() names for other BPF
> > > > > > > helpers using the same approach. How about we call this one simply
> > > > > > > `bpf_printf`? It will be in line with other naming, it is logical BPF
> > > > > > > equivalent of user-space printf (which outputs to stderr, which in BPF
> > > > > > > land is /sys/kernel/debug/tracing/trace_pipe). And it will be logical
> > > > > > > to have a nice and short BPF_PRINTF() convenience macro provided by
> > > > > > > libbpf.
> > > > > > >
> > > > > > > > support". Follow bpf_snprintf's example and take a u64 pseudo-vararg
> > > > > > > > array. Write to dmesg using the same mechanism as bpf_trace_printk.
> > > > > > >
> > > > > > > Are you sure about the dmesg part?... bpf_trace_printk is outputting
> > > > > > > into /sys/kernel/debug/tracing/trace_pipe.
> > > > > >
> > > > > > Actually I like bpf_trace_vprintk() name, since it makes it obvious that
> > > > >
> > > > > It's the inconsistency with bpf_snprintf() and bpf_seq_printf() that's
> > > > > mildly annoying (it's f at the end, and no v- prefix). Maybe
> > > > > bpf_trace_printf() then? Or is it too close to bpf_trace_printk()?
> > > >
> > > > bpf_trace_printf could be ok, but see below.
> > > >
> > > > > But
> > > > > either way you would be using BPF_PRINTF() macro for this. And we can
> > > > > make that macro use bpf_trace_printk() transparently for <3 args, so
> > > > > that new macro works on old kernels.
> > > >
> > > > Cannot we change the existing bpf_printk() macro to work on old and new kernels?
> > >
> > > Only if we break backwards compatibility. And I only know how to
> > > detect the presence of new helper with CO-RE, which automatically
> > > makes any BPF program using this macro CO-RE-dependent, which might
> > > not be what users want (vmlinux BTF is still not universally
> > > available). If I could do something like that without breaking change
> > > and without CO-RE, I'd update bpf_printk() to use `const char *fmt`
> > > for format string a long time ago. But adding CO-RE dependency for
> > > bpf_printk() seems like a no-go.
> >
> > I see. Naming is the hardest.
> > I think Dave's current choice of lower case bpf_vprintk() macro and
> > bpf_trace_vprintk()
> > helper fits the existing bpf_printk/bpf_trace_printk the best.
> > Yes, it's inconsistent with BPF_SEQ_PRINTF/BPF_SNPRINTF,
> > but consistent with trace_printk. Whichever way we go it will be inconsistent.
> > Stylistically I like the lower case macro, since it doesn't scream at me.
>
> Ok, it's fine. Even more so because we don't need a new macro, we can
> just extend the existing bpf_printk() macro to automatically pick
> bpf_trace_printk() if more than 3 arguments is provided.
>
> Dave, you'll have to solve a bit of a puzzle macro-wise, but it's
> possible to use either bpf_trace_printk() or bpf_trace_vprintk()
> transparently for the user.
>
> The only downside is that for <3 args, for backwards compatibility,
> we'd have to stick to
>
> char ___fmt[] = fmt;
>
> vs more efficient
>
> static const char ___fmt[] = fmt;
>
> But I'm thinking it might be time to finally make this improvement. We
> can also allow users to fallback to less efficient ways for really old
> kernels with some extra flag, like so
>
> #ifdef BPF_NO_GLOBAL_DATA
> char ___fmt[] = fmt;
> #else
> static const char ___fmt[] = fmt;
> #end
>
> Thoughts?

+1 from me for the latter assuming macro magic is possible.
