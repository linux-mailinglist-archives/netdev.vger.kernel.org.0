Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA8C1974DF
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbgC3HJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:09:15 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:56918 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729367AbgC3HJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 03:09:15 -0400
Received: by mail-il1-f199.google.com with SMTP id 191so15621691ilb.23
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 00:09:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=8TuEQfozi3qtdKMSaM6xioHT3mtPpo41itG5UVD+Eso=;
        b=GHZGbhpJc+TwRZJa/NVuUU7bwBoeEHn9wFANbaXlbPpKeeEmWmhRGYazbfIoXhu3F/
         lxH+9f/L1vufmzWuRON0FvN2crIlVaNiWGvyrCeIaCjPTJqp7RauQX3u+7lNk2vHaPPU
         jLAsH2lkokKbFzE7zMxBOICAEr9WxySJrE0uQrywaG6X/65XFtC1Lt7q5tO56P1RgKqX
         JnsgKUN++qXY1TC9dZSF9HJ235jwB7yuvabeZ7UNpWymXz1mbtvd+8gaarfc8maHqMtr
         PdQqvqbgv5RpF76z/bg1hWSQAmADHj5LmE4+beQEcaZeYT1JmWC+rqTlP7HjLwsZozeL
         mcXg==
X-Gm-Message-State: ANhLgQ2apljej7TPfLG+g2D8khjkRf0dozegvHifHm+nb+LPqaWdPc8X
        pViK3Qk004XOe3JWxb0Xk8RwlrWUUv2nN5qDfLWbr/l7+Mqe
X-Google-Smtp-Source: ADFU+vu2j0rEsGDVSkIQEs5DgMFdAvHwOzO9J2dkCFNkZdKntGzGSzjOtEaasqVtsjnObGZFblBAXREyY6BCCms03mVwrz0L8m9J
MIME-Version: 1.0
X-Received: by 2002:a02:6cd5:: with SMTP id w204mr9415818jab.43.1585552152580;
 Mon, 30 Mar 2020 00:09:12 -0700 (PDT)
Date:   Mon, 30 Mar 2020 00:09:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d3d67f05a20d2027@google.com>
Subject: INFO: task hung in tls_sk_proto_close
From:   syzbot <syzbot+ca1345cca66556f3d79b@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davem@davemloft.net, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    1a147b74 Merge branch 'DSA-mtu'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=124fcacbe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=46ee14d4915944bc
dashboard link: https://syzkaller.appspot.com/bug?extid=ca1345cca66556f3d79b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ca1345cca66556f3d79b@syzkaller.appspotmail.com

INFO: task syz-executor.3:11325 blocked for more than 143 seconds.
      Not tainted 5.6.0-rc7-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.3  D28352 11325   7299 0x00004004
Call Trace:
 schedule+0xd0/0x2a0 kernel/sched/core.c:4154
 schedule_timeout+0x6db/0xba0 kernel/time/timer.c:1871
 do_wait_for_common kernel/sched/completion.c:83 [inline]
 __wait_for_common kernel/sched/completion.c:104 [inline]
 wait_for_common kernel/sched/completion.c:115 [inline]
 wait_for_completion+0x26a/0x3c0 kernel/sched/completion.c:136
 __flush_work+0x4f0/0xa70 kernel/workqueue.c:3043
 __cancel_work_timer+0x3a2/0x500 kernel/workqueue.c:3130
 tls_sk_proto_close+0x4a9/0xaf0 net/tls/tls_main.c:305
 inet_release+0xe4/0x1f0 net/ipv4/af_inet.c:427
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:470
 __sock_release+0xcd/0x280 net/socket.c:605
 sock_close+0x18/0x20 net/socket.c:1283
 __fput+0x2da/0x850 fs/file_table.c:280
 task_work_run+0x13f/0x1b0 kernel/task_work.c:113
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop+0x2fa/0x360 arch/x86/entry/common.c:164
 prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
 do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:304
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4163e1
Code: Bad RIP value.
RSP: 002b:00007ffe2e1990c0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000006 RCX: 00000000004163e1
RDX: 0000000000000000 RSI: 0000000000001a5e RDI: 0000000000000005
RBP: 0000000000000001 R08: 00000000c2e43a5e R09: 00000000c2e43a62
R10: 00007ffe2e1991a0 R11: 0000000000000293 R12: 000000000076c900
R13: 000000000076c900 R14: 0000000000042661 R15: 000000000076bfac

