Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD4D2F3D61
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436690AbhALVgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436677AbhALUIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 15:08:09 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DB7C061575;
        Tue, 12 Jan 2021 12:07:29 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id z1so149185ybr.4;
        Tue, 12 Jan 2021 12:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wEHoLQAtxyd4MkQNCrEZv+gmArAk+lXeRqyYttgwwQc=;
        b=kO0PHLFOKt+6IvDPd2ok0QqB7v8CECKLjwfi0o8uD9phz+84eX28UwoZdmXmHvmshO
         p2dvlMh/069wi2Qqoug9KRSvKMWiKOcSl+JsMyDmnx3cOhL+hfBND5Sjm79Yuh/6O7n4
         2I8mtGEuGNhFPfSscinD9MbKP/RjlEhKdRXEw5aDKHEIaa0Uq2RO+1kFEK1xLQUvowtN
         9DuHbwiLyciN+ySgFfbChzpA7PMSwsU7wq5tyVDMHqgAg3QxL+DBGBiX41n1bNnKj0AA
         l6IQItOon0Trb/ARJ9gL5vjiTYzwOAWvoSJk0/i4xyErcsYfLmuGh+6p7yG4tLTXloKW
         7tMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wEHoLQAtxyd4MkQNCrEZv+gmArAk+lXeRqyYttgwwQc=;
        b=fDx9QDkKNif2a5+CF5sG6sG7mHlV+xGOO2piYKszv2hHf26b+QKB007Ytcc3ooXI+Q
         A9xkSB/L1Nl51xbgavi+ZRl/ci1MXKJMEzwGOsykjRVmYVUkzpegB/bKDkuvQgmZcZxs
         Eejm8TRAm83X5lLov6P0B1p5gtHfDDX+VcjALVNBcuaFJsaf7lA9/TmNaelRGFoDeGGr
         9hyRNOmvwkOzKtBzvP/wIQSvDdHlGXox7fh2yzHvlsXdzJd/7Tk0rFuRoKx5/OeSlbvC
         F/rESLQ1Qbw5hWv984ElKOrHxwrkPmG41SlED8RUv49VMZ/uSh2BK4BWqchH1MAlfxER
         5vJQ==
X-Gm-Message-State: AOAM5300nReXr//NSiyJy0xZC6m1sLYYW6sdZBN/aDNYNwQ2kHpu1n+F
        d5tAe0RwZgnyxDlludEWk7pz6k1jnkvqsojuSxIdXkDrcNB5DpAa
X-Google-Smtp-Source: ABdhPJyzzwDUAbM9PTFwre76mMErQbr8tvC/qWopLh5AH4ieHmxvUIYzX3n0dUnaMazbO5p7ENrOo6mzRBibZ94qPyg=
X-Received: by 2002:a25:9882:: with SMTP id l2mr1512741ybo.425.1610482048689;
 Tue, 12 Jan 2021 12:07:28 -0800 (PST)
MIME-Version: 1.0
References: <20210111182027.1448538-1-qais.yousef@arm.com> <20210111182027.1448538-3-qais.yousef@arm.com>
 <CAEf4BzYwOAHGOiZBUx86yZ1ofwJ1WqCDR3dyRMrTeQa2ZU7ftA@mail.gmail.com> <20210112192729.q47avnmnzl54nekg@e107158-lin>
In-Reply-To: <20210112192729.q47avnmnzl54nekg@e107158-lin>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 Jan 2021 12:07:17 -0800
Message-ID: <CAEf4BzZiYv1M04FBmuzMH5cxLUXzLthDfpp4nORMEmvkcfzyRQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests: bpf: Add a new test for bare tracepoints
To:     Qais Yousef <qais.yousef@arm.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 11:27 AM Qais Yousef <qais.yousef@arm.com> wrote:
>
> On 01/11/21 23:26, Andrii Nakryiko wrote:
> > On Mon, Jan 11, 2021 at 10:20 AM Qais Yousef <qais.yousef@arm.com> wrote:
> > >
> > > Reuse module_attach infrastructure to add a new bare tracepoint to check
> > > we can attach to it as a raw tracepoint.
> > >
> > > Signed-off-by: Qais Yousef <qais.yousef@arm.com>
> > > ---
> > >
> > > Andrii
> > >
> > > I was getting the error below when I was trying to run the test.
> > > I had to comment out all related fentry* code to be able to test the raw_tp
> > > stuff. Not sure something I've done wrong or it's broken for some reason.
> > > I was on v5.11-rc2.
> >
> > Check that you have all the required Kconfig options from
> > tools/testing/selftests/bpf/config. And also you will need to build
>
> Yep I have merged this config snippet using merge_config.sh script.
>
> > pahole from master, 1.19 doesn't have some fixes that add kernel
> > module support. I think pahole is the reasons why you have the failure
> > below.
>
> I am using pahole 1.19. I have built it from tip of master though.
>
> /trying using v1.19 tag
>
> Still fails the same.
>
> >
> > >
> > >         $ sudo ./test_progs -v -t module_attach
> >
> > use -vv when debugging stuff like that with test_progs, it will output
> > libbpf detailed logs, that often are very helpful
>
> I tried that but it didn't help me. Full output is here
>
>         https://paste.debian.net/1180846
>

It did help a bit for me to make sure that you have bpf_testmod
properly loaded and its BTF was found, so the problem is somewhere
else. Also, given load succeeded and attach failed with OPNOTSUPP, I
suspect you are missing some of FTRACE configs, which seems to be
missing from selftests's config as well. Check that you have
CONFIG_FTRACE=y and CONFIG_DYNAMIC_FTRACE=y, and you might need some
more. See [0] for a real config we are using to run all tests in
libbpf CI. If you figure out what you were missing, please also
contribute a patch to selftests' config.

  [0] https://github.com/libbpf/libbpf/blob/master/travis-ci/vmtest/configs/latest.config

