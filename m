Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23A93FDE56
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 17:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245479AbhIAPQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 11:16:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22909 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233929AbhIAPQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 11:16:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630509319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cI3YGKinUAUJ4EIDJFrV5CUhikBFatmsrzCz3MZjYcI=;
        b=HuYqvpR7JkysFKxsJGdYcAQHhowFMl1p4g0ogTWEUtWS9lgeo0B4BO70meSOMbiaNGmVqp
        zKORp5ww9tWc8OEvdbm9LK94QLFz/Maq5rex4kaXAKEz4ND+G1IhcpGBU2uXHlM6YUnx2R
        YT9kq+D7lJ4mTk8JJ/lgQPR6GU4FO/c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-mTf0DlwhMdGrzgedxTHcEQ-1; Wed, 01 Sep 2021 11:15:18 -0400
X-MC-Unique: mTf0DlwhMdGrzgedxTHcEQ-1
Received: by mail-wm1-f70.google.com with SMTP id s197-20020a1ca9ce000000b002e72ba822dcso2960662wme.6
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 08:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cI3YGKinUAUJ4EIDJFrV5CUhikBFatmsrzCz3MZjYcI=;
        b=se62OqIBBHKgwIqSDrjbN5u0PIR4HfYWA9nM/AVcidmTvlMPUGVJrmdP1d9yBqyaY3
         d6j+o1gWjKhUrBu636Zpla5VcyRt1TrzBJ8sud7+g0rvoqBTkPLWBtid5iaMMOoDMK/w
         aaos4D+IQK51F/6h3tBA4UbdBuoV9TEu3aukUFds5t0tivPwlYbIQtcLtpJspHt4Rfwn
         pUpsAwNoLel9P4L9BAjKf2XQiRRqHayEjtivxFTPb6soINy7vlXgdU6Ubby3KKUZEw/X
         2GmR0GK0guaBUE1Jp/UnsYf8Tyd0K+rk+jt/BmkA1GyVl4rAEOSwGPKF/1VyMsHlosSv
         VBuA==
X-Gm-Message-State: AOAM532w4OikF6RRPxx936kjPzlGwhItOmW/P3CfAyHj0R1bZr0VT6db
        kmpI2zNx82txbebtvdSL97qD5vcIxpi1FZsA/PjRHyyynCFhI7VhrBfbf4+CtFzjbzR2J13atJR
        eHweFWcgfCX94rArh
X-Received: by 2002:a1c:2209:: with SMTP id i9mr3399wmi.92.1630509316850;
        Wed, 01 Sep 2021 08:15:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKqj6Zpr84oS5Vukf+XvV1LZYkEqWj63+vl/cyeW1zP6cuDgdGyICCzoFwuFdkiBvi+ZLUYQ==
X-Received: by 2002:a1c:2209:: with SMTP id i9mr3360wmi.92.1630509316587;
        Wed, 01 Sep 2021 08:15:16 -0700 (PDT)
Received: from krava ([94.113.247.3])
        by smtp.gmail.com with ESMTPSA id v21sm23343257wra.92.2021.09.01.08.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 08:15:16 -0700 (PDT)
Date:   Wed, 1 Sep 2021 17:15:13 +0200
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
Message-ID: <YS+ZAbb+h9uAX6EP@krava>
References: <20210826193922.66204-1-jolsa@kernel.org>
 <20210826193922.66204-19-jolsa@kernel.org>
 <CAEf4BzbFxSVzu1xrUyzrgn1jKyR40RJ3UEEsUCkii3u5nN_8wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbFxSVzu1xrUyzrgn1jKyR40RJ3UEEsUCkii3u5nN_8wg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 04:51:18PM -0700, Andrii Nakryiko wrote:
