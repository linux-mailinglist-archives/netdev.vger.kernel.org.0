Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385283BDFA8
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 01:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhGFXOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 19:14:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230012AbhGFXOL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 19:14:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7234E61CB0;
        Tue,  6 Jul 2021 23:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625613092;
        bh=EOwCeWrO1xda1Q1l3BgEjdJEqMXFJtlECZzdKuyENmg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Lpc+5ak7jRQozvjHcl2dFyXzsGreTkw3jC0fi9DmL8BfDe30k+Ch7l4BUi5NOqzca
         Mddo7dHf+oVj1iHZozqNjRTBhobLL49Xy69cTqrMSV3blwcMswaQG9OnHU/nGY8JtL
         FjlnUZlG/OKm/Vd0NK87+xR4YRyRVNAZUWgEXYOyUInRXn8+Crho2tzIdeYPc1MYlT
         WQpsJpPjpbATI3FL4zZlTZbGn/TPOOBc6Si7Q0qZpmGvAEtkkuPh1DneXwDztG3gGw
         eTbSkiReq6NkU4tL3MsdE4tSAG0sEMCMzbUto+i43HZlp+rvDQoBkPyo1mar3BBs48
         HqtKahBgKWr3A==
Received: by mail-lj1-f179.google.com with SMTP id k8so228042lja.4;
        Tue, 06 Jul 2021 16:11:32 -0700 (PDT)
X-Gm-Message-State: AOAM532nOZWngzjnMaotexetZHnZZ+8Thv5EDEDvDGn6sQZaI/w/NA9+
        2vLTk21wlIA+OvPIjZfVSNXrMeAoLUyKXlcdlGQ=
X-Google-Smtp-Source: ABdhPJzbyZggoQgHXszIIbrZCG7wCB7WIbfCbZIDFecoKGN4kVmYEnr8QixAH0LCuXep0FVddJFAS60XmnvyB69L6TQ=
X-Received: by 2002:a2e:6a07:: with SMTP id f7mr8954651ljc.506.1625613090714;
 Tue, 06 Jul 2021 16:11:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210706174409.15001-1-vjsanjay@gmail.com> <b87ad042-eaf0-d1ac-6760-b3c92439655d@fb.com>
 <CAEf4BzZidvzFjw=m3zEmnrVhNYhrmy1pV-XgAfxMvgrb8Snw8w@mail.gmail.com>
In-Reply-To: <CAEf4BzZidvzFjw=m3zEmnrVhNYhrmy1pV-XgAfxMvgrb8Snw8w@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 6 Jul 2021 16:11:19 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4EeY9CHE73Sy6zdteLhj6G-f+M9jSxrPuXpE81tPZoeA@mail.gmail.com>
Message-ID: <CAPhsuW4EeY9CHE73Sy6zdteLhj6G-f+M9jSxrPuXpE81tPZoeA@mail.gmail.com>
Subject: Re: [PATCH] tools/runqslower: use __state instead of state
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Tue, Jul 6, 2021 at 3:05 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Jul 6, 2021 at 11:26 AM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 7/6/21 10:44 AM, SanjayKumar J wrote:
> > >       task->state is renamed to task->__state in task_struct
> >
> > Could you add a reference to
> >    2f064a59a11f ("sched: Change task_struct::state")
> > which added this change?
> >
> > I think this should go to bpf tree as the change is in linus tree now.
> > Could you annotate the tag as "[PATCH bpf]" ("[PATCH bpf v2]")?
> >
> > Please align comments to the left without margins.
> >
> > >
> > >       Signed-off-by: SanjayKumar J <vjsanjay@gmail.com>
> >
> > This Singed-off-by is not needed.
> >
> > You can add my Ack in the next revision:
> > Acked-by: Yonghong Song <yhs@fb.com>
> >
> > >
> > > Signed-off-by: SanjayKumar J <vjsanjay@gmail.com>
> > > ---
> > >   tools/bpf/runqslower/runqslower.bpf.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
> > > index 645530ca7e98..ab9353f2fd46 100644
> > > --- a/tools/bpf/runqslower/runqslower.bpf.c
> > > +++ b/tools/bpf/runqslower/runqslower.bpf.c
> > > @@ -74,7 +74,7 @@ int handle__sched_switch(u64 *ctx)
> > >       u32 pid;
> > >
> > >       /* ivcsw: treat like an enqueue event and store timestamp */
> > > -     if (prev->state == TASK_RUNNING)
> > > +     if (prev->__state == TASK_RUNNING)
> >
> > Currently, runqslower.bpf.c uses vmlinux.h.
> > I am thinking to use bpf_core_field_exists(), but we need to
> > single out task_struct structure from vmlinux.h
> > with both state and __state fields, we could make it work
> > by *changes* like
> >
> > #define task_struct task_struct_orig
> > #include "vmlinux.h"
> > #undef task_struct
> >
> > struct task_struct {
> >     ... state;
> >     ... __state;
> > ...
> > };
>
>
> no need for such surgery, recommended way is to use ___suffix to
> declare incompatible struct definition:
>
> struct task_struct___old {
>     int state;
> };
>
> Then do casting in BPF code. We don't have to do it in kernel tree's
> runqslower, but we'll definitely have to do that for libbpf-tools'
> runqslower and runqlat.

Question on this topic: state and __state are of different sizes here. IIUC,
bpf_core_types_are_compat() does allow size mismatch. But it may cause
problems in some cases, no? For example, would some combination make
task->state return 32 extra bits from another field and cause confusion?

Thanks,
Song
