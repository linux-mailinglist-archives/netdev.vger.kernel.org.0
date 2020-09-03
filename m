Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6F225BDB8
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 10:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgICIsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 04:48:17 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:37812 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgICIsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 04:48:16 -0400
Received: by mail-il1-f200.google.com with SMTP id b5so1829089ilf.4
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 01:48:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=iCd5gx/40jFX4BtWwtBzsRyfg6n4g25z4Q+4Zxn6oic=;
        b=tHAX39+3ylGd1RK7WVzWkNZ256Bs9k4B2LUgXP0iD1NueNbuMt0rnvoHXVbkl0zwUx
         Zeb4N3M56Nj9sjT9buZi6InBNM5plxKsR2KGQ4plahXtKWOgA2VStr6Fub8G5b3eIu+v
         08v03IsyRSOfNG1iD4PzNTkYmNjFG9uJuPYYdW8KypIVkIMG6+yjoGxrQjPFrwD0kHtE
         TukvxfoIm3JnIQTvv+axJqmHH1/RPLeAgP21OWaOf3TiAs6aw0joY9L0w+/E7VfjQrWY
         WHnSiRXp2/VYsDxfhpZyMW6flRK2RYZVwngZLubYrKwzQ0upnesw/sLXJ0VPAnGs4lA7
         Mm/w==
X-Gm-Message-State: AOAM533+TLsP3dNasyRipKw2zUujX0SZADWkchZYKcbKvzpi347HoCsB
        YhaKsSYPrHiJmZAYaw72VF6SvwnY0ibpvm55Oz1DiYYwdUQ2
X-Google-Smtp-Source: ABdhPJxNvSrsn6z9FTYcGCVogBABIhboIfWF9qQgYFIy/IdLLnij0OjhSOu+DXGd0lQvfv8aTxN6XGCWlI6GC9CGkIPwWKCva0CU
MIME-Version: 1.0
X-Received: by 2002:a92:2c0f:: with SMTP id t15mr2302697ile.205.1599122894550;
 Thu, 03 Sep 2020 01:48:14 -0700 (PDT)
Date:   Thu, 03 Sep 2020 01:48:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000014fd1405ae64d01f@google.com>
Subject: INFO: task hung in tcf_ife_init
From:   syzbot <syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1996cf46 net: bcmgenet: fix mask check in bcmgenet_validat..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=17233f4d900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0437fdd630bee11
dashboard link: https://syzkaller.appspot.com/bug?extid=80e32b5d1f9923f8ace6
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=161678e1900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14f826d1900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com

INFO: task syz-executor939:6846 blocked for more than 143 seconds.
      Not tainted 5.9.0-rc1-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor939 state:D stack:25032 pid: 6846 ppid:  6839 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0x8e5/0x21e0 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4661
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10e0 kernel/locking/mutex.c:1103
 load_metaops_and_vet net/sched/act_ife.c:277 [inline]
 populate_metalist net/sched/act_ife.c:452 [inline]
 tcf_ife_init+0x11a4/0x16f0 net/sched/act_ife.c:578
 tcf_action_init_1+0x6a5/0xac0 net/sched/act_api.c:984
 tcf_action_init+0x249/0x380 net/sched/act_api.c:1043
 tcf_action_add+0xd9/0x360 net/sched/act_api.c:1451
 tc_ctl_action+0x33a/0x439 net/sched/act_api.c:1504
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
RIP: 0033:0x445e29
Code: Bad RIP value.
RSP: 002b:00007f9e83d9ddb8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dac28 RCX: 0000000000445e29
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 00000000006dac20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000006 R11: 0000000000000246 R12: 00000000006dac2c
R13: 00007fff2893048f R14: 00007f9e83d9e9c0 R15: 20c49ba5e353f7cf

Showing all locks held in the system:
3 locks held by kworker/0:2/48:
 #0: ffff888214d82538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888214d82538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888214d82538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888214d82538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888214d82538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888214d82538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90000e47da8 ((addr_chk_work).work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8a7e76c8 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4568
1 lock held by khungtaskd/1166:
 #0: ffffffff89bd6900 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5825
1 lock held by in:imklog/6548:
 #0: ffff8880a8d05870 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:930
1 lock held by syz-executor939/6846:
 #0: ffffffff8a7e76c8 (rtnl_mutex){+.+.}-{3:3}, at: load_metaops_and_vet net/sched/act_ife.c:277 [inline]
 #0: ffffffff8a7e76c8 (rtnl_mutex){+.+.}-{3:3}, at: populate_metalist net/sched/act_ife.c:452 [inline]
 #0: ffffffff8a7e76c8 (rtnl_mutex){+.+.}-{3:3}, at: tcf_ife_init+0x11a4/0x16f0 net/sched/act_ife.c:578
1 lock held by syz-executor939/6848:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1166 Comm: khungtaskd Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd7d/0x1000 kernel/hung_task.c:295
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 6848 Comm: syz-executor939 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:arch_local_irq_restore+0x2e/0x50 arch/x86/include/asm/paravirt.h:770
Code: 3b b6 89 53 48 89 fb 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 75 18 48 83 3d 41 e6 5c 08 00 74 0c 48 89 df 57 9d <0f> 1f 44 00 00 5b c3 0f 0b 48 c7 c7 c8 3b b6 89 e8 bd 01 5b 00 eb
RSP: 0018:ffffc9000527ec78 EFLAGS: 00000286
RAX: 1ffffffff136c779 RBX: 0000000000000286 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: ffffffff89bd6840 RDI: 0000000000000286
RBP: ffff888093c08440 R08: ffffffff865a9e38 R09: ffff888099edb807
R10: ffffed10133db700 R11: 0000000000000001 R12: 0000000000000000
R13: ffff888093c08d28 R14: ffff888093c08d28 R15: 0000000000000286
FS:  00007f9e83d7d700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6aa9c91000 CR3: 0000000091d8f000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_is_held_type+0xbb/0xf0 kernel/locking/lockdep.c:5044
 lock_is_held include/linux/lockdep.h:267 [inline]
 ___might_sleep+0x268/0x2f0 kernel/sched/core.c:7265
 __mutex_lock_common kernel/locking/mutex.c:935 [inline]
 __mutex_lock+0xa9/0x10e0 kernel/locking/mutex.c:1103
 tcf_idr_check_alloc+0x78/0x3b0 net/sched/act_api.c:508
 tcf_ife_init+0x3b1/0x16f0 net/sched/act_ife.c:513
 tcf_action_init_1+0x6a5/0xac0 net/sched/act_api.c:984
 tcf_action_init+0x249/0x380 net/sched/act_api.c:1043
 tcf_action_add+0xd9/0x360 net/sched/act_api.c:1451
 tc_ctl_action+0x33a/0x439 net/sched/act_api.c:1504
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
RIP: 0033:0x445e29
Code: e8 bc b7 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 ab 11 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f9e83d7cdb8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dac38 RCX: 0000000000445e29
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000004
RBP: 00000000006dac30 R08: 0000000000000003 R09: 0000000000000000
R10: 0000000000000003 R11: 0000000000000246 R12: 00000000006dac3c
R13: 00007fff2893048f R14: 00007f9e83d7d9c0 R15: 20c49ba5e353f7cf
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 0.000 msecs


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
