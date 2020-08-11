Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4C0241ECD
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 19:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgHKQ7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 12:59:32 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:37627 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728970AbgHKQ7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 12:59:18 -0400
Received: by mail-io1-f72.google.com with SMTP id f6so10212816ioa.4
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 09:59:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hSEJXzv+2/hL/Vk/d5GgjQ9pCOq0Yj5nO/mPcFisPBc=;
        b=JK/+G0s4UYkSGROv6Z5/Ln7XK20neIqkFVDCw0dAgJ7+6FjjdriIMIQ8aSkIqVXLBq
         bYCFRsGzGmYFJvxVuQnkwwD4Vd0calee1fMen9UYrVovvT4pqDaARD3V2e+YvAjJjvNt
         7wY2k/3fmXQagwLJAJN+ap/ErUOwOXi2/LrYqgawxrubU7d/NGBsGNdZavYDTQNsmpNx
         278W86ZMSU4R4Lur2Fu7m/iolnB4a9CH6aidZOAL+za0Bj0WbVKbERSFbmnt5heTvkX6
         V8rkwTEXQJRNCRXCfK7X9siKuaRdg415F54WjqZlY9EVtHIbXQHmqp4rw5F93pTQ/4Pv
         kmwg==
X-Gm-Message-State: AOAM531klGZVXw42iLY/6PZA5fMh0IkhcZjJMEp+BQ5lG0y8T9djVzaW
        2w6+Ccy10DdMAJWsy6B9TomwqJ3yUnSCg9FHEY7vEkA24w0z
X-Google-Smtp-Source: ABdhPJxu/1MqreBbidE4ORyAAkFzEtqnHaDgcTxlmC9T9XKnibeibkp/DbjZxUmJL4fdgExE4Ll6R9x+mVwjH+S3HfR9J1bDYfRt
MIME-Version: 1.0
X-Received: by 2002:a6b:8d03:: with SMTP id p3mr23308034iod.114.1597165157566;
 Tue, 11 Aug 2020 09:59:17 -0700 (PDT)
Date:   Tue, 11 Aug 2020 09:59:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd65fe05ac9cfda4@google.com>
Subject: KASAN: use-after-free Read in ovs_ct_exit
From:   syzbot <syzbot+dbb75a2ade6116de3326@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pshelar@ovn.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1c3b63f1 net/tls: allow MSG_CMSG_COMPAT in sendmsg
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=105b73fa900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7bb894f55faf8242
dashboard link: https://syzkaller.appspot.com/bug?extid=dbb75a2ade6116de3326
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dbb75a2ade6116de3326@syzkaller.appspotmail.com

netdevsim netdevsim2 netdevsim0 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
==================================================================
BUG: KASAN: use-after-free in ovs_ct_limit_exit net/openvswitch/conntrack.c:1900 [inline]
BUG: KASAN: use-after-free in ovs_ct_exit+0x269/0x4c7 net/openvswitch/conntrack.c:2298
Read of size 8 at addr ffff88806896be00 by task kworker/u4:2/38

CPU: 1 PID: 38 Comm: kworker/u4:2 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 ovs_ct_limit_exit net/openvswitch/conntrack.c:1900 [inline]
 ovs_ct_exit+0x269/0x4c7 net/openvswitch/conntrack.c:2298
 ovs_exit_net+0x1e8/0xba0 net/openvswitch/datapath.c:2513
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:186
 cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Allocated by task 10412:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 kmem_cache_alloc_trace+0x14f/0x2d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 ovs_ct_limit_set_zone_limit net/openvswitch/conntrack.c:1963 [inline]
 ovs_ct_limit_cmd_set+0x42e/0xc60 net/openvswitch/conntrack.c:2143
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2359
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2413
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2446
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 9661:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kmem_cache_free_bulk+0x7f/0x290 mm/slab.c:3721
 kfree_bulk include/linux/slab.h:412 [inline]
 kfree_rcu_work+0x506/0x8c0 kernel/rcu/tree.c:3148
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

The buggy address belongs to the object at ffff88806896be00
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes inside of
 64-byte region [ffff88806896be00, ffff88806896be40)
The buggy address belongs to the page:
page:ffffea0001a25ac0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00026629c8 ffffea00026c7008 ffff8880aa000380
raw: 0000000000000000 ffff88806896b000 0000000100000020 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88806896bd00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88806896bd80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff88806896be00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                   ^
 ffff88806896be80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88806896bf00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
