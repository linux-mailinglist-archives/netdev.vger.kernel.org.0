Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8299225709
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 07:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgGTF2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 01:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgGTF2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 01:28:46 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2632C0619D2;
        Sun, 19 Jul 2020 22:28:45 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id t11so6863843qvk.1;
        Sun, 19 Jul 2020 22:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/pPLWH2pAbx1o3stWmvU+LLBgaAPdK0/HVHPrqXWxZ0=;
        b=bp7rfRoXx85Xod2uY1if/rc8is/p0z/2Lcg+IN+acZrGf5MJHtpV7P2HhgB7N6FXWg
         wfcrm7i1CGitaXJJ80Ruc2JRtUxYqx+cf/WaQ+GfKi42RZR2+tPuRAu/yCD1v33K4/+Q
         CUt/dLdvDR+UjdCW2pgdGNTwv0Z1ESzozDqBjiQAZJOUzxKrwGx9ZfteGd4ovMcf/jui
         9MhShSBUrIm4vvXgGqyATyF4EFebd89G4c/rA3Jnnzqm9xh3oNB6RRsmnA4dFjwq4Cdr
         hyGu3W5x5OSQQK6AwGRfZxLpn0Bb6nHFs20aObksYenaUW07EAaCJKAcEEJplbnBNfBy
         /Emg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/pPLWH2pAbx1o3stWmvU+LLBgaAPdK0/HVHPrqXWxZ0=;
        b=UAvLj1UYVXnOW8z+hS5F6ENw9iDJbMTdkn9srwDv1Wn+TMYJdufijnwntAyP87jyzj
         ZkNnBvWZcM//n/xHekWIx+2Ixv7ZIpakRmfdoncgdfF8PrJKiqOPrtLmDrIH748RjWTc
         hZDP5hpEwiA6d3QxSHypdzjR/BXD6XpqXHu/f+qqye/mQTZJr/9Naj6fpQuTKu1fC+s7
         6PYZ6isQ9RdmBTvGhH29hwMRzU6UdajEST4QoonRwZ1k0sLg0qS6Q6wc7Qxa0B/uCL6k
         qzNizizxKMBWB3ysZXiMFJIhInGFF7aybmlFT6+tWCQaMBgViYYhEy6Mm/mFqMn2q5qA
         9c6A==
X-Gm-Message-State: AOAM530iLH1Lo2HvPagSpy7z3eqGavyaOKVSbFxJNJ4apvHt/Fc8RYze
        /z1CKuNhWVO28MSr3B9jX6AZTEHAwIYOrt1kGRE=
X-Google-Smtp-Source: ABdhPJy0EA3lpXmrDf+zf1q3j2pxPWCxo+u84HKXJN1t0t/3YbTo9GGUPSdeJ9gRq+B645tvZsR4Y0n/iYequIQPjJw=
X-Received: by 2002:a05:6214:8f4:: with SMTP id dr20mr19119695qvb.228.1595222924959;
 Sun, 19 Jul 2020 22:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200715214312.2266839-1-haoluo@google.com> <20200715214312.2266839-3-haoluo@google.com>
In-Reply-To: <20200715214312.2266839-3-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 19 Jul 2020 22:28:34 -0700
Message-ID: <CAEf4BzYxWk9OmN0QhDrvE943YsYd2Opdkbt7NQTO9-YM6c4aGw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/2] selftests/bpf: Test __ksym externs with BTF
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 2:46 PM Hao Luo <haoluo@google.com> wrote:
>
> Extend ksyms.c selftest to make sure BTF enables direct loads of ksyms.
>
> Note that test is done against the kernel btf extended with kernel VARs.
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/ksyms.c |  2 ++
>  tools/testing/selftests/bpf/progs/test_ksyms.c | 14 ++++++++++++++
>  2 files changed, 16 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms.c b/tools/testing/selftests/bpf/prog_tests/ksyms.c
> index e3d6777226a8..0e7f3bc3b0ae 100644
> --- a/tools/testing/selftests/bpf/prog_tests/ksyms.c
> +++ b/tools/testing/selftests/bpf/prog_tests/ksyms.c
> @@ -65,6 +65,8 @@ void test_ksyms(void)
>               "got %llu, exp %llu\n", data->out__btf_size, btf_size);
>         CHECK(data->out__per_cpu_start != 0, "__per_cpu_start",
>               "got %llu, exp %llu\n", data->out__per_cpu_start, (__u64)0);
> +       CHECK(data->out__rq_cpu != 0, "rq_cpu",
> +             "got %llu, exp %llu\n", data->out__rq_cpu, (__u64)0);
>
>  cleanup:
>         test_ksyms__destroy(skel);
> diff --git a/tools/testing/selftests/bpf/progs/test_ksyms.c b/tools/testing/selftests/bpf/progs/test_ksyms.c
> index 6c9cbb5a3bdf..e777603757e5 100644
> --- a/tools/testing/selftests/bpf/progs/test_ksyms.c
> +++ b/tools/testing/selftests/bpf/progs/test_ksyms.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Copyright (c) 2019 Facebook */
>
> +#include "vmlinux.h"
>  #include <stdbool.h>
>  #include <linux/bpf.h>
>  #include <bpf/bpf_helpers.h>
> @@ -9,11 +10,13 @@ __u64 out__bpf_link_fops = -1;
>  __u64 out__bpf_link_fops1 = -1;
>  __u64 out__btf_size = -1;
>  __u64 out__per_cpu_start = -1;
> +__u64 out__rq_cpu = -1;
>
>  extern const void bpf_link_fops __ksym;
>  extern const void __start_BTF __ksym;
>  extern const void __stop_BTF __ksym;
>  extern const void __per_cpu_start __ksym;
> +extern const void runqueues __ksym;

This should ideally look like a real global variable extern:

extern const struct rq runqueues __ksym;


But that's the case for non-per-cpu variables. You didn't seem to
address per-CPU variables in this patch set. How did you intend to
handle that? We should look at a possible BPF helper to access such
variables as well and how the verifier will prevent direct memory
accesses for such variables.

We should have some BPF helper that accepts per-CPU PTR_TO_BTF_ID, and
returns PTR_TO_BTF_ID, but adjusted to desired CPU. And verifier
ideally would allow direct memory access on that resulting
PTR_TO_BTF_ID, but not on per-CPU one. Not sure yet how this should
look like, but the verifier probably needs to know that variable
itself is per-cpu, no?

>  /* non-existing symbol, weak, default to zero */
>  extern const void bpf_link_fops1 __ksym __weak;
>
> @@ -29,4 +32,15 @@ int handler(const void *ctx)
>         return 0;
>  }
>
> +SEC("tp_btf/sys_enter")
> +int handler_tp_btf(const void *ctx)
> +{
> +       const struct rq *rq = &runqueues;
> +
> +       /* rq now points to the runqueue of cpu 0. */
> +       out__rq_cpu = rq->cpu;
> +
> +       return 0;
> +}
> +
>  char _license[] SEC("license") = "GPL";
> --
> 2.27.0.389.gc38d7665816-goog
>
