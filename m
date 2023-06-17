Return-Path: <netdev+bounces-11712-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B825734075
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 13:12:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35AAE28132A
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 11:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84B5279F1;
	Sat, 17 Jun 2023 11:12:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778FD1C33
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 11:12:50 +0000 (UTC)
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737F7E6D
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 04:12:48 -0700 (PDT)
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3420ed1a6dcso10342975ab.0
        for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 04:12:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687000368; x=1689592368;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tqysVBz+NFmrTu+Ca/Xnkrb+OEIx8dLa2JZyf+GKTrw=;
        b=PeHWWfvfg4/3xXGfWlLVvClzoTf7HMwpKzE5VukSxdzBPp7zqLivZqHUdWlF9/+HG+
         J8DJGsCvAPfdldjdAxmad+mRTCMFFYXxcSu9prHjaeZFVIxH3lfSheih68jVvxP7ruzX
         Ck7SiMtkD2zgQ+1YyFQZBM1dJup71rSgWGLqgIsEnpz0nDuctEXH/WnhrwaJNm6vg0oO
         GyubcnMQ4JNAhygC4Z0HZWZlkMUiTYbiefhQ74Od/+t6TKqtY60I/I2vPc24Ax/a5xfc
         gQBVevXlgK2aJgcwQ56D7PWBrmafqWl34qR5Mof+isFKFAYeSgabmGAfPwbU5J1MjKof
         jrFg==
X-Gm-Message-State: AC+VfDzV9DbtZl1v2lk2gFREY2tGYFk3P0dgCPASgZ3lcEqeJVLvPlis
	cvitTVKPrT9UYJhhHOuzDGSkZlrLKe++uiAIswTCtYLo2517
X-Google-Smtp-Source: ACHHUZ4msT+TTZyn0q/FX5PQ0CqLUvKtu2X97cf3SNxRrcp6ri3a1sPOQOT2KklftY2+grulVgp2JCc8fdvjhW7CFLx9FFQpBLCb
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aac:b0:341:e20d:24b with SMTP id
 l12-20020a056e021aac00b00341e20d024bmr1531796ilv.0.1687000367830; Sat, 17 Jun
 2023 04:12:47 -0700 (PDT)
Date: Sat, 17 Jun 2023 04:12:47 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a91cfe05fe5161f2@google.com>
Subject: [syzbot] [bluetooth?] BUG: sleeping function called from invalid
 context in __hci_cmd_sync_sk
From: syzbot <syzbot+c715e1bd8dfbcb1ab176@syzkaller.appspotmail.com>
To: johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org, 
	linux-kernel@vger.kernel.org, luiz.dentz@gmail.com, marcel@holtmann.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    1f6ce8392d6f Add linux-next specific files for 20230613
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14adff43280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d103d5f9125e9fe9
dashboard link: https://syzkaller.appspot.com/bug?extid=c715e1bd8dfbcb1ab176
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11287563280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14395963280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2d9bf45aeae9/disk-1f6ce839.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e0b03ef83e17/vmlinux-1f6ce839.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b6c21a24174d/bzImage-1f6ce839.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c715e1bd8dfbcb1ab176@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at net/bluetooth/hci_sync.c:166
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 4430, name: kworker/u5:1
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
4 locks held by kworker/u5:1/4430:
 #0: ffff888020183138 ((wq_completion)hci0#2){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:20 [inline]
 #0: ffff888020183138 ((wq_completion)hci0#2){+.+.}-{0:0}, at: raw_atomic64_set include/linux/atomic/atomic-arch-fallback.h:2608 [inline]
 #0: ffff888020183138 ((wq_completion)hci0#2){+.+.}-{0:0}, at: raw_atomic_long_set include/linux/atomic/atomic-long.h:79 [inline]
 #0: ffff888020183138 ((wq_completion)hci0#2){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:3196 [inline]
 #0: ffff888020183138 ((wq_completion)hci0#2){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:675 [inline]
 #0: ffff888020183138 ((wq_completion)hci0#2){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:702 [inline]
 #0: ffff888020183138 ((wq_completion)hci0#2){+.+.}-{0:0}, at: process_one_work+0x8fd/0x16f0 kernel/workqueue.c:2564
 #1: ffffc900057a7db0 ((work_completion)(&hdev->rx_work)){+.+.}-{0:0}, at: process_one_work+0x930/0x16f0 kernel/workqueue.c:2568
 #2: ffff88802b78c078 (&hdev->lock){+.+.}-{3:3}, at: hci_le_create_big_complete_evt+0xe9/0xab0 net/bluetooth/hci_event.c:6947
 #3: ffffffff8c9a2840 (rcu_read_lock){....}-{1:2}, at: hci_le_ev_skb_pull net/bluetooth/hci_event.c:79 [inline]
 #3: ffffffff8c9a2840 (rcu_read_lock){....}-{1:2}, at: hci_le_create_big_complete_evt+0xcc/0xab0 net/bluetooth/hci_event.c:6943
