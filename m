Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6C2341417
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 05:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbhCSEVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 00:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbhCSEVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 00:21:20 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A7BC06174A;
        Thu, 18 Mar 2021 21:21:20 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id l14so4362646ybe.2;
        Thu, 18 Mar 2021 21:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v1P/y1fX96z0W6p11WpVaKTrdpWY4ca52CVqQFx6ngU=;
        b=qqCIFBCK9t7hmLsxTP8bw7RWVMuWGheRbe3k+NyF0NBDmNvSSyz/s47zggHoSBP4/W
         NtjY+89bgd1uaKXcX2OTNbfPFJ0IFWBsM72vB/LrdsyjuF3mVF2TwLDR9oH92UWp5GyK
         nUPq6HX10W2MnMa2TAa8LfdBKLTefKH7Nu3lMnE8km966d1V+QHvCXbebZUft1l1cWc0
         TxSHDPt2yQypjyCGN3J05Udc1ATNA6FX4P+DRWTLXWl7YarahXA6VEVVRKw94NgwSAKp
         AMSHamBfFCdsMpnOIvhdp6QZaNhN/ME2kXhybtXfWrAD1bX3p3p1O5Nh4UrCoJ3CWil2
         JmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v1P/y1fX96z0W6p11WpVaKTrdpWY4ca52CVqQFx6ngU=;
        b=MesuRJRkhAxur/GrwhyvG7khRoAbUHSIEwRjDYuOFPiPkPLq/eZyi5GLxiJZyDKDvx
         3qTA5DYZ6yrTPMpWwwcoXZAlVe/FNa/lVG1ADOBfGpOCaRws8OhHwFcSaVpzJF3XMpFM
         QJ30s9KqCMmnX18N8FKrqBTqjpxpiD8521A60lga+j6s97Iq2CAuRG10U1ZcNh57Mkqf
         /xSrNIrQAYAYTbfk8xdMdgkaJt/RYwMO8nHwRBxbmSYq3iuPBPZ/HDs3S8/P/A6qQuLv
         ADkK4R3OhljHL3TsbPwyktKlQuHiqgtOAgLY4mIV4PL0WbbFHwHKRUW6oINPw/nX31G2
         yrCQ==
X-Gm-Message-State: AOAM533RvUh6T0K51juiM6rdaC29kJhElipDrYF5TPIB/tvvCuqvfKGs
        N7+50KjMyv3Pra8MWw/xmiRZSUKoq7qbZ13oiFY=
X-Google-Smtp-Source: ABdhPJzoeoVhEA9olpV1l2oPkcSL9un1VHYvo60azuUh49GnbHyIlNHbxDVa/Skk4eExyjfUnX+XPTvcVizggR91WFA=
X-Received: by 2002:a25:74cb:: with SMTP id p194mr3898008ybc.347.1616127679274;
 Thu, 18 Mar 2021 21:21:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011336.4173585-1-kafai@fb.com> <20210316011510.4181765-1-kafai@fb.com>
In-Reply-To: <20210316011510.4181765-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Mar 2021 21:21:08 -0700
Message-ID: <CAEf4BzaGAbOSGGySyid22bzBbLJuBz+yYK6JmTBzuLYAZv__7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 15/15] bpf: selftest: Add kfunc_call test
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 12:02 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch adds two kernel function bpf_kfunc_call_test[12]() for the
> selftest's test_run purpose.  They will be allowed for tc_cls prog.
>
> The selftest calling the kernel function bpf_kfunc_call_test[12]()
> is also added in this patch.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  net/bpf/test_run.c                            | 11 ++++
>  net/core/filter.c                             | 11 ++++
>  .../selftests/bpf/prog_tests/kfunc_call.c     | 61 +++++++++++++++++++
>  .../selftests/bpf/progs/kfunc_call_test.c     | 48 +++++++++++++++
>  .../bpf/progs/kfunc_call_test_subprog.c       | 31 ++++++++++
>  5 files changed, 162 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/kfunc_call.c
>  create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test.c
>  create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_subprog.c
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 0abdd67f44b1..c1baab0c7d96 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -209,6 +209,17 @@ int noinline bpf_modify_return_test(int a, int *b)
>         *b += 1;
>         return a + *b;
>  }
> +
> +u64 noinline bpf_kfunc_call_test1(struct sock *sk, u32 a, u64 b, u32 c, u64 d)
> +{
> +       return a + b + c + d;
> +}
> +
> +int noinline bpf_kfunc_call_test2(struct sock *sk, u32 a, u32 b)
> +{
> +       return a + b;
> +}
> +
>  __diag_pop();
>
>  ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 10dac9dd5086..605fbbdd694b 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -9799,12 +9799,23 @@ const struct bpf_prog_ops sk_filter_prog_ops = {
>         .test_run               = bpf_prog_test_run_skb,
>  };
>
> +BTF_SET_START(bpf_tc_cls_kfunc_ids)
> +BTF_ID(func, bpf_kfunc_call_test1)
> +BTF_ID(func, bpf_kfunc_call_test2)
> +BTF_SET_END(bpf_tc_cls_kfunc_ids)
> +
> +static bool tc_cls_check_kern_func_call(u32 kfunc_id)
> +{
> +       return btf_id_set_contains(&bpf_tc_cls_kfunc_ids, kfunc_id);
> +}
> +
>  const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
>         .get_func_proto         = tc_cls_act_func_proto,
>         .is_valid_access        = tc_cls_act_is_valid_access,
>         .convert_ctx_access     = tc_cls_act_convert_ctx_access,
>         .gen_prologue           = tc_cls_act_prologue,
>         .gen_ld_abs             = bpf_gen_ld_abs,
> +       .check_kern_func_call   = tc_cls_check_kern_func_call,
>  };
>
>  const struct bpf_prog_ops tc_cls_act_prog_ops = {
> diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> new file mode 100644
> index 000000000000..3850e6cc0a7d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> @@ -0,0 +1,61 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +#include "kfunc_call_test.skel.h"
> +#include "kfunc_call_test_subprog.skel.h"
> +
> +static __u32 duration;
> +

you shouldn't need it, you don't use CHECK()s

> +static void test_main(void)
> +{
> +       struct kfunc_call_test *skel;
> +       int prog_fd, retval, err;
> +
> +       skel = kfunc_call_test__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "skel"))
> +               return;
> +
> +       prog_fd = bpf_program__fd(skel->progs.kfunc_call_test1);
> +       err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
> +                               NULL, NULL, (__u32 *)&retval, &duration);
> +
> +       if (ASSERT_OK(err, "bpf_prog_test_run(test1)"))
> +               ASSERT_EQ(retval, 12, "test1-retval");

