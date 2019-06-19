Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FECB4BD3A
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 17:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbfFSPrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 11:47:09 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:43733 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfFSPrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 11:47:08 -0400
Received: by mail-io1-f71.google.com with SMTP id y5so21722936ioj.10
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 08:47:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=G35OJz6sjhkbUbQl7PzvWn/reajdAg+kBApbnx/fYHU=;
        b=dG9QyjegkgksCMv79/IiuNUULBxWDBqH1XWYFl+uC1U404BlVBWiEZj4ZcNqUxV3E7
         fMfRLpeCWyhBzuxctRM2i90RxKjb6LVRX1atvYdxSfU5nKQbAFZQDPdVBUT8FsOw6Y1S
         dOiRoOLcx7Vf27XdxQl+aK6CV4olapZ/StUIDs4cyZn1wFu3g2ZLS2qKnxoMDCoKc0xD
         pG+9DCKn/QeyanFfrEwD7Wwjxk6s+FkRVDE3bUi2X3EjLzRCrLb/B2ZxEX0nQB32QJ7y
         WyUEagby3gWuN7lUgSFMLFnw5xBLO1qJZvXAqWCRoM7YlJ2crTGYZd5R3XI5Ebx/XRV3
         LaDQ==
X-Gm-Message-State: APjAAAVMZ/+wi/HYDbFaix00FKNJeEcu2XYMNEKPOMR0Sn9xDvSqKOSU
        bk4CcSGi1ta3SZ3BveqJu47rUPhXKhU4nt5F96VaRstabnpt
X-Google-Smtp-Source: APXvYqzq4EUif8uTIkSHcyc+eYTxq38OopdKHHNqsUg4jZEvXH37Sh6ZpEE3MHsTEo3MlyJaDFmS1geYq/r+Re3NYNGnFVWLfXLb
MIME-Version: 1.0
X-Received: by 2002:a5e:890f:: with SMTP id k15mr5521851ioj.121.1560959227647;
 Wed, 19 Jun 2019 08:47:07 -0700 (PDT)
Date:   Wed, 19 Jun 2019 08:47:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000045db72058baf24f7@google.com>
Subject: KMSAN: uninit-value in tipc_nl_compat_bearer_disable
From:   syzbot <syzbot+30eaa8bf392f7fafffaf@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, jon.maloy@ericsson.com,
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

HEAD commit:    f75e4cfe kmsan: use kmsan_handle_urb() in urb.c
git tree:       kmsan
console output: https://syzkaller.appspot.com/x/log.txt?x=13d0a6fea00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=602468164ccdc30a
dashboard link: https://syzkaller.appspot.com/bug?extid=30eaa8bf392f7fafffaf
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
06d00afa61eef8f7f501ebdb4e8612ea43ec2d78)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b4a95aa00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=162fc761a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+30eaa8bf392f7fafffaf@syzkaller.appspotmail.com

IPv6: ADDRCONF(NETDEV_CHANGE): hsr0: link becomes ready
8021q: adding VLAN 0 to HW filter on device batadv0
==================================================================
BUG: KMSAN: uninit-value in memchr+0xce/0x110 lib/string.c:981
CPU: 0 PID: 12554 Comm: syz-executor731 Not tainted 5.1.0+ #1
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:622
  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
  memchr+0xce/0x110 lib/string.c:981
  string_is_valid net/tipc/netlink_compat.c:176 [inline]
  tipc_nl_compat_bearer_disable+0x2a1/0x480 net/tipc/netlink_compat.c:449
  __tipc_nl_compat_doit net/tipc/netlink_compat.c:327 [inline]
  tipc_nl_compat_doit+0x3ac/0xb00 net/tipc/netlink_compat.c:360
  tipc_nl_compat_handle net/tipc/netlink_compat.c:1178 [inline]
  tipc_nl_compat_recv+0x1b1b/0x27b0 net/tipc/netlink_compat.c:1281
  genl_family_rcv_msg net/netlink/genetlink.c:602 [inline]
  genl_rcv_msg+0x185a/0x1a40 net/netlink/genetlink.c:627
  netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2486
  genl_rcv+0x63/0x80 net/netlink/genetlink.c:638
  netlink_unicast_kernel net/netlink/af_netlink.c:1311 [inline]
  netlink_unicast+0xf3e/0x1020 net/netlink/af_netlink.c:1337
  netlink_sendmsg+0x127e/0x12f0 net/netlink/af_netlink.c:1926
  sock_sendmsg_nosec net/socket.c:651 [inline]
  sock_sendmsg net/socket.c:661 [inline]
  ___sys_sendmsg+0xcc6/0x1200 net/socket.c:2260
  __sys_sendmsg net/socket.c:2298 [inline]
  __do_sys_sendmsg net/socket.c:2307 [inline]
  __se_sys_sendmsg+0x305/0x460 net/socket.c:2305
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2305
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x442639
Code: 41 02 00 85 c0 b8 00 00 00 00 48 0f 44 c3 5b c3 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00000000007efea8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000442639
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00000000007eff00 R08: 0000000000000003 R09: 0000000000000003
R10: 00000000bb1414ac R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000403c50 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:208 [inline]
  kmsan_internal_poison_shadow+0x92/0x150 mm/kmsan/kmsan.c:162
  kmsan_kmalloc+0xa4/0x130 mm/kmsan/kmsan_hooks.c:175
  kmsan_slab_alloc+0xe/0x10 mm/kmsan/kmsan_hooks.c:184
  slab_post_alloc_hook mm/slab.h:442 [inline]
  slab_alloc_node mm/slub.c:2771 [inline]
  __kmalloc_node_track_caller+0xcba/0xf30 mm/slub.c:4399
  __kmalloc_reserve net/core/skbuff.c:140 [inline]
  __alloc_skb+0x306/0xa10 net/core/skbuff.c:208
  alloc_skb include/linux/skbuff.h:1059 [inline]
  netlink_alloc_large_skb net/netlink/af_netlink.c:1183 [inline]
  netlink_sendmsg+0xb81/0x12f0 net/netlink/af_netlink.c:1901
  sock_sendmsg_nosec net/socket.c:651 [inline]
  sock_sendmsg net/socket.c:661 [inline]
  ___sys_sendmsg+0xcc6/0x1200 net/socket.c:2260
  __sys_sendmsg net/socket.c:2298 [inline]
  __do_sys_sendmsg net/socket.c:2307 [inline]
  __se_sys_sendmsg+0x305/0x460 net/socket.c:2305
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2305
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
