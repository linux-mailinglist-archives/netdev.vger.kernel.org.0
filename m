Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBAF3ECA48
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 18:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbhHOQry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 12:47:54 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:34528 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhHOQrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 12:47:52 -0400
Received: by mail-il1-f198.google.com with SMTP id d17-20020a9287510000b0290223c9088c96so8304137ilm.1
        for <netdev@vger.kernel.org>; Sun, 15 Aug 2021 09:47:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4u6e+Oil2S39cgjanzC4P/rDz71Nf/GOHI/svT7/rUo=;
        b=MYGjAhDr7wGXfmlU+qlnT0ArYnU4b1vawQSgXoCkMv19Awj9UihPYvHVYO7YveSY9+
         ZGuXOupcZ7L+ovXsobj+jA/HeocBpQp6d8NPG8ZNJEuhSHeODSRRpg9KUxqvQsWGs51d
         HEJ8L1G1SxFkAMO4bb26SyxwmynrXXV6jK5LiX9aVu4hLXMmTzq5T8nc1iHZxXfHhdRt
         AT2F+o3xIM/InR15g5miirXolNRS114Gg2IATfAelFjnA4YVgqGaK2pPsd3j52B0/cw2
         NX+8Asnt3CTdI3bxqFRAqTnbyNrM+ZRY1jD+MYxnGyDrTRV/XfUJT63tiDUV6wd/ZmHG
         1mxw==
X-Gm-Message-State: AOAM532Wey4GSJ2MnvuZJyHUmqeeyDfxRln2x1gsIvvzRRhiN057uf/O
        DY1PdjtzVDR0HkPG+9r5f5IZoQzXcheyL4lix8zn7A9yMtir
X-Google-Smtp-Source: ABdhPJw5fGRJ33Q1jY5VAb8XtKYUYzcBe/LYhZgRjogvz3szE/3V4wzGz9XXS1WOHwAOqW41Qc5cD2U1Cck3cj9yWuxXnoz1H6Rg
MIME-Version: 1.0
X-Received: by 2002:a5e:d91a:: with SMTP id n26mr9444745iop.96.1629046042639;
 Sun, 15 Aug 2021 09:47:22 -0700 (PDT)
Date:   Sun, 15 Aug 2021 09:47:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b1c39505c99bd67c@google.com>
Subject: [syzbot] INFO: task can't die in __lock_sock
From:   syzbot <syzbot+7d51f807c81b190a127d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4b358aabb93a Add linux-next specific files for 20210813
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1603f181300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b99612666fbe2d6a
dashboard link: https://syzkaller.appspot.com/bug?extid=7d51f807c81b190a127d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7d51f807c81b190a127d@syzkaller.appspotmail.com

