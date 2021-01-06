Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CBD2EBC29
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 11:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbhAFKLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 05:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbhAFKLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 05:11:41 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDD5C06134C;
        Wed,  6 Jan 2021 02:11:00 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y24so3858635edt.10;
        Wed, 06 Jan 2021 02:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KbDwJYzXgd4n6eHXBstvFb0BLjUx8u//JioPSbJSWfU=;
        b=XZzgJ4wWXiJBfoM80MPPJLKoAnpC6oaPfVkXLrmdltmOAjrhEDDXKpxGOOB0NkTLGz
         +4cWub4E1L6EiM2w6NtJPLqVjGts70YLNwDU08S6As+WDfHMyOEJmEPoBkeQSrVLq8gb
         8FSsRaNFRlFNZK+7ccL9P2Ze6iKMvrmnIJDwpB7yWKQzFe7/Mm8zvBKEmRos8oZ+5ev/
         K7Zlgdg+6P1qClOa9NFq5qYeouCEUCFcdG8l8gZo1zurrnZxGUsqegFBGR6zAIHrvo3t
         8CZ1a/60aSlvQg41hDvKG9/idzqDEO4k/RTS/pRKosn0rUfVZufB4igXFonACao0WE4d
         KkVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KbDwJYzXgd4n6eHXBstvFb0BLjUx8u//JioPSbJSWfU=;
        b=XGDxZ04u3T9ccpORqIC8WLVGDDKp52LM2J3voY8DbQy+qcONbpmPvJaHqAxnIxtpNF
         plu8LWVvhZgBnLeHlFOrwx4IS6yCUwe3mVXvihT/5uL5PbUjqdPFXLmtcCbmAcaTruXi
         6OjEcDRA1Wlmhq2cSQ5QXNp/FG+BWCOJwqcwqQUG/CkhPOk4yscMNI0b2Maead5CQLpg
         7PA6BmvikqjBHKSGj3lpMsl8zXJ5vmsjK++409OZmoHJ0vtWInPdlt4DKbYSn6tE4ghF
         1kjjVj7TdxAsKpERqi5i1KflLcsQb0buTqaJJDANMXIQ94tGoYlCU45oZacUGgneNQ8R
         d6DQ==
X-Gm-Message-State: AOAM531Y26O9JNQOyvgrEQf6kT4rgVty5wlmbBGApaqH7pGSxXxv0Z6X
        fe53CX7/zaFBxyosTWoIrzI4a8hYm0Gc1k8aD0Q=
X-Google-Smtp-Source: ABdhPJwqVMHUJkxnalz3GbVfp+1c9j9zvN2vAMHUkYAajAWw8rtCx5rrE3zo5IHl04JNrDK6Dc0gv2xkNqwr3Xmr9vA=
X-Received: by 2002:a05:6402:30ac:: with SMTP id df12mr3630905edb.175.1609927859032;
 Wed, 06 Jan 2021 02:10:59 -0800 (PST)
MIME-Version: 1.0
References: <20201218235614.2284956-1-andrii@kernel.org> <20201218235614.2284956-4-andrii@kernel.org>
 <20210105034644.5thpans6alifiq65@ast-mbp> <CAEf4BzY4qXW_xV+0pcWPQp+Tda6BY69xgJnaA3RFxKc255rP2g@mail.gmail.com>
 <20210105190355.2lbt6vlmi752segx@ast-mbp> <CAEf4BzZPqBp=Th5Xy3mrWZ2k5ANo_+1rQSkC1Q=uEHz6FcBqpA@mail.gmail.com>
 <20210106060920.wmnvwolbmju4edp3@ast-mbp>
