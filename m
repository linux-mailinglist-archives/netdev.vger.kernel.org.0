Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7AB43AA3E
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 04:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhJZCYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 22:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233824AbhJZCYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 22:24:43 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C638C061745;
        Mon, 25 Oct 2021 19:22:20 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id s3so15342178ild.0;
        Mon, 25 Oct 2021 19:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aYNLxVJxhJtkV7LDbxh0/fDHQmD9y+lnwZgdD2VF1nY=;
        b=XgapHKCXLmK3d4ipnGkwLkAGLSdvG7pnijM97IFpuTwDyGAfqY59hcKHAkFeWeODpR
         Jjw6Crqe3bj2KeTn18MQNqhF6xyIO9m5VCAZSOvjPyxkaMHgxDDOrmQk/awyWCYQDRSk
         6bymVQKy2ViFsapdJMYcsCQJtEi8NA++UKtPQznjRMqBWX7HwEOEhQgpCIQYIW4SZyH6
         2igGPL3JgSaKMp6J2XuE+q8hBa0Bb5FDYHh3+eJ/bVlPWF67rMGCtmNjs684L/5vq1J0
         gMM5AX63+DqOco6YtYfXmMbgeSeiXxzR2KzEe/Lxfp/IWkwi73Le44LxB0368IuSuxbd
         0K2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aYNLxVJxhJtkV7LDbxh0/fDHQmD9y+lnwZgdD2VF1nY=;
        b=uUXY6+F62X6W1NRZWWl2VX/Uwf8TnONomSGWW8HG0Zh4WG4xsCAhMMUDYEbRi/pilv
         UqM/Es+ZiEan10kr41pOcODI7SoIllkjnvcWU12PJvQxC0enABivzNKCFVpjbH8mqVfS
         MAJeG8DGjldM00fGLjhlI4t17B3Bo1wj573MtDGYcyXHuXiswD83ZO0gAGPNr5WskaI8
         uCgP2BDEM2do+iz9+/UW6uSmfbv+snIlmqXXCFhikL4LvsERJHISIOJ2US4165j2b7cX
         vMJyDbypn8CQGhEmqzsW+Rbh86h0DMYhOC9CIe88T7/4cYuycgjUOwtP78X9c8yApxKf
         n5+A==
X-Gm-Message-State: AOAM533FZpaURRqgDyhiDB3POUN+NQV3uJA00PRUg0NqZ6Sh0lMg42B9
        4A4KwGlllcXktRrGNUjsSb0CJptf9d+cqDUQls8=
X-Google-Smtp-Source: ABdhPJy1/BIRcRVvc7L15TX90MIkD80tatO8voO6JJbloERLJG1VNNMnwLh8i+0LovAq3pIM8zOUowRpitmZp3NbmsQ=
X-Received: by 2002:a05:6e02:218f:: with SMTP id j15mr12615063ila.23.1635214939600;
 Mon, 25 Oct 2021 19:22:19 -0700 (PDT)
MIME-Version: 1.0
References: <20211025083315.4752-1-laoar.shao@gmail.com> <20211025083315.4752-11-laoar.shao@gmail.com>
 <202110251428.B891AD6ACB@keescook>
In-Reply-To: <202110251428.B891AD6ACB@keescook>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 26 Oct 2021 10:21:43 +0800
Message-ID: <CALOAHbCNq3sFpd44M0C1ZnKt_KJYOrERqr0m9foxSFHjR4Chyg@mail.gmail.com>
Subject: Re: [PATCH v6 10/12] tools/testing/selftests/bpf: make it adopt to
 task comm size change
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

On Tue, Oct 26, 2021 at 5:29 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Oct 25, 2021 at 08:33:13AM +0000, Yafang Shao wrote:
> > The hard-coded 16 is used in various bpf progs. These progs get task
> > comm either via bpf_get_current_comm() or prctl() or
> > bpf_core_read_str(), all of which can work well even if the task comm size
> > is changed.
> >
> > In these BPF programs, one thing to be improved is the
> > sched:sched_switch tracepoint args. As the tracepoint args are derived
> > from the kernel, we'd better make it same with the kernel. So the macro
> > TASK_COMM_LEN is converted to type enum, then all the BPF programs can
> > get it through BTF.
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
> >  include/linux/sched.h                                   | 9 +++++++--
> >  tools/testing/selftests/bpf/progs/test_stacktrace_map.c | 6 +++---
> >  tools/testing/selftests/bpf/progs/test_tracepoint.c     | 6 +++---
> >  3 files changed, 13 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index c1a927ddec64..124538db792c 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -274,8 +274,13 @@ struct task_group;
> >
> >  #define get_current_state()  READ_ONCE(current->__state)
> >
> > -/* Task command name length: */
> > -#define TASK_COMM_LEN                        16
> > +/*
> > + * Define the task command name length as enum, then it can be visible to
> > + * BPF programs.
> > + */
> > +enum {
> > +     TASK_COMM_LEN = 16,
> > +};
> >
> >  extern void scheduler_tick(void);
> >
> > diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
> > index 00ed48672620..e9b602a6dc1b 100644
> > --- a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
> > +++ b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
> > @@ -1,7 +1,7 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  // Copyright (c) 2018 Facebook
> >
> > -#include <linux/bpf.h>
> > +#include <vmlinux.h>
>
> Why is this change needed here and below?
>

If the BPF programs want to use the type defined in the kernel, for
example the enum we used here, we must include the vmlinux.h generated
by BTF.

> >  #include <bpf/bpf_helpers.h>
> >
> >  #ifndef PERF_MAX_STACK_DEPTH
> > @@ -41,11 +41,11 @@ struct {
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
> > diff --git a/tools/testing/selftests/bpf/progs/test_tracepoint.c b/tools/testing/selftests/bpf/progs/test_tracepoint.c
> > index 4b825ee122cf..f21982681e28 100644
> > --- a/tools/testing/selftests/bpf/progs/test_tracepoint.c
> > +++ b/tools/testing/selftests/bpf/progs/test_tracepoint.c
> > @@ -1,17 +1,17 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  // Copyright (c) 2017 Facebook
> >
> > -#include <linux/bpf.h>
> > +#include <vmlinux.h>
> >  #include <bpf/bpf_helpers.h>
> >
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
