Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A28D4A92A1
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 04:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356744AbiBDDOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 22:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234466AbiBDDOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 22:14:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95543C061714;
        Thu,  3 Feb 2022 19:14:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E069B83651;
        Fri,  4 Feb 2022 03:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC5AC340E8;
        Fri,  4 Feb 2022 03:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643944477;
        bh=LBsBh6EdRVeQhUGEyf/yNe0ywu7J4X/vV5zcBX+reb4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DsARRkvMbVBXOrQUSLY7e0KPwUn/1InPRyngBeob84IhwHb9/H3HOBsuHHFmzVTFe
         O0MihJasTfRYjFZemEqpNXHbKx0I8tES856KH28Kxo6+d8EKKG4umrty3vKwiIwwr4
         9DpSKLLYL7ZROxxGgDGm7GU7Mq2eZX55cZkHVe+WPSrvU5WyV4O0zsDXKZYHM4moUl
         RJGxl4fL9bgF9IWA6fUA6trKzrysp0DwCy0VoEHy8k1a55LjTI2MlwI+I2tjHyfMVg
         frO4gaWD7eCNw1GtHmjJ3EnSDpL6TSx2go8LNi/dOSgsp7pKgHF8IMDUsRERCwxBuA
         +/0HYdMvXA0PA==
Date:   Fri, 4 Feb 2022 12:14:33 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
Message-Id: <20220204121433.7309b6fc49688c5428dfb789@kernel.org>
In-Reply-To: <CAADnVQJfq_10H0V+u0w0rzyZ9uy7vq=T-3BMDANjEN8A3-prsQ@mail.gmail.com>
References: <20220202135333.190761-1-jolsa@kernel.org>
        <CAADnVQ+hTWbvNgnvJpAeM_-Ui2-G0YSM3QHB9G2+2kWEd4-Ymw@mail.gmail.com>
        <Yfq+PJljylbwJ3Bf@krava>
        <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
        <YfvvfLlM1FOTgvDm@krava>
        <20220204094619.2784e00c0b7359356458ca57@kernel.org>
        <CAADnVQJYY0Xm6M9O02E5rOkdQPX39NOOS4tM2jpwRLQvP-qDBg@mail.gmail.com>
        <20220204110704.7c6eaf43ff9c8f5fe9bf3179@kernel.org>
        <CAADnVQJfq_10H0V+u0w0rzyZ9uy7vq=T-3BMDANjEN8A3-prsQ@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 18:12:11 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Feb 3, 2022 at 6:07 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > On Thu, 3 Feb 2022 17:34:54 -0800
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > > On Thu, Feb 3, 2022 at 4:46 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > > >
> > > > I thought What Alexei pointed was that don't expose the FPROBE name
> > > > to user space. If so, I agree with that. We can continue to use
> > > > KPROBE for user space. Using fprobe is just for kernel implementation.
> > >
> > > Clearly that intent is not working.
> >
> > Thanks for confirmation :-)
> >
> > > The "fprobe" name is already leaking outside of the kernel internals.
> > > The module interface is being proposed.
> >
> > Yes, but that is only for making the example module.
> > It is easy for me to enclose it inside kernel. I'm preparing KUnit
> > selftest code for next version. After integrated that, we don't need
> > that example module anymore.
> >
> > > You'd need to document it, etc.
> >
> > Yes, I've added a document of the APIs for the series.  :-)
> >
> > > I think it's only causing confusion to users.
> > > The new name serves no additional purpose other than
> > > being new and unheard of.
> > > fprobe is kprobe on ftrace. That's it.
> >
> > No, fprobe is NOT kprobe on ftrace, kprobe on ftrace is already implemented
> > transparently.
> 
> Not true.
> fprobe is nothing but _explicit_ kprobe on ftrace.
> There was an implicit optimization for kprobe when ftrace
> could be used.
> All this new interface is doing is making it explicit.
> So a new name is not warranted here.
> 
> > from that viewpoint, fprobe and kprobe interface are similar but different.
> 
> What is the difference?
> I don't see it.

From the raw-kernel programer's viewpoint, here are the differences.

kprobes is focusing on probing just a single probe point, and it can probe
everywhere including function body. With this charactoristics, user can
made a callback logic which is specialized for a specific address.

typedef int (*kprobe_pre_handler_t) (struct kprobe *, struct pt_regs *);


On the other hand, fprobe focuses on the multiple function entry and exit.
That is just a wrapper of ftrace. So callbacks will need to check the
function IP and change their behavior according to the IP.

        void (*entry_handler)(struct fprobe *fp, unsigned long entry_ip, struct pt_regs *regs);
        void (*exit_handler)(struct fprobe *fp, unsigned long entry_ip, struct pt_regs *regs);

This is why the fprobe handler gets @entry_ip for the handlers.

However, from viewpoint of the higher level users, those may look same
because both interrupts the kernel execution and callback their program
like BPF. BPF can select collect program according to the instruction_pointer
of @regs in both case.

In that case, I think it is natual that the BPF layer hides those differences
from user, by abstracting those as a generic "kprobe" which means an idea of
the general kernel instrumentation.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
