Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41566156179
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 00:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgBGXIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 18:08:10 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:34134 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgBGXIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 18:08:10 -0500
Received: by mail-io1-f70.google.com with SMTP id n26so742979ioj.1
        for <netdev@vger.kernel.org>; Fri, 07 Feb 2020 15:08:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rGxyfQD3JKmvYCOUgqBr7s0tZhn2+yJc7rMGfVpxdo0=;
        b=kw1e/Y/4YWcLyFIAl3zvW4QSvyZGZm5S6/PByNYALcdO0a4dvfr+YtPGVfhAjFZQSg
         t4etTw9CHW0VS3yMchVHTKOZWThPfgCo60GW3dsboIhW2pwSo8fbk3Fo3FmkBPt3eQ5u
         DHkcWV3MjKphUpZyjAV5r9x9aNppRHKNpZrtpnIXya7DzfWAjin+EyhzhTMNcu/y6MsS
         Xuv/PMRlrE2Quo63wSIWnOic3zoJpTsOjW+LPcG5t1lHwKwl8DHwCcDZtd//eeBWqcbd
         rn9hhslUYHDc36j9LoJKFINKH2akTfI3kmI7qxjZJR3qQLo/drigsGxEOWuyIUhv5lN4
         aKmA==
X-Gm-Message-State: APjAAAXAobMUnAop1Mea/icdVYFZVzeXPVOFllFrALc6CZKAqg/dFdzk
        CbNK3zSDGeozLs7eVt7ujwPVoI/tt2In/KXyPRkmDpdDvAmA
X-Google-Smtp-Source: APXvYqzrbCU0rYvp+VC3pQ99QzZhpGmFoALtQwFA8n06w1aZLW6jwT7LLn8nVX+YXqcL//lG5E3AorcYXO3PbZ/+dCHhWIEE9tcu
MIME-Version: 1.0
X-Received: by 2002:a92:d5d2:: with SMTP id d18mr1857791ilq.32.1581116889107;
 Fri, 07 Feb 2020 15:08:09 -0800 (PST)
Date:   Fri, 07 Feb 2020 15:08:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000861441059e047626@google.com>
Subject: INFO: task hung in tls_sw_cancel_work_tx
From:   syzbot <syzbot+ba431dd9afc3a918981a@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, aviadye@mellanox.com,
        borisp@mellanox.com, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    90568ecf Merge tag 'kvm-5.6-2' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16513809e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=69fa012479f9a62
dashboard link: https://syzkaller.appspot.com/bug?extid=ba431dd9afc3a918981a
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1036b6b5e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1651f6e9e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ba431dd9afc3a918981a@syzkaller.appspotmail.com

INFO: task syz-executor561:9073 blocked for more than 143 seconds.
      Not tainted 5.5.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor561 D24464  9073   9072 0x00004000
Call Trace:
 context_switch kernel/sched/core.c:3386 [inline]
 __schedule+0x87f/0xcd0 kernel/sched/core.c:4082
 schedule+0x188/0x210 kernel/sched/core.c:4156
 schedule_timeout+0x46/0x240 kernel/time/timer.c:1871
 do_wait_for_common+0x2e7/0x4d0 kernel/sched/completion.c:83
 __wait_for_common kernel/sched/completion.c:104 [inline]
 wait_for_common kernel/sched/completion.c:115 [inline]
 wait_for_completion+0x47/0x60 kernel/sched/completion.c:136
 __flush_work kernel/workqueue.c:3041 [inline]
 __cancel_work_timer+0x4b7/0x630 kernel/workqueue.c:3128
 cancel_delayed_work_sync+0x1a/0x20 kernel/workqueue.c:3260
 tls_sw_cancel_work_tx+0x72/0x80 net/tls/tls_sw.c:2096
 tls_sk_proto_close+0xd2/0x910 net/tls/tls_main.c:304
 inet_release+0x165/0x1c0 net/ipv4/af_inet.c:427
 inet6_release+0x57/0x70 net/ipv6/af_inet6.c:470
 __sock_release net/socket.c:605 [inline]
 sock_close+0xe1/0x260 net/socket.c:1283
 __fput+0x2e4/0x740 fs/file_table.c:280
 ____fput+0x15/0x20 fs/file_table.c:313
 task_work_run+0x176/0x1b0 kernel/task_work.c:113
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop arch/x86/entry/common.c:164 [inline]
 prepare_exit_to_usermode+0x480/0x5b0 arch/x86/entry/common.c:195
 syscall_return_slowpath+0x113/0x4a0 arch/x86/entry/common.c:278
 do_syscall_64+0x11f/0x1c0 arch/x86/entry/common.c:304
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x402aa0
Code: 00 00 6e 05 00 00 12 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2a 05 00 00 12 00 00 00 00 00 00 00 00 00 00 00 <00> 00 00 00 00 00 00 00 dd 05 00 00 12 00 00 00 00 00 00 00 00 00
RSP: 002b:00007ffe8d80bd08 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000402aa0
RDX: 00000000000000d8 RSI: 00000000200005c0 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000000000d8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000403cd0 R14: 0000000000000000 R15: 0000000000000000