Showing all locks held in the system:
1 lock held by khungtaskd/1134:
 #0: ffffffff899accc0 (rcu_read_lock){....}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5331
3 locks held by kworker/1:3/2831:
 #0: ffff8880aa026d28 ((wq_completion)events){+.+.}, at: __write_once_size include/linux/compiler.h:226 [inline]
 #0: ffff8880aa026d28 ((wq_completion)events){+.+.}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa026d28 ((wq_completion)events){+.+.}, at: atomic64_set include/asm-generic/atomic-instrumented.h:855 [inline]
 #0: ffff8880aa026d28 ((wq_completion)events){+.+.}, at: atomic_long_set include/asm-generic/atomic-long.h:40 [inline]
 #0: ffff8880aa026d28 ((wq_completion)events){+.+.}, at: set_work_data kernel/workqueue.c:615 [inline]
 #0: ffff8880aa026d28 ((wq_completion)events){+.+.}, at: set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
 #0: ffff8880aa026d28 ((wq_completion)events){+.+.}, at: process_one_work+0x82a/0x1690 kernel/workqueue.c:2237
 #1: ffffc9000825fdd0 ((work_completion)(&(&sw_ctx_tx->tx_work.work)->work)){+.+.}, at: process_one_work+0x85e/0x1690 kernel/workqueue.c:2241
 #2: ffff88809fb020d0 (&ctx->tx_lock){+.+.}, at: tx_work_handler+0x127/0x190 net/tls/tls_sw.c:2209
1 lock held by in:imklog/6642:
 #0: ffff8880a794bae0 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xe3/0x100 fs/file.c:826
1 lock held by syz-executor.3/11325:
 #0: ffff88808602f740 (&sb->s_type->i_mutex_key#14){+.+.}, at: inode_lock include/linux/fs.h:792 [inline]
 #0: ffff88808602f740 (&sb->s_type->i_mutex_key#14){+.+.}, at: __sock_release+0x86/0x280 net/socket.c:604

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1134 Comm: khungtaskd Not tainted 5.6.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x231/0x27e lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
 watchdog+0xa8c/0x1010 kernel/hung_task.c:289
 kthread+0x357/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 55 Comm: kworker/u4:2 Not tainted 5.6.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_nc_worker
RIP: 0010:check_preemption_disabled lib/smp_processor_id.c:14 [inline]
RIP: 0010:debug_smp_processor_id+0x8/0x185 lib/smp_processor_id.c:57
Code: 1b fe e9 e3 fe ff ff 48 c7 c7 84 02 86 8a e8 9f d6 1b fe eb 87 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 41 54 53 e8 c8 01 df fd <65> 44 8b 25 b0 86 6e 7c 65 8b 1d d1 f1 6e 7c 81 e3 ff ff ff 7f 31
RSP: 0018:ffffc90000ef7cb0 EFLAGS: 00000293
RAX: ffff8880a91be100 RBX: 0000000000038300 RCX: ffffffff87a49a8d
RDX: 0000000000000000 RSI: ffffffff83932ca8 RDI: 0000000000000001
RBP: ffff88805be14b80 R08: ffff8880a91be100 R09: ffffed1015ce707c
R10: ffffed1015ce707b R11: ffff8880ae7383db R12: 0000000000000001
R13: 0000000000000104 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f70bad32000 CR3: 00000000a608e000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rcu_dynticks_curr_cpu_in_eqs+0x12/0xb0 kernel/rcu/tree.c:299
 rcu_is_watching+0xc/0x20 kernel/rcu/tree.c:919
 rcu_read_unlock include/linux/rcupdate.h:651 [inline]
 batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:411 [inline]
 batadv_nc_worker+0x47b/0x760 net/batman-adv/network-coding.c:718
 process_one_work+0x94b/0x1690 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x357/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
