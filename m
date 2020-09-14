Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA14726925B
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgINRAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgINQ7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 12:59:39 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215B9C06178A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 09:59:36 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id ay8so267993edb.8
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 09:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LgLAMiueLQvRKT1VcEwOX2h3O0SkkBVCwrQksaStG58=;
        b=jv/fPVXh1KEyUtr9JDvvSS70fn8QoRa90CWrtDzhxsA9wNIZWHAKgmO8qu+3EbaSKM
         lZ1OaRD9c6cn9gQIFgY/EuTNoP92gAqebpel5NUV+0vitfhjKNiidqQjqnFtdAKATlVo
         5THtQPrlcO6Y9Y82Vu8dbC70NC08iZ3278dbv+mwIL1Pua4QYVBjPZ7OHQ72BXMPbCBx
         AHBu68of/NHbbxyQNDsMG0duW3KPEYHDTedQzOFZ0h6DGTrZxnoE04naRAJlrVagZFjY
         XMIOZOoJ17mqdMQqxiHvdEiRRjMcXuEs6E75wRddWp0D21gag8P5+PrmA13Y3thIgH6m
         cNbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LgLAMiueLQvRKT1VcEwOX2h3O0SkkBVCwrQksaStG58=;
        b=h029DZHwMqZAx1FrOXzYiZeVaNR2gowDSsCixxmMLk5tDW+U3V6AiSWQ+hohOFx+2h
         P5LvmXshs9bxpQWKR3uDGVbju1nynLHooAiF0JgVZkcM+gyqt41FnHWIhuuqxAqKhFeU
         5qHYxrjhbiNp/WmSO2nr3FSTN4LIMoOBwGAGpFs8zZ7EYtf2v+1vNcC7HnuqKzezDACv
         r4ANc8LbHzyzarUy9d/PyACM4Jwo8buW5pnXxAMzyvmTGPE4e5whMwJW/7DSWBS4w+RE
         dzgCIwOvElI63EWfOFQ/mj3+ZRmHSbcWILnbRoJUbGL0H3H7lgPJF0OreGnWmPJO1Mrw
         TSbg==
X-Gm-Message-State: AOAM532AMsPPc6HNMyzj+n5PnLdPRnsMAxGtV4jwUyEQhxvjuTNp4Fl6
        w+jXmnFx1xLif1NrFg2yWd6ZwdZSljIDjtb+kI2WMoVSY0JNW5W6
X-Google-Smtp-Source: ABdhPJyf71GHMcSXV/6dwx1JG6zZA1TrrkxDbBoFuTWIhVXx+UIIOcl5Zk2CATzCo6Lsp9g4jiDQRDaSJlkWm1k/IOo=
X-Received: by 2002:aa7:d606:: with SMTP id c6mr18565446edr.370.1600102774571;
 Mon, 14 Sep 2020 09:59:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200903223332.881541-1-haoluo@google.com> <20200903223332.881541-7-haoluo@google.com>
 <CAEf4BzZ9krnVzAR=0oQMe+f96cZff5MSdV3_EHiS-mSNF8MieQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZ9krnVzAR=0oQMe+f96cZff5MSdV3_EHiS-mSNF8MieQ@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Mon, 14 Sep 2020 09:59:22 -0700
Message-ID: <CA+khW7j_jZPtpO0_z51EfuUnN-Kxt2CytGG695=D0jR7my7pBg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/6] bpf/selftests: Test for bpf_per_cpu_ptr()
 and bpf_this_cpu_ptr()
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

Thanks for taking a look!