INFO: task syz-executor.4:21120 can't die for more than 143 seconds.
task:syz-executor.4  state:D stack:28448 pid:21120 ppid:  6572 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4711 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:5966
 schedule+0xd3/0x270 kernel/sched/core.c:6045
 __lock_sock+0x13d/0x260 net/core/sock.c:2645
 lock_sock_nested+0xf6/0x120 net/core/sock.c:3178
 lock_sock include/net/sock.h:1612 [inline]
 bt_sock_wait_state+0x249/0x590 net/bluetooth/af_bluetooth.c:557
 rfcomm_sock_connect+0x3a5/0x460 net/bluetooth/rfcomm/sock.c:416
 __sys_connect_file+0x155/0x1a0 net/socket.c:1890
 __sys_connect+0x161/0x190 net/socket.c:1907
 __do_sys_connect net/socket.c:1917 [inline]
 __se_sys_connect net/socket.c:1914 [inline]
 __x64_sys_connect+0x6f/0xb0 net/socket.c:1914
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
RSP: 002b:00007fa7b02bf188 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665e9
RDX: 0000000000000080 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007fffd83567bf R14: 00007fa7b02bf300 R15: 0000000000022000
INFO: task syz-executor.4:21120 blocked for more than 143 seconds.
      Not tainted 5.14.0-rc5-next-20210813-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.4  state:D stack:28448 pid:21120 ppid:  6572 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4711 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:5966
 schedule+0xd3/0x270 kernel/sched/core.c:6045
 __lock_sock+0x13d/0x260 net/core/sock.c:2645
 lock_sock_nested+0xf6/0x120 net/core/sock.c:3178
 lock_sock include/net/sock.h:1612 [inline]
 bt_sock_wait_state+0x249/0x590 net/bluetooth/af_bluetooth.c:557
 rfcomm_sock_connect+0x3a5/0x460 net/bluetooth/rfcomm/sock.c:416
 __sys_connect_file+0x155/0x1a0 net/socket.c:1890
 __sys_connect+0x161/0x190 net/socket.c:1907
 __do_sys_connect net/socket.c:1917 [inline]
 __se_sys_connect net/socket.c:1914 [inline]
 __x64_sys_connect+0x6f/0xb0 net/socket.c:1914
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
RSP: 002b:00007fa7b02bf188 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665e9
RDX: 0000000000000080 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007fffd83567bf R14: 00007fa7b02bf300 R15: 0000000000022000
INFO: task syz-executor.4:21124 can't die for more than 143 seconds.
task:syz-executor.4  state:D stack:29104 pid:21124 ppid:  6572 flags:0x00000004
Call Trace:
 context_switch kernel/sched/core.c:4711 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:5966
 schedule+0xd3/0x270 kernel/sched/core.c:6045
 __lock_sock+0x13d/0x260 net/core/sock.c:2645
 lock_sock_nested+0xf6/0x120 net/core/sock.c:3178
 lock_sock include/net/sock.h:1612 [inline]
 rfcomm_sk_state_change+0xb4/0x390 net/bluetooth/rfcomm/sock.c:73
 __rfcomm_dlc_close+0x1b6/0x8a0 net/bluetooth/rfcomm/core.c:489
 rfcomm_dlc_close+0x1ea/0x240 net/bluetooth/rfcomm/core.c:520
 __rfcomm_sock_close+0xac/0x260 net/bluetooth/rfcomm/sock.c:220
 rfcomm_sock_shutdown+0xe9/0x210 net/bluetooth/rfcomm/sock.c:931
 __sys_shutdown_sock net/socket.c:2242 [inline]
 __sys_shutdown_sock net/socket.c:2236 [inline]
 __sys_shutdown+0xf1/0x1b0 net/socket.c:2254
 __do_sys_shutdown net/socket.c:2262 [inline]
 __se_sys_shutdown net/socket.c:2260 [inline]
 __x64_sys_shutdown+0x50/0x70 net/socket.c:2260
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
RSP: 002b:00007fa7b029e188 EFLAGS: 00000246 ORIG_RAX: 0000000000000030
RAX: ffffffffffffffda RBX: 000000000056c038 RCX: 00000000004665e9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c038
R13: 00007fffd83567bf R14: 00007fa7b029e300 R15: 0000000000022000
INFO: task syz-executor.4:21124 blocked for more than 143 seconds.
      Not tainted 5.14.0-rc5-next-20210813-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.4  state:D stack:29104 pid:21124 ppid:  6572 flags:0x00000004
