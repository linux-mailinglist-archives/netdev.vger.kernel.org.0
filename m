Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0634850F0BF
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244979AbiDZGNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 02:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244899AbiDZGNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 02:13:38 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC40213CC9
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 23:10:29 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id g16-20020a05660226d000b00638d8e1828bso12992692ioo.13
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 23:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ZWHhaIrivc1f6vDpT+SHzqKXoDWupxSOGEWylDRsX7Q=;
        b=K3UQjLuQERaJHEVM8ea51UHtVZROhqlW6NXU4lZtz8OSNy05kJXTtoC02PpEo93tdk
         o+JlFE2MQQjD0tIYClCfUCRJT1rEp376Vgs5JmrMYr8z+8aulYmO8ZIXhVBrGWRpLedL
         8HX1Lv1Y0QkeSq2v8IITt+WZGYIy7JgtfvgHHxChIDMTU4ob+2kSAxMl12/DLyUjcu4D
         EPV21PsEACZgw49u1nkVJ6vL7SRSgb1+tTcjVHevWRug0g+ONwmD++wYCZ21cKI6i1La
         GAelabTgTF7DBRMMvG2zDrXi+zq2TjY5F8hsJun1h52ek8gaTg50dVDguRdZtJKDp7k4
         KJPA==
X-Gm-Message-State: AOAM530jbZDI/tTzJPBGjtz4ennRHiC/qWM8ogVlZJYm0K6YGwgaoJTq
        SYS9ymY2mP4eDVDYa5olofe0NQ0MfAXkyoyUfiTd0XBWY48S
X-Google-Smtp-Source: ABdhPJxd4OhW5fJ9D/zeNIYqKBHidukRcTLTJlXh4AJZatacN8jqFFaP3aGDIhew5KTWYUpya7vod1R9P41JSVOatAs9qGrgjTEs
MIME-Version: 1.0
X-Received: by 2002:a92:d01:0:b0:2c5:daa4:77e0 with SMTP id
 1-20020a920d01000000b002c5daa477e0mr8674069iln.154.1650953429038; Mon, 25 Apr
 2022 23:10:29 -0700 (PDT)
Date:   Mon, 25 Apr 2022 23:10:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000adbca705dd888c1d@google.com>
Subject: [syzbot] KASAN: use-after-free Read in ieee80211_scan_rx (3)
From:   syzbot <syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    af2d861d4cd2 Linux 5.18-rc4
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13bf73b2f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4071c85377b36266
dashboard link: https://syzkaller.appspot.com/bug?extid=f9acff9bf08a845f225d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in ieee80211_scan_rx+0x7d0/0x7e0 net/mac80211/scan.c:293
Read of size 4 at addr ffff888025e7f02c by task ksoftirqd/2/28

CPU: 2 PID: 28 Comm: ksoftirqd/2 Not tainted 5.18.0-rc4-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x467 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 ieee80211_scan_rx+0x7d0/0x7e0 net/mac80211/scan.c:293
 __ieee80211_rx_handle_packet net/mac80211/rx.c:4782 [inline]
 ieee80211_rx_list+0x1fe3/0x2740 net/mac80211/rx.c:4975
 ieee80211_rx_napi+0xdb/0x3d0 net/mac80211/rx.c:4998
 ieee80211_rx include/net/mac80211.h:4611 [inline]
 ieee80211_tasklet_handler+0xd4/0x130 net/mac80211/main.c:235
 tasklet_action_common.constprop.0+0x201/0x2e0 kernel/softirq.c:784
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:913
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>

Allocated by task 12352:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa6/0xd0 mm/kasan/common.c:524
 kasan_kmalloc include/linux/kasan.h:234 [inline]
 kmem_cache_alloc_trace+0x1ea/0x4a0 mm/slab.c:3583
 kmalloc include/linux/slab.h:581 [inline]
 sl_alloc_bufs drivers/net/slip/slip.c:157 [inline]
 slip_open+0x9e3/0x11b0 drivers/net/slip/slip.c:827
 tty_ldisc_open+0x9b/0x110 drivers/tty/tty_ldisc.c:433
 tty_set_ldisc+0x2f1/0x680 drivers/tty/tty_ldisc.c:558
 tiocsetd drivers/tty/tty_io.c:2433 [inline]
 tty_ioctl+0xae0/0x15e0 drivers/tty/tty_io.c:2714
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0x7e/0x90 mm/kasan/generic.c:348
 kvfree_call_rcu+0x74/0x990 kernel/rcu/tree.c:3595
 drop_sysctl_table+0x3c0/0x4e0 fs/proc/proc_sysctl.c:1705
 unregister_sysctl_table fs/proc/proc_sysctl.c:1743 [inline]
 unregister_sysctl_table+0xc0/0x190 fs/proc/proc_sysctl.c:1718
 sctp_sysctl_net_unregister+0x58/0x80 net/sctp/sysctl.c:602
 ops_exit_list+0xb0/0x170 net/core/net_namespace.c:162
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:594
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

