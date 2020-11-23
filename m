Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6842C02EC
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 11:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgKWKEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 05:04:21 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:53982 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbgKWKET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 05:04:19 -0500
Received: by mail-il1-f199.google.com with SMTP id t9so13317242ilp.20
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 02:04:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lSQK3mAUQqWpSVCyehyklfAWXzREsg2z87s+rsm3dyk=;
        b=BqICf/4VOHenanzM9xpL5qerByCZleDRV9w5+ArVRNlMZEjkEsQMh+tOJ2Xyu6DegD
         qLz0eFMPdeEFECGWdBr3Sl09hH6IpexaWKBGZCXFRrAPZNepSmUEZ+dcByc+ZDVzD2mC
         idUS56ZbhzQX59g3mng0zMzkM6heiHl0CDAx1Pfv9JS+HUhoqgWACF3vzZRvrv+Upofh
         TufuQiPMlrp8InEANRIBxdB4btLQYCkVEaV6BSLYkgM35NIwbSDt8RByB9H20H/qTbJi
         Go+CKdCGBNbe/svbZCfijTGnwqyTku9YrRIUcvAhOrMjtS+ku+Ujl3vbxe+Fwy9vg59m
         M6Tw==
X-Gm-Message-State: AOAM533mVi1XFp3uctfD9mpwWCosd5zu9d15dS8snISnL/Qq6To5ZfuL
        uCzSgKuFNIyvVsUy4DRWhQFSHwtBcAHTEyd0jzMrGSfVa5ji
X-Google-Smtp-Source: ABdhPJyeJkAw0NshxGpN4recZHOtKc3vbHMAB9z3HRor/gZCaX9cDMvqpMIU3b6H+Lgd8NLXLE/k5OHTTv44rHbtvmReVe/a6mkG
MIME-Version: 1.0
X-Received: by 2002:a92:dd91:: with SMTP id g17mr30459785iln.12.1606125856837;
 Mon, 23 Nov 2020 02:04:16 -0800 (PST)
Date:   Mon, 23 Nov 2020 02:04:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002953ba05b4c351f4@google.com>
Subject: general protection fault in ieee80211_subif_start_xmit
From:   syzbot <syzbot+d7a3b15976bf7de2238a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a349e4c6 Merge tag 'xfs-5.10-fixes-7' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1427b225500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=330f3436df12fd44
dashboard link: https://syzkaller.appspot.com/bug?extid=d7a3b15976bf7de2238a
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164652f5500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d7a3b15976bf7de2238a@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000034: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000001a0-0x00000000000001a7]
CPU: 0 PID: 10156 Comm: syz-executor.4 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ieee80211_multicast_to_unicast net/mac80211/tx.c:4070 [inline]
RIP: 0010:ieee80211_subif_start_xmit+0x24e/0xee0 net/mac80211/tx.c:4154
Code: 03 80 3c 02 00 0f 85 83 0c 00 00 49 8b 9f 50 17 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb a4 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 58 0c 00 00
RSP: 0018:ffffc90000007588 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8851c61d
RDX: 0000000000000034 RSI: ffffffff8851c6ad RDI: 00000000000001a4
RBP: ffff88801b850280 R08: 0000000000000000 R09: ffffffff8cecb9cf
R10: 0000000000000004 R11: 0000000000000000 R12: ffffffff8a61f1e0
R13: ffff888012f07042 R14: 000000000000005a R15: ffff8880284b0000
FS:  00007f1159678700(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000016a9e60 CR3: 000000002ca99000 CR4: 00000000001506f0
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
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/irqflags.h:85 [inline]
RIP: 0010:lock_acquire kernel/locking/lockdep.c:5438 [inline]
RIP: 0010:lock_acquire+0x2cd/0x8c0 kernel/locking/lockdep.c:5400
Code: 48 c7 c7 c0 5e 4b 89 48 83 c4 20 e8 dd 68 8f 07 b8 ff ff ff ff 65 0f c1 05 c0 b2 ab 7e 83 f8 01 0f 85 09 04 00 00 ff 34 24 9d <e9> 37 fe ff ff 65 ff 05 67 a1 ab 7e 48 8b 05 a0 ab 82 0b e8 6b 5d
RSP: 0018:ffffc9000aaf73e0 EFLAGS: 00000246
RAX: 0000000000000001 RBX: 1ffff9200155ee7e RCX: ffffffff8155f384
RDX: 1ffff11004e58121 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffff8ebb166f
R10: fffffbfff1d762cd R11: 0000000000000000 R12: 0000000000000000
R13: ffff88803eff20a8 R14: 0000000000000000 R15: 0000000000000000
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 lockref_put_or_lock+0x14/0x80 lib/lockref.c:174
 fast_dput fs/dcache.c:747 [inline]
 dput+0x4b9/0xbc0 fs/dcache.c:865
 simple_recursive_removal+0x411/0x6b0 fs/libfs.c:296
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
RIP: 0033:0x417937
Code: 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 81 19 00 00 c3 48 83 ec 08 e8 e7 fa ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 2d fb ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007f1159676a90 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f1159676be0 RCX: 0000000000417937
RDX: 0000000000000024 RSI: 00007f1159676c30 RDI: 0000000000000007
RBP: 0000000000000000 R08: 00007f1159676aa0 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f1159676c30 R15: 0000000000000007
Modules linked in:
---[ end trace 80d935084a37d7a4 ]---
RIP: 0010:ieee80211_multicast_to_unicast net/mac80211/tx.c:4070 [inline]
RIP: 0010:ieee80211_subif_start_xmit+0x24e/0xee0 net/mac80211/tx.c:4154
Code: 03 80 3c 02 00 0f 85 83 0c 00 00 49 8b 9f 50 17 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb a4 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 58 0c 00 00
RSP: 0018:ffffc90000007588 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8851c61d
RDX: 0000000000000034 RSI: ffffffff8851c6ad RDI: 00000000000001a4
RBP: ffff88801b850280 R08: 0000000000000000 R09: ffffffff8cecb9cf
R10: 0000000000000004 R11: 0000000000000000 R12: ffffffff8a61f1e0
R13: ffff888012f07042 R14: 000000000000005a R15: ffff8880284b0000
FS:  00007f1159678700(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000016a9e60 CR3: 000000002ca99000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
