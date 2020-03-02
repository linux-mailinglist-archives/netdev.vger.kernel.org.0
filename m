Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F60176844
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 00:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgCBXfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 18:35:25 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46068 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgCBXfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 18:35:24 -0500
Received: by mail-qt1-f195.google.com with SMTP id a4so1440101qto.12;
        Mon, 02 Mar 2020 15:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OJBDJwENWHOoZ+46E7dRo/9snsZhqqc7tcN3yi+LXck=;
        b=FMwKPQh+jE8ZmYvb003EggDyy5MSTsMT/wYx5SXLCfSLIjkIB8tURYc9SJBsb/bWJA
         1EA2f5mKZUP7p5YvTIxYOZfZks4jhft+as2oobmiqClUj7sfO6L0PzDGO6Ju7555h+pl
         xW6+/IiL2X0IkB0777c2ruPAqDO+Y9O5rKzGHZ3LsdEFI2bziOze9xlHFvMwjMuPL92M
         OXGYoNMVfQUgjPFvhscwB4E49tpogq+sGUa5O4BCydpM1JhPnSP9necvXV9vzsbfXqkN
         bycsli3yMwHQzLZz77E8imWr2DGdGKCHkBVoKvs10cuc9/JpBGpwm8FY2d0V/Wg/ZmID
         dKTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OJBDJwENWHOoZ+46E7dRo/9snsZhqqc7tcN3yi+LXck=;
        b=biNTLEEISiy4inbiE6LI6r9jJFlvFJ8CkQKnOEBMLz3GJUfVs8y8h7vseGfzyMAKCT
         Y9CJ/th8SlIObi+2mjZbAL5l3UPDqef5jTcAdmskX/XqyFoYb1Mk6iPHgKZCuD64Wyu+
         FQGTAfrMi2tKfgc0AwxvsAQobnzIDIK+BZaI0GIiWym3r3o+TfNRJ/+fZYiveRKqGLVe
         tS/1XbJszbnj4XTjodqefFxu5g8Pj5GyxYEUjWErEPRBErXoRL3/TUVGz/gKL/6PpKez
         Nc6Tx8rqQOdosMGCxEvlJuCVm+3em39HgFOwRjohTmPn/rLQkzr9ex1kJEg9RJS4II0u
         P07Q==
X-Gm-Message-State: ANhLgQ3coJp2lmEkOMolpQmvsu1M+lTlcYmlslDam95bk1ai8oWS22s8
        94B0+v8pBnRvUyffbahLtEZU8Gs+Pbi7Sqkxd6g=
X-Google-Smtp-Source: ADFU+vsm/N0cc0BoHt46WrI0A20Trzy8ErDlj27hXv8Gg1s8IyEmUC3KEFsVZsiY9eK7+91fDIWdgEUaf2p5t+PWIuU=
X-Received: by 2002:ac8:140c:: with SMTP id k12mr1993769qtj.117.1583192123457;
 Mon, 02 Mar 2020 15:35:23 -0800 (PST)
MIME-Version: 1.0
References: <20200228223948.360936-1-andriin@fb.com> <87mu8zt6a8.fsf@toke.dk>
 <CAEf4BzZGn9FcUdEOSR_ouqSNvzY2AdJA=8ffMV5mTmJQS-10VA@mail.gmail.com> <87imjms8cm.fsf@toke.dk>
In-Reply-To: <87imjms8cm.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Mar 2020 15:35:12 -0800
Message-ID: <CAEf4BzbUpfKfB6raqwvTFPm_13Een7A9WUbQeSjdAtvcEU3nLA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel abstraction
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
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

