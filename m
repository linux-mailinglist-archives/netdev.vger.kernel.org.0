Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F9510D24A
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 09:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfK2INL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 03:13:11 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:44206 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfK2INK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 03:13:10 -0500
Received: by mail-io1-f70.google.com with SMTP id t16so14744897iog.11
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 00:13:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=a1fEaqHoFp3OE0xOJ+yzl9G2kFByF8iDW8WA6fZk+mc=;
        b=bwJRuQKEPrzlqXqg+dqKihrgK4p9E5sfXXJz0Tps52ftOI3DBNdSnf0NFyMRLC88oF
         gt/LktMMsoV69deQuJZEeR9qP4/BiUdRvgP+UUFqGkTzIJhdVzCqkGa1IT6G+W1MqqoY
         zDInl67ji45lCAvCSVLeALZ0RdmFvIagRhAG/Ezi0DuQxIiTQ958XA6HbM3w9hVE3l02
         CqIjaBprUz5VSKm1LzmWcZrRXrlrWLOf4NSR5XA52Io3afoxwR9IvpmRpspLs8IvDmrh
         gKiuZb+dyWcHMfWDWofpN74YyMISjF4kebTWGKSoaD+xWAeu7b8djx0hlt1hynFAUwJI
         ZrTQ==
X-Gm-Message-State: APjAAAVaAKsMUtPwmw3MCmIfeAU4KnF0M3qfg2h0SvzoOmedpGuiRTfk
        XWlrmk9KNULdLyILqv4ZZxVAJiI2djw9GlZG86eAy5K/8PQM
X-Google-Smtp-Source: APXvYqyiu8qU8ClqW1sFDcQYSs0kmZUKS8dXsX9tV0TcbR7EftpgScOub0H4UDTu4IRwwCnRsKQJvpEDFrohcupUJgFrL/W6s59C
MIME-Version: 1.0
X-Received: by 2002:a5d:88c3:: with SMTP id i3mr43571723iol.69.1575015187753;
 Fri, 29 Nov 2019 00:13:07 -0800 (PST)
Date:   Fri, 29 Nov 2019 00:13:07 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c832e2059877ccdb@google.com>
Subject: general protection fault in skb_clone (2)
From:   syzbot <syzbot+9fe8e3f6c64aa5e5d82c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0be0ee71 vfs: properly and reliably lock f_pos in fdget_po..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10ac989ce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c483a72a6c4b4dab
dashboard link: https://syzkaller.appspot.com/bug?extid=9fe8e3f6c64aa5e5d82c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9fe8e3f6c64aa5e5d82c@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 18879 Comm: syz-executor.1 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:skb_clone+0xea/0x3d0 net/core/skbuff.c:1440
Code: 89 de e8 09 ef ce fb 84 db 0f 85 ec 00 00 00 e8 bc ed ce fb 49 8d 5c  
24 7e 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <0f> b6 04 02 48  
89 da 83 e2 07 38 d0 7f 08 84 c0 0f 85 75 02 00 00
RSP: 0018:ffff8881ff037878 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: 000000000000007e RCX: ffffc90008198000
RDX: 000000000000000f RSI: ffffffff85a46964 RDI: 0000000000000000
RBP: ffff8881ff0378a0 R08: 1ffffffff14f0156 R09: fffffbfff14f0157
R10: fffffbfff14f0156 R11: ffffffff8a780ab7 R12: 0000000000000000
R13: 0000000000000004 R14: 0000000000000a20 R15: ffffed1002d69894
FS:  00007fc8606cb700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2f531000 CR3: 000000021338a000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  nr_kick.part.0+0x3ca/0x5e0 net/netrom/nr_out.c:156
  nr_kick net/netrom/nr_out.c:131 [inline]
  nr_output+0x5c4/0x710 net/netrom/nr_out.c:72
  nr_sendmsg+0x915/0xb00 net/netrom/af_netrom.c:1111
  sock_sendmsg_nosec net/socket.c:638 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:658
  sock_write_iter+0x27c/0x3e0 net/socket.c:990
  call_write_iter include/linux/fs.h:1893 [inline]
  new_sync_write+0x4d3/0x770 fs/read_write.c:483
  __vfs_write+0xe1/0x110 fs/read_write.c:496
  vfs_write+0x268/0x5d0 fs/read_write.c:558
  ksys_write+0x220/0x290 fs/read_write.c:611
  __do_sys_write fs/read_write.c:623 [inline]
  __se_sys_write fs/read_write.c:620 [inline]
  __x64_sys_write+0x73/0xb0 fs/read_write.c:620
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a639
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fc8606cac78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045a639
RDX: 0000000000000278 RSI: 00000000200002c0 RDI: 0000000000000007
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fc8606cb6d4
R13: 00000000004cb0e4 R14: 00000000004e3810 R15: 00000000ffffffff
Modules linked in:
---[ end trace 30cf82ed03f1b88f ]---
RIP: 0010:skb_clone+0xea/0x3d0 net/core/skbuff.c:1440
Code: 89 de e8 09 ef ce fb 84 db 0f 85 ec 00 00 00 e8 bc ed ce fb 49 8d 5c  
24 7e 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <0f> b6 04 02 48  
89 da 83 e2 07 38 d0 7f 08 84 c0 0f 85 75 02 00 00
RSP: 0018:ffff8881ff037878 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: 000000000000007e RCX: ffffc90008198000
RDX: 000000000000000f RSI: ffffffff85a46964 RDI: 0000000000000000
RBP: ffff8881ff0378a0 R08: 1ffffffff14f0156 R09: fffffbfff14f0157
R10: fffffbfff14f0156 R11: ffffffff8a780ab7 R12: 0000000000000000
R13: 0000000000000004 R14: 0000000000000a20 R15: ffffed1002d69894
FS:  00007fc8606cb700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31c29000 CR3: 000000021338a000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
