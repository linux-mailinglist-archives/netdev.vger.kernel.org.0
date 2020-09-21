Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28055271D7A
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 10:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgIUIJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 04:09:28 -0400
Received: from mail-il1-f208.google.com ([209.85.166.208]:37319 "EHLO
        mail-il1-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgIUIIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 04:08:20 -0400
Received: by mail-il1-f208.google.com with SMTP id c66so10429075ilf.4
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 01:08:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=h9pfpRslp+3AfQsET9z3oDwqPiab+eVh57GDZWwZu0c=;
        b=PzAaleXa7kP6OHoIxvHwY2Ax8/NCAlA2bFDuVtGtdDLW35wSRVGXV+yyvW8/dhjqa5
         Q4AJEj8QRrvdU34e6+gwP8ej/RTxy7pyqPSsInOqtyU3Wf8qhF+oYmZ16vOtYQiU8L8T
         UktbS3y3/RBHmkjmeQ0/RORJ8AAw2HmbmHHd+vcyV4/13hy0PenD2wOShCPqh0wHuaOT
         CtIIvwbdqU5IFm9aWEZkc5SbZs2erT8fGmuCPwR1dA/bktOWV3YVzOustcpyegNPPvII
         z10zx0PY9kbzeazhiQOBvnCMQmzfysnWuo/afXLK90XlmwFJNDzKygTUe9iRWv5n1l8Q
         SzNg==
X-Gm-Message-State: AOAM530DnOmONxTyfzq1BkuYz/ENJu+W/kG30debw4I9Mx+xKn+or9u6
        UC/KCR/nFkLLYLpTzLbp6zOwMJBtzwOYWwDC/hW74RTbvWqr
X-Google-Smtp-Source: ABdhPJwlJt+9H47JyQD4TBNFrT86bTrvPVUWsM2zy9BDqnesUHSdvzM3SHjZlX6RjxUmTod3KHetQZTEizKPwfUdx9pZwFQIGJAY
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3b5:: with SMTP id z21mr39136123jap.33.1600675699073;
 Mon, 21 Sep 2020 01:08:19 -0700 (PDT)
Date:   Mon, 21 Sep 2020 01:08:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000071a5f305afce5a2f@google.com>
Subject: general protection fault in debug_check_no_obj_freed (3)
From:   syzbot <syzbot+06df86d7d68707715eec@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ba4f184e Linux 5.9-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16200765900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5f4c828c9e3cef97
dashboard link: https://syzkaller.appspot.com/bug?extid=06df86d7d68707715eec
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+06df86d7d68707715eec@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000ee000e: 0000 [#1] PREEMPT SMP KASAN
KASAN: probably user-memory-access in range [0x0000000007700070-0x0000000007700077]
CPU: 1 PID: 6892 Comm: syz-executor.3 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__debug_check_no_obj_freed lib/debugobjects.c:956 [inline]
RIP: 0010:debug_check_no_obj_freed+0x1d3/0x41c lib/debugobjects.c:998
Code: 39 00 0f 85 0f 02 00 00 48 89 45 08 4d 89 30 4c 89 c7 4d 89 68 08 e8 bc c9 ff ff 48 85 ed 74 2c 49 89 e8 4c 89 c0 48 c1 e8 03 <42> 80 3c 38 00 0f 84 2e ff ff ff 4c 89 c7 4c 89 44 24 38 e8 c5 31
RSP: 0018:ffffc90000da8bc0 EFLAGS: 00010003
RAX: 0000000000ee000e RBX: ffff888048f37000 RCX: ffffffff815cf7b0
RDX: 1ffffffff1adc084 RSI: 0000000000000004 RDI: ffff88800014f280
RBP: 0000000007700077 R08: 0000000007700077 R09: ffffe8ffffb63c70
R10: fffff520001b5166 R11: 0000000000000000 R12: 0000000000000003
R13: dead000000000122 R14: dead000000000100 R15: dffffc0000000000
FS:  00007f6a8cc2a700(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000401e70 CR3: 000000020c219000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 kfree+0xfb/0x2b0 mm/slab.c:3755
 skb_free_head net/core/skbuff.c:590 [inline]
 skb_release_data+0x6d9/0x910 net/core/skbuff.c:610
 skb_release_all net/core/skbuff.c:664 [inline]
 __kfree_skb net/core/skbuff.c:678 [inline]
 consume_skb net/core/skbuff.c:838 [inline]
 consume_skb+0xc2/0x160 net/core/skbuff.c:832
 tipc_loopback_rcv_pkt+0x11/0x20 net/tipc/bearer.c:745
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5286
 __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5400
 process_backlog+0x2e1/0x8e0 net/core/dev.c:6242
 napi_poll net/core/dev.c:6688 [inline]
 net_rx_action+0x50d/0xfc0 net/core/dev.c:6758
 __do_softirq+0x1f8/0xb23 kernel/softirq.c:298
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
 do_softirq kernel/softirq.c:343 [inline]
 do_softirq+0x154/0x1b0 kernel/softirq.c:330
 netif_rx_ni+0x3c5/0x650 net/core/dev.c:4835
 tipc_clone_to_loopback+0x330/0x480 net/tipc/bearer.c:738
 tipc_loopback_trace net/tipc/bearer.h:249 [inline]
 tipc_node_xmit+0xb44/0xd00 net/tipc/node.c:1653
 tipc_node_xmit_skb net/tipc/node.c:1715 [inline]
 tipc_node_distr_xmit+0x15c/0x3a0 net/tipc/node.c:1730
 tipc_sk_backlog_rcv+0x155/0x1c0 net/tipc/socket.c:2381
 sk_backlog_rcv include/net/sock.h:1011 [inline]
 __release_sock+0x134/0x3a0 net/core/sock.c:2542
 release_sock+0x54/0x1b0 net/core/sock.c:3065
 tipc_release+0xbb1/0x1a70 net/tipc/socket.c:638
 __sock_release+0xcd/0x280 net/socket.c:596
 sock_close+0x18/0x20 net/socket.c:1277
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:165 [inline]
 exit_to_user_mode_prepare+0x1e1/0x200 kernel/entry/common.c:192
 syscall_exit_to_user_mode+0x7e/0x2e0 kernel/entry/common.c:267
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5f9
Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f6a8cc29c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000021
RAX: 0000000000000004 RBX: 0000000000002a40 RCX: 000000000045d5f9
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000006
RBP: 000000000118d018 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cfec
R13: 000000000169fb6f R14: 00007f6a8cc2a9c0 R15: 000000000118cfec
Modules linked in:
---[ end trace f5472acb007e885e ]---
RIP: 0010:__debug_check_no_obj_freed lib/debugobjects.c:956 [inline]
RIP: 0010:debug_check_no_obj_freed+0x1d3/0x41c lib/debugobjects.c:998
Code: 39 00 0f 85 0f 02 00 00 48 89 45 08 4d 89 30 4c 89 c7 4d 89 68 08 e8 bc c9 ff ff 48 85 ed 74 2c 49 89 e8 4c 89 c0 48 c1 e8 03 <42> 80 3c 38 00 0f 84 2e ff ff ff 4c 89 c7 4c 89 44 24 38 e8 c5 31
RSP: 0018:ffffc90000da8bc0 EFLAGS: 00010003
RAX: 0000000000ee000e RBX: ffff888048f37000 RCX: ffffffff815cf7b0
RDX: 1ffffffff1adc084 RSI: 0000000000000004 RDI: ffff88800014f280
RBP: 0000000007700077 R08: 0000000007700077 R09: ffffe8ffffb63c70
R10: fffff520001b5166 R11: 0000000000000000 R12: 0000000000000003
R13: dead000000000122 R14: dead000000000100 R15: dffffc0000000000
FS:  00007f6a8cc2a700(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000401e70 CR3: 000000020c219000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
