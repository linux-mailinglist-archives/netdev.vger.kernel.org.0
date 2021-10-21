Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D13436DAF
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 00:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhJUWqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 18:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhJUWqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 18:46:43 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1510C061764;
        Thu, 21 Oct 2021 15:44:26 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id l201so2727444ybl.9;
        Thu, 21 Oct 2021 15:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=09kdkVZkmd58ejES1AAZZfHSG8+rA+GkSwWN7PbT0k0=;
        b=hLUAMOcL2RTbMgWy6y11jsBkZHOABEo03iqfAd90gR2W4kHPemBNJsnSfuWEuPxQ9l
         4wqlBNlnOfP7xY76kXIOKT6pPM4p2++hWDHiRJyqKD7Qo8Y6uWidKlbvUmHWxcQfviyv
         eE1vy/KLTnvKlNrUsWrAXMain0ONjmo9X4k78Lv7i6Yd9MoPZ1v7iEQsHjgtUNs15bdF
         gqolL+xQdENH3Xfa2TH4TOKhQRZdHTWMeC8aPXvvSqdeJtSOmMPD1pGthL6WLQHjgtPK
         ZSsPJH+E6LnNdyqFdnIASQFdgxPj6GOrHiy2TstfBCWiS5hM32RiNt/TEGuGvtLvf7jw
         2JBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=09kdkVZkmd58ejES1AAZZfHSG8+rA+GkSwWN7PbT0k0=;
        b=TqX2eyrdtkRussTMQn8UKBfrVXtZxJzZhzJx71jtqXArkTxRr+YPj8SoHYEVaETRHl
         s8QKIm2rwj8JIW3VCe0FTYe2VHV1TW4rh2DFxXRByNnDX7NiCjqDHuf7VbKcKVcVJkHo
         QB+WQqReN1eBo4Flu8PX2VTDZEl9SHa4tSyPMerw17O/PkIagmq4rdfBZu+H/Vk98/ba
         7OjULym/AlmUZ38MWzvNNyY7GcKmf1RzzI+gQn/mKsxa9gVa35R3Sz5i3ICKrxi9e6RX
         uC8VxoVNi+OgYv+QwUsnWS1ADL76bsLJyf283zvzVeFsKf4gUo1dZ0ag8b9n6YuOdMmP
         6PrQ==
X-Gm-Message-State: AOAM532kdnB/5g1JlPDXIsA9sj+su6sLLgHkBJgDjKHVjPurc4+Z+0Xp
        VeF+HlMLzzS13kTZLt/ch3Ni8uG6YfJzEGuEJcs=
X-Google-Smtp-Source: ABdhPJx/E3dp41LdklMiO6BNnVl71z/dxyneF9NI9t0qPB/1mcpduZSBqldy0/PlIUQo005/X1bU0N0lAGv76MWJLis=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr9586804ybj.504.1634856266057;
 Thu, 21 Oct 2021 15:44:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211021034603.4458-1-laoar.shao@gmail.com> <20211021034603.4458-4-laoar.shao@gmail.com>
In-Reply-To: <20211021034603.4458-4-laoar.shao@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 Oct 2021 15:44:15 -0700
Message-ID: <CAEf4BzYTEoDwWzXd91MeMH5Qr9L853Ff3Qq8_wnwfJ8GK0oLnw@mail.gmail.com>
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
        qiang.zhang@windriver.com, robdclark@chromium.org,
        Christian Brauner <christian@brauner.io>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>, juri.lelli@redhat.com,
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
        oliver.sang@intel.com, kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 8:46 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> The hard-coded 16 is used in various bpf progs. These progs get task
> comm either via bpf_get_current_comm() or prctl() or
> bpf_core_read_str(), all of which can work well even if the task comm size
> is changed.
> Below is the detailed information,
>
> bpf_get_current_comm:
>     progs/test_ringbuf.c
>     progs/test_ringbuf_multi.c
>
> prctl:
>     prog_tests/test_overhead.c
>     prog_tests/trampoline_count.c
>
> bpf_core_read_str:
>     progs/test_core_reloc_kernel.c
>     progs/test_sk_storage_tracing.c
>
> We'd better replace the hard-coded 16 with TASK_COMM_LEN_16 to make it
> more grepable.
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Petr Mladek <pmladek@suse.com>
> ---
>  tools/testing/selftests/bpf/Makefile                      | 2 +-
>  tools/testing/selftests/bpf/prog_tests/ringbuf.c          | 3 ++-
>  tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c    | 3 ++-
>  .../testing/selftests/bpf/prog_tests/sk_storage_tracing.c | 3 ++-
>  tools/testing/selftests/bpf/prog_tests/test_overhead.c    | 3 ++-
>  tools/testing/selftests/bpf/prog_tests/trampoline_count.c | 3 ++-
>  tools/testing/selftests/bpf/progs/profiler.h              | 7 ++++---
>  tools/testing/selftests/bpf/progs/profiler.inc.h          | 8 ++++----
>  tools/testing/selftests/bpf/progs/pyperf.h                | 4 ++--
>  tools/testing/selftests/bpf/progs/strobemeta.h            | 6 +++---
>  .../testing/selftests/bpf/progs/test_core_reloc_kernel.c  | 3 ++-
>  tools/testing/selftests/bpf/progs/test_ringbuf.c          | 3 ++-
>  tools/testing/selftests/bpf/progs/test_ringbuf_multi.c    | 3 ++-
>  .../testing/selftests/bpf/progs/test_sk_storage_tracing.c | 5 +++--
>  tools/testing/selftests/bpf/progs/test_skb_helpers.c      | 5 ++---
>  tools/testing/selftests/bpf/progs/test_stacktrace_map.c   | 5 +++--
>  tools/testing/selftests/bpf/progs/test_tracepoint.c       | 5 +++--
>  17 files changed, 41 insertions(+), 30 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 799b88152e9e..5e72d783d3fe 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -279,7 +279,7 @@ MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
>
>  CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
>  BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)                  \
> -            -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)                   \
> +            -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR) -I${TOOLSINCDIR}  \

please don't add new include paths unnecessarily. See my comment on
another patch, if you add those new constants as enums, they will be
automatically available in vmlinux BTF and thus in auto-generated
vmlinux.h header (for those programs using it). For others, I'd just
leave hard-coded 16 or re-defined TASK_COMM_LEN_16 where appropriate.

>              -I$(abspath $(OUTPUT)/../usr/include)
>
>  CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
> diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
> index 4706cee84360..ac82d57c09dc 100644
> --- a/tools/testing/selftests/bpf/prog_tests/ringbuf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
> @@ -12,6 +12,7 @@
>  #include <sys/sysinfo.h>
>  #include <linux/perf_event.h>
>  #include <linux/ring_buffer.h>
> +#include <linux/sched/task.h>
>  #include "test_ringbuf.lskel.h"
>
>  #define EDONE 7777
> @@ -22,7 +23,7 @@ struct sample {
>         int pid;
>         int seq;
>         long value;
> -       char comm[16];
> +       char comm[TASK_COMM_LEN_16];

how much value is in this "grep-ability", really? I'm not convinced
all this code churn is justified.

>  };
>
>  static int sample_cnt;
> diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
> index 167cd8a2edfd..f0748305ffd6 100644
> --- a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
> +++ b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
> @@ -2,6 +2,7 @@
>  #define _GNU_SOURCE
>  #include <test_progs.h>
>  #include <sys/epoll.h>
> +#include <linux/sched/task.h>
>  #include "test_ringbuf_multi.skel.h"
>
>  static int duration = 0;

[...]
