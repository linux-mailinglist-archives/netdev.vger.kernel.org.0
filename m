Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD94C1AD06B
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 21:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgDPTfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 15:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725894AbgDPTfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 15:35:21 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BFDC061A0C;
        Thu, 16 Apr 2020 12:35:20 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id c16so11740278qtv.1;
        Thu, 16 Apr 2020 12:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wzSTrGClbCuD66vOeVt8dV20r/AIZE3EJPZRsv7m3m8=;
        b=GBaMxZOd3VbZWU9YUgkoU3mrM629ONSJr6MhNYgkCv4FPFAuIsyev4sXlDveSCU01G
         pzd9Cmmcy2IDTW+CqFqoOD9Jg8/1ZKr1eRuomLcM331ReiVrI/t0uuUPbLk1Bub1S3aw
         QvWMOd+4H8h8drwZp3epAZ+VxwLAdAJm6P5cUpriclXh2b7hQK1EeWiiQ1sKMkzdYxct
         qfebXiOxaeVcxIcOPhr+1t4LC3wFdqRPN0xmRzQQ0HaO02HD8OM32Hm7EUpWS3cw7W6f
         pcy44scCu898h6Nz7srsZ8cqWocCMd4Iq3nQUcNUlGf2+xize27Yd8QHv+goUVKbhb96
         wWNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wzSTrGClbCuD66vOeVt8dV20r/AIZE3EJPZRsv7m3m8=;
        b=gReAoXYC9jxvWp54bRg88l0hrQH7d1ocdcaktsIWTzlhWqfthX9/IsV24DuK0XpOAa
         mDWSr1JW4LD7RMkqBK3aoz8rkSc3YqPkq+0TPnvOSUJDFCJfHA/UajF65EHYX/QxUQkW
         UdjNuyCfe6IYllGZ/aoYxGyf/k4SYMMEEb9yJqqeURM43zuZFNlJHM/WWOZihLl6IRWp
         p0mcnLhS14Rc7B3bzyMtDkMqigDxDVuSyzLyWm9NGre7ybVYZ8I/qv1Xvb4e+3XLiesy
         Yjp/faAhfbUOksFuspOlYGhYeEmBl19BSKaBWMr/62lvgdMa2Q4vhKYPnLJShQh+AQJP
         OCTg==
X-Gm-Message-State: AGi0PuauUEDTxV27Dg0/gZuYjoKGaMObkHNffjdfMPoDgL4d86FP1ybp
        FZwkTjdkg3844NsItF923CIbDvsvns3gamupxEKPy+9H4uc=
X-Google-Smtp-Source: APiQypJp0bdfUsnncb/cjJlJkyvxqJ4C7H+5xML0Q2laxoKrvNq2weLhzs/b+p8Ox3pRTwPrcl8uHGVdT9bF17HDEmw=
X-Received: by 2002:aed:2e24:: with SMTP id j33mr27610688qtd.117.1587065719592;
 Thu, 16 Apr 2020 12:35:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232526.2675664-1-yhs@fb.com>
 <CAEf4Bzawu2dFXL7nvYhq1tKv9P7Bb9=6ksDpui5nBjxRrx=3_w@mail.gmail.com>
 <4bf72b3c-5fee-269f-1d71-7f808f436db9@fb.com> <CAEf4BzZnq958Guuusb9y65UCtB-DARxdk7_q7ZPBZ3WOwjSKaw@mail.gmail.com>
 <20200415164640.evaujoootr4n55sc@ast-mbp> <CAEf4Bza2YkmFMZ_d6d6keLqeWNDr8dbBQj=42xSrONaULK1PXg@mail.gmail.com>
 <20200416170414.ds3hcb3bgfetjt4v@ast-mbp>
