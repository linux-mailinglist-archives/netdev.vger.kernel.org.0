Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756BA594E95
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 04:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbiHPCRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 22:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237787AbiHPCPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 22:15:24 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F06F1257AB
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 15:24:23 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id a4-20020a056e0208a400b002e4621942dfso5847574ilt.0
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 15:24:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=H7UiU1sSMkI2uPnOnfB4y3ObJwOrcNNrp7E87VZ9Yjw=;
        b=M0Jkbn/xQNcZCmYsT9Upxq5tP9bfrB/JvFXkY6gRLMxZiXIDvmhq8xRNi8uEURoY82
         rLPVQfvmrP7dBqNZkHpPdKEAJ/A0b2VdywbO2vCE5dz5MkmPRV8yIxKNDmAihPon6jMA
         /4aLkQGlUbgB4JMNy5lG5dEk4oxKheV4DGf9C/Zygh4nRFbrphh/la5C53nZ66hzldI/
         Ye+3/ORC9XfbB6mAuwNX4Qk//WNKzGWJQrhih7Ip4fQpn9xHTa6E5zyTcZr1VNx822dS
         Ce8NlwBcdVW6fEF30OZt5lpr2xbkGytxx1x8zxsUZvG5n47/UOcCXAQDvy3pr3UKf6cL
         6XxA==
X-Gm-Message-State: ACgBeo29000gYMCmJdvS3xVI/wY6IPJTpE8LdB9lnlr0Tsuo2z/PoU6C
        8Tf7z6C1YR1Z8GZkvBDgnBAVS5mt0NEHvPSjQY/42GUzQZz9
X-Google-Smtp-Source: AA6agR5YKV2bK7ocELduCy6QalIpkbY3lU41hNXGT3iv2+92/aaGzW8grbAmrFTzqlumWyCDkPRWah7U/IjMzK9lopaK+MO7BZky
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2684:b0:344:ccfc:ce62 with SMTP id
 o4-20020a056638268400b00344ccfcce62mr4109067jat.131.1660602262500; Mon, 15
 Aug 2022 15:24:22 -0700 (PDT)
Date:   Mon, 15 Aug 2022 15:24:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f842c805e64f17a8@google.com>
Subject: [syzbot] inconsistent lock state in p9_req_put
From:   syzbot <syzbot+2f20b523930c32c160cc@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, edumazet@google.com,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
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

HEAD commit:    f6eb0fed6a39 Merge tag 'timers-urgent-2022-08-13' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1184fec3080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ffbab52ef9fab60
dashboard link: https://syzkaller.appspot.com/bug?extid=2f20b523930c32c160cc
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2f20b523930c32c160cc@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
5.19.0-syzkaller-14264-gf6eb0fed6a39 #0 Not tainted
--------------------------------
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
syz-executor.3/10062 [HC1[1]:SC1[1]:HE0:SE0] takes:
ffff88801ceb8c18 (&clnt->lock){?.+.}-{2:2}, at: p9_tag_remove net/9p/client.c:367 [inline]
ffff88801ceb8c18 (&clnt->lock){?.+.}-{2:2}, at: p9_req_put net/9p/client.c:375 [inline]
ffff88801ceb8c18 (&clnt->lock){?.+.}-{2:2}, at: p9_req_put+0xc6/0x250 net/9p/client.c:372
{HARDIRQ-ON-W} state was registered at:
  lock_acquire kernel/locking/lockdep.c:5666 [inline]
  lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
  __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
  spin_lock include/linux/spinlock.h:349 [inline]
  p9_fd_request+0x85/0x330 net/9p/trans_fd.c:672
  p9_client_rpc+0x2f0/0xce0 net/9p/client.c:660
  p9_client_version net/9p/client.c:880 [inline]
  p9_client_create+0xaec/0x1070 net/9p/client.c:985
  v9fs_session_init+0x1e2/0x1810 fs/9p/v9fs.c:408
  v9fs_mount+0xba/0xc90 fs/9p/vfs_super.c:126
  legacy_get_tree+0x105/0x220 fs/fs_context.c:610
  vfs_get_tree+0x89/0x2f0 fs/super.c:1530
  do_new_mount fs/namespace.c:3040 [inline]
  path_mount+0x1326/0x1e20 fs/namespace.c:3370
  do_mount fs/namespace.c:3383 [inline]
  __do_sys_mount fs/namespace.c:3591 [inline]
  __se_sys_mount fs/namespace.c:3568 [inline]
  __x64_sys_mount+0x27f/0x300 fs/namespace.c:3568
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
irq event stamp: 1139
hardirqs last  enabled at (1138): [<ffffffff89c00190>] __do_softirq+0x190/0x9c6 kernel/softirq.c:555
hardirqs last disabled at (1139): [<ffffffff897eaf31>] common_interrupt+0x11/0xc0 arch/x86/kernel/irq.c:240
softirqs last  enabled at (62): [<ffffffff81483e73>] invoke_softirq kernel/softirq.c:445 [inline]
softirqs last  enabled at (62): [<ffffffff81483e73>] __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
softirqs last disabled at (1137): [<ffffffff81483e73>] invoke_softirq kernel/softirq.c:445 [inline]
softirqs last disabled at (1137): [<ffffffff81483e73>] __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&clnt->lock);
  <Interrupt>
    lock(&clnt->lock);

 *** DEADLOCK ***

