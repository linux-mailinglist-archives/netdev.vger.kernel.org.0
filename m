Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F69735D797
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 07:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344719AbhDMF5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 01:57:37 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:52800 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344646AbhDMF5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 01:57:36 -0400
Received: by mail-il1-f198.google.com with SMTP id s20so7600090ilj.19
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 22:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=9N2bchLvnxMPpnYPWbmt0xNeB+s9h5wOzhFHSIaU43s=;
        b=i/Ampm3LbgEX5+GdaXK2mOi440Eetjr0JBQ33dn7DpfweUttk1t2ScnoFsq7wNqC45
         fvLbOkauk6MISTMeRSieuDHzhZozr36JUEJCfdy2SsJiyXFyPa/6C6fyPq5kAzeDllnv
         hXEcFc6252OjFIuH6Q9M278yPvIXtRfrRXc4k6ub7ljvVZs4sNwz9eKJPK8pnCc7ssdi
         Lbma5RYnQtFYg6SB8ysbjkuEAoz2GxcWz3hwZE483LKI3ucddaZCMJ9uNHjjs608j+Xy
         RARbZ8K6eOp3KR9F+IgE9LyGnnbNrkLlpvd9aVp/ZK1hsEnopgkJXHCobueSGKtDGPG1
         9Oow==
X-Gm-Message-State: AOAM5331p54PYr1OBPACgaTK5g+SU1ZaC1dQUUxibUgy8JM1mD/ZQa8O
        kq0lmIZbJqHi078h4sjGMSG/hWo1jIhQqzzv4q1KD/BmV1tS
X-Google-Smtp-Source: ABdhPJxVGhlNQSutJQy5f5/Cz8uoYrUfBQpKFJDZpu9acdOcQJ4KgNn7xpPRZvYH+p2NLq/ew9zLQJh31pBy0EedhY7w1GqzwqwX
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:c74:: with SMTP id f20mr26304386ilj.281.1618293434993;
 Mon, 12 Apr 2021 22:57:14 -0700 (PDT)
Date:   Mon, 12 Apr 2021 22:57:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000055d14505bfd44d8a@google.com>
Subject: [syzbot] KASAN: slab-out-of-bounds Read in __xfrm_decode_session (2)
From:   syzbot <syzbot+518a7b845c0083047e9c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1678e493 Merge tag 'lto-v5.12-rc6' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1565bf7cd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=71a75beb62b62a34
dashboard link: https://syzkaller.appspot.com/bug?extid=518a7b845c0083047e9c
compiler:       Debian clang version 11.0.1-2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+518a7b845c0083047e9c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in decode_session6 net/xfrm/xfrm_policy.c:3403 [inline]
BUG: KASAN: slab-out-of-bounds in __xfrm_decode_session+0x1ba4/0x2720 net/xfrm/xfrm_policy.c:3495
Read of size 1 at addr ffff888013104540 by task syz-executor.3/16514

CPU: 0 PID: 16514 Comm: syz-executor.3 Not tainted 5.12.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x176/0x24e lib/dump_stack.c:120
 print_address_description+0x5f/0x3a0 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report+0x15c/0x200 mm/kasan/report.c:416
 decode_session6 net/xfrm/xfrm_policy.c:3403 [inline]
 __xfrm_decode_session+0x1ba4/0x2720 net/xfrm/xfrm_policy.c:3495
 vti_tunnel_xmit+0x1ea/0x1510 net/ipv4/ip_vti.c:286
 __netdev_start_xmit include/linux/netdevice.h:4825 [inline]
 netdev_start_xmit include/linux/netdevice.h:4839 [inline]
 xmit_one net/core/dev.c:3605 [inline]
 dev_hard_start_xmit+0x20b/0x450 net/core/dev.c:3621
 sch_direct_xmit+0x1f0/0xd30 net/sched/sch_generic.c:313
 qdisc_restart net/sched/sch_generic.c:376 [inline]
 __qdisc_run+0xa4d/0x1a90 net/sched/sch_generic.c:384
 __dev_xmit_skb net/core/dev.c:3855 [inline]
 __dev_queue_xmit+0x1141/0x2a50 net/core/dev.c:4162
 neigh_output include/net/neighbour.h:510 [inline]
 ip6_finish_output2+0x10be/0x1460 net/ipv6/ip6_output.c:117
 dst_output include/net/dst.h:448 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ndisc_send_skb+0x93b/0xd50 net/ipv6/ndisc.c:508
 addrconf_rs_timer+0x242/0x6f0 net/ipv6/addrconf.c:3877
 call_timer_fn+0x91/0x160 kernel/time/timer.c:1431
 expire_timers kernel/time/timer.c:1476 [inline]
 __run_timers+0x6c0/0x8a0 kernel/time/timer.c:1745
 run_timer_softirq+0x63/0xf0 kernel/time/timer.c:1758
 __do_softirq+0x318/0x714 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu+0x1d8/0x200 kernel/softirq.c:422
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0x91/0xb0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
RIP: 0010:__sanitizer_cov_trace_pc+0x56/0x60 kernel/kcov.c:205
Code: 2c 8b 91 10 15 00 00 83 fa 02 75 21 48 8b 91 18 15 00 00 48 8b 32 48 8d 7e 01 8b 89 14 15 00 00 48 39 cf 73 08 48 89 44 f2 08 <48> 89 3a c3 66 0f 1f 44 00 00 4c 8b 04 24 65 48 8b 14 25 80 ef 01
RSP: 0018:ffffc90001acf9f0 EFLAGS: 00000283
RAX: ffffffff821506a4 RBX: 0000000000000000 RCX: 0000000000040000
RDX: ffffc9000f2df000 RSI: 0000000000002928 RDI: 0000000000002929
RBP: 1ffff92000359f57 R08: dffffc0000000000 R09: fffff52000359f5e
R10: fffff52000359f5e R11: 0000000000000000 R12: 1ffff11029006027
R13: ffff888034b67020 R14: 1ffff92000359f98 R15: ffff888034b67018
 ext4_match fs/ext4/namei.c:1364 [inline]
 ext4_search_dir+0x2f4/0xa10 fs/ext4/namei.c:1395
 search_dirblock fs/ext4/namei.c:1199 [inline]
 __ext4_find_entry+0x121c/0x1790 fs/ext4/namei.c:1553
 ext4_find_entry fs/ext4/namei.c:1602 [inline]
 ext4_rmdir+0x347/0x1180 fs/ext4/namei.c:3132
 vfs_rmdir+0x20a/0x3f0 fs/namei.c:3899
 ovl_remove_upper fs/overlayfs/dir.c:825 [inline]
 ovl_do_remove+0x4d2/0xbe0 fs/overlayfs/dir.c:904
 vfs_rmdir+0x20a/0x3f0 fs/namei.c:3899
 do_rmdir+0x2a5/0x560 fs/namei.c:3962
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x466459
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f08cdd4a188 EFLAGS: 00000246 ORIG_RAX: 0000000000000054
RAX: ffffffffffffffda RBX: 000000000056c008 RCX: 0000000000466459
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000200000c0
RBP: 00000000004bf9fb R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c008
R13: 00007ffefaa401bf R14: 00007f08cdd4a300 R15: 0000000000022000