In-Reply-To: <20200416170414.ds3hcb3bgfetjt4v@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Apr 2020 12:35:07 -0700
Message-ID: <CAEf4BzY0a_Rzt8vtLLSz3+xAhx0CWhetxcUNdyK7ZygMms7srA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 10:04 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Apr 15, 2020 at 06:48:13PM -0700, Andrii Nakryiko wrote:
> > On Wed, Apr 15, 2020 at 9:46 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Apr 14, 2020 at 09:45:08PM -0700, Andrii Nakryiko wrote:
> > > > >
> > > > > > FD is closed, dumper program is detached and dumper is destroye=
d
> > > > > > (unless pinned in bpffs, just like with any other bpf_link.
> > > > > > 3. At this point bpf_dumper_link can be treated like a factory =
of
> > > > > > seq_files. We can add a new BPF_DUMPER_OPEN_FILE (all names are=
 for
> > > > > > illustration purposes) command, that accepts dumper link FD and
> > > > > > returns a new seq_file FD, which can be read() normally (or, e.=
g.,
> > > > > > cat'ed from shell).
> > > > >
> > > > > In this case, link_query may not be accurate if a bpf_dumper_link
> > > > > is created but no corresponding bpf_dumper_open_file. What we rea=
lly
> > > > > need to iterate through all dumper seq_file FDs.
> > > >
> > > > If the goal is to iterate all the open seq_files (i.e., bpfdump act=
ive
> > > > sessions), then bpf_link is clearly not the right approach. But I
> > > > thought we are talking about iterating all the bpfdump programs
> > > > attachments, not **sessions**, in which case bpf_link is exactly th=
e
> > > > right approach.
> > >
> > > That's an important point. What is the pinned /sys/kernel/bpfdump/tas=
ks/foo ?
> >
> > Assuming it's not a rhetorical question, foo is a pinned bpf_dumper
> > link (in my interpretation of all this).
>
> It wasn't rhetorical question and your answer is differrent from mine :)
> It's not a link. It's a template of seq_file. It's the same as
> $ stat /proc/net/ipv6_route
>   File: =E2=80=98/proc/net/ipv6_route=E2=80=99
>   Size: 0               Blocks: 0          IO Block: 1024   regular empty=
 file

I don't see a contradiction. Pinning bpfdumper link in bpfdumpfs will
create a direntry and corresponding inode. That inode's i_private
field will contain a pointer to that link. When that direntry is
open()'ed, seq_file is going to be created. That seq_file will
probably need to take refcnt on underlying bpf_link and store it in
its private data. I was *not* implying that
/sys/kernel/bpfdump/tasks/foo is same as bpf_link pinned in bpffs,
which you can restore by doing BPF_OBJ_GET. It's more of a "backed by
bpf_link", if that helps to clarify.

But in your terminology, bpfdumper bpf_link *is* "a template of
seq_file", that I agree.

>
> > > Every time 'cat' opens it a new seq_file is created with new FD, righ=
t ?
> >
> > yes
> >
> > > Reading of that file can take infinite amount of time, since 'cat' ca=
n be
> > > paused in the middle.
> >
> > yep, correct (though most use case probably going to be very short-live=
d)
> >
> > > I think we're dealing with several different kinds of objects here.
> > > 1. "template" of seq_file that is seen with 'ls' in /sys/kernel/bpfdu=
mp/
> >
> > Let's clarify here again, because this can be interpreted differently.
> >
> > Are you talking about, e.g., /sys/fs/bpfdump/task directory that
> > defines what class of items should be iterated? Or you are talking
> > about named dumper: /sys/fs/bpfdump/task/my_dumper?
>
> the latter.
>
> >
> > If the former, I agree that it's not a link. If the latter, then
> > that's what we've been so far calling "a named bpfdumper". Which is
> > what I argue is a link, pinned in bpfdumpfs (*not bpffs*).
>
> It cannot be a link, since link is only a connection between
> kernel object and bpf prog.
> Whereas seq_file is such kernel object.

Not sure, but maybe that's where the misconnect is? seq_file instance
is derivative of bpf_prog + bpfdump provider. That couplin of bpf_prog
and provider is a link to me. That bpf_link can be used to "produce"
many independent seq_files then.

I do agree that link is a connection between prog and kernel object,
but I argue that "kernel object" in this case is bpfdumper provider
(e.g., what is backing /sys/fs/bpfdump/task), not any specific
seq_file.

>
> >
> > For named dumper:
> > 1. load bpfdump prog
> > 2. attach prog to bpfdump "provider" (/sys/fs/bpfdump/task), get
> > bpf_link anon FD back
> > 3. pin link in bpfdumpfs (e.g., /sys/fs/bpfdump/task/my_dumper)
> > 4. each open() of /sys/fs/bpfdump/task/my_dumper produces new
> > bpfdumper session/seq_file
> >
> > For anon dumper:
> > 1. load bpfdump prog
> > 2. attach prog to bpfdump "provider" (/sys/fs/bpfdump/task), get
> > bpf_link anon FD back
> > 3. give bpf_link FD to some new API (say, BPF_DUMP_NEW_SESSION or
> > whatever name) to create seq_file/bpfdumper session, which will create
> > FD that can be read(). One can do that many times, each time getting
> > its own bpfdumper session.
>
> I slept on it and still fundamentally disagree that seq_file + bpf_prog
> is a derivative of link. Or in OoO terms it's not a child class of bpf_li=
nk.
> seq_file is its own class that should contain bpf_link as one of its
> members, but it shouldn't be derived from 'class bpf_link'.

Referring to inheritance here doesn't seem necessary or helpful, I'd
rather not confuse and complicate all this further.

bpfdump provider/target + bpf_prog =3D bpf_link. bpf_link is "a factory"
of seq_files. That's it, no inheritance.


>
> In that sense Yonghong proposed api (raw_tp_open to create anon seq_file+=
prog
> and obj_pin to create a template of named seq_file+prog) are the best fit=
.
> Implementation wise his 'struct extra_priv_data' needs to include
> 'struct bpf_link' instead of 'struct bpf_prog *prog;' directly.
>
> So evertime 'cat' opens named seq_file there is bpf_link registered in ID=
R.
> Anon seq_file should have another bpf_link as well.

So that's where I disagree and don't see the point of having all those
short-lived bpf_links. cat opening seq_file doesn't create a bpf_link,
it creates a seq_file. If we want to associate some ID with it, it's
fine, but it's not a bpf_link ID (in my opinion, of course).

>
> My earlier suggestion to disallow get_fd_from_id for such links is wrong.
> It's fine to get an FD to such link, but it shouldn't prevent destruction

This is again some custom limitations and implementation, which again
I think is a sign of not ideal design for this. And now that we'll
have bpfdumper for iterate task/file, I also don't think that
everything should have ID to be "iterable" anymore.


> of seq_file. 'cat' will close named seq_file and 'struct extra_priv_data'=
 class
> should do link_put. If some other process did get_fd_from_id then such li=
nk will
> become dangling. Just like removal of netdev will make dangling xdp links=
.