Showing all locks held in the system:
1 lock held by khungtaskd/1106:
 #0: ffffffff892d98c8 (rcu_read_lock){....}, at: rcu_lock_acquire+0x4/0x30 include/linux/rcupdate.h:207
3 locks held by kworker/0:16/2742:
 #0: ffff8880aa426d28 ((wq_completion)events){+.+.}, at: spin_unlock_irq include/linux/spinlock.h:388 [inline]
 #0: ffff8880aa426d28 ((wq_completion)events){+.+.}, at: process_one_work+0x763/0x10f0 kernel/workqueue.c:2237
 #1: ffffc90007fcfd78 ((work_completion)(&(&sw_ctx_tx->tx_work.work)->work)){+.+.}, at: process_one_work+0x7a5/0x10f0 kernel/workqueue.c:2239
 #2: ffff8880921f10d0 (&ctx->tx_lock){+.+.}, at: tx_work_handler+0x10d/0x150 net/tls/tls_sw.c:2209
2 locks held by rsyslogd/8958:
 #0: ffff888099f906a0 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x279/0x310 fs/file.c:821
 #1: ffffffff89307a80 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x4/0x30 mm/page_alloc.c:4072
2 locks held by getty/9048:
 #0: ffff8880a8367090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:267
 #1: ffffc900018232e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x22f/0x1bc0 drivers/tty/n_tty.c:2156
2 locks held by getty/9049:
 #0: ffff88809f16d090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:267
 #1: ffffc900018332e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x22f/0x1bc0 drivers/tty/n_tty.c:2156
2 locks held by getty/9050:
 #0: ffff888094456090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:267
 #1: ffffc900018132e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x22f/0x1bc0 drivers/tty/n_tty.c:2156
2 locks held by getty/9051:
 #0: ffff8880a2177090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:267
 #1: ffffc900018532e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x22f/0x1bc0 drivers/tty/n_tty.c:2156
2 locks held by getty/9052:
 #0: ffff8880999c3090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:267
 #1: ffffc900018432e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x22f/0x1bc0 drivers/tty/n_tty.c:2156
2 locks held by getty/9053:
 #0: ffff888097a81090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:267
 #1: ffffc900018632e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x22f/0x1bc0 drivers/tty/n_tty.c:2156
2 locks held by getty/9054:
 #0: ffff8880a836a090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:267
 #1: ffffc900017a32e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x22f/0x1bc0 drivers/tty/n_tty.c:2156
1 lock held by syz-executor561/9073:
 #0: ffff88808c93c240 (&sb->s_type->i_mutex_key#11){+.+.}, at: inode_lock include/linux/fs.h:791 [inline]
 #0: ffff88808c93c240 (&sb->s_type->i_mutex_key#11){+.+.}, at: __sock_release net/socket.c:604 [inline]
 #0: ffff88808c93c240 (&sb->s_type->i_mutex_key#11){+.+.}, at: sock_close+0x9e/0x260 net/socket.c:1283

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1106 Comm: khungtaskd Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 nmi_cpu_backtrace+0xaa/0x190 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x16f/0x290 lib/nmi_backtrace.c:62
 arch_trigger_cpumask_backtrace+0x10/0x20 arch/x86/kernel/apic/hw_nmi.c:38
 trigger_all_cpu_backtrace+0x17/0x20 include/linux/nmi.h:146
 check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
 watchdog+0xd40/0xd60 kernel/hung_task.c:289
 kthread+0x332/0x350 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:___update_load_sum kernel/sched/pelt.c:208 [inline]
