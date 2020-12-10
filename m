Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370FB2D6795
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 20:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393441AbgLJTyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 14:54:08 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:51577 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390008AbgLJTxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 14:53:52 -0500
Received: by mail-io1-f69.google.com with SMTP id h206so4758087iof.18
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 11:53:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=XMRAja/ZoZsO+seiyLvnZ/1aFb6VeuDhCam8FD/lCas=;
        b=RMaQvMYeCUHWfBUvCqP1k/PCR6BaQtPZSeW1LqIjD3/pvNqEUoUNWrpi+PNdPZ/bmW
         IJzaGKVT7U/t3aOP6X/8wlhD1cH9tjD3Jsdq6gtLw2wOhZ+h/WhWtU8r3Ex0I4cC1DIf
         vK7fpEk0OqmrkF07hWpjykBHWYFm6DDGJzL4IARuNoTacewEQBeQercI3W7PXWYToFei
         9bC1bvje70+nb/AX9G9Ff4dmcvSRIY/P8O7ij2pHkamTb39lvCJUFnu25iLrKfd9yBEz
         4pdXKyiMGVRUmWhFySdr5q569hRWbNc30/BfBaaugMx425lG/U6h8ODJMTfEMU6rrgLX
         Ejfw==
X-Gm-Message-State: AOAM5317s90dlLwWciM+B6AODQR129Q+XMo7W32DE/GkOXfn0jgSxlQJ
        MOIsomiD9a/UA65EThZ/RIUQFIBvKzJ1kTCL5VqZ6dfPAyu3
X-Google-Smtp-Source: ABdhPJzHihha2NRM9J5ANRC2LOgfdhkiZCLnzaIdYA4Tc5r1XSugDIzZX54V4zVLxW1xDMmSuHg2OW1tW/g7HUDec13P+cjXYg+J
MIME-Version: 1.0
X-Received: by 2002:a02:ce2f:: with SMTP id v15mr10735095jar.44.1607629991299;
 Thu, 10 Dec 2020 11:53:11 -0800 (PST)
Date:   Thu, 10 Dec 2020 11:53:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008fd03305b62186a7@google.com>
Subject: INFO: task can't die in inet_twsk_purge
From:   syzbot <syzbot+4c1b0c5364346e7beafa@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a9e26cb5 Add linux-next specific files for 20201208
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=161a9613500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e259434a8eaf0206
dashboard link: https://syzkaller.appspot.com/bug?extid=4c1b0c5364346e7beafa
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=109cf703500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1587c923500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4c1b0c5364346e7beafa@syzkaller.appspotmail.com

INFO: task syz-executor343:8498 can't die for more than 143 seconds.
task:syz-executor343 state:R  running task     stack:25920 pid: 8498 ppid:  8495 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4325 [inline]
 __schedule+0x8eb/0x21b0 kernel/sched/core.c:5076
 preempt_schedule_irq+0x4e/0x90 kernel/sched/core.c:5338
 rcu_read_unlock include/linux/rcupdate.h:694 [inline]
 inet_twsk_purge+0x57f/0x810 net/ipv4/inet_timewait_sock.c:299
INFO: task syz-executor343:8743 can't die for more than 145 seconds.
task:syz-executor343 state:R  running task     stack:25768 pid: 8743 ppid:  8494 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4325 [inline]
 __schedule+0x8eb/0x21b0 kernel/sched/core.c:5076
 preempt_schedule_notrace+0x5b/0xd0 kernel/sched/core.c:5309
INFO: task syz-executor343:8744 can't die for more than 147 seconds.
task:syz-executor343 state:R  running task     stack:25784 pid: 8744 ppid:  8490 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4325 [inline]
 __schedule+0x8eb/0x21b0 kernel/sched/core.c:5076
INFO: task syz-executor343:8745 can't die for more than 148 seconds.
task:syz-executor343 state:D stack:25864 pid: 8745 ppid:  8491 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4325 [inline]
 __schedule+0x8eb/0x21b0 kernel/sched/core.c:5076
 schedule+0xcf/0x270 kernel/sched/core.c:5155
 synchronize_rcu_expedited+0x458/0x620 kernel/rcu/tree_exp.h:852
 synchronize_rcu+0xee/0x190 kernel/rcu/tree.c:3729
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:190
 setup_net+0x508/0x850 net/core/net_namespace.c:365
 copy_net_ns+0x376/0x7b0 net/core/net_namespace.c:483
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xbd/0x230 kernel/nsproxy.c:231
 ksys_unshare+0x445/0x8e0 kernel/fork.c:2958
 __do_sys_unshare kernel/fork.c:3026 [inline]
 __se_sys_unshare kernel/fork.c:3024 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3024
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4414a9
RSP: 002b:00007ffd8be6e998 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004414a9
RDX: 00000000004414a9 RSI: ffffffffffffffff RDI: 0000000040000000
RBP: 000000000007851d R08: 00000000000000c2 R09: 00000000000000c2
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004021a0
R13: 0000000000402230 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor343:8748 can't die for more than 151 seconds.
task:syz-executor343 state:R  running task     stack:25784 pid: 8748 ppid:  8493 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4325 [inline]
 __schedule+0x8eb/0x21b0 kernel/sched/core.c:5076
 native_restore_fl arch/x86/include/asm/irqflags.h:41 [inline]
 arch_local_irq_restore arch/x86/include/asm/irqflags.h:84 [inline]
 lock_is_held_type+0xc2/0x100 kernel/locking/lockdep.c:5478


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
