Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3071B1AB5A4
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 03:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387905AbgDPBsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 21:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729491AbgDPBsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 21:48:25 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA549C061A0C;
        Wed, 15 Apr 2020 18:48:25 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id l60so6804655qtd.8;
        Wed, 15 Apr 2020 18:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XuNKYISD+t+PSFfwH7kSQ2EhRMhyMs5XQnzd/oOhuqc=;
        b=gWAKb53gdSoPumI7uht2yPeY9c9OlNXOstqEnZYfyKjILVaSMjRbn/o2Lp/f73mybA
         t2JTXIj40pU8KuM5yqoDM04ytRlXBwFeRbz+Fshmvhg1E15/hb/8IVbC/LX9yp8AMjzC
         OaLcuaPJ9gRbIW8UVteF4FP2X4CtP1wLNfJOMkvzdsEbZIHKlZxv8hmA6IgRzh8l+vgE
         yVgLcD9EmMyaKDFIrIYNG7o/BDdFOTgdqY69wn9N4tgjCBHxOQ60HUt02bz/mrN2YvNZ
         n4jSlNrKQMzzsCjXVc7DFaenPOQ5LULtIKkCn3AP4+OUgLEvKpfApt7RSeTDaTiI1cOh
         aM+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XuNKYISD+t+PSFfwH7kSQ2EhRMhyMs5XQnzd/oOhuqc=;
        b=nkFSzZHE85uxyHYesOixdwx6gQ8N9iC94SUXcERT0rYMeH8HZDpAyo7n7Sdw6soJgN
         P189YGM7bbtwF+CBLR3RRjP8954ohzDl/RozYjTS4AkKlt2omciujajKUaRZBkFdqS8E
         sQwUwZ46L0MdQ1DqmsMezVomFuSk/4T8brLb//HB4bZh05SSx8gPux1fi6gkRKjag4eO
         P/Qi8iPQp4ND0MZBIPb/yuCBcisp0RQAFnu2m3Le1LCikUyjSQ7uKYD/38IOx1eDIUz1
         XkP1wE9kTUr+EGQi/5K+co1BP2D2+nXUCPFmq4ckiBf0IWT7pQGvjfgI1PyYmXmkl3/t
         dpIw==
X-Gm-Message-State: AGi0PuZQVaoj8gBZtpOPy//hsN+Rack1Nkvvb8BiCFpoupSIAwosoghi
        F8aNS7Pmfvp59vWgPs08awlBAqJ7ebI0jhrVNrk=
X-Google-Smtp-Source: APiQypKd2aOmvbKg8wW4hVF+k0trxmkcbJHJqSaM6unNTXwLyGhzpNCgpFMOK5Our6AX/tuLtGQVF++ZMjD03kQqT7o=
X-Received: by 2002:aed:2e24:: with SMTP id j33mr23808435qtd.117.1587001704711;
 Wed, 15 Apr 2020 18:48:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232526.2675664-1-yhs@fb.com>
 <CAEf4Bzawu2dFXL7nvYhq1tKv9P7Bb9=6ksDpui5nBjxRrx=3_w@mail.gmail.com>
 <4bf72b3c-5fee-269f-1d71-7f808f436db9@fb.com> <CAEf4BzZnq958Guuusb9y65UCtB-DARxdk7_q7ZPBZ3WOwjSKaw@mail.gmail.com>
 <20200415164640.evaujoootr4n55sc@ast-mbp>
