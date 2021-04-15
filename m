Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8269F3613AF
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 22:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhDOUpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 16:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbhDOUpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 16:45:43 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6153DC061574;
        Thu, 15 Apr 2021 13:45:18 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id p3so7002281ybk.0;
        Thu, 15 Apr 2021 13:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=adz9UvuviWrBM9o1jkC+ykOt4rkNk9aXVQRYxt11Bp8=;
        b=M0K6+SgQ045X4XVjE4dSInxh/1Y4mMlWP5XwQ1Y2aEOSKWd0sgsDFsWz1AU3zM49ou
         v1puR9O4y6NS9erk0TjkeHALtRsxBN3ce/037s3vSdW6YWXJ0UQp7wB8xn7w1yViRi1c
         J5M4BhyM8i82cPviExR+WI0onsbwd5SS0XRq8pc1EZQMd4hU+4X6/ihH+RjQMUDK+ghq
         0aalfVcEMKufeKskkmpLKG7/QMgibFgINf95fDfRG4JKQRvQoxvEmSSJ2md3sDPY/gzf
         /Me/qylGT7GNU0Z0aXigykgPRUSda0z9jv98jraiZqXTRLF2GM9ySpV012oGy1VqjlX5
         w2Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=adz9UvuviWrBM9o1jkC+ykOt4rkNk9aXVQRYxt11Bp8=;
        b=JYOvmcwCmD6UYfN2FIIxsiGvGFLYf42xTBN1vR7VE0bK+q03R/9ijoFtKhsbLqcPBM
         Ot2Vf46nUJwBU7lN307EmrOYHWAqDy0XEP2u+bzyXb00sQ+/aT6ld9dIGh9LyRtixekv
         Z10C2jhtDIfzUKtQRbEYz5jLsUpZF2fF9Pg0F29Fz9D0KC83vaf2ai7HphXQruxn3BHt
         Sa2s62uAGLxSffRq/7aRuG+xCyiOrLYDGXIFga1H030CBYEQZJDJZlkwNxZFs/UlT67D
         B4MpCFm+IuebdfrQo0SqPd9hRpXiqjxCg73X5YwFf+pAs+EThDCouGvOGxbFavSnsOni
         /yKw==
X-Gm-Message-State: AOAM530Sc1XElC16I5OC5YmV+T+FqDN3BDmw6S3olNxBtsZNWIZQ+sq8
        SxI6c3SSjpJ6k67Uwx6Bgssf5zRRoKnCKQg3Pl8=
X-Google-Smtp-Source: ABdhPJykJJixY3ITtHFbBxIVcwg8MQ5MBTllZdbtxbKPrdzrBYKQ5Yu4dCrMw3ur1kkqzEAlHE/u6vBvBBvNLsOFp/0=
X-Received: by 2002:a25:5b55:: with SMTP id p82mr7151528ybb.510.1618519517668;
 Thu, 15 Apr 2021 13:45:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210413121516.1467989-1-jolsa@kernel.org> <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
 <YHbd2CmeoaiLJj7X@krava> <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
 <20210415111002.324b6bfa@gandalf.local.home>
In-Reply-To: <20210415111002.324b6bfa@gandalf.local.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Apr 2021 13:45:06 -0700
Message-ID: <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
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

