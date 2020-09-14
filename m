Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A162683DC
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 06:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgINE7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 00:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgINE66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 00:58:58 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B99DC061787
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 21:58:57 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id c8so16216286edv.5
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 21:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bruhIH4CDHums7UUWVvK8ZwvwKM6vyD/d4MfCflsEtg=;
        b=Om3aDl9WIviASU808y7ftS1SfffUPIlGspCiwkFK0X80hhlm8kExah6P5oCwh1w62j
         JSBRPpPzqkXxK45ryxK/SfsUXQIWCU/cXOpiFyQjwZ5JJ/ZK3oCw5GWyci9OgEEQiap2
         bOzmsHzb4u8G7Of4XIIXKP9kwvydnwUGuLoTg7oPZijs5AQ5S4WebFLUR44miSDhq+aC
         GLQfPoj5mTlrhfkc2Lkp2Z0x7QTp7mUJDA+alJjFQ8thea4qVe4wWpCA0FslsJg1kAFg
         K+2nwPyNTzxZC43iVEw5EI1FDBM4LpMAujbg9LbCTKOVeIYr+tLIofheyhrZHevMXhfM
         CjOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bruhIH4CDHums7UUWVvK8ZwvwKM6vyD/d4MfCflsEtg=;
        b=klfAP3bM4PnirJnasX3omGfeRHCzNkKdDe404ZAuEaqOZi6Bbe3JRoqwwMVRiIyXpr
         JtlzG0nTf2TG2Qz+bQaFCLBj/WTfrPWFk7xf9BcariQFdgCkXYgompi2XMGwcqk06TU+
         3VlZOoX3yMMYCh1hjY7XsvvT3k7nqSHnEv+fBbW99qXJjZ2sgm0X667mjD33do0HLNqs
         tWenuj6tsxAklRXvikdQz60iSqaEnaLCedipA+z5EjVJqKoBeA1WvkrvO7NH6xXxVHY8
         Kl6DAi3z0SvoiEuOzEhPPEJcQ2jfgidmmibd1Yh+VzdRWA1bfw2WtNT0Gm2TeRnpnptY
         nqYw==
X-Gm-Message-State: AOAM5336a8IdJeN0KhQU9VRMFHDDSMLe0jc1+bhejCpZ7ciN2GF7Mf4T
        haGXYVgbt6GdvQT7vc4yCwB1QZ189/Xz3Nf212qqBA==
X-Google-Smtp-Source: ABdhPJzUl2PIE+E4bdR2k5a/nAFLbfeXoaODUXNbWgYHryIReE2MsJE8Hrq/ShhJGEaZo1TBsmuDvyFioDuUZJE9zSo=
X-Received: by 2002:aa7:d606:: with SMTP id c6mr15708061edr.370.1600059535975;
 Sun, 13 Sep 2020 21:58:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200903223332.881541-1-haoluo@google.com> <20200903223332.881541-4-haoluo@google.com>
 <CAEf4BzZPMwe=kz_K8P-6aeLiJo4rC69bMvju4=JEEv0CDEE9_w@mail.gmail.com>
In-Reply-To: <CAEf4BzZPMwe=kz_K8P-6aeLiJo4rC69bMvju4=JEEv0CDEE9_w@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Sun, 13 Sep 2020 21:58:45 -0700
Message-ID: <CA+khW7gWaMfok5wxyB0_EiVBnULR08vi6mtVZMwat2bhJY+k8Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/6] bpf/selftests: ksyms_btf to test typed ksyms
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
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

Thanks for taking a look, Andrii.

On Fri, Sep 4, 2020 at 12:49 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Sep 3, 2020 at 3:35 PM Hao Luo <haoluo@google.com> wrote:
> >
> > Selftests for typed ksyms. Tests two types of ksyms: one is a struct,
> > the other is a plain int. This tests two paths in the kernel. Struct
> > ksyms will be converted into PTR_TO_BTF_ID by the verifier while int
> > typed ksyms will be converted into PTR_TO_MEM.
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > ---
> >  .../testing/selftests/bpf/prog_tests/ksyms.c  | 31 +++------
> >  .../selftests/bpf/prog_tests/ksyms_btf.c      | 63 +++++++++++++++++++
> >  .../selftests/bpf/progs/test_ksyms_btf.c      | 23 +++++++
> >  tools/testing/selftests/bpf/trace_helpers.c   | 26 ++++++++
> >  tools/testing/selftests/bpf/trace_helpers.h   |  4 ++
> >  5 files changed, 123 insertions(+), 24 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> >

[...]

> > +       percpu_datasec = btf__find_by_name_kind(btf, ".data..percpu",
> > +                                               BTF_KIND_DATASEC);
> > +       if (percpu_datasec < 0) {
> > +               printf("%s:SKIP:no PERCPU DATASEC in kernel btf\n",
> > +                      __func__);
> > +               test__skip();
>
> leaking btf here
>
> > +               return;
> > +       }
> > +
> > +       skel = test_ksyms_btf__open_and_load();
> > +       if (CHECK(!skel, "skel_open", "failed to open and load skeleton\n"))
>
> here
>

