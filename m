Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0269F18AA89
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 03:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgCSCDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 22:03:15 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:49049 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCSCDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 22:03:15 -0400
Received: by mail-il1-f198.google.com with SMTP id c12so712704ilo.15
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 19:03:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ebUpr0nDVPI/4FejDjdsoRaTZVJDHsEuOly4Gcn0S9g=;
        b=Sp+0h93fTb0eKpWJ207ltj2UiPFl9/7eI+wNCNEr8vmqyMnQGGJv4pf3Cs+5VVmygX
         PkiXpyJrzfSEecA5fLVWvgQTowiCnipLadqzqHSZlA3zxw3k+k/Da7MI+3OvpZG9Pahe
         HVW7an/8cYSeiWSEFcNWQ3PNlsSfI7ZWWCYND/ho/VCRSr7Cs10otwBRWs2TOzMTtNOl
         B0V0XThgl/xGbiKPCiIO0NxMlNn1oRvr6VRyp3wnSqw1DoYlux85iAnWp3eig0SY2ITz
         H4hxehGwf5He+1d39ci2M7EMTfWg9/yO/e6u+QMkX+RXKMGapMptV54RyctHzmoyZnGL
         /M0w==
X-Gm-Message-State: ANhLgQ0FvYP9eI0jq4JC5+xfNQyjHaLfoqG+6lyCPveBRpY7OD0/r4Dv
        J5cPl4QcEJzt9QnskSLImiHei28eK+YFynhj9DcaEjgG9cqj
X-Google-Smtp-Source: ADFU+vtKfqBBed1v2NugKCi7Gb7e5owCDnUhqEKy9I1NGeUE2YIo5yx9GDdUxv3FODhWxKAmrKOzkLIfm+VUMZ3mTdW5u/cnBJcl
MIME-Version: 1.0
X-Received: by 2002:a92:8659:: with SMTP id g86mr969265ild.96.1584583394184;
 Wed, 18 Mar 2020 19:03:14 -0700 (PDT)
Date:   Wed, 18 Mar 2020 19:03:14 -0700
In-Reply-To: <000000000000fd030905a0b75ac8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000053d1d805a12b92c6@google.com>
Subject: Re: KASAN: use-after-free Read in route4_get
From:   syzbot <syzbot+1cba26af4a37d30e8040@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hdanton@sina.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    5076190d mm: slub: be more careful about the double cmpxch..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1645af81e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9f894bd92023de02
dashboard link: https://syzkaller.appspot.com/bug?extid=1cba26af4a37d30e8040
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a2c5f9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=145da7c3e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1cba26af4a37d30e8040@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in route4_get+0x3e1/0x420 net/sched/cls_route.c:235
Read of size 4 at addr ffff8880a6ad6340 by task syz-executor193/9646

CPU: 1 PID: 9646 Comm: syz-executor193 Not tainted 5.6.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:374
 __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:506
 kasan_report+0xe/0x20 mm/kasan/common.c:641
 route4_get+0x3e1/0x420 net/sched/cls_route.c:235
 tc_new_tfilter+0x7a9/0x20b0 net/sched/cls_api.c:2082
 rtnetlink_rcv_msg+0x810/0xad0 net/core/rtnetlink.c:5427
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x44c3d9
Code: e8 7c e6 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 1b 05 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f51dd98ace8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006e8a28 RCX: 000000000044c3d9
RDX: 0000000000000000 RSI: 0000000020000280 RDI: 0000000000000007
RBP: 00000000006e8a20 R08: 0000000000000065 R09: 0000000000000000
R10: 0000000000000014 R11: 0000000000000246 R12: 00000000006e8a2c
R13: 00007fff6ce670bf R14: 00007f51dd98b9c0 R15: 20c49ba5e353f7cf

Allocated by task 9646:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
 kmem_cache_alloc_trace+0x153/0x7d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 route4_change+0x2a9/0x2250 net/sched/cls_route.c:493
 tc_new_tfilter+0xa59/0x20b0 net/sched/cls_api.c:2103
 rtnetlink_rcv_msg+0x810/0xad0 net/core/rtnetlink.c:5427
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 7:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:476
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 route4_delete_filter_work+0x17/0x20 net/sched/cls_route.c:266
 process_one_work+0x94b/0x1690 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x357/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8880a6ad6300
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 64 bytes inside of
 192-byte region [ffff8880a6ad6300, ffff8880a6ad63c0)
The buggy address belongs to the page:
page:ffffea00029ab580 refcount:1 mapcount:0 mapping:ffff8880aa000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00023ceec8 ffffea00024bc688 ffff8880aa000000
raw: 0000000000000000 ffff8880a6ad6000 0000000100000010 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a6ad6200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8880a6ad6280: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
>ffff8880a6ad6300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff8880a6ad6380: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff8880a6ad6400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================

