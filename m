Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFC3185976
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 03:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgCOC4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 22:56:53 -0400
Received: from mail-pj1-f72.google.com ([209.85.216.72]:57193 "EHLO
        mail-pj1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgCOC4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 22:56:53 -0400
Received: by mail-pj1-f72.google.com with SMTP id f94so6746851pjg.6
        for <netdev@vger.kernel.org>; Sat, 14 Mar 2020 19:56:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=L6H6FQ0YI1KZPOgA+EKb7X/N/vK4W0R1pMP2V3SjmPM=;
        b=KOnpeHyYYk9XP30AUs37HvYvrUK0J0HNzrg7PiSXzmFfA7htXPRMVGQCqyffxb3QdI
         jRBcAK+/fiKGnqBGl1CYG2nk5Rw8Zxdd/6BChb7LgveGHF4RqJ+9b1RueT0ZymRQxikj
         1cAUXGZzYsXcS9RdqVppbbLpouEHSpVRnJx0svqnBmxzBZQDzASBc5RrVGP4DGwI0ybS
         InPJWRzteuCMunWZS5OkKshDfcwXNZ5/T1b9BKgxOIm0AX7I0tKFOvzhkdVgWL4H5ywS
         waxuWC5ESOHRi1ste3Jdobkv9di7tPQNr4eXlB4GVn9OnqfG/WHqyfBlgCFFy3NYgcHv
         yKhA==
X-Gm-Message-State: ANhLgQ3kE2QBYol6K5u18x1xPh3IuItL+zF95MEroPlNXqo1YdWJ0/3t
        4vRLS0xKR+NOtcT1QlTQIgJnBCj6QuBe1KmLMIhYJHY1pPrD
X-Google-Smtp-Source: ADFU+vtR7EUSGsomgvNItoEsYJt6QuU68t7OxCF/1re49AxOC9MLebieGeM6tZL6GTYsU5KiNTOadVVDgEsUSrLKbxxs78PEwEws
MIME-Version: 1.0
X-Received: by 2002:a6b:8ec2:: with SMTP id q185mr15923286iod.180.1584181691130;
 Sat, 14 Mar 2020 03:28:11 -0700 (PDT)
Date:   Sat, 14 Mar 2020 03:28:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f5a6bf05a0ce0a95@google.com>
Subject: BUG: stack guard page was hit in deref_stack_reg
From:   syzbot <syzbot+2a3c14db0e17fe4c7409@syzkaller.appspotmail.com>
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

HEAD commit:    34a568a2 net: sgi: ioc3-eth: Remove phy workaround
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=103e69fde00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=598678fc6e800071
dashboard link: https://syzkaller.appspot.com/bug?extid=2a3c14db0e17fe4c7409
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2a3c14db0e17fe4c7409@syzkaller.appspotmail.com

BUG: stack guard page was hit at 0000000085925c81 (stack is 00000000386230c4..00000000d4e5808f)
kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 5148 Comm: syz-executor.5 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:deref_stack_reg+0x22/0xe0 arch/x86/kernel/unwind_orc.c:347
Code: 0f 1f 84 00 00 00 00 00 41 55 49 bd 00 00 00 00 00 fc ff df 41 54 49 89 d4 ba 08 00 00 00 55 48 89 f5 53 48 83 ec 60 48 89 e3 <48> c7 04 24 b3 8a b5 41 48 c7 44 24 08 e0 4c 24 89 48 c1 eb 03 48
RSP: 0018:ffffc900179d7fe0 EFLAGS: 00010282
RAX: ffffc900179d81f8 RBX: ffffc900179d7fe0 RCX: 0000000000000000
RDX: 0000000000000008 RSI: ffffc900179d81f0 RDI: ffffc900179d81f8
RBP: ffffc900179d81f0 R08: ffffffff8acbe0f4 R09: ffffffff8acbe0f8
R10: 000000000000c44c R11: 000000000006e027 R12: ffffc900179d8240
R13: dffffc0000000000 R14: ffffc900179d8248 R15: ffffc900179d81f8
FS:  00007f2c8b150700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc900179d7fd8 CR3: 0000000059456000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 unwind_next_frame+0xbfa/0x19d0 arch/x86/kernel/unwind_orc.c:499
 __unwind_start arch/x86/kernel/unwind_orc.c:655 [inline]
 __unwind_start+0x474/0x820 arch/x86/kernel/unwind_orc.c:585
 unwind_start arch/x86/include/asm/unwind.h:60 [inline]
 arch_stack_walk+0x57/0xd0 arch/x86/kernel/stacktrace.c:24
 stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:123
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
 slab_post_alloc_hook mm/slab.h:584 [inline]
 slab_alloc_node mm/slab.c:3263 [inline]
 kmem_cache_alloc_node_trace+0x14b/0x790 mm/slab.c:3593
 __do_kmalloc_node mm/slab.c:3615 [inline]
 __kmalloc_node_track_caller+0x38/0x60 mm/slab.c:3630
 __kmalloc_reserve.isra.0+0x39/0xe0 net/core/skbuff.c:142
 pskb_expand_head+0x148/0x1020 net/core/skbuff.c:1627
 netlink_trim+0x1ea/0x240 net/netlink/af_netlink.c:1285
 netlink_broadcast_filtered+0x5f/0xd40 net/netlink/af_netlink.c:1490
 netlink_broadcast net/netlink/af_netlink.c:1535 [inline]
 nlmsg_multicast include/net/netlink.h:968 [inline]
 nlmsg_notify+0x90/0x250 net/netlink/af_netlink.c:2521
 rtnl_notify net/core/rtnetlink.c:737 [inline]
 rtmsg_ifinfo_send net/core/rtnetlink.c:3705 [inline]
 rtmsg_ifinfo_event.part.0+0xb6/0xe0 net/core/rtnetlink.c:3720
 rtmsg_ifinfo_event net/core/rtnetlink.c:5498 [inline]
 rtnetlink_event+0x11e/0x150 net/core/rtnetlink.c:5491
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
 bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 netdev_features_change net/core/dev.c:1364 [inline]
 netdev_update_features net/core/dev.c:9082 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
 netdev_sync_lower_features net/core/dev.c:8891 [inline]
 __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
 netdev_change_features+0x61/0xb0 net/core/dev.c:9098
 bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
 bond_enslave+0x3418/0x4800 drivers/net/bonding/bond_main.c:1818
 do_set_master net/core/rtnetlink.c:2468 [inline]
 do_set_master+0x1d7/0x230 net/core/rtnetlink.c:2441
 do_setlink+0xaa2/0x35e0 net/core/rtnetlink.c:2603
 __rtnl_newlink+0xad5/0x1590 net/core/rtnetlink.c:3252
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3377
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5440
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_64+0xf6/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c4a9
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f2c8b14fc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f2c8b1506d4 RCX: 000000000045c4a9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000005
RBP: 000000000076bfc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009f9 R14: 00000000004cc766 R15: 000000000076bfcc
Modules linked in:
---[ end trace f67e5717e1c84195 ]---
RIP: 0010:deref_stack_reg+0x22/0xe0 arch/x86/kernel/unwind_orc.c:347
Code: 0f 1f 84 00 00 00 00 00 41 55 49 bd 00 00 00 00 00 fc ff df 41 54 49 89 d4 ba 08 00 00 00 55 48 89 f5 53 48 83 ec 60 48 89 e3 <48> c7 04 24 b3 8a b5 41 48 c7 44 24 08 e0 4c 24 89 48 c1 eb 03 48
RSP: 0018:ffffc900179d7fe0 EFLAGS: 00010282
RAX: ffffc900179d81f8 RBX: ffffc900179d7fe0 RCX: 0000000000000000
RDX: 0000000000000008 RSI: ffffc900179d81f0 RDI: ffffc900179d81f8
RBP: ffffc900179d81f0 R08: ffffffff8acbe0f4 R09: ffffffff8acbe0f8
R10: 000000000000c44c R11: 000000000006e027 R12: ffffc900179d8240
R13: dffffc0000000000 R14: ffffc900179d8248 R15: ffffc900179d81f8
FS:  00007f2c8b150700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc900179d7fd8 CR3: 0000000059456000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
