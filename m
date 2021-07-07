Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD333BE2A5
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 07:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhGGFk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 01:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhGGFk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 01:40:56 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D880C061574;
        Tue,  6 Jul 2021 22:38:15 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id e14so817123qkl.9;
        Tue, 06 Jul 2021 22:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mLGh5tTzL/cG8c5FVtlvOA2pfQm08Wk1nun4HQEKIpI=;
        b=RFNTOQBM8C6TeOtOnYLXdRjMbJMlkpVVHYRNT/buctcsYKDsB8/9KF6V1yngvmmD7V
         sd5zR7IwlSPh9uNoEDP9w6HngwefFOA8HSeTqz03k8Q0mXYVoO1PI5TAIyL4AvQZk+dv
         DzCMEnsaTuLMBWok0miAQ9Q3I/ugQ+hYIQJHtL1+YX8RI3WZ4uj8A2c41GM5WPVyDEv+
         lJa2bpG4WKf7l1X0LCqO0yJ5zO6VfQmHA/cihvsNdLAdrD4YXHeK5bUZNVqoGhi5Lrc5
         9JPdE5EsPJcVUR9elsA5CMuxC9Yv71jm1yNj7t1KnlAwQcJIChm07FZa0fqR3iLti+EL
         ySuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mLGh5tTzL/cG8c5FVtlvOA2pfQm08Wk1nun4HQEKIpI=;
        b=CqlEt5qVxVWKTsmEXD1AjuV6EIUSI7ony7Zm47pxu9QzPBH6it8hDd/lVn9MZo/wOb
         3GJL5SHT3G59heZS5FVTQwRFcS0Ogh7TTgsok9Rm/fD9DbhKYr3OxkiX9aG86+8cw4lC
         QXWdGQq4lS463gVEAPvDrxnVRIrkicpQU+ql8rjU/JDYR96ci2fB4E6ZbFIG2GpKi8Nn
         1IUpZ7UwYZ9gEYyhO4vjAY6al3yty9LlMnJPn808jcycw2ZJRy7aWlC+9DPTlXa49Or/
         oX2nXyHHVmI4ktVv32co8ua4/wmMZyowG5y54l4wYTYy7GE4bAmf8mfTJGp3jYSUOom3
         6KgQ==
X-Gm-Message-State: AOAM5314OiQ7Xy80U3orvu4ZA+yDV2xAwzbhz8Br4+8uPdlfUf76WEz0
        dHBtI5M+1yHY1PGkqjp4l52Gg5jgQ9dgNkj4feA=
X-Google-Smtp-Source: ABdhPJx/frs+cbkbnaGXPeFu/aBTa/lrKhJDEt2cOC6XBkddLnddyB0dRZA97HVB7MZtxmsUHh4rvKed93toasaiN38=
X-Received: by 2002:ae9:dd06:: with SMTP id r6mr24188863qkf.74.1625636292828;
 Tue, 06 Jul 2021 22:38:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210706174409.15001-1-vjsanjay@gmail.com> <b87ad042-eaf0-d1ac-6760-b3c92439655d@fb.com>
 <CAEf4BzZLZcUhij2LjiZ7W_YfdW+DiiMEjyB2jVA+D9+d41utgg@mail.gmail.com>
In-Reply-To: <CAEf4BzZLZcUhij2LjiZ7W_YfdW+DiiMEjyB2jVA+D9+d41utgg@mail.gmail.com>
From:   Sanjay Kumar J <vjsanjay@gmail.com>
Date:   Wed, 7 Jul 2021 11:05:40 +0530
Message-ID: <CAN7cG1ZDC4PXvwuXb2zvM3Z_xA-sTbKbd7ASw+mJzh-fD+0QCw@mail.gmail.com>
Subject: Re: [PATCH] tools/runqslower: use __state instead of state
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
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

On Wed, Jul 7, 2021 at 9:53 AM Andrii Nakryiko
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
>
> Please use a full and proper name in Signed-off-by.
>
> This currently breaks selftests build in bpf tree, so please
> prioritize sending v2. Alternatively, we can apply Jiri's fix instead.
>
   I have send v4 .. apologies for the iterations.

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
> >
> > Considering tools/bpf/runqslower is tied with a particular
> > kernel source, and vmlinux.h mostly derived from that
> > kernel source, I feel the above change is not necessary.
> >
> > >               trace_enqueue(prev);
> > >
> > >       pid = next->pid;
> > >
