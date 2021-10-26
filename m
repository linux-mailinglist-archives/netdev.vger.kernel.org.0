Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE2643AA02
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 03:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhJZB7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 21:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhJZB7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 21:59:15 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86255C061745;
        Mon, 25 Oct 2021 18:56:52 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id v65so6542398ioe.5;
        Mon, 25 Oct 2021 18:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xWeUj1T4Lr60JoRsLSjKYzLtDKrcRSE1xJJaTRkfYu0=;
        b=gAapokdrHWuAyvsseWO0TvIdywOQUK0S407ePIzmBXjmKHIKH7NnSGxsvX9iKiES2N
         HLwuffairU//rIaPVQ7ez8hSwM91YyJ7d3VUtGe56ciYfAVTOhAUPEMmlZNxhUjRHPeP
         BtXSS/9svwqyTRQ+lHY3Ka1U0E7iVJfsIN6OD1hucX8L4TePBv4zmsOosvIRNQDTtPCk
         jTlTc8jliDg0tD/CmcRWdUr2YtK7LHcDeitU4M/+Fc+8DgtMfBM+h+e4Qz0XJ+H3wBFu
         rWVej7/USxWcq4JINLUJ0HukPwZI5emI+RM9PYxx6Icx++KKVF0uuHn9dAW+oFohue2K
         DJ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xWeUj1T4Lr60JoRsLSjKYzLtDKrcRSE1xJJaTRkfYu0=;
        b=agB3lOyJAsyiSCq8J8fq1V8lYwFXB3aLXrM+QAxoZHR8CiiJDruC/1daYsimNRmy55
         z9241xXN97nIgVXGmrr0joCNceVBMqKWvbFv34Qir68AvgGEu6tMU5OytoxV6ByD/7OT
         L04qHrfBD99NVM/kYIYS3eOcLXPCtpjEdw50FMFdtH5lIjxzxwcrVA+mnP5f7YW9AW3R
         Oe2G8rBZG4CDI7Ztt0YzcE8VQkySXyyHM7hhTcgmf7DGaf9RflFABi2wl9AKUc+2Nc1W
         3P23fxXBIKCVeUeOaIuFnHUJQ9A5RxjDexyVXZsgi+5Szzt5keX0SRpCTBfKoKnw1ESx
         u53Q==
X-Gm-Message-State: AOAM533tAcloJfi5T53UsWUT5O7B/dMklSpI1NyyBZhGfqz50XT+OJ9c
        zDwOJQziFwkW0kkAptd3NCUjA4Uch9sWwRAjZ+E=
X-Google-Smtp-Source: ABdhPJzn3jxml3ZFy8UfHJXcY4mdjkvn7tNH2JicBIze1RxSUpk5VNwer/ZyY/WbY+4kBOP+NVYRRevs/EoFq1bKkdE=
X-Received: by 2002:a02:aa96:: with SMTP id u22mr13403998jai.95.1635213411760;
 Mon, 25 Oct 2021 18:56:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211025083315.4752-1-laoar.shao@gmail.com> <20211025083315.4752-6-laoar.shao@gmail.com>
 <202110251417.4D879366@keescook>
In-Reply-To: <202110251417.4D879366@keescook>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 26 Oct 2021 09:56:15 +0800
Message-ID: <CALOAHbDSAiqFG5+fT2bkt2SCNXznqyjO0wQqyuZqSnRg49n0Lg@mail.gmail.com>
Subject: Re: [PATCH v6 05/12] elfcore: make prpsinfo always get a nul
 terminated task comm
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