CPU: 0 PID: 4430 Comm: kworker/u5:1 Not tainted 6.4.0-rc6-next-20230613-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
Workqueue: hci0 hci_rx_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x136/0x150 lib/dump_stack.c:106
 __might_resched+0x358/0x580 kernel/sched/core.c:10188
 __hci_cmd_sync_sk+0x359/0xe30 net/bluetooth/hci_sync.c:166
 __hci_cmd_sync_status_sk+0x45/0x160 net/bluetooth/hci_sync.c:247
 __hci_cmd_sync_status net/bluetooth/hci_sync.c:273 [inline]
 hci_le_terminate_big_sync+0xa4/0xd0 net/bluetooth/hci_sync.c:1671
 hci_le_create_big_complete_evt+0x741/0xab0 net/bluetooth/hci_event.c:6982
 hci_le_meta_evt+0x2bc/0x510 net/bluetooth/hci_event.c:7182
 hci_event_func net/bluetooth/hci_event.c:7512 [inline]
 hci_event_packet+0x641/0xfd0 net/bluetooth/hci_event.c:7567
 hci_rx_work+0xaeb/0x1340 net/bluetooth/hci_core.c:4064
 process_one_work+0xa34/0x16f0 kernel/workqueue.c:2594
 worker_thread+0x67d/0x10c0 kernel/workqueue.c:2745
 kthread+0x344/0x440 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
------------[ cut here ]------------
Voluntary context switch within RCU read-side critical section!
WARNING: CPU: 0 PID: 4430 at kernel/rcu/tree_plugin.h:320 rcu_note_context_switch+0xbb9/0x1800 kernel/rcu/tree_plugin.h:320
Modules linked in:
CPU: 0 PID: 4430 Comm: kworker/u5:1 Tainted: G        W          6.4.0-rc6-next-20230613-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
Workqueue: hci0 hci_rx_work
RIP: 0010:rcu_note_context_switch+0xbb9/0x1800 kernel/rcu/tree_plugin.h:320
Code: 1d 44 68 00 4c 8b 4c 24 30 8b 4c 24 28 48 8b 54 24 20 e9 8f 03 00 00 48 c7 c7 c0 32 6e 8a c6 05 10 41 24 0d 01 e8 87 83 dc ff <0f> 0b e9 4c f5 ff ff 81 e5 ff ff ff 7f 0f 84 d7 f6 ff ff 65 48 8b
RSP: 0018:ffffc900057a74c0 EFLAGS: 00010086
RAX: 0000000000000000 RBX: ffff8880b983d340 RCX: 0000000000000000
RDX: ffff88802c40bb80 RSI: ffffffff814bf5f7 RDI: 0000000000000001
RBP: ffff88802c40bb80 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: ffff88802c40bb80 R14: ffffffff8ea9aff0 R15: ffff8880b983c440
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f802b262fc8 CR3: 000000002812e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __schedule+0x276/0x5790 kernel/sched/core.c:6609
 schedule+0xde/0x1a0 kernel/sched/core.c:6785
 schedule_timeout+0x14e/0x2b0 kernel/time/timer.c:2167
 __hci_cmd_sync_sk+0xc1d/0xe30 net/bluetooth/hci_sync.c:166
 __hci_cmd_sync_status_sk+0x45/0x160 net/bluetooth/hci_sync.c:247
 __hci_cmd_sync_status net/bluetooth/hci_sync.c:273 [inline]
 hci_le_terminate_big_sync+0xa4/0xd0 net/bluetooth/hci_sync.c:1671
 hci_le_create_big_complete_evt+0x741/0xab0 net/bluetooth/hci_event.c:6982
 hci_le_meta_evt+0x2bc/0x510 net/bluetooth/hci_event.c:7182
 hci_event_func net/bluetooth/hci_event.c:7512 [inline]
 hci_event_packet+0x641/0xfd0 net/bluetooth/hci_event.c:7567
 hci_rx_work+0xaeb/0x1340 net/bluetooth/hci_core.c:4064
 process_one_work+0xa34/0x16f0 kernel/workqueue.c:2594
 worker_thread+0x67d/0x10c0 kernel/workqueue.c:2745
 kthread+0x344/0x440 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

