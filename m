Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092FB2C383B
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgKYEpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:45:17 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:40007 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbgKYEpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:45:16 -0500
Received: by mail-il1-f199.google.com with SMTP id b18so839580ilr.7
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:45:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=u4H8KrNhGepYi7DrBesiMdEtasQuTu9KqqFYY/sbUTo=;
        b=RjwF7++LnHBSfOeYAs3b7a5HhuhU9PvucRAU5/Z5ZWT+MnWkD5cTQ7C1mz1tKczraw
         gCAdXikXtes4vFXyC8QezvNWtwqwBo2ZmPsXxHN5wuw/DtGLqkXCYYSsg3d0DMPwSo8O
         KXma8U0rY9W8gn61cXco3O7RE/Bqe+g9JwoHPYTpJdiyTcYr9nA9+rCTq2De3j+4zcGG
         anwLqUus07zvkegSbkb/f4ZZMvNlmNg715y6TDDG1LuPu01A8egxmck4kEhkQXAkTi36
         AAIWu1yzXV78MUOF53m6/zhvpWqJG+/urGL1irAxYLWW5GwAX7vOzu7OKVl3J9WbgTcr
         6kBw==
X-Gm-Message-State: AOAM533F0yzAuhGSrLXwaV6Fc1WEHVY9UsulTor+ofCWx5eVEyVrjF7F
        Wtu4yoUilw+ulHhUpbwj0J6ONpH2HhmPmcGwDm1M6l1CI4It
X-Google-Smtp-Source: ABdhPJyrq+8vqWDkgDm0jbyXrouQafHGnMmSi82uuECzWxi8Ju+VMPMEk1VZP/Z+vEIv1fUkjiX4/OpwGizLaZqbm2h71Amdo7PJ
MIME-Version: 1.0
X-Received: by 2002:a92:c941:: with SMTP id i1mr1492714ilq.158.1606279515000;
 Tue, 24 Nov 2020 20:45:15 -0800 (PST)
