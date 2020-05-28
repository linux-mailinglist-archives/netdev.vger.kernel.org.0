Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3841E6901
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 20:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391413AbgE1SDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 14:03:22 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:51524 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391403AbgE1SDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 14:03:17 -0400
Received: by mail-io1-f71.google.com with SMTP id c5so11259498iok.18
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 11:03:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yv7cA9FoK0ge2NXknXoJO8E4gA2SHjoaGzsyBUcXZgA=;
        b=TaUk0WIGjXHz5rnLBheD3Zz+t6T8oAvetsslyVu/Cd2NzH1sh/WSqKZ26b9/V2FJt8
         yh9LNIJ5s3AdYiQ5xF9vR+UY+r6hsqeJWHKBYpFIbvMPEsYw4u7zoGnYSnx6Gfad+Atk
         hDJI615CgVumLV2vUnLMSTPaOdPEx9w+Glvh36XlxVHliPAh1vIJnu13KoxhifvhalHV
         goBvyyHWxNHLwlGHL76mTnSifxpi3Ow0jDgJFpb5d+2k70BQ6h+vuAyf3RlBARxm0sld
         KPf4vK3N33NywqbuK/v+JNFNrBULFwg0e6I85PhR2kHOJQAZIC2qJJhuUFJ73xz9E+I+
         XRHQ==
X-Gm-Message-State: AOAM533GiYOTrnI3vXVwzHT8h9BP1BwxfSHL7TNKdg4rN14WRSLQujqh
        IzMPtHvV/tfqwVCxPcbsxAmiGJFuNU2pP7dyMfnnGCD3gzIg
X-Google-Smtp-Source: ABdhPJwl6b9KTKG3pi+HvYIG2ZnXhHqtOW139IaRfZt3VNf36NRLxr0ugeDB3f83Us97Sct+jpjxCAbhZ4fzbS2bpLkro2rtbeVA
MIME-Version: 1.0
X-Received: by 2002:a92:d94b:: with SMTP id l11mr4064523ilq.105.1590688993661;
 Thu, 28 May 2020 11:03:13 -0700 (PDT)
Date:   Thu, 28 May 2020 11:03:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006a575205a6b9242d@google.com>
Subject: BUG: stack guard page was hit in mark_lock
From:   syzbot <syzbot+1ea34900b9a6fb8526c4@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        hawk@kernel.org, jiri@mellanox.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    54b9aca0 Merge branch 'r8169-remove-mask-argument-from-few..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13e710ee100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=85548e63e9ca83a9
dashboard link: https://syzkaller.appspot.com/bug?extid=1ea34900b9a6fb8526c4
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1ea34900b9a6fb8526c4@syzkaller.appspotmail.com

