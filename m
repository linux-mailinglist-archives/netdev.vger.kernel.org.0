Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43A2250A4
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 15:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbfEUNjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 09:39:13 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:48155 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728045AbfEUNjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 09:39:09 -0400
Received: by mail-io1-f71.google.com with SMTP id l6so14161839ioc.15
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 06:39:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=CDCd1TkY/oOVPqRmtfyNXLl11BgXhvCkLARUalmsIiw=;
        b=S47AFVYLU64yWmmcoa1Gd6PapiyD+jDVeEhH95/fykJvbfn4WbFAxXI6IoLOOuh7Am
         u6EZw+kLcdpwJVU5hjTIk/smMcxUaCwDOhMlTaWRcQ2IjFZ/ptw+x08ubBOxonNR0ZRW
         1PgJRU9lRC4mEb7veSuvZKmpXyfgkAQJ/bcVw1UYXUl7dAQa2P0GH1FgxfR6farFaoMI
         PAmeOOoVkU/+RVtOWMaRr804QsYUnJWb321kdlsKyVkLqWf6U/dGjZK2JpjETP4OoQcR
         yWglboycGi6Uns7uGaYwz9zC8Paybj/cPs/Ludj/dkUd/eWR0mMhNJAy+k4Cyz/WtXz9
         QNqg==
X-Gm-Message-State: APjAAAUhgbRgobgYT2tpHmy+yVitP9+VymwAQLMqGZ9/K1uXAYEvYMll
        hx6Rsrgb1fJZZf39tSNCpd5umk4wFgj03aFsZejU5Ut38T4U
X-Google-Smtp-Source: APXvYqxArd2SzN2pZjV1ID/FBivBt5xqkU/KW5B70f2PWB0hs0jHURmfvsqzJi28FjGZ7eNHnaIxXBgDlqKdkLwLhxW+jiXI1pXA
MIME-Version: 1.0
X-Received: by 2002:a24:7592:: with SMTP id y140mr4127328itc.47.1558445947338;
 Tue, 21 May 2019 06:39:07 -0700 (PDT)
Date:   Tue, 21 May 2019 06:39:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000017d64c058965f966@google.com>
Subject: memory leak in batadv_tvlv_handler_register
From:   syzbot <syzbot+d454a826e670502484b8@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f49aa1de Merge tag 'for-5.2-rc1-tag' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16ca4654a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61dd9e15a761691d
dashboard link: https://syzkaller.appspot.com/bug?extid=d454a826e670502484b8
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b81d9ca00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1500bd9ca00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d454a826e670502484b8@syzkaller.appspotmail.com

    57.000820][ T7044] team0 (unregistering): Port device team_slave_0  
removed
BUG: memory leak
unreferenced object 0xffff888113c48bc0 (size 64):
   comm "softirq", pid 0, jiffies 4294942488 (age 34.850s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 e0 cc 4c 13 81 88 ff ff  ..........L.....
     00 00 00 00 00 00 00 00 a0 81 15 83 ff ff ff ff  ................
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000004b89e436>] kmalloc include/linux/slab.h:547 [inline]
     [<000000004b89e436>] kzalloc include/linux/slab.h:742 [inline]
     [<000000004b89e436>] batadv_tvlv_handler_register+0xae/0x140  
net/batman-adv/tvlv.c:529
     [<00000000b3d9e02d>] batadv_tt_init+0x78/0x180  
net/batman-adv/translation-table.c:4411
     [<000000009ae2cc39>] batadv_mesh_init+0x196/0x230  
net/batman-adv/main.c:208
     [<000000005fc0d64d>] batadv_softif_init_late+0x1ca/0x220  
net/batman-adv/soft-interface.c:861
     [<00000000ecdf3bd4>] register_netdevice+0xbf/0x600 net/core/dev.c:8673
     [<00000000f14c9819>] __rtnl_newlink+0xaca/0xb30  
net/core/rtnetlink.c:3203
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972

