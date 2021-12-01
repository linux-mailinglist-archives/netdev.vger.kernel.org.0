Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D7D46582B
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 22:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343848AbhLAVNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 16:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245319AbhLAVND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 16:13:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635F3C061748;
        Wed,  1 Dec 2021 13:09:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ADAC8CE20EC;
        Wed,  1 Dec 2021 21:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5625C53FCD;
        Wed,  1 Dec 2021 21:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638392978;
        bh=16Nfdd8O1UZIPT+mMKwLqE1crTPMbdMUdXr+0/0h0fU=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=O3ylG/108bQIwvBrXqecGHm8DjYoBBRtWM14LWqRYpLrmF+vvD2DyNiurWSpFb0t2
         oWe0QD5EnDi0q/Gh8pWlaPEMUTvxA+yUZQ39spr9FqPA1iV2oq0WOBVA9MMWYYws3E
         LpUTQp1jRacpFywVHrW4aaC6uE8xo8ld2jK8zlHX2B9mE7OLR5QEBxd3siKTVFUSeZ
         4OWPNRTBHEtznbuTUCy0BEQRtwtRhB7UcKo6+/rkzWCSLH2Wy9WSE1N0ImEC9BXpbQ
         42NApEttKJ+P9isVpNxjPbORbXHts6bqvZhUClJG76TXb4tSXqElF/I+XWqG1QjNHs
         26EQNz2B0toSg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 90C405C1107; Wed,  1 Dec 2021 13:09:38 -0800 (PST)
Date:   Wed, 1 Dec 2021 13:09:38 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     syzbot <syzbot+fe9d8c955bd1d0f02dc1@syzkaller.appspotmail.com>
Cc:     bigeasy@linutronix.de, jgross@suse.com, jiangshanlai@gmail.com,
        joel@joelfernandes.org, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
        mingo@kernel.org, namit@vmware.com, netdev@vger.kernel.org,
        peterz@infradead.org, rcu@vger.kernel.org, rdunlap@infradead.org,
        rostedt@goodmis.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING in trc_read_check_handler
Message-ID: <20211201210938.GL641268@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <00000000000069924b05c8cc3b84@google.com>
 <000000000000b7e3ee05d21bd19d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000b7e3ee05d21bd19d@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 12:50:07PM -0800, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 96017bf9039763a2e02dcc6adaa18592cd73a39d
> Author: Paul E. McKenney <paulmck@kernel.org>
> Date:   Wed Jul 28 17:53:41 2021 +0000
> 
>     rcu-tasks: Simplify trc_read_check_handler() atomic operations
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1281d89db00000
> start commit:   5319255b8df9 selftests/bpf: Skip verifier tests that fail ..
> git tree:       bpf-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9290a409049988d4
> dashboard link: https://syzkaller.appspot.com/bug?extid=fe9d8c955bd1d0f02dc1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14990477300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105ebd84b00000
> 
> If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: rcu-tasks: Simplify trc_read_check_handler() atomic operations

> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Give or take.  There were quite a few related bugs, so some or all of
the following commits might also have helped:

cbe0d8d91415c rcu-tasks: Wait for trc_read_check_handler() IPIs
18f08e758f34e rcu-tasks: Add trc_inspect_reader() checks for exiting critical section
46aa886c483f5 rcu-tasks: Fix IPI failure handling in trc_wait_for_one_reader

Quibbles aside, it is nice to get an automated email about having fixed
a bug as opposed to having added one.  ;-)

							Thanx, Paul
