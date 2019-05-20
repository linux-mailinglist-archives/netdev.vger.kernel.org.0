Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21857243CF
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 00:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfETW7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 18:59:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:50577 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbfETW7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 18:59:06 -0400
Received: by mail-io1-f69.google.com with SMTP id t7so12660148iod.17
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 15:59:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=H2RF7PBYmKcYbcYFcfHkUeABVhZ/dzC324c2l3eFimU=;
        b=RYd9WZjab2IsQmyt0FdRyRzZmB2oUkRM7y3Jb12UI/ZXbw0dIZK+m7kVSCb4ZCUxWt
         r1g9nxr+Pa0aq/aXKiHczEp8Af7xr4fWXBEQwoMr6vJXEbRM2p5aoMMIFagiI7rxc6i2
         atmktns1HbCcKN/xxnc3OFb5/SlOLjGrRUq0Fv057eOSMJ/TT+VMFO+ztzH1TMC2Tbrt
         pfDIU3rUKDRDlPISu9w0QoS3I/sQkTuy0UllXBMNH0JnuSOTj/6AfdAGFMVuG3Cg1ttQ
         8hkVhhG15hDy08amrqcsBsbK2PajPvjCyk/YqHdgVCIZ32QC0oQzijwu6Ts8nWjurqKR
         Vffg==
X-Gm-Message-State: APjAAAXV92/G8szb4s4Vc52z4Sl5sfTQe2sVFjJTcucrYgcP9ARcc30n
        Mbi6x95RnFY/m/cHL6QOfWDttBI/G1D0i3DbbUanMsak8IXY
X-Google-Smtp-Source: APXvYqyVB/bD6zDOXeGkgauXLH5TIABstR5vcP4hyTL31JXomiX5dRpVY0hDZlga2LwM13Bo19SYWRobCXQmIy5CRYqf/px9XZon
MIME-Version: 1.0
X-Received: by 2002:a6b:c812:: with SMTP id y18mr11882563iof.237.1558393145538;
 Mon, 20 May 2019 15:59:05 -0700 (PDT)
Date:   Mon, 20 May 2019 15:59:05 -0700
In-Reply-To: <00000000000014e65905892486ab@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dc4454058959ad47@google.com>
Subject: Re: INFO: trying to register non-static key in rhashtable_walk_enter
From:   syzbot <syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dvyukov@google.com, edumazet@google.com,
        hujunwei4@huawei.com, jon.maloy@ericsson.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net,
        willemdebruijn.kernel@gmail.com, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    f49aa1de Merge tag 'for-5.2-rc1-tag' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1492b482a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc045131472947d7
