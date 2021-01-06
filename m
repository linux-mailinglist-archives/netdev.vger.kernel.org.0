Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889FE2EB97C
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 06:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbhAFF1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 00:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbhAFF1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 00:27:17 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF1EC06134C;
        Tue,  5 Jan 2021 21:26:37 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id y128so1741960ybf.10;
        Tue, 05 Jan 2021 21:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UknX9QmHip+tndRmYcnv02sGjXL/6i8uFjVy4S3Vt/Q=;
        b=UCqx7khl9md1WnUTUb7YlN78GS0MsCd0mzo/BVqnUQtr2UsI9ZRjYRzBgoehkg22R9
         /IWD53nu5L+j/BqZNXkU22MBN5k+DU2EpmPBnxoD5tlHG6+ckRYp+blgGNktePOHVRJz
         7DTUVb+2iLoKxijxEqSDi6RldMhKyOJH6hM/rkJgGbQ7OPHbdaVWd5ibNdxFA7BMQf5M
         bd3svGVmYFunWx727frVHFI2tf7u65hxMMgrNaoMxYsU3mn5ntsZbjv34HdL8CXM0qwl
         1lTLfQomb36JqhKEdmboQWozdEFvL5gJI973hMmbbrwHZRzSpeg8o2qRk0QX6NNMPzVy
         iV4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UknX9QmHip+tndRmYcnv02sGjXL/6i8uFjVy4S3Vt/Q=;
        b=H4cadZUfSa4/2IxNKqHK5nnCJeG6q0SukL3LEymijZD+2opScbL5ITbeRF/NjSRY0l
         k1jo7HzzSbdeuY9lidwx7oBzyeQb/ycRFqql5u6+S2bOL579xIrtE6CLKE7fpE4XfNu9
         kbW7VheGw8sMN3Rg4P3e0OLM5WuwjkkRBUruM6JBvtX4lwjEViQGRB6p2hkGEXUIjkhr
         qRtrVp+sBKR5zPcIVz1/HDYLfBXVwYtSCJS6IsexxteKfg5P9KFik7LPPNPZ+7U7qbjS
         Ye4IYpEt1jA6fdMqJU2BiHW/pPu10SuxHmCPXLjFoY0ZEA4+VylvZOWlSrOElPXT0J8v
         TCLw==
X-Gm-Message-State: AOAM532G7/B4XJaRIrMVuoU5XaztrSkHQr2jIFuVr19XVafyOnIav7Dq
        aVc4FG9bCa8bXcH1pVO23AtRbayIB+S96mKCGMA=
X-Google-Smtp-Source: ABdhPJzwaP4vbBtfhgJ0/2XhRCDqHdkub1FRWUHNWILKxZRFis779cP0s0aUseN5F4krORUSrTDk5/+Vl/6naN0a6AE=
X-Received: by 2002:a25:aea8:: with SMTP id b40mr4044517ybj.347.1609910796865;
 Tue, 05 Jan 2021 21:26:36 -0800 (PST)