Date:   Tue, 24 Nov 2020 20:45:14 -0800
In-Reply-To: <0000000000002953ba05b4c351f4@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e6da4405b4e717b3@google.com>
Subject: Re: general protection fault in ieee80211_subif_start_xmit
From:   syzbot <syzbot+d7a3b15976bf7de2238a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    80145ac2 Merge tag 's390-5.10-5' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12a8ad43500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b81aff78c272da44
dashboard link: https://syzkaller.appspot.com/bug?extid=d7a3b15976bf7de2238a
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1229d0fd500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11a963d1500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d7a3b15976bf7de2238a@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000034: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000001a0-0x00000000000001a7]
CPU: 0 PID: 10709 Comm: syz-executor918 Not tainted 5.10.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ieee80211_multicast_to_unicast net/mac80211/tx.c:4070 [inline]
RIP: 0010:ieee80211_subif_start_xmit+0x24e/0xee0 net/mac80211/tx.c:4154
Code: 03 80 3c 02 00 0f 85 83 0c 00 00 49 8b 9f 50 17 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb a4 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 58 0c 00 00
RSP: 0018:ffffc90000007588 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8851c2ad
RDX: 0000000000000034 RSI: ffffffff8851c33d RDI: 00000000000001a4
RBP: ffff888018f8fc80 R08: 0000000000000000 R09: ffffffff8cecbd4f
R10: 0000000000000004 R11: 0000000000000001 R12: ffffffff8a61f520
R13: ffff88802517a042 R14: 000000000000005a R15: ffff888018314000
FS:  0000000000ff5940(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000046dde0 CR3: 00000000203d8000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __netdev_start_xmit include/linux/netdevice.h:4718 [inline]
 netdev_start_xmit include/linux/netdevice.h:4732 [inline]
 xmit_one net/core/dev.c:3564 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3580
 sch_direct_xmit+0x2e1/0xbd0 net/sched/sch_generic.c:313
 qdisc_restart net/sched/sch_generic.c:376 [inline]
 __qdisc_run+0x4ba/0x15e0 net/sched/sch_generic.c:384
 qdisc_run include/net/pkt_sched.h:131 [inline]
 qdisc_run include/net/pkt_sched.h:123 [inline]
 __dev_xmit_skb net/core/dev.c:3755 [inline]
 __dev_queue_xmit+0x1453/0x2da0 net/core/dev.c:4108
 neigh_hh_output include/net/neighbour.h:499 [inline]
 neigh_output include/net/neighbour.h:508 [inline]
 ip6_finish_output2+0x8db/0x16c0 net/ipv6/ip6_output.c:117
 __ip6_finish_output net/ipv6/ip6_output.c:143 [inline]
 __ip6_finish_output+0x447/0xab0 net/ipv6/ip6_output.c:128
 ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
 NF_HOOK_COND include/linux/netfilter.h:290 [inline]
 ip6_output+0x1db/0x520 net/ipv6/ip6_output.c:176
 dst_output include/net/dst.h:443 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 NF_HOOK include/linux/netfilter.h:295 [inline]
 mld_sendpack+0x92a/0xdb0 net/ipv6/mcast.c:1679
 mld_send_cr net/ipv6/mcast.c:1975 [inline]
 mld_ifc_timer_expire+0x60a/0xf10 net/ipv6/mcast.c:2474
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1410
 expire_timers kernel/time/timer.c:1455 [inline]
 __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1747
 __run_timers kernel/time/timer.c:1728 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1760
 __do_softirq+0x2a0/0x9f6 kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x132/0x200 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
RIP: 0010:bytes_is_nonzero mm/kasan/generic.c:91 [inline]
RIP: 0010:memory_is_nonzero mm/kasan/generic.c:108 [inline]
RIP: 0010:memory_is_poisoned_n mm/kasan/generic.c:134 [inline]
RIP: 0010:memory_is_poisoned mm/kasan/generic.c:165 [inline]
RIP: 0010:check_memory_region_inline mm/kasan/generic.c:183 [inline]
RIP: 0010:check_memory_region+0xde/0x180 mm/kasan/generic.c:192
Code: 74 f2 48 89 c2 b8 01 00 00 00 48 85 d2 75 56 5b 5d 41 5c c3 48 85 d2 74 5e 48 01 ea eb 09 48 83 c0 01 48 39 d0 74 50 80 38 00 <74> f2 eb d4 41 bc 08 00 00 00 48 89 ea 45 29 dc 4d 8d 1c 2c eb 0c
RSP: 0018:ffffc90001a4f478 EFLAGS: 00000246
RAX: fffff52000013784 RBX: fffff52000013785 RCX: ffffffff81c2295c
RDX: fffff52000013785 RSI: 0000000000000008 RDI: ffffc9000009bc20
RBP: fffff52000013784 R08: 0000000000000001 R09: ffffc9000009bc27
R10: fffff52000013784 R11: 0000000000000000 R12: ffff88802d3305e0
R13: fffff52000013784 R14: ffff88802d330628 R15: ffff88802d330648
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 test_and_set_bit_lock include/asm-generic/bitops/instrumented-lock.h:55 [inline]
 bit_spin_lock include/linux/bit_spinlock.h:27 [inline]
 hlist_bl_lock include/linux/list_bl.h:148 [inline]
 ___d_drop+0xac/0x350 fs/dcache.c:489
 __d_drop fs/dcache.c:497 [inline]
 __d_drop fs/dcache.c:494 [inline]
 d_invalidate+0xa2/0x280 fs/dcache.c:1670
 simple_recursive_removal+0x347/0x6b0 fs/libfs.c:289
 debugfs_remove fs/debugfs/inode.c:725 [inline]
 debugfs_remove+0x59/0x80 fs/debugfs/inode.c:719
 ieee80211_debugfs_remove_netdev+0x43/0xc0 net/mac80211/debugfs_netdev.c:833
 ieee80211_teardown_sdata+0x48/0x2d0 net/mac80211/iface.c:687
 ieee80211_runtime_change_iftype net/mac80211/iface.c:1657 [inline]
 ieee80211_if_change_type+0x2b4/0x620 net/mac80211/iface.c:1691
 ieee80211_change_iface+0x26/0x210 net/mac80211/cfg.c:157
 rdev_change_virtual_intf net/wireless/rdev-ops.h:69 [inline]
 cfg80211_change_iface+0x2eb/0xef0 net/wireless/util.c:1032
 nl80211_set_interface+0x65c/0x8d0 net/wireless/nl80211.c:3789
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 __sys_sendto+0x21c/0x320 net/socket.c:1992
 __do_sys_sendto net/socket.c:2004 [inline]
 __se_sys_sendto net/socket.c:2000 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2000
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4026b3
Code: ff ff ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb cd 66 0f 1f 44 00 00 83 3d 5d 80 2d 00 00 75 17 49 89 ca b8 2c 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 71 0e 00 00 c3 48 83 ec 08 e8 d7 03 00 00
RSP: 002b:00007ffe154f4a38 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007ffe154f4af0 RCX: 00000000004026b3
RDX: 0000000000000024 RSI: 00007ffe154f4b40 RDI: 0000000000000007
RBP: 0000000000000000 R08: 00007ffe154f4a40 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007ffe154f4b40 R15: 0000000000000007
Modules linked in:
---[ end trace 16e6f8b07571c99a ]---
RIP: 0010:ieee80211_multicast_to_unicast net/mac80211/tx.c:4070 [inline]
RIP: 0010:ieee80211_subif_start_xmit+0x24e/0xee0 net/mac80211/tx.c:4154
Code: 03 80 3c 02 00 0f 85 83 0c 00 00 49 8b 9f 50 17 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb a4 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 58 0c 00 00
RSP: 0018:ffffc90000007588 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8851c2ad
RDX: 0000000000000034 RSI: ffffffff8851c33d RDI: 00000000000001a4
RBP: ffff888018f8fc80 R08: 0000000000000000 R09: ffffffff8cecbd4f
R10: 0000000000000004 R11: 0000000000000001 R12: ffffffff8a61f520
R13: ffff88802517a042 R14: 000000000000005a R15: ffff888018314000
FS:  0000000000ff5940(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000046dde0 CR3: 00000000203d8000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

