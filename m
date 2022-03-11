Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80734D6A4F
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiCKWt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiCKWtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:49:20 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C0F1587BF;
        Fri, 11 Mar 2022 14:23:16 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id r11so11727895ioh.10;
        Fri, 11 Mar 2022 14:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c1oesbnKmDcQXvY8yfzmiNzpMiDAOHp1ykwgmMM9nlA=;
        b=iwTjtfvGojQ9KUq3c8HJ/wzYbGP8a7/Q5qUFesXx9rh96Q/IUb6knVDfAhWgIKOOZj
         EykXMAr7pZKSKyL2yqW0e33Zt4QxbhU8vN5MCcWydDoUn2zuAJ4DKbHhN6cQE6lkyd+I
         m93QcP7aAxT9Zjvn+iCiQB35YqHSNwMuprvXouukaGiwns8vKOrC8cN5Ai3HEFK9mGMG
         7guuT8T3tNFNKY+brnd3DwrJyAU/s9eUb/12MTPQ0hcISikHC7fFdSJ3n+Q4UkZy6YXm
         AuvwSu+To65uNZCioQlzvn9BSb4AbGotlELegsJx3oWVWkH648eaRgdpyf1Q1PIMgcS8
         1C7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c1oesbnKmDcQXvY8yfzmiNzpMiDAOHp1ykwgmMM9nlA=;
        b=d4VOIY3XVcygor5ePqjy0LsigTK0XZJBT7yTAYCeor45tRnkQDT7j2kQuNF8kQA7Q4
         tJX68cAQcHz4rb51F55z8Bf17ZEa5EWkr1SX/VzdeX8s+qJgJ7teUzthOf8iDZKfhUV7
         OeJpkoru51eLKAYRt+UhqwZOwOMymJeVy6ZZH7p5q1/VOMqQTSUluPddgbjoM5Tsh/Pr
         oFAqu0yq6YXE/+aVbAAPCgX5vS+Ag30q7tzoVfnWuCV1vy+VH4h9cZskUegKFgFpga2T
         2QuOpPrgt1YdwRL8Ii7+AV8i1VUMiqVCUFCal16evPwdSDKGKEPiST3Vrj1VwNKUCXcB
         R2aA==
X-Gm-Message-State: AOAM530pNmnVO5WIQby6/6J20fc6RPfWrft4Tbq7oal2f4RMqNptP387
        DtsD+MzVLmEEFLNBhvDWAr7+oKwUvRJapAtU4Rc=
X-Google-Smtp-Source: ABdhPJxkLN6itSSQGHJQzD9aspp0hOVSsIwmlG2LO+lBCNVlra1XsQGYdTFQvWXM6bMb8lIqj26JC8xgMJsNUQBtI/I=
X-Received: by 2002:a05:6602:185a:b0:645:d914:35e9 with SMTP id
 d26-20020a056602185a00b00645d91435e9mr9402831ioi.154.1647037395766; Fri, 11
 Mar 2022 14:23:15 -0800 (PST)
