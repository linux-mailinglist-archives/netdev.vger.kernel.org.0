Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D4649AB74
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 06:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390962AbiAYE4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 23:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S246658AbiAYDsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 22:48:04 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE92C06B5AA;
        Mon, 24 Jan 2022 14:47:33 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id v6so21476949iom.6;
        Mon, 24 Jan 2022 14:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pamBhU9MB/DFcON/vDn8TDJdYZSb1buiYBtziGJhhOs=;
        b=jBRK1JtmoYCuYblOKBG10OzVxd2tdKuyBy3zgWmoXz1617N+Z0YLpFhytuuzfoQ/nG
         Q2JXfxSEk+f7lN0O9mOpxNzUqUA3Li6iaIv5PhC0nat3Cv3cWzcKavrZ4VNWgIxfRR5c
         6SmWjiEo3epJZTit3QL/XfDs8p1cpIXcD/biatOOIz3oSqoY6VtvNoGf6P7gLS5sSgYS
         Ja2PzPIqcP5uXsperEQE9fYhiMp7kMnakCStDzCBdRQB4rYMrCon1siHjOqWYW9/tQn/
         JyviiGHgdw+KDsZPYfQ9yrmns1FsGPVoyT4h704uj69wLsizR+2Q5gqoNvDLUq/tjfJU
         Gevw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pamBhU9MB/DFcON/vDn8TDJdYZSb1buiYBtziGJhhOs=;
        b=TtzPuct8+6yogsb+pZqvH5qJeyvbj6xO/ZKbV79xkLHTN2l5jooTnZBHWUMJ9bR2jQ
         RbDfOFD8ZM4njmiUevsG1O8aq6zVxILUuu81R/Jv/v7m9YmzTAMXciTuG3uAm+84Cl/3
         2qEYtBjd9oHyJ/iApvqNpSP3FnZIqwRG+D0TUHq68gvKy9/7cg7UfI982rygFQvfFZIG
         OUTCt0MXYE2utMy0PG5QMp3SKHnw1oIjfJBua6qPS55dntDXEu5Zjgh/IAhsMzYU6cOU
         WvYuWBQGM3eAuhGHvRWEODP2o2tairDrPMVKaOGvSAOrLzIK5046mI4to9py7QFXS9HC
         LMuw==
X-Gm-Message-State: AOAM530hxx+TOqib3I6j5qKJtuLk9/xXLP4BDb8tgnBVZdRog0iEOOuk
        EkqspVk3YsU5Kgz34+ZsqWfoLoyeF5EgVAg107M=
X-Google-Smtp-Source: ABdhPJxo6ToPh7rgzXGr1Z/a1EvzwHl8Iy6sVMHrPV592Yv0lM+HB8twQ5IqJ0ZZzP8Hh/WZcYJDp+6SDO5LrGZpxus=
X-Received: by 2002:a02:818a:: with SMTP id n10mr7254778jag.145.1643064452513;
 Mon, 24 Jan 2022 14:47:32 -0800 (PST)
MIME-Version: 1.0
References: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com>
 <CAADnVQJMsVw_oD7BWoMhG7hNdqLcFFzTwSAhnJLCh0vEBMHZbQ@mail.gmail.com>
 <CAEf4Bza8m33juRRXa1ozg44txMALr4A_QOJYp5Nw70HiWRryfA@mail.gmail.com> <alpine.LRH.2.23.451.2201241348550.28129@localhost>
In-Reply-To: <alpine.LRH.2.23.451.2201241348550.28129@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 Jan 2022 14:47:21 -0800
Message-ID: <CAEf4BzZ4Xzhybhw_e1Q3rBNvSvdLBF7JFMex=mg_dUf_Eza5TQ@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/3] libbpf: name-based u[ret]probe attach
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 6:14 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Fri, 21 Jan 2022, Andrii Nakryiko wrote:
>
> > On Thu, Jan 20, 2022 at 5:44 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Thu, Jan 20, 2022 at 3:43 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> > > >
> > > > This patch series is a refinement of the RFC patchset [1], focusing
> > > > on support for attach by name for uprobes and uretprobes.  Still
> > > > marked RFC as there are unresolved questions.
> > > >
> > > > Currently attach for such probes is done by determining the offset
> > > > manually, so the aim is to try and mimic the simplicity of kprobe
> > > > attach, making use of uprobe opts to specify a name string.
> > > >
> > > > uprobe attach is done by specifying a binary path, a pid (where
> > > > 0 means "this process" and -1 means "all processes") and an
> > > > offset.  Here a 'func_name' option is added to 'struct uprobe_opts'
> > > > and that name is searched for in symbol tables.  If the binary
> > > > is a program, relative offset calcuation must be done to the
> > > > symbol address as described in [2].
> > >
> > > I think the pid discussion here and in the patches only causes
> > > confusion. I think it's best to remove pid from the api.
> >
> > It's already part of the uprobe API in libbpf
> > (bpf_program__attach_uprobe), but nothing really changes there.
> > API-wise Alan just added an optional func_name option. I think it
> > makes sense overall.
> >
> > For auto-attach it has to be all PIDs, of course.
> >
>
> Makes sense.
>
> > > uprobes are attached to an inode. They're not attached to a pid
> > > or a process. Any existing process or future process started
> > > from that inode (executable file) will have that uprobe triggering.
> > > The kernel can do pid filtering through predicate mechanism,
> > > but bpf uprobe doesn't do any filtering. iirc.
>
> I _think_ there is filtering in uprobe_perf_func() - it calls
> uprobe_perf_filter() prior to calling __uprobe_perf_func(), and
> the latter runs the BPF program. Maybe I'm missing something here
> though? However I think we need to give the user ways to minimize
> the cost of breakpoint placement where possible. See below...
>
> > > Similarly "attach to all processes" doesn't sound right either.
> > > It's attached to all current and future processes.
> >
>
> True, will fix for the next version.
>
> I think for users it'd be good to clarify what the overheads are. If I
> want to see malloc()s in a particular process, say I specify the libc
> path along with the process ID I'm interested in.  This adds the
> breakpoint to libc and will - as far as I understand it - trigger
> breakpoints system-wide which are then filtered out by uprobe perf handling
> for the specific process specified.  That's pretty expensive
> performance-wise, so we should probably try and give users options to
> limit the cost in cases where they don't want to incur system-wide
> overheads. I've been investigating adding support for instrumenting shared
> library calls _within_ programs by placing the breakpoint on the procedure
> linking table call associated with the function.  As this is local to the

You mean to patch PLT stubs ([0])? One concern with that is (besides
making sure that pt_regs still have exactly the same semantics and
stuff) that uprobes are much faster when patching nop instructions (if
the library was compiled with nop "preambles". Do you know if @plt
entries can be compiled with nops as well? The difference in
performance is more than 2x from my non-scientific testing recently.
So it can be a pretty big difference.

  [0] https://www.technovelty.org/linux/plt-and-got-the-key-to-code-sharing-and-dynamic-libraries.html

> program, it will only have an effect on malloc()s in that specific
> program.  So the next version will have a solution which allows us to
> trace malloc() in /usr/bin/foo as well as in libc. Thanks!
>
> Alan
