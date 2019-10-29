Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB65E7DC7
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 02:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfJ2BKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 21:10:10 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:56836 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbfJ2BKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 21:10:09 -0400
Received: by mail-il1-f199.google.com with SMTP id e15so11353534ilq.23
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 18:10:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cB6cvA8GxN2NTL00Iw/U17L1GLZzJfZEAVHRPwWdzgw=;
        b=qmwlidYnohVvMe/bsNbGajQ+QB3eWeXzDqZef5REJkNvgw0YdSA53Tdu6wKq4wyAoG
         /6dOcMbOpMV37VYBBjRYwurtuXAa2BIXx0dRhXAl5uiizpWdueOO5PXonyAIBha6dW5I
         ECOqmO9vhGe3d89J+KC423hvgbVMQIsgs9iMc7a8kjP4kEjvgkFhmGvsYcjjbqyz+60R
         xBVl6lhu509sw7pxYeC4PXWItAJrVjVjcoDPNOxyhwTGyaclytngIjSRIVbdWVtT122N
         eBoPsnAXIkdtVNzdDIZQ2aA0x6YGk68yhgX3FS2zUvxnDVcb94i+jICj3nsvPCs6ND9a
         vNpA==
X-Gm-Message-State: APjAAAX2N1VcfAKBrb8guA9L83fmpPf8O4yTUxJVYJL77cSVsTWVElg7
        B4LXAkguuIBaF8TPpNfFIzJ6V+WdFtYI27vCExxxMS0Fnchp
X-Google-Smtp-Source: APXvYqy9/aueHOje7a487Yj+qIrFBXmQhynu1txhyI2e1kEkkdScqj9T8Ugl2XVuHChbGlpEPv52Z4jpXjX+9CptFW8rnZe3BK3t
MIME-Version: 1.0
X-Received: by 2002:a92:1d44:: with SMTP id d65mr22458572ild.14.1572311408580;
 Mon, 28 Oct 2019 18:10:08 -0700 (PDT)
Date:   Mon, 28 Oct 2019 18:10:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fc25a1059602460a@google.com>
Subject: INFO: trying to register non-static key in bond_3ad_update_lacp_rate
From:   syzbot <syzbot+0d083911ab18b710da71@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, j.vosburgh@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    60c1769a Add linux-next specific files for 20191028
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11151ad4e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb86688f30db053d
dashboard link: https://syzkaller.appspot.com/bug?extid=0d083911ab18b710da71
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15381ee0e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11571570e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0d083911ab18b710da71@syzkaller.appspotmail.com

