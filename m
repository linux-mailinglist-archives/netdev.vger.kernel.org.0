Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96202F21FC
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 22:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733305AbhAKVlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 16:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbhAKVli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 16:41:38 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC124C061795;
        Mon, 11 Jan 2021 13:40:57 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id w127so197514ybw.8;
        Mon, 11 Jan 2021 13:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TUFQh3FPlt8qvoud1BlrGloEpH1n0/n71IG6rvku3ik=;
        b=DYm3M1hZc4Z/WeUlLT73RJ2JnBshC4Pcqvpin3BfaQnUeHwbAGAeySUIY5Ki2ubTwG
         m/5EXAWB6bh/5cUbwMkbOtj3jGPdLmhlJms9vavVGbdSQTsKyNP5chNrO0GLw6AxYLZv
         JoOK3RQWVHdLMxMOWOmx31HkCr7I0mVZkxr3iwsU/9b5IZu4lc1/+pnUdF+zzFdbZbB3
         AkNkrBqFIvKRmPnxN1qrGVwKZehCaHSHthxHRJMmsBZQPUqQt86jXDWkryFFTbtBN2RB
         sUsIRK+mR6UOeaE3c9yv46u1wViEe56u3sd57twOmhfWRUFP7+0YawUPZJQMgcbGMBF7
         DJxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TUFQh3FPlt8qvoud1BlrGloEpH1n0/n71IG6rvku3ik=;
        b=U8g/5ecPn1DRidrt0/TUgcWxvXG9DivKBq/DkhlMHna45WxFhaYt1fWGQQpHhjxVed
         tP26xXmZDyj5TKlfYk09aGu8yr93HF4C7eZKynWiYbSlWk1UP0Axqsytb4H/Yab6RxPQ
         mn2yM9Df4zS9cOSrympCphrDlpRDyj3DndVor9xG5iH0RGJGe1nDjXszrpNN06KtffAO
         oQ90PuXpK7Jy94ftEPgfKoRcfoofhwFLsjikfDm53lISaklTWKxYG+aRBPtn0U2EFWBv
         uKBjrmOgqkkzoprwzD3x3VzQIZ9JPwxudxxv9iIto0P1qZotZm3NtanfCpPaz4/V1NUO
         //sA==
X-Gm-Message-State: AOAM5334dD829AstJk8xeEUK5MRZrKhVIMivoPHZpAA1+VEoMkkzWMqH
        8ZU/AnwQGCWAVjsXC5NI3k8DrXOzuoxZIsG6Jlg=
X-Google-Smtp-Source: ABdhPJxj9yLUeHGzQXu8dZ38BQVWec03NiGGSVd+Y37xWwyLeCbEkMOZJCmOqAQ8w/G3WFfW3f4MRGlBDnxjHBZXCIQ=
X-Received: by 2002:a25:9882:: with SMTP id l2mr2381350ybo.425.1610401257228;
 Mon, 11 Jan 2021 13:40:57 -0800 (PST)
MIME-Version: 1.0
References: <20210108220930.482456-1-andrii@kernel.org> <20210108220930.482456-8-andrii@kernel.org>
 <24b84186-4cd6-131c-2284-d0fdc51ce7b4@fb.com>
In-Reply-To: <24b84186-4cd6-131c-2284-d0fdc51ce7b4@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jan 2021 13:40:46 -0800
Message-ID: <CAEf4BzYLX+jrgKt5gJGmvQ8OOQMEK1V=19R=L2QxZtU_AYPKGg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 7/7] selftests/bpf: test kernel module ksym externs
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 8:18 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/8/21 2:09 PM, Andrii Nakryiko wrote:
> > Add per-CPU variable to bpf_testmod.ko and use those from new selftest to
> > validate it works end-to-end.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Ack with a nit below.
>
> Acked-by: Yonghong Song <yhs@fb.com>
>
> > ---
> >   .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  3 ++
> >   .../selftests/bpf/prog_tests/ksyms_module.c   | 33 +++++++++++++++++++
> >   .../selftests/bpf/progs/test_ksyms_module.c   | 26 +++++++++++++++
> >   3 files changed, 62 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module.c
> >
> > diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> > index 2df19d73ca49..0b991e115d1f 100644
> > --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> > +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> > @@ -3,6 +3,7 @@
> >   #include <linux/error-injection.h>
> >   #include <linux/init.h>
> >   #include <linux/module.h>
> > +#include <linux/percpu-defs.h>
> >   #include <linux/sysfs.h>
> >   #include <linux/tracepoint.h>
> >   #include "bpf_testmod.h"
> > @@ -10,6 +11,8 @@
> >   #define CREATE_TRACE_POINTS
> >   #include "bpf_testmod-events.h"
> >
> > +DEFINE_PER_CPU(int, bpf_testmod_ksym_percpu) = 123;
> > +
> >   noinline ssize_t
> >   bpf_testmod_test_read(struct file *file, struct kobject *kobj,
> >                     struct bin_attribute *bin_attr,
> > diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> > new file mode 100644
> > index 000000000000..7fa3d8b6ca30
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> > @@ -0,0 +1,33 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2021 Facebook */
> > +
> > +#include <test_progs.h>
> > +#include <bpf/libbpf.h>
> > +#include <bpf/btf.h>
> > +#include "test_ksyms_module.skel.h"
> > +
> > +static int duration;
> > +
> > +void test_ksyms_module(void)
> > +{
> > +     struct test_ksyms_module* skel;
> > +     struct test_ksyms_module__bss *bss;
> > +     int err;
> > +
> > +     skel = test_ksyms_module__open_and_load();
> > +     if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> > +             return;
> > +     bss = skel->bss;
> > +
> > +     err = test_ksyms_module__attach(skel);
> > +     if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
> > +             goto cleanup;
> > +
> > +     usleep(1);
>
> The above bss = skel->bss might be moved here for better readability.
> Or better, you can remove definition bss and just use skel->bss
> in below two ASSERT_EQs.

Sure, I'll just inline for such a short test.

>
> > +     ASSERT_EQ(bss->triggered, true, "triggered");
> > +     ASSERT_EQ(bss->out_mod_ksym_global, 123, "global_ksym_val");
> > +
> > +cleanup:
> > +     test_ksyms_module__destroy(skel);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_module.c b/tools/testing/selftests/bpf/progs/test_ksyms_module.c
> > new file mode 100644
> > index 000000000000..d6a0b3086b90
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_ksyms_module.c
> > @@ -0,0 +1,26 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2021 Facebook */
> > +
> > +#include "vmlinux.h"
> > +
> > +#include <bpf/bpf_helpers.h>
> > +
> > +extern const int bpf_testmod_ksym_percpu __ksym;
> > +
> > +int out_mod_ksym_global = 0;
> > +bool triggered = false;
> > +
> > +SEC("raw_tp/sys_enter")
> > +int handler(const void *ctx)
> > +{
> > +     int *val;
> > +     __u32 cpu;
> > +
> > +     val = (int *)bpf_this_cpu_ptr(&bpf_testmod_ksym_percpu);
> > +     out_mod_ksym_global = *val;
> > +     triggered = true;
> > +
> > +     return 0;
> > +}
> > +
> > +char LICENSE[] SEC("license") = "GPL";
> >
