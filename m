Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433F23A5CAA
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 07:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbhFNGAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 02:00:36 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:35455 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhFNGAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 02:00:32 -0400
Received: by mail-il1-f198.google.com with SMTP id n18-20020a92dd120000b02901eda20e4362so6087371ilm.2
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 22:58:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=iolwSrBLU5wcSTW/N0CiJLq6wC7qoEFtQEKW0DDo1fc=;
        b=ZpWWY0LVKzwfWseDaooZ9Xf4RO7/zlhQbbDV0D9cbFeZ9h+Zk59hcpQUI76tkkbk3h
         Lw7+Fl98mOcR6p3zTpUWsEDKNcqvYoGAR4TjjXIw41ftz+27g4jF6DwS+J2XOfWzXr6z
         wb0DMdIHV8uK5VHc1iHwCdW5ZnhV5ULtN4cAyXqpfKc7vWhzMjqWLyMPIFjcPZOD8r9+
         E3s37dHLNA1O/Un4DX4ZoGewg4Ie2M3bxw1J3///mKwZaW1f18gltv4qhpC4qBCsNUdT
         OMJrBwUYZbQZZ7ievgHJaagsakPzgpQGWonkt3IamEMR2FL/9YstNvAavziwmOR+7xCr
         SGZw==
X-Gm-Message-State: AOAM531UGK8Xv5d+kCplNK5GMyx/ZkgxRMZos9NqSheWhTY5GGAW/UeI
        DETs5YGEGL2Mz04dBKdriUuUdbVXtFjfnSAgl5afHVEQe1wK
X-Google-Smtp-Source: ABdhPJy6CFJhViExCUyijYTrppYaOtBX+UmeEp+WNK5oxst0Kvv0cP1NrKo57iwv0a/qyhrK0GfcrmSxdXbovNwmor5OrY1FQJYp
MIME-Version: 1.0
X-Received: by 2002:a92:d24a:: with SMTP id v10mr13215606ilg.246.1623650296720;
 Sun, 13 Jun 2021 22:58:16 -0700 (PDT)
Date:   Sun, 13 Jun 2021 22:58:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002cf2d905c4b38bee@google.com>
Subject: [syzbot] BUG: stack guard page was hit in preempt_count_add
From:   syzbot <syzbot+df16599805dec43e5fc2@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jirislaby@kernel.org,
        jpoimboe@redhat.com, jthierry@redhat.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2aa8eca6 net: appletalk: fix some mistakes in grammar
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10c653afd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a43776cd214e447a
dashboard link: https://syzkaller.appspot.com/bug?extid=df16599805dec43e5fc2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+df16599805dec43e5fc2@syzkaller.appspotmail.com

