Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259AD35FE00
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 00:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhDNWrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 18:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhDNWrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 18:47:23 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E435C061574;
        Wed, 14 Apr 2021 15:47:01 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id x8so18811969ybx.2;
        Wed, 14 Apr 2021 15:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iG/bzcOuz0T3mi8ygtcgigtH46bIry+8H6Amt7aVtJQ=;
        b=vaRv3aBaIfWiBhk62+n3d1aZc+ZXgTm12tDxAuAy6iAZoodfZOJnJNySa3ZUiDvYVQ
         g1owOLKA5ty4ZmAwftJnOfyEYpIht17lGbrtyu6KYNUrmJnRwHQkBTUKbB9NuXh0C+28
         8pTnjykdMDHU93cznOYJk0yd1Kdwdu5tnq3pW9w4EwzZ9fhdXhNK2mEWEV4UWD4+jFBL
         tpdNbJ7fvXyEqQ/kW1ENedl0ZK4HPol06BT/TkT1SpNUqiCzdhpcywX+z9+vrwLlqnic
         a1Szy+M+cWyLR3qv/O6+Sj1x72d5NXebn2v+k3tKCCW5Nmp8kxGPvrqSKz2K3+YG7kZF
         wqWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iG/bzcOuz0T3mi8ygtcgigtH46bIry+8H6Amt7aVtJQ=;
        b=RwfzcbtOKWMj/QQCV5/SwZUg2WgdhQKklK3tAJB83xAEy/jDvOkiLYmVRBIXkYpcNl
         Jc5i7Rvn9ExiNd0wZ2dEgzlssEOM/+ajqDtRY2tEa2wC/a7sEynhZo0oxa59IKfKzM5G
         9OusOCkf16S9e1vhVhQRCwp9Nu7zZavN5LeSrDsxIYtZQJDwxnSMixxZou5WD4VOfOmZ
         bFQiBuL5fIK2fGbMfqD5vcftwG2Jnxsizy62H1B8qsZRvt+ahIPnNpHgUGo1rgp35pnv
         Y/r2aUj7JZ238ZiUcbmPt8awTcIs4FZtwZgquQUYJKet8GU+p/eV6wGwGGDI53547sy5
         5VCg==
X-Gm-Message-State: AOAM530CYfuMmDWFTtfGYMPdYt6fY4Rgx5bpcsF/EMnsJZu1QCHaqP5C
        D70BfbrtN+3cWJCls1/ln2BYFy4B3Lmb0k7F5Cc=
X-Google-Smtp-Source: ABdhPJx6TYoqBafM79DsOqCbJevqbPIunKywdkNqm7MrsgpC+QDGIFr2cC82eNVRJqGOypRI4mrn4/Mi6k+AWxaStyc=
X-Received: by 2002:a25:9942:: with SMTP id n2mr423190ybo.230.1618440420688;
 Wed, 14 Apr 2021 15:47:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210413121516.1467989-1-jolsa@kernel.org> <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
 <YHbd2CmeoaiLJj7X@krava>
In-Reply-To: <YHbd2CmeoaiLJj7X@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Apr 2021 15:46:49 -0700
Message-ID: <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 5:19 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Apr 13, 2021 at 06:04:05PM -0700, Andrii Nakryiko wrote:
> > On Tue, Apr 13, 2021 at 7:57 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > hi,
> > > sending another attempt on speeding up load of multiple probes
> > > for bpftrace and possibly other tools (first post in [1]).
> > >
> > > This patchset adds support to attach bpf program directly to
> > > ftrace probe as suggested by Steven and it speeds up loading
> > > for bpftrace commands like:
> > >
> > >    # bpftrace -e 'kfunc:_raw_spin* { @[probe] = count(); }'
> > >    # bpftrace -e 'kfunc:ksys_* { @[probe] = count(); }'
> > >
> > > Using ftrace with single bpf program for attachment to multiple
> > > functions is much faster than current approach, where we need to
> > > load and attach program for each probe function.
> > >
> >
> > Ok, so first of all, I think it's super important to allow fast
> > attachment of a single BPF program to multiple kernel functions (I
> > call it mass-attachment). I've been recently prototyping a tool
> > (retsnoop, [0]) that allows attaching fentry/fexit to multiple
> > functions, and not having this feature turned into lots of extra code
> > and slow startup/teardown speeds. So we should definitely fix that.
> >
> > But I think the approach you've taken is not the best one, even though
> > it's a good starting point for discussion.
> >
> > First, you are saying function return attachment support is missing,
> > but is not needed so far. I actually think that without func return
> > the whole feature is extremely limiting. Not being able to measure
> > function latency  by tracking enter/exit events is crippling for tons
> > of useful applications. So I think this should go with both at the
> > same time.
> >
> > But guess what, we already have a good BPF infra (BPF trampoline and
> > fexit programs) that supports func exit tracing. Additionally, it
> > supports the ability to read input arguments *on function exit*, which
> > is something that kretprobe doesn't support and which is often a very
> > limiting restriction, necessitating complicated logic to trace
> > function entry just to store input arguments. It's a killer feature
> > and one that makes fexit so much more useful than kretprobe.
> >
> > The only problem is that currently we have a 1:1:1 relationship
> > between BPF trampoline, BPF program, and kernel function. I think we
> > should allow to have a single BPF program, using a single BPF
> > trampoline, but being able to attach to multiple kernel functions
> > (1:1:N). This will allow to validate BPF program once, allocate only
> > one dedicated BPF trampoline, and then (with appropriate attach API)
> > attach them in a batch mode.
>
> heya,
> I had some initial prototypes trying this way, but always ended up
> in complicated code, that's why I turned to ftrace_ops.
>
> let's see if it'll make any sense to you ;-)
>
> 1) so let's say we have extra trampoline for the program (which
> also seems a bit of waste since there will be just single record

