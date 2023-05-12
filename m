Return-Path: <netdev+bounces-2315-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AEF0701244
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 00:50:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9CA91C212D1
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 22:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A225B22612;
	Fri, 12 May 2023 22:50:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6AE22600
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 22:50:53 +0000 (UTC)
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7B04C1C
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 15:50:50 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-331027514f6so69028295ab.0
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 15:50:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683931850; x=1686523850;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9XW1v84MCiE6HB/1T4rDTcZlViKTP1TqQBq0bOy7GQE=;
        b=CkoVHKqSeMAaUlWJFd14/vFQ1TVkI/ukNdv1zEWwh84C5hD32mKhNUpCkb6Ig+vAW5
         b0yrjsX886pkN8dF/aXX1DwlxATfXMwbr8GZoMFFaOzVIwqXUbYZ//DH9OdDcF/N/Ftm
         fhzPA5WCyPy0CNdrfTPWpTAgZcCo80AmoX1Ogo1oyyC9/KLyCvNwW8lbofA99Q9cpKOg
         9bnALg48USs95Sa0Qhby7E901bGzoKuykKasLXclpZmwHtwlE3Vt1nFBTj6lhx5M2C43
         4eeE+JaDKfyQeGLwHn5hRG3AEirTER1RiLZiJNHIJnEliwupGrBD54LWodw3vSWIt95W
         U8Gw==
X-Gm-Message-State: AC+VfDymfVrGTDEY4vyLXiz3vXCWTqGkGEq7gTVcUN4B5/yHUyhb7smd
	FSuHq4HDkONEQ5DuzmIUbqRV1WAnJc3DqGSvL869SAD3mHEP
X-Google-Smtp-Source: ACHHUZ5Tw/ef0/e+MEymVteq4J21oKS+teNkn1kKMsDqkVB6KnVYawdOyMRZ8eSNytXGWXPKzfObXrD24k2xrsMQkuuPZPyOltP+
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:9547:0:b0:406:35e8:51e6 with SMTP id
 y65-20020a029547000000b0040635e851e6mr7240095jah.1.1683931849937; Fri, 12 May
 2023 15:50:49 -0700 (PDT)
Date: Fri, 12 May 2023 15:50:49 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bdd6c305fb86ef53@google.com>
Subject: [syzbot] [net?] KASAN: slab-out-of-bounds Read in taprio_dequeue_from_txq
From: syzbot <syzbot+04afcb3d2c840447559a@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com, 
	jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com, 
	vinicius.gomes@intel.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    cc3c44c9fda2 Merge tag 'drm-fixes-2023-05-12' of git://ano..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1207804a280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4340592eb0a0a7c5
dashboard link: https://syzkaller.appspot.com/bug?extid=04afcb3d2c840447559a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=153c01dc280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d2c24de9e223/disk-cc3c44c9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/53f62666288b/vmlinux-cc3c44c9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5ebe93c20d75/bzImage-cc3c44c9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+04afcb3d2c840447559a@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in taprio_dequeue_from_txq+0x835/0x940 net/sched/sch_taprio.c:714
Read of size 8 at addr ffff88807b55da80 by task syz-executor.5/8955

