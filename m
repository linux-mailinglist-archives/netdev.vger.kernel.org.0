Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0EF1761DA
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 19:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgCBSFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 13:05:35 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33126 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgCBSFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 13:05:34 -0500
Received: by mail-qk1-f195.google.com with SMTP id p62so618340qkb.0;
        Mon, 02 Mar 2020 10:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qJtedBXtNKxE2zN5cPAiqCVjbBcZCO+pRfOQvUMHjvQ=;
        b=dmnPdTD9+fLSEuPbuYhNCczqUhiu+OxfKHQ8EqZg2MB7d4FeUj1sR/wzWHaGyovB7u
         M1wTne/Jl4CP8TJQ07NfY/E5j17IpEu1KPrHoNJA82RboY84X1CaOAwXcjh126CInmbS
         CVqaVroduzjvwEk6VJntVO5XPG1W7F7B6McD3LDzzH+ltb1WoBycHvGrOFYnFpanHZxb
         EDVDE6hQNskKazFeKNMuRCu4TwbgBqyyJ39kwVuqNilg7xeqgVf0Z1MysP67r3hrGM58
         Ep3SY/PMFRi5JE3vMjDyO0wkcQqR2BOq1frOFuhGGuO1fr7bmI+Pso2iSQPY6QTEbbVq
         wVow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qJtedBXtNKxE2zN5cPAiqCVjbBcZCO+pRfOQvUMHjvQ=;
        b=BVMO1fSHnDPn86agWOLUim97L1WXY94tl4GG9n1goazZykM8wwOo1P5ZrjQgvblNCQ
         ypF3I0TzSsIEn2/fgtj7MRAEOce6UiDWziUQaozBVuTScZ3QF2YKTMO5EXtxnt4SUP1j
         QQywbXkLUZVwF4P81rVds0YCjnX4w7qmoJxrDJw9gqGXIdWy+W+jbeNlBL6eW6fWjbJU
         33Aj3A7DzVIeYPmB+BLgXpDZJh8d3j9hD8CXn5vAWWsZk8U72FIt01PZMVVh7DKKgu70
         DCKL7C3Hp/3mDyKsfdY6/p6zPPTEK2Bepsj55AOlbQIF8KoZPR+I3OHNI5qQV9tdFoNa
         WVOQ==
X-Gm-Message-State: ANhLgQ0dctCZrINzxdqhVdvHcrCfiGVd71OijAYipDdcYbIpN195DL47
        +CsoQ8ZRMznV7AF7ZV2piFioTg1XvsFWqBEABH+SGSJ2
X-Google-Smtp-Source: ADFU+vsAdbEHC0zURtRFB423X6a31ZcVMiReMomtW05rByufE2RJb5K0ZLcWneTVXAcRjtRIG3Ix6hDkXAgeT0trUyk=
X-Received: by 2002:a37:6716:: with SMTP id b22mr435028qkc.437.1583172333270;
 Mon, 02 Mar 2020 10:05:33 -0800 (PST)
MIME-Version: 1.0
References: <20200228223948.360936-1-andriin@fb.com> <87mu8zt6a8.fsf@toke.dk>
In-Reply-To: <87mu8zt6a8.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Mar 2020 10:05:22 -0800
Message-ID: <CAEf4BzZGn9FcUdEOSR_ouqSNvzY2AdJA=8ffMV5mTmJQS-10VA@mail.gmail.com>
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

On Mon, Mar 2, 2020 at 2:12 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > This patch series adds bpf_link abstraction, analogous to libbpf's alre=
ady
> > existing bpf_link abstraction. This formalizes and makes more uniform e=
xisting
> > bpf_link-like BPF program link (attachment) types (raw tracepoint and t=
racing
> > links), which are FD-based objects that are automatically detached when=
 last
> > file reference is closed. These types of BPF program links are switched=
 to
> > using bpf_link framework.
> >
> > FD-based bpf_link approach provides great safety guarantees, by ensurin=
g there
> > is not going to be an abandoned BPF program attached, if user process s=
uddenly
> > exits or forgets to clean up after itself. This is especially important=
 in
> > production environment and is what all the recent new BPF link types fo=
llowed.
> >
> > One of the previously existing  inconveniences of FD-based approach, th=
ough,
> > was the scenario in which user process wants to install BPF link and ex=
it, but
> > let attached BPF program run. Now, with bpf_link abstraction in place, =
it's
> > easy to support pinning links in BPF FS, which is done as part of the s=
ame
> > patch #1. This allows FD-based BPF program links to survive exit of a u=
ser
> > process and original file descriptor being closed, by creating an file =
entry
> > in BPF FS. This provides great safety by default, with simple way to op=
t out
> > for cases where it's needed.
>
> While being able to pin the fds returned by bpf_raw_tracepoint_open()
> certainly helps, I still feel like this is the wrong abstraction for
> freplace(): When I'm building a program using freplace to put in new
> functions (say, an XDP multi-prog dispatcher :)), I really want the
> 'new' functions (i.e., the freplace'd bpf_progs) to share their lifetime
> with the calling BPF program. I.e., I want to be able to do something
> like:

freplace programs will take refcount on a BPF program they are
replacing, so in that sense they do share lifetime, except dependency
is opposite to what you describe: rootlet/dispatcher program can't go
away as long it has at least one freplace program attached. It
(dispatcher) might get detached, though, but freplace, technically,
will still be attached to now-detached dispatcher (so won't be
invoked, yet still attached). I hope that makes sense :)

>
> prog_fd =3D sys_bpf(BPF_PROG_LOAD, ...); // dispatcher
> func_fd =3D sys_bpf(BPF_PROG_LOAD, ...); // replacement func
> err =3D sys_bpf(BPF_PROG_REPLACE_FUNC, prog_fd, btf_id, func_fd); // does=
 *not* return an fd
>
> That last call should make the ref-counting be in the prog_fd -> func_fd
> direction, so that when prog_fd is released, it will do
> bpf_prog_put(func_fd). There could be an additional call like
> sys_bpf(BPF_PROG_REPLACE_FUNC_DETACH, prog_fd, btf_id) for explicit
> detach as well, of course.

Taking this additional refcount will create a dependency loop (see
above), so that's why it wasn't done, I think.

With FD-based bpf_link, though, you'll be able to "transfer ownership"
from application that installed freplace program in the first place,
to the program that eventually will unload/replace dispatcher BPF
program. You do that by pinning freplace program in BPFFS location,
that's known to this libxdp library, and when you need to detach and
unload XDP dispatcher and overriden XDP programs, the "admin process"
which manages XDP dispatcher, will be able to just go and unpin and
detach everything, if necessary.

>
> With such an API, lifecycle management for an XDP program keeps being
> obvious: There's an fd for the root program attached to the interface,
> and that's it. When that is released the whole thing disappears. Whereas
> with the bpf_raw_tracepoint_open() API, the userspace program suddenly
> has to make sure all the component function FDs are pinned, which seems
> cumbersome and error-prone...

I thought that's what libxdp is supposed to do (among other things).
So for user applications it will be all hidden inside the library API,
no?

>
> I'll try to propose patches for what this could look like; I think it
> could co-exist with this bpf_link abstraction, though, so no need to
> hold up this series...

Yeah, either way, this is important and is desired behavior not just
for freplace cases.

>
> -Toke
>
