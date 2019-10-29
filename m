Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0291BE7DCE
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 02:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbfJ2BLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 21:11:10 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:47851 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbfJ2BLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 21:11:09 -0400
Received: by mail-il1-f200.google.com with SMTP id c19so11444674ilf.14
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 18:11:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=/mBS0wCcF5M4PMDKVhNmnoIn15kcMF3m1nUEU3l1yZc=;
        b=RQYXCqsKwo67k0xWKOUvtXKoxOV/5hK5ITT71oZseT3ylKSvRO7GBonHh6Aa2wObsi
         NQjcp8IzM4mFaHv8ftOPKuHasbPeBsHO92vLDaRSPGkaVy67QhqMOY3uPnj9ZMxbOYw1
         PtKlYxeonGgQRJ81SLLXxVwxZJb82wvBDpWdKPBNnuPmrQHrmbIiTXMiiKb/LLQ0gNAo
         lYc7IdfLmj1YOq6fswtlElfnYj8pudw7OGAI2o6bHJP+xT63mJmY+ibcim2D7WRZSjcj
         rpVaiQjex84EzuIaU5wVuuVJ044R8R/D5Z20pkCp88eDevgkBR1L41u+5/vp9NJv/am1
         BFLA==
X-Gm-Message-State: APjAAAUh6qQbQ294LOQExf+iTImrXemnDb5E78Q0wEWjDDeDb+Z82ZY3
        9UxzzlYdc286NSLsbzluWqmLnMaNPiw2m5+zYGFwzW1Bz6rA
X-Google-Smtp-Source: APXvYqx68h1h2OQ2OvVV6xsc7ULvZp8MUEcMXHfomj09XKrZNG/wYG51tiq3Sa06OFNmxyqe60aBSGyRO+7jsPWYnh6LwVvgkzZL
MIME-Version: 1.0
X-Received: by 2002:a02:a584:: with SMTP id b4mr5189655jam.67.1572311468774;
 Mon, 28 Oct 2019 18:11:08 -0700 (PDT)
Date:   Mon, 28 Oct 2019 18:11:08 -0700
In-Reply-To: <000000000000044a7f0595fbaf2c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000929f990596024a82@google.com>
Subject: Re: INFO: trying to register non-static key in bond_3ad_update_ad_actor_settings
From:   syzbot <syzbot+8da67f407bcba2c72e6e@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, j.vosburgh@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    60c1769a Add linux-next specific files for 20191028
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=154d4374e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb86688f30db053d
dashboard link: https://syzkaller.appspot.com/bug?extid=8da67f407bcba2c72e6e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14d43a04e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16be3b9ce00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8da67f407bcba2c72e6e@syzkaller.appspotmail.com

netlink: 'syz-executor411': attribute type 24 has an invalid length.
netlink: 'syz-executor411': attribute type 1 has an invalid length.
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 8702 Comm: syz-executor411 Not tainted 5.4.0-rc5-next-20191028  
#0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  assign_lock_key kernel/locking/lockdep.c:881 [inline]
  register_lock_class+0x179e/0x1850 kernel/locking/lockdep.c:1190
  __lock_acquire+0xf4/0x4a00 kernel/locking/lockdep.c:3837
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4487
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  bond_3ad_update_ad_actor_settings+0x37b/0x7b0  
drivers/net/bonding/bond_3ad.c:2260
  bond_option_ad_actor_sys_prio_set+0x67/0x80  
