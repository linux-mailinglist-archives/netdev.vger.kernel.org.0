Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284B13FEE2B
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 14:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344729AbhIBM6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 08:58:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344481AbhIBM6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 08:58:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630587437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dPOZ8nIkrI7ew/J5rj43oMDhy/dYGh3jKeD7fvlj+ns=;
        b=L9qpGrUYBbzuHJk5PixjsdPdDkie1Wwkvm6dm1NU5YQXqtFMZX8vfWCsy/Yvva4QSrYE+f
        d9fsPPyKMhrlp+/J2NbFM2Olmt9BbRvLKoIp4NKbdb6S7Ydnsv4Vj2l5n6hG/y0T0x1MFs
        mYPdYjDb2VEZWfVRyWUNgPnuAOiE0JU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-SeYo2btMNqut-L-ZcqNgNQ-1; Thu, 02 Sep 2021 08:57:16 -0400
X-MC-Unique: SeYo2btMNqut-L-ZcqNgNQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5-20020a1c00050000b02902e67111d9f0so667938wma.4
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 05:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dPOZ8nIkrI7ew/J5rj43oMDhy/dYGh3jKeD7fvlj+ns=;
        b=qL9CeIdEQbFnBMLZ1HuVQFj/vR507Wry8klq+XFKtPnCpYhcSfxQGjQKXywQZ/kR9G
         TZE+2mNoL7HnwjtHGpEB4jU9b7bRwHL4tJ70w4hj7zaaSgabSgEZrNSElHcyqcLwtoi/
         if/TJUS7fDpv8E9O9sZkfggqdAwHz4BtQ5rgOfo1BLKJudjlyZOkXfOXzESsjaO8lWjC
         JfU3ExXi67ueO49lv/OSLEm/PoN6gtz+339Psqp7yq8xerpajyNJ6ZvVZW7hyKYmq4uZ
         dDN5T/jSEdu6PXIeQfXgFz6SsPjw2ffFZBkxZLqxqFvUKLJ4vt5KADQMO6F5gVMGYS/m
         TLkQ==
X-Gm-Message-State: AOAM531reVrm4r2qM8enkq0h/cNiLks1Sxr4GyerZZ9HQjDQ0KO1MaY3
        xQCuioBMrSUQz0LkYyBbmzzdItveQwPSvtVr/8ij1fSh5fIyuOpMbFvIR4Riq0+f41ci9J55Hd3
        FbWs4WGwssdiVXbJy
X-Received: by 2002:a5d:5712:: with SMTP id a18mr3458509wrv.367.1630587434370;
        Thu, 02 Sep 2021 05:57:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzF54+zTnKj97lVrFXjvdcWNp0nyG2WXkiMsyFArySIbH3D4zNlVlDRzNhdSJH8pwe/pTecUQ==
X-Received: by 2002:a5d:5712:: with SMTP id a18mr3458477wrv.367.1630587434037;
        Thu, 02 Sep 2021 05:57:14 -0700 (PDT)
Received: from krava ([94.113.247.3])
        by smtp.gmail.com with ESMTPSA id k14sm1773069wri.46.2021.09.02.05.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 05:57:13 -0700 (PDT)
Date:   Thu, 2 Sep 2021 14:57:11 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH bpf-next v4 18/27] bpf, x64: Store properly return value
 for trampoline with multi func programs
Message-ID: <YTDKJ2E1fN0hPDZj@krava>
References: <20210826193922.66204-1-jolsa@kernel.org>
 <20210826193922.66204-19-jolsa@kernel.org>
 <CAEf4BzbFxSVzu1xrUyzrgn1jKyR40RJ3UEEsUCkii3u5nN_8wg@mail.gmail.com>
 <YS+ZAbb+h9uAX6EP@krava>
 <CAEf4BzY1XhuZ5huinfTmUZGhrT=wgACOgKbbdEPmnek=nN6YgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY1XhuZ5huinfTmUZGhrT=wgACOgKbbdEPmnek=nN6YgA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 08:56:19PM -0700, Andrii Nakryiko wrote:
