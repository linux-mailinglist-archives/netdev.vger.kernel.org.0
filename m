Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066F0239E98
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 07:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgHCFHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 01:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgHCFHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 01:07:16 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56568C06174A;
        Sun,  2 Aug 2020 22:07:16 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id n141so17339636ybf.3;
        Sun, 02 Aug 2020 22:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=djS5LyIwx9n0PelO0PUaubRUNqf6/nX5Lff7bitAtBc=;
        b=isf2aM/pD9kAn+Y6j/KkkvSU0FuCeu0qae35C6bZAI8M0DUzPsN41SPRrZlocQQJ7k
         PlDEa5MSW6xHOxhfNzgYNvL991vZg+UYGZW8x24zHfKyYxdhUC0irl85Q8ewMLuj8v4a
         xqr0pcuyCCClCAAwReT4RlZ4vTyZmSLj8IlXKvXP+6zC2clgWUctG0y2nd0f9X35NI7e
         +onuaQLxyWc1LmBR/BewVH69spLn0woZ2QfVmY4BibN7u3EYDJtLu0gh34PSYW5/2YI1
         YmsmqbWsIn/hVIFtKpFL/Y7DEOXvqYwtP2OLEoWQsPE86dsgFvcBTSOHOKPu0faazoRY
         QnrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=djS5LyIwx9n0PelO0PUaubRUNqf6/nX5Lff7bitAtBc=;
        b=SqToEhJeBjyFUNVZ9hOgja/T8phzzzyIXSZT1/ql5pHznd+sDhuiVetRm6VmhEBAUa
         uU2gS7SnEx1kkPgtwrbuVe2E+NAkekiiNDmblHT4Vqh8388jVwdRzyKVjpQtKwG/r4Y+
         UU9NYyVz217/t5KQBA3AsAXcwEevC4081EorI1Y/wn12S42HNMqzaWKQRu8kUKhFwELj
         xDP/LQfwph9+A3XicchJvh2bfAGJtiS1jel0k669r5U4HxX9YdJFrPDWkkSU1JaLlGaG
         MO6BrEJPQZjnU2jkfh8Dq0aSHpL5sWPfE6BvcSCoVFQgzN8TJkfyp7fyMNSSaWIZR8nw
         WcZQ==
X-Gm-Message-State: AOAM530d3VNuZ/sTXWwRZv7Nn1IoiHqL2Nnfdv6NohNt28MNtWm3b1XP
        SNWLO1+n2h8Z5Bj1oaoSUsonIjuRRDm8/Hu2QkU=
X-Google-Smtp-Source: ABdhPJyD/Iri0DwQnhXGpo4GROOQguyNnL1+qUXzq6I9s48aLzlByOKuhNeU+9G//QJwp711V5gtbrFwmTgARAnxQMU=
X-Received: by 2002:a25:37c8:: with SMTP id e191mr21556785yba.230.1596431235604;
 Sun, 02 Aug 2020 22:07:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-4-songliubraving@fb.com> <CAEf4BzazkFMw3LAs3M2hxSLWWZJ7ywykwte=0WDhC1zgMYw-3A@mail.gmail.com>
 <C5606E9B-D3EC-4425-82F5-DA5865836D3E@fb.com>
In-Reply-To: <C5606E9B-D3EC-4425-82F5-DA5865836D3E@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 2 Aug 2020 22:07:04 -0700
Message-ID: <CAEf4BzZuZt52M1Ta42D=z3m5jC4gi0K=_dzWhDB8DVV5Dkxwmg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] selftests/bpf: add selftest for BPF_PROG_TYPE_USER
To:     Song Liu <songliubraving@fb.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 2, 2020 at 9:33 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Aug 2, 2020, at 6:43 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote:
> >>
> >> This test checks the correctness of BPF_PROG_TYPE_USER program, including:
> >> running on the right cpu, passing in correct args, returning retval, and
> >> being able to call bpf_get_stack|stackid.
> >>
> >> Signed-off-by: Song Liu <songliubraving@fb.com>
> >> ---
> >> .../selftests/bpf/prog_tests/user_prog.c      | 52 +++++++++++++++++
> >> tools/testing/selftests/bpf/progs/user_prog.c | 56 +++++++++++++++++++
> >> 2 files changed, 108 insertions(+)
> >> create mode 100644 tools/testing/selftests/bpf/prog_tests/user_prog.c
> >> create mode 100644 tools/testing/selftests/bpf/progs/user_prog.c
> >>
> >> diff --git a/tools/testing/selftests/bpf/prog_tests/user_prog.c b/tools/testing/selftests/bpf/prog_tests/user_prog.c
> >> new file mode 100644
> >> index 0000000000000..416707b3bff01
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/bpf/prog_tests/user_prog.c
> >> @@ -0,0 +1,52 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/* Copyright (c) 2020 Facebook */
> >> +#include <test_progs.h>
> >> +#include "user_prog.skel.h"
> >> +
> >> +static int duration;
> >> +
> >> +void test_user_prog(void)
> >> +{
> >> +       struct bpf_user_prog_args args = {{0, 1, 2, 3, 4}};
> >> +       struct bpf_prog_test_run_attr attr = {};
> >> +       struct user_prog *skel;
> >> +       int i, numcpu, ret;
> >> +
> >> +       skel = user_prog__open_and_load();
> >> +
> >> +       if (CHECK(!skel, "user_prog__open_and_load",
> >> +                 "skeleton open_and_laod failed\n"))
> >> +               return;
> >> +
> >> +       numcpu = libbpf_num_possible_cpus();
> >
> > nit: possible doesn't mean online right now, so it will fail on
> > offline or non-present CPUs
>
> Just found parse_cpu_mask_file(), will use it to fix this.
>
> [...]
>
> >> +
> >> +volatile int cpu_match = 1;
> >> +volatile __u64 sum = 1;
> >> +volatile int get_stack_success = 0;
> >> +volatile int get_stackid_success = 0;
> >> +volatile __u64 stacktrace[PERF_MAX_STACK_DEPTH];
> >
> > nit: no need for volatile for non-static variables
> >
> >> +
> >> +SEC("user")
> >> +int user_func(struct bpf_user_prog_ctx *ctx)
> >
> > If you put args in bpf_user_prog_ctx as a first field, you should be
> > able to re-use the BPF_PROG macro to access those arguments in a more
> > user-friendly way.
>
> I am not sure I am following here. Do you mean something like:
>
> struct bpf_user_prog_ctx {
>         __u64 args[BPF_USER_PROG_MAX_ARGS];
>         struct pt_regs *regs;
> };
>
> (swap args and regs)?
>

Yes, BPF_PROG assumes that context is a plain u64[5] array, so if you
put args at the beginning, it will work nicely with BPF_PROG.

> Thanks,
> Song
>
>
