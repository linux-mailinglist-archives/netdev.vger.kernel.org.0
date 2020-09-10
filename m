Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D06265521
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 00:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725300AbgIJWej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 18:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgIJWei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 18:34:38 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B043DC061573;
        Thu, 10 Sep 2020 15:34:37 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id s19so93944ybc.5;
        Thu, 10 Sep 2020 15:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=26Kn2rhsa3xJivd2y4pBgAN2IoN23FJyYykJzBjpe7M=;
        b=Bff8oa2xCRWxrgHhixxfFe4FLc/9PYNmLczTjY+l2nbj1zGeWbbmHFOYKByesmlQP4
         7InaCj2RFix3eod8D9l1yTXY0G6D+DPC8cwBb2uIYSaFVtsDIueclR85js4uJvR4VxHJ
         TpNrECfhMVyN6Y6bOCJ/VGW2UB1jeTQ1KARBw61bHFHqrGkXeWBbiasi34HGv+P1lOmK
         RD13IoEgHb+//td3lsh3TMh6BMRxdsaOSlIYvFfGV5mPP0+NqgRTiV6a0GTduFFN0k8Q
         DUwoe9INtMzXiXOeUufozvUXMNAdS/skF/9aAGc6+O2kVOgyN9hFO95oC7cj1RVKMTeH
         NQdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=26Kn2rhsa3xJivd2y4pBgAN2IoN23FJyYykJzBjpe7M=;
        b=OLe75qHRSN2qBguau4Iu1LH3M7aFfyr9DPmJyAloi7+VbwZYTNpukTeh8qOL72Xnt1
         sb7j/eVWWSxNfZ/3deRqq8AeGVNYYNbbDKE4OHJMA+2QU5sZN3P5AMSIZbNzUShZ/T8w
         sygpy0/5YFcRdwSxmk4EJnp4ayDpC9grX8hFS8X37nsBNy2x7auZZemeg8Gb5tRTGRPQ
         4qkrbZT6h97gRrSNLfueZoySXVcvsQONteK7+y8kqm1exA2wkv9alz5pzSa7L01wJy5D
         ac2oPBeEBXfddAbCXjtOcLWg19ln7qmYjWuxt7GBb1NmdHBANUY7MFUp7laih0gl+hk+
         wi/A==
X-Gm-Message-State: AOAM530uHfsSTk80cr5Nfpv/l6lRsCNAe07F2n7c10rSdn+gjFVbUeEN
        VLnMh4yY7rBoNYt13o9k5xRFY8WWYoMvv2nSeXE=
X-Google-Smtp-Source: ABdhPJyvJ/p87NeXapSWZ0Ub8O3hBJie+jISKLaezMybzzjVtKEsnN54NXw+ExrMrIScKGTldLsXCgoONjA1zmb/XUc=
X-Received: by 2002:a25:7b81:: with SMTP id w123mr16797765ybc.260.1599777276885;
 Thu, 10 Sep 2020 15:34:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200909151115.1559418-1-jolsa@kernel.org> <20200909151115.1559418-2-jolsa@kernel.org>
In-Reply-To: <20200909151115.1559418-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Sep 2020 15:34:26 -0700
Message-ID: <CAEf4BzbY3zV-xYDBvCYztXOkn=MJwHxOVyAH7YRH8JH869qtDg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Adding test for arg
 dereference in extension trace
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 8:38 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding test that setup following program:
>
>   SEC("classifier/test_pkt_md_access")
>   int test_pkt_md_access(struct __sk_buff *skb)
>
> with its extension:
>
>   SEC("freplace/test_pkt_md_access")
>   int test_pkt_md_access_new(struct __sk_buff *skb)
>
> and tracing that extension with:
>
>   SEC("fentry/test_pkt_md_access_new")
>   int BPF_PROG(fentry, struct sk_buff *skb)
>
> The test verifies that the tracing program can
> dereference skb argument properly.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/trace_ext.c      | 93 +++++++++++++++++++
>  .../selftests/bpf/progs/test_trace_ext.c      | 18 ++++
>  .../bpf/progs/test_trace_ext_tracing.c        | 25 +++++
>  3 files changed, 136 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_ext.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/trace_ext.c b/tools/testing/selftests/bpf/prog_tests/trace_ext.c
> new file mode 100644
> index 000000000000..1089dafb4653
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/trace_ext.c
> @@ -0,0 +1,93 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#define _GNU_SOURCE
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +#include <sys/stat.h>
> +#include <linux/sched.h>
> +#include <sys/syscall.h>
> +
> +#include "test_trace_ext.skel.h"
> +#include "test_trace_ext_tracing.skel.h"
> +
> +static __u32 duration;
> +
> +void test_trace_ext(void)
> +{
> +       struct test_trace_ext_tracing *skel_trace = NULL;
> +       struct test_trace_ext_tracing__bss *bss_trace;
> +       const char *file = "./test_pkt_md_access.o";
> +       struct test_trace_ext *skel_ext = NULL;
> +       struct test_trace_ext__bss *bss_ext;
> +       int err, prog_fd, ext_fd;
> +       struct bpf_object *obj;
> +       char buf[100];
> +       __u32 retval;
> +       __u64 len;
> +
> +       err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
> +       if (CHECK_FAIL(err))
> +               return;

We should avoid using bpf_prog_load() for new code. Can you please
just skeleton instead? Or at least bpf_object__open_file()?

> +
> +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
> +                           .attach_prog_fd = prog_fd,
> +       );

