Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11344269890
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 00:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgINWGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 18:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgINWGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 18:06:32 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6935DC06174A;
        Mon, 14 Sep 2020 15:06:31 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id h126so995411ybg.4;
        Mon, 14 Sep 2020 15:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qjXTDrZsJtVC0UTN/zfoow5ilYHg2sYH2n/teLc5H/4=;
        b=Qw6cBHvSogrZmbGiHDwR7HFjNftujO7Sd6TjpwZvPkcwwL6NUS7qjbunscoh9ES0lR
         xFVtL6bkHXKZ3i5EW0egCPiVlm74VnAUVTSZRJvNCm6j+nXJr14xH4JViYXRA3BkBtbd
         ip4fS5NwcORHLqI7pdnPcA6Ji8czYXjdAOLu1JP55sZQoKATNjDbqoZNPx5IkATUvtIL
         pHtV4uKmhr8Qx3g4bhmAzcyNLm0LEErHfqRuTuvk/eFWCa2bemYuBIO2xXD1BKitnSUd
         wtzslH7FXex4cGT/G00Fmpwg5tk4DO7tsF/FXhZXIc9+7a1z5knakeqRsPmZEqcd+uD+
         Gzwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qjXTDrZsJtVC0UTN/zfoow5ilYHg2sYH2n/teLc5H/4=;
        b=bjlo4x7d/e32GQjuD2rEsCrAsuyvSVL7ezr2jM5zUoZqT7dsg414SNx7vIdjzGJtm0
         gDFQPZ141oBF4QiHEVC/7YgLT6i0hUhmqrkccPvykcHpz7nUSNLwNtDnFOXE0wMB50E3
         uck+eCH4z5dLIGhWBxu46uZ5bkD1gNKbfyTA+xr/AhpSbS/qgfW7pta9HLqXZHRb53fB
         cHRwvNaUgRZljP/nyxOayhgcehgkptHYYEvaAk5fFKY76tc01YtI7aXT0VQTqGNUAEFC
         s18p3MjGwgVYeZRQ8zfdezs339TVEywFnTIP9y/iiHTNnUEu3VtLwUkVPgeGp+2F28yV
         TrTQ==
X-Gm-Message-State: AOAM530H7cizaqfBsGaZ7aZO6sxPNsUI4I2drnl2XTlbsMA4RFsGgZd+
        34KitNCNF+/xuXJqHgr5bjmyA+gltL1lG/CMk6g=
X-Google-Smtp-Source: ABdhPJwysH7nAwjlgvWCOzljKDnsSGQmPChYgS8uR6UmMoJQit46Ww8wpXwxUk329AzLTfIrCjdyEtbZeUrVchUqb2I=
X-Received: by 2002:a25:33c4:: with SMTP id z187mr10197978ybz.27.1600121190211;
 Mon, 14 Sep 2020 15:06:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200903223332.881541-1-haoluo@google.com> <20200903223332.881541-4-haoluo@google.com>
 <CAEf4BzZPMwe=kz_K8P-6aeLiJo4rC69bMvju4=JEEv0CDEE9_w@mail.gmail.com> <CA+khW7gWaMfok5wxyB0_EiVBnULR08vi6mtVZMwat2bhJY+k8Q@mail.gmail.com>
In-Reply-To: <CA+khW7gWaMfok5wxyB0_EiVBnULR08vi6mtVZMwat2bhJY+k8Q@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Sep 2020 15:06:18 -0700
Message-ID: <CAEf4BzbcQv2w-zZTUrwEuCckx_uUime023fb=qGyL3t2x35QRQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/6] bpf/selftests: ksyms_btf to test typed ksyms
To:     Hao Luo <haoluo@google.com>
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

On Sun, Sep 13, 2020 at 9:58 PM Hao Luo <haoluo@google.com> wrote:
>
> Thanks for taking a look, Andrii.
>
> On Fri, Sep 4, 2020 at 12:49 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Sep 3, 2020 at 3:35 PM Hao Luo <haoluo@google.com> wrote:
> > >
> > > Selftests for typed ksyms. Tests two types of ksyms: one is a struct,
> > > the other is a plain int. This tests two paths in the kernel. Struct
> > > ksyms will be converted into PTR_TO_BTF_ID by the verifier while int
> > > typed ksyms will be converted into PTR_TO_MEM.
> > >
> > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > ---
> > >  .../testing/selftests/bpf/prog_tests/ksyms.c  | 31 +++------
> > >  .../selftests/bpf/prog_tests/ksyms_btf.c      | 63 +++++++++++++++++++
> > >  .../selftests/bpf/progs/test_ksyms_btf.c      | 23 +++++++
> > >  tools/testing/selftests/bpf/trace_helpers.c   | 26 ++++++++
> > >  tools/testing/selftests/bpf/trace_helpers.h   |  4 ++
> > >  5 files changed, 123 insertions(+), 24 deletions(-)
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> > >
>

