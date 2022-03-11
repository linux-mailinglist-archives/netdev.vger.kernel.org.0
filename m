Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE35D4D56DB
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 01:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240061AbiCKAlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 19:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbiCKAlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 19:41:42 -0500
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77419F94D0;
        Thu, 10 Mar 2022 16:40:40 -0800 (PST)
Received: by mail-lf1-f52.google.com with SMTP id bu29so12492799lfb.0;
        Thu, 10 Mar 2022 16:40:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DP0kU4x8GXKr6JAdKENJlGaBxGTYI5VlsJ14e++YvXE=;
        b=AusvwTcj7K6hXRXUJlax2O/8aluoQgiA/2yzJIcM7SYIQyLjLtu5GbaZgrNdJEAs42
         RwDyv+e7i3na+P5qLPUi6zerfCwVi0iArVPncOVsomihnGJF4kt9ZPQM/Et0iOux+gMu
         hTfZG1osIEb1Q0RKBOSUfdUy7TfLpwI2Zt1pdtv9xV2fm8UyRPolunZGFXDO8cwEB6nn
         IgdinHMEb0ty5pECEcxkCpYa6bROo6ulTod+CRcI0aEhzPM+gCxnSR9R7LZjXqjUf5WA
         /e0gObDY6rl07yi8h5hylY1dOdtxBkGgmiRRm2lnDYMV6Xs73oSkzxt0Cji0j0UyKLeN
         Eatw==
X-Gm-Message-State: AOAM5333FLUkklDZaXVazRfwTxGUs5bLw77NhLtagjzDpMIfmiRc5qiH
        AZ3LjP5h3Z/R4j6RTOpVKcMOlOvQtSXfkqH5NUk=
X-Google-Smtp-Source: ABdhPJwaotV0SJNmxa5dG+49/Wy0pE7hOHMsQHmYsCQetoBaPzl4+5lm9DrL9pP7/gGzkarqb94q24KiqsdqibLTVTE=
X-Received: by 2002:a05:6512:1195:b0:448:4fcc:34f2 with SMTP id
 g21-20020a056512119500b004484fcc34f2mr4406443lfr.454.1646959238796; Thu, 10
 Mar 2022 16:40:38 -0800 (PST)
MIME-Version: 1.0
References: <20220310082202.1229345-1-namhyung@kernel.org> <20220310082202.1229345-2-namhyung@kernel.org>
 <da714be4-3d65-0df5-b60e-37882524ebeb@fb.com>