RIP: 0010:update_irq_load_avg+0x301/0xa00 kernel/sched/pelt.c:407
Code: 74 12 4c 89 f7 e8 6f cc 59 00 49 b8 00 00 00 00 00 fc ff df 49 8b 06 4c 89 eb 48 29 c3 0f 88 e5 02 00 00 49 89 dd 49 c1 ed 0a <0f> 84 f8 02 00 00 48 81 e3 00 fc ff ff 48 01 c3 48 8b 45 c8 42 80
RSP: 0018:ffffc90000007c00 EFLAGS: 00000002
RAX: 0000005a48311c00 RBX: 00000000000005fb RCX: 0000000000000000
RDX: 1ffff11015d46fa3 RSI: 0000000000000002 RDI: ffff8880aea37d08
RBP: ffffc90000007c68 R08: dffffc0000000000 R09: 1ffff11015d46fa1
R10: ffffffff899f4010 R11: ffffffff899f4003 R12: ffff8880aea37180
R13: 0000000000000001 R14: ffff8880aea37d00 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 0000000095122000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 update_rq_clock_task kernel/sched/core.c:195 [inline]
 update_rq_clock+0x20c/0x430 kernel/sched/core.c:219
 update_blocked_averages+0x76/0xf70 kernel/sched/fair.c:7670
 _nohz_idle_balance+0x446/0x530 kernel/sched/fair.c:9997
 nohz_idle_balance kernel/sched/fair.c:10048 [inline]
 run_rebalance_domains+0x165/0x290 kernel/sched/fair.c:10237
 __do_softirq+0x283/0x7bd kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x227/0x230 kernel/softirq.c:413
 scheduler_ipi+0x444/0x4a0 kernel/sched/core.c:2349
 smp_reschedule_interrupt+0x7a/0xa0 arch/x86/kernel/smp.c:244
 reschedule_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:853
 </IRQ>
RIP: 0010:native_safe_halt+0x12/0x20 arch/x86/include/asm/irqflags.h:61
Code: 89 d9 80 e1 07 80 c1 03 38 c1 7c ba 48 89 df e8 e4 05 9d f9 eb b0 cc cc 55 48 89 e5 e9 07 00 00 00 0f 00 2d 02 8d 4b 00 fb f4 <5d> c3 66 90 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 e9 07 00 00
RSP: 0018:ffffffff89207db8 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff02
RAX: 1ffffffff1255a5d RBX: ffffffff89275b00 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffffffff812c26da RDI: ffffffff89276344
RBP: ffffffff89207db8 R08: ffffffff89276358 R09: fffffbfff124eb61
R10: fffffbfff124eb61 R11: 0000000000000000 R12: 1ffffffff124eb60
R13: dffffc0000000000 R14: dffffc0000000000 R15: 1ffffffff1255a5b
 arch_safe_halt arch/x86/include/asm/paravirt.h:144 [inline]
 default_idle+0x50/0x70 arch/x86/kernel/process.c:695
 arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:686
 default_idle_call+0x59/0xa0 kernel/sched/idle.c:94
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x1ec/0x630 kernel/sched/idle.c:269
 cpu_startup_entry+0x25/0x30 kernel/sched/idle.c:361
 rest_init+0x29d/0x2b0 init/main.c:631
 arch_call_rest_init+0xe/0x10
 start_kernel+0x676/0x777 init/main.c:969
 x86_64_start_reservations+0x18/0x2e arch/x86/kernel/head64.c:490
 x86_64_start_kernel+0x7a/0x7d arch/x86/kernel/head64.c:471
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
