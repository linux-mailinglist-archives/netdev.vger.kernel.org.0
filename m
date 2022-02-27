Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8487C4C5902
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 04:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiB0DHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 22:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiB0DHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 22:07:46 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F49205E14
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 19:07:09 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id b22-20020a6b6716000000b0064070ce7b49so6428565ioc.5
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 19:07:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ZI/TnczTGZWx16MyuOAAaApciMqhDhuv/qpLMCRtkkw=;
        b=vFnermW9EWm8GWosX9bCCmh6ECiVF21+I6mh3kpnPhhqZfTUye6Kuh6f+c4mzd+B+n
         1iLom4QOVI8qGaVYYOXL/gVO771D0VNghyNSziHJY0jdlbOqHXAKKeFh2i7J/k2Prl7j
         slI/zK5vxOUFdC3NdOi6lHpMZ6IGcc8Eck+gbH0LrDHtLxeGlO309gUsD9cOt3aYVrx8
         XEe8Kje2iCArYPQCfc1OIsBZNH9yq8MepNmI9fPjHVnkdWYeIF/HhHYHBIf4GCoTsmwN
         IgAdRqE1BsJC4FFXU+8fSjzKhAEPKDnBuHVFyokmjI5OcuE5PmjsfP2k1mNxKn+khG/b
         B9WQ==
X-Gm-Message-State: AOAM531ZnEDVs+344u21gGbGcKMbE7cuYCHJc8bBWEEI/HUWNLh5HxiJ
        YBnZcn2CuT35/3flrSuFHpPmPOltldOEqLEDhXnA4RapmooS
X-Google-Smtp-Source: ABdhPJwt01IVL5GbiuyiTNu4eC1wB8l4dV9Itk1gHvNeHEVLAVNAWFc2P16f0cqB7Lx4AYVIkA/nYSR2p0mnjbDyYlBV/e2AyFDS
MIME-Version: 1.0
X-Received: by 2002:a6b:6b19:0:b0:640:a354:69ef with SMTP id
 g25-20020a6b6b19000000b00640a35469efmr10882071ioc.186.1645931228468; Sat, 26
 Feb 2022 19:07:08 -0800 (PST)
Date:   Sat, 26 Feb 2022 19:07:08 -0800
In-Reply-To: <20220227025605.2681-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003298d505d8f73af1@google.com>
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

Bluetooth: hci0: command 0x040f tx timeout
Bluetooth: hci0: command 0x0405 tx timeout
==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: use-after-free in atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:116 [inline]
BUG: KASAN: use-after-free in __refcount_add include/linux/refcount.h:193 [inline]
BUG: KASAN: use-after-free in __refcount_inc include/linux/refcount.h:250 [inline]
BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:267 [inline]
BUG: KASAN: use-after-free in sock_hold include/net/sock.h:726 [inline]
BUG: KASAN: use-after-free in sco_sock_timeout+0x64/0x290 net/bluetooth/sco.c:89
Write of size 4 at addr ffff888021031080 by task kworker/0:3/1132

CPU: 0 PID: 1132 Comm: kworker/0:3 Not tainted 5.17.0-rc4-syzkaller-01424-g922ea87ff6f2-dirty #0
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
 sco_sock_alloc.constprop.0+0x31/0x330 net/bluetooth/sco.c:488
 sco_sock_create+0xd5/0x1b0 net/bluetooth/sco.c:527
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

Freed by task 4058:
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
 sco_sock_release+0x197/0x310 net/bluetooth/sco.c:1264
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

The buggy address belongs to the object at ffff888021031000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
 2048-byte region [ffff888021031000, ffff888021031800)
The buggy address belongs to the page:
page:ffffea0000840c00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x21030
head:ffffea0000840c00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010c42000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd28c0(GFP_NOWAIT|__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3595, ts 45073525139, free_ts 36261730425
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
 __kmalloc_node_track_caller+0x339/0x470 mm/slub.c:4957
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 pskb_expand_head+0x15e/0x1060 net/core/skbuff.c:1699
 netlink_trim+0x1ea/0x240 net/netlink/af_netlink.c:1299
 netlink_broadcast+0x5b/0xd50 net/netlink/af_netlink.c:1495
 nlmsg_multicast include/net/netlink.h:1033 [inline]
 nlmsg_notify+0x8f/0x280 net/netlink/af_netlink.c:2537
 rtnl_notify net/core/rtnetlink.c:730 [inline]
 rtmsg_ifinfo_send net/core/rtnetlink.c:3857 [inline]
 rtmsg_ifinfo_event net/core/rtnetlink.c:3872 [inline]
 rtmsg_ifinfo_event net/core/rtnetlink.c:3860 [inline]
 rtnetlink_event+0x193/0x1d0 net/core/rtnetlink.c:5649
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:84
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1939
 __netdev_upper_dev_link+0x3fd/0x7f0 net/core/dev.c:7483
 netdev_upper_dev_link+0x8a/0xc0 net/core/dev.c:7524
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1352 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1404
 free_unref_page_prepare mm/page_alloc.c:3325 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3404
 __put_page+0x193/0x1e0 mm/swap.c:128
 folio_put include/linux/mm.h:1199 [inline]
 put_page include/linux/mm.h:1237 [inline]
 __skb_frag_unref include/linux/skbuff.h:3249 [inline]
 skb_release_data+0x49d/0x790 net/core/skbuff.c:672
 skb_release_all net/core/skbuff.c:742 [inline]
 __kfree_skb+0x46/0x60 net/core/skbuff.c:756
 __sk_defer_free_flush net/ipv4/tcp.c:1600 [inline]
 sk_defer_free_flush include/net/tcp.h:1380 [inline]
 tcp_recvmsg+0x1ca/0x610 net/ipv4/tcp.c:2574
 inet_recvmsg+0x11b/0x5e0 net/ipv4/af_inet.c:850
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 sock_read_iter+0x33c/0x470 net/socket.c:1039
 call_read_iter include/linux/fs.h:2068 [inline]
 new_sync_read+0x5c2/0x6e0 fs/read_write.c:400
 vfs_read+0x35c/0x600 fs/read_write.c:481
 ksys_read+0x1ee/0x250 fs/read_write.c:619
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff888021030f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888021031000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888021031080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888021031100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888021031180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         922ea87f ionic: use vmalloc include
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
console output: https://syzkaller.appspot.com/x/log.txt?x=152f4b46700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d63ad23bb09039e8
dashboard link: https://syzkaller.appspot.com/bug?extid=2bef95d3ab4daa10155b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=170926a2700000