CPU: 0 PID: 8955 Comm: syz-executor.5 Not tainted 6.4.0-rc1-syzkaller-00109-gcc3c44c9fda2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/28/2023
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
 print_report mm/kasan/report.c:462 [inline]
 kasan_report+0x11c/0x130 mm/kasan/report.c:572
 taprio_dequeue_from_txq+0x835/0x940 net/sched/sch_taprio.c:714
 taprio_dequeue_tc_priority+0x277/0x450 net/sched/sch_taprio.c:795
 taprio_dequeue+0x12c/0x5e0 net/sched/sch_taprio.c:862
 dequeue_skb net/sched/sch_generic.c:292 [inline]
 qdisc_restart net/sched/sch_generic.c:397 [inline]
 __qdisc_run+0x1b2/0x1780 net/sched/sch_generic.c:415
 __dev_xmit_skb net/core/dev.c:3868 [inline]
 __dev_queue_xmit+0x2215/0x3b10 net/core/dev.c:4210
 dev_queue_xmit include/linux/netdevice.h:3085 [inline]
 neigh_hh_output include/net/neighbour.h:528 [inline]
 neigh_output include/net/neighbour.h:542 [inline]
 ip6_finish_output2+0xfbd/0x1560 net/ipv6/ip6_output.c:134
 __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
 ip6_finish_output+0x69a/0x1170 net/ipv6/ip6_output.c:206
 NF_HOOK_COND include/linux/netfilter.h:292 [inline]
 ip6_output+0x1f1/0x540 net/ipv6/ip6_output.c:227
 dst_output include/net/dst.h:458 [inline]
 NF_HOOK include/linux/netfilter.h:303 [inline]
 ndisc_send_skb+0xa63/0x1850 net/ipv6/ndisc.c:508
 ndisc_send_rs+0x132/0x6f0 net/ipv6/ndisc.c:718
 addrconf_rs_timer+0x3f1/0x870 net/ipv6/addrconf.c:3936
 call_timer_fn+0x1a0/0x580 kernel/time/timer.c:1700
 expire_timers+0x29b/0x4b0 kernel/time/timer.c:1751
 __run_timers kernel/time/timer.c:2022 [inline]
 __run_timers kernel/time/timer.c:1995 [inline]
 run_timer_softirq+0x326/0x910 kernel/time/timer.c:2035
 __do_softirq+0x1d4/0x905 kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x114/0x190 kernel/softirq.c:650
 irq_exit_rcu+0x9/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x97/0xc0 arch/x86/kernel/apic/apic.c:1106
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:645
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x3c/0x70 kernel/locking/spinlock.c:194
Code: 74 24 10 e8 c6 6f 53 f7 48 89 ef e8 ee dd 53 f7 81 e3 00 02 00 00 75 25 9c 58 f6 c4 02 75 2d 48 85 db 74 01 fb bf 01 00 00 00 <e8> 3f b2 45 f7 65 8b 05 50 24 f2 75 85 c0 74 0a 5b 5d c3 e8 ac 6a
RSP: 0018:ffffc900063a7258 EFLAGS: 00000206
RAX: 0000000000000006 RBX: 0000000000000200 RCX: 1ffffffff22a44de
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: ffff888016b945b8 R08: 0000000000000001 R09: ffffffff9151cd0f
R10: 0000000000000001 R11: 0000000000000000 R12: 1ffff92000c74e50
R13: 0000000000000000 R14: ffff88807721f040 R15: ffff88807721f048
 spin_unlock_irqrestore include/linux/spinlock.h:405 [inline]
 ref_tracker_free+0x367/0x820 lib/ref_tracker.c:151
 netdev_tracker_free include/linux/netdevice.h:4090 [inline]
 netdev_put include/linux/netdevice.h:4107 [inline]
 netdev_put include/linux/netdevice.h:4103 [inline]
 qdisc_destroy+0x163/0x450 net/sched/sch_generic.c:1066
 qdisc_put+0xd1/0xf0 net/sched/sch_generic.c:1082
 taprio_destroy+0x2e6/0x710 net/sched/sch_taprio.c:2033
 qdisc_create+0xa33/0x1040 net/sched/sch_api.c:1331
 tc_modify_qdisc+0x488/0x1aa0 net/sched/sch_api.c:1682
 rtnetlink_rcv_msg+0x43d/0xd50 net/core/rtnetlink.c:6395
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2546
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1913
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 ____sys_sendmsg+0x71c/0x900 net/socket.c:2503
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2557
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2586
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fbfb208c169
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbfb2e55168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fbfb21abf80 RCX: 00007fbfb208c169
RDX: 0000000000000000 RSI: 00000000200007c0 RDI: 0000000000000008
RBP: 00007fbfb20e7ca1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffde123676f R14: 00007fbfb2e55300 R15: 0000000000022000
 </TASK>

Allocated by task 8955:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:374 [inline]
 ____kasan_kmalloc mm/kasan/common.c:333 [inline]
 __kasan_kmalloc+0xa3/0xb0 mm/kasan/common.c:383
 kasan_kmalloc include/linux/kasan.h:196 [inline]
 __do_kmalloc_node mm/slab_common.c:966 [inline]
 __kmalloc+0x5e/0x190 mm/slab_common.c:979
 kmalloc_array include/linux/slab.h:596 [inline]
 kcalloc include/linux/slab.h:627 [inline]
 taprio_init+0x319/0x940 net/sched/sch_taprio.c:2086
 qdisc_create+0x4d1/0x1040 net/sched/sch_api.c:1297
 tc_modify_qdisc+0x488/0x1aa0 net/sched/sch_api.c:1682
 rtnetlink_rcv_msg+0x43d/0xd50 net/core/rtnetlink.c:6395
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2546
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1913
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 ____sys_sendmsg+0x71c/0x900 net/socket.c:2503
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2557
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2586
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0x7b/0x90 mm/kasan/generic.c:491
 kvfree_call_rcu+0x70/0xad0 kernel/rcu/tree.c:3332
 kernfs_unlink_open_file+0x3a4/0x4a0 fs/kernfs/file.c:633
 kernfs_fop_release+0xeb/0x1e0 fs/kernfs/file.c:805
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x210/0x240 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Second to last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0x7b/0x90 mm/kasan/generic.c:491
 kvfree_call_rcu+0x70/0xad0 kernel/rcu/tree.c:3332
 kernfs_unlink_open_file+0x3a4/0x4a0 fs/kernfs/file.c:633
 kernfs_fop_release+0xeb/0x1e0 fs/kernfs/file.c:805
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x210/0x240 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88807b55da00
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 0 bytes to the right of
 allocated 128-byte region [ffff88807b55da00, ffff88807b55da80)

