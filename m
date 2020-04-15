Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6921A920A
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 06:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393110AbgDOEpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 00:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389526AbgDOEpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 00:45:21 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3D4C061A0C;
        Tue, 14 Apr 2020 21:45:21 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id v38so1089233qvf.6;
        Tue, 14 Apr 2020 21:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nfNa93KrrCTo3pp8oA599wmeGGVr6mWMuKzzexYFyEM=;
        b=SGg6N7rDY4XCQe4s1RPeIRwSMJ7bryn+xjjB7jszUtjQd9l0nEyxio8z6wbsUvhrzW
         5JIwj2pxPmyKp6FsoXiwV1lca+xIVScpq2k9Z7FC8Omo5x0NZf2vQh9GwYFAdmYj0jlt
         bzh4JNJ3d69k6+ulNZvkVe3RRqDoABrVK/AE5VZX9RgNcPoEJfDnX/En/1jOOpFlO8Ky
         g0KLaLnPS/Bo0h+yDQJwGBsB9XdAhCTP3UVuweuPFM9rBxrK5oOXMfg0FlB6w5z1MnPP
         dPTGrbwBDKlEjZRQqIttWKQEGfRQ2ertGHYx92daqs5zA2gq2Cg19jEMAIiC/85QeG5N
         yRbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nfNa93KrrCTo3pp8oA599wmeGGVr6mWMuKzzexYFyEM=;
        b=RTPQdA772aiI1/qUvvDgEwoyIeDT3ZfEESPqVYrXZsjpeDNABvqRkOkwf5fXXKZjqZ
         h8mhaeHkEZgIJ10bFjuZ76xzPKikM6nNaUkNksx9He9zTU7M1JTN6v6iS/7DXX+Upukt
         I8kvMX41r7g5gMPqB+LVETvelrO1gEnvZv/Vn4iazuxnx/JoeDzCQU7uYo5VbLVTeb/m
         gcyUq9qz8gQPUSKzBO1yIXMFoH6aXAB4H68J3mHhZd5JXVL8fb6BD9I0Lm1WpBj+S33V
         rbHFIaqsZzeD2JVMz7yp1mA4VsB/TmOrwOJS29xwnfiUXHZl/Yj1uqUX8LYnPjrgmLhe
         bGyw==
X-Gm-Message-State: AGi0PuZ9xI3yCP6jgBRgjc7AeWbbcc7jjihqzWlR9vo49nChry+Pv0hw
        ZJ7Q/bbhzb8K0ITgQ487IpqeUcNeZ2l0NLeKO68=
X-Google-Smtp-Source: APiQypIsXTy/0i7aZDhTzCWirf5n8dO6zfAFro145WN3Jy4OfDjS97AMNo/0mq06Ok671EJDcIn7PS8JLWe1K86n7og=
X-Received: by 2002:a0c:f74b:: with SMTP id e11mr3325545qvo.196.1586925919957;
 Tue, 14 Apr 2020 21:45:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232526.2675664-1-yhs@fb.com>
 <CAEf4Bzawu2dFXL7nvYhq1tKv9P7Bb9=6ksDpui5nBjxRrx=3_w@mail.gmail.com> <4bf72b3c-5fee-269f-1d71-7f808f436db9@fb.com>
In-Reply-To: <4bf72b3c-5fee-269f-1d71-7f808f436db9@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Apr 2020 21:45:08 -0700
Message-ID: <CAEf4BzZnq958Guuusb9y65UCtB-DARxdk7_q7ZPBZ3WOwjSKaw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 4:59 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/13/20 10:56 PM, Andrii Nakryiko wrote:
> > On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> Given a loaded dumper bpf program, which already
> >> knows which target it should bind to, there
> >> two ways to create a dumper:
> >>    - a file based dumper under hierarchy of
> >>      /sys/kernel/bpfdump/ which uses can
> >>      "cat" to print out the output.
> >>    - an anonymous dumper which user application
> >>      can "read" the dumping output.
> >>
> >> For file based dumper, BPF_OBJ_PIN syscall interface
> >> is used. For anonymous dumper, BPF_PROG_ATTACH
> >> syscall interface is used.
> >
> > We discussed this offline with Yonghong a bit, but I thought I'd put
> > my thoughts about this in writing for completeness. To me, it seems
> > like the most consistent way to do both anonymous and named dumpers is
> > through the following steps:
>
> The main motivation for me to use bpf_link is to enumerate
> anonymous bpf dumpers by using idr based link_query mechanism in one
> of previous Andrii's RFC patch so I do not need to re-invent the wheel.
>
> But looks like there are some difficulties:
>
> >
> > 1. BPF_PROG_LOAD to load/verify program, that created program FD.
> > 2. LINK_CREATE using that program FD and direntry FD. This creates
> > dumper bpf_link (bpf_dumper_link), returns anonymous link FD. If link
>
> bpf dump program already have the target information as part of
> verification propose, so it does not need directory FD.
> LINK_CREATE probably not a good fit here.
>
> bpf dump program is kind similar to fentry/fexit program,
> where after successful program loading, the program will know
> where to attach trampoline.
>
> Looking at kernel code, for fentry/fexit program, at raw_tracepoint_open
> syscall, the trampoline will be installed and actually bpf program will
> be called.
>

direntry FD doesn't have to be specified at attach time, I forgot that
it is already provided during load. That wasn't a requirement or
critical part. I think if we already had LINK_CREATE command, we'd
never have to create RAW_TRACEPOINT_OPEN one, all of them could be the
same command.

> So, ideally, if we want to use kernel bpf_link, we want to
> return a cat-able bpf_link because ultimately we want to query
> file descriptors which actually 'read' bpf program outputs.
>
> Current bpf_link is not cat-able.

