Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218D34380BC
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhJVXn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhJVXn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 19:43:56 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37695C061766;
        Fri, 22 Oct 2021 16:41:38 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id o12so6406910ybk.1;
        Fri, 22 Oct 2021 16:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nPJ9a7CQIvAdyA+WOKxT08L5sahv9vJ6Iua2FzEHVIU=;
        b=WtcpSq41dJe0VvXdxdUm8KzkiMObft9FRmxcA9JDbHLfAY3q7Uwq2XQ4XtM9E8tCoH
         xdR3ZBrnXBX+1jVHlDx2jpKWL24wnXkXNV15j2CSsivMNMB8umth3+T3V6SBnPb70eJ7
         CkqtJvdPbmLPX/wnjviTuwKP5usyoPl5+9QTywCHMp7+Y7nYTWkO+v3bkwDhNTSvhjZn
         hLpQCh5pKJnaMfm97v1ESbM5UuJxA0hEkOEl5ZzlJe62rBRyUiJwGiIvGj+mJmF8RUep
         vO7q586reyeSc+Oiv/MlFiyTZhuDtCTnqoZQsswLx3dNThZ4d0MQ0n3ojuWH6bYuDXs8
         AG7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nPJ9a7CQIvAdyA+WOKxT08L5sahv9vJ6Iua2FzEHVIU=;
        b=rcaidWWUvW84xOLimWYDuN0FI+Ki9mtP1oQMHh4yUJ1RBmYE1SwDzykJ6haf8vL1VA
         cEMlN4ltFN0qLNSg4AdFVxAPkXzn/fI93VBWhQg0izRih4RU/xLdOedGMO6ipmD6NgGa
         6BpDAbfORVPBEWeetXpO6dg4Dymi/+Y+NMMVunstXshINu89w0XDYPWCCuRPp2WX6DbP
         p0WsUaw1yTwIzgqgMgdAdEmlMvXQSVUlYu/EMBAX1Cuakr9B//cezqUz5szyD9uTIwUd
         TzAaIwxw1yOhOwZE3jbiPQRq4bac7C3wHTlYgCQMtVrrrWNe5MLrA5R/cNpnJMnwui5B
         Ml1Q==
X-Gm-Message-State: AOAM530YBVgDAZuSR7nL1tK9Gj/Vi37LQwchciuXjcHjtH5VMTDumq9Y
        XnW62gAzJbO0xCYpJqfuIXJpWSQG2wqOlqZig8A=
X-Google-Smtp-Source: ABdhPJzSmDh/m1Z6b+6/xf79h92UrL7VtHeA/YDtBqv7ZXX0MjHsHM5t0iqxRutu4F9NwwQT14weZ0q8pLK92LXQgEU=
X-Received: by 2002:a25:e7d7:: with SMTP id e206mr2669663ybh.267.1634946097494;
 Fri, 22 Oct 2021 16:41:37 -0700 (PDT)
MIME-Version: 1.0
References: <20211021034603.4458-1-laoar.shao@gmail.com> <20211021034603.4458-4-laoar.shao@gmail.com>
 <CAEf4BzYTEoDwWzXd91MeMH5Qr9L853Ff3Qq8_wnwfJ8GK0oLnw@mail.gmail.com> <CALOAHbB6KS8iscsz6y7zd=aGfKfo4jPbyMBKXL4ORY8taZRa8A@mail.gmail.com>
In-Reply-To: <CALOAHbB6KS8iscsz6y7zd=aGfKfo4jPbyMBKXL4ORY8taZRa8A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 Oct 2021 16:41:26 -0700
Message-ID: <CAEf4Bzb6AcoiKotHD5Fg1gT3psAC34s54Yo7fmGUZtwcGBW2zQ@mail.gmail.com>
Subject: Re: [PATCH v5 13/15] tools/testing/selftests/bpf: use
 TASK_COMM_LEN_16 instead of hard-coded 16
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Peter Ziljstra <peterz@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Qiang Zhang <qiang.zhang@windriver.com>,
        robdclark <robdclark@chromium.org>,
        Christian Brauner <christian@brauner.io>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 11:36 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> On Fri, Oct 22, 2021 at 6:44 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Oct 20, 2021 at 8:46 PM Yafang Shao <laoar.shao@gmail.com> wrote:
