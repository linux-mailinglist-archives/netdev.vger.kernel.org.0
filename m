Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C7E5A1ECC
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 04:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244804AbiHZC1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 22:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244434AbiHZC1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 22:27:08 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D604CB5DC;
        Thu, 25 Aug 2022 19:27:07 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id y17so156322ilp.10;
        Thu, 25 Aug 2022 19:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=BLbW/Hc9+8C/YeGWsEa0wxvXNrLc+FSe/iqx4IWMEKY=;
        b=nLkOregbT+5WWjBg9MO2obFGHIWiy+pR0M4MCIMhIPzfIvZn1M4FskxC4phWe0GzTq
         t5oDJYIpmfIZdnF6cgKHF8Yfx/Znr7qQFjafOHPR4pBn3xF3TBf+V/LVnSwgsv3oz0Oa
         iurqpSQUiqyV7xuVG8UIJRL7fGjyOyoEQL8Pqk6eitCd7iSXjYqONYbyIG/IwMzbJxmQ
         mqRiMPOcVGuS98KU192H9jmBOAuSiVuwCvVqvTNXoiCVMMuHzCSy5lhH3Didx5MywKzh
         D4i9+Ums2BDoazHbKt8hzMYg0yNaO7l8pd5vUqNYsnuhDh/qp7Xb/yZINgu/RX8ADVx2
         WzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=BLbW/Hc9+8C/YeGWsEa0wxvXNrLc+FSe/iqx4IWMEKY=;
        b=gcT71/2lKxIeDIIwM9AlbIQY+Qd9FCqEFsqlBGzNEowMQzFLEbreRAnfkfu8e28IQA
         nRL2UfvCm2kWWlnC2QzZlBjbVkW70u87WQm1aF1XLUvLZHcvEtZHpYceC7wgal9NemCg
         bgiOJqWvDMXSRFJ8teCKv1bI/JHCmxHlaXT+HSxIU1qT+ugYEOTeDaBuHWjb2coUvevl
         HAisIung7A/XMmkZYcoG1XiACwOMvST0hPEgog0A68Df0swq1BHhIvo7pc0K/Q74sPFn
         5oXqDBi9TRwSBHoPZW9QaOwCXoXUG7WcqLXqHURMb0V+RfrCA5vTXNEtDMI/ny8rH8Oj
         Fq9g==
X-Gm-Message-State: ACgBeo3STx8zrtTbZbFJNWFaCUPzLBFdTA3kb18MW5lSYsb42S2eXKjR
        XcPmwZezgIVRHSNIWS30+hV0cV/g1i2PcIf71zo=
X-Google-Smtp-Source: AA6agR7U/3OjyR2q/ujGHj2ZbxQS2mnEgOZ+g5Z97d+MHg8yI9zuc5BjgMabAaB23Ei+qfahXelFbkTkIv8x1zrTOfc=
X-Received: by 2002:a05:6e02:1c04:b0:2df:6b58:5fe8 with SMTP id
 l4-20020a056e021c0400b002df6b585fe8mr3230907ilh.68.1661480826341; Thu, 25 Aug
 2022 19:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com> <20220824134055.1328882-6-benjamin.tissoires@redhat.com>
In-Reply-To: <20220824134055.1328882-6-benjamin.tissoires@redhat.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 26 Aug 2022 04:26:30 +0200
Message-ID: <CAP01T75YkJx10kTLEb7fQOY18ELRKHQMHsmO-OCjyGnUJzUVZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 05/23] selftests/bpf: Add tests for kfunc
 returning a memory pointer
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
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