3 locks held by syz-executor.3/10062:
 #0: ffff888066ee2ab0 (&p->alloc_lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:349 [inline]
 #0: ffff888066ee2ab0 (&p->alloc_lock){+.+.}-{2:2}, at: task_lock include/linux/sched/task.h:174 [inline]
 #0: ffff888066ee2ab0 (&p->alloc_lock){+.+.}-{2:2}, at: exit_fs+0x5a/0x170 fs/fs_struct.c:101
 #1: ffff88801b98ca20 (&fs->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:349 [inline]
 #1: ffff88801b98ca20 (&fs->lock){+.+.}-{2:2}, at: exit_fs+0x62/0x170 fs/fs_struct.c:102
 #2: ffff888022720020 (&chan->lock#2){-.-.}-{2:2}, at: req_done+0xcf/0x2e0 net/9p/trans_virtio.c:139

stack backtrace:
CPU: 0 PID: 10062 Comm: syz-executor.3 Not tainted 5.19.0-syzkaller-14264-gf6eb0fed6a39 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_usage_bug kernel/locking/lockdep.c:3961 [inline]
 valid_state kernel/locking/lockdep.c:3973 [inline]
 mark_lock_irq kernel/locking/lockdep.c:4176 [inline]
 mark_lock.part.0.cold+0x18/0xd8 kernel/locking/lockdep.c:4632
 mark_lock kernel/locking/lockdep.c:4596 [inline]
 mark_usage kernel/locking/lockdep.c:4524 [inline]
 __lock_acquire+0x14a2/0x56d0 kernel/locking/lockdep.c:5007
 lock_acquire kernel/locking/lockdep.c:5666 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 p9_tag_remove net/9p/client.c:367 [inline]
 p9_req_put net/9p/client.c:375 [inline]
 p9_req_put+0xc6/0x250 net/9p/client.c:372
 req_done+0x1de/0x2e0 net/9p/trans_virtio.c:148
 vring_interrupt drivers/virtio/virtio_ring.c:2454 [inline]
 vring_interrupt+0x29d/0x3d0 drivers/virtio/virtio_ring.c:2429
 __handle_irq_event_percpu+0x227/0x870 kernel/irq/handle.c:158
 handle_irq_event_percpu kernel/irq/handle.c:193 [inline]
 handle_irq_event+0xa7/0x1e0 kernel/irq/handle.c:210
 handle_edge_irq+0x25f/0xd00 kernel/irq/chip.c:819
 generic_handle_irq_desc include/linux/irqdesc.h:158 [inline]
 handle_irq arch/x86/kernel/irq.c:231 [inline]
 __common_interrupt+0x9d/0x210 arch/x86/kernel/irq.c:250
 common_interrupt+0x4d/0xc0 arch/x86/kernel/irq.c:240
 asm_common_interrupt+0x22/0x40 arch/x86/include/asm/idtentry.h:640
