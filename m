Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63009141CF1
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 09:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgASIRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 03:17:10 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:50526 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgASIRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 03:17:10 -0500
Received: by mail-il1-f200.google.com with SMTP id z12so22605532ilh.17
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 00:17:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=/guCOx5lMdx+Zdu9nfOmHH8Mcgn3glUDb7n9t31wdDk=;
        b=aPHLH3rmXaoAKyeUlDcKPtO6gtWoxuEoXWOAKnD4jNz60ZiEMul/AU9j7EQXb5s1f0
         QC8tlnNjuMcmsowIEgnAcjcDzeT4nnWI1AxVm3qxrI+mpsor+iVcb7DJdJB0BVTRwGmf
         /2ljZYDOBG9wYsKwIQJxut40+xC+2k7GSoEZMpuytfcCKbzQpa2KFtrMOPwDBG17c9FO
         CEPodrSXNpndNf63d/+0H/mR07zBYbtM7kfz/I2v0NhAdh75mN92wPSGo7YmBjPv/Xu+
         OWGr+lOyUhxdDGWFm7jaFWr3nVcc4HtmFtr33k0e3q1tx+vmWacdXpM8nidVZrhRGc98
         9zWQ==
X-Gm-Message-State: APjAAAUX3OyYcPvzl1g6WIquVl3rXGdVThiJDKRlkG6NjXOTuR6A0WZA
        R3n9YYImgHKeWIbu+turVR02NosXRua58ukVQCiqqiRSdtiR
X-Google-Smtp-Source: APXvYqwywpU6xaALmMiK6Ov5mNKPuUiL6Eb11XoWNZARmLrshjQiEzsQ2JuPIqXT22Air/BHkI6lcAXwUkNR8ME3BU9FeEbYJdA2
MIME-Version: 1.0
X-Received: by 2002:a6b:4407:: with SMTP id r7mr17757611ioa.160.1579421829216;
 Sun, 19 Jan 2020 00:17:09 -0800 (PST)
Date:   Sun, 19 Jan 2020 00:17:09 -0800
In-Reply-To: <000000000000466b64059bcb3843@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000014be95059c79cd19@google.com>
Subject: Re: INFO: task hung in hashlimit_mt_check_common
From:   syzbot <syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    9aaa2949 Merge branch '1GbE' of git://git.kernel.org/pub/s..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=167bb1d1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66d8660c57ff3c98
dashboard link: https://syzkaller.appspot.com/bug?extid=adf6c6c2be1c3a718121
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15a3fa85e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16bac135e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com

