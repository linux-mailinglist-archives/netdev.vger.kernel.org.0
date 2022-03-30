Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89DE54EB7E0
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241665AbiC3BgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 21:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241523AbiC3BgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 21:36:05 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1AE6928B
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 18:34:20 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id h14-20020a05660208ce00b00645c339411bso13491407ioz.8
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 18:34:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=va05jRzK/SCLEj6HDQO0eCPe+nDWCLO9CrJExBDzQb0=;
        b=3JnJXT9JtutFnHQJFTvV4HlqiSwy/JjWeUcPGTMR5OaSjnu8OyF1VzXHJwZuYEUJLo
         agKOYCsiqH+4XYjf9ZbLW9IaHKs/Rq/SH66bQH2q2b76K8xQwgcSIGFwZBRhwLdM4Cwz
         lgUXn6iEp5oGevKsl0T3piv8DcBZrfzsyD3AWtX67exSoTeO3Z0Fplgq1gSHWCAvzLbn
         Fk7HxRQk5rzK5WdFsK52pVxjL9DnFHUXJdz0MlI5Vy7PUPwwnglcY/7op6dIYruLHmQ/
         PdtGrZG5JIT6CB1n9YGSVF3GqHULzL4hb7iPOwSkYcCWmQ+lz6MniqoG4mwDDQn+HGc+
         BlNg==
X-Gm-Message-State: AOAM533WbrzZGsLPdeM9AhRNvjtNm1Dxq+gHQuAEa1+MmxSXSPUcDcDZ
        Mv17wPWuyXQVUsBlQnCxtdqtf9FtChHdNxOjfd0syeAtHyqo
X-Google-Smtp-Source: ABdhPJzMr6DFezAeRCrWnahgP1KDp6dWXgmNqoRh6AXQC9e6x7IAiapUulJirSQxwwtLsKkdv1fOgXMJAzRY4f8db94Izi0+RL/9
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d81:b0:2c9:bf9e:91ee with SMTP id
 h1-20020a056e021d8100b002c9bf9e91eemr5270707ila.128.1648604059959; Tue, 29
 Mar 2022 18:34:19 -0700 (PDT)
Date:   Tue, 29 Mar 2022 18:34:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005e857005db658b71@google.com>
Subject: [syzbot] INFO: task hung in rfcomm_process_sessions (2)
From:   syzbot <syzbot+d761775dff24be3ad4be@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    cffb2b72d3ed Merge tag 'kgdb-5.18-rc1' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11ae58bb700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=69c8957f4ac2dea6
dashboard link: https://syzkaller.appspot.com/bug?extid=d761775dff24be3ad4be
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103e2107700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=149c7ec7700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d761775dff24be3ad4be@syzkaller.appspotmail.com

INFO: task krfcommd:2706 blocked for more than 143 seconds.
      Tainted: G        W         5.17.0-syzkaller-12817-gcffb2b72d3ed #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:krfcommd        state:D stack:28984 pid: 2706 ppid:     2 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5073 [inline]
 __schedule+0x937/0x1090 kernel/sched/core.c:6382
 schedule+0xeb/0x1b0 kernel/sched/core.c:6454
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6513
 __mutex_lock_common+0xd1f/0x2590 kernel/locking/mutex.c:673
 __mutex_lock kernel/locking/mutex.c:733 [inline]
 mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:785
 rfcomm_process_sessions+0x21/0x3f0 net/bluetooth/rfcomm/core.c:2015
 rfcomm_run+0x195/0x2c0 net/bluetooth/rfcomm/core.c:2122
 kthread+0x2a3/0x2d0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30
 </TASK>
INFO: task syz-executor296:3618 blocked for more than 143 seconds.
      Tainted: G        W         5.17.0-syzkaller-12817-gcffb2b72d3ed #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor296 state:D stack:26552 pid: 3618 ppid:  3612 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5073 [inline]
 __schedule+0x937/0x1090 kernel/sched/core.c:6382
 schedule+0xeb/0x1b0 kernel/sched/core.c:6454
 __lock_sock+0x1cf/0x330 net/core/sock.c:2770
 lock_sock_nested+0x9f/0x100 net/core/sock.c:3317
 lock_sock include/net/sock.h:1682 [inline]
 rfcomm_sk_state_change+0x63/0x300 net/bluetooth/rfcomm/sock.c:73
 __rfcomm_dlc_close+0x2cc/0x480 net/bluetooth/rfcomm/core.c:489
 rfcomm_dlc_close+0x10d/0x1c0 net/bluetooth/rfcomm/core.c:520
 __rfcomm_sock_close+0x101/0x220 net/bluetooth/rfcomm/sock.c:220
 rfcomm_sock_shutdown+0xa5/0x220 net/bluetooth/rfcomm/sock.c:905
 rfcomm_sock_release+0x55/0x120 net/bluetooth/rfcomm/sock.c:925
 __sock_release net/socket.c:650 [inline]
 sock_close+0xd8/0x260 net/socket.c:1318
 __fput+0x3f6/0x860 fs/file_table.c:317
 task_work_run+0x146/0x1c0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0x5e3/0x20f0 kernel/exit.c:794
 do_group_exit+0x2af/0x2b0 kernel/exit.c:924
 get_signal+0x23e8/0x23f0 kernel/signal.c:2903
 arch_do_signal_or_restart+0xa1/0x740 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:149 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:187 [inline]
 exit_to_user_mode_prepare+0x165/0x200 kernel/entry/common.c:222
 __syscall_exit_to_user_mode_work kernel/entry/common.c:304 [inline]
 syscall_exit_to_user_mode+0x2e/0x70 kernel/entry/common.c:315
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f4e731503f9
RSP: 002b:00007fff14a0e988 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: fffffffffffffffc RBX: 0000555556a333b8 RCX: 00007f4e731503f9
RDX: 0000000000000080 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
R13: 0000000000000072 R14: 00007fff14a0ea10 R15: 0000000000000000
 </TASK>
