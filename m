Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42FE54AC925
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 20:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238594AbiBGTDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 14:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbiBGS7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:59:44 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96755C0401DA;
        Mon,  7 Feb 2022 10:59:43 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id y84so18173613iof.0;
        Mon, 07 Feb 2022 10:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xfYZRl1OVTWfdQ/sU41tVKebTENh4xaVI8jBkhFXtXA=;
        b=j4S6T16yFNPY+sUSBFplFg0FzkMzMrACtaQtim6kwigBrUHuUzkiDmj0/LITb40ipY
         GTXKl4MW4nng6H9V69eZiPjTP0Qvjald5+Ud9LN19KhxvQRI8AOeudLelGLMlTT8ksiN
         6aQBrMubY6jccwfPijFso67SSZY+i9654ASmkNDAEugaLfMU3T34VMfWAe7mB2NmRGs8
         G6OMoAgIQfMDLs/bs6oFPXhu3PbFcNxHhaN7PQMg2U9N+v0RNkLX6c6kJn+7aQYcrVqm
         zsljFWLdWzMYQ6Sla06vdAwLXcAQQQOdYDCz/O483u+wVwsWw19IQcu/gQZv/A5V4MbT
         NFHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xfYZRl1OVTWfdQ/sU41tVKebTENh4xaVI8jBkhFXtXA=;
        b=vgif5SNOoo07D5zTTnikgxnL/0waMuOOCM5nNN6BbLJqsmzAu7lDGdbxSra4/PcCFm
         VmBjVKYb9GPyoJzEG4i/dK/qVQJQ/qE/OKiRuQbJTt6BirtpEJgwh87cyM3QKFdEcMhT
         LvYNma0Tgn34cn2LGhXwsr34LIGgFENaSAghM+SCSysH6clix0FEDB1BuQxtKMZUn346
         vd3qZ434gxbuw1n7GUySyZUug5hHr4b9WhGQxtyK8lBBrTriK/VwA/lvQcagRRARAzYi
         W7XRxB7S+4MD0txijYvPQuO6J8xsejx8uGode58JPIxy2YbpNaiQs/FzZdMYB6c0g+ii
         XmYg==
X-Gm-Message-State: AOAM531kC4D9IHR45TT4Il/vpSSuylRiu3gVBIgeT/XgowZFxBO903Pt
        2iaEjVWyeRlJmjhN6loMdNRqYBT8IXquILVyFB8=
X-Google-Smtp-Source: ABdhPJwQewAXb9sKMxkioejbd4BT7Ed/oAXnQ522zaUYajnj6KqoYKS/vnOH5ADXp3tYzjbFSkV1XlRoe0kkC9/NVVA=
X-Received: by 2002:a05:6638:d88:: with SMTP id l8mr530684jaj.234.1644260383051;
 Mon, 07 Feb 2022 10:59:43 -0800 (PST)
MIME-Version: 1.0
References: <20220202135333.190761-1-jolsa@kernel.org> <20220202135333.190761-9-jolsa@kernel.org>
In-Reply-To: <20220202135333.190761-9-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Feb 2022 10:59:32 -0800
Message-ID: <CAEf4Bzbi3t_zZL2=8NyBeJ9q95ODH7pXF+EybtgBQp7LTyfr6Q@mail.gmail.com>
Subject: Re: [PATCH 8/8] selftest/bpf: Add fprobe test for bpf_cookie values
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
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

