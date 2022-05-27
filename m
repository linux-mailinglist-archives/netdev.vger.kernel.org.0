Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2A1535AE9
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 10:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235258AbiE0IDX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 27 May 2022 04:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiE0IDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 04:03:21 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A7943EDE
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 01:03:20 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id x8-20020a056e021ca800b002d1332831deso2606632ill.23
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 01:03:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to
         :content-transfer-encoding;
        bh=qNRiG9ste6GJBHJOyzzCKOGL82ROVbE9MAhjwH6wM/Y=;
        b=z9PF6P+Tf/lTg8ozZZBYDqdpbgVe6yv2zK+Nv7bkfcLcxyU05ZMJe1Qf0nY4jkUeBE
         +lsWMGxl8RuzNxiNSwcTa/mByyMBcKBif4VDI5tyrMHQs1rY1W0M146S+SwCoIOWwO1R
         KU7eXpzgRg/pGki+1L5ONFIIcThRq5Gbi0YIX0iX8MRiPFNXW862wC/hwFB6kUbTuRL/
         EbVUc8J+VEJ/oL4pukRYll3Q84bRovs8PAQXu9hQTPzifZdl8OMUDpY64XbN0lJcMVe6
         Z2530aYwT/tlyv84Vx9SEK24YmwIKXZ4GbcpP0uzOD3wnhnICj9cxO7kcqYmVr4bVUkt
         v+EA==
X-Gm-Message-State: AOAM531K7sXpxOtjmJwlkOfVUVpWrUrm2JIiUWuc3r4wrrVpgu8BhMln
        may1GTeSTrXiL/N1SGZoon33IdmW8MoGx4n/San2fW/Mv+Ia
X-Google-Smtp-Source: ABdhPJwtXSZmLMVl61D0dFcFNjIUwk2uU7D7muhG6IaH0ssyItmT+9aOUipNnjZekT7yDtHoqqo07leCASZjf7ahHc4bAWUEXLUw
MIME-Version: 1.0
X-Received: by 2002:a6b:3ec1:0:b0:65a:499f:23a4 with SMTP id
 l184-20020a6b3ec1000000b0065a499f23a4mr18180016ioa.189.1653638600142; Fri, 27
 May 2022 01:03:20 -0700 (PDT)
Date:   Fri, 27 May 2022 01:03:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000593d7c05dff9bd77@google.com>
Subject: [syzbot] KASAN: use-after-free Read in macsec_get_iflink
From:   syzbot <syzbot+d0e94b65ac259c29ce7a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c272e2591169 Merge branch 'bpf: refine kernel.unprivileged..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=129fa75ef00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dd72ba865bee7ee0
dashboard link: https://syzkaller.appspot.com/bug?extid=d0e94b65ac259c29ce7a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d0e94b65ac259c29ce7a@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in macsec_get_iflink+0x5f/0x70 drivers/net/macsec.c:3662
Read of size 4 at addr ffff88801da0c0d8 by task kworker/0:1/7455

CPU: 0 PID: 7455 Comm: kworker/0:1 Not tainted 5.18.0-rc3-syzkaller-01632-gc272e2591169 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events linkwatch_event
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 macsec_get_iflink+0x5f/0x70 drivers/net/macsec.c:3662
 dev_get_iflink+0x73/0xe0 net/core/dev.c:637
 default_operstate net/core/link_watch.c:42 [inline]
 rfc2863_policy+0x233/0x2d0 net/core/link_watch.c:54
 linkwatch_do_dev+0x2a/0x150 net/core/link_watch.c:161
 __linkwatch_run_queue+0x243/0x6b0 net/core/link_watch.c:221
 linkwatch_event+0x4a/0x60 net/core/link_watch.c:264
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>