The buggy address belongs to the physical page:
page:ffffea0001ed5740 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7b55d
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0x10()
raw: 00fff00000000200 ffff888012440400 ffffea0001dccb10 ffffea0000844350
raw: 0000000000000000 ffff88807b55d000 0000000100000010 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x3420c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_COMP|__GFP_HARDWALL|__GFP_THISNODE), pid 5023, tgid 5023 (udevd), ts 303630964026, free_ts 303272122010
 set_page_owner include/linux/page_owner.h:31 [inline]
 post_alloc_hook+0x2db/0x350 mm/page_alloc.c:1731
 prep_new_page mm/page_alloc.c:1738 [inline]
 get_page_from_freelist+0xf41/0x2c00 mm/page_alloc.c:3502
 __alloc_pages+0x1cb/0x4a0 mm/page_alloc.c:4768
 __alloc_pages_node include/linux/gfp.h:237 [inline]
 kmem_getpages mm/slab.c:1360 [inline]
 cache_grow_begin+0x9b/0x3b0 mm/slab.c:2569
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2942
 ____cache_alloc mm/slab.c:3018 [inline]
 ____cache_alloc mm/slab.c:3001 [inline]
 __do_cache_alloc mm/slab.c:3201 [inline]
 slab_alloc_node mm/slab.c:3249 [inline]
 __kmem_cache_alloc_node+0x360/0x3f0 mm/slab.c:3540
 kmalloc_trace+0x26/0xe0 mm/slab_common.c:1057
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:680 [inline]
 kernfs_get_open_node fs/kernfs/file.c:572 [inline]
 kernfs_fop_open+0xaea/0xe70 fs/kernfs/file.c:740
 do_dentry_open+0x6cc/0x13f0 fs/open.c:920
 do_open fs/namei.c:3636 [inline]
 path_openat+0x1baa/0x2750 fs/namei.c:3791
 do_filp_open+0x1ba/0x410 fs/namei.c:3818
 do_sys_openat2+0x16d/0x4c0 fs/open.c:1356
 do_sys_open fs/open.c:1372 [inline]
 __do_sys_openat fs/open.c:1388 [inline]
 __se_sys_openat fs/open.c:1383 [inline]
 __x64_sys_openat+0x143/0x1f0 fs/open.c:1383
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1302 [inline]
 free_unref_page_prepare+0x62e/0xcb0 mm/page_alloc.c:2564
 free_unref_page+0x33/0x370 mm/page_alloc.c:2659
 slab_destroy mm/slab.c:1612 [inline]
 slabs_destroy+0x85/0xc0 mm/slab.c:1632
 cache_flusharray mm/slab.c:3360 [inline]
 ___cache_free+0x2ae/0x3d0 mm/slab.c:3423
 qlink_free mm/kasan/quarantine.c:166 [inline]
 qlist_free_all+0x4f/0x1a0 mm/kasan/quarantine.c:185
 kasan_quarantine_reduce+0x195/0x220 mm/kasan/quarantine.c:292
 __kasan_slab_alloc+0x63/0x90 mm/kasan/common.c:305
 kasan_slab_alloc include/linux/kasan.h:186 [inline]
 slab_post_alloc_hook mm/slab.h:711 [inline]
 slab_alloc_node mm/slab.c:3256 [inline]
 slab_alloc mm/slab.c:3265 [inline]
 __kmem_cache_alloc_lru mm/slab.c:3442 [inline]
 kmem_cache_alloc+0x1bd/0x3f0 mm/slab.c:3451
 getname_flags.part.0+0x50/0x4f0 fs/namei.c:140
 getname_flags+0x9e/0xe0 include/linux/audit.h:321
 vfs_fstatat+0x77/0xb0 fs/stat.c:275
 __do_sys_newfstatat+0x8a/0x110 fs/stat.c:446
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff88807b55d980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807b55da00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88807b55da80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff88807b55db00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88807b55db80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	24 10                	and    $0x10,%al
   2:	e8 c6 6f 53 f7       	callq  0xf7536fcd
   7:	48 89 ef             	mov    %rbp,%rdi
   a:	e8 ee dd 53 f7       	callq  0xf753ddfd
   f:	81 e3 00 02 00 00    	and    $0x200,%ebx
  15:	75 25                	jne    0x3c
  17:	9c                   	pushfq
  18:	58                   	pop    %rax
  19:	f6 c4 02             	test   $0x2,%ah
  1c:	75 2d                	jne    0x4b
  1e:	48 85 db             	test   %rbx,%rbx
  21:	74 01                	je     0x24
  23:	fb                   	sti
  24:	bf 01 00 00 00       	mov    $0x1,%edi
* 29:	e8 3f b2 45 f7       	callq  0xf745b26d <-- trapping instruction
  2e:	65 8b 05 50 24 f2 75 	mov    %gs:0x75f22450(%rip),%eax        # 0x75f22485
  35:	85 c0                	test   %eax,%eax
  37:	74 0a                	je     0x43
  39:	5b                   	pop    %rbx
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	e8                   	.byte 0xe8
  3d:	ac                   	lods   %ds:(%rsi),%al
  3e:	6a                   	.byte 0x6a


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

