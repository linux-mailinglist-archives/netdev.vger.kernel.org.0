Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E31C3D0E30
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238435AbhGULNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 07:13:55 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:47646 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238633AbhGUKx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 06:53:59 -0400
Received: by mail-il1-f198.google.com with SMTP id c7-20020a92b7470000b0290205c6edd752so1444575ilm.14
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 04:34:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=iN8Dt9o08LlltN3uLTb3eyt/rtetzeEwGyPp78QglxQ=;
        b=ZukkBAkSa9XcdTE/CjQW04RzxZVe6dDV4GTVmnjxPL56cZ5iZHUgorG1UTDeKtvhHv
         VjBBqBOmLyL/p0dhrHftTkkGcZx9sYxhCaPbZmJxArQIXwD+s3vdRL7atmRuXVBiXwbj
         b5LJHagr42XVdjXnh7Ls+R68CueZim7FPFjk5usnkhoVc+G9PwsARoQZLHCOIMvrlhPg
         r5wIxpZgdw1NW0P7M5/oHnnpuakKsBQ5jy5/ShK3St6ukcD2WK9rZ/lNs0Zfzwdn5gRi
         2+7Ab+H0FKTM9N8YLY/hkufeD0UhzgWKJuSrWHREDDZmXeaOMuDk39C/yNSiQ5teZE/y
         ISyQ==
X-Gm-Message-State: AOAM532iK9NxIV8xNWURStSKlwPit8RB3zjQEyJSjB7vJacIgGiG7Kmu
        yIxHeJu16hzvHHu5GXt8qDvNN5ZzWOqHy08MGjIc3GgEBcUh
X-Google-Smtp-Source: ABdhPJzgo6UOGC6rcdoWb9ymHj1nPfx2/a/Eb/ELavSwYsW2vPQVTDX87C9kVJGo0NId4gvsRQYyOfbF2kQK8AyaGZyDIuo1Tf9F
MIME-Version: 1.0
X-Received: by 2002:a5d:88c6:: with SMTP id i6mr27103035iol.75.1626867266062;
 Wed, 21 Jul 2021 04:34:26 -0700 (PDT)
Date:   Wed, 21 Jul 2021 04:34:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007d8c3305c7a08db4@google.com>
Subject: [syzbot] BUG: stack guard page was hit in dev_ioctl
From:   syzbot <syzbot+6fd476398dd851d6a50d@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5b69874f74cc bonding: fix build issue
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=127ed122300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6da37c7627210105
dashboard link: https://syzkaller.appspot.com/bug?extid=6fd476398dd851d6a50d

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6fd476398dd851d6a50d@syzkaller.appspotmail.com

BUG: stack guard page was hit at ffffc900177c7f98 (stack is ffffc900177c8000..ffffc900177cffff)
kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 6209 Comm: syz-executor.5 Not tainted 5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__lock_acquire+0x4b/0x54a0 kernel/locking/lockdep.c:4873
Code: 84 24 20 01 00 00 48 c7 84 24 88 00 00 00 b3 8a b5 41 48 c7 84 24 90 00 00 00 0d b9 12 8b 48 c7 84 24 98 00 00 00 b0 a3 5a 81 <44> 89 44 24 08 48 89 44 24 20 48 8d 84 24 88 00 00 00 48 c1 e8 03
RSP: 0018:ffffc900177c7fa8 EFLAGS: 00010092
RAX: 0000000000000000 RBX: ffffffff8ba9c3a0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8ba9c3a0
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f4770783700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc900177c7f98 CR3: 000000007f220000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __fs_reclaim_acquire mm/page_alloc.c:4552 [inline]
 fs_reclaim_acquire+0x117/0x160 mm/page_alloc.c:4566
 prepare_alloc_pages+0x15c/0x580 mm/page_alloc.c:5164
 __alloc_pages+0x12f/0x500 mm/page_alloc.c:5363
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
 alloc_slab_page mm/slub.c:1713 [inline]
 allocate_slab+0x32b/0x4c0 mm/slub.c:1853
 new_slab mm/slub.c:1916 [inline]
 new_slab_objects mm/slub.c:2662 [inline]
 ___slab_alloc+0x4ba/0x820 mm/slub.c:2825
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2865
 slab_alloc_node mm/slub.c:2947 [inline]
 kmem_cache_alloc_node+0x12c/0x3e0 mm/slub.c:3017
 __alloc_skb+0x20b/0x340 net/core/skbuff.c:414
 alloc_skb include/linux/skbuff.h:1112 [inline]
 nlmsg_new include/net/netlink.h:953 [inline]
 rtmsg_ifinfo_build_skb+0x72/0x1a0 net/core/rtnetlink.c:3811
 rtmsg_ifinfo_event net/core/rtnetlink.c:3847 [inline]
 rtmsg_ifinfo_event net/core/rtnetlink.c:3838 [inline]
 rtnetlink_event+0x123/0x1d0 net/core/rtnetlink.c:5625
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_change_features+0x61/0xb0 net/core/dev.c:10094
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1452
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3565 [inline]
 bond_netdev_event+0x75d/0xae0 drivers/net/bonding/bond_main.c:3605
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 netdev_features_change net/core/dev.c:1495 [inline]
 netdev_sync_lower_features net/core/dev.c:9875 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:10022
 netdev_update_features net/core/dev.c:10077 [inline]
 dev_disable_lro+0x8d/0x3e0 net/core/dev.c:1767
 br_add_if+0xa52/0x1dc0 net/bridge/br_if.c:650
 add_del_if+0x10c/0x140 net/bridge/br_ioctl.c:97
 old_dev_ioctl.constprop.0.isra.0+0x118/0x1450 net/bridge/br_ioctl.c:122
 br_dev_ioctl+0x67/0x160 net/bridge/br_ioctl.c:387
 dev_do_ioctl net/core/dev_ioctl.c:230 [inline]
 dev_ifsioc+0x90d/0xa60 net/core/dev_ioctl.c:336
 dev_ioctl+0x277/0xb70 net/core/dev_ioctl.c:530
 sock_ioctl+0x50d/0x6a0 net/socket.c:1146
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4770783188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665d9
RDX: 0000000020000000 RSI: 00000000000089f0 RDI: 0000000000000007
RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffc4c62e09f R14: 00007f4770783300 R15: 0000000000022000
Modules linked in:
---[ end trace b67e8c7f28e41ea1 ]---
RIP: 0010:__lock_acquire+0x4b/0x54a0 kernel/locking/lockdep.c:4873
Code: 84 24 20 01 00 00 48 c7 84 24 88 00 00 00 b3 8a b5 41 48 c7 84 24 90 00 00 00 0d b9 12 8b 48 c7 84 24 98 00 00 00 b0 a3 5a 81 <44> 89 44 24 08 48 89 44 24 20 48 8d 84 24 88 00 00 00 48 c1 e8 03
RSP: 0018:ffffc900177c7fa8 EFLAGS: 00010092
RAX: 0000000000000000 RBX: ffffffff8ba9c3a0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8ba9c3a0
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f4770783700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc900177c7f98 CR3: 000000007f220000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
