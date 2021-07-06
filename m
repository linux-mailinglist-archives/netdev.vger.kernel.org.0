Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B733BDF40
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 00:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhGFWHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 18:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhGFWHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 18:07:39 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C360AC061574;
        Tue,  6 Jul 2021 15:05:00 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id g19so36570832ybe.11;
        Tue, 06 Jul 2021 15:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7s0iX2zt7Td9IA+iZNbaoXQLVEKP0qXg6cnYXh7MfYM=;
        b=gHVWCj6YooT+FaE9Vk2jTS7wj397IZy8h/5LYYzjCqU2+J76Q9PrOZ+fAP7N/U/O/c
         37wyCsrYZnbjzz3BtKJSnWnihXqKN/h5eHXLIjEE5f7x8C7fpgqSTgUog6ixwnhqxiKf
         hOJ6ZUY6GmEliH3riIWufKxXPgvKYY0tsqNWsYbYYm9hkkAlIVmdjwwVPSj27d82HBgb
         G6D7iFLzfVBDbHmCrY3gVJ4KxHSY2Xfgi07j5f7Da1h1ty/Oidmlf3KzKX/DBjP8IILR
         Elx47O0KL+wnjUS7EnNwDqNMWyOatcjwlXdrHyuQduJE0vXfTZfuvEhOMsk/c/0OcOfb
         6NdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7s0iX2zt7Td9IA+iZNbaoXQLVEKP0qXg6cnYXh7MfYM=;
        b=VLG8dOrVALI4RoSc9EFFYJgYwXP0xsr8BueR+1LB8KY3GWdEdIq2AXs15an+/6KTr3
         1ag4NLPJPED58TjsxWeXL5gzHGz84YmKNMPQxA2+PSpSDozslfHR2A7f4CVN+zCSm/aO
         m397J958lj0j344GSmlhXuoTTThGF5uug1tyvEVsJ/7o8WSRaxT1d8aCfROZQDyid284
         3kPoiRmyG5gJ1c8++TkG0QFfU2xirlYaBxoHu8M/pvyRmeRgjPY3NED6RC62ge2KudV5
         OdMHNoJWL4F/aiRS7T1ZdjTx79rhx17eBp2zdFtfdJnkZrZPsmzyV7LOxNAss+nPPOEv
         cWhA==
X-Gm-Message-State: AOAM532HNCGePZRsBTrIoJDM2Tjnvp3Rb4u4zGaxkXWjlcytrxqpdd8D
        OyouXEiZU/tTbwNlHSUJJ/v/DdmyC3po/G92gQE=
X-Google-Smtp-Source: ABdhPJwvr8zT6qgw016mwKlS7zr8Q+O7VDmnymrZ2p7ZvaYWCaz8NrRt+gCZURAlp/Gwjv6oShQIdyGq8zBqwQ3ZLUU=
X-Received: by 2002:a25:1ec4:: with SMTP id e187mr27166368ybe.425.1625609099595;
 Tue, 06 Jul 2021 15:04:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210706174409.15001-1-vjsanjay@gmail.com> <b87ad042-eaf0-d1ac-6760-b3c92439655d@fb.com>
In-Reply-To: <b87ad042-eaf0-d1ac-6760-b3c92439655d@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Jul 2021 15:04:48 -0700
Message-ID: <CAEf4BzZidvzFjw=m3zEmnrVhNYhrmy1pV-XgAfxMvgrb8Snw8w@mail.gmail.com>
Subject: Re: [PATCH] tools/runqslower: use __state instead of state
To:     Yonghong Song <yhs@fb.com>
Cc:     SanjayKumar J <vjsanjay@gmail.com>,
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

On Tue, Jul 6, 2021 at 11:26 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/6/21 10:44 AM, SanjayKumar J wrote:
> >       task->state is renamed to task->__state in task_struct
>
> Could you add a reference to
>    2f064a59a11f ("sched: Change task_struct::state")
> which added this change?
>
> I think this should go to bpf tree as the change is in linus tree now.
> Could you annotate the tag as "[PATCH bpf]" ("[PATCH bpf v2]")?
>
> Please align comments to the left without margins.
>
> >
> >       Signed-off-by: SanjayKumar J <vjsanjay@gmail.com>
>
> This Singed-off-by is not needed.
>
> You can add my Ack in the next revision:
> Acked-by: Yonghong Song <yhs@fb.com>
>
> >
> > Signed-off-by: SanjayKumar J <vjsanjay@gmail.com>
> > ---
> >   tools/bpf/runqslower/runqslower.bpf.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
> > index 645530ca7e98..ab9353f2fd46 100644
> > --- a/tools/bpf/runqslower/runqslower.bpf.c
> > +++ b/tools/bpf/runqslower/runqslower.bpf.c
> > @@ -74,7 +74,7 @@ int handle__sched_switch(u64 *ctx)
> >       u32 pid;
> >
> >       /* ivcsw: treat like an enqueue event and store timestamp */
> > -     if (prev->state == TASK_RUNNING)
> > +     if (prev->__state == TASK_RUNNING)
>
> Currently, runqslower.bpf.c uses vmlinux.h.
> I am thinking to use bpf_core_field_exists(), but we need to
> single out task_struct structure from vmlinux.h
> with both state and __state fields, we could make it work
> by *changes* like
>
> #define task_struct task_struct_orig
> #include "vmlinux.h"
> #undef task_struct
>
> struct task_struct {
>     ... state;
>     ... __state;
> ...
> };


no need for such surgery, recommended way is to use ___suffix to
declare incompatible struct definition:

struct task_struct___old {
    int state;
};

Then do casting in BPF code. We don't have to do it in kernel tree's
runqslower, but we'll definitely have to do that for libbpf-tools'
runqslower and runqlat.


>
> Considering tools/bpf/runqslower is tied with a particular
> kernel source, and vmlinux.h mostly derived from that
> kernel source, I feel the above change is not necessary.
>
> >               trace_enqueue(prev);
> >
> >       pid = next->pid;
> >
