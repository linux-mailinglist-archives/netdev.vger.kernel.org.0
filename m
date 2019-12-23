Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB2B1297A6
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 15:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfLWOpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 09:45:11 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:45137 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfLWOpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 09:45:11 -0500
Received: by mail-il1-f200.google.com with SMTP id w6so14324066ill.12
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 06:45:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=02BQy7ugbT8QS1BxBq5h0pQHKxjdntlT6/0f+D2DJck=;
        b=Rs/d0BH/RHraE5Gf6qpaqqHlBjRyaj1ECJCBB8rnYJpPIColvY4H7fKHVsGqRZzF4u
         2O5QvsFCkb3t2Aexvsrpiq1j++/1g5t1lWKi1y0CU3O9kVcMPzpgeExJ1xlHz18Sgok9
         g/4wAuDdAJ2zYAe4Ap4VseQMAxaS8c4A8Hsuy/L9+syOe/c9nfMDP9luOJweg8AO4Nwz
         joAeMBK5J4icb61fbZejuNbHHQUmxEleO2hh32Uj3OWjSp7iBn00fOnVIMyyxlkxspJt
         jehxHUtoA9nkB+R98kvIL0duOkvP5GEQPz9oLAIPs6y+LJsOLdcg5L+ghFI1rEO0f7GE
         uVZA==
X-Gm-Message-State: APjAAAUMATWoAkMWQMyWG4CVDge7TGkFJ5sHhiyryS5xiXcjbOuF34fF
        tZDRTy47/i9GeAJ57h68gWbBi9nD4/Uv/eY/NYPId7ygt79I
X-Google-Smtp-Source: APXvYqwuVKT+wFYCVUWmsmMd7f/3p4ZC8+Hyt82EcBqFCc8zioQYtZXa90XA1x659glhpJyM3dNEPTNlZ0J5bKrpVK2gUmA3ajC2
MIME-Version: 1.0
X-Received: by 2002:a6b:f913:: with SMTP id j19mr18914743iog.124.1577112310032;
 Mon, 23 Dec 2019 06:45:10 -0800 (PST)
Date:   Mon, 23 Dec 2019 06:45:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000002b21f059a6013b0@google.com>
Subject: KASAN: slab-out-of-bounds Read in j1939_tp_txtimer
From:   syzbot <syzbot+11d6c5c51b583bea8575@syzkaller.appspotmail.com>
To:     bst@pengutronix.de, davem@davemloft.net,
        dev.kurt@vandijck-laurijssen.be, ecathinds@gmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rempel-privat.de,
        lkp@intel.com, maxime.jayat@mobile-devices.fr, mkl@pengutronix.de,
        netdev@vger.kernel.org, o.rempel@pengutronix.de, robin@protonic.nl,
        socketcan@hartkopp.net, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4a94c433 Merge tag 'tpmdd-next-20191219' of git://git.infr..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17dce0c1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=745a1e367d8abf39
dashboard link: https://syzkaller.appspot.com/bug?extid=11d6c5c51b583bea8575
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13246151e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16bd77dee00000

The bug was bisected to:

commit 9d71dd0c70099914fcd063135da3c580865e924c
Author: The j1939 authors <linux-can@vger.kernel.org>
Date:   Mon Oct 8 09:48:36 2018 +0000

     can: add support of SAE J1939 protocol

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1730ecb9e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14b0ecb9e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=10b0ecb9e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+11d6c5c51b583bea8575@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")