INFO: task syz-executor555:10053 blocked for more than 143 seconds.
      Not tainted 5.5.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor555 D27640 10053  10049 0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3385 [inline]
 __schedule+0x934/0x1f90 kernel/sched/core.c:4081
 schedule+0xdc/0x2b0 kernel/sched/core.c:4155
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
 mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
 hashlimit_mt_check_common.isra.0+0x341/0x1500 net/netfilter/xt_hashlimit.c:903
 hashlimit_mt_check_v1+0x325/0x3ab net/netfilter/xt_hashlimit.c:932
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
 tcp_setsockopt net/ipv4/tcp.c:3158 [inline]
 tcp_setsockopt+0x8f/0xe0 net/ipv4/tcp.c:3152
 sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
 __sys_setsockopt+0x261/0x4c0 net/socket.c:2130
 __do_sys_setsockopt net/socket.c:2146 [inline]
 __se_sys_setsockopt net/socket.c:2143 [inline]
 __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2143
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441269
Code: 66 69 67 20 69 73 20 6e 6f 74 20 63 6c 65 61 6e 2e 0a 43 68 65 63 6b 20 65 72 72 6f 72 20 6c 6f 67 20 66 6f 72 20 64 65 74 61 <69> 6c 73 2c 20 66 69 78 20 65 72 72 6f 72 73 20 61 6e 64 20 72 65
RSP: 002b:00007ffe1774d8c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441269
RDX: 0000000000000040 RSI: 0004000000000000 RDI: 0000000000000003
RBP: 00000000006cc018 R08: 0000000000000509 R09: 00000000004002c8
R10: 00000000200002c0 R11: 0000000000000246 R12: 0000000000401fe0
R13: 0000000000402070 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor555:10054 blocked for more than 143 seconds.
      Not tainted 5.5.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor555 D28160 10054  10051 0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3385 [inline]
 __schedule+0x934/0x1f90 kernel/sched/core.c:4081
 schedule+0xdc/0x2b0 kernel/sched/core.c:4155
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
 mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
 hashlimit_mt_check_common.isra.0+0x341/0x1500 net/netfilter/xt_hashlimit.c:903
 hashlimit_mt_check_v1+0x325/0x3ab net/netfilter/xt_hashlimit.c:932
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
 tcp_setsockopt net/ipv4/tcp.c:3158 [inline]
 tcp_setsockopt+0x8f/0xe0 net/ipv4/tcp.c:3152
 sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
 __sys_setsockopt+0x261/0x4c0 net/socket.c:2130
 __do_sys_setsockopt net/socket.c:2146 [inline]
 __se_sys_setsockopt net/socket.c:2143 [inline]
 __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2143
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441269
Code: 66 69 67 20 69 73 20 6e 6f 74 20 63 6c 65 61 6e 2e 0a 43 68 65 63 6b 20 65 72 72 6f 72 20 6c 6f 67 20 66 6f 72 20 64 65 74 61 <69> 6c 73 2c 20 66 69 78 20 65 72 72 6f 72 73 20 61 6e 64 20 72 65
RSP: 002b:00007ffe1774d8c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441269
RDX: 0000000000000040 RSI: 0004000000000000 RDI: 0000000000000003
RBP: 00000000006cc018 R08: 0000000000000509 R09: 00000000004002c8
R10: 00000000200002c0 R11: 0000000000000246 R12: 0000000000401fe0
R13: 0000000000402070 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor555:10055 blocked for more than 144 seconds.
      Not tainted 5.5.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor555 D28160 10055  10052 0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3385 [inline]
 __schedule+0x934/0x1f90 kernel/sched/core.c:4081
 schedule+0xdc/0x2b0 kernel/sched/core.c:4155
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
 mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
 hashlimit_mt_check_common.isra.0+0x341/0x1500 net/netfilter/xt_hashlimit.c:903
 hashlimit_mt_check_v1+0x325/0x3ab net/netfilter/xt_hashlimit.c:932
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
 tcp_setsockopt net/ipv4/tcp.c:3158 [inline]
 tcp_setsockopt+0x8f/0xe0 net/ipv4/tcp.c:3152
 sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
 __sys_setsockopt+0x261/0x4c0 net/socket.c:2130
 __do_sys_setsockopt net/socket.c:2146 [inline]
 __se_sys_setsockopt net/socket.c:2143 [inline]
 __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2143
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441269
Code: 66 69 67 20 69 73 20 6e 6f 74 20 63 6c 65 61 6e 2e 0a 43 68 65 63 6b 20 65 72 72 6f 72 20 6c 6f 67 20 66 6f 72 20 64 65 74 61 <69> 6c 73 2c 20 66 69 78 20 65 72 72 6f 72 73 20 61 6e 64 20 72 65
RSP: 002b:00007ffe1774d8c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441269
RDX: 0000000000000040 RSI: 0004000000000000 RDI: 0000000000000003
RBP: 00000000006cc018 R08: 0000000000000509 R09: 00000000004002c8
R10: 00000000200002c0 R11: 0000000000000246 R12: 0000000000401fe0
R13: 0000000000402070 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor555:10056 blocked for more than 144 seconds.
      Not tainted 5.5.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor555 D27792 10056  10047 0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3385 [inline]
 __schedule+0x934/0x1f90 kernel/sched/core.c:4081
 schedule+0xdc/0x2b0 kernel/sched/core.c:4155
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
 mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
 hashlimit_mt_check_common.isra.0+0x341/0x1500 net/netfilter/xt_hashlimit.c:903
 hashlimit_mt_check_v1+0x325/0x3ab net/netfilter/xt_hashlimit.c:932
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
 tcp_setsockopt net/ipv4/tcp.c:3158 [inline]
 tcp_setsockopt+0x8f/0xe0 net/ipv4/tcp.c:3152
 sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
 __sys_setsockopt+0x261/0x4c0 net/socket.c:2130
 __do_sys_setsockopt net/socket.c:2146 [inline]
 __se_sys_setsockopt net/socket.c:2143 [inline]
 __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2143
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441269
Code: 66 69 67 20 69 73 20 6e 6f 74 20 63 6c 65 61 6e 2e 0a 43 68 65 63 6b 20 65 72 72 6f 72 20 6c 6f 67 20 66 6f 72 20 64 65 74 61 <69> 6c 73 2c 20 66 69 78 20 65 72 72 6f 72 73 20 61 6e 64 20 72 65
RSP: 002b:00007ffe1774d8c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441269
RDX: 0000000000000040 RSI: 0004000000000000 RDI: 0000000000000003
RBP: 00000000006cc018 R08: 0000000000000509 R09: 00000000004002c8
R10: 00000000200002c0 R11: 0000000000000246 R12: 0000000000401fe0
R13: 0000000000402070 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor555:10058 blocked for more than 145 seconds.
      Not tainted 5.5.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor555 D28160 10058  10050 0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3385 [inline]
 __schedule+0x934/0x1f90 kernel/sched/core.c:4081
 schedule+0xdc/0x2b0 kernel/sched/core.c:4155
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
 mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
 hashlimit_mt_check_common.isra.0+0x341/0x1500 net/netfilter/xt_hashlimit.c:903
 hashlimit_mt_check_v1+0x325/0x3ab net/netfilter/xt_hashlimit.c:932
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
 tcp_setsockopt net/ipv4/tcp.c:3158 [inline]
 tcp_setsockopt+0x8f/0xe0 net/ipv4/tcp.c:3152
 sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
 __sys_setsockopt+0x261/0x4c0 net/socket.c:2130
 __do_sys_setsockopt net/socket.c:2146 [inline]
 __se_sys_setsockopt net/socket.c:2143 [inline]
 __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2143
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441269
Code: 66 69 67 20 69 73 20 6e 6f 74 20 63 6c 65 61 6e 2e 0a 43 68 65 63 6b 20 65 72 72 6f 72 20 6c 6f 67 20 66 6f 72 20 64 65 74 61 <69> 6c 73 2c 20 66 69 78 20 65 72 72 6f 72 73 20 61 6e 64 20 72 65
RSP: 002b:00007ffe1774d8c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441269
RDX: 0000000000000040 RSI: 0004000000000000 RDI: 0000000000000003
RBP: 00000000000c318f R08: 0000000000000509 R09: 00000009004002c8
R10: 00000000200002c0 R11: 0000000000000246 R12: 0000000000401fe0
R13: 0000000000402070 R14: 0000000000000000 R15: 0000000000000000