On Wed, Feb 2, 2022 at 5:54 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Adding bpf_cookie test for kprobe attached by fprobe link.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/bpf_cookie.c     | 73 +++++++++++++++++++
>  .../selftests/bpf/progs/fprobe_bpf_cookie.c   | 62 ++++++++++++++++
>  2 files changed, 135 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/fprobe_bpf_cookie.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> index cd10df6cd0fc..bf70d859c598 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> @@ -7,6 +7,7 @@
>  #include <unistd.h>
>  #include <test_progs.h>
>  #include "test_bpf_cookie.skel.h"
> +#include "fprobe_bpf_cookie.skel.h"
>
>  /* uprobe attach point */
>  static void trigger_func(void)
> @@ -63,6 +64,76 @@ static void kprobe_subtest(struct test_bpf_cookie *skel)
>         bpf_link__destroy(retlink2);
>  }
>
> +static void fprobe_subtest(void)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> +       int err, prog_fd, link1_fd = -1, link2_fd = -1;
> +       struct fprobe_bpf_cookie *skel = NULL;
> +       __u32 duration = 0, retval;
> +       __u64 addrs[8], cookies[8];
> +
> +       skel = fprobe_bpf_cookie__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "fentry_raw_skel_load"))
> +               goto cleanup;
> +
> +       kallsyms_find("bpf_fentry_test1", &addrs[0]);
> +       kallsyms_find("bpf_fentry_test2", &addrs[1]);
> +       kallsyms_find("bpf_fentry_test3", &addrs[2]);
> +       kallsyms_find("bpf_fentry_test4", &addrs[3]);
> +       kallsyms_find("bpf_fentry_test5", &addrs[4]);
> +       kallsyms_find("bpf_fentry_test6", &addrs[5]);
> +       kallsyms_find("bpf_fentry_test7", &addrs[6]);
> +       kallsyms_find("bpf_fentry_test8", &addrs[7]);
> +
> +       cookies[0] = 1;
> +       cookies[1] = 2;
> +       cookies[2] = 3;
> +       cookies[3] = 4;
> +       cookies[4] = 5;
> +       cookies[5] = 6;
> +       cookies[6] = 7;
> +       cookies[7] = 8;
> +
> +       opts.fprobe.addrs = (__u64) &addrs;

we should have ptr_to_u64() for test_progs, but if not, let's either
add it or it should be (__u64)(uintptr_t)&addrs. Otherwise we'll be
getting compilation warnings on some architectures.

> +       opts.fprobe.cnt = 8;
> +       opts.fprobe.bpf_cookies = (__u64) &cookies;
> +       prog_fd = bpf_program__fd(skel->progs.test2);
> +
> +       link1_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_FPROBE, &opts);
> +       if (!ASSERT_GE(link1_fd, 0, "link1_fd"))
> +               return;
> +
> +       cookies[0] = 8;
> +       cookies[1] = 7;
> +       cookies[2] = 6;
> +       cookies[3] = 5;
> +       cookies[4] = 4;
> +       cookies[5] = 3;
> +       cookies[6] = 2;
> +       cookies[7] = 1;
> +
> +       opts.flags = BPF_F_FPROBE_RETURN;
> +       prog_fd = bpf_program__fd(skel->progs.test3);
> +
> +       link2_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_FPROBE, &opts);
> +       if (!ASSERT_GE(link2_fd, 0, "link2_fd"))
> +               goto cleanup;
> +
> +       prog_fd = bpf_program__fd(skel->progs.test1);
> +       err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> +                               NULL, NULL, &retval, &duration);
> +       ASSERT_OK(err, "test_run");
> +       ASSERT_EQ(retval, 0, "test_run");
> +
> +       ASSERT_EQ(skel->bss->test2_result, 8, "test2_result");
> +       ASSERT_EQ(skel->bss->test3_result, 8, "test3_result");
> +
> +cleanup:
> +       close(link1_fd);
> +       close(link2_fd);
> +       fprobe_bpf_cookie__destroy(skel);
> +}
> +
>  static void uprobe_subtest(struct test_bpf_cookie *skel)
>  {
>         DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
> @@ -249,6 +320,8 @@ void test_bpf_cookie(void)
>
>         if (test__start_subtest("kprobe"))
>                 kprobe_subtest(skel);
> +       if (test__start_subtest("rawkprobe"))

kprobe.multi?

> +               fprobe_subtest();
>         if (test__start_subtest("uprobe"))
>                 uprobe_subtest(skel);
>         if (test__start_subtest("tracepoint"))

[...]