Oops. Good catches. Will fix.

> > +               return;
> > +
> > +       err = test_ksyms_btf__attach(skel);
> > +       if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
> > +               goto cleanup;
> > +
> > +       /* trigger tracepoint */
> > +       usleep(1);
> > +
> > +       data = skel->data;
> > +       CHECK(data->out__runqueues != runqueues_addr, "runqueues",
> > +             "got %llu, exp %llu\n", data->out__runqueues, runqueues_addr);
> > +       CHECK(data->out__bpf_prog_active != bpf_prog_active_addr, "bpf_prog_active",
> > +             "got %llu, exp %llu\n", data->out__bpf_prog_active, bpf_prog_active_addr);
>
> u64 is not %llu on some arches, please cast explicitly to (unsigned long long)
>

Ack.

> > +
> > +cleanup:
>
> ... and here (I suggest to just jump from all those locations here for cleanup)
>

Makes sense. Will do.

> > +       test_ksyms_btf__destroy(skel);
> > +}
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
>
> this is addresses, not values, so _addr part would make it clearer.
>

Ack.

> > +
> > +extern const struct rq runqueues __ksym; /* struct type global var. */
> > +extern const int bpf_prog_active __ksym; /* int type global var. */
>
> When we add non-per-CPU kernel variables, I wonder if the fact that we
> have both per-CPU and global kernel variables under the same __ksym
> section would cause any problems and confusion? It's not clear to me
> if we need to have a special __percpu_ksym section or not?..
>

Yeah. Totally agree. I thought about this. I think a separate
__percpu_ksym attribute is *probably* more clear. Not sure though. How
about we introduce a "__percpu_ksym" and make it an alias to "__ksym"
for now? If needed, we make an actual section for it in future.

> > +
> > +SEC("raw_tp/sys_enter")
> > +int handler(const void *ctx)
> > +{
> > +       out__runqueues = (__u64)&runqueues;
> > +       out__bpf_prog_active = (__u64)&bpf_prog_active;
> > +
> > +       return 0;
> > +}
> > +
> > +char _license[] SEC("license") = "GPL";
> > diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
> > index 4d0e913bbb22..ade555fe8294 100644
> > --- a/tools/testing/selftests/bpf/trace_helpers.c
> > +++ b/tools/testing/selftests/bpf/trace_helpers.c
> > @@ -90,6 +90,32 @@ long ksym_get_addr(const char *name)
> >         return 0;
> >  }
> >
> > +/* open kallsyms and read symbol addresses on the fly. Without caching all symbols,
> > + * this is faster than load + find. */
> > +int kallsyms_find(const char *sym, unsigned long long *addr)
> > +{
> > +       char type, name[500];
> > +       unsigned long long value;
> > +       int err = 0;
> > +       FILE *f;
> > +
> > +       f = fopen("/proc/kallsyms", "r");
> > +       if (!f)
> > +               return -ENOENT;
> > +
> > +       while (fscanf(f, "%llx %c %499s%*[^\n]\n", &value, &type, name) > 0) {
> > +               if (strcmp(name, sym) == 0) {
> > +                       *addr = value;
> > +                       goto out;
> > +               }
> > +       }
> > +       err = -EINVAL;
>
> These error codes seem backward to me. If you fail to open
> /proc/kallsyms, that's an unexpected and invalid situation, so EINVAL
> makes a bit more sense there. But -ENOENT is clearly for cases where
> you didn't find what you were looking for, which is exactly this case.
>
>

I thought about it. I used -ENOENT for fopen failure because I found
-ENOENT is for the case when a file/directory is not found, which is
more reasonable in describing fopen error. But your proposal also
makes  sense and that is what I originally had. It doesn't sound like
a big deal, I can switch the order them in v3.

> > +
> > +out:
> > +       fclose(f);
> > +       return err;
> > +}
> > +
> >  void read_trace_pipe(void)
> >  {
> >         int trace_fd;
> > diff --git a/tools/testing/selftests/bpf/trace_helpers.h b/tools/testing/selftests/bpf/trace_helpers.h
> > index 25ef597dd03f..f62fdef9e589 100644
> > --- a/tools/testing/selftests/bpf/trace_helpers.h
> > +++ b/tools/testing/selftests/bpf/trace_helpers.h
> > @@ -12,6 +12,10 @@ struct ksym {
> >  int load_kallsyms(void);
> >  struct ksym *ksym_search(long key);
> >  long ksym_get_addr(const char *name);
> > +
> > +/* open kallsyms and find addresses on the fly, faster than load + search. */
> > +int kallsyms_find(const char *sym, unsigned long long *addr);
> > +
> >  void read_trace_pipe(void);
> >
> >  #endif
> > --
> > 2.28.0.526.ge36021eeef-goog
> >
