Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE7F299A51
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 00:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404448AbgJZXTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 19:19:43 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:45878 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404409AbgJZXTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 19:19:43 -0400
Received: by mail-yb1-f196.google.com with SMTP id s89so9103399ybi.12;
        Mon, 26 Oct 2020 16:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ONXhMRZsgx/QqDiXQIu3e8TXeENYkv2yw33OEhr5wUU=;
        b=RtCYwX8FU6G24hsq5GuTElH+slyLRlMHweYO4eY5FdVIwlR5zUPNIsNelg5VxR7MMQ
         i1Wru+GTtWyEIPQj78/C/L6FX63F3Eujo59fY1eGJvCnKH9UCJkFSJN2oLjS6eJB0/ny
         o2AXoe8b8JAOp7mtQgA1Fuz1ecv7mQC1K/JQfwI99lN8wEGAr6uNeqpRB/GfxZVOeXqF
         7SwrObIcT6QNdRBdsx169tY964RrYsWDVsIeBIwG2pF4H55COBwHmodA0hqB1tv6rYaF
         Pp3NzEUeCfru2tXxaXQ64MgjhzIKrf4x2P5cLy7lbySM0nNeI7GQmgeX2cZ5Tul3dYKC
         T51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ONXhMRZsgx/QqDiXQIu3e8TXeENYkv2yw33OEhr5wUU=;
        b=cjtuSgffykXQgkWQCWxU5CeUBxhEJ8fU2e7pR8zQtvvH56sfevUgfONMGIaTnoUGI2
         RAO9HrKYdrGX8I84Tr0trYvIwjCOyLjas49X2bebEdbF5986kzBhV1TJDvLBy9cukFW2
         i91lyVUj/mt2fHGWsxYUgTqbDZ4it8xwQZD58YOViU8RjcCNfqCA/K1WBcvOB6gG5Vys
         acLoI6Z2MYHedB1hAL+tVm1wpn8aNGB+LJDr3j5QiSNmWr+Eff8+aRptA1tkqKtRmfmx
         RQGz7OmWO37U9PgJKTK9T+jjVY4WBfhcpNWGSIWrifFM1lJJOnLIW67jakCG3kht5hVy
         hMjg==
X-Gm-Message-State: AOAM531BT6E7GgXS/L7z6rjYPeQWnsCYRVrPxGJ+R6wNEjp4qge0kqwE
        r7DqrXr+H/nhHalZA5e2Tdjc3eOK8eaFZ+lU7+w=
X-Google-Smtp-Source: ABdhPJy7oFEH+fXy/lJPdqdGXUEv0BpRKZzDH6dO0JW8dLOh8UhW7d4bn22pGcrHMKYjHu3YkrCXuhH7+R+DQ972La8=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr27774673ybl.347.1603754381348;
 Mon, 26 Oct 2020 16:19:41 -0700 (PDT)
MIME-Version: 1.0
References: <20201022082138.2322434-1-jolsa@kernel.org> <20201022082138.2322434-10-jolsa@kernel.org>
 <CAEf4Bzb_HPmGSoUX+9+LvSP2Yb95OqEQKtjpMiW1Um-rixAM8Q@mail.gmail.com>
 <20201023163110.54e4a202@gandalf.local.home> <CAEf4Bza4=KKZS_OGnaLvFELE8W+Nm4sah2--CYP6wopQecxg5g@mail.gmail.com>
 <20201025194123.GD2681365@krava>
In-Reply-To: <20201025194123.GD2681365@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Oct 2020 16:19:30 -0700
Message-ID: <CAEf4Bza0+MHuRneepidvXFZGZJ+hnMtaJpCq7EU=pvZHW7FD9w@mail.gmail.com>
Subject: Re: [RFC bpf-next 09/16] bpf: Add BPF_TRAMPOLINE_BATCH_ATTACH support
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@kernel.org>,
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

