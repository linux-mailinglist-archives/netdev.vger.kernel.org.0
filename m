Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85674877DA
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 13:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347244AbiAGMzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 07:55:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38304 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiAGMzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 07:55:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEAAA60AAF;
        Fri,  7 Jan 2022 12:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91584C36AE5;
        Fri,  7 Jan 2022 12:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641560114;
        bh=JsU2qs9kcOP11xgLqJB4Eq2GZtGGt42uQoq8yv8fZVM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QEVI3shOr9SR1meDkjYxcklM/V/6xbAbo5TK3ThOsPiZV/MHKPGfXtOQZnos0jlre
         XcwqQapC6J9BH3/rq0zh9cC5YEGqtHBcdIEFa42P4mXdCpwis16rwYrFZfEl8o1uFJ
         Ip2fEa1p0dcK99KBgG4rsKwoem0H17SS17/VA6KnsVpoQnThC6YmuWWbJWb04Xsc8f
         ZsRCgCoy7akLsCEhiUuV6TR0XbY+P4HrWVLlC7p3nyIUb0AOLNV9QwWPOmEB1kMylm
         VxRMVbKN+eF/nqxBtfgLsNKlRnI/XqKzKxlasvbBEZ7Najunn2/bbk1/ndfhSPxfz1
         15dkwWmvgfdZw==
Date:   Fri, 7 Jan 2022 21:55:08 +0900
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
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC 00/13] kprobe/bpf: Add support to attach multiple kprobes
Message-Id: <20220107215508.eaac4e225add48b0705f5f14@kernel.org>
In-Reply-To: <CAADnVQ+mZxxm=96pQ4ekV3rbjV=svPOKg3TG+K0396g+iMjTbA@mail.gmail.com>
References: <20220104080943.113249-1-jolsa@kernel.org>
        <20220106002435.d73e4010c93462fbee9ef074@kernel.org>
        <YdaoTuWjEeT33Zzm@krava>
        <20220106225943.87701fcc674202dc3e172289@kernel.org>
        <CAADnVQLjjcsckQVqaSB8ODB4FKdVUt-PB9xyJ3FAa2GWGLbHgA@mail.gmail.com>
        <20220107085203.14f9c06e0537ea6b00779842@kernel.org>
        <CAADnVQ+mZxxm=96pQ4ekV3rbjV=svPOKg3TG+K0396g+iMjTbA@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jan 2022 16:20:05 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Jan 6, 2022 at 3:52 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > On Thu, 6 Jan 2022 09:40:17 -0800
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > > On Thu, Jan 6, 2022 at 5:59 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > > >
> > > > That seems to bind your mind. The program type is just a programing
> > > > 'model' of the bpf. You can choose the best implementation to provide
> > > > equal functionality. 'kprobe' in bpf is just a name that you call some
> > > > instrumentations which can probe kernel code.
> > >
> > > No. We're not going to call it "fprobe" or any other name.
> > > From bpf user's pov it's going to be "multi attach kprobe",
> > > because this is how everyone got to know kprobes.
> > > The 99% usage is at the beginning of the funcs.
> > > When users say "kprobe" they don't care how kernel attaches it.
> > > The func entry limitation for "multi attach kprobe" is a no-brainer.
> >
> > Agreed. I think I might mislead you. From the bpf user pov, it always be
> > shown as 'multi attached kprobes (but only for the function entry)'
> > the 'fprobe' is kernel internal API name.
> >
> > > And we need both "multi attach kprobe" and "multi attach kretprobe"
> > > at the same time. It's no go to implement one first and the other
> > > some time later.
> >
> > You can provide the interface to user space, but the kernel implementation
> > is optimized step by step. We can start it with using real multiple
> > kretprobes, and then, switch to 'fprobe' after integrating fgraph
> > callback. :)
> 
> Sounds good to me.
> My point was that users often want to say:
> "profile speed of all foo* functions".
> To perform such a command a tracer would need to
> attach kprobes and kretprobes to all such functions.

Yeah, I know. That is more than 10 years issue since
systemtap. :)

> The speed of attach/detach has to be fast.

Yes, that's why I provided register/unregister_kprobes()
but it sounds not enough (and maybe not optimized enough
because all handlers are same)

> Currently tracers artificially limit the regex just because
> attach/detach is so slow that the user will likely Ctrl-C
> instead of waiting for many seconds.

Ah, OK.
Anyway I also would like to fix that issue. If user wants
only function entry/exit, it should be done by ftrace. But
since the syntax (and user's mind model) it should be done via
'kprobe', so transparently converting such request to ftrace
is needed.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