Showing all locks held in the system:
1 lock held by khungtaskd/1121:
 #0: ffffffff899a3f40 (rcu_read_lock){....}, at: debug_show_all_locks+0x5f/0x279 kernel/locking/lockdep.c:5334
3 locks held by rs:main Q:Reg/9929:
 #0: ffff8880ae837358 (&rq->lock){-.-.}, at: rq_lock kernel/sched/sched.h:1215 [inline]
 #0: ffff8880ae837358 (&rq->lock){-.-.}, at: __schedule+0x232/0x1f90 kernel/sched/core.c:4029
 #1: ffffffff899a3f40 (rcu_read_lock){....}, at: file_start_write include/linux/fs.h:2885 [inline]
 #1: ffffffff899a3f40 (rcu_read_lock){....}, at: vfs_write+0x485/0x5d0 fs/read_write.c:557
 #2: ffff888091a3b588 (&sb->s_type->i_mutex_key#11){+.+.}, at: inode_lock include/linux/fs.h:791 [inline]
 #2: ffff888091a3b588 (&sb->s_type->i_mutex_key#11){+.+.}, at: ext4_buffered_write_iter+0xba/0x460 fs/ext4/file.c:246
1 lock held by rsyslogd/9931:
 #0: ffff8880a26511a0 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110 fs/file.c:801
2 locks held by getty/10021:
 #0: ffff888098196090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc9000174b2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10022:
 #0: ffff888093340090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc900017eb2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10023:
 #0: ffff8880a7891090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc900017ab2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10024:
 #0: ffff88809400f090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc900017db2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10025:
 #0: ffff888097d44090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc900017bb2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10026:
 #0: ffff88809243e090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc900017cb2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10027:
 #0: ffff8880a6821090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc9000172b2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
1 lock held by syz-executor555/10048:
1 lock held by syz-executor555/10053:
 #0: ffffffff8a562ee0 (hashlimit_mutex){+.+.}, at: hashlimit_mt_check_common.isra.0+0x341/0x1500 net/netfilter/xt_hashlimit.c:903