BUG: stack guard page was hit at ffffc90009defff8 (stack is ffffc90009df0000..ffffc90009df7fff)
kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 17591 Comm: syz-executor.0 Not tainted 5.13.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:get_lock_parent_ip include/linux/ftrace.h:841 [inline]
RIP: 0010:preempt_latency_start kernel/sched/core.c:4780 [inline]
RIP: 0010:preempt_latency_start kernel/sched/core.c:4777 [inline]
RIP: 0010:preempt_count_add+0x6f/0x140 kernel/sched/core.c:4805
Code: 05 16 f0 b2 7e 0f b6 c0 3d f4 00 00 00 7f 64 65 8b 05 05 f0 b2 7e 25 ff ff ff 7f 39 c3 74 03 5b 5d c3 48 8b 5c 24 10 48 89 df <e8> 8c cd 0b 00 85 c0 75 35 65 48 8b 2c 25 00 f0 01 00 48 8d bd f0
RSP: 0018:ffffc90009df0000 EFLAGS: 00010246
RAX: 0000000000000001 RBX: ffffffff81331a80 RCX: 1ffffffff20f20e4
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81331a80
RBP: 0000000000000001 R08: 0000000000000001 R09: ffffc90009df0140
R10: fffff520013be033 R11: 0000000000000000 R12: ffffc90009df0188
R13: fffff520013be029 R14: ffffc90009df0140 R15: ffffc90009df0140
FS:  00007f6395c14700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90009defff8 CR3: 0000000094018000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 unwind_next_frame+0x120/0x1ce0 arch/x86/kernel/unwind_orc.c:428
 __unwind_start+0x51b/0x800 arch/x86/kernel/unwind_orc.c:699
 unwind_start arch/x86/include/asm/unwind.h:60 [inline]
 arch_stack_walk+0x5c/0xe0 arch/x86/kernel/stacktrace.c:24
 stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:121
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:428 [inline]
 __kasan_slab_alloc+0x84/0xa0 mm/kasan/common.c:461
 kasan_slab_alloc include/linux/kasan.h:236 [inline]
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:2913 [inline]
 kmem_cache_alloc_node+0x269/0x3e0 mm/slub.c:2949
 __alloc_skb+0x20b/0x340 net/core/skbuff.c:414
 alloc_skb include/linux/skbuff.h:1112 [inline]
 nlmsg_new include/net/netlink.h:953 [inline]
 rtmsg_ifinfo_build_skb+0x72/0x1a0 net/core/rtnetlink.c:3791
 rtmsg_ifinfo_event net/core/rtnetlink.c:3827 [inline]
 rtmsg_ifinfo_event net/core/rtnetlink.c:3818 [inline]
 rtnetlink_event+0x123/0x1d0 net/core/rtnetlink.c:5603
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
 call_netdevice_notifiers net/core/dev.c:2147 [inline]
 netdev_features_change net/core/dev.c:1493 [inline]
 netdev_sync_lower_features net/core/dev.c:9814 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:9961
 netdev_change_features+0x61/0xb0 net/core/dev.c:10033
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1329
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3431 [inline]
 bond_netdev_event+0x5d6/0xa80 drivers/net/bonding/bond_main.c:3471
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
 call_netdevice_notifiers net/core/dev.c:2147 [inline]
 netdev_features_change net/core/dev.c:1493 [inline]
 netdev_sync_lower_features net/core/dev.c:9814 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:9961
 netdev_change_features+0x61/0xb0 net/core/dev.c:10033
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1329
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3431 [inline]
 bond_netdev_event+0x5d6/0xa80 drivers/net/bonding/bond_main.c:3471
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
 call_netdevice_notifiers net/core/dev.c:2147 [inline]
 netdev_features_change net/core/dev.c:1493 [inline]
 netdev_sync_lower_features net/core/dev.c:9814 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:9961
 netdev_change_features+0x61/0xb0 net/core/dev.c:10033
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1329
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3431 [inline]
 bond_netdev_event+0x5d6/0xa80 drivers/net/bonding/bond_main.c:3471
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
 call_netdevice_notifiers net/core/dev.c:2147 [inline]
 netdev_features_change net/core/dev.c:1493 [inline]
 netdev_sync_lower_features net/core/dev.c:9814 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:9961
 netdev_change_features+0x61/0xb0 net/core/dev.c:10033
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1329
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3431 [inline]
 bond_netdev_event+0x5d6/0xa80 drivers/net/bonding/bond_main.c:3471
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
 call_netdevice_notifiers net/core/dev.c:2147 [inline]
 netdev_features_change net/core/dev.c:1493 [inline]
 netdev_sync_lower_features net/core/dev.c:9814 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:9961
 netdev_change_features+0x61/0xb0 net/core/dev.c:10033
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1329
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3431 [inline]
 bond_netdev_event+0x5d6/0xa80 drivers/net/bonding/bond_main.c:3471
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
 call_netdevice_notifiers net/core/dev.c:2147 [inline]
 netdev_features_change net/core/dev.c:1493 [inline]
 netdev_sync_lower_features net/core/dev.c:9814 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:9961
 netdev_change_features+0x61/0xb0 net/core/dev.c:10033
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1329
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3431 [inline]
 bond_netdev_event+0x5d6/0xa80 drivers/net/bonding/bond_main.c:3471
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
 call_netdevice_notifiers net/core/dev.c:2147 [inline]
 netdev_features_change net/core/dev.c:1493 [inline]
 netdev_sync_lower_features net/core/dev.c:9814 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:9961
 netdev_change_features+0x61/0xb0 net/core/dev.c:10033
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1329
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3431 [inline]
 bond_netdev_event+0x5d6/0xa80 drivers/net/bonding/bond_main.c:3471
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
 call_netdevice_notifiers net/core/dev.c:2147 [inline]
 netdev_features_change net/core/dev.c:1493 [inline]
 netdev_sync_lower_features net/core/dev.c:9814 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:9961
 netdev_change_features+0x61/0xb0 net/core/dev.c:10033
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1329
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3431 [inline]
 bond_netdev_event+0x5d6/0xa80 drivers/net/bonding/bond_main.c:3471
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
 call_netdevice_notifiers net/core/dev.c:2147 [inline]
 netdev_features_change net/core/dev.c:1493 [inline]
 netdev_sync_lower_features net/core/dev.c:9814 [inline]
 __netdev_update_features+0x95d/0x17d0 net/core/dev.c:9961
 netdev_change_features+0x61/0xb0 net/core/dev.c:10033
 bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1329
 bond_slave_netdev_event drivers/net/bonding/bond_main.c:3431 [inline]
 bond_netdev_event+0x5d6/0xa80 drivers/net/bonding/bond_main.c:3471
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 __netdev_update_features+0x9
Lost 457 message(s)!
---[ end trace 910abc79cbd754ed ]---
RIP: 0010:get_lock_parent_ip include/linux/ftrace.h:841 [inline]
RIP: 0010:preempt_latency_start kernel/sched/core.c:4780 [inline]
RIP: 0010:preempt_latency_start kernel/sched/core.c:4777 [inline]
RIP: 0010:preempt_count_add+0x6f/0x140 kernel/sched/core.c:4805
Code: 05 16 f0 b2 7e 0f b6 c0 3d f4 00 00 00 7f 64 65 8b 05 05 f0 b2 7e 25 ff ff ff 7f 39 c3 74 03 5b 5d c3 48 8b 5c 24 10 48 89 df <e8> 8c cd 0b 00 85 c0 75 35 65 48 8b 2c 25 00 f0 01 00 48 8d bd f0
RSP: 0018:ffffc90009df0000 EFLAGS: 00010246
RAX: 0000000000000001 RBX: ffffffff81331a80 RCX: 1ffffffff20f20e4
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81331a80
RBP: 0000000000000001 R08: 0000000000000001 R09: ffffc90009df0140
R10: fffff520013be033 R11: 0000000000000000 R12: ffffc90009df0188
R13: fffff520013be029 R14: ffffc90009df0140 R15: ffffc90009df0140
FS:  00007f6395c14700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90009defff8 CR3: 0000000094018000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
