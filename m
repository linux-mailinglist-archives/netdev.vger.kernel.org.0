Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD05F45563B
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 09:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244183AbhKRIHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 03:07:24 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:36778 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244124AbhKRIHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 03:07:17 -0500
Received: by mail-il1-f197.google.com with SMTP id i10-20020a056e02152a00b00293be3da5c0so2564449ilu.3
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 00:04:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7Mho7qWRkuWu1SA8iytHjoQBHpUCmbQH7SJHb0/dT9k=;
        b=0jMBG0sZmHHweds3QPlXjLobB/rutcYddg/sMOkx6PCrWz7JKm46zaeEL+CCKv0kId
         6nXF27hROvZb+c9zbTNcz6Jb4UT10q/DTds+e3psA71wPVaRRWx+hEgHX9I8lK8FZS58
         IU0q4yGil7am2JT5ACNla9n5iBxsF60c36fmzSF6gCnhtXVmncK2Bx/nS9kqcfC79Pam
         0TxLNPb6Z4StPuRT1PJQgzBAviXKbhUjoSM+kpkZptNqmMyfJnT7gtNpF8iS1peeflZg
         eqEa/MiSBZLVpGK5j3wDXxzZhuYjmVm7j4We2Yh7/lv9tL5eiyb0TglXee6CaeFzifmB
         YT2A==
X-Gm-Message-State: AOAM5320EEz27NyNETUoHZSUQvTMFN0SAT8siRiO07z833zWIVg1RLTL
        X/BKRs/UG7c6ZpqNrIrZHwvJvTr37oi5Yva34FWE3BjFdiOU
X-Google-Smtp-Source: ABdhPJwrGx853dXaJkxNu1qAB4In5m5L/UJdzFebplhCuZKgrmlRcnHhrC1BBuuHwZPV2vYl+s55SQt+z62Txxoq7/7bRWhZQks2
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2166:: with SMTP id s6mr14323780ilv.170.1637222657734;
 Thu, 18 Nov 2021 00:04:17 -0800 (PST)
Date:   Thu, 18 Nov 2021 00:04:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000eebfbe05d10b9a9f@google.com>
Subject: [syzbot] UBSAN: array-index-out-of-bounds in llc_conn_state_process
From:   syzbot <syzbot+ec3de60670a959d21eb0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    66f4beaa6c1d Merge branch 'linus' of git://git.kernel.org/..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=151c6221b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a262045c4c15a9e0
dashboard link: https://syzkaller.appspot.com/bug?extid=ec3de60670a959d21eb0
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ec3de60670a959d21eb0@syzkaller.appspotmail.com

