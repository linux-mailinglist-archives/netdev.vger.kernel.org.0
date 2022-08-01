Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED85958739A
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 23:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbiHAVvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 17:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiHAVvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 17:51:45 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E397039BA0;
        Mon,  1 Aug 2022 14:51:43 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id m8so15392980edd.9;
        Mon, 01 Aug 2022 14:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VLuEcIkJtnKoMl8gBoUClGYBdOKVju+Fv4CrOEtOKBE=;
        b=eQywm0SYRown4Vd/F5Sr8QZB48pltddGfTACwJqvJydCzDVTxghTZycjVyzWDiMkmx
         tyyyQjbdCUDr7XtTQ8Ow/Tih7gktgV/xyfyLcPy3yJy4r2s7Hw+2X2ghPlZqM7nVHMLG
         QCJX6wLvU8q8xx94nsmL3NoW5mKF0nqg+5QEysJ6T6a29nFkAFoXXobQSBocpv57pRcL
         z4XvKnxw7JfBduEJtfa4MjDQ3/1NK5RV/ssYjkCtpAm2mGhzllxE7Kc1LCHKxObtsWr3
         B0lzm8o+zw0y3SOBWcaSuVIiA8/z+5kCPMPgv6COUw0f4mbhhWge+Ay9Uh2mSj/gehvA
         g+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=VLuEcIkJtnKoMl8gBoUClGYBdOKVju+Fv4CrOEtOKBE=;
        b=ICV92xa1efoaTRYgnd1C1x2J/yS0ye0Iu69cKne491bsw7uQkcc9UpltVjN1W75/Cr
         nkkyTt48pL4611zpYYzSQgRJiSAvIZiLmLQANsfY0J29/zchHqCXWshhMLkoZnV86u63
         XyKUMGI5ChWykYxnxtUgj2kLwqiekAbBc2L1fPaSgGC6EI2GHfLLUDN0NBMheE86vI+n
         oNTWbCE4ax35CMugzanDNWnnE/afj2lqJFrMueT3AxBQ6r2b7lki2CU7dwsigE2ndovu
         RPBX6h/DGadhU1/CVP8W9hnCs6F8POWN05eAlt71/lqv/08ZrKIXyMZUghqojSw72zks
         c1sg==
X-Gm-Message-State: ACgBeo2o9T6Rwi9niqGYkY9w9o/iWX2q+2bGQiIWU0jlhYPRmlAeq5Ox
        xI4i7XSmTnE6/7bgeR2pqCW2evwjNIwPZJWt+PQ=
X-Google-Smtp-Source: AA6agR7aLJ8wAO+BNHBsLmozA0N0weo6l4KeLAuItYUFusShEQ4dh2D1zYVKD/t563zJOWxIQTUHpiTlWB4jj8uhxY8=
X-Received: by 2002:aa7:de18:0:b0:43d:30e2:d22b with SMTP id
 h24-20020aa7de18000000b0043d30e2d22bmr15551672edv.224.1659390702488; Mon, 01
 Aug 2022 14:51:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220801175407.2647869-1-haoluo@google.com> <20220801175407.2647869-6-haoluo@google.com>
In-Reply-To: <20220801175407.2647869-6-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Aug 2022 14:51:31 -0700
Message-ID: <CAEf4Bzbdz7=Cg-87G2tak1Mr=1wJkqr6g2d=dkHqu0YH+j2unA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 5/8] selftests/bpf: Test cgroup_iter.
To:     Hao Luo <haoluo@google.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 1, 2022 at 10:54 AM Hao Luo <haoluo@google.com> wrote:
>
> Add a selftest for cgroup_iter. The selftest creates a mini cgroup tree
> of the following structure:
>
>     ROOT (working cgroup)
>      |
>    PARENT
>   /      \
> CHILD1  CHILD2
>
> and tests the following scenarios:
>
>  - invalid cgroup fd.
>  - pre-order walk over descendants from PARENT.
>  - post-order walk over descendants from PARENT.
>  - walk of ancestors from PARENT.
>  - early termination.
>
> Acked-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>  .../selftests/bpf/prog_tests/cgroup_iter.c    | 193 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
>  .../testing/selftests/bpf/progs/cgroup_iter.c |  39 ++++
>  3 files changed, 239 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
>  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
> new file mode 100644
> index 000000000000..5dc843a3f507
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
> @@ -0,0 +1,193 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2022 Google */
> +
> +#include <test_progs.h>
> +#include <bpf/libbpf.h>
> +#include <bpf/btf.h>
> +#include "cgroup_iter.skel.h"
> +#include "cgroup_helpers.h"
> +
> +#define ROOT           0
> +#define PARENT         1
> +#define CHILD1         2
> +#define CHILD2         3
> +#define NUM_CGROUPS    4
> +
> +#define PROLOGUE       "prologue\n"
> +#define EPILOGUE       "epilogue\n"
> +
> +#define format_expected_output1(cg_id1) \
> +       snprintf(expected_output, sizeof(expected_output), \
> +                PROLOGUE "%8llu\n" EPILOGUE, (cg_id1))
> +
> +#define format_expected_output2(cg_id1, cg_id2) \
> +       snprintf(expected_output, sizeof(expected_output), \
> +                PROLOGUE "%8llu\n%8llu\n" EPILOGUE, \
> +                (cg_id1), (cg_id2))
> +
> +#define format_expected_output3(cg_id1, cg_id2, cg_id3) \
> +       snprintf(expected_output, sizeof(expected_output), \
> +                PROLOGUE "%8llu\n%8llu\n%8llu\n" EPILOGUE, \
> +                (cg_id1), (cg_id2), (cg_id3))
> +

