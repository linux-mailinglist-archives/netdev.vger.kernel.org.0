Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881E9221C4D
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 08:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgGPGFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 02:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgGPGFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 02:05:10 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B428C061755;
        Wed, 15 Jul 2020 23:05:10 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id e13so4512677qkg.5;
        Wed, 15 Jul 2020 23:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C/Sx3DD1xiFaSouN+hVZkXpnDAPJUJUqVEbjzUVKBjY=;
        b=hjKUUYbaz0sPmdc6UkL8TZ4OoDP5uCGuba45k0YMT6bu+EKvgOa1BPJ6yRhs9m7cq6
         CTjX45iH8nxWh9STseaR2UkX8wBd/vgoJ188UbrshIEKILPkp1IL+XCnhQ9G4gKYWGb1
         gZHn6ivhyTnaOSMhs7Ow6/q/kXFmIjybLHzwW6PuVBNsroG/OgP8aPZFryIV14rKwTpO
         ITK1GBBw06ZPq+uPik67Q6qUvxzmYe1akszXBinO20+G1+8H3ZzSmrgGfQ4QzMzAkQ4d
         ATxa7jrwbD6Wp5bo7p1Sdg6M1aw36MfNtGMW/HufqTeqg/8JgpMvzt+CP2khPp9rLwhf
         NSfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C/Sx3DD1xiFaSouN+hVZkXpnDAPJUJUqVEbjzUVKBjY=;
        b=cU3m+nMXEWRBtZr7NirE9oYUnIcZjOQaXVGMLB2oImhynyS9MfOIJoU7e3Bg/gGXFX
         pB68t5Hp4E0pkqGdvaOQrEFaYRE4JHiqdkJsKaVvMSp2xNNziXWIdUulMZ7SjaHJ3sTw
         P4d4xtgvooSughihjwBGU4LtdSTkZ/xmh6AHq1RyuKhOdKqq1TK5ndiGPeS7BwGU6eJb
         Qabl+0OGiaRIyagnkMZ2PBAIzc1jojNHiriy4D+Xte0rq396JZelV81/XtZSrHKcpF44
         VTzu3NO0j+iPt74VkBgOD5AsnC6NwcexEzv98SX+dTmec7kwEeR+FfhQZ/UD00zzUV/G
         jlRQ==
X-Gm-Message-State: AOAM530oW8+mCnjkUCVcEAZzs8bs4SlcHTD4RAfamkHqlIyITKyiVAMp
        8D4VvQzbVX0hmnWL9IIMUZr+SESuw0fAFFOgw8M=
X-Google-Smtp-Source: ABdhPJxsUjKeetvu0GriGmGx8SewSAdbVUPi3lkk8oiAMpiNXMbWGBd3Uk1PlySj3VC0hVbyi/jEMpgm4s/WCadMCXI=
X-Received: by 2002:ae9:f002:: with SMTP id l2mr2532019qkg.437.1594879509565;
 Wed, 15 Jul 2020 23:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200715052601.2404533-1-songliubraving@fb.com> <20200715052601.2404533-3-songliubraving@fb.com>
In-Reply-To: <20200715052601.2404533-3-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jul 2020 23:04:58 -0700
Message-ID: <CAEf4BzZdvBKp6WO+zUTF0F9iL2WaukvTWNGZggUPx-nwESpQ7w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/2] selftests/bpf: add callchain_stackid
To:     Song Liu <songliubraving@fb.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Peter Ziljstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 11:09 PM Song Liu <songliubraving@fb.com> wrote:
>
> This tests new helper function bpf_get_stackid_pe and bpf_get_stack_pe.
> These two helpers have different implementation for perf_event with PEB
> entries.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  .../bpf/prog_tests/perf_event_stackmap.c      | 120 ++++++++++++++++++
>  .../selftests/bpf/progs/perf_event_stackmap.c |  64 ++++++++++
>  2 files changed, 184 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_event_stackmap.c
>  create mode 100644 tools/testing/selftests/bpf/progs/perf_event_stackmap.c
>

Just few simplification suggestions, but overall looks good, so please add:

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]

