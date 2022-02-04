Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB144A92E3
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 04:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356810AbiBDD7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 22:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345345AbiBDD7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 22:59:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175E6C061714;
        Thu,  3 Feb 2022 19:59:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF988B8364F;
        Fri,  4 Feb 2022 03:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE27C004E1;
        Fri,  4 Feb 2022 03:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643947187;
        bh=lCcXf1A5cM6ZpNUg4SCoX5duKcDpWk2uRMyMgVPxB+8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NJRJKDaw9Vn190aAcLwQMQRshh4hwOeOUIItjod7QdF4mtpwbNPpSEdmpMQsawVXz
         vQl2uimyvZqHJHQ1AKtxxGs3K1NXh1R4PGPwm3Cq5VPDC96GSstDT9cYbtf6ujivtE
         6ZDGBPD3Y1u8tdP51+9us+lp8APZbDFvo4OntNYEC6MJEimbw0vRcBGUGQUoRgx0Qt
         EP9skThRPo4RGT2morDxFF6zWNwpPJPdbbl+E00Ujv4+nChQIN0Tb7gnLVwRgv6eXt
         IBzoyVeUkUMEArllEuKtEp471sV/Ch5OW25xMEbj1d26JBu/X9CB7qkmQ6iyHI5doX
         WN+lJ7/Femb8A==
Date:   Fri, 4 Feb 2022 12:59:42 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Jiri Olsa <olsajiri@gmail.com>
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
Message-Id: <20220204125942.a4bda408f536c2e3248955e1@kernel.org>
In-Reply-To: <CAADnVQKjNJjZDs+ZV7vcusEkKuDq+sWhSD3M5GtvNeZMx3Fcmg@mail.gmail.com>
References: <20220202135333.190761-1-jolsa@kernel.org>
        <CAADnVQ+hTWbvNgnvJpAeM_-Ui2-G0YSM3QHB9G2+2kWEd4-Ymw@mail.gmail.com>
        <Yfq+PJljylbwJ3Bf@krava>
        <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
        <YfvvfLlM1FOTgvDm@krava>
        <20220204094619.2784e00c0b7359356458ca57@kernel.org>
        <CAADnVQJYY0Xm6M9O02E5rOkdQPX39NOOS4tM2jpwRLQvP-qDBg@mail.gmail.com>
        <20220204110704.7c6eaf43ff9c8f5fe9bf3179@kernel.org>
        <CAADnVQJfq_10H0V+u0w0rzyZ9uy7vq=T-3BMDANjEN8A3-prsQ@mail.gmail.com>
        <20220203211954.67c20cd3@gandalf.local.home>
        <CAADnVQKjNJjZDs+ZV7vcusEkKuDq+sWhSD3M5GtvNeZMx3Fcmg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

On Thu, 3 Feb 2022 18:42:22 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Feb 3, 2022 at 6:19 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Thu, 3 Feb 2022 18:12:11 -0800
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > > > No, fprobe is NOT kprobe on ftrace, kprobe on ftrace is already implemented
> > > > transparently.
> > >
> > > Not true.
> > > fprobe is nothing but _explicit_ kprobe on ftrace.
> > > There was an implicit optimization for kprobe when ftrace
> > > could be used.
> > > All this new interface is doing is making it explicit.
> > > So a new name is not warranted here.
> > >
> > > > from that viewpoint, fprobe and kprobe interface are similar but different.
> > >
> > > What is the difference?
> > > I don't see it.
> >
> > IIUC, a kprobe on a function (or ftrace, aka fprobe) gives some extra
> > abilities that a normal kprobe does not. Namely, "what is the function
> > parameters?"
> >
> > You can only reliably get the parameters at function entry. Hence, by
> > having a probe that is unique to functions as supposed to the middle of a
> > function, makes sense to me.
> >
> > That is, the API can change. "Give me parameter X". That along with some
> > BTF reading, could figure out how to get parameter X, and record that.
> 
> This is more or less a description of kprobe on ftrace :)
> The bpf+kprobe users were relying on that for a long time.
> See PT_REGS_PARM1() macros in bpf_tracing.h
> They're meaningful only with kprobe on ftrace.
> So, no, fprobe is not inventing anything new here.

Hmm, you may be misleading why PT_REGS_PARAM1() macro works. You can use
it even if CONFIG_FUNCITON_TRACER=n if your kernel is built with
CONFIG_KPROBES=y. It is valid unless you put a probe out of function
entry.

> No one is using kprobe in the middle of the function.
> It's too difficult to make anything useful out of it,
> so no one bothers.
> When people say "kprobe" 99 out of 100 they mean
> kprobe on ftrace/fentry.

I see. But the kprobe is kprobe. It is not designed to support multiple
probe points. If I'm forced to say, I can rename the struct fprobe to
struct multi_kprobe, but that doesn't change the essence. You may need
to use both of kprobes and so-called multi_kprobe properly. (Someone
need to do that.)

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