netlink: 'syz-executor241': attribute type 21 has an invalid length.
netlink: 'syz-executor241': attribute type 1 has an invalid length.
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 8825 Comm: syz-executor241 Not tainted 5.4.0-rc5-next-20191028  
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
  bond_3ad_update_lacp_rate+0xb9/0x290 drivers/net/bonding/bond_3ad.c:2694
  bond_option_lacp_rate_set+0x66/0x80 drivers/net/bonding/bond_options.c:1293
  __bond_opt_set+0x2a1/0x540 drivers/net/bonding/bond_options.c:677
  bond_changelink+0x139e/0x1bd0 drivers/net/bonding/bond_netlink.c:395
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
RSP: 002b:00007ffce2473e18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004402b9
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000001 R09: 00000000004002c8
R10: 000000000000000c R11: 0000000000000246 R12: 0000000000401b40
R13: 0000000000401bd0 R14: 0000000000000000 R15: 0000000000000000
kobject: 'bond1' (00000000babd83e5): kobject_add_internal: parent: 'net',  
set: 'devices'
kobject: 'bond1' (00000000babd83e5): kobject_uevent_env
kobject: 'bond1' (00000000babd83e5): fill_kobj_path: path  
= '/devices/virtual/net/bond1'
kobject: 'queues' (00000000e75fd84a): kobject_add_internal:  
parent: 'bond1', set: '<NULL>'
kobject: 'queues' (00000000e75fd84a): kobject_uevent_env
kobject: 'queues' (00000000e75fd84a): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'rx-0' (00000000e9a254f1): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-0' (00000000e9a254f1): kobject_uevent_env
kobject: 'rx-0' (00000000e9a254f1): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-0'
kobject: 'rx-1' (000000009ff0a2ea): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-1' (000000009ff0a2ea): kobject_uevent_env
kobject: 'rx-1' (000000009ff0a2ea): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-1'
kobject: 'rx-2' (00000000771a0432): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-2' (00000000771a0432): kobject_uevent_env
kobject: 'rx-2' (00000000771a0432): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-2'
kobject: 'rx-3' (000000008fbd4308): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-3' (000000008fbd4308): kobject_uevent_env
kobject: 'rx-3' (000000008fbd4308): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-3'
kobject: 'rx-4' (00000000e9e849b2): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-4' (00000000e9e849b2): kobject_uevent_env
kobject: 'rx-4' (00000000e9e849b2): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-4'
kobject: 'rx-5' (000000001599d31c): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-5' (000000001599d31c): kobject_uevent_env
kobject: 'rx-5' (000000001599d31c): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-5'
kobject: 'rx-6' (0000000035c79e5c): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-6' (0000000035c79e5c): kobject_uevent_env
kobject: 'rx-6' (0000000035c79e5c): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-6'
kobject: 'rx-7' (000000007a6348ea): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-7' (000000007a6348ea): kobject_uevent_env
kobject: 'rx-7' (000000007a6348ea): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-7'
kobject: 'rx-8' (00000000b6efbc00): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-8' (00000000b6efbc00): kobject_uevent_env
kobject: 'rx-8' (00000000b6efbc00): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-8'
kobject: 'rx-9' (000000003f2c9c88): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-9' (000000003f2c9c88): kobject_uevent_env
kobject: 'rx-9' (000000003f2c9c88): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-9'
kobject: 'rx-10' (0000000014cafa47): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-10' (0000000014cafa47): kobject_uevent_env
kobject: 'rx-10' (0000000014cafa47): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-10'
kobject: 'rx-11' (00000000d6d7c697): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-11' (00000000d6d7c697): kobject_uevent_env
kobject: 'rx-11' (00000000d6d7c697): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-11'
kobject: 'rx-12' (0000000049162d98): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-12' (0000000049162d98): kobject_uevent_env
kobject: 'rx-12' (0000000049162d98): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-12'
kobject: 'rx-13' (00000000abfdfa04): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-13' (00000000abfdfa04): kobject_uevent_env
kobject: 'rx-13' (00000000abfdfa04): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-13'
kobject: 'rx-14' (00000000af052089): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-14' (00000000af052089): kobject_uevent_env
kobject: 'rx-14' (00000000af052089): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-14'
kobject: 'rx-15' (00000000b0f431c4): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-15' (00000000b0f431c4): kobject_uevent_env
kobject: 'rx-15' (00000000b0f431c4): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/rx-15'
kobject: 'tx-0' (000000003e5205bd): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-0' (000000003e5205bd): kobject_uevent_env
kobject: 'tx-0' (000000003e5205bd): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-0'
kobject: 'tx-1' (000000004a6e3a1f): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-1' (000000004a6e3a1f): kobject_uevent_env
kobject: 'tx-1' (000000004a6e3a1f): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-1'
kobject: 'tx-2' (0000000062516d14): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-2' (0000000062516d14): kobject_uevent_env
kobject: 'tx-2' (0000000062516d14): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-2'
kobject: 'tx-3' (00000000e816cdc5): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-3' (00000000e816cdc5): kobject_uevent_env
kobject: 'tx-3' (00000000e816cdc5): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-3'
kobject: 'tx-4' (00000000354484c4): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-4' (00000000354484c4): kobject_uevent_env
kobject: 'tx-4' (00000000354484c4): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-4'
kobject: 'tx-5' (00000000249faa27): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-5' (00000000249faa27): kobject_uevent_env
kobject: 'tx-5' (00000000249faa27): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-5'
kobject: 'tx-6' (0000000086f0c013): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-6' (0000000086f0c013): kobject_uevent_env
kobject: 'tx-6' (0000000086f0c013): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-6'
kobject: 'tx-7' (000000009f854e23): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-7' (000000009f854e23): kobject_uevent_env
kobject: 'tx-7' (000000009f854e23): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-7'
kobject: 'tx-8' (000000008149c52d): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-8' (000000008149c52d): kobject_uevent_env
kobject: 'tx-8' (000000008149c52d): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-8'
kobject: 'tx-9' (000000006642fcfb): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-9' (000000006642fcfb): kobject_uevent_env
kobject: 'tx-9' (000000006642fcfb): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-9'
kobject: 'tx-10' (00000000a81ace8d): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-10' (00000000a81ace8d): kobject_uevent_env
kobject: 'tx-10' (00000000a81ace8d): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-10'
kobject: 'tx-11' (0000000082d86d67): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-11' (0000000082d86d67): kobject_uevent_env
kobject: 'tx-11' (0000000082d86d67): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-11'
kobject: 'tx-12' (00000000f88e9bc2): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-12' (00000000f88e9bc2): kobject_uevent_env
kobject: 'tx-12' (00000000f88e9bc2): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-12'
kobject: 'tx-13' (00000000f5c01991): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-13' (00000000f5c01991): kobject_uevent_env
kobject: 'tx-13' (00000000f5c01991): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-13'
kobject: 'tx-14' (00000000f01d7ebb): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-14' (00000000f01d7ebb): kobject_uevent_env
kobject: 'tx-14' (00000000f01d7ebb): fill_kobj_path: path  
= '/devices/virtual/net/bond1/queues/tx-14'
kobject: 'tx-15' (000000001891794b): kobject_add_internal:  
parent: 'queues', set: 'queues'


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
