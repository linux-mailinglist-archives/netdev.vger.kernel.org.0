Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B97312BC3F
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 03:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfL1CZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 21:25:10 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:42448 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbfL1CZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 21:25:10 -0500
Received: by mail-il1-f200.google.com with SMTP id c5so17671734ilo.9
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 18:25:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dkMBOiYFVN/QgBDsRTSBXVQRsjZiREbEFc+AoW++NlU=;
        b=OyXo3W7XsCjxl6EU007MKpQ7m+4Q2ctOn9juqXHqyjUmJmTTItKxUaoN+QrKMnbmu3
         6UvexJEwO1sC6jMRENvCNhRTFm7jZ+SW0By+FV6zZk5BHwz0KwqlhndAL0/NjxbNfrYB
         MPPhGNQnR4Xl6SUP6XUhAMRkIzVwk5tJl+97/akBuT8RsJ8hEoqCdeyIbSoR6lOrvgl6
         6nkXXbM3F2bOrKcNrY87kjJyXNlSzWcynt670dVWJhL90RUzN5jNDekIZsG327DAKqh+
         lPM4UkeRutabmDoYOirsd6AUWSdG/LUsGRj3+6C4gYHAnBlmjPQunbtbZQvg+z2kQuT/
         BNIA==
X-Gm-Message-State: APjAAAVfLugF20rAamNcjPwltYho7x037N4Jc/Tn9PxPvTjDlYPhr7RT
        5ZkIKsa6ha6AH2fdsMZvlowryyEBXFepvFTFl9uCvOOETm37
X-Google-Smtp-Source: APXvYqwLaMv/LswRa53Dmo4Pg4vZYkdsBZ0NheBEGX2oMrsE914+BQPXHwF/NuuEtckYuqCU8X+pmSCe+L3/Xo/fcSNEv2OR9qpW
MIME-Version: 1.0
X-Received: by 2002:a6b:680d:: with SMTP id d13mr35421523ioc.188.1577499909040;
 Fri, 27 Dec 2019 18:25:09 -0800 (PST)
Date:   Fri, 27 Dec 2019 18:25:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b63799059aba5164@google.com>
Subject: KASAN: slab-out-of-bounds Read in hsr_debugfs_rename
From:   syzbot <syzbot+9328206518f08318a5fd@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3c2f450e Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=15853866e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7f6119e2e3675a73
dashboard link: https://syzkaller.appspot.com/bug?extid=9328206518f08318a5fd
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=106d4751e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1775a49ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9328206518f08318a5fd@syzkaller.appspotmail.com

8021q: adding VLAN 0 to HW filter on device batadv0
@: renamed from hsr_slave_0
==================================================================
BUG: KASAN: slab-out-of-bounds in hsr_debugfs_rename+0xa8/0xc0  
net/hsr/hsr_debugfs.c:73
Read of size 8 at addr ffff88809f7f4cd8 by task syz-executor679/9217

CPU: 1 PID: 9217 Comm: syz-executor679 Not tainted 5.5.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:639
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
  hsr_debugfs_rename+0xa8/0xc0 net/hsr/hsr_debugfs.c:73
  hsr_netdev_notify+0x6c8/0xa00 net/hsr/hsr_main.c:49
  notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
  __raw_notifier_call_chain kernel/notifier.c:361 [inline]
  raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:368
  call_netdevice_notifiers_info net/core/dev.c:1893 [inline]
  call_netdevice_notifiers_info+0xba/0x130 net/core/dev.c:1878
  call_netdevice_notifiers_extack net/core/dev.c:1905 [inline]
  call_netdevice_notifiers net/core/dev.c:1919 [inline]
  dev_change_name+0x504/0x930 net/core/dev.c:1270
  do_setlink+0x2d28/0x3720 net/core/rtnetlink.c:2571
  __rtnl_newlink+0xbf0/0x1790 net/core/rtnetlink.c:3238
  rtnl_newlink+0x69/0xa0 net/core/rtnetlink.c:3363
  rtnetlink_rcv_msg+0x45e/0xaf0 net/core/rtnetlink.c:5424
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:659
  ____sys_sendmsg+0x753/0x880 net/socket.c:2330
  ___sys_sendmsg+0x100/0x170 net/socket.c:2384
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
  __do_sys_sendmsg net/socket.c:2426 [inline]
  __se_sys_sendmsg net/socket.c:2424 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4425d9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 6b 0e fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd616ed1b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004425d9
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 0000000000000003 R08: 00000000bb1414ac R09: 00000000bb1414ac
R10: 00000000bb1414ac R11: 0000000000000246 R12: 0000000000000004
R13: 0000000000403960 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9217:
  save_stack+0x23/0x90 mm/kasan/common.c:72
  set_track mm/kasan/common.c:80 [inline]
  __kasan_kmalloc mm/kasan/common.c:513 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
  __do_kmalloc_node mm/slab.c:3616 [inline]
  __kmalloc_node+0x4e/0x70 mm/slab.c:3623
  kmalloc_node include/linux/slab.h:579 [inline]
  kvmalloc_node+0x68/0x100 mm/util.c:574
  kvmalloc include/linux/mm.h:655 [inline]
  kvzalloc include/linux/mm.h:663 [inline]
  alloc_netdev_mqs+0x98/0xde0 net/core/dev.c:9731
  rtnl_create_link+0x22d/0xab0 net/core/rtnetlink.c:3042
  __rtnl_newlink+0xfa0/0x1790 net/core/rtnetlink.c:3295
  rtnl_newlink+0x69/0xa0 net/core/rtnetlink.c:3363
  rtnetlink_rcv_msg+0x45e/0xaf0 net/core/rtnetlink.c:5424
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:659
  __sys_sendto+0x262/0x380 net/socket.c:1985
  __do_sys_sendto net/socket.c:1997 [inline]
  __se_sys_sendto net/socket.c:1993 [inline]
  __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1993
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff88809f7f4000
  which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 3288 bytes inside of
  4096-byte region [ffff88809f7f4000, ffff88809f7f5000)
The buggy address belongs to the page:
page:ffffea00027dfd00 refcount:1 mapcount:0 mapping:ffff8880aa402000  
index:0x0 compound_mapcount: 0
raw: 00fffe0000010200 ffffea00028eb488 ffffea0002387b08 ffff8880aa402000
raw: 0000000000000000 ffff88809f7f4000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88809f7f4b80: 00 00 00 00 00 00 00 00 07 fc fc fc fc fc fc fc
  ffff88809f7f4c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff88809f7f4c80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                                     ^
  ffff88809f7f4d00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88809f7f4d80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
