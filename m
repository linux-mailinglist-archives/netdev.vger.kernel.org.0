Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874A13AE387
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 08:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhFUGxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 02:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFUGxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 02:53:23 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670E1C061574;
        Sun, 20 Jun 2021 23:51:08 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id w21so14009987qkb.9;
        Sun, 20 Jun 2021 23:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P/Jd69LAIaulebYjXEri4xk253ZJaVKSOVRKmX5VtLw=;
        b=rbDG3wWTV+6uq15QI2c1+Pzt7ZUGxEWWqfHK5rch8C1P+GhjS4mwnd7EiXj44MX3F4
         75pgBhyyi3GgUr9PkGNOD7lHVAVH5at0adzzsHKN11A6hjMU0h7eh96RI4f8wrfXaUUN
         E+gJTfOr3HKrpS/dbJ65i1FHChVE35Fzy1f2uUwZxIViH1QNYwUGUxa55kQRSmp9IxiJ
         vt4eUadxCwTVrGOT3702dxb1FHO1yLwUa5oA4S3Y5PYql7TwBi9gktTWbx1OxaXAJE/a
         uUAl/5cBbeEcjxeHkyryDnn4N0GCPDK9Zoo1XnlL/iDf1OzCy30TI8/K7XFaJuaoQAwv
         Kwgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P/Jd69LAIaulebYjXEri4xk253ZJaVKSOVRKmX5VtLw=;
        b=XTiRHYfzF4vvdR8F8vF6E+SkEX2Dtul/Rq6OtS7rx1zOxhFnBiLEvabDqNCoMUIAfN
         vvbPDEl3Ng7HJ6vMACe0vBCIluAoN9RYupTJBD0PXTGIyFVVLigK1MvXak5NtpaGFIGt
         emtu3y2LNi12FASKkgnSamKaHp3TDFhLR3YSEhrE+6Mx2L631O6F+p3RMfxigmhImDYm
         RtCGQLwDjPbnTFVlRXUbKW2u2/s9GBPuX5F7EyHnGA8kUIwQGUWG+7NPxaabQp3CWsjJ
         HwCPG/mLxsJ8ZGERRheRuce6tSjXfeGN6zLKmu3itKBjhlaVRP198zvLUALSubmWeymC
         HdNw==
X-Gm-Message-State: AOAM533Wg/SLVenpxY/lqv3amOwDpyB5CtaW7mmgo1wj+1RfRx02Gr8q
        WBcwE9TafnoEn0ilwbpBg8nK+M62bLr7h1df1mo=
X-Google-Smtp-Source: ABdhPJwkHoocM+N5V6xVmyyV+rXwk+Hcflcx3RAkkFhjRCNyjl9ykduMipWEBH65st2mQPKARZndFwhnrrL3LV3NQZA=
X-Received: by 2002:a25:1455:: with SMTP id 82mr30210550ybu.403.1624258267361;
 Sun, 20 Jun 2021 23:51:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210605111034.1810858-1-jolsa@kernel.org> <CAEf4BzaK+t7zom6JHWf6XSPGDxjwhG4Wj3+CHKVshdmP3=FgnA@mail.gmail.com>
 <YM2r139rHuXialVG@krava>
