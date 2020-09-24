Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4602779CA
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 21:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgIXT46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 15:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgIXT45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 15:56:57 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB177C0613CE;
        Thu, 24 Sep 2020 12:56:57 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id k18so339530ybh.1;
        Thu, 24 Sep 2020 12:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yW4Sb5ujcpxoqND7/j5cwQs+yhdW2ARh8qlUcLJlqkc=;
        b=f5eyfX3FMMsbhC/mccyNJ6RUd+VnE5EYvluo+PJG0Qk/pysC9yk0ocPIUH3CpwvRr7
         iQyNqq3TsRCnFGgQP7UIspWO5c/EJp+vZ4J1A+Nh7NtDclaXAX+clO97/9mlrTd2RAar
         L7td7HM5I6BSSdQD8ppJSu6A0jeFtNeGpUUyksMFk9tcMjum+AOMvDXmVp6SkPmwvdaR
         3DhKw1Mt+zjVI8oZ8TwBcN033gr/YcPs9mqANzEJPQOIdiTRNTDhXLVlDQ4hTp2SYemy
         Tb7kGaKJ2NXRn630ZDiE4yBgUT7xAZNOdiag2Mc2oiDTKvzxKJTdWmy82iaPnWB18Rv0
         oTwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yW4Sb5ujcpxoqND7/j5cwQs+yhdW2ARh8qlUcLJlqkc=;
        b=k4zXNUhp2HqrwHy1FlaG6DWUoO7aPjvTHkb7uTOAIZFP9bdYFdTqLAkeee+YsZkbVB
         cyT/NZgnq24FVP7vnzYc1cPvs+Fvv770m2s3l8cznbIxZ/lpXDQUbacKMddrcxgn4g6W
         ZCjTxwRrZMqNM10GUV4p2ZHGn1EkmnGJxIzWO6O9wvIbsPuzCo5Q7Sq4iSlT9IjiTZNN
         T/UZ/R5ge96oI1t//ohtDrQ0+YNfZI5A05FhlU4U2/YI26rOf1xQmolMzyLnmHtrUpKR
         I04h7yCXtzfzfxm8zn5luqkGz5nJt5Z1H/Rx//ay1Jpq4ydPKKDSsDrowpm6rFpdJ8em
         Pc4Q==
X-Gm-Message-State: AOAM532V15My66RtxCMs8MvVxCHBBsRTVy4gTFaP3pKyb+kATtT+j0V7
        EJnfuLFg5odYInQCKmWDEK8tf8WCcnGmPW4zors=
X-Google-Smtp-Source: ABdhPJwF33l8gEfQrwu+2VrRSFF5NDfPej5qi6OfOnjNpLgPHgEeWcFnfiyKc68IWvSR/LQena9QfJTR0hgGk6oLbmY=
X-Received: by 2002:a25:730a:: with SMTP id o10mr573686ybc.403.1600977416822;
 Thu, 24 Sep 2020 12:56:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200924011951.408313-1-songliubraving@fb.com> <20200924011951.408313-2-songliubraving@fb.com>
In-Reply-To: <20200924011951.408313-2-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Sep 2020 12:56:46 -0700
Message-ID: <CAEf4Bzasv2wJZ32G0K9aohZN=s7nys5LMcM4MywyMxBW7baOsQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/3] bpf: enable BPF_PROG_TEST_RUN for raw_tracepoint
To:     Song Liu <songliubraving@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 6:46 PM Song Liu <songliubraving@fb.com> wrote:
>
> Add .test_run for raw_tracepoint. Also, introduce a new feature that runs
> the target program on a specific CPU. This is achieved by a new flag in
> bpf_attr.test, BPF_F_TEST_RUN_ON_CPU. When this flag is set, the program
> is triggered on cpu with id bpf_attr.test.cpu. This feature is needed for
> BPF programs that handle perf_event and other percpu resources, as the
> program can access these resource locally.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  include/linux/bpf.h            |  3 ++
>  include/uapi/linux/bpf.h       |  7 +++
>  kernel/bpf/syscall.c           |  2 +-
>  kernel/trace/bpf_trace.c       |  1 +
>  net/bpf/test_run.c             | 89 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  7 +++
>  6 files changed, 108 insertions(+), 1 deletion(-)
>

[...]

> +int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
> +                            const union bpf_attr *kattr,
> +                            union bpf_attr __user *uattr)
> +{
> +       void __user *ctx_in = u64_to_user_ptr(kattr->test.ctx_in);
> +       __u32 ctx_size_in = kattr->test.ctx_size_in;
> +       struct bpf_raw_tp_test_run_info info;
> +       int cpu, err = 0;
> +
> +       /* doesn't support data_in/out, ctx_out, duration, or repeat */
> +       if (kattr->test.data_in || kattr->test.data_out ||
> +           kattr->test.ctx_out || kattr->test.duration ||
> +           kattr->test.repeat)

duration and repeat sound generally useful (benchmarking raw_tp
programs), so it's a pity you haven't implemented them. But it can be
added later, so not a deal breaker.

> +               return -EINVAL;
> +
> +       if (ctx_size_in < prog->aux->max_ctx_offset)
> +               return -EINVAL;
> +
> +       if (ctx_size_in) {
> +               info.ctx = kzalloc(ctx_size_in, GFP_USER);
> +               if (!info.ctx)
> +                       return -ENOMEM;
> +               if (copy_from_user(info.ctx, ctx_in, ctx_size_in)) {
> +                       err = -EFAULT;
> +                       goto out;
> +               }
> +       } else {
> +               info.ctx = NULL;
> +       }
> +
> +       info.prog = prog;
> +       cpu = kattr->test.cpu;
> +
> +       if ((kattr->test.flags & BPF_F_TEST_RUN_ON_CPU) == 0 ||
> +           cpu == smp_processor_id()) {

should we enforce that cpu == 0 if BPF_F_TEST_RUN_ON_CPU is not set?


> +               __bpf_prog_test_run_raw_tp(&info);
> +       } else {
> +               /* smp_call_function_single() also checks cpu_online()
> +                * after csd_lock(). However, since cpu_plus is from user

cpu_plus leftover in a comment

> +                * space, let's do an extra quick check to filter out
> +                * invalid value before smp_call_function_single().
> +                */
> +               if (!cpu_online(cpu)) {

briefly looking at cpu_online() code, it seems like it's not checking
that cpu is < NR_CPUS. Should we add a selftest that validates that
passing unreasonable cpu index doesn't generate warning or invalid
memory access?

> +                       err = -ENXIO;
> +                       goto out;
> +               }
> +
> +               err = smp_call_function_single(cpu, __bpf_prog_test_run_raw_tp,
> +                                              &info, 1);
> +               if (err)
> +                       goto out;
> +       }
> +

[...]
