Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5701624E620
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 09:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgHVHf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 03:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgHVHf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 03:35:56 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1066C061573;
        Sat, 22 Aug 2020 00:35:55 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id m200so2271248ybf.10;
        Sat, 22 Aug 2020 00:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JZvQzu00zP1NLFWDB6tTXL4jQGOMR3ZC4lkoKHP245g=;
        b=twm3utfXU4KwpCmBw03ms3SqB4VVSd44bGgPFHXGz6VJpq6CgvjpEepVzSIGHKqaXl
         mdiERPxfCjugejJ/fQh5aFPDgime0SQOW5Bnk3AuO7qkWD7QPEvoY52Oi3eyTNPy2B7h
         9punzsKt35wtAMb21Nq5PON47eGWiy38YadKontTLTs1aZ6pRai/bZ1hGWULvN2pY+xS
         cUk2TBTmzHL+zp9SijzRyT8TqGuo/TwLALegEFlZNC4y/YgQeItYttdvNYBNv3kDZgqN
         TNYu9wvCP0YWoLnr1woe6iVeK+7Tr/W+ztz/nRCTXm3A8H00QSgbJh52UqEGnRjwQrt+
         ITVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JZvQzu00zP1NLFWDB6tTXL4jQGOMR3ZC4lkoKHP245g=;
        b=bEvozwsn5cYyQtCDxP7pU6o+PHRMuqdIEiJYCkE3NtqrdC3ulIEIZL4gY61WRp4+bM
         2la3d1Eo4XxzrNwk9USkSA90aVQMppC6fYcy4JcOJaQVeNmf2p8nnAy+JMctD6wN8Xt5
         +XlprhJwD7Trd+aQfNhq/Fvu1mJgf4YIAO5dYkugBOO0OEQzo/2NirVKERx6sidcZNdv
         +scEEkY2QbGCl7bCj5QQqmWDqxbOZoYccXvG3r9R+loaZyk3iN7VQ4auhyy/hoFTdPl6
         IC/D4XkcCgo2A6npUxB+CHkxb4ZeRBU7+zAYbGxevbfri6oSkhbzPVymHtihrrbvDdHW
         SOUA==
X-Gm-Message-State: AOAM5321+22zx7h39q3j13hCddbrwTSxnFr/6EjpJqmnPAkgxxxeKqrA
        C1y06Yb9yzjzJKeNScbfZIZpvKS7+Dj/n3L3xpI=
X-Google-Smtp-Source: ABdhPJyHTvLRIhFHOfW+d+8K+6Jz3fYNuiU4ndnlw3rfiN3TAag+oNWbc1igJT5BOpzjS8Blor0UDgYjLF12MeyQ4kU=
X-Received: by 2002:a25:824a:: with SMTP id d10mr8811177ybn.260.1598081754829;
 Sat, 22 Aug 2020 00:35:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-6-haoluo@google.com>
 <29b8358f-64fb-9e82-acb0-20b5922afc81@fb.com> <CAEf4BzbmOnv1W4p2F6Ke8W_Gwi-QjtsOW8MFSifVoiaRY8jNVg@mail.gmail.com>
 <CA+khW7iLW-KsrfBS2a+OOMU4i72sHiNeSzkAnXoidW7gwaMaLA@mail.gmail.com>
In-Reply-To: <CA+khW7iLW-KsrfBS2a+OOMU4i72sHiNeSzkAnXoidW7gwaMaLA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 22 Aug 2020 00:35:43 -0700
Message-ID: <CAEf4BzbCWcQqOaKoZT2o31_xijA5aWYUNYM3J5UR=Eiq-5V2Vg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 5/8] bpf/selftests: ksyms_btf to test typed ksyms
To:     Hao Luo <haoluo@google.com>
Cc:     Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>,
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