BUG: stack guard page was hit at 00000000714cd75e (stack is 00000000aa311719..00000000d060b614)
kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 31367 Comm: syz-executor.2 Not tainted 5.7.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:mark_lock+0x16/0xf10 kernel/locking/lockdep.c:3900
Code: 6c 58 00 eb 80 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 41 57 41 56 41 55 41 54 41 89 d4 48 ba 00 00 00 00 00 fc ff df 55 <53> 48 81 ec 90 00 00 00 48 c7 44 24 30 b3 8a b5 41 48 8d 5c 24 30
RSP: 0018:ffffc90007600000 EFLAGS: 00010002
RAX: 000000000000000c RBX: 000000000000001d RCX: ffff888045176cec
RDX: dffffc0000000000 RSI: ffff888045176d30 RDI: ffff888045176440
RBP: ffff888045176d30 R08: 0000000000000000 R09: fffffbfff1860938
R10: ffffffff8c3049bf R11: fffffbfff1860937 R12: 0000000000000008
R13: 0000000000000000 R14: ffff888045176d52 R15: dffffc0000000000
FS:  00007ff061e16700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc900075ffff8 CR3: 0000000089edb000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 mark_usage kernel/locking/lockdep.c:3860 [inline]
 __lock_acquire+0x9a4/0x4c50 kernel/locking/lockdep.c:4309
 lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4934
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x8c/0xbf kernel/locking/spinlock.c:159
 rmqueue mm/page_alloc.c:3349 [inline]
 get_page_from_freelist+0x14c7/0x3590 mm/page_alloc.c:3759
 __alloc_pages_nodemask+0x29f/0x810 mm/page_alloc.c:4812
 __alloc_pages include/linux/gfp.h:504 [inline]
 __alloc_pages_node include/linux/gfp.h:517 [inline]
 kmem_getpages mm/slab.c:1367 [inline]
 cache_grow_begin+0x8c/0xc10 mm/slab.c:2600
 cache_alloc_refill mm/slab.c:2972 [inline]
 ____cache_alloc mm/slab.c:3055 [inline]
 ____cache_alloc mm/slab.c:3038 [inline]
 slab_alloc_node mm/slab.c:3250 [inline]
 kmem_cache_alloc_node_trace+0x6c3/0x790 mm/slab.c:3593
 __do_kmalloc_node mm/slab.c:3615 [inline]
 __kmalloc_node_track_caller+0x38/0x60 mm/slab.c:3630
 __kmalloc_reserve.isra.0+0x39/0xe0 net/core/skbuff.c:142
 __alloc_skb+0xef/0x5a0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 nlmsg_new include/net/netlink.h:940 [inline]
 rtmsg_ifinfo_build_skb+0x72/0x1a0 net/core/rtnetlink.c:3702
 rtmsg_ifinfo_event.part.0+0x49/0xe0 net/core/rtnetlink.c:3738
 rtmsg_ifinfo_event net/core/rtnetlink.c:5519 [inline]
 rtnetlink_event+0x11e/0x150 net/core/rtnetlink.c:5512
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x331/0x410 drivers/net/team/team.c:3006
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 netdev_features_change net/core/dev.c:1432 [inline]
 netdev_sync_lower_features net/core/dev.c:9015 [inline]
 __netdev_update_features+0x877/0x1320 net/core/dev.c:9146
 netdev_change_features+0x61/0xb0 net/core/dev.c:9218
 team_add_slave+0x1678/0x1790 drivers/net/team/team.c:1971
 do_set_master net/core/rtnetlink.c:2477 [inline]
 do_set_master+0x1d7/0x230 net/core/rtnetlink.c:2450
 do_setlink+0xaa2/0x3680 net/core/rtnetlink.c:2612
 __rtnl_newlink+0xad5/0x1590 net/core/rtnetlink.c:3273
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3398
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e6/0x810 net/socket.c:2352
 ___sys_sendmsg+0x100/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45ca29
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ff061e15c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000500f40 RCX: 000000000045ca29
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000005
RBP: 000000000078c040 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a04 R14: 00000000004ccdcc R15: 00007ff061e166d4
Modules linked in:
---[ end trace 2d08b4afbacd7cf7 ]---
RIP: 0010:mark_lock+0x16/0xf10 kernel/locking/lockdep.c:3900
Code: 6c 58 00 eb 80 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 41 57 41 56 41 55 41 54 41 89 d4 48 ba 00 00 00 00 00 fc ff df 55 <53> 48 81 ec 90 00 00 00 48 c7 44 24 30 b3 8a b5 41 48 8d 5c 24 30
RSP: 0018:ffffc90007600000 EFLAGS: 00010002
RAX: 000000000000000c RBX: 000000000000001d RCX: ffff888045176cec
RDX: dffffc0000000000 RSI: ffff888045176d30 RDI: ffff888045176440
RBP: ffff888045176d30 R08: 0000000000000000 R09: fffffbfff1860938
R10: ffffffff8c3049bf R11: fffffbfff1860937 R12: 0000000000000008
R13: 0000000000000000 R14: ffff888045176d52 R15: dffffc0000000000
FS:  00007ff061e16700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc900075ffff8 CR3: 0000000089edb000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
