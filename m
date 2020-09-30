Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8788027E8E0
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 14:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbgI3MtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 08:49:17 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:44658 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729917AbgI3MtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 08:49:17 -0400
Received: by mail-il1-f205.google.com with SMTP id l16so457830ils.11
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 05:49:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/hvE1WJmPnaf3tjNkTN3ozvcblsJGWdVi4rG2TJXdkU=;
        b=G2bioiPX4A0xtqal9WdZWkZLfDRBFCBR9ufs7SS7K4lJuhcOMwgITTBU7YEPntDalA
         jejkKIi8YOY8LpxqC8w0cCbjHoGYzSSJMel9Z9dOoJSbBsrNv2xVUnQxWU/t/+EV3SmB
         mkZB/B8ab9ySNgU6Yoc23fHmLm9OrhQBS9Ll3QyiK6kUfcf6DQE9kO0G0FAOkbNvSJL1
         2DaaO6lBZDnXWD0ezmX8Pjkmu3J/Qa6vk85cq+23ktcfgzVapOBd4jp5svJokKIuQGH9
         pNd1y3YjDsSdodSF6HpKqISv3AqlDMoBN2upAGTSZg+PTgzWCBGMK04JCziUQ8nc/YMo
         CeHw==
X-Gm-Message-State: AOAM532RwFztm61kRRofR2jDRNg4GV4vAgwQA2c9bMMWfq/9PB1qBzJy
        P47SKVPorhnMILzMhX/54pRDIAUqWdVDREepDiUfQp5K2VL8
X-Google-Smtp-Source: ABdhPJwbn/fqdYCXnI/R+QHdujVgoT2Pzz8fN7PgCIf7YuX8QCigcm7lu47/nSQDOlgt+u78bQauDvqSjujVtabBfA9X7GyLDH+m
MIME-Version: 1.0
X-Received: by 2002:a92:7713:: with SMTP id s19mr1904120ilc.161.1601470155527;
 Wed, 30 Sep 2020 05:49:15 -0700 (PDT)
Date:   Wed, 30 Sep 2020 05:49:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bd1edd05b087535a@google.com>
Subject: INFO: rcu detected stall in security_file_open (3)
From:   syzbot <syzbot+d2b6e8cc299748fecf25@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, fweisbec@gmail.com, ktkhai@virtuozzo.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, miklos@szeredi.hu, mingo@kernel.org,
        mszeredi@redhat.com, netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fb0155a0 Merge tag 'nfs-for-5.9-3' of git://git.linux-nfs...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10b007cf900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41b736b7ce1b3ea4
dashboard link: https://syzkaller.appspot.com/bug?extid=d2b6e8cc299748fecf25
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1249c717900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1048d9e3900000

The issue was bisected to:

commit c9d8f5f0692d5960ed50970ffe63756fb8f96cdb
Author: Kirill Tkhai <ktkhai@virtuozzo.com>
Date:   Fri Nov 9 10:33:27 2018 +0000

    fuse: Protect fi->nlookup with fi->lock

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11af769d900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13af769d900000
console output: https://syzkaller.appspot.com/x/log.txt?x=15af769d900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d2b6e8cc299748fecf25@syzkaller.appspotmail.com
Fixes: c9d8f5f0692d ("fuse: Protect fi->nlookup with fi->lock")

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1):
------------[ cut here ]------------
WARNING: CPU: 0 PID: 3922 at kernel/sched/core.c:3013 rq_unlock kernel/sched/sched.h:1326 [inline]
WARNING: CPU: 0 PID: 3922 at kernel/sched/core.c:3013 try_invoke_on_locked_down_task+0x21d/0x2f0 kernel/sched/core.c:3019
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 3922 Comm: systemd-udevd Not tainted 5.9.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:try_invoke_on_locked_down_task+0x21d/0x2f0 kernel/sched/core.c:3013
Code: 45 31 f6 49 39 c0 74 3a 8b 74 24 38 49 8d 78 18 4c 89 04 24 e8 a4 e7 08 00 4c 8b 04 24 4c 89 c7 e8 28 ab d6 06 e9 20 ff ff ff <0f> 0b e9 7d fe ff ff 4c 89 ee 48 89 ef 41 ff d4 41 89 c6 e9 08 ff
RSP: 0018:ffffc90000007be0 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 1ffff92000000f7e RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffffffff8162da10 RDI: ffff8880a61a2440
RBP: ffff8880a61a2440 R08: 0000000000000033 R09: ffffffff8a05ae03
R10: 000000000000062e R11: 0000000000000001 R12: ffffffff8162da10
R13: ffffc90000007d08 R14: ffff8880a61a2440 R15: 0000000000000000
 rcu_print_task_stall kernel/rcu/tree_stall.h:267 [inline]
 print_other_cpu_stall kernel/rcu/tree_stall.h:475 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:634 [inline]
 rcu_pending kernel/rcu/tree.c:3639 [inline]
 rcu_sched_clock_irq.cold+0x97e/0xdfd kernel/rcu/tree.c:2521
 update_process_times+0x25/0xa0 kernel/time/timer.c:1710
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:176
 tick_sched_timer+0x1d1/0x2a0 kernel/time/tick-sched.c:1328
 __run_hrtimer kernel/time/hrtimer.c:1524 [inline]
 __hrtimer_run_queues+0x1d5/0xfc0 kernel/time/hrtimer.c:1588
 hrtimer_interrupt+0x334/0x940 kernel/time/hrtimer.c:1650
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1080 [inline]
 __sysvec_apic_timer_interrupt+0x147/0x5f0 arch/x86/kernel/apic/apic.c:1097
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_sysvec_on_irqstack arch/x86/include/asm/irq_stack.h:37 [inline]
 run_sysvec_on_irqstack_cond arch/x86/include/asm/irq_stack.h:89 [inline]
 sysvec_apic_timer_interrupt+0xb2/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:preempt_count arch/x86/include/asm/preempt.h:26 [inline]