On Sat, Aug 22, 2020 at 12:27 AM Hao Luo <haoluo@google.com> wrote:
>
> On Fri, Aug 21, 2020 at 4:03 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Aug 20, 2020 at 10:32 AM Yonghong Song <yhs@fb.com> wrote:
> > >
> > >
> > >
> > > On 8/19/20 3:40 PM, Hao Luo wrote:
> > > > Selftests for typed ksyms. Tests two types of ksyms: one is a struct,
> > > > the other is a plain int. This tests two paths in the kernel. Struct
> > > > ksyms will be converted into PTR_TO_BTF_ID by the verifier while int
> > > > typed ksyms will be converted into PTR_TO_MEM.
> > > >
> > > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > > ---
> > > >   .../selftests/bpf/prog_tests/ksyms_btf.c      | 77 +++++++++++++++++++
> > > >   .../selftests/bpf/progs/test_ksyms_btf.c      | 23 ++++++
> > > >   2 files changed, 100 insertions(+)
> > > >   create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> > > >   create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> > > > new file mode 100644
> > > > index 000000000000..1dad61ba7e99
> > > > --- /dev/null
> > > > +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> > > > @@ -0,0 +1,77 @@
> > > > +// SPDX-License-Identifier: GPL-2.0
> > > > +/* Copyright (c) 2020 Google */
> > > > +
> > > > +#include <test_progs.h>
> > > > +#include <bpf/libbpf.h>
> > > > +#include <bpf/btf.h>
> > > > +#include "test_ksyms_btf.skel.h"
> > > > +
> > > > +static int duration;
> > > > +
> > > > +static __u64 kallsyms_find(const char *sym)
> > > > +{
> > > > +     char type, name[500];
> > > > +     __u64 addr, res = 0;
> > > > +     FILE *f;
> > > > +
> > > > +     f = fopen("/proc/kallsyms", "r");
> > > > +     if (CHECK(!f, "kallsyms_fopen", "failed to open: %d\n", errno))
> > > > +             return 0;
> > >
> > > could you check whether libbpf API can provide this functionality for
> > > you? As far as I know, libbpf does parse /proc/kallsyms.
> >
> > No need to use libbpf's implementation. We already have
> > kallsyms_find() in prog_tests/ksyms.c and a combination of
> > load_kallsyms() + ksym_get_addr() in trace_helpers.c. It would be good
> > to switch to one implementation for both prog_tests/ksyms.c and this
> > one.
> >
> Ack. I can do some refactoring. The least thing that I can do is
> moving kallsyms_find() to a header for both prog_tests/ksyms.c and
> this test to use.

Please no extra headers. Just put kallsyms_find() in trace_helpers.c,
along other kallsyms-related functions.

>
> >
> > > > diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> > > > new file mode 100644
> > > > index 000000000000..e04e31117f84
> > > > --- /dev/null
> > > > +++ b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> > > > @@ -0,0 +1,23 @@
> > > > +// SPDX-License-Identifier: GPL-2.0
> > > > +/* Copyright (c) 2020 Google */
> > > > +
> > > > +#include "vmlinux.h"
> > > > +
> > > > +#include <bpf/bpf_helpers.h>
> > > > +
> > > > +__u64 out__runqueues = -1;
> > > > +__u64 out__bpf_prog_active = -1;
> > > > +
> > > > +extern const struct rq runqueues __ksym; /* struct type global var. */
> > > > +extern const int bpf_prog_active __ksym; /* int type global var. */
> > > > +
> > > > +SEC("raw_tp/sys_enter")
> > > > +int handler(const void *ctx)
> > > > +{
> > > > +     out__runqueues = (__u64)&runqueues;
> > > > +     out__bpf_prog_active = (__u64)&bpf_prog_active;
> > > > +
> >
> > You didn't test accessing any of the members of runqueues, because BTF
> > only has per-CPU variables, right? Adding global/static variables was
> > adding too much data to BTF or something like that, is that right?
> >
>
> Right. With some experiments, I found the address of a percpu variable
> doesn't necessarily point to a valid structure. So it doesn't make
> sense to dereference runqueues and access its members. However, right
> now there are only percpu variables encoded in BTF, so I can't test
> accessing members of general global/static variables unfortunately.
>
> Hao
