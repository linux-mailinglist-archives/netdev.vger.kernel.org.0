Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDA8E7778
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 18:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404110AbfJ1RSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 13:18:12 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:57168 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730665AbfJ1RSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 13:18:11 -0400
Received: by mail-io1-f72.google.com with SMTP id o2so1265442ioa.23
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 10:18:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cbt9l8HimPacD4gTquI3ZWa3mV2sHz+7E5RjywMP6iA=;
        b=XYiURXl4/ooAczV3w9kQrHMKm3t9YY2YDtWQlZ2HG/kzeQQuH7/JfUKXSZYwTUWF6T
         S2qm0jyI2dFeeo6/0FpUJzGMIzlG5bo5dKW2mdl473CTVyXIt592UnHzUqVFa/4JDlfu
         OJrXsIhuCSLsjy64tqGjN0yhjK/oplswYcPO7AgXEItTPBp1Jtn7nzz9AjyQ84S0e/Mn
         ELyCqLRnN/k02SRiwpaLzTsI2qWu2P9IPyqeYBMSGNREZp8YK/haEBqsnVl/g8pk9feJ
         sqKZw37ue46npfD7BmTiPdHIatQdopjhSDhRw77WiVmO4WMCKkqbmpcgjFRCAJlvXV8h
         FYdQ==
X-Gm-Message-State: APjAAAUNJacjKjqX0xqorPjr+RkRVvJWM24pLrrTGTmPJ4ttVYfWV4AT
        Nww9Zl3RsdcgE4nCaZ8J1cvsHXaCrin/qoYm9HExsLqHXwKa
X-Google-Smtp-Source: APXvYqzd0kngwL635O8OAElFAfgxFZ9E7ghLGZXtiB/rFaHx0Tu3cy3dHCj/58AVG1LU+k25b3QR2vEr54cUOACshXqTvVNGVLLQ
MIME-Version: 1.0
X-Received: by 2002:a92:9f1c:: with SMTP id u28mr20070746ili.97.1572283089171;
 Mon, 28 Oct 2019 10:18:09 -0700 (PDT)
Date:   Mon, 28 Oct 2019 10:18:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000044a7f0595fbaf2c@google.com>
Subject: INFO: trying to register non-static key in bond_3ad_update_ad_actor_settings
From:   syzbot <syzbot+8da67f407bcba2c72e6e@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=14b90574e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb86688f30db053d
dashboard link: https://syzkaller.appspot.com/bug?extid=8da67f407bcba2c72e6e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8da67f407bcba2c72e6e@syzkaller.appspotmail.com

