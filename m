Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF409148CB
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 13:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEFLQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 07:16:34 -0400
Received: from mail-it1-f197.google.com ([209.85.166.197]:50274 "EHLO
        mail-it1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfEFLQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 07:16:07 -0400
Received: by mail-it1-f197.google.com with SMTP id k8so11033767itd.0
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 04:16:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=BN9kMr6VZQzhqffxvPGpBVCV4wBfOVi6hr2TY26skHA=;
        b=Ut2UkORFaS5zAnYWvGCCTwHrhumreMoaCX6rcy5E75MnQhOZwaOUqSLalaQD8G9anE
         0bht3riNk0a378Tdp7YsNAsSPGqd4NSed1KJuzxRavlOlhnUJZ0lgwfzQtGOyQ7/tiJY
         J5qA4wifekwQRAsbE5Sq5Noey6/P1LqIklGCK3PZtOrDyk7L4qAOrN2vmLU+z+PlKX5e
         PWKeVz3rJZ3NzafN0tINdvPlCPiDWkSxm/x4KSP7w4xmMTt/onzSjxpJpgPONuFSFUHI
         0JM1zIorOLa6In1KGYUTaeHtySYOjFpuVVDhHkIP959R4Krllk1eZTBrIGp1gye5oClN
         ZWGA==
X-Gm-Message-State: APjAAAXfRp2H8DIr3U3Cr76fmZsGukPK3V1Hn8BSj2Hp81kEzgk7q/9M
        /7TT9RofmxpN+4pYuL6R/PMANTq9C81q0h+DWpGFE1vuztL/
X-Google-Smtp-Source: APXvYqwH7JIUqnnfwXRVpaboE17nKjPnok0C1QhbL3fT4ZnqNAOx/7oJEKcTnzHpuJcUaTseJzHM4uzXDo3ZluJWDJEumSHbmy+i
MIME-Version: 1.0
X-Received: by 2002:a5e:920a:: with SMTP id y10mr12746024iop.115.1557141366362;
 Mon, 06 May 2019 04:16:06 -0700 (PDT)
Date:   Mon, 06 May 2019 04:16:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000001de810588363aaf@google.com>
Subject: KASAN: slab-out-of-bounds Read in p54u_load_firmware_cb
From:   syzbot <syzbot+6d237e74cdc13f036473@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, chunkeey@googlemail.com,
        davem@davemloft.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    43151d6c usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=12c0112ca00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4183eeef650d1234
dashboard link: https://syzkaller.appspot.com/bug?extid=6d237e74cdc13f036473
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6d237e74cdc13f036473@syzkaller.appspotmail.com

cx231xx 2-1:0.1: New device   @ 480 Mbps (2040:b111) with 1 interfaces
cx231xx 2-1:0.1: Not found matching IAD interface
usb 6-1: Direct firmware load for isl3887usb failed with error -2
usb 6-1: Firmware not found.
==================================================================
BUG: KASAN: slab-out-of-bounds in p54u_load_firmware_cb.cold+0x97/0x13a  
drivers/net/wireless/intersil/p54/p54usb.c:936
Read of size 8 at addr ffff888099763588 by task kworker/0:1/12

CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.1.0-rc3-319004-g43151d6 #6
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events request_firmware_work_func
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xe8/0x16e lib/dump_stack.c:113
  print_address_description+0x6c/0x236 mm/kasan/report.c:187
  kasan_report.cold+0x1a/0x3c mm/kasan/report.c:317
  p54u_load_firmware_cb.cold+0x97/0x13a  
drivers/net/wireless/intersil/p54/p54usb.c:936
  request_firmware_work_func+0x12d/0x249  
drivers/base/firmware_loader/main.c:785
  process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
  worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
  kthread+0x313/0x420 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Allocated by task 7931:
  set_track mm/kasan/common.c:87 [inline]
  __kasan_kmalloc mm/kasan/common.c:497 [inline]
  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:470
  slab_post_alloc_hook mm/slab.h:437 [inline]
  slab_alloc_node mm/slub.c:2756 [inline]
  __kmalloc_node_track_caller+0xf3/0x320 mm/slub.c:4372
  __kmalloc_reserve.isra.0+0x3e/0xf0 net/core/skbuff.c:140
  __alloc_skb+0xf4/0x5a0 net/core/skbuff.c:208
  alloc_skb include/linux/skbuff.h:1058 [inline]
  alloc_uevent_skb+0x7b/0x210 lib/kobject_uevent.c:289
  uevent_net_broadcast_untagged lib/kobject_uevent.c:325 [inline]
  kobject_uevent_net_broadcast lib/kobject_uevent.c:408 [inline]
  kobject_uevent_env+0x865/0x13d0 lib/kobject_uevent.c:589
  udc_bind_to_driver+0x33e/0x5e0 drivers/usb/gadget/udc/core.c:1357
  usb_gadget_probe_driver+0x23f/0x380 drivers/usb/gadget/udc/core.c:1408
  fuzzer_ioctl_run drivers/usb/gadget/fuzzer/fuzzer.c:718 [inline]
  fuzzer_ioctl+0x15be/0x1d90 drivers/usb/gadget/fuzzer/fuzzer.c:1130
  full_proxy_unlocked_ioctl+0x11b/0x180 fs/debugfs/file.c:205
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xced/0x12f0 fs/ioctl.c:696
  ksys_ioctl+0xa0/0xc0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x74/0xb0 fs/ioctl.c:718
  do_syscall_64+0xcf/0x4f0 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 805:
  set_track mm/kasan/common.c:87 [inline]
  __kasan_slab_free+0x130/0x180 mm/kasan/common.c:459
  slab_free_hook mm/slub.c:1429 [inline]
  slab_free_freelist_hook+0x5e/0x140 mm/slub.c:1456
  slab_free mm/slub.c:3003 [inline]
  kfree+0xce/0x290 mm/slub.c:3958
  skb_free_head+0x90/0xb0 net/core/skbuff.c:557
  skb_release_data+0x543/0x8b0 net/core/skbuff.c:577
  skb_release_all+0x4b/0x60 net/core/skbuff.c:631
  __kfree_skb net/core/skbuff.c:645 [inline]
  consume_skb net/core/skbuff.c:705 [inline]
  consume_skb+0xc5/0x2f0 net/core/skbuff.c:699
  skb_free_datagram+0x1b/0xf0 net/core/datagram.c:329
  netlink_recvmsg+0x663/0xea0 net/netlink/af_netlink.c:2004
  sock_recvmsg_nosec net/socket.c:881 [inline]
  sock_recvmsg net/socket.c:888 [inline]
  sock_recvmsg+0xd1/0x110 net/socket.c:884
  ___sys_recvmsg+0x278/0x5a0 net/socket.c:2422
  __sys_recvmsg+0xee/0x1b0 net/socket.c:2471
  do_syscall_64+0xcf/0x4f0 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888099763180
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 8 bytes to the right of
  1024-byte region [ffff888099763180, ffff888099763580)
The buggy address belongs to the page:
page:ffffea000265d800 count:1 mapcount:0 mapping:ffff88812c3f4a00 index:0x0  
compound_mapcount: 0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000200 ffff88812c3f4a00
raw: 0000000000000000 00000000000e000e 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888099763480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888099763500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff888099763580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                       ^
  ffff888099763600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888099763680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
