Return-Path: <netdev+bounces-231-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AB0B6F62C6
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 04:01:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAB0E1C21062
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 02:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4449FA55;
	Thu,  4 May 2023 02:01:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DC57E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 02:01:54 +0000 (UTC)
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA66D135
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 19:01:51 -0700 (PDT)
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-33156204adcso21473215ab.1
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 19:01:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683165711; x=1685757711;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MRK5jTft3BrTiKwZWh1WJtul0v0zFeRYHVWPAass0oY=;
        b=D4dN8A73kbz+aq8vRAdOMcWKJvjPFIi+celTTTGGIwwBpquT0SMLKJ/lrvSvr3X1Pe
         he0xtRDqRgjXsc1+6H+zeYuofIXTi1dNLhNvc+byWwYSBXHc9bZrIzy/tk2Lx6HIltm7
         s8ifx8NS7fdMVp+5TdKiSq4jZgmnG7AVhkXRLnyQPkcdvcQOfYBZPzU9ZeFS2EJ5o2v2
         E210ir01/mrDvFjibPPSK1ylLqlFzljY6sf4CwdlJ3UxQoBdRiG1E/cgKnHphDtiggpX
         kbu1GHY0ZdOmHfFEr2qAIWm74KceT37UIPPz+cj0O66tUH/MpQ9SV4CpQuwTyeyIVgK1
         KLaw==
X-Gm-Message-State: AC+VfDw0fdOJ8OPbWec/wveC1JnNiNsYTJ7HOMRi9txPzoj6BjEs7Uvi
	d6IlE4gUbcBdyLL/kfk54u/mpzfEd4suyHO8lHEWu1CUG7qT
X-Google-Smtp-Source: ACHHUZ7a+i/5539Z99itMjElna3F55TT5GZ0n0Y64lg1c2AgUJAvGrzU5w7K372oYHks8JcNvj1MO7ZGwo7TpGggc0tKMANac8G2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c90e:0:b0:329:4c5e:15d8 with SMTP id
 t14-20020a92c90e000000b003294c5e15d8mr13005665ilp.2.1683165711140; Wed, 03
 May 2023 19:01:51 -0700 (PDT)
Date: Wed, 03 May 2023 19:01:51 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004f938b05fad48ee6@google.com>
Subject: [syzbot] [fs?] INFO: task hung in synchronize_rcu (4)
From: syzbot <syzbot+222aa26d0a5dbc2e84fe@syzkaller.appspotmail.com>
To: amir73il@gmail.com, daniel@iogearbox.net, jack@suse.cz, kafai@fb.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
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

HEAD commit:    6686317855c6 net: dsa: mv88e6xxx: add mv88e6321 rsvd2cpu
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1457a594280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7205cdba522fe4bc
dashboard link: https://syzkaller.appspot.com/bug?extid=222aa26d0a5dbc2e84fe
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12ede410280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/48685f457043/disk-66863178.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7e1798ecf070/vmlinux-66863178.xz
kernel image: https://storage.googleapis.com/syzbot-assets/cc77fb901221/bzImage-66863178.xz

The issue was bisected to:

commit 3b5d4ddf8fe1f60082513f94bae586ac80188a03
Author: Martin KaFai Lau <kafai@fb.com>
Date:   Wed Mar 9 09:04:50 2022 +0000

    bpf: net: Remove TC_AT_INGRESS_OFFSET and SKB_MONO_DELIVERY_TIME_OFFSET macro

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=153459d7c80000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=173459d7c80000
console output: https://syzkaller.appspot.com/x/log.txt?x=133459d7c80000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+222aa26d0a5dbc2e84fe@syzkaller.appspotmail.com
Fixes: 3b5d4ddf8fe1 ("bpf: net: Remove TC_AT_INGRESS_OFFSET and SKB_MONO_DELIVERY_TIME_OFFSET macro")

INFO: task kworker/u4:1:12 blocked for more than 145 seconds.
      Not tainted 6.3.0-syzkaller-07940-g6686317855c6 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:1    state:D stack:26288 pid:12    ppid:2      flags:0x00004000
Workqueue: events_unbound fsnotify_connector_destroy_workfn
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5307 [inline]
 __schedule+0xc91/0x5770 kernel/sched/core.c:6625
 schedule+0xde/0x1a0 kernel/sched/core.c:6701
 schedule_timeout+0x276/0x2b0 kernel/time/timer.c:2143
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x1ce/0x5c0 kernel/sched/completion.c:106
 __synchronize_srcu+0x1be/0x2c0 kernel/rcu/srcutree.c:1360
 fsnotify_connector_destroy_workfn+0x4d/0xa0 fs/notify/mark.c:208
 process_one_work+0x991/0x15c0 kernel/workqueue.c:2390
 worker_thread+0x669/0x1090 kernel/workqueue.c:2537
 kthread+0x344/0x440 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
