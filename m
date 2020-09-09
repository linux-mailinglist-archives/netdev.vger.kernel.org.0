Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF91262CB0
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgIIJ6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:58:31 -0400
Received: from mail-il1-f208.google.com ([209.85.166.208]:49965 "EHLO
        mail-il1-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgIIJ6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 05:58:24 -0400
Received: by mail-il1-f208.google.com with SMTP id f132so1590061ilh.16
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 02:58:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ULPCKEjateHcthoDFeuXq/eqfB9xO+OxE96IrMm+mac=;
        b=TZj6Mtv/iga8EY5xtum6+Q3iOXPcVxNMpyhaaXnkxvM7etEX0kG0SFmy+RQoWPXkUP
         Vvk6L/qOdPIk9Ps5rxPqQk0QWpWv2JWIhzLnLhuO6h5u2dJaHxjA4jg+K0Mf2claMx7E
         /2BsqwI1UTv9z/CJCn7Cm66LGAun29YBPzpD/arIjjV8PoX4o83x4+jY6NVc1iXqnWG2
         ZyaZGNPqaUm/dLgCaw/z9GF84fxFySFieKdGTtL63wqIZzTEEYKXCtK7lwswS6FOiy/k
         fupHkWboij2RLsLfdyzauEFB9HpIJdbYsioSMY/DaTx2ovH+Km8WwehY7yWON8P3RC1i
         xFkQ==
X-Gm-Message-State: AOAM531RhFolPMDlNa7hI/HuGwtXx1M8rwGXBFX2l/epXmE8yVov6b1t
        1yLEFOZnIVXxepiarIoO4eANq16VXt9uTltUjD9s5cz2X/JL
X-Google-Smtp-Source: ABdhPJzmwllqFRd42fuXZ5xumiU80KjTlc/taqWdd3jBdm6nJuxLom/wnLLgT2bcDjyAUuhbo6ylOJGyrTGMtI9EHoJyypnZPkUR
MIME-Version: 1.0
X-Received: by 2002:a92:d28c:: with SMTP id p12mr2997493ilp.7.1599645502892;
 Wed, 09 Sep 2020 02:58:22 -0700 (PDT)
Date:   Wed, 09 Sep 2020 02:58:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f76ff805aede7daf@google.com>
Subject: general protection fault in skb_release_data (2)
From:   syzbot <syzbot+ccfa5775bc1bda21ddd1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, keescook@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pankaj.laxminarayan.bharadiya@intel.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    19162fd4 hv_netvsc: Fix hibernation for mlx5 VF driver
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=163310f1900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd46548257448703
dashboard link: https://syzkaller.appspot.com/bug?extid=ccfa5775bc1bda21ddd1
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=175305f9900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11145e31900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ccfa5775bc1bda21ddd1@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 7081 Comm: syz-executor931 Not tainted 5.9.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:compound_head include/linux/page-flags.h:182 [inline]
RIP: 0010:put_page include/linux/mm.h:1170 [inline]
RIP: 0010:__skb_frag_unref include/linux/skbuff.h:3014 [inline]
RIP: 0010:skb_release_data+0x232/0x910 net/core/skbuff.c:604
Code: 48 c1 e8 03 42 80 3c 30 00 0f 85 ea 05 00 00 48 8b 0c 24 49 63 c4 48 c1 e0 04 48 8b 6c 08 30 48 8d 7d 08 48 89 f8 48 c1 e8 03 <42> 80 3c 30 00 0f 85 ba 05 00 00 48 8b 5d 08 31 ff 49 89 dd 41 83
RSP: 0018:ffffc90000007a48 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000002 RCX: ffff88809f9d54c0
RDX: ffff8880932d4540 RSI: ffffffff8637b105 RDI: 0000000000000008
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8ab2680f
R10: 0000000000000000 R11: 1ffffffff1835523 R12: 0000000000000000
R13: ffff88809f9d54c0 R14: dffffc0000000000 R15: ffff88809f9d54f0
FS:  00007f8f17fb9700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200004c0 CR3: 00000000921c5000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 skb_release_all net/core/skbuff.c:664 [inline]
 __kfree_skb net/core/skbuff.c:678 [inline]
 kfree_skb.part.0+0xc2/0x350 net/core/skbuff.c:696
 kfree_skb+0x7d/0x100 include/linux/refcount.h:270
 validate_xmit_skb+0x9d9/0xf00 net/core/dev.c:3664
 __dev_queue_xmit+0x990/0x2d60 net/core/dev.c:4128
 mrp_queue_xmit net/802/mrp.c:351 [inline]
 mrp_join_timer+0x8a/0xc0 net/802/mrp.c:595
 call_timer_fn+0x1ac/0x760 kernel/time/timer.c:1413
 expire_timers kernel/time/timer.c:1458 [inline]
 __run_timers.part.0+0x67c/0xaa0 kernel/time/timer.c:1755
 __run_timers kernel/time/timer.c:1736 [inline]
 run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1768
 __do_softirq+0x1f7/0xa91 kernel/softirq.c:298
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x235/0x280 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:770 [inline]
RIP: 0010:console_unlock+0xb4a/0xe60 kernel/printk/printk.c:2509
Code: 89 48 c1 e8 03 42 80 3c 38 00 0f 85 18 03 00 00 48 83 3d a0 f8 58 08 00 0f 84 90 01 00 00 e8 4d 07 17 00 48 8b 7c 24 30 57 9d <0f> 1f 44 00 00 8b 5c 24 64 31 ff 89 de e8 b4 03 17 00 85 db 0f 84
RSP: 0018:ffffc90005776ed0 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000200 RCX: 0000000000000006
RDX: ffff8880932d4540 RSI: ffffffff815d43b3 RDI: 0000000000000293
RBP: 0000000000000000 R08: 0000000000000001 R09: ffffffff8c5f49e7
R10: fffffbfff18be93c R11: 0000000038303754 R12: ffffffff84c29770
R13: 000000000000003d R14: ffffffff8a3cb5d0 R15: dffffc0000000000
 vprintk_emit+0x2ff/0x740 kernel/printk/printk.c:2029
 vprintk_func+0x8f/0x1a6 kernel/printk/printk_safe.c:393
 printk+0xba/0xed kernel/printk/printk.c:2078
 __dev_set_promiscuity.cold+0x55/0x35f net/core/dev.c:8076
 __dev_change_flags+0x3af/0x660 net/core/dev.c:8294
 rtnl_configure_link+0xee/0x230 net/core/rtnetlink.c:3123
 __rtnl_newlink+0x10b6/0x1740 net/core/rtnetlink.c:3460
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446ec9
Code: e8 bc b4 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8f17fb8db8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc68 RCX: 0000000000446ec9
RDX: 0000000000000000 RSI: 0000000020000280 RDI: 0000000000000005
RBP: 00000000006dbc60 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 00000000006dbc6c
R13: 00007ffc03b1786f R14: 00007f8f17fb99c0 R15: 0000000000000064
Modules linked in:
---[ end trace e9a2262e09a956fb ]---
RIP: 0010:compound_head include/linux/page-flags.h:182 [inline]
RIP: 0010:put_page include/linux/mm.h:1170 [inline]
RIP: 0010:__skb_frag_unref include/linux/skbuff.h:3014 [inline]
RIP: 0010:skb_release_data+0x232/0x910 net/core/skbuff.c:604
Code: 48 c1 e8 03 42 80 3c 30 00 0f 85 ea 05 00 00 48 8b 0c 24 49 63 c4 48 c1 e0 04 48 8b 6c 08 30 48 8d 7d 08 48 89 f8 48 c1 e8 03 <42> 80 3c 30 00 0f 85 ba 05 00 00 48 8b 5d 08 31 ff 49 89 dd 41 83
RSP: 0018:ffffc90000007a48 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000002 RCX: ffff88809f9d54c0
RDX: ffff8880932d4540 RSI: ffffffff8637b105 RDI: 0000000000000008
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8ab2680f
R10: 0000000000000000 R11: 1ffffffff1835523 R12: 0000000000000000
R13: ffff88809f9d54c0 R14: dffffc0000000000 R15: ffff88809f9d54f0
FS:  00007f8f17fb9700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200004c0 CR3: 00000000921c5000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