> On Wed, Sep 1, 2021 at 8:15 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Tue, Aug 31, 2021 at 04:51:18PM -0700, Andrii Nakryiko wrote:
> > > On Thu, Aug 26, 2021 at 12:41 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > When we have multi func program attached, the trampoline
> > > > switched to the function model of the multi func program.
> > > >
> > > > This breaks already attached standard programs, for example
> > > > when we attach following program:
> > > >
> > > >   SEC("fexit/bpf_fentry_test2")
> > > >   int BPF_PROG(test1, int a, __u64 b, int ret)
> > > >
> > > > the trampoline pushes on stack args 'a' and 'b' and return
> > > > value 'ret'.
> > > >
> > > > When following multi func program is attached to bpf_fentry_test2:
> > > >
> > > >   SEC("fexit.multi/bpf_fentry_test*")
> > > >   int BPF_PROG(test2, __u64 a, __u64 b, __u64 c, __u64 d,
> > > >                        __u64 e, __u64 f, int ret)
> > > >
> > > > the trampoline takes this program model and pushes all 6 args
> > > > and return value on stack.
> > > >
> > > > But we still have the original 'test1' program attached, that
> > > > expects 'ret' value where there's 'c' argument now:
> > > >
> > > >   test1(a, b, c)
> > > >
> > > > To fix that we simply overwrite 'c' argument with 'ret' value,
> > > > so test1 is called as expected and test2 gets called as:
> > > >
> > > >   test2(a, b, ret, d, e, f, ret)
> > > >
> > > > which is ok, because 'c' is not defined for bpf_fentry_test2
> > > > anyway.
> > > >
> > >
> > > What if we change the order on the stack to be the return value first,
> > > followed by input arguments. That would get us a bit closer to
> > > unifying multi-trampoline and the normal one, right? BPF verifier
> > > should be able to rewrite access to the last argument (i.e., return
> > > value) for fexit programs to actually be at offset 0, and shift all
> > > other arguments by 8 bytes. For fentry, if that helps to keep things
> > > more aligned, we'd just skip the first 8 bytes on the stack and store
> > > all the input arguments in the same offsets. So BPF verifier rewriting
> > > logic stays consistent (except offset 0 will be disallowed).
> >
> > nice idea, with this in place we could cut that args re-arranging code
> >
> > >
> > > Basically, I'm thinking how we can make normal and multi trampolines
> > > more interoperable to remove those limitations that two
> > > multi-trampolines can't be attached to the same function, which seems
> > > like a pretty annoying limitation which will be easy to hit in
> > > practice. Alexei previously proposed (as an optimization) to group all
> > > to-be-attached functions into groups by number of arguments, so that
> > > we can have up to 6 different trampolines tailored to actual functions
> > > being attached. So that we don't save unnecessary extra input
> > > arguments saving, which will be even more important once we allow more
> > > than 6 arguments in the future.
> > >
> > > With such logic, we should be able to split all the functions into
> > > multiple underlying trampolines, so it seems like it should be
> > > possible to also allow multiple multi-fentry programs to be attached
> > > to the same function by having a separate bpf_trampoline just for
> > > those functions. It will be just an extension of the above "just 6
> > > trampolines" strategy to "as much as we need trampolines".
> >
> > I'm probably missing something here.. say we have 2 functions with single
> > argument:
> >
> >   foo1(int a)
> >   foo2(int b)
> >
> > then having 2 programs:
> >
> >   A - attaching to foo1
> >   B - attaching to foo2
> >
> > then you need to have 2 different trampolines instead of single 'generic-1-argument-trampoline'
> 
> right, you have two different BPF progs attached to two different
> functions. You have to have 2 trampolines, not sure what's
> confusing?..

I misunderstood the statement above:

> > > practice. Alexei previously proposed (as an optimization) to group all
> > > to-be-attached functions into groups by number of arguments, so that
> > > we can have up to 6 different trampolines tailored to actual functions
> > > being attached. So that we don't save unnecessary extra input

you meant just functions to be attached at that moment, not all, ok

