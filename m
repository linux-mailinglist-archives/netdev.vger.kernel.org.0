Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF2C4ECE24
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 22:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351046AbiC3Ulr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 16:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiC3Ulq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 16:41:46 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF34237D8;
        Wed, 30 Mar 2022 13:40:01 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id u22so19914325pfg.6;
        Wed, 30 Mar 2022 13:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IxJ+2fqQtSsTYPlRGM3piQWIajIXCVBAF61vrtKQylo=;
        b=UCBqabKfkd5UJAsITfqoLnXYRfLTNT7gLImrdxHwgVmLmetSr+kv/fqtCG3pKnSUUO
         YR6dQnL6QZC+y481uYIYnjhR+dplfBbUX39gYlS95XwaE5F2dETDn5c0etEy4PceLEbC
         ukR2df69dxu+UWeIU0RfYuOdn5vf7PYjvFbBptVhcWCFmsK1RVp3hbB/gvZJVUElAphq
         azPiJA9Y+jGL8Gnxh3k5NGZEpWL92NoEdGYA+msXea8DzTMB3aaLtQFFIbe++bqAKKKT
         80en/DHj1zHa+weCt7lZfaqBCVOtXUvCTUD6fvKsKI/KZpkKmirzVsYxsLnbpNpZcmap
         zSMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IxJ+2fqQtSsTYPlRGM3piQWIajIXCVBAF61vrtKQylo=;
        b=B/F9GIb77cRT+tYJu/5hV3Axn5EFsOudSdIAncMY1NEpn3eLx5QS4KWe8HdDW+/lwg
         bbMoNNjLq4N+Zf2S+9GgRGar1KVKlQE5k3gQ1UHQ1zXqU/llhitVfEhNsCWu6F37kizj
         30wl8iQcQVyjjXHYcVHZBKsix6umTR7Gf1Vn+y2AxL+JBdHZdPj0z5A1oQ/sB//LubLc
         hM7dxxzJzxwNHuEsVziBYEzrKYawZL+aArCTHQj6YA1fUPX4+Z9+fjXG53GY7omex4fb
         AVKfw6o1dGg9Xno1FT/Z1AvoOyBMI7v4ddGeTljY1mD8/zdkRqmdLWHSuAamb2MpoZ86
         04Zw==
X-Gm-Message-State: AOAM532sMfc1sGnk1J+zfe4sGb8fbsfbRnehVVIS8VOJmKGMXCGgH9b1
        EP64ZPUSYI3ixseuT6Lhi7KWb2Dbg9ryh6HQbOs=
X-Google-Smtp-Source: ABdhPJxjVxo79aVxa8qwAqQLtTxvZWX3Kf8d3dd1xuutPLo3KrAc4GDmaSES0q3U/Nd25ZPcmioiWEe7PsSCDf+48Jc=
X-Received: by 2002:a05:6a00:1c9e:b0:4fa:d946:378b with SMTP id
 y30-20020a056a001c9e00b004fad946378bmr1345122pfw.46.1648672800697; Wed, 30
 Mar 2022 13:40:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220329181935.2183-1-beaub@linux.microsoft.com>
 <CAADnVQ+XpoCjL-rSz2hj05L21s8NtMJuWYC14b9Mvk7XE5KT_g@mail.gmail.com>
 <20220329201057.GA2549@kbox> <CAADnVQ+gm4yU9S6y+oeR3TNj82kKX0gk4ey9gVnKXKWy1Js4-A@mail.gmail.com>
 <20220329231137.GA3357@kbox> <CAPhsuW4WH4Hn+DaQZui5au=ueG1G5zGYiOACfKm9imG2kGA+KA@mail.gmail.com>
 <20220330163411.GA1812@kbox> <CAADnVQKQw+K2CoCW-nA=bngKtjP495wpB1yhEXNjKg4wSeXAWg@mail.gmail.com>
 <20220330191551.GA2377@kbox>
