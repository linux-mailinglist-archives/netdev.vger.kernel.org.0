Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9264BC06C
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 20:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbiBRTqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 14:46:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234826AbiBRTqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 14:46:30 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7681A2E7A;
        Fri, 18 Feb 2022 11:46:13 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id d3so5451621ilr.10;
        Fri, 18 Feb 2022 11:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NtZXoooqCDPAZYhZFj3ZqvMxpCYgOZsPpYOZ1vg41sE=;
        b=lCkf7ZGtKl4Np1oR9fePi+RvDaHQVlc7uRgy5rqKFL13Mt7LLrSpoFMV15KhWxV/JB
         oOk8Vu2sk/5lq5mv5LLnP457jQJadCNn0FBhLvT46RqQprxsW5xXKj8VH7TKMay1LSMw
         d0eBXtTTyNFCMhItQBBvFJ9o1Kc6AbNHNKVkwuqHb59CDTWEo9dTS85DF/LWVtwLu8WN
         IXGVF1vjn4pvlotIq5hO+YTuQzZ7pRzwc1vFs6bGYpaj2ablRC8PE5NBNS6mBnigLpfg
         H8BcEbkiQNk+r9GaVehWaPYZUHsUtF2bwE0pgaJfJvqnLfXi6UrWLaX9tNgC+XKfRX0s
         VL2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NtZXoooqCDPAZYhZFj3ZqvMxpCYgOZsPpYOZ1vg41sE=;
        b=6o4t63gS4UCAjvFRiL+KzSpWI1AqGamVb4NhYSfiExsDRV9B57x+ecVrsfcgiRz+gM
         l9opKIkJUfFsg6DvWnKpK7N2H2PYIsNF+a8vijeKEbXMWFsCaZjRUbNxOkLl6U0xS9X2
         iPhbBdILgTklEg5FK9MWZNCEEQPUErjAPcp8A2zsSHai1oiQJIcFuKlfflfi0kRGFc+3
         xaM5a/PXNYnMblU4aj04V7Vb1rKu+rQ8SGprUZ0da41BrojLJgrhnfR8qKh/CTAss6C6
         bQed0HaL3jzXDDPl8fI4HC8l04zB5iBah31tU8wxmECWnceQahSXharE1Zc4eaPbbrT1
         74Hw==
X-Gm-Message-State: AOAM5338bo3kaKz+SXTXzy+Vnzass3HSW+S+LwtxkLuACzj5txQBa86e
        BfbmjBzlXIhXHrWcMnghEj/rZod6eO36xT+51kY=
X-Google-Smtp-Source: ABdhPJzINzjgFGOAayf7gdBfTBcKyugk8IUzTeyKMb+T3r0cZicwb7BndLSqLTd7hBa64N+q3DifFydJdtXKs3kaeIs=
X-Received: by 2002:a92:d208:0:b0:2c1:1a3c:7b01 with SMTP id
 y8-20020a92d208000000b002c11a3c7b01mr6430392ily.71.1645213572928; Fri, 18 Feb
 2022 11:46:12 -0800 (PST)
MIME-Version: 1.0
References: <Yfq+PJljylbwJ3Bf@krava> <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
 <YfvvfLlM1FOTgvDm@krava> <20220204094619.2784e00c0b7359356458ca57@kernel.org>
 <CAADnVQJYY0Xm6M9O02E5rOkdQPX39NOOS4tM2jpwRLQvP-qDBg@mail.gmail.com>
 <20220204110704.7c6eaf43ff9c8f5fe9bf3179@kernel.org> <CAADnVQJfq_10H0V+u0w0rzyZ9uy7vq=T-3BMDANjEN8A3-prsQ@mail.gmail.com>
 <20220203211954.67c20cd3@gandalf.local.home> <CAADnVQKjNJjZDs+ZV7vcusEkKuDq+sWhSD3M5GtvNeZMx3Fcmg@mail.gmail.com>
 <20220204125942.a4bda408f536c2e3248955e1@kernel.org> <Yguo4v7c+3A0oW/h@krava>
 <CAEf4BzYO_B51TPgUnDXUPUsK55RSczwcnhuLz9DMbfO5JCj=Cw@mail.gmail.com>
 <20220217230357.67d09baa261346a985b029b6@kernel.org> <CAEf4BzYxcSCae=sF3EKNUtLDCZhkhHkd88CEBt4bffzN_AZrDw@mail.gmail.com>
 <20220218130727.51db96861c3e1c79b45daafb@kernel.org>
In-Reply-To: <20220218130727.51db96861c3e1c79b45daafb@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 18 Feb 2022 11:46:01 -0800
Message-ID: <CAEf4BzY1fiihJ2_9yBeFQ-rtXL49A3MLeKyNbYB7XiqWYthTzA@mail.gmail.com>
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 8:07 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> On Thu, 17 Feb 2022 14:01:30 -0800
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
>
> > > > Is there any chance to support this fast multi-attach for uprobe? If
> > > > yes, we might want to reuse the same link for both (so should we name
> > > > it more generically?
> > >
> > > There is no interface to do that but also there is no limitation to
> > > expand uprobes. For the kprobes, there are some limitations for the
> > > function entry because it needs to share the space with ftrace. So
> > > I introduced fprobe for easier to use.
> > >
> > > > on the other hand BPF program type for uprobe is
> > > > BPF_PROG_TYPE_KPROBE anyway, so keeping it as "kprobe" also would be
> > > > consistent with what we have today).
> > >
> > > Hmm, I'm not sure why BPF made such design choice... (Uprobe needs
> > > the target program.)
> > >
> >
> > We've been talking about sleepable uprobe programs, so we might need
> > to add uprobe-specific program type, probably. But historically, from
> > BPF point of view there was no difference between kprobe and uprobe
> > programs (in terms of how they are run and what's available to them).
> > From BPF point of view, it was just attaching BPF program to a
> > perf_event.
>
> Got it, so that will reuse the uprobe_events in ftrace. But I think
> the uprobe requires a "path" to the attached binary, how is it
> specified?

It's passed as a string to perf subsystem during perf_event_open() syscall.

>
> > > > But yeah, the main question is whether there is something preventing
> > > > us from supporting multi-attach uprobe as well? It would be really
> > > > great for USDT use case.
> > >
> > > Ah, for the USDT, it will be useful. But since now we will have "user-event"
> > > which is faster than uprobes, we may be better to consider to use it.
> >
> > Any pointers? I'm not sure what "user-event" refers to.
>
> Here is the user-events series, which allows user program to define
> raw dynamic events and it can write raw event data directly from
> user space.
>
> https://lore.kernel.org/all/20220118204326.2169-1-beaub@linux.microsoft.com/
>

Thanks for the link! I'll check it out.

> Thank you,
>
> --
> Masami Hiramatsu <mhiramat@kernel.org>
