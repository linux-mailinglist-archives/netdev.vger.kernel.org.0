Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC8E17836D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731306AbgCCTyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:54:04 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42316 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730488AbgCCTyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 14:54:03 -0500
Received: by mail-qk1-f194.google.com with SMTP id e11so3917015qkg.9;
        Tue, 03 Mar 2020 11:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vGc8MHL2OxCWqBd5/Ljz2NGeWdL2dMuDx3BrLtQERCs=;
        b=k964/K6KV6nNt/7ilYDhroN52czvHVg0sOYE6lwQC/E1v9e2YXX3oEr6pz2VsTm6J+
         69qKtSpRUCdlJiPu6AuRpwAzLoJzGTa5noYfrxLdj4izVDkwMwVU7FuDhEQEvm9k9vE7
         BEK25R/86cASoAT7hwECj0TWU2qsC5kUD8sTpJaGtmcO1ncmDJ20tjb1WX+DQ5/zfHHq
         jLJTTJ7p+RTdnyba1PoVBtagmkN3s+ziBwOkNcjE20rLpYFobNdE2GuJxGmcUHOFD1Lx
         nvskJQraFq95+SPAQ3v0CYXY8vaohwRwGQGyumGUKbkAZIEgLx8POjjqgq+EbxhE7ZjH
         sjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vGc8MHL2OxCWqBd5/Ljz2NGeWdL2dMuDx3BrLtQERCs=;
        b=pwzBNDJFCrWQx0aN47qq0SOgTSAQwz+4UwoOtozEJhLVTtquMC5ExNQoWLu5JvibX7
         +FxCBsidRUNFMls9NDLFGzFh8VUItoqrFJBSiiOsrW8EQNBJOUxFvR9U8J8CvydhtwvF
         P0wb9RajA5BrwFZtkbQNsp9u5bWydozGEsFZe3rnBQLzy8IAN6BohxbnUZ2UN0bP5pwj
         wVmNNu7O3ytb1Dg1aYKqo9vtLvbrQEztm7T3XphhS1eTc8NhDLQcEwd6SBHBhLHRvjq7
         dBbetHYWmgJkjD+m3umM5XopzzfTKO7MuOkHzTgV+y2Tj6KyVuuKp7bNdc0J9W1+CPdg
         6wGA==
X-Gm-Message-State: ANhLgQ3bJIREX3GeeomuiOUt56dB68oJmjC/lghwpJWWEex1CPOVqtFn
        jMgkVopMK83BmJISvYutRm54117uDCm0bu85XGA=
X-Google-Smtp-Source: ADFU+vviNo/32zCLQNBR2JhneZO5PpPtOHliqqoChyuqCsfzE1ZcrtDMQbLW2knlitiUcv0NgDIOVBdJalNJL+E8ORc=
X-Received: by 2002:a37:9104:: with SMTP id t4mr5997397qkd.449.1583265240252;
 Tue, 03 Mar 2020 11:54:00 -0800 (PST)
MIME-Version: 1.0
References: <158289973977.337029.3637846294079508848.stgit@toke.dk>
 <20200228221519.GE51456@rdna-mbp> <87v9npu1cg.fsf@toke.dk> <20200303010318.GB84713@rdna-mbp>
In-Reply-To: <20200303010318.GB84713@rdna-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 3 Mar 2020 11:53:49 -0800
Message-ID: <CAEf4BzaC=dVV-vc-KRYmErdSOLo94LGTngzu6wfs-jFLLuPcsA@mail.gmail.com>
Subject: Re: [PATCH RFC] Userspace library for handling multiple XDP programs
 on an interface
To:     Andrey Ignatov <rdna@fb.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        ctakshak@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 2, 2020 at 5:03 PM Andrey Ignatov <rdna@fb.com> wrote:
>
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> [Sat, 2020-02-29 02:36=
 -0800]:
