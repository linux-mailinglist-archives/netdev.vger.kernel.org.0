Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B179925E281
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 22:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgIDUPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 16:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgIDUPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 16:15:38 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7875DC061244;
        Fri,  4 Sep 2020 13:15:37 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id s92so5255213ybi.2;
        Fri, 04 Sep 2020 13:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=97wzGZNbKGw+kQNf1bsqW3kl5yXeq4pPu+Jx+t1WtzM=;
        b=hICa4+M6d+Nqw5YUWT81HMx3smIYig/Jb+N+cjagh6RRYrH4CymwW47A+c3FbXFvMD
         KzRJm49qOCVX8WdxXV6cFGGI3PS/dzHRcR6XMyicTXS+DOfqlK/9m/bgTkWcJHOVQGW4
         qQcLjethrLRfvElVjKdxMFKTPR+Q+DOTXx4aFP/1heVBGhoTAXziqG9ifVJzqrOStkxI
         QZbEjM/qc8NZXq80lAyk51ahNuv+ICL7LOyNy1AEoeHYnu+8bEnCrYjyZSCwvxBG2S2B
         zjoXMw0mAnoIQsRwF1p+rmcSgvGLfs7MjSxMi4V1wAUrJjqoNcLx1bQDVJGmeyM4csK4
         uZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=97wzGZNbKGw+kQNf1bsqW3kl5yXeq4pPu+Jx+t1WtzM=;
        b=uYT+5aNttDllwPsDvNEjyA5/e4FZJz7PumU8as6VSOA2ZkOovxkv8wB0CnhuTQp5oZ
         4J+LloSx9SSPgJG83JK+qsYkL3OzLGrYlZMueEIgs1/2iMbsjF7ousa3ggzFgFalcFXy
         4wqyuGCrF+0KDPSTnXXumANDJU9N3BSiUgRd7l8n8ILHbebQgGHrYk/XcXRl3Y6CKSwx
         XhPu+haCB/2UzUQdvEoIpkeeQZHHov5tGqv3TH/c6yssTOhrcY0I4VIDU2adXhZYkChK
         d7jxmYky+ZfrUlTj8U4nBeLHldZYRas6nhYSS9rZgrT790HkvFAbhIkuSuT9+GNaBDor
         amfQ==
X-Gm-Message-State: AOAM530tOPv6jxrbcax4xYBsRza8Gx7Gut786hOGikZHaZ0dibMncWhc
        bpJpjAvrwgiHRGnXPaqjUQIH2WL7IxoweyOjrwo=
X-Google-Smtp-Source: ABdhPJw921xqUNKFTY3kqidSmF8NHNWMNXNRdfJiST4Nyh8faFKrC8j/KeTMJYoUzHNrK/iv4c2bwDoqDZKN0FOG5sk=
X-Received: by 2002:a25:cb57:: with SMTP id b84mr12280536ybg.425.1599250536285;
 Fri, 04 Sep 2020 13:15:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200903223332.881541-1-haoluo@google.com> <20200903223332.881541-7-haoluo@google.com>
In-Reply-To: <20200903223332.881541-7-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Sep 2020 13:15:25 -0700
Message-ID: <CAEf4BzZ9krnVzAR=0oQMe+f96cZff5MSdV3_EHiS-mSNF8MieQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/6] bpf/selftests: Test for bpf_per_cpu_ptr()
 and bpf_this_cpu_ptr()
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 3, 2020 at 3:35 PM Hao Luo <haoluo@google.com> wrote:
>
> Test bpf_per_cpu_ptr() and bpf_this_cpu_ptr(). Test two paths in the
> kernel. If the base pointer points to a struct, the returned reg is
> of type PTR_TO_BTF_ID. Direct pointer dereference can be applied on
> the returned variable. If the base pointer isn't a struct, the
> returned reg is of type PTR_TO_MEM, which also supports direct pointer
> dereference.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>  .../selftests/bpf/prog_tests/ksyms_btf.c      | 10 +++++++
>  .../selftests/bpf/progs/test_ksyms_btf.c      | 26 +++++++++++++++++++
>  2 files changed, 36 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> index 7b6846342449..22cc642dbc0e 100644
> --- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> @@ -58,6 +58,16 @@ void test_ksyms_btf(void)
>         CHECK(data->out__bpf_prog_active != bpf_prog_active_addr, "bpf_prog_active",
>               "got %llu, exp %llu\n", data->out__bpf_prog_active, bpf_prog_active_addr);
>
> +       CHECK(data->out__rq_cpu == -1, "rq_cpu",
> +             "got %u, exp != -1\n", data->out__rq_cpu);
> +       CHECK(data->out__percpu_bpf_prog_active == -1, "percpu_bpf_prog_active",
> +             "got %d, exp != -1\n", data->out__percpu_bpf_prog_active);
> +
> +       CHECK(data->out__this_rq_cpu == -1, "this_rq_cpu",
> +             "got %u, exp != -1\n", data->out__this_rq_cpu);
> +       CHECK(data->out__this_bpf_prog_active == -1, "this_bpf_prog_active",
> +             "got %d, exp != -1\n", data->out__this_bpf_prog_active);

see below for few suggestions to make these test more specific

out__this_bpf_prog_active it should always be > 0, no?

> +
>  cleanup:
>         test_ksyms_btf__destroy(skel);
>  }
> diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> index e04e31117f84..02d564349892 100644
> --- a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> +++ b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> @@ -8,15 +8,41 @@
>  __u64 out__runqueues = -1;
>  __u64 out__bpf_prog_active = -1;
>
> +__u32 out__rq_cpu = -1; /* percpu struct fields */
> +int out__percpu_bpf_prog_active = -1; /* percpu int */
> +
> +__u32 out__this_rq_cpu = -1;
> +int out__this_bpf_prog_active = -1;
> +
>  extern const struct rq runqueues __ksym; /* struct type global var. */
>  extern const int bpf_prog_active __ksym; /* int type global var. */
>
>  SEC("raw_tp/sys_enter")
>  int handler(const void *ctx)
>  {
> +       struct rq *rq;
> +       int *active;
> +       __u32 cpu;
> +
>         out__runqueues = (__u64)&runqueues;
>         out__bpf_prog_active = (__u64)&bpf_prog_active;
>
> +       cpu = bpf_get_smp_processor_id();
> +
> +       /* test bpf_per_cpu_ptr() */
> +       rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, cpu);
> +       if (rq)
> +               out__rq_cpu = rq->cpu;
> +       active = (int *)bpf_per_cpu_ptr(&bpf_prog_active, cpu);
> +       if (active)
> +               out__percpu_bpf_prog_active = *active;

this is equivalent to using bpf_this_cpu_ptr(), so:

1. you can compare value with out__this_xxx in user-space

2. it's interesting to also test that you can read value from some
other CPU. Can you add another variable and get value from CPU #0
always? E.g., for out__cpu_0_rq_cpu it should always be zero, right?

> +
> +       /* test bpf_this_cpu_ptr */
> +       rq = (struct rq *)bpf_this_cpu_ptr(&runqueues);
> +       out__this_rq_cpu = rq->cpu;
> +       active = (int *)bpf_this_cpu_ptr(&bpf_prog_active);
> +       out__this_bpf_prog_active = *active;
> +
>         return 0;
>  }
>
> --
> 2.28.0.526.ge36021eeef-goog
>