validate_nla: 2 callbacks suppressed
netlink: 'syz-executor.2': attribute type 24 has an invalid length.
netlink: 'syz-executor.2': attribute type 1 has an invalid length.
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 16587 Comm: syz-executor.2 Not tainted 5.4.0-rc5-next-20191028  
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
RIP: 0033:0x459f39
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f1ca6c7ac78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459f39
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000004
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f1ca6c7b6d4
R13: 00000000004c8320 R14: 00000000004de420 R15: 00000000ffffffff
kobject: 'bond5' (0000000030c8073b): kobject_add_internal: parent: 'net',  
set: 'devices'
kobject: 'bond5' (0000000030c8073b): kobject_uevent_env
kobject: 'bond5' (0000000030c8073b): fill_kobj_path: path  
= '/devices/virtual/net/bond5'
kobject: 'queues' (00000000b3044d36): kobject_add_internal:  
parent: 'bond5', set: '<NULL>'
kobject: 'queues' (00000000b3044d36): kobject_uevent_env
kobject: 'queues' (00000000b3044d36): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'rx-0' (0000000011e747e6): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-0' (0000000011e747e6): kobject_uevent_env
kobject: 'rx-0' (0000000011e747e6): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/rx-0'
kobject: 'rx-1' (00000000497026af): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-1' (00000000497026af): kobject_uevent_env
kobject: 'rx-1' (00000000497026af): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/rx-1'
kobject: 'rx-2' (00000000010759d0): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-2' (00000000010759d0): kobject_uevent_env
kobject: 'rx-2' (00000000010759d0): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/rx-2'
kobject: 'rx-3' (00000000834e4fdb): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-3' (00000000834e4fdb): kobject_uevent_env
kobject: 'rx-3' (00000000834e4fdb): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/rx-3'
kobject: 'rx-4' (000000002f04b4d0): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-4' (000000002f04b4d0): kobject_uevent_env
kobject: 'rx-4' (000000002f04b4d0): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/rx-4'
kobject: 'rx-5' (00000000a8e87ede): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-5' (00000000a8e87ede): kobject_uevent_env
kobject: 'rx-5' (00000000a8e87ede): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/rx-5'
kobject: 'rx-6' (0000000046771599): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-6' (0000000046771599): kobject_uevent_env
kobject: 'rx-6' (0000000046771599): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/rx-6'
kobject: 'rx-7' (000000000bbe727f): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-7' (000000000bbe727f): kobject_uevent_env
kobject: 'rx-7' (000000000bbe727f): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/rx-7'
kobject: 'rx-8' (000000003b71f1bf): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-8' (000000003b71f1bf): kobject_uevent_env
kobject: 'rx-8' (000000003b71f1bf): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/rx-8'
kobject: 'rx-9' (000000005c8857f9): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-9' (000000005c8857f9): kobject_uevent_env
kobject: 'rx-9' (000000005c8857f9): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/rx-9'
kobject: 'rx-10' (0000000045ac7b51): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-10' (0000000045ac7b51): kobject_uevent_env
kobject: 'rx-10' (0000000045ac7b51): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/rx-10'
kobject: 'rx-11' (00000000b5982a0d): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-11' (00000000b5982a0d): kobject_uevent_env
kobject: 'rx-11' (00000000b5982a0d): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/rx-11'
kobject: 'rx-12' (00000000e8dc1f87): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-12' (00000000e8dc1f87): kobject_uevent_env
kobject: 'rx-12' (00000000e8dc1f87): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/rx-12'
kobject: 'rx-13' (00000000d7795584): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-13' (00000000d7795584): kobject_uevent_env
kobject: 'rx-13' (00000000d7795584): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/rx-13'
kobject: 'rx-14' (00000000596eebf3): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-14' (00000000596eebf3): kobject_uevent_env
kobject: 'rx-14' (00000000596eebf3): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/rx-14'
kobject: 'rx-15' (00000000b045f7e4): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'rx-15' (00000000b045f7e4): kobject_uevent_env
kobject: 'rx-15' (00000000b045f7e4): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/rx-15'
kobject: 'tx-0' (00000000c6dcb83c): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-0' (00000000c6dcb83c): kobject_uevent_env
kobject: 'tx-0' (00000000c6dcb83c): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/tx-0'
kobject: 'tx-1' (00000000cd679d8e): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-1' (00000000cd679d8e): kobject_uevent_env
kobject: 'tx-1' (00000000cd679d8e): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/tx-1'
kobject: 'tx-2' (000000005e9289ef): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-2' (000000005e9289ef): kobject_uevent_env
kobject: 'tx-2' (000000005e9289ef): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/tx-2'
kobject: 'tx-3' (000000007d096435): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-3' (000000007d096435): kobject_uevent_env
kobject: 'tx-3' (000000007d096435): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/tx-3'
kobject: 'tx-4' (00000000e86e5471): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-4' (00000000e86e5471): kobject_uevent_env
kobject: 'tx-4' (00000000e86e5471): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/tx-4'
kobject: 'tx-5' (00000000a81574e7): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-5' (00000000a81574e7): kobject_uevent_env
kobject: 'tx-5' (00000000a81574e7): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/tx-5'
kobject: 'tx-6' (00000000de9466a0): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-6' (00000000de9466a0): kobject_uevent_env
kobject: 'tx-6' (00000000de9466a0): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/tx-6'
kobject: 'tx-7' (00000000088bce98): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-7' (00000000088bce98): kobject_uevent_env
kobject: 'tx-7' (00000000088bce98): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/tx-7'
kobject: 'tx-8' (0000000092dedf13): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-8' (0000000092dedf13): kobject_uevent_env
kobject: 'tx-8' (0000000092dedf13): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/tx-8'
kobject: 'tx-9' (000000003d373759): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-9' (000000003d373759): kobject_uevent_env
kobject: 'tx-9' (000000003d373759): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/tx-9'
kobject: 'tx-10' (00000000cc775474): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-10' (00000000cc775474): kobject_uevent_env
kobject: 'tx-10' (00000000cc775474): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/tx-10'
kobject: 'tx-11' (000000007f0d872a): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-11' (000000007f0d872a): kobject_uevent_env
kobject: 'tx-11' (000000007f0d872a): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/tx-11'
kobject: 'tx-12' (0000000081bcd29c): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-12' (0000000081bcd29c): kobject_uevent_env
kobject: 'tx-12' (0000000081bcd29c): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/tx-12'
kobject: 'tx-13' (0000000005fecb61): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-13' (0000000005fecb61): kobject_uevent_env
kobject: 'tx-13' (0000000005fecb61): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/tx-13'
kobject: 'tx-14' (00000000de8334e0): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-14' (00000000de8334e0): kobject_uevent_env
kobject: 'tx-14' (00000000de8334e0): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/tx-14'
kobject: 'tx-15' (000000009cc7f5e5): kobject_add_internal:  
parent: 'queues', set: 'queues'
kobject: 'tx-15' (000000009cc7f5e5): kobject_uevent_env
kobject: 'tx-15' (000000009cc7f5e5): fill_kobj_path: path  
= '/devices/virtual/net/bond5/queues/tx-15'
kobject: 'batman_adv' (00000000ff71c398): kobject_add_internal:  
parent: 'bond5', set: '<NULL>'


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
