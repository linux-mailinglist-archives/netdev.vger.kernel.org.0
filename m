Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4738246F384
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 19:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhLITBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 14:01:00 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:52925 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbhLITA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 14:00:59 -0500
Received: by mail-il1-f197.google.com with SMTP id y3-20020a056e021be300b0029f6c440695so8084897ilv.19
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 10:57:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/jThWv1+SPBGbAQPgT8sXYErXG2da2eSKsxQaEVinZw=;
        b=HDZpwJHuCSGkQ/rwWCv7Er8aZ72t92SLYRnup4Fbh34cJyxp54riRPZE1xq9spEc5F
         VsxsdjFpIv0vghw9Tj6KzzdtYKlx1+9A2puYhSzLXGNmx7UqXb1gAnUnvK5BihF1UeZ6
         BDF8RGAoDA2an8fkBkaSK5RG85gLXDNWV61MH50OlrS+vkv16XoJ0QxMNRVau6m/hbmj
         CB83bZBhbpr6ZPd+gF3vN7sntQpzMngSvLFiHpqIuO+Kpvr/MApHdwque8W8fi846G6P
         B4CCtKmBiuD/OIgDJa+pXmqoc7ARYnXyqjq9/SskdVTXRFbutczpNqkXPt5Y/vQLIL9T
         +abA==
X-Gm-Message-State: AOAM531MpT/85hyHW0cLblrhMDoG4IS4fwM59c0KxuKkyUWwdpYz9wIl
        2uxXCYHn0j9wu/WStwzIzw9d+GRHARKOGLZjdGQM84SX6n2/
X-Google-Smtp-Source: ABdhPJz82AA/+SMk0aKZyWv6ABiSNqDw7paWLHJE6pw01mtk/Hvb3p7U0DB2vG49SJH4XwOflwBoFMRX3Lj/AOASDzGt5B8EIJ0q
MIME-Version: 1.0
X-Received: by 2002:a6b:7711:: with SMTP id n17mr15974209iom.21.1639076245171;
 Thu, 09 Dec 2021 10:57:25 -0800 (PST)
Date:   Thu, 09 Dec 2021 10:57:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005a735005d2bb2dff@google.com>
Subject: [syzbot] KMSAN: uninit-value in fib_get_nhs
From:   syzbot <syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    8b936c96768e kmsan: core: remove the accidentally committe..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1724ebc5b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e00a8959fdd3f3e8
dashboard link: https://syzkaller.appspot.com/bug?extid=d4b9a2851cc3ce998741
compiler:       clang version 14.0.0 (git@github.com:llvm/llvm-project.git 0996585c8e3b3d409494eb5f1cad714b9e1f7fb5), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1225f875b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139513c5b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in fib_get_nhs+0xac4/0x1f80 net/ipv4/fib_semantics.c:708
 fib_get_nhs+0xac4/0x1f80 net/ipv4/fib_semantics.c:708
 fib_create_info+0x2411/0x4870 net/ipv4/fib_semantics.c:1453
 fib_table_insert+0x45c/0x3a10 net/ipv4/fib_trie.c:1224
 inet_rtm_newroute+0x289/0x420 net/ipv4/fib_frontend.c:886
 rtnetlink_rcv_msg+0x145d/0x18c0 net/core/rtnetlink.c:5571
 netlink_rcv_skb+0x447/0x800 net/netlink/af_netlink.c:2491
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5589
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x1095/0x1360 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x16f3/0x1870 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0xe11/0x12c0 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmsg+0x4a5/0x640 net/socket.c:2492
 __do_sys_sendmsg net/socket.c:2501 [inline]
 __se_sys_sendmsg net/socket.c:2499 [inline]
 __x64_sys_sendmsg+0xe2/0x120 net/socket.c:2499
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:3251 [inline]
 __kmalloc_node_track_caller+0xe0c/0x1510 mm/slub.c:4974
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1126 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1191 [inline]
 netlink_sendmsg+0xe93/0x1870 net/netlink/af_netlink.c:1891
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0xe11/0x12c0 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmsg+0x4a5/0x640 net/socket.c:2492
 __do_sys_sendmsg net/socket.c:2501 [inline]
 __se_sys_sendmsg net/socket.c:2499 [inline]
 __x64_sys_sendmsg+0xe2/0x120 net/socket.c:2499
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

CPU: 0 PID: 6371 Comm: syz-executor193 Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
