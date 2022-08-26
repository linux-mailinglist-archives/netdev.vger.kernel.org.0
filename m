Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CD75A1E90
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 04:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244707AbiHZCIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 22:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244689AbiHZCIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 22:08:11 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF1ECB5CE;
        Thu, 25 Aug 2022 19:08:10 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id r141so190240iod.4;
        Thu, 25 Aug 2022 19:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=fERtzDctzEgNBIaU4dCxwXZi2ONbhFJ/oi3xF/aUGXg=;
        b=oKp7GMafkmShi+aJkF+5jK2VKKtkn7+qV8h5HcfyXNqs52MpRiHACqgb34U7tQVpos
         BZiWLHW7MIlkdWpqT8sn+zGySIZqrR1YFKeCytvv7ImQS/7GGE5S8CP6PWe1dX1LsNpn
         ID+8f5Zun2vZSdk6ud3ZT0dnlG50nl1qIKHGBXKIz9WHdE4CeDQ/Dpx+PqRanQDPHW7m
         S/wigs2P9ujolxMLYOxcLAX7FZbLfN1GdpDJcvGFeU/odJD7SsIbhvo+tVZxguDA2OHQ
         C/rSo/sjyyHdPpI0y9QbRtqh+3MCxasvD2CdLnsAhkdt59N+gNp8xG4OhVlgsOxcLaaG
         m/sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=fERtzDctzEgNBIaU4dCxwXZi2ONbhFJ/oi3xF/aUGXg=;
        b=6ForWiJhX89Ij9Zx/1zzP1YKcYkf5zlxN2j0MsJ1JstJpA99CRQVR1TcPgLmlT/xmZ
         ly7XmHBYxlBabcaTbsWfzfbmwWsvgDyHo/gMa//MfVSEXa6hYPGahJed7/RfGgbfhYfy
         qZUkdOhG7a818z1+Tp9i1kX+QR4FBFlCSDwzecTbmks+nOAzAalJZZbzznh2O5v/yvwX
         Q8r4aJwfGH7Dvp0PJb2+9zb/9MOnZbftUvIrqXN9Z/Zs1+m9zH5ZGeI2iMcaht9Q39IG
         /VXTnYVphRyaiGNZB4Wdd/h1qsGCY7NnKJQF/qWygjXBO3aJg/hR8CieBoMUysHMn9L0
         b7AQ==
X-Gm-Message-State: ACgBeo2/MWYH0yOa4YOJsiSko4Fns5PkajZA3IcdWAdhSGmyYduWy+fJ
        QuGDFM9CDqi35Cr51YyQVk1IahmI/O4XvVdJyV9SHE+L
X-Google-Smtp-Source: AA6agR4ldtT2jXu2MMdWpyUaleDmiGpun9w/4YV89ydabuMBA9T2L5GHZQgrPu70W4tTfH2ZT7eK9ZO8UDRXogqQkRY=
X-Received: by 2002:a05:6638:16cf:b0:34a:263f:966d with SMTP id
 g15-20020a05663816cf00b0034a263f966dmr497631jat.124.1661479689438; Thu, 25
 Aug 2022 19:08:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com> <20220824134055.1328882-4-benjamin.tissoires@redhat.com>
