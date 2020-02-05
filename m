Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B2F153A07
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 22:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgBEVUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 16:20:15 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:53829 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgBEVUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 16:20:14 -0500
Received: by mail-il1-f197.google.com with SMTP id d3so2626877ilg.20
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 13:20:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=yeXkaU6z1oAYHjJ8XgSVU6rYjp0GpTAJJmGIMTNlysQ=;
        b=EONgk/ThQ9awOkzT2OOX8eX/82opYcbODTfs81HqrkQtByvwNeGL8gtGhdM6/bIJbE
         CKVorHE6DQ0R81l7iOP8axgyz1jgfGsNYPBeiWSD1pq6H/tS0LStHyY2oqNCh4+s+Mtd
         6SZ9zbxR1MzObnoNLwptQRZxKghUGEN4q1RjwjhxM28ciN6qKKdQ95QVA42KaU8co1J4
         5rUUVxzwOg4SXVrJzMetzrHy7kzbzzGTxmsLu1AHUIhkqvPGNsup3jyLBEGs8jKubH+f
         QoXWaDVEMRQrLo0HiA0BQTWt+emKKOfC8/1mg77X4qUTyiJrn9iZ4uv3Tp5DolYtA1k9
         y/Kw==
X-Gm-Message-State: APjAAAXj4IsioRE5NUnqX2ar0VTFr1V7xyHSDBrycBZcJ8fziCHpKCgo
        mNu5OtWP7Y7NSxS48KRTFVyGRn8m3c6gTtE8uiI3nK0bAyhj
X-Google-Smtp-Source: APXvYqyvDiGo+UaqQXOuzP+fiPpY5cB/Q5k2WTDbSj1YM0SiZksxh1BjbAia4zzMV9cBDyRqFfSNXmDgDICvI+1MTnP+qlq9htZT
MIME-Version: 1.0
X-Received: by 2002:a02:cc75:: with SMTP id j21mr30135547jaq.113.1580937613555;
 Wed, 05 Feb 2020 13:20:13 -0800 (PST)
Date:   Wed, 05 Feb 2020 13:20:13 -0800
In-Reply-To: <000000000000f0baeb059db8b055@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000de3ccd059ddab8b8@google.com>
Subject: Re: inconsistent lock state in rxrpc_put_client_connection_id
From:   syzbot <syzbot+d82f3ac8d87e7ccbb2c9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    6992ca0d Merge branch 'parisc-5.6-1' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12dbd7f1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f22d38d7f9a488a8
dashboard link: https://syzkaller.appspot.com/bug?extid=d82f3ac8d87e7ccbb2c9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14317dbee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=145a44f6e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d82f3ac8d87e7ccbb2c9@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
5.5.0-syzkaller #0 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/1/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
ffffffff8a8c84b8 (rxrpc_conn_id_lock){+.?.}, at: spin_lock include/linux/spinlock.h:338 [inline]
ffffffff8a8c84b8 (rxrpc_conn_id_lock){+.?.}, at: rxrpc_put_client_connection_id net/rxrpc/conn_client.c:138 [inline]
ffffffff8a8c84b8 (rxrpc_conn_id_lock){+.?.}, at: rxrpc_put_client_connection_id+0x73/0xe0 net/rxrpc/conn_client.c:135
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  rxrpc_get_client_connection_id net/rxrpc/conn_client.c:109 [inline]
  rxrpc_alloc_client_connection net/rxrpc/conn_client.c:193 [inline]
  rxrpc_get_client_conn net/rxrpc/conn_client.c:340 [inline]
  rxrpc_connect_call+0x954/0x4e30 net/rxrpc/conn_client.c:701
  rxrpc_new_client_call+0x9c0/0x1ad0 net/rxrpc/call_object.c:290
  rxrpc_new_client_call_for_sendmsg net/rxrpc/sendmsg.c:595 [inline]
  rxrpc_do_sendmsg+0xffa/0x1d5f net/rxrpc/sendmsg.c:652
  rxrpc_sendmsg+0x4d6/0x5f0 net/rxrpc/af_rxrpc.c:586
  sock_sendmsg_nosec net/socket.c:652 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:672
  ____sys_sendmsg+0x358/0x880 net/socket.c:2343
  ___sys_sendmsg+0x100/0x170 net/socket.c:2397
  __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2487
  __do_sys_sendmmsg net/socket.c:2516 [inline]
  __se_sys_sendmmsg net/socket.c:2513 [inline]
  __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2513
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
irq event stamp: 182462
hardirqs last  enabled at (182462): [<ffffffff87ec18d6>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (182462): [<ffffffff87ec18d6>] _raw_spin_unlock_irqrestore+0x66/0xe0 kernel/locking/spinlock.c:191
hardirqs last disabled at (182461): [<ffffffff87ec1c4f>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (182461): [<ffffffff87ec1c4f>] _raw_spin_lock_irqsave+0x6f/0xcd kernel/locking/spinlock.c:159
softirqs last  enabled at (182386): [<ffffffff8147368c>] _local_bh_enable+0x1c/0x30 kernel/softirq.c:162
softirqs last disabled at (182387): [<ffffffff8147608b>] invoke_softirq kernel/softirq.c:373 [inline]
softirqs last disabled at (182387): [<ffffffff8147608b>] irq_exit+0x19b/0x1e0 kernel/softirq.c:413

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(rxrpc_conn_id_lock);
  <Interrupt>
    lock(rxrpc_conn_id_lock);

 *** DEADLOCK ***

1 lock held by swapper/1/0:
 #0: ffffffff89babac0 (rcu_callback){....}, at: rcu_do_batch kernel/rcu/tree.c:2176 [inline]
 #0: ffffffff89babac0 (rcu_callback){....}, at: rcu_core+0x562/0x1390 kernel/rcu/tree.c:2410

stack backtrace:
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_usage_bug.cold+0x327/0x378 kernel/locking/lockdep.c:3100
 valid_state kernel/locking/lockdep.c:3111 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3308 [inline]
 mark_lock+0xbb4/0x1220 kernel/locking/lockdep.c:3665
 mark_usage kernel/locking/lockdep.c:3565 [inline]
 __lock_acquire+0x1e8e/0x4a00 kernel/locking/lockdep.c:3908
 lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:338 [inline]
 rxrpc_put_client_connection_id net/rxrpc/conn_client.c:138 [inline]
 rxrpc_put_client_connection_id+0x73/0xe0 net/rxrpc/conn_client.c:135
 rxrpc_put_one_client_conn net/rxrpc/conn_client.c:955 [inline]
 rxrpc_put_client_conn+0x243/0xc90 net/rxrpc/conn_client.c:1001
 rxrpc_put_connection net/rxrpc/ar-internal.h:965 [inline]
 rxrpc_rcu_destroy_call+0xbd/0x200 net/rxrpc/call_object.c:572
 rcu_do_batch kernel/rcu/tree.c:2186 [inline]
 rcu_core+0x5e1/0x1390 kernel/rcu/tree.c:2410
 rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2419
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x19b/0x1e0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: 38 ea c7 f9 eb 8a cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d 94 76 5c 00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d 84 76 5c 00 fb f4 <c3> cc 55 48 89 e5 41 57 41 56 41 55 41 54 53 e8 ce b7 76 f9 e8 09
RSP: 0018:ffffc90000d3fd68 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff1367542 RBX: ffff8880a99fc340 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffff8880a99fcbd4
RBP: ffffc90000d3fd98 R08: ffff8880a99fc340 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffffff8aa509c0 R14: 0000000000000000 R15: 0000000000000001

