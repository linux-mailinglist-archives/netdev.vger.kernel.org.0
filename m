Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15FD84FC77B
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 00:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241387AbiDKWS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 18:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347793AbiDKWSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 18:18:13 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4B01C904;
        Mon, 11 Apr 2022 15:15:51 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id y16so12432203ilc.7;
        Mon, 11 Apr 2022 15:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pah6dFtB/Pcvu2zEarTnB8ifwqo0zAZEes1j6yd9fhk=;
        b=JiKEWMYkgn3YjUMQx4zQiB6kahNGD0Gk33yc9QezXtWNdkNYTcQi5wgf9FpUMGs537
         0eFlYsSaqgYKDtqcM/vqzuBoHYx1DWzFzWOB4h6Bsztbb8jzaYTaLmlcqPDGcvsNyTlr
         ZvtasycqGjeTF4Kaer0KecO6GO1aZ/pPt7V8Hl/6+1GdfxdKfU9UPih0qLYqv5yVJptW
         DyQf6CIKP7tv7WGBD6MZ0BD/+14bFTL5Gi1t3iJZwynw+8FO86jl1rTvFeIaLOBQMG5c
         I1b8eqqxr+yMdJahqCAUA8tLQykm3fwUT7+N3+c35IrrxiI/pgRhX24W9JSeRs+eHkLo
         Tfxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pah6dFtB/Pcvu2zEarTnB8ifwqo0zAZEes1j6yd9fhk=;
        b=CGBMp/ymp0m+7vXSGw0zN40EEm291UA9Mjj9+FRq+gMTY5JzrCm5ePdPVn9TZ4AWE/
         AGSQz7hj03PAfxikRAOs4ETmjREqxLtV5GLPu31AuwC2i6gkYszE/mtiAFPFAE2AMZB3
         HQtUwgrkg7UzF2LAw6m1YYRy3TXoCaUG8gqFdsvVvNmAFCbaGUbeHdnrSw8eItQrLlOi
         vCSgbDTzJvUkj8qeOhyFqylsnu4S1wPLXkApJI9Ti2T8gsZdZPV79WsXlNIyQqY7DFub
         +tMta+r3kGXTkCPWiwnyMVmz4t3cK/2zgayX9MN6Tef0V8HT/xGbJzxrj+J+9uaNVHyS
         hHVQ==
X-Gm-Message-State: AOAM530P5dWMuDbK4XfTYJr4o+f3lijEYXRM1HfxoyJvCLlpzuRaXHyZ
        kweAmbsABmcCUL5Ybd7vVEXrrKYFe6Ur6U0wBvc=
X-Google-Smtp-Source: ABdhPJwhjKyj8AP3Dy0Z8ofMvk6opi9uZuOY/4ga06sHxxrYu4iaNSIXqLXkM+Z4Cqt/pAkyLg1mYJwIK0LpBSo0eJY=
X-Received: by 2002:a05:6e02:1562:b0:2ca:50f1:72f3 with SMTP id
 k2-20020a056e02156200b002ca50f172f3mr14496482ilu.71.1649715350871; Mon, 11
 Apr 2022 15:15:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220407125224.310255-1-jolsa@kernel.org> <20220407125224.310255-5-jolsa@kernel.org>
In-Reply-To: <20220407125224.310255-5-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Apr 2022 15:15:40 -0700
Message-ID: <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com>
Subject: Re: [RFC bpf-next 4/4] selftests/bpf: Add attach bench test
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
        KP Singh <kpsingh@chromium.org>
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

