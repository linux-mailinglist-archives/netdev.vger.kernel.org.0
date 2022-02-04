Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0268A4A92AB
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 04:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356763AbiBDDRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 22:17:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39660 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiBDDRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 22:17:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02143B83627;
        Fri,  4 Feb 2022 03:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41945C340E8;
        Fri,  4 Feb 2022 03:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643944634;
        bh=NqM2WtdU+wC+xBqVomWEgZWGFCr4mBJrQWblpb21Ie4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lBPFDNMTU1voo9aRlMjcnPgb3ACjF6Lo6bhbs4MsY7s53FA2HqrXPF0X0NLgje8+t
         +SYJEfXHzjpWHvzUpe+QP5X2hnOJMa+TNX9MTTlAKN+kTFwhcKIkee/9Q4ZwRpOERX
         Q0BubqjGqcx1zjiskLjs2Nshl6NVzwjiTvMFejYcG2SKrrLLZJqLY40+BuvHrC+nh5
         uigCaqspALLT+I7OEreZSg3yKe9F9OdbkNbTQaWzb/wXzM6GBG9DO96HznoB/BWllX
         dZFTtaiGrf0vWv00/19c/lKaRtPhml1VCHZVbtfgEuHDbFVNpVn1wOhvXCfjh/zZg+
         8ffbW/ghaLEkg==
Date:   Fri, 4 Feb 2022 12:17:10 +0900
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
Message-Id: <20220204121710.bf29138c4d581bcbcce639fc@kernel.org>
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
> 
> No one is using kprobe in the middle of the function.
> It's too difficult to make anything useful out of it,
> so no one bothers.

Perf-probe makes it very easy, as easy as gdb does. :-)

Thank you,

> When people say "kprobe" 99 out of 100 they mean
> kprobe on ftrace/fentry.


-- 
Masami Hiramatsu <mhiramat@kernel.org>
