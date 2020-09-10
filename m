Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317F3263C26
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 06:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgIJEiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 00:38:11 -0400
Received: from mail-io1-f78.google.com ([209.85.166.78]:35938 "EHLO
        mail-io1-f78.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgIJEhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 00:37:24 -0400
Received: by mail-io1-f78.google.com with SMTP id h8so3522942ioa.3
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 21:37:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cRb1PLmASYYGw1Fmzq24cU897CwVfD9msFh4OhP5aZM=;
        b=rpCMKhHBT/403DVvtPdyjsAQGay1aGNcVaHUjLJGFFL4xtGpb57fWYyAXeU+3ZWJ+1
         2By0biXTn80hg8IqJ90PWfqBTTPKQNQ6XQ1vKmB9SUYFFm/TuGkTiNVfOmTVy+2/Cb08
         4VL5jXcOmTaeAOGNOVFXKN3vBDJSzNNxhOUut5ZpAwcnPjneukBX7WaOxm8jplf2Wbaq
         kG82qQCckSig8+Ydf+OF/+PUxNpHo6mgyRnd3ojrb3463JXIQcuuFPwHK3M9pX7fG2qD
         SyJSCLNGQl4dYSjFpZPO2JLA+b4UuOVgG3hJp7XjyC5Qxrw6AB99K61BuJwfXkNOzNI6
         2iPw==
X-Gm-Message-State: AOAM531v7HM5Bblhk5T0hdk1PZwl4QYTegn3+yFPsfFggh1AIZzNVgcq
        wF+Do1HCRUm858nqMqmxmlFy2HdrV4579rq/fY1yInKWkNpB
X-Google-Smtp-Source: ABdhPJwq80HEOkyyMJ2rDfEMMlVzF0k8iWSGMjzf0GMZqlSowrxXUO2cgZS3sciiG7lc1gnfCUrI22mARBgKutjX4iUgO+nAvSpB
MIME-Version: 1.0
X-Received: by 2002:a92:d0d0:: with SMTP id y16mr69265ila.158.1599712642176;
 Wed, 09 Sep 2020 21:37:22 -0700 (PDT)
Date:   Wed, 09 Sep 2020 21:37:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c79dcf05aeee1fb8@google.com>
Subject: BUG: stack guard page was hit in validate_chain (2)
From:   syzbot <syzbot+5846c06bbd501a165e52@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        hawk@kernel.org, jiri@mellanox.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9322c47b Merge tag 'xfs-5.9-fixes-2' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11428395900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e1c560d0f4e121c9
dashboard link: https://syzkaller.appspot.com/bug?extid=5846c06bbd501a165e52
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5846c06bbd501a165e52@syzkaller.appspotmail.com

BUG: stack guard page was hit at 00000000554f5028 (stack is 00000000460081ac..000000007ee658c0)
kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 17122 Comm: syz-executor.2 Not tainted 5.9.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:validate_chain+0x3f/0x88a0 kernel/locking/lockdep.c:3171
Code: 01 00 00 49 89 ce 89 54 24 68 48 89 7c 24 28 65 48 8b 04 25 28 00 00 00 48 89 84 24 b0 01 00 00 49 bf 00 00 00 00 00 fc ff df <48> 89 34 24 4c 8d 6e 20 4c 89 e8 48 c1 e8 03 48 89 44 24 58 42 8a
RSP: 0018:ffffc90008d1ffe0 EFLAGS: 00010082
RAX: ffa821a9c58d6a00 RBX: ffffffff8afcba70 RCX: 041395c41cf575f9
RDX: 0000000000000000 RSI: ffff88808c830990 RDI: ffff88808c830080
RBP: ffffc90008d201d0 R08: dffffc0000000000 R09: fffffbfff167d899
R10: fffffbfff167d899 R11: 0000000000000000 R12: 041395c41cf575f9
R13: ffff88808c8309b0 R14: 041395c41cf575f9 R15: dffffc0000000000
FS:  00007f2bfc628700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90008d1ffe0 CR3: 0000000015958000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __lock_acquire+0x110b/0x2ae0 kernel/locking/lockdep.c:4426
 lock_acquire+0x140/0x6f0 kernel/locking/lockdep.c:5006
 seqcount_lockdep_reader_access include/linux/seqlock.h:102 [inline]
 read_seqcount_t_begin+0xb3/0x1a0 include/linux/seqlock.h:311
 read_seqbegin include/linux/seqlock.h:752 [inline]
 zone_span_seqbegin include/linux/memory_hotplug.h:80 [inline]
 page_outside_zone_boundaries mm/page_alloc.c:561 [inline]
 bad_range+0x7e/0x260 mm/page_alloc.c:590
 rmqueue+0xde/0x1c90 mm/page_alloc.c:3409
 get_page_from_freelist+0x631/0xcc0 mm/page_alloc.c:3828
 __alloc_pages_nodemask+0x27e/0x5c0 mm/page_alloc.c:4882
 __alloc_pages include/linux/gfp.h:509 [inline]
 __alloc_pages_node include/linux/gfp.h:522 [inline]
 kmem_getpages+0x37/0x1d0 mm/slab.c:1376
 cache_grow_begin+0x64/0x2b0 mm/slab.c:2590
 cache_alloc_refill+0x359/0x3f0 mm/slab.c:2962
 ____cache_alloc mm/slab.c:3045 [inline]
 slab_alloc_node mm/slab.c:3241 [inline]
 kmem_cache_alloc_node_trace+0x285/0x2a0 mm/slab.c:3592
 __do_kmalloc_node mm/slab.c:3614 [inline]
 __kmalloc_node_track_caller+0x37/0x60 mm/slab.c:3629
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0xde/0x4f0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1094 [inline]
 nlmsg_new include/net/netlink.h:940 [inline]
 rtmsg_ifinfo_build_skb+0x81/0x180 net/core/rtnetlink.c:3804
 rtmsg_ifinfo_event net/core/rtnetlink.c:3840 [inline]
 rtnetlink_event+0xed/0x1b0 net/core/rtnetlink.c:5614
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2033 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 netdev_features_change net/core/dev.c:1444 [inline]
 netdev_sync_lower_features net/core/dev.c:9372 [inline]
 __netdev_update_features+0xa11/0x1860 net/core/dev.c:9503
 netdev_change_features+0x2e/0x140 net/core/dev.c:9575
 bond_compute_features+0x5d0/0x690 drivers/net/bonding/bond_main.c:1308
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3375 [inline]
 bond_netdev_event+0x31a/0xb50 drivers/net/bonding/bond_main.c:3415
 raw_notifier_call_chain+0x
Lost 239 message(s)!
---[ end trace fceae5a866b0f30f ]---
RIP: 0010:validate_chain+0x3f/0x88a0 kernel/locking/lockdep.c:3171
Code: 01 00 00 49 89 ce 89 54 24 68 48 89 7c 24 28 65 48 8b 04 25 28 00 00 00 48 89 84 24 b0 01 00 00 49 bf 00 00 00 00 00 fc ff df <48> 89 34 24 4c 8d 6e 20 4c 89 e8 48 c1 e8 03 48 89 44 24 58 42 8a
RSP: 0018:ffffc90008d1ffe0 EFLAGS: 00010082
RAX: ffa821a9c58d6a00 RBX: ffffffff8afcba70 RCX: 041395c41cf575f9
RDX: 0000000000000000 RSI: ffff88808c830990 RDI: ffff88808c830080
RBP: ffffc90008d201d0 R08: dffffc0000000000 R09: fffffbfff167d899
R10: fffffbfff167d899 R11: 0000000000000000 R12: 041395c41cf575f9
R13: ffff88808c8309b0 R14: 041395c41cf575f9 R15: dffffc0000000000
FS:  00007f2bfc628700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90008d1ffe0 CR3: 0000000015958000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
