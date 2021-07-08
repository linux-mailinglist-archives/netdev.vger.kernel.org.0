Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDF63BF2EF
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 02:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhGHAqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 20:46:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhGHAqW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 20:46:22 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D039261CAC;
        Thu,  8 Jul 2021 00:43:40 +0000 (UTC)
Date:   Wed, 7 Jul 2021 20:43:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        syzbot+721aa903751db87aa244@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] tracepoint: Add tracepoint_probe_register_may_exist()
 for BPF tracing
Message-ID: <20210707204339.5f415991@rorschach.local.home>
In-Reply-To: <CAEf4BzYRxRW8qR3oENuVEMBYtcvK0bUDEkoq+e4TRT5Hh0pV_Q@mail.gmail.com>
References: <20210629095543.391ac606@oasis.local.home>
        <CAEf4BzZPb=cPf9V1Bz+USiq+b5opUTNkj4+CRjXdHcmExW3jVg@mail.gmail.com>
        <20210707184518.618ae497@rorschach.local.home>
        <CAEf4BzZ=hFZw1RNx0Pw=kMNq2xRrqHYCQQ_TY_pt86Zg9HFJfA@mail.gmail.com>
        <20210707200544.1fbfd42b@rorschach.local.home>
        <CAEf4BzYRxRW8qR3oENuVEMBYtcvK0bUDEkoq+e4TRT5Hh0pV_Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Jul 2021 17:23:54 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Wed, Jul 7, 2021 at 5:05 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Wed, 7 Jul 2021 16:49:26 -0700
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >  
> > > As for why the user might need that, it's up to the user and I don't
> > > want to speculate because it will always sound contrived without a
> > > specific production use case. But people are very creative and we try
> > > not to dictate how and what can be done if it doesn't break any
> > > fundamental assumption and safety.  
> >
> > I guess it doesn't matter, because if they try to do it, the second
> > attachment will simply fail to attach.
> >  
> 
> But not for the kprobe case.

What do you mean "not for the kprobe case"? What kprobe case?

You attach the same program twice to the same kprobe? Or do you create
two kprobes at the same location?

> 
> And it might not always be possible to know that the same BPF program
> is being attached. It could be attached by different processes that
> re-use pinned program (without being aware of each other). Or it could
> be done from some generic library that just accepts prog_fd and
> doesn't really know the exact BPF program and whether it was already
> attached.
> 
> Not sure why it doesn't matter that attachment will fail where it is
> expected to succeed. The question is rather why such restriction?

Why is it expected to succeed? It never did. And why such a
restriction? Because it complicates the code, and there's no good use
case to do so. Why complicate something for little reward?

-- Steve
