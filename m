Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 471AF19FB54
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 19:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbgDFRVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 13:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728634AbgDFRVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 13:21:55 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57D41249ED;
        Mon,  6 Apr 2020 17:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586193715;
        bh=7XxtwAxLTHDhADD534ziekkcah86Bk+g2voCfpWi3Ps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cGccNQvDJBIaDD04k8fJND630HZeD/YcLmbuZIOYWl4GtluGmyZlzBI4Bvm9hK7vU
         fTrdI4yNLtrkh8Is4iM8cB+ER51L2uN4FDpWeDzh5LYDEt9JMIysbF1JvhL66uXDfc
         A7V89HPCKZwoDAwJ8ID7tqkdG8/uIoY58bWciRwc=
Date:   Mon, 6 Apr 2020 20:21:51 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     syzbot <syzbot+9627a92b1f9262d5d30c@syzkaller.appspotmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: WARNING in ib_umad_kill_port
Message-ID: <20200406172151.GJ80989@unreal>
References: <00000000000075245205a2997f68@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000075245205a2997f68@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ RDMA

On Sun, Apr 05, 2020 at 11:37:15PM -0700, syzbot wrote:
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    304e0242 net_sched: add a temporary refcnt for struct tcin..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=119dd16de00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8c1e98458335a7d1
> dashboard link: https://syzkaller.appspot.com/bug?extid=9627a92b1f9262d5d30c
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+9627a92b1f9262d5d30c@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> sysfs group 'power' not found for kobject 'umad1'
> WARNING: CPU: 1 PID: 31308 at fs/sysfs/group.c:279 sysfs_remove_group fs/sysfs/group.c:279 [inline]
> WARNING: CPU: 1 PID: 31308 at fs/sysfs/group.c:279 sysfs_remove_group+0x155/0x1b0 fs/sysfs/group.c:270
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 1 PID: 31308 Comm: kworker/u4:10 Not tainted 5.6.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events_unbound ib_unregister_work
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>  panic+0x2e3/0x75c kernel/panic.c:221
>  __warn.cold+0x2f/0x35 kernel/panic.c:582
>  report_bug+0x27b/0x2f0 lib/bug.c:195
>  fixup_bug arch/x86/kernel/traps.c:175 [inline]
>  fixup_bug arch/x86/kernel/traps.c:170 [inline]
>  do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
>  do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
>  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
> RIP: 0010:sysfs_remove_group fs/sysfs/group.c:279 [inline]
> RIP: 0010:sysfs_remove_group+0x155/0x1b0 fs/sysfs/group.c:270
> Code: 48 89 d9 49 8b 14 24 48 b8 00 00 00 00 00 fc ff df 48 c1 e9 03 80 3c 01 00 75 41 48 8b 33 48 c7 c7 60 c3 39 88 e8 93 c3 5f ff <0f> 0b eb 95 e8 22 62 cb ff e9 d2 fe ff ff 48 89 df e8 15 62 cb ff
> RSP: 0018:ffffc90001d97a60 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffffffff88915620 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff815ca861 RDI: fffff520003b2f3e
> RBP: 0000000000000000 R08: ffff8880a78fc2c0 R09: ffffed1015ce66a1
> R10: ffffed1015ce66a0 R11: ffff8880ae733507 R12: ffff88808e5ba070
> R13: ffffffff88915bc0 R14: ffff88808e5ba008 R15: dffffc0000000000
>  dpm_sysfs_remove+0x97/0xb0 drivers/base/power/sysfs.c:794
>  device_del+0x18b/0xd30 drivers/base/core.c:2687
>  cdev_device_del+0x15/0x80 fs/char_dev.c:570
>  ib_umad_kill_port+0x45/0x250 drivers/infiniband/core/user_mad.c:1327
>  ib_umad_remove_one+0x18a/0x220 drivers/infiniband/core/user_mad.c:1409
>  remove_client_context+0xbe/0x110 drivers/infiniband/core/device.c:724
>  disable_device+0x13b/0x230 drivers/infiniband/core/device.c:1270
>  __ib_unregister_device+0x91/0x180 drivers/infiniband/core/device.c:1437
>  ib_unregister_work+0x15/0x30 drivers/infiniband/core/device.c:1547
>  process_one_work+0x965/0x16a0 kernel/workqueue.c:2266
>  worker_thread+0x96/0xe20 kernel/workqueue.c:2412
>  kthread+0x388/0x470 kernel/kthread.c:268
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
