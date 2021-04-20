Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07EB36628C
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 01:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbhDTXjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 19:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234438AbhDTXjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 19:39:31 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D651BC061763;
        Tue, 20 Apr 2021 16:38:58 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id n138so64189225lfa.3;
        Tue, 20 Apr 2021 16:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5881XH3ZBW3PZMla4/C/2vdBEBn0QBC47+hiApR9+4k=;
        b=kiBmGlX6J9slhnhA7CHbH1RE/KVZaEcHhxqOfZ0hdRR45zM8Zq0pdLEOyg3z6u6ao0
         pZuzXlQtuAGmWn4vrlcDOjLcE9i1Hh4R/0dF1IfZiXnbvo3T5rYV7YP8Mv3XJl/pQn/C
         2kOImDT7tT+5/vRA9LGNlS84PD1uPKb+1ydzExG36B8Tx6acn54bWdepjHb1RtZ42xww
         J1ORthena89jfLW+bxZy6TG26HOs09lQa0WOat7dbnubcwlZg2Qy4hMJQlcauQHZV4YB
         iDMVlTY4Uh/32O0868bGlVC0G78zXZ5n8YeiSaklandwN+kufX3IftSb8usyC03Wcyau
         8Xdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5881XH3ZBW3PZMla4/C/2vdBEBn0QBC47+hiApR9+4k=;
        b=ckkQCBgsDySt1eFD+1c3QeIakYsDwbqyovwd4/hdH8F2J8gkDLiOtplenqox3Cl9yI
         JEImbIlIYG9CY8ngaOtxIWESWxmGiR/WaKQIdaUZKXPWY3lStiaiSReSZV9ofIcrG3UJ
         jL4vcsW6uGSR25bXlGcqOd1DHkqX7nlbzNolYYEJyIWUs7cxE6fTGBGg6D/Fdu2Ja9yA
         IJ++Hc4am1CF4oNFhutQQLswOk71adjh+29SK9yKSn3cJF0QiKQaWPLeEir+08viWwrU
         OAgxiF46O9Kf8G/I1//tIw7+aKqmI3TdP/Gs/NbUADDmEt+ThD7pOzVLrRX2Yt5iLrRB
         t9ww==
X-Gm-Message-State: AOAM531Z3LQKmiFgAhJL/CBXA+dTh275BiVu199FUDAPJm9CSZV/661s
        yeSWoPwyw5YfJ725iIqzCxEir877lL6nkqQqzxw=
X-Google-Smtp-Source: ABdhPJyKVa4dquqlSn1PfPDjtZIdaXOOqApg/aaa/2tQCL9TykwNwR4ebOdwTXMs6nX18KrcpPHADUn/lUC9ByXr2k0=
X-Received: by 2002:a05:6512:3f93:: with SMTP id x19mr17529133lfa.182.1618961936863;
 Tue, 20 Apr 2021 16:38:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
 <YHbd2CmeoaiLJj7X@krava> <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
 <20210415111002.324b6bfa@gandalf.local.home> <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
 <20210415170007.31420132@gandalf.local.home> <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
 <20210416124834.05862233@gandalf.local.home> <YH7OXrjBIqvEZbsc@krava>
 <CAADnVQK55WzR6_JfxkMzEfUnLJnX75bRHjCkaptcVF=nQ_gWfw@mail.gmail.com> <YH8GxNi5VuYjwNmK@krava>
