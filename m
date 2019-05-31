Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D51D53071B
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 05:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfEaDsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 23:48:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:47247 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfEaDsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 23:48:07 -0400
Received: by mail-io1-f69.google.com with SMTP id r27so6512296iob.14
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 20:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ZY4THjifAaJLkq6CzGKGde3Hd+0/DlckHGeMC1I6vds=;
        b=HEHVt/Xk6SbHa2/V54Gj3xntRHelfXgv3DB+G3AR6PLCBF3X7i2t51emj4eLNCvkQW
         YT3Ec08Nf3JFTJTB8CAw0ndRunTUFbQXBc8GRQTae1IVOIcqSzkpnezE3CZqSHPb/Nxs
         eKOfo+jV70vtQOFGfWNjY+tH4NrCgXuSILkZzOJX3J+wNp83VyLDI09TWaSqUfCTuP31
         U5qRLVtWZGeyQ3xYtPXa9QktSoytUu2ZY7w6GZVv2Rf/chFQtmHhXUDb7d2x4A+s2ZoY
         l42ptggCJdHv3ehQI9ZK9E+4Rz4sNufDJzf036tC40j9rznRn5K4gsHbpM3TP0O/dSkf
         VITQ==
X-Gm-Message-State: APjAAAWmGGZowA5rDe8ohwSVSN7OA80vfDSWCLI2W2FMK4wbWpBn/9u2
        D3uF+gF+LXPzRj1uZ1RvBGB6QDxmxORipn6iVlBeX/BCsl3V
X-Google-Smtp-Source: APXvYqy2RJM11TMJKMIz/mjDJvs2BGYyQRp6rybjPaBIeC20R+SxjQ69BUzoYugrqVtyhkj2ZPXtT8BbUMqSCTwLb+mN7v7/lLkU
MIME-Version: 1.0
X-Received: by 2002:a5e:d70c:: with SMTP id v12mr4694981iom.12.1559274486069;
 Thu, 30 May 2019 20:48:06 -0700 (PDT)
Date:   Thu, 30 May 2019 20:48:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d981f1058a26e1a8@google.com>
Subject: memory leak in pppoe_sendmsg
From:   syzbot <syzbot+6bdfd184eac7709e5cc9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        mostrows@earthlink.net, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    bec7550c Merge tag 'docs-5.2-fixes2' of git://git.lwn.net/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1280ecbaa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=64479170dcaf0e11
dashboard link: https://syzkaller.appspot.com/bug?extid=6bdfd184eac7709e5cc9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17112572a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6bdfd184eac7709e5cc9@syzkaller.appspotmail.com

