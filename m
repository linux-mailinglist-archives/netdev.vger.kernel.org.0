Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182634C592A
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 04:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiB0Djv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 22:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiB0Dju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 22:39:50 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F3E249105
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 19:39:14 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id t19-20020a6b5f13000000b0064041171126so6435445iob.10
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 19:39:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=OuCDuTr2ICvJ8daWCzNDgUEKDonqGbWDQuWfTCc3ix4=;
        b=lPae7KMVdY2xYhvmzhOrr4e9706p0J5xAEeFmMokq2H70owgoGJ0GoFhBiosBgbfln
         Wd2aVXWwSb2nLf0oXhrO8PAJ5FeUsYdfci/sIJThZr++tV2wDRsj5104MvrQyn9DntFF
         xPGaiLnn1WrClQxs1UEkd+K5OpcSE/rHIGSMyvyCEKkQbSW9fDKKfwx3Vg7xAkNX2K0X
         uSrbv63i9vbuHx2VDxr84xdzrtY+a7pLsSsodJxBjeIVfJHrQT0o9mprWJ4Pr9WSvsz8
         haoFRpb3TqCc0OGyDdT4f92VDCLxri3AwZSsv1qHChFWI4ZbOXsx+XKego0KOWAp8Lnu
         hPpQ==
X-Gm-Message-State: AOAM532mylg3F8hGftpdpeFRP9P7Kwtleoc1wpQkimnOZH2mu716AQOt
        +UNLemVEMpVbUNJqzRGR/13Nj56M9mGyuljm3WzPXs/ftVyE
X-Google-Smtp-Source: ABdhPJxq6IBuqlAcvd54V15+v3nzq+W5h/QMC8ZZNuGT+jqJW5wKGzA41HXhx8/cOUrtQpT3+LenDbzxQ2EtARmyViDyB9gpwN39
MIME-Version: 1.0
X-Received: by 2002:a92:ce49:0:b0:2ba:cf5e:85fe with SMTP id
 a9-20020a92ce49000000b002bacf5e85femr12526520ilr.130.1645933154135; Sat, 26
 Feb 2022 19:39:14 -0800 (PST)
Date:   Sat, 26 Feb 2022 19:39:14 -0800
In-Reply-To: <20220227032747.2752-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f9f54805d8f7acd3@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in sco_sock_timeout
From:   syzbot <syzbot+2bef95d3ab4daa10155b@syzkaller.appspotmail.com>
To:     desmondcheongzx@gmail.com, hdanton@sina.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,FROM_FMBLA_NEWDOM,
        FROM_LOCAL_HEX,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: use-after-free Write in sco_sock_timeout

Bluetooth: hci0: command 0x0419 tx timeout
Bluetooth: hci0: command 0x0405 tx timeout
==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: use-after-free in atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:116 [inline]
BUG: KASAN: use-after-free in __refcount_add include/linux/refcount.h:193 [inline]
BUG: KASAN: use-after-free in __refcount_inc include/linux/refcount.h:250 [inline]
BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:267 [inline]
BUG: KASAN: use-after-free in sock_hold include/net/sock.h:726 [inline]
BUG: KASAN: use-after-free in sco_sock_timeout+0x64/0x290 net/bluetooth/sco.c:89
Write of size 4 at addr ffff888074aac080 by task kworker/1:2/141

CPU: 1 PID: 141 Comm: kworker/1:2 Not tainted 5.17.0-rc4-syzkaller-01424-g922ea87ff6f2-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events sco_sock_timeout
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x336 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:116 [inline]
 __refcount_add include/linux/refcount.h:193 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 sock_hold include/net/sock.h:726 [inline]
 sco_sock_timeout+0x64/0x290 net/bluetooth/sco.c:89
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Allocated by task 4058:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc include/linux/slab.h:586 [inline]
 sk_prot_alloc+0x110/0x290 net/core/sock.c:1936
 sk_alloc+0x32/0xa80 net/core/sock.c:1989
 sco_sock_alloc.constprop.0+0x31/0x330 net/bluetooth/sco.c:484
 sco_sock_create+0xd5/0x1b0 net/bluetooth/sco.c:523
 bt_sock_create+0x17c/0x340 net/bluetooth/af_bluetooth.c:130
 __sock_create+0x353/0x790 net/socket.c:1468
 sock_create net/socket.c:1519 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1561
 __do_sys_socket net/socket.c:1570 [inline]
 __se_sys_socket net/socket.c:1568 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1568
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 4059:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x126/0x160 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:236 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1754
 slab_free mm/slub.c:3509 [inline]
 kfree+0xd0/0x390 mm/slub.c:4562
 sk_prot_free net/core/sock.c:1972 [inline]
 __sk_destruct+0x6c0/0x920 net/core/sock.c:2058
 sk_destruct+0x131/0x180 net/core/sock.c:2076
 __sk_free+0xef/0x3d0 net/core/sock.c:2087
 sk_free+0x78/0xa0 net/core/sock.c:2098
 sock_put include/net/sock.h:1926 [inline]
 sco_sock_kill+0x18d/0x1b0 net/bluetooth/sco.c:403
 sco_sock_release+0x155/0x2c0 net/bluetooth/sco.c:1260
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1318
 __fput+0x286/0x9f0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 get_signal+0x1de2/0x2490 kernel/signal.c:2631
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888074aac000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
 2048-byte region [ffff888074aac000, ffff888074aac800)