> > Andrey Ignatov <rdna@fb.com> writes:
> >
> > > The main challenges I see for applying this approach in fb case is th=
e
> > > need to recreate the dispatcher every time a new program has to be
> > > added.
> > >
> > > Imagine there there are a few containers and every container wants to
> > > run an application that attaches XDP program to the "dispatcher" via
> > > freplace. Every application may have a "priority" reserved for it, bu=
t
> > > recreating the dispatcher may have race condition, for example:
> >
> > Yeah, I did realise this is potentially racy, but so is any loading of
> > XDP programs right now (i.e., two applications can both try loading a
> > single XDP program at the same time, and end up stomping on each others=
'
> > feet). So we'll need to solve that in any case. I've managed to come up
> > with two possible ways to solve this:
> >
> > 1. Locking: Make it possible for a process to temporarily lock the
> > XDP program loaded onto an interface so no other program can modify it
> > until the lock is released.
> >
> > 2. A cmpxchg operation: Add a new field to the XDP load netlink message
> > containing an fd of the old program that the load call is expecting to
> > replace. I.e., instead of attach(ifindex, prog_fd, flags), you have
> > attach(ifindex, prog_fd, old_fd, flags). The kernel can then check that
> > the old_fd matches the program currently loaded before replacing
> > anything, and reject the operation otherwise.
> >
> > With either of these mechanisms it should be possible for userspace to
> > do the right thing if the kernel state changes underneath it. I'm
> > leaning towards (2) because I think it is simpler to implement and
> > doesn't require any new state be kept in the kernel.
>
> Yep, that will solve the race.
>
> (2) sounds good to me, in fact I did similar thing for cgroup-bpf in:
>
> 7dd68b3279f1 ("bpf: Support replacing cgroup-bpf program in MULTI mode")
>
> where user can pass replace_bpf_fd and BPF_F_REPLACE flag and it
> guarantees that the program, users wants, will be replaced, not a new
> program that was attached by somebody else just a moment ago.
>
>
> > The drawback is
> > that it may lead to a lot of retries if many processes are trying to
> > load their programs at the same time. Some data would be good here: How
> > often do you expect programs to be loaded/unloaded in your use case?
>
>
> In the case I mentioned it's more about having multiple applications
> that may start/restart at the same time, not about frequency. It'll be a
> few (one digit number) apps, what means having a few retries should be
> fine if "the old program doesn't exist" can be detected easily (e.g.
> ENOENT should work) not to do retry for errors that are obviously
> unrelated to the race condition.
>
>
> > As for your other suggestion:
> >
> > > Also I see at least one other way to do it w/o regenerating dispatche=
r
> > > every time:
> > >
> > > It can be created and attached once with "big enough" number of slots=
,
> > > for example with 100 and programs may use use their corresponding slo=
t
> > > to freplace w/o regenerating the dispatcher. Having those big number =
of
> > > no-op slots should not be a big deal from what I understand and kerne=
l
> > > can optimize it.
> >
> > I thought about having the dispatcher stay around for longer, and just
> > replacing more function slots as new programs are added/removed. The
> > reason I didn't go with this is the following: Modifying the dispatcher
> > while it is loaded means that the modifications will apply to traffic o=
n
> > the interface immediately. This is fine for simple add/remove of a
> > single program, but it limits which operations you can do atomically.
> > E.g., you can't switch the order of two programs, or add or remove more
> > than one, in a way that is atomic from the PoV of the traffic on the
> > interface.
>
> Right, simple add/remove cases is the only ones I've seen so far since
> programs are usually more or less independent and they just should be
> chained properly w/o anything like "order of programs should be changed
> atomically" or "two programs must be enabled atomically".
>
> But okay, I can imagine that this may happen in the wild. In this case
> yes, full regeneration of the dispatcher looks like the option ..
>
>
> > Since I expect that we will need to support atomic operations even for
> > these more complex cases, that means we'll need to support rebuilding
> > the dispatcher anyway, and solving the race condition problem for that.
> > And once we've done that, the simple add/remove in the existing
> > dispatcher becomes just an additional code path that we'll need to
> > maintain, so why bother? :)
> >
> > I am also not sure it's as simple as you say for the kernel to optimise
> > a more complex dispatcher: The current dead code elimination relies on
> > map data being frozen at verification time, so it's not applicable to
> > optimising a dispatcher as it is being changed later. Now, this could
> > probably be fixed and/or we could try doing clever tricks with the flow
> > control in the dispatcher program itself. But again, why bother if we
> > have to support the dispatcher rebuild mode of operation anyway?
>
> Yeah, having the ability to regenerate the full dispatcher helps to
> avoid dealing with those no-ops programs.
>
> This kinda solves another problem of allocating positions in the list of
> noop_fun1, noop_func2, ..., noop_funcN, since the N is limited and
> keeping "enough space" between existing programs to be able to attach
> something else between them in the future can be challenging in general
> case.
>
> > I may have missed something, of course, so feel free to point out if yo=
u
> > see anything wrong with my reasoning above!
> >
> > > This is the main thing so far, I'll likely provide more feedback when
> > > have some more time to read the code ..
> >
> > Sounds good! You're already being very helpful, so thank you! :)
>
> I've spent more time reading the library and like the static global data
> idea that allows to "regenerate" dispatcher w/o actually recompiling it
> so that it can still be compiled once and distributed to all relevant
> hosts.  It simplifies a bunch of things discussed above.
>
> But this part in the "missing pieces":
>
> > > - There is no way to re-attach an already loaded program to another f=
unction;
> > >   this is needed for updating the call sequence: When a new program i=
s loaded,
> > >   libxdp should get the existing list of component programs on the in=
terface and
> > >   insert the new one into the chain in the appropriate place. To do t=
his it
> > >   needs to build a new dispatcher and reattach all the old programs t=
o it.
> > >   Ideally, this should be doable without detaching them from the old =
dispatcher;
> > >   that way, we can build the new dispatcher completely, and atomicall=
y replace
> > >   it on the interface by the usual XDP attach mechanism.
>
> seems to be "must-have", including the "Ideally" section, since IMO
> simply adding a new program should not interrupt what previously
> attached programs are doing.
>
> If there is a container A that attached progA to dispatcher some time
> ago, and then container B is regenerating dispatcher to add progB, that
> shouldn't stop progA from being executed even for short period of time
> since for some programs it's just no-go (e.g. if progA is a firewall and
> disabling it would mean allowing traffic that otherwise is denied).
>
> I'm not the one who can answer the question how hard would it be to
> support this kind of "re-attaching" on kernel side and curios myself. I
> do see though that current implementation of ext programs has a single
> (prog->aux->linked_prog, prog->aux->attach_btf_id) pair.
>
> Also it's not clear what to do with fd returned by
> bpf_tracing_prog_attach (whether it can be pined or not), e.g. if
> container A generated dispatcher with ext progA attached to it and got
> this "link" fd, but then dispatcher was regenerated and the progA was
> reattached to the new dispatcher, how to make sure that the "link" fd is
> still the right one and cleanup will happen when a process in container
> A closes the fd it has (or unpins corresponding file in bpf fs).

I just replied to Daniel on another thread (it's weird how we have
inter-related discussions on separate thread, but whatever..).
Basically, once you establish XDP bpf_link for XDP dispatcher, you
can't attach another bpf_link anymore. It will keep failing until
bpf_link goes away (close FD, unpin, etc). But, once you have
bpf_link, you should be able to replace underlying BPF program, as
long as you still own that link). This way it should be possible to
re-generate XDP dispatcher and safely switch it.

>
>
> --
> Andrey Ignatov
