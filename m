Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4643B1791C9
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 14:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbgCDNyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 08:54:06 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:54070 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgCDNyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 08:54:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=x7QxWeQIS4QmKxDASEYVZavWooJQqeQFhHog8X1BkfA=; b=oG5B0bbZM/UCZziL+BKY3IdPW/
        BjJi6lZfeHj8rJ58DlWVG1XXOWQUKB+Qj1OB5wDu1gEVe+ebjwPo0Idq/IKgs+5KWUn/ldoEKAxt9
        v0gH6m40CEe6lV42BBXk1iswmJHFzjz6u3dz8WJeVniKKAw4EZe4/dK5G8ojNgQcf5bFV7HPTocMz
        FRHhWy3lLlOb4yiDPjwEdlUOmcfervjPiwKOo/hNT1/kJeAIOraz7R90MEtexL0+nrwDPIsroABBw
        a8+6MIDkfZ3pw9he6gXBhkSvxzO/X3d6MjWQdVMLhALgQIs7r6ernzxbx8a/z44s7fjXse1gy8YF+
        meEZ4UQQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9UTC-0000HA-SQ; Wed, 04 Mar 2020 13:53:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 767C630066E;
        Wed,  4 Mar 2020 14:51:53 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DF7D423D4FA1C; Wed,  4 Mar 2020 14:53:51 +0100 (CET)
Date:   Wed, 4 Mar 2020 14:53:51 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     syzbot <syzbot+3daecb3e8271380aeb51@syzkaller.appspotmail.com>
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, jolsa@redhat.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: WARNING: locking bug in __perf_event_task_sched_in
Message-ID: <20200304135351.GN2596@hirez.programming.kicks-ass.net>
References: <0000000000005c967305a006d54d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000005c967305a006d54d@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 04:48:13AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    f8788d86 Linux 5.6-rc3
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13bcd8f9e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5d2e033af114153f
> dashboard link: https://syzkaller.appspot.com/bug?extid=3daecb3e8271380aeb51
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+3daecb3e8271380aeb51@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> DEBUG_LOCKS_WARN_ON(1)
> WARNING: CPU: 0 PID: 22488 at kernel/locking/lockdep.c:167 hlock_class kernel/locking/lockdep.c:167 [inline]
> WARNING: CPU: 0 PID: 22488 at kernel/locking/lockdep.c:167 __lock_acquire+0x18b8/0x1bc0 kernel/locking/lockdep.c:3950

Something went sideways bad, could be you've overflowed lockdep_depth.
For some reason the check:

	if (unlikely(curr->lockdep_depth >= MAX_LOCK_DEPTH))

is rather late.. Dunno, most times I've hit lockdep errors like this,
something else was screwy and we're just the ones to trip over it.
