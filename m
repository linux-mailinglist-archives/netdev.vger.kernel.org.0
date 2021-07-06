Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCC13BDE6E
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 22:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhGFU3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 16:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhGFU3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 16:29:37 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166EAC061574;
        Tue,  6 Jul 2021 13:26:58 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id s129so36266560ybf.3;
        Tue, 06 Jul 2021 13:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GbBVrkqrY93F9sj6B+OAwUYv/es7dMOikfT/GTPkWtw=;
        b=P5zmEyx+5khyJv4gDRe4GvwcZsf9VNiOrdMVXbUanspQSwC2vUY2ZsVLBTK7SYFtkc
         FM/FdhNw7MCiyRBqmbawSf+v9av0Rpp4CLtMHCYYSPLL+0nvKMQKl9dR4bVFHleB/IQt
         Efv8WIfwZyoY4yTYiKHs982qssXl+JrsxBJGKwvbKMbHbxIiMMBXDdZSB/D/opDW4vt4
         cp2GAndEAcs/9SFgrZPevqtKIMGYLZDJfPqYUwO14DEcJ9aVxcjG0XBN8dQwa7xyF9iE
         ug4GuS85abEluxn6n9yyKCIVrWI5ImwLV9sntlrdmCNxYC0lexQa7wRgUxusCuWNt23I
         moLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GbBVrkqrY93F9sj6B+OAwUYv/es7dMOikfT/GTPkWtw=;
        b=YRZkwKxZuzbzt70RkMHJ3hbTl3spcxndFgSEUHQLv6x0kFcsEvaGoBRD3GdRzJGp5U
         VgdvQi8/AGZ32P0rVbEQ50zS/5hlG5SZd45ZbeU0dHDR4y5f4yBty49KoPcR0OMihLA2
         6z17K6UU64hEoTPO3NjzabcPA0ylsNTWddS6uWTD9o8xJN04loT3yBjH2iMKOp/VQH8x
         ytk9hNK57BofF4a+87LtD4ZLTt/TLx2mHyAVJCP/7DMucJs7dxms/J2UIvEydI6mlOGn
         FtGF01TXhyl5inF7ASaxNSEWnuLbuk6qA0hnD4JL8d5KZ5K2WJENTMpOuHCf81CSLmbi
         l5kA==
X-Gm-Message-State: AOAM530JIkTg/6CJ5qnupJ/fak4J32tVhv9Ndj9icBme9n7Of4FKy31g
        WlpcIBN0KxNfvDFP1yPbffsksBUs7iU2DPZIiys=
X-Google-Smtp-Source: ABdhPJxcjCtfoLauTkuID+GsbEsqU07auAZQzuTnWYO3q2bs42dr9m7JLJspXVmMnkF1akHLatwz7vm6TeiYAFOTnE8=
X-Received: by 2002:a25:3787:: with SMTP id e129mr26439876yba.459.1625603217306;
 Tue, 06 Jul 2021 13:26:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210605111034.1810858-1-jolsa@kernel.org> <CAEf4BzaK+t7zom6JHWf6XSPGDxjwhG4Wj3+CHKVshdmP3=FgnA@mail.gmail.com>
 <YM2r139rHuXialVG@krava> <CAEf4BzaCXG=Z4F=WQCZVRQFq2zYeY_tmxRVpOtZpgJ2Y+sVLgw@mail.gmail.com>
In-Reply-To: <CAEf4BzaCXG=Z4F=WQCZVRQFq2zYeY_tmxRVpOtZpgJ2Y+sVLgw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Jul 2021 13:26:46 -0700
Message-ID: <CAEf4BzaGdD=B5qcaraSKVpNp_NQLBLLxiCsLEQB-0i7JxxA_Bw@mail.gmail.com>
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