On Tue, Oct 26, 2021 at 5:18 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Oct 25, 2021 at 08:33:08AM +0000, Yafang Shao wrote:
> > kernel test robot reported a -Wstringop-truncation warning after I
> > extend task comm from 16 to 24. Below is the detailed warning:
> >
> >    fs/binfmt_elf.c: In function 'fill_psinfo.isra':
> > >> fs/binfmt_elf.c:1575:9: warning: 'strncpy' output may be truncated copying 16 bytes from a string of length 23 [-Wstringop-truncation]
> >     1575 |         strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
> >          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> > This patch can fix this warning.
> >
> > Replacing strncpy() with strscpy_pad() can avoid this warning.
> >
> > This patch also replace the hard-coded 16 with TASK_COMM_LEN to make it
> > more compatible with task comm size change.
> >
> > I also verfied if it still work well when I extend the comm size to 24.
> > struct elf_prpsinfo is used to dump the task information in userspace
> > coredump or kernel vmcore. Below is the verfication of vmcore,
> >
> > crash> ps
> >    PID    PPID  CPU       TASK        ST  %MEM     VSZ    RSS  COMM
> >       0      0   0  ffffffff9d21a940  RU   0.0       0      0  [swapper/0]
> > >     0      0   1  ffffa09e40f85e80  RU   0.0       0      0  [swapper/1]
> > >     0      0   2  ffffa09e40f81f80  RU   0.0       0      0  [swapper/2]
> > >     0      0   3  ffffa09e40f83f00  RU   0.0       0      0  [swapper/3]
> > >     0      0   4  ffffa09e40f80000  RU   0.0       0      0  [swapper/4]
> > >     0      0   5  ffffa09e40f89f80  RU   0.0       0      0  [swapper/5]
> >       0      0   6  ffffa09e40f8bf00  RU   0.0       0      0  [swapper/6]
> > >     0      0   7  ffffa09e40f88000  RU   0.0       0      0  [swapper/7]
> > >     0      0   8  ffffa09e40f8de80  RU   0.0       0      0  [swapper/8]
> > >     0      0   9  ffffa09e40f95e80  RU   0.0       0      0  [swapper/9]
> > >     0      0  10  ffffa09e40f91f80  RU   0.0       0      0  [swapper/10]
> > >     0      0  11  ffffa09e40f93f00  RU   0.0       0      0  [swapper/11]
> > >     0      0  12  ffffa09e40f90000  RU   0.0       0      0  [swapper/12]
> > >     0      0  13  ffffa09e40f9bf00  RU   0.0       0      0  [swapper/13]
> > >     0      0  14  ffffa09e40f98000  RU   0.0       0      0  [swapper/14]
> > >     0      0  15  ffffa09e40f9de80  RU   0.0       0      0  [swapper/15]
> >
> > It works well as expected.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
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
> >  fs/binfmt_elf.c                | 2 +-
> >  include/linux/elfcore-compat.h | 3 ++-
> >  include/linux/elfcore.h        | 4 ++--
> >  3 files changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> > index a813b70f594e..a4ba79fce2a9 100644
> > --- a/fs/binfmt_elf.c
> > +++ b/fs/binfmt_elf.c
> > @@ -1572,7 +1572,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
> >       SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
> >       SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
> >       rcu_read_unlock();
> > -     strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
> > +     strscpy_pad(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
>
> This should use get_task_comm().
>

Sure.

> >
> >       return 0;
> >  }
> > diff --git a/include/linux/elfcore-compat.h b/include/linux/elfcore-compat.h
> > index e272c3d452ce..afa0eb45196b 100644
> > --- a/include/linux/elfcore-compat.h
> > +++ b/include/linux/elfcore-compat.h
> > @@ -5,6 +5,7 @@
> >  #include <linux/elf.h>
> >  #include <linux/elfcore.h>
> >  #include <linux/compat.h>
> > +#include <linux/sched.h>
> >
> >  /*
> >   * Make sure these layouts match the linux/elfcore.h native definitions.
> > @@ -43,7 +44,7 @@ struct compat_elf_prpsinfo
> >       __compat_uid_t                  pr_uid;
> >       __compat_gid_t                  pr_gid;
> >       compat_pid_t                    pr_pid, pr_ppid, pr_pgrp, pr_sid;
> > -     char                            pr_fname[16];
> > +     char                            pr_fname[TASK_COMM_LEN];
> >       char                            pr_psargs[ELF_PRARGSZ];
> >  };
> >
> > diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
> > index 2aaa15779d50..8d79cd58b09a 100644
> > --- a/include/linux/elfcore.h
> > +++ b/include/linux/elfcore.h
> > @@ -65,8 +65,8 @@ struct elf_prpsinfo
> >       __kernel_gid_t  pr_gid;
> >       pid_t   pr_pid, pr_ppid, pr_pgrp, pr_sid;
> >       /* Lots missing */
> > -     char    pr_fname[16];   /* filename of executable */
> > -     char    pr_psargs[ELF_PRARGSZ]; /* initial part of arg list */
> > +     char    pr_fname[TASK_COMM_LEN];        /* filename of executable */
> > +     char    pr_psargs[ELF_PRARGSZ];         /* initial part of arg list */
> >  };
> >
> >  static inline void elf_core_copy_regs(elf_gregset_t *elfregs, struct pt_regs *regs)
> > --
> > 2.17.1
> >
>
> These structs are externally parsed -- we can't change the size of
> pr_fname AFAICT.
>

Yes, they are parsed by crash utility and other tools.
I will keep pr_fname as-is.

-- 
Thanks
Yafang
