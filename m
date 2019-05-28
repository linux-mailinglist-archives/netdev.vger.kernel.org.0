Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 599322BCCB
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 03:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfE1BUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 21:20:07 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:52114 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727271AbfE1BUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 21:20:07 -0400
Received: by mail-it1-f200.google.com with SMTP id g1so1043176itd.1
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 18:20:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=4u3mMMg2RgVRM4w7OUmFknZ6ThxIhv1XclEq3t7eyF8=;
        b=otv92C90jkzLIFsy9mhdLrQwu/Z2wm6wLcpbr6uAVFqRpkq5QDyAMuNIICHeqENLzc
         eqQLOh/lVSu3dwLdZXAJt+Z354w+FznN0D9ZEJiv9Mc/Sq9V6i6uc8/edMkmg+EZmYHY
         XV5aWTiP4CgwyiOHmrwHHA/scqCzp8jiDz0Ezh8cL+3feiQFBMS4JSb1qfGVPGPeVw8e
         QQPF92NqAlOjaJDHzO0EjPmBbHpEzMiiHb017iToenSI91zAMiZ3Zt0lmOHstMDWuku0
         QIGCKPU/LFEjBdYeA2AO+cMVWlr6RekP/sjprR72YYnpSeOi2xDb5S8gl3PJljbvxK0t
         t82A==
X-Gm-Message-State: APjAAAXxmLu11z2Jhc/bHlc93Hajaf/IR0ItWudzLYBd/VTm2GxuVvBU
        0LMOHfnluAGdG7Riw87OR1POH53iRY1oI/RKQTC1BXOL5wQS
X-Google-Smtp-Source: APXvYqy37eWcE8HoAFU3enzaEqFUmM9/hPduPFlrkjlcT4tf14L01xfCyccAvvjBpzZ+s5L105U9cN/euZG25T72GTRwGP9BrGWt
MIME-Version: 1.0
X-Received: by 2002:a24:2b81:: with SMTP id h123mr1290339ita.124.1559006405935;
 Mon, 27 May 2019 18:20:05 -0700 (PDT)
Date:   Mon, 27 May 2019 18:20:05 -0700
In-Reply-To: <000000000000ea09dd0589e3af1a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000756310589e877ce@google.com>
Subject: Re: memory leak in hsr_create_self_node
From:   syzbot <syzbot+c6167ec3de7def23d1e8@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    cd6c84d8 Linux 5.2-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10aa46c4a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=64479170dcaf0e11
dashboard link: https://syzkaller.appspot.com/bug?extid=c6167ec3de7def23d1e8
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13787616a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17a5119aa00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c6167ec3de7def23d1e8@syzkaller.appspotmail.com

    68.477885][    T7] team0 (unregistering): Port device team_slave_0  