[...]

> > > +
> > > +extern const struct rq runqueues __ksym; /* struct type global var. */
> > > +extern const int bpf_prog_active __ksym; /* int type global var. */
> >
> > When we add non-per-CPU kernel variables, I wonder if the fact that we
> > have both per-CPU and global kernel variables under the same __ksym
> > section would cause any problems and confusion? It's not clear to me
> > if we need to have a special __percpu_ksym section or not?..
> >
>
> Yeah. Totally agree. I thought about this. I think a separate
> __percpu_ksym attribute is *probably* more clear. Not sure though. How
> about we introduce a "__percpu_ksym" and make it an alias to "__ksym"
> for now? If needed, we make an actual section for it in future.

Let's keep it in __ksym as is. Verifier will have enough insight to
produce a meaningful error message, it won't be easy to misuse this
feature.

>
> > > +
> > > +SEC("raw_tp/sys_enter")
> > > +int handler(const void *ctx)
> > > +{
> > > +       out__runqueues = (__u64)&runqueues;
> > > +       out__bpf_prog_active = (__u64)&bpf_prog_active;
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +char _license[] SEC("license") = "GPL";
> > > diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
> > > index 4d0e913bbb22..ade555fe8294 100644
> > > --- a/tools/testing/selftests/bpf/trace_helpers.c
> > > +++ b/tools/testing/selftests/bpf/trace_helpers.c
> > > @@ -90,6 +90,32 @@ long ksym_get_addr(const char *name)
> > >         return 0;
> > >  }
> > >
> > > +/* open kallsyms and read symbol addresses on the fly. Without caching all symbols,
> > > + * this is faster than load + find. */
> > > +int kallsyms_find(const char *sym, unsigned long long *addr)
> > > +{
> > > +       char type, name[500];
> > > +       unsigned long long value;
> > > +       int err = 0;
> > > +       FILE *f;
> > > +
> > > +       f = fopen("/proc/kallsyms", "r");
> > > +       if (!f)
> > > +               return -ENOENT;
> > > +
> > > +       while (fscanf(f, "%llx %c %499s%*[^\n]\n", &value, &type, name) > 0) {
> > > +               if (strcmp(name, sym) == 0) {
> > > +                       *addr = value;
> > > +                       goto out;
> > > +               }
> > > +       }
> > > +       err = -EINVAL;
> >
> > These error codes seem backward to me. If you fail to open
> > /proc/kallsyms, that's an unexpected and invalid situation, so EINVAL
> > makes a bit more sense there. But -ENOENT is clearly for cases where
> > you didn't find what you were looking for, which is exactly this case.
> >
> >
>
> I thought about it. I used -ENOENT for fopen failure because I found
> -ENOENT is for the case when a file/directory is not found, which is
> more reasonable in describing fopen error. But your proposal also
> makes  sense and that is what I originally had. It doesn't sound like
> a big deal, I can switch the order them in v3.

For me, ENOENT is about the logical entity the function is working
with. For fopen() that would be file, so if it's not found -- ENOENT.
But here, for kallsyms_find it's a ksym. If /proc/kallsyms isn't there
or can't be open -- that's unexpected (EINVAL). But if /proc/kallsyms
was open but didn't contain the entity we are looking for (requested
ksym) -- that's ENOENT.

>
> > > +
> > > +out:
> > > +       fclose(f);
> > > +       return err;
> > > +}
> > > +
> > >  void read_trace_pipe(void)
> > >  {
> > >         int trace_fd;
> > > diff --git a/tools/testing/selftests/bpf/trace_helpers.h b/tools/testing/selftests/bpf/trace_helpers.h
> > > index 25ef597dd03f..f62fdef9e589 100644
> > > --- a/tools/testing/selftests/bpf/trace_helpers.h
> > > +++ b/tools/testing/selftests/bpf/trace_helpers.h
> > > @@ -12,6 +12,10 @@ struct ksym {
> > >  int load_kallsyms(void);
> > >  struct ksym *ksym_search(long key);
> > >  long ksym_get_addr(const char *name);
> > > +
> > > +/* open kallsyms and find addresses on the fly, faster than load + search. */
> > > +int kallsyms_find(const char *sym, unsigned long long *addr);
> > > +
> > >  void read_trace_pipe(void);
> > >
> > >  #endif
> > > --
> > > 2.28.0.526.ge36021eeef-goog
> > >
