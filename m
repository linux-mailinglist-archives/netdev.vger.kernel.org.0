Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C0A259DE6
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbgIASMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgIASMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:12:41 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A6AC061244;
        Tue,  1 Sep 2020 11:12:39 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id i10so1318415ybt.11;
        Tue, 01 Sep 2020 11:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fo76CB7ot38YXOx7Pt8T2DJw7Wwns+OpublnLmsqW58=;
        b=DWGoneNm1E0H2TB0kRrtrEM4Z6g03YA3r+WDj4ntFFFH9GwIGOGQiGBcyz4KakgYdQ
         ZMsLJWOKJNHY3IVCJ78DN+ZJ49+n/urFRj/hZ0ZwS0CNhqzEA9xo/RYCr+1lR4JZWcgK
         MKFJeUnWuCzkPmZ13p3LNlIaVuLAyrxCMRRM2qzgtrtSBUxlsTVXl8nRNHpuQLpmwJja
         P8osFyO/zEqQde54OD2UC9OmaWuz+yWjzfrRBc6IBKS9N67UWS0qzzCAAiri93W6lRwr
         P5XzlbxVHlpVxbGH8vVEEtYA6RqZUEasi9JUcnrcnXeFRQTud30kGVL9uZsrIToNY7VV
         mXfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fo76CB7ot38YXOx7Pt8T2DJw7Wwns+OpublnLmsqW58=;
        b=CANnVMOTUKyGBwnvJ1+iCWB4XiFO6raobG+DmSGa2Vk7pVo3dC0wQGo50zBRdjfbmv
         OGcusG2yG0JzGcUjL0jKEd4qg9rzjUQQGIZ4PNnzpEpAfeXUk2o6ARDL7vcBKgcG83EE
         q359eb5g5GHbEGLI8QfJZWJKBDQc7HaQ+Uw5v1rmNm2lfRtuZcN9qsptGooivTmcSTPI
         GNtlX+vs/o0lmdF8ssxGB/V/D/C3Z/yNwnHvPTG4Z/XOKhD7tKZsKkW0rOGVe4txR1Yn
         7ky+yx1RA9SwRc4APevdOtosv52euxDNl65MgJKRDzKTwK5fNH9oyIChPg/9VYeHwOj8
         IgHA==
X-Gm-Message-State: AOAM533WZrLGFH0FFE8j6keRsK0SDgukWXKz+SCLNvjE9j2MgjXYqCOQ
        fj7dtx9YrJS7+M0lpaN3F4Nq16QOJLqqaf3uLeE=
X-Google-Smtp-Source: ABdhPJyNWB7lSMY+KzqZEo4eVLNYUtv6CMdaZ2Mlwnslc8xJRr/gmPTZ86hVWzmXcG5pEs8cqD9DnHuTb17F/JIgkFM=
X-Received: by 2002:a25:6885:: with SMTP id d127mr4380112ybc.27.1598983957566;
 Tue, 01 Sep 2020 11:12:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-9-haoluo@google.com>
 <CAEf4BzYC0JRQusCxTrmraYQC7SZdkVjdy8DMUNECKwCbXP9-dw@mail.gmail.com> <CA+khW7jYWNT5aVe5vCinw5qwKKoB0w386qz2g+0ndv1LeeoGGg@mail.gmail.com>
In-Reply-To: <CA+khW7jYWNT5aVe5vCinw5qwKKoB0w386qz2g+0ndv1LeeoGGg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Sep 2020 11:12:26 -0700
Message-ID: <CAEf4Bza5+m72JQ1Q3a2GRetGB7C-Zemvd-ib0u_VKC2nrYkgdQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 8/8] bpf/selftests: Test for bpf_per_cpu_ptr()
To:     Hao Luo <haoluo@google.com>
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

On Thu, Aug 27, 2020 at 8:42 PM Hao Luo <haoluo@google.com> wrote:
>
> Thanks for taking a look!
>
> On Fri, Aug 21, 2020 at 8:30 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Aug 19, 2020 at 3:42 PM Hao Luo <haoluo@google.com> wrote:
> > >
> > > Test bpf_per_cpu_ptr(). Test two paths in the kernel. If the base
> > > pointer points to a struct, the returned reg is of type PTR_TO_BTF_ID.
> > > Direct pointer dereference can be applied on the returned variable.
> > > If the base pointer isn't a struct, the returned reg is of type
> > > PTR_TO_MEM, which also supports direct pointer dereference.
> > >
> > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > ---
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >
> [...]
> > >
> > >  __u64 out__runqueues = -1;
> > >  __u64 out__bpf_prog_active = -1;
> > > +__u32 out__rq_cpu = -1;
> > > +unsigned long out__process_counts = -1;
> >
> > try to not use long for variables, it is 32-bit integer in user-space
> > but always 64-bit in BPF. This causes problems when using skeleton on
> > 32-bit architecture.
> >
>
> Ack. I will use another variable of type 'int' instead.

__u64 is fine as well

>
> > >
> > > -extern const struct rq runqueues __ksym; /* struct type global var. */
> > > +extern const struct rq runqueues __ksym; /* struct type percpu var. */
> > >  extern const int bpf_prog_active __ksym; /* int type global var. */
> > > +extern const unsigned long process_counts __ksym; /* int type percpu var. */
> > >
> > >  SEC("raw_tp/sys_enter")
> > >  int handler(const void *ctx)
> > >  {
> > > +       struct rq *rq;
> > > +       unsigned long *count;
> > > +
> > >         out__runqueues = (__u64)&runqueues;
> > >         out__bpf_prog_active = (__u64)&bpf_prog_active;
> > >
> > > +       rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, 1);
> > > +       if (rq)
> > > +               out__rq_cpu = rq->cpu;
> >
> > this is awesome!
> >
> > Are there any per-cpu variables that are arrays? Would be nice to test
> > those too.
> >
> >
>
> There are currently per-cpu arrays, but not common. There is a
> 'pmc_prev_left' in arch/x86, I can add that in this test.

arch-specific variables are bad, because selftests will be failing on
other architectures; let's not do this then.

>
> [...]
