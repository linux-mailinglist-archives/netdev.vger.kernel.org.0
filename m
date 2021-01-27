Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3683065EC
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 22:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhA0VWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 16:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbhA0VWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 16:22:23 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B38C061573;
        Wed, 27 Jan 2021 13:21:43 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id w24so3420292ybi.7;
        Wed, 27 Jan 2021 13:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BRPZ4D+C/ROPLOS9wpCMTb0wBg9l/hdG9nGUxbgvdbE=;
        b=lxwsnAUBmN7o8FlV9lUT6PX3wvKhLRcwjAhH3Ii6IEfjhlFdz9HUofyVI2OvqXBWiv
         FDTesI+Y46bNgjfDfytQod9mlarEJnFKOjUMj12xiLuaUNSUup1UMDdLcAK5iaeVnVLc
         B+8giBnM+zREQJYEEBvx8LdaTpo6Q03tTw/jdvO6VaO92LI9fdO22hRIhRXN+yUcVay7
         fTTn7qIfaVker9+ujnZBizGOAMAHCPj6cztIJD1A+m243Eo8FDThEOpaQrmViuEk+G9s
         Bn8Xb3++MEHKSoqhrt6Q9DpEjAI40UagtuSIRdnq5ylX1NZAT7cV6qtHdffcAIyLvDvZ
         cn4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BRPZ4D+C/ROPLOS9wpCMTb0wBg9l/hdG9nGUxbgvdbE=;
        b=TcERaMECaP+9bSSdbfaE8DeKA4nvokEe2AfqEifRFKD9OpLXsMAaDlU/IJaEFk/rF6
         /PIVtT+C5RbHxGvfrhCRdy7uB9PzZgIcJCDiX2ME6PNw9olbohBIQ1aAV7vSG3d9bNMJ
         vyq2wqLn2eUAHp3sU/NF2KLnP3Rg6J42dRA0QjfN6YINkU34yBwSr7OUn3MTntkfzNgt
         fLZgvPaKQr/wMXi1hr5MYpco/PGaIxxsaBz3/iElwwPWOb42vAHV/dzOzvqdxylUt20h
         Hm3Kunli+VhQJrpyjaJHU4j3XL7hRZQ0jUC+JV/iGwaRsQochHxyCoPo0vZ50K5kIJMU
         R1sQ==
X-Gm-Message-State: AOAM531WxfSBdkWOycsB81Xp6YOEmeVgqNfViUiNig9O4scvtuXdgqE9
        6qgo8RWLdJuLVwpQqdbuTaJpFdptjItn06hU5nQ=
X-Google-Smtp-Source: ABdhPJwtMEg/Ci97Ou+PD/qWyfBeMJH887qqDVU1QDPvaDQxMdmdXAJ37a7H8+au/rMwfg4hAjx7Zq3BsDxEh1C+8BU=
X-Received: by 2002:a25:9882:: with SMTP id l2mr18227840ybo.425.1611782502851;
 Wed, 27 Jan 2021 13:21:42 -0800 (PST)
