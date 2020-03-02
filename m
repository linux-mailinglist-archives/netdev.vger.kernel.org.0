Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 611F41766D7
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 23:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgCBWZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 17:25:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37452 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726728AbgCBWZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 17:25:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583187901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9hRBKtE+c+GniMKyGrkqhdyv1XsV6MxZ4SgNtQszIdk=;
        b=h/LIIMf/1GGSs2PqrEN1urzJml6emTkZO3Wa26469aqRTRyKMJ+JPdsqQBoWPLjJyvJZW4
        +hKEkRx5CxHv5/Gg6Zr037IAOY8xagcx3z6Rjq5Ky490rKfZvh6ekEVMvj71G2ds2a+O/n
        ketRL9pXeV4PQbrC5R+cVpBCj9Hb7yY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-Sv2cHq2gMOaPy2pPcYt-5w-1; Mon, 02 Mar 2020 17:25:00 -0500
X-MC-Unique: Sv2cHq2gMOaPy2pPcYt-5w-1
Received: by mail-wr1-f71.google.com with SMTP id c6so311534wrm.18
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 14:24:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=9hRBKtE+c+GniMKyGrkqhdyv1XsV6MxZ4SgNtQszIdk=;
        b=ujuAe3el8vCtt6MCgHyIH26DwVCFyHnftu5fsoFXc/EX94C7R9e7dGzz0bMDx+F4xD
         /HE+eZjko/MH5Z248L6ODF9LVVF/2jptj6R0avzWohgR30e+acA1sxVFKWyvlwKIBq6o
         hYRxrIxl1hqBhCedR8nVEN1tNJAW/lBko5k3GLv+OO+Ocw9GQ1NCpzyCpb+Gt2HgJXbA
         3ld5T/lYqf/9ZKt3Y9v2GbCOHpgclhodCcDsQVZd5PtAu3yASJl1MZSRuq4o8rGnFGqE
         UlUNwKJTBQsZgjEYpUhuR3CMX0kPVerTXNMTah132eDsqpvy/q7vH8jHpaYbNVorOcK8
         1peg==
X-Gm-Message-State: ANhLgQ1m38mf9FFkyaGsnjJDAA3OIWhM4yRWWaIbPWh/KHz312IyqEwR
        9G92BuXYjcbaV5c+cFfEzr3hcoQxsC3Dd1w3IstLuPHp/bcD0TqEkUxWNX/5gGNEnRY4/bUM9g9
        63l4XywdK10fo3c7r
X-Received: by 2002:adf:e98f:: with SMTP id h15mr1611426wrm.263.1583187898908;
        Mon, 02 Mar 2020 14:24:58 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuAbuSsx0O1zNIkxBIHyrRcg7hxX1SzEWLl9MR22QqpnbKcgKFRz1C5BsRmuNY0YXa0oMVdmA==
X-Received: by 2002:adf:e98f:: with SMTP id h15mr1611399wrm.263.1583187898481;
        Mon, 02 Mar 2020 14:24:58 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f127sm606808wma.4.2020.03.02.14.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 14:24:57 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 27BD1180362; Mon,  2 Mar 2020 23:24:57 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel abstraction
In-Reply-To: <CAEf4BzZGn9FcUdEOSR_ouqSNvzY2AdJA=8ffMV5mTmJQS-10VA@mail.gmail.com>
References: <20200228223948.360936-1-andriin@fb.com> <87mu8zt6a8.fsf@toke.dk> <CAEf4BzZGn9FcUdEOSR_ouqSNvzY2AdJA=8ffMV5mTmJQS-10VA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 02 Mar 2020 23:24:57 +0100
Message-ID: <87imjms8cm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Mar 2, 2020 at 2:12 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> Andrii Nakryiko <andriin@fb.com> writes:
>>
>> > This patch series adds bpf_link abstraction, analogous to libbpf's alr=
eady
>> > existing bpf_link abstraction. This formalizes and makes more uniform =
existing
>> > bpf_link-like BPF program link (attachment) types (raw tracepoint and =
tracing
>> > links), which are FD-based objects that are automatically detached whe=
n last
>> > file reference is closed. These types of BPF program links are switche=
d to
>> > using bpf_link framework.
>> >
>> > FD-based bpf_link approach provides great safety guarantees, by ensuri=
ng there
>> > is not going to be an abandoned BPF program attached, if user process =
suddenly
>> > exits or forgets to clean up after itself. This is especially importan=
t in
>> > production environment and is what all the recent new BPF link types f=
ollowed.
>> >
>> > One of the previously existing  inconveniences of FD-based approach, t=
hough,
>> > was the scenario in which user process wants to install BPF link and e=
xit, but
>> > let attached BPF program run. Now, with bpf_link abstraction in place,=
 it's
>> > easy to support pinning links in BPF FS, which is done as part of the =
same
>> > patch #1. This allows FD-based BPF program links to survive exit of a =
user
>> > process and original file descriptor being closed, by creating an file=
 entry
