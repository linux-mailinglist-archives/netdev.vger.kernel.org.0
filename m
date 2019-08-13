Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F9A8BAB9
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 15:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbfHMNsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 09:48:06 -0400
Received: from mail-ot1-f72.google.com ([209.85.210.72]:46381 "EHLO
        mail-ot1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729208AbfHMNsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 09:48:06 -0400
Received: by mail-ot1-f72.google.com with SMTP id g6so30325667otq.13
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 06:48:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wI5i1u19Qg/2UzcnukBir3zrUEiLPgI3wzEdXh6RbDM=;
        b=ewLOFewLuFZiR1SWps0D3bcn15OX6LDCIXXv8WufxN6WwXN+g1bvai0z8VciCNJYDC
         8wxCGW/GK80rEnwmf2PGzyvoJwFeo3w1JWjjjqaDzPhd8nuTKzZHiknzXEUPtHVks6k8
         L4IHFqTkMJB0P+sEfgp2ORi9jkM6pe76vOKuPkZP8KRxgzrMRC/XWHzYsz9DyQR7uth4
         PkYs03wtBvV1soeeJAdeSp4J4eW3vP4S4Zh2iM/KADicNuUl0JLfm07ZC4QjA/tcyXV6
         +B72dzbNlhiCJ30NmaYQIvIRae7+dgC9rHa6qhEmhmiPKMts4d/3fwq17TotTyfJ97/7
         CS8Q==
X-Gm-Message-State: APjAAAXOeXki5JyFpQx72yneIRMt1uigMDLYJ56s9cE2sUGShogLCUpD
        gR8OvDuarLVIawLx4OcS7t4d7MC78u+pe1rkBy3diveJ0Wlo
X-Google-Smtp-Source: APXvYqyOW1hZvK9p5ysBJ9VWjLasAaMZ3upF6H5W+mnrn9EqpuDhSJixt+b//48TMNxd35+dQHCBy1HkAaa/HDB2vFx/A4jeXNBl
MIME-Version: 1.0
X-Received: by 2002:a6b:3883:: with SMTP id f125mr26119162ioa.109.1565704085561;
 Tue, 13 Aug 2019 06:48:05 -0700 (PDT)
Date:   Tue, 13 Aug 2019 06:48:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d7edc0058fffe31a@google.com>
Subject: KMSAN: uninit-value in nh_valid_get_del_req
From:   syzbot <syzbot+86ec9d8c02c07571873c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, glider@google.com,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    61ccdad1 Revert "drm/bochs: Use shadow buffer for bochs fr..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=14c120e2600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=27abc558ecb16a3b
dashboard link: https://syzkaller.appspot.com/bug?extid=86ec9d8c02c07571873c
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15ed6c4a600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11de024a600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+86ec9d8c02c07571873c@syzkaller.appspotmail.com

==================================================================
BUG: KMSAN: uninit-value in nh_valid_get_del_req+0x6f1/0x8c0  
net/ipv4/nexthop.c:1510
CPU: 0 PID: 11812 Comm: syz-executor444 Not tainted 5.3.0-rc3+ #17
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x162/0x2d0 mm/kmsan/kmsan_report.c:109
  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:294
  nh_valid_get_del_req+0x6f1/0x8c0 net/ipv4/nexthop.c:1510
  rtm_del_nexthop+0x1b1/0x610 net/ipv4/nexthop.c:1543
  rtnetlink_rcv_msg+0x115a/0x1580 net/core/rtnetlink.c:5223
  netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2477
  rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5241
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0xf6c/0x1050 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x110f/0x1330 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  ___sys_sendmsg+0x14ff/0x1590 net/socket.c:2311
  __sys_sendmmsg+0x53a/0xae0 net/socket.c:2413
  __do_sys_sendmmsg net/socket.c:2442 [inline]
  __se_sys_sendmmsg+0xbd/0xe0 net/socket.c:2439
  __x64_sys_sendmmsg+0x56/0x70 net/socket.c:2439
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:297
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x440259
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff15f10d08 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440259
RDX: 0492492492492805 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401ae0
R13: 0000000000401b70 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:187 [inline]
  kmsan_internal_poison_shadow+0x53/0xa0 mm/kmsan/kmsan.c:146
  kmsan_slab_alloc+0xaa/0x120 mm/kmsan/kmsan_hooks.c:175
  slab_alloc_node mm/slub.c:2790 [inline]
  __kmalloc_node_track_caller+0xb55/0x1320 mm/slub.c:4388
  __kmalloc_reserve net/core/skbuff.c:141 [inline]
  __alloc_skb+0x306/0xa10 net/core/skbuff.c:209
  alloc_skb include/linux/skbuff.h:1056 [inline]
  netlink_alloc_large_skb net/netlink/af_netlink.c:1174 [inline]
  netlink_sendmsg+0x783/0x1330 net/netlink/af_netlink.c:1892
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  ___sys_sendmsg+0x14ff/0x1590 net/socket.c:2311
  __sys_sendmmsg+0x53a/0xae0 net/socket.c:2413
  __do_sys_sendmmsg net/socket.c:2442 [inline]
  __se_sys_sendmmsg+0xbd/0xe0 net/socket.c:2439
  __x64_sys_sendmmsg+0x56/0x70 net/socket.c:2439
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:297
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
