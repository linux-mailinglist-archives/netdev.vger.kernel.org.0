Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2AB5B0B4F
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiIGRRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiIGRRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:17:09 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B62BC82F;
        Wed,  7 Sep 2022 10:17:08 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id 62so12027675iov.5;
        Wed, 07 Sep 2022 10:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=KKIRQMJkDKXtKt4G+fefePPM90t25xGMOi2Kab/8G5k=;
        b=h9Ov6KEGNVtE6tzwj0P314uLRue5Yn48cLhvKec2YIw7QWr1HXRJc2iEv4/yIBTLPZ
         jkbWbyeupjT5toYbjIy8g51zHM5oO7UCMf/HehdXe0HYQtp7QyYGXyk7JG4SOKM7NQs7
         dVNxjgydcdDKqoO8VcdmEbCTvt7esD0Jc2Td8YZav422X/gWmbdOdlGKhEgyDp+bZ1dl
         0Fo8SlJKhp9FGDar+jwzOrSh2jqv5v06ZHqx21fDdXM5pZbWkp5tfgKzxhg2ENiEDexH
         +kSkDcVUokQoEky+F2P1gi819RL9Egp1T3u7wu/NS7rn4bwAfcoPH6MkTe1+qHINipVS
         Mohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=KKIRQMJkDKXtKt4G+fefePPM90t25xGMOi2Kab/8G5k=;
        b=SXGGkTxnKEeHVTOpE4sdw/6aoBy/g1d8vaWM1V3LOxe4pg2LbFlRIui0zrHkKgEE2I
         WBpcXomNt4WyG9TGBwxxSWlo1IhBhPbnWuRrebFxCxpys65o54XZMKCqQDjl3FfVMrGj
         HvNvxi9oxilUIMjU4JDcfb4oCMCyzaUuC/mw1nd+LWDKNKiUFx+Va4aQ4vW7b5FAXcmF
         K8a/fftxbUfXCnykgfv2Y3rLaZL+pBoO12lvlMPnRKUk5EVKAdpOsq0tQuXNeQuHuP3A
         YzbbwRFZ/GzbF7mEgpIT0ExBTU6PXfpozJSB0JIFP2mwTurqe8uuGm3xGixDZXcowHPd
         nYYA==
X-Gm-Message-State: ACgBeo2dUwFxe4Fno5bLkU7cY9cWFobQyzdv4TGj+HNu1Zype+aEq2FM
        3y2SsnnOmmwi8OAXxQPTZRIsGZADHjySW4aLuUo=
X-Google-Smtp-Source: AA6agR41zZYrh7NLOFW5mJwpIwPooqsWkrQDW0V3lCXeN3D5avc5mBviFJUPkGWBUb4uZ5ZUCAnmgBRXJx4M0QQ9fA0=
X-Received: by 2002:a05:6638:3802:b0:351:d8a5:6d58 with SMTP id
 i2-20020a056638380200b00351d8a56d58mr2747786jav.206.1662571027533; Wed, 07
 Sep 2022 10:17:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220906151303.2780789-1-benjamin.tissoires@redhat.com> <20220906151303.2780789-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20220906151303.2780789-2-benjamin.tissoires@redhat.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 7 Sep 2022 19:16:31 +0200
Message-ID: <CAP01T744MZhX8qd1VaZ8p=ZYCX2ogf=-mmy40j-7ypW2oNFzsw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v11 1/7] selftests/bpf: regroup and declare
 similar kfuncs selftests in an array
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
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

On Tue, 6 Sept 2022 at 17:13, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Similar to tools/testing/selftests/bpf/prog_tests/dynptr.c:
> we declare an array of tests that we run one by one in a for loop.
>
> Followup patches will add more similar-ish tests, so avoid a lot of copy
> paste by grouping the declaration in an array.
>
> For light skeletons, we have to rely on the offsetof() macro so we can
> statically declare which program we are using.
> In the libbpf case, we can rely on bpf_object__find_program_by_name().
> So also change the Makefile to generate both light skeletons and normal
> ones.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

