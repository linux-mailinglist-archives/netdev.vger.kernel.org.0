Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B633067F7
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbhA0Xc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 18:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234823AbhA0Xbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 18:31:44 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A774CC061573;
        Wed, 27 Jan 2021 15:31:04 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id w24so3702586ybi.7;
        Wed, 27 Jan 2021 15:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BUnlD5wLx21g0V7L3S3zNSYk2oxfbZxjzKguPsz3fzk=;
        b=QzD0o0DaAUJyZ+Hv8cy1Kb4Dpaw1J+H3iLYk8s5De6qqZWfHYebPvYziAhkaa6VOkF
         SlGgve0Kf5c6axVSJ8Op+D8PxG76Jxg6MQaYUJDD5dpok29lvS+2+twpT3AbC6hih1UL
         enfS5nxZ8od2gXXcjMKpxWBGoAqsxBCJm4Rbv6Zh6BY4hWBxUXKbhh2xYqZOBA3NJjuc
         HJ24WB98f8Fa52st+0Ryo167WUm5xQcfoRsvxJj4ccibeb2Vjg2xS704cZTpMxorbe1y
         SDhFu4X8IuxEfEr6vDv1ZiSVmQeCIYwUAu0C9u+3DpTQFyMIN1q3gkUp0RAt/yZ/CdCp
         4ylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BUnlD5wLx21g0V7L3S3zNSYk2oxfbZxjzKguPsz3fzk=;
        b=SFSLx97W2S579MA2tOXYorfjWi3hqI52sCh2oU3Bhp+s45pBg2UYMnCzYWSqsD47ui
         tyemB5iM36w+y5qrYTDKygNaIXPAg67KDg0B8h01FbsbsYd0AzFBZM9VypmjwgPnCwaI
         /C5Zp5FwFFf3v8zjsqe6ObeTX35cOSZbbLBKobFzk6XoBN3nxFQYKqBFvatboC1qsgvi
         B2FCRPB9M7O1Z0Hxws7pv7yrEX3BBP56EDLum1582hPQ4qN6Tvb9VdHMtgQfxb3fo0jq
         HrGDzxOKwMTcH0ud2p05f9HlTNYyBDQHhox9J3xNpoL1/F8d/E7Zvl8ko4pVv0+iNfBA
         DMpA==
X-Gm-Message-State: AOAM5322IHg+Wyk23p3+dByRsj3fkiMpxGpKVlZo1Pv/Y/10VpdYoS3c
        IXmXl1ooOf8dYE1POVuP+Kzpp8/1aCMFe36FTnI=
X-Google-Smtp-Source: ABdhPJzMUDWE+f3WA5Dqwt0rbQH0oKVi/AibFw5AA8XpC2vIZ5zSogVwTVqbrJVy3g43Yqymhyx8mnE5LhPJ1W2S+B8=
X-Received: by 2002:a25:a183:: with SMTP id a3mr19339891ybi.459.1611790263856;
 Wed, 27 Jan 2021 15:31:03 -0800 (PST)
MIME-Version: 1.0
References: <20210126085923.469759-1-songliubraving@fb.com>
 <20210126085923.469759-3-songliubraving@fb.com> <CAEf4BzZLJc9=JgZBmvRazHsZg+VLihaRi-3Pt8wrsT9am-eBGg@mail.gmail.com>
 <4A77E6CE-82FE-4578-BC13-05583E2EA17D@fb.com>
In-Reply-To: <4A77E6CE-82FE-4578-BC13-05583E2EA17D@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Jan 2021 15:30:53 -0800
Message-ID: <CAEf4Bza22ueyAB4tUo4YAz1L_8+RvNHdcfi75bOVJvROf62UMA@mail.gmail.com>
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
        Kernel Team <Kernel-team@fb.com>, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 1:43 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jan 27, 2021, at 1:21 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Jan 26, 2021 at 1:21 AM Song Liu <songliubraving@fb.com> wrote:
