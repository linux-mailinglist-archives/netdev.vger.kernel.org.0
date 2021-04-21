Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C8136680C
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 11:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238267AbhDUJdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 05:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237041AbhDUJdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 05:33:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64077C06174A;
        Wed, 21 Apr 2021 02:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YDpKhq3lEyHoaGRnqdn0n1KeXiDGOFgpAVazWEK6jjM=; b=hUTRioDO9yMCVjGjRtZdJIimKD
        amLrXljQUyiXujO/gW2E/5KfG3hGTS3/F4kpLS++BJSjrSaTN98spYobmufzP5bekJHiGjKwN9wqa
        P7Fwejqp6uAdUAsZYVsI+zikYWZ/+bI6vR1L1dIJCJXxMjmb8e1Fqatof//5WX0Uw365ZoCSPNpSj
        ha5Zl1BJwFTKzeO51GXyGmWZf9BTUbilsD+okvhfsT8MaGSdijhIZqLasYWnu0bIVq8lH/kNVKLQN
        kbIUYF4lSF/5gqsbfaya7Eyhy4yl3VNP21IzgC/PRgbYwcvcs9d19zs5Txx+IhHSMSVlal8LqhBw9
        rOF3FDFQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lZ9Ay-00GKSu-6P; Wed, 21 Apr 2021 09:29:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 15616300130;
        Wed, 21 Apr 2021 11:29:38 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C529F20190AC3; Wed, 21 Apr 2021 11:29:38 +0200 (CEST)
Date:   Wed, 21 Apr 2021 11:29:38 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     syzbot <syzbot+7692cea7450c97fa2a0a@syzkaller.appspotmail.com>
Cc:     acme@kernel.org, acme@redhat.com,
        alexander.shishkin@linux.intel.com, andrii@kernel.org,
        ast@kernel.org, bpf@vger.kernel.org, cobranza@ingcoecuador.com,
        daniel@iogearbox.net, eranian@google.com, john.fastabend@gmail.com,
        jolsa@redhat.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        mingo@kernel.org, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vincent.weaver@maine.edu, yhs@fb.com
Subject: Re: [syzbot] INFO: task hung in perf_event_free_task
Message-ID: <YH/wggx86Ph1bwPi@hirez.programming.kicks-ass.net>
References: <00000000000057102e058e722bba@google.com>
 <000000000000dfe1bc05c063d0fa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000dfe1bc05c063d0fa@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 02:10:22AM -0700, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    7af08140 Revert "gcov: clang: fix clang-11+ build"
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15416871d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c0a6882014fd3d45
> dashboard link: https://syzkaller.appspot.com/bug?extid=7692cea7450c97fa2a0a
> compiler:       Debian clang version 11.0.1-2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145c9ffed00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12de31ded00000

When I build that C file and run it, it completes. AFAICT that's not the
expected outcome given we're looking for a hung-task scenario. Hmm?