Allocated by task 22209:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc_node include/linux/slab.h:604 [inline]
 kvmalloc_node+0x3e/0x130 mm/util.c:580
 kvmalloc include/linux/slab.h:731 [inline]
 kvzalloc include/linux/slab.h:739 [inline]
 alloc_netdev_mqs+0x98/0x1100 net/core/dev.c:10549
 rtnl_create_link+0x9d7/0xc00 net/core/rtnetlink.c:3235
 veth_newlink+0x20e/0xa90 drivers/net/veth.c:1748
 __rtnl_newlink+0xfe2/0x16a0 net/core/rtnetlink.c:3521
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3569
 rtnetlink_rcv_msg+0x43a/0xc90 net/core/rtnetlink.c:6065
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 __sys_sendto+0x216/0x310 net/socket.c:2040
 __do_sys_sendto net/socket.c:2052 [inline]
 __se_sys_sendto net/socket.c:2048 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2048
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 8:
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
 kvfree+0x42/0x50 mm/util.c:615
 device_release+0x9f/0x240 drivers/base/core.c:2229
 kobject_cleanup lib/kobject.c:673 [inline]
 kobject_release lib/kobject.c:704 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:721
 netdev_run_todo+0x72e/0x10b0 net/core/dev.c:10327
 default_device_exit_batch+0x44e/0x590 net/core/dev.c:11300
 ops_exit_list+0x125/0x170 net/core/net_namespace.c:167
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:594
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

The buggy address belongs to the object at ffff88801da0c000
 which belongs to the cache kmalloc-cg-4k of size 4096
The buggy address is located 216 bytes inside of
 4096-byte region [ffff88801da0c000, ffff88801da0d000)

The buggy address belongs to the physical page:
page:ffffea0000768200 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1da08
head:ffffea0000768200 order:3 compound_mapcount:0 compound_pincount:0
memcg:ffff888023adf0c1
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888010c4c280
raw: 0000000000000000 0000000000040004 00000001ffffffff ffff888023adf0c1
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d60c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 22209, tgid 22209 (syz-executor.5), ts 892037592420, free_ts 892001171236
 prep_new_page mm/page_alloc.c:2441 [inline]
 get_page_from_freelist+0xba2/0x3e00 mm/page_alloc.c:4182
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5408
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x26c/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0x8df/0xf20 mm/slub.c:3005
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3092
 slab_alloc_node mm/slub.c:3183 [inline]
 __kmalloc_node+0x2cb/0x390 mm/slub.c:4458
 kmalloc_node include/linux/slab.h:604 [inline]
 kvmalloc_node+0x3e/0x130 mm/util.c:580
 kvmalloc include/linux/slab.h:731 [inline]
 kvzalloc include/linux/slab.h:739 [inline]
 alloc_netdev_mqs+0x98/0x1100 net/core/dev.c:10549
 rtnl_create_link+0x9d7/0xc00 net/core/rtnetlink.c:3235
 __rtnl_newlink+0xef3/0x16a0 net/core/rtnetlink.c:3511
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3569
 rtnetlink_rcv_msg+0x43a/0xc90 net/core/rtnetlink.c:6065
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1921
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1356 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1406
 free_unref_page_prepare mm/page_alloc.c:3328 [inline]
 free_unref_page+0x19/0x6a0 mm/page_alloc.c:3423
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2523
 qlink_free mm/kasan/quarantine.c:157 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:176
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:283
 ____kasan_kmalloc mm/kasan/common.c:481 [inline]
 __kasan_kmalloc+0xbd/0xd0 mm/kasan/common.c:524
 kmalloc include/linux/slab.h:581 [inline]
 kzalloc include/linux/slab.h:714 [inline]
 kset_create lib/kobject.c:937 [inline]
 kset_create_and_add+0x4b/0x1a0 lib/kobject.c:980
 register_queue_kobjects net/core/net-sysfs.c:1754 [inline]
 netdev_register_kobject+0x1c6/0x430 net/core/net-sysfs.c:2013
 register_netdevice+0xd9d/0x15b0 net/core/dev.c:10014
 veth_newlink+0x59c/0xa90 drivers/net/veth.c:1795
 __rtnl_newlink+0xfe2/0x16a0 net/core/rtnetlink.c:3521
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3569
 rtnetlink_rcv_msg+0x43a/0xc90 net/core/rtnetlink.c:6065
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1921

Memory state around the buggy address:
 ffff88801da0bf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801da0c000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88801da0c080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                    ^
 ffff88801da0c100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801da0c180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