In-Reply-To: <da714be4-3d65-0df5-b60e-37882524ebeb@fb.com>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Thu, 10 Mar 2022 16:40:27 -0800
Message-ID: <CAM9d7cgoe_omaTb9Ab+7DLZ41Zpm+isbOyi_PmpcPpUJmz5SEQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] bpf/selftests: Test skipping stacktrace
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Eugene Loh <eugene.loh@oracle.com>, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 3:22 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 3/10/22 12:22 AM, Namhyung Kim wrote:
> > Add a test case for stacktrace with skip > 0 using a small sized
> > buffer.  It didn't support skipping entries greater than or equal to
> > the size of buffer and filled the skipped part with 0.
> >
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
> >   .../bpf/prog_tests/stacktrace_map_skip.c      | 72 ++++++++++++++++
> >   .../selftests/bpf/progs/stacktrace_map_skip.c | 82 +++++++++++++++++++
> >   2 files changed, 154 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
> > new file mode 100644
> > index 000000000000..bcb244aa3c78
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
> > @@ -0,0 +1,72 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <test_progs.h>
> > +#include "stacktrace_map_skip.skel.h"
> > +
> > +#define TEST_STACK_DEPTH  2
> > +
> > +void test_stacktrace_map_skip(void)
> > +{
> > +     struct stacktrace_map_skip *skel;
> > +     int control_map_fd, stackid_hmap_fd, stackmap_fd, stack_amap_fd;
> > +     int err, stack_trace_len;
> > +     __u32 key, val, duration = 0;
> > +
> > +     skel = stacktrace_map_skip__open_and_load();
> > +     if (CHECK(!skel, "skel_open_and_load", "skeleton open failed\n"))
> > +             return;
>
> Please use ASSERT_* macros instead of CHECK* macros.
> You can see other prog_tests/*.c files for examples.

I'll take a look and make the changes.

>
> > +
> > +     /* find map fds */
> > +     control_map_fd = bpf_map__fd(skel->maps.control_map);
> > +     if (CHECK_FAIL(control_map_fd < 0))
> > +             goto out;
> > +
> > +     stackid_hmap_fd = bpf_map__fd(skel->maps.stackid_hmap);
> > +     if (CHECK_FAIL(stackid_hmap_fd < 0))
> > +             goto out;
> > +
> > +     stackmap_fd = bpf_map__fd(skel->maps.stackmap);
> > +     if (CHECK_FAIL(stackmap_fd < 0))
> > +             goto out;
> > +
> > +     stack_amap_fd = bpf_map__fd(skel->maps.stack_amap);
> > +     if (CHECK_FAIL(stack_amap_fd < 0))
> > +             goto out;
> > +
> > +     err = stacktrace_map_skip__attach(skel);
> > +     if (CHECK(err, "skel_attach", "skeleton attach failed\n"))
> > +             goto out;
> > +
> > +     /* give some time for bpf program run */
> > +     sleep(1);
> > +
> > +     /* disable stack trace collection */
> > +     key = 0;
> > +     val = 1;
> > +     bpf_map_update_elem(control_map_fd, &key, &val, 0);
> > +
> > +     /* for every element in stackid_hmap, we can find a corresponding one
> > +      * in stackmap, and vise versa.
> > +      */
> > +     err = compare_map_keys(stackid_hmap_fd, stackmap_fd);
> > +     if (CHECK(err, "compare_map_keys stackid_hmap vs. stackmap",
> > +               "err %d errno %d\n", err, errno))
> > +             goto out;
> > +
> > +     err = compare_map_keys(stackmap_fd, stackid_hmap_fd);
> > +     if (CHECK(err, "compare_map_keys stackmap vs. stackid_hmap",
> > +               "err %d errno %d\n", err, errno))
> > +             goto out;
> > +
> > +     stack_trace_len = TEST_STACK_DEPTH * sizeof(__u64);
> > +     err = compare_stack_ips(stackmap_fd, stack_amap_fd, stack_trace_len);
> > +     if (CHECK(err, "compare_stack_ips stackmap vs. stack_amap",
> > +               "err %d errno %d\n", err, errno))
> > +             goto out;
> > +
> > +     if (CHECK(skel->bss->failed, "check skip",
> > +               "failed to skip some depth: %d", skel->bss->failed))
> > +             goto out;
> > +
> > +out:
> > +     stacktrace_map_skip__destroy(skel);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c b/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
> > new file mode 100644
> > index 000000000000..323248b17ae4
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
> > @@ -0,0 +1,82 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <vmlinux.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +#define TEST_STACK_DEPTH         2
> > +
> > +struct {
> > +     __uint(type, BPF_MAP_TYPE_ARRAY);
> > +     __uint(max_entries, 1);
> > +     __type(key, __u32);
> > +     __type(value, __u32);
> > +} control_map SEC(".maps");
>
> You can use a global variable for this.
> The global variable can be assigned a value (if needed, e.g., non-zero)
> before skeleton open and load.

Right, will change.

>
> > +
> > +struct {
> > +     __uint(type, BPF_MAP_TYPE_HASH);
> > +     __uint(max_entries, 16384);
> > +     __type(key, __u32);
> > +     __type(value, __u32);
> > +} stackid_hmap SEC(".maps");
> > +
> > +typedef __u64 stack_trace_t[TEST_STACK_DEPTH];
> > +
> > +struct {
> > +     __uint(type, BPF_MAP_TYPE_STACK_TRACE);
> > +     __uint(max_entries, 16384);
> > +     __type(key, __u32);
> > +     __type(value, stack_trace_t);
> > +} stackmap SEC(".maps");
> > +
> > +struct {
> > +     __uint(type, BPF_MAP_TYPE_ARRAY);
> > +     __uint(max_entries, 16384);
> > +     __type(key, __u32);
> > +     __type(value, stack_trace_t);
> > +} stack_amap SEC(".maps");
> > +
> > +/* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
> > +struct sched_switch_args {
> > +     unsigned long long pad;
> > +     char prev_comm[TASK_COMM_LEN];
> > +     int prev_pid;
> > +     int prev_prio;
> > +     long long prev_state;
> > +     char next_comm[TASK_COMM_LEN];
> > +     int next_pid;
> > +     int next_prio;
> > +};
>
> You can use this structure in vmlinux.h instead of the above:
> struct trace_event_raw_sched_switch {
>          struct trace_entry ent;
>          char prev_comm[16];
>          pid_t prev_pid;
>          int prev_prio;
>          long int prev_state;
>          char next_comm[16];
>          pid_t next_pid;
>          int next_prio;
>          char __data[0];
> };

Looks good, will change.

>
> > +
> > +int failed = 0;
> > +
> > +SEC("tracepoint/sched/sched_switch")
> > +int oncpu(struct sched_switch_args *ctx)
> > +{
> > +     __u32 max_len = TEST_STACK_DEPTH * sizeof(__u64);
> > +     __u32 key = 0, val = 0, *value_p;
> > +     __u64 *stack_p;
> > +
> > +     value_p = bpf_map_lookup_elem(&control_map, &key);
> > +     if (value_p && *value_p)
> > +             return 0; /* skip if non-zero *value_p */
> > +
> > +     /* it should allow skipping whole buffer size entries */
> > +     key = bpf_get_stackid(ctx, &stackmap, TEST_STACK_DEPTH);
> > +     if ((int)key >= 0) {
> > +             /* The size of stackmap and stack_amap should be the same */
> > +             bpf_map_update_elem(&stackid_hmap, &key, &val, 0);
> > +             stack_p = bpf_map_lookup_elem(&stack_amap, &key);
> > +             if (stack_p) {
> > +                     bpf_get_stack(ctx, stack_p, max_len, TEST_STACK_DEPTH);
> > +                     /* it wrongly skipped all the entries and filled zero */
> > +                     if (stack_p[0] == 0)
> > +                             failed = 1;
> > +             }
> > +     } else if ((int)key == -14/*EFAULT*/) {
> > +             /* old kernel doesn't support skipping that many entries */
> > +             failed = 2;
>
> The selftest is supposed to run with the kernel in the same code base.
> So it is okay to skip the above 'if' test and just set failed = 2.

I see.  I will make the change.

Thanks,
Namhyung

>
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +char _license[] SEC("license") = "GPL";
