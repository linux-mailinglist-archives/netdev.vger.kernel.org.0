Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D9320BF4D
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 09:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgF0HSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 03:18:15 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:39582 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbgF0HSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 03:18:13 -0400
Received: by mail-il1-f197.google.com with SMTP id f66so2486365ilh.6
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 00:18:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=11Wf+73coqv1W4WTS3Nhb3hN1AVynvw9VaW2mbtvR5g=;
        b=VnhZhkVPVkbjVqLf+iKgIqGCkpYAJ/JznkozrhIfvmpVBvY9CrHu3Y5oI2SSRxK+aT
         rfIsnzTpwB7688UTAmxj0oH64hDmYGk5ePRNievV5BD35/S9AASRBIKStLo/fLVQA+JD
         Ls12a/J76nSPT111pYYreamvFYXOHNwE+nW+ZVNaXaplUr64yPvibnHrrkxQJhOrTIUf
         3x9cwv+/KWndytNc6sCt2T6ryvenah5HO7iY/KSJVu49FyEgGMuSAWpPC3bjmZxNhXQ3
         RpCkpgvZCFFQw/QzQbrck8o0Esc8yimzVuR7nWn20PUadFksxXBgehXOTkFNRdl6EqSw
         1Xsg==
X-Gm-Message-State: AOAM5334XL0/qT8iyXGKcvLqc6+bwbxQ2Dun7mWC7LWc9HapBN3jdQAv
        qAjVcGjHs7f8i+ZSGoq416prFDdf6RSyPPRQwSSYid1tw7Lu
X-Google-Smtp-Source: ABdhPJw5LSGIq4ROdhLXaoi25yTEnEa+GdURV6shHXHe1YuOnW9XRvai8vx9j21UMI9BLbYmJHUyNMPijBorUpHRR70e19n0hk+i
MIME-Version: 1.0
X-Received: by 2002:a92:6c0f:: with SMTP id h15mr6805940ilc.210.1593242292532;
 Sat, 27 Jun 2020 00:18:12 -0700 (PDT)
Date:   Sat, 27 Jun 2020 00:18:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e33c8905a90ba06f@google.com>
Subject: KASAN: slab-out-of-bounds Read in decode_session6
From:   syzbot <syzbot+2bcc71839223ec82f056@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b835a71e usbnet: smsc95xx: Fix use-after-free after removal
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1565a5fd100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcc6334acae363d4
dashboard link: https://syzkaller.appspot.com/bug?extid=2bcc71839223ec82f056
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2bcc71839223ec82f056@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in decode_session6+0xe7c/0x1580 net/xfrm/xfrm_policy.c:3389
Read of size 1 at addr ffff88809edddd50 by task syz-executor.5/2845

