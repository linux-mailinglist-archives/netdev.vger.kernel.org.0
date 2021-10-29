Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E082843F72E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 08:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhJ2GeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 02:34:05 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:37573 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbhJ2Gd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 02:33:59 -0400
Received: by mail-io1-f71.google.com with SMTP id w8-20020a0566022c0800b005dc06acea8dso6059325iov.4
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 23:31:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=AC9p9RxOmeNQ0Di2MFioUi4UnNuSIcEbEznMQJTmPkA=;
        b=JLgWL7q+nBMwAhi9xIcOSmEe0FfKK/vthZp+T+l3Z9Sol9OXyz/QB/iKhyPPG4lHK9
         ww8Bz414LJ1/TDj/F5OVOtaSwEhPhwwaybf4anEnBFIhAq4jOi5jXd1NuLLitChbsXM9
         qxus6beC1luJlSh6oRNPb82O5y0LpIWN8d1YIJE7d00woFjeu+aFS5/PcDznrMiitxNm
         8+I3/VOChXw7cPiyhCdjHE8cE9cBFNYLUlQm7iU64gn+9G2PQHIqCk5sUawM+7t+KyCs
         cgoba0FiZAHwapJpnASjBKdX2bLd8WXCQUCUazo3fxmoqj0ZEkX2rcQ73OZUH1YtZujj
         rvDA==
X-Gm-Message-State: AOAM531qKU7A8/zcVbm1IcZjOOQf8A6+ZdflrS/U9ATfGzUfJY7tCxJY
        edkhz4H6tearlqwiR5YmpfpAyUzsWhl8Dj8fFT3kJOx9tM6B
X-Google-Smtp-Source: ABdhPJy0E+j7xuSw8yIOoYKhwovQzCbEbO8niWm2d1O185p9atM/01zDVdO3mQ+zldKe1wiS/QzYV2xRCroXYfWxgUyuU9xPRnZC
MIME-Version: 1.0
X-Received: by 2002:a92:cd84:: with SMTP id r4mr6460778ilb.310.1635489089196;
 Thu, 28 Oct 2021 23:31:29 -0700 (PDT)
Date:   Thu, 28 Oct 2021 23:31:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000032171c05cf77fabe@google.com>
Subject: [syzbot] KASAN: use-after-free Read in advance_sched
From:   syzbot <syzbot+1655e83234d0f0ad1fa4@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vinicius.gomes@intel.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4d98bb0d7ec2 net: macb: Use mdio child node for MDIO bus i..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17ed2c4ab00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d36d2402e8523638
dashboard link: https://syzkaller.appspot.com/bug?extid=1655e83234d0f0ad1fa4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1655e83234d0f0ad1fa4@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in advance_sched+0x967/0x9a0 net/sched/sch_taprio.c:728
Read of size 8 at addr ffff88806c81f610 by task kworker/u4:9/31023

CPU: 1 PID: 31023 Comm: kworker/u4:9 Not tainted 5.15.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 advance_sched+0x967/0x9a0 net/sched/sch_taprio.c:728
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x609/0xe50 kernel/time/hrtimer.c:1749
 hrtimer_interrupt+0x31c/0x790 kernel/time/hrtimer.c:1811
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x530 arch/x86/kernel/apic/apic.c:1103
 sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:orc_ip arch/x86/kernel/unwind_orc.c:30 [inline]
