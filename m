Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFB32EB9DD
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 07:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbhAFGKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 01:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbhAFGKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 01:10:04 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EE8C06134D;
        Tue,  5 Jan 2021 22:09:24 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id s21so1097181pfu.13;
        Tue, 05 Jan 2021 22:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hLC4e/uWxbPvWq2CAZHTjcrZzuof3P9/ZxitB9WSmb0=;
        b=oNrj+4xawpCPNdLNQfilfJE/Wky+Q2ViJq82f2ZVI/5Jk8Jam43n5PCoz8KYS7Q2hH
         W3lKyo6/qrIGjHbXCUgFVNpPAuXZApCFzEGk2IJBpq9rJhlUQ8horUkbQlT8hGa1/obT
         H9IfZ4G5kFjM7wyFOSTmkx40cfrgatQR7j93dTVNrRN2JZVSx/BvhzLo4axiB8yfcBB7
         zUWRWUUE/oyy32TeiSnGN76gjn9fxPqrh3GSgfRtbZA3aTBC/bia/wL5LyxGiuHmxile
         Na/EZdIBg8D0xEtLEPLqUh9HIDVg2BlhJeHzY6aZ98aQQji/1ZQQObQ9I22DmgdU1Yil
         giKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hLC4e/uWxbPvWq2CAZHTjcrZzuof3P9/ZxitB9WSmb0=;
        b=c5pvpLjNyLJn/qHtijbHwbYfyVw5QiowIrySbdHMEotY/2LmV+xcdfFIT89u3PQVWi
         ORK30RGW0/DW7eqNDwZymzMKP/wHfX2qhYO8D0QB2tXJGC1cYBYTo0hUfbZrIMj549q8
         Q+XEpmqLSiuTKgLENDHgfFj32J6hSGOdX4Sixog9fpHBGP0JIDQKqWbiiuwJ781xWSxi
         v5C3dC+v/s6aPFAO5n8OZZ53vYV+4XhIi4jgwnrJ1GPr3RczgMJNpPmiqHTVzO7PeQSU
         jYZuDXKFDWbypwTux83+Knl9LEZ8fYJuY7kx+CteUfQ71LzxFg4QkcnMmpVUzXCdFkjI
         L5eA==
X-Gm-Message-State: AOAM531yc5Kxgj8SKqInAKfk5mTdCGDSQ/cQVip+eq1O72E47KMolPHu
        +AuO96F2tYhlmlthrjUo0Jc=
X-Google-Smtp-Source: ABdhPJy1JRNPcQGZaJJ9R4IyaHzclMpyg6gu7wORDrATbLRL/VpEWbDQPcb7Vx6j4CFBZX0nYTZ2MA==
X-Received: by 2002:a63:c205:: with SMTP id b5mr2814009pgd.281.1609913363481;
        Tue, 05 Jan 2021 22:09:23 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:cb32])
        by smtp.gmail.com with ESMTPSA id f7sm977642pjs.25.2021.01.05.22.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 22:09:22 -0800 (PST)
Date:   Tue, 5 Jan 2021 22:09:20 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Gilad Reti <gilad.reti@gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add tests for user- and
 non-CO-RE BPF_CORE_READ() variants
Message-ID: <20210106060920.wmnvwolbmju4edp3@ast-mbp>
References: <20201218235614.2284956-1-andrii@kernel.org>
 <20201218235614.2284956-4-andrii@kernel.org>
 <20210105034644.5thpans6alifiq65@ast-mbp>
 <CAEf4BzY4qXW_xV+0pcWPQp+Tda6BY69xgJnaA3RFxKc255rP2g@mail.gmail.com>
 <20210105190355.2lbt6vlmi752segx@ast-mbp>
 <CAEf4BzZPqBp=Th5Xy3mrWZ2k5ANo_+1rQSkC1Q=uEHz6FcBqpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZPqBp=Th5Xy3mrWZ2k5ANo_+1rQSkC1Q=uEHz6FcBqpA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 01:03:47PM -0800, Andrii Nakryiko wrote:
> > >
> > >   - handling 32-bit vs 64-bit UAPI structs uniformly;
> >
> > what do you mean?
> > 32-bit user space running on 64-bit kernel works through 'compat' syscalls.
> > If bpf progs are accessing 64-bit uapi structs in such case they're broken
> > and no amount of co-re can help.
> 
> I know nothing about compat, so can't comment on that. But the way I
> understood the situation was the BPF program compiled once (well, at
> least from the unmodified source code), but runs on ARM32 and (on a
> separate physical host) on ARM64. And it's task is, say, to read UAPI
> kernel structures from syscall arguments.

I'm not sure about arm, but on x86 there should be two different progs
for this to work (if we're talking about 32-bit userspace).
See below.

> One simple example I found in UAPI definitions is struct timespec, it
> seems it's defined with `long`:
> 
> struct timespec {
>         __kernel_old_time_t     tv_sec;         /* seconds */
>         long                    tv_nsec;        /* nanoseconds */
> }
> 
> So if you were to trace clock_gettime(), you'd need to deal with
> differently-sized reads of tv_nsec, depending on whether you are
> running on the 32-bit or 64-bit host.

I believe gettime is vdso, so that's not a syscall and there are no bpf hooks
available to track that.
For normal syscall with timespec argument like sys_recvmmsg and sys_nanosleep
the user needs to load two programs and attach to two different points:
fentry/__x64_sys_nanosleep and fentry/__ia32_sys_nanosleep.
(I'm not an expert on compat and not quite sure how _time32 suffix is handled,
so may be 4 different progs are needed).
The point is that there are several different entry points with different args.
ia32 user space will call into the kernel differently.
At the end different pieces of the syscall and compat handling will call
into hrtimer_nanosleep with ktime.
So if one bpf prog needs to work for 32 and 64 bit user space it should be
attached to common piece of code like hrtimer_nanosleep().
If it's attached to syscall entry it needs to attach to at least 2 different
entry points with 2 different progs.
I guess it's possible to load single prog and kprobe-attach it to
two different kernel functions, but code is kinda different.
For the simplest things like sys_nanosleep it might work and timespec
is simple enough structure to handle with sizeof(long) co-re tricks,
but it's not a generally applicable approach.
So for a tool to track 32-bit and 64-bit user space is quite tricky.

If bpf prog doesn't care about user space and only needs to deal
with 64-bit kernel + 64-bit user space and 32-bit kernel + 32-bit user space
then it's a bit simpler, but probably still requires attaching
to two different points. On 32-bit x86 kernel there will be no
"fentry/__x64_sys_nanosleep" function.

> There are probably other examples where UAPI structs use long instead
> of __u32 or __u64, but I didn't dig too deep.

There is also crazy difference between compact_ioctl vs ioctl.

The point I'm trying to get across is that the clean 32-bit processing is
a lot more involved than just CORE_READ_USER macro and I want to make sure that
the expections are set correctly.
BPF CO-RE prog may handle 32-bit and 64-bit at the same time, but
it's probably exception than the rule.

> Let's see if Gilad can provide his perspective. I have no strong
> feelings about this and can send a patch removing CORE_READ_USER
> variants (they didn't make it into libbpf v0.3, so no harm or API
> stability concerns). BPF_PROBE_READ() and BPF_PROBE_READ_USER() are
> still useful for reading non-relocatable, but nested data structures,
> so I'd prefer to keep those.

Let's hear from Gilad.
I'm not against BPF_CORE_READ_USER macro as-is. I was objecting
to the reasons of implementing it.
