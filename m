Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F183F6908
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 20:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbhHXSZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 14:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhHXSZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 14:25:30 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003A0C061764;
        Tue, 24 Aug 2021 11:24:45 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id q70so26627834ybg.11;
        Tue, 24 Aug 2021 11:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P4XKEDVshvZ6mRCpA96uYzQxuCPzHu8v7URpToKGGfI=;
        b=RI6YnTmUvPwOZrHhC6zq2WoBXCIXbNELNmUJLU3UnOpLIYXgNs1b8Ri4XPjOyZ2oPS
         GUqPBBXJdmEqM8HjrV8QsD5c1HQ1lv88q+UACqEb6xdZlE7QfCofBm3wiSogl478PHM8
         CZ0D9HFVAtRIEKe9XwiLhRnZK1Rw5RryaDS0utmfZlJ6uwUcRGkXSHyPfvmHwavGOjLZ
         TCdHrrG9vmx298Wa04ngje3V09EJJwP/hZokaJHJIwBokmwN3RWzWJ4VnO66dx5IL5hO
         BKxJTo/OXvY/t5NT/D87zLlJ9hLxaCJluDWPNHIGYHy4VKHqGygVDzr5AK2brTAYZAE5
         Qf5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P4XKEDVshvZ6mRCpA96uYzQxuCPzHu8v7URpToKGGfI=;
        b=aEQBun9lDGWLKa0bPZjYP9xxdEeTmkMBScHKba4o4F++ij5v4dOnn8P0wG0x6YlBxn
         pkcg5/0mKmF94IOnd8sYtxmUSLCp69UZcbnVRo28sn+i2OoBZzeCBYT1y364059vHmJE
         gL3T5ba0VJH0jBRwkituezPmPRWPGeFT9lyrJS7VsnyjHzrpC3G97Bs6IUar+Vsjz7uC
         C8uXxUhCoKWdVeBaMSoJOI3xjFneKOfDb5R/Ihoo18NAw/ldFMVqXSW3W0FFps6LdauE
         BOnsj9Yx5SntzDQ3RFFKa+kCdFntVZcbmXLBscXBSEDAMtzAVtsAi0hrmilEdJYxxoYO
         W6xQ==
X-Gm-Message-State: AOAM530950XacFwh+ONbemZa+OYmcXuDPSnlwjuch95jdalSXMT4WjOo
        yB4FwN6QX1GxrJaVp5EPwoePiWZkBAD5iiF3SWw=
X-Google-Smtp-Source: ABdhPJyg9+JntaD9Y+zvdFtgLUZCtvUcBlxuswgnnLasJRbdJkRTFDNEyqdZPXY+3NTmO7zhkYI5tg2zIsCeT6utHP0=
X-Received: by 2002:a25:bb13:: with SMTP id z19mr54535514ybg.347.1629829485212;
 Tue, 24 Aug 2021 11:24:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210821025837.1614098-1-davemarchevsky@fb.com>
 <20210821025837.1614098-3-davemarchevsky@fb.com> <CAEf4BzYEOzfmwi8n8K_W_6Pc+gC081ncmRCAq8Fz0vr=y7eMcg@mail.gmail.com>
 <CAADnVQLUWHO0EhLhMVATc9-z11H7ROF6DCmJ=sW+-iP1baeWWg@mail.gmail.com>
 <CAEf4Bza30Rkg02AzmG7Mw5AyE1wykPBuH6f_fXAQXLu2qH2POA@mail.gmail.com> <CAADnVQ+Kxei6_q4PWQ57zVr86gKqu=4s07Y1Kwy9SNz__PWYdQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+Kxei6_q4PWQ57zVr86gKqu=4s07Y1Kwy9SNz__PWYdQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 24 Aug 2021 11:24:34 -0700
Message-ID: <CAEf4BzbU6xt49+VYSDGoXonOMdB3SPDdh_sr2pTeUC66sT3kPw@mail.gmail.com>
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

On Tue, Aug 24, 2021 at 11:17 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 24, 2021 at 11:02 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Aug 24, 2021 at 10:57 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Mon, Aug 23, 2021 at 9:50 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Fri, Aug 20, 2021 at 7:59 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
> > > > >
> > > > > This helper is meant to be "bpf_trace_printk, but with proper vararg
> > > >
> > > > We have bpf_snprintf() and bpf_seq_printf() names for other BPF
> > > > helpers using the same approach. How about we call this one simply
> > > > `bpf_printf`? It will be in line with other naming, it is logical BPF
> > > > equivalent of user-space printf (which outputs to stderr, which in BPF
> > > > land is /sys/kernel/debug/tracing/trace_pipe). And it will be logical
> > > > to have a nice and short BPF_PRINTF() convenience macro provided by
> > > > libbpf.
> > > >
> > > > > support". Follow bpf_snprintf's example and take a u64 pseudo-vararg
> > > > > array. Write to dmesg using the same mechanism as bpf_trace_printk.
> > > >
> > > > Are you sure about the dmesg part?... bpf_trace_printk is outputting
> > > > into /sys/kernel/debug/tracing/trace_pipe.
> > >
> > > Actually I like bpf_trace_vprintk() name, since it makes it obvious that
> >
> > It's the inconsistency with bpf_snprintf() and bpf_seq_printf() that's
> > mildly annoying (it's f at the end, and no v- prefix). Maybe
> > bpf_trace_printf() then? Or is it too close to bpf_trace_printk()?
>
> bpf_trace_printf could be ok, but see below.
>
> > But
> > either way you would be using BPF_PRINTF() macro for this. And we can
> > make that macro use bpf_trace_printk() transparently for <3 args, so
> > that new macro works on old kernels.
>
> Cannot we change the existing bpf_printk() macro to work on old and new kernels?

Only if we break backwards compatibility. And I only know how to
detect the presence of new helper with CO-RE, which automatically
makes any BPF program using this macro CO-RE-dependent, which might
not be what users want (vmlinux BTF is still not universally
available). If I could do something like that without breaking change
and without CO-RE, I'd update bpf_printk() to use `const char *fmt`
for format string a long time ago. But adding CO-RE dependency for
bpf_printk() seems like a no-go.

> So bpf_printk() would use bpf_trace_printf() on new and
> bpf_trace_printk() on old?
> I think bpf_trace_vprintk() looks cleaner in this context if we reuse
> bpf_printk() macro.