BUG: memory leak
unreferenced object 0xffff888114921200 (size 128):
   comm "syz-executor123", pid 7016, jiffies 4294942583 (age 33.900s)
   hex dump (first 32 bytes):
     f0 a8 c1 12 81 88 ff ff f0 a8 c1 12 81 88 ff ff  ................
     0a 57 ac 57 c4 a5 6e 00 af d0 6c 97 81 88 ff ff  .W.W..n...l.....
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000004cc7ff0e>] kmalloc include/linux/slab.h:547 [inline]
     [<000000004cc7ff0e>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<0000000015dc75a8>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<00000000cb1acb7e>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e468583b>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000b8ae154c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000002d5a7be6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811483f940 (size 64):
   comm "syz-executor123", pid 7016, jiffies 4294942583 (age 33.900s)
   hex dump (first 32 bytes):
     c0 e3 11 16 81 88 ff ff 00 02 00 00 00 00 ad de  ................
     00 a0 c1 12 81 88 ff ff c0 a8 c1 12 81 88 ff ff  ................
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000fda8b63f>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000fda8b63f>] kzalloc include/linux/slab.h:742 [inline]
     [<00000000fda8b63f>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<000000009bd8bf70>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<00000000cb1acb7e>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e468583b>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000b8ae154c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000002d5a7be6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888113c48bc0 (size 64):
   comm "softirq", pid 0, jiffies 4294942488 (age 36.440s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 e0 cc 4c 13 81 88 ff ff  ..........L.....
     00 00 00 00 00 00 00 00 a0 81 15 83 ff ff ff ff  ................
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000004b89e436>] kmalloc include/linux/slab.h:547 [inline]
     [<000000004b89e436>] kzalloc include/linux/slab.h:742 [inline]
     [<000000004b89e436>] batadv_tvlv_handler_register+0xae/0x140  
net/batman-adv/tvlv.c:529
     [<00000000b3d9e02d>] batadv_tt_init+0x78/0x180  
net/batman-adv/translation-table.c:4411
     [<000000009ae2cc39>] batadv_mesh_init+0x196/0x230  
net/batman-adv/main.c:208
     [<000000005fc0d64d>] batadv_softif_init_late+0x1ca/0x220  
net/batman-adv/soft-interface.c:861
     [<00000000ecdf3bd4>] register_netdevice+0xbf/0x600 net/core/dev.c:8673
     [<00000000f14c9819>] __rtnl_newlink+0xaca/0xb30  
net/core/rtnetlink.c:3203
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972

BUG: memory leak
unreferenced object 0xffff888114921200 (size 128):
   comm "syz-executor123", pid 7016, jiffies 4294942583 (age 35.490s)
   hex dump (first 32 bytes):
     f0 a8 c1 12 81 88 ff ff f0 a8 c1 12 81 88 ff ff  ................
     0a 57 ac 57 c4 a5 6e 00 af d0 6c 97 81 88 ff ff  .W.W..n...l.....
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000004cc7ff0e>] kmalloc include/linux/slab.h:547 [inline]
     [<000000004cc7ff0e>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<0000000015dc75a8>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<00000000cb1acb7e>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e468583b>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000b8ae154c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000002d5a7be6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811483f940 (size 64):
   comm "syz-executor123", pid 7016, jiffies 4294942583 (age 35.490s)
   hex dump (first 32 bytes):
     c0 e3 11 16 81 88 ff ff 00 02 00 00 00 00 ad de  ................
     00 a0 c1 12 81 88 ff ff c0 a8 c1 12 81 88 ff ff  ................
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000fda8b63f>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000fda8b63f>] kzalloc include/linux/slab.h:742 [inline]
     [<00000000fda8b63f>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<000000009bd8bf70>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<00000000cb1acb7e>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e468583b>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000b8ae154c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000002d5a7be6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888113c48bc0 (size 64):
   comm "softirq", pid 0, jiffies 4294942488 (age 38.040s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 e0 cc 4c 13 81 88 ff ff  ..........L.....
     00 00 00 00 00 00 00 00 a0 81 15 83 ff ff ff ff  ................
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000004b89e436>] kmalloc include/linux/slab.h:547 [inline]
     [<000000004b89e436>] kzalloc include/linux/slab.h:742 [inline]
     [<000000004b89e436>] batadv_tvlv_handler_register+0xae/0x140  
net/batman-adv/tvlv.c:529
     [<00000000b3d9e02d>] batadv_tt_init+0x78/0x180  
net/batman-adv/translation-table.c:4411
     [<000000009ae2cc39>] batadv_mesh_init+0x196/0x230  
net/batman-adv/main.c:208
     [<000000005fc0d64d>] batadv_softif_init_late+0x1ca/0x220  
net/batman-adv/soft-interface.c:861
     [<00000000ecdf3bd4>] register_netdevice+0xbf/0x600 net/core/dev.c:8673
     [<00000000f14c9819>] __rtnl_newlink+0xaca/0xb30  
net/core/rtnetlink.c:3203
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972

BUG: memory leak
unreferenced object 0xffff888114921200 (size 128):
   comm "syz-executor123", pid 7016, jiffies 4294942583 (age 37.090s)
   hex dump (first 32 bytes):
     f0 a8 c1 12 81 88 ff ff f0 a8 c1 12 81 88 ff ff  ................
     0a 57 ac 57 c4 a5 6e 00 af d0 6c 97 81 88 ff ff  .W.W..n...l.....
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000004cc7ff0e>] kmalloc include/linux/slab.h:547 [inline]
     [<000000004cc7ff0e>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<0000000015dc75a8>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<00000000cb1acb7e>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e468583b>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000b8ae154c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000002d5a7be6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811483f940 (size 64):
   comm "syz-executor123", pid 7016, jiffies 4294942583 (age 37.090s)
   hex dump (first 32 bytes):
     c0 e3 11 16 81 88 ff ff 00 02 00 00 00 00 ad de  ................
     00 a0 c1 12 81 88 ff ff c0 a8 c1 12 81 88 ff ff  ................
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000fda8b63f>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000fda8b63f>] kzalloc include/linux/slab.h:742 [inline]
     [<00000000fda8b63f>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<000000009bd8bf70>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<00000000cb1acb7e>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e468583b>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000b8ae154c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000002d5a7be6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888113c48bc0 (size 64):
   comm "softirq", pid 0, jiffies 4294942488 (age 38.130s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 e0 cc 4c 13 81 88 ff ff  ..........L.....
     00 00 00 00 00 00 00 00 a0 81 15 83 ff ff ff ff  ................
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000004b89e436>] kmalloc include/linux/slab.h:547 [inline]
     [<000000004b89e436>] kzalloc include/linux/slab.h:742 [inline]
     [<000000004b89e436>] batadv_tvlv_handler_register+0xae/0x140  
net/batman-adv/tvlv.c:529
     [<00000000b3d9e02d>] batadv_tt_init+0x78/0x180  
net/batman-adv/translation-table.c:4411
     [<000000009ae2cc39>] batadv_mesh_init+0x196/0x230  
net/batman-adv/main.c:208
     [<000000005fc0d64d>] batadv_softif_init_late+0x1ca/0x220  
net/batman-adv/soft-interface.c:861
     [<00000000ecdf3bd4>] register_netdevice+0xbf/0x600 net/core/dev.c:8673
     [<00000000f14c9819>] __rtnl_newlink+0xaca/0xb30  
net/core/rtnetlink.c:3203
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972

BUG: memory leak
unreferenced object 0xffff888114921200 (size 128):
   comm "syz-executor123", pid 7016, jiffies 4294942583 (age 37.180s)
   hex dump (first 32 bytes):
     f0 a8 c1 12 81 88 ff ff f0 a8 c1 12 81 88 ff ff  ................
     0a 57 ac 57 c4 a5 6e 00 af d0 6c 97 81 88 ff ff  .W.W..n...l.....
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000004cc7ff0e>] kmalloc include/linux/slab.h:547 [inline]
     [<000000004cc7ff0e>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<0000000015dc75a8>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<00000000cb1acb7e>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e468583b>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000b8ae154c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000002d5a7be6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811483f940 (size 64):
   comm "syz-executor123", pid 7016, jiffies 4294942583 (age 37.180s)
   hex dump (first 32 bytes):
     c0 e3 11 16 81 88 ff ff 00 02 00 00 00 00 ad de  ................
     00 a0 c1 12 81 88 ff ff c0 a8 c1 12 81 88 ff ff  ................
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000fda8b63f>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000fda8b63f>] kzalloc include/linux/slab.h:742 [inline]
     [<00000000fda8b63f>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<000000009bd8bf70>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<00000000cb1acb7e>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e468583b>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000b8ae154c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000002d5a7be6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888113c48bc0 (size 64):
   comm "softirq", pid 0, jiffies 4294942488 (age 38.210s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 e0 cc 4c 13 81 88 ff ff  ..........L.....
     00 00 00 00 00 00 00 00 a0 81 15 83 ff ff ff ff  ................
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000004b89e436>] kmalloc include/linux/slab.h:547 [inline]
     [<000000004b89e436>] kzalloc include/linux/slab.h:742 [inline]
     [<000000004b89e436>] batadv_tvlv_handler_register+0xae/0x140  
net/batman-adv/tvlv.c:529
     [<00000000b3d9e02d>] batadv_tt_init+0x78/0x180  
net/batman-adv/translation-table.c:4411
     [<000000009ae2cc39>] batadv_mesh_init+0x196/0x230  
net/batman-adv/main.c:208
     [<000000005fc0d64d>] batadv_softif_init_late+0x1ca/0x220  
net/batman-adv/soft-interface.c:861
     [<00000000ecdf3bd4>] register_netdevice+0xbf/0x600 net/core/dev.c:8673
     [<00000000f14c9819>] __rtnl_newlink+0xaca/0xb30  
net/core/rtnetlink.c:3203
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972

BUG: memory leak
unreferenced object 0xffff888114921200 (size 128):
   comm "syz-executor123", pid 7016, jiffies 4294942583 (age 37.260s)
   hex dump (first 32 bytes):
     f0 a8 c1 12 81 88 ff ff f0 a8 c1 12 81 88 ff ff  ................
     0a 57 ac 57 c4 a5 6e 00 af d0 6c 97 81 88 ff ff  .W.W..n...l.....
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000004cc7ff0e>] kmalloc include/linux/slab.h:547 [inline]
     [<000000004cc7ff0e>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<0000000015dc75a8>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<00000000cb1acb7e>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e468583b>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000b8ae154c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000002d5a7be6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811483f940 (size 64):
   comm "syz-executor123", pid 7016, jiffies 4294942583 (age 37.260s)
   hex dump (first 32 bytes):
     c0 e3 11 16 81 88 ff ff 00 02 00 00 00 00 ad de  ................
     00 a0 c1 12 81 88 ff ff c0 a8 c1 12 81 88 ff ff  ................
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000fda8b63f>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000fda8b63f>] kzalloc include/linux/slab.h:742 [inline]
     [<00000000fda8b63f>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<000000009bd8bf70>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<00000000cb1acb7e>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e468583b>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000b8ae154c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000002d5a7be6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888113c48bc0 (size 64):
   comm "softirq", pid 0, jiffies 4294942488 (age 38.290s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 e0 cc 4c 13 81 88 ff ff  ..........L.....
     00 00 00 00 00 00 00 00 a0 81 15 83 ff ff ff ff  ................
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000004b89e436>] kmalloc include/linux/slab.h:547 [inline]
     [<000000004b89e436>] kzalloc include/linux/slab.h:742 [inline]
     [<000000004b89e436>] batadv_tvlv_handler_register+0xae/0x140  
net/batman-adv/tvlv.c:529
     [<00000000b3d9e02d>] batadv_tt_init+0x78/0x180  
net/batman-adv/translation-table.c:4411
     [<000000009ae2cc39>] batadv_mesh_init+0x196/0x230  
net/batman-adv/main.c:208
     [<000000005fc0d64d>] batadv_softif_init_late+0x1ca/0x220  
net/batman-adv/soft-interface.c:861
     [<00000000ecdf3bd4>] register_netdevice+0xbf/0x600 net/core/dev.c:8673
     [<00000000f14c9819>] __rtnl_newlink+0xaca/0xb30  
net/core/rtnetlink.c:3203
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972

BUG: memory leak
unreferenced object 0xffff888114921200 (size 128):
   comm "syz-executor123", pid 7016, jiffies 4294942583 (age 37.350s)
   hex dump (first 32 bytes):
     f0 a8 c1 12 81 88 ff ff f0 a8 c1 12 81 88 ff ff  ................
     0a 57 ac 57 c4 a5 6e 00 af d0 6c 97 81 88 ff ff  .W.W..n...l.....
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000004cc7ff0e>] kmalloc include/linux/slab.h:547 [inline]
     [<000000004cc7ff0e>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<0000000015dc75a8>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<00000000cb1acb7e>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e468583b>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000b8ae154c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000002d5a7be6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811483f940 (size 64):
   comm "syz-executor123", pid 7016, jiffies 4294942583 (age 37.350s)
   hex dump (first 32 bytes):
     c0 e3 11 16 81 88 ff ff 00 02 00 00 00 00 ad de  ................
     00 a0 c1 12 81 88 ff ff c0 a8 c1 12 81 88 ff ff  ................
   backtrace:
     [<00000000e8f47afd>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e8f47afd>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e8f47afd>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000e8f47afd>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000fda8b63f>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000fda8b63f>] kzalloc include/linux/slab.h:742 [inline]
     [<00000000fda8b63f>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<000000009bd8bf70>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<00000000cb1acb7e>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e468583b>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000008fd2d6fa>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<0000000029fa04eb>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<0000000092499169>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000072c4499d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000f89d63a1>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000f89d63a1>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000006e2fb165>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<0000000068f29576>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000068f29576>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000707b1f6b>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<0000000015b6ba89>] __do_sys_sendto net/socket.c:1976 [inline]
     [<0000000015b6ba89>] __se_sys_sendto net/socket.c:1972 [inline]
     [<0000000015b6ba89>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000b8ae154c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000002d5a7be6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

executing program
executing program
executing program
executing program
executing program
executing program
executing program


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