RIP: 0010:__do_softirq+0x196/0x9c6 kernel/softirq.c:557
Code: 00 48 01 f0 48 89 44 24 18 48 c7 c7 c0 41 eb 89 e8 5f ff be ff 65 66 c7 05 35 94 43 76 00 00 e8 70 ab c1 f7 fb b8 ff ff ff ff <48> c7 c3 c0 a0 c0 8b 41 0f bc c5 41 89 c7 41 83 c7 01 0f 85 ad 00
RSP: 0018:ffffc90000007f70 EFLAGS: 00000206
RAX: 00000000ffffffff RBX: ffff888066ee2140 RCX: 1ffffffff211cc2e
RDX: 0000000000000000 RSI: 0000000000000102 RDI: 0000000000000000
RBP: ffff8880125241c0 R08: 0000000000000001 R09: ffffffff908d9967
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000080 R14: 0000000000000000 R15: 0000000000000000
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1106
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
RIP: 0010:lock_acquire+0x1ef/0x570 kernel/locking/lockdep.c:5634
Code: d2 a3 7e 83 f8 01 0f 85 e8 02 00 00 9c 58 f6 c4 02 0f 85 fb 02 00 00 48 83 7c 24 08 00 74 01 fb 48 b8 00 00 00 00 00 fc ff df <48> 01 c3 48 c7 03 00 00 00 00 48 c7 43 08 00 00 00 00 48 8b 84 24
RSP: 0018:ffffc9000357fa48 EFLAGS: 00000206
RAX: dffffc0000000000 RBX: 1ffff920006aff4b RCX: ffffffff815e513e
RDX: 1ffff1100cddc576 RSI: 0000000000000002 RDI: 0000000000000000
RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffff908d9967
R10: fffffbfff211b32c R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88801b98ca20 R15: 0000000000000000
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:349 [inline]
 exit_fs+0x62/0x170 fs/fs_struct.c:102
 do_exit+0xaa6/0x29b0 kernel/exit.c:791
 do_group_exit+0xd2/0x2f0 kernel/exit.c:925
 get_signal+0x238c/0x2610 kernel/signal.c:2857
 arch_do_signal_or_restart+0x82/0x2300 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop kernel/entry/common.c:166 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f0b07489279
Code: Unable to access opcode bytes at RIP 0x7f0b0748924f.
RSP: 002b:00007f0b085a3218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f0b0759bf88 RCX: 00007f0b07489279
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f0b0759bf88
RBP: 00007f0b0759bf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f0b0759bf8c
R13: 00007ffdfa1bfd4f R14: 00007f0b085a3300 R15: 0000000000022000
 </TASK>
----------------
Code disassembly (best guess):
   0:	00 48 01             	add    %cl,0x1(%rax)
   3:	f0 48 89 44 24 18    	lock mov %rax,0x18(%rsp)
   9:	48 c7 c7 c0 41 eb 89 	mov    $0xffffffff89eb41c0,%rdi
  10:	e8 5f ff be ff       	callq  0xffbeff74
  15:	65 66 c7 05 35 94 43 	movw   $0x0,%gs:0x76439435(%rip)        # 0x76439454
  1c:	76 00 00
  1f:	e8 70 ab c1 f7       	callq  0xf7c1ab94
  24:	fb                   	sti
  25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
* 2a:	48 c7 c3 c0 a0 c0 8b 	mov    $0xffffffff8bc0a0c0,%rbx <-- trapping instruction
  31:	41 0f bc c5          	bsf    %r13d,%eax
  35:	41 89 c7             	mov    %eax,%r15d
  38:	41 83 c7 01          	add    $0x1,%r15d
  3c:	0f                   	.byte 0xf
  3d:	85                   	.byte 0x85
  3e:	ad                   	lods   %ds:(%rsi),%eax


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
