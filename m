Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1899E152014
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 18:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbgBDR6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 12:58:14 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:54604 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727363AbgBDR6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 12:58:14 -0500
Received: by mail-io1-f71.google.com with SMTP id r62so12217800ior.21
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 09:58:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Um3Xpzx3vG7vvdGcvA/0vPPxMKJre/Qdw6/82ARcNPc=;
        b=QAfkGF7p+APwOSmX6/GtrvU+wkwtsI3VzZy5UlMhGiw+v+FdcWHuyOHoqRLjIlsonL
         3o8L9b9R9vFO4jKlCswvFuA1Fzg/6dccojq8Q/VWXxRuaEJaWdnari+7EIXMjMOQkywf
         7iAQdqojIcItPqerl00QXm0Y16CmJ2joKbxCqfYwAtfoVrc8B6fBk1sWgAj5KBWatQIV
         CiwJHCU96bZOb/T87I5QpjRks0qCxdur+NfHVDydDCqgL31caVstbaKrIbuIzHXOXDAf
         Y8jkSQYtISLZpQ055V9QVei0zpTetZtAAG0QXfLt4/iwZ7d8L+kPlc9wjrMoF7GTipHh
         Sikg==
X-Gm-Message-State: APjAAAXNIS/DK1BA1uNi5OlcI0Xf9YyxqD8PFGapYuwSRXf4CebsoQJo
        VvXXmWt6U2lmgYtCH0DxldU7OPJoESoyQQgeUuvlyhz29vWR
X-Google-Smtp-Source: APXvYqz/k4Imyeeca95alZX24eMTHmjPtFwnVqBqXMpEoIKiVc1JLT2fCo9+2dodxN3LxxIeANc25wcdden+gG5lgaAfBgztARLH
MIME-Version: 1.0
X-Received: by 2002:a6b:8e51:: with SMTP id q78mr23341440iod.179.1580839093292;
 Tue, 04 Feb 2020 09:58:13 -0800 (PST)
Date:   Tue, 04 Feb 2020 09:58:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009a59d2059dc3c8e9@google.com>
Subject: memory leak in tcindex_set_parms
From:   syzbot <syzbot+f0bbb2287b8993d4fa74@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    322bf2d3 Merge branch 'for-5.6' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1111f8e6e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8d0490614a000a37
dashboard link: https://syzkaller.appspot.com/bug?extid=f0bbb2287b8993d4fa74
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17db90f6e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a94511e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f0bbb2287b8993d4fa74@syzkaller.appspotmail.com

