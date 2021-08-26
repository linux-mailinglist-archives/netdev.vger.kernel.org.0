Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539CF3F8FE9
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 23:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243527AbhHZUwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 16:52:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34506 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbhHZUwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 16:52:36 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1630011107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=weqSKBDICcsYc3zvuUXTCsucNGbY5lYHThcH84k67EU=;
        b=MZuIiaosjhBeWU9bjlAgQxWkHixtuZAjMM6xVonwnp727kheIAqJM4NCx6SNv3vhVQuz1Q
        FnoYFveCAugJ6k1l+LC/wP4mESr+2BG+EuhxN+2DFNlOxbGuD0+asP+PG8elGwyTXHtzdT
        TSHCmjYafZDgmjiXK17ycKw/O+ty9jQBhX83u9sN+b0yDHUjoLpwUdFT/PLRoHpMXuvpn6
        q5Nyfs1VSv4JWyyrww72TFw8I3TOPXtTsIJRzhW0xdDi1zervOHLEzsDec9w6yUHzWKMxV
        sY2UErbD+nN61ol20VY+SMlmUvP9ZB43fUjCMgYKu74kNTinXy5fJ7wArD2c6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1630011107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=weqSKBDICcsYc3zvuUXTCsucNGbY5lYHThcH84k67EU=;
        b=bN3CorDdCaaddkUS7ZQsFE3/F65XaF8TekVvoprZ7tVlQyNV6W4YqWwtOhXYQ9d27sgrVW
        txlDV1ieAMDIikDw==
To:     syzbot <syzbot+ae14beb9462a89054786@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING in timerqueue_del (2)
In-Reply-To: <000000000000d7055905ca3101a4@google.com>
References: <000000000000d7055905ca3101a4@google.com>
Date:   Thu, 26 Aug 2021 22:51:47 +0200
Message-ID: <87h7fc2al8.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22 2021 at 19:45, syzbot wrote:
> HEAD commit:    3349d3625d62 Merge branch '40GbE' of git://git.kernel.org/..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=11282731300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a03b1e3ef878f6c1
> dashboard link: https://syzkaller.appspot.com/bug?extid=ae14beb9462a89054786
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ae14beb9462a89054786@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 3780 at lib/timerqueue.c:55 timerqueue_del+0xf2/0x140 lib/timerqueue.c:55
> Modules linked in:
> CPU: 1 PID: 3780 Comm: syz-executor.5 Not tainted 5.14.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:timerqueue_del+0xf2/0x140 lib/timerqueue.c:55
> Code: 48 89 df e8 c0 7c ff ff 4c 89 e1 48 ba 00 00 00 00 00 fc ff df 48 c1 e9 03 80 3c 11 00 75 40 48 89 45 08 eb 82 e8 0e b8 82 fd <0f> 0b e9 4c ff ff ff 48 89 df e8 1f 51 c9 fd eb 93 4c 89 e7 e8 95
> RSP: 0000:ffffc9000101f370 EFLAGS: 00010046
> RAX: 0000000000040000 RBX: ffffe8ffffd3fce0 RCX: ffffc900145f4000
> RDX: 0000000000040000 RSI: ffffffff83f2f1a2 RDI: 0000000000000003
> RBP: ffff8880b9d42490 R08: ffffe8ffffd3fce0 R09: 0000000000000001
> R10: ffffffff83f2f0ec R11: 0000000000000000 R12: ffffe8ffffd3fce0
> R13: 0000000000000001 R14: ffff8880b9d423c0 R15: 0000000000000000
> FS:  00007f8847706700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f333ef09f80 CR3: 0000000064822000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  __remove_hrtimer+0xa1/0x2a0 kernel/time/hrtimer.c:1014
>  remove_hrtimer+0x19f/0x410 kernel/time/hrtimer.c:1054
>  hrtimer_try_to_cancel kernel/time/hrtimer.c:1186 [inline]
>  hrtimer_try_to_cancel+0x102/0x1e0 kernel/time/hrtimer.c:1168
>  hrtimer_cancel+0x13/0x40 kernel/time/hrtimer.c:1295
>  napi_disable+0xc3/0x110 net/core/dev.c:6909

This smells badly of memory corruption.

remove_hrtimer() invokes __remove_hrtimer() only when hrtimer->state has
the HRTIMER_STATE_ENQUEUED bit set which in turn means that the hrtimer
is queued in the timerqueue. But timerqueue_del() sees an empty
hrtimer->node.

I double checked the hrtimer code whether there is a blind spot where
the timer state and the node state could get out of sync, but I could
not find one.

Thanks,

        tglx