INFO: task kworker/u4:4:5134 blocked for more than 146 seconds.
      Not tainted 6.3.0-syzkaller-07940-g6686317855c6 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:4    state:D stack:26344 pid:5134  ppid:2      flags:0x00004000
Workqueue: events_unbound fsnotify_mark_destroy_workfn
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5307 [inline]
 __schedule+0xc91/0x5770 kernel/sched/core.c:6625
 schedule+0xde/0x1a0 kernel/sched/core.c:6701
 schedule_timeout+0x276/0x2b0 kernel/time/timer.c:2143
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x1ce/0x5c0 kernel/sched/completion.c:106
 __synchronize_srcu+0x1be/0x2c0 kernel/rcu/srcutree.c:1360
 fsnotify_mark_destroy_workfn+0x101/0x3c0 fs/notify/mark.c:898
 process_one_work+0x991/0x15c0 kernel/workqueue.c:2390
 worker_thread+0x669/0x1090 kernel/workqueue.c:2537
 kthread+0x344/0x440 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>

Showing all locks held in the system:
2 locks held by kworker/u4:1/12:
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1324 [inline]
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:639 [inline]
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x87a/0x15c0 kernel/workqueue.c:2361
 #1: ffffc90000117da8 (connector_reaper_work){+.+.}-{0:0}, at: process_one_work+0x8ae/0x15c0 kernel/workqueue.c:2365
1 lock held by rcu_tasks_kthre/13:
 #0: ffffffff8c7962f0 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x31/0xd80 kernel/rcu/tasks.h:518
1 lock held by rcu_tasks_trace/14:
 #0: ffffffff8c795ff0 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x31/0xd80 kernel/rcu/tasks.h:518
3 locks held by kworker/1:0/22:
1 lock held by khungtaskd/28:
 #0: ffffffff8c796f00 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x340 kernel/locking/lockdep.c:6545
1 lock held by khugepaged/34:
 #0: ffffffff8c896708 (lock#3){+.+.}-{3:3}, at: __lru_add_drain_all+0x62/0x6a0 mm/swap.c:852
2 locks held by getty/4759:
 #0: ffff88814c1e0098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x26/0x80 drivers/tty/tty_ldisc.c:244
 #1: ffffc900015a02f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xef4/0x13e0 drivers/tty/n_tty.c:2177
4 locks held by syz-executor.2/5077:
 #0: ffff8880b993c2d8 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2f/0x120 kernel/sched/core.c:539
 #1: ffff88802296aef0 (&mm->cid_lock#2){....}-{2:2}, at: mm_cid_get kernel/sched/sched.h:3280 [inline]
 #1: ffff88802296aef0 (&mm->cid_lock#2){....}-{2:2}, at: switch_mm_cid kernel/sched/sched.h:3302 [inline]
 #1: ffff88802296aef0 (&mm->cid_lock#2){....}-{2:2}, at: prepare_task_switch kernel/sched/core.c:5117 [inline]
 #1: ffff88802296aef0 (&mm->cid_lock#2){....}-{2:2}, at: context_switch kernel/sched/core.c:5258 [inline]
 #1: ffff88802296aef0 (&mm->cid_lock#2){....}-{2:2}, at: __schedule+0x2802/0x5770 kernel/sched/core.c:6625
 #2: ffff8880b9929698 (&base->lock){-.-.}-{2:2}, at: lock_timer_base+0x5a/0x1f0 kernel/time/timer.c:999
 #3: ffffffff91fb4ac8 (&obj_hash[i].lock){-.-.}-{2:2}, at: debug_object_activate+0x134/0x3f0 lib/debugobjects.c:690
1 lock held by syz-executor.5/5080:
2 locks held by kworker/u4:4/5134:
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1324 [inline]
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:639 [inline]
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x87a/0x15c0 kernel/workqueue.c:2361
 #1: ffffc9000433fda8 ((reaper_work).work){+.+.}-{0:0}, at: process_one_work+0x8ae/0x15c0 kernel/workqueue.c:2365
2 locks held by dhcpcd/5583:
 #0: ffff88802b7e0130 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1697 [inline]
 #0: ffff88802b7e0130 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x2f/0xe30 net/packet/af_packet.c:3204
 #1: ffffffff8c7a2378 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:293 [inline]
 #1: ffffffff8c7a2378 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x64a/0x770 kernel/rcu/tree_exp.h:992
