Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFDD2A18C2
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 17:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgJaQnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 12:43:25 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:57218 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbgJaQnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 12:43:25 -0400
Received: by mail-il1-f197.google.com with SMTP id y15so6890937ilq.23
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 09:43:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=FF3ULlvXFfH0/25/zEK6CK+ewSrhdXs4qIRBIcWcMJo=;
        b=F82Z1edZrwfd3kIVdsrZKJd18UDTAjQRjm43cvqmkfVtpqVOcLe5SWjhWTVh9WIyWl
         3lXC94Zu92iw/XCHJ1tZbrkGUdYbiQ8ewxcnKrGst6bwz6ttYxAXXQojrFqxFJxRZNnS
         Jue1vY8yZ8ATqEtU1d0hhq6cZHbN9uyG8mfFMH+v7JZoYCfhQ+fNMGT2XVCSz7nfpHib
         oNJtP1RAyiog+I2+RLVjCHII+f8QMJgY2OCwuzkDwk2rQdB2/G+tBWatOoOKi5BUjdwf
         3RwGSMJSBemFqTDg+FKRG5z+rVO0aum8gjzMADf8xL5bYWRFGuoxhv8V2ejVmQQPBNAh
         n2SQ==
X-Gm-Message-State: AOAM532sfE9nb7y9BExkSrb3rZ/zOmx+zHSDyrfdb8P1kw6oez09qqu/
        JtszgkCQECgqsKWpnMv5pFno5wo0p3IiDnXYZ8vbjdhuicHx
X-Google-Smtp-Source: ABdhPJwrOSbdAF7lZOBxNAljzQlqPH0oWRT2+m2xHd1YDYFmcYHOyVTUNRx3ZOgMwIQJCDRxb87B8ess1aQzxUFdJRAL0yqrANdW
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1381:: with SMTP id w1mr6241325jad.79.1604162603832;
 Sat, 31 Oct 2020 09:43:23 -0700 (PDT)
Date:   Sat, 31 Oct 2020 09:43:23 -0700
In-Reply-To: <00000000000013259505a931dd26@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029e03805b2fa362f@google.com>
Subject: Re: KASAN: use-after-free Read in decode_session6
From:   syzbot <syzbot+5be8aebb1b7dfa90ef31@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    68bb4665 Merge branch 'l2-multicast-forwarding-for-ocelot-..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1219346c500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eac680ae76558a0e
dashboard link: https://syzkaller.appspot.com/bug?extid=5be8aebb1b7dfa90ef31
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11286398500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11bbf398500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5be8aebb1b7dfa90ef31@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in decode_session6+0xe7c/0x1580 net/xfrm/xfrm_policy.c:3393
Read of size 1 at addr ffff88802c9d08af by task syz-executor061/8480

