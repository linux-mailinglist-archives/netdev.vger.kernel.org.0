Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9376017700D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 08:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbgCCH0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 02:26:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727616AbgCCH0D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 02:26:03 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 390ED20CC7;
        Tue,  3 Mar 2020 07:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583220361;
        bh=9j2q5/KiZmqwEZ7ngx2ZBfODKeu3cSHAUMGPbYUIY3U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KQbDJjd+h4YsiFqMmtIKQSN569JZ3Bs+7XFL00ZjIcmwjVdJNCrWdJtHJbzQsZ59Q
         onFbQ1o3mNyATREKZ1oUoWzcDRvbuBV//y8GuGieeuIZ0CrCg0NmDw4oE0+B97N1tY
         XiKF0TNYkV73XMHCybnDNWE36gE66LQsBKiMx+Xs=
Date:   Tue, 3 Mar 2020 09:25:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     syzbot <syzbot+46fe08363dbba223dec5@syzkaller.appspotmail.com>
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        syzkaller-bugs@googlegroups.com,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: general protection fault in kobject_get
Message-ID: <20200303072558.GF121803@unreal>
References: <000000000000c4b371059fd83a92@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000c4b371059fd83a92@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+RDMA

On Sun, Mar 01, 2020 at 09:12:11PM -0800, syzbot wrote:
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    3b3e808c Merge tag 'mac80211-next-for-net-next-2020-02-24'..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15e20a2de00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6ec9623400ee72
> dashboard link: https://syzkaller.appspot.com/bug?extid=46fe08363dbba223dec5
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+46fe08363dbba223dec5@syzkaller.appspotmail.com
>
> general protection fault, probably for non-canonical address 0xdffffc00000000ba: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x00000000000005d0-0x00000000000005d7]
> CPU: 0 PID: 20851 Comm: syz-executor.0 Not tainted 5.6.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:kobject_get+0x35/0x150 lib/kobject.c:640
> Code: 53 e8 3f b0 8b f9 4d 85 e4 0f 84 a2 00 00 00 e8 31 b0 8b f9 49 8d 7c 24 3c 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 eb 00 00 00
> RSP: 0018:ffffc9000946f1a0 EFLAGS: 00010203
> RAX: dffffc0000000000 RBX: ffffffff85bdbbb0 RCX: ffffc9000bf22000
> RDX: 00000000000000ba RSI: ffffffff87e9d78f RDI: 00000000000005d4
> RBP: ffffc9000946f1b8 R08: ffff8880581a6440 R09: ffff8880581a6cd0
> R10: fffffbfff154b838 R11: ffffffff8aa5c1c7 R12: 0000000000000598
> R13: 0000000000000000 R14: ffffc9000946f278 R15: ffff88805cb0c4d0
> FS:  00007faa9e8af700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30121000 CR3: 000000004515d000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  get_device+0x25/0x40 drivers/base/core.c:2574
>  __ib_get_client_nl_info+0x205/0x2e0 drivers/infiniband/core/device.c:1861
>  ib_get_client_nl_info+0x35/0x180 drivers/infiniband/core/device.c:1881
>  nldev_get_chardev+0x575/0xac0 drivers/infiniband/core/nldev.c:1621
>  rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
>  rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
>  rdma_nl_rcv+0x5d9/0x980 drivers/infiniband/core/netlink.c:259
>  netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
>  netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
>  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg+0xd7/0x130 net/socket.c:672
>  ____sys_sendmsg+0x753/0x880 net/socket.c:2343
>  ___sys_sendmsg+0x100/0x170 net/socket.c:2397
>  __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
>  __do_sys_sendmsg net/socket.c:2439 [inline]
>  __se_sys_sendmsg net/socket.c:2437 [inline]
>  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
>  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x45c479
> Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007faa9e8aec78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007faa9e8af6d4 RCX: 000000000045c479
> RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000003
> RBP: 000000000076bf20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 00000000000009a2 R14: 00000000004d56c0 R15: 000000000076bf2c
> Modules linked in:
> ---[ end trace 48adc6d1ec9b227c ]---
> RIP: 0010:kobject_get+0x35/0x150 lib/kobject.c:640
> Code: 53 e8 3f b0 8b f9 4d 85 e4 0f 84 a2 00 00 00 e8 31 b0 8b f9 49 8d 7c 24 3c 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 eb 00 00 00
> RSP: 0018:ffffc9000946f1a0 EFLAGS: 00010203
> RAX: dffffc0000000000 RBX: ffffffff85bdbbb0 RCX: ffffc9000bf22000
> RDX: 00000000000000ba RSI: ffffffff87e9d78f RDI: 00000000000005d4
> RBP: ffffc9000946f1b8 R08: ffff8880581a6440 R09: ffff8880581a6cd0
> R10: fffffbfff154b838 R11: ffffffff8aa5c1c7 R12: 0000000000000598
> R13: 0000000000000000 R14: ffffc9000946f278 R15: ffff88805cb0c4d0
> FS:  00007faa9e8af700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ff582e8e000 CR3: 000000004515d000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
