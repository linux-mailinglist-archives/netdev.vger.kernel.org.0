Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B9646B147
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 04:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbhLGDNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 22:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbhLGDNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 22:13:39 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03422C061746;
        Mon,  6 Dec 2021 19:10:10 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id f9so36981040ybq.10;
        Mon, 06 Dec 2021 19:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jFBIoXTHjSjRCTq446pVI/yyHoaY3syCVRzpwOCvtFU=;
        b=GSd5/bH1KjhZxf+KU7MxenuGBz26Q2oqZ3HCb1/nrG/KQGoJbInh7zSbKBV4f4bMHA
         nyCWk7zbVzW/84nTt6tWhtJRxErZ7EVa0ZtJ0keql9OzL4C196eXUysmp9ZR4Ik372Nx
         rMYNCm7OHdyZYfTBBKdSOM2j0Fsy++T+AinFDPOn6dpSASIseZcDLCJgCyygmHoq6hR2
         6eAgELX4n6C1RXub9RiT1DP4KBBxBaABiHKS4XVT/N1rreM7I/6gbN3BY2LZ2Zk8TSsv
         I8n3pchq3OiVB0EwIqwsw9y70uy8zjwnDAPV37ZQIUsEd78fUJp17eZ2jsruiIwvOQPE
         OHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jFBIoXTHjSjRCTq446pVI/yyHoaY3syCVRzpwOCvtFU=;
        b=G1tJaoxI0biurGqrnpCoiqcjx1jZR0HCgQHC/9L89AYBEuaS17ElDWjdGcKGnUtY7n
         /GFMUkTr5dOpPAIZm2rAMS7+0MU0oPiWcG0V2dm/ITOPBs16eWMnW1E+nQnKUua9lBsw
         /A3zhyMBo0VdXOhEqVPAJDiiwyMMim/3c78zKF2laZuCTvHnGfMNcOzV/GrPssRmsK8Q
         UEdPtMyQFzID8Hgn5mwjd11jiaRWwZ/PyMxqbWOzpsejJcKULlEg9TK7RPoYEGW5+n4t
         qrdXwrwmwEIUdP9y5l/NE0rq2O4s3ouF7QTi/NcvDnAsprC9bGFjSzBz2MDFkltPuv1F
         SvZg==
X-Gm-Message-State: AOAM531hGPn+8ICXZdwqdSKeyI9oyFel0FjWtKeysm7+Mzxt9JqPLsOc
        +2S5Hc0gvK52Kjm9bQZRGgE0BWVatuBqlgt001o=
X-Google-Smtp-Source: ABdhPJzPAP37sh2hAglG4roaojaWYf0oDUj8SFtY7CWUAxE4uvVhl+FNY6lLapapEpDSmCMzSmj8c4jZoLNeiLnsfi0=
X-Received: by 2002:a25:54e:: with SMTP id 75mr45686039ybf.393.1638846609212;
 Mon, 06 Dec 2021 19:10:09 -0800 (PST)
