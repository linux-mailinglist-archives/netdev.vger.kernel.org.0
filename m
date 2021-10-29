Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382A643F7F8
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 09:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbhJ2HsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 03:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhJ2HsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 03:48:05 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40AEC061570;
        Fri, 29 Oct 2021 00:45:37 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id n67so11489652iod.9;
        Fri, 29 Oct 2021 00:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YvS3OEojn6WlgoM5Pok9+XWG3Yikban/dCaVMqXh6O4=;
        b=j0ZYEwfg/RFP3vZ0NF45LNbXn0FXnpRrSZKuYBz/v3Ti0BTmeyp9N7VQZHJ0MOpaHc
         SyOFdeQmIvmzNxRqDvY36MWKL4TN4GyGqlch3Oic3ZzzQtFJzSqAx6Sncn84ySZo0K/U
         CDVKvtPGDJyopdDodidwBiFnONnN0Y+zPuafOQ6zzwcj0xmqQruYxufDtrGqgVTm197X
         YD7WbaChlI8ZDicXCuH4XD1MpdTyJ50sTFdy4MOyQqgKK1CXkRLKfxaPvxQqnar8Ew15
         4rzhCfQnHV9Kq+c95oj4HnQu6n4EutKUy+lqQDB3VSiBsBk12fvwsyMW/u3N12jhBu3l
         Yg8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YvS3OEojn6WlgoM5Pok9+XWG3Yikban/dCaVMqXh6O4=;
        b=Dy+L2AIyx8TPFQn9HjDpaganSZ4/9hXjfefaJa5ZQ+Ao0OlHtHnsgU2/ANFCz027DB
         OzcpXx7w5abhPDzg6FKagaZ0pci1jadnof3uroSqKjOP1qV0ReILwvxbYRmioikToxOR
         CBwpMeVdB2gIg80oLTSZSHbVGvPX6NH5Ql2YL+sQTzEId9hGtr39ssnZPmNCs8nCQpfl
         1uNJQ1bRaCyjWOvcE4ovJ5buqaIcRwO2ySeuD6ST7//Wnrw35DabK/wTIfQwCRtRT8Qe
         run0JpMf41CZOxGtnqbQux9wy8skHBdexwjzlbDkTEJScEvBlt4xjjJ4UCzVax+weyJw
         jITg==
X-Gm-Message-State: AOAM530kgGMKBstBxKTuI/V7O59d1ylMJumuc/VM7XjstAdqzehCCevV
        6DJp11l0OzhHkDqGwo+SFs0Pxb9375Pbo9YkjiI=
X-Google-Smtp-Source: ABdhPJyETE/qLAF0grfwPy1l00eM4REeeLtmeoBWL6wOt59OXeZvcrCFeFwAw5oh/9q3xbShCHKFcImikiHaH3niayk=
X-Received: by 2002:a05:6602:27d4:: with SMTP id l20mr6774818ios.94.1635493536891;
 Fri, 29 Oct 2021 00:45:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211025083315.4752-1-laoar.shao@gmail.com> <20211025083315.4752-13-laoar.shao@gmail.com>
 <202110251431.F594652F@keescook> <YXmySeDsxxbA7hcq@alley>
In-Reply-To: <YXmySeDsxxbA7hcq@alley>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 29 Oct 2021 15:44:47 +0800
Message-ID: <CALOAHbDQkfdpW4hktPCcstEAYG6ecEan_b095NeanA7sC1K=-w@mail.gmail.com>
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

Now I understand it.
So the patch will be:

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 5b37a8567168..c1ff67283725 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -399,12 +399,29 @@ struct task_struct *__kthread_create_on_node(int
(*threadfn)(void *data),
        if (!IS_ERR(task)) {
                static const struct sched_param param = { .sched_priority = 0 };
                char name[TASK_COMM_LEN];
+               char *full_comm;
+               va_list aq;
+               int len;

                /*
                 * task is already visible to other tasks, so updating
                 * COMM must be protected.
                 */
-               vsnprintf(name, sizeof(name), namefmt, args);
+               va_copy(aq, args);
+               len = vsnprintf(name, sizeof(name), namefmt, aq);
+               va_end(aq);
+               if (len >= TASK_COMM_LEN) {
+                       full_comm = kvasprintf(GFP_KERNEL, namefmt, args);
+                       if (full_comm) {
+                               pr_warn("truncated kthread comm '%s'
to '%s' (pid:%d)\n",
+                                       full_comm, name, task->pid);
+                               kfree(full_comm);
+                       } else {
+                               pr_warn("truncated kthread comm '%s'
(pid:%d) by %d characters\n",
+                                       name, task->pid, len -
TASK_COMM_LEN + 1);
+
+                       }
+               }
                set_task_comm(task, name);
                /*
                 * root may have changed our (kthreadd's) priority or CPU mask.

That seems a little overkill to me.
I prefer to keep the v6 as-is.

> For example, see how kvasprintf() is implemented. It calls
> vsnprintf() twice and it uses va_copy()/va_end() around the the first call.
>
> kvasprintf() could also return NULL if there is not enough memory.
>
> >                       pr_warn("truncated kthread comm '%s' to '%s' (pid:%d)\n",
> >                               full_comm, name);
>
> BTW: Is this message printed during normal boot? I did not tried the
> patchset myself.
>
> We should add this warning only if there is a good solution how to
> avoid the truncated names. And we should me sure that the most common
> kthreads/workqueues do not trigger it. It would be ugly to print many
> warnings during boot if people could not get rid of them easily.
>
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
