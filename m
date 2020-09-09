Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EEF262CB3
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729449AbgIIJ6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:58:32 -0400
Received: from mail-io1-f77.google.com ([209.85.166.77]:50257 "EHLO
        mail-io1-f77.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbgIIJ6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 05:58:24 -0400
Received: by mail-io1-f77.google.com with SMTP id b16so1553022iod.17
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 02:58:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=uWeEmvYITQnMvBnpcJO6GKoW9bXJbiVcnO0AlirR3JA=;
        b=Kl0UEgyQlhHd1Bin1aDeEl6ULtkfHYGbEy0VyRQ6TbfsToNQMeV3kS+fRk/Y64N2Qu
         F0CAfM5J5OYlOdG6ty8auiRFJHaIOBEeiyugXv0xa6FheOOtiH+iLcZeIK/Ypdcqutvc
         CQvIDDKlS1JGJp6rZMDFCuSj2ReHanHtuShas2kRX59UxAAb44ihh3CmERDGhof4BNIa
         XLpoNwgWk7gv7TON40Ow5QACDVET48ZUUugls9mj6V2geBzrnYK33p7hAI90pjB3iDtC
         623a9ikVeTpgaJrn0//fMy8TcsanTu6YDlGQd51CYRnfQq/QsDP9LSEFd0LPulmLoYp+
         b6vw==
X-Gm-Message-State: AOAM531heSLhDIyxu2+8NyyMr6X97jm+mgVeJGEn0AAFWpuiz2aEGkBz
        e1fUEWrsr9Me7h/gp9SLwxD1iTIKRlG+zn78MELVdKyglpip
X-Google-Smtp-Source: ABdhPJyT2fiKic6EiQG5oWSiDu3gkK4Kb46xs4s0wPwFt2pZ04gdgHanHEQRKNhp2vi9tZZ28aMQVrZI7tYObXg9Hs2UG5Dq77s1
MIME-Version: 1.0
X-Received: by 2002:a5e:9e0a:: with SMTP id i10mr2646457ioq.41.1599645503122;
 Wed, 09 Sep 2020 02:58:23 -0700 (PDT)
Date:   Wed, 09 Sep 2020 02:58:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000faf37f05aede7db6@google.com>
Subject: KMSAN: uninit-value in skb_release_data (3)
From:   syzbot <syzbot+067cfb341865e4074630@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, keescook@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pankaj.laxminarayan.bharadiya@intel.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3b3ea602 x86: add failure injection to get/put/clear_user
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=15bdcb35900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3afe005fb99591f
dashboard link: https://syzkaller.appspot.com/bug?extid=067cfb341865e4074630
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1712e7cd900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=143305f9900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+067cfb341865e4074630@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in compound_head include/linux/page-flags.h:182 [inline]
BUG: KMSAN: uninit-value in put_page include/linux/mm.h:1154 [inline]
BUG: KMSAN: uninit-value in __skb_frag_unref include/linux/skbuff.h:2999 [inline]
BUG: KMSAN: uninit-value in skb_release_data+0x4b4/0xde0 net/core/skbuff.c:604
CPU: 1 PID: 8773 Comm: syz-executor104 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 compound_head include/linux/page-flags.h:182 [inline]
 put_page include/linux/mm.h:1154 [inline]
 __skb_frag_unref include/linux/skbuff.h:2999 [inline]
 skb_release_data+0x4b4/0xde0 net/core/skbuff.c:604
 skb_release_all net/core/skbuff.c:664 [inline]
 __kfree_skb+0x9e/0x320 net/core/skbuff.c:678
 kfree_skb+0x323/0x390 net/core/skbuff.c:696
 validate_xmit_skb+0x1386/0x1aa0 net/core/dev.c:3659
 __dev_queue_xmit+0x2aa5/0x4470 net/core/dev.c:4123
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4164
 mrp_queue_xmit net/802/mrp.c:351 [inline]
 mrp_join_timer+0x1fc/0x380 net/802/mrp.c:595
 call_timer_fn+0x226/0x550 kernel/time/timer.c:1404
 expire_timers+0x4fc/0x780 kernel/time/timer.c:1449
 __run_timers+0xaf4/0xd30 kernel/time/timer.c:1773
 run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
 __do_softirq+0x2ea/0x7f5 kernel/softirq.c:293
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:23 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:50 [inline]
 do_softirq_own_stack+0x7c/0xa0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:390 [inline]
 __irq_exit_rcu+0x226/0x270 kernel/softirq.c:420
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:432
 sysvec_apic_timer_interrupt+0x107/0x130 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:593
RIP: 0010:console_unlock+0x195c/0x1e10 kernel/printk/printk.c:2503
Code: c8 00 00 00 48 8b 9c 24 c0 00 00 00 e8 5d d3 00 00 48 85 db 0f 85 89 00 00 00 4c 89 bc 24 28 01 00 00 ff b4 24 28 01 00 00 9d <44> 89 f0 34 01 22 44 24 3f 44 89 f3 0a 5c 24 2a 3c 01 74 76 f6 c3
RSP: 0018:ffff8880b7c8a830 EFLAGS: 00000282
RAX: 00007ffffffff000 RBX: 0000000000000000 RCX: ffff88811a098000
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 000000000001b9a0
RBP: ffff8880b7c8a9b8 R08: ffffea000000000f R09: ffff88812fffa000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffffff925cad60
R13: ffff88811a0989d8 R14: 0000000000000000 R15: 0000000000000282
 vprintk_emit+0x48f/0x990 kernel/printk/printk.c:2028
 vprintk_default+0x90/0xa0 kernel/printk/printk.c:2046
 vprintk_func+0x2f7/0x300 kernel/printk/printk_safe.c:393
 printk+0x18b/0x1d3 kernel/printk/printk.c:2077
 addrconf_notify+0x2f35/0x6400 net/ipv6/addrconf.c:3542
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0x123/0x290 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2027 [inline]
 __dev_notify_flags+0x90e/0xb90 net/core/dev.c:8330
 rtnl_configure_link+0x492/0x4e0 net/core/rtnetlink.c:3028
 __rtnl_newlink net/core/rtnetlink.c:3357 [inline]
 rtnl_newlink+0x2f10/0x3ed0 net/core/rtnetlink.c:3397
 rtnetlink_rcv_msg+0x142b/0x18c0 net/core/rtnetlink.c:5460
 netlink_rcv_skb+0x6d7/0x7e0 net/netlink/af_netlink.c:2469
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x11c8/0x1490 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x173a/0x1840 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0xc82/0x1240 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x6d1/0x840 net/socket.c:2439
 __do_sys_sendmsg net/socket.c:2448 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2446
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2446
 do_syscall_64+0xad/0x160 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441929
Code: Bad RIP value.
RSP: 002b:00007ffca7a67de8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441929
RDX: 0000000000000000 RSI: 0000000020000280 RDI: 0000000000000005
RBP: 00007ffca7a67df0 R08: 0000000100000000 R09: 0000000100000000
R10: 0000000100000000 R11: 0000000000000246 R12: 00000000000244e3
R13: 0000000000402800 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2839 [inline]
 __kmalloc_node_track_caller+0xeab/0x12e0 mm/slub.c:4478
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x35f/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 mrp_pdu_init net/802/mrp.c:300 [inline]
 mrp_pdu_append_vecattr_event+0x4ad/0x2310 net/802/mrp.c:399
 mrp_attr_event+0x2a1/0x4e0 net/802/mrp.c:494
 mrp_mad_event net/802/mrp.c:574 [inline]
 mrp_join_timer+0x10e/0x380 net/802/mrp.c:591
 call_timer_fn+0x226/0x550 kernel/time/timer.c:1404
 expire_timers+0x4fc/0x780 kernel/time/timer.c:1449
 __run_timers+0xaf4/0xd30 kernel/time/timer.c:1773
 run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
 __do_softirq+0x2ea/0x7f5 kernel/softirq.c:293
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
