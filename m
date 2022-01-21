Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD8A4965D1
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 20:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiAUTk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 14:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiAUTkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 14:40:25 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D0CC06173B;
        Fri, 21 Jan 2022 11:40:25 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id a18so8520934ilq.6;
        Fri, 21 Jan 2022 11:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PP2AoAwYzPkh8RnwvN79ZEEJxwHSwD91bg7VRyYckFU=;
        b=mF2ZGlxSWpvvEZEs7uOz9WVNT558Y9jYAD8R/FSw91tSATrDGP+IsDvqoqchf35BgK
         rFVnWh00ne+LjOOUupj7ApcVPp93BEkmgv/7CFMe3ms+8qKJgJ8j5qkZtUMM+rxSoArO
         191gjc/ET1rYFqlCPFZ63QJnMhb2M8rv4e+FS3cQkJuMX9wCbv8YB2rJfXxwapODAWrv
         ryO461ZlATvvNqbItb/HZTMmUmJ8QqJCY6tQ+JzfURjaGzXDB8ZzMFCRkOZ9xanQ+niU
         9zDTk9HcaSQcNV+AQ10Gku9tzOkyblebOlJzjXuD+w5rVNRcmls+Q+F4XSOq2d0K7o9D
         RIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PP2AoAwYzPkh8RnwvN79ZEEJxwHSwD91bg7VRyYckFU=;
        b=nFxcCN9INkhxHahMDuadg3+ve4a2YK1jNGQpFtF/5J5mm6cTl3tZs1lbtOV8TGG0Rv
         MAXhChRdbIluCeEp+OsRzeD7iUl5/mQjykvbsVnQ9oriX0wsGihvqGOwsnJhxj2wMBDL
         slwTWAHMgznyMyMqcej2KRRNYRZ2EbX9m/XbqL+z0cf6tFh9MviD8dR3a680orQbxsz2
         d/wtvan06+4wdKhgWjYLVw954QLU1MP+huPq7Ti7q4+J+TTshVe3EA3Z5mzsbSFnoxEK
         yni3zGIBOk0uVIon+ebsUcTpvlOnS6txX3sIX5/2fTEEkfz0sUrDGNF53NQoWuZ0mE4Q
         4X/A==
X-Gm-Message-State: AOAM532Z58rV1cNkmYoC/NXo4QJBeujWyqohOnwbZXUs0PxgO1tJyg+5
        wF66Ntbo0upzV1o20gUlOxmFiq+Mp1n1cjN1bGk=
X-Google-Smtp-Source: ABdhPJyRKp0nU5lr9fXawCcJyIARpvrq6Kgc7Jupq60jCRxckq3orAAfkSzmWCWXglaIu+kDi1lb36T92tkmj+3ZapA=
X-Received: by 2002:a05:6e02:190e:: with SMTP id w14mr2320757ilu.71.1642794024712;
 Fri, 21 Jan 2022 11:40:24 -0800 (PST)
MIME-Version: 1.0
References: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com> <1642678950-19584-4-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1642678950-19584-4-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Jan 2022 11:40:13 -0800
Message-ID: <CAEf4BzY+VfOO6ykj5G1km3k2JfAbFVGynzmSkhjbUJyb-NKFdw@mail.gmail.com>
Subject: Re: [RFC bpf-next 3/3] selftests/bpf: add tests for u[ret]probe
 attach by name
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 3:43 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> add tests that verify attaching by name for local functions in
> a program and library functions in a shared object succeed for
> uprobe and uretprobes using new "func_name" option for
> bpf_program__attach_uprobe_opts().  Also verify auto-attach
> works where uprobe, path to binary and function name are
> specified.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  .../selftests/bpf/prog_tests/attach_probe.c        | 114 ++++++++++++++++++---
>  .../selftests/bpf/progs/test_attach_probe.c        |  33 ++++++
>  2 files changed, 130 insertions(+), 17 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> index d0bd51e..1bfb09e 100644
> --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> @@ -10,16 +10,24 @@ static void method(void) {
>         return ;
>  }
>
> +/* attach point for byname uprobe */
> +static void method2(void)
> +{
> +}
> +
>  void test_attach_probe(void)
>  {
>         DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, uprobe_opts);
>         int duration = 0;
>         struct bpf_link *kprobe_link, *kretprobe_link;
> -       struct bpf_link *uprobe_link, *uretprobe_link;
> +       struct bpf_link *uprobe_link[3], *uretprobe_link[3];

why do you need an array, uprobe_link and uretprobe_link are just
temporary variables for shorter code, those links are assigned into
skel->links section and taken care of by skeleton destroy method