BPF trampoline does more than just calls BPF program. At the very
least it saves input arguments for fexit program to be able to access
it. But given it's one BPF trampoline attached to thousands of
functions, I don't see any problem there.

> in it, but sure) - this single trampoline can be easily attached
> to multiple functions, but what about other trampolines/tools,
> that want to trace the same function? we'd need some way for a
> function to share/call multiple trampolines - I did not see easy
> solution in here so I moved to another way..

The easiest would be to make the existing BPF trampoline to co-exist
with this new multi-attach one. As to how, I don't know the code well
enough yet to answer specifically.

>
>
> 2) we keep the trampoline:function relationship to 1:1 and allow
> 'mass-attachment' program to register in multiple trampolines.
> (it needs special hlist node for each attachment, but that's ok)
>
> the problem was that to make this fast, you don't want to attach/detach
> program to trampolines one by one, you need to do it in batch,
> so you can call ftrace API just once (ftrace API is another problem below)
> and doing this in batch mode means, that you need to lock all the
> related trampolines and not allow any change in them by another tools,
> and that's where I couldn't find any easy solution.. you can't take
> a lock for 100 trampolines.. and having some 'master' lock is tricky

So this generic fentry would have its own BPF trampoline. Now you need
to attach it to 1000s of places with a single batch API call. We won't
have to modify 100s of other BPF trampolines, if we can find a good
way to let them co-exist.


>
> another problem is the ftrace API.. to make it fast we either
> need to use ftrace_ops or create fast API to ftrace's direct
> functions.. and that was rejected last time [1]

I don't read it as a rejection, just that ftrace infra needs to be
improved to support. In any case, I haven't spent enough time thinking
and digging through code, but I know that without fexit support this
feature is useless in a lot of cases. And input argument reading in
fexit is too good to give up at this point either.

>
>
> 3) bpf has support for batch interface already, but only if ftrace

It does? What is it? Last time I looked I didn't find anything like that.

> is not in the way..  compile without ftrace is not an option for us,
> so I was also thinking about some way to bypass ftrace and allow
> any trace engine to own some function.. so whoever takes it first
> (ftrace or bpf) can use it, the other one will see -EBUSY and once
> the tool is done, the function is free to take
>
>
> [1] https://lore.kernel.org/bpf/20201022104205.728dd135@gandalf.local.home/#t
>
> >
> > We'll probably have to abandon direct memory read for input arguments,
> > but for these mass-attachment scenarios that's rarely needed at all.
> > Just allowing to read input args as u64 and providing traced function
> > IP would be enough to do a lot. BPF trampoline can just
> > unconditionally save the first 6 arguments, similarly how we do it
> > today for a specific BTF function, just always 6.
>
> yes, we don't need arguments just function ip/id to tell what
> function we just trace
>
> >
> > As for attachment, dedicating an entire new FD for storing functions
> > seems like an overkill. I think BPF_LINK_CREATE is the right place to
> > do this, providing an array of BTF IDs to identify all functions to be
> > attached to. It's both simple and efficient.
>
> that fd can be closed right after link is created ;-)
>
> I used it because it seemed simpler than the array approach,
> and also for the ftrace_location check when adding the function
> to the object - so you know it's under ftrace - when it passed,
> the attach will most likely pass as well - so tools is just adding
> IDs and the objects keeps only the good ones ;-)
>
> but that ftrace_location info can be found in user space as well,
> so it's definitely possible to prepare 'good' BTF IDs in userspace
> and use array

right; a new FD and new concept just for this seems like an overkill

>
> >
> > We'll get to libbpf APIs and those pseudo-regexp usage a bit later, I
> > don't think we need to discuss that at this stage yet :)
> >
> > So, WDYT about BPF trampoline-based generic fentry/fexit with mass-attach API?
>
> I'll double check the ftrace graph support for ftrace_ops ;-)
>
> let's see if we could find some solutions for the problems I
> described above.. or most likely another better way to do this,
> that'd be great
>
> >
> >   [0] https://github.com/anakryiko/retsnoop
>
> nice tool, could it be also part of bcc?

As it is right now it takes minutes to attach and then minutes to
detach, so not a very convenient tool without batched attach. Brendan
Gregg also hinted that he doesn't intend to allow BCC tools collection
to grow unbounded. So for now it is in its own repo, feel free to try
it. We'll see how it goes.

>
> thanks,
> jirka
>
> >

[...]
