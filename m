Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4AD2EB49D
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 22:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbhAEVEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 16:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbhAEVEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 16:04:39 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB35C061574;
        Tue,  5 Jan 2021 13:03:59 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id k4so798577ybp.6;
        Tue, 05 Jan 2021 13:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JQXFw/+QcftjZUsC58ItFBOKP3f1MsgZ8muOqxdv4S8=;
        b=opYVF0OqOvKJNckIwQXSpGTFhrC6zPV/xRXMW1p3gIRyBxuA4zXffOLl3K5LsANY0c
         qK0UEwqeVaho4vtECsFK5wVDSweZP1AAQHWb18rBdc+UcE8ikyWNJxVJmBOLf9CY+pVF
         1e4uZX9e67x8us7Ir/jy2jq10+sZm3lr+ONyKO/+KT4bQPVRqFONKyiuxyJjubNiBsWa
         Ghb8lJu6JYoA6nzcKE7pYRXdPl8uUyZukzU5rveclN3V0E6V8A7eSX7BIoaS0htiX2l8
         cblOz3vBistjsHKHhfNReAIosKHZmIHrkkId8FzTdWOMDjLSvB2Ap9pyHsahP3ZTPcf3
         iq6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JQXFw/+QcftjZUsC58ItFBOKP3f1MsgZ8muOqxdv4S8=;
        b=CpBtJ1qopwOz9XqHM5QmTcjhN6gJy64BCfawrUiXVa5S60bJ2auBvSUo32tQSE+0ul
         CtsaUrqu/vTEuU7ix5PAwbLNp7dfcvRoXqX0f+jdW8FuneraE1H3AGdYfeY3GyGtw2kQ
         XWoRIby+tV1M60N4MnHgg6WXY2lLTe7qfWpd787Z/mwDR42lVKWBOZzV6uWw8+fx/KCz
         Y7xmM5L/W68UjOXDxYDVMh/cnurMYTZEg15Fyokkl5nCEJC6ScSoaTj5sEz8Cneavr5l
         wKt5i6/Y+haR0z2FWJ0BINHHyKm4dDoOKo3NRYPglxhX2DTkRmzTmeHqpMN5yBjTUJfD
         qi5g==
X-Gm-Message-State: AOAM531N677yFGBpwLoL4cCj01+lHLpU2hudapH6e8U6jqR7H2fLdCAO
        NpS0cJzJ2anWYkv07MDTNMDugNrDknMwRa78zb+wO0t4zt4=
X-Google-Smtp-Source: ABdhPJxgvWV15g2tLEQxobwYj8y+CBEqQbhfFRkK4fbNeRWoMVt6E6GpREvzimOCiNjoeCx4nqiTVrLaawORd1kJCxQ=
X-Received: by 2002:a25:d6d0:: with SMTP id n199mr1795923ybg.27.1609880638479;
 Tue, 05 Jan 2021 13:03:58 -0800 (PST)
MIME-Version: 1.0
References: <20201218235614.2284956-1-andrii@kernel.org> <20201218235614.2284956-4-andrii@kernel.org>
 <20210105034644.5thpans6alifiq65@ast-mbp> <CAEf4BzY4qXW_xV+0pcWPQp+Tda6BY69xgJnaA3RFxKc255rP2g@mail.gmail.com>
 <20210105190355.2lbt6vlmi752segx@ast-mbp>