> +
> +void test_perf_event_stackmap(void)
> +{
> +       struct perf_event_attr attr = {
> +               /* .type = PERF_TYPE_SOFTWARE, */
> +               .type = PERF_TYPE_HARDWARE,
> +               .config = PERF_COUNT_HW_CPU_CYCLES,
> +               .precise_ip = 2,
> +               .sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_BRANCH_STACK |
> +                       PERF_SAMPLE_CALLCHAIN,
> +               .branch_sample_type = PERF_SAMPLE_BRANCH_USER |
> +                       PERF_SAMPLE_BRANCH_NO_FLAGS |
> +                       PERF_SAMPLE_BRANCH_NO_CYCLES |
> +                       PERF_SAMPLE_BRANCH_CALL_STACK,
> +               .sample_period = 5000,
> +               .size = sizeof(struct perf_event_attr),
> +       };
> +       struct perf_event_stackmap *skel;
> +       __u32 duration = 0;
> +       cpu_set_t cpu_set;
> +       int pmu_fd, err;
> +
> +       skel = perf_event_stackmap__open();
> +
> +       if (CHECK(!skel, "skel_open", "skeleton open failed\n"))
> +               return;
> +
> +       /* override program type */
> +       bpf_program__set_perf_event(skel->progs.oncpu);

this should be unnecessary, didn't libbpf detect the type correctly
from SEC? If not, let's fix that.

> +
> +       err = perf_event_stackmap__load(skel);
> +       if (CHECK(err, "skel_load", "skeleton load failed: %d\n", err))
> +               goto cleanup;
> +
> +       CPU_ZERO(&cpu_set);
> +       CPU_SET(0, &cpu_set);
> +       err = pthread_setaffinity_np(pthread_self(), sizeof(cpu_set), &cpu_set);
> +       if (CHECK(err, "set_affinity", "err %d, errno %d\n", err, errno))
> +               goto cleanup;
> +
> +       pmu_fd = syscall(__NR_perf_event_open, &attr, -1 /* pid */,
> +                        0 /* cpu 0 */, -1 /* group id */,
> +                        0 /* flags */);
> +       if (pmu_fd < 0) {
> +               printf("%s:SKIP:cpu doesn't support the event\n", __func__);
> +               test__skip();
> +               goto cleanup;
> +       }
> +
> +       skel->links.oncpu = bpf_program__attach_perf_event(skel->progs.oncpu,
> +                                                          pmu_fd);
> +       if (CHECK(IS_ERR(skel->links.oncpu), "attach_perf_event",
> +                 "err %ld\n", PTR_ERR(skel->links.oncpu))) {
> +               close(pmu_fd);
> +               goto cleanup;
> +       }
> +
> +       /* create kernel and user stack traces for testing */
> +       func_6();
> +
> +       CHECK(skel->data->stackid_kernel != 2, "get_stackid_kernel", "failed\n");
> +       CHECK(skel->data->stackid_user != 2, "get_stackid_user", "failed\n");
> +       CHECK(skel->data->stack_kernel != 2, "get_stack_kernel", "failed\n");
> +       CHECK(skel->data->stack_user != 2, "get_stack_user", "failed\n");
> +       close(pmu_fd);

I think pmu_fd will be closed by perf_event_stackmap__destory (through
closing the link)

> +
> +cleanup:
> +       perf_event_stackmap__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/perf_event_stackmap.c b/tools/testing/selftests/bpf/progs/perf_event_stackmap.c
> new file mode 100644
> index 0000000000000..1b0457efeedec
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/perf_event_stackmap.c
> @@ -0,0 +1,64 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2020 Facebook
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +
> +#ifndef PERF_MAX_STACK_DEPTH
> +#define PERF_MAX_STACK_DEPTH         127
> +#endif
> +
> +#ifndef BPF_F_USER_STACK
> +#define BPF_F_USER_STACK               (1ULL << 8)
> +#endif

BPF_F_USER_STACK should be in vmlinux.h already, similarly to BPF_F_CURRENT_CPU

> +
> +typedef __u64 stack_trace_t[PERF_MAX_STACK_DEPTH];
> +struct {
> +       __uint(type, BPF_MAP_TYPE_STACK_TRACE);
> +       __uint(max_entries, 16384);
> +       __uint(key_size, sizeof(__u32));
> +       __uint(value_size, sizeof(stack_trace_t));
> +} stackmap SEC(".maps");
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(max_entries, 1);
> +       __type(key, __u32);
> +       __type(value, stack_trace_t);
> +} stackdata_map SEC(".maps");
> +
> +long stackid_kernel = 1;
> +long stackid_user = 1;
> +long stack_kernel = 1;
> +long stack_user = 1;
> +

nit: kind of unusual to go from 1 -> 2, why no zero to one as a flag?
those variables will be available through skel->bss, btw

> +SEC("perf_event")
> +int oncpu(void *ctx)
> +{
> +       int max_len = PERF_MAX_STACK_DEPTH * sizeof(__u64);
> +       stack_trace_t *trace;
> +       __u32 key = 0;
> +       long val;
> +
> +       val = bpf_get_stackid(ctx, &stackmap, 0);
> +       if (val > 0)
> +               stackid_kernel = 2;
> +       val = bpf_get_stackid(ctx, &stackmap, BPF_F_USER_STACK);
> +       if (val > 0)
> +               stackid_user = 2;
> +
> +       trace = bpf_map_lookup_elem(&stackdata_map, &key);
> +       if (!trace)
> +               return 0;
> +
> +       val = bpf_get_stack(ctx, trace, max_len, 0);

given you don't care about contents of trace, you could have used
`stack_trace_t trace = {}` global variable instead of PERCPU_ARRAY.

> +       if (val > 0)
> +               stack_kernel = 2;
> +
> +       val = bpf_get_stack(ctx, trace, max_len, BPF_F_USER_STACK);

nit: max_len == sizeof(stack_trace_t) ?

> +       if (val > 0)
> +               stack_user = 2;
> +
> +       return 0;
> +}
> +
> +char LICENSE[] SEC("license") = "GPL";
> --
> 2.24.1
>