>> > in BPF FS. This provides great safety by default, with simple way to o=
pt out
>> > for cases where it's needed.
>>
>> While being able to pin the fds returned by bpf_raw_tracepoint_open()
>> certainly helps, I still feel like this is the wrong abstraction for
>> freplace(): When I'm building a program using freplace to put in new
>> functions (say, an XDP multi-prog dispatcher :)), I really want the
>> 'new' functions (i.e., the freplace'd bpf_progs) to share their lifetime
>> with the calling BPF program. I.e., I want to be able to do something
>> like:
>
> freplace programs will take refcount on a BPF program they are
> replacing, so in that sense they do share lifetime, except dependency
> is opposite to what you describe: rootlet/dispatcher program can't go
> away as long it has at least one freplace program attached. It
> (dispatcher) might get detached, though, but freplace, technically,
> will still be attached to now-detached dispatcher (so won't be
> invoked, yet still attached). I hope that makes sense :)

Yes, I realise that; I just think it's the wrong way 'round :)

>> prog_fd =3D sys_bpf(BPF_PROG_LOAD, ...); // dispatcher
>> func_fd =3D sys_bpf(BPF_PROG_LOAD, ...); // replacement func
>> err =3D sys_bpf(BPF_PROG_REPLACE_FUNC, prog_fd, btf_id, func_fd); // doe=
s *not* return an fd
>>
>> That last call should make the ref-counting be in the prog_fd -> func_fd
>> direction, so that when prog_fd is released, it will do
>> bpf_prog_put(func_fd). There could be an additional call like
>> sys_bpf(BPF_PROG_REPLACE_FUNC_DETACH, prog_fd, btf_id) for explicit
>> detach as well, of course.
>
> Taking this additional refcount will create a dependency loop (see
> above), so that's why it wasn't done, I think.

Right, that's why I want the new operation to 'flip' the direction of
the refcnt inside the kernel, so there would no longer be a reference
from the replacement to the dispatcher, only the other way (so no
loops).

> With FD-based bpf_link, though, you'll be able to "transfer ownership"
> from application that installed freplace program in the first place,
> to the program that eventually will unload/replace dispatcher BPF
> program. You do that by pinning freplace program in BPFFS location,
> that's known to this libxdp library, and when you need to detach and
> unload XDP dispatcher and overriden XDP programs, the "admin process"
> which manages XDP dispatcher, will be able to just go and unpin and
> detach everything, if necessary.

Yes, so let's assume we want to do it this way (with replacement
programs pinned in a known location in bpffs). First off, that will
introduce a hard dependency on bpffs for XDP; so now your networking
program also needs access to mounting filesystems, or you need to rely
on the system (including your container runtime) to set this up right
for you.

Assuming that has been solved, the steps to replace an existing set of
programs with a new one would be something like:

0. We assume that we already have /sys/fs/bpf/xdp/eth0/mainprog,
   /sys/fs/bpf/xdp/eth0/prog1, /sys/fs/bpf/xdp/eth0/prog2, and that
   mainprog is attached to eth0
=20=20=20
1. Create new dispatcher, attach programs, pin replacement progs
   somewhere (/sys/fs/bpf/xdp/eth0.new/{mainprog,prog1,prog2,prog3}?)

2. Attach new mainprog to eth0, replacing the old one

3. `mv /sys/fs/bpf/xdp/eth0 /sys/fs/bpf/xdp/eth0.old`

4. `mv /sys/fs/bpf/xdp/eth0.new /sys/fs/bpf/xdp/eth0`

5. `rm -r /sys/fs/bpf/xdp/eth0.old`


Or you could switch steps 2 and 3. Either way, there is no way to do
steps 2..4 as one atomic operation; so you can end up in an inconsistent
state.

Oh, and what happens if the netdevice moves namespaces while it has an
XDP program attached? Then you can end up with the bpffs where you
pinned the programs originally not being available at all anymore.

Contrast this to the case where the replacement programs are just
referenced from the main prog: none of the above will be necessary, and
replacement will just be one atomic operation on the interface.

>> With such an API, lifecycle management for an XDP program keeps being
>> obvious: There's an fd for the root program attached to the interface,
>> and that's it. When that is released the whole thing disappears. Whereas
>> with the bpf_raw_tracepoint_open() API, the userspace program suddenly
>> has to make sure all the component function FDs are pinned, which seems
>> cumbersome and error-prone...
>
> I thought that's what libxdp is supposed to do (among other things).
> So for user applications it will be all hidden inside the library API,
> no?

Sure, but that also means that even if we somehow manage to write a
library without any bugs, it will still be called from arbitrary
applications that may crash between two operations and leave things in
an inconsistent state.

So I guess what I'm saying is that while it most likely is *possible* to
build the multi-prog facility using bpf_raw_tracepoint_open() + pinning,
I believe that the result will be brittle, and that we would be better
served with a different kernel primitive.

Do you see what I mean? Or am I missing something obvious here?

-Toke

