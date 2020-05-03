Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51FE1C2A67
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 08:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgECGgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 02:36:15 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:47176 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgECGgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 02:36:15 -0400
Received: by mail-il1-f200.google.com with SMTP id w65so10070571ilk.14
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 23:36:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=67a07j0usMs49GGNNlvvOPtJ8adW6qy1T1+hcEAdDTo=;
        b=eeg8eTk56SBBtZJSl8rO1WfBLG0n8dBaJMMalw9QCJ8zhr+yZmiqRD6UeNv2l99Sk7
         ug6C9C37JcZyZ5XR021WSw5JKUx849rWV0vidpNmktIYEYsLH3Ij726D1QfqmEyDgqq9
         nhBnUPEPD1QERnjb5fVakQXgZLYaPNEOxdDMIctG9kmNCQpfm5up6uugZWdTozPRPspt
         +5yEWuMvuxpTje2GE41Up4TsM8/t5oBPYX15WtHLH7kb7ijHOet47mLHylcxiKv/Luox
         hDxVJ468EUMYYdx5z2+TtGIOCOCQUi8o0XK4gFC64sV8LII3wgjPwzxvRs8197KKK6L7
         +1fg==
X-Gm-Message-State: AGi0PuaCBEO9KnoLCWrdoAoQUG5/xkTZ1tFNnoplNkGs9U03V4+6e7SS
        bvpi3E+nmPfWvLEfGhKcXCHS8bVCf8uuby6ybpNbZWF5tBCD
X-Google-Smtp-Source: APiQypKaxfcT+YeC4PvSUl2qmq321wZ6VvcD8xu3RyqqPjlAm3QeVdsqlgsl0AaoaxthVj3ddlGQW43W+DbEoRrFjsval54CmH2V
MIME-Version: 1.0
X-Received: by 2002:a6b:7319:: with SMTP id e25mr10505817ioh.193.1588487771556;
 Sat, 02 May 2020 23:36:11 -0700 (PDT)
Date:   Sat, 02 May 2020 23:36:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005a8fe005a4b8a114@google.com>
Subject: BUG: stack guard page was hit in unwind_next_frame
From:   syzbot <syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jpoimboe@redhat.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, peterz@infradead.org,
        shile.zhang@linux.alibaba.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    8999dc89 net/x25: Fix null-ptr-deref in x25_disconnect
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16004440100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7a70e992f2f9b68
dashboard link: https://syzkaller.appspot.com/bug?extid=e73ceacfd8560cc8a3ca
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com

bridge4: port 1(bond0) entered blocking state
bridge4: port 1(bond0) entered disabled state
BUG: stack guard page was hit at 000000008ec16325 (stack is 0000000068a067dc..00000000b4f7fcaf)
kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 7601 Comm: syz-executor.0 Not tainted 5.7.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:unwind_next_frame+0xe4/0x19d0 arch/x86/kernel/unwind_orc.c:386
Code: 41 5d 41 5e 41 5f c3 4d 8d 67 48 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 80 3c 02 00 0f 85 39 12 00 00 49 8b 47 48 <48> 89 44 24 10 49 8d 47 38 48 89 c2 48 89 04 24 48 b8 00 00 00 00
RSP: 0018:ffffc9000cd07fe8 EFLAGS: 00010246
RAX: ffffffff81327f33 RBX: 1ffff920019a1005 RCX: ffffc9000cd08200
RDX: 1ffff920019a1038 RSI: 0000000000000000 RDI: ffffc9000cd08178
RBP: 0000000000000001 R08: 0000000000000001 R09: ffffc9000cd081a0
R10: ffffc9000cd081cf R11: fffff520019a1039 R12: ffffc9000cd081c0
R13: fffff520019a1031 R14: fffff520019a1030 R15: ffffc9000cd08178
FS:  00007ff0d192f700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc9000cd07ff8 CR3: 000000005d606000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __unwind_start arch/x86/kernel/unwind_orc.c:655 [inline]
 __unwind_start+0x474/0x820 arch/x86/kernel/unwind_orc.c:585
 unwind_start arch/x86/include/asm/unwind.h:60 [inline]
 arch_stack_walk+0x57/0xd0 arch/x86/kernel/stacktrace.c:24
 stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:123
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 __kasan_kmalloc mm/kasan/common.c:495 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:468
 slab_post_alloc_hook mm/slab.h:586 [inline]
 slab_alloc_node mm/slab.c:3263 [inline]
 kmem_cache_alloc_node+0x13c/0x760 mm/slab.c:3575
 __alloc_skb+0xba/0x5a0 net/core/skbuff.c:198
 alloc_skb include/linux/skbuff.h:1083 [inline]
 nlmsg_new include/net/netlink.h:888 [inline]
 rtmsg_ifinfo_build_skb+0x72/0x1a0 net/core/rtnetlink.c:3695
 rtmsg_ifinfo_event.part.0+0x49/0xe0 net/core/rtnetlink.c:3731
 rtmsg_ifinfo_event net/core/rtnetlink.c:5512 [inline]
 rtnetlink_event+0x11e/0x150 net/core/rtnetlink.c:5505
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_change_features+0x61/0xb0 net/core/dev.c:9117
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9101 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9098
 netdev_sync_lower_features net/core/dev.c:8910 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9045
 netdev_update_features+0x63/0xd0 net/core/dev.c:9100
 dev_disable_lro+0x45/0x320 net/core/dev.c:1592
 br_add_if+0x8c5/0x1810 net/bridge/br_if.c:633
 do_set_master net/core/rtnetlink.c:2470 [inline]
 do_set_master+0x1d7/0x230 net/core/rtnetlink.c:2443
 do_setlink+0xaa2/0x3680 net/core/rtnetlink.c:2605
 __rtnl_newlink+0xad5/0x1590 net/core/rtnetlink.c:3266
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3391
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5454
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c829
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ff0d192ec78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000500a40 RCX: 000000000045c829
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000006
RBP: 000000000078bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009fe R14: 00000000004ccb57 R15: 00007ff0d192f6d4
Modules linked in:
---[ end trace 9178e0e56bfc9183 ]---
RIP: 0010:unwind_next_frame+0xe4/0x19d0 arch/x86/kernel/unwind_orc.c:386
Code: 41 5d 41 5e 41 5f c3 4d 8d 67 48 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 80 3c 02 00 0f 85 39 12 00 00 49 8b 47 48 <48> 89 44 24 10 49 8d 47 38 48 89 c2 48 89 04 24 48 b8 00 00 00 00
RSP: 0018:ffffc9000cd07fe8 EFLAGS: 00010246
RAX: ffffffff81327f33 RBX: 1ffff920019a1005 RCX: ffffc9000cd08200
RDX: 1ffff920019a1038 RSI: 0000000000000000 RDI: ffffc9000cd08178
RBP: 0000000000000001 R08: 0000000000000001 R09: ffffc9000cd081a0
R10: ffffc9000cd081cf R11: fffff520019a1039 R12: ffffc9000cd081c0
R13: fffff520019a1031 R14: fffff520019a1030 R15: ffffc9000cd08178
FS:  00007ff0d192f700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc9000cd07ff8 CR3: 000000005d606000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
