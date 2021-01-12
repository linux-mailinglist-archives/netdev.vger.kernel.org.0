Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A682F28E6
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391915AbhALH1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730416AbhALH1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 02:27:15 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB50C061575;
        Mon, 11 Jan 2021 23:26:35 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id y4so1305324ybn.3;
        Mon, 11 Jan 2021 23:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vNB71HyThzWfrEJHQ+MLv+jEXvSuEUzrCgPvp58QQ7Y=;
        b=QA9VaTd7+rSUVgL8EEtAyKJMcg4xlaFA0IrdeST2S8O4QEQ70XOXPR0Y67jRdLmU9S
         WP8LKoEoA/KriQa0OgCB0V8ZAm70Zr4/739s2TOcjZBJT0HrigP+5N9jiPu/+tsxIdYV
         mAOzcznFcAJ8Ev2iBH2Brdhqkg9Jfze2bG4R4UsK16NvzT92BnKeYZO5iqIhqkNi2xuP
         5ZZyjjBx+pqPI3Uxg3HnH3qlLNMzILRxA5yg/qIEjApHz0drPOHBB3YGvUi+Ya77Sb06
         WJRyFj4uvI2bFyJ8pWteLSpnWmFx94eZWBndgWNytps/sS9APw6UB8EfhyGf/xSoPG+e
         61Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vNB71HyThzWfrEJHQ+MLv+jEXvSuEUzrCgPvp58QQ7Y=;
        b=g4WTg7upHtMqbbv6VXmm7Dd5ci8IplTzdNif2tKwJ3HX5QelvDcS6EIs4U5QOkCF14
         XH15a2opUindNfJxJol4dX6ZW7pzGUQ4eGvt4Dbi/5aHqcMo9tzZD2q7FD2ciDu8kHjv
         kLN5x5N6HVLVi6PHFZVhBG9jK3f1LMVnEaLWtdFAF8SsbZH6HNMdi6ssrzTJ3bS+oAZi
         zVNNHPLEp+2hK9ndoqlStZ1/n5jWocPJ3slmWEk4qfwx1uWEIc1vYr9NXBkp7iRpKKP3
         XjgTwP+sLzj5lAfKXeKycX3RQ1XVyfF0kOsztgeak4H2yULFPSzOSfji/5XvI2mrw1A4
         mWRQ==
X-Gm-Message-State: AOAM5313kal1hjA3xCcY+ZlzGMM1GukaEjNmhuyhgEY8je8FigDAofT8
        z5L2rc/aKSoshmJCW2xeKT5pxwvnV2I78M88ljE=
X-Google-Smtp-Source: ABdhPJwmqp7QEpzslEopYGunjgcV5eopLlPZ5tq4kTXLnwarLECTPdzDWovPdcPZA7nzMM4/lmA+aqFeIiKKof51JT0=
X-Received: by 2002:a25:854a:: with SMTP id f10mr4723037ybn.510.1610436394470;
 Mon, 11 Jan 2021 23:26:34 -0800 (PST)
MIME-Version: 1.0
References: <20210111182027.1448538-1-qais.yousef@arm.com> <20210111182027.1448538-3-qais.yousef@arm.com>
In-Reply-To: <20210111182027.1448538-3-qais.yousef@arm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jan 2021 23:26:23 -0800
Message-ID: <CAEf4BzYwOAHGOiZBUx86yZ1ofwJ1WqCDR3dyRMrTeQa2ZU7ftA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests: bpf: Add a new test for bare tracepoints
To:     Qais Yousef <qais.yousef@arm.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 10:20 AM Qais Yousef <qais.yousef@arm.com> wrote:
>
> Reuse module_attach infrastructure to add a new bare tracepoint to check
> we can attach to it as a raw tracepoint.
>
> Signed-off-by: Qais Yousef <qais.yousef@arm.com>
> ---
>
> Andrii
>
> I was getting the error below when I was trying to run the test.
> I had to comment out all related fentry* code to be able to test the raw_tp
> stuff. Not sure something I've done wrong or it's broken for some reason.
> I was on v5.11-rc2.

Check that you have all the required Kconfig options from
tools/testing/selftests/bpf/config. And also you will need to build
pahole from master, 1.19 doesn't have some fixes that add kernel
module support. I think pahole is the reasons why you have the failure
below.

>
>         $ sudo ./test_progs -v -t module_attach

use -vv when debugging stuff like that with test_progs, it will output
libbpf detailed logs, that often are very helpful

