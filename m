Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEC8259F61
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 21:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732047AbgIATrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 15:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbgIATrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 15:47:16 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F1CC061247
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 12:47:15 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id i26so3346454ejb.12
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 12:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kTur4TszHq9523qD6iPQQf45ohXDEUrbbOabBCfKuUw=;
        b=CWzyYuoBpHyopcW6UGJzCRrbzhPmoxUBaCxI7bRNujUqWrF5to/QhuZqjrS7nxWu0W
         jAbOrW/VUjLw5eCygcxnnz4+H4WcP4zPwj0aufjfMcS7bjx3wkayFffr7Z6u5k2s8TFD
         8tXV8kM+VzEYM9fO8VnSzWieJ5cQoi7lXniCotDInsAEJFLJ7zfDy2L/kUH4emO0IlvH
         gpqmf3HLFgBRudRPyT4CD2lBOGN0UFZiJ0WwVcUE7jm9LSNP+IE3hPw9g59DEqCzfSEL
         THiflFVqtJ+7m5QY2g3VNZ5cZdTzYUjw1h86UqHsaXiHTetSrbuY9+PWlnuAGvW1/UM7
         Af1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kTur4TszHq9523qD6iPQQf45ohXDEUrbbOabBCfKuUw=;
        b=DXiA7bLf8h7Oe2X2uuFvjOxtWf1YJEMmJcJVhPevW/lp9ATccvJQuJ4wN3YDYxjUtp
         GaCbQAr8/9leVcvDxaXpFx5pof+v6aMdvKZiY03Fa8SCKYnlHBVhLzzzWATOhcZrP0CX
         z5QSJMBG+Hh2FVq1n5M8zeT13OUGAyDSPto7EiuNkwv/QHitKlho4/FIarnCdONLPm4I
         sKJWmsT0n1DAsyXbbSht4jjV/a+QwC5gx5CenRjJ3QK0wyNcH3iCwFv4/djq8QY4ois7
         B+NSXIJwHSTg+dO2nV8ERlR2aoQWIcOTmd0gbR9Q76pJqx2r0G4pckK3Za3SIfqVS0hJ
         ZGSA==
X-Gm-Message-State: AOAM531xy61QHmD3+GxaOAS8pFOnGRfXC/ocM7x6sm95TtVh6sHq3yom
        tlWED4+Ae93WiwTuTWNeiO0pO3+aZvvxVa98TQYGoQ==
X-Google-Smtp-Source: ABdhPJzf8T7FXtY0Q7Fx2epgXAQyimHZxDg5Mh5UyXW9wn394/QoJXCbMs9CPXEix3VkOUNcTb7yISndZZ2r4JYr/AI=
X-Received: by 2002:a17:906:a209:: with SMTP id r9mr3270866ejy.413.1598989633789;
 Tue, 01 Sep 2020 12:47:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-9-haoluo@google.com>
 <CAEf4BzYC0JRQusCxTrmraYQC7SZdkVjdy8DMUNECKwCbXP9-dw@mail.gmail.com>
 <CA+khW7jYWNT5aVe5vCinw5qwKKoB0w386qz2g+0ndv1LeeoGGg@mail.gmail.com> <CAEf4Bza5+m72JQ1Q3a2GRetGB7C-Zemvd-ib0u_VKC2nrYkgdQ@mail.gmail.com>
In-Reply-To: <CAEf4Bza5+m72JQ1Q3a2GRetGB7C-Zemvd-ib0u_VKC2nrYkgdQ@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Tue, 1 Sep 2020 12:47:02 -0700
Message-ID: <CA+khW7iP+BsXnNg0E-K3npR74FqV0b+oHo9j27ymKWobi-QBVw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 8/8] bpf/selftests: Test for bpf_per_cpu_ptr()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 11:12 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Aug 27, 2020 at 8:42 PM Hao Luo <haoluo@google.com> wrote:
> >
[...]
> > > >
> > > > -extern const struct rq runqueues __ksym; /* struct type global var. */
> > > > +extern const struct rq runqueues __ksym; /* struct type percpu var. */
> > > >  extern const int bpf_prog_active __ksym; /* int type global var. */
> > > > +extern const unsigned long process_counts __ksym; /* int type percpu var. */
> > > >
> > > >  SEC("raw_tp/sys_enter")
> > > >  int handler(const void *ctx)
> > > >  {
> > > > +       struct rq *rq;
> > > > +       unsigned long *count;
> > > > +
> > > >         out__runqueues = (__u64)&runqueues;
> > > >         out__bpf_prog_active = (__u64)&bpf_prog_active;
> > > >
> > > > +       rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, 1);
> > > > +       if (rq)
> > > > +               out__rq_cpu = rq->cpu;
> > >
> > > this is awesome!
> > >
> > > Are there any per-cpu variables that are arrays? Would be nice to test
> > > those too.
> > >
> > >
> >
> > There are currently per-cpu arrays, but not common. There is a
> > 'pmc_prev_left' in arch/x86, I can add that in this test.
>
> arch-specific variables are bad, because selftests will be failing on
> other architectures; let's not do this then.
>

Yeah, no problem. Though not going to add this arch-specific variable
in the posted patches, I tried array-typed ksyms locally in my test
environment. It worked fine, except that the array size is not
checked. For instance, if there is a percpu array in kernel as

DEFINE_PER_CPU(u32[64], foo);

we can declare a ksym of different size and it passes libbpf checks
and kernel verification.

extern u32 foo[128] __ksyms;

It seems that bpf_core_types_are_compat() doesn't check nr_elem. But
it seems the kernel verifier does check out-of-bounds accesses, so
this may not be a real problem. Just want to list what I saw.

> >
> > [...]
