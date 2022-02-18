Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607174BB081
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 05:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiBREHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 23:07:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiBREHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 23:07:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07A66CA7A;
        Thu, 17 Feb 2022 20:07:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82DA1B82555;
        Fri, 18 Feb 2022 04:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7893EC340E9;
        Fri, 18 Feb 2022 04:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645157254;
        bh=cYuuDOJYlJ0GA8aOQN1fPD9uNOqWl6U/+6PySPtBn0o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SoYk0T1zpZbx6ZtuRLZScyIA9v0u6JZ+kMkNOJpecXA18uq+UFY6HecKmegKW/+GE
         4YH5+D2IEZVrljZMeBuwLzKhpRvWg+QcTVZeiA315E4i5ZdHDBcKT8G5hVGrwgpRlU
         FoE+YZku6KHYLbHU1hb88nbt/k5mqmSoqhOe7NAP5TTxbjSj5mmndNIyL+aXxOD5NZ
         aR/y70og5+rONPRaIZ9guGtMBUXS29YABJM4a1BTDbJVP2iFCBivl8MGaZ/s6caYEj
         wHMF41q0jPQ7CnzNOyFiFQYNKnaTEDpOsHzDqS1Y/XR4x7rp7uMYH8kiWjRhf0rO8R
         ILn6MNUyeuFyg==
Date:   Fri, 18 Feb 2022 13:07:27 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
Message-Id: <20220218130727.51db96861c3e1c79b45daafb@kernel.org>
In-Reply-To: <CAEf4BzYxcSCae=sF3EKNUtLDCZhkhHkd88CEBt4bffzN_AZrDw@mail.gmail.com>
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
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Feb 2022 14:01:30 -0800
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:


> > > Is there any chance to support this fast multi-attach for uprobe? If
> > > yes, we might want to reuse the same link for both (so should we name
> > > it more generically?
> >
> > There is no interface to do that but also there is no limitation to
> > expand uprobes. For the kprobes, there are some limitations for the
> > function entry because it needs to share the space with ftrace. So
> > I introduced fprobe for easier to use.
> >
> > > on the other hand BPF program type for uprobe is
> > > BPF_PROG_TYPE_KPROBE anyway, so keeping it as "kprobe" also would be
> > > consistent with what we have today).
> >
> > Hmm, I'm not sure why BPF made such design choice... (Uprobe needs
> > the target program.)
> >
> 
> We've been talking about sleepable uprobe programs, so we might need
> to add uprobe-specific program type, probably. But historically, from
> BPF point of view there was no difference between kprobe and uprobe
> programs (in terms of how they are run and what's available to them).
> From BPF point of view, it was just attaching BPF program to a
> perf_event.

Got it, so that will reuse the uprobe_events in ftrace. But I think
the uprobe requires a "path" to the attached binary, how is it
specified?

> > > But yeah, the main question is whether there is something preventing
> > > us from supporting multi-attach uprobe as well? It would be really
> > > great for USDT use case.
> >
> > Ah, for the USDT, it will be useful. But since now we will have "user-event"
> > which is faster than uprobes, we may be better to consider to use it.
> 
> Any pointers? I'm not sure what "user-event" refers to.

Here is the user-events series, which allows user program to define
raw dynamic events and it can write raw event data directly from
user space.

https://lore.kernel.org/all/20220118204326.2169-1-beaub@linux.microsoft.com/

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
