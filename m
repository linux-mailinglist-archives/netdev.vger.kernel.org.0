Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084404153DF
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 01:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238448AbhIVX2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 19:28:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231259AbhIVX2d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 19:28:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FDEB6103C;
        Wed, 22 Sep 2021 23:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632353222;
        bh=B9wUq++BfpPdROLkDQ1ay+9OI8ABDBjLRzCN62l1Wa4=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=EFftjTbTT2QhB+RPyDX19kkr1eiNw15aoE2mHCvDroxRiaG+B03YAitAC5ggnqek+
         7JivKA16Q52AlmRdQ4vs7AsDG9ZGWr/NeO6l6I2gByNTqgeSWXk7rkIZEKLgaHRzar
         3Dr15PqqX22yajEXJ2G4dW6xZcRZ3HHKVA7H0iC1vwYVFQaCwoyMXywx3KTy2Sxd/Y
         a8AYv49zG9mnmp2lRmBNDVxA0Hmv9GaQ/G6YOBkpEWuD2By6fKZyfZhenx1i79Xzxc
         eZmM0JOb1c5Tnuc2qEc0spLs71+Jl3emWB2LC1ZdjSky1bhT1cVAk+SLE0RP8RX7r+
         RJAQopNTghzfA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 2D52C5C1613; Wed, 22 Sep 2021 16:27:02 -0700 (PDT)
Date:   Wed, 22 Sep 2021 16:27:02 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     syzbot <syzbot+a10a3d280be23be45d04@syzkaller.appspotmail.com>,
        axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING: ODEBUG bug in blk_mq_hw_sysfs_release
Message-ID: <20210922232702.GE880162@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <000000000000bd3a8005cc78ce14@google.com>
 <87mto4gqxk.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mto4gqxk.ffs@tglx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 12:56:39AM +0200, Thomas Gleixner wrote:
> On Mon, Sep 20 2021 at 20:15, syzbot wrote:
> 
> Cc+: paulmck
> 
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    85c698863c15 net/ipv4/tcp_minisocks.c: remove superfluous ..
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13d9d3e7300000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=6d93fe4341f98704
> > dashboard link: https://syzkaller.appspot.com/bug?extid=a10a3d280be23be45d04
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11bd98f7300000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+a10a3d280be23be45d04@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
> > WARNING: CPU: 0 PID: 3816 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
> > Modules linked in:
> > CPU: 0 PID: 3816 Comm: syz-executor.0 Not tainted 5.15.0-rc1-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
> > Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd c0 39 e4 89 4c 89 ee 48 c7 c7 c0 2d e4 89 e8 ef e3 14 05 <0f> 0b 83 05 35 09 91 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
> > RSP: 0018:ffffc9000a6770f0 EFLAGS: 00010282
> > RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
> > RDX: ffff88805b3db900 RSI: ffffffff815dbd88 RDI: fffff520014cee10
> > RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> > R10: ffffffff815d5b2e R11: 0000000000000000 R12: ffffffff898de180
> > R13: ffffffff89e43440 R14: ffffffff8164bae0 R15: 1ffff920014cee29
> > FS:  00007fee66b3a700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f362471f3a0 CR3: 00000000272af000 CR4: 00000000001506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  debug_object_assert_init lib/debugobjects.c:895 [inline]
> >  debug_object_assert_init+0x1f4/0x2e0 lib/debugobjects.c:866
> >  debug_timer_assert_init kernel/time/timer.c:739 [inline]
> >  debug_assert_init kernel/time/timer.c:784 [inline]
> >  try_to_del_timer_sync+0x6d/0x110 kernel/time/timer.c:1229
> >  del_timer_sync+0x138/0x1b0 kernel/time/timer.c:1382
> >  cleanup_srcu_struct+0x14c/0x2f0 kernel/rcu/srcutree.c:379
> 
> So cleanup_srcu_struct() tries to delete a timer which was never initialized....

That does not sound like a way to keep a kernel running...

For dynamically allocated srcu_struct structures, what is supposed to
happen is that init_srcu_struct() is invoked at some point before the
first use.  Then init_srcu_struct() invokes init_srcu_struct_fields()
which invokes init_srcu_struct_nodes() which initializes that timer.
Unless the memory allocations in init_srcu_struct_fields() failed,
in which case init_srcu_struct() should have handed you back a -ENOMEM.

OK, there is a call to init_srcu_struct() in blk_mq_alloc_hctx().
It does ignore the init_srcu_struct() return value, so maybe a
WARN_ON_ONCE(init_srcu_struct(hctx->srcu)) would be good.

The ->srcu field is declared as follows:

	struct srcu_struct	srcu[];

The blk_mq_hw_ctx_size() function adjusts the size.  All of this is
controlled by a BLK_MQ_F_BLOCKING flag.  If this flag were to change,
clearly bad things could happen.  The places where it is set look to me
to be initialization time, but it might be good to have someone familiar
with this code double-check this.  Or have a separate bit that records
the state of BLK_MQ_F_BLOCKING at blk_mq_alloc_hctx() time and complain
bitterly if there was a change at blk_mq_hw_sysfs_release() time.

Other thoughts?

							Thanx, Paul

> >  blk_mq_hw_sysfs_release+0x147/0x190 block/blk-mq-sysfs.c:40
> >  kobject_cleanup lib/kobject.c:705 [inline]
> >  kobject_release lib/kobject.c:736 [inline]
> >  kref_put include/linux/kref.h:65 [inline]
> >  kobject_put+0x1c8/0x540 lib/kobject.c:753
> >  blk_mq_release+0x259/0x430 block/blk-mq.c:3094
> >  blk_release_queue+0x2a7/0x4a0 block/blk-sysfs.c:823
> >  kobject_cleanup lib/kobject.c:705 [inline]
> >  kobject_release lib/kobject.c:736 [inline]
> >  kref_put include/linux/kref.h:65 [inline]
> >  kobject_put+0x1c8/0x540 lib/kobject.c:753
> >  __blk_mq_alloc_disk+0x12e/0x160 block/blk-mq.c:3142
> >  nbd_dev_add+0x3be/0xb90 drivers/block/nbd.c:1716
> >  nbd_genl_connect+0x11f3/0x1930 drivers/block/nbd.c:1884
> >  genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
> >  genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
> >  genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
> >  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
> >  genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
> >  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
> >  netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
> >  sock_sendmsg_nosec net/socket.c:704 [inline]
> >  sock_sendmsg+0xcf/0x120 net/socket.c:724
> >  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
> >  ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
> >  __sys_sendmsg+0xf3/0x1c0 net/socket.c:2492
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > RIP: 0033:0x7fee673e4739
> > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007fee66b3a188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> > RAX: ffffffffffffffda RBX: 00007fee674e9038 RCX: 00007fee673e4739
> > RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000007
> > RBP: 00007fee6743ecc4 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 00007fee674e9038
> > R13: 00007ffe3695106f R14: 00007fee66b3a300 R15: 0000000000022000
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > syzbot can test patches for this issue, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