On Thu, Apr 7, 2022 at 5:53 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding test that reads all functions from ftrace available_filter_functions
> file and attach them all through kprobe_multi API.
>
> It checks that the attach and detach times is under 2 seconds
> and printf stats info with -v option, like on my setup:
>
>   test_bench_attach: found 48712 functions
>   test_bench_attach: attached in   1.069s
>   test_bench_attach: detached in   0.373s
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../bpf/prog_tests/kprobe_multi_test.c        | 141 ++++++++++++++++++
>  .../selftests/bpf/progs/kprobe_multi_empty.c  |  12 ++
>  2 files changed, 153 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> index b9876b55fc0c..6798b54416de 100644
> --- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> +++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> @@ -2,6 +2,9 @@
>  #include <test_progs.h>
>  #include "kprobe_multi.skel.h"
>  #include "trace_helpers.h"
> +#include "kprobe_multi_empty.skel.h"
> +#include "bpf/libbpf_internal.h"
> +#include "bpf/hashmap.h"
>
>  static void kprobe_multi_test_run(struct kprobe_multi *skel, bool test_return)
>  {
> @@ -301,6 +304,142 @@ static void test_attach_api_fails(void)
>         kprobe_multi__destroy(skel);
>  }
>
> +static inline __u64 get_time_ns(void)
> +{
> +       struct timespec t;
> +
> +       clock_gettime(CLOCK_MONOTONIC, &t);
> +       return (__u64) t.tv_sec * 1000000000 + t.tv_nsec;
> +}
> +
> +static size_t symbol_hash(const void *key, void *ctx __maybe_unused)
> +{
> +       return str_hash((const char *) key);
> +}
> +
> +static bool symbol_equal(const void *key1, const void *key2, void *ctx __maybe_unused)
> +{
> +       return strcmp((const char *) key1, (const char *) key2) == 0;
> +}
> +
> +#define DEBUGFS "/sys/kernel/debug/tracing/"
> +
> +static int get_syms(char ***symsp, size_t *cntp)
> +{
> +       size_t cap = 0, cnt = 0, i;
> +       char *name, **syms = NULL;
> +       struct hashmap *map;
> +       char buf[256];
> +       FILE *f;
> +       int err;
> +
> +       /*
> +        * The available_filter_functions contains many duplicates,
> +        * but other than that all symbols are usable in kprobe multi
> +        * interface.
> +        * Filtering out duplicates by using hashmap__add, which won't
> +        * add existing entry.
> +        */
> +       f = fopen(DEBUGFS "available_filter_functions", "r");

I'm really curious how did you manage to attach to everything in
available_filter_functions because when I'm trying to do that I fail.
available_filter_functions has a bunch of functions that should not be
attachable (e.g., notrace functions). Look just at __bpf_tramp_exit:

  void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);

So first, curious what I am doing wrong or rather why it succeeds in
your case ;)

But second, just wanted to plea to "fix" available_filter_functions to
not list stuff that should not be attachable. Can you please take a
look and checks what's going on there and why do we have notrace
functions (and what else should *NOT* be there)?


> +       if (!f)
> +               return -EINVAL;
> +
> +       map = hashmap__new(symbol_hash, symbol_equal, NULL);
> +       err = libbpf_get_error(map);
> +       if (err)
> +               goto error;
> +

[...]

> +
> +       attach_delta_ns = (attach_end_ns - attach_start_ns) / 1000000000.0;
> +       detach_delta_ns = (detach_end_ns - detach_start_ns) / 1000000000.0;
> +
> +       fprintf(stderr, "%s: found %lu functions\n", __func__, cnt);
> +       fprintf(stderr, "%s: attached in %7.3lfs\n", __func__, attach_delta_ns);
> +       fprintf(stderr, "%s: detached in %7.3lfs\n", __func__, detach_delta_ns);
> +
> +       if (attach_delta_ns > 2.0)
> +               PRINT_FAIL("attach time above 2 seconds\n");
> +       if (detach_delta_ns > 2.0)
> +               PRINT_FAIL("detach time above 2 seconds\n");

see my reply on the cover letter, any such "2 second" assumption are
guaranteed to bite us. We've dealt with a lot of timing issues due to
CI being slower and more unpredictable in terms of performance, I'd
like to avoid dealing with one more case like that.


> +
> +cleanup:
> +       kprobe_multi_empty__destroy(skel);
> +       if (syms) {
> +               for (i = 0; i < cnt; i++)
> +                       free(syms[i]);
> +               free(syms);
> +       }
> +}
> +
>  void test_kprobe_multi_test(void)
>  {
>         if (!ASSERT_OK(load_kallsyms(), "load_kallsyms"))
> @@ -320,4 +459,6 @@ void test_kprobe_multi_test(void)
>                 test_attach_api_syms();
>         if (test__start_subtest("attach_api_fails"))
>                 test_attach_api_fails();
> +       if (test__start_subtest("bench_attach"))
> +               test_bench_attach();
>  }
> diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi_empty.c b/tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
> new file mode 100644
> index 000000000000..be9e3d891d46
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
> @@ -0,0 +1,12 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +SEC("kprobe.multi/*")
> +int test_kprobe_empty(struct pt_regs *ctx)
> +{
> +       return 0;
> +}
> --
> 2.35.1
>
