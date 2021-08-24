Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C563F6ABA
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbhHXVA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhHXVA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:00:58 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB92C061757;
        Tue, 24 Aug 2021 14:00:14 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id u15so12974646plg.13;
        Tue, 24 Aug 2021 14:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4PeJVRJEQrcQS/xSOFl809fBPMW5vFyiEmaRx1X5lyE=;
        b=XN8lkNvEd6ydysVM+LH/FmMWEeggim3nhHBNXMHTrMSK0ERwIMxdnq5kabqp6MdsBV
         XVEym4xvA+erdUX7GcdaLWc9xS5GaeHwD2Wmyh07ogWqDonJa/40jFqj9u6YZlP1rxXA
         bxVOCeBk0zh6R6chhJVC2vNfUaIrw6LiTUT2/nBsaJkfh1gGZAvPJuOEBuZBTaAv362B
         ggy0r8WROngzZGDJg6fp7/6km5V7tRibaK+rCMuoypamxRKWFSGDzgAMILn7v1HZqY61
         VU4KHmitxihR9jqAtakyQw0UyUiu7czS/HsUZRnfX9FoQzECBXDy1B5KZR+kzbLaWbRB
         B2xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4PeJVRJEQrcQS/xSOFl809fBPMW5vFyiEmaRx1X5lyE=;
        b=i/D89Pk88gczDYu6nj+M7r5fNnlFjRWLijp7lPu1br+SXYAjfqMtTGtBmmbCct8y2i
         p7o4xxvnsX+CgQO3gIAOdVSSvEAz9FbooCEYqFWG5YxHc/tqmVfIApnLEVj/hIQ2VyOW
         +ms7yNvitCB8/C1jVDUlzg+FtJvznNTkRdyoe4obZmrgSLEbY57Gdmg2O+1YKbPQrUTC
         +TcVnONSR4Yqq6XYfQvXJrikam9St4l6AzTlqI6rPr04j+4eKnUj6VSSi2rN5mNoxrpO
         bjFusLd5c/kVhDwri8LqMZBGhgkeH6vL9sl3Pb2t+TxGY8B8PhZgCbcL0U1ARypPrsYZ
         twZQ==
X-Gm-Message-State: AOAM533xn+nG9I4MivPEQpQGnKo2vP4NCTfeIuoGFempmB+Muqgrm090
        XKS1ZXdMMi1uBXLSg8ZfM+sWbvL63LgbtxuXt7c=
X-Google-Smtp-Source: ABdhPJydXrZQQlG4uKkcAfPelbgjar1XWVYgDGe3i6bThzMbqa3I/ldT45oQNpMx3lnElciMHdWaaanIJoK6kB503gk=
X-Received: by 2002:a17:902:82c6:b0:136:59b0:ed17 with SMTP id
 u6-20020a17090282c600b0013659b0ed17mr4332817plz.61.1629838813533; Tue, 24 Aug
 2021 14:00:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210821025837.1614098-1-davemarchevsky@fb.com>
 <20210821025837.1614098-3-davemarchevsky@fb.com> <CAEf4BzYEOzfmwi8n8K_W_6Pc+gC081ncmRCAq8Fz0vr=y7eMcg@mail.gmail.com>
 <CAADnVQLUWHO0EhLhMVATc9-z11H7ROF6DCmJ=sW+-iP1baeWWg@mail.gmail.com>
 <CAEf4Bza30Rkg02AzmG7Mw5AyE1wykPBuH6f_fXAQXLu2qH2POA@mail.gmail.com>
 <CAADnVQ+Kxei6_q4PWQ57zVr86gKqu=4s07Y1Kwy9SNz__PWYdQ@mail.gmail.com> <CAEf4BzbU6xt49+VYSDGoXonOMdB3SPDdh_sr2pTeUC66sT3kPw@mail.gmail.com>
In-Reply-To: <CAEf4BzbU6xt49+VYSDGoXonOMdB3SPDdh_sr2pTeUC66sT3kPw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 24 Aug 2021 14:00:02 -0700
Message-ID: <CAADnVQL_6XNoUaO_J43OSfyirjRRLUgK7B18BVopd49suUJt6A@mail.gmail.com>
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

On Tue, Aug 24, 2021 at 11:24 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Aug 24, 2021 at 11:17 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Aug 24, 2021 at 11:02 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Tue, Aug 24, 2021 at 10:57 AM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Mon, Aug 23, 2021 at 9:50 PM Andrii Nakryiko
> > > > <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > On Fri, Aug 20, 2021 at 7:59 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
> > > > > >
> > > > > > This helper is meant to be "bpf_trace_printk, but with proper vararg
> > > > >
> > > > > We have bpf_snprintf() and bpf_seq_printf() names for other BPF
> > > > > helpers using the same approach. How about we call this one simply
> > > > > `bpf_printf`? It will be in line with other naming, it is logical BPF
> > > > > equivalent of user-space printf (which outputs to stderr, which in BPF
> > > > > land is /sys/kernel/debug/tracing/trace_pipe). And it will be logical
> > > > > to have a nice and short BPF_PRINTF() convenience macro provided by
> > > > > libbpf.
> > > > >
> > > > > > support". Follow bpf_snprintf's example and take a u64 pseudo-vararg
> > > > > > array. Write to dmesg using the same mechanism as bpf_trace_printk.
> > > > >
> > > > > Are you sure about the dmesg part?... bpf_trace_printk is outputting
> > > > > into /sys/kernel/debug/tracing/trace_pipe.
> > > >
> > > > Actually I like bpf_trace_vprintk() name, since it makes it obvious that
> > >
> > > It's the inconsistency with bpf_snprintf() and bpf_seq_printf() that's
> > > mildly annoying (it's f at the end, and no v- prefix). Maybe
> > > bpf_trace_printf() then? Or is it too close to bpf_trace_printk()?
> >
> > bpf_trace_printf could be ok, but see below.
> >
> > > But
> > > either way you would be using BPF_PRINTF() macro for this. And we can
> > > make that macro use bpf_trace_printk() transparently for <3 args, so
> > > that new macro works on old kernels.
> >
> > Cannot we change the existing bpf_printk() macro to work on old and new kernels?
>
> Only if we break backwards compatibility. And I only know how to
> detect the presence of new helper with CO-RE, which automatically
> makes any BPF program using this macro CO-RE-dependent, which might
> not be what users want (vmlinux BTF is still not universally
> available). If I could do something like that without breaking change
> and without CO-RE, I'd update bpf_printk() to use `const char *fmt`
> for format string a long time ago. But adding CO-RE dependency for
> bpf_printk() seems like a no-go.

I see. Naming is the hardest.
I think Dave's current choice of lower case bpf_vprintk() macro and
bpf_trace_vprintk()
helper fits the existing bpf_printk/bpf_trace_printk the best.
Yes, it's inconsistent with BPF_SEQ_PRINTF/BPF_SNPRINTF,
but consistent with trace_printk. Whichever way we go it will be inconsistent.
Stylistically I like the lower case macro, since it doesn't scream at me.