drivers/net/bonding/bond_options.c:1434
  __bond_opt_set+0x2a1/0x540 drivers/net/bonding/bond_options.c:677
  bond_changelink+0x14ed/0x1bd0 drivers/net/bonding/bond_netlink.c:413
  bond_newlink+0x2d/0x90 drivers/net/bonding/bond_netlink.c:454
  __rtnl_newlink+0x10a1/0x16e0 net/core/rtnetlink.c:3268
  rtnl_newlink+0x69/0xa0 net/core/rtnetlink.c:3326
  rtnetlink_rcv_msg+0x45e/0xaf0 net/core/rtnetlink.c:5387
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5405
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x8cf/0xda0 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:638 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:658
  ___sys_sendmsg+0x803/0x920 net/socket.c:2312
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2357
  __do_sys_sendmsg net/socket.c:2366 [inline]
  __se_sys_sendmsg net/socket.c:2364 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2364
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4402b9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc45a3b478 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004402b9
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000001 R09: 00000000004002c8
R10: 000000000000000c R11: 0000000000000246 R12: 0000000000401b40
R13: 0000000000401bd0 R14: 0000000000000000 R15: 0000000000000000
kobject: 'bond1' (000000004c2e596c): kobject_add_internal: parent: 'net',  
set: 'devices'
kobject: 'bond1' (000000004c2e596c): kobject_uevent_env
kobject: 'bond1' (000000004c2e596c): fill_kobj_path: path  
= '/devices/virtual/net/bond1'
kobject: 'queues' (00000000dfeb0249): kobject_add_internal:  
parent: 'bond1', set: '<NULL>'
kobject: 'queues' (00000000dfeb0249): kobject_uevent_env
kobject: 'queues' (00000000dfeb0249): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'rx-0' (000000006cc022b5): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-0' (000000006cc022b5): kobject_uevent_env
kobject: 'rx-0' (000000006cc022b5): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-0'
kobject: 'rx-1' (00000000f41ae229): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-1' (00000000f41ae229): kobject_uevent_env
kobject: 'rx-1' (00000000f41ae229): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-1'
kobject: 'rx-2' (00000000f65859db): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-2' (00000000f65859db): kobject_uevent_env
kobject: 'rx-2' (00000000f65859db): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-2'
kobject: 'rx-3' (000000002efb6c90): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-3' (000000002efb6c90): kobject_uevent_env
kobject: 'rx-3' (000000002efb6c90): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-3'
kobject: 'rx-4' (00000000a4015138): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-4' (00000000a4015138): kobject_uevent_env
kobject: 'rx-4' (00000000a4015138): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-4'
kobject: 'rx-5' (00000000a9a2c066): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-5' (00000000a9a2c066): kobject_uevent_env
kobject: 'rx-5' (00000000a9a2c066): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-5'
kobject: 'rx-6' (00000000f0181667): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-6' (00000000f0181667): kobject_uevent_env
kobject: 'rx-6' (00000000f0181667): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-6'
kobject: 'rx-7' (00000000ac83f7a2): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-7' (00000000ac83f7a2): kobject_uevent_env
kobject: 'rx-7' (00000000ac83f7a2): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-7'
kobject: 'rx-8' (000000000447065e): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-8' (000000000447065e): kobject_uevent_env
kobject: 'rx-8' (000000000447065e): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-8'
kobject: 'rx-9' (000000000e65150a): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-9' (000000000e65150a): kobject_uevent_env
kobject: 'rx-9' (000000000e65150a): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-9'
kobject: 'rx-10' (00000000a13a2fdc): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-10' (00000000a13a2fdc): kobject_uevent_env
kobject: 'rx-10' (00000000a13a2fdc): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-10'
kobject: 'rx-11' (000000000d4499bc): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-11' (000000000d4499bc): kobject_uevent_env
kobject: 'rx-11' (000000000d4499bc): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-11'
kobject: 'rx-12' (00000000c04a7df7): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-12' (00000000c04a7df7): kobject_uevent_env
kobject: 'rx-12' (00000000c04a7df7): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-12'
kobject: 'rx-13' (00000000383d5fab): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-13' (00000000383d5fab): kobject_uevent_env
kobject: 'rx-13' (00000000383d5fab): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-13'
kobject: 'rx-14' (00000000675d2762): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-14' (00000000675d2762): kobject_uevent_env
kobject: 'rx-14' (00000000675d2762): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-14'
kobject: 'rx-15' (0000000077408fd4): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-15' (0000000077408fd4): kobject_uevent_env
kobject: 'rx-15' (0000000077408fd4): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-15'
kobject: 'tx-0' (00000000fc5e1be9): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-0' (00000000fc5e1be9): kobject_uevent_env
kobject: 'tx-0' (00000000fc5e1be9): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-0'
kobject: 'tx-1' (000000003d036af0): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-1' (000000003d036af0): kobject_uevent_env
kobject: 'tx-1' (000000003d036af0): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-1'
kobject: 'tx-2' (000000002b1aed3d): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-2' (000000002b1aed3d): kobject_uevent_env
kobject: 'tx-2' (000000002b1aed3d): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-2'
kobject: 'tx-3' (0000000074d7b4aa): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-3' (0000000074d7b4aa): kobject_uevent_env
kobject: 'tx-3' (0000000074d7b4aa): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-3'
kobject: 'tx-4' (000000006ccd3c3a): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-4' (000000006ccd3c3a): kobject_uevent_env
kobject: 'tx-4' (000000006ccd3c3a): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-4'
kobject: 'tx-5' (000000000e0f31c9): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-5' (000000000e0f31c9): kobject_uevent_env
kobject: 'tx-5' (000000000e0f31c9): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-5'
kobject: 'tx-6' (00000000eafd25e6): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-6' (00000000eafd25e6): kobject_uevent_env
kobject: 'tx-6' (00000000eafd25e6): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-6'
kobject: 'tx-7' (000000009448502b): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-7' (000000009448502b): kobject_uevent_env
kobject: 'tx-7' (000000009448502b): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-7'
kobject: 'tx-8' (000000006f9cb59a): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-8' (000000006f9cb59a): kobject_uevent_env
kobject: 'tx-8' (000000006f9cb59a): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-8'
kobject: 'tx-9' (000000006374c1d3): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-9' (000000006374c1d3): kobject_uevent_env
kobject: 'tx-9' (000000006374c1d3): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-9'
kobject: 'tx-10' (000000008478cb5e): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-10' (000000008478cb5e): kobject_uevent_env
kobject: 'tx-10' (000000008478cb5e): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-10'
kobject: 'tx-11' (00000000bc80336d): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-11' (00000000bc80336d): kobject_uevent_env
kobject: 'tx-11' (00000000bc80336d): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-11'
kobject: 'tx-12' (00000000ec425f4e): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-12' (00000000ec425f4e): kobject_uevent_env
kobject: 'tx-12' (00000000ec425f4e): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-12'
kobject: 'tx-13' (000000006d9d3bb6): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-13' (000000006d9d3bb6): kobject_uevent_env
kobject: 'tx-13' (000000006d9d3bb6): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-13'
kobject: 'tx-14' (000000008ad7b3a4): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-14' (000000008ad7b3a4): kobject_uevent_env
kobject: 'tx-14' (000000008ad7b3a4): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-14'
kobject: 'tx-15' (00000000da467199): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-15' (00000000da467199): kobject_uevent_env
kobject: 'tx-15' (00000000da467199): fill_kobj_path: path = '/devi