In-Reply-To: <YH8GxNi5VuYjwNmK@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 20 Apr 2021 16:38:45 -0700
Message-ID: <CAADnVQLh3tCWi=TiWnJVaMrYhJ=j-xSrJ72+XnZDP8CMZM+1mQ@mail.gmail.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 9:52 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Apr 20, 2021 at 08:33:43AM -0700, Alexei Starovoitov wrote:
> > On Tue, Apr 20, 2021 at 5:51 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Fri, Apr 16, 2021 at 12:48:34PM -0400, Steven Rostedt wrote:
> > > > On Sat, 17 Apr 2021 00:03:04 +0900
> > > > Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > > >
> > > > > > Anyway, IIRC, Masami wasn't sure that the full regs was ever needed for the
> > > > > > return (who cares about the registers on return, except for the return
> > > > > > value?)
> > > > >
> > > > > I think kretprobe and ftrace are for a bit different usage. kretprobe can be
> > > > > used for something like debugger. In that case, accessing full regs stack
> > > > > will be more preferrable. (BTW, what the not "full regs" means? Does that
> > > > > save partial registers?)
> > > >
> > > > When the REGS flag is not set in the ftrace_ops (where kprobes uses the
> > > > REGS flags), the regs parameter is not a full set of regs, but holds just
> > > > enough to get access to the parameters. This just happened to be what was
> > > > saved in the mcount/fentry trampoline, anyway, because tracing the start of
> > > > the program, you had to save the arguments before calling the trace code,
> > > > otherwise you would corrupt the parameters of the function being traced.
> > > >
> > > > I just tweaked it so that by default, the ftrace callbacks now have access
> > > > to the saved regs (call ftrace_regs, to not let a callback get confused and
> > > > think it has full regs when it does not).
> > > >
> > > > Now for the exit of a function, what does having the full pt_regs give you?
> > > > Besides the information to get the return value, the rest of the regs are
> > > > pretty much meaningless. Is there any example that someone wants access to
> > > > the regs at the end of a function besides getting the return value?
> > >
> > > for ebpf program attached to the function exit we need the functions's
> > > arguments.. so original registers from time when the function was entered,
> > > we don't need registers state at the time function is returning
> > >
> > > as we discussed in another email, we could save input registers in
> > > fgraph_ops entry handler and load them in exit handler before calling
> > > ebpf program
> >
> > I don't see how you can do it without BTF.
> > The mass-attach feature should prepare generic 6 or so arguments
> > from all functions it attached to.
> > On x86-64 it's trivial because 6 regs are the same.
> > On arm64 is now more challenging since return value regs overlaps with
> > first argument, so bpf trampoline (when it's ready for arm64) will look
> > a bit different than bpf trampoline on x86-64 to preserve arg0, arg1,
> > ..arg6, ret
> > 64-bit values that bpf prog expects to see.
> > On x86-32 it's even more trickier, since the same 6 args need to be copied
> > from a combination of regs and stack.
> > This is not some hypothetical case. We already use BTF in x86-32 JIT
> > and btf_func_model was introduced specifically to handle such cases.
> > So I really don't see how ftrace can do that just yet. It has to understand BTF
> > of all of the funcs it attaches to otherwise it's just saving all regs.
> > That approach was a pain to deal with.
>
> ok, my idea was to get regs from the ftrace and have arch specific code
> to prepare 6 (or less) args for ebpf program.. that part would be
> already in bpf code
>
> so you'd like to see this functionality directly in ftrace, so we don't
> save unneeded regs, is that right?

What do you mean by "already in bpf code" ?

The main question is an api across layers.
If ftrace doesn't use BTF it has to prepare all regs that could be used.
Meaning on x86-64 that has to be 6 regs for args, 1 reg for return and
stack pointer.
That would be enough to discover input args and return value in fexit.
On arm64 that has to be similar, but while x86-64 can do with single pt_regs
where %rax is updated on fexit, arm64 cannot do so, since the same register
is used as arg1 and as a return value.
The most generic api between ftrace and bpf layers would be two sets of
pt_regs. One on entry and one on exit, but that's going to be very expensive.
On x86-32 it would have to be 3 regs plus stack pointer and another 2 regs
to cover all input args and return value.
So there will be plenty of per-arch differences.

Jiri, if you're thinking of a bpf helper like:
u64 bpf_read_argN(pt_regs, ip, arg_num)
that will do lookup of btf_id from ip, then it will parse btf_id and
function proto,
then it will translate that to btf_func_model and finally will extract the right
argument value from a combination of stack and regs ?
That's doable, but it's a lot of run-time overhead.
It would be usable by bpf progs that don't care much about run-time perf
and don't care that they're not usable 24/7 on production systems.
Such tools exist and they're useful,
but I'd like this mass-attach facility to be usable everywhere
including the production and 24/7 tracing.
Hence I think it's better to do this per-arch translation during bpf
prog attach.
That's exactly what bpf trampoline is doing.
Currently it's doing for single btf_id, single trampoline, and single bpf prog.
To make the same logic work across N attach points the trampoline logic
would need to iterate all btf_func_model-s of all btf_id-s and generate
M trampolines (where M < N) for a combination of possible argument passing.
On x86-64 the M will be equal to 1. On arm64 it will be equal to 1 as well.
But on x86-32 it will depend on a set of btf_ids. It could be 1,2,..10.
Since bpf doesn't allow to attach to struct-by-value it's only 32-bit and 64-bit
integers to deal with and number of combinations of possible calling conventions
is actually very small. I suspect it won't be more than 10.
This way there will be no additional run-time overhead and bpf programs
can be portable. They will work as-is on x86-64, x86-32, arm64.
Just like fentry/fexit work today. Or rather they will be portable
when bpf trampoline is supported on these archs.
This portability is the key feature of bpf trampoline design. The bpf trampoline
was implemented for x86-64 only so far. Arm64 patches are still wip.
btf_func_model is used by both x86-64 and x86-32 JITs.
