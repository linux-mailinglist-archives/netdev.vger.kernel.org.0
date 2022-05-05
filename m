Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD5051BC6B
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 11:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354171AbiEEJvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 05:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354110AbiEEJvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 05:51:01 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C558939813
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 02:47:22 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id k2-20020a0566022a4200b00654c0f121a9so2546593iov.1
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 02:47:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eV38iSYAFGjXt9JWlkIOLhHqsRAqY/eXwKHu9dO4WfM=;
        b=qFslF1Fb3nYTc0dXZYPAF328rN03mArqs4nYwqQP0it2ZTgX/XTvV34i4BIFFrRiTX
         dU4+1qLubMc4CoKL2pBNR+PlOVBdSPXJ0Nd4UBsp9iUYLzlkQw6fZCPpJ1wtWz98uePn
         BBTC6L2SW5o+S26fW+ThAtdORVDPeh0GYX+xHWvMxxbbsld6qfpgWrsvujLSYNpBWnYU
         bu/CgvNdjqzAgMo8pZTJGxyMyallgnJBdGR45+IX6iaQO7sAHw/Xof/g55T+yCIiW4Zi
         /brwH1eOwy0vgj2Kl4ni3O7xkHgAPTdPp698xvra5rW6KqRMPlK+PceD/RwTzdc3UgJP
         nUBw==
X-Gm-Message-State: AOAM533tMAEpt/UfMZ/CvpvQGZjDnbtBlY9hlcCWTbPyR9uUjIbpzEwK
        GqlLoFyszE3LWVUIEWdS5Kpv9noO+Zk3FfEkS539jerYc1YZ
X-Google-Smtp-Source: ABdhPJxL5XoOFhIWkIgGimlGzxLGs+KghxbThlHH0A4u3iFDaS4+GhJKngtIFRIFACuIz4GSRic/MRITFWOHKXmjlxt7C123rDYQ
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2e07:b0:65a:5818:2b3d with SMTP id
 o7-20020a0566022e0700b0065a58182b3dmr8054370iow.128.1651744041879; Thu, 05
 May 2022 02:47:21 -0700 (PDT)
