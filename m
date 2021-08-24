Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EAB3F68F6
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 20:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhHXSSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 14:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhHXSSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 14:18:31 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E91C061757;
        Tue, 24 Aug 2021 11:17:46 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id k24so20553941pgh.8;
        Tue, 24 Aug 2021 11:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K6xsPczp5p4sylJR4HjPDsGgmUJ090Eb3sXPSU4OcVY=;
        b=cE2hpj69HNW0lpbsw3GNdp2PCvgjkSD74QhjmH/j+ijPf1WsidkC+TiNJmtvvvNs6Q
         tSsYAgX0JB6IbG4QBJ94K029cyy6PKLsuv9mR/ec5NbWKPJjB+zdj8RIqXypZWyEDsVB
         8o7nknGu7d/vNc6SS9UTGW4Nuf+sHDNLcKkL+1pa9i7YqvqExsm8G4ieP7XVRHC46hb3
         6juZXBU7DyCA4R5FlemgqrKXkNKhYQ+2EXhdQwZe2hR9ForIi+5u0E2CnbWF/Ydr4Y6q
         yJe2AWMZAo0uU5pOKxHRI/pR0R0MXcj+dxn5hixQB8PVXndp7jkgJ0EqfjeXKQiLVmmi
         NYEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K6xsPczp5p4sylJR4HjPDsGgmUJ090Eb3sXPSU4OcVY=;
        b=eynBPsWpX8jADalmNbNPi5enT4LOdx34TXQ3YnVHptuIuAH4GwFPYAzdbl+fBECpOw
         kYcmQhrb+GmXo73tHIa+z8g5VrvdBMqBZqEsmdaYZNiF8Qv+wuyV4vHhCGZ3i0lTfSYe
         Rp/GKI8SGhnaQmItOvrBiqTGJX4Ocm/awzM2QCHPoR4711fZSpYUdsrffgw2j1lqysW7
         T6vxt7Knrswc/hJ9JBMcE7Edl7zoF0QogT50UQyvFOLMe9vfh7TFktdVSfXdZKfJjjX5
         wkDU5BDZaIdnEeUzoDveR7U0iYvORoFxzewre2N2kh+0F+L16aZiNBuoWMgQG0nTEmBp
         lZgg==
X-Gm-Message-State: AOAM5315SODzeoVuE1Cd66ESLiBB5WpnehWnTVnsNgUkR9xacR3HECtl
        t3ofhC4UUFNb1KcmHobmJ+K0JfVVNNZkXu6DN2w=
X-Google-Smtp-Source: ABdhPJzlz61PNVdo9lPSPLCCnl1o17ty5jmNBBFQgU75ZcsL9oha/WfLLYDgA3bXWOP+zKqb7YA+TYBVC6Qh9D2pLHg=
X-Received: by 2002:aa7:8754:0:b0:3e2:1de:4f92 with SMTP id
 g20-20020aa78754000000b003e201de4f92mr40630085pfo.16.1629829066232; Tue, 24
 Aug 2021 11:17:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210821025837.1614098-1-davemarchevsky@fb.com>
 <20210821025837.1614098-3-davemarchevsky@fb.com> <CAEf4BzYEOzfmwi8n8K_W_6Pc+gC081ncmRCAq8Fz0vr=y7eMcg@mail.gmail.com>
 <CAADnVQLUWHO0EhLhMVATc9-z11H7ROF6DCmJ=sW+-iP1baeWWg@mail.gmail.com> <CAEf4Bza30Rkg02AzmG7Mw5AyE1wykPBuH6f_fXAQXLu2qH2POA@mail.gmail.com>
In-Reply-To: <CAEf4Bza30Rkg02AzmG7Mw5AyE1wykPBuH6f_fXAQXLu2qH2POA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 24 Aug 2021 11:17:35 -0700
Message-ID: <CAADnVQ+Kxei6_q4PWQ57zVr86gKqu=4s07Y1Kwy9SNz__PWYdQ@mail.gmail.com>
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

On Tue, Aug 24, 2021 at 11:02 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Aug 24, 2021 at 10:57 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Aug 23, 2021 at 9:50 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Fri, Aug 20, 2021 at 7:59 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
> > > >
> > > > This helper is meant to be "bpf_trace_printk, but with proper vararg
> > >
> > > We have bpf_snprintf() and bpf_seq_printf() names for other BPF
> > > helpers using the same approach. How about we call this one simply
> > > `bpf_printf`? It will be in line with other naming, it is logical BPF
> > > equivalent of user-space printf (which outputs to stderr, which in BPF
> > > land is /sys/kernel/debug/tracing/trace_pipe). And it will be logical
> > > to have a nice and short BPF_PRINTF() convenience macro provided by
> > > libbpf.
> > >
> > > > support". Follow bpf_snprintf's example and take a u64 pseudo-vararg
> > > > array. Write to dmesg using the same mechanism as bpf_trace_printk.
> > >
> > > Are you sure about the dmesg part?... bpf_trace_printk is outputting
> > > into /sys/kernel/debug/tracing/trace_pipe.
> >
> > Actually I like bpf_trace_vprintk() name, since it makes it obvious that
>
> It's the inconsistency with bpf_snprintf() and bpf_seq_printf() that's
> mildly annoying (it's f at the end, and no v- prefix). Maybe
> bpf_trace_printf() then? Or is it too close to bpf_trace_printk()?

bpf_trace_printf could be ok, but see below.

> But
> either way you would be using BPF_PRINTF() macro for this. And we can
> make that macro use bpf_trace_printk() transparently for <3 args, so
> that new macro works on old kernels.

Cannot we change the existing bpf_printk() macro to work on old and new kernels?
So bpf_printk() would use bpf_trace_printf() on new and
bpf_trace_printk() on old?
I think bpf_trace_vprintk() looks cleaner in this context if we reuse
bpf_printk() macro.