vcan0: j1939_xtp_rx_abort_one: 0x000000000820f4a9: 0x00000: (3) A timeout  
occurred and this is the connection abort to close the session.
vcan0: j1939_xtp_rx_abort_one: 0x00000000b1f6d063: 0x00000: (3) A timeout  
occurred and this is the connection abort to close the session.
==================================================================
BUG: KASAN: slab-out-of-bounds in memcpy include/linux/string.h:380 [inline]
BUG: KASAN: slab-out-of-bounds in j1939_session_tx_dat  
net/can/j1939/transport.c:790 [inline]
BUG: KASAN: slab-out-of-bounds in j1939_xtp_txnext_transmiter  
net/can/j1939/transport.c:847 [inline]
BUG: KASAN: slab-out-of-bounds in j1939_tp_txtimer+0x777/0x1b00  
net/can/j1939/transport.c:1095
Read of size 7 at addr ffff8880905826af by task ksoftirqd/1/16

CPU: 1 PID: 16 Comm: ksoftirqd/1 Not tainted 5.5.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:639
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
  memcpy+0x24/0x50 mm/kasan/common.c:125
  memcpy include/linux/string.h:380 [inline]
  j1939_session_tx_dat net/can/j1939/transport.c:790 [inline]
  j1939_xtp_txnext_transmiter net/can/j1939/transport.c:847 [inline]
  j1939_tp_txtimer+0x777/0x1b00 net/can/j1939/transport.c:1095
  __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
  __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1579
  hrtimer_run_softirq+0x17e/0x270 kernel/time/hrtimer.c:1596
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  run_ksoftirqd kernel/softirq.c:603 [inline]
  run_ksoftirqd+0x8e/0x110 kernel/softirq.c:595
  smpboot_thread_fn+0x6a3/0xa40 kernel/smpboot.c:165
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 9315:
  save_stack+0x23/0x90 mm/kasan/common.c:72
  set_track mm/kasan/common.c:80 [inline]
  __kasan_kmalloc mm/kasan/common.c:513 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
  __do_kmalloc mm/slab.c:3656 [inline]
  __kmalloc+0x163/0x770 mm/slab.c:3665
  kmalloc include/linux/slab.h:561 [inline]
  kzalloc include/linux/slab.h:670 [inline]
  __register_sysctl_table+0xc7/0xef0 fs/proc/proc_sysctl.c:1331
  register_net_sysctl+0x29/0x30 net/sysctl_net.c:121
  __addrconf_sysctl_register+0x221/0x430 net/ipv6/addrconf.c:6850
  addrconf_sysctl_register net/ipv6/addrconf.c:6897 [inline]
  addrconf_sysctl_register+0x140/0x1e0 net/ipv6/addrconf.c:6886
  ipv6_add_dev net/ipv6/addrconf.c:443 [inline]
  ipv6_add_dev+0x9dd/0x10b0 net/ipv6/addrconf.c:363
  addrconf_notify+0x89c/0x2270 net/ipv6/addrconf.c:3491
  notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
  __raw_notifier_call_chain kernel/notifier.c:361 [inline]
  raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:368
  call_netdevice_notifiers_info net/core/dev.c:1893 [inline]
  call_netdevice_notifiers_info+0xba/0x130 net/core/dev.c:1878
  call_netdevice_notifiers_extack net/core/dev.c:1905 [inline]
  call_netdevice_notifiers net/core/dev.c:1919 [inline]
  register_netdevice+0x6de/0x1020 net/core/dev.c:9345
  bond_newlink drivers/net/bonding/bond_netlink.c:458 [inline]
  bond_newlink+0x4b/0x90 drivers/net/bonding/bond_netlink.c:448
  __rtnl_newlink+0x109e/0x1790 net/core/rtnetlink.c:3305
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

The buggy address belongs to the object at ffff888090582000
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1711 bytes inside of
  2048-byte region [ffff888090582000, ffff888090582800)
The buggy address belongs to the page:
page:ffffea0002416080 refcount:1 mapcount:0 mapping:ffff8880aa400e00  
index:0x0
raw: 00fffe0000000200 ffffea0002a06388 ffffea00025cd188 ffff8880aa400e00
raw: 0000000000000000 ffff888090582000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888090582580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff888090582600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ffff888090582680: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
                                      ^
  ffff888090582700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff888090582780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