RIP: 0010:__orc_find+0x6f/0xf0 arch/x86/kernel/unwind_orc.c:52
Code: 72 4d 4c 89 e0 48 29 e8 48 89 c2 48 c1 e8 3f 48 c1 fa 02 48 01 d0 48 d1 f8 48 8d 5c 85 00 48 89 d8 48 c1 e8 03 42 0f b6 14 38 <48> 89 d8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 48 48 63 03 48 01
RSP: 0018:ffffc90017487340 EFLAGS: 00000a07
RAX: 1ffffffff1b0677b RBX: ffffffff8d833bdc RCX: ffffffff81be5d2f
RDX: 0000000000000000 RSI: ffffffff8df4b456 RDI: ffffffff8d833bd0
RBP: ffffffff8d833bdc R08: 0000000000000000 R09: ffffffff8df4b456
R10: fffff52002e90e97 R11: 0000000000086089 R12: ffffffff8d833be0
R13: ffffffff8d833bd0 R14: ffffffff8d833bd8 R15: dffffc0000000000
 orc_find arch/x86/kernel/unwind_orc.c:173 [inline]
 unwind_next_frame+0x32a/0x1ce0 arch/x86/kernel/unwind_orc.c:443
 arch_stack_walk+0x7d/0xe0 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:121
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xff/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1700 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1726
 slab_free mm/slub.c:3492 [inline]
 kfree+0xf3/0x550 mm/slub.c:4552
 kfree_const+0x51/0x60 mm/util.c:40
 kernfs_put.part.0+0x159/0x540 fs/kernfs/dir.c:530
 kernfs_put+0x42/0x50 fs/kernfs/dir.c:513
 __kernfs_remove+0x727/0xab0 fs/kernfs/dir.c:1372
 kernfs_remove_by_name_ns+0x4f/0xa0 fs/kernfs/dir.c:1544
 kernfs_remove_by_name include/linux/kernfs.h:598 [inline]
 remove_files+0x96/0x1c0 fs/sysfs/group.c:28
 sysfs_remove_group+0x87/0x170 fs/sysfs/group.c:289
 sysfs_remove_groups fs/sysfs/group.c:313 [inline]
 sysfs_remove_groups+0x5c/0xa0 fs/sysfs/group.c:305
 destroy_gid_attrs drivers/infiniband/core/sysfs.c:1174 [inline]
 ib_free_port_attrs+0x1dd/0x460 drivers/infiniband/core/sysfs.c:1394
 remove_one_compat_dev drivers/infiniband/core/device.c:1001 [inline]
 rdma_dev_exit_net+0x2b2/0x550 drivers/infiniband/core/device.c:1139
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:168
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:593
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Allocated by task 14706:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa4/0xd0 mm/kasan/common.c:522
 kmalloc include/linux/slab.h:591 [inline]
 kzalloc include/linux/slab.h:721 [inline]
 taprio_change+0x5fb/0x4160 net/sched/sch_taprio.c:1477
 taprio_init+0x52e/0x670 net/sched/sch_taprio.c:1731
 qdisc_create.constprop.0+0x457/0x10f0 net/sched/sch_api.c:1253
 tc_modify_qdisc+0x4c5/0x1980 net/sched/sch_api.c:1660
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5571
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2491
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xda0 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 sock_no_sendpage+0xf3/0x130 net/core/sock.c:3080
 kernel_sendpage.part.0+0x1a0/0x340 net/socket.c:3504
 kernel_sendpage net/socket.c:3501 [inline]
 sock_sendpage+0xe5/0x140 net/socket.c:1003
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 do_splice+0xb7e/0x1960 fs/splice.c:1079
 __do_splice+0x134/0x250 fs/splice.c:1144
 __do_sys_splice fs/splice.c:1350 [inline]
 __se_sys_splice fs/splice.c:1332 [inline]
 __x64_sys_splice+0x198/0x250 fs/splice.c:1332
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 6572:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xff/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1700 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1726
 slab_free mm/slub.c:3492 [inline]
 kfree+0xf3/0x550 mm/slub.c:4552
 rcu_do_batch kernel/rcu/tree.c:2508 [inline]
 rcu_core+0x7ab/0x1470 kernel/rcu/tree.c:2743
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe9/0x110 mm/kasan/generic.c:348
 __call_rcu kernel/rcu/tree.c:2987 [inline]
 call_rcu+0xb1/0x750 kernel/rcu/tree.c:3067
 taprio_change+0x2fe5/0x4160 net/sched/sch_taprio.c:1597
 qdisc_change net/sched/sch_api.c:1329 [inline]
 tc_modify_qdisc+0xd87/0x1980 net/sched/sch_api.c:1631
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5571
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2491
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xda0 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 sock_no_sendpage+0xf3/0x130 net/core/sock.c:3080
 kernel_sendpage.part.0+0x1a0/0x340 net/socket.c:3504
 kernel_sendpage net/socket.c:3501 [inline]
 sock_sendpage+0xe5/0x140 net/socket.c:1003
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 do_splice+0xb7e/0x1960 fs/splice.c:1079
 __do_splice+0x134/0x250 fs/splice.c:1144
 __do_sys_splice fs/splice.c:1350 [inline]
 __se_sys_splice fs/splice.c:1332 [inline]
 __x64_sys_splice+0x198/0x250 fs/splice.c:1332
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe9/0x110 mm/kasan/generic.c:348
 kvfree_call_rcu+0x74/0x990 kernel/rcu/tree.c:3552
 cfg80211_update_known_bss+0x833/0xa60 net/wireless/scan.c:1660
 cfg80211_bss_update+0xef/0x2070 net/wireless/scan.c:1707
 cfg80211_inform_single_bss_frame_data+0x6e8/0xee0 net/wireless/scan.c:2422
 cfg80211_inform_bss_frame_data+0xa7/0xb10 net/wireless/scan.c:2455
 ieee80211_bss_info_update+0x35b/0xb30 net/mac80211/scan.c:190
 ieee80211_rx_bss_info net/mac80211/ibss.c:1119 [inline]
 ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1610 [inline]
 ieee80211_ibss_rx_queued_mgmt+0x19d4/0x3130 net/mac80211/ibss.c:1639
 ieee80211_iface_process_skb net/mac80211/iface.c:1466 [inline]
 ieee80211_iface_work+0xa65/0xd00 net/mac80211/iface.c:1520
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff88806c81f600
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 16 bytes inside of
 96-byte region [ffff88806c81f600, ffff88806c81f660)