> > >
> > > The hard-coded 16 is used in various bpf progs. These progs get task
> > > comm either via bpf_get_current_comm() or prctl() or
> > > bpf_core_read_str(), all of which can work well even if the task comm size
> > > is changed.
> > > Below is the detailed information,
> > >
> > > bpf_get_current_comm:
> > >     progs/test_ringbuf.c
> > >     progs/test_ringbuf_multi.c
> > >
> > > prctl:
> > >     prog_tests/test_overhead.c
> > >     prog_tests/trampoline_count.c
> > >
> > > bpf_core_read_str:
> > >     progs/test_core_reloc_kernel.c
> > >     progs/test_sk_storage_tracing.c
> > >
> > > We'd better replace the hard-coded 16 with TASK_COMM_LEN_16 to make it
> > > more grepable.
> > >
> > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > > Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > > Cc: Petr Mladek <pmladek@suse.com>
> > > ---
> > >  tools/testing/selftests/bpf/Makefile                      | 2 +-
> > >  tools/testing/selftests/bpf/prog_tests/ringbuf.c          | 3 ++-
> > >  tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c    | 3 ++-
> > >  .../testing/selftests/bpf/prog_tests/sk_storage_tracing.c | 3 ++-
> > >  tools/testing/selftests/bpf/prog_tests/test_overhead.c    | 3 ++-
> > >  tools/testing/selftests/bpf/prog_tests/trampoline_count.c | 3 ++-
> > >  tools/testing/selftests/bpf/progs/profiler.h              | 7 ++++---
> > >  tools/testing/selftests/bpf/progs/profiler.inc.h          | 8 ++++----
> > >  tools/testing/selftests/bpf/progs/pyperf.h                | 4 ++--
> > >  tools/testing/selftests/bpf/progs/strobemeta.h            | 6 +++---
> > >  .../testing/selftests/bpf/progs/test_core_reloc_kernel.c  | 3 ++-
> > >  tools/testing/selftests/bpf/progs/test_ringbuf.c          | 3 ++-
> > >  tools/testing/selftests/bpf/progs/test_ringbuf_multi.c    | 3 ++-
> > >  .../testing/selftests/bpf/progs/test_sk_storage_tracing.c | 5 +++--
> > >  tools/testing/selftests/bpf/progs/test_skb_helpers.c      | 5 ++---
> > >  tools/testing/selftests/bpf/progs/test_stacktrace_map.c   | 5 +++--
> > >  tools/testing/selftests/bpf/progs/test_tracepoint.c       | 5 +++--
> > >  17 files changed, 41 insertions(+), 30 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > > index 799b88152e9e..5e72d783d3fe 100644
> > > --- a/tools/testing/selftests/bpf/Makefile
> > > +++ b/tools/testing/selftests/bpf/Makefile
> > > @@ -279,7 +279,7 @@ MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
> > >
> > >  CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
> > >  BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)                  \
> > > -            -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)                   \
> > > +            -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR) -I${TOOLSINCDIR}  \
> >
> > please don't add new include paths unnecessarily. See my comment on
> > another patch, if you add those new constants as enums, they will be
> > automatically available in vmlinux BTF and thus in auto-generated
> > vmlinux.h header (for those programs using it).
>
> Yes, after converting it to enum, the BPF programs can get it from the
> generated vmlinux.h.
>
> > For others, I'd just
> > leave hard-coded 16 or re-defined TASK_COMM_LEN_16 where appropriate.
> >
>
> It seems not all the BPF programs can include the vmlinux.h.
> What we really care about here is the copy of task comm should be with
> a nul terminator, if we can assure it, then the size used by the BPF
> is not important.
> I have checked the copy of task comm in all these BPF programs one by
> one, and replaced the unsafe bpf_probe_read_kernel() with
> bpf_probe_read_kernel_str(), after that change, I think we can leave
> hard-coded 16 for the progs which can't include vmlinux.h.

SGTM, thanks.

>
> > >              -I$(abspath $(OUTPUT)/../usr/include)
> > >
> > >  CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
> > > index 4706cee84360..ac82d57c09dc 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/ringbuf.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
> > > @@ -12,6 +12,7 @@
> > >  #include <sys/sysinfo.h>
> > >  #include <linux/perf_event.h>
> > >  #include <linux/ring_buffer.h>
> > > +#include <linux/sched/task.h>
> > >  #include "test_ringbuf.lskel.h"
> > >
> > >  #define EDONE 7777
> > > @@ -22,7 +23,7 @@ struct sample {
> > >         int pid;
> > >         int seq;
> > >         long value;
> > > -       char comm[16];
> > > +       char comm[TASK_COMM_LEN_16];
> >
> > how much value is in this "grep-ability", really? I'm not convinced
> > all this code churn is justified.
> >
> > >  };
> > >
> > >  static int sample_cnt;
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
> > > index 167cd8a2edfd..f0748305ffd6 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
> > > @@ -2,6 +2,7 @@
> > >  #define _GNU_SOURCE
> > >  #include <test_progs.h>
> > >  #include <sys/epoll.h>
> > > +#include <linux/sched/task.h>
> > >  #include "test_ringbuf_multi.skel.h"
> > >
> > >  static int duration = 0;
> >
> > [...]
>
>
> --
> Thanks
> Yafang