In-Reply-To: <20220824134055.1328882-4-benjamin.tissoires@redhat.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 26 Aug 2022 04:07:33 +0200
Message-ID: <CAP01T75Xs8HqDzsqJ5_69ei6ujnBXSbOg=ad7fGaei6OVNpiOg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 03/23] selftests/bpf: add test for accessing
 ctx from syscall program type
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
> We need to also export the kfunc set to the syscall program type,
> and then add a couple of eBPF programs that are testing those calls.
>
> The first one checks for valid access, and the second one is OK
> from a static analysis point of view but fails at run time because
> we are trying to access outside of the allocated memory.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> no changes in v9
>
> no changes in v8
>
> changes in v7:
> - add 1 more case to ensure we can read the entire sizeof(ctx)
> - add a test case for when the context is NULL
>
> new in v6
> ---
>  net/bpf/test_run.c                            |  1 +
>  .../selftests/bpf/prog_tests/kfunc_call.c     | 28 +++++++++++++++
>  .../selftests/bpf/progs/kfunc_call_test.c     | 36 +++++++++++++++++++
>  3 files changed, 65 insertions(+)
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 25d8ecf105aa..f16baf977a21 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -1634,6 +1634,7 @@ static int __init bpf_prog_test_run_init(void)
>
>         ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_prog_test_kfunc_set);
>         ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &bpf_prog_test_kfunc_set);
> +       ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &bpf_prog_test_kfunc_set);
>         return ret ?: register_btf_id_dtor_kfuncs(bpf_prog_test_dtor_kfunc,
>                                                   ARRAY_SIZE(bpf_prog_test_dtor_kfunc),
>                                                   THIS_MODULE);
> diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> index eede7c304f86..1edad012fe01 100644
> --- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> +++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> @@ -9,10 +9,22 @@
>
>  #include "cap_helpers.h"
>
> +struct syscall_test_args {
> +       __u8 data[16];
> +       size_t size;
> +};
> +
>  static void test_main(void)
>  {
>         struct kfunc_call_test_lskel *skel;
>         int prog_fd, err;
> +       struct syscall_test_args args = {
> +               .size = 10,
> +       };
> +       DECLARE_LIBBPF_OPTS(bpf_test_run_opts, syscall_topts,
> +               .ctx_in = &args,
> +               .ctx_size_in = sizeof(args),
> +       );
>         LIBBPF_OPTS(bpf_test_run_opts, topts,
>                 .data_in = &pkt_v4,
>                 .data_size_in = sizeof(pkt_v4),
> @@ -38,6 +50,22 @@ static void test_main(void)
>         ASSERT_OK(err, "bpf_prog_test_run(test_ref_btf_id)");
>         ASSERT_EQ(topts.retval, 0, "test_ref_btf_id-retval");
>
> +       prog_fd = skel->progs.kfunc_syscall_test.prog_fd;
> +       err = bpf_prog_test_run_opts(prog_fd, &syscall_topts);
> +       ASSERT_OK(err, "bpf_prog_test_run(syscall_test)");
> +
> +       prog_fd = skel->progs.kfunc_syscall_test_fail.prog_fd;
> +       err = bpf_prog_test_run_opts(prog_fd, &syscall_topts);
> +       ASSERT_ERR(err, "bpf_prog_test_run(syscall_test_fail)");

It would be better to assert on the verifier error string, to make
sure we continue actually testing the error we care about and not
something else.

> +
> +       syscall_topts.ctx_in = NULL;
> +       syscall_topts.ctx_size_in = 0;
> +
> +       prog_fd = skel->progs.kfunc_syscall_test_null.prog_fd;
> +       err = bpf_prog_test_run_opts(prog_fd, &syscall_topts);
> +       ASSERT_OK(err, "bpf_prog_test_run(syscall_test_null)");
> +       ASSERT_EQ(syscall_topts.retval, 0, "syscall_test_null-retval");
> +
>         kfunc_call_test_lskel__destroy(skel);
>  }
>
> diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> index 5aecbb9fdc68..da7ae0ef9100 100644
> --- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> +++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
> @@ -92,4 +92,40 @@ int kfunc_call_test_pass(struct __sk_buff *skb)
>         return 0;
>  }
>
> +struct syscall_test_args {
> +       __u8 data[16];
> +       size_t size;
> +};
> +
> +SEC("syscall")
> +int kfunc_syscall_test(struct syscall_test_args *args)
> +{
> +       const int size = args->size;
> +
> +       if (size > sizeof(args->data))
> +               return -7; /* -E2BIG */
> +
> +       bpf_kfunc_call_test_mem_len_pass1(&args->data, sizeof(args->data));
> +       bpf_kfunc_call_test_mem_len_pass1(&args->data, sizeof(*args));
> +       bpf_kfunc_call_test_mem_len_pass1(&args->data, size);
> +
> +       return 0;
> +}
> +
> +SEC("syscall")
> +int kfunc_syscall_test_null(struct syscall_test_args *args)
> +{
> +       bpf_kfunc_call_test_mem_len_pass1(args, 0);
> +

Where is it testing 'NULL'? It is testing zero_size_allowed.

> +       return 0;
> +}
> +
> +SEC("syscall")
> +int kfunc_syscall_test_fail(struct syscall_test_args *args)
> +{
> +       bpf_kfunc_call_test_mem_len_pass1(&args->data, sizeof(*args) + 1);
> +
> +       return 0;
> +}
> +
>  char _license[] SEC("license") = "GPL";
> --
> 2.36.1
>
