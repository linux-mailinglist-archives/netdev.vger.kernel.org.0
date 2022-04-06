Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60A94F620D
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 16:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbiDFOuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 10:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbiDFOtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 10:49:52 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C9D551710
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 04:22:20 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id u10-20020a5ec00a000000b00648e5804d5bso1373051iol.12
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 04:22:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=x/qCC5+GnyyLeCkaTSkIm+5IHRWqVhEnulX7wsb3R+s=;
        b=6nbUhrRlAyJDPnuuecmNTrHYZr8AUI5PMiSVW6kV2FaoTikY+9BNfvXs6nYhXlTeXw
         ewXryNclLght/WbwCTYesMF+sUQLayz2NFg5hKjzVudY7hnfrOpwFV5Ru83lj0RKxolB
         ZgvcBJvklzPKbB3QoW28i70wkid1ssxrbpikyAYh+IpRVOvIQHOIsd82L2rn/rdJSM1+
         w6un83+4jKHYZaiWl9hUt5H20CxPdhuqEkFgR+Op6A3n+91JyswF/AuKvLd8VX/VdhtO
         tDm9rpuzQLG8oeu8BSFOkyv7Y5rBdK/GuDX0SoWIvY2/dbqoubky6lQG9ebmAHoRjSDy
         qxVQ==
X-Gm-Message-State: AOAM532+mD2+oFV5ZoK135ZKmQaSqtJkD9p3OItwk4goIlit1HxvlYW0
        qDEuk/Ojbj+GY8JYegMqumsnf0Hx2sHpGAYIIXYpjKhVowjH
X-Google-Smtp-Source: ABdhPJzj01h04gRkIODqbzmwsP6tQaN4+z9UGiYxaaRQ7MvWp+2B4T+8VtftPgASYjdUxwid9b0x23+N3WTd4zr1EYSUwGGMzXQ6
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1685:b0:2c9:a9e9:846 with SMTP id
 f5-20020a056e02168500b002c9a9e90846mr4114782ila.273.1649244139757; Wed, 06
 Apr 2022 04:22:19 -0700 (PDT)
Date:   Wed, 06 Apr 2022 04:22:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000019260105dbfa9337@google.com>
Subject: [syzbot] KASAN: use-after-free Read in cdc_ncm_set_dgram_size
From:   syzbot <syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        oliver@neukum.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    787af64d05cd mm: page_alloc: validate buddy before check i..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16b1ebf5700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=84cc605575ae78ef
dashboard link: https://syzkaller.appspot.com/bug?extid=eabbf2aaa999cc507108
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in cdc_ncm_set_dgram_size+0xc91/0xde0 drivers/net/usb/cdc_ncm.c:608
Read of size 8 at addr ffff8880755210b0 by task dhcpcd/3174

CPU: 0 PID: 3174 Comm: dhcpcd Tainted: G        W         5.17.0-syzkaller-13430-g787af64d05cd #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 cdc_ncm_set_dgram_size+0xc91/0xde0 drivers/net/usb/cdc_ncm.c:608
 cdc_ncm_change_mtu+0x10c/0x140 drivers/net/usb/cdc_ncm.c:798
 __dev_set_mtu net/core/dev.c:8519 [inline]
 dev_set_mtu_ext+0x352/0x5b0 net/core/dev.c:8572
 dev_set_mtu+0x8e/0x120 net/core/dev.c:8596
 dev_ifsioc+0xb87/0x1090 net/core/dev_ioctl.c:332
 dev_ioctl+0x1b9/0xe30 net/core/dev_ioctl.c:586
 sock_do_ioctl+0x15a/0x230 net/socket.c:1136
 sock_ioctl+0x2f1/0x640 net/socket.c:1239
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f00859e70e7
Code: 3c 1c e8 1c ff ff ff 85 c0 79 87 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 61 9d 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffedd503dd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f00858f96c8 RCX: 00007f00859e70e7
RDX: 00007ffedd513fc8 RSI: 0000000000008922 RDI: 0000000000000018
RBP: 00007ffedd524178 R08: 00007ffedd513f88 R09: 00007ffedd513f38
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffedd513fc8 R14: 0000000000000028 R15: 0000000000008922
 </TASK>

Allocated by task 26:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc include/linux/slab.h:581 [inline]
 kzalloc include/linux/slab.h:714 [inline]
 cdc_ncm_bind_common+0xb8/0x2df0 drivers/net/usb/cdc_ncm.c:826
 cdc_ncm_bind+0x7c/0x1c0 drivers/net/usb/cdc_ncm.c:1069
 usbnet_probe+0xaf8/0x2580 drivers/net/usb/usbnet.c:1747
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:541 [inline]
 really_probe+0x23e/0xb20 drivers/base/dd.c:620
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:751
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:781
 __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:898
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x228/0x4a0 drivers/base/dd.c:969
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xb83/0x1e20 drivers/base/core.c:3405
 usb_set_configuration+0x101e/0x1900 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
 call_driver_probe drivers/base/dd.c:541 [inline]
 really_probe+0x23e/0xb20 drivers/base/dd.c:620
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:751
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:781
 __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:898
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x228/0x4a0 drivers/base/dd.c:969
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xb83/0x1e20 drivers/base/core.c:3405
 usb_new_device.cold+0x641/0x1091 drivers/usb/core/hub.c:2566
 hub_port_connect drivers/usb/core/hub.c:5363 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5507 [inline]
 port_event drivers/usb/core/hub.c:5665 [inline]
 hub_event+0x25c6/0x4680 drivers/usb/core/hub.c:5747
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

