Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A4843AA44
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 04:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbhJZCZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 22:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbhJZCZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 22:25:55 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9F0C061745;
        Mon, 25 Oct 2021 19:23:31 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id o184so18205870iof.6;
        Mon, 25 Oct 2021 19:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SJJNCBGzUmtsuEprx1i5HjE5RgD2pCrRE+ugyLzOEzM=;
        b=WTtEtNem1M+VdHMG4o22y5QD2FKJ3obNc6U2+A0rrMtL9MD2s38WsezagZpp6oAGpO
         /b8zFtMpA/933tK1lk4kBsOiTmex+FwlyI7quRSoBfiCMZxAXeTVrC+1UBBVwjxFkDRH
         2EXU6vbJEX3kEK1TzXbQsL8v8+OLxVvxSQ9J6NjDYXHC3kfXZ94sYk0eFBj0uYzBvVn7
         8MJbeiuDRxblIlZWd4Kqx1ZgeqOqNGCu4ly68IxmQypZp8j0z+foo1i8rEqxCKebDTVe
         7X33rwCd6TvP5E1Nf/jgGRz4IpMCReFaoZSf3ueCu0jbTuF2iy8LzQW3GYjkCNiSlLOg
         E85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SJJNCBGzUmtsuEprx1i5HjE5RgD2pCrRE+ugyLzOEzM=;
        b=HHywz2Bd4oIaZmSD6wfS/E9rmf0cr2QKfUmyetrW9DtH4ocld9mF+Mn5wU9tVo8iXs
         Ac+f9SMZ1Rwj9EUKCeRFdgKU+GXcykcw2T0dMVokUTCUF6uhD0COJ+2m4uEGtQJbQTz9
         Yhfd2lItC45Z1Z5MMOjJhSNORvwkNbOxy3vNvRphiSWS1/QhVtIbLM+YWAYMrv7xb+dY
         57D7sQtAQTsuBtJeD5GloezJv59318DB25qjJvMXKhTaGWHt8n+Ul/uPs/B5G+OmWYCc
         YL2OA34WYuKTVd0X/DhQhWThA+p2eL7fbkJh/bdwknCq7oDpNmrO0IKjcWnKkrWcaRMz
         aUSQ==
X-Gm-Message-State: AOAM532xBX5fkEcZoFluqV/Qtk5kkQFmt34mWCv6hvrMaCR8RnkW1vde
        Grb5Q7Uo3ahD2/wPYylCubxzQRyjv5wx/dTvtj8=
X-Google-Smtp-Source: ABdhPJxLmBzK5FZBxQZCZz83VD8ExfjyjVQb3LuiMJweAWynal5QYJEn08HmmwVm7kPgVnRJmrxLHo7yOYshF0+BFzQ=
X-Received: by 2002:a05:6602:2e05:: with SMTP id o5mr12896890iow.204.1635215010620;
 Mon, 25 Oct 2021 19:23:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211025083315.4752-1-laoar.shao@gmail.com> <20211025083315.4752-12-laoar.shao@gmail.com>
 <202110251429.DD44ED7B76@keescook>
In-Reply-To: <202110251429.DD44ED7B76@keescook>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 26 Oct 2021 10:22:54 +0800
Message-ID: <CALOAHbDp9zW+mr+_ZrWLNWP4aeqa+z_JBhJjQe=c+WT0qXGbhQ@mail.gmail.com>
Subject: Re: [PATCH v6 11/12] sched.h: extend task comm from 16 to 24
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

On Tue, Oct 26, 2021 at 5:30 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Oct 25, 2021 at 08:33:14AM +0000, Yafang Shao wrote:
> > When I was implementing a new per-cpu kthread cfs_migration, I found the
> > comm of it "cfs_migration/%u" is truncated due to the limitation of
> > TASK_COMM_LEN. For example, the comm of the percpu thread on CPU10~19 are
> > all with the same name "cfs_migration/1", which will confuse the user. This
> > issue is not critical, because we can get the corresponding CPU from the
> > task's Cpus_allowed. But for kthreads correspoinding to other hardware
> > devices, it is not easy to get the detailed device info from task comm,
> > for example,
> >
> >     jbd2/nvme0n1p2-
> >     xfs-reclaim/sdf
> >
> > We can also shorten the name to work around this problem, but I find
> > there are so many truncated kthreads:
> >
> >     rcu_tasks_kthre
> >     rcu_tasks_rude_
> >     rcu_tasks_trace
> >     poll_mpt3sas0_s
> >     ext4-rsv-conver
> >     xfs-reclaim/sd{a, b, c, ...}
> >     xfs-blockgc/sd{a, b, c, ...}
> >     xfs-inodegc/sd{a, b, c, ...}
> >     audit_send_repl
> >     ecryptfs-kthrea
> >     vfio-irqfd-clea
> >     jbd2/nvme0n1p2-
> >     ...
> >
> > We should improve this problem fundamentally by extending comm size to
> > 24 bytes. task_struct is growing rather regularly by 8 bytes.
> >
> > After this change, the truncated kthreads listed above will be
> > displayed as:
> >
> >     rcu_tasks_kthread
> >     rcu_tasks_rude_kthread
> >     rcu_tasks_trace_kthread
> >     poll_mpt3sas0_statu
> >     ext4-rsv-conversion
> >     xfs-reclaim/sdf1
> >     xfs-blockgc/sdf1
> >     xfs-inodegc/sdf1
> >     audit_send_reply
> >     ecryptfs-kthread
> >     vfio-irqfd-cleanup
> >     jbd2/nvme0n1p2-8
> >
> > As we have converted all the unsafe copy of task comm to the safe one,
> > this change won't make any trouble to the kernel or the in-tree tools.
> > The safe one and unsafe one of comm copy as follows,
> >
> >   Unsafe                 Safe
> >   strlcpy                strscpy_pad
> >   strncpy                strscpy_pad
> >   bpf_probe_read_kernel  bpf_probe_read_kernel_str
> >                          bpf_core_read_str
> >                          bpf_get_current_comm
> >                          perf_event__prepare_comm
> >                          prctl(2)
> >
> > Regarding the possible risk it may take to the out-of-tree user tools, if
> > the user tools get the task comm through kernel API like prctl(2),
> > bpf_get_current_comm() and etc, the tools still work well after this
> > change. While If the user tools get the task comm through direct string
> > copy, it must make sure the copied string should be with a nul terminator.
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
> >  include/linux/sched.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 124538db792c..490d12eabe44 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -279,7 +279,7 @@ struct task_group;
> >   * BPF programs.
> >   */
> >  enum {
> > -     TASK_COMM_LEN = 16,
> > +     TASK_COMM_LEN = 24,
> >  };
>
> I suspect this should be kept in sync with the tools/ copy of sched.h
> (i.e. we may need to keep the TASK_COMM_LEN_16 around in the kernel tree
> too.)
>

Sure. I will change it.

> >
> >  extern void scheduler_tick(void);
> > --
> > 2.17.1
> >
>
> --
> Kees Cook



-- 
Thanks
Yafang
