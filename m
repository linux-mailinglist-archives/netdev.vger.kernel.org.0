Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0851A29325F
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389447AbgJTAdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389433AbgJTAdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 20:33:37 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87E4C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 17:33:35 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id e22so128722ejr.4
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 17:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vKvPK7V4y8z7IWovFbJlk20J5q0NAQpUk0V/OTP/q04=;
        b=I26X5yR5N0CwdKDcnkcH3cD/8daHQWP0Ij/MZSXPCk5S9AChVcqXAYQZVGTppMboKS
         I3BRKx3Jftt881v4DExmsA76s82qb3BNEm6N0TPsS84B2+urdl6iR5ObpNhhF8gKa9kA
         nUMC796wKrwNEAyT+Gvr8vPMr+7jSL6A31G8m9lyCaEN9g+Hbd3XKQ9e246JAQ3q3fqk
         98iQDGDbfrUoEsEBxLvIQqh+n4zZe6qivkRpSpQ9RsS9LkCzwP9cxxaqSfJNeCYgmzpd
         vzRMgqP3JrKKnTyisouQ0+e0IAYxG5dARNwZyGBtc9g60TQwgKHfW5njyyHh/MGeZ0KJ
         6WaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vKvPK7V4y8z7IWovFbJlk20J5q0NAQpUk0V/OTP/q04=;
        b=kwigLnVHqzlCF8G1uY8EK3Mx5EjYdx+KZ0siAzt+a/vILoR4WktSiU08HFxrvnaMqf
         osx994gigaBXFr/UXPNX33APLrcjYSvzVrMQkyC9bLvcSI0qpwCOka0OB3XPebNSbbB6
         9YFSYPVwkltxB+vmMlC7ZieZCJwvKN+2q45T+H5I1IMEQKkwVXQ7GtXQBqM+QUUrSAtC
         zsVqMPdbEDbs29hBlPX752WD8hYl5f70MASyxnkPD0M2esZaBRLQx7EXBDm0mGTzNZuc
         6ooSToZ+Le+hrK6v0jOioHlchI+/gXhBqWDYGYi3pRaNsKXTia/OH3weX1yx0yDW47m/
         FVFw==
X-Gm-Message-State: AOAM5329r1HbTNMF10rpFdq0ckmPm7q/sksahu14Hzhg2IdPgxF8pcsE
        U4HSrW8ZBlmHZgTXKmx8XWUZZ0Atm7V7HWGRl1BDsA==
X-Google-Smtp-Source: ABdhPJztnKu8sCDJ3tQQuJfeM6llalq5vKfE73DH0Q0Tp86fPbuEL/+mDgaxgyrKNK9c4z+thvvdhiJt6ZS3EnOSero=
X-Received: by 2002:a17:906:4e19:: with SMTP id z25mr533284eju.44.1603154014206;
 Mon, 19 Oct 2020 17:33:34 -0700 (PDT)
MIME-Version: 1.0
References: <20201019194206.1050591-1-kafai@fb.com> <20201019194225.1051596-1-kafai@fb.com>
In-Reply-To: <20201019194225.1051596-1-kafai@fb.com>
From:   Hao Luo <haoluo@google.com>
Date:   Mon, 19 Oct 2020 17:33:22 -0700
Message-ID: <CA+khW7iyPMjAFjPHC4iys8G219RWnAoNDndUY_QTksYgfR8Eyw@mail.gmail.com>
Subject: Re: [PATCH bpf 3/3] bpf: selftest: Ensure the return value of the
 bpf_per_cpu_ptr() must be checked
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Martin for catching and fixing this!


