Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C8D12AECC
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 22:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfLZVPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 16:15:33 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:53574 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbfLZVPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 16:15:12 -0500
Received: by mail-io1-f69.google.com with SMTP id m5so10811346iol.20
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 13:15:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eKYwtZjwxXpWCOekYMYt9WDRJ4Y/KJHGrx/6wjCId6U=;
        b=L1lhMIBJ6IIM33DDQ4OQbPQlckaf2EhXxNwc/beVuDRbheyAxc6QmFsR7oCOPWXB3M
         U7iID2JRhVVswN+NQ6YeQBUGlJiS0w1jUz4jVRsT2YgMKPLK93ls4KqlG5kfv6lZ3/wc
         9XupmIm3PpXRMoOZp7E+xSSE4a4Vfj3sITqCPRLomCdlXJlJFfa7XI0Y7kdVsC7FVDWP
         bfLolRJCQvZGsHrU5Ds6nwDx3bKFLIlGKVCqFHcmOINRl34kt14T91Px/wHK261PbzB1
         GslmU9rl5/fmtJ7oyvDBGEkSGKoDL2Nlcn0nAnk4ANqM79UmwOxeLNhkR2nTIVkd6J2z
         ZRIA==
X-Gm-Message-State: APjAAAUyxFflJqDKdocEm3EWVZ7/+fBkrUfsLlUoGD0bBY9TbOsOL6Jt
        fAfWLx69OgwbugSpZ5/e/Xi2jwqUHCTtOU8suB3JsyQ/UPv8
X-Google-Smtp-Source: APXvYqzN1LRZcat8Gf3OapnF1VMsPHi/08XA+LdwCxVqpkNPiAQXMA7ZBRKm53iEIlzEsbYzGIImsucG0fuWBeuT3VRauNOa9V0e
MIME-Version: 1.0
X-Received: by 2002:a92:d18a:: with SMTP id z10mr42462219ilz.48.1577394911483;
 Thu, 26 Dec 2019 13:15:11 -0800 (PST)
Date:   Thu, 26 Dec 2019 13:15:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005eaea0059aa1dff6@google.com>
Subject: INFO: task hung in htable_put
From:   syzbot <syzbot+84936245a918e2cddb32@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, hannes@cmpxchg.org,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, mhocko@suse.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    46cf053e Linux 5.5-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=128f54e1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed9d672709340e35
dashboard link: https://syzkaller.appspot.com/bug?extid=84936245a918e2cddb32
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=134252c6e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c7c63ee00000

The bug was bisected to:

commit b8c8a338f75e052d9fa2fed851259320af412e3f
Author: Johannes Weiner <hannes@cmpxchg.org>
Date:   Fri Oct 13 22:58:05 2017 +0000

     Revert "vmalloc: back off when the current task is killed"

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=178f8649e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=144f8649e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=104f8649e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+84936245a918e2cddb32@syzkaller.appspotmail.com
Fixes: b8c8a338f75e ("Revert "vmalloc: back off when the current task is  
killed"")

