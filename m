Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B135622206
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 09:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfERH2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 03:28:06 -0400
Received: from mail-it1-f197.google.com ([209.85.166.197]:36388 "EHLO
        mail-it1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfERH2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 03:28:06 -0400
Received: by mail-it1-f197.google.com with SMTP id u131so8626192itc.1
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 00:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=CS67Nh+w09K7rx+tarvOrs1p/4ZthQOjtiay8Tg2Ypw=;
        b=f3YUa/oOXHN1GGhFoszirtrgddmfPdq4hLLBufPqC3Vm0lIj+F65stLV9CcYBNfShg
         5wzN2Y4QYYWpeqFynVhQlmcoNsKwezc3WahP1/Pw6nUeYa0KB/a9Ev3LEO49fDSPYnuI
         hLG0lKgXfw3MngcQjBSmcxjvweRJP1qQFKuY5apAOiyEyBN3HEn4Nxghxzqq0NW/eY1b
         pmIZwlZJIiNRrX68mc5yVcKj6FewBN06xcNl1FEzGeBmOFsra5j2kOHV0eNGJJiAnkRK
         7DP9U3BwShPVSJX1D7pkvbD6tN/9WQdRQTYcTKRMF/DzXP7ec3Z/g6rJgzPtlw6JuZN4
         12VQ==
X-Gm-Message-State: APjAAAU7BPwKtdkEuyXhIPrsEZPlnKzbfed/8tMEJAw8MBHXpBxaRl04
        GirjPX1f02FjINBjOWzOcV4XeSlfWxpYu1vQrERrshfcbUsG
X-Google-Smtp-Source: APXvYqxSkX95ASGwQoi5Yp/ForJIRPbBkuQz6t0sp987/fbCEqvwiHSzxPM1Z1xjFYtKKOnppWa20U2W2qLtVAPiXsyn/t9errji
MIME-Version: 1.0
X-Received: by 2002:a02:1384:: with SMTP id 126mr37351023jaz.72.1558164485542;
 Sat, 18 May 2019 00:28:05 -0700 (PDT)
Date:   Sat, 18 May 2019 00:28:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a99a470589247007@google.com>
Subject: KASAN: slab-out-of-bounds Read in rhashtable_walk_enter
From:   syzbot <syzbot+21ad49ad4c11cbfba8d7@syzkaller.appspotmail.com>
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

HEAD commit:    510e2ced ipv6: fix src addr routing with the exception table
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15345db2a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=82f0809e8f0a8c87
dashboard link: https://syzkaller.appspot.com/bug?extid=21ad49ad4c11cbfba8d7
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1648fdb2a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16437cf8a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+21ad49ad4c11cbfba8d7@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in __lock_acquire+0x3ba2/0x5490  
kernel/locking/lockdep.c:3664
Read of size 8 at addr ffff88821640d0c0 by task syz-executor701/9065

CPU: 0 PID: 9065 Comm: syz-executor701 Not tainted 5.1.0+ #17
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
  __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  kasan_report+0x12/0x20 mm/kasan/common.c:614
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  __lock_acquire+0x3ba2/0x5490 kernel/locking/lockdep.c:3664
  lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4302
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  rhashtable_walk_enter+0xf9/0x390 lib/rhashtable.c:669
  __tipc_dump_start+0x1fa/0x3c0 net/tipc/socket.c:3414
  tipc_dump_start+0x70/0x90 net/tipc/socket.c:3396
  __netlink_dump_start+0x4fb/0x7e0 net/netlink/af_netlink.c:2351
  netlink_dump_start include/linux/netlink.h:226 [inline]
  tipc_sock_diag_handler_dump+0x1d9/0x270 net/tipc/diag.c:91
  __sock_diag_cmd net/core/sock_diag.c:232 [inline]
  sock_diag_rcv_msg+0x322/0x410 net/core/sock_diag.c:263
  netlink_rcv_skb+0x17a/0x460 net/netlink/af_netlink.c:2486
  sock_diag_rcv+0x2b/0x40 net/core/sock_diag.c:274
  netlink_unicast_kernel net/netlink/af_netlink.c:1311 [inline]
  netlink_unicast+0x536/0x720 net/netlink/af_netlink.c:1337
  netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1926
  sock_sendmsg_nosec net/socket.c:660 [inline]
  sock_sendmsg+0x12e/0x170 net/socket.c:671
  ___sys_sendmsg+0x81d/0x960 net/socket.c:2292
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2330
  __do_sys_sendmsg net/socket.c:2339 [inline]
  __se_sys_sendmsg net/socket.c:2337 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2337
  do_syscall_64+0x103/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4401f9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffce5915488 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401f9
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a80
R13: 0000000000401b10 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 1:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:489 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
  kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:497
  slab_post_alloc_hook mm/slab.h:437 [inline]
  slab_alloc mm/slab.c:3356 [inline]
  kmem_cache_alloc+0x11a/0x6f0 mm/slab.c:3518
  kmem_cache_zalloc include/linux/slab.h:732 [inline]
  __kernfs_new_node+0xf0/0x6c0 fs/kernfs/dir.c:632
  kernfs_new_node+0x96/0x120 fs/kernfs/dir.c:698
  __kernfs_create_file+0x51/0x340 fs/kernfs/file.c:1002
  sysfs_add_file_mode_ns+0x222/0x560 fs/sysfs/file.c:305
  create_files fs/sysfs/group.c:63 [inline]
  internal_create_group+0x35b/0xc40 fs/sysfs/group.c:148
  sysfs_create_group fs/sysfs/group.c:174 [inline]
  sysfs_create_groups fs/sysfs/group.c:201 [inline]
  sysfs_create_groups+0x9b/0x141 fs/sysfs/group.c:191
  device_add_groups drivers/base/core.c:1288 [inline]
  device_add_attrs drivers/base/core.c:1436 [inline]
  device_add+0x80f/0x17a0 drivers/base/core.c:2080
  netdev_register_kobject+0x183/0x3b0 net/core/net-sysfs.c:1750
  register_netdevice+0x878/0xff0 net/core/dev.c:8743
  register_netdev+0x30/0x50 net/core/dev.c:8861
  vti6_init_net+0x518/0x820 net/ipv6/ip6_vti.c:1126
  ops_init+0xb6/0x410 net/core/net_namespace.c:129
  __register_pernet_operations net/core/net_namespace.c:1092 [inline]
  register_pernet_operations+0x382/0x7f0 net/core/net_namespace.c:1163
  register_pernet_device+0x2a/0x80 net/core/net_namespace.c:1250
  vti6_tunnel_init+0x19/0x176 net/ipv6/ip6_vti.c:1195
  do_one_initcall+0x109/0x7ca init/main.c:914
  do_initcall_level init/main.c:982 [inline]
  do_initcalls init/main.c:990 [inline]
  do_basic_setup init/main.c:1008 [inline]
  kernel_init_freeable+0x4da/0x5c9 init/main.c:1168
  kernel_init+0x12/0x1c5 init/main.c:1086
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff88821640d000
  which belongs to the cache kernfs_node_cache of size 160
The buggy address is located 32 bytes to the right of
  160-byte region [ffff88821640d000, ffff88821640d0a0)
The buggy address belongs to the page:
page:ffffea0008590340 count:1 mapcount:0 mapping:ffff88821bc45500  
index:0xffff88821640dfee
flags: 0x6fffc0000000200(slab)
raw: 06fffc0000000200 ffffea00085a7c48 ffffea0008590388 ffff88821bc45500
raw: ffff88821640dfee ffff88821640d000 0000000100000012 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88821640cf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88821640d000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ffff88821640d080: 00 00 00 00 fc fc fc fc fc fc fc fc 00 00 00 00
                                            ^
  ffff88821640d100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff88821640d180: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
