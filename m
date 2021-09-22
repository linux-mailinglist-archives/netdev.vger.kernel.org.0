Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A628A4153AB
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 00:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238458AbhIVW6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 18:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238293AbhIVW6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 18:58:12 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AA6C061574;
        Wed, 22 Sep 2021 15:56:41 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632351400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xXPSq+aEA0memaGjoDkKnyon7rNc+TqtiIdR44G/y5E=;
        b=eGKyZywTXSTLv7yDSJNHd+ITjQyB11b9D9c7FQexGB1sGFe7UJCFJb+aIu5m/qYMGVaUBl
        2L9xMhWsB8qkiNX5eqQI5DoDkvRfSBXCunOlf4W9hikaANuQJmz5S6qmSSBgYq72bRiHgT
        yQUzOrZ/aMyqnd/TmOsI6G38B6q4LXYSuNavg6rcHkgYhtmSs2VASGH1W7HLTOzFT38tjw
        Y0HqdiSidr4K2VZZxX0ItA5TgpAXwZZgUJRs95KKxdJTq6QBsvbN9lcsbj3Y2pmdrq7NGE
        Ae6wy+Sm2teOEEOA+tcVGIfvkmUg43uX+ud3CVqKBNjeN3gxSiDpbd6K2yhrww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632351400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xXPSq+aEA0memaGjoDkKnyon7rNc+TqtiIdR44G/y5E=;
        b=rcfiayeW9SZ7jMCFHjqkATj4NnHhze6gH9lzeRTyCZ1/Psxjfx3PWI7bbtk70g1/UQL1GE
        cjftc+ro+HTz1UAg==
To:     syzbot <syzbot+a10a3d280be23be45d04@syzkaller.appspotmail.com>,
        axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Cc:     "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [syzbot] WARNING: ODEBUG bug in blk_mq_hw_sysfs_release
In-Reply-To: <000000000000bd3a8005cc78ce14@google.com>
References: <000000000000bd3a8005cc78ce14@google.com>
Date:   Thu, 23 Sep 2021 00:56:39 +0200
Message-ID: <87mto4gqxk.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20 2021 at 20:15, syzbot wrote:

Cc+: paulmck

> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    85c698863c15 net/ipv4/tcp_minisocks.c: remove superfluous ..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=13d9d3e7300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6d93fe4341f98704
> dashboard link: https://syzkaller.appspot.com/bug?extid=a10a3d280be23be45d04
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11bd98f7300000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a10a3d280be23be45d04@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
> WARNING: CPU: 0 PID: 3816 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
> Modules linked in:
> CPU: 0 PID: 3816 Comm: syz-executor.0 Not tainted 5.15.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
> Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd c0 39 e4 89 4c 89 ee 48 c7 c7 c0 2d e4 89 e8 ef e3 14 05 <0f> 0b 83 05 35 09 91 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
> RSP: 0018:ffffc9000a6770f0 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
> RDX: ffff88805b3db900 RSI: ffffffff815dbd88 RDI: fffff520014cee10
> RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815d5b2e R11: 0000000000000000 R12: ffffffff898de180
> R13: ffffffff89e43440 R14: ffffffff8164bae0 R15: 1ffff920014cee29
> FS:  00007fee66b3a700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f362471f3a0 CR3: 00000000272af000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  debug_object_assert_init lib/debugobjects.c:895 [inline]
>  debug_object_assert_init+0x1f4/0x2e0 lib/debugobjects.c:866
>  debug_timer_assert_init kernel/time/timer.c:739 [inline]
>  debug_assert_init kernel/time/timer.c:784 [inline]
>  try_to_del_timer_sync+0x6d/0x110 kernel/time/timer.c:1229
>  del_timer_sync+0x138/0x1b0 kernel/time/timer.c:1382
>  cleanup_srcu_struct+0x14c/0x2f0 kernel/rcu/srcutree.c:379

So cleanup_srcu_struct() tries to delete a timer which was never initialized....

>  blk_mq_hw_sysfs_release+0x147/0x190 block/blk-mq-sysfs.c:40
>  kobject_cleanup lib/kobject.c:705 [inline]
>  kobject_release lib/kobject.c:736 [inline]
>  kref_put include/linux/kref.h:65 [inline]
>  kobject_put+0x1c8/0x540 lib/kobject.c:753
>  blk_mq_release+0x259/0x430 block/blk-mq.c:3094
>  blk_release_queue+0x2a7/0x4a0 block/blk-sysfs.c:823
>  kobject_cleanup lib/kobject.c:705 [inline]
>  kobject_release lib/kobject.c:736 [inline]
>  kref_put include/linux/kref.h:65 [inline]
>  kobject_put+0x1c8/0x540 lib/kobject.c:753
>  __blk_mq_alloc_disk+0x12e/0x160 block/blk-mq.c:3142
>  nbd_dev_add+0x3be/0xb90 drivers/block/nbd.c:1716
>  nbd_genl_connect+0x11f3/0x1930 drivers/block/nbd.c:1884
>  genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
>  genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
>  genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
>  genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
>  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
>  netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
>  sock_sendmsg_nosec net/socket.c:704 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:724
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
>  __sys_sendmsg+0xf3/0x1c0 net/socket.c:2492
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fee673e4739
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fee66b3a188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fee674e9038 RCX: 00007fee673e4739
> RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000007
> RBP: 00007fee6743ecc4 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fee674e9038
> R13: 00007ffe3695106f R14: 00007fee66b3a300 R15: 0000000000022000
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