MIME-Version: 1.0
References: <20211130142215.1237217-1-houtao1@huawei.com> <20211130142215.1237217-6-houtao1@huawei.com>
In-Reply-To: <20211130142215.1237217-6-houtao1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Dec 2021 19:09:57 -0800
Message-ID: <CAEf4BzaZR84VXUSh-SkA32yTYXhz5vUxK7ysoGMgWsa0+d54vQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: add test cases for bpf_strncmp()
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 6:07 AM Hou Tao <houtao1@huawei.com> wrote:
>
> Four test cases are added:
> (1) ensure the return value is expected
> (2) ensure no const size is rejected
> (3) ensure writable str is rejected
> (4) ensure no null-terminated str is rejected
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  .../selftests/bpf/prog_tests/test_strncmp.c   | 170 ++++++++++++++++++
>  .../selftests/bpf/progs/strncmp_test.c        |  59 ++++++
>  2 files changed, 229 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_strncmp.c
>  create mode 100644 tools/testing/selftests/bpf/progs/strncmp_test.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/test_strncmp.c b/tools/testing/selftests/bpf/prog_tests/test_strncmp.c
> new file mode 100644
> index 000000000000..3ed54b55f96a
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/test_strncmp.c
> @@ -0,0 +1,170 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2021. Huawei Technologies Co., Ltd */
> +#include <test_progs.h>
> +#include "strncmp_test.skel.h"
> +
> +static struct strncmp_test *strncmp_test_open_and_disable_autoload(void)
> +{
> +       struct strncmp_test *skel;
> +       struct bpf_program *prog;
> +
> +       skel = strncmp_test__open();
> +       if (libbpf_get_error(skel))
> +               return skel;
> +
> +       bpf_object__for_each_program(prog, skel->obj)
> +               bpf_program__set_autoload(prog, false);

I think this is a wrong "code economy". You save few lines of code,
but make tests harder to follow. Just do 4 lines of code for each
subtest:

skel = strncmp_test__open();
if (!ASSERT_OK_PTR(skel, "skel_open"))
    return;

bpf_object__for_each_program(prog, skel->obj)
    bpf_program__set_autoload(prog, false);


It makes tests more self-contained and easier to follow. Also if some
tests need to do something slightly different it's easier to modify
them, as they are not coupled to some common helper. DRY is good where
it makes sense, but it also increases code coupling and more "jumping
around" in code, so it shouldn't be applied blindly.

> +
> +       return skel;
> +}
> +
> +static inline int to_tristate_ret(int ret)
> +{
> +       if (ret > 0)
> +               return 1;
> +       if (ret < 0)
> +               return -1;
> +       return 0;
> +}
> +
> +static int trigger_strncmp(const struct strncmp_test *skel)
> +{
> +       struct timespec wait = {.tv_sec = 0, .tv_nsec = 1};
> +
> +       nanosleep(&wait, NULL);

all the other tests are just doing usleep(1), why using this more verbose way?

> +       return to_tristate_ret(skel->bss->cmp_ret);
> +}
> +
> +/*
> + * Compare str and target after making str[i] != target[i].
> + * When exp is -1, make str[i] < target[i] and delta is -1.
> + */
> +static void strncmp_full_str_cmp(struct strncmp_test *skel, const char *name,
> +                                int exp)
> +{
> +       size_t nr = sizeof(skel->bss->str);
> +       char *str = skel->bss->str;
> +       int delta = exp;
> +       int got;
> +       size_t i;
> +
> +       memcpy(str, skel->rodata->target, nr);
> +       for (i = 0; i < nr - 1; i++) {
> +               str[i] += delta;
> +
> +               got = trigger_strncmp(skel);
> +               ASSERT_EQ(got, exp, name);
> +
> +               str[i] -= delta;
> +       }
> +}
> +

[...]

> diff --git a/tools/testing/selftests/bpf/progs/strncmp_test.c b/tools/testing/selftests/bpf/progs/strncmp_test.c
> new file mode 100644
> index 000000000000..8cdf950a0ce1
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/strncmp_test.c
> @@ -0,0 +1,59 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2021. Huawei Technologies Co., Ltd */
> +#include <stdbool.h>
> +#include <linux/types.h>
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +#define STRNCMP_STR_SZ 8
> +
> +const char target[STRNCMP_STR_SZ] = "EEEEEEE";
> +
> +char str[STRNCMP_STR_SZ];
> +int cmp_ret = 0;
> +int target_pid = 0;
> +
> +char bad_target[STRNCMP_STR_SZ];
> +unsigned int bad_cmp_str_size = STRNCMP_STR_SZ;
> +
> +char _license[] SEC("license") = "GPL";
> +
> +static __always_inline bool called_by_target_pid(void)
> +{
> +       __u32 pid = bpf_get_current_pid_tgid() >> 32;
> +
> +       return pid == target_pid;
> +}

again, what's the point of this helper? it's used once and you'd
actually save the code by doing the following inline:

if ((bpf_get_current_pid_tgid() >> 32) != target_pid)
    return 0;

> +
> +SEC("tp/syscalls/sys_enter_nanosleep")
> +int do_strncmp(void *ctx)
> +{
> +       if (!called_by_target_pid())
> +               return 0;
> +
> +       cmp_ret = bpf_strncmp(str, STRNCMP_STR_SZ, target);
> +
> +       return 0;
> +}
> +
> +SEC("tp/syscalls/sys_enter_nanosleep")
> +int strncmp_bad_not_const_str_size(void *ctx)
> +{

probably worth leaving a short comment explaining that this program
should fail because ...

> +       cmp_ret = bpf_strncmp(str, bad_cmp_str_size, target);
> +       return 0;
> +}
> +
> +SEC("tp/syscalls/sys_enter_nanosleep")
> +int strncmp_bad_writable_target(void *ctx)
> +{
> +       cmp_ret = bpf_strncmp(str, STRNCMP_STR_SZ, bad_target);
> +       return 0;
> +}
> +
> +SEC("tp/syscalls/sys_enter_nanosleep")
> +int strncmp_bad_not_null_term_target(void *ctx)
> +{
> +       cmp_ret = bpf_strncmp(str, STRNCMP_STR_SZ, target);
> +       return 0;
> +}
> --
> 2.29.2
>
