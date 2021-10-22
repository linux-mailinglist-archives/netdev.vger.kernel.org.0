Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2524371EE
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 08:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhJVGi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 02:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbhJVGix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 02:38:53 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C743C061766;
        Thu, 21 Oct 2021 23:36:36 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id o184so4018496iof.6;
        Thu, 21 Oct 2021 23:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c/GFWfrfQCEwAUkTRHGoboE0d5lC1Uh+koDzmicEca0=;
        b=WMbENLpzZjcQwzZGiPW9Rhj/vFgwtV2c/zTneotJXvWjk7VUNpF5RqaRXkH7XVbb1v
         m/Bt+TPNkNMeG6CjLyjFtqDGplI7JGUtLGfH1tHhdqQauWPvrpXwMZhv+FT8usoTTzA4
         7yQ8eYL40BoICYMya8ERyMssfiR9dSuRYuHP44OoJ3KGgq8N/cMF43J7WJZvQvaBLEYC
         WC5lVPCnSPrD4rMtJ2E2YXIQRuoiX/lZtPhoz6BwAWzPDoJe962/hNugrkTW1efe9lYR
         rEfL1Ylxd1IQCgi6FL1FOj/9mOj5+dxGwhbrXYgVM8dJfJnARoVGkPhGsTWCUTR+WZph
         orSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c/GFWfrfQCEwAUkTRHGoboE0d5lC1Uh+koDzmicEca0=;
        b=H0aW4brsariRoaYr2AmT/m5WuvpddmvwHJn1ZEPAsIBrwTk/d6LYk6iExoAz3A4/n4
         vgNEU2nnpubUahd65a9GCJX9GG8Do8l8Tbu34OKu/QsyKEkjMU96p4TZc7d9iKz86Wrv
         fh2N8INqJWNavwjKviqo8/FcFyVbApRWu1x1nz2Ww5eeeseE+pxFldsTonOVjumIWEBS
         uquOpZpRXYUClwftPSPK0WUidfogZnQ9d1z8N3IuJv1R1tbW9E+TbBjEC1IZB0EdUANA
         rsMhHJToz5l7tsmSu85RmTXPXDQp+RFz4ywv+zGAOFycm7YbuEweaKpw3RCF80iX4b80
         qZvQ==
X-Gm-Message-State: AOAM532BXbEh6dujVoZvsV/H1qV8eVew2Y8p1v3NpiUfIioZRqw5ku8N
        VeN5hweICZoNZqZPIrioYWB/DPD3GzxLBYI5qCA=
X-Google-Smtp-Source: ABdhPJzW3+HUT/rPVCwHnSiPO4ICRmyWKrku4AlXcSF+9AY0i+8EGnflNLTeS7Y89nZNFwPHrpQ1nFFJVIRURXVCvJQ=
X-Received: by 2002:a05:6638:1607:: with SMTP id x7mr6984970jas.128.1634884595972;
 Thu, 21 Oct 2021 23:36:35 -0700 (PDT)
MIME-Version: 1.0
References: <20211021034603.4458-1-laoar.shao@gmail.com> <20211021034603.4458-4-laoar.shao@gmail.com>
 <CAEf4BzYTEoDwWzXd91MeMH5Qr9L853Ff3Qq8_wnwfJ8GK0oLnw@mail.gmail.com>