The buggy address belongs to the page:
page:ffffea0001b207c0 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88806c81fc80 pfn:0x6c81f
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea000068fe80 0000000b0000000b ffff888010c41780
raw: ffff88806c81fc80 000000008020001f 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY), pid 20, ts 172114283996, free_ts 172104540971
 prep_new_page mm/page_alloc.c:2424 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4153
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5375
 alloc_pages+0x1a7/0x300 mm/mempolicy.c:2191
 alloc_slab_page mm/slub.c:1770 [inline]
 allocate_slab mm/slub.c:1907 [inline]
 new_slab+0x319/0x490 mm/slub.c:1970
 ___slab_alloc+0x950/0x1050 mm/slub.c:3001
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3088
 slab_alloc_node mm/slub.c:3179 [inline]
 slab_alloc mm/slub.c:3221 [inline]
 kmem_cache_alloc_trace+0x302/0x3c0 mm/slub.c:3238
 kmalloc include/linux/slab.h:591 [inline]
 dst_cow_metrics_generic+0x48/0x1e0 net/core/dst.c:199
 dst_metrics_write_ptr include/net/dst.h:118 [inline]
 dst_metric_set include/net/dst.h:179 [inline]
 icmp6_dst_alloc+0x4f5/0x6c0 net/ipv6/route.c:3284
 mld_sendpack+0x56f/0xe40 net/ipv6/mcast.c:1815
 mld_send_initial_cr.part.0+0x194/0x230 net/ipv6/mcast.c:2245
 mld_send_initial_cr net/ipv6/mcast.c:1232 [inline]
 mld_dad_work+0x1d3/0x690 net/ipv6/mcast.c:2268
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3315 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3394
 kasan_depopulate_vmalloc_pte+0x5c/0x70 mm/kasan/shadow.c:375
 apply_to_pte_range mm/memory.c:2532 [inline]
 apply_to_pmd_range mm/memory.c:2576 [inline]
 apply_to_pud_range mm/memory.c:2612 [inline]
 apply_to_p4d_range mm/memory.c:2648 [inline]
 __apply_to_page_range+0x694/0x1080 mm/memory.c:2682
 kasan_release_vmalloc+0xa7/0xc0 mm/kasan/shadow.c:485
 __purge_vmap_area_lazy+0x8f9/0x1c50 mm/vmalloc.c:1704
 _vm_unmap_aliases.part.0+0x3f0/0x500 mm/vmalloc.c:2107
 _vm_unmap_aliases mm/vmalloc.c:2081 [inline]
 vm_unmap_aliases+0x47/0x50 mm/vmalloc.c:2130
 change_page_attr_set_clr+0x241/0x500 arch/x86/mm/pat/set_memory.c:1740
 change_page_attr_clear arch/x86/mm/pat/set_memory.c:1797 [inline]
 set_memory_ro+0x78/0xa0 arch/x86/mm/pat/set_memory.c:1943
 bpf_jit_binary_lock_ro include/linux/filter.h:889 [inline]
 bpf_int_jit_compile+0xe36/0x11e0 arch/x86/net/bpf_jit_comp.c:2361
 bpf_prog_select_runtime+0x464/0x6a0 kernel/bpf/core.c:1914
 bpf_prog_load+0xe8b/0x21f0 kernel/bpf/syscall.c:2305
 __sys_bpf+0x67e/0x5df0 kernel/bpf/syscall.c:4587
 __do_sys_bpf kernel/bpf/syscall.c:4691 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4689 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4689
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80

Memory state around the buggy address:
 ffff88806c81f500: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff88806c81f580: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>ffff88806c81f600: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                         ^
 ffff88806c81f680: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff88806c81f700: 00 00 00 00 00 00 00 00 07 fc fc fc fc fc fc fc
==================================================================
----------------
Code disassembly (best guess):
   0:	72 4d                	jb     0x4f
   2:	4c 89 e0             	mov    %r12,%rax
   5:	48 29 e8             	sub    %rbp,%rax
   8:	48 89 c2             	mov    %rax,%rdx
   b:	48 c1 e8 3f          	shr    $0x3f,%rax
   f:	48 c1 fa 02          	sar    $0x2,%rdx
  13:	48 01 d0             	add    %rdx,%rax
  16:	48 d1 f8             	sar    %rax
  19:	48 8d 5c 85 00       	lea    0x0(%rbp,%rax,4),%rbx
  1e:	48 89 d8             	mov    %rbx,%rax
  21:	48 c1 e8 03          	shr    $0x3,%rax
  25:	42 0f b6 14 38       	movzbl (%rax,%r15,1),%edx
* 2a:	48 89 d8             	mov    %rbx,%rax <-- trapping instruction
  2d:	83 e0 07             	and    $0x7,%eax
  30:	83 c0 03             	add    $0x3,%eax
  33:	38 d0                	cmp    %dl,%al
  35:	7c 04                	jl     0x3b
  37:	84 d2                	test   %dl,%dl
  39:	75 48                	jne    0x83
  3b:	48 63 03             	movslq (%rbx),%rax
  3e:	48                   	rex.W
  3f:	01                   	.byte 0x1


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