>
> changes in v11:
> - use of both light skeletons and normal libbpf
>
> new in v10
> ---
>  tools/testing/selftests/bpf/Makefile          |  5 +-
>  .../selftests/bpf/prog_tests/kfunc_call.c     | 81 +++++++++++++++----
>  2 files changed, 68 insertions(+), 18 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index eecad99f1735..314216d77b8d 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -351,11 +351,12 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h             \
>                 test_subskeleton.skel.h test_subskeleton_lib.skel.h     \
>                 test_usdt.skel.h
>
> -LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
> +LSKELS := fentry_test.c fexit_test.c fexit_sleep.c \
>         test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c \
>         map_ptr_kern.c core_kern.c core_kern_overflow.c
>  # Generate both light skeleton and libbpf skeleton for these
> -LSKELS_EXTRA := test_ksyms_module.c test_ksyms_weak.c kfunc_call_test_subprog.c
> +LSKELS_EXTRA := test_ksyms_module.c test_ksyms_weak.c kfunc_call_test.c \
> +       kfunc_call_test_subprog.c
>  SKEL_BLACKLIST += $$(LSKELS)
>
>  test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
> diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> index eede7c304f86..9dfbe5355a2d 100644
> --- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> +++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> @@ -2,6 +2,7 @@
>  /* Copyright (c) 2021 Facebook */
>  #include <test_progs.h>
>  #include <network_helpers.h>
> +#include "kfunc_call_test.skel.h"
>  #include "kfunc_call_test.lskel.h"
>  #include "kfunc_call_test_subprog.skel.h"
>  #include "kfunc_call_test_subprog.lskel.h"
> @@ -9,9 +10,31 @@
>
>  #include "cap_helpers.h"
>
> -static void test_main(void)
> +struct kfunc_test_params {
> +       const char *prog_name;
> +       unsigned long lskel_prog_desc_offset;
> +       int retval;
> +};
> +
> +#define TC_TEST(name, __retval) \
> +       { \
> +         .prog_name = #name, \
> +         .lskel_prog_desc_offset = offsetof(struct kfunc_call_test_lskel, progs.name), \
> +         .retval = __retval, \
> +       }
> +
> +static struct kfunc_test_params kfunc_tests[] = {
> +       TC_TEST(kfunc_call_test1, 12),
> +       TC_TEST(kfunc_call_test2, 3),
> +       TC_TEST(kfunc_call_test_ref_btf_id, 0),
> +};
> +
> +static void verify_success(struct kfunc_test_params *param)
>  {
> -       struct kfunc_call_test_lskel *skel;
> +       struct kfunc_call_test_lskel *lskel = NULL;
> +       struct bpf_prog_desc *lskel_prog;
> +       struct kfunc_call_test *skel;
> +       struct bpf_program *prog;
>         int prog_fd, err;
>         LIBBPF_OPTS(bpf_test_run_opts, topts,
>                 .data_in = &pkt_v4,
> @@ -19,26 +42,53 @@ static void test_main(void)
>                 .repeat = 1,
>         );
>
> -       skel = kfunc_call_test_lskel__open_and_load();
> +       /* first test with normal libbpf */
> +       skel = kfunc_call_test__open_and_load();
>         if (!ASSERT_OK_PTR(skel, "skel"))
>                 return;
>
> -       prog_fd = skel->progs.kfunc_call_test1.prog_fd;
> -       err = bpf_prog_test_run_opts(prog_fd, &topts);
> -       ASSERT_OK(err, "bpf_prog_test_run(test1)");
> -       ASSERT_EQ(topts.retval, 12, "test1-retval");
> +       prog = bpf_object__find_program_by_name(skel->obj, param->prog_name);
> +       if (!ASSERT_OK_PTR(prog, "bpf_object__find_program_by_name"))
> +               goto cleanup;
>
> -       prog_fd = skel->progs.kfunc_call_test2.prog_fd;
> +       prog_fd = bpf_program__fd(prog);
>         err = bpf_prog_test_run_opts(prog_fd, &topts);
> -       ASSERT_OK(err, "bpf_prog_test_run(test2)");
> -       ASSERT_EQ(topts.retval, 3, "test2-retval");
> +       if (!ASSERT_OK(err, param->prog_name))
> +               goto cleanup;
> +
> +       if (!ASSERT_EQ(topts.retval, param->retval, "retval"))
> +               goto cleanup;
> +
> +       /* second test with light skeletons */
> +       lskel = kfunc_call_test_lskel__open_and_load();
> +       if (!ASSERT_OK_PTR(lskel, "lskel"))
> +               goto cleanup;
> +
> +       lskel_prog = (struct bpf_prog_desc *)((char *)lskel + param->lskel_prog_desc_offset);
>
> -       prog_fd = skel->progs.kfunc_call_test_ref_btf_id.prog_fd;
> +       prog_fd = lskel_prog->prog_fd;
>         err = bpf_prog_test_run_opts(prog_fd, &topts);
> -       ASSERT_OK(err, "bpf_prog_test_run(test_ref_btf_id)");
> -       ASSERT_EQ(topts.retval, 0, "test_ref_btf_id-retval");
> +       if (!ASSERT_OK(err, param->prog_name))
> +               goto cleanup;
> +
> +       ASSERT_EQ(topts.retval, param->retval, "retval");
> +
> +cleanup:
> +       kfunc_call_test__destroy(skel);
> +       if (lskel)
> +               kfunc_call_test_lskel__destroy(lskel);
> +}
> +
> +static void test_main(void)
> +{
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(kfunc_tests); i++) {
> +               if (!test__start_subtest(kfunc_tests[i].prog_name))
> +                       continue;
>
> -       kfunc_call_test_lskel__destroy(skel);
> +               verify_success(&kfunc_tests[i]);
> +       }
>  }
>
>  static void test_subprog(void)
> @@ -121,8 +171,7 @@ static void test_destructive(void)
>
>  void test_kfunc_call(void)
>  {
> -       if (test__start_subtest("main"))
> -               test_main();
> +       test_main();
>
>         if (test__start_subtest("subprog"))
>                 test_subprog();
> --
> 2.36.1
>