>         struct test_attach_probe* skel;
>         size_t uprobe_offset;
>         ssize_t base_addr, ref_ctr_offset;
> +       char libc_path[256];
>         bool legacy;
> +       char *mem;
> +       FILE *f;
>
>         /* Check if new-style kprobe/uprobe API is supported.
>          * Kernels that support new FD-based kprobe and uprobe BPF attachment
> @@ -69,14 +77,14 @@ void test_attach_probe(void)
>
>         uprobe_opts.retprobe = false;
>         uprobe_opts.ref_ctr_offset = legacy ? 0 : ref_ctr_offset;
> -       uprobe_link = bpf_program__attach_uprobe_opts(skel->progs.handle_uprobe,
> -                                                     0 /* self pid */,
> -                                                     "/proc/self/exe",
> -                                                     uprobe_offset,
> -                                                     &uprobe_opts);
> -       if (!ASSERT_OK_PTR(uprobe_link, "attach_uprobe"))
> +       uprobe_link[0] = bpf_program__attach_uprobe_opts(skel->progs.handle_uprobe,
> +                                                        0 /* self pid */,
> +                                                        "/proc/self/exe",
> +                                                        uprobe_offset,
> +                                                        &uprobe_opts);
> +       if (!ASSERT_OK_PTR(uprobe_link[0], "attach_uprobe"))
>                 goto cleanup;
> -       skel->links.handle_uprobe = uprobe_link;
> +       skel->links.handle_uprobe = uprobe_link[0];
>
>         if (!legacy)
>                 ASSERT_GT(uprobe_ref_ctr, 0, "uprobe_ref_ctr_after");
> @@ -84,17 +92,79 @@ void test_attach_probe(void)
>         /* if uprobe uses ref_ctr, uretprobe has to use ref_ctr as well */
>         uprobe_opts.retprobe = true;
>         uprobe_opts.ref_ctr_offset = legacy ? 0 : ref_ctr_offset;
> -       uretprobe_link = bpf_program__attach_uprobe_opts(skel->progs.handle_uretprobe,
> -                                                        -1 /* any pid */,
> +       uretprobe_link[0] = bpf_program__attach_uprobe_opts(skel->progs.handle_uretprobe,
> +                                                           -1 /* any pid */,
> +                                                           "/proc/self/exe",
> +                                                           uprobe_offset, &uprobe_opts);
> +       if (!ASSERT_OK_PTR(uretprobe_link[0], "attach_uretprobe"))
> +               goto cleanup;
> +       skel->links.handle_uretprobe = uretprobe_link[0];
> +
> +       uprobe_opts.func_name = "method2";
> +       uprobe_opts.retprobe = false;
> +       uprobe_opts.ref_ctr_offset = 0;
> +       uprobe_link[1] = bpf_program__attach_uprobe_opts(skel->progs.handle_uprobe_byname,
> +                                                        0 /* this pid */,
>                                                          "/proc/self/exe",
> -                                                        uprobe_offset, &uprobe_opts);
> -       if (!ASSERT_OK_PTR(uretprobe_link, "attach_uretprobe"))
> +                                                        0, &uprobe_opts);
> +       if (!ASSERT_OK_PTR(uprobe_link[1], "attach_uprobe_byname"))
> +               goto cleanup;
> +       skel->links.handle_uprobe_byname = uprobe_link[1];
> +
> +       /* verify auto-attach works */
> +       uretprobe_link[1] = bpf_program__attach(skel->progs.handle_uretprobe_byname);
> +       if (!ASSERT_OK_PTR(uretprobe_link[1], "attach_uretprobe_byname"))
> +               goto cleanup;
> +       skel->links.handle_uretprobe_byname = uretprobe_link[1];
> +
> +       /* test attach by name for a library function, using the library
> +        * as the binary argument.  To do this, find path to libc used
> +        * by test_progs via /proc/self/maps.
> +        */
> +       f = fopen("/proc/self/maps", "r");
> +       if (!ASSERT_OK_PTR(f, "read /proc/self/maps"))
> +               goto cleanup;
> +       while (fscanf(f, "%*s %*s %*s %*s %*s %[^\n]", libc_path) == 1) {
> +               if (strstr(libc_path, "libc-"))
> +                       break;
> +       }
> +       fclose(f);
> +       if (!ASSERT_NEQ(strstr(libc_path, "libc-"), NULL, "find libc path in /proc/self/maps"))
> +               goto cleanup;