RIP: 0010:check_kcov_mode kernel/kcov.c:163 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x9/0x60 kernel/kcov.c:197
Code: 5d be 03 00 00 00 e9 76 af 49 02 66 0f 1f 44 00 00 48 8b be b0 01 00 00 e8 b4 ff ff ff 31 c0 c3 90 65 48 8b 14 25 c0 fe 01 00 <65> 8b 05 e0 bf 8b 7e a9 00 01 ff 00 48 8b 34 24 74 0f f6 c4 01 74
RSP: 0018:ffffc90000f075a8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000004 RCX: ffffffff838a0be7
RDX: ffff88809c62c4c0 RSI: ffff88809c62c4c0 RDI: 0000000000000005
RBP: ffff8880a601de80 R08: 0000000000000001 R09: ffffffff8d5f79c7
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000183 R14: dffffc0000000000 R15: 0000000000000000
 tomoyo_domain_quota_is_ok+0x31a/0x550 security/tomoyo/util.c:1070
 tomoyo_supervisor+0x2f2/0xef0 security/tomoyo/common.c:2089
 tomoyo_audit_path_log security/tomoyo/file.c:168 [inline]
 tomoyo_path_permission security/tomoyo/file.c:587 [inline]
 tomoyo_path_permission+0x270/0x3a0 security/tomoyo/file.c:573
 tomoyo_check_open_permission+0x33e/0x380 security/tomoyo/file.c:777
 tomoyo_file_open security/tomoyo/tomoyo.c:313 [inline]
 tomoyo_file_open+0xa3/0xd0 security/tomoyo/tomoyo.c:308
 security_file_open+0x52/0x4f0 security/security.c:1574
 do_dentry_open+0x358/0x11b0 fs/open.c:804
 do_open fs/namei.c:3251 [inline]
 path_openat+0x1b9a/0x2730 fs/namei.c:3368
 do_filp_open+0x17e/0x3c0 fs/namei.c:3395
 do_sys_openat2+0x16d/0x420 fs/open.c:1168
 do_sys_open fs/open.c:1184 [inline]
 __do_sys_open fs/open.c:1192 [inline]
 __se_sys_open fs/open.c:1188 [inline]
 __x64_sys_open+0x119/0x1c0 fs/open.c:1188
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fb405960840
Code: 73 01 c3 48 8b 0d 68 77 20 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 bb 20 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 1e f6 ff ff 48 89 04 24
RSP: 002b:00007fff26dc0bd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007fff26dc0c70 RCX: 00007fb405960840
RDX: 0000560daddc7fe3 RSI: 00000000000a0800 RDI: 0000560daede0670
RBP: 00007fff26dc1100 R08: 0000560daddc7670 R09: 0000000000000010
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff26dc0d80
R13: 0000560daed2da60 R14: 0000560daedeeef0 R15: 00007fff26dc0c50
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