Date:   Thu, 05 May 2022 02:47:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e04c5605de40a0dc@google.com>
Subject: [syzbot] inconsistent lock state in rxrpc_put_call
From:   syzbot <syzbot+7ff43f67d38f2d8e07ef@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    48cec73a891c net: lan966x: Fix compilation error
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=135956d8f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4f67580b287bc88d
dashboard link: https://syzkaller.appspot.com/bug?extid=7ff43f67d38f2d8e07ef
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7ff43f67d38f2d8e07ef@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
5.18.0-rc4-syzkaller-00910-g48cec73a891c #0 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
ffff88805a1a4038 (&rxnet->call_lock){+.?.}-{2:2}, at: rxrpc_put_call+0x175/0x300 net/rxrpc/call_object.c:634
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire kernel/locking/lockdep.c:5641 [inline]
  lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5606
  __raw_write_lock include/linux/rwlock_api_smp.h:209 [inline]
  _raw_write_lock+0x2a/0x40 kernel/locking/spinlock.c:300
  rxrpc_service_prealloc_one+0xacf/0x1440 net/rxrpc/call_accept.c:143
  rxrpc_kernel_charge_accept+0xd4/0x120 net/rxrpc/call_accept.c:487
  afs_charge_preallocation+0xba/0x310 fs/afs/rxrpc.c:733
  afs_open_socket+0x294/0x360 fs/afs/rxrpc.c:92
  afs_net_init+0xa75/0xec0 fs/afs/main.c:126
  ops_init+0xaf/0x470 net/core/net_namespace.c:134
  __register_pernet_operations net/core/net_namespace.c:1146 [inline]
  register_pernet_operations+0x35a/0x850 net/core/net_namespace.c:1215
  register_pernet_device+0x26/0x70 net/core/net_namespace.c:1302
  afs_init+0xe6/0x218 fs/afs/main.c:189
  do_one_initcall+0x103/0x650 init/main.c:1298
  do_initcall_level init/main.c:1371 [inline]
  do_initcalls init/main.c:1387 [inline]
  do_basic_setup init/main.c:1406 [inline]
  kernel_init_freeable+0x6b1/0x73a init/main.c:1613
  kernel_init+0x1a/0x1d0 init/main.c:1502
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
irq event stamp: 474002
hardirqs last  enabled at (474002): [<ffffffff89800c02>] asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:645
hardirqs last disabled at (474001): [<ffffffff896a855b>] sysvec_apic_timer_interrupt+0xb/0xc0 arch/x86/kernel/apic/apic.c:1097
softirqs last  enabled at (473854): [<ffffffff8147bb73>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last  enabled at (473854): [<ffffffff8147bb73>] __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
softirqs last disabled at (473975): [<ffffffff8147bb73>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last disabled at (473975): [<ffffffff8147bb73>] __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&rxnet->call_lock);
  <Interrupt>
    lock(&rxnet->call_lock);

 *** DEADLOCK ***

1 lock held by swapper/0/0:
 #0: ffffc90000007d70 ((&call->timer)){+.-.}-{0:0}, at: lockdep_copy_map include/linux/lockdep.h:35 [inline]
 #0: ffffc90000007d70 ((&call->timer)){+.-.}-{0:0}, at: call_timer_fn+0xd5/0x6b0 kernel/time/timer.c:1411

stack backtrace:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.18.0-rc4-syzkaller-00910-g48cec73a891c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_usage_bug kernel/locking/lockdep.c:3935 [inline]
 valid_state kernel/locking/lockdep.c:3947 [inline]
 mark_lock_irq kernel/locking/lockdep.c:4150 [inline]
 mark_lock.part.0.cold+0x18/0xd8 kernel/locking/lockdep.c:4607
 mark_lock kernel/locking/lockdep.c:4571 [inline]
 mark_usage kernel/locking/lockdep.c:4502 [inline]
 __lock_acquire+0x11e7/0x56c0 kernel/locking/lockdep.c:4983
 lock_acquire kernel/locking/lockdep.c:5641 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5606
 __raw_write_lock include/linux/rwlock_api_smp.h:209 [inline]
 _raw_write_lock+0x2a/0x40 kernel/locking/spinlock.c:300
 rxrpc_put_call+0x175/0x300 net/rxrpc/call_object.c:634
 rxrpc_call_timer_expired+0xa1/0xc0 net/rxrpc/call_object.c:58
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x679/0xa80 kernel/time/timer.c:1737
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1750
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:645
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:130 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c6/0x250 drivers/acpi/processor_idle.c:551
Code: 89 de e8 ad a6 0b f8 84 db 75 ac e8 c4 a2 0b f8 e8 2f eb 11 f8 eb 0c e8 b8 a2 0b f8 0f 00 2d d1 4b c5 00 e8 ac a2 0b f8 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 27 a5 0b f8 48 85 db
RSP: 0018:ffffffff8ba07d60 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffffffff8babc700 RSI: ffffffff896d8694 RDI: 0000000000000000
RBP: ffff88801639f864 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff817f71e8 R11: 0000000000000000 R12: 0000000000000001
R13: ffff88801639f800 R14: ffff88801639f864 R15: ffff888019952004
 acpi_idle_enter+0x361/0x500 drivers/acpi/processor_idle.c:686
 cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:155 [inline]
 cpuidle_idle_call kernel/sched/idle.c:236 [inline]
 do_idle+0x3e8/0x590 kernel/sched/idle.c:303
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:400
 start_kernel+0x47f/0x4a0 init/main.c:1140
 secondary_startup_64_no_verify+0xc3/0xcb
 </TASK>
----------------
Code disassembly (best guess):
   0:	89 de                	mov    %ebx,%esi
   2:	e8 ad a6 0b f8       	callq  0xf80ba6b4
   7:	84 db                	test   %bl,%bl
   9:	75 ac                	jne    0xffffffb7
   b:	e8 c4 a2 0b f8       	callq  0xf80ba2d4
  10:	e8 2f eb 11 f8       	callq  0xf811eb44
  15:	eb 0c                	jmp    0x23
  17:	e8 b8 a2 0b f8       	callq  0xf80ba2d4
  1c:	0f 00 2d d1 4b c5 00 	verw   0xc54bd1(%rip)        # 0xc54bf4
  23:	e8 ac a2 0b f8       	callq  0xf80ba2d4
  28:	fb                   	sti
  29:	f4                   	hlt
* 2a:	9c                   	pushfq <-- trapping instruction
  2b:	5b                   	pop    %rbx
  2c:	81 e3 00 02 00 00    	and    $0x200,%ebx
  32:	fa                   	cli
  33:	31 ff                	xor    %edi,%edi
  35:	48 89 de             	mov    %rbx,%rsi
  38:	e8 27 a5 0b f8       	callq  0xf80ba564
  3d:	48 85 db             	test   %rbx,%rbx


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
