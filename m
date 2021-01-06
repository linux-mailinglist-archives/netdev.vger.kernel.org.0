Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63662EC6D8
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbhAFX0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbhAFX0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 18:26:23 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B23CC061757;
        Wed,  6 Jan 2021 15:25:42 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id r63so4430339ybf.5;
        Wed, 06 Jan 2021 15:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x0YrIMBBWBn97y+yprI1QvAdWudZQ/QK8v4zbR8sops=;
        b=HJGn3NtTPNLOqik+BpAqAFiaKBdcp6X1sA9IdcVyfhrNrfeI1yjAiuYvyUUaqVGv+D
         RmBflcUB99VdFaFkI97c/e2iWQHXh3NGTo7vmPJFjQpY47Fv0/ZqoZHDb5BtKsp7LT//
         KbKgBmH9kRpaH1qmujAa/EyL4WicYsSM6fgr2QN2ePwbx0lNS+Sx12Dl9YM9kFzEQSfY
         TwwfMMUMMWtaEYZECw09BETeEG6VV9HgNvKZExqxs6PBNjM7u4rCWpFGeo8xR6zgVDqm
         nGVtEq4o1lMSKEQTP9B8mwAleLbezChmEgVRms79OOcpw0Nm0C0w5YgXEiYCGUMfUdu6
         E8Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x0YrIMBBWBn97y+yprI1QvAdWudZQ/QK8v4zbR8sops=;
        b=OMtuRHi6bLBOg125KYYXfuUFZ8cq4TXcsJe7jy0dhH/ywf/DhSpIrMpKUKhmOBmPMp
         6jCI2L4XGw6MIWfcPqgkwm8NMi7WoRWWMeJjtOkGKwuIxD8byi998cG2vKBlqXYXo8Vp
         gM+wiC41LFs0bDlVWj0oiSHkFAVSO3/pezqCG3PFGd7KPy5Ewh2leoyzW9zKrXhFxP2S
         QFRmBQVYVkAB+KlQOUWlnWLxJWKhBD3RD6W3T5wIbnkQ6gYpr/iISIOmL4QQbOEDS82r
         JsCS6IMCkzJkgSo9G0kUlkXpteCF7yVk4kPPFElqml7yKx8yO71RWuamSStzxmwqdDNO
         wumA==
X-Gm-Message-State: AOAM530DJXrnUUxQwtNLnyOBtdLss2ERGlC0pt3Y0LunO/OHAkgxbW3c
        ghPXI6cwLpn8B3heCTpo2zVjIVN53ean000EQ8zJv6MG
X-Google-Smtp-Source: ABdhPJxjcuLrkqLLY3RbaQtHKihGl6u6jbIaYuROLS5KVIiBtPyoCWI7/ne63MhGEe6roh+IJCYTPEfQr+G3wN3Thm4=
X-Received: by 2002:a25:2c4c:: with SMTP id s73mr9537727ybs.230.1609975541329;
 Wed, 06 Jan 2021 15:25:41 -0800 (PST)
MIME-Version: 1.0
References: <20201218235614.2284956-1-andrii@kernel.org> <20201218235614.2284956-4-andrii@kernel.org>
 <20210105034644.5thpans6alifiq65@ast-mbp> <CAEf4BzY4qXW_xV+0pcWPQp+Tda6BY69xgJnaA3RFxKc255rP2g@mail.gmail.com>
 <20210105190355.2lbt6vlmi752segx@ast-mbp> <CAEf4BzZPqBp=Th5Xy3mrWZ2k5ANo_+1rQSkC1Q=uEHz6FcBqpA@mail.gmail.com>
 <20210106060920.wmnvwolbmju4edp3@ast-mbp> <CANaYP3E5qYq0JznOkxVf6r3N-oM-WjKEw6kqPKD_ofQtk1gL+A@mail.gmail.com>
In-Reply-To: <CANaYP3E5qYq0JznOkxVf6r3N-oM-WjKEw6kqPKD_ofQtk1gL+A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Jan 2021 15:25:30 -0800
Message-ID: <CAEf4BzZay-ofoZ-RURa0vTyQnEVaqF4_xuTAijSA9wgm=kt02g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add tests for user- and
 non-CO-RE BPF_CORE_READ() variants