removed
BUG: memory leak
unreferenced object 0xffff8881143dfb00 (size 128):
   comm "syz-executor744", pid 6995, jiffies 4294943713 (age 30.830s)
   hex dump (first 32 bytes):
     f0 68 38 15 81 88 ff ff f0 68 38 15 81 88 ff ff  .h8......h8.....
     ea ff ec 35 72 e3 56 fe 48 40 f2 12 8a 83 76 ee  ...5r.V.H@....v.
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000002bcc4522>] kmalloc include/linux/slab.h:547 [inline]
     [<000000002bcc4522>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<00000000e4882852>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811406fa40 (size 64):
   comm "syz-executor744", pid 6995, jiffies 4294943713 (age 30.830s)
   hex dump (first 32 bytes):
     00 2a b5 14 81 88 ff ff 00 02 00 00 00 00 ad de  .*..............
     00 60 38 15 81 88 ff ff c0 68 38 15 81 88 ff ff  .`8......h8.....
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000005da31874>] kmalloc include/linux/slab.h:547 [inline]
     [<000000005da31874>] kzalloc include/linux/slab.h:742 [inline]
     [<000000005da31874>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000c1ae433c>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888114b52a00 (size 64):
   comm "syz-executor744", pid 6995, jiffies 4294943716 (age 30.800s)
   hex dump (first 32 bytes):
     d0 68 38 15 81 88 ff ff 00 02 00 00 00 00 ad de  .h8.............
     00 80 06 14 81 88 ff ff c0 68 38 15 81 88 ff ff  .........h8.....
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000005da31874>] kmalloc include/linux/slab.h:547 [inline]
     [<000000005da31874>] kzalloc include/linux/slab.h:742 [inline]
     [<000000005da31874>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000c198c9a6>] hsr_dev_finalize+0x1d1/0x233  
net/hsr/hsr_device.c:480
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881143dfb00 (size 128):
   comm "syz-executor744", pid 6995, jiffies 4294943713 (age 30.890s)
   hex dump (first 32 bytes):
     f0 68 38 15 81 88 ff ff f0 68 38 15 81 88 ff ff  .h8......h8.....
     ea ff ec 35 72 e3 56 fe 48 40 f2 12 8a 83 76 ee  ...5r.V.H@....v.
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000002bcc4522>] kmalloc include/linux/slab.h:547 [inline]
     [<000000002bcc4522>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<00000000e4882852>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811406fa40 (size 64):
   comm "syz-executor744", pid 6995, jiffies 4294943713 (age 30.890s)
   hex dump (first 32 bytes):
     00 2a b5 14 81 88 ff ff 00 02 00 00 00 00 ad de  .*..............
     00 60 38 15 81 88 ff ff c0 68 38 15 81 88 ff ff  .`8......h8.....
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000005da31874>] kmalloc include/linux/slab.h:547 [inline]
     [<000000005da31874>] kzalloc include/linux/slab.h:742 [inline]
     [<000000005da31874>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000c1ae433c>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888114b52a00 (size 64):
   comm "syz-executor744", pid 6995, jiffies 4294943716 (age 30.860s)
   hex dump (first 32 bytes):
     d0 68 38 15 81 88 ff ff 00 02 00 00 00 00 ad de  .h8.............
     00 80 06 14 81 88 ff ff c0 68 38 15 81 88 ff ff  .........h8.....
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000005da31874>] kmalloc include/linux/slab.h:547 [inline]
     [<000000005da31874>] kzalloc include/linux/slab.h:742 [inline]
     [<000000005da31874>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000c198c9a6>] hsr_dev_finalize+0x1d1/0x233  