On Fri, Sep 4, 2020 at 1:15 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Sep 3, 2020 at 3:35 PM Hao Luo <haoluo@google.com> wrote:
> >
> > Test bpf_per_cpu_ptr() and bpf_this_cpu_ptr(). Test two paths in the
> > kernel. If the base pointer points to a struct, the returned reg is
> > of type PTR_TO_BTF_ID. Direct pointer dereference can be applied on
> > the returned variable. If the base pointer isn't a struct, the
> > returned reg is of type PTR_TO_MEM, which also supports direct pointer
> > dereference.
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > ---
> >  .../selftests/bpf/prog_tests/ksyms_btf.c      | 10 +++++++
> >  .../selftests/bpf/progs/test_ksyms_btf.c      | 26 +++++++++++++++++++
> >  2 files changed, 36 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> > index 7b6846342449..22cc642dbc0e 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> > @@ -58,6 +58,16 @@ void test_ksyms_btf(void)
> >         CHECK(data->out__bpf_prog_active != bpf_prog_active_addr, "bpf_prog_active",
> >               "got %llu, exp %llu\n", data->out__bpf_prog_active, bpf_prog_active_addr);
> >
> > +       CHECK(data->out__rq_cpu == -1, "rq_cpu",
> > +             "got %u, exp != -1\n", data->out__rq_cpu);
> > +       CHECK(data->out__percpu_bpf_prog_active == -1, "percpu_bpf_prog_active",
> > +             "got %d, exp != -1\n", data->out__percpu_bpf_prog_active);
> > +
> > +       CHECK(data->out__this_rq_cpu == -1, "this_rq_cpu",
> > +             "got %u, exp != -1\n", data->out__this_rq_cpu);
> > +       CHECK(data->out__this_bpf_prog_active == -1, "this_bpf_prog_active",
> > +             "got %d, exp != -1\n", data->out__this_bpf_prog_active);
>
> see below for few suggestions to make these test more specific
>
> out__this_bpf_prog_active it should always be > 0, no?
>

I could be wrong, but I remember raw_trace_point is not tracked by
bpf_prog_active. So I used bpf_prog_active >= 0 to be safe.

> > +
> >  cleanup:
> >         test_ksyms_btf__destroy(skel);
> >  }
> > diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> > index e04e31117f84..02d564349892 100644
> > --- a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> > +++ b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> > @@ -8,15 +8,41 @@
> >  __u64 out__runqueues = -1;
> >  __u64 out__bpf_prog_active = -1;
> >
> > +__u32 out__rq_cpu = -1; /* percpu struct fields */
> > +int out__percpu_bpf_prog_active = -1; /* percpu int */
> > +
> > +__u32 out__this_rq_cpu = -1;
> > +int out__this_bpf_prog_active = -1;
> > +
> >  extern const struct rq runqueues __ksym; /* struct type global var. */
> >  extern const int bpf_prog_active __ksym; /* int type global var. */
> >
> >  SEC("raw_tp/sys_enter")
> >  int handler(const void *ctx)
> >  {
> > +       struct rq *rq;
> > +       int *active;
> > +       __u32 cpu;
> > +
> >         out__runqueues = (__u64)&runqueues;
> >         out__bpf_prog_active = (__u64)&bpf_prog_active;
> >
> > +       cpu = bpf_get_smp_processor_id();
> > +
> > +       /* test bpf_per_cpu_ptr() */
> > +       rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, cpu);
> > +       if (rq)
> > +               out__rq_cpu = rq->cpu;
> > +       active = (int *)bpf_per_cpu_ptr(&bpf_prog_active, cpu);
> > +       if (active)
> > +               out__percpu_bpf_prog_active = *active;
>
> this is equivalent to using bpf_this_cpu_ptr(), so:
>
> 1. you can compare value with out__this_xxx in user-space
>
> 2. it's interesting to also test that you can read value from some
> other CPU. Can you add another variable and get value from CPU #0
> always? E.g., for out__cpu_0_rq_cpu it should always be zero, right?
>

Ack. That makes sense. You are right, out__cpu_0_rq_cpu is always zero.

> > +
> > +       /* test bpf_this_cpu_ptr */
> > +       rq = (struct rq *)bpf_this_cpu_ptr(&runqueues);
> > +       out__this_rq_cpu = rq->cpu;
> > +       active = (int *)bpf_this_cpu_ptr(&bpf_prog_active);
> > +       out__this_bpf_prog_active = *active;
> > +
> >         return 0;
> >  }
> >
> > --
> > 2.28.0.526.ge36021eeef-goog
> >