DECLARE_LIBBPF_OPTS does declare a variable, so should be together
with all the other variables above, otherwise some overly strict C89
mode compiler will start complaining. You can assign
`opts.attach_prog_fd = prog_fd;` outside of declaration. But I also
don't think you need this one. Having .attach_prog_fd in open_opts is
not great, because it's a per-program setting specified at bpf_object
level. Would bpf_program__set_attach_target() work here?

> +
> +       skel_ext = test_trace_ext__open_opts(&opts);
> +       if (CHECK(!skel_ext, "setup", "freplace/test_pkt_md_access open failed\n"))
> +               goto cleanup;
> +
> +       err = test_trace_ext__load(skel_ext);
> +       if (CHECK(err, "setup", "freplace/test_pkt_md_access load failed\n")) {
> +               libbpf_strerror(err, buf, sizeof(buf));
> +               fprintf(stderr, "%s\n", buf);
> +               goto cleanup;
> +       }
> +
> +       err = test_trace_ext__attach(skel_ext);
> +       if (CHECK(err, "setup", "freplace/test_pkt_md_access attach failed: %d\n", err))
> +               goto cleanup;
> +
> +       ext_fd = bpf_program__fd(skel_ext->progs.test_pkt_md_access_new);
> +
> +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts_trace,
> +                           .attach_prog_fd = ext_fd,
> +       );
> +

same

> +       skel_trace = test_trace_ext_tracing__open_opts(&opts_trace);
> +       if (CHECK(!skel_trace, "setup", "tracing/test_pkt_md_access_new open failed\n"))
> +               goto cleanup;
> +
> +       err = test_trace_ext_tracing__load(skel_trace);
> +       if (CHECK(err, "setup", "tracing/test_pkt_md_access_new load failed\n")) {
> +               libbpf_strerror(err, buf, sizeof(buf));
> +               fprintf(stderr, "%s\n", buf);
> +               goto cleanup;
> +       }
> +
> +       err = test_trace_ext_tracing__attach(skel_trace);
> +       if (CHECK(err, "setup", "tracing/test_pkt_md_access_new attach failed: %d\n", err))
> +               goto cleanup;
> +
> +       err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
> +                               NULL, NULL, &retval, &duration);
> +       CHECK(err || retval, "",
> +             "err %d errno %d retval %d duration %d\n",
> +             err, errno, retval, duration);
> +
> +       bss_ext = skel_ext->bss;
> +       bss_trace = skel_trace->bss;
> +
> +       len = bss_ext->ext_called;
> +
> +       CHECK(bss_ext->ext_called == 0,
> +               "check", "failed to trigger freplace/test_pkt_md_access\n");
> +       CHECK(bss_trace->fentry_called != len,
> +               "check", "failed to trigger fentry/test_pkt_md_access_new\n");
> +       CHECK(bss_trace->fexit_called != len,
> +               "check", "failed to trigger fexit/test_pkt_md_access_new\n");
> +
> +cleanup:
> +       test_trace_ext__destroy(skel_ext);
> +       bpf_object__close(obj);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_trace_ext.c b/tools/testing/selftests/bpf/progs/test_trace_ext.c
> new file mode 100644
> index 000000000000..a6318f6b52ee
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_trace_ext.c
> @@ -0,0 +1,18 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +#include <linux/bpf.h>
> +#include <stdbool.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +#include <bpf/bpf_tracing.h>
> +
> +volatile __u64 ext_called = 0;

nit: no need for volatile, global variables are not going anywhere;
same below in two places

> +
> +SEC("freplace/test_pkt_md_access")
> +int test_pkt_md_access_new(struct __sk_buff *skb)
> +{
> +       ext_called = skb->len;
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c b/tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c
> new file mode 100644
> index 000000000000..9e52a831446f
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c
> @@ -0,0 +1,25 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +volatile __u64 fentry_called = 0;
> +
> +SEC("fentry/test_pkt_md_access_new")
> +int BPF_PROG(fentry, struct sk_buff *skb)
> +{
> +       fentry_called = skb->len;
> +       return 0;
> +}
> +
> +volatile __u64 fexit_called = 0;
> +
> +SEC("fexit/test_pkt_md_access_new")
> +int BPF_PROG(fexit, struct sk_buff *skb)
> +{
> +       fexit_called = skb->len;
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.26.2
>