> >
> > >         bpf_testmod.ko is already unloaded.
> > >         Loading bpf_testmod.ko...
> > >         Successfully loaded bpf_testmod.ko.
> > >         test_module_attach:PASS:skel_open 0 nsec
> > >         test_module_attach:PASS:set_attach_target 0 nsec
> > >         test_module_attach:PASS:skel_load 0 nsec
> > >         libbpf: prog 'handle_fentry': failed to attach: ERROR: strerror_r(-524)=22
> > >         libbpf: failed to auto-attach program 'handle_fentry': -524
> > >         test_module_attach:FAIL:skel_attach skeleton attach failed: -524
> > >         #58 module_attach:FAIL
> > >         Successfully unloaded bpf_testmod.ko.
> > >         Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
> > >
> >
> > But even apart from test failure, there seems to be kernel build
> > failure. See [0] for what fails in kernel-patches CI.
> >
> >    [0] https://travis-ci.com/github/kernel-patches/bpf/builds/212730017
>
> Sorry about that. I did a last minute change because of checkpatch.pl error and
> it seems I either forgot to rebuild or missed that the rebuild failed :/
>

no worries, just fix and re-submit. Good that we have CI that caught
this early on.

> >
> >
> > >
> > >  .../selftests/bpf/bpf_testmod/bpf_testmod-events.h     |  6 ++++++
> > >  tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c  |  2 ++
> > >  tools/testing/selftests/bpf/prog_tests/module_attach.c |  1 +
> > >  tools/testing/selftests/bpf/progs/test_module_attach.c | 10 ++++++++++
> > >  4 files changed, 19 insertions(+)
> > >
> > > diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> > > index b83ea448bc79..e1ada753f10c 100644
> > > --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> > > +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> > > @@ -28,6 +28,12 @@ TRACE_EVENT(bpf_testmod_test_read,
> > >                   __entry->pid, __entry->comm, __entry->off, __entry->len)
> > >  );
> > >
> > > +/* A bare tracepoint with no event associated with it */
> > > +DECLARE_TRACE(bpf_testmod_test_read_bare,
> > > +       TP_PROTO(struct task_struct *task, struct bpf_testmod_test_read_ctx *ctx),
> > > +       TP_ARGS(task, ctx)
> > > +);
> > > +
> > >  #endif /* _BPF_TESTMOD_EVENTS_H */
> > >
> > >  #undef TRACE_INCLUDE_PATH
> > > diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> > > index 2df19d73ca49..d63cebdaca44 100644
> > > --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> > > +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> > > @@ -22,6 +22,8 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
> > >         };
> > >
> > >         trace_bpf_testmod_test_read(current, &ctx);
> > > +       ctx.len++;
> > > +       trace_bpf_testmod_test_read_bare(current, &ctx);
> >
> > It's kind of boring to have two read tracepoints :) Do you mind adding
>
> Hehe boring is good :p
>
> > a write tracepoint and use bare tracepoint there? You won't need this
> > ctx.len++ hack as well. Feel free to add identical
> > bpf_testmod_test_write_ctx (renaming it is more of a pain).
>
> It was easy to get this done. So I think it should be easy to make it a write
> too :)

yep, having two tracepoints allow more flexibility over longer term,
so I think it's good to do (regardless of boring or not ;) )

>
> Thanks
>
> --
> Qais Yousef
>
> >
> > >
> > >         return -EIO; /* always fail */
> > >  }
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/module_attach.c b/tools/testing/selftests/bpf/prog_tests/module_attach.c
> > > index 50796b651f72..7085a118f38c 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/module_attach.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/module_attach.c
> > > @@ -50,6 +50,7 @@ void test_module_attach(void)
> > >         ASSERT_OK(trigger_module_test_read(READ_SZ), "trigger_read");
> > >
> > >         ASSERT_EQ(bss->raw_tp_read_sz, READ_SZ, "raw_tp");
> > > +       ASSERT_EQ(bss->raw_tp_bare_read_sz, READ_SZ+1, "raw_tp_bare");
> > >         ASSERT_EQ(bss->tp_btf_read_sz, READ_SZ, "tp_btf");
> > >         ASSERT_EQ(bss->fentry_read_sz, READ_SZ, "fentry");
> > >         ASSERT_EQ(bss->fentry_manual_read_sz, READ_SZ, "fentry_manual");
> > > diff --git a/tools/testing/selftests/bpf/progs/test_module_attach.c b/tools/testing/selftests/bpf/progs/test_module_attach.c
> > > index efd1e287ac17..08aa157afa1d 100644
> > > --- a/tools/testing/selftests/bpf/progs/test_module_attach.c
> > > +++ b/tools/testing/selftests/bpf/progs/test_module_attach.c
> > > @@ -17,6 +17,16 @@ int BPF_PROG(handle_raw_tp,
> > >         return 0;
> > >  }
> > >
> > > +__u32 raw_tp_bare_read_sz = 0;
> > > +
> > > +SEC("raw_tp/bpf_testmod_test_read_bare")
> > > +int BPF_PROG(handle_raw_tp_bare,
> > > +            struct task_struct *task, struct bpf_testmod_test_read_ctx *read_ctx)
> > > +{
> > > +       raw_tp_bare_read_sz = BPF_CORE_READ(read_ctx, len);
> > > +       return 0;
> > > +}
> > > +
> > >  __u32 tp_btf_read_sz = 0;
> > >
> > >  SEC("tp_btf/bpf_testmod_test_read")
> > > --
> > > 2.25.1
> > >
