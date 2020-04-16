Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC901ABF44
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 13:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633415AbgDPLcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 07:32:18 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:56764 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506172AbgDPLJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 07:09:07 -0400
Received: by mail-il1-f197.google.com with SMTP id z24so1330077ilk.23
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 04:08:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eW5xO3rmmKlcyvNXxv8/k1vDrsALM6R8izzm/K7H98E=;
        b=FzxSJBaCI/J0vB5Ask+xLzq7TuasLHCcKVgm+HZOsZ4HkqgPneVHHxolvvqcl40MMZ
         ktxPDJTXFYFTCxpPhgxrtaYoSE4zdaxvcqM9ebsTKAqADHE6rvZcxnCWcURRfK2LClTq
         /lNtRUvbq+bawFqOIXAQjfWLO+JiLJSsRE4ywrrdFsjhNdVD8vjso/LUrj6Q1GJmae0E
         BcwOe173ml7icFIcYnFXDkgd/gTTVXTZzqgELSbtxetDJi1pNgWxx7FiIkSlHbuwrvhB
         webekjKSjmphnnNzWFkSp5FL1wJXjYXP9WTt48uL73254YvBhoMwSeTaFwgtBwYa61yu
         Gtkg==
X-Gm-Message-State: AGi0PuZ3dKWhC0ec5fk0QtqGGt9uKa1FPyQFPo8ndnzLyt48tVegFGUb
        Zdq3/UpRhMhFjvvRyvvOv5I4uLJYI6LC3dCnlshWI2Dce8jG
X-Google-Smtp-Source: APiQypKHPmbdOV6a2pVkExQJNi44Xg7ki95J0szeZHGhoZ7RC+BcNxefu0IQpANQbcQ5Ldf6IPA6br93GCvwh2owOG5I2qQLc0aD
MIME-Version: 1.0
X-Received: by 2002:a92:394d:: with SMTP id g74mr9911618ila.250.1587035293853;
 Thu, 16 Apr 2020 04:08:13 -0700 (PDT)
Date:   Thu, 16 Apr 2020 04:08:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000efafd205a366722c@google.com>
Subject: general protection fault in macvlan_device_event
From:   syzbot <syzbot+5035b1f9dc7ea4558d5a@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, edumazet@google.com,
        gustavo@embeddedor.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    8f3d9f35 Linux 5.7-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1377da00100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d351a1019ed81a2
dashboard link: https://syzkaller.appspot.com/bug?extid=5035b1f9dc7ea4558d5a
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+5035b1f9dc7ea4558d5a@syzkaller.appspotmail.com

device veth0_macvtap left promiscuous mode
device veth1_vlan left promiscuous mode
device veth0_vlan left promiscuous mode
bond0 (unregistering): (slave macvlan4): Releasing backup interface
general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 9087 Comm: kworker/u4:9 Not tainted 5.7.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:macvlan_device_event+0x62c/0x930 drivers/net/macvlan.c:1707
Code: df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 09 03 00 00 4c 89 e2 48 8b b3 50 03 00 00 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 d2 02 00 00 49 8b 3c 24 41 bc 02 80 00 00 e8 5b
RSP: 0018:ffffc90002407410 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff88808e450000 RCX: ffffffff84b25ca5
RDX: 0000000000000000 RSI: ffff88809eefbb90 RDI: ffff88808e450350
RBP: 1ffff92000480e88 R08: ffff88804a7a8000 R09: fffffbfff14b0471
R10: ffffffff8a582387 R11: fffffbfff14b0470 R12: 0000000000000000
R13: ffff88804adfc808 R14: ffff88804adfc808 R15: ffff88804adfc000
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055e77ab909c0 CR3: 00000000936d3000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 dev_set_mac_address net/core/dev.c:8404 [inline]
 dev_set_mac_address+0x2ef/0x3f0 net/core/dev.c:8385
 macvlan_set_mac_address drivers/net/macvlan.c:747 [inline]
 macvlan_set_mac_address+0x298/0x320 drivers/net/macvlan.c:733
 dev_set_mac_address+0x283/0x3f0 net/core/dev.c:8400
 __bond_release_one.cold+0xcb3/0xd11 drivers/net/bonding/bond_main.c:2055
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3166 [inline]
 bond_netdev_event+0x81c/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 rollback_registered_many+0x75c/0xe70 net/core/dev.c:8826
 unregister_netdevice_many.part.0+0x16/0x1e0 net/core/dev.c:9986
 unregister_netdevice_many net/core/dev.c:9985 [inline]
 default_device_exit_batch+0x311/0x3d0 net/core/dev.c:10469
 ops_exit_list.isra.0+0x103/0x150 net/core/net_namespace.c:189
 cleanup_net+0x511/0xa50 net/core/net_namespace.c:603
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace 91121f28d4d1c866 ]---
RIP: 0010:macvlan_device_event+0x62c/0x930 drivers/net/macvlan.c:1707
Code: df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 09 03 00 00 4c 89 e2 48 8b b3 50 03 00 00 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 d2 02 00 00 49 8b 3c 24 41 bc 02 80 00 00 e8 5b
RSP: 0018:ffffc90002407410 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff88808e450000 RCX: ffffffff84b25ca5
RDX: 0000000000000000 RSI: ffff88809eefbb90 RDI: ffff88808e450350
RBP: 1ffff92000480e88 R08: ffff88804a7a8000 R09: fffffbfff14b0471
R10: ffffffff8a582387 R11: fffffbfff14b0470 R12: 0000000000000000
R13: ffff88804adfc808 R14: ffff88804adfc808 R15: ffff88804adfc000
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7c22392008 CR3: 00000000936d3000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