INFO: task syz-executor013:10018 blocked for more than 143 seconds.
       Not tainted 5.5.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor013 D27416 10018  10013 0x00004004
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_timeout+0x717/0xc50 kernel/time/timer.c:1871
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x29c/0x440 kernel/sched/completion.c:136
  __flush_work+0x4fe/0xa50 kernel/workqueue.c:3041
  __cancel_work_timer+0x3d9/0x540 kernel/workqueue.c:3128
  cancel_delayed_work_sync+0x1b/0x20 kernel/workqueue.c:3260
  htable_destroy net/netfilter/xt_hashlimit.c:420 [inline]
  htable_put+0x15f/0x220 net/netfilter/xt_hashlimit.c:449
  hashlimit_mt_destroy_v2+0x56/0x70 net/netfilter/xt_hashlimit.c:971
  cleanup_match+0xde/0x170 net/ipv6/netfilter/ip6_tables.c:478
  cleanup_entry+0xd7/0x270 net/ipv4/netfilter/ip_tables.c:645
  do_replace net/ipv4/netfilter/ip_tables.c:1148 [inline]
  do_ipt_set_ctl+0x3e4/0x4c2 net/ipv4/netfilter/ip_tables.c:1672
  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
  nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
  ip_setsockopt net/ipv4/ip_sockglue.c:1260 [inline]
  ip_setsockopt+0xdf/0x100 net/ipv4/ip_sockglue.c:1240
  udp_setsockopt+0x68/0xb0 net/ipv4/udp.c:2639
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
  __sys_setsockopt+0x261/0x4c0 net/socket.c:2117
  __do_sys_setsockopt net/socket.c:2133 [inline]
  __se_sys_setsockopt net/socket.c:2130 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2130
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4412b9
Code: 0a 72 65 73 6f 72 74 2c 20 79 6f 75 20 6d 61 79 20 77 61 6e 74 20 74  
6f 20 72 65 6d 6f 76 65 20 24 41 62 6f 72 74 4f 6e 55 6e <63> 6c 65 61 6e  
43 6f 6e 66 69 67 20 74 6f 20 70 65 72 6d 69 74 20
RSP: 002b:00007ffc9723f3f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004412b9
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00000000006cc018 R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000020000500 R11: 0000000000000246 R12: 0000000000402030
R13: 00000000004020c0 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor013:10029 blocked for more than 143 seconds.
       Not tainted 5.5.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor013 D28160 10029  10017 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
  __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
  hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
  hashlimit_mt_check_v2+0x327/0x3b0 net/netfilter/xt_hashlimit.c:950
  xt_check_match+0x280/0x690 net/netfilter/x_tables.c:501
  check_match net/ipv4/netfilter/ip_tables.c:472 [inline]
  find_check_match net/ipv4/netfilter/ip_tables.c:488 [inline]
  find_check_entry.isra.0+0x32f/0x920 net/ipv4/netfilter/ip_tables.c:538
  translate_table+0xcb4/0x17d0 net/ipv4/netfilter/ip_tables.c:717
  do_replace net/ipv4/netfilter/ip_tables.c:1136 [inline]
  do_ipt_set_ctl+0x2fe/0x4c2 net/ipv4/netfilter/ip_tables.c:1672
  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
  nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
  ip_setsockopt net/ipv4/ip_sockglue.c:1260 [inline]
  ip_setsockopt+0xdf/0x100 net/ipv4/ip_sockglue.c:1240
  udp_setsockopt+0x68/0xb0 net/ipv4/udp.c:2639
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
  __sys_setsockopt+0x261/0x4c0 net/socket.c:2117
  __do_sys_setsockopt net/socket.c:2133 [inline]
  __se_sys_setsockopt net/socket.c:2130 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2130
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4412b9
Code: 0a 72 65 73 6f 72 74 2c 20 79 6f 75 20 6d 61 79 20 77 61 6e 74 20 74  
6f 20 72 65 6d 6f 76 65 20 24 41 62 6f 72 74 4f 6e 55 6e <63> 6c 65 61 6e  
43 6f 6e 66 69 67 20 74 6f 20 70 65 72 6d 69 74 20
RSP: 002b:00007ffc9723f3f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004412b9
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00000000000c7176 R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000020000500 R11: 0000000000000246 R12: 0000000000402030
R13: 00000000004020c0 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor013:10030 blocked for more than 144 seconds.
       Not tainted 5.5.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor013 D28160 10030  10014 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
  __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
  hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
  hashlimit_mt_check_v2+0x327/0x3b0 net/netfilter/xt_hashlimit.c:950
  xt_check_match+0x280/0x690 net/netfilter/x_tables.c:501
  check_match net/ipv4/netfilter/ip_tables.c:472 [inline]
  find_check_match net/ipv4/netfilter/ip_tables.c:488 [inline]
  find_check_entry.isra.0+0x32f/0x920 net/ipv4/netfilter/ip_tables.c:538
  translate_table+0xcb4/0x17d0 net/ipv4/netfilter/ip_tables.c:717
  do_replace net/ipv4/netfilter/ip_tables.c:1136 [inline]
  do_ipt_set_ctl+0x2fe/0x4c2 net/ipv4/netfilter/ip_tables.c:1672
  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
  nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
  ip_setsockopt net/ipv4/ip_sockglue.c:1260 [inline]
  ip_setsockopt+0xdf/0x100 net/ipv4/ip_sockglue.c:1240
  udp_setsockopt+0x68/0xb0 net/ipv4/udp.c:2639
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
  __sys_setsockopt+0x261/0x4c0 net/socket.c:2117
  __do_sys_setsockopt net/socket.c:2133 [inline]
  __se_sys_setsockopt net/socket.c:2130 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2130
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4412b9
Code: 0a 72 65 73 6f 72 74 2c 20 79 6f 75 20 6d 61 79 20 77 61 6e 74 20 74  
6f 20 72 65 6d 6f 76 65 20 24 41 62 6f 72 74 4f 6e 55 6e <63> 6c 65 61 6e  
43 6f 6e 66 69 67 20 74 6f 20 70 65 72 6d 69 74 20
RSP: 002b:00007ffc9723f3f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004412b9
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00000000000c84a6 R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000020000500 R11: 0000000000000246 R12: 0000000000402030
R13: 00000000004020c0 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor013:10031 blocked for more than 144 seconds.
       Not tainted 5.5.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor013 D28160 10031  10015 0x00004004
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
  __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
  hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
  hashlimit_mt_check_v2+0x327/0x3b0 net/netfilter/xt_hashlimit.c:950
  xt_check_match+0x280/0x690 net/netfilter/x_tables.c:501
  check_match net/ipv4/netfilter/ip_tables.c:472 [inline]
  find_check_match net/ipv4/netfilter/ip_tables.c:488 [inline]
  find_check_entry.isra.0+0x32f/0x920 net/ipv4/netfilter/ip_tables.c:538
  translate_table+0xcb4/0x17d0 net/ipv4/netfilter/ip_tables.c:717
  do_replace net/ipv4/netfilter/ip_tables.c:1136 [inline]
  do_ipt_set_ctl+0x2fe/0x4c2 net/ipv4/netfilter/ip_tables.c:1672
  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
  nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
  ip_setsockopt net/ipv4/ip_sockglue.c:1260 [inline]
  ip_setsockopt+0xdf/0x100 net/ipv4/ip_sockglue.c:1240
  udp_setsockopt+0x68/0xb0 net/ipv4/udp.c:2639
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
  __sys_setsockopt+0x261/0x4c0 net/socket.c:2117
  __do_sys_setsockopt net/socket.c:2133 [inline]
  __se_sys_setsockopt net/socket.c:2130 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2130
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4412b9
Code: 0a 72 65 73 6f 72 74 2c 20 79 6f 75 20 6d 61 79 20 77 61 6e 74 20 74  
6f 20 72 65 6d 6f 76 65 20 24 41 62 6f 72 74 4f 6e 55 6e <63> 6c 65 61 6e  
43 6f 6e 66 69 67 20 74 6f 20 70 65 72 6d 69 74 20
RSP: 002b:00007ffc9723f3f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004412b9
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00000000000c84a6 R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000020000500 R11: 0000000000000246 R12: 0000000000402030
R13: 00000000004020c0 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor013:10032 blocked for more than 144 seconds.
       Not tainted 5.5.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor013 D28160 10032  10012 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
  __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
  hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
  hashlimit_mt_check_v2+0x327/0x3b0 net/netfilter/xt_hashlimit.c:950
  xt_check_match+0x280/0x690 net/netfilter/x_tables.c:501
  check_match net/ipv4/netfilter/ip_tables.c:472 [inline]
  find_check_match net/ipv4/netfilter/ip_tables.c:488 [inline]
  find_check_entry.isra.0+0x32f/0x920 net/ipv4/netfilter/ip_tables.c:538
  translate_table+0xcb4/0x17d0 net/ipv4/netfilter/ip_tables.c:717
  do_replace net/ipv4/netfilter/ip_tables.c:1136 [inline]
  do_ipt_set_ctl+0x2fe/0x4c2 net/ipv4/netfilter/ip_tables.c:1672
  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
  nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
  ip_setsockopt net/ipv4/ip_sockglue.c:1260 [inline]
  ip_setsockopt+0xdf/0x100 net/ipv4/ip_sockglue.c:1240
  udp_setsockopt+0x68/0xb0 net/ipv4/udp.c:2639
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
  __sys_setsockopt+0x261/0x4c0 net/socket.c:2117
  __do_sys_setsockopt net/socket.c:2133 [inline]
  __se_sys_setsockopt net/socket.c:2130 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2130
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4412b9
Code: 0a 72 65 73 6f 72 74 2c 20 79 6f 75 20 6d 61 79 20 77 61 6e 74 20 74  
6f 20 72 65 6d 6f 76 65 20 24 41 62 6f 72 74 4f 6e 55 6e <63> 6c 65 61 6e  
43 6f 6e 66 69 67 20 74 6f 20 70 65 72 6d 69 74 20
RSP: 002b:00007ffc9723f3f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004412b9
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00000000000c84a7 R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000020000500 R11: 0000000000000246 R12: 0000000000402030
R13: 00000000004020c0 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor013:10033 blocked for more than 145 seconds.
       Not tainted 5.5.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor013 D28160 10033  10016 0x00004004
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
  __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
  hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
  hashlimit_mt_check_v2+0x327/0x3b0 net/netfilter/xt_hashlimit.c:950
  xt_check_match+0x280/0x690 net/netfilter/x_tables.c:501
  check_match net/ipv4/netfilter/ip_tables.c:472 [inline]
  find_check_match net/ipv4/netfilter/ip_tables.c:488 [inline]
  find_check_entry.isra.0+0x32f/0x920 net/ipv4/netfilter/ip_tables.c:538
  translate_table+0xcb4/0x17d0 net/ipv4/netfilter/ip_tables.c:717
  do_replace net/ipv4/netfilter/ip_tables.c:1136 [inline]
  do_ipt_set_ctl+0x2fe/0x4c2 net/ipv4/netfilter/ip_tables.c:1672
  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
  nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
  ip_setsockopt net/ipv4/ip_sockglue.c:1260 [inline]
  ip_setsockopt+0xdf/0x100 net/ipv4/ip_sockglue.c:1240
  udp_setsockopt+0x68/0xb0 net/ipv4/udp.c:2639
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
  __sys_setsockopt+0x261/0x4c0 net/socket.c:2117
  __do_sys_setsockopt net/socket.c:2133 [inline]
  __se_sys_setsockopt net/socket.c:2130 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2130
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4412b9
Code: 0a 72 65 73 6f 72 74 2c 20 79 6f 75 20 6d 61 79 20 77 61 6e 74 20 74  
6f 20 72 65 6d 6f 76 65 20 24 41 62 6f 72 74 4f 6e 55 6e <63> 6c 65 61 6e  
43 6f 6e 66 69 67 20 74 6f 20 70 65 72 6d 69 74 20
RSP: 002b:00007ffc9723f3f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004412b9
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00000000000c84a2 R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000020000500 R11: 0000000000000246 R12: 0000000000402030
R13: 00000000004020c0 R14: 0000000000000000 R15: 0000000000000000