On Mon, Oct 19, 2020 at 12:43 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch tests all pointers returned by bpf_per_cpu_ptr() must be
> tested for NULL first before it can be accessed.
>
> This patch adds a subtest "null_check", so it moves the ".data..percpu"
> existence check to the very beginning and before doing any subtest.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  .../selftests/bpf/prog_tests/ksyms_btf.c      | 57 +++++++++++++------
>  .../bpf/progs/test_ksyms_btf_null_check.c     | 31 ++++++++++
>  2 files changed, 70 insertions(+), 18 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf_null_check.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> index 28e26bd3e0ca..b58b775d19f3 100644
> --- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> @@ -5,18 +5,17 @@
>  #include <bpf/libbpf.h>
>  #include <bpf/btf.h>
>  #include "test_ksyms_btf.skel.h"
> +#include "test_ksyms_btf_null_check.skel.h"
>
>  static int duration;
>
> -void test_ksyms_btf(void)
> +static void test_basic(void)
>  {
>         __u64 runqueues_addr, bpf_prog_active_addr;
>         __u32 this_rq_cpu;
>         int this_bpf_prog_active;
>         struct test_ksyms_btf *skel = NULL;
>         struct test_ksyms_btf__data *data;
> -       struct btf *btf;
> -       int percpu_datasec;
>         int err;
>
>         err = kallsyms_find("runqueues", &runqueues_addr);
> @@ -31,20 +30,6 @@ void test_ksyms_btf(void)
>         if (CHECK(err == -ENOENT, "ksym_find", "symbol 'bpf_prog_active' not found\n"))
>                 return;
>
> -       btf = libbpf_find_kernel_btf();
> -       if (CHECK(IS_ERR(btf), "btf_exists", "failed to load kernel BTF: %ld\n",
> -                 PTR_ERR(btf)))
> -               return;
> -
> -       percpu_datasec = btf__find_by_name_kind(btf, ".data..percpu",
> -                                               BTF_KIND_DATASEC);
> -       if (percpu_datasec < 0) {
> -               printf("%s:SKIP:no PERCPU DATASEC in kernel btf\n",
> -                      __func__);
> -               test__skip();
> -               goto cleanup;
> -       }
> -
>         skel = test_ksyms_btf__open_and_load();
>         if (CHECK(!skel, "skel_open", "failed to open and load skeleton\n"))
>                 goto cleanup;
> @@ -83,6 +68,42 @@ void test_ksyms_btf(void)
>               data->out__bpf_prog_active);
>
>  cleanup:
> -       btf__free(btf);
>         test_ksyms_btf__destroy(skel);
>  }
> +
> +static void test_null_check(void)
> +{
> +       struct test_ksyms_btf_null_check *skel;
> +
> +       skel = test_ksyms_btf_null_check__open_and_load();
> +       CHECK(skel, "skel_open", "unexpected load of a prog missing null check\n");
> +
> +       test_ksyms_btf_null_check__destroy(skel);
> +}
> +
> +void test_ksyms_btf(void)
> +{
> +       int percpu_datasec;
> +       struct btf *btf;
> +
> +       btf = libbpf_find_kernel_btf();
> +       if (CHECK(IS_ERR(btf), "btf_exists", "failed to load kernel BTF: %ld\n",
> +                 PTR_ERR(btf)))
> +               return;
> +
> +       percpu_datasec = btf__find_by_name_kind(btf, ".data..percpu",
> +                                               BTF_KIND_DATASEC);
> +       btf__free(btf);
> +       if (percpu_datasec < 0) {
> +               printf("%s:SKIP:no PERCPU DATASEC in kernel btf\n",
> +                      __func__);
> +               test__skip();
> +               return;
> +       }
> +
> +       if (test__start_subtest("basic"))
> +               test_basic();
> +
> +       if (test__start_subtest("null_check"))
> +               test_null_check();
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_btf_null_check.c b/tools/testing/selftests/bpf/progs/test_ksyms_btf_null_check.c
> new file mode 100644
> index 000000000000..8bc8f7c637bc
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_ksyms_btf_null_check.c
> @@ -0,0 +1,31 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +
> +#include "vmlinux.h"
> +
> +#include <bpf/bpf_helpers.h>
> +
> +extern const struct rq runqueues __ksym; /* struct type global var. */
> +extern const int bpf_prog_active __ksym; /* int type global var. */
> +
> +SEC("raw_tp/sys_enter")
> +int handler(const void *ctx)
> +{
> +       struct rq *rq;
> +       int *active;
> +       __u32 cpu;
> +
> +       cpu = bpf_get_smp_processor_id();
> +       rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, cpu);
> +       active = (int *)bpf_per_cpu_ptr(&bpf_prog_active, cpu);
> +       if (active) {
> +               /* READ_ONCE */
> +               *(volatile int *)active;
> +               /* !rq has not been tested, so verifier should reject. */
> +               *(volatile int *)(&rq->cpu);
> +       }
> +
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.24.1
>