Allocated by task 8393:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc+0xc2/0xf0 mm/kasan/common.c:506
 kasan_kmalloc include/linux/kasan.h:233 [inline]
 __kmalloc+0xb4/0x380 mm/slub.c:4055
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:684 [inline]
 __register_sysctl_table+0xbf/0x11a0 fs/proc/proc_sysctl.c:1317
 neigh_sysctl_register+0x525/0x5e0 net/core/neighbour.c:3695
 devinet_sysctl_register+0x9d/0x1a0 net/ipv4/devinet.c:2608
 inetdev_init+0x234/0x440 net/ipv4/devinet.c:276
 inetdev_event+0x18c/0x14b0 net/ipv4/devinet.c:1530
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2075 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2087 [inline]
 call_netdevice_notifiers net/core/dev.c:2101 [inline]
 register_netdevice+0x155f/0x1b10 net/core/dev.c:10238
 hsr_dev_finalize+0x483/0x760 net/hsr/hsr_device.c:532
 hsr_newlink+0x5e5/0x6b0 net/hsr/hsr_netlink.c:102
 __rtnl_newlink net/core/rtnetlink.c:3443 [inline]
 rtnl_newlink+0x13ba/0x1b30 net/core/rtnetlink.c:3491
 rtnetlink_rcv_msg+0x895/0xd50 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x9ae/0xd50 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 __sys_sendto+0x438/0x5c0 net/socket.c:1977
 __do_sys_sendto net/socket.c:1989 [inline]
 __se_sys_sendto net/socket.c:1985 [inline]
 __x64_sys_sendto+0xda/0xf0 net/socket.c:1985
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
 kasan_save_stack+0x27/0x50 mm/kasan/common.c:38
 kasan_record_aux_stack+0xee/0x120 mm/kasan/generic.c:345
 kvfree_call_rcu+0x14f/0x6c0 kernel/rcu/tree.c:3577
 drop_sysctl_table+0x2c2/0x400 fs/proc/proc_sysctl.c:1646
 unregister_sysctl_table+0x88/0x130 fs/proc/proc_sysctl.c:1684
 neigh_sysctl_unregister+0x74/0x90 net/core/neighbour.c:3714
 devinet_sysctl_unregister net/ipv4/devinet.c:2623 [inline]
 inetdev_destroy net/ipv4/devinet.c:324 [inline]
 inetdev_event+0x734/0x14b0 net/ipv4/devinet.c:1598
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2075 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2087 [inline]
 call_netdevice_notifiers net/core/dev.c:2101 [inline]
 unregister_netdevice_many+0xee6/0x18e0 net/core/dev.c:10934
 default_device_exit_batch+0x3a8/0x3f0 net/core/dev.c:11454
 ops_exit_list net/core/net_namespace.c:178 [inline]
 cleanup_net+0x79c/0xbd0 net/core/net_namespace.c:595
 process_one_work+0x789/0xfd0 kernel/workqueue.c:2275
 worker_thread+0xac1/0x1300 kernel/workqueue.c:2421
 kthread+0x39a/0x3c0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

The buggy address belongs to the object at ffff888013104000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 320 bytes to the right of
 1024-byte region [ffff888013104000, ffff888013104400)
The buggy address belongs to the page:
page:ffffea00004c4000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x13100
head:ffffea00004c4000 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010841dc0
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888013104400: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888013104480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888013104500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                           ^
 ffff888013104580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888013104600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