2019/05/30 11:35:26 executed programs: 9
2019/05/30 11:35:32 executed programs: 11
2019/05/30 11:35:38 executed programs: 13
2019/05/30 11:35:44 executed programs: 15
2019/05/30 11:35:50 executed programs: 17
BUG: memory leak
unreferenced object 0xffff888124199500 (size 224):
   comm "syz-executor.0", pid 7122, jiffies 4295041954 (age 13.860s)
   hex dump (first 32 bytes):
     00 96 19 24 81 88 ff ff d0 20 0e 2a 81 88 ff ff  ...$..... .*....
     00 00 00 00 00 00 00 00 00 20 0e 2a 81 88 ff ff  ......... .*....
   backtrace:
     [<00000000688f689a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000688f689a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000688f689a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000688f689a>] kmem_cache_alloc_node+0x153/0x2a0 mm/slab.c:3579
     [<00000000e781c880>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:198
     [<000000004ce3be0b>] alloc_skb include/linux/skbuff.h:1058 [inline]
     [<000000004ce3be0b>] sock_wmalloc+0x4f/0x80 net/core/sock.c:2077
     [<000000008110994c>] pppoe_sendmsg+0xd0/0x250  
drivers/net/ppp/pppoe.c:871
     [<00000000c1e51321>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000c1e51321>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<000000008012ebfd>] ___sys_sendmsg+0x194/0x3c0 net/socket.c:2292
     [<0000000087b8ef6f>] __sys_sendmmsg+0xf4/0x270 net/socket.c:2387
     [<000000002b3700b1>] __do_sys_sendmmsg net/socket.c:2416 [inline]
     [<000000002b3700b1>] __se_sys_sendmmsg net/socket.c:2413 [inline]
     [<000000002b3700b1>] __x64_sys_sendmmsg+0x28/0x30 net/socket.c:2413
     [<0000000028e31f9f>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000004279bc05>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888115706600 (size 512):
   comm "syz-executor.0", pid 7122, jiffies 4295041954 (age 13.860s)
   hex dump (first 32 bytes):
     23 32 aa aa aa aa aa 0a aa aa aa aa aa 0a 88 64  #2.............d
     11 00 04 00 00 00 70 72 6f 66 69 6c 65 3d 30 20  ......profile=0
   backtrace:
     [<00000000c07b4ae3>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000c07b4ae3>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000c07b4ae3>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000c07b4ae3>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000e84718bb>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000e84718bb>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3634
     [<000000008692fea3>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:142
     [<00000000da312aad>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:210
     [<000000004ce3be0b>] alloc_skb include/linux/skbuff.h:1058 [inline]
     [<000000004ce3be0b>] sock_wmalloc+0x4f/0x80 net/core/sock.c:2077
     [<000000008110994c>] pppoe_sendmsg+0xd0/0x250  
drivers/net/ppp/pppoe.c:871
     [<00000000c1e51321>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000c1e51321>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<000000008012ebfd>] ___sys_sendmsg+0x194/0x3c0 net/socket.c:2292
     [<0000000087b8ef6f>] __sys_sendmmsg+0xf4/0x270 net/socket.c:2387
     [<000000002b3700b1>] __do_sys_sendmmsg net/socket.c:2416 [inline]
     [<000000002b3700b1>] __se_sys_sendmmsg net/socket.c:2413 [inline]
     [<000000002b3700b1>] __x64_sys_sendmmsg+0x28/0x30 net/socket.c:2413
     [<0000000028e31f9f>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000004279bc05>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888124199600 (size 224):
   comm "syz-executor.0", pid 7122, jiffies 4295041954 (age 13.860s)
   hex dump (first 32 bytes):
     00 97 19 24 81 88 ff ff 00 95 19 24 81 88 ff ff  ...$.......$....
     00 00 00 00 00 00 00 00 00 20 0e 2a 81 88 ff ff  ......... .*....
   backtrace:
     [<00000000688f689a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000688f689a>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000688f689a>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000688f689a>] kmem_cache_alloc_node+0x153/0x2a0 mm/slab.c:3579
     [<00000000e781c880>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:198
     [<000000004ce3be0b>] alloc_skb include/linux/skbuff.h:1058 [inline]
     [<000000004ce3be0b>] sock_wmalloc+0x4f/0x80 net/core/sock.c:2077
     [<000000008110994c>] pppoe_sendmsg+0xd0/0x250  
drivers/net/ppp/pppoe.c:871
     [<00000000c1e51321>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000c1e51321>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<000000008012ebfd>] ___sys_sendmsg+0x194/0x3c0 net/socket.c:2292
     [<0000000087b8ef6f>] __sys_sendmmsg+0xf4/0x270 net/socket.c:2387
     [<000000002b3700b1>] __do_sys_sendmmsg net/socket.c:2416 [inline]
     [<000000002b3700b1>] __se_sys_sendmmsg net/socket.c:2413 [inline]
     [<000000002b3700b1>] __x64_sys_sendmmsg+0x28/0x30 net/socket.c:2413
     [<0000000028e31f9f>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000004279bc05>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811a0b2600 (size 512):
   comm "syz-executor.0", pid 7122, jiffies 4295041954 (age 13.860s)
   hex dump (first 32 bytes):
     00 00 aa aa aa aa aa 0a aa aa aa aa aa 0a 88 64  ...............d
     11 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000c07b4ae3>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000c07b4ae3>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000c07b4ae3>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000c07b4ae3>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000e84718bb>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000e84718bb>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3634
     [<000000008692fea3>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:142
     [<00000000da312aad>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:210
     [<000000004ce3be0b>] alloc_skb include/linux/skbuff.h:1058 [inline]
     [<000000004ce3be0b>] sock_wmalloc+0x4f/0x80 net/core/sock.c:2077
     [<000000008110994c>] pppoe_sendmsg+0xd0/0x250  
drivers/net/ppp/pppoe.c:871
     [<00000000c1e51321>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000c1e51321>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<000000008012ebfd>] ___sys_sendmsg+0x194/0x3c0 net/socket.c:2292
     [<0000000087b8ef6f>] __sys_sendmmsg+0xf4/0x270 net/socket.c:2387
     [<000000002b3700b1>] __do_sys_sendmmsg net/socket.c:2416 [inline]
     [<000000002b3700b1>] __se_sys_sendmmsg net/socket.c:2413 [inline]
     [<000000002b3700b1>] __x64_sys_sendmmsg+0x28/0x30 net/socket.c:2413
     [<0000000028e31f9f>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000004279bc05>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