1 lock held by syz-executor555/10054:
 #0: ffffffff8a562ee0 (hashlimit_mutex){+.+.}, at: hashlimit_mt_check_common.isra.0+0x341/0x1500 net/netfilter/xt_hashlimit.c:903
1 lock held by syz-executor555/10055:
 #0: ffffffff8a562ee0 (hashlimit_mutex){+.+.}, at: hashlimit_mt_check_common.isra.0+0x341/0x1500 net/netfilter/xt_hashlimit.c:903
1 lock held by syz-executor555/10056:
 #0: ffffffff8a562ee0 (hashlimit_mutex){+.+.}, at: hashlimit_mt_check_common.isra.0+0x341/0x1500 net/netfilter/xt_hashlimit.c:903
1 lock held by syz-executor555/10058:
 #0: ffffffff8a562ee0 (hashlimit_mutex){+.+.}, at: hashlimit_mt_check_common.isra.0+0x341/0x1500 net/netfilter/xt_hashlimit.c:903

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1121 Comm: khungtaskd Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
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
CPU: 0 PID: 10048 Comm: syz-executor555 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_lockdep_rcu_enabled+0x53/0xa0 kernel/rcu/update.c:251
Code: 04 84 d2 75 49 8b 15 9c 4b 1b 09 85 d2 74 3b 48 c7 c0 34 b6 7c 8a 48 ba 00 00 00 00 00 fc ff df 48 89 c1 83 e0 07 48 c1 e9 03 <83> c0 03 0f b6 14 11 38 d0 7c 04 84 d2 75 23 8b 05 6c 7c 1b 09 85
RSP: 0018:ffffc900020f7758 EFLAGS: 00000a07
RAX: 0000000000000004 RBX: 0000000000000000 RCX: 1ffffffff14f96c6
RDX: dffffc0000000000 RSI: ffffffff899a3f00 RDI: 0000000000000282
RBP: ffffc900020f7758 R08: 1ffffffff16611b1 R09: fffffbfff16611b2
R10: fffffbfff16611b1 R11: ffffffff8b308d8f R12: ffffffff88de1100
R13: 0000000000000184 R14: ffffc9000d74a000 R15: 000000000dbd6db6
FS:  00000000026be880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 00000000a0663000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ___might_sleep+0x30/0x2c0 kernel/sched/core.c:6765
 htable_selective_cleanup+0x22c/0x330 net/netfilter/xt_hashlimit.c:388
 htable_destroy net/netfilter/xt_hashlimit.c:422 [inline]
 htable_put+0x176/0x220 net/netfilter/xt_hashlimit.c:449
 hashlimit_mt_destroy_v1+0x50/0x70 net/netfilter/xt_hashlimit.c:978
 cleanup_match+0xde/0x170 net/ipv6/netfilter/ip6_tables.c:478
 find_check_entry.isra.0+0x454/0x920 net/ipv4/netfilter/ip_tables.c:564
 translate_table+0xcb4/0x17d0 net/ipv4/netfilter/ip_tables.c:717
 do_replace net/ipv4/netfilter/ip_tables.c:1136 [inline]
 do_ipt_set_ctl+0x2fe/0x4c2 net/ipv4/netfilter/ip_tables.c:1672
 nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
 nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
 ip_setsockopt net/ipv4/ip_sockglue.c:1260 [inline]
 ip_setsockopt+0xdf/0x100 net/ipv4/ip_sockglue.c:1240
 tcp_setsockopt net/ipv4/tcp.c:3158 [inline]
 tcp_setsockopt+0x8f/0xe0 net/ipv4/tcp.c:3152
 sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
 __sys_setsockopt+0x261/0x4c0 net/socket.c:2130
 __do_sys_setsockopt net/socket.c:2146 [inline]
 __se_sys_setsockopt net/socket.c:2143 [inline]
 __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2143
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441269
Code: e8 ac e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe1774d8c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441269
RDX: 0000000000000040 RSI: 0004000000000000 RDI: 0000000000000003
RBP: 00000000006cc018 R08: 0000000000000509 R09: 00000000004002c8
R10: 00000000200002c0 R11: 0000000000000246 R12: 0000000000401fe0
R13: 0000000000402070 R14: 0000000000000000 R15: 0000000000000000