To:     Gilad Reti <gilad.reti@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 6, 2021 at 2:10 AM Gilad Reti <gilad.reti@gmail.com> wrote:
>
> On Wed, Jan 6, 2021 at 8:09 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Jan 05, 2021 at 01:03:47PM -0800, Andrii Nakryiko wrote:
> > > > >
> > > > >   - handling 32-bit vs 64-bit UAPI structs uniformly;
> > > >
> > > > what do you mean?
> > > > 32-bit user space running on 64-bit kernel works through 'compat' syscalls.
> > > > If bpf progs are accessing 64-bit uapi structs in such case they're broken
> > > > and no amount of co-re can help.
> > >
> > > I know nothing about compat, so can't comment on that. But the way I
> > > understood the situation was the BPF program compiled once (well, at
> > > least from the unmodified source code), but runs on ARM32 and (on a
> > > separate physical host) on ARM64. And it's task is, say, to read UAPI
> > > kernel structures from syscall arguments.
> >
> > I'm not sure about arm, but on x86 there should be two different progs
> > for this to work (if we're talking about 32-bit userspace).
> > See below.
> >
> > > One simple example I found in UAPI definitions is struct timespec, it
> > > seems it's defined with `long`:
> > >
> > > struct timespec {
> > >         __kernel_old_time_t     tv_sec;         /* seconds */
> > >         long                    tv_nsec;        /* nanoseconds */
> > > }
> > >
> > > So if you were to trace clock_gettime(), you'd need to deal with
> > > differently-sized reads of tv_nsec, depending on whether you are
> > > running on the 32-bit or 64-bit host.
> >
> > I believe gettime is vdso, so that's not a syscall and there are no bpf hooks
> > available to track that.
> > For normal syscall with timespec argument like sys_recvmmsg and sys_nanosleep
> > the user needs to load two programs and attach to two different points:
> > fentry/__x64_sys_nanosleep and fentry/__ia32_sys_nanosleep.
> > (I'm not an expert on compat and not quite sure how _time32 suffix is handled,
> > so may be 4 different progs are needed).
> > The point is that there are several different entry points with different args.
> > ia32 user space will call into the kernel differently.
> > At the end different pieces of the syscall and compat handling will call
> > into hrtimer_nanosleep with ktime.
> > So if one bpf prog needs to work for 32 and 64 bit user space it should be
> > attached to common piece of code like hrtimer_nanosleep().
> > If it's attached to syscall entry it needs to attach to at least 2 different
> > entry points with 2 different progs.
>
> I think that while it is true that syscall handlers are different for
> 32 and 64 bit,
> it may happen that some syscall handlers will pass user-space pointers down to
> shared common functions, which may be hooked by ebpf probes. I am no expert, but
> I think that the cp_new_stat function is such an example; it gets a
> user struct stat* pointer,
> whose definition varies across different architectures (32/64-bit,
> different processor archs etc.)
>
> > I guess it's possible to load single prog and kprobe-attach it to
> > two different kernel functions, but code is kinda different.
> > For the simplest things like sys_nanosleep it might work and timespec
> > is simple enough structure to handle with sizeof(long) co-re tricks,
> > but it's not a generally applicable approach.
> > So for a tool to track 32-bit and 64-bit user space is quite tricky.
> >
> > If bpf prog doesn't care about user space and only needs to deal
> > with 64-bit kernel + 64-bit user space and 32-bit kernel + 32-bit user space
> > then it's a bit simpler, but probably still requires attaching
> > to two different points. On 32-bit x86 kernel there will be no
> > "fentry/__x64_sys_nanosleep" function.
> >
> > > There are probably other examples where UAPI structs use long instead
> > > of __u32 or __u64, but I didn't dig too deep.
> >
> > There is also crazy difference between compact_ioctl vs ioctl.
> >
> > The point I'm trying to get across is that the clean 32-bit processing is
> > a lot more involved than just CORE_READ_USER macro and I want to make sure that
> > the expections are set correctly.
> > BPF CO-RE prog may handle 32-bit and 64-bit at the same time, but
> > it's probably exception than the rule.
> >
> > > Let's see if Gilad can provide his perspective. I have no strong
> > > feelings about this and can send a patch removing CORE_READ_USER
> > > variants (they didn't make it into libbpf v0.3, so no harm or API
> > > stability concerns). BPF_PROBE_READ() and BPF_PROBE_READ_USER() are
> > > still useful for reading non-relocatable, but nested data structures,
> > > so I'd prefer to keep those.
> >
> > Let's hear from Gilad.
> > I'm not against BPF_CORE_READ_USER macro as-is. I was objecting
> > to the reasons of implementing it.
>
> If I am not mistaken (which is completely possible), I think that
> providing such a macro will
> not cause any more confusion than the bpf_probe_read_{,user}
> distinction already does,
> since BPF_CORE_READ_USER to BPF_CORE_READ is the same as bpf_probe_read_user
> to bpf_probe_read.

I think the biggest source of confusion is that USER part in
BPF_CORE_READ_USER refers to reading data from user address space, not
really user structs (which is kind of natural instinct here). CO-RE
*always* works only with kernel types, which is obvious if you have a
lot of experience with using CO-RE, but not initially, unfortunately.

So in the end, while a narrow use case, it seems like it might be
useful to have BPF_CORE_READ_USER. Maybe emphasizing (in the doc
comment) the fact that all types need to be kernel types would help a
bit? If not, it's not a big deal, because it's pretty easy for users
to just explicitly write bpf_probe_read_user(&dst, sizeof(dst),
__builtin_preserve_access_index(src)). But there is definitely a bit
of mental satisfaction with having all possible combinations of
CORE/non-CORE and USER/KERNEL variants :)

Btw, it seems these patches are already in bpf-next, so, Alexei,
please let me know if you insist on removing BPF_CORE_READ_USER()
variant and I'll send a follow up patch.