executing program
executing program
BUG: memory leak
unreferenced object 0xffff88811ee18c00 (size 256):
  comm "syz-executor278", pid 7255, jiffies 4294941828 (age 13.710s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000004705b10>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<0000000004705b10>] slab_post_alloc_hook mm/slab.h:586 [inline]
    [<0000000004705b10>] slab_alloc mm/slab.c:3320 [inline]
    [<0000000004705b10>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3549
    [<000000005a926de7>] kmalloc include/linux/slab.h:556 [inline]
    [<000000005a926de7>] kmalloc_array include/linux/slab.h:597 [inline]
    [<000000005a926de7>] kcalloc include/linux/slab.h:609 [inline]
    [<000000005a926de7>] tcf_exts_init include/net/pkt_cls.h:210 [inline]
    [<000000005a926de7>] tcindex_set_parms+0xac/0x970 net/sched/cls_tcindex.c:313
    [<000000004198237d>] tcindex_change+0xd8/0x110 net/sched/cls_tcindex.c:519
    [<00000000f90be4e9>] tc_new_tfilter+0x566/0xf50 net/sched/cls_api.c:2103
    [<00000000bdffab68>] rtnetlink_rcv_msg+0x3b2/0x4b0 net/core/rtnetlink.c:5429
    [<000000008de6f6fa>] netlink_rcv_skb+0x61/0x170 net/netlink/af_netlink.c:2477
    [<00000000637db501>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5456
    [<00000000cb1396a7>] netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
    [<00000000cb1396a7>] netlink_unicast+0x223/0x310 net/netlink/af_netlink.c:1328
    [<000000003d9f7439>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink.c:1917
    [<0000000004922ee9>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<0000000004922ee9>] sock_sendmsg+0x54/0x70 net/socket.c:672
    [<00000000bbc6917f>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2343
    [<00000000d3ae3854>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2397
    [<0000000000c5372b>] __sys_sendmsg+0x80/0xf0 net/socket.c:2430
    [<00000000db15859a>] __do_sys_sendmsg net/socket.c:2439 [inline]
    [<00000000db15859a>] __se_sys_sendmsg net/socket.c:2437 [inline]
    [<00000000db15859a>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2437
    [<00000000a5a1c036>] do_syscall_64+0x73/0x220 arch/x86/entry/common.c:294
    [<00000000e73613df>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811ee18900 (size 256):
  comm "syz-executor278", pid 7255, jiffies 4294941828 (age 13.710s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000004705b10>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<0000000004705b10>] slab_post_alloc_hook mm/slab.h:586 [inline]
    [<0000000004705b10>] slab_alloc mm/slab.c:3320 [inline]
    [<0000000004705b10>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3549
    [<0000000036dbc592>] kmalloc include/linux/slab.h:556 [inline]
    [<0000000036dbc592>] kmalloc_array include/linux/slab.h:597 [inline]
    [<0000000036dbc592>] kcalloc include/linux/slab.h:609 [inline]
    [<0000000036dbc592>] tcf_exts_init include/net/pkt_cls.h:210 [inline]
    [<0000000036dbc592>] tcindex_alloc_perfect_hash net/sched/cls_tcindex.c:287 [inline]
    [<0000000036dbc592>] tcindex_alloc_perfect_hash+0x8f/0xf0 net/sched/cls_tcindex.c:277
    [<0000000088e6ec51>] tcindex_set_parms+0x831/0x970 net/sched/cls_tcindex.c:405
    [<000000004198237d>] tcindex_change+0xd8/0x110 net/sched/cls_tcindex.c:519
    [<00000000f90be4e9>] tc_new_tfilter+0x566/0xf50 net/sched/cls_api.c:2103
    [<00000000bdffab68>] rtnetlink_rcv_msg+0x3b2/0x4b0 net/core/rtnetlink.c:5429
    [<000000008de6f6fa>] netlink_rcv_skb+0x61/0x170 net/netlink/af_netlink.c:2477
    [<00000000637db501>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5456
    [<00000000cb1396a7>] netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
    [<00000000cb1396a7>] netlink_unicast+0x223/0x310 net/netlink/af_netlink.c:1328
    [<000000003d9f7439>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink.c:1917
    [<0000000004922ee9>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<0000000004922ee9>] sock_sendmsg+0x54/0x70 net/socket.c:672
    [<00000000bbc6917f>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2343
    [<00000000d3ae3854>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2397
    [<0000000000c5372b>] __sys_sendmsg+0x80/0xf0 net/socket.c:2430
    [<00000000db15859a>] __do_sys_sendmsg net/socket.c:2439 [inline]
    [<00000000db15859a>] __se_sys_sendmsg net/socket.c:2437 [inline]
    [<00000000db15859a>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2437
    [<00000000a5a1c036>] do_syscall_64+0x73/0x220 arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff88811ee18800 (size 256):
  comm "syz-executor278", pid 7255, jiffies 4294941828 (age 13.710s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000004705b10>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<0000000004705b10>] slab_post_alloc_hook mm/slab.h:586 [inline]
    [<0000000004705b10>] slab_alloc mm/slab.c:3320 [inline]
    [<0000000004705b10>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3549
    [<0000000036dbc592>] kmalloc include/linux/slab.h:556 [inline]
    [<0000000036dbc592>] kmalloc_array include/linux/slab.h:597 [inline]
    [<0000000036dbc592>] kcalloc include/linux/slab.h:609 [inline]
    [<0000000036dbc592>] tcf_exts_init include/net/pkt_cls.h:210 [inline]
    [<0000000036dbc592>] tcindex_alloc_perfect_hash net/sched/cls_tcindex.c:287 [inline]
    [<0000000036dbc592>] tcindex_alloc_perfect_hash+0x8f/0xf0 net/sched/cls_tcindex.c:277
    [<0000000088e6ec51>] tcindex_set_parms+0x831/0x970 net/sched/cls_tcindex.c:405
    [<000000004198237d>] tcindex_change+0xd8/0x110 net/sched/cls_tcindex.c:519
    [<00000000f90be4e9>] tc_new_tfilter+0x566/0xf50 net/sched/cls_api.c:2103
    [<00000000bdffab68>] rtnetlink_rcv_msg+0x3b2/0x4b0 net/core/rtnetlink.c:5429
    [<000000008de6f6fa>] netlink_rcv_skb+0x61/0x170 net/netlink/af_netlink.c:2477
    [<00000000637db501>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5456
    [<00000000cb1396a7>] netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
    [<00000000cb1396a7>] netlink_unicast+0x223/0x310 net/netlink/af_netlink.c:1328
    [<000000003d9f7439>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink.c:1917
    [<0000000004922ee9>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<0000000004922ee9>] sock_sendmsg+0x54/0x70 net/socket.c:672
    [<00000000bbc6917f>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2343
    [<00000000d3ae3854>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2397
    [<0000000000c5372b>] __sys_sendmsg+0x80/0xf0 net/socket.c:2430
    [<00000000db15859a>] __do_sys_sendmsg net/socket.c:2439 [inline]
    [<00000000db15859a>] __se_sys_sendmsg net/socket.c:2437 [inline]
    [<00000000db15859a>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2437
    [<00000000a5a1c036>] do_syscall_64+0x73/0x220 arch/x86/entry/common.c:294



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