On Mon, Mar 2, 2020 at 2:25 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Mon, Mar 2, 2020 at 2:12 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> Andrii Nakryiko <andriin@fb.com> writes:
> >>
> >> > This patch series adds bpf_link abstraction, analogous to libbpf's a=
lready
> >> > existing bpf_link abstraction. This formalizes and makes more unifor=
m existing
> >> > bpf_link-like BPF program link (attachment) types (raw tracepoint an=
d tracing
> >> > links), which are FD-based objects that are automatically detached w=
hen last
> >> > file reference is closed. These types of BPF program links are switc=
hed to
> >> > using bpf_link framework.
> >> >
> >> > FD-based bpf_link approach provides great safety guarantees, by ensu=
ring there
> >> > is not going to be an abandoned BPF program attached, if user proces=
s suddenly
> >> > exits or forgets to clean up after itself. This is especially import=
ant in
> >> > production environment and is what all the recent new BPF link types=
 followed.
> >> >
> >> > One of the previously existing  inconveniences of FD-based approach,=
 though,
> >> > was the scenario in which user process wants to install BPF link and=
 exit, but
> >> > let attached BPF program run. Now, with bpf_link abstraction in plac=
e, it's
> >> > easy to support pinning links in BPF FS, which is done as part of th=
e same
> >> > patch #1. This allows FD-based BPF program links to survive exit of =
a user
> >> > process and original file descriptor being closed, by creating an fi=
le entry
> >> > in BPF FS. This provides great safety by default, with simple way to=
 opt out
> >> > for cases where it's needed.
> >>
> >> While being able to pin the fds returned by bpf_raw_tracepoint_open()
> >> certainly helps, I still feel like this is the wrong abstraction for
> >> freplace(): When I'm building a program using freplace to put in new
> >> functions (say, an XDP multi-prog dispatcher :)), I really want the
> >> 'new' functions (i.e., the freplace'd bpf_progs) to share their lifeti=
me
> >> with the calling BPF program. I.e., I want to be able to do something
> >> like:
> >
> > freplace programs will take refcount on a BPF program they are
> > replacing, so in that sense they do share lifetime, except dependency
> > is opposite to what you describe: rootlet/dispatcher program can't go
> > away as long it has at least one freplace program attached. It
> > (dispatcher) might get detached, though, but freplace, technically,
> > will still be attached to now-detached dispatcher (so won't be
> > invoked, yet still attached). I hope that makes sense :)
>
> Yes, I realise that; I just think it's the wrong way 'round :)
>
> >> prog_fd =3D sys_bpf(BPF_PROG_LOAD, ...); // dispatcher
> >> func_fd =3D sys_bpf(BPF_PROG_LOAD, ...); // replacement func
> >> err =3D sys_bpf(BPF_PROG_REPLACE_FUNC, prog_fd, btf_id, func_fd); // d=
oes *not* return an fd
> >>
> >> That last call should make the ref-counting be in the prog_fd -> func_=
fd
> >> direction, so that when prog_fd is released, it will do
> >> bpf_prog_put(func_fd). There could be an additional call like
> >> sys_bpf(BPF_PROG_REPLACE_FUNC_DETACH, prog_fd, btf_id) for explicit
> >> detach as well, of course.
> >
> > Taking this additional refcount will create a dependency loop (see
> > above), so that's why it wasn't done, I think.
>
> Right, that's why I want the new operation to 'flip' the direction of
> the refcnt inside the kernel, so there would no longer be a reference
> from the replacement to the dispatcher, only the other way (so no
> loops).
>
> > With FD-based bpf_link, though, you'll be able to "transfer ownership"
> > from application that installed freplace program in the first place,
> > to the program that eventually will unload/replace dispatcher BPF
> > program. You do that by pinning freplace program in BPFFS location,
> > that's known to this libxdp library, and when you need to detach and
> > unload XDP dispatcher and overriden XDP programs, the "admin process"
> > which manages XDP dispatcher, will be able to just go and unpin and
> > detach everything, if necessary.
>
> Yes, so let's assume we want to do it this way (with replacement
> programs pinned in a known location in bpffs). First off, that will
> introduce a hard dependency on bpffs for XDP; so now your networking
> program also needs access to mounting filesystems, or you need to rely
> on the system (including your container runtime) to set this up right
> for you.
>
> Assuming that has been solved, the steps to replace an existing set of
> programs with a new one would be something like:
>
> 0. We assume that we already have /sys/fs/bpf/xdp/eth0/mainprog,
>    /sys/fs/bpf/xdp/eth0/prog1, /sys/fs/bpf/xdp/eth0/prog2, and that
>    mainprog is attached to eth0
>
> 1. Create new dispatcher, attach programs, pin replacement progs
>    somewhere (/sys/fs/bpf/xdp/eth0.new/{mainprog,prog1,prog2,prog3}?)
>
> 2. Attach new mainprog to eth0, replacing the old one
>
> 3. `mv /sys/fs/bpf/xdp/eth0 /sys/fs/bpf/xdp/eth0.old`
>
> 4. `mv /sys/fs/bpf/xdp/eth0.new /sys/fs/bpf/xdp/eth0`
>
> 5. `rm -r /sys/fs/bpf/xdp/eth0.old`
>
>
> Or you could switch steps 2 and 3. Either way, there is no way to do
> steps 2..4 as one atomic operation; so you can end up in an inconsistent
> state.
>