net/hsr/hsr_device.c:480
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881143dfb00 (size 128):
   comm "syz-executor744", pid 6995, jiffies 4294943713 (age 30.950s)
   hex dump (first 32 bytes):
     f0 68 38 15 81 88 ff ff f0 68 38 15 81 88 ff ff  .h8......h8.....
     ea ff ec 35 72 e3 56 fe 48 40 f2 12 8a 83 76 ee  ...5r.V.H@....v.
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000002bcc4522>] kmalloc include/linux/slab.h:547 [inline]
     [<000000002bcc4522>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<00000000e4882852>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811406fa40 (size 64):
   comm "syz-executor744", pid 6995, jiffies 4294943713 (age 30.950s)
   hex dump (first 32 bytes):
     00 2a b5 14 81 88 ff ff 00 02 00 00 00 00 ad de  .*..............
     00 60 38 15 81 88 ff ff c0 68 38 15 81 88 ff ff  .`8......h8.....
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000005da31874>] kmalloc include/linux/slab.h:547 [inline]
     [<000000005da31874>] kzalloc include/linux/slab.h:742 [inline]
     [<000000005da31874>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000c1ae433c>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888114b52a00 (size 64):
   comm "syz-executor744", pid 6995, jiffies 4294943716 (age 30.920s)
   hex dump (first 32 bytes):
     d0 68 38 15 81 88 ff ff 00 02 00 00 00 00 ad de  .h8.............
     00 80 06 14 81 88 ff ff c0 68 38 15 81 88 ff ff  .........h8.....
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000005da31874>] kmalloc include/linux/slab.h:547 [inline]
     [<000000005da31874>] kzalloc include/linux/slab.h:742 [inline]
     [<000000005da31874>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000c198c9a6>] hsr_dev_finalize+0x1d1/0x233  
net/hsr/hsr_device.c:480
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881143dfb00 (size 128):
   comm "syz-executor744", pid 6995, jiffies 4294943713 (age 31.010s)
   hex dump (first 32 bytes):
     f0 68 38 15 81 88 ff ff f0 68 38 15 81 88 ff ff  .h8......h8.....
     ea ff ec 35 72 e3 56 fe 48 40 f2 12 8a 83 76 ee  ...5r.V.H@....v.
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000002bcc4522>] kmalloc include/linux/slab.h:547 [inline]
     [<000000002bcc4522>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<00000000e4882852>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811406fa40 (size 64):
   comm "syz-executor744", pid 6995, jiffies 4294943713 (age 31.010s)
   hex dump (first 32 bytes):
     00 2a b5 14 81 88 ff ff 00 02 00 00 00 00 ad de  .*..............
     00 60 38 15 81 88 ff ff c0 68 38 15 81 88 ff ff  .`8......h8.....
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000005da31874>] kmalloc include/linux/slab.h:547 [inline]
     [<000000005da31874>] kzalloc include/linux/slab.h:742 [inline]
     [<000000005da31874>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000c1ae433c>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888114b52a00 (size 64):
   comm "syz-executor744", pid 6995, jiffies 4294943716 (age 30.980s)
   hex dump (first 32 bytes):
     d0 68 38 15 81 88 ff ff 00 02 00 00 00 00 ad de  .h8.............
     00 80 06 14 81 88 ff ff c0 68 38 15 81 88 ff ff  .........h8.....
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000005da31874>] kmalloc include/linux/slab.h:547 [inline]
     [<000000005da31874>] kzalloc include/linux/slab.h:742 [inline]
     [<000000005da31874>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000c198c9a6>] hsr_dev_finalize+0x1d1/0x233  
net/hsr/hsr_device.c:480
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881143dfb00 (size 128):
   comm "syz-executor744", pid 6995, jiffies 4294943713 (age 31.060s)
   hex dump (first 32 bytes):
     f0 68 38 15 81 88 ff ff f0 68 38 15 81 88 ff ff  .h8......h8.....
     ea ff ec 35 72 e3 56 fe 48 40 f2 12 8a 83 76 ee  ...5r.V.H@....v.
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000002bcc4522>] kmalloc include/linux/slab.h:547 [inline]
     [<000000002bcc4522>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<00000000e4882852>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811406fa40 (size 64):
   comm "syz-executor744", pid 6995, jiffies 4294943713 (age 31.060s)
   hex dump (first 32 bytes):
     00 2a b5 14 81 88 ff ff 00 02 00 00 00 00 ad de  .*..............
     00 60 38 15 81 88 ff ff c0 68 38 15 81 88 ff ff  .`8......h8.....
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000005da31874>] kmalloc include/linux/slab.h:547 [inline]
     [<000000005da31874>] kzalloc include/linux/slab.h:742 [inline]
     [<000000005da31874>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000c1ae433c>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888114b52a00 (size 64):
   comm "syz-executor744", pid 6995, jiffies 4294943716 (age 31.030s)
   hex dump (first 32 bytes):
     d0 68 38 15 81 88 ff ff 00 02 00 00 00 00 ad de  .h8.............
     00 80 06 14 81 88 ff ff c0 68 38 15 81 88 ff ff  .........h8.....
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000005da31874>] kmalloc include/linux/slab.h:547 [inline]
     [<000000005da31874>] kzalloc include/linux/slab.h:742 [inline]
     [<000000005da31874>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000c198c9a6>] hsr_dev_finalize+0x1d1/0x233  
net/hsr/hsr_device.c:480
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881143dfb00 (size 128):
   comm "syz-executor744", pid 6995, jiffies 4294943713 (age 31.120s)
   hex dump (first 32 bytes):
     f0 68 38 15 81 88 ff ff f0 68 38 15 81 88 ff ff  .h8......h8.....
     ea ff ec 35 72 e3 56 fe 48 40 f2 12 8a 83 76 ee  ...5r.V.H@....v.
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000002bcc4522>] kmalloc include/linux/slab.h:547 [inline]
     [<000000002bcc4522>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<00000000e4882852>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811406fa40 (size 64):
   comm "syz-executor744", pid 6995, jiffies 4294943713 (age 31.120s)
   hex dump (first 32 bytes):
     00 2a b5 14 81 88 ff ff 00 02 00 00 00 00 ad de  .*..............
     00 60 38 15 81 88 ff ff c0 68 38 15 81 88 ff ff  .`8......h8.....
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000005da31874>] kmalloc include/linux/slab.h:547 [inline]
     [<000000005da31874>] kzalloc include/linux/slab.h:742 [inline]
     [<000000005da31874>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000c1ae433c>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888114b52a00 (size 64):
   comm "syz-executor744", pid 6995, jiffies 4294943716 (age 31.090s)
   hex dump (first 32 bytes):
     d0 68 38 15 81 88 ff ff 00 02 00 00 00 00 ad de  .h8.............
     00 80 06 14 81 88 ff ff c0 68 38 15 81 88 ff ff  .........h8.....
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000005da31874>] kmalloc include/linux/slab.h:547 [inline]
     [<000000005da31874>] kzalloc include/linux/slab.h:742 [inline]
     [<000000005da31874>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000c198c9a6>] hsr_dev_finalize+0x1d1/0x233  
