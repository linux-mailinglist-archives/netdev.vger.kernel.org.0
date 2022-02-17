Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F274BAC2F
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 23:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242200AbiBQWB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 17:01:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiBQWB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 17:01:59 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9C155488;
        Thu, 17 Feb 2022 14:01:42 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id o10so3340746ilh.0;
        Thu, 17 Feb 2022 14:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y8vBU/N90g9PQqWS7R85gzF9eCysv6xSx3mG+pafmO4=;
        b=HyVp3T7ImwWErOoPlymYPZpTjlC+6DGqco7b6HAXYSyKc3WFNMHqyAaRo73I+NNTE+
         w+5xb80Tnnl8Ty0My2AoHh7Cb/gTtgWEdor1D9bt2WvFCKorZPglRgZd6LX+/ypC7NJL
         iJJQZRvjfvQfq9HhWS6BuratncMgF70bO5vsUkBCWpOwzkl4FzT4FpOQGfA6KO05ZCaR
         qFInuXqY+E+bWM0T0uxN0SMj0/87W2f9Ud2PkwJ5ZikygPmLRXlyz6Gl4i1rge2GREZc
         EB3G4eghrJUxKF0LBVtQEKz4fV5xPlhXni5+wTK7MBXxtBAypcE4QeZoG3JOEiMFpBqg
         FXsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y8vBU/N90g9PQqWS7R85gzF9eCysv6xSx3mG+pafmO4=;
        b=Cgj9g1d0gixb3I75sz0DNsagzKNuLJazpC2/49mUIxZ0XCfESl1apXu1g3HqDE0uxX
         MQ76iJd3CxLB1BPbFmoDYWQtFLHkwRVXGsSNsXW8iFBpDPxW/ZjvPq3BxH9f6qCSFZGL
         5zFGgvXtoSt1Rcp28dYW8Aw4+K5bMKFwf1QDJB9SjSa3H8QNqj3DsOVxGAKs5VR9vDQd
         N0p0+NM70aJHY11AlX3ZnHK7PuUYj93KodAUrFKRh2/l8orEkGUfDkJBGcbEM3VjslD3
         bczB9ptVUUuBPbUsQ6Jts4TCLEfT666Jyr94jrUS9W1lUc12WCBJlcpX7Lq8lNKKj33q
         hXzQ==
X-Gm-Message-State: AOAM532+a6NpGcvHng+aEM0y7JWTkPqi1G3XJdDiNxLN4FN7lOi2k5M3
        eibTvu1F/JgIaUH0ozEmtojo2gKCKM2HBOxxRfs=
X-Google-Smtp-Source: ABdhPJybiqGzhlLjrIdceYE/mkp4NV9iHMNW3mi6KEzcAgg8GZY7DYb0MP5W3g2gMYkgCA5IkW2DD8tSrTk1Wk1jA/s=
X-Received: by 2002:a05:6e02:503:b0:2bf:a929:4dc3 with SMTP id
 d3-20020a056e02050300b002bfa9294dc3mr3307109ils.98.1645135301751; Thu, 17 Feb
 2022 14:01:41 -0800 (PST)
MIME-Version: 1.0
References: <Yfq+PJljylbwJ3Bf@krava> <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
 <YfvvfLlM1FOTgvDm@krava> <20220204094619.2784e00c0b7359356458ca57@kernel.org>
 <CAADnVQJYY0Xm6M9O02E5rOkdQPX39NOOS4tM2jpwRLQvP-qDBg@mail.gmail.com>
 <20220204110704.7c6eaf43ff9c8f5fe9bf3179@kernel.org> <CAADnVQJfq_10H0V+u0w0rzyZ9uy7vq=T-3BMDANjEN8A3-prsQ@mail.gmail.com>
 <20220203211954.67c20cd3@gandalf.local.home> <CAADnVQKjNJjZDs+ZV7vcusEkKuDq+sWhSD3M5GtvNeZMx3Fcmg@mail.gmail.com>
 <20220204125942.a4bda408f536c2e3248955e1@kernel.org> <Yguo4v7c+3A0oW/h@krava>
 <CAEf4BzYO_B51TPgUnDXUPUsK55RSczwcnhuLz9DMbfO5JCj=Cw@mail.gmail.com> <20220217230357.67d09baa261346a985b029b6@kernel.org>
In-Reply-To: <20220217230357.67d09baa261346a985b029b6@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 17 Feb 2022 14:01:30 -0800
Message-ID: <CAEf4BzYxcSCae=sF3EKNUtLDCZhkhHkd88CEBt4bffzN_AZrDw@mail.gmail.com>
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