MIME-Version: 1.0
References: <cover.1609855479.git.sean@mess.org> <a9334d4ecb66d58d326c19b78e18b44a180967d1.1609855479.git.sean@mess.org>
In-Reply-To: <a9334d4ecb66d58d326c19b78e18b44a180967d1.1609855479.git.sean@mess.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Jan 2021 21:26:26 -0800
Message-ID: <CAEf4BzY2nDzT4FjfARiPJdu=G-0uwhxrUHpNrdAEB9NRxu4RqQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] bpf: add tests for ints larger than 128 bits
To:     Sean Young <sean@mess.org>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        linux-doc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 6:45 AM Sean Young <sean@mess.org> wrote:
>
> clang supports arbitrary length ints using the _ExtInt extension. This
> can be useful to hold very large values, e.g. 256 bit or 512 bit types.
>
> Larger types (e.g. 1024 bits) are possible but I am unaware of a use
> case for these.
>
> This requires the _ExtInt extension enabled in clang, which is under
> review.
>
> Link: https://clang.llvm.org/docs/LanguageExtensions.html#extended-integer-types
> Link: https://reviews.llvm.org/D93103
>
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  tools/testing/selftests/bpf/Makefile          |   3 +-
>  tools/testing/selftests/bpf/prog_tests/btf.c  |   3 +-
>  .../selftests/bpf/progs/test_btf_extint.c     |  50 ++
>  tools/testing/selftests/bpf/test_extint.py    | 535 ++++++++++++++++++
>  4 files changed, 589 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_btf_extint.c
>  create mode 100755 tools/testing/selftests/bpf/test_extint.py
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 8c33e999319a..436ad1aed3d9 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -70,7 +70,8 @@ TEST_PROGS := test_kmod.sh \
>         test_bpftool_build.sh \
>         test_bpftool.sh \
>         test_bpftool_metadata.sh \
> -       test_xsk.sh
> +       test_xsk.sh \
> +       test_extint.py
>
>  TEST_PROGS_EXTENDED := with_addr.sh \
>         with_tunnels.sh \
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
> index 8ae97e2a4b9d..96a93502cf27 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf.c
> @@ -4073,6 +4073,7 @@ struct btf_file_test {
>  static struct btf_file_test file_tests[] = {
>         { .file = "test_btf_haskv.o", },
>         { .file = "test_btf_newkv.o", },
> +       { .file = "test_btf_extint.o", },
>         { .file = "test_btf_nokv.o", .btf_kv_notfound = true, },
>  };
>
> @@ -4414,7 +4415,7 @@ static struct btf_raw_test pprint_test_template[] = {
>          * will have both int and enum types.
>          */
>         .raw_types = {
> -               /* unsighed char */                     /* [1] */
> +               /* unsigned char */                     /* [1] */

unintentional whitespaces change?

>                 BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 8, 1),
>                 /* unsigned short */                    /* [2] */
>                 BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 16, 2),
> diff --git a/tools/testing/selftests/bpf/progs/test_btf_extint.c b/tools/testing/selftests/bpf/progs/test_btf_extint.c
> new file mode 100644
> index 000000000000..b0fa9f130dda
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_btf_extint.c
> @@ -0,0 +1,50 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include "bpf_legacy.h"
> +
> +struct extint {
> +       _ExtInt(256) v256;
> +       _ExtInt(512) v512;
> +};
> +
> +struct bpf_map_def SEC("maps") btf_map = {
> +       .type = BPF_MAP_TYPE_ARRAY,
> +       .key_size = sizeof(int),
> +       .value_size = sizeof(struct extint),
> +       .max_entries = 1,
> +};
> +
> +BPF_ANNOTATE_KV_PAIR(btf_map, int, struct extint);

this is deprecated, don't add new tests using it. Please use BTF-based
map definition instead (see any other selftests).

> +
> +__attribute__((noinline))
> +int test_long_fname_2(void)
> +{
> +       struct extint *bi;
> +       int key = 0;
> +
> +       bi = bpf_map_lookup_elem(&btf_map, &key);
> +       if (!bi)
> +               return 0;
> +
> +       bi->v256 <<= 64;
> +       bi->v256 += (_ExtInt(256))0xcafedead;
> +       bi->v512 <<= 128;
> +       bi->v512 += (_ExtInt(512))0xff00ff00ff00ffull;
> +
> +       return 0;
> +}
> +
> +__attribute__((noinline))
> +int test_long_fname_1(void)
> +{
> +       return test_long_fname_2();
> +}
> +
> +SEC("dummy_tracepoint")
> +int _dummy_tracepoint(void *arg)
> +{
> +       return test_long_fname_1();
> +}

why the chain of test_long_fname functions? Please minimize the test
to only test the essential logic - _ExtInt handling.

> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/test_extint.py b/tools/testing/selftests/bpf/test_extint.py
> new file mode 100755
> index 000000000000..86af815a0cf6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/test_extint.py

this looks like a total overkill (with a lot of unrelated code) for a
pretty simple test you need to perform. you can run bpftool and get
its output from test_progs with popen().

> @@ -0,0 +1,535 @@
> +#!/usr/bin/python3

[...]
