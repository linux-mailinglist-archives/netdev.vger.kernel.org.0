Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09980169FF9
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgBXI2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:28:47 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:51777 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbgBXI2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 03:28:15 -0500
Received: by mail-il1-f198.google.com with SMTP id c12so16926488ilr.18
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 00:28:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=W9h08KTSjSCdy4kLKcKAldx/qM48NLEiDmE9jIQx3TQ=;
        b=jwzqz+xObN7hcViaLi2mopdbh6m72doBCt2PG4u2OZJY4U06cIlFV9nVnIsGvrSxOs
         jQsCBjVSwRZrRQi/AwQ4EJONL6Rq3E30qSn46o+P5mPvalJFQTPyaXhmyU7rii7veyXg
         90by2BUcpPWwQLtBX2K25EoBaDTQGuOtFEccTocM4i9o9F4Y1Eks7g7o+u/Gflici3Gg
         fpTcTgdoiO0tuWA+6nEQjIbFmChHb21gx1Xlb9D0997fBNg4scrgqEvacmQOmxzJMloM
         R6IvB3mzoQGWjR3rnDxn8LRa8GGgyWml3Iz9Qtz8RDAR7wvbSKYGYs/ixWietG2ZZbrK
         7Ccw==
X-Gm-Message-State: APjAAAUWM73oW8kEyvrrUDTyn1YK/D55CHcwhunoXShm62g2wghxXKAb
        DgO9nL+KIMWGSzRlSqWMh8tdoIIjfjUGb1bJYDMGu0tfJMTH
X-Google-Smtp-Source: APXvYqx1krtC9a0XOk9/Sr6rX0i4xU5AKD6T/W5yYOfuYSjBW0REBDhxBqlsBR3+vBeHdhRO59PmNGVwgEeiqnW3xJFbNyHyLykv
MIME-Version: 1.0
X-Received: by 2002:a02:b38f:: with SMTP id p15mr50212592jan.56.1582532894740;
 Mon, 24 Feb 2020 00:28:14 -0800 (PST)
Date:   Mon, 24 Feb 2020 00:28:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000955df059f4e276f@google.com>
Subject: KMSAN: uninit-value in number (2)
From:   syzbot <syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        mkl@pengutronix.de, netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    8bbbc5cf kmsan: don't compile memmove
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1661da7ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cd0e9a6b0e555cc3
dashboard link: https://syzkaller.appspot.com/bug?extid=9bcb0c9409066696d3aa
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111141a1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ad5245e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in number+0x9f8/0x2000 lib/vsprintf.c:459
CPU: 1 PID: 11897 Comm: syz-executor136 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 number+0x9f8/0x2000 lib/vsprintf.c:459
 vsnprintf+0x1d85/0x31b0 lib/vsprintf.c:2640
 vscnprintf+0xc2/0x180 lib/vsprintf.c:2677
 vprintk_store+0xef/0x11d0 kernel/printk/printk.c:1917
 vprintk_emit+0x2c0/0x860 kernel/printk/printk.c:1984
 vprintk_default+0x90/0xa0 kernel/printk/printk.c:2029
 vprintk_func+0x636/0x820 kernel/printk/printk_safe.c:386
 printk+0x18b/0x1d3 kernel/printk/printk.c:2062
 canfd_rcv+0x370/0x3a0 net/can/af_can.c:697
 __netif_receive_skb_one_core net/core/dev.c:5198 [inline]
 __netif_receive_skb net/core/dev.c:5312 [inline]
 netif_receive_skb_internal net/core/dev.c:5402 [inline]
 netif_receive_skb+0xe77/0xf20 net/core/dev.c:5461
 tun_rx_batched include/linux/skbuff.h:4321 [inline]
 tun_get_user+0x6aef/0x6f60 drivers/net/tun.c:1997
 tun_chr_write_iter+0x1f2/0x360 drivers/net/tun.c:2026
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:483 [inline]
 __vfs_write+0xa5a/0xca0 fs/read_write.c:496
 vfs_write+0x44a/0x8f0 fs/read_write.c:558
 ksys_write+0x267/0x450 fs/read_write.c:611
 __do_sys_write fs/read_write.c:623 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:620
 __x64_sys_write+0x4a/0x70 fs/read_write.c:620
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440239
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd3d6d1f28 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000003172 RCX: 0000000000440239
RDX: 0000000000000004 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 656c6c616b7a7973 R08: 0000000000401ac0 R09: 0000000000401ac0
R10: 0000000000401ac0 R11: 0000000000000246 R12: 0000000000401ac0
R13: 0000000000401b50 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:82
 slab_alloc_node mm/slub.c:2793 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4401
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1051 [inline]
 alloc_skb_with_frags+0x18c/0xa70 net/core/skbuff.c:5766
 sock_alloc_send_pskb+0xada/0xc60 net/core/sock.c:2242
 tun_alloc_skb drivers/net/tun.c:1529 [inline]
 tun_get_user+0x10ae/0x6f60 drivers/net/tun.c:1843
 tun_chr_write_iter+0x1f2/0x360 drivers/net/tun.c:2026
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:483 [inline]
 __vfs_write+0xa5a/0xca0 fs/read_write.c:496
 vfs_write+0x44a/0x8f0 fs/read_write.c:558
 ksys_write+0x267/0x450 fs/read_write.c:611
 __do_sys_write fs/read_write.c:623 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:620
 __x64_sys_write+0x4a/0x70 fs/read_write.c:620
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
