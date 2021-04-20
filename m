Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91673651A0
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 06:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhDTEwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 00:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhDTEwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 00:52:22 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3803CC06174A;
        Mon, 19 Apr 2021 21:51:51 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id c195so41480580ybf.9;
        Mon, 19 Apr 2021 21:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OVm6Q6DWFJgZYgTCjlWXe5mpJJwXK8u9Ggs+d2c5dp8=;
        b=m8MKa5WLmJZUI2IEoPDo62XVr1psbRIgNp78NNoF+g0IShaen22e8YNPWiYIQgiudm
         m+ZQdDem8M+02PeyV5aFCog7MtZZ3nNiqqUoeJ2/UapjdG5KMjs7vx4WHJPWN88tXhPc
         V3cof9h2kGPcsz547d8s11BiyJJIpAY7VUAGcXzd4tTPpueXT1WYguMaR8iE0/Pb7S+F
         cYxJxMFTIYtO0HHIjqIWu+qCfsWiI69FQLgxnVkJ3e5ZCSzWBdSBdWRgspqtouvn04zh
         d/vfY6iDcvpyeXgymuxrQnMKNzzAuctE/1/iy+fNwGPTNVSEkOUl5c00WdpjD6njzAUS
         b68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OVm6Q6DWFJgZYgTCjlWXe5mpJJwXK8u9Ggs+d2c5dp8=;
        b=Fmf/Q4eSFCzZa5e87U+6AUPK9BAo+UitZNVrO7isu21BkVwCyZfsJFVM0EvYXZgJrA
         +8fxco6JgcFkV5JdrnqRng19cQh0wjFNuwKHBpS+5w+tf34g3wsUeEqI083qLI7JKWTy
         i7HDvbX3YOJZO8fha7HfelT9YCC5xRjid9ao8yNa51LIyABpvXYTsToHdqPyNzPMr/7Q
         QiW3V9/cexwVRPYDQ0/UMaXt4Q8b1aH4y+taMpQZQrb1FmkuAcXngbgHbP1k0ZyegJtc
         09R/J2w3Gm66Id0VBoNSkQOUaexIkMam4DKJkKfDQJAldDDVlqz0CA9RrUghemWictlS
         AbVg==
X-Gm-Message-State: AOAM530ymSNzhbG3dQGfqkS7d0n97Pilb1FOcOzDeBJIKW7in5THplFv
        gTWk7L9Dgwzxd2BJane+KDFT1jOABjfCstDfmx/KdMY410c=
X-Google-Smtp-Source: ABdhPJx5uXzKQusVJtOM01CRE9d4ygyU0A2E0rJTTYBatvyb4H6gee0oSzG31OavRvd2SXPuIPuQIFNP6Sagtt+0I0k=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr14318255ybg.459.1618894310552;
 Mon, 19 Apr 2021 21:51:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210413121516.1467989-1-jolsa@kernel.org> <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
 <YHbd2CmeoaiLJj7X@krava> <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
 <20210415111002.324b6bfa@gandalf.local.home> <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
 <20210415170007.31420132@gandalf.local.home> <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
In-Reply-To: <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 19 Apr 2021 21:51:39 -0700
Message-ID: <CAEf4Bzb1uDwSeW-5q06748foJ5=ShEgvF7kDmiCPnv4393SSVw@mail.gmail.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 8:03 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> Hi,
>
> On Thu, 15 Apr 2021 17:00:07 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> >
> > [
> >   Added Masami, as I didn't realize he wasn't on Cc. He's the maintainer of
> >   kretprobes.
> >
> >   Masami, you may want to use lore.kernel.org to read the history of this
> >   thread.
> > ]
> >
> > On Thu, 15 Apr 2021 13:45:06 -0700
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > > > I don't know how the BPF code does it, but if you are tracing the exit
> > > > of a function, I'm assuming that you hijack the return pointer and replace
> > > > it with a call to a trampoline that has access to the arguments. To do
> > >
> > > As Jiri replied, BPF trampoline doesn't do it the same way as
> > > kretprobe does it. Which gives the fexit BPF program another critical
> > > advantage over kretprobe -- we know traced function's entry IP in both
> > > entry and exit cases, which allows us to generically correlate them.
> > >
> > > I've tried to figure out how to get that entry IP from kretprobe and
> > > couldn't find any way. Do you know if it's possible at all or it's a
> > > fundamental limitation of the way kretprobe is implemented (through
> > > hijacking return address)?
>
> Inside the kretprobe handler, you can get the entry IP from kretprobe as below;
>
> static int my_kretprobe_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
> {
>         struct kretprobe *rp = get_kretprobe(ri);
>         unsigned long entry = (unsigned long)rp->kp.addr;
>         unsigned long retaddr = (unsigned long)ri->ret_addr;
>         ...
> }

