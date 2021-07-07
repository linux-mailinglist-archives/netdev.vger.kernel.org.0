Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678133BE1E5
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 06:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhGGE0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 00:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhGGE0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 00:26:06 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A21C061574;
        Tue,  6 Jul 2021 21:23:16 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id r132so1115723yba.5;
        Tue, 06 Jul 2021 21:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+p6VB8Hd51uU7jYbLYvHGKh32BmqnmmU1N8kDEnL9dQ=;
        b=In4I5xpswdJNBskECT5fupSFKkmyJzZXtcQ0JCDwq/j3O/QNL9/D4qNBFB772K3efa
         3ws5sjfzxEMsFY4OKljKa6foYG5rx03badn+3KvaZYhugqtlEwhr1mRiS59jmXDexlxx
         yKYLMvxpEejeKfteA5GwGu6WVCBH+uiUGyy+hRe3Ftt5uue1h4GMf2oIIG3hGxpRaSVs
         7UJdrDIgBKYUrjrVmJrNs0e9bxFra8lcR4kBjanQNb3LWgb+xXw9/S4IoTdJ8aU9f07w
         Dj4jDRLh2f2QqJuw5gaMgtnC4Ce4OongnnuCGKXCBHb36XjzO3K/mF/A5x6D8aw2Nbtn
         A+pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+p6VB8Hd51uU7jYbLYvHGKh32BmqnmmU1N8kDEnL9dQ=;
        b=ZbT4IxTrNZqzARmkHUFQ2wbbAnI4XfMtmajHLHrz3DrVv5WXxCkRIvolxBmq4aWMBW
         JiCo1FKyhBmvzUqjLROEta2y1atUbWWmO07tVs9LRd23i4tfLLaolYMblxP+8rpABNLm
         fKyqP5BfjR6yNXoopjcczra64Uroctq+vI1osywECjLMVpEuKLEHsgoFAA0EpLcYP4SH
         3XBM3HNiRDKgMDVLvawpvzHNWR4rTjHfZyrjiTpBgFn2rUA8R9gGv9ZDB4qWyxq5bWAT
         kNwprcQ/HC3jWWXAdLxlJGE/RWLuMoyYA5U88q7VzSDbPZ7YA8sRz0L4KfqV+58dZTj5
         V8uA==
X-Gm-Message-State: AOAM532MwWsVSbCN4J/S5z3i62BY2S1tsjcoJ2H8oX32s2JPfuDnYjim
        KODsLf5iAy9H6lzBcwIDUV7IJenFf/v9fCJbMPk=
X-Google-Smtp-Source: ABdhPJzrgonRH+zbm42wm7TV8GFSOooCvyByldmlHUa5XEBAvbe74DbKe7Lwvj2vPy/7MbTz9QKhMOnznbd9G6CxrWY=
X-Received: by 2002:a25:3787:: with SMTP id e129mr28600364yba.459.1625631795576;
 Tue, 06 Jul 2021 21:23:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210706174409.15001-1-vjsanjay@gmail.com> <b87ad042-eaf0-d1ac-6760-b3c92439655d@fb.com>
In-Reply-To: <b87ad042-eaf0-d1ac-6760-b3c92439655d@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Jul 2021 21:23:04 -0700
Message-ID: <CAEf4BzZLZcUhij2LjiZ7W_YfdW+DiiMEjyB2jVA+D9+d41utgg@mail.gmail.com>
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

Please use a full and proper name in Signed-off-by.

This currently breaks selftests build in bpf tree, so please
prioritize sending v2. Alternatively, we can apply Jiri's fix instead.

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
>
> Considering tools/bpf/runqslower is tied with a particular
> kernel source, and vmlinux.h mostly derived from that
> kernel source, I feel the above change is not necessary.
>
> >               trace_enqueue(prev);
> >
> >       pid = next->pid;
> >