Second to last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0x7e/0x90 mm/kasan/generic.c:348
 kvfree_call_rcu+0x74/0x990 kernel/rcu/tree.c:3595
 drop_sysctl_table+0x3c0/0x4e0 fs/proc/proc_sysctl.c:1705
 unregister_sysctl_table fs/proc/proc_sysctl.c:1743 [inline]
 unregister_sysctl_table+0xc0/0x190 fs/proc/proc_sysctl.c:1718
 __devinet_sysctl_unregister net/ipv4/devinet.c:2611 [inline]
 devinet_sysctl_unregister net/ipv4/devinet.c:2639 [inline]
 inetdev_destroy net/ipv4/devinet.c:327 [inline]
 inetdev_event+0xcaf/0x15d0 net/ipv4/devinet.c:1604
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:84
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1938
 call_netdevice_notifiers_extack net/core/dev.c:1976 [inline]
 call_netdevice_notifiers net/core/dev.c:1990 [inline]
 unregister_netdevice_many+0x92e/0x1890 net/core/dev.c:10751
 ip_tunnel_delete_nets+0x39f/0x5b0 net/ipv4/ip_tunnel.c:1124
 ops_exit_list+0x125/0x170 net/core/net_namespace.c:167
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:594
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

The buggy address belongs to the object at ffff888025e7f000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 44 bytes inside of
 2048-byte region [ffff888025e7f000, ffff888025e7f800)

The buggy address belongs to the physical page:
page:ffffea0000979fc0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x25e7f
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea00008aaa88 ffffea000081d988 ffff888010c40800
raw: 0000000000000000 ffff888025e7f000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2420c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_COMP|__GFP_THISNODE), pid 28931, tgid 28930 (syz-executor.2), ts 858983317706, free_ts 817324026609
 prep_new_page mm/page_alloc.c:2441 [inline]
 get_page_from_freelist+0xba2/0x3e00 mm/page_alloc.c:4182
 __alloc_pages_slowpath.constprop.0+0x2eb/0x20e0 mm/page_alloc.c:4953
 __alloc_pages+0x412/0x500 mm/page_alloc.c:5421
 __alloc_pages_node include/linux/gfp.h:587 [inline]
 kmem_getpages mm/slab.c:1378 [inline]
 cache_grow_begin+0x75/0x350 mm/slab.c:2584
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2957
 ____cache_alloc mm/slab.c:3040 [inline]
 ____cache_alloc mm/slab.c:3023 [inline]
 __do_cache_alloc mm/slab.c:3267 [inline]
 slab_alloc mm/slab.c:3309 [inline]
 __do_kmalloc mm/slab.c:3708 [inline]
 __kmalloc+0x3b3/0x4d0 mm/slab.c:3719
 kmalloc include/linux/slab.h:586 [inline]
 kzalloc include/linux/slab.h:714 [inline]
 __register_sysctl_table+0x112/0x1090 fs/proc/proc_sysctl.c:1335
 __devinet_sysctl_register+0x156/0x280 net/ipv4/devinet.c:2588
 devinet_sysctl_register net/ipv4/devinet.c:2628 [inline]
 devinet_sysctl_register+0x160/0x230 net/ipv4/devinet.c:2618
 inetdev_init+0x286/0x580 net/ipv4/devinet.c:279
 inetdev_event+0xa8a/0x15d0 net/ipv4/devinet.c:1536
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:84
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1938
 call_netdevice_notifiers_extack net/core/dev.c:1976 [inline]
 call_netdevice_notifiers net/core/dev.c:1990 [inline]
 register_netdevice+0x109e/0x15b0 net/core/dev.c:9994
 __ip_tunnel_create+0x398/0x5c0 net/ipv4/ip_tunnel.c:267
 ip_tunnel_init_net+0x2e4/0x9d0 net/ipv4/ip_tunnel.c:1071
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1356 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1406
 free_unref_page_prepare mm/page_alloc.c:3328 [inline]
 free_unref_page+0x19/0x6a0 mm/page_alloc.c:3423
 slab_destroy mm/slab.c:1630 [inline]
 drain_freelist.isra.0+0xc6/0x130 mm/slab.c:2222
 cache_reap+0x1ba/0x290 mm/slab.c:4041
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

Memory state around the buggy address:
 ffff888025e7ef00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888025e7ef80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888025e7f000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                                  ^
 ffff888025e7f080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888025e7f100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