> On Thu, Aug 26, 2021 at 12:41 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > When we have multi func program attached, the trampoline
> > switched to the function model of the multi func program.
> >
> > This breaks already attached standard programs, for example
> > when we attach following program:
> >
> >   SEC("fexit/bpf_fentry_test2")
> >   int BPF_PROG(test1, int a, __u64 b, int ret)
> >
> > the trampoline pushes on stack args 'a' and 'b' and return
> > value 'ret'.
> >
> > When following multi func program is attached to bpf_fentry_test2:
> >
> >   SEC("fexit.multi/bpf_fentry_test*")
> >   int BPF_PROG(test2, __u64 a, __u64 b, __u64 c, __u64 d,
> >                        __u64 e, __u64 f, int ret)
> >
> > the trampoline takes this program model and pushes all 6 args
> > and return value on stack.
> >
> > But we still have the original 'test1' program attached, that
> > expects 'ret' value where there's 'c' argument now:
> >
> >   test1(a, b, c)
> >
> > To fix that we simply overwrite 'c' argument with 'ret' value,
> > so test1 is called as expected and test2 gets called as:
> >
> >   test2(a, b, ret, d, e, f, ret)
> >
> > which is ok, because 'c' is not defined for bpf_fentry_test2
> > anyway.
> >
> 
> What if we change the order on the stack to be the return value first,
> followed by input arguments. That would get us a bit closer to
> unifying multi-trampoline and the normal one, right? BPF verifier
> should be able to rewrite access to the last argument (i.e., return
> value) for fexit programs to actually be at offset 0, and shift all
> other arguments by 8 bytes. For fentry, if that helps to keep things
> more aligned, we'd just skip the first 8 bytes on the stack and store
> all the input arguments in the same offsets. So BPF verifier rewriting
> logic stays consistent (except offset 0 will be disallowed).

nice idea, with this in place we could cut that args re-arranging code

> 
> Basically, I'm thinking how we can make normal and multi trampolines
> more interoperable to remove those limitations that two
> multi-trampolines can't be attached to the same function, which seems
> like a pretty annoying limitation which will be easy to hit in
> practice. Alexei previously proposed (as an optimization) to group all
> to-be-attached functions into groups by number of arguments, so that
> we can have up to 6 different trampolines tailored to actual functions
> being attached. So that we don't save unnecessary extra input
> arguments saving, which will be even more important once we allow more
> than 6 arguments in the future.
> 
> With such logic, we should be able to split all the functions into
> multiple underlying trampolines, so it seems like it should be
> possible to also allow multiple multi-fentry programs to be attached
> to the same function by having a separate bpf_trampoline just for
> those functions. It will be just an extension of the above "just 6
> trampolines" strategy to "as much as we need trampolines".

I'm probably missing something here.. say we have 2 functions with single
argument:

  foo1(int a)
  foo2(int b)

then having 2 programs:

  A - attaching to foo1
  B - attaching to foo2

then you need to have 2 different trampolines instead of single 'generic-1-argument-trampoline'

> 
> It's just a vague idea, sorry, I don't understand all the code yet.
> But the limitation outlined in one of the previous patches seems very
> limiting and unpleasant. I can totally see that some 24/7 running BPF
> tracing app uses multi-fentry for tracing a small subset of kernel
> functions non-stop, and then someone is trying to use bpftrace or
> retsnoop to trace overlapping set of functions. And it immediately
> fails. Very frustrating.

so the current approach is to some extent driven by the direct ftrace
batch API:

  you have ftrace_ops object and set it up with functions you want
  to change with calling:

  ftrace_set_filter_ip(ops, ip1);
  ftrace_set_filter_ip(ops, ip2);
  ...

and then register trampoline with those functions:

  register_ftrace_direct_multi(ops, tramp_addr);

and with this call being the expensive one (it does the actual work
and sync waiting), my objective was to call it just once for update

now with 2 intersecting multi trampolines we end up with 3 functions
sets:

  A - functions for first multi trampoline
  B - functions for second multi trampoline
  C - intersection of them

each set needs different trampoline:

  tramp A - calls program for first multi trampoline
  tramp B - calls program for second multi trampoline
  tramp C - calls both programs

so we need to call register_ftrace_direct_multi 3 times

if we allow also standard trampolines being attached, it makes
it even more complicated and ultimatelly gets broken to
1-function/1-trampoline pairs, ending up with attach speed
that we have now

...

I have test code for ftrace direct interface that would
allow to register/change separate function/addr pairs,
so in one call you can change multiple ips each to
different tramp addresss

but even with that, I ended up with lot of new complexity
on bpf side keeping track of multi trampolines intersections,
so I thought I'd start with something limited and simpler

perhaps I should move back to that approach and see how bad
it ends ;-)

or this could be next step on top of current work, that should
get simpler with the args re-arranging you proposed

jirka