CPU: 1 PID: 8480 Comm: syz-executor061 Not tainted 5.10.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 decode_session6+0xe7c/0x1580 net/xfrm/xfrm_policy.c:3393
 __xfrm_decode_session net/xfrm/xfrm_policy.c:3485 [inline]
 __xfrm_policy_check+0x2fa/0x2850 net/xfrm/xfrm_policy.c:3540
 __xfrm_policy_check2 include/net/xfrm.h:1097 [inline]
 xfrm_policy_check include/net/xfrm.h:1106 [inline]
 sctp_rcv+0x12b0/0x2e30 net/sctp/input.c:202
 sctp6_rcv+0x22/0x40 net/sctp/ipv6.c:1078
 ip6_protocol_deliver_rcu+0x2e8/0x1680 net/ipv6/ip6_input.c:433
 ip6_input_finish+0x7f/0x160 net/ipv6/ip6_input.c:474
 NF_HOOK include/linux/netfilter.h:301 [inline]
 NF_HOOK include/linux/netfilter.h:295 [inline]
 ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:483
 dst_input include/net/dst.h:449 [inline]
 ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 NF_HOOK include/linux/netfilter.h:295 [inline]
 ipv6_rcv+0x28e/0x3c0 net/ipv6/ip6_input.c:307
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5315
 __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5429
 process_backlog+0x232/0x6c0 net/core/dev.c:6319
 napi_poll net/core/dev.c:6763 [inline]
 net_rx_action+0x4dc/0x1100 net/core/dev.c:6833
 __do_softirq+0x2a0/0x9f6 kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
 do_softirq kernel/softirq.c:343 [inline]
 do_softirq+0xb5/0xe0 kernel/softirq.c:330
 __local_bh_enable_ip+0xf0/0x110 kernel/softirq.c:195
 local_bh_enable include/linux/bottom_half.h:32 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:730 [inline]
 ip6_finish_output2+0x71f/0x16c0 net/ipv6/ip6_output.c:118
 __ip6_finish_output net/ipv6/ip6_output.c:143 [inline]
 __ip6_finish_output+0x447/0xab0 net/ipv6/ip6_output.c:128
 ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
 NF_HOOK_COND include/linux/netfilter.h:290 [inline]
 ip6_output+0x1db/0x520 net/ipv6/ip6_output.c:176
 dst_output include/net/dst.h:443 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 NF_HOOK include/linux/netfilter.h:295 [inline]
 ip6_xmit+0x1258/0x1e80 net/ipv6/ip6_output.c:280
 sctp_v6_xmit+0xbf3/0xfe0 net/sctp/ipv6.c:223
 sctp_packet_transmit+0x1f44/0x32f0 net/sctp/output.c:627
 sctp_packet_singleton net/sctp/outqueue.c:773 [inline]
 sctp_outq_flush_ctrl.constprop.0+0x6d3/0xc40 net/sctp/outqueue.c:904
 sctp_outq_flush+0xf3/0x2580 net/sctp/outqueue.c:1186
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x74e/0x5130 net/sctp/sm_sideeffect.c:1156
 sctp_primitive_ASSOCIATE+0x98/0xc0 net/sctp/primitive.c:73
 sctp_sendmsg_to_asoc+0xb5b/0x2140 net/sctp/socket.c:1823
 sctp_sendmsg+0x103b/0x1d30 net/sctp/socket.c:2013
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:817
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 __sys_sendto+0x21c/0x320 net/socket.c:1992
 __do_sys_sendto net/socket.c:2004 [inline]
 __se_sys_sendto net/socket.c:2000 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2000
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4413c9
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 1b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff3d021208 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004413c9
RDX: 0000000000034000 RSI: 0000000020847fff RDI: 0000000000000004
RBP: 00000000006cb018 R08: 000000002005ffe4 R09: 000000000000001c
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402170
R13: 0000000000402200 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 1:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 kmalloc include/linux/slab.h:557 [inline]
 tomoyo_realpath_from_path+0xc3/0x620 security/tomoyo/realpath.c:254
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x21b/0x400 security/tomoyo/file.c:822
 security_inode_getattr+0xcf/0x140 security/security.c:1279
 vfs_getattr fs/stat.c:121 [inline]
 vfs_statx+0x164/0x390 fs/stat.c:189
 vfs_fstatat fs/stat.c:207 [inline]
 vfs_lstat include/linux/fs.h:3109 [inline]
 __do_sys_newlstat+0x91/0x110 fs/stat.c:362
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 1:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
 slab_free_hook mm/slub.c:1544 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
 slab_free mm/slub.c:3142 [inline]
 kfree+0xdb/0x360 mm/slub.c:4124
 tomoyo_realpath_from_path+0x191/0x620 security/tomoyo/realpath.c:291
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x21b/0x400 security/tomoyo/file.c:822
 security_inode_getattr+0xcf/0x140 security/security.c:1279
 vfs_getattr fs/stat.c:121 [inline]
 vfs_statx+0x164/0x390 fs/stat.c:189
 vfs_fstatat fs/stat.c:207 [inline]
 vfs_lstat include/linux/fs.h:3109 [inline]
 __do_sys_newlstat+0x91/0x110 fs/stat.c:362
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88802c9d0000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 2223 bytes inside of
 4096-byte region [ffff88802c9d0000, ffff88802c9d1000)
The buggy address belongs to the page:
page:00000000a89e7c26 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2c9d0
head:00000000a89e7c26 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 0000000000000000 0000000100000001 ffff888010042140
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88802c9d0780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802c9d0800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88802c9d0880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff88802c9d0900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802c9d0980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