MIME-Version: 1.0
References: <20220310082202.1229345-1-namhyung@kernel.org> <20220310082202.1229345-2-namhyung@kernel.org>
In-Reply-To: <20220310082202.1229345-2-namhyung@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Mar 2022 14:23:04 -0800
Message-ID: <CAEf4BzZUEvCqz-zGdKAeyg3vywEEnFWuZ4Q446BrTGOsFqNqyQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] bpf/selftests: Test skipping stacktrace
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Eugene Loh <eugene.loh@oracle.com>, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 12:22 AM Namhyung Kim <namhyung@kernel.org> wrote:
>
> Add a test case for stacktrace with skip > 0 using a small sized
> buffer.  It didn't support skipping entries greater than or equal to
> the size of buffer and filled the skipped part with 0.
>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  .../bpf/prog_tests/stacktrace_map_skip.c      | 72 ++++++++++++++++
>  .../selftests/bpf/progs/stacktrace_map_skip.c | 82 +++++++++++++++++++
>  2 files changed, 154 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
>  create mode 100644 tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
> new file mode 100644
> index 000000000000..bcb244aa3c78
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
> @@ -0,0 +1,72 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include "stacktrace_map_skip.skel.h"
> +
> +#define TEST_STACK_DEPTH  2
> +
> +void test_stacktrace_map_skip(void)
> +{
> +       struct stacktrace_map_skip *skel;
> +       int control_map_fd, stackid_hmap_fd, stackmap_fd, stack_amap_fd;
> +       int err, stack_trace_len;
> +       __u32 key, val, duration = 0;
> +
> +       skel = stacktrace_map_skip__open_and_load();
> +       if (CHECK(!skel, "skel_open_and_load", "skeleton open failed\n"))
> +               return;
> +
> +       /* find map fds */
> +       control_map_fd = bpf_map__fd(skel->maps.control_map);
> +       if (CHECK_FAIL(control_map_fd < 0))
> +               goto out;
> +
> +       stackid_hmap_fd = bpf_map__fd(skel->maps.stackid_hmap);
> +       if (CHECK_FAIL(stackid_hmap_fd < 0))
> +               goto out;
> +
> +       stackmap_fd = bpf_map__fd(skel->maps.stackmap);
> +       if (CHECK_FAIL(stackmap_fd < 0))
> +               goto out;
> +
> +       stack_amap_fd = bpf_map__fd(skel->maps.stack_amap);
> +       if (CHECK_FAIL(stack_amap_fd < 0))
> +               goto out;
> +
> +       err = stacktrace_map_skip__attach(skel);
> +       if (CHECK(err, "skel_attach", "skeleton attach failed\n"))
> +               goto out;
> +
> +       /* give some time for bpf program run */
> +       sleep(1);
> +
> +       /* disable stack trace collection */
> +       key = 0;
> +       val = 1;
> +       bpf_map_update_elem(control_map_fd, &key, &val, 0);
> +
> +       /* for every element in stackid_hmap, we can find a corresponding one
> +        * in stackmap, and vise versa.
> +        */
> +       err = compare_map_keys(stackid_hmap_fd, stackmap_fd);
> +       if (CHECK(err, "compare_map_keys stackid_hmap vs. stackmap",
> +                 "err %d errno %d\n", err, errno))
> +               goto out;
> +
> +       err = compare_map_keys(stackmap_fd, stackid_hmap_fd);
> +       if (CHECK(err, "compare_map_keys stackmap vs. stackid_hmap",
> +                 "err %d errno %d\n", err, errno))
> +               goto out;
> +
> +       stack_trace_len = TEST_STACK_DEPTH * sizeof(__u64);
> +       err = compare_stack_ips(stackmap_fd, stack_amap_fd, stack_trace_len);
> +       if (CHECK(err, "compare_stack_ips stackmap vs. stack_amap",
> +                 "err %d errno %d\n", err, errno))
> +               goto out;
> +
> +       if (CHECK(skel->bss->failed, "check skip",
> +                 "failed to skip some depth: %d", skel->bss->failed))
> +               goto out;
> +
> +out:
> +       stacktrace_map_skip__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c b/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
> new file mode 100644
> index 000000000000..323248b17ae4
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
> @@ -0,0 +1,82 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <vmlinux.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#define TEST_STACK_DEPTH         2
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(max_entries, 1);
> +       __type(key, __u32);
> +       __type(value, __u32);
> +} control_map SEC(".maps");
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_HASH);
> +       __uint(max_entries, 16384);
> +       __type(key, __u32);
> +       __type(value, __u32);
> +} stackid_hmap SEC(".maps");
> +
> +typedef __u64 stack_trace_t[TEST_STACK_DEPTH];
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_STACK_TRACE);
> +       __uint(max_entries, 16384);
> +       __type(key, __u32);
> +       __type(value, stack_trace_t);
> +} stackmap SEC(".maps");
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(max_entries, 16384);
> +       __type(key, __u32);
> +       __type(value, stack_trace_t);
> +} stack_amap SEC(".maps");
> +
> +/* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
> +struct sched_switch_args {
> +       unsigned long long pad;
> +       char prev_comm[TASK_COMM_LEN];
> +       int prev_pid;
> +       int prev_prio;
> +       long long prev_state;
> +       char next_comm[TASK_COMM_LEN];
> +       int next_pid;
> +       int next_prio;
> +};
> +
> +int failed = 0;
> +
> +SEC("tracepoint/sched/sched_switch")
> +int oncpu(struct sched_switch_args *ctx)
> +{
> +       __u32 max_len = TEST_STACK_DEPTH * sizeof(__u64);
> +       __u32 key = 0, val = 0, *value_p;
> +       __u64 *stack_p;
> +

please also add filtering by PID to avoid interference from other
selftests when run in parallel mode

> +       value_p = bpf_map_lookup_elem(&control_map, &key);
> +       if (value_p && *value_p)
> +               return 0; /* skip if non-zero *value_p */
> +
> +       /* it should allow skipping whole buffer size entries */
> +       key = bpf_get_stackid(ctx, &stackmap, TEST_STACK_DEPTH);
> +       if ((int)key >= 0) {
> +               /* The size of stackmap and stack_amap should be the same */
> +               bpf_map_update_elem(&stackid_hmap, &key, &val, 0);
> +               stack_p = bpf_map_lookup_elem(&stack_amap, &key);
> +               if (stack_p) {
> +                       bpf_get_stack(ctx, stack_p, max_len, TEST_STACK_DEPTH);
> +                       /* it wrongly skipped all the entries and filled zero */
> +                       if (stack_p[0] == 0)
> +                               failed = 1;
> +               }
> +       } else if ((int)key == -14/*EFAULT*/) {
> +               /* old kernel doesn't support skipping that many entries */
> +               failed = 2;
> +       }
> +
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.35.1.723.g4982287a31-goog
>