In-Reply-To: <20210106060920.wmnvwolbmju4edp3@ast-mbp>
From:   Gilad Reti <gilad.reti@gmail.com>
Date:   Wed, 6 Jan 2021 12:10:22 +0200
Message-ID: <CANaYP3E5qYq0JznOkxVf6r3N-oM-WjKEw6kqPKD_ofQtk1gL+A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add tests for user- and
 non-CO-RE BPF_CORE_READ() variants
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 6, 2021 at 8:09 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jan 05, 2021 at 01:03:47PM -0800, Andrii Nakryiko wrote:
> > > >
> > > >   - handling 32-bit vs 64-bit UAPI structs uniformly;
> > >
> > > what do you mean?
> > > 32-bit user space running on 64-bit kernel works through 'compat' syscalls.
> > > If bpf progs are accessing 64-bit uapi structs in such case they're broken
> > > and no amount of co-re can help.
> >
> > I know nothing about compat, so can't comment on that. But the way I
> > understood the situation was the BPF program compiled once (well, at
> > least from the unmodified source code), but runs on ARM32 and (on a
> > separate physical host) on ARM64. And it's task is, say, to read UAPI
> > kernel structures from syscall arguments.
>
> I'm not sure about arm, but on x86 there should be two different progs
> for this to work (if we're talking about 32-bit userspace).
> See below.
>
> > One simple example I found in UAPI definitions is struct timespec, it
> > seems it's defined with `long`:
> >
> > struct timespec {
> >         __kernel_old_time_t     tv_sec;         /* seconds */
> >         long                    tv_nsec;        /* nanoseconds */
> > }
> >
> > So if you were to trace clock_gettime(), you'd need to deal with
> > differently-sized reads of tv_nsec, depending on whether you are
> > running on the 32-bit or 64-bit host.
>
> I believe gettime is vdso, so that's not a syscall and there are no bpf hooks
> available to track that.
> For normal syscall with timespec argument like sys_recvmmsg and sys_nanosleep
> the user needs to load two programs and attach to two different points:
> fentry/__x64_sys_nanosleep and fentry/__ia32_sys_nanosleep.
> (I'm not an expert on compat and not quite sure how _time32 suffix is handled,
> so may be 4 different progs are needed).
> The point is that there are several different entry points with different args.
> ia32 user space will call into the kernel differently.
> At the end different pieces of the syscall and compat handling will call
> into hrtimer_nanosleep with ktime.
> So if one bpf prog needs to work for 32 and 64 bit user space it should be
> attached to common piece of code like hrtimer_nanosleep().
> If it's attached to syscall entry it needs to attach to at least 2 different
> entry points with 2 different progs.

I think that while it is true that syscall handlers are different for
32 and 64 bit,
it may happen that some syscall handlers will pass user-space pointers down to
shared common functions, which may be hooked by ebpf probes. I am no expert, but
I think that the cp_new_stat function is such an example; it gets a
user struct stat* pointer,
whose definition varies across different architectures (32/64-bit,
different processor archs etc.)

> I guess it's possible to load single prog and kprobe-attach it to
> two different kernel functions, but code is kinda different.
> For the simplest things like sys_nanosleep it might work and timespec
> is simple enough structure to handle with sizeof(long) co-re tricks,
> but it's not a generally applicable approach.
> So for a tool to track 32-bit and 64-bit user space is quite tricky.
>
> If bpf prog doesn't care about user space and only needs to deal
> with 64-bit kernel + 64-bit user space and 32-bit kernel + 32-bit user space
> then it's a bit simpler, but probably still requires attaching
> to two different points. On 32-bit x86 kernel there will be no
> "fentry/__x64_sys_nanosleep" function.
>
> > There are probably other examples where UAPI structs use long instead
> > of __u32 or __u64, but I didn't dig too deep.
>
> There is also crazy difference between compact_ioctl vs ioctl.
>
> The point I'm trying to get across is that the clean 32-bit processing is
> a lot more involved than just CORE_READ_USER macro and I want to make sure that
> the expections are set correctly.
> BPF CO-RE prog may handle 32-bit and 64-bit at the same time, but
> it's probably exception than the rule.
>
> > Let's see if Gilad can provide his perspective. I have no strong
> > feelings about this and can send a patch removing CORE_READ_USER
> > variants (they didn't make it into libbpf v0.3, so no harm or API
> > stability concerns). BPF_PROBE_READ() and BPF_PROBE_READ_USER() are
> > still useful for reading non-relocatable, but nested data structures,
> > so I'd prefer to keep those.
>
> Let's hear from Gilad.
> I'm not against BPF_CORE_READ_USER macro as-is. I was objecting
> to the reasons of implementing it.

If I am not mistaken (which is completely possible), I think that
providing such a macro will
not cause any more confusion than the bpf_probe_read_{,user}
distinction already does,
since BPF_CORE_READ_USER to BPF_CORE_READ is the same as bpf_probe_read_user
to bpf_probe_read.
