Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A9C18273F
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 04:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387681AbgCLDEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 23:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387585AbgCLDEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 23:04:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3798120735;
        Thu, 12 Mar 2020 03:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583982241;
        bh=2OYQoNX+yRW1yvohToWg47lIGn/Iswj32WyxhjuwLpU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1V7pkUrBFaUDOix6iYouxAXv+NHpWOI7p6DYYehqegJ4XcLgcSjITfdhtmxibT0KQ
         bF5tFnt8PR+IeGIYRDRYCXSZ/83/oiI517m+Q6wy4jYR/1Eqdnpgz4bmp2BmathbUq
         A8+Hm7lt88agL9OtHCA6CYEou8VF2HS/LwlHnrm8=
Date:   Wed, 11 Mar 2020 20:04:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     syzbot <syzbot+34c3a8c021ca80c808b0@syzkaller.appspotmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        syzkaller-bugs@googlegroups.com, Al Viro <viro@zeniv.linux.org.uk>,
        netdev@vger.kernel.org
Subject: Re: general protection fault in list_lru_del
Message-Id: <20200311200400.a383230a33722d4c3a6886dd@linux-foundation.org>
In-Reply-To: <000000000000e8001905a07be9de@google.com>
References: <000000000000e8001905a07be9de@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Mar 2020 01:29:09 -0700 syzbot <syzbot+34c3a8c021ca80c808b0@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following crash on:

Might be vfs, more likely networking, might be something else.  Cc's
added.


> HEAD commit:    63623fd4 Merge tag 'for-linus' of git://git.kernel.org/pub..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1492da55e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9833e26bab355358
> dashboard link: https://syzkaller.appspot.com/bug?extid=34c3a8c021ca80c808b0
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+34c3a8c021ca80c808b0@syzkaller.appspotmail.com
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 PID: 11205 Comm: kworker/u4:4 Not tainted 5.6.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: krdsd rds_tcp_accept_worker
> RIP: 0010:__list_del_entry_valid+0x85/0xf5 lib/list_debug.c:51
> Code: 0f 84 e1 00 00 00 48 b8 22 01 00 00 00 00 ad de 49 39 c4 0f 84 e2 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 75 53 49 8b 14 24 4c 39 f2 0f 85 99 00 00 00 49 8d 7d
> RSP: 0018:ffffc90001b27af0 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: ffff888020040c60 RCX: ffffffff81a1dda6
> RDX: 0000000000000000 RSI: ffffffff81a1dba1 RDI: ffff888020040c68
> RBP: ffffc90001b27b08 R08: ffff88809f18e280 R09: fffff52000364f51
> R10: fffff52000364f50 R11: 0000000000000003 R12: 0000000000000000
> R13: 0000000000000000 R14: ffff888020040c60 R15: ffff888020040c68
> FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f78a44de000 CR3: 000000008c993000 CR4: 00000000001426e0
> DR0: 0000000000000000 DR1: 0000000000006920 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  __list_del_entry include/linux/list.h:132 [inline]
>  list_del_init include/linux/list.h:204 [inline]
>  list_lru_del+0x11d/0x620 mm/list_lru.c:158
>  inode_lru_list_del fs/inode.c:450 [inline]
>  iput_final fs/inode.c:1568 [inline]
>  iput+0x52c/0x900 fs/inode.c:1597
>  __sock_release+0x20e/0x280 net/socket.c:617
>  sock_release+0x18/0x20 net/socket.c:625
>  rds_tcp_accept_one+0x5a9/0xc00 net/rds/tcp_listen.c:251
>  rds_tcp_accept_worker+0x56/0x80 net/rds/tcp.c:525
>  process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
>  worker_thread+0x98/0xe40 kernel/workqueue.c:2410
>  kthread+0x361/0x430 kernel/kthread.c:255
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> Modules linked in:
> ---[ end trace 424f0561ef9bfe17 ]---
> RIP: 0010:__list_del_entry_valid+0x85/0xf5 lib/list_debug.c:51
> Code: 0f 84 e1 00 00 00 48 b8 22 01 00 00 00 00 ad de 49 39 c4 0f 84 e2 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 75 53 49 8b 14 24 4c 39 f2 0f 85 99 00 00 00 49 8d 7d
> RSP: 0018:ffffc90001b27af0 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: ffff888020040c60 RCX: ffffffff81a1dda6
> RDX: 0000000000000000 RSI: ffffffff81a1dba1 RDI: ffff888020040c68
> RBP: ffffc90001b27b08 R08: ffff88809f18e280 R09: fffff52000364f51
> R10: fffff52000364f50 R11: 0000000000000003 R12: 0000000000000000
> R13: 0000000000000000 R14: ffff888020040c60 R15: ffff888020040c68
> FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f78a44de000 CR3: 000000008c993000 CR4: 00000000001426e0
> DR0: 0000000000000000 DR1: 0000000000006920 DR2: 0000000000000000
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
