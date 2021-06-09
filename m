Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD653A0BEB
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 07:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhFIFon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 01:44:43 -0400
Received: from mail-yb1-f181.google.com ([209.85.219.181]:39752 "EHLO
        mail-yb1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhFIFom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 01:44:42 -0400
Received: by mail-yb1-f181.google.com with SMTP id n133so33796846ybf.6;
        Tue, 08 Jun 2021 22:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a7JE0TcAimkJS8TzPveDWGTTXkAr9Kq+ijssc8HKJ6M=;
        b=RHU28bkIV20N9Kxxs0XYm8qgF+0nGXwee1nRlHUSd74OF1fVldXVsEBNc8ilf3zF16
         pa1WbsJCg3jgWofVCV++aHu7kpW3/bAsOY1SAFqcXAeB6bJvUfhzO71J1NLB4VmTC+lb
         fC1RU6AM11Yqf0JXvH6g3cnSXYZj52rpr2uaAdaCm5lEnTRNtfHNDExi/hF4uqyJscpK
         Rh7U56QXi8dMfKVU9TlLPpVG+pOIF/c//0IfZh/HZ2kxbOhOIfDD/m0ZugEsIyK5IegH
         sE/W/v0a4A/+ezAfhoytGAo+ZS+WAgU+1Uy38pMY3h4NlSn6FL5PSGpztrYiyqZeGI5r
         3jww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a7JE0TcAimkJS8TzPveDWGTTXkAr9Kq+ijssc8HKJ6M=;
        b=CGNFkpDnXAaLrS1/QtRDkxlYeTNjcVZ1zL/wi9Kp7Uq4t5fu7y56aHNGBNlLAscMMV
         2eJrqqXk4sXDLGUEsLfnnNXBOy9W9gaX5849qYUYBtEZt04ahk/oAuP86A8dtcmAmM/U
         jjnPDhqi5akzSf+J1i8Fg91G2tYrTXgRjt1Y87pLXfTCtGSb8yqLYrqljS9tBRHpdPEq
         s0stLDqK5TJ5b5cJHvrnby2YFLx0RcCpeGqkI54FquU/ccFOwzctdEuasS06Hj3ohR2p
         87zuW1+LDqDDuG1DpKxebMIFCJzD8e46wV6N+ssEsPD0Xntw2F9e3PoEWA/22lvVNH4x
         INDQ==
X-Gm-Message-State: AOAM5314Kamvre9/55pdJsJWN9TeSvne6B0iiAf7bmS+PX7OO2IGvQ6Y
        rz4N8d4O2oAOcUq/+M5ut5GTe+N7JM7ia8E0JdpNa3evv5s=
X-Google-Smtp-Source: ABdhPJz8ikE9Aet27Q/Fsz9W2AwJZSQO7ok7SCXDMP+tT9VErDMYpfm+eLMHdQP1j/3b1jslcvUFB3pTh3WtJu7PZt4=
X-Received: by 2002:a25:6612:: with SMTP id a18mr36939653ybc.347.1623217308407;
 Tue, 08 Jun 2021 22:41:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210605111034.1810858-1-jolsa@kernel.org> <20210605111034.1810858-19-jolsa@kernel.org>
In-Reply-To: <20210605111034.1810858-19-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Jun 2021 22:41:37 -0700
Message-ID: <CAEf4BzZWMekJvmadz1wuFhmvRrGuSgHtLH1WoyY7t=C5gWVKoQ@mail.gmail.com>
Subject: Re: [PATCH 18/19] selftests/bpf: Add fentry/fexit multi func test
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 5, 2021 at 4:13 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding selftest for fentry/fexit multi func test that attaches
> to bpf_fentry_test* functions and checks argument values based
> on the processed function.
>
> When multi_arg_check is used from 2 different places I'm getting
> compilation fail, which I did not deciphered yet:
>
>   $ CLANG=/opt/clang/bin/clang LLC=/opt/clang/bin/llc make
>     CLNG-BPF [test_maps] fentry_fexit_multi_test.o
>   progs/fentry_fexit_multi_test.c:18:2: error: too many args to t24: i64 = \
>   GlobalAddress<void (i64, i64, i64, i64, i64, i64, i64, i64*)* @multi_arg_check> 0, \
>   progs/fentry_fexit_multi_test.c:18:2 @[ progs/fentry_fexit_multi_test.c:16:5 ]
>           multi_arg_check(ip, a, b, c, d, e, f, &test1_arg_result);
>           ^
>   progs/fentry_fexit_multi_test.c:25:2: error: too many args to t32: i64 = \
>   GlobalAddress<void (i64, i64, i64, i64, i64, i64, i64, i64*)* @multi_arg_check> 0, \
>   progs/fentry_fexit_multi_test.c:25:2 @[ progs/fentry_fexit_multi_test.c:23:5 ]
>           multi_arg_check(ip, a, b, c, d, e, f, &test2_arg_result);
>           ^
>   In file included from progs/fentry_fexit_multi_test.c:5:
>   /home/jolsa/linux-qemu/tools/testing/selftests/bpf/multi_check.h:9:6: error: defined with too many args
>   void multi_arg_check(unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, __u64 *test_result)
>        ^
>   /home/jolsa/linux-qemu/tools/testing/selftests/bpf/multi_check.h:9:6: error: defined with too many args
>   /home/jolsa/linux-qemu/tools/testing/selftests/bpf/multi_check.h:9:6: error: defined with too many args
>   5 errors generated.
>   make: *** [Makefile:470: /home/jolsa/linux-qemu/tools/testing/selftests/bpf/fentry_fexit_multi_test.o] Error 1
>
> I can fix that by defining 2 separate multi_arg_check functions
> with different names, which I did in follow up temporaary patch.
> Not sure I'm hitting some clang/bpf limitation in here?

don't know about  clang limitations, but we should use static linking
proper anyways

>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../bpf/prog_tests/fentry_fexit_multi_test.c  | 52 +++++++++++++++++++
>  .../bpf/progs/fentry_fexit_multi_test.c       | 28 ++++++++++
>  2 files changed, 80 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_fexit_multi_test.c
>  create mode 100644 tools/testing/selftests/bpf/progs/fentry_fexit_multi_test.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_fexit_multi_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_fexit_multi_test.c
> new file mode 100644
> index 000000000000..76f917ad843d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/fentry_fexit_multi_test.c
> @@ -0,0 +1,52 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include "fentry_fexit_multi_test.skel.h"
> +
> +void test_fentry_fexit_multi_test(void)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_link_update_opts, link_upd_opts);
> +       struct fentry_fexit_multi_test *skel = NULL;
> +       unsigned long long *bpf_fentry_test;
> +       __u32 duration = 0, retval;
> +       struct bpf_link *link;
> +       int err, prog_fd;
> +
> +       skel = fentry_fexit_multi_test__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "fentry_multi_skel_load"))
> +               goto cleanup;
> +
> +       bpf_fentry_test = &skel->bss->bpf_fentry_test[0];
> +       ASSERT_OK(kallsyms_find("bpf_fentry_test1", &bpf_fentry_test[0]), "kallsyms_find");
> +       ASSERT_OK(kallsyms_find("bpf_fentry_test2", &bpf_fentry_test[1]), "kallsyms_find");
> +       ASSERT_OK(kallsyms_find("bpf_fentry_test3", &bpf_fentry_test[2]), "kallsyms_find");
> +       ASSERT_OK(kallsyms_find("bpf_fentry_test4", &bpf_fentry_test[3]), "kallsyms_find");
> +       ASSERT_OK(kallsyms_find("bpf_fentry_test5", &bpf_fentry_test[4]), "kallsyms_find");
> +       ASSERT_OK(kallsyms_find("bpf_fentry_test6", &bpf_fentry_test[5]), "kallsyms_find");
> +       ASSERT_OK(kallsyms_find("bpf_fentry_test7", &bpf_fentry_test[6]), "kallsyms_find");
> +       ASSERT_OK(kallsyms_find("bpf_fentry_test8", &bpf_fentry_test[7]), "kallsyms_find");
> +
> +       link = bpf_program__attach(skel->progs.test1);
> +       if (!ASSERT_OK_PTR(link, "attach_fentry_fexit"))
> +               goto cleanup;
> +
> +       err = bpf_link_update(bpf_link__fd(link),
> +                             bpf_program__fd(skel->progs.test2),
> +                             NULL);
> +       if (!ASSERT_OK(err, "bpf_link_update"))
> +               goto cleanup_link;
> +
> +       prog_fd = bpf_program__fd(skel->progs.test1);
> +       err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> +                               NULL, NULL, &retval, &duration);
> +       ASSERT_OK(err, "test_run");
> +       ASSERT_EQ(retval, 0, "test_run");
> +
> +       ASSERT_EQ(skel->bss->test1_arg_result, 8, "test1_arg_result");
> +       ASSERT_EQ(skel->bss->test2_arg_result, 8, "test2_arg_result");
> +       ASSERT_EQ(skel->bss->test2_ret_result, 8, "test2_ret_result");
> +
> +cleanup_link:
> +       bpf_link__destroy(link);
> +cleanup:
> +       fentry_fexit_multi_test__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/fentry_fexit_multi_test.c b/tools/testing/selftests/bpf/progs/fentry_fexit_multi_test.c
> new file mode 100644
> index 000000000000..e25ab0085399
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/fentry_fexit_multi_test.c
> @@ -0,0 +1,28 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include "multi_check.h"
> +
> +char _license[] SEC("license") = "GPL";
> +
> +unsigned long long bpf_fentry_test[8];
> +
> +__u64 test1_arg_result = 0;
> +__u64 test2_arg_result = 0;
> +__u64 test2_ret_result = 0;
> +
> +SEC("fentry.multi/bpf_fentry_test*")
> +int BPF_PROG(test1, unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
> +{
> +       multi_arg_check(ip, a, b, c, d, e, f, &test1_arg_result);
> +       return 0;
> +}
> +
> +SEC("fexit.multi/")
> +int BPF_PROG(test2, unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, int ret)
> +{
> +       multi_arg_check(ip, a, b, c, d, e, f, &test2_arg_result);
> +       multi_ret_check(ip, ret, &test2_ret_result);
> +       return 0;
> +}
> --
> 2.31.1
>
