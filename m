Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF520407FAE
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 21:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbhILTXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 15:23:40 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:34587 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235752AbhILTXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 15:23:39 -0400
Received: by mail-il1-f200.google.com with SMTP id d17-20020a9287510000b0290223c9088c96so14022485ilm.1
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 12:22:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ul+YwBXMFuYLPOR8Yu9SXOMza6wNejwsN+jqp7q9+Qw=;
        b=AoIQAs8xEkziV1sQ7aIGuBo/dS8uLIJCpKqsB94nGB+LcdkKN2ye+o7qt4rRwiEatb
         w6Li2vHqCoRUbLeA5JfdacAbFrGlwPYk+gMdFIRsonkKUuhpdH70Kt/y6z6uSCDbNuOo
         +ZLqkbmeO3lJxNztvZ0iFI2zVcFftF2BtCZ0ReVwpjNQQ3cwXpWKlfC5GA8fNgfuXJm9
         gHEprlw/Jh+sOQJUxgt/yfAwxyEKxR9ZD5ekQeBxy9UY2EOrKYmZxfvpNeo+VxNKPRHQ
         cUO9shW7zWWLCOEHFFeEWSTS9qElhXZJrflUMDymDB/n5FhGthuuNcgI1XHi0YIm+sqy
         awFQ==
X-Gm-Message-State: AOAM532XDK4X8QbcvZNsaLU3dok/5g/qA76D8BpfwuraiOyAQodbqyYd
        elTQ0xeJzra7By5kz9tgIphuQXqrvzRnbxpjYyrB9mihRfus
X-Google-Smtp-Source: ABdhPJxlN6/JRIp1F3Rwn3/9h4uqIgzofSlSubJQDGMKz41eVKWL2jWNl39egzta5aQ7nLIuzpntcafDkMp8yFUk/aHYdbd0O5Am
MIME-Version: 1.0
X-Received: by 2002:a92:cb12:: with SMTP id s18mr5224646ilo.32.1631474544736;
 Sun, 12 Sep 2021 12:22:24 -0700 (PDT)
Date:   Sun, 12 Sep 2021 12:22:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b2fdbc05cbd144b7@google.com>
Subject: [syzbot] INFO: task hung in cangw_pernet_exit (3)
From:   syzbot <syzbot+c46e2a20b7d78a4e5c6a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    999569d59a0a Add linux-next specific files for 20210908
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17c68851300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7ad035460e67a9c3
dashboard link: https://syzkaller.appspot.com/bug?extid=c46e2a20b7d78a4e5c6a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1653aab5300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c46e2a20b7d78a4e5c6a@syzkaller.appspotmail.com

INFO: task syz-executor.1:8622 can't die for more than 143 seconds.
task:syz-executor.1  state:D stack:25536 pid: 8622 ppid:  6556 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4955 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6302
 schedule+0xd3/0x270 kernel/sched/core.c:6381
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6440
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
 cangw_pernet_exit+0xe/0x20 net/can/gw.c:1244
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:168
 setup_net+0x639/0xa30 net/core/net_namespace.c:349
 copy_net_ns+0x319/0x760 net/core/net_namespace.c:470
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3127
 __do_sys_unshare kernel/fork.c:3201 [inline]
 __se_sys_unshare kernel/fork.c:3199 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3199
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
RSP: 002b:00007fdd1cebc188 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000040000000
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffe22423e0f R14: 00007fdd1cebc300 R15: 0000000000022000
INFO: task syz-executor.2:8795 can't die for more than 146 seconds.
task:syz-executor.2  state:D stack:25208 pid: 8795 ppid:  6559 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4955 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6302
 schedule+0xd3/0x270 kernel/sched/core.c:6381
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6440
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
 cangw_pernet_exit+0xe/0x20 net/can/gw.c:1244
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:168
 setup_net+0x639/0xa30 net/core/net_namespace.c:349
 copy_net_ns+0x319/0x760 net/core/net_namespace.c:470
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3127
 __do_sys_unshare kernel/fork.c:3201 [inline]
 __se_sys_unshare kernel/fork.c:3199 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3199
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
RSP: 002b:00007f42a74e7188 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000040000000
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffe2b27af6f R14: 00007f42a74e7300 R15: 0000000000022000
INFO: task syz-executor.5:8889 can't die for more than 148 seconds.
task:syz-executor.5  state:R  running task     stack:25288 pid: 8889 ppid:  6557 flags:0x00004006
Call Trace:
INFO: task syz-executor.3:8988 can't die for more than 151 seconds.
task:syz-executor.3  state:R  running task     stack:25760 pid: 8988 ppid:  6554 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4955 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6302
 preempt_schedule_irq+0x4e/0x90 kernel/sched/core.c:6702
 irqentry_exit+0x31/0x80 kernel/entry/common.c:427
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0000:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: d5a7ae8:0000000000000000 EFLAGS: 00000046 ORIG_RAX: 0000000000000001
RAX: dffffc0000000000 RBX: 1ffff92001ab4f58 RCX: f4d672f5b9097ca7
RDX: ffffffff8d6e3a57 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffffed1003aa4390 R08: 0000000000000001 R09: ffffffff8fcfa92f
R10: dffffc0000000000 R11: 0000000000000002 R12: ffff88801d521c80
R13: 64a21813a00bdf00 R14: ffffed1017386541 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
