Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440324CE0B5
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 00:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiCDXMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 18:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiCDXMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 18:12:24 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E241427B910;
        Fri,  4 Mar 2022 15:11:34 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id d62so11086589iog.13;
        Fri, 04 Mar 2022 15:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1gzqM+fI8L57ITd1AkQS2sQnxRxWLhMOjue8gj0QwBk=;
        b=XzsSls8oRVEG8aj5sG+FF+YVI5/j/VzcgZINA5RRFPCtVeqt4MejlWe8K+hLZU14TW
         2SlKlbmnm2WYXn7zJkgULe4VjzHuNJDLPYmz1GbSg99Dlvp/XJz3dCiquVABzZj1OXNr
         eGS1kBH1GNX7+sCwb+Bo+vI8zljaNEbcrGMg2t0+PoxCoT33mvSIF9Hwyd5tHk1fpPIl
         VMhs7lTMlB2q6ZEh7ikUpxU0KReomvRjbv4WHrpwxlst4LnxDToDMyGVT1jfpJI55p9G
         117iDhkrRDCWxYxlglSo2AiOYmXzw51IkQwV5NQ8yNEsiKGxh4yUGz9IGKQyJDDAY9Yx
         1zSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1gzqM+fI8L57ITd1AkQS2sQnxRxWLhMOjue8gj0QwBk=;
        b=bgjaU9sYlC9iwjqXzvfocgw02p/yTM6nJy+pVKblHKfz2MFDpsN8sAJ6FHouyE5aUZ
         bqwzk9eGxlXr4Ncwa/36Kqj5vbUaIui4KB1SAef2p0l1ZbdzhMqBU3HLFbwSJJJc/vag
         T7KJ/RyJhlILt7ysOjsu8s0dFAHQqZ2NGVJtDGlPCIygDlqeb63Qe8x1djZjvuQQJ9V5
         qD3ZmTkjZjA9PKqA3AFBRYp4ZQ9RGpojhv/I4Id5o/0CGT8F4RZFnq7YNgSA2vi2hnGp
         LQH7arv5ER7+ERE/Hv+ABYQr1BPh5LS+VyER263HrM2+HMeBYN1ImQO6HTnn0K8vNA5C
         b30g==
X-Gm-Message-State: AOAM530K3viDKeUeqFUHfT9bbc7tIfOEV4irGYzO893uHwijrI7PjVO2
        ez+5VuKZvxwtr20YQDfoPPpiqJ1ZKRXIjt6utI8=
X-Google-Smtp-Source: ABdhPJydnf0WSpatYMMouwDrjxxxT95bQIsWqB7R4Dd3PlUe4UmH9w0ofUg05YR/rqnn3I6iI7eMF485cVV1Cb6i2bo=
X-Received: by 2002:a05:6602:1605:b0:644:d491:1bec with SMTP id
 x5-20020a056602160500b00644d4911becmr730013iow.63.1646435494276; Fri, 04 Mar
 2022 15:11:34 -0800 (PST)
MIME-Version: 1.0
References: <20220222170600.611515-1-jolsa@kernel.org> <20220222170600.611515-10-jolsa@kernel.org>
In-Reply-To: <20220222170600.611515-10-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Mar 2022 15:11:23 -0800
Message-ID: <CAEf4BzZ+6SN4BRFKEBePqyjB2-Xw49tKa3rpmxt8-qDwONXC8w@mail.gmail.com>
Subject: Re: [PATCH 09/10] selftest/bpf: Add kprobe_multi attach test
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
> Adding kprobe_multi attach test that uses new fprobe interface to
> attach kprobe program to multiple functions.
>
> The test is attaching programs to bpf_fentry_test* functions and
> uses single trampoline program bpf_prog_test_run to trigger
> bpf_fentry_test* functions.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

subj typo: selftest -> selftests

>  .../bpf/prog_tests/kprobe_multi_test.c        | 115 ++++++++++++++++++
>  .../selftests/bpf/progs/kprobe_multi.c        |  58 +++++++++
>  2 files changed, 173 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
>  create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi.c
>

