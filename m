Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEC9177011
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 08:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbgCCH0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 02:26:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgCCH0l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 02:26:41 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7372D20CC7;
        Tue,  3 Mar 2020 07:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583220401;
        bh=iA9BbKHVzzhrQKJ8DL4n8BWWSjM/WZyThTCys2QuWSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kAml+JeKJiXV5M6taPCSwGAvtKZKgVJHoJFN9DoC9PJjjbIgmLcqmj3b+Z/mR088g
         D7gozeV2mEgjmyLbxYPHGhT08bKGAKEelmrMn7bpA9NR+doXJBHf6gs+STPDqExH+Y
         V86ihK+Ky6sqMEuz+ICaVXgQa4DK1St8L7IhUtRk=
Date:   Tue, 3 Mar 2020 09:26:38 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     syzbot <syzbot+e909641b84b5bc17ad8b@syzkaller.appspotmail.com>
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        syzkaller-bugs@googlegroups.com,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: WARNING in ib_free_port_attrs
Message-ID: <20200303072638.GG121803@unreal>
References: <000000000000460717059fd83734@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000460717059fd83734@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ RDMA

On Sun, Mar 01, 2020 at 09:11:12PM -0800, syzbot wrote:
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    c3e042f5 igmp: remove unused macro IGMP_Vx_UNSOLICITED_REP..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=14957a81e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3b8906eb6a7d6028
> dashboard link: https://syzkaller.appspot.com/bug?extid=e909641b84b5bc17ad8b
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+e909641b84b5bc17ad8b@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> sysfs group 'pkeys' not found for kobject '1'
> WARNING: CPU: 0 PID: 25854 at fs/sysfs/group.c:278 sysfs_remove_group fs/sysfs/group.c:278 [inline]
> WARNING: CPU: 0 PID: 25854 at fs/sysfs/group.c:278 sysfs_remove_group+0x15b/0x1b0 fs/sysfs/group.c:269
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 25854 Comm: syz-executor.0 Not tainted 5.6.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x197/0x210 lib/dump_stack.c:118
>  panic+0x2e3/0x75c kernel/panic.c:221
>  __warn.cold+0x2f/0x3e kernel/panic.c:582
>  report_bug+0x289/0x300 lib/bug.c:195
>  fixup_bug arch/x86/kernel/traps.c:174 [inline]
>  fixup_bug arch/x86/kernel/traps.c:169 [inline]
>  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
>  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
>  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
> RIP: 0010:sysfs_remove_group fs/sysfs/group.c:278 [inline]
> RIP: 0010:sysfs_remove_group+0x15b/0x1b0 fs/sysfs/group.c:269
> Code: 48 89 d9 49 8b 55 00 48 b8 00 00 00 00 00 fc ff df 48 c1 e9 03 80 3c 01 00 75 41 48 8b 33 48 c7 c7 e0 9f 59 88 e8 14 a8 5b ff <0f> 0b eb 92 e8 7c fe c9 ff e9 d0 fe ff ff 48 89 df e8 6f fe c9 ff
> RSP: 0018:ffffc900057e7aa0 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff888098a94078 RCX: 0000000000000000
> RDX: 0000000000040000 RSI: ffffffff815eae46 RDI: fffff52000afcf46
> RBP: ffffc900057e7ac8 R08: ffff888050196400 R09: ffffed1015d06659
> R10: ffffed1015d06658 R11: ffff8880ae8332c7 R12: 0000000000000000
> R13: ffff888098a94000 R14: ffffffff88e24120 R15: ffff888098a94008
>  ib_free_port_attrs+0x26c/0x510 drivers/infiniband/core/sysfs.c:1322
>  remove_one_compat_dev+0x51/0x70 drivers/infiniband/core/device.c:937
>  rdma_dev_exit_net+0x2e0/0x520 drivers/infiniband/core/device.c:1075
>  ops_exit_list.isra.0+0xb1/0x160 net/core/net_namespace.c:172
>  setup_net+0x546/0x8b0 net/core/net_namespace.c:350
>  copy_net_ns+0x29e/0x5a0 net/core/net_namespace.c:468
>  create_new_namespaces+0x403/0xb50 kernel/nsproxy.c:108
>  unshare_nsproxy_namespaces+0xc2/0x200 kernel/nsproxy.c:229
>  ksys_unshare+0x444/0x980 kernel/fork.c:2955
>  __do_sys_unshare kernel/fork.c:3023 [inline]
>  __se_sys_unshare kernel/fork.c:3021 [inline]
>  __x64_sys_unshare+0x31/0x40 kernel/fork.c:3021
>  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x45c449
> Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f5911615c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
> RAX: ffffffffffffffda RBX: 00007f59116166d4 RCX: 000000000045c449
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000040000000
> RBP: 000000000076bf20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 0000000000000c3e R14: 00000000004ce216 R15: 000000000076bf2c
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
