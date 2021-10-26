Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606C843AA0A
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 03:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhJZB7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 21:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhJZB7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 21:59:53 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DFCC061745;
        Mon, 25 Oct 2021 18:57:30 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id w10so15180539ilc.13;
        Mon, 25 Oct 2021 18:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h1mFkqw1bYSFeCSrd/PEtQdSLUT1fyZYNbF/5Y+ggX8=;
        b=MwNfeqG2aIp1bt36kgpdSUAwOlAC6WEpYKTinXDmuGHvBvwPfR3h7B0nbR9mI3G9XV
         4tS7PwJgWjgJ6/s3PYwCC/gbeM67Ofj22f56oaF5LRWRRZi50oq781H0CzOaA3QhvD3D
         DpF3nJ+LB3ABE51rgVQSBySmLhezzoci6ofwgJDEgXZRm1s2uwdWyB646pDAPLjDOsWo
         5UlQde3obRCPFYkzcrw1qC3BJa1C/eloF6aGI6lTUX+/2jRTZktBqe8GbT33W1OkVMip
         bp+V/0ju65JpOXFygFAjrHZPlB8qK2p/d3aduS4GRYQQytcd39NpS0FzO+hP6Chi6Hpe
         dawA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h1mFkqw1bYSFeCSrd/PEtQdSLUT1fyZYNbF/5Y+ggX8=;
        b=5FA6lSsVwa1KpOp4YF6F0W5sMj8riAX7GO9JS8JqQ48JVSrBz/ajjYqxmnDicd5Uk0
         NuUAN2j0wqCJc5BFG1rdpuBX8g0IECXq9dBfvC10VULLNK2p54VUwLousHwGolB7seRq
         GiDQtKRGkZ8wAwYpOYNl7UYRpKTR+uwMFgtRE+LK7HIDQ4BtooErdBR/NUaf6X5v8YwJ
         G5OqnsfIJC208Vzymd+7Ub7K7cy18nBL/+kah5rwRYxj8inYWFbSqQdLoWC6HRvkfCWC
         MrHNsXL8tvXwS1TQTkAE4MucNEcTEGkflCZ4F3uayXUDy/yxUiLwd6oCwPmlT6pszYig
         GW9Q==
X-Gm-Message-State: AOAM532Unm4wiBJfufE2RhER7IIbKeH0+su+ems/VA5KwuX8z4+jhNCg
        mNp2b9TiFQdRj+kD9zH8KHJNYtCRFztpPGymYCg=
X-Google-Smtp-Source: ABdhPJwHUG7WEz08Z8XERQPU7oIm9JZmJrAVZWUlfDNKkrt5XkUcnFIX776HdHhY+ONTUXiXDv4QL+xeFeg1LnRgGFk=
X-Received: by 2002:a05:6e02:20e7:: with SMTP id q7mr13181212ilv.254.1635213449350;
 Mon, 25 Oct 2021 18:57:29 -0700 (PDT)
MIME-Version: 1.0
References: <20211025083315.4752-1-laoar.shao@gmail.com> <20211025083315.4752-8-laoar.shao@gmail.com>
 <202110251421.0CD56F8@keescook>
In-Reply-To: <202110251421.0CD56F8@keescook>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 26 Oct 2021 09:56:53 +0800
Message-ID: <CALOAHbAqu3zrFiu-36dnPw-Jchz_Be9W_AbSFXFYsH0kNacGeg@mail.gmail.com>
Subject: Re: [PATCH v6 07/12] samples/bpf/offwaketime_kern: make sched_switch
 tracepoint args adopt to comm size change
To:     Kees Cook <keescook@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Qiang Zhang <qiang.zhang@windriver.com>,
        robdclark <robdclark@chromium.org>,
        christian <christian@brauner.io>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 5:21 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Oct 25, 2021 at 08:33:10AM +0000, Yafang Shao wrote:
> > The sched:sched_switch tracepoint is derived from kernel, we should make
> > its args compitable with the kernel.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> > Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Petr Mladek <pmladek@suse.com>
> > ---
> >  samples/bpf/offwaketime_kern.c | 4 ++--
>
> Seems this should be merged with the prior bpf samples patch?
>

Sure

>
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/samples/bpf/offwaketime_kern.c b/samples/bpf/offwaketime_kern.c
> > index 4866afd054da..eb4d94742e6b 100644
> > --- a/samples/bpf/offwaketime_kern.c
> > +++ b/samples/bpf/offwaketime_kern.c
> > @@ -113,11 +113,11 @@ static inline int update_counts(void *ctx, u32 pid, u64 delta)
> >  /* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
> >  struct sched_switch_args {
> >       unsigned long long pad;
> > -     char prev_comm[16];
> > +     char prev_comm[TASK_COMM_LEN];
> >       int prev_pid;
> >       int prev_prio;
> >       long long prev_state;
> > -     char next_comm[16];
> > +     char next_comm[TASK_COMM_LEN];
> >       int next_pid;
> >       int next_prio;
> >  };
> > --
> > 2.17.1
> >
>
> --
> Kees Cook



-- 
Thanks
Yafang
