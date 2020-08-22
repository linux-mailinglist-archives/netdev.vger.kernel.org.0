Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6960B24E4E1
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 05:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgHVDag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 23:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726639AbgHVDaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 23:30:35 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44CBC061573;
        Fri, 21 Aug 2020 20:30:34 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id x2so2093832ybf.12;
        Fri, 21 Aug 2020 20:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rwXBsAtmVDX+ECduRnQm34azFTvTIJrAjbNmRhPqbx8=;
        b=nJqynmkOMpMJ6z8CbAoJrBvIjjZh29RE5TqYgfsZApVbt9WpdYhYcQ0B/Vsyfm4eEG
         nOpaYodc9nofw7PlCFjk+fyHJe5lRBEhwqEnxiFxhG/J2prejlt5QsfyAde0XyKUqvUc
         kG2WWD3+d3CSzV4YlAfVu/GX7lyUKBIwFKwSuSBvKo8sBEvgzNsUzrbBT2HX53BVZ+D0
         m+g/ZtjfGBezonRB+7v2bZVlM05y3Hq4erQamuKEw+5SEoH5OfsRd59R6FcGXuGbTvO7
         tED6K+BdlRG/X2kiITrnAMM0R22mNh3Ab2FwBRIiy20vb4D5eWOtzsP0/dSZjRRu23QB
         BKrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rwXBsAtmVDX+ECduRnQm34azFTvTIJrAjbNmRhPqbx8=;
        b=D8rTvp3+pOjenGlWOj0XiXTVg7U0CWPGkUpsGNwUMIxjWs7aPBDkN0DSj3x4ATe/0H
         Rk68GZ3Qz6BJvjavyCCecP4eoWKtl44bi2bmsqCLBRiI/Rb7PoiuNI1oK2VXDiek+tOe
         +CnvoSFeCet3yk5W+YWiC83Ms0LhPhYMo4xsS4xqM/ZmfgAJY9v33wc5gxN1vg+PKF3Z
         A+N5QboT23r648nWeoN7pVkK8FHxINr3tsvdyvSxgGcsOu1yeVjMmcx3NRY0TRZYh3X1
         3O0Zm5gfhAUvIOBYz53mJlwqV57sYMH8ddrbNwkXe2rzhO5GF67nbCKAsw24UYSv7/kX
         NaRg==
X-Gm-Message-State: AOAM532Ugo4kYTIbx24ydv9D39ZuQR5Ya0I/Ohl51k6iwzewk6WPQ6GT
        yd5oJma/CbaMGxbQJh9cMmoEvWD6gf1iLsL21pI=
X-Google-Smtp-Source: ABdhPJx/UHOJZH9k2JWKEiMFa6Ij5s665WrbECXeOpshL/BqF3E5bQJqt7pAH2LrqjYs5AqmhcWu0HGXghqve+2wvPI=
X-Received: by 2002:a25:84cd:: with SMTP id x13mr7616141ybm.425.1598067034159;
 Fri, 21 Aug 2020 20:30:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-9-haoluo@google.com>
In-Reply-To: <20200819224030.1615203-9-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Aug 2020 20:30:22 -0700
Message-ID: <CAEf4BzYC0JRQusCxTrmraYQC7SZdkVjdy8DMUNECKwCbXP9-dw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 8/8] bpf/selftests: Test for bpf_per_cpu_ptr()
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

On Wed, Aug 19, 2020 at 3:42 PM Hao Luo <haoluo@google.com> wrote:
>
> Test bpf_per_cpu_ptr(). Test two paths in the kernel. If the base
> pointer points to a struct, the returned reg is of type PTR_TO_BTF_ID.
> Direct pointer dereference can be applied on the returned variable.
> If the base pointer isn't a struct, the returned reg is of type
> PTR_TO_MEM, which also supports direct pointer dereference.
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../testing/selftests/bpf/prog_tests/ksyms_btf.c  |  4 ++++
>  .../testing/selftests/bpf/progs/test_ksyms_btf.c  | 15 ++++++++++++++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> index 1dad61ba7e99..bdedd4a76b42 100644
> --- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> @@ -71,6 +71,10 @@ void test_ksyms_btf(void)
>               "got %llu, exp %llu\n", data->out__runqueues, runqueues_addr);
>         CHECK(data->out__bpf_prog_active != bpf_prog_active_addr, "bpf_prog_active",
>               "got %llu, exp %llu\n", data->out__bpf_prog_active, bpf_prog_active_addr);
> +       CHECK(data->out__rq_cpu != 1, "rq_cpu",
> +             "got %u, exp %u\n", data->out__rq_cpu, 1);
> +       CHECK(data->out__process_counts == -1, "process_counts",
> +             "got %lu, exp != -1", data->out__process_counts);
>
>  cleanup:
>         test_ksyms_btf__destroy(skel);
> diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> index e04e31117f84..78cf1ebb753d 100644
> --- a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> +++ b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> @@ -7,16 +7,29 @@
>
>  __u64 out__runqueues = -1;
>  __u64 out__bpf_prog_active = -1;
> +__u32 out__rq_cpu = -1;
> +unsigned long out__process_counts = -1;

try to not use long for variables, it is 32-bit integer in user-space
but always 64-bit in BPF. This causes problems when using skeleton on
32-bit architecture.

>
> -extern const struct rq runqueues __ksym; /* struct type global var. */
> +extern const struct rq runqueues __ksym; /* struct type percpu var. */
>  extern const int bpf_prog_active __ksym; /* int type global var. */
> +extern const unsigned long process_counts __ksym; /* int type percpu var. */
>
>  SEC("raw_tp/sys_enter")
>  int handler(const void *ctx)
>  {
> +       struct rq *rq;
> +       unsigned long *count;
> +
>         out__runqueues = (__u64)&runqueues;
>         out__bpf_prog_active = (__u64)&bpf_prog_active;
>
> +       rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, 1);
> +       if (rq)
> +               out__rq_cpu = rq->cpu;

this is awesome!

Are there any per-cpu variables that are arrays? Would be nice to test
those too.


> +       count = (unsigned long *)bpf_per_cpu_ptr(&process_counts, 1);
> +       if (count)
> +               out__process_counts = *count;
> +
>         return 0;
>  }
>
> --
> 2.28.0.220.ged08abb693-goog
>
