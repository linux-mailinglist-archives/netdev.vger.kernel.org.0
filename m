Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18C44BD6FC
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 08:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240291AbiBUHSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 02:18:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345941AbiBUHSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 02:18:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0282631;
        Sun, 20 Feb 2022 23:18:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE81860F31;
        Mon, 21 Feb 2022 07:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93AEC340E9;
        Mon, 21 Feb 2022 07:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645427894;
        bh=LgQjXd4WN0kF4H55no28FnkGWNbYSD9+uIC761PMlbc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e4uPllXxesVF8kZU6rixAvWBH7hkw5/x6qSlo1CxnP0B9Zt+wA+DFDrSlh2/9Zv57
         BZrYiJZqlvm/yMNGLPYK4k2Wi0g4HcR3osWJn16gkcbc9Ra2xWgIG0xNIK1M2Ya04O
         Tv2BwVvv6XH+Azr/T2tlXdCsOnya7t5wpfpZlbR4LOqUDRAGWkCCB/qwji/0fzFz/n
         nFC6RKpk/LenLzQyx7jQWiK/kxIoAq6sftOzrzp9wZoYzKaoNOLQe38awRe4/87Z6l
         XJTXJwUAC/aWwrCVuKW5yiBf+iW6AszicZMXw58qW5+V01h2Msbi2hOJ2Sjs3OCyGk
         wssEgTVrgaMUw==
Date:   Mon, 21 Feb 2022 16:18:08 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <olsajiri@gmail.com>,
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
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
Message-Id: <20220221161808.46d9809fed5be7be8e16e47d@kernel.org>
In-Reply-To: <CAADnVQ+eojJ8KMwbieJrtOf7oWPqw7VDYV9EAAWpx3UoFHZFDQ@mail.gmail.com>
References: <Yfq+PJljylbwJ3Bf@krava>
        <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
        <YfvvfLlM1FOTgvDm@krava>
        <20220204094619.2784e00c0b7359356458ca57@kernel.org>
        <CAADnVQJYY0Xm6M9O02E5rOkdQPX39NOOS4tM2jpwRLQvP-qDBg@mail.gmail.com>
        <20220204110704.7c6eaf43ff9c8f5fe9bf3179@kernel.org>
        <CAADnVQJfq_10H0V+u0w0rzyZ9uy7vq=T-3BMDANjEN8A3-prsQ@mail.gmail.com>
        <20220203211954.67c20cd3@gandalf.local.home>
        <CAADnVQKjNJjZDs+ZV7vcusEkKuDq+sWhSD3M5GtvNeZMx3Fcmg@mail.gmail.com>
        <20220204125942.a4bda408f536c2e3248955e1@kernel.org>
        <Yguo4v7c+3A0oW/h@krava>
        <CAEf4BzYO_B51TPgUnDXUPUsK55RSczwcnhuLz9DMbfO5JCj=Cw@mail.gmail.com>
        <20220217230357.67d09baa261346a985b029b6@kernel.org>
        <CAEf4BzYxcSCae=sF3EKNUtLDCZhkhHkd88CEBt4bffzN_AZrDw@mail.gmail.com>
        <20220218130727.51db96861c3e1c79b45daafb@kernel.org>
        <CAADnVQ+eojJ8KMwbieJrtOf7oWPqw7VDYV9EAAWpx3UoFHZFDQ@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Feb 2022 18:10:08 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Feb 17, 2022 at 8:07 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > On Thu, 17 Feb 2022 14:01:30 -0800
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> >
> > > > > Is there any chance to support this fast multi-attach for uprobe? If
> > > > > yes, we might want to reuse the same link for both (so should we name
> > > > > it more generically?
> > > >
> > > > There is no interface to do that but also there is no limitation to
> > > > expand uprobes. For the kprobes, there are some limitations for the
> > > > function entry because it needs to share the space with ftrace. So
> > > > I introduced fprobe for easier to use.
> > > >
> > > > > on the other hand BPF program type for uprobe is
> > > > > BPF_PROG_TYPE_KPROBE anyway, so keeping it as "kprobe" also would be
> > > > > consistent with what we have today).
> > > >
> > > > Hmm, I'm not sure why BPF made such design choice... (Uprobe needs
> > > > the target program.)
> > > >
> > >
> > > We've been talking about sleepable uprobe programs, so we might need
> > > to add uprobe-specific program type, probably. But historically, from
> > > BPF point of view there was no difference between kprobe and uprobe
> > > programs (in terms of how they are run and what's available to them).
> > > From BPF point of view, it was just attaching BPF program to a
> > > perf_event.
> >
> > Got it, so that will reuse the uprobe_events in ftrace. But I think
> > the uprobe requires a "path" to the attached binary, how is it
> > specified?
> >
> > > > > But yeah, the main question is whether there is something preventing
> > > > > us from supporting multi-attach uprobe as well? It would be really
> > > > > great for USDT use case.
> > > >
> > > > Ah, for the USDT, it will be useful. But since now we will have "user-event"
> > > > which is faster than uprobes, we may be better to consider to use it.
> > >
> > > Any pointers? I'm not sure what "user-event" refers to.
> >
> > Here is the user-events series, which allows user program to define
> > raw dynamic events and it can write raw event data directly from
> > user space.
> >
> > https://lore.kernel.org/all/20220118204326.2169-1-beaub@linux.microsoft.com/
> 
> Is this a way for user space to inject user bytes into kernel events?

Yes, it is.

> What is the use case?

This is like trace_marker but more ftrace/perf friendly version. The trace_marker
can only send a user string, and the kernel can not parse it. Thus, the traced
data will be shown in the trace buffer, but the event filter, event trigger,
histogram etc didn't work with trace_marker.

On the other hand, the user-events allows user-space defines new events with
various arguments with types, and the application can send the formatted raw
data to the kernel. Thus the kernel can apply event filter, event trigger and
histograms on those events as same as other kernel defined events.

This will be helpful for users to push their own data as events of ftrace
and perf (and eBPF I think) so that they can use those tracing tools to analyze
both of their events and kernel events. :-)

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