INFO: lockdep is turned off.
NMI backtrace for cpu 1
CPU: 1 PID: 28 Comm: khungtaskd Tainted: G        W         5.17.0-syzkaller-12817-gcffb2b72d3ed #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1dc/0x2d8 lib/dump_stack.c:106
 nmi_cpu_backtrace+0x45f/0x490 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x16a/0x280 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:212 [inline]
 watchdog+0xc82/0xcd0 kernel/hung_task.c:369
 kthread+0x2a3/0x2d0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 8 Comm: kworker/u4:0 Tainted: G        W         5.17.0-syzkaller-12817-gcffb2b72d3ed #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:bcmp+0x1/0x170 lib/string.c:801
Code: 7e fd eb c5 44 89 f9 80 e1 07 38 c1 7c ce 4c 89 ff e8 33 7c 7e fd eb c4 31 ed 89 e8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 90 55 <41> 57 41 56 41 55 41 54 53 49 89 d6 49 89 f7 48 89 fb 49 bd 00 00
RSP: 0018:ffffc900000d7930 EFLAGS: 00000297
RAX: 1ffffffff15103dd RBX: ffffffff81d6d87e RCX: dffffc0000000000
RDX: 0000000000000005 RSI: ffffffff8f7f6000 RDI: ffffffff81d6d87e
RBP: ffffc900000d7a80 R08: ffffffff81d6d87e R09: ffffffff845cf58d
R10: 0000000000000003 R11: ffff88813fe6d700 R12: ffffffff8a881e6a
R13: ffffffff8f7f6000 R14: ffffffff8f7f6000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055e1e7f11600 CR3: 000000000ca8e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __jump_label_patch+0x24d/0x410 arch/x86/kernel/jump_label.c:65
 arch_jump_label_transform_queue+0x49/0xd0 arch/x86/kernel/jump_label.c:137
 __jump_label_update+0x15d/0x350 kernel/jump_label.c:451
 static_key_disable_cpuslocked+0xcc/0x1b0 kernel/jump_label.c:207
 static_key_disable+0x16/0x20 kernel/jump_label.c:215
 toggle_allocation_gate+0x3c8/0x460 mm/kfence/core.c:793
 process_one_work+0x83c/0x11a0 kernel/workqueue.c:2289
 worker_thread+0xa6c/0x1290 kernel/workqueue.c:2436
 kthread+0x2a3/0x2d0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30
 </TASK>
----------------
Code disassembly (best guess):
   0:	7e fd                	jle    0xffffffff
   2:	eb c5                	jmp    0xffffffc9
   4:	44 89 f9             	mov    %r15d,%ecx
   7:	80 e1 07             	and    $0x7,%cl
   a:	38 c1                	cmp    %al,%cl
   c:	7c ce                	jl     0xffffffdc
   e:	4c 89 ff             	mov    %r15,%rdi
  11:	e8 33 7c 7e fd       	callq  0xfd7e7c49
  16:	eb c4                	jmp    0xffffffdc
  18:	31 ed                	xor    %ebp,%ebp
  1a:	89 e8                	mov    %ebp,%eax
  1c:	5b                   	pop    %rbx
  1d:	41 5c                	pop    %r12
  1f:	41 5d                	pop    %r13
  21:	41 5e                	pop    %r14
  23:	41 5f                	pop    %r15
  25:	5d                   	pop    %rbp
  26:	c3                   	retq
  27:	66 90                	xchg   %ax,%ax
  29:	55                   	push   %rbp
* 2a:	41 57                	push   %r15 <-- trapping instruction
  2c:	41 56                	push   %r14
  2e:	41 55                	push   %r13
  30:	41 54                	push   %r12
  32:	53                   	push   %rbx
  33:	49 89 d6             	mov    %rdx,%r14
  36:	49 89 f7             	mov    %rsi,%r15
  39:	48 89 fb             	mov    %rdi,%rbx
  3c:	49                   	rex.WB
  3d:	bd                   	.byte 0xbd


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