> >>
> >> Task local storage is enabled for tracing programs. Add two tests for
> >> task local storage without CONFIG_BPF_LSM.
> >>
> >> The first test measures the duration of a syscall by storing sys_enter
> >> time in task local storage.
> >>
> >> The second test checks whether the kernel allows allocating task local
> >> storage in exit_creds() (which it should not).
> >>
> >> Signed-off-by: Song Liu <songliubraving@fb.com>
> >> ---
> >> .../bpf/prog_tests/task_local_storage.c       | 85 +++++++++++++++++++
> >> .../selftests/bpf/progs/task_local_storage.c  | 56 ++++++++++++
> >> .../bpf/progs/task_local_storage_exit_creds.c | 32 +++++++
> >> 3 files changed, 173 insertions(+)
> >> create mode 100644 tools/testing/selftests/bpf/prog_tests/task_local_storage.c
> >> create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage.c
> >> create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage_exit_creds.c
> >>
> >> diff --git a/tools/testing/selftests/bpf/prog_tests/task_local_storage.c b/tools/testing/selftests/bpf/prog_tests/task_local_storage.c
> >> new file mode 100644
> >> index 0000000000000..a8e2d3a476145
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/bpf/prog_tests/task_local_storage.c
> >> @@ -0,0 +1,85 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/* Copyright (c) 2021 Facebook */
> >> +
> >> +#include <sys/types.h>
> >> +#include <unistd.h>
> >> +#include <test_progs.h>
> >> +#include "task_local_storage.skel.h"
> >> +#include "task_local_storage_exit_creds.skel.h"
> >> +
> >> +static unsigned int duration;
> >> +
> >> +static void check_usleep_duration(struct task_local_storage *skel,
> >> +                                 __u64 time_us)
> >> +{
> >> +       __u64 syscall_duration;
> >> +
> >> +       usleep(time_us);
> >> +
> >> +       /* save syscall_duration measure in usleep() */
> >> +       syscall_duration = skel->bss->syscall_duration;
> >> +
> >> +       /* time measured by the BPF program (in nanoseconds) should be
> >> +        * within +/- 20% of time_us * 1000.
> >> +        */
> >> +       CHECK(syscall_duration < 800 * time_us, "syscall_duration",
> >> +             "syscall_duration was too small\n");
> >> +       CHECK(syscall_duration > 1200 * time_us, "syscall_duration",
> >> +             "syscall_duration was too big\n");
> >
> > this is going to be very flaky, especially in Travis CI. Can you
> > please use something more stable that doesn't rely on time?
>
> Let me try.
>
> >
> >> +}
> >> +
> >> +static void test_syscall_duration(void)
> >> +{
> >> +       struct task_local_storage *skel;
> >> +       int err;
> >> +
> >> +       skel = task_local_storage__open_and_load();
> >> +       if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
> >> +               return;
> >> +
> >> +       skel->bss->target_pid = getpid();
> >
> > you are getting process ID, but comparing it with thread ID in BPF
> > code. It will stop working properly if/when tests will be run in
> > separate threads, so please use gettid() instead.
>
> Will fix.
>
> >
> >> +
> >> +       err = task_local_storage__attach(skel);
> >> +       if (!ASSERT_OK(err, "skel_attach"))
> >> +               goto out;
> >> +
> >> +       check_usleep_duration(skel, 2000);
> >> +       check_usleep_duration(skel, 3000);
> >> +       check_usleep_duration(skel, 4000);
> >> +
> >> +out:
> >> +       task_local_storage__destroy(skel);
> >> +}
> >> +
> >> +static void test_exit_creds(void)
> >> +{
> >> +       struct task_local_storage_exit_creds *skel;
> >> +       int err;
> >> +
> >> +       skel = task_local_storage_exit_creds__open_and_load();
> >> +       if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
> >> +               return;
> >> +
> >> +       err = task_local_storage_exit_creds__attach(skel);
> >> +       if (!ASSERT_OK(err, "skel_attach"))
> >> +               goto out;
> >> +
> >> +       /* trigger at least one exit_creds() */
> >> +       if (CHECK_FAIL(system("ls > /dev/null")))
> >> +               goto out;
> >> +
> >> +       /* sync rcu, so the following reads could get latest values */
> >> +       kern_sync_rcu();
> >
> > what are we waiting for here? you don't detach anything... system() is
> > definitely going to complete by now, so whatever counter was or was
> > not updated will be reflected here. Seems like kern_sync_rcu() is not
> > needed?
>
> IIUC, without sync_ruc(), even system() is finished, the kernel may not
> have called exit_creds() for the "ls" task yet. Then the following check
> for null_ptr_count != 0 would fail.

Oh, so waiting for exit_creds() invocation which can get delayed, I
see. Would be good to make the above comment a bit more detailed,
thanks!

>
> >
> >> +       ASSERT_EQ(skel->bss->valid_ptr_count, 0, "valid_ptr_count");
> >> +       ASSERT_NEQ(skel->bss->null_ptr_count, 0, "null_ptr_count");
> >> +out:
> >> +       task_local_storage_exit_creds__destroy(skel);
> >> +}
> >> +
> >> +void test_task_local_storage(void)
> >> +{
> >> +       if (test__start_subtest("syscall_duration"))
> >> +               test_syscall_duration();
> >> +       if (test__start_subtest("exit_creds"))
> >> +               test_exit_creds();
> >> +}
> >
> > [...]
> >
> >> +int valid_ptr_count = 0;
> >> +int null_ptr_count = 0;
> >> +
> >> +SEC("fentry/exit_creds")
> >> +int BPF_PROG(trace_exit_creds, struct task_struct *task)
> >> +{
> >> +       __u64 *ptr;
> >> +
> >> +       ptr = bpf_task_storage_get(&task_storage, task, 0,
> >> +                                  BPF_LOCAL_STORAGE_GET_F_CREATE);
> >> +       if (ptr)
> >> +               valid_ptr_count++;
> >> +       else
> >> +               null_ptr_count++;
> >
> >
> > use atomic increments?
>
> Do you mean __sync_fetch_and_add()?

yep

>
> >
> >> +       return 0;
> >> +}
> >> --
> >> 2.24.1
>