net/hsr/hsr_device.c:480
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881143dfb00 (size 128):
   comm "syz-executor744", pid 6995, jiffies 4294943713 (age 31.180s)
   hex dump (first 32 bytes):
     f0 68 38 15 81 88 ff ff f0 68 38 15 81 88 ff ff  .h8......h8.....
     ea ff ec 35 72 e3 56 fe 48 40 f2 12 8a 83 76 ee  ...5r.V.H@....v.
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000002bcc4522>] kmalloc include/linux/slab.h:547 [inline]
     [<000000002bcc4522>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<00000000e4882852>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811406fa40 (size 64):
   comm "syz-executor744", pid 6995, jiffies 4294943713 (age 31.180s)
   hex dump (first 32 bytes):
     00 2a b5 14 81 88 ff ff 00 02 00 00 00 00 ad de  .*..............
     00 60 38 15 81 88 ff ff c0 68 38 15 81 88 ff ff  .`8......h8.....
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000005da31874>] kmalloc include/linux/slab.h:547 [inline]
     [<000000005da31874>] kzalloc include/linux/slab.h:742 [inline]
     [<000000005da31874>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000c1ae433c>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888114b52a00 (size 64):
   comm "syz-executor744", pid 6995, jiffies 4294943716 (age 31.150s)
   hex dump (first 32 bytes):
     d0 68 38 15 81 88 ff ff 00 02 00 00 00 00 ad de  .h8.............
     00 80 06 14 81 88 ff ff c0 68 38 15 81 88 ff ff  .........h8.....
   backtrace:
     [<000000009a4e4995>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009a4e4995>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009a4e4995>] slab_alloc mm/slab.c:3326 [inline]
     [<000000009a4e4995>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000005da31874>] kmalloc include/linux/slab.h:547 [inline]
     [<000000005da31874>] kzalloc include/linux/slab.h:742 [inline]
     [<000000005da31874>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000c198c9a6>] hsr_dev_finalize+0x1d1/0x233  
net/hsr/hsr_device.c:480
     [<00000000422bac9b>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<000000000023c97f>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000006b30cccb>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000d777513f>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000f9b19995>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<000000002235e2b8>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000ef9fbc4e>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000ef9fbc4e>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<00000000d45c6eb2>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000050d30521>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000050d30521>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<0000000052aab806>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000007c8496b5>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000007c8496b5>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000007c8496b5>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000779aa30b>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000a530d116>] entry_SYSCALL_64_after_hwframe+0x44/0xa9


