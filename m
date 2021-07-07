Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBB73BE1CD
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 06:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhGGEGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 00:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhGGEGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 00:06:21 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8B5C061574;
        Tue,  6 Jul 2021 21:03:41 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id a16so1045697ybt.8;
        Tue, 06 Jul 2021 21:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JpJPvzTMXqbU6WWCnPrJiuNQm9s8oHY0iAkh3Y/2RpQ=;
        b=VAwHfJSXEz6OBHzR0j9Nrqx3iF5wwdQ1uZ8znEv8feOhJsNc6hdhxcpi4H9Bes0NNM
         fHWyE6U3m/uDy12r/uuaDbs+s7t3oXjhFV3h0V9dAx0qKXOPCJX50iXPAonUUIgAUKvQ
         UXW7O1vZXvF9c94TQtSm80Dxc1iqexQxGHsdVIxSMg1gaRntey0t7g0EnG3NJmsa1Zzh
         +z5q4YVMKUXwvoMQ5PD+ciu1j1HmPwh+p20jDjcW4lAZQJD1LKShI9BqoewWJDjVAeX1
         BTtpfJuijJMgmEiSC5BLdOlnYVGMvhjvi4MibGPgNnx4SKRdoCxfKBDbNQMyJWCrQ19Q
         t5bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JpJPvzTMXqbU6WWCnPrJiuNQm9s8oHY0iAkh3Y/2RpQ=;
        b=HDCSjxqY7e/G3LjXfp/zQnrhAYcI6hS9Xb0a5mouVkAkFyHAlx+5uZjBGZzTjYCzxp
         qFPF3bbF6EXFNdtxSSmuFDUtGBLmP4n0q7TBDMzIpVLNDymHDqtVPrABire75OZHreZ8
         Ho0VpYsgkmElLZv/B1ktarmTYMcu0WWlFKPDohqBpq2wKsEmkbaOEt0QS4uIOvMxqqIE
         mQgv+7Ukrm7VC/8ORL71Rwqhzlwo5UOSjkYPFoGx2yHJuRBqbsWIbc/UFaGGgz9wp7Xv
         xRPbnkiIYENdES9U45WoBB4gfWNHbOTm6wQjk3JswfexTGY8G2wrywCC+ss9MntbnYec
         O11w==
X-Gm-Message-State: AOAM530fWjqzgaGZVE8mrAJFoYpMMEGsWnzb5NWLnidHZp0Q3Ag9JMaX
        xxT75wfqMPh0qkEvjguWxt7irf+ueZid03XfADU=
X-Google-Smtp-Source: ABdhPJw+vXKt/L8p149KnPuK0fFSPNjrl/B6Yj0zCBGJb4SCOzxhcdAbVBYCOgc66srqjkfcgT+KL+DzMAioXqmLRRs=
X-Received: by 2002:a25:1455:: with SMTP id 82mr28896708ybu.403.1625630620354;
 Tue, 06 Jul 2021 21:03:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210706174409.15001-1-vjsanjay@gmail.com> <b87ad042-eaf0-d1ac-6760-b3c92439655d@fb.com>
 <CAEf4BzZidvzFjw=m3zEmnrVhNYhrmy1pV-XgAfxMvgrb8Snw8w@mail.gmail.com> <CAPhsuW4EeY9CHE73Sy6zdteLhj6G-f+M9jSxrPuXpE81tPZoeA@mail.gmail.com>
In-Reply-To: <CAPhsuW4EeY9CHE73Sy6zdteLhj6G-f+M9jSxrPuXpE81tPZoeA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Jul 2021 21:03:29 -0700
Message-ID: <CAEf4BzaFSmpzin-ukmfQcS8+cHYZ_QwNe5u1eATLb_Omn6Wgog@mail.gmail.com>
Subject: Re: [PATCH] tools/runqslower: use __state instead of state
To:     Song Liu <song@kernel.org>
Cc:     Yonghong Song <yhs@fb.com>, SanjayKumar J <vjsanjay@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 6, 2021 at 4:11 PM Song Liu <song@kernel.org> wrote:
>
> On Tue, Jul 6, 2021 at 3:05 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Jul 6, 2021 at 11:26 AM Yonghong Song <yhs@fb.com> wrote:
> > >
> > >
> > >
> > > On 7/6/21 10:44 AM, SanjayKumar J wrote:
> > > >       task->state is renamed to task->__state in task_struct
> > >
> > > Could you add a reference to
> > >    2f064a59a11f ("sched: Change task_struct::state")
> > > which added this change?
> > >
> > > I think this should go to bpf tree as the change is in linus tree now.
> > > Could you annotate the tag as "[PATCH bpf]" ("[PATCH bpf v2]")?
> > >
> > > Please align comments to the left without margins.
> > >
> > > >
> > > >       Signed-off-by: SanjayKumar J <vjsanjay@gmail.com>
> > >
> > > This Singed-off-by is not needed.
> > >
> > > You can add my Ack in the next revision:
> > > Acked-by: Yonghong Song <yhs@fb.com>
> > >
> > > >
> > > > Signed-off-by: SanjayKumar J <vjsanjay@gmail.com>
> > > > ---
> > > >   tools/bpf/runqslower/runqslower.bpf.c | 2 +-
> > > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
> > > > index 645530ca7e98..ab9353f2fd46 100644
> > > > --- a/tools/bpf/runqslower/runqslower.bpf.c
> > > > +++ b/tools/bpf/runqslower/runqslower.bpf.c
> > > > @@ -74,7 +74,7 @@ int handle__sched_switch(u64 *ctx)
> > > >       u32 pid;
> > > >
> > > >       /* ivcsw: treat like an enqueue event and store timestamp */
> > > > -     if (prev->state == TASK_RUNNING)
> > > > +     if (prev->__state == TASK_RUNNING)
> > >
> > > Currently, runqslower.bpf.c uses vmlinux.h.
> > > I am thinking to use bpf_core_field_exists(), but we need to
> > > single out task_struct structure from vmlinux.h
> > > with both state and __state fields, we could make it work
> > > by *changes* like
> > >
> > > #define task_struct task_struct_orig
> > > #include "vmlinux.h"
> > > #undef task_struct
> > >
> > > struct task_struct {
> > >     ... state;
> > >     ... __state;
> > > ...
> > > };
> >
> >
> > no need for such surgery, recommended way is to use ___suffix to
> > declare incompatible struct definition:
> >
> > struct task_struct___old {
> >     int state;
> > };
> >
> > Then do casting in BPF code. We don't have to do it in kernel tree's
> > runqslower, but we'll definitely have to do that for libbpf-tools'
> > runqslower and runqlat.
>
> Question on this topic: state and __state are of different sizes here. IIUC,
> bpf_core_types_are_compat() does allow size mismatch. But it may cause
> problems in some cases, no? For example, would some combination make
> task->state return 32 extra bits from another field and cause confusion?

In this case it's two different fields, long state vs int __state, so
there is no confusion, you'd be using either one or another. But even
if it was the same field and its type changed from long to int, libbpf
will still try to accommodate that. Worst case,
BPF_CORE_READ_BITFIELD() is able to read any bitfield or integer
field, regardless of its size.

>
> Thanks,
> Song