The buggy address belongs to the page:
page:ffffea0001d2aa00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x74aa8
head:ffffea0001d2aa00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea000078ac00 dead000000000002 ffff888010c42000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3593, ts 45984233319, free_ts 45950800073
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4165
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2271
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x27f/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0xbe1/0x12b0 mm/slub.c:3018
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3105
 slab_alloc_node mm/slub.c:3196 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 __kmalloc+0x372/0x450 mm/slub.c:4420
 kmalloc include/linux/slab.h:586 [inline]
 kzalloc include/linux/slab.h:715 [inline]
 __register_sysctl_table+0x112/0x1090 fs/proc/proc_sysctl.c:1335
 __devinet_sysctl_register+0x156/0x280 net/ipv4/devinet.c:2588
 devinet_sysctl_register net/ipv4/devinet.c:2628 [inline]
 devinet_sysctl_register+0x160/0x230 net/ipv4/devinet.c:2618
 inetdev_init+0x286/0x580 net/ipv4/devinet.c:279
 inetdev_event+0xa8a/0x15d0 net/ipv4/devinet.c:1536
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:84
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1939
 call_netdevice_notifiers_extack net/core/dev.c:1951 [inline]
 call_netdevice_notifiers net/core/dev.c:1965 [inline]
 register_netdevice+0x1102/0x15a0 net/core/dev.c:9696
 veth_newlink+0x59c/0xa90 drivers/net/veth.c:1725
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1352 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1404
 free_unref_page_prepare mm/page_alloc.c:3325 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3404
 __unfreeze_partials+0x320/0x340 mm/slub.c:2536
 qlink_free mm/kasan/quarantine.c:157 [inline]
 qlist_free_all+0x6d/0x160 mm/kasan/quarantine.c:176
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:283
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:446
 kasan_slab_alloc include/linux/kasan.h:260 [inline]
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc_node mm/slub.c:3230 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 kmem_cache_alloc_trace+0x258/0x3d0 mm/slub.c:3255
 kmalloc include/linux/slab.h:581 [inline]
 kzalloc include/linux/slab.h:715 [inline]
 ref_tracker_alloc+0x14c/0x550 lib/ref_tracker.c:85
 __netdev_tracker_alloc include/linux/netdevice.h:3860 [inline]
 dev_hold_track include/linux/netdevice.h:3889 [inline]
 dev_hold_track include/linux/netdevice.h:3884 [inline]
 netdev_queue_add_kobject net/core/net-sysfs.c:1650 [inline]
 netdev_queue_update_kobjects+0x1a7/0x4e0 net/core/net-sysfs.c:1705
 register_queue_kobjects net/core/net-sysfs.c:1766 [inline]
 netdev_register_kobject+0x35a/0x430 net/core/net-sysfs.c:2012
 register_netdevice+0xd9d/0x15a0 net/core/dev.c:9663
 veth_newlink+0x405/0xa90 drivers/net/veth.c:1694
 __rtnl_newlink+0x107c/0x1760 net/core/rtnetlink.c:3483
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3531
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5598
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494

Memory state around the buggy address:
 ffff888074aabf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888074aac000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888074aac080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888074aac100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888074aac180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         922ea87f ionic: use vmalloc include
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
console output: https://syzkaller.appspot.com/x/log.txt?x=118926a2700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d63ad23bb09039e8
dashboard link: https://syzkaller.appspot.com/bug?extid=2bef95d3ab4daa10155b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=130215b6700000