Great. In kprobe_perf_func(), which seems to be the callback that
triggers kretprobe BPF programs, we can get that struct kretprobe
through tk->rp. So we'll just need to figure out how to pass that into
the BPF program in a sane way. Thanks!

>
> It is ensured that rp != NULL in the handler.
>
> >
> > The function graph tracer has the entry IP on exit, today. That's how we
> > can trace and show this:
> >
> >  # cd /sys/kernel/tracing
> >  # echo 1 > echo 1 > options/funcgraph-tail
> >  # echo function_graph > current_tracer
> >  # cat trace
> > # tracer: function_graph
> > #
> > # CPU  DURATION                  FUNCTION CALLS
> > # |     |   |                     |   |   |   |
> >  7)   1.358 us    |  rcu_idle_exit();
> >  7)   0.169 us    |  sched_idle_set_state();
> >  7)               |  cpuidle_reflect() {
> >  7)               |    menu_reflect() {
> >  7)   0.170 us    |      tick_nohz_idle_got_tick();
> >  7)   0.585 us    |    } /* menu_reflect */
> >  7)   1.115 us    |  } /* cpuidle_reflect */
> >
> > That's how we can show the tail function that's called. I'm sure kreprobes
> > could do the same thing.
>
> Yes, I have to update the document how to do that (and maybe introduce 2 functions
> to wrap the entry/retaddr code)
>
> >
> > The patch series I shared with Jiri, was work to allow kretprobes to be
> > built on top of the function graph tracer.
> >
> > https://lore.kernel.org/lkml/20190525031633.811342628@goodmis.org/
> >
> > The feature missing from that series, and why I didn't push it (as I had
> > ran out of time to work on it), was that kreprobes wants the full regs
> > stack as well. And since kretprobes was the main client of this work, that
> > I decided to work on this at another time. But like everything else, I got
> > distracted by other work, and didn't realize it has been almost 2 years
> > since looking at it :-p
> >
> > Anyway, IIRC, Masami wasn't sure that the full regs was ever needed for the
> > return (who cares about the registers on return, except for the return
> > value?)
>
> I think kretprobe and ftrace are for a bit different usage. kretprobe can be
> used for something like debugger. In that case, accessing full regs stack
> will be more preferrable. (BTW, what the not "full regs" means? Does that
> save partial registers?)
>
>
> Thank you,
>
> > But this code could easily save the parameters as well.
> >
> > >
> > > > this you need a shadow stack to save the real return as well as the
> > > > parameters of the function. This is something that I have patches that do
> > > > similar things with function graph.
> > > >
> > > > If you want this feature, lets work together and make this work for both
> > > > BPF and ftrace.
> > >
> > > Absolutely, ultimately for users it doesn't matter what specific
> > > mechanism is used under the cover. It just seemed like BPF trampoline
> > > has all the useful tracing features (entry IP and input arguments in
> > > fexit) already and is just mostly missing a quick batch attach API. If
> > > we can get the same from ftrace, all the better.
> >
> > Let me pull these patches out again, and see what we can do. Since then,
> > I've added the code that lets function tracer save parameters and the
> > stack, and function graph can use that as well.
> >
> >
> > -- Steve
>
>
> --
> Masami Hiramatsu <mhiramat@kernel.org>
