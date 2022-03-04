Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728D24CE0C3
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 00:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiCDXMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 18:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiCDXM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 18:12:26 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2943727B929;
        Fri,  4 Mar 2022 15:11:38 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id c23so11216271ioi.4;
        Fri, 04 Mar 2022 15:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WMYQjlufi219kBckXHrmZ59mOYrpYpcXHXQJbwGQ/Pc=;
        b=OMoGxLR4MZVjm3RcfwM0Wdf3BKqIen4nHOnAFYk0HEdPl9USyJrqWHaRSX02dZ2I21
         iy32OEKWrnA98EwaZYZYQxaX5tCpAzmVhxxz9UpZMnlogWqWovo/wkk35luKpl+gX71I
         cAB0EOLwJqyOgGXFqARIIsDqGh9LdZBQjC8RN5Chg6mQjY/ubqb99hDjd9E0uJYjCIr8
         hdNzJ/0OavB8NnENeP0ZP7OL4ILiSubLNzSaZgbL8KhZ6/yEEg6NvANLzDOWSYxA+b+O
         2coGuqGpGO/Is6kAElHhw8tpcVTSkcItxiww7OsONLFQCcT1qAmHVmPmQVQpNlCOdgK5
         FNyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WMYQjlufi219kBckXHrmZ59mOYrpYpcXHXQJbwGQ/Pc=;
        b=G6EMpwYO7sMghmUuG5ESkrmdSqbOpp5N46xOpsVRMBo3iH9vZ5wt9esiJINimRS385
         mUMXHdI3uxASq89OLl9VX9rcIBsZXhpp2n8RGBsWmxKtuzhJaWHURNCtgodjR6M4jmAv
         27mvER/tEx/2dwUBCQ65qDj8SOBl2CFhx7n/9JlYdVPkJ4DagT4lK+WSLRAOkbrcguFo
         a5x596Y/Ud9ed2nJi+xVO66Ty/1uY0fgkoZdzL9ltnZXuebHxqh/Jnpj/rQml4Vh+mKn
         rTTQDKQory0b2AfuJVIXWKE1WwC0H5ayJj9KJlEL+g2LYDkSBCoHhu2KmuuPh2LznfYn
         iR6w==
X-Gm-Message-State: AOAM530b16bgCHFSW0sNIisitfKs1oz1ud4uoSeYS4K+ogF8UB2e2TS+
        M338rHgxWJ0CbjBp8J5chysikpJ3hUZUTxI9nIwLx8TcBUg=
X-Google-Smtp-Source: ABdhPJy8YiUtVDrIHUNcSSBJVOoBbqJYOSDBqdCWj9X7n5pS3Y2c7UBPg7D9k6N2Oqgi4iqfXEO9XtqTvM23iOeGSm0=
X-Received: by 2002:a6b:e901:0:b0:640:7bf8:f61d with SMTP id
 u1-20020a6be901000000b006407bf8f61dmr754404iof.112.1646435497530; Fri, 04 Mar
 2022 15:11:37 -0800 (PST)
MIME-Version: 1.0
References: <20220222170600.611515-1-jolsa@kernel.org> <20220222170600.611515-11-jolsa@kernel.org>
In-Reply-To: <20220222170600.611515-11-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Mar 2022 15:11:26 -0800
Message-ID: <CAEf4BzZW-W5PcNmB2PoRE-70e1FjqpE-EJKgxfj2SsvjwdBjRA@mail.gmail.com>
Subject: Re: [PATCH 10/10] selftest/bpf: Add kprobe_multi test for bpf_cookie values
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
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

On Tue, Feb 22, 2022 at 9:08 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding bpf_cookie test for programs attached by kprobe_multi links.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/bpf_cookie.c     | 72 +++++++++++++++++++
>  .../bpf/progs/kprobe_multi_bpf_cookie.c       | 62 ++++++++++++++++
>  2 files changed, 134 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_bpf_cookie.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> index cd10df6cd0fc..edfb9f8736c6 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> @@ -7,6 +7,7 @@
>  #include <unistd.h>
>  #include <test_progs.h>
>  #include "test_bpf_cookie.skel.h"
> +#include "kprobe_multi_bpf_cookie.skel.h"
>
>  /* uprobe attach point */
>  static void trigger_func(void)
> @@ -63,6 +64,75 @@ static void kprobe_subtest(struct test_bpf_cookie *skel)
>         bpf_link__destroy(retlink2);
>  }
>
> +static void kprobe_multi_subtest(void)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> +       int err, prog_fd, link1_fd = -1, link2_fd = -1;
> +       LIBBPF_OPTS(bpf_test_run_opts, topts);