dashboard link: https://syzkaller.appspot.com/bug?extid=1e8114b61079bfe9cbc5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11baf8e4a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13bf3d9ca00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 8939 Comm: syz-executor164 Not tainted 5.2.0-rc1+ #1
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  assign_lock_key kernel/locking/lockdep.c:774 [inline]
  register_lock_class+0x167e/0x1860 kernel/locking/lockdep.c:1083
  __lock_acquire+0x116/0x5490 kernel/locking/lockdep.c:3673
  lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4302
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  rhashtable_walk_enter+0xf9/0x390 lib/rhashtable.c:669
  __tipc_dump_start+0x1fa/0x3c0 net/tipc/socket.c:3414
  tipc_dump_start+0x70/0x90 net/tipc/socket.c:3396
  __netlink_dump_start+0x4f8/0x7d0 net/netlink/af_netlink.c:2351
  netlink_dump_start include/linux/netlink.h:226 [inline]
  tipc_sock_diag_handler_dump+0x1d9/0x270 net/tipc/diag.c:91
  __sock_diag_cmd net/core/sock_diag.c:232 [inline]
  sock_diag_rcv_msg+0x319/0x410 net/core/sock_diag.c:263
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2486
  sock_diag_rcv+0x2b/0x40 net/core/sock_diag.c:274
  netlink_unicast_kernel net/netlink/af_netlink.c:1311 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1337
  netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1926
  sock_sendmsg_nosec net/socket.c:652 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:671
  ___sys_sendmsg+0x803/0x920 net/socket.c:2292
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2330
  __compat_sys_sendmsg net/compat.c:640 [inline]
  __do_compat_sys_sendmsg net/compat.c:647 [inline]
  __se_compat_sys_sendmsg net/compat.c:644 [inline]
  __ia32_compat_sys_sendmsg+0x7a/0xb0 net/compat.c:644
  do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
  do_fast_syscall_32+0x27b/0xd7d arch/x86/entry/common.c:408
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f2e849
Code: 85 d2 74 02 89 0a 5b 5d c3 8b 04 24 c3 8b 14 24 c3 8b 3c 24 c3 90 90  
90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90  
90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffdfb03c EFLAGS: 00000246 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020000040
RDX: 0000000000000000 RSI: 00000000080ea078 RDI: 00000000ffdfb090
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8939 Comm: syz-executor164 Not tainted 5.2.0-rc1+ #1
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:list_add include/linux/list.h:79 [inline]
RIP: 0010:rhashtable_walk_enter+0x18f/0x390 lib/rhashtable.c:672
Code: c1 ea 03 80 3c 02 00 0f 85 ac 01 00 00 4d 8d 7e 10 4c 89 73 28 48 b8  
00 00 00 00 00 fc ff df 48 8d 4b 18 4c 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 70 01 00 00 49 8b 56 10 48 89 cf 4c 89 fe 48 89
RSP: 0018:ffff888089a17620 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8880991f0f80 RCX: ffff8880991f0f98
RDX: 0000000000000002 RSI: ffffffff833391e4 RDI: ffff8880991f0fa8
RBP: ffff888089a17658 R08: ffff888096072480 R09: ffffed1011342eb2
R10: ffffed1011342eb1 R11: 0000000000000003 R12: ffff88809b30dc28
R13: ffff88809b30dd28 R14: 0000000000000000 R15: 0000000000000010
FS:  0000000000000000(0000) GS:ffff8880ae900000(0063) knlGS:0000000057838840
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000020000040 CR3: 000000009a614000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __tipc_dump_start+0x1fa/0x3c0 net/tipc/socket.c:3414
  tipc_dump_start+0x70/0x90 net/tipc/socket.c:3396
  __netlink_dump_start+0x4f8/0x7d0 net/netlink/af_netlink.c:2351
  netlink_dump_start include/linux/netlink.h:226 [inline]
  tipc_sock_diag_handler_dump+0x1d9/0x270 net/tipc/diag.c:91
  __sock_diag_cmd net/core/sock_diag.c:232 [inline]
  sock_diag_rcv_msg+0x319/0x410 net/core/sock_diag.c:263
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2486
  sock_diag_rcv+0x2b/0x40 net/core/sock_diag.c:274
  netlink_unicast_kernel net/netlink/af_netlink.c:1311 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1337
  netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1926
  sock_sendmsg_nosec net/socket.c:652 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:671
  ___sys_sendmsg+0x803/0x920 net/socket.c:2292
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2330
  __compat_sys_sendmsg net/compat.c:640 [inline]
  __do_compat_sys_sendmsg net/compat.c:647 [inline]
  __se_compat_sys_sendmsg net/compat.c:644 [inline]
  __ia32_compat_sys_sendmsg+0x7a/0xb0 net/compat.c:644
  do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
  do_fast_syscall_32+0x27b/0xd7d arch/x86/entry/common.c:408
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f2e849
Code: 85 d2 74 02 89 0a 5b 5d c3 8b 04 24 c3 8b 14 24 c3 8b 3c 24 c3 90 90  
90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90  
90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffdfb03c EFLAGS: 00000246 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020000040
RDX: 0000000000000000 RSI: 00000000080ea078 RDI: 00000000ffdfb090
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace df764217ca13e9ce ]---
RIP: 0010:list_add include/linux/list.h:79 [inline]
RIP: 0010:rhashtable_walk_enter+0x18f/0x390 lib/rhashtable.c:672
Code: c1 ea 03 80 3c 02 00 0f 85 ac 01 00 00 4d 8d 7e 10 4c 89 73 28 48 b8  
00 00 00 00 00 fc ff df 48 8d 4b 18 4c 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 70 01 00 00 49 8b 56 10 48 89 cf 4c 89 fe 48 89
RSP: 0018:ffff888089a17620 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8880991f0f80 RCX: ffff8880991f0f98
RDX: 0000000000000002 RSI: ffffffff833391e4 RDI: ffff8880991f0fa8
RBP: ffff888089a17658 R08: ffff888096072480 R09: ffffed1011342eb2
R10: ffffed1011342eb1 R11: 0000000000000003 R12: ffff88809b30dc28
R13: ffff88809b30dd28 R14: 0000000000000000 R15: 0000000000000010
FS:  0000000000000000(0000) GS:ffff8880ae900000(0063) knlGS:0000000057838840
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000020000040 CR3: 000000009a614000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

