Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368BA5B0C35
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 20:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiIGSJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 14:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiIGSJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 14:09:36 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443A06361;
        Wed,  7 Sep 2022 11:09:25 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id fg1so10098230ejc.2;
        Wed, 07 Sep 2022 11:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=YpBQotoGZNVTm0xUrupXAeoFQOusEenuOy1efqUfeig=;
        b=j4ISLYTikdQ6qUZEdNQO2K8UEEV/jYQxSH/ugTlxA2Rp9XhkXab+fAt7e6NWqpI1y4
         NZdbJAPREKqWPbgOdFfTmUxUKEWIxKY75WRayDWkTFTb/IOiMQZEvXYwAG+I6kOhlF0z
         1hiLgTn/N5yntMm+bCRHA8eo+HSHADrD9KWweabXH2mxexPciowOEQ3WjD268z8MArfY
         HCXpPbnHmho/9a++dlI2H9JK7j9H3baAIA/9WKbCq0sjYfuVSso09o2yQkFavQFdoYVy
         8WUB3Dfjak5wiGiiF51FUZz74pY6Yb1jRNM+q5eWlAp4C8E2Xk7raE5okQc6gOFDEK13
         0hMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=YpBQotoGZNVTm0xUrupXAeoFQOusEenuOy1efqUfeig=;
        b=5XlNalnMmSKth7Yr7Ct51iyVxuMBMNJFA3yvf7IfEZHrhLSYL9g+KpqbSAaQEnsIDW
         UHJdsaEKmExKv09SrrUQBWf3TVr0qznEHgl3SEVftBSpaNaAysJVTXtW6ldgUKOdjpw+
         O8kaYmQXVhsvMCL25nOCa31QY0LY+K3NIzv+zm3HzS7KPgQ/Ly9UL3Gc5MIFpFkkKtFv
         ri6thBzw/MvK5yv+hYkTv1KfzHoqJWb+bv3VODhB2w+BcWpq3fjnP7f4fSAxiZu2T+9S
         9I8FNzZMpr+DJk5Y1sJ1wZKqy3SBym5gXF/D+1kZPAvK67ba/KpJw1SJS6vOTjnLlIYK
         yrxg==
X-Gm-Message-State: ACgBeo1cxAq6FpiJZuFOKKE+5V70Kl0JLS2PaZ3Fr/Wi64xRNV6wIANR
        vQPL0Ye4UHz7iTQq8o4yWxK53TJlJKGQBMzrJF4=
X-Google-Smtp-Source: AA6agR6wtygx0JUUhPohNUk5lAc85vpE1NnKtlYo41kHO/pZRz4XZFdDpp8a3uD4M+AqIiT2pkzaBAYq2gGMqGsynZE=
X-Received: by 2002:a17:907:2c74:b0:741:657a:89de with SMTP id
 ib20-20020a1709072c7400b00741657a89demr3156554ejc.58.1662574163526; Wed, 07
 Sep 2022 11:09:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220906151303.2780789-1-benjamin.tissoires@redhat.com>
 <20220906151303.2780789-5-benjamin.tissoires@redhat.com> <CAP01T76Q4VGYveL=6NoRFsgjFvLTLLF8jER0HwU1hx+maqo7Tg@mail.gmail.com>