consistency ftw, LIBBPF_OPTS


> +       struct kprobe_multi_bpf_cookie *skel = NULL;
> +       __u64 addrs[8], cookies[8];
> +

[..]

> diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi_bpf_cookie.c b/tools/testing/selftests/bpf/progs/kprobe_multi_bpf_cookie.c
> new file mode 100644
> index 000000000000..d6f8454ba093
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/kprobe_multi_bpf_cookie.c
> @@ -0,0 +1,62 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +extern const void bpf_fentry_test1 __ksym;
> +extern const void bpf_fentry_test2 __ksym;
> +extern const void bpf_fentry_test3 __ksym;
> +extern const void bpf_fentry_test4 __ksym;
> +extern const void bpf_fentry_test5 __ksym;
> +extern const void bpf_fentry_test6 __ksym;
> +extern const void bpf_fentry_test7 __ksym;
> +extern const void bpf_fentry_test8 __ksym;
> +
> +/* No tests, just to trigger bpf_fentry_test* through tracing test_run */
> +SEC("fentry/bpf_modify_return_test")
> +int BPF_PROG(test1)
> +{
> +       return 0;
> +}
> +
> +__u64 test2_result = 0;
> +
> +SEC("kprobe.multi/bpf_fentry_tes??")
> +int test2(struct pt_regs *ctx)
> +{
> +       __u64 cookie = bpf_get_attach_cookie(ctx);
> +       __u64 addr = bpf_get_func_ip(ctx);
> +
> +       test2_result += (const void *) addr == &bpf_fentry_test1 && cookie == 1;
> +       test2_result += (const void *) addr == &bpf_fentry_test2 && cookie == 2;
> +       test2_result += (const void *) addr == &bpf_fentry_test3 && cookie == 3;
> +       test2_result += (const void *) addr == &bpf_fentry_test4 && cookie == 4;
> +       test2_result += (const void *) addr == &bpf_fentry_test5 && cookie == 5;
> +       test2_result += (const void *) addr == &bpf_fentry_test6 && cookie == 6;
> +       test2_result += (const void *) addr == &bpf_fentry_test7 && cookie == 7;
> +       test2_result += (const void *) addr == &bpf_fentry_test8 && cookie == 8;

this is not parallel mode friendly

let's filter by pid, but also it's best to do count locally and just
assign it (so that multiple calls of the program still produce the
same value, instead of constantly increasing global variable with each
run)


> +
> +       return 0;
> +}
> +
> +__u64 test3_result = 0;
> +
> +SEC("kretprobe.multi/bpf_fentry_test*")
> +int test3(struct pt_regs *ctx)
> +{
> +       __u64 cookie = bpf_get_attach_cookie(ctx);
> +       __u64 addr = bpf_get_func_ip(ctx);
> +
> +       test3_result += (const void *) addr == &bpf_fentry_test1 && cookie == 8;
> +       test3_result += (const void *) addr == &bpf_fentry_test2 && cookie == 7;
> +       test3_result += (const void *) addr == &bpf_fentry_test3 && cookie == 6;
> +       test3_result += (const void *) addr == &bpf_fentry_test4 && cookie == 5;
> +       test3_result += (const void *) addr == &bpf_fentry_test5 && cookie == 4;
> +       test3_result += (const void *) addr == &bpf_fentry_test6 && cookie == 3;
> +       test3_result += (const void *) addr == &bpf_fentry_test7 && cookie == 2;
> +       test3_result += (const void *) addr == &bpf_fentry_test8 && cookie == 1;
> +
> +       return 0;
> +}
> --
> 2.35.1
>