Let's be precise here. By cat-able you mean that you'd like to just
start issuing read() calls and get output of bpfdump program, is that
right? Wouldn't that mean that you can read output just once? So it
won't be possible to create anonymous dumper and periodically get
up-to-date output. User would need to call RAW_TRACEPOINT_OPEN every
single time it would need to do a dump. I guess that would work, but
I'm not seeing why it has to be that way.

What I proposed above was that once you create a bpf_link, you can use
that same bpf_link to open many seq_files, each with its own FD, which
can be read() independently of each other. This behavior would be
consistent with named bpfdumper, which can produce many independent
seq_files with each new open() syscall, but all from exactly the same
attached bpfdumper.

> I try to hack by manipulating fops and other stuff, it may work,
> but looks ugly. Or we create a bpf_catable_link and build an
> infrastructure around that? Not sure whether it is worthwhile for this
> one-off thing (bpfdump)?
>
> Or to query anonymous bpf dumpers, I can just write a bpf dump program
> to go through all fd's to find out.
>
> BTW, my current approach (in my private branch),
> anonymous dumper:
>     bpf_raw_tracepoint_open(NULL, prog) -> cat-able fd

So just to re-iterate. If my understanding is correct, this cat-able
fd is a single seq_file. If you want to dump it again, you would call
bpf_raw_tracepoint_open() again?

> file dumper:
>     bpf_obj_pin(prog, path)  -> a cat-able file

While in this case, you'd open() as many times as you need and get new
cat-able fd for each of those calls.

>
> If you consider program itself is a link, this is like what
> described below in 3 and 4.

Program is not a link. Same as cgroup BPF program attached somewhere
to a cgroup is not a link. Because that BPF program can be attached to
multiple cgroups or even under multiple attach types to the same
cgroup. Same here, same dumper can be "attached" in bpfdumpfs multiple
times, and each instance of attachment is link, but it's still the
same program.

>
>
> > FD is closed, dumper program is detached and dumper is destroyed
> > (unless pinned in bpffs, just like with any other bpf_link.
> > 3. At this point bpf_dumper_link can be treated like a factory of
> > seq_files. We can add a new BPF_DUMPER_OPEN_FILE (all names are for
> > illustration purposes) command, that accepts dumper link FD and
> > returns a new seq_file FD, which can be read() normally (or, e.g.,
> > cat'ed from shell).
>
> In this case, link_query may not be accurate if a bpf_dumper_link
> is created but no corresponding bpf_dumper_open_file. What we really
> need to iterate through all dumper seq_file FDs.

If the goal is to iterate all the open seq_files (i.e., bpfdump active
sessions), then bpf_link is clearly not the right approach. But I
thought we are talking about iterating all the bpfdump programs
attachments, not **sessions**, in which case bpf_link is exactly the
right approach.


>
> > 4. Additionally, this anonymous bpf_link can be pinned/mounted in
> > bpfdumpfs. We can do it as BPF_OBJ_PIN or as a separate command. Once
> > pinned at, e.g., /sys/fs/bpfdump/task/my_dumper, just opening that
> > file is equivalent to BPF_DUMPER_OPEN_FILE and will create a new
> > seq_file that can be read() independently from other seq_files opened
> > against the same dumper. Pinning bpfdumpfs entry also bumps refcnt of
> > bpf_link itself, so even if process that created link dies, bpf dumper
> > stays attached until its bpfdumpfs entry is deleted.
> >
> > Apart from BPF_DUMPER_OPEN_FILE and open()'ing bpfdumpfs file duality,
> > it seems pretty consistent and follows safe-by-default auto-cleanup of
> > anonymous link, unless pinned in bpfdumpfs (or one can still pin
> > bpf_link in bpffs, but it can't be open()'ed the same way, it just
> > preserves BPF program from being cleaned up).
> >
> > Out of all schemes I could come up with, this one seems most unified
> > and nicely fits into bpf_link infra. Thoughts?
> >
> >>
> >> To facilitate target seq_ops->show() to get the
> >> bpf program easily, dumper creation increased
> >> the target-provided seq_file private data size
> >> so bpf program pointer is also stored in seq_file
> >> private data.
> >>
> >> Further, a seq_num which represents how many
> >> bpf_dump_get_prog() has been called is also
> >> available to the target seq_ops->show().
> >> Such information can be used to e.g., print
> >> banner before printing out actual data.
> >>
> >> Note the seq_num does not represent the num
> >> of unique kernel objects the bpf program has
> >> seen. But it should be a good approximate.
> >>
> >> A target feature BPF_DUMP_SEQ_NET_PRIVATE
> >> is implemented specifically useful for
> >> net based dumpers. It sets net namespace
> >> as the current process net namespace.
> >> This avoids changing existing net seq_ops
> >> in order to retrieve net namespace from
> >> the seq_file pointer.
> >>
> >> For open dumper files, anonymous or not, the
> >> fdinfo will show the target and prog_id associated
> >> with that file descriptor. For dumper file itself,
> >> a kernel interface will be provided to retrieve the
> >> prog_id in one of the later patches.
> >>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >>   include/linux/bpf.h            |   5 +
> >>   include/uapi/linux/bpf.h       |   6 +-
> >>   kernel/bpf/dump.c              | 338 ++++++++++++++++++++++++++++++++-
> >>   kernel/bpf/syscall.c           |  11 +-
> >>   tools/include/uapi/linux/bpf.h |   6 +-
> >>   5 files changed, 362 insertions(+), 4 deletions(-)
> >>
> >
> > [...]
> >