On Sun, Oct 25, 2020 at 12:41 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Fri, Oct 23, 2020 at 03:23:10PM -0700, Andrii Nakryiko wrote:
> > On Fri, Oct 23, 2020 at 1:31 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > On Fri, 23 Oct 2020 13:03:22 -0700
> > > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > >
> > > > Basically, maybe ftrace subsystem could provide a set of APIs to
> > > > prepare a set of functions to attach to. Then BPF subsystem would just
> > > > do what it does today, except instead of attaching to a specific
> > > > kernel function, it would attach to ftrace's placeholder. I don't know
> > > > anything about ftrace implementation, so this might be far off. But I
> > > > thought that looking at this problem from a bit of a different angle
> > > > would benefit the discussion. Thoughts?
> > >
> > > I probably understand bpf internals as much as you understand ftrace
> > > internals ;-)
> > >
> >
> > Heh :) But while we are here, what do you think about this idea of
> > preparing a no-op trampoline, that a bunch (thousands, potentially) of
> > function entries will jump to. And once all that is ready and patched
> > through kernel functions entry points, then allow to attach BPF
> > program or ftrace callback (if I get the terminology right) in a one
> > fast and simple operation? For users that would mean that they will
> > either get calls for all or none of attached kfuncs, with a simple and
> > reliable semantics.
>
> so the main pain point the batch interface is addressing, is that
> every attach (BPF_RAW_TRACEPOINT_OPEN command) calls register_ftrace_direct,
> and you'll need to do the same for nop trampoline, no?

I guess I had a hope that if we know it's a nop that we are
installing, then we can do it without extra waiting, which should
speed it up quite a bit.

>
> I wonder if we could create some 'transaction object' represented
> by fd and add it to bpf_attr::raw_tracepoint
>
> then attach (BPF_RAW_TRACEPOINT_OPEN command) would add program to this
> new 'transaction object' instead of updating ftrace directly
>
> and when the collection is done (all BPF_RAW_TRACEPOINT_OPEN command
> are executed), we'd call new bpf syscall command on that transaction
> and it would call ftrace interface
>

This is conceptually something like what I had in mind, but I had a
single BPF program attached to many kernel functions in mind.
Something that's impossible today, as you mentioned in another thread.

> something like:
>
>   bpf(TRANSACTION_NEW) = fd
>   bpf(BPF_RAW_TRACEPOINT_OPEN) for prog_fd_1, fd
>   bpf(BPF_RAW_TRACEPOINT_OPEN) for prog_fd_2, fd
>   ...
>   bpf(TRANSACTION_DONE) for fd
>
> jirka
>
> >
> > Something like this, where bpf_prog attachment (which replaces nop)
> > happens as step 2:
> >
> > +------------+  +----------+  +----------+
> > |  kfunc1    |  |  kfunc2  |  |  kfunc3  |
> > +------+-----+  +----+-----+  +----+-----+
> >        |             |             |
> >        |             |             |
> >        +---------------------------+
> >                      |
> >                      v
> >                  +---+---+           +-----------+
> >                  |  nop  +----------->  bpf_prog |
> >                  +-------+           +-----------+
> >
> >
> > > Anyway, what I'm currently working on, is a fast way to get to the
> > > arguments of a function. For now, I'm just focused on x86_64, and only add
> > > 6 argments.
> > >
> > > The main issue that Alexei had with using the ftrace trampoline, was that
> > > the only way to get to the arguments was to set the "REGS" flag, which
> > > would give a regs parameter that contained a full pt_regs. The problem with
> > > this approach is that it required saving *all* regs for every function
> > > traced. Alexei felt that this was too much overehead.
> > >
> > > Looking at Jiri's patch, I took a look at the creation of the bpf
> > > trampoline, and noticed that it's copying the regs on a stack (at least
> > > what is used, which I think could be an issue).
> >
> > Right. And BPF doesn't get access to the entire pt_regs struct, so it
> > doesn't have to pay the prices of saving it.
> >
> > But just FYI. Alexei is out till next week, so don't expect him to
> > reply in the next few days. But he's probably best to discuss these
> > nitty-gritty details with :)
> >
> > >
> > > For tracing a function, one must store all argument registers used, and
> > > restore them, as that's how they are passed from caller to callee. And
> > > since they are stored anyway, I figure, that should also be sent to the
> > > function callbacks, so that they have access to them too.
> > >
> > > I'm working on a set of patches to make this a reality.
> > >
> > > -- Steve
> >
>