Call Trace:
 context_switch kernel/sched/core.c:4711 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:5966
 schedule+0xd3/0x270 kernel/sched/core.c:6045
 __lock_sock+0x13d/0x260 net/core/sock.c:2645
 lock_sock_nested+0xf6/0x120 net/core/sock.c:3178
 lock_sock include/net/sock.h:1612 [inline]
 rfcomm_sk_state_change+0xb4/0x390 net/bluetooth/rfcomm/sock.c:73
 __rfcomm_dlc_close+0x1b6/0x8a0 net/bluetooth/rfcomm/core.c:489
 rfcomm_dlc_close+0x1ea/0x240 net/bluetooth/rfcomm/core.c:520
 __rfcomm_sock_close+0xac/0x260 net/bluetooth/rfcomm/sock.c:220
 rfcomm_sock_shutdown+0xe9/0x210 net/bluetooth/rfcomm/sock.c:931
 __sys_shutdown_sock net/socket.c:2242 [inline]
 __sys_shutdown_sock net/socket.c:2236 [inline]
 __sys_shutdown+0xf1/0x1b0 net/socket.c:2254
 __do_sys_shutdown net/socket.c:2262 [inline]
 __se_sys_shutdown net/socket.c:2260 [inline]
 __x64_sys_shutdown+0x50/0x70 net/socket.c:2260
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
RSP: 002b:00007fa7b029e188 EFLAGS: 00000246 ORIG_RAX: 0000000000000030
RAX: ffffffffffffffda RBX: 000000000056c038 RCX: 00000000004665e9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c038
R13: 00007fffd83567bf R14: 00007fa7b029e300 R15: 0000000000022000
INFO: lockdep is turned off.
NMI backtrace for cpu 1
CPU: 1 PID: 27 Comm: khungtaskd Not tainted 5.14.0-rc5-next-20210813-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:254 [inline]
 watchdog+0xcb7/0xed0 kernel/hung_task.c:339
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 6267 Comm: in:imklog Not tainted 5.14.0-rc5-next-20210813-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__sanitizer_cov_trace_pc+0x37/0x60 kernel/kcov.c:197
Code: 81 e1 00 01 00 00 65 48 8b 14 25 40 f0 01 00 a9 00 01 ff 00 74 0e 85 c9 74 35 8b 82 3c 15 00 00 85 c0 74 2b 8b 82 18 15 00 00 <83> f8 02 75 20 48 8b 8a 20 15 00 00 8b 92 1c 15 00 00 48 8b 01 48
RSP: 0018:ffffc9000c577648 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8880775b9c80 RSI: ffffffff83f260b5 RDI: 0000000000000003
RBP: 0000000000000000 R08: 000000000000002f R09: 0000000000000000
R10: ffffffff83f26037 R11: 0000000000000000 R12: 0000000000000004
R13: ffffffff898ca243 R14: ffffc9008c577a4f R15: ffffc9000c577a51
FS:  00007f9245542700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9a4b72b008 CR3: 000000006fe68000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 number+0x205/0xae0 lib/vsprintf.c:490
 vsnprintf+0xf09/0x14f0 lib/vsprintf.c:2875
 sprintf+0xc0/0x100 lib/vsprintf.c:3011
 print_syslog kernel/printk/printk.c:1257 [inline]
 info_print_prefix+0x2d5/0x340 kernel/printk/printk.c:1287
 record_print_text+0x14d/0x3e0 kernel/printk/printk.c:1339
 syslog_print+0x48c/0x580 kernel/printk/printk.c:1539
 do_syslog.part.0+0x202/0x640 kernel/printk/printk.c:1658
 do_syslog+0x49/0x60 kernel/printk/printk.c:1643
 kmsg_read+0x90/0xb0 fs/proc/kmsg.c:40
 pde_read fs/proc/inode.c:311 [inline]
 proc_reg_read+0x119/0x300 fs/proc/inode.c:321
 vfs_read+0x1b5/0x600 fs/read_write.c:494
 ksys_read+0x12d/0x250 fs/read_write.c:634
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f9247b8522d
Code: c1 20 00 00 75 10 b8 00 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 4e fc ff ff 48 89 04 24 b8 00 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 97 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007f9245521580 EFLAGS: 00000293 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f9247b8522d
RDX: 0000000000001fa0 RSI: 00007f9245521da0 RDI: 0000000000000004
RBP: 000055eb855a59d0 R08: 0000000000000000 R09: 0000000004000001
R10: 0000000000000001 R11: 0000000000000293 R12: 00007f9245521da0
R13: 0000000000001fa0 R14: 0000000000001f9f R15: 00007f9245521dd7
----------------
Code disassembly (best guess):
   0:	81 e1 00 01 00 00    	and    $0x100,%ecx
   6:	65 48 8b 14 25 40 f0 	mov    %gs:0x1f040,%rdx
   d:	01 00 
   f:	a9 00 01 ff 00       	test   $0xff0100,%eax
  14:	74 0e                	je     0x24
  16:	85 c9                	test   %ecx,%ecx
  18:	74 35                	je     0x4f
  1a:	8b 82 3c 15 00 00    	mov    0x153c(%rdx),%eax
  20:	85 c0                	test   %eax,%eax
  22:	74 2b                	je     0x4f
  24:	8b 82 18 15 00 00    	mov    0x1518(%rdx),%eax
  2a:	83 f8 02             	cmp    $0x2,%eax <-- trapping instruction
  2d:	75 20                	jne    0x4f
  2f:	48 8b 8a 20 15 00 00 	mov    0x1520(%rdx),%rcx
  36:	8b 92 1c 15 00 00    	mov    0x151c(%rdx),%edx
  3c:	48 8b 01             	mov    (%rcx),%rax
  3f:	48                   	rex.W


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