[...]

> +
> +static void test_link_api_addrs(void)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> +       __u64 addrs[8];
> +
> +       kallsyms_find("bpf_fentry_test1", &addrs[0]);
> +       kallsyms_find("bpf_fentry_test2", &addrs[1]);
> +       kallsyms_find("bpf_fentry_test3", &addrs[2]);
> +       kallsyms_find("bpf_fentry_test4", &addrs[3]);
> +       kallsyms_find("bpf_fentry_test5", &addrs[4]);
> +       kallsyms_find("bpf_fentry_test6",  &addrs[5]);
> +       kallsyms_find("bpf_fentry_test7", &addrs[6]);
> +       kallsyms_find("bpf_fentry_test8", &addrs[7]);

ASSERT_OK() that symbols are found? It also sucks that we re-parse
kallsyms so much...

maybe use load_kallsyms() to pre-cache? We should also teach
load_kallsyms() to not reload kallsyms more than once

> +
> +       opts.kprobe_multi.addrs = (__u64) addrs;
> +       opts.kprobe_multi.cnt = 8;

ARRAY_SIZE()?

> +       test_link_api(&opts);
> +}
> +
> +static void test_link_api_syms(void)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);

nit: just LIBBPF_OPTS

> +       const char *syms[8] = {
> +               "bpf_fentry_test1",
> +               "bpf_fentry_test2",
> +               "bpf_fentry_test3",
> +               "bpf_fentry_test4",
> +               "bpf_fentry_test5",
> +               "bpf_fentry_test6",
> +               "bpf_fentry_test7",
> +               "bpf_fentry_test8",
> +       };
> +
> +       opts.kprobe_multi.syms = (__u64) syms;
> +       opts.kprobe_multi.cnt = 8;

ARRAY_SIZE() ?

> +       test_link_api(&opts);
> +}
> +
> +void test_kprobe_multi_test(void)
> +{
> +       test_skel_api();
> +       test_link_api_syms();
> +       test_link_api_addrs();

model as subtests?


> +}
> diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi.c b/tools/testing/selftests/bpf/progs/kprobe_multi.c
> new file mode 100644
> index 000000000000..71318c65931c
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/kprobe_multi.c
> @@ -0,0 +1,58 @@
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
> +SEC("kprobe.multi/bpf_fentry_test?")
> +int test2(struct pt_regs *ctx)
> +{
> +       __u64 addr = bpf_get_func_ip(ctx);
> +
> +       test2_result += (const void *) addr == &bpf_fentry_test1 ||
> +                       (const void *) addr == &bpf_fentry_test2 ||
> +                       (const void *) addr == &bpf_fentry_test3 ||
> +                       (const void *) addr == &bpf_fentry_test4 ||
> +                       (const void *) addr == &bpf_fentry_test5 ||
> +                       (const void *) addr == &bpf_fentry_test6 ||
> +                       (const void *) addr == &bpf_fentry_test7 ||
> +                       (const void *) addr == &bpf_fentry_test8;
> +       return 0;
> +}
> +
> +__u64 test3_result = 0;
> +
> +SEC("kretprobe.multi/bpf_fentry_test*")
> +int test3(struct pt_regs *ctx)
> +{
> +       __u64 addr = bpf_get_func_ip(ctx);
> +
> +       test3_result += (const void *) addr == &bpf_fentry_test1 ||
> +                       (const void *) addr == &bpf_fentry_test2 ||
> +                       (const void *) addr == &bpf_fentry_test3 ||
> +                       (const void *) addr == &bpf_fentry_test4 ||
> +                       (const void *) addr == &bpf_fentry_test5 ||
> +                       (const void *) addr == &bpf_fentry_test6 ||
> +                       (const void *) addr == &bpf_fentry_test7 ||
> +                       (const void *) addr == &bpf_fentry_test8;
> +       return 0;
> +}
> --
> 2.35.1
>