there is no harm in doing retval check unconditionally. If something
goes wrong, you'll both know that err != 0 and what retval you got (if
you ever care, but if not, it doesn't hurt either). Same below.

> +
> +       prog_fd = bpf_program__fd(skel->progs.kfunc_call_test2);
> +       err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
> +                               NULL, NULL, (__u32 *)&retval, &duration);
> +       if (ASSERT_OK(err, "bpf_prog_test_run(test2)"))
> +               ASSERT_EQ(retval, 3, "test2-retval");
> +
> +       kfunc_call_test__destroy(skel);
> +}
> +
> +static void test_subprog(void)
> +{
> +       struct kfunc_call_test_subprog *skel;
> +       int prog_fd, retval, err;
> +
> +       skel = kfunc_call_test_subprog__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "skel"))
> +               return;
> +
> +       prog_fd = bpf_program__fd(skel->progs.kfunc_call_test1);
> +       err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
> +                               NULL, NULL, (__u32 *)&retval, &duration);
> +
> +       if (ASSERT_OK(err, "bpf_prog_test_run(test1)"))
> +               ASSERT_EQ(retval, 10, "test1-retval");
> +
> +       kfunc_call_test_subprog__destroy(skel);
> +}
> +
> +void test_kfunc_call(void)
> +{
> +       if (test__start_subtest("main"))
> +               test_main();
> +
> +       if (test__start_subtest("subprog"))
> +               test_subprog();
> +}
> diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> new file mode 100644
> index 000000000000..ea8c5266efd8
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> @@ -0,0 +1,48 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include "bpf_tcp_helpers.h"
> +
> +extern __u64 bpf_kfunc_call_test1(struct sock *sk, __u32 a, __u64 b,
> +                                 __u32 c, __u64 d) __ksym;
> +extern int bpf_kfunc_call_test2(struct sock *sk, __u32 a, __u32 b) __ksym;
> +
> +SEC("classifier/test2")
> +int kfunc_call_test2(struct __sk_buff *skb)
> +{
> +       struct bpf_sock *sk = skb->sk;
> +
> +       if (!sk)
> +               return -1;
> +
> +       sk = bpf_sk_fullsock(sk);
> +       if (!sk)
> +               return -1;
> +
> +       return bpf_kfunc_call_test2((struct sock *)sk, 1, 2);
> +}
> +
> +SEC("classifier/test1")

please use just SEC("classifier") here and above, libbpf will handle
that properly

> +int kfunc_call_test1(struct __sk_buff *skb)
> +{
> +       struct bpf_sock *sk = skb->sk;
> +       __u64 a = 1ULL << 32;
> +       __u32 ret;
> +
> +       if (!sk)
> +               return -1;
> +
> +       sk = bpf_sk_fullsock(sk);
> +       if (!sk)
> +               return -1;
> +
> +       a = bpf_kfunc_call_test1((struct sock *)sk, 1, a | 2, 3, a | 4);
> +
> +       ret = a >> 32;   /* ret should be 2 */
> +       ret += (__u32)a; /* ret should be 12 */
> +
> +       return ret;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_subprog.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_subprog.c
> new file mode 100644
> index 000000000000..9bf66f8c826e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_subprog.c
> @@ -0,0 +1,31 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include "bpf_tcp_helpers.h"
> +
> +extern __u64 bpf_kfunc_call_test1(struct sock *sk, __u32 a, __u64 b,
> +                                 __u32 c, __u64 d) __ksym;
> +
> +__attribute__ ((noinline))

__noinline

> +int f1(struct __sk_buff *skb)
> +{
> +       struct bpf_sock *sk = skb->sk;
> +
> +       if (!sk)
> +               return -1;
> +
> +       sk = bpf_sk_fullsock(sk);
> +       if (!sk)
> +               return -1;
> +
> +       return (__u32)bpf_kfunc_call_test1((struct sock *)sk, 1, 2, 3, 4);
> +}
> +
> +SEC("classifier/test1_subprog")

same, just "classifier"

> +int kfunc_call_test1(struct __sk_buff *skb)
> +{
> +       return f1(skb);
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.30.2
>