In-Reply-To: <20220330191551.GA2377@kbox>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 30 Mar 2022 13:39:49 -0700
Message-ID: <CAADnVQL9T=zDbO04-s+WCtNRETs+mC=oDRwv8UUJYiJ7Dv1owA@mail.gmail.com>
Subject: Re: [PATCH] tracing/user_events: Add eBPF interface for user_event
 created events
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Song Liu <song@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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

On Wed, Mar 30, 2022 at 12:15 PM Beau Belgrave
<beaub@linux.microsoft.com> wrote:
>
> On Wed, Mar 30, 2022 at 11:22:32AM -0700, Alexei Starovoitov wrote:
> > On Wed, Mar 30, 2022 at 9:34 AM Beau Belgrave <beaub@linux.microsoft.com> wrote:
> > > > >
> > > > > But you are fine with uprobe costs? uprobes appear to be much more costly
> > > > > than a syscall approach on the hardware I've run on.
> >
> > Care to share the numbers?
> > uprobe over USDT is a single trap.
> > Not much slower compared to syscall with kpti.
> >
>
> Sure, these are the numbers we have from a production device.
>
> They are captured via perf via PERF_COUNT_HW_CPU_CYCLES.
> It's running a 20K loop emitting 4 bytes of data out.
> Each 4 byte event time is recorded via perf.
> At the end we have the total time and the max seen.
>
> null numbers represent a 20K loop with just perf start/stop ioctl costs.
>
> null: min=2863, avg=2953, max=30815
> uprobe: min=10994, avg=11376, max=146682

I suspect it's a 3 trap case of uprobe.
USDT is a nop. It's a 1 trap case.

> uevent: min=7043, avg=7320, max=95396
> lttng: min=6270, avg=6508, max=41951
>
> These costs include the data getting into a buffer, so they represent
> what we would see in production vs the trap cost alone. For uprobe this
> means we created a uprobe and attached it via tracefs to get the above
> numbers.
>
> There also seems to be some thinking around this as well from Song Liu.
> Link: https://lore.kernel.org/lkml/20200801084721.1812607-1-songliubraving@fb.com/
>
> From the link:
> 1. User programs are faster. The new selftest added in 5/5, shows that a
>    simple uprobe program takes 1400 nanoseconds, while user program only
>       takes 300 nanoseconds.


Take a look at Song's code. It's 2 trap case.
The USDT is a half of that. ~700ns.
Compared to 300ns of syscall that difference
could be acceptable.

>
> > > >
> > > > Can we achieve the same/similar performance with sys_bpf(BPF_PROG_RUN)?
> > > >
> > >
> > > I think so, the tough part is how do you let the user-space know which
> > > program is attached to run? In the current code this is done by the BPF
> > > program attaching to the event via perf and we run the one there if
> > > any when data is emitted out via write calls.
> > >
> > > I would want to make sure that operators can decide where the user-space
> > > data goes (perf/ftrace/eBPF) after the code has been written. With the
> > > current code this is done via the tracepoint callbacks that perf/ftrace
> > > hook up when operators enable recording via perf, tracefs, libbpf, etc.
> > >
> > > We have managed code (C#/Java) where we cannot utilize stubs or traps
> > > easily due to code movement. So we are limited in how we can approach
> > > this problem. Having the interface be mmap/write has enabled this
> > > for us, since it's easy to interact with in most languages and gives us
> > > lifetime management of the trace objects between user-space and the
> > > kernel.
> >
> > Then you should probably invest into making USDT work inside
> > java applications instead of reinventing the wheel.
> >
> > As an alternative you can do a dummy write or any other syscall
> > and attach bpf on the kernel side.
> > No kernel changes are necessary.
>
> We only want syscall/tracing overheads for the specific events that are
> hooked. I don't see how we could hook up a dummy write that is unique
> per-event without having a way to know when the event is being traced.

You're adding writev-s to user apps. Keep that writev without
any user_events on the kernel side and pass -1 as FD.
Hook bpf prog to sys_writev and filter by pid.