MIME-Version: 1.0
References: <20210126085923.469759-1-songliubraving@fb.com> <20210126085923.469759-3-songliubraving@fb.com>
In-Reply-To: <20210126085923.469759-3-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Jan 2021 13:21:32 -0800
Message-ID: <CAEf4BzZLJc9=JgZBmvRazHsZg+VLihaRi-3Pt8wrsT9am-eBGg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/4] selftests/bpf: add non-BPF_LSM test for
 task local storage
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Ziljstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 1:21 AM Song Liu <songliubraving@fb.com> wrote:
>
> Task local storage is enabled for tracing programs. Add two tests for
> task local storage without CONFIG_BPF_LSM.
>
> The first test measures the duration of a syscall by storing sys_enter
> time in task local storage.
>
> The second test checks whether the kernel allows allocating task local
> storage in exit_creds() (which it should not).
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  .../bpf/prog_tests/task_local_storage.c       | 85 +++++++++++++++++++
>  .../selftests/bpf/progs/task_local_storage.c  | 56 ++++++++++++
>  .../bpf/progs/task_local_storage_exit_creds.c | 32 +++++++
>  3 files changed, 173 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/task_local_storage.c
>  create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage.c
>  create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage_exit_creds.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/task_local_storage.c b/tools/testing/selftests/bpf/prog_tests/task_local_storage.c
> new file mode 100644
> index 0000000000000..a8e2d3a476145
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/task_local_storage.c
> @@ -0,0 +1,85 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +
> +#include <sys/types.h>
> +#include <unistd.h>
> +#include <test_progs.h>
> +#include "task_local_storage.skel.h"
> +#include "task_local_storage_exit_creds.skel.h"
> +
> +static unsigned int duration;
> +
> +static void check_usleep_duration(struct task_local_storage *skel,
> +                                 __u64 time_us)
> +{
> +       __u64 syscall_duration;
> +
> +       usleep(time_us);
> +
> +       /* save syscall_duration measure in usleep() */
> +       syscall_duration = skel->bss->syscall_duration;
> +
> +       /* time measured by the BPF program (in nanoseconds) should be
> +        * within +/- 20% of time_us * 1000.
> +        */
> +       CHECK(syscall_duration < 800 * time_us, "syscall_duration",
> +             "syscall_duration was too small\n");
> +       CHECK(syscall_duration > 1200 * time_us, "syscall_duration",
> +             "syscall_duration was too big\n");

this is going to be very flaky, especially in Travis CI. Can you
please use something more stable that doesn't rely on time?

> +}
> +
> +static void test_syscall_duration(void)
> +{
> +       struct task_local_storage *skel;
> +       int err;
> +
> +       skel = task_local_storage__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
> +               return;
> +
> +       skel->bss->target_pid = getpid();

you are getting process ID, but comparing it with thread ID in BPF
code. It will stop working properly if/when tests will be run in
separate threads, so please use gettid() instead.

> +
> +       err = task_local_storage__attach(skel);
> +       if (!ASSERT_OK(err, "skel_attach"))
> +               goto out;
> +
> +       check_usleep_duration(skel, 2000);
> +       check_usleep_duration(skel, 3000);
> +       check_usleep_duration(skel, 4000);
> +
> +out:
> +       task_local_storage__destroy(skel);
> +}
> +
> +static void test_exit_creds(void)
> +{
> +       struct task_local_storage_exit_creds *skel;
> +       int err;
> +
> +       skel = task_local_storage_exit_creds__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
> +               return;
> +
> +       err = task_local_storage_exit_creds__attach(skel);
> +       if (!ASSERT_OK(err, "skel_attach"))
> +               goto out;
> +
> +       /* trigger at least one exit_creds() */
> +       if (CHECK_FAIL(system("ls > /dev/null")))
> +               goto out;
> +
> +       /* sync rcu, so the following reads could get latest values */
> +       kern_sync_rcu();

what are we waiting for here? you don't detach anything... system() is
definitely going to complete by now, so whatever counter was or was
not updated will be reflected here. Seems like kern_sync_rcu() is not
needed?

> +       ASSERT_EQ(skel->bss->valid_ptr_count, 0, "valid_ptr_count");
> +       ASSERT_NEQ(skel->bss->null_ptr_count, 0, "null_ptr_count");
> +out:
> +       task_local_storage_exit_creds__destroy(skel);
> +}
> +
> +void test_task_local_storage(void)
> +{
> +       if (test__start_subtest("syscall_duration"))
> +               test_syscall_duration();
> +       if (test__start_subtest("exit_creds"))
> +               test_exit_creds();
> +}

[...]

> +int valid_ptr_count = 0;
> +int null_ptr_count = 0;
> +
> +SEC("fentry/exit_creds")
> +int BPF_PROG(trace_exit_creds, struct task_struct *task)
> +{
> +       __u64 *ptr;
> +
> +       ptr = bpf_task_storage_get(&task_storage, task, 0,
> +                                  BPF_LOCAL_STORAGE_GET_F_CREATE);
> +       if (ptr)
> +               valid_ptr_count++;
> +       else
> +               null_ptr_count++;


use atomic increments?

> +       return 0;
> +}
> --
> 2.24.1
>