In-Reply-To: <20210105190355.2lbt6vlmi752segx@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Jan 2021 13:03:47 -0800
Message-ID: <CAEf4BzZPqBp=Th5Xy3mrWZ2k5ANo_+1rQSkC1Q=uEHz6FcBqpA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add tests for user- and
 non-CO-RE BPF_CORE_READ() variants
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Gilad Reti <gilad.reti@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 11:04 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jan 04, 2021 at 09:08:21PM -0800, Andrii Nakryiko wrote:
> > On Mon, Jan 4, 2021 at 7:46 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Dec 18, 2020 at 03:56:14PM -0800, Andrii Nakryiko wrote:
> > > > +
> > > > +/* shuffled layout for relocatable (CO-RE) reads */
> > > > +struct callback_head___shuffled {
> > > > +     void (*func)(struct callback_head___shuffled *head);
> > > > +     struct callback_head___shuffled *next;
> > > > +};
> > > > +
> > > > +struct callback_head k_probe_in = {};
> > > > +struct callback_head___shuffled k_core_in = {};
> > > > +
> > > > +struct callback_head *u_probe_in = 0;
> > > > +struct callback_head___shuffled *u_core_in = 0;
> > > > +
> > > > +long k_probe_out = 0;
> > > > +long u_probe_out = 0;
> > > > +
> > > > +long k_core_out = 0;
> > > > +long u_core_out = 0;
> > > > +
> > > > +int my_pid = 0;
> > > > +
> > > > +SEC("raw_tracepoint/sys_enter")
> > > > +int handler(void *ctx)
> > > > +{
> > > > +     int pid = bpf_get_current_pid_tgid() >> 32;
> > > > +
> > > > +     if (my_pid != pid)
> > > > +             return 0;
> > > > +
> > > > +     /* next pointers for kernel address space have to be initialized from
> > > > +      * BPF side, user-space mmaped addresses are stil user-space addresses
> > > > +      */
> > > > +     k_probe_in.next = &k_probe_in;
> > > > +     __builtin_preserve_access_index(({k_core_in.next = &k_core_in;}));
> > > > +
> > > > +     k_probe_out = (long)BPF_PROBE_READ(&k_probe_in, next, next, func);
> > > > +     k_core_out = (long)BPF_CORE_READ(&k_core_in, next, next, func);
> > > > +     u_probe_out = (long)BPF_PROBE_READ_USER(u_probe_in, next, next, func);
> > > > +     u_core_out = (long)BPF_CORE_READ_USER(u_core_in, next, next, func);
> > >
> > > I don't understand what the test suppose to demonstrate.
> > > co-re relocs work for kernel btf only.
> > > Are you saying that 'struct callback_head' happened to be used by user space
> > > process that allocated it in user memory. And that is the same struct as
> > > being used by the kernel? So co-re relocs that apply against the kernel
> > > will sort-of work against the data of user space process because
> > > the user space is using the same struct? That sounds convoluted.
> >
> > The test itself just tests that bpf_probe_read_user() is executed, not
> > bpf_probe_read_kernel(). But yes, the use case is to read kernel data
> > structures from the user memory address space. See [0] for the last
> > time this was requested and justifications. It's not the first time
> > someone asked about the user-space variant of BPF_CORE_READ(), though
> > I won't be able to find the reference at this time.
> >
> >   [0] https://lore.kernel.org/bpf/CANaYP3GetBKUPDfo6PqWnm3xuGs2GZjLF8Ed51Q1=Emv2J-dKg@mail.gmail.com/
>
> That's quite confusing thread.
>
> > > I struggle to see the point of patch 1:
> > > +#define bpf_core_read_user(dst, sz, src)                                   \
> > > +       bpf_probe_read_user(dst, sz, (const void *)__builtin_preserve_access_index(src))
> > >
> > > co-re for user structs? Aren't they uapi? No reloc is needed.
> >
> > The use case in [0] above is for reading UAPI structs, passed as input
> > arguments to syscall. It's a pretty niche use case, but there are at
> > least two more-or-less valid benefits to use CO-RE with "stable" UAPI
> > structs:
> >
> >   - handling 32-bit vs 64-bit UAPI structs uniformly;
>
> what do you mean?
> 32-bit user space running on 64-bit kernel works through 'compat' syscalls.
> If bpf progs are accessing 64-bit uapi structs in such case they're broken
> and no amount of co-re can help.

I know nothing about compat, so can't comment on that. But the way I
understood the situation was the BPF program compiled once (well, at
least from the unmodified source code), but runs on ARM32 and (on a
separate physical host) on ARM64. And it's task is, say, to read UAPI
kernel structures from syscall arguments.

>
> >   - handling UAPI fields that were added in later kernels, but are
> > missing on the earlier ones.
> >
> > For the former, you'd need to compile two variants of the BPF program
> > (or do convoluted and inconvenient 32-bit UAPI struct re-definition
> > for 64-bit BPF target).
>
> No. 32-bit uapi structs should be used by bpf prog.
> compat stuff is not only casting pointers from 64-bit to 32.
>

See above about compat, that's not what I was thinking about.

One simple example I found in UAPI definitions is struct timespec, it
seems it's defined with `long`:

struct timespec {
        __kernel_old_time_t     tv_sec;         /* seconds */
        long                    tv_nsec;        /* nanoseconds */
}

So if you were to trace clock_gettime(), you'd need to deal with
differently-sized reads of tv_nsec, depending on whether you are
running on the 32-bit or 64-bit host.

There are probably other examples where UAPI structs use long instead
of __u32 or __u64, but I didn't dig too deep.


> > For the latter... I guess you can do if/else
> > dance based on the kernel version. Which sucks and is inconvenient
> > (and kernel version checks are discouraged, it's more reliable to
> > detect availability of specific types and fields).
>
> Not really. ifdef based on kernel version is not needed.
> bpf_core_field_exists() will work just fine.
> No need to bpf_probe_read_user() macros.

Yes, you are right, detection of field/type existence doesn't depend
on kernel- vs user-space, disregard this one.

>
> > So all in all, while pretty rare and niche, seemed like a valid use
> > case. And easy to support while reusing all the macro logic almost
> > without any changes.
>
> I think these new macros added with confusing and unclear goals
> will do more harm than good.

Let's see if Gilad can provide his perspective. I have no strong
feelings about this and can send a patch removing CORE_READ_USER
variants (they didn't make it into libbpf v0.3, so no harm or API
stability concerns). BPF_PROBE_READ() and BPF_PROBE_READ_USER() are
still useful for reading non-relocatable, but nested data structures,
so I'd prefer to keep those.
