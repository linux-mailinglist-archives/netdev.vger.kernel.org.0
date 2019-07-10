Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C43264CF8
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 21:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfGJTr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 15:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbfGJTr4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 15:47:56 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5922E2086D;
        Wed, 10 Jul 2019 19:47:54 +0000 (UTC)
Date:   Wed, 10 Jul 2019 15:47:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Chris Mason <clm@fb.com>, brendan.d.gregg@gmail.com,
        davem@davemloft.net
Subject: Re: [PATCH V2 1/1 (was 0/1 by accident)] tools/dtrace: initial
 implementation of DTrace
Message-ID: <20190710154752.76e36e8a@gandalf.local.home>
In-Reply-To: <c7f15d1d-1696-4d95-1729-4c4e97bdc43e@iogearbox.net>
References: <201907101537.x6AFboMR015946@aserv0122.oracle.com>
        <201907101542.x6AFgOO9012232@userv0121.oracle.com>
        <20190710181227.GA9925@oracle.com>
        <c7f15d1d-1696-4d95-1729-4c4e97bdc43e@iogearbox.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Jul 2019 21:32:25 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:


> Looks like you missed Brendan Gregg's prior feedback from v1 [0]. I haven't
> seen a strong compelling argument for why this needs to reside in the kernel
> tree given we also have all the other tracing tools and many of which also
> rely on BPF such as bcc, bpftrace, ply, systemtap, sysdig, lttng to just name
> a few. Given all the other tracers manage to live outside the kernel tree just
> fine, so can dtrace as well; it's _not_ special in this regard in any way. It
> will be tons of code in long term which is better off in its separate project,
> and if we add tools/dtrace/, other projects will come as well asking for kernel
> tree inclusion 'because tools/dtrace' is now there, too. While it totally makes
> sense to extend the missing kernel bits where needed, it doesn't make sense to
> have another big tracing project similar to perf in the tree. Therefore, I'm
> not applying this patch, sorry.

I agree with this.

Note, trace-cmd is very tied to ftrace just as much as perf is to the
code in tree. There was a window in time I had a choice to add it to
tools/ as well, but after careful consideration, I decided it's best
against it. The only thing being in tree gives you is marketing.
Otherwise, it makes it too coupled. I keep having to compile perf
separately, because a lot of perf distro packages appear to think that
it requires the same kernel version.

It also makes it easier to have your own release cycles, otherwise it
forces you to be on a 2 1/2 month cycle that the kernel is on. And it
forces you to have a clear separation between kernel and user space.

That said, I'm working to put together libraries that interact with all
the current tracers (perf, trace-cmd, lttng, bpftrace, etc) and call it
the "Unified Tracing Platform". The purpose is to allow any tool to be
able to take advantage of any of the supported tracers within the
running kernel. This will be one of the topics at the Tracing MC at
Linux Plumbers in September. I hope to see all of you there ;-)

-- Steve

