Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACA5445C9D
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 00:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhKDX0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 19:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhKDX0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 19:26:02 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA66C061714;
        Thu,  4 Nov 2021 16:23:24 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id t127so18276647ybf.13;
        Thu, 04 Nov 2021 16:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w1ny6v8Ff+jiCmOKwd3n0gTTmMzBCgLS1MQy6CI2ZKk=;
        b=Bt0kp4bGZyajR+SKx68pxZuow9kPqmiCx4ilXzCs5N6pocvL/MJiXl8ISFhXzE/ieL
         bc8oT9Dtza3r+2OpRG0ZAkqy16Y8Dz1ROdWRlGGVphGZMpI9VokCZCmXLl+X6UZaTuGh
         2BxSir2SGSnOG2hKll6jUZ6kYUuk1qR3O3PwRFYkDPaQTai3QFlgS/gTSXqFSJHLgij6
         tLHxygOSF0ihG6yUVmsneKRVp+V+Ge2RYZ7z22MyZfewmE31hvy+92lD9hQg8L7RDW3f
         0ab6LhSNPXl5dsL4/aOamsNUcLW8NzxeZjktrM/UIURJ82oeNMEu4odtOxgzeUA2VvSL
         FsEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w1ny6v8Ff+jiCmOKwd3n0gTTmMzBCgLS1MQy6CI2ZKk=;
        b=fNp8nRx8tskk8JYIgPgGEHwLySD52ORY78lXVn4ft9ITK6AGFHPfhrKUrrjOC5c/07
         53KNy96ShFQgvUl7CIGRU2hatuiKaHopYhQl6GWHj2h/ZC6wonwn9ER0W7ZXw1GyoxRW
         otIbqYxIQRhXjLi9tNF/qWH2JbbLhQIJhw5aRpc60Z1BeN4SA1NxAWbXs80qCCq92V+m
         GDuQ8TQImURsTivOLXOLgFCP41vYtNDV5Gpv+lsRFEJSMbih7ZtwAg0PhTSXgCcOhtFE
         hdsyyD2aoRbgoZDnDClwf8Kq+h53Fyd3ZoTpy++htIN5lqVdTJYowvTGIcQ+Vprvevt2
         tyCA==
X-Gm-Message-State: AOAM530WkWpQ4rK7OMKUvqis0EWGQdMHOhaF5tIsNQFI25ly0nXpN643
        YQ/UL1sTrgvyLCyQM0/LwCuBzdAjHNHxLoepHP8=
X-Google-Smtp-Source: ABdhPJx9lEiJykh9uI1934RoVEkE2eq4IQg8O7IREyA47sZVHk3P49V2CN2HHUnWjt8dKzEeSO27psDJEIn2ig5Cq/Q=
X-Received: by 2002:a25:d187:: with SMTP id i129mr47046676ybg.2.1636068203465;
 Thu, 04 Nov 2021 16:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <1635932969-13149-1-git-send-email-alan.maguire@oracle.com>
 <1635932969-13149-3-git-send-email-alan.maguire@oracle.com>
 <CAEf4BzadDy006mGCZac4kySX_re7eFe6VY0cHgkpY3fQNRuASg@mail.gmail.com> <alpine.LRH.2.23.451.2111042248360.7576@localhost>
In-Reply-To: <alpine.LRH.2.23.451.2111042248360.7576@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 4 Nov 2021 16:23:12 -0700
Message-ID: <CAEf4BzaX65wMwEGZJ6HL+zOtAQjUk3A5ySiECYuSH5bLsPFAGg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: add exception handling
 selftests for tp_bpf program
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ardb@kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, andreyknvl@gmail.com,
        vincenzo.frascino@arm.com, Mark Rutland <mark.rutland@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>, joey.gouly@arm.com,
        maz@kernel.org, daizhiyuan@phytium.com.cn, jthierry@redhat.com,
        Tian Tao <tiantao6@hisilicon.com>,
        Peter Collingbourne <pcc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, rppt@kernel.org,
        Jisheng.Zhang@synaptics.com, liu.hailong6@zte.com.cn,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 4, 2021 at 3:56 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