On Thu, Feb 17, 2022 at 6:04 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> On Wed, 16 Feb 2022 10:27:19 -0800
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > On Tue, Feb 15, 2022 at 5:21 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> > >
> > > On Fri, Feb 04, 2022 at 12:59:42PM +0900, Masami Hiramatsu wrote:
> > > > Hi Alexei,
> > > >
> > > > On Thu, 3 Feb 2022 18:42:22 -0800
> > > > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > > On Thu, Feb 3, 2022 at 6:19 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > > >
> > > > > > On Thu, 3 Feb 2022 18:12:11 -0800
> > > > > > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > > > No, fprobe is NOT kprobe on ftrace, kprobe on ftrace is already implemented
> > > > > > > > transparently.
> > > > > > >
> > > > > > > Not true.
> > > > > > > fprobe is nothing but _explicit_ kprobe on ftrace.
> > > > > > > There was an implicit optimization for kprobe when ftrace
> > > > > > > could be used.
> > > > > > > All this new interface is doing is making it explicit.
> > > > > > > So a new name is not warranted here.
> > > > > > >
> > > > > > > > from that viewpoint, fprobe and kprobe interface are similar but different.
> > > > > > >
> > > > > > > What is the difference?
> > > > > > > I don't see it.
> > > > > >
> > > > > > IIUC, a kprobe on a function (or ftrace, aka fprobe) gives some extra
> > > > > > abilities that a normal kprobe does not. Namely, "what is the function
> > > > > > parameters?"
> > > > > >
> > > > > > You can only reliably get the parameters at function entry. Hence, by
> > > > > > having a probe that is unique to functions as supposed to the middle of a
> > > > > > function, makes sense to me.
> > > > > >
> > > > > > That is, the API can change. "Give me parameter X". That along with some
> > > > > > BTF reading, could figure out how to get parameter X, and record that.
> > > > >
> > > > > This is more or less a description of kprobe on ftrace :)
> > > > > The bpf+kprobe users were relying on that for a long time.
> > > > > See PT_REGS_PARM1() macros in bpf_tracing.h
> > > > > They're meaningful only with kprobe on ftrace.
> > > > > So, no, fprobe is not inventing anything new here.
> > > >
> > > > Hmm, you may be misleading why PT_REGS_PARAM1() macro works. You can use
> > > > it even if CONFIG_FUNCITON_TRACER=n if your kernel is built with
> > > > CONFIG_KPROBES=y. It is valid unless you put a probe out of function
> > > > entry.
> > > >
> > > > > No one is using kprobe in the middle of the function.
> > > > > It's too difficult to make anything useful out of it,
> > > > > so no one bothers.
> > > > > When people say "kprobe" 99 out of 100 they mean
> > > > > kprobe on ftrace/fentry.
> > > >
> > > > I see. But the kprobe is kprobe. It is not designed to support multiple
> > > > probe points. If I'm forced to say, I can rename the struct fprobe to
> > > > struct multi_kprobe, but that doesn't change the essence. You may need
> > > > to use both of kprobes and so-called multi_kprobe properly. (Someone
> > > > need to do that.)
> > >
> > > hi,
> > > tying to kick things further ;-) I was thinking about bpf side of this
> > > and we could use following interface:
> > >
> > >   enum bpf_attach_type {
> > >     ...
> > >     BPF_TRACE_KPROBE_MULTI
> > >   };
> > >
> > >   enum bpf_link_type {
> > >     ...
> > >     BPF_LINK_TYPE_KPROBE_MULTI
> > >   };
> > >
> > >   union bpf_attr {
> > >
> > >     struct {
> > >       ...
> > >       struct {
> > >         __aligned_u64   syms;
> > >         __aligned_u64   addrs;
> > >         __aligned_u64   cookies;
> > >         __u32           cnt;
> > >         __u32           flags;
> > >       } kprobe_multi;
> > >     } link_create;
> > >   }
> > >
> > > because from bpf user POV it's new link for attaching multiple kprobes
> > > and I agree new 'fprobe' type name in here brings more confusion, using
> > > kprobe_multi is straightforward
> > >
> > > thoguhts?
> >
> > I think this makes sense. We do need new type of link to store ip ->
> > cookie mapping anyways.
>
> This looks good to me too.
>
> >
> > Is there any chance to support this fast multi-attach for uprobe? If
> > yes, we might want to reuse the same link for both (so should we name
> > it more generically?
>
> There is no interface to do that but also there is no limitation to
> expand uprobes. For the kprobes, there are some limitations for the
> function entry because it needs to share the space with ftrace. So
> I introduced fprobe for easier to use.
>
> > on the other hand BPF program type for uprobe is
> > BPF_PROG_TYPE_KPROBE anyway, so keeping it as "kprobe" also would be
> > consistent with what we have today).
>
> Hmm, I'm not sure why BPF made such design choice... (Uprobe needs
> the target program.)
>

We've been talking about sleepable uprobe programs, so we might need
to add uprobe-specific program type, probably. But historically, from
BPF point of view there was no difference between kprobe and uprobe
programs (in terms of how they are run and what's available to them).
From BPF point of view, it was just attaching BPF program to a
perf_event.

>
> > But yeah, the main question is whether there is something preventing
> > us from supporting multi-attach uprobe as well? It would be really
> > great for USDT use case.
>
> Ah, for the USDT, it will be useful. But since now we will have "user-event"
> which is faster than uprobes, we may be better to consider to use it.

Any pointers? I'm not sure what "user-event" refers to.

>
> I'm not so sure how uprobes probes the target process, but maybe it has
> to manage some memory pages and task related things. If we can split
> those task-related part from struct uprobe software-breakpoint part,
> it maybe easy to support multiple probe (one task-related part + multiple
> software-breakpoint parts.)
>
> Thank you,
>
> --
> Masami Hiramatsu <mhiramat@kernel.org>