Freed by task 3742:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x166/0x1a0 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1754
 slab_free mm/slub.c:3510 [inline]
 kfree+0xd6/0x4d0 mm/slub.c:4552
 cdc_ncm_free+0x145/0x1a0 drivers/net/usb/cdc_ncm.c:786
 cdc_ncm_unbind+0x1a7/0x340 drivers/net/usb/cdc_ncm.c:1021
 usbnet_disconnect+0x103/0x270 drivers/net/usb/usbnet.c:1620
 usb_unbind_interface+0x1d8/0x8e0 drivers/usb/core/driver.c:458
 device_remove drivers/base/dd.c:531 [inline]
 device_remove+0x11f/0x170 drivers/base/dd.c:523
 __device_release_driver drivers/base/dd.c:1199 [inline]
 device_release_driver_internal+0x4a3/0x680 drivers/base/dd.c:1222
 bus_remove_device+0x2eb/0x5a0 drivers/base/bus.c:529
 device_del+0x4f3/0xc80 drivers/base/core.c:3592
 usb_disable_device+0x35b/0x7b0 drivers/usb/core/message.c:1419
 usb_disconnect.cold+0x278/0x6ec drivers/usb/core/hub.c:2228
 hub_port_connect drivers/usb/core/hub.c:5207 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5507 [inline]
 port_event drivers/usb/core/hub.c:5665 [inline]
 hub_event+0x1e74/0x4680 drivers/usb/core/hub.c:5747
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

The buggy address belongs to the object at ffff888075521000
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 176 bytes inside of
 512-byte region [ffff888075521000, ffff888075521200)

The buggy address belongs to the physical page:
page:ffffea0001d54800 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888075522800 pfn:0x75520
head:ffffea0001d54800 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea0001f37f08 ffffea0001d16d08 ffff888010c41c80
raw: ffff888075522800 0000000000100007 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd2a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 21, tgid 21 (ksoftirqd/1), ts 65372771303, free_ts 55099250438
 prep_new_page mm/page_alloc.c:2441 [inline]
 get_page_from_freelist+0xba2/0x3df0 mm/page_alloc.c:4182
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5408
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2262
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x26c/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0x8df/0xf20 mm/slub.c:3005
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3092
 slab_alloc_node mm/slub.c:3183 [inline]
 __kmalloc_node_track_caller+0x2cb/0x360 mm/slub.c:4947
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0xde/0x340 net/core/skbuff.c:426
 __napi_alloc_skb+0x70/0x310 net/core/skbuff.c:568
 napi_alloc_skb include/linux/skbuff.h:3157 [inline]
 page_to_skb+0x188/0xc00 drivers/net/virtio_net.c:437
 receive_mergeable drivers/net/virtio_net.c:1039 [inline]
 receive_buf+0xd24/0x5210 drivers/net/virtio_net.c:1149
 virtnet_receive drivers/net/virtio_net.c:1441 [inline]
 virtnet_poll+0x5cd/0x11a0 drivers/net/virtio_net.c:1550
 __napi_poll+0xb3/0x6e0 net/core/dev.c:6413
 napi_poll net/core/dev.c:6480 [inline]
 net_rx_action+0x8ec/0xc60 net/core/dev.c:6567
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1356 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1406
 free_unref_page_prepare mm/page_alloc.c:3328 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3423
 __put_page+0x17d/0x280 mm/swap.c:127
 folio_put include/linux/mm.h:1200 [inline]
 put_page include/linux/mm.h:1233 [inline]
 __skb_frag_unref include/linux/skbuff.h:3330 [inline]
 skb_release_data+0x513/0x810 net/core/skbuff.c:672
 skb_release_all net/core/skbuff.c:742 [inline]
 __kfree_skb+0x46/0x60 net/core/skbuff.c:756
 __sk_defer_free_flush net/ipv4/tcp.c:1601 [inline]
 sk_defer_free_flush include/net/tcp.h:1380 [inline]
 tcp_recvmsg+0x1ca/0x610 net/ipv4/tcp.c:2577
 inet_recvmsg+0x11b/0x5e0 net/ipv4/af_inet.c:850
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 sock_read_iter+0x336/0x470 net/socket.c:1039
 call_read_iter include/linux/fs.h:2073 [inline]
 new_sync_read+0x4f9/0x5f0 fs/read_write.c:401
 vfs_read+0x492/0x5d0 fs/read_write.c:482
 ksys_read+0x1e8/0x250 fs/read_write.c:620
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff888075520f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888075521000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888075521080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff888075521100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888075521180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