you use format_expected_output{1,2} just once and
format_expected_output3 twice. Is it worth defining macros for that?

> +const char *cg_path[] = {
> +       "/", "/parent", "/parent/child1", "/parent/child2"
> +};
> +
> +static int cg_fd[] = {-1, -1, -1, -1};
> +static unsigned long long cg_id[] = {0, 0, 0, 0};
> +static char expected_output[64];
> +
> +int setup_cgroups(void)
> +{
> +       int fd, i = 0;
> +
> +       for (i = 0; i < NUM_CGROUPS; i++) {
> +               fd = create_and_get_cgroup(cg_path[i]);
> +               if (fd < 0)
> +                       return fd;
> +
> +               cg_fd[i] = fd;
> +               cg_id[i] = get_cgroup_id(cg_path[i]);
> +       }
> +       return 0;
> +}
> +
> +void cleanup_cgroups(void)

some more statics to cover (same for setup_cgroups)

> +{
> +       int i;
> +
> +       for (i = 0; i < NUM_CGROUPS; i++)
> +               close(cg_fd[i]);
> +}
> +
> +static void read_from_cgroup_iter(struct bpf_program *prog, int cgroup_fd,
> +                                 int order, const char *testname)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> +       union bpf_iter_link_info linfo;
> +       struct bpf_link *link;
> +       int len, iter_fd;
> +       static char buf[64];
> +
> +       memset(&linfo, 0, sizeof(linfo));
> +       linfo.cgroup.cgroup_fd = cgroup_fd;
> +       linfo.cgroup.traversal_order = order;
> +       opts.link_info = &linfo;
> +       opts.link_info_len = sizeof(linfo);
> +
> +       link = bpf_program__attach_iter(prog, &opts);
> +       if (!ASSERT_OK_PTR(link, "attach_iter"))
> +               return;
> +
> +       iter_fd = bpf_iter_create(bpf_link__fd(link));
> +       if (iter_fd < 0)
> +               goto free_link;
> +
> +       memset(buf, 0, sizeof(buf));
> +       while ((len = read(iter_fd, buf, sizeof(buf))) > 0)
> +               ;

this is broken, in general, you are overriding buffer content with
each call to len

I think you intended to advance buf after each read() call (and reduce
remaining available buf size)?

> +
> +       ASSERT_STREQ(buf, expected_output, testname);
> +
> +       /* read() after iter finishes should be ok. */
> +       if (len == 0)
> +               ASSERT_OK(read(iter_fd, buf, sizeof(buf)), "second_read");
> +
> +       close(iter_fd);
> +free_link:
> +       bpf_link__destroy(link);
> +}
> +
> +/* Invalid cgroup. */
> +static void test_invalid_cgroup(struct cgroup_iter *skel)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> +       union bpf_iter_link_info linfo;
> +       struct bpf_link *link;
> +
> +       memset(&linfo, 0, sizeof(linfo));
> +       linfo.cgroup.cgroup_fd = (__u32)-1;
> +       opts.link_info = &linfo;
> +       opts.link_info_len = sizeof(linfo);
> +
> +       link = bpf_program__attach_iter(skel->progs.cgroup_id_printer, &opts);
> +       if (!ASSERT_ERR_PTR(link, "attach_iter"))
> +               bpf_link__destroy(link);

nit: you can call bpf_link__destroy() even if link is NULL or IS_ERR

> +}
> +

[...]

> diff --git a/tools/testing/selftests/bpf/progs/cgroup_iter.c b/tools/testing/selftests/bpf/progs/cgroup_iter.c
> new file mode 100644
> index 000000000000..2a34d146d6df
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/cgroup_iter.c
> @@ -0,0 +1,39 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2022 Google */
> +
> +#include "bpf_iter.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +volatile int terminate_early = 0;
> +volatile u64 terminal_cgroup = 0;
> +

nit: you shouldn't need volatile for non-const global variables. Did
you see any problems without volatile?

> +static inline u64 cgroup_id(struct cgroup *cgrp)
> +{
> +       return cgrp->kn->id;
> +}
> +

[...]