> 
> >
> > >
> > > It's just a vague idea, sorry, I don't understand all the code yet.
> > > But the limitation outlined in one of the previous patches seems very
> > > limiting and unpleasant. I can totally see that some 24/7 running BPF
> > > tracing app uses multi-fentry for tracing a small subset of kernel
> > > functions non-stop, and then someone is trying to use bpftrace or
> > > retsnoop to trace overlapping set of functions. And it immediately
> > > fails. Very frustrating.
> >
> > so the current approach is to some extent driven by the direct ftrace
> > batch API:
> >
> >   you have ftrace_ops object and set it up with functions you want
> >   to change with calling:
> >
> >   ftrace_set_filter_ip(ops, ip1);
> >   ftrace_set_filter_ip(ops, ip2);
> >   ...
> >
> > and then register trampoline with those functions:
> >
> >   register_ftrace_direct_multi(ops, tramp_addr);
> >
> > and with this call being the expensive one (it does the actual work
> > and sync waiting), my objective was to call it just once for update
> >
> > now with 2 intersecting multi trampolines we end up with 3 functions
> > sets:
> >
> >   A - functions for first multi trampoline
> >   B - functions for second multi trampoline
> >   C - intersection of them
> >
> > each set needs different trampoline:
> >
> >   tramp A - calls program for first multi trampoline
> >   tramp B - calls program for second multi trampoline
> >   tramp C - calls both programs
> >
> > so we need to call register_ftrace_direct_multi 3 times
> 
> Yes, that's the minimal amount of trampolines you need. Calling
> register_ftrace_direct_multi() three times is not that bad at all,
> compared to calling it 1000s of times. If you are worried about 1 vs 3
> calls, I think you are over-optimizing here. I'd rather take no
> restrictions on what can be attached to what and in which sequences
> but taking 3ms vs having obscure (for uninitiated users) restrictions,
> but in some cases allowing attachment to happen in 1ms.
> 
> The goal with multi-attach is to make it decently fast when attaching
> to a lot functions, but if attachment speed is fast enough, then such
> small performance differences don't matter anymore.

true, I might have been focused on the worst possible case here ;-)

> 
> >
> > if we allow also standard trampolines being attached, it makes
> > it even more complicated and ultimatelly gets broken to
> > 1-function/1-trampoline pairs, ending up with attach speed
> > that we have now
> >
> 
> So let's make sure that we are on the same page. Let me write out an example.
> 
> Let's say we have 5 kernel functions: a, b, c, d, e. Say a, b, c all
> have 1 input args, and d and e have 2.
> 
> Now let's say we attach just normal fentry program A to function a.
> Also we attach normal fexit program E to func e.
> 
> We'll have A  attached to a with trampoline T1. We'll also have E
> attached to e with trampoline T2. Right?
> 
> And now we try to attach generic fentry (fentry.multi in your
> terminology) prog X to all 5 of them. If A and E weren't attached,
> we'd need two generic trampolines, one for a, b, c (because 1 input
> argument) and another for d,e (because 2 input arguments). But because
> we already have A and B attached, we'll end up needing 4:
> 
> T1 (1 arg)  for func a calling progs A and X
> T2 (2 args) for func e calling progs E and X
> T3 (1 arg)  for func b and c calling X
> T4 (2 args) for func d calling X

so current code would group T3/T4 together, but if we keep
them separated, then we won't need to use new model and
cut off some of the code, ok

together with that args shifting we could endup with almost
untouched trampoline generation code ;-)

> 
> We can't have less than that and satisfy all the constraints. But 4 is
> not that bad. If the example has 1000s of functions, you'd still need
> between 4 and 8 trampolines (if we had 3, 4, 5, and 6 input args for
> kernel functions). That's way less than 1000s of trampolines needed
> today. And it's still fast enough on the attachment.
> 
> The good thing with what we discussed with making current trampoline
> co-exist with generic (multi) fentry/fexit, is that we'll still have
> just one trampoline, saving exactly as many input arguments as
> attached function(s) have. So at least we don't have to maintain two
> separate pieces of logic for that. Then the only added complexity
> would be breaking up all to-be-attached kernel functions into groups,
> as described in the example.
> 
> It sounds a bit more complicated in writing than it will be in
> practice, probably. I think the critical part is unification of
> trampoline to work with fentry/fexit and fentry.multi/fexit.multi
> simultaneously, which seems like you agreed above is achievable.

ok, I haven't considered this way, but I think it's doable

thanks,
jirka