CPU: 1 PID: 2845 Comm: syz-executor.5 Not tainted 5.8.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 decode_session6+0xe7c/0x1580 net/xfrm/xfrm_policy.c:3389
 __xfrm_decode_session+0x50/0xb0 net/xfrm/xfrm_policy.c:3481
 xfrm_decode_session_reverse include/net/xfrm.h:1141 [inline]
 icmpv6_route_lookup+0x304/0x470 net/ipv6/icmp.c:388
 icmp6_send+0x1327/0x26b0 net/ipv6/icmp.c:588
 icmpv6_send+0xde/0x210 net/ipv6/ip6_icmp.c:43
 ip6_link_failure+0x26/0x500 net/ipv6/route.c:2665
 dst_link_failure include/net/dst.h:418 [inline]
 ipip6_tunnel_xmit net/ipv6/sit.c:1042 [inline]
 sit_tunnel_xmit+0x1919/0x29d0 net/ipv6/sit.c:1079
 __netdev_start_xmit include/linux/netdevice.h:4611 [inline]
 netdev_start_xmit include/linux/netdevice.h:4625 [inline]
 xmit_one net/core/dev.c:3556 [inline]
 dev_hard_start_xmit+0x193/0x950 net/core/dev.c:3572
 sch_direct_xmit+0x2ea/0xc00 net/sched/sch_generic.c:313
 qdisc_restart net/sched/sch_generic.c:376 [inline]
 __qdisc_run+0x4b9/0x1630 net/sched/sch_generic.c:384
 __dev_xmit_skb net/core/dev.c:3795 [inline]
 __dev_queue_xmit+0x1995/0x2d60 net/core/dev.c:4100
 neigh_output include/net/neighbour.h:509 [inline]
 ip6_finish_output2+0x8b6/0x17b0 net/ipv6/ip6_output.c:117
 __ip6_finish_output net/ipv6/ip6_output.c:143 [inline]
 __ip6_finish_output+0x447/0xab0 net/ipv6/ip6_output.c:128
 ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x1db/0x520 net/ipv6/ip6_output.c:176
 dst_output include/net/dst.h:435 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_xmit+0x1258/0x1e80 net/ipv6/ip6_output.c:280
 sctp_v6_xmit+0x339/0x650 net/sctp/ipv6.c:217
 sctp_packet_transmit+0x20d7/0x3240 net/sctp/output.c:629
 sctp_packet_singleton net/sctp/outqueue.c:773 [inline]
 sctp_outq_flush_ctrl.constprop.0+0x6d3/0xc40 net/sctp/outqueue.c:904
 sctp_outq_flush+0xfb/0x2380 net/sctp/outqueue.c:1186
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x4d0/0x4d80 net/sctp/sm_sideeffect.c:1156
 sctp_primitive_ASSOCIATE+0x98/0xc0 net/sctp/primitive.c:73
 sctp_sendmsg_to_asoc+0xb44/0x2090 net/sctp/socket.c:1848
 sctp_sendmsg+0x1025/0x1cf0 net/sctp/socket.c:2038
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:814
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x331/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmmsg+0x195/0x480 net/socket.c:2496
 __do_sys_sendmmsg net/socket.c:2525 [inline]
 __se_sys_sendmmsg net/socket.c:2522 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2522
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45ca59
Code: Bad RIP value.
RSP: 002b:00007f677b566c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00000000004fd400 RCX: 000000000045ca59
RDX: 0000000000000001 RSI: 00000000200006c0 RDI: 0000000000000003
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000902 R14: 00000000004cbd15 R15: 00007f677b5676d4

Allocated by task 7426:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 kmalloc_node include/linux/slab.h:578 [inline]
 kvmalloc_node+0x61/0xf0 mm/util.c:574
 kvmalloc include/linux/mm.h:753 [inline]
 xt_alloc_table_info+0x3c/0xa0 net/netfilter/x_tables.c:1176
 do_replace net/ipv6/netfilter/ip6_tables.c:1142 [inline]
 do_ip6t_set_ctl+0x226/0x460 net/ipv6/netfilter/ip6_tables.c:1681
 nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
 nf_setsockopt+0x6f/0xc0 net/netfilter/nf_sockopt.c:115
 ipv6_setsockopt+0x10c/0x170 net/ipv6/ipv6_sockglue.c:905
 tcp_setsockopt+0x86/0xd0 net/ipv4/tcp.c:3334
 __sys_setsockopt+0x24a/0x480 net/socket.c:2127
 __do_sys_setsockopt net/socket.c:2143 [inline]
 __se_sys_setsockopt net/socket.c:2140 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2140
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 7135:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 sk_prot_free net/core/sock.c:1730 [inline]
 __sk_destruct+0x63b/0x860 net/core/sock.c:1814
 sk_destruct+0xbd/0xe0 net/core/sock.c:1829
 __sk_free+0xef/0x3d0 net/core/sock.c:1840
 sk_free+0x78/0xa0 net/core/sock.c:1851
 deferred_put_nlk_sk+0x151/0x2e0 net/netlink/af_netlink.c:729
 rcu_do_batch kernel/rcu/tree.c:2396 [inline]
 rcu_core+0x5c7/0x1160 kernel/rcu/tree.c:2623
 __do_softirq+0x34c/0xa60 kernel/softirq.c:292

The buggy address belongs to the object at ffff88809eddd000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1360 bytes to the right of
 2048-byte region [ffff88809eddd000, ffff88809eddd800)
The buggy address belongs to the page:
page:ffffea00027b7740 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002566d88 ffffea00026a7188 ffff8880aa000e00
raw: 0000000000000000 ffff88809eddd000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809edddc00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88809edddc80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88809edddd00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                                 ^
 ffff88809edddd80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88809eddde00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
