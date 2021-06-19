Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C383ADB0B
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 19:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbhFSRLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 13:11:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59435 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234871AbhFSRLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 13:11:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624122574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GazjCUZzE89eAD8Q8Aisfx3nlAR2cPP6gAa3WvGzdhg=;
        b=ilhEXZGvrAqKSNekx6MOo4rqxnddaMzVZj8C3aqPTSHLcU49Pn5rlu7NbS/YgSN6gxbY3e
        yWW9PkA6MptQBp0pIoS0PbYvEjtjcVvkv/Ag/oNgK/iJBZY9/X/lQWYm5Cjg1CYpAnsjlc
        BOpL0pptP5BfF1nJ9Pbv1REjosAdzvM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-y3I1RirNOKKjzH2CayIcKA-1; Sat, 19 Jun 2021 13:09:32 -0400
X-MC-Unique: y3I1RirNOKKjzH2CayIcKA-1
Received: by mail-wr1-f72.google.com with SMTP id y12-20020adffa4c0000b0290119c11bd29eso6192656wrr.2
        for <netdev@vger.kernel.org>; Sat, 19 Jun 2021 10:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GazjCUZzE89eAD8Q8Aisfx3nlAR2cPP6gAa3WvGzdhg=;
        b=QFYKmpHzr6tXlBRZv2OKDb2zhOGkqsh5W2vG6Ug+EoEf3nCsqAG0lD6B50uCjqjj7U
         AC2hIWom4mtDbEr+CW50KpX/yuadlwJGGPdSsYVmPUi7JsyJoFhYdYs38VO8vqKC9/tE
         pHh+OgpGem96Ztq6v7Frl6W76Eege2ewLEI+6ZbsLG/YEQfULBFgqi+SYFprWw6W/369
         o/f7J382LHqBfK2ol2o1SptXtdHBUVuw4SS71ougmrdUTWZgB2D+5xoeLCiM37WFdKYe
         E5DSPDWXH4bsMq1pz5tKV7SG0uLiZNLL/OUDpyKTqHV9db/p2y7UzCLmnnf4XpWMvdS/
         rB7g==
X-Gm-Message-State: AOAM532U2jpYh712q+f2bxbKUB2sFB/TjN0M2yypx2wCH/eYQ/JLZU7A
        I0f+scvu5pPNa+El9gfI658Mfwv3kql/fM7PDj77ebWQVM8CCgVvN7D2aoEjliMcgoszaE+hbpP
        8eTQJDx7AnIrKTzEY
X-Received: by 2002:adf:b19a:: with SMTP id q26mr18529261wra.401.1624122571729;
        Sat, 19 Jun 2021 10:09:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzguNc55/swC68ILwLpUPVmXIoDs93+NxCTUtxmjzc+IJFas+QjZ9W2ckDV09Fc8MEEhNe8lQ==
X-Received: by 2002:adf:b19a:: with SMTP id q26mr18529239wra.401.1624122571530;
        Sat, 19 Jun 2021 10:09:31 -0700 (PDT)
Received: from krava ([37.161.48.99])
        by smtp.gmail.com with ESMTPSA id r1sm11307946wmh.32.2021.06.19.10.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jun 2021 10:09:31 -0700 (PDT)
Date:   Sat, 19 Jun 2021 19:09:25 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFCv3 00/19] x86/ftrace/bpf: Add batch support for
 direct/tracing attach
Message-ID: <YM4kxcCMHpIJeKum@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <CAEf4BzaK+t7zom6JHWf6XSPGDxjwhG4Wj3+CHKVshdmP3=FgnA@mail.gmail.com>
 <YM2r139rHuXialVG@krava>
 <4af931a5-3c43-9571-22ac-63e5d299fa42@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4af931a5-3c43-9571-22ac-63e5d299fa42@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 19, 2021 at 09:19:57AM -0700, Yonghong Song wrote:
> 
> 
> On 6/19/21 1:33 AM, Jiri Olsa wrote:
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
> > > >    1) patches (1-4) that fix the ftrace graph tracing over the function
> > > >       with direct trampolines attached
> > > >    2) patches (5-8) that add batch interface for ftrace direct function
> > > >       register/unregister/modify
> > > >    3) patches (9-19) that add support to attach BPF program to multiple
> > > >       functions
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
> 
> ctx does pass to the bpf program. You can check BPF_PROG
> macro definition.

ah right, should have checked it.. so how about we change
trampoline code to store ip in ctx-8 and make bpf_get_func_ip(ctx)
to return [ctx-8]

I'll need to check if it's ok for the tracing helper to take
ctx as argument

thanks,
jirka