I understand that as well :) But bpf_link is not trying to solve this
multi-XDP program use cases. What it does solve is making it possible
to have "ephemeral" FD-based attachment points (links), which by
default will be auto-detached if process exists or crashes (so they
are safe for production use and don't leave unaccounted BPF programs
running). But they allow to turn that "ephemeral" link into
"permanent" one by pinning it in BPF FS. That's it, I wasn't trying to
solve your specific use case. It does help with preserving XDP
dispatcher indefinitely, though. So that original process that created
XDP dispatcher doesn't have to use existing "permanent" XDP program
attachment and doesn't have to stay alive for too long.

All the XDP chaining specific issues should probably discussed on your
original thread that includes Andrey as well.

> Oh, and what happens if the netdevice moves namespaces while it has an
> XDP program attached? Then you can end up with the bpffs where you
> pinned the programs originally not being available at all anymore.
>
> Contrast this to the case where the replacement programs are just
> referenced from the main prog: none of the above will be necessary, and
> replacement will just be one atomic operation on the interface.

I don't think it's that simple. To do this atomic switch, you'll need
to be able to attach same XDP program to two different XDP
dispatchers, which isn't possible today. But again, I don't think this
thread is the right place to discuss those issues.

>
> >> With such an API, lifecycle management for an XDP program keeps being
> >> obvious: There's an fd for the root program attached to the interface,
> >> and that's it. When that is released the whole thing disappears. Where=
as
> >> with the bpf_raw_tracepoint_open() API, the userspace program suddenly
> >> has to make sure all the component function FDs are pinned, which seem=
s
> >> cumbersome and error-prone...
> >
> > I thought that's what libxdp is supposed to do (among other things).
> > So for user applications it will be all hidden inside the library API,
> > no?
>
> Sure, but that also means that even if we somehow manage to write a
> library without any bugs, it will still be called from arbitrary
> applications that may crash between two operations and leave things in
> an inconsistent state.

Whatever that library does, it shouldn't leave the host system in a
bad state despite any possible crashes, that should be designed in,
regardless of specific mechanism used. Which is also a reason for
having FD-based ephemeral links, because they will get cleaned up
automatically on crash, unless library reached stable point where
attached program can be permanently pinned. But again, that's general
problem, not just with XDP programs, but with cgroup programs and
others, which is what I try to address with bpf_link. Let's continue
discussing XDP dispatcher stuff on respective mail thread.

>
> So I guess what I'm saying is that while it most likely is *possible* to
> build the multi-prog facility using bpf_raw_tracepoint_open() + pinning,
> I believe that the result will be brittle, and that we would be better
> served with a different kernel primitive.
>
> Do you see what I mean? Or am I missing something obvious here?
>
> -Toke
>