2 locks held by dhcpcd/5586:
 #0: ffff88806919e130 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1697 [inline]
 #0: ffff88806919e130 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x2f/0xe30 net/packet/af_packet.c:3204
 #1: ffffffff8c7a2378 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:325 [inline]
 #1: ffffffff8c7a2378 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x3e8/0x770 kernel/rcu/tree_exp.h:992
1 lock held by dhcpcd/5587:
 #0: ffff88802cca0130 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1697 [inline]
 #0: ffff88802cca0130 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x2f/0xe30 net/packet/af_packet.c:3204
1 lock held by dhcpcd/5598:
 #0: ffff88807be2c130 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1697 [inline]
 #0: ffff88807be2c130 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x2f/0xe30 net/packet/af_packet.c:3204
1 lock held by dhcpcd/5621:
 #0: ffff88805f706130 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1697 [inline]
 #0: ffff88805f706130 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x2f/0xe30 net/packet/af_packet.c:3204
1 lock held by dhcpcd/5622:
 #0: ffff88807e98e130 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1697 [inline]
 #0: ffff88807e98e130 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x2f/0xe30 net/packet/af_packet.c:3204
2 locks held by syz-executor.5/6144:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 28 Comm: khungtaskd Not tainted 6.3.0-syzkaller-07940-g6686317855c6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 nmi_cpu_backtrace+0x29c/0x350 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x2a4/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:148 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:222 [inline]
 watchdog+0xe16/0x1090 kernel/hung_task.c:379
 kthread+0x344/0x440 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 6146 Comm: syz-executor.1 Not tainted 6.3.0-syzkaller-07940-g6686317855c6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
RIP: 0010:get_page_from_freelist+0x2f5/0x2e20 mm/page_alloc.c:4281
Code: e8 03 42 80 3c 28 00 0f 85 25 1d 00 00 48 8b 04 24 4d 03 67 20 48 8d 48 1c 48 89 c8 48 89 4c 24 38 48 c1 e8 03 42 0f b6 14 28 <48> 89 c8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 c2 1c 00 00 48
RSP: 0018:ffffc9000392f408 EFLAGS: 00000a07
RAX: 1ffff92000725ec9 RBX: 0000000000000001 RCX: ffffc9000392f64c
RDX: 0000000000000000 RSI: ffffffffffffffff RDI: ffff88813fffae08
RBP: ffff88813fffc300 R08: 0000000000000000 R09: ffff88802581b0b7
R10: ffffed1004b03616 R11: 0000000000000000 R12: 0000000000000006
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88813fffae00
FS:  00007f7b6a98a700(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5f54fa8000 CR3: 0000000191236000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __alloc_pages+0x1cb/0x4a0 mm/page_alloc.c:5592
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2277
 __get_free_pages+0xc/0x40 mm/page_alloc.c:5642
 kasan_populate_vmalloc_pte mm/kasan/shadow.c:323 [inline]
 kasan_populate_vmalloc_pte+0x2e/0x180 mm/kasan/shadow.c:314
 apply_to_pte_range mm/memory.c:2578 [inline]
 apply_to_pmd_range mm/memory.c:2622 [inline]
 apply_to_pud_range mm/memory.c:2658 [inline]
 apply_to_p4d_range mm/memory.c:2694 [inline]
 __apply_to_page_range+0x68c/0x1030 mm/memory.c:2728
 alloc_vmap_area+0x500/0x1e00 mm/vmalloc.c:1642
 __get_vm_area_node+0x145/0x3f0 mm/vmalloc.c:2499
 __vmalloc_node_range+0x252/0x14a0 mm/vmalloc.c:3165
 __bpf_map_area_alloc+0xe5/0x180 kernel/bpf/syscall.c:336
 bloom_map_alloc+0x303/0x560 kernel/bpf/bloom_filter.c:137
 find_and_alloc_map kernel/bpf/syscall.c:135 [inline]
 map_create+0x508/0x1860 kernel/bpf/syscall.c:1161
 __sys_bpf+0x127f/0x5420 kernel/bpf/syscall.c:5040
 __do_sys_bpf kernel/bpf/syscall.c:5162 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5160 [inline]
 __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5160
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f7b69c8c169
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7b6a98a168 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f7b69dabf80 RCX: 00007f7b69c8c169
RDX: 0000000000000048 RSI: 0000000020000180 RDI: 0000000000000000
RBP: 00007f7b69ce7ca1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd1b79d6ff R14: 00007f7b6a98a300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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

