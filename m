Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5EF43D8CA
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 03:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhJ1Bpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 21:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhJ1Bpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 21:45:54 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A36C061570;
        Wed, 27 Oct 2021 18:43:28 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id v65so6113407ioe.5;
        Wed, 27 Oct 2021 18:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q2MWT3ltBpEutemWMnO5IV+Dli3w0cr7Jk2rYKN1WKo=;
        b=VYaQyXfWM6sOanx3t6qAvPWFfD338jdnTaM7L2F4EXwJrISOsX2ByFuKTHv7xNRkTG
         7BWciBeSY2irXsWhnWRi6OVqJxQs7/ZO79rLcIDs/aiVFWgHfJlvuVpfUToWcVFBDw49
         BCfecdSa2WUEjL+TN94OyEqsucM5rEaK9DgGgCJaOCYNRUwXGRjWaKZseUmGso3F9gxw
         di+uY+S3e+rK3xyX3eI/JiQ9ICTO+6tm+0hZ1D5dbOqVvxb2fQEWj7uSPsf/vcKdxhy1
         StoSWoyz4zwvhiyUgYfxfRiYrspymffEwoasFZiknT2hQbvSdzCZRqpNBiWlqe1b6cj1
         mybQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q2MWT3ltBpEutemWMnO5IV+Dli3w0cr7Jk2rYKN1WKo=;
        b=5GtjatUqJ3P9/HnNIN95alD9Bu6whWZ9XVH5ktL/d+9Y3X89z5iUXVvwstLkiMjlFh
         hC0T0712eP4l1p0mDmyu5STkFNR9g/cCuoBFFLCV62gMSpF4zwqp788gqcLN1dTxVywT
         5qQ9wYhSEAijAef1im6uXAFA2apjq5ewm3Ae2/isLPWeAutvFD1husaS/pkPBIA3dE8t
         KCkzdsFUsrcoaeDGsP6trlq2ypDDWFRtQshtZogN5AyzuTfZE+Gi5lx4/KsOtzrHyWBD
         XM9Dr8AC3LgvMDp0hYdRRLA8ifS6PBqYsQJxe3H0MsMQTWMv0yc2NUF2Pksh870R8cOH
         SO3Q==
X-Gm-Message-State: AOAM533MCB28MCWGOamJ3U8rP8FlBSMyDsmopkaAF7lQwf9LT/NoZXEn
        /S17W2MLejSuW/NLZahlp0d1KcSH8CgbVh6cZdQ=
X-Google-Smtp-Source: ABdhPJwNQClWNir1jhV830HzS4FTBIIlwJORqskR1S8FYGa8OK7RlivKeHpt/M/ZKHGSsheR5GLY1mxrQk02MMgYFuc=
X-Received: by 2002:a02:cb9c:: with SMTP id u28mr1005721jap.95.1635385408343;
 Wed, 27 Oct 2021 18:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <20211025083315.4752-1-laoar.shao@gmail.com> <20211025083315.4752-13-laoar.shao@gmail.com>
 <202110251431.F594652F@keescook> <YXmySeDsxxbA7hcq@alley>
In-Reply-To: <YXmySeDsxxbA7hcq@alley>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 28 Oct 2021 09:42:52 +0800
Message-ID: <CALOAHbB4LT8t6g5NseRygGAaAbHzKXfuWzg+TnLeg1tRUuwePg@mail.gmail.com>
Subject: Re: [PATCH v6 12/12] kernel/kthread: show a warning if kthread's comm
 is truncated
To:     Petr Mladek <pmladek@suse.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
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

On Thu, Oct 28, 2021 at 4:10 AM Petr Mladek <pmladek@suse.com> wrote:
>
> On Mon 2021-10-25 14:35:42, Kees Cook wrote:
> > On Mon, Oct 25, 2021 at 08:33:15AM +0000, Yafang Shao wrote:
> > > Show a warning if task comm is truncated. Below is the result
> > > of my test case:
> > >
> > > truncated kthread comm:I-am-a-kthread-with-lon, pid:14 by 6 characters
> > >
> > > Suggested-by: Petr Mladek <pmladek@suse.com>
> > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > Reviewed-by: Kees Cook <keescook@chromium.org>
> > > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > > Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> > > Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Cc: Petr Mladek <pmladek@suse.com>
> > > ---
> > >  kernel/kthread.c | 7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/kernel/kthread.c b/kernel/kthread.c
> > > index 5b37a8567168..46b924c92078 100644
> > > --- a/kernel/kthread.c
> > > +++ b/kernel/kthread.c
> > > @@ -399,12 +399,17 @@ struct task_struct *__kthread_create_on_node(int (*threadfn)(void *data),
> > >     if (!IS_ERR(task)) {
> > >             static const struct sched_param param = { .sched_priority = 0 };
> > >             char name[TASK_COMM_LEN];
> > > +           int len;
> > >
> > >             /*
> > >              * task is already visible to other tasks, so updating
> > >              * COMM must be protected.
> > >              */
> > > -           vsnprintf(name, sizeof(name), namefmt, args);
> > > +           len = vsnprintf(name, sizeof(name), namefmt, args);
> > > +           if (len >= TASK_COMM_LEN) {
> >
> > And since this failure case is slow-path, we could improve the warning
> > as other had kind of suggested earlier with something like this instead:
> >
> >                       char *full_comm;
> >
> >                       full_comm = kvasprintf(GFP_KERNEL, namefmt, args);
>
> You need to use va_copy()/va_end() if you want to use the same va_args
> twice.
>
> For example, see how kvasprintf() is implemented. It calls
> vsnprintf() twice and it uses va_copy()/va_end() around the the first call.
>

Does it mean that if we want to call vsnprintf() three times, we must
use va_copy()/va_end() around the first call and the second call ?
IOW, if we call vsnprintf() multiple times, all the calls except the
last call should be protected by va_copy()/va_end().
Actually I don't quite understand why we should do it like this. I
will try to understand it, and appreciate it if you could explain it
in detail.

BTW,  can we use va_copy()/va_end() in vsnprintf(), then the caller
doesn't need to care how many times it will call vsnprintf().

> kvasprintf() could also return NULL if there is not enough memory.

Right. We need to do the NULL check.

>
> >                       pr_warn("truncated kthread comm '%s' to '%s' (pid:%d)\n",
> >                               full_comm, name);
>
> BTW: Is this message printed during normal boot? I did not tried the
> patchset myself.
>

Yes, it will be printed at boot time.

> We should add this warning only if there is a good solution how to
> avoid the truncated names. And we should me sure that the most common
> kthreads/workqueues do not trigger it. It would be ugly to print many
> warnings during boot if people could not get rid of them easily.
>

As we have extended task comm to 24, there's no such warning printed
for the existing kthreads/workqueues.
IOW, it will only print for the newly introduced one if it has a long name.
That means this printing is under control.

> >                       kfree(full_comm);
> >               }
> > >             set_task_comm(task, name);
> > >             /*
> > >              * root may have changed our (kthreadd's) priority or CPU mask.
>
> Best Regards,
> Petr



-- 
Thanks
Yafang