>         bpf_testmod.ko is already unloaded.
>         Loading bpf_testmod.ko...
>         Successfully loaded bpf_testmod.ko.
>         test_module_attach:PASS:skel_open 0 nsec
>         test_module_attach:PASS:set_attach_target 0 nsec
>         test_module_attach:PASS:skel_load 0 nsec
>         libbpf: prog 'handle_fentry': failed to attach: ERROR: strerror_r(-524)=22
>         libbpf: failed to auto-attach program 'handle_fentry': -524
>         test_module_attach:FAIL:skel_attach skeleton attach failed: -524
>         #58 module_attach:FAIL
>         Successfully unloaded bpf_testmod.ko.
>         Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
>

But even apart from test failure, there seems to be kernel build
failure. See [0] for what fails in kernel-patches CI.

   [0] https://travis-ci.com/github/kernel-patches/bpf/builds/212730017


>
>  .../selftests/bpf/bpf_testmod/bpf_testmod-events.h     |  6 ++++++
>  tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c  |  2 ++
>  tools/testing/selftests/bpf/prog_tests/module_attach.c |  1 +
>  tools/testing/selftests/bpf/progs/test_module_attach.c | 10 ++++++++++
>  4 files changed, 19 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> index b83ea448bc79..e1ada753f10c 100644
> --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> @@ -28,6 +28,12 @@ TRACE_EVENT(bpf_testmod_test_read,
>                   __entry->pid, __entry->comm, __entry->off, __entry->len)
>  );
>
> +/* A bare tracepoint with no event associated with it */
> +DECLARE_TRACE(bpf_testmod_test_read_bare,
> +       TP_PROTO(struct task_struct *task, struct bpf_testmod_test_read_ctx *ctx),
> +       TP_ARGS(task, ctx)
> +);
> +
>  #endif /* _BPF_TESTMOD_EVENTS_H */
>
>  #undef TRACE_INCLUDE_PATH
> diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> index 2df19d73ca49..d63cebdaca44 100644
> --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> @@ -22,6 +22,8 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
>         };
>
>         trace_bpf_testmod_test_read(current, &ctx);
> +       ctx.len++;
> +       trace_bpf_testmod_test_read_bare(current, &ctx);

It's kind of boring to have two read tracepoints :) Do you mind adding
a write tracepoint and use bare tracepoint there? You won't need this
ctx.len++ hack as well. Feel free to add identical
bpf_testmod_test_write_ctx (renaming it is more of a pain).

>
>         return -EIO; /* always fail */
>  }
> diff --git a/tools/testing/selftests/bpf/prog_tests/module_attach.c b/tools/testing/selftests/bpf/prog_tests/module_attach.c
> index 50796b651f72..7085a118f38c 100644
> --- a/tools/testing/selftests/bpf/prog_tests/module_attach.c
> +++ b/tools/testing/selftests/bpf/prog_tests/module_attach.c
> @@ -50,6 +50,7 @@ void test_module_attach(void)
>         ASSERT_OK(trigger_module_test_read(READ_SZ), "trigger_read");
>
>         ASSERT_EQ(bss->raw_tp_read_sz, READ_SZ, "raw_tp");
> +       ASSERT_EQ(bss->raw_tp_bare_read_sz, READ_SZ+1, "raw_tp_bare");
>         ASSERT_EQ(bss->tp_btf_read_sz, READ_SZ, "tp_btf");
>         ASSERT_EQ(bss->fentry_read_sz, READ_SZ, "fentry");
>         ASSERT_EQ(bss->fentry_manual_read_sz, READ_SZ, "fentry_manual");
> diff --git a/tools/testing/selftests/bpf/progs/test_module_attach.c b/tools/testing/selftests/bpf/progs/test_module_attach.c
> index efd1e287ac17..08aa157afa1d 100644
> --- a/tools/testing/selftests/bpf/progs/test_module_attach.c
> +++ b/tools/testing/selftests/bpf/progs/test_module_attach.c
> @@ -17,6 +17,16 @@ int BPF_PROG(handle_raw_tp,
>         return 0;
>  }
>
> +__u32 raw_tp_bare_read_sz = 0;
> +
> +SEC("raw_tp/bpf_testmod_test_read_bare")
> +int BPF_PROG(handle_raw_tp_bare,
> +            struct task_struct *task, struct bpf_testmod_test_read_ctx *read_ctx)
> +{
> +       raw_tp_bare_read_sz = BPF_CORE_READ(read_ctx, len);
> +       return 0;
> +}
> +
>  __u32 tp_btf_read_sz = 0;
>
>  SEC("tp_btf/bpf_testmod_test_read")
> --
> 2.25.1
>