In-Reply-To: <CAEf4BzYTEoDwWzXd91MeMH5Qr9L853Ff3Qq8_wnwfJ8GK0oLnw@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 22 Oct 2021 14:36:00 +0800
Message-ID: <CALOAHbB6KS8iscsz6y7zd=aGfKfo4jPbyMBKXL4ORY8taZRa8A@mail.gmail.com>
Subject: Re: [PATCH v5 13/15] tools/testing/selftests/bpf: use
 TASK_COMM_LEN_16 instead of hard-coded 16
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Fri, Oct 22, 2021 at 6:44 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Oct 20, 2021 at 8:46 PM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > The hard-coded 16 is used in various bpf progs. These progs get task
> > comm either via bpf_get_current_comm() or prctl() or
> > bpf_core_read_str(), all of which can work well even if the task comm size
> > is changed.
> > Below is the detailed information,
> >
> > bpf_get_current_comm:
> >     progs/test_ringbuf.c
> >     progs/test_ringbuf_multi.c
> >
> > prctl:
> >     prog_tests/test_overhead.c
> >     prog_tests/trampoline_count.c
> >
> > bpf_core_read_str:
> >     progs/test_core_reloc_kernel.c
> >     progs/test_sk_storage_tracing.c
> >
> > We'd better replace the hard-coded 16 with TASK_COMM_LEN_16 to make it
> > more grepable.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Petr Mladek <pmladek@suse.com>
> > ---
> >  tools/testing/selftests/bpf/Makefile                      | 2 +-
> >  tools/testing/selftests/bpf/prog_tests/ringbuf.c          | 3 ++-
> >  tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c    | 3 ++-
> >  .../testing/selftests/bpf/prog_tests/sk_storage_tracing.c | 3 ++-
> >  tools/testing/selftests/bpf/prog_tests/test_overhead.c    | 3 ++-
> >  tools/testing/selftests/bpf/prog_tests/trampoline_count.c | 3 ++-
> >  tools/testing/selftests/bpf/progs/profiler.h              | 7 ++++---
> >  tools/testing/selftests/bpf/progs/profiler.inc.h          | 8 ++++----
> >  tools/testing/selftests/bpf/progs/pyperf.h                | 4 ++--
> >  tools/testing/selftests/bpf/progs/strobemeta.h            | 6 +++---
> >  .../testing/selftests/bpf/progs/test_core_reloc_kernel.c  | 3 ++-
> >  tools/testing/selftests/bpf/progs/test_ringbuf.c          | 3 ++-
> >  tools/testing/selftests/bpf/progs/test_ringbuf_multi.c    | 3 ++-
> >  .../testing/selftests/bpf/progs/test_sk_storage_tracing.c | 5 +++--
> >  tools/testing/selftests/bpf/progs/test_skb_helpers.c      | 5 ++---
> >  tools/testing/selftests/bpf/progs/test_stacktrace_map.c   | 5 +++--
> >  tools/testing/selftests/bpf/progs/test_tracepoint.c       | 5 +++--
> >  17 files changed, 41 insertions(+), 30 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 799b88152e9e..5e72d783d3fe 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -279,7 +279,7 @@ MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
> >
> >  CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
> >  BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)                  \
> > -            -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)                   \
> > +            -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR) -I${TOOLSINCDIR}  \
>
> please don't add new include paths unnecessarily. See my comment on
> another patch, if you add those new constants as enums, they will be
> automatically available in vmlinux BTF and thus in auto-generated
> vmlinux.h header (for those programs using it).

Yes, after converting it to enum, the BPF programs can get it from the
generated vmlinux.h.

> For others, I'd just
> leave hard-coded 16 or re-defined TASK_COMM_LEN_16 where appropriate.
>

It seems not all the BPF programs can include the vmlinux.h.
What we really care about here is the copy of task comm should be with
a nul terminator, if we can assure it, then the size used by the BPF
is not important.
I have checked the copy of task comm in all these BPF programs one by
one, and replaced the unsafe bpf_probe_read_kernel() with
bpf_probe_read_kernel_str(), after that change, I think we can leave
hard-coded 16 for the progs which can't include vmlinux.h.

> >              -I$(abspath $(OUTPUT)/../usr/include)
> >
> >  CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
> > diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
> > index 4706cee84360..ac82d57c09dc 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/ringbuf.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
> > @@ -12,6 +12,7 @@
> >  #include <sys/sysinfo.h>
> >  #include <linux/perf_event.h>
> >  #include <linux/ring_buffer.h>
> > +#include <linux/sched/task.h>
> >  #include "test_ringbuf.lskel.h"
> >
> >  #define EDONE 7777
> > @@ -22,7 +23,7 @@ struct sample {
> >         int pid;
> >         int seq;
> >         long value;
> > -       char comm[16];
> > +       char comm[TASK_COMM_LEN_16];
>
> how much value is in this "grep-ability", really? I'm not convinced
> all this code churn is justified.
>
> >  };
> >
> >  static int sample_cnt;
> > diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
> > index 167cd8a2edfd..f0748305ffd6 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
> > @@ -2,6 +2,7 @@
> >  #define _GNU_SOURCE
> >  #include <test_progs.h>
> >  #include <sys/epoll.h>
> > +#include <linux/sched/task.h>
> >  #include "test_ringbuf_multi.skel.h"
> >
> >  static int duration = 0;
>
> [...]


-- 
Thanks
Yafang
