Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF8024E3BF
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 01:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgHUXDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 19:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgHUXDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 19:03:14 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F92C061573;
        Fri, 21 Aug 2020 16:03:14 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id y134so1880379yby.2;
        Fri, 21 Aug 2020 16:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QndIelKTZyhrZCQLXMh+hYGMR0IVoTsACe7ccuk1g4o=;
        b=kdF2YGLqt0bTXX3HauXpH3bbmHRLBO9zeYDsyKHQBPiQSezcaONvt58zFFrIglfVtT
         /2HA6NDts3dGMeta0CcVbAUL8W6Ojt6CaEBMDD1i+pSRRmbHGct3Pq1Fz9mBlisETqMR
         Z/Aelax1cwX1peCjVfz//Iou5n6V6sDrK77Bynu1ov59MA7gPUq5SK1pfZSuwX7PPmbU
         axO16cAOgNJQFGnT7+tYkemLnLsSl57RtP0g1PJGhRQQAOK6xXnNzeLpkFPknPot5vnY
         3fV9edWhfXWZRqbNDFdEybD53tdC4E+rMSpK4YYePosyOwDbxdDSIBCC03WfAL39g51O
         vHVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QndIelKTZyhrZCQLXMh+hYGMR0IVoTsACe7ccuk1g4o=;
        b=iWgU16ZN1i7o6KKvGB3pLdZ0aYTFLSKWC0/CdSiQsFF8ZDmc/+IDl/g9UyEoDKNEvj
         jSH87vTV3ljbOAoRTRYMbiFr9o21LmS7zt9n7yzOqbkqLl+htNXfarmj4i5SSsIe2u+k
         f2FjnXw5vI95UrzZoVkOm9Y+CYB+vRY73MGdGB+JEtYC8phlzqiKhEW2QQ0t+samwkhS
         L79wyAPAJ2e8HGQggc0ny4L6el5jTuoYZ+qWwbba9QazdrqQlaT80AaUioXJ/rngUOMM
         7gDhBXVZHXiBN+Ki76P1iIVwwc5edhl/4s6UmnO0AB6Z3zn/zTp8Ys4SZWRYgczlVqhN
         FebQ==
X-Gm-Message-State: AOAM533kCn5ePmE1d+dTR4lxgmeLiqfF+sRfyDXoEyULELWSIB7wUac9
        ztx5ek3d/gWzfUJjtISsWYtpcKFyGjbyNGkKWuw=
X-Google-Smtp-Source: ABdhPJya8C0YVkSK3qm2yL9XvcMiXZ8bdwkYbMX9zeLUBpXm1lzO2Gby8Wz5JSR2SMiuZnwEjw2d4HRQSCVGOxTeU3c=
X-Received: by 2002:a25:ae43:: with SMTP id g3mr7002244ybe.459.1598050993832;
 Fri, 21 Aug 2020 16:03:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-6-haoluo@google.com>
 <29b8358f-64fb-9e82-acb0-20b5922afc81@fb.com>
In-Reply-To: <29b8358f-64fb-9e82-acb0-20b5922afc81@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Aug 2020 16:03:03 -0700
Message-ID: <CAEf4BzbmOnv1W4p2F6Ke8W_Gwi-QjtsOW8MFSifVoiaRY8jNVg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 5/8] bpf/selftests: ksyms_btf to test typed ksyms
To:     Yonghong Song <yhs@fb.com>
Cc:     Hao Luo <haoluo@google.com>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 10:32 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/19/20 3:40 PM, Hao Luo wrote:
> > Selftests for typed ksyms. Tests two types of ksyms: one is a struct,
> > the other is a plain int. This tests two paths in the kernel. Struct
> > ksyms will be converted into PTR_TO_BTF_ID by the verifier while int
> > typed ksyms will be converted into PTR_TO_MEM.
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > ---
> >   .../selftests/bpf/prog_tests/ksyms_btf.c      | 77 +++++++++++++++++++
> >   .../selftests/bpf/progs/test_ksyms_btf.c      | 23 ++++++
> >   2 files changed, 100 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> > new file mode 100644
> > index 000000000000..1dad61ba7e99
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> > @@ -0,0 +1,77 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2020 Google */
> > +
> > +#include <test_progs.h>
> > +#include <bpf/libbpf.h>
> > +#include <bpf/btf.h>
> > +#include "test_ksyms_btf.skel.h"
> > +
> > +static int duration;
> > +
> > +static __u64 kallsyms_find(const char *sym)
> > +{
> > +     char type, name[500];
> > +     __u64 addr, res = 0;
> > +     FILE *f;
> > +
> > +     f = fopen("/proc/kallsyms", "r");
> > +     if (CHECK(!f, "kallsyms_fopen", "failed to open: %d\n", errno))
> > +             return 0;
>
> could you check whether libbpf API can provide this functionality for
> you? As far as I know, libbpf does parse /proc/kallsyms.

No need to use libbpf's implementation. We already have
kallsyms_find() in prog_tests/ksyms.c and a combination of
load_kallsyms() + ksym_get_addr() in trace_helpers.c. It would be good
to switch to one implementation for both prog_tests/ksyms.c and this
one.


>
> > +
> > +     while (fscanf(f, "%llx %c %499s%*[^\n]\n", &addr, &type, name) > 0) {
> > +             if (strcmp(name, sym) == 0) {
> > +                     res = addr;
> > +                     goto out;
> > +             }
> > +     }
> > +

[...]

> > diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> > new file mode 100644
> > index 000000000000..e04e31117f84
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> > @@ -0,0 +1,23 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2020 Google */
> > +
> > +#include "vmlinux.h"
> > +
> > +#include <bpf/bpf_helpers.h>
> > +
> > +__u64 out__runqueues = -1;
> > +__u64 out__bpf_prog_active = -1;
> > +
> > +extern const struct rq runqueues __ksym; /* struct type global var. */
> > +extern const int bpf_prog_active __ksym; /* int type global var. */
> > +
> > +SEC("raw_tp/sys_enter")
> > +int handler(const void *ctx)
> > +{
> > +     out__runqueues = (__u64)&runqueues;
> > +     out__bpf_prog_active = (__u64)&bpf_prog_active;
> > +

You didn't test accessing any of the members of runqueues, because BTF
only has per-CPU variables, right? Adding global/static variables was
adding too much data to BTF or something like that, is that right?

> > +     return 0;
> > +}
> > +
> > +char _license[] SEC("license") = "GPL";
> >
