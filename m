Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A81322869
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 20:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfESSpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 14:45:46 -0400
Received: from mail-it1-f198.google.com ([209.85.166.198]:51149 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfESSpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 14:45:46 -0400
Received: by mail-it1-f198.google.com with SMTP id o128so12047373ita.0
        for <netdev@vger.kernel.org>; Sun, 19 May 2019 11:45:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=M1TghxkZ2cqK/XU0n2a61ItohSKPfNjC9hEQzfL0wnc=;
        b=coMRJw+4vgLRperCZlbh3tAV3RVxKUTXpxwrYA0BGE8GAt5oIcWBfHwoqqETW99CJ0
         h2Js3TLrbIPPOa9mQkpWgeNYGZnzUuTAPvhXiSpT1D5jPNbyOxu0daPvzJxKmz6H0kfR
         ZMRtZg6BvIlbZH0wofIRWj6eSXDIiJY6NRgf51dD/vymnjkGv/V1dE+ESzZ6a0/WN9+n
         2Oh6KlQMlkrMIz4CtmfQqqomDypxR++w9p0e2wLFpn8P70jXpA2D+WyztozVz2elVt94
         fMo+b3noK5aQlOkg2P0vqfLHhDWYj4vnzFq/0jBEch1fqVKWTr3IXFHDP1czEbBmxdPY
         svSA==
X-Gm-Message-State: APjAAAVdzf/KlAlac6YN9c6QWPjWOIcL4M45xm/OhKRhOJNF+EtYBSc/
        +cJZ7BaKwmXV6ZKPca8O9e5CNzpdHKOc2CDYMYcrSmqMU9Ob
X-Google-Smtp-Source: APXvYqwJMvHP1nHjqR08pleCqoffj1JzDsim7beyXZUNubPpMK3yQh38HPUVLvyiIJD+FgMh1dtC7AoKpHKqET2ojtRwpjpVGXez
MIME-Version: 1.0
X-Received: by 2002:a05:6638:221:: with SMTP id f1mr41655686jaq.1.1558258025060;
 Sun, 19 May 2019 02:27:05 -0700 (PDT)
Date:   Sun, 19 May 2019 02:27:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000d60e405893a38f0@google.com>
Subject: general protection fault in rhashtable_walk_enter
From:   syzbot <syzbot+153641db1759e576ec8e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jon.maloy@ericsson.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b1d6682e Add linux-next specific files for 20190517
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1022b8bca00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d3758876561d8cec
dashboard link: https://syzkaller.appspot.com/bug?extid=153641db1759e576ec8e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+153641db1759e576ec8e@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 2377 Comm: syz-executor.0 Not tainted 5.1.0-next-20190517 #17
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:strlen+0x1f/0xa0 lib/string.c:516
Code: 00 66 2e 0f 1f 84 00 00 00 00 00 48 b8 00 00 00 00 00 fc ff df 55 48  
89 fa 48 89 e5 48 c1 ea 03 41 54 49 89 fc 53 48 83 ec 08 <0f> b6 04 02 48  
89 fa 83 e2 07 38 d0 7f 04 84 c0 75 4d 41 80 3c 24
RSP: 0018:ffff88803eacf488 EFLAGS: 00010096
RAX: dffffc0000000000 RBX: ffff8880a4dba828 RCX: 0000000000000000
RDX: 00000000200002ce RSI: ffff888093223440 RDI: 0000000100001674
RBP: ffff88803eacf4a0 R08: 0000000000000000 R09: 0000000000000001
R10: ffffed1015d06bdf R11: 0000000000000001 R12: 0000000100001674
R13: 0000000000000000 R14: ffff888093223440 R15: ffff88803eacf570
FS:  00007fa96d643700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000738000 CR3: 00000000a8324000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  trace_event_get_offsets_lock_acquire include/trace/events/lock.h:13  
[inline]
  perf_trace_lock_acquire+0xb9/0x530 include/trace/events/lock.h:13
  trace_lock_acquire include/trace/events/lock.h:13 [inline]
  lock_acquire+0x299/0x3f0 kernel/locking/lockdep.c:4301
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
  netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1926
  sock_sendmsg_nosec net/socket.c:660 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:671
  ___sys_sendmsg+0x803/0x920 net/socket.c:2292
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2330
  __do_sys_sendmsg net/socket.c:2339 [inline]
  __se_sys_sendmsg net/socket.c:2337 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2337
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x458da9
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa96d642c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000458da9
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000004
RBP: 000000000073bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa96d6436d4
R13: 00000000004c6790 R14: 00000000004db3e8 R15: 00000000ffffffff
Modules linked in:
---[ end trace 88f78024ddc40fcd ]---
RIP: 0010:strlen+0x1f/0xa0 lib/string.c:516
Code: 00 66 2e 0f 1f 84 00 00 00 00 00 48 b8 00 00 00 00 00 fc ff df 55 48  
89 fa 48 89 e5 48 c1 ea 03 41 54 49 89 fc 53 48 83 ec 08 <0f> b6 04 02 48  
89 fa 83 e2 07 38 d0 7f 04 84 c0 75 4d 41 80 3c 24
RSP: 0018:ffff88803eacf488 EFLAGS: 00010096
RAX: dffffc0000000000 RBX: ffff8880a4dba828 RCX: 0000000000000000
RDX: 00000000200002ce RSI: ffff888093223440 RDI: 0000000100001674
RBP: ffff88803eacf4a0 R08: 0000000000000000 R09: 0000000000000001
R10: ffffed1015d06bdf R11: 0000000000000001 R12: 0000000100001674
R13: 0000000000000000 R14: ffff888093223440 R15: ffff88803eacf570
FS:  00007fa96d643700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000738000 CR3: 00000000a8324000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