On Wed, 24 Aug 2022 at 15:41, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> We add 2 new kfuncs that are following the RET_PTR_TO_MEM
> capability from the previous commit.
> Then we test them in selftests:
> the first tests are testing valid case, and are not failing,
> and the later ones are actually preventing the program to be loaded
> because they are wrong.
>
> To work around that, we mark the failing ones as not autoloaded
> (with SEC("?tc")), and we manually enable them one by one, ensuring
> the verifier rejects them.
>
> To be able to use bpf_program__set_autoload() from libbpf, we need
> to use a plain skeleton, not a light-skeleton, and this is why we
> also change the Makefile to generate both for kfunc_call_test.c
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> changes in v9:
> - updated to match upstream (net/bpf/test_run.c id sets is now using
>   flags)
>
> no changes in v8
>
> changes in v7:
> - removed stray include/linux/btf.h change
>
> new in v6
> ---
>  net/bpf/test_run.c                            | 20 +++++
>  tools/testing/selftests/bpf/Makefile          |  5 +-
>  .../selftests/bpf/prog_tests/kfunc_call.c     | 48 ++++++++++
>  .../selftests/bpf/progs/kfunc_call_test.c     | 89 +++++++++++++++++++
>  4 files changed, 160 insertions(+), 2 deletions(-)
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index f16baf977a21..6accd57d4ded 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -606,6 +606,24 @@ noinline void bpf_kfunc_call_memb1_release(struct prog_test_member1 *p)
>         WARN_ON_ONCE(1);
>  }
>
> +static int *__bpf_kfunc_call_test_get_mem(struct prog_test_ref_kfunc *p, const int size)
> +{
> +       if (size > 2 * sizeof(int))
> +               return NULL;
> +
> +       return (int *)p;
> +}
> +
> +noinline int *bpf_kfunc_call_test_get_rdwr_mem(struct prog_test_ref_kfunc *p, const int rdwr_buf_size)
> +{
> +       return __bpf_kfunc_call_test_get_mem(p, rdwr_buf_size);
> +}
> +
> +noinline int *bpf_kfunc_call_test_get_rdonly_mem(struct prog_test_ref_kfunc *p, const int rdonly_buf_size)
> +{
> +       return __bpf_kfunc_call_test_get_mem(p, rdonly_buf_size);
> +}
> +
>  noinline struct prog_test_ref_kfunc *
>  bpf_kfunc_call_test_kptr_get(struct prog_test_ref_kfunc **pp, int a, int b)
>  {
> @@ -712,6 +730,8 @@ BTF_ID_FLAGS(func, bpf_kfunc_call_memb_acquire, KF_ACQUIRE | KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_release, KF_RELEASE)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_memb_release, KF_RELEASE)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_memb1_release, KF_RELEASE)
> +BTF_ID_FLAGS(func, bpf_kfunc_call_test_get_rdwr_mem, KF_RET_NULL)
> +BTF_ID_FLAGS(func, bpf_kfunc_call_test_get_rdonly_mem, KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_kptr_get, KF_ACQUIRE | KF_RET_NULL | KF_KPTR_GET)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_pass_ctx)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_pass1)
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 8d59ec7f4c2d..0905315ff86d 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -350,11 +350,12 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h             \
>                 test_subskeleton.skel.h test_subskeleton_lib.skel.h     \
>                 test_usdt.skel.h
>
> -LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
> +LSKELS := fentry_test.c fexit_test.c fexit_sleep.c \
>         test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c \
>         map_ptr_kern.c core_kern.c core_kern_overflow.c
>  # Generate both light skeleton and libbpf skeleton for these
> -LSKELS_EXTRA := test_ksyms_module.c test_ksyms_weak.c kfunc_call_test_subprog.c
> +LSKELS_EXTRA := test_ksyms_module.c test_ksyms_weak.c kfunc_call_test.c        \
> +               kfunc_call_test_subprog.c
>  SKEL_BLACKLIST += $$(LSKELS)
>
>  test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
> diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> index 1edad012fe01..590417d48962 100644
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
> @@ -53,10 +54,12 @@ static void test_main(void)
>         prog_fd = skel->progs.kfunc_syscall_test.prog_fd;
>         err = bpf_prog_test_run_opts(prog_fd, &syscall_topts);
>         ASSERT_OK(err, "bpf_prog_test_run(syscall_test)");
> +       ASSERT_EQ(syscall_topts.retval, 0, "syscall_test-retval");
>
>         prog_fd = skel->progs.kfunc_syscall_test_fail.prog_fd;
>         err = bpf_prog_test_run_opts(prog_fd, &syscall_topts);
>         ASSERT_ERR(err, "bpf_prog_test_run(syscall_test_fail)");
> +       ASSERT_EQ(syscall_topts.retval, 0, "syscall_test_fail-retval");
>
>         syscall_topts.ctx_in = NULL;
>         syscall_topts.ctx_size_in = 0;
> @@ -147,6 +150,48 @@ static void test_destructive(void)
>         cap_enable_effective(save_caps, NULL);
>  }
>
> +static void test_get_mem(void)
> +{
> +       struct kfunc_call_test *skel;
> +       int prog_fd, err;
> +       LIBBPF_OPTS(bpf_test_run_opts, topts,
> +               .data_in = &pkt_v4,
> +               .data_size_in = sizeof(pkt_v4),
> +               .repeat = 1,
> +       );
> +
> +       skel = kfunc_call_test__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "skel"))
> +               return;
> +
> +       prog_fd = bpf_program__fd(skel->progs.kfunc_call_test_get_mem);
> +       err = bpf_prog_test_run_opts(prog_fd, &topts);
> +       ASSERT_OK(err, "bpf_prog_test_run(test_get_mem)");
> +       ASSERT_EQ(topts.retval, 42, "test_get_mem-retval");
> +
> +       kfunc_call_test__destroy(skel);
> +
> +       /* start the various failing tests */
> +       skel = kfunc_call_test__open();
> +       if (!ASSERT_OK_PTR(skel, "skel"))
> +               return;
> +
> +       bpf_program__set_autoload(skel->progs.kfunc_call_test_get_mem_fail1, true);
> +       err = kfunc_call_test__load(skel);
> +       ASSERT_ERR(err, "load(kfunc_call_test_get_mem_fail1)");
> +       kfunc_call_test__destroy(skel);
> +
> +       skel = kfunc_call_test__open();
> +       if (!ASSERT_OK_PTR(skel, "skel"))
> +               return;
> +
> +       bpf_program__set_autoload(skel->progs.kfunc_call_test_get_mem_fail2, true);
> +       err = kfunc_call_test__load(skel);
> +       ASSERT_ERR(err, "load(kfunc_call_test_get_mem_fail2)");