In-Reply-To: <YM2r139rHuXialVG@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Jun 2021 09:50:56 +0300
Message-ID: <CAEf4BzaCXG=Z4F=WQCZVRQFq2zYeY_tmxRVpOtZpgJ2Y+sVLgw@mail.gmail.com>
Subject: Re: [RFCv3 00/19] x86/ftrace/bpf: Add batch support for
 direct/tracing attach
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 19, 2021 at 11:33 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Jun 17, 2021 at 01:29:45PM -0700, Andrii Nakryiko wrote:
> > On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > hi,
> > > saga continues.. ;-) previous post is in here [1]
> > >
> > > After another discussion with Steven, he mentioned that if we fix
> > > the ftrace graph problem with direct functions, he'd be open to
> > > add batch interface for direct ftrace functions.
> > >
> > > He already had prove of concept fix for that, which I took and broke
> > > up into several changes. I added the ftrace direct batch interface
> > > and bpf new interface on top of that.
> > >
> > > It's not so many patches after all, so I thought having them all
> > > together will help the review, because they are all connected.
> > > However I can break this up into separate patchsets if necessary.
> > >
> > > This patchset contains:
> > >
> > >   1) patches (1-4) that fix the ftrace graph tracing over the function
> > >      with direct trampolines attached
> > >   2) patches (5-8) that add batch interface for ftrace direct function
> > >      register/unregister/modify
> > >   3) patches (9-19) that add support to attach BPF program to multiple
> > >      functions
> > >
> > > In nutshell:
> > >
> > > Ad 1) moves the graph tracing setup before the direct trampoline
> > > prepares the stack, so they don't clash
> > >
> > > Ad 2) uses ftrace_ops interface to register direct function with
> > > all functions in ftrace_ops filter.
> > >
> > > Ad 3) creates special program and trampoline type to allow attachment
> > > of multiple functions to single program.
> > >
> > > There're more detailed desriptions in related changelogs.
> > >
> > > I have working bpftrace multi attachment code on top this. I briefly
> > > checked retsnoop and I think it could use the new API as well.
> >
> > Ok, so I had a bit of time and enthusiasm to try that with retsnoop.
> > The ugly code is at [0] if you'd like to see what kind of changes I
> > needed to make to use this (it won't work if you check it out because
> > it needs your libbpf changes synced into submodule, which I only did
> > locally). But here are some learnings from that experiment both to
> > emphasize how important it is to make this work and how restrictive
> > are some of the current limitations.
> >
> > First, good news. Using this mass-attach API to attach to almost 1000
> > kernel functions goes from
> >
> > Plain fentry/fexit:
> > ===================
> > real    0m27.321s
> > user    0m0.352s
> > sys     0m20.919s
> >
> > to
> >
> > Mass-attach fentry/fexit:
> > =========================
> > real    0m2.728s
> > user    0m0.329s
> > sys     0m2.380s
>
> I did not meassured the bpftrace speedup, because the new code
> attached instantly ;-)
>
> >
> > It's a 10x speed up. And a good chunk of those 2.7 seconds is in some
> > preparatory steps not related to fentry/fexit stuff.
> >
> > It's not exactly apples-to-apples, though, because the limitations you
> > have right now prevents attaching both fentry and fexit programs to
> > the same set of kernel functions. This makes it pretty useless for a
>
> hum, you could do link_update with fexit program on the link fd,
> like in the selftest, right?

Hm... I didn't realize we can attach two different prog FDs to the
same link, honestly (and was too lazy to look through selftests
again). I can try that later. But it's actually quite a
counter-intuitive API (I honestly assumed that link_update can be used
to add more BTF IDs, but not change prog_fd). Previously bpf_link was
always associated with single BPF prog FD. It would be good to keep
that property in the final version, but we can get back to that later.

>
> > lot of cases, in particular for retsnoop. So I haven't really tested
> > retsnoop end-to-end, I only verified that I do see fentries triggered,
> > but can't have matching fexits. So the speed-up might be smaller due
> > to additional fexit mass-attach (once that is allowed), but it's still
> > a massive difference. So we absolutely need to get this optimization
> > in.
> >
> > Few more thoughts, if you'd like to plan some more work ahead ;)
> >
> > 1. We need similar mass-attach functionality for kprobe/kretprobe, as
> > there are use cases where kprobe are more useful than fentry (e.g., >6
> > args funcs, or funcs with input arguments that are not supported by
> > BPF verifier, like struct-by-value). It's not clear how to best
> > represent this, given currently we attach kprobe through perf_event,
> > but we'll need to think about this for sure.
>
> I'm fighting with the '2 trampolines concept' at the moment, but the
> mass attach for kprobes seems interesting ;-) will check
>
> >
> > 2. To make mass-attach fentry/fexit useful for practical purposes, it
> > would be really great to have an ability to fetch traced function's
> > IP. I.e., if we fentry/fexit func kern_func_abc, bpf_get_func_ip()
> > would return IP of that functions that matches the one in
> > /proc/kallsyms. Right now I do very brittle hacks to do that.
>
> so I hoped that we could store ip always in ctx-8 and have
> the bpf_get_func_ip helper to access that, but the BPF_PROG
> macro does not pass ctx value to the program, just args
>
> we could perhaps somehow store the ctx in BPF_PROG before calling
> the bpf program, but I did not get to try that yet
>
> >
> > So all-in-all, super excited about this, but I hope all those issues
> > are addressed to make retsnoop possible and fast.
> >
> >   [0] https://github.com/anakryiko/retsnoop/commit/8a07bc4d8c47d025f755c108f92f0583e3fda6d8
>
> thanks for checking on this,
> jirka
>
