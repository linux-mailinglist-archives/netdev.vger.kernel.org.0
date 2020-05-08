Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37951CB435
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgEHP7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:59:17 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:45604 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbgEHP7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:59:16 -0400
Received: by mail-il1-f197.google.com with SMTP id t10so1989746ilf.12
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 08:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/Z8ebm8JnEqgq5bx209BZcVEeu1IlwW2yeabxiXAO+A=;
        b=nkpUAdzc91B+xauiT569FrRLXY/uSULKMxfP9G8K0BYdZnbeRk+Xlkesl5aSOO84Q7
         Il9jdtp4ixU8nCIF8h9SGJc3XQwLu0kXFdom2Kx6+rfO6/TVHEViyYlcyELV7/1FEV75
         HbRBhWPQ4hoenytPeeJIfFQl2+9O1Fi1ImrTzVyLOMeaJNny4mQN7Hs6qcDc3KoI8cwP
         GQ/t1VXmfW1+Hf2X6ahJ4x5r/aQ9oQ+XNNIo2fTRe7snCNHYtRM0nrptFIWINGtxEgH4
         KXeXjEiFGGC4IzCj4XGcGoPTMALwGiIBhsV7I1+7z6YAocdMkDfsME2dkQsUbj75QN1j
         OF2Q==
X-Gm-Message-State: AGi0PuZqwVDijAaN3O3/a2xEdXSTC65yZp/933Dsc/e1OBqdRTUN/3Qb
        sjFk4Vopw7/Pr04/+NsBDOXUnfDZb/MdZsjpvqSdz/kqsHt8
X-Google-Smtp-Source: APiQypKqftp0kt1EMnSsQN4HtMQxwBlXzGEM0gHQxmdOYiLVj7wA69CEAbdNCTom4ZPfIKsIpg/k//peBN3aN3pSPy24m8jMthWq
MIME-Version: 1.0
X-Received: by 2002:a02:860e:: with SMTP id e14mr3161121jai.109.1588953553458;
 Fri, 08 May 2020 08:59:13 -0700 (PDT)
Date:   Fri, 08 May 2020 08:59:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001e5cef05a52514c5@google.com>
Subject: KMSAN: uninit-value in route4_get
From:   syzbot <syzbot+0f695e9c22e33a40e8b5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    21c44613 kmsan: page_alloc: more assuring comment
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=111271e4100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5915107b3106aaa
dashboard link: https://syzkaller.appspot.com/bug?extid=0f695e9c22e33a40e8b5
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
userspace arch: i386

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0f695e9c22e33a40e8b5@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in route4_get+0x2cd/0x3d0 net/sched/cls_route.c:235
CPU: 1 PID: 15044 Comm: syz-executor.4 Not tainted 5.6.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 route4_get+0x2cd/0x3d0 net/sched/cls_route.c:235
 tc_new_tfilter+0x1f32/0x4f40 net/sched/cls_api.c:2082
 rtnetlink_rcv_msg+0xcb7/0x1570 net/core/rtnetlink.c:5427
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2478
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5454
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x1246/0x14d0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2432
 __compat_sys_sendmsg net/compat.c:642 [inline]
 __do_compat_sys_sendmsg net/compat.c:649 [inline]
 __se_compat_sys_sendmsg net/compat.c:646 [inline]
 __ia32_compat_sys_sendmsg+0xed/0x130 net/compat.c:646
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3c7/0x6e0 arch/x86/entry/common.c:410
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f0bd99
Code: 90 e8 0b 00 00 00 f3 90 0f ae e8 eb f9 8d 74 26 00 89 3c 24 c3 90 90 90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f5cc40cc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020000280
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2801 [inline]
 slab_alloc mm/slub.c:2810 [inline]
 kmem_cache_alloc_trace+0x6f3/0xd70 mm/slub.c:2827
 kmalloc include/linux/slab.h:555 [inline]
 batadv_forw_packet_alloc+0x1be/0x6d0 net/batman-adv/send.c:525
 batadv_iv_ogm_aggregate_new net/batman-adv/bat_iv_ogm.c:562 [inline]
 batadv_iv_ogm_queue_add+0x11cb/0x1900 net/batman-adv/bat_iv_ogm.c:670
 batadv_iv_ogm_schedule_buff net/batman-adv/bat_iv_ogm.c:833 [inline]
 batadv_iv_ogm_schedule+0xd4c/0x1430 net/batman-adv/bat_iv_ogm.c:869
 batadv_iv_send_outstanding_bat_ogm_packet+0xbae/0xd50 net/batman-adv/bat_iv_ogm.c:1722
 process_one_work+0x1555/0x1f40 kernel/workqueue.c:2266
 worker_thread+0xef6/0x2450 kernel/workqueue.c:2412
 kthread+0x4b5/0x4f0 kernel/kthread.c:256
 ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:353
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
