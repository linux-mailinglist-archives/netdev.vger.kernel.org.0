Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0995ADDF0
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 05:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237228AbiIFDZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 23:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbiIFDZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 23:25:53 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921E93FA21;
        Mon,  5 Sep 2022 20:25:51 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id p187so7950401iod.8;
        Mon, 05 Sep 2022 20:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=iKR/yW56j50b1EcL3EzHzwbMOKwCegyIlsHLHbCh6hs=;
        b=Ld6VntwA3f7JZWbh+p4iNwPWOgJ0nYZVTFic4wsZcRDbFDYESNvQEnxL94FJz5TmTb
         Uhl2V/sj2erbx1fR34euMt1ZKxCasw8mJgpYXLUYFhdaVy3TfxhzzVNvb00v4gZycLgs
         IbXI1duj9HXkOpb7Lj0cLu72admUNGgx0rbW3w4iE10InyDuYp4YOZ/DtDEylHXMunkf
         NUhl5+Dw4q7a/SJCBWO0qgc3hWX7I/S8ODRRaAtbHYv0wLeQ2iyg1vBmZ5KfxU+uQpBQ
         yNLgmdZUZXftVV8AwmKS73KO6O8uQdz3J2pTQ/EMayuVOz8D6H+Cqjhdur73wF4Z9h41
         Nsgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=iKR/yW56j50b1EcL3EzHzwbMOKwCegyIlsHLHbCh6hs=;
        b=WitMjPVKrdD1voPnIYpIRFnzZgmHvZWPKCtMiTRoV7OhVw5JAKCykx9/l1QldG6SFV
         +cgR88QztzLBUt2r97FdH6kYaFBzoOFI+uEDPqQfFciSt4Auw1G7vK9//Xz63KzYEMd+
         /rdoexe2WCqmToB9djWwRwYkIDPDo9e4dgX6Nlky3ml63jYg97AwRAfDNpDzpuwj+T+s
         PHwwv4UWWNWf6ySaeAG8Qsj56rkr/duM5Qg/laPrRTV9uT9quCOv6LV5VuqFgFOBcPX9
         6kwdc/dt6rnKkwXajYC9OXVpSzkcIXfgAgzZ4wyToWwdzSf4+HVZBJ1Q29Wr5yu93dNE
         gBjg==
X-Gm-Message-State: ACgBeo028LIga90Q1uj5l+LvGcAKaqQf84J/25otDyzw1wuqjUNBdzKu
        /VzYio/6bQ3NhdUktav9GmTOWyTJ0dWHmBMT940=
X-Google-Smtp-Source: AA6agR6JtNTwijCAbGTjg6V5OCvJLefNSzHEWL7bYm+x4vG2crnAVtACsKmbemfujAazaocMd6x9RIZnV9qn/PFuI3A=
X-Received: by 2002:a05:6638:2388:b0:34a:e033:396b with SMTP id
 q8-20020a056638238800b0034ae033396bmr15562574jat.93.1662434750943; Mon, 05
 Sep 2022 20:25:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220902132938.2409206-1-benjamin.tissoires@redhat.com> <20220902132938.2409206-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20220902132938.2409206-2-benjamin.tissoires@redhat.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Tue, 6 Sep 2022 05:25:14 +0200
Message-ID: <CAP01T75KTjawtsvQmhZhj0=tEJVwc7UewRqdT1ui+uKONg07Zw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v10 01/23] selftests/bpf: regroup and declare
 similar kfuncs selftests in an array
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

On Fri, 2 Sept 2022 at 15:29, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Similar to tools/testing/selftests/bpf/prog_tests/dynptr.c:
> we declare an array of tests that we run one by one in a for loop.
>
> Followup patches will add more similar-ish tests, so avoid a lot of copy
> paste by grouping the declaration in an array.
>
> To be able to call bpf_object__find_program_by_name(), we need to use
> plain libbpf calls, and not light skeletons. So also change the Makefile
> to not generate light skeletons.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---

I see your point, but this is also a test so that we keep verifying
kfunc call in light skeleton.
Code for relocating both is different in libbpf (we generate BPF ASM
for light skeleton so it is done inside a loader BPF program instead
of userspace).
You might then be able to make it work for both light and normal skeleton.

>
> new in v10
> ---
>  tools/testing/selftests/bpf/Makefile          |  2 +-
>  .../selftests/bpf/prog_tests/kfunc_call.c     | 56 +++++++++++++------
>  2 files changed, 39 insertions(+), 19 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index eecad99f1735..b19b0b35aec8 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -351,7 +351,7 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h               \
>                 test_subskeleton.skel.h test_subskeleton_lib.skel.h     \
>                 test_usdt.skel.h
>
> -LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
> +LSKELS := fentry_test.c fexit_test.c fexit_sleep.c \
>         test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c \
>         map_ptr_kern.c core_kern.c core_kern_overflow.c
>  # Generate both light skeleton and libbpf skeleton for these
> diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> index eede7c304f86..21e347f46c93 100644
> --- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> +++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> @@ -2,16 +2,28 @@
>  /* Copyright (c) 2021 Facebook */
>  #include <test_progs.h>
>  #include <network_helpers.h>
> -#include "kfunc_call_test.lskel.h"
> +#include "kfunc_call_test.skel.h"
>  #include "kfunc_call_test_subprog.skel.h"
>  #include "kfunc_call_test_subprog.lskel.h"
>  #include "kfunc_call_destructive.skel.h"
>
>  #include "cap_helpers.h"
>
> -static void test_main(void)
> +struct kfunc_test_params {
> +       const char *prog_name;
> +       int retval;
> +};
> +
> +static struct kfunc_test_params kfunc_tests[] = {
> +       {"kfunc_call_test1", 12},
> +       {"kfunc_call_test2", 3},
> +       {"kfunc_call_test_ref_btf_id", 0},
> +};
> +
> +static void verify_success(struct kfunc_test_params *param)
>  {
> -       struct kfunc_call_test_lskel *skel;
> +       struct kfunc_call_test *skel;
> +       struct bpf_program *prog;
>         int prog_fd, err;
>         LIBBPF_OPTS(bpf_test_run_opts, topts,
>                 .data_in = &pkt_v4,
> @@ -19,26 +31,35 @@ static void test_main(void)
>                 .repeat = 1,
>         );
>
> -       skel = kfunc_call_test_lskel__open_and_load();
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
>
> -       prog_fd = skel->progs.kfunc_call_test_ref_btf_id.prog_fd;
> -       err = bpf_prog_test_run_opts(prog_fd, &topts);
> -       ASSERT_OK(err, "bpf_prog_test_run(test_ref_btf_id)");
> -       ASSERT_EQ(topts.retval, 0, "test_ref_btf_id-retval");
> +       ASSERT_EQ(topts.retval, param->retval, "retval");
> +
> +cleanup:
> +       kfunc_call_test__destroy(skel);
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
> @@ -121,8 +142,7 @@ static void test_destructive(void)
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