================================================================================
UBSAN: array-index-out-of-bounds in net/llc/llc_conn.c:682:24
index -1 is out of range for type 'int [12][5]'
CPU: 0 PID: 9103 Comm: syz-executor.5 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:151
 __ubsan_handle_out_of_bounds.cold+0x62/0x6c lib/ubsan.c:291
 llc_find_offset net/llc/llc_conn.c:682 [inline]
 llc_qualify_conn_ev net/llc/llc_conn.c:400 [inline]
 llc_conn_service net/llc/llc_conn.c:365 [inline]
 llc_conn_state_process+0x139a/0x1410 net/llc/llc_conn.c:71
 llc_process_tmr_ev net/llc/llc_c_ac.c:1445 [inline]
 llc_conn_tmr_common_cb+0x2bb/0x8b0 net/llc/llc_c_ac.c:1331
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x675/0xa20 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:636
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:__sanitizer_cov_trace_pc+0x37/0x60 kernel/kcov.c:200
Code: 81 e1 00 01 00 00 65 48 8b 14 25 40 70 02 00 a9 00 01 ff 00 74 0e 85 c9 74 35 8b 82 a4 15 00 00 85 c0 74 2b 8b 82 80 15 00 00 <83> f8 02 75 20 48 8b 8a 88 15 00 00 8b 92 84 15 00 00 48 8b 01 48
RSP: 0018:ffffc9000292ea70 EFLAGS: 00000246
RAX: 0000000000000002 RBX: ffff888010cc0a10 RCX: 0000000000000000
RDX: ffff888027c25700 RSI: ffffffff83f50ac0 RDI: 0000000000000003
RBP: ffffc9000292eab0 R08: 00000000ffffffe4 R09: ffff88802a020d2f
R10: ffffffff83f50ab1 R11: 0000000000000000 R12: 0000000000000001
R13: ffff888010cc0a64 R14: 0000000000000000 R15: 000000007fffffff
 idr_alloc_cyclic+0x120/0x230 lib/idr.c:130
 __kernfs_new_node+0x117/0x8b0 fs/kernfs/dir.c:591
 kernfs_new_node+0x93/0x120 fs/kernfs/dir.c:647
 __kernfs_create_file+0x51/0x350 fs/kernfs/file.c:985
 sysfs_add_file_mode_ns+0x20f/0x3f0 fs/sysfs/file.c:294
 create_files fs/sysfs/group.c:64 [inline]
 internal_create_group+0x322/0xb10 fs/sysfs/group.c:148
 internal_create_groups.part.0+0x90/0x140 fs/sysfs/group.c:188
 internal_create_groups fs/sysfs/group.c:184 [inline]
 sysfs_create_groups+0x25/0x50 fs/sysfs/group.c:214
 setup_gid_attrs drivers/infiniband/core/sysfs.c:1168 [inline]
 ib_setup_port_attrs+0x3e7/0x5c0 drivers/infiniband/core/sysfs.c:1440
 add_one_compat_dev+0x517/0x7f0 drivers/infiniband/core/device.c:968
 add_compat_devs drivers/infiniband/core/device.c:1026 [inline]
 enable_device_and_get+0x313/0x3b0 drivers/infiniband/core/device.c:1337
 ib_register_device drivers/infiniband/core/device.c:1419 [inline]
 ib_register_device+0x854/0xb50 drivers/infiniband/core/device.c:1365
 rxe_register_device+0x2fe/0x3b0 drivers/infiniband/sw/rxe/rxe_verbs.c:1146
 rxe_add+0x1331/0x1710 drivers/infiniband/sw/rxe/rxe.c:248
 rxe_net_add+0x8c/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:543
 rxe_newlink drivers/infiniband/sw/rxe/rxe.c:270 [inline]
 rxe_newlink+0xb7/0xe0 drivers/infiniband/sw/rxe/rxe.c:251
 nldev_newlink+0x30a/0x560 drivers/infiniband/core/nldev.c:1717
 rdma_nl_rcv_msg+0x36d/0x690 drivers/infiniband/core/netlink.c:195
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0x2ee/0x430 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xda0 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f74647c0ae9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7461d15188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f74648d4020 RCX: 00007f74647c0ae9
RDX: 0000000000000000 RSI: 00000000200002c0 RDI: 0000000000000003
RBP: 00007f746481af6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffdddcd1cef R14: 00007f7461d15300 R15: 0000000000022000
 </TASK>
================================================================================
----------------
Code disassembly (best guess):
   0:	81 e1 00 01 00 00    	and    $0x100,%ecx
   6:	65 48 8b 14 25 40 70 	mov    %gs:0x27040,%rdx
   d:	02 00
   f:	a9 00 01 ff 00       	test   $0xff0100,%eax
  14:	74 0e                	je     0x24
  16:	85 c9                	test   %ecx,%ecx
  18:	74 35                	je     0x4f
  1a:	8b 82 a4 15 00 00    	mov    0x15a4(%rdx),%eax
  20:	85 c0                	test   %eax,%eax
  22:	74 2b                	je     0x4f
  24:	8b 82 80 15 00 00    	mov    0x1580(%rdx),%eax
* 2a:	83 f8 02             	cmp    $0x2,%eax <-- trapping instruction
  2d:	75 20                	jne    0x4f
  2f:	48 8b 8a 88 15 00 00 	mov    0x1588(%rdx),%rcx
  36:	8b 92 84 15 00 00    	mov    0x1584(%rdx),%edx
  3c:	48 8b 01             	mov    (%rcx),%rax
  3f:	48                   	rex.W


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