On Thu, Apr 15, 2021 at 8:10 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 14 Apr 2021 15:46:49 -0700
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > On Wed, Apr 14, 2021 at 5:19 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Tue, Apr 13, 2021 at 06:04:05PM -0700, Andrii Nakryiko wrote:
> > > > On Tue, Apr 13, 2021 at 7:57 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > > >
> > > > > hi,
> > > > > sending another attempt on speeding up load of multiple probes
> > > > > for bpftrace and possibly other tools (first post in [1]).
> > > > >
> > > > > This patchset adds support to attach bpf program directly to
> > > > > ftrace probe as suggested by Steven and it speeds up loading
> > > > > for bpftrace commands like:
> > > > >
> > > > >    # bpftrace -e 'kfunc:_raw_spin* { @[probe] = count(); }'
> > > > >    # bpftrace -e 'kfunc:ksys_* { @[probe] = count(); }'
> > > > >
> > > > > Using ftrace with single bpf program for attachment to multiple
> > > > > functions is much faster than current approach, where we need to
> > > > > load and attach program for each probe function.
> > > > >
> > > >
> > > > Ok, so first of all, I think it's super important to allow fast
> > > > attachment of a single BPF program to multiple kernel functions (I
> > > > call it mass-attachment). I've been recently prototyping a tool
> > > > (retsnoop, [0]) that allows attaching fentry/fexit to multiple
> > > > functions, and not having this feature turned into lots of extra code
> > > > and slow startup/teardown speeds. So we should definitely fix that.
> > > >
> > > > But I think the approach you've taken is not the best one, even though
> > > > it's a good starting point for discussion.
> > > >
> > > > First, you are saying function return attachment support is missing,
> > > > but is not needed so far. I actually think that without func return
> > > > the whole feature is extremely limiting. Not being able to measure
> > > > function latency  by tracking enter/exit events is crippling for tons
> > > > of useful applications. So I think this should go with both at the
> > > > same time.
> > > >
> > > > But guess what, we already have a good BPF infra (BPF trampoline and
> > > > fexit programs) that supports func exit tracing. Additionally, it
> > > > supports the ability to read input arguments *on function exit*, which
> > > > is something that kretprobe doesn't support and which is often a very
> > > > limiting restriction, necessitating complicated logic to trace
> > > > function entry just to store input arguments. It's a killer feature
> > > > and one that makes fexit so much more useful than kretprobe.
> > > >
> > > > The only problem is that currently we have a 1:1:1 relationship
> > > > between BPF trampoline, BPF program, and kernel function. I think we
> > > > should allow to have a single BPF program, using a single BPF
> > > > trampoline, but being able to attach to multiple kernel functions
> > > > (1:1:N). This will allow to validate BPF program once, allocate only
> > > > one dedicated BPF trampoline, and then (with appropriate attach API)
> > > > attach them in a batch mode.
> > >
> > > heya,
> > > I had some initial prototypes trying this way, but always ended up
> > > in complicated code, that's why I turned to ftrace_ops.
> > >
> > > let's see if it'll make any sense to you ;-)
> > >
> > > 1) so let's say we have extra trampoline for the program (which
> > > also seems a bit of waste since there will be just single record
> >
> > BPF trampoline does more than just calls BPF program. At the very
> > least it saves input arguments for fexit program to be able to access
> > it. But given it's one BPF trampoline attached to thousands of
> > functions, I don't see any problem there.
>
> Note, there's a whole infrastructure that does similar things in ftrace.
> I wrote the direct call to jump to individual trampolines, because ftrace
> was too generic. The only way at the time to get to the arguments was via
> the ftrace_regs_caller, which did a full save of regs, because this was
> what kprobes needed, and was too expensive for BPF.
>
> I now regret writing the direct callers, and instead should have just done
> what I did afterward, which was to make ftrace default to a light weight
> trampoline that only saves enough for getting access to the arguments of
> the function. And have BPF use that. But I was under the impression that
> BPF needed fast access to a single function, and it would not become a
> generic trampoline for multiple functions, because that was the argument
> used to not enhance ftrace.
>
> Today, ftrace by dafault (on x86) implements a generic way to get the
> arguments, and just the arguments which is exactly what BPF would need for
> multiple functions. And yes, you even have access to the return code if you
> want to "hijack" it. And since it was originally for a individual functions
> (and not a batch), I created the direct caller for BPF. But the direct
> caller will not be enhanced for multiple functions, as that's not its
> purpose. If you want a trampoline to be called back to multiple functions,
> then use the infrastructure that was designed for that. Which is what Jiri
> had proposed here.
>
> And because the direct caller can mess with the return code, it breaks
> function graph tracing. As a temporary work around, we just made function
> graph ignore any function that has a direct caller attached to it.
>
> If you want batch processing of BPF programs, you need to first fix the
> function graph tracing issue, and allow both BPF attached callers and
> function graph to work on the same functions.
>
> I don't know how the BPF code does it, but if you are tracing the exit
> of a function, I'm assuming that you hijack the return pointer and replace
> it with a call to a trampoline that has access to the arguments. To do

As Jiri replied, BPF trampoline doesn't do it the same way as
kretprobe does it. Which gives the fexit BPF program another critical
advantage over kretprobe -- we know traced function's entry IP in both
entry and exit cases, which allows us to generically correlate them.

I've tried to figure out how to get that entry IP from kretprobe and
couldn't find any way. Do you know if it's possible at all or it's a
fundamental limitation of the way kretprobe is implemented (through
hijacking return address)?

> this you need a shadow stack to save the real return as well as the
> parameters of the function. This is something that I have patches that do
> similar things with function graph.
>
> If you want this feature, lets work together and make this work for both
> BPF and ftrace.

Absolutely, ultimately for users it doesn't matter what specific
mechanism is used under the cover. It just seemed like BPF trampoline
has all the useful tracing features (entry IP and input arguments in
fexit) already and is just mostly missing a quick batch attach API. If
we can get the same from ftrace, all the better.

>
> -- Steve
