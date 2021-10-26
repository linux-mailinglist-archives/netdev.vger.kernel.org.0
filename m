Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53BB43AA4C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 04:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbhJZC05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 22:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhJZC0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 22:26:54 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12123C061745;
        Mon, 25 Oct 2021 19:24:31 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id n10so8740705iod.13;
        Mon, 25 Oct 2021 19:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/GAImBcqzGF4ZlKPfVyKeIteXxvhu81c3zR5LkKqlwY=;
        b=HckTWrHAKpA9NZaDoBD2BNIf8fBKYacL3yGZ+CmJTO2viT8TEvn6v4CXE5/MtmD3wy
         eAoYl2oIe7HeG5FcGIaPzaE6CEuiH6ZkKKQ9dLnt7VuKtJeea3Mjpw21tZOjWjlS+8vO
         zLbZeiwh3xYW6HpdYXoz4CkXS+cf/UMI8DG0JVazxbno27ArXIfeY4GaTnsP1sydjXFr
         ayX5Ge09SgMHgIoClCs/l+KSLWg0OURLJGKdRC62NTmdIC7Cb+NOI3rNPLrEQsuxg8J5
         zCJvRfrF17lPOWTDUF0EgqHPKuoreW6wCp/PfyWozgwykrOfyHraYfRztxnTZEshUVoN
         HydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/GAImBcqzGF4ZlKPfVyKeIteXxvhu81c3zR5LkKqlwY=;
        b=50ufQ+j4y1mtTzGM01tTtAOmWbjQk2AeRcBgelhcRDjrU6jWYmmfsDA/svyg1xNidQ
         EqEgYQPkAyCtwaGvMv6uH4BIVlX/PiiLx6OB/ujUNb58JbOvwnAdNwboi0jaLfEoq1JX
         DRplhUeJTDocL5M6nhle4dci0+XgsILVFtC3cbcxXOR4Bm0mw5mr7as6sjwD7Fr8hEaI
         Ymv2ilJmzwfTWAkGz5jNdQvbgOP0Mu/Vu8SXhGFutFh2JxmXQbjqLE+jmdN17YrvO7H3
         4yGEn4p1Oc92oRKMOTW6pq6dh9/tnE84HO2VrNLKvpP6ZjLv2+Iqxuvf59VIvvvveKQl
         AmYA==
X-Gm-Message-State: AOAM532B5GTYo0JhW/4eSULTgG5Q0xl87MLGBSUhQG90IcjlgZI/9p3j
        kj5qFUP+w2Vnq8/JCcAXIglZA2nsAk4h1f1vCjs=
X-Google-Smtp-Source: ABdhPJxvXEqIO8vqTWxsYX6HC3Vxi6T3FWqsGQ75A1upKsImFHiyikOsYrF3Livq3yt5hVdH592yN3ANmyCD09/8e8c=
X-Received: by 2002:a02:a483:: with SMTP id d3mr3945986jam.23.1635215070448;
 Mon, 25 Oct 2021 19:24:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211025083315.4752-1-laoar.shao@gmail.com> <20211025083315.4752-13-laoar.shao@gmail.com>
 <202110251431.F594652F@keescook>
In-Reply-To: <202110251431.F594652F@keescook>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 26 Oct 2021 10:23:54 +0800
Message-ID: <CALOAHbA40qJZjdiM6+_e+t-qrE3kdHROPSTE4ttv4JT-HKCG-g@mail.gmail.com>
Subject: Re: [PATCH v6 12/12] kernel/kthread: show a warning if kthread's comm
 is truncated
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

On Tue, Oct 26, 2021 at 5:35 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Oct 25, 2021 at 08:33:15AM +0000, Yafang Shao wrote:
> > Show a warning if task comm is truncated. Below is the result
> > of my test case:
> >
> > truncated kthread comm:I-am-a-kthread-with-lon, pid:14 by 6 characters
> >
> > Suggested-by: Petr Mladek <pmladek@suse.com>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> > Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Petr Mladek <pmladek@suse.com>
> > ---
> >  kernel/kthread.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/kthread.c b/kernel/kthread.c
> > index 5b37a8567168..46b924c92078 100644
> > --- a/kernel/kthread.c
> > +++ b/kernel/kthread.c
> > @@ -399,12 +399,17 @@ struct task_struct *__kthread_create_on_node(int (*threadfn)(void *data),
> >       if (!IS_ERR(task)) {
> >               static const struct sched_param param = { .sched_priority = 0 };
> >               char name[TASK_COMM_LEN];
> > +             int len;
> >
> >               /*
> >                * task is already visible to other tasks, so updating
> >                * COMM must be protected.
> >                */
> > -             vsnprintf(name, sizeof(name), namefmt, args);
> > +             len = vsnprintf(name, sizeof(name), namefmt, args);
> > +             if (len >= TASK_COMM_LEN) {
>
> And since this failure case is slow-path, we could improve the warning
> as other had kind of suggested earlier with something like this instead:
>

It Makes sense to me.  I will do it as you suggested.

>                         char *full_comm;
>
>                         full_comm = kvasprintf(GFP_KERNEL, namefmt, args);
>                         pr_warn("truncated kthread comm '%s' to '%s' (pid:%d)\n",
>                                 full_comm, name);
>
>                         kfree(full_comm);
>                 }
> >               set_task_comm(task, name);
> >               /*
> >                * root may have changed our (kthreadd's) priority or CPU mask.
> > --
> > 2.17.1
> >
>
> --
> Kees Cook



-- 
Thanks
Yafang