In-Reply-To: <CAP01T76Q4VGYveL=6NoRFsgjFvLTLLF8jER0HwU1hx+maqo7Tg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 7 Sep 2022 11:09:12 -0700
Message-ID: <CAADnVQK=ZYRvnR38+JMS_ckZBAeHm_o1Jg3XCyr1mg2Hpu4xSg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v11 4/7] selftests/bpf: add test for accessing
 ctx from syscall program type
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 7, 2022 at 10:46 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Tue, 6 Sept 2022 at 17:13, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> >
> > We need to also export the kfunc set to the syscall program type,
> > and then add a couple of eBPF programs that are testing those calls.
> >
> > The first one checks for valid access, and the second one is OK
> > from a static analysis point of view but fails at run time because
> > we are trying to access outside of the allocated memory.
> >
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >
> > ---
>
> CI is failing for test_progs-no_alu32:
> https://github.com/kernel-patches/bpf/runs/8220916615?check_suite_focus=true
>
> >
> > changes in v11:
> > - use new way of declaring tests
> >
> > changes in v10:
> > - use new definitions for tests in an array
> > - add a new kfunc syscall_test_null_fail test
> >
> > no changes in v9
> >
> > no changes in v8
> >
> > changes in v7:
> > - add 1 more case to ensure we can read the entire sizeof(ctx)
> > - add a test case for when the context is NULL
> >
> > new in v6
> > ---
> >  net/bpf/test_run.c                            |   1 +
> >  .../selftests/bpf/prog_tests/kfunc_call.c     | 143 +++++++++++++++++-
> >  .../selftests/bpf/progs/kfunc_call_fail.c     |  39 +++++
> >  .../selftests/bpf/progs/kfunc_call_test.c     |  38 +++++
> >  4 files changed, 214 insertions(+), 7 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_fail.c
> >
> > diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > index 25d8ecf105aa..f16baf977a21 100644
> > --- a/net/bpf/test_run.c
> > +++ b/net/bpf/test_run.c
> > @@ -1634,6 +1634,7 @@ static int __init bpf_prog_test_run_init(void)
> >
> >         ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_prog_test_kfunc_set);
> >         ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &bpf_prog_test_kfunc_set);
> > +       ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &bpf_prog_test_kfunc_set);
> >         return ret ?: register_btf_id_dtor_kfuncs(bpf_prog_test_dtor_kfunc,
> >                                                   ARRAY_SIZE(bpf_prog_test_dtor_kfunc),
> >                                                   THIS_MODULE);
> > diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> > index 9dfbe5355a2d..d5881c3331a8 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> > @@ -2,6 +2,7 @@
> >  /* Copyright (c) 2021 Facebook */
> >  #include <test_progs.h>
> >  #include <network_helpers.h>
> > +#include "kfunc_call_fail.skel.h"
> >  #include "kfunc_call_test.skel.h"
> >  #include "kfunc_call_test.lskel.h"
> >  #include "kfunc_call_test_subprog.skel.h"
> > @@ -10,37 +11,96 @@
> >
> >  #include "cap_helpers.h"
> >
> > +static size_t log_buf_sz = 1048576; /* 1 MB */
> > +static char obj_log_buf[1048576];
> > +
> > +enum kfunc_test_type {
> > +       tc_test = 0,
> > +       syscall_test,
> > +       syscall_null_ctx_test,
> > +};
> > +
> >  struct kfunc_test_params {
> >         const char *prog_name;
> >         unsigned long lskel_prog_desc_offset;
> >         int retval;
> > +       enum kfunc_test_type test_type;
> > +       const char *expected_err_msg;
> >  };
> >
> > -#define TC_TEST(name, __retval) \
> > +#define __BPF_TEST_SUCCESS(name, __retval, type) \
> >         { \
> >           .prog_name = #name, \
> >           .lskel_prog_desc_offset = offsetof(struct kfunc_call_test_lskel, progs.name), \
> >           .retval = __retval, \
> > +         .test_type = type, \
> > +         .expected_err_msg = NULL, \
> > +       }
> > +
> > +#define __BPF_TEST_FAIL(name, __retval, type, error_msg) \
> > +       { \
> > +         .prog_name = #name, \
> > +         .lskel_prog_desc_offset = 0 /* unused when test is failing */, \
> > +         .retval = __retval, \
> > +         .test_type = type, \
> > +         .expected_err_msg = error_msg, \
> >         }
> >
> > +#define TC_TEST(name, retval) __BPF_TEST_SUCCESS(name, retval, tc_test)
> > +#define SYSCALL_TEST(name, retval) __BPF_TEST_SUCCESS(name, retval, syscall_test)
> > +#define SYSCALL_NULL_CTX_TEST(name, retval) __BPF_TEST_SUCCESS(name, retval, syscall_null_ctx_test)
> > +
> > +#define SYSCALL_NULL_CTX_FAIL(name, retval, error_msg) \
> > +       __BPF_TEST_FAIL(name, retval, syscall_null_ctx_test, error_msg)
> > +
> >  static struct kfunc_test_params kfunc_tests[] = {
> > +       /* failure cases:
> > +        * if retval is 0 -> the program will fail to load and the error message is an error
> > +        * if retval is not 0 -> the program can be loaded but running it will gives the
> > +        *                       provided return value. The error message is thus the one
> > +        *                       from a successful load
> > +        */
> > +       SYSCALL_NULL_CTX_FAIL(kfunc_syscall_test_fail, -EINVAL, "processed 4 insns"),
> > +       SYSCALL_NULL_CTX_FAIL(kfunc_syscall_test_null_fail, -EINVAL, "processed 4 insns"),
> > +
> > +       /* success cases */
> >         TC_TEST(kfunc_call_test1, 12),
> >         TC_TEST(kfunc_call_test2, 3),
> >         TC_TEST(kfunc_call_test_ref_btf_id, 0),
> > +       SYSCALL_TEST(kfunc_syscall_test, 0),
> > +       SYSCALL_NULL_CTX_TEST(kfunc_syscall_test_null, 0),
> > +};
> > +
> > +struct syscall_test_args {
> > +       __u8 data[16];
> > +       size_t size;
> >  };
> >
> >  static void verify_success(struct kfunc_test_params *param)
> >  {
> >         struct kfunc_call_test_lskel *lskel = NULL;
> > +       LIBBPF_OPTS(bpf_test_run_opts, topts);
> >         struct bpf_prog_desc *lskel_prog;
> >         struct kfunc_call_test *skel;
> >         struct bpf_program *prog;
> >         int prog_fd, err;
> > -       LIBBPF_OPTS(bpf_test_run_opts, topts,
> > -               .data_in = &pkt_v4,
> > -               .data_size_in = sizeof(pkt_v4),
> > -               .repeat = 1,
> > -       );
> > +       struct syscall_test_args args = {
> > +               .size = 10,
> > +       };
> > +
> > +       switch (param->test_type) {
> > +       case syscall_test:
> > +               topts.ctx_in = &args;
> > +               topts.ctx_size_in = sizeof(args);
> > +               /* fallthrough */
> > +       case syscall_null_ctx_test:
> > +               break;
> > +       case tc_test:
> > +               topts.data_in = &pkt_v4;
> > +               topts.data_size_in = sizeof(pkt_v4);
> > +               topts.repeat = 1;
> > +               break;
> > +       }
> >
> >         /* first test with normal libbpf */
> >         skel = kfunc_call_test__open_and_load();
> > @@ -79,6 +139,72 @@ static void verify_success(struct kfunc_test_params *param)
> >                 kfunc_call_test_lskel__destroy(lskel);
> >  }
> >
> > +static void verify_fail(struct kfunc_test_params *param)
> > +{
> > +       LIBBPF_OPTS(bpf_object_open_opts, opts);
> > +       LIBBPF_OPTS(bpf_test_run_opts, topts);
> > +       struct bpf_program *prog;
> > +       struct kfunc_call_fail *skel;
> > +       int prog_fd, err;
> > +       struct syscall_test_args args = {
> > +               .size = 10,
> > +       };
> > +
> > +       opts.kernel_log_buf = obj_log_buf;
> > +       opts.kernel_log_size = log_buf_sz;
> > +       opts.kernel_log_level = 1;
> > +
> > +       switch (param->test_type) {
> > +       case syscall_test:
> > +               topts.ctx_in = &args;
> > +               topts.ctx_size_in = sizeof(args);
> > +               /* fallthrough */
> > +       case syscall_null_ctx_test:
> > +               break;
> > +       case tc_test:
> > +               topts.data_in = &pkt_v4;
> > +               topts.data_size_in = sizeof(pkt_v4);
> > +               break;
> > +               topts.repeat = 1;
> > +       }
> > +
> > +       skel = kfunc_call_fail__open_opts(&opts);
> > +       if (!ASSERT_OK_PTR(skel, "kfunc_call_fail__open_opts"))
> > +               goto cleanup;
> > +
> > +       prog = bpf_object__find_program_by_name(skel->obj, param->prog_name);
> > +       if (!ASSERT_OK_PTR(prog, "bpf_object__find_program_by_name"))
> > +               goto cleanup;
> > +
> > +       bpf_program__set_autoload(prog, true);
> > +
> > +       err = kfunc_call_fail__load(skel);
> > +       if (!param->retval) {
> > +               /* the verifier is supposed to complain and refuses to load */
> > +               if (!ASSERT_ERR(err, "unexpected load success"))
> > +                       goto out_err;
> > +
> > +       } else {
> > +               /* the program is loaded but must dynamically fail */
> > +               if (!ASSERT_OK(err, "unexpected load error"))
> > +                       goto out_err;
> > +
> > +               prog_fd = bpf_program__fd(prog);
> > +               err = bpf_prog_test_run_opts(prog_fd, &topts);
> > +               if (!ASSERT_EQ(err, param->retval, param->prog_name))
> > +                       goto out_err;
> > +       }
> > +
> > +out_err:
> > +       if (!ASSERT_OK_PTR(strstr(obj_log_buf, param->expected_err_msg), "expected_err_msg")) {
> > +               fprintf(stderr, "Expected err_msg: %s\n", param->expected_err_msg);
> > +               fprintf(stderr, "Verifier output: %s\n", obj_log_buf);
> > +       }
> > +
> > +cleanup:
> > +       kfunc_call_fail__destroy(skel);
> > +}
> > +
> >  static void test_main(void)
> >  {
> >         int i;
> > @@ -87,7 +213,10 @@ static void test_main(void)
> >                 if (!test__start_subtest(kfunc_tests[i].prog_name))
> >                         continue;
> >
> > -               verify_success(&kfunc_tests[i]);
> > +               if (!kfunc_tests[i].expected_err_msg)
> > +                       verify_success(&kfunc_tests[i]);
> > +               else
> > +                       verify_fail(&kfunc_tests[i]);
> >         }
> >  }
> >
> > diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_fail.c b/tools/testing/selftests/bpf/progs/kfunc_call_fail.c
> > new file mode 100644
> > index 000000000000..4168027f2ab1
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/kfunc_call_fail.c
> > @@ -0,0 +1,39 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2021 Facebook */
> > +#include <vmlinux.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +extern void bpf_kfunc_call_test_mem_len_pass1(void *mem, int len) __ksym;
> > +
> > +struct syscall_test_args {
> > +       __u8 data[16];
> > +       size_t size;
> > +};
> > +
> > +SEC("?syscall")
> > +int kfunc_syscall_test_fail(struct syscall_test_args *args)
> > +{
> > +       bpf_kfunc_call_test_mem_len_pass1(&args->data, sizeof(*args) + 1);
> > +
> > +       return 0;
> > +}
> > +
> > +SEC("?syscall")
> > +int kfunc_syscall_test_null_fail(struct syscall_test_args *args)
> > +{
> > +       /* Must be called with args as a NULL pointer
> > +        * we do not check for it to have the verifier consider that
> > +        * the pointer might not be null, and so we can load it.
> > +        *
> > +        * So the following can not be added:
> > +        *
> > +        * if (args)
> > +        *      return -22;
> > +        */
> > +
> > +       bpf_kfunc_call_test_mem_len_pass1(args, sizeof(*args));
> > +
> > +       return 0;
> > +}
> > +
> > +char _license[] SEC("license") = "GPL";
> > diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> > index 5aecbb9fdc68..94c05267e5e7 100644
> > --- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> > +++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> > @@ -92,4 +92,42 @@ int kfunc_call_test_pass(struct __sk_buff *skb)
> >         return 0;
> >  }
> >
> > +struct syscall_test_args {
> > +       __u8 data[16];
> > +       size_t size;
> > +};
> > +
> > +SEC("syscall")
> > +int kfunc_syscall_test(struct syscall_test_args *args)
> > +{
> > +       const int size = args->size;
> > +
> > +       if (size > sizeof(args->data))
> > +               return -7; /* -E2BIG */
> > +
>
> Looks like it is due to this. Verifier is confused because:
> r7 = args->data;
> r1 = r7;
>
> then it does r1 <<= 32; r1 >>=32; clearing upper 32 bits, so both r1
> and r7 lose the id association which propagates the bounds of r1
> learnt from comparison of it with sizeof(args->data);
>
> > +       bpf_kfunc_call_test_mem_len_pass1(&args->data, sizeof(args->data));
> > +       bpf_kfunc_call_test_mem_len_pass1(&args->data, sizeof(*args));
>
> Later llvm assigns r7 to r2 for this call's 2nd arg. At this point the
> verifier still thinks r7 is unbounded, while to make a call with mem,
> len pair you need non-negative min value.
>
> Easiest way might be to just do args->size & sizeof(args->data), as
> the verifier log says. You might still keep the error above.
> Others may have better ideas/insights.

I just did s/const int size/const long size/
to fix the issues.

Also fixed commit in patch 3 that talks about max_ctx_offset
and did:
-       BTF_KFUNC_SET_MAX_CNT = 64,
+       BTF_KFUNC_SET_MAX_CNT = 256,

and applied.