On Sun, Jun 20, 2021 at 11:50 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Jun 19, 2021 at 11:33 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Thu, Jun 17, 2021 at 01:29:45PM -0700, Andrii Nakryiko wrote:
> > > On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > hi,
> > > > saga continues.. ;-) previous post is in here [1]
> > > >
> > > > After another discussion with Steven, he mentioned that if we fix
> > > > the ftrace graph problem with direct functions, he'd be open to
> > > > add batch interface for direct ftrace functions.
> > > >
> > > > He already had prove of concept fix for that, which I took and broke
> > > > up into several changes. I added the ftrace direct batch interface
> > > > and bpf new interface on top of that.
> > > >
> > > > It's not so many patches after all, so I thought having them all
> > > > together will help the review, because they are all connected.
> > > > However I can break this up into separate patchsets if necessary.
> > > >
> > > > This patchset contains:
> > > >
> > > >   1) patches (1-4) that fix the ftrace graph tracing over the function
> > > >      with direct trampolines attached
> > > >   2) patches (5-8) that add batch interface for ftrace direct function
> > > >      register/unregister/modify
> > > >   3) patches (9-19) that add support to attach BPF program to multiple
> > > >      functions
> > > >
> > > > In nutshell:
> > > >
> > > > Ad 1) moves the graph tracing setup before the direct trampoline
> > > > prepares the stack, so they don't clash
> > > >
> > > > Ad 2) uses ftrace_ops interface to register direct function with
> > > > all functions in ftrace_ops filter.
> > > >
> > > > Ad 3) creates special program and trampoline type to allow attachment
> > > > of multiple functions to single program.
> > > >
> > > > There're more detailed desriptions in related changelogs.
> > > >
> > > > I have working bpftrace multi attachment code on top this. I briefly
> > > > checked retsnoop and I think it could use the new API as well.
> > >
> > > Ok, so I had a bit of time and enthusiasm to try that with retsnoop.
> > > The ugly code is at [0] if you'd like to see what kind of changes I
> > > needed to make to use this (it won't work if you check it out because
> > > it needs your libbpf changes synced into submodule, which I only did
> > > locally). But here are some learnings from that experiment both to
> > > emphasize how important it is to make this work and how restrictive
> > > are some of the current limitations.
> > >
> > > First, good news. Using this mass-attach API to attach to almost 1000
> > > kernel functions goes from
> > >
> > > Plain fentry/fexit:
> > > ===================
> > > real    0m27.321s
> > > user    0m0.352s
> > > sys     0m20.919s
> > >
> > > to
> > >
> > > Mass-attach fentry/fexit:
> > > =========================
> > > real    0m2.728s
> > > user    0m0.329s
> > > sys     0m2.380s
> >
> > I did not meassured the bpftrace speedup, because the new code
> > attached instantly ;-)
> >
> > >
> > > It's a 10x speed up. And a good chunk of those 2.7 seconds is in some
> > > preparatory steps not related to fentry/fexit stuff.
> > >
> > > It's not exactly apples-to-apples, though, because the limitations you
> > > have right now prevents attaching both fentry and fexit programs to
> > > the same set of kernel functions. This makes it pretty useless for a
> >
> > hum, you could do link_update with fexit program on the link fd,
> > like in the selftest, right?
>
> Hm... I didn't realize we can attach two different prog FDs to the
> same link, honestly (and was too lazy to look through selftests
> again). I can try that later. But it's actually quite a
> counter-intuitive API (I honestly assumed that link_update can be used
> to add more BTF IDs, but not change prog_fd). Previously bpf_link was
> always associated with single BPF prog FD. It would be good to keep
> that property in the final version, but we can get back to that later.

Ok, I'm back from PTO and as a warm-up did a two-line change to make
retsnoop work end-to-end using this bpf_link_update() approach. See
[0]. I still think it's a completely confusing API to do
bpf_link_update() to have both fexit and fentry, but it worked for
this experiment.

BTW, adding ~900 fexit attachments is barely noticeable, which is
great, means that attachment is instantaneous.

real    0m2.739s
user    0m0.351s
sys     0m2.370s

  [0] https://github.com/anakryiko/retsnoop/commit/c915d729d6e98f83601e432e61cb1bdf476ceefb

>
> >
> > > lot of cases, in particular for retsnoop. So I haven't really tested
> > > retsnoop end-to-end, I only verified that I do see fentries triggered,
> > > but can't have matching fexits. So the speed-up might be smaller due
> > > to additional fexit mass-attach (once that is allowed), but it's still
> > > a massive difference. So we absolutely need to get this optimization
> > > in.
> > >
> > > Few more thoughts, if you'd like to plan some more work ahead ;)
> > >
> > > 1. We need similar mass-attach functionality for kprobe/kretprobe, as
> > > there are use cases where kprobe are more useful than fentry (e.g., >6
> > > args funcs, or funcs with input arguments that are not supported by
> > > BPF verifier, like struct-by-value). It's not clear how to best
> > > represent this, given currently we attach kprobe through perf_event,
> > > but we'll need to think about this for sure.
> >
> > I'm fighting with the '2 trampolines concept' at the moment, but the
> > mass attach for kprobes seems interesting ;-) will check
> >
> > >
> > > 2. To make mass-attach fentry/fexit useful for practical purposes, it
> > > would be really great to have an ability to fetch traced function's
> > > IP. I.e., if we fentry/fexit func kern_func_abc, bpf_get_func_ip()
> > > would return IP of that functions that matches the one in
> > > /proc/kallsyms. Right now I do very brittle hacks to do that.
> >
> > so I hoped that we could store ip always in ctx-8 and have
> > the bpf_get_func_ip helper to access that, but the BPF_PROG
> > macro does not pass ctx value to the program, just args
> >
> > we could perhaps somehow store the ctx in BPF_PROG before calling
> > the bpf program, but I did not get to try that yet
> >
> > >
> > > So all-in-all, super excited about this, but I hope all those issues
> > > are addressed to make retsnoop possible and fast.
> > >
> > >   [0] https://github.com/anakryiko/retsnoop/commit/8a07bc4d8c47d025f755c108f92f0583e3fda6d8
> >
> > thanks for checking on this,
> > jirka
> >