>
>
> On Wed, 3 Nov 2021, Andrii Nakryiko wrote:
>
> > On Wed, Nov 3, 2021 at 2:50 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> > >
> > > Exception handling is triggered in BPF tracing programs when
> > > a NULL pointer is dereferenced; the exception handler zeroes the
> > > target register and execution of the BPF program progresses.
> > >
> > > To test exception handling then, we need to trigger a NULL pointer
> > > dereference for a field which should never be zero; if it is, the
> > > only explanation is the exception handler ran.  The skb->sk is
> > > the NULL pointer chosen (for a ping received for 127.0.0.1 there
> > > is no associated socket), and the sk_sndbuf size is chosen as the
> > > "should never be 0" field.  Test verifies sk is NULL and sk_sndbuf
> > > is zero.
> > >
> > > Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> > > ---
> > >  tools/testing/selftests/bpf/prog_tests/exhandler.c | 45 ++++++++++++++++++++++
> > >  tools/testing/selftests/bpf/progs/exhandler_kern.c | 35 +++++++++++++++++
> > >  2 files changed, 80 insertions(+)
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/exhandler.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/exhandler_kern.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/exhandler.c b/tools/testing/selftests/bpf/prog_tests/exhandler.c
> > > new file mode 100644
> > > index 0000000..5999498
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/prog_tests/exhandler.c
> <snip>
> > > +
> > > +       bss = skel->bss;
> >
> > nit: you don't need to have a separate variable for that,
> > skel->bss->exception_triggered in below check would be just as
> > readable
> >
>
> sure, will do.
>
> > > +
> > > +       err = exhandler_kern__attach(skel);
> > > +       if (CHECK(err, "attach", "attach failed: %d\n", err))
> > > +               goto cleanup;
> > > +
> > > +       if (CHECK(SYSTEM("ping -c 1 127.0.0.1"),
> >
> > Is there some other tracepoint or kernel function that could be used
> > for testing and triggered without shelling out to ping binary? This
> > hurts test isolation and will make it or some other ping-using
> > selftests spuriously fail when running in parallel test mode (i.e.,
> > sudo ./test_progs -j).
>
> I've got a new version of this working which uses a fork() in
> combination with tp_btf/task_newtask ; the new task will have
> a NULL task->task_works pointer, but if it wasn't NULL it
> would have to point at a struct callback_head containing a
> non-NULL callback function. So we can verify that
> task->task_works and task->task_works->func are NULL to ensure
> exception triggered instead.  That should interfere
> less with other parallel tests hopefully?

Yeah, tracing a fork would be better, thanks!. Make sure you are
filtering by pid, to avoid accidentally tripping on some unrelated
fork.

>
> >
> > > +                 "ping localhost",
> > > +                 "ping localhost failed\n"))
> > > +               goto cleanup;
> > > +
> > > +       if (CHECK(bss->exception_triggered == 0,
> >
> > please use ASSERT_EQ() instead, CHECK()s are kind of deprecated for new tests
> >
>
>
> sure, will do.
>
> > > diff --git a/tools/testing/selftests/bpf/progs/exhandler_kern.c b/tools/testing/selftests/bpf/progs/exhandler_kern.c
> > > new file mode 100644
> > > index 0000000..4049450
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/progs/exhandler_kern.c
> > > @@ -0,0 +1,35 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/* Copyright (c) 2021, Oracle and/or its affiliates. */
> > > +
> > > +#include "vmlinux.h"
> > > +
> > > +#include <bpf/bpf_helpers.h>
> > > +#include <bpf/bpf_tracing.h>
> > > +#include <bpf/bpf_core_read.h>
> > > +
> > > +char _license[] SEC("license") = "GPL";
> > > +
> > > +unsigned int exception_triggered;
> > > +
> > > +/* TRACE_EVENT(netif_rx,
> > > + *         TP_PROTO(struct sk_buff *skb),
> > > + */
> > > +SEC("tp_btf/netif_rx")
> > > +int BPF_PROG(trace_netif_rx, struct sk_buff *skb)
> > > +{
> > > +       struct sock *sk;
> > > +       int sndbuf;
> > > +
> > > +       /* To verify we hit an exception we dereference skb->sk->sk_sndbuf;
> > > +        * sndbuf size should never be zero, so if it is we know the exception
> > > +        * handler triggered and zeroed the destination register.
> > > +        */
> > > +       __builtin_preserve_access_index(({
> > > +               sk = skb->sk;
> > > +               sndbuf = sk->sk_sndbuf;
> > > +       }));
> >
> > you don't need __builtin_preserve_access_index(({ }) region, because
> > vmlinux.h already annotates all the types with preserve_access_index
> > attribute
> >
>
> ah, great, I missed that somehow. Thanks!
>
> Alan