We should match the verifier error string. See e.g. how dynptr tests
work. Also it would be better to split failure and success tests into
separate objects.

> +
> +       kfunc_call_test__destroy(skel);
> +}
> +
>  void test_kfunc_call(void)
>  {
>         if (test__start_subtest("main"))
> @@ -160,4 +205,7 @@ void test_kfunc_call(void)
>
>         if (test__start_subtest("destructive"))
>                 test_destructive();
> +
> +       if (test__start_subtest("get_mem"))
> +               test_get_mem();
>  }
> diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> index da7ae0ef9100..b4a98d17c2b6 100644
> --- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> +++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> @@ -14,6 +14,8 @@ extern void bpf_kfunc_call_test_pass1(struct prog_test_pass1 *p) __ksym;
>  extern void bpf_kfunc_call_test_pass2(struct prog_test_pass2 *p) __ksym;
>  extern void bpf_kfunc_call_test_mem_len_pass1(void *mem, int len) __ksym;
>  extern void bpf_kfunc_call_test_mem_len_fail2(__u64 *mem, int len) __ksym;
> +extern int *bpf_kfunc_call_test_get_rdwr_mem(struct prog_test_ref_kfunc *p, const int rdwr_buf_size) __ksym;
> +extern int *bpf_kfunc_call_test_get_rdonly_mem(struct prog_test_ref_kfunc *p, const int rdonly_buf_size) __ksym;
>
>  SEC("tc")
>  int kfunc_call_test2(struct __sk_buff *skb)
> @@ -128,4 +130,91 @@ int kfunc_syscall_test_fail(struct syscall_test_args *args)
>         return 0;
>  }
>
> +SEC("tc")
> +int kfunc_call_test_get_mem(struct __sk_buff *skb)
> +{
> +       struct prog_test_ref_kfunc *pt;
> +       unsigned long s = 0;
> +       int *p = NULL;
> +       int ret = 0;
> +
> +       pt = bpf_kfunc_call_test_acquire(&s);
> +       if (pt) {
> +               if (pt->a != 42 || pt->b != 108)
> +                       ret = -1;

No need to test this I think.

> +
> +               p = bpf_kfunc_call_test_get_rdwr_mem(pt, 2 * sizeof(int));
> +               if (p) {
> +                       p[0] = 42;
> +                       ret = p[1]; /* 108 */
> +               } else {
> +                       ret = -1;
> +               }
> +
> +               if (ret >= 0) {
> +                       p = bpf_kfunc_call_test_get_rdonly_mem(pt, 2 * sizeof(int));
> +                       if (p)
> +                               ret = p[0]; /* 42 */
> +                       else
> +                               ret = -1;
> +               }
> +
> +               bpf_kfunc_call_test_release(pt);
> +       }
> +       return ret;
> +}
> +
> +SEC("?tc")
> +int kfunc_call_test_get_mem_fail1(struct __sk_buff *skb)
> +{
> +       struct prog_test_ref_kfunc *pt;
> +       unsigned long s = 0;
> +       int *p = NULL;
> +       int ret = 0;
> +
> +       pt = bpf_kfunc_call_test_acquire(&s);
> +       if (pt) {
> +               if (pt->a != 42 || pt->b != 108)
> +                       ret = -1;
> +
> +               p = bpf_kfunc_call_test_get_rdonly_mem(pt, 2 * sizeof(int));
> +               if (p)
> +                       p[0] = 42; /* this is a read-only buffer, so -EACCES */
> +               else
> +                       ret = -1;
> +
> +               bpf_kfunc_call_test_release(pt);
> +       }
> +       return ret;
> +}
> +
> +SEC("?tc")
> +int kfunc_call_test_get_mem_fail2(struct __sk_buff *skb)
> +{
> +       struct prog_test_ref_kfunc *pt;
> +       unsigned long s = 0;
> +       int *p = NULL;
> +       int ret = 0;
> +
> +       pt = bpf_kfunc_call_test_acquire(&s);
> +       if (pt) {
> +               if (pt->a != 42 || pt->b != 108)
> +                       ret = -1;
> +
> +               p = bpf_kfunc_call_test_get_rdwr_mem(pt, 2 * sizeof(int));
> +               if (p) {
> +                       p[0] = 42;
> +                       ret = p[1]; /* 108 */
> +               } else {
> +                       ret = -1;
> +               }
> +
> +               bpf_kfunc_call_test_release(pt);
> +       }
> +       if (p)
> +               ret = p[0]; /* p is not valid anymore */

Great that this ref_obj_id transfer is tested. A few more small test
cases that come to mind:
. oob access to returned ptr_to_mem to ensure size is set correctly.
. failure when size is not 'const', since this is not going through
check_mem_size_reg.
. incorrect acq kfunc type inside kernel so that on use its ret type
is not struct ptr, so verifier complains about it.


> +
> +       return ret;
> +}
> +
>  char _license[] SEC("license") = "GPL";
> --
> 2.36.1
>