In-Reply-To: <20200415164640.evaujoootr4n55sc@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Apr 2020 18:48:13 -0700
Message-ID: <CAEf4Bza2YkmFMZ_d6d6keLqeWNDr8dbBQj=42xSrONaULK1PXg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 9:46 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Apr 14, 2020 at 09:45:08PM -0700, Andrii Nakryiko wrote:
> > >
> > > > FD is closed, dumper program is detached and dumper is destroyed
> > > > (unless pinned in bpffs, just like with any other bpf_link.
> > > > 3. At this point bpf_dumper_link can be treated like a factory of
> > > > seq_files. We can add a new BPF_DUMPER_OPEN_FILE (all names are for
> > > > illustration purposes) command, that accepts dumper link FD and
> > > > returns a new seq_file FD, which can be read() normally (or, e.g.,
> > > > cat'ed from shell).
> > >
> > > In this case, link_query may not be accurate if a bpf_dumper_link
> > > is created but no corresponding bpf_dumper_open_file. What we really
> > > need to iterate through all dumper seq_file FDs.
> >
> > If the goal is to iterate all the open seq_files (i.e., bpfdump active
> > sessions), then bpf_link is clearly not the right approach. But I
> > thought we are talking about iterating all the bpfdump programs
> > attachments, not **sessions**, in which case bpf_link is exactly the
> > right approach.
>
> That's an important point. What is the pinned /sys/kernel/bpfdump/tasks/foo ?

Assuming it's not a rhetorical question, foo is a pinned bpf_dumper
link (in my interpretation of all this).

> Every time 'cat' opens it a new seq_file is created with new FD, right ?

yes

> Reading of that file can take infinite amount of time, since 'cat' can be
> paused in the middle.

yep, correct (though most use case probably going to be very short-lived)

> I think we're dealing with several different kinds of objects here.
> 1. "template" of seq_file that is seen with 'ls' in /sys/kernel/bpfdump/

Let's clarify here again, because this can be interpreted differently.

Are you talking about, e.g., /sys/fs/bpfdump/task directory that
defines what class of items should be iterated? Or you are talking
about named dumper: /sys/fs/bpfdump/task/my_dumper?

If the former, I agree that it's not a link. If the latter, then
that's what we've been so far calling "a named bpfdumper". Which is
what I argue is a link, pinned in bpfdumpfs (*not bpffs*).

UPD: reading further, seems like it's some third interpretation, so
please clarify.

> 2. given instance of seq_file after "template" was open

Right, corresponding to "bpfdump session" (has its own unique session_id).

> 3. bpfdumper program

Yep, BPF_PROG_LOAD returns FD to verified bpfdumper program.

> 4. and now links. One bpf_link from seq_file template to bpf prog and

So I guess "seq_file template" is /sys/kernel/bpfdump/tasks direntry
itself, which has to be specified as FD during BPF_PROG_LOAD, is that
right? If yes, I agree, "seq_file template" + attached bpf_prog is a
link.

>   many other bpf_links from actual seq_file kernel object to bpf prog.

I think this one is not a link at all. It's a bpfdumper session. For
me this is equivalent of a single BPF program invocation on cgroup due
to a single packet. I understand that in this case it's multiple BPF
program invocations, so it's not exactly 1:1, but if we had an easy
way to do iteration from inside BPF program over all, say, tasks, that
would be one BPF program invocation with a loop inside. So to me one
seq_file session is analogous to a single BPF program execution (or,
say one hardware event triggering one execution of perf_event BPF
program).

>   I think both kinds of links need to be iteratable via get_next_id.
>
> At the same time I don't think 1 and 2 are links.
> read-ing link FD should not trigger program execution. link is the connecting
> abstraction. It shouldn't be used to trigger anything. It's static.
> Otherwise read-ing cgroup-bpf link would need to trigger cgroup bpf prog too.
> FD that points to actual seq_file is the one that should be triggering
> iteration of kernel objects and corresponding execution of linked prog.

Yep, I agree totally, reading bpf_link FD directly as if it was
seq_file seems weird and would support only a single time to read.

> That FD can be anon_inode returned from raw_tp_open (or something else)

raw_tp_open currently always returns bpf_link FDs, so if this suddenly
returns readable seq_file instead, that would be weird, IMO.


> or FD from open("/sys/kernel/bpfdump/foo").

Agreed.

>
> The more I think about all the objects involved the more it feels that the
> whole process should consist of three steps (instead of two).
> 1. load bpfdump prog
> 2. create seq_file-template in /sys/kernel/bpfdump/
>    (not sure which api should do that)

Hm... ok, I think seq_file-template means something else entirely.
It's not an attached BPF program, but also not a /sys/fs/bpfdump/task
"provider". What is it and what is its purpose? Also, how is it
cleaned up if application crashes between creating "seq_file-template"
and attaching BPF program to it?

> 3. use bpf_link_create api to attach bpfdumper prog to that seq_file-template
>
> Then when the file is opened a new bpf_link is created for that reading session.
> At the same time both kinds of links (to teamplte and to seq_file) should be
> iteratable for observability reasons, but get_fd_from_id on them should probably
> be disallowed, since holding such FD to these special links by other process
> has odd semantics.

This special get_fd_from_id handling for bpfdumper links (in your
interpretation) looks like a sign that using bpf_link to represent a
specific bpfdumper session is not the right design.

As for obserabilitiy of bpfdumper sessions, I think using bpfdump
program + task/file provider will give a good way to do this,
actually, with no need to maintain a separate IDR just for bpfdumper
sessions.

>
> Similarly for anon seq_file it should be three step process as well:
> 1. load bpfdump prog
> 2. create anon seq_file (api is tbd) that returns FD
> 3. use bpf_link_create to attach prog to seq_file FD
>
> May be it's all overkill. These are just my thoughts so far.

Just to contrast, in a condensed form, what I was proposing:

For named dumper:
1. load bpfdump prog
2. attach prog to bpfdump "provider" (/sys/fs/bpfdump/task), get
bpf_link anon FD back
3. pin link in bpfdumpfs (e.g., /sys/fs/bpfdump/task/my_dumper)
4. each open() of /sys/fs/bpfdump/task/my_dumper produces new
bpfdumper session/seq_file

For anon dumper:
1. load bpfdump prog
2. attach prog to bpfdump "provider" (/sys/fs/bpfdump/task), get
bpf_link anon FD back
3. give bpf_link FD to some new API (say, BPF_DUMP_NEW_SESSION or
whatever name) to create seq_file/bpfdumper session, which will create
FD that can be read(). One can do that many times, each time getting
its own bpfdumper session.

First two steps are exactly the same, as it should be, because
named/anon dumper is still the same dumper. Note also that we can use
bpf_link FD of named dumper and BPF_DUMP_NEW_SESSION command to also
create sessions, which further underlines that the only difference
between named and anon dumper is this bpfdumpfs direntry that allows
to create new seq_file/session by doing normal open(), instead of
BPF's BPF_DUMP_NEW_SESSION.

Named vs anon dumper is like "named" vs "anon" bpf_link -- we don't
even talk in those terms about bpf_link, because the only difference
is pinned direntry in a special FS, really.