Showing all locks held in the system:
1 lock held by khungtaskd/1114:
  #0: ffffffff899a5680 (rcu_read_lock){....}, at:  
debug_show_all_locks+0x5f/0x279 kernel/locking/lockdep.c:5334
3 locks held by kworker/0:92/3036:
1 lock held by rsyslogd/9860:
  #0: ffff888095c665e0 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110  
fs/file.c:801
2 locks held by getty/9982:
  #0: ffff88809875e090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900017cb2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9983:
  #0: ffff8880864d9090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900017db2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9984:
  #0: ffff8880a8c78090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000185b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9985:
  #0: ffff888096bdd090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000184b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9986:
  #0: ffff888097e13090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000183b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9987:
  #0: ffff888082318090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900017fb2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9988:
  #0: ffff88821526f090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900011202e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
1 lock held by syz-executor013/10018:
  #0: ffffffff8a5393e0 (hashlimit_mutex){+.+.}, at: htable_put+0x21/0x220  
net/netfilter/xt_hashlimit.c:446
1 lock held by syz-executor013/10029:
  #0: ffffffff8a5393e0 (hashlimit_mutex){+.+.}, at:  
hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
1 lock held by syz-executor013/10030:
  #0: ffffffff8a5393e0 (hashlimit_mutex){+.+.}, at:  
hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
1 lock held by syz-executor013/10031:
  #0: ffffffff8a5393e0 (hashlimit_mutex){+.+.}, at:  
hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
1 lock held by syz-executor013/10032:
  #0: ffffffff8a5393e0 (hashlimit_mutex){+.+.}, at:  
hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
1 lock held by syz-executor013/10033:
  #0: ffffffff8a5393e0 (hashlimit_mutex){+.+.}, at:  
hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1114 Comm: khungtaskd Not tainted 5.5.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
  check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
  watchdog+0xb11/0x10c0 kernel/hung_task.c:289
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 3036 Comm: kworker/0:92 Not tainted 5.5.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events_power_efficient htable_gc
RIP: 0010:__lock_acquire+0x1bc/0x4a00 kernel/locking/lockdep.c:3864
Code: 2f 0f 87 bf 18 00 00 49 8d bb 98 08 00 00 49 81 ec 80 e1 2c 8b 48 b8  
a3 8b 2e ba e8 a2 8b 2e 49 c1 fc 04 48 89 bd 60 ff ff ff <4c> 0f af e0 8b  
85 70 ff ff ff 4c 8d 14 80 49 c1 e2 03 85 c0 74 46
RSP: 0018:ffffc9000853fae8 EFLAGS: 00000006
RAX: 2e8ba2e8ba2e8ba3 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88809e498dd8
RBP: ffffc9000853fc00 R08: 0000000000000001 R09: 0000000000000001
R10: fffffbfff14f3320 R11: ffff88809e498540 R12: 0000000000003d72
R13: 0000000000000000 R14: ffffc9000d431060 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000500 CR3: 000000009624d000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4485
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  htable_selective_cleanup+0xa6/0x330 net/netfilter/xt_hashlimit.c:382
  htable_gc+0x26/0xc0 net/netfilter/xt_hashlimit.c:398
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2264
  worker_thread+0x98/0xe40 kernel/workqueue.c:2410
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