maybe let's extract this into a small helper, we'll eventually
probably use it for other tests (and it just makes it a bit more
obvious what's going on)

> +
> +       uprobe_opts.func_name = "malloc";
> +       uprobe_opts.retprobe = false;
> +       uprobe_link[2] = bpf_program__attach_uprobe_opts(skel->progs.handle_uprobe_byname2,
> +                                                         0 /* this pid */,
> +                                                         libc_path,
> +                                                         0, &uprobe_opts);
> +       if (!ASSERT_OK_PTR(uprobe_link[2], "attach_uprobe_byname2"))
>                 goto cleanup;
> -       skel->links.handle_uretprobe = uretprobe_link;
> +       skel->links.handle_uprobe_byname2 = uprobe_link[2];
>
> -       /* trigger & validate kprobe && kretprobe */
> +       uprobe_opts.func_name = "free";
> +       uprobe_opts.retprobe = true;
> +       uretprobe_link[2] = bpf_program__attach_uprobe_opts(skel->progs.handle_uretprobe_byname2,
> +                                                           -1 /* any pid */,
> +                                                           libc_path,
> +                                                           0, &uprobe_opts);
> +       if (!ASSERT_OK_PTR(uretprobe_link[2], "attach_uretprobe_byname2"))
> +               goto cleanup;
> +       skel->links.handle_uretprobe_byname2 = uretprobe_link[2];
> +
> +       /* trigger & validate kprobe && kretprobe && uretprobe by name */
>         usleep(1);
>
> +       /* trigger & validate shared library u[ret]probes attached by name */
> +       mem = malloc(1);
> +       free(mem);
> +
> +       /* trigger & validate uprobe & uretprobe */
> +       method();
> +
> +       /* trigger & validate uprobe attached by name */
> +       method2();
> +
>         if (CHECK(skel->bss->kprobe_res != 1, "check_kprobe_res",
>                   "wrong kprobe res: %d\n", skel->bss->kprobe_res))
>                 goto cleanup;
> @@ -102,9 +172,6 @@ void test_attach_probe(void)
>                   "wrong kretprobe res: %d\n", skel->bss->kretprobe_res))
>                 goto cleanup;
>
> -       /* trigger & validate uprobe & uretprobe */
> -       method();
> -
>         if (CHECK(skel->bss->uprobe_res != 3, "check_uprobe_res",
>                   "wrong uprobe res: %d\n", skel->bss->uprobe_res))
>                 goto cleanup;
> @@ -112,6 +179,19 @@ void test_attach_probe(void)
>                   "wrong uretprobe res: %d\n", skel->bss->uretprobe_res))
>                 goto cleanup;
>
> +       if (CHECK(skel->bss->uprobe_byname_res != 5, "check_uprobe_byname_res",
> +                 "wrong uprobe byname res: %d\n", skel->bss->uprobe_byname_res))
> +               goto cleanup;
> +       if (CHECK(skel->bss->uretprobe_byname_res != 6, "check_uretprobe_byname_res",
> +                 "wrong uretprobe byname res: %d\n", skel->bss->uretprobe_byname_res))
> +               goto cleanup;
> +       if (CHECK(skel->bss->uprobe_byname2_res != 7, "check_uprobe_byname2_res",
> +                 "wrong uprobe byname2 res: %d\n", skel->bss->uprobe_byname2_res))
> +               goto cleanup;
> +       if (CHECK(skel->bss->uretprobe_byname2_res != 8, "check_uretprobe_byname2_res",
> +                 "wrong uretprobe byname2 res: %d\n", skel->bss->uretprobe_byname2_res))
> +               goto cleanup;

use ASSERT_xxx() instead of CHECK() for new tests

> +
>  cleanup:
>         test_attach_probe__destroy(skel);
>         ASSERT_EQ(uprobe_ref_ctr, 0, "uprobe_ref_ctr_cleanup");
> diff --git a/tools/testing/selftests/bpf/progs/test_attach_probe.c b/tools/testing/selftests/bpf/progs/test_attach_probe.c
> index 8056a4c..c176c89 100644
> --- a/tools/testing/selftests/bpf/progs/test_attach_probe.c
> +++ b/tools/testing/selftests/bpf/progs/test_attach_probe.c
> @@ -10,6 +10,10 @@
>  int kretprobe_res = 0;
>  int uprobe_res = 0;
>  int uretprobe_res = 0;
> +int uprobe_byname_res = 0;
> +int uretprobe_byname_res = 0;
> +int uprobe_byname2_res = 0;
> +int uretprobe_byname2_res = 0;
>
>  SEC("kprobe/sys_nanosleep")
>  int handle_kprobe(struct pt_regs *ctx)
> @@ -39,4 +43,33 @@ int handle_uretprobe(struct pt_regs *ctx)
>         return 0;
>  }
>
> +SEC("uprobe/trigger_func_byname")

this should be just SEC("uprobe") ?

> +int handle_uprobe_byname(struct pt_regs *ctx)
> +{
> +       uprobe_byname_res = 5;
> +       return 0;
> +}
> +
> +/* use auto-attach format for section definition. */
> +SEC("uretprobe/proc/self/exe/method2")
> +int handle_uretprobe_byname(struct pt_regs *ctx)
> +{
> +       uretprobe_byname_res = 6;
> +       return 0;
> +}
> +
> +SEC("uprobe/trigger_func_byname2")
> +int handle_uprobe_byname2(struct pt_regs *ctx)
> +{
> +       uprobe_byname2_res = 7;
> +       return 0;
> +}
> +
> +SEC("uretprobe/trigger_func_byname2")

same here and above, SEC("uprobe") if you don't specify binary + func.

We should tighten this up for other SEC_DEF()s as well, but that's
separate change from yours.

> +int handle_uretprobe_byname2(struct pt_regs *ctx)
> +{
> +       uretprobe_byname2_res = 8;
> +       return 0;
> +}
> +
>  char _license[] SEC("license") = "GPL";
> --
> 1.8.3.1
>
