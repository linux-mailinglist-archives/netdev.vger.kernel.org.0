Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C75DEE05CA
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388967AbfJVODI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:03:08 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:36648 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387814AbfJVODI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 10:03:08 -0400
Received: by mail-il1-f199.google.com with SMTP id y7so9462918ilb.3
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 07:03:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=X8R9No+KYRblmHd6HBmjv/vYFX9sgoKPVl5b2HVYjsw=;
        b=eBdxv/muArhdcR0BrHEkI1a35xgSnvB/6DYIKM0tSSM0X2xcTAT4TH7/ny/JDAJBmV
         aQiPutqQQKRO5ZAtfnHJCr73e5VwkHTepeesjLB+gjp78m6c/Jp3SgIIo4fwkziNqVju
         mI7KyrXd80rv7vDK0TPvQBR8ngy2hVqBlb+AZywTMrNukSpwQ5jTE+Xf7NtoExAZp+g9
         KAeg2g29xGxodEV5D4Kam2ao5Qo/RoQ5rcHkZCL8RDQa4SPxRdxuohCOKcYfUbbXIpUZ
         d826TOXkM4b2+Xad54VxB59gzS6JkNgYP6YYnU9Qq8E9ckARSrv1mienzbY2izuNSnUb
         zvXw==
X-Gm-Message-State: APjAAAWLKGpWEluVpkBnGciGdY2qY+svKgprU1H2+4FBiJikW80r/8Fj
        6cv8PhNJoqe96dXjcuDAAL9nywQ0sU/LkQH5XiccUxWYxgZb
X-Google-Smtp-Source: APXvYqy9Lrb+tqJJGeEY5yKqbiUG8/YR6RXMSFJXZ6uHkr8DS0g+4onKOt30+gN8f921O1j6CCOlHO85Czr9m/g1vP4nzjfri3pG
MIME-Version: 1.0
X-Received: by 2002:a02:b817:: with SMTP id o23mr3974902jam.42.1571752986849;
 Tue, 22 Oct 2019 07:03:06 -0700 (PDT)
Date:   Tue, 22 Oct 2019 07:03:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000074bc3105958042ef@google.com>
Subject: KASAN: use-after-free Read in nf_ct_deliver_cached_events
From:   syzbot <syzbot+c7aabc9fe93e7f3637ba@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    a6fcdcd9 Add linux-next specific files for 20191021
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=111b7fcf600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=32434321999f01e9
dashboard link: https://syzkaller.appspot.com/bug?extid=c7aabc9fe93e7f3637ba
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c7aabc9fe93e7f3637ba@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __nf_ct_ext_exist  
include/net/netfilter/nf_conntrack_extend.h:53 [inline]
BUG: KASAN: use-after-free in nf_ct_ext_exist  
include/net/netfilter/nf_conntrack_extend.h:58 [inline]
BUG: KASAN: use-after-free in __nf_ct_ext_find  
include/net/netfilter/nf_conntrack_extend.h:63 [inline]
BUG: KASAN: use-after-free in nf_ct_ecache_find  
include/net/netfilter/nf_conntrack_ecache.h:35 [inline]
BUG: KASAN: use-after-free in nf_ct_deliver_cached_events+0x5c3/0x6d0  
net/netfilter/nf_conntrack_ecache.c:205
Read of size 1 at addr ffff88806bb2dc04 by task syz-executor.2/27585

CPU: 0 PID: 27585 Comm: syz-executor.2 Not tainted 5.4.0-rc4-next-20191021  
#0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  __asan_report_load1_noabort+0x14/0x20 mm/kasan/generic_report.c:129
  __nf_ct_ext_exist include/net/netfilter/nf_conntrack_extend.h:53 [inline]
  nf_ct_ext_exist include/net/netfilter/nf_conntrack_extend.h:58 [inline]
  __nf_ct_ext_find include/net/netfilter/nf_conntrack_extend.h:63 [inline]
  nf_ct_ecache_find include/net/netfilter/nf_conntrack_ecache.h:35 [inline]
  nf_ct_deliver_cached_events+0x5c3/0x6d0  
net/netfilter/nf_conntrack_ecache.c:205
  nf_conntrack_confirm include/net/netfilter/nf_conntrack_core.h:65 [inline]
  nf_confirm+0x3d8/0x4d0 net/netfilter/nf_conntrack_proto.c:154
  ipv4_confirm+0x14c/0x240 net/netfilter/nf_conntrack_proto.c:169
  nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
  nf_hook_slow+0xbc/0x1e0 net/netfilter/core.c:512
  nf_hook include/linux/netfilter.h:262 [inline]
  NF_HOOK_COND include/linux/netfilter.h:295 [inline]
  ip_output+0x40d/0x670 net/ipv4/ip_output.c:432
  dst_output include/net/dst.h:436 [inline]
  ip_local_out+0xbb/0x1b0 net/ipv4/ip_output.c:125
  ip_send_skb+0x42/0xf0 net/ipv4/ip_output.c:1558
  udp_send_skb.isra.0+0x6d5/0x11b0 net/ipv4/udp.c:891
  udp_sendmsg+0x1e8f/0x2810 net/ipv4/udp.c:1178
  inet_sendmsg+0x9e/0xe0 net/ipv4/af_inet.c:807
  sock_sendmsg_nosec net/socket.c:638 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:658
  kernel_sendmsg+0x44/0x50 net/socket.c:678
  rxrpc_send_data_packet+0x10cb/0x36b0 net/rxrpc/output.c:416
  rxrpc_queue_packet net/rxrpc/sendmsg.c:220 [inline]
  rxrpc_send_data+0x1097/0x4130 net/rxrpc/sendmsg.c:427
  rxrpc_do_sendmsg+0xb8e/0x1d5f net/rxrpc/sendmsg.c:736
  rxrpc_sendmsg+0x4d6/0x5f0 net/rxrpc/af_rxrpc.c:585
  sock_sendmsg_nosec net/socket.c:638 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:658
  ___sys_sendmsg+0x3e2/0x920 net/socket.c:2312
  __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2414
  __do_sys_sendmmsg net/socket.c:2443 [inline]
  __se_sys_sendmmsg net/socket.c:2440 [inline]
  __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2440
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459a59
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f18acb64c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000000459a59
RDX: 0000000000000001 RSI: 0000000020005c00 RDI: 0000000000000004
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f18acb656d4
R13: 00000000004c74b8 R14: 00000000004dd1a8 R15: 00000000ffffffff

Allocated by task 27585:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_krealloc+0x84/0xc0 mm/kasan/common.c:565
  __do_krealloc mm/slab_common.c:1655 [inline]
  krealloc+0xa6/0xd0 mm/slab_common.c:1710
  nf_ct_ext_add+0x2c7/0x630 net/netfilter/nf_conntrack_extend.c:74
  nf_ct_ecache_ext_add include/net/netfilter/nf_conntrack_ecache.h:55  
[inline]
  init_conntrack.isra.0+0x5ed/0x11a0 net/netfilter/nf_conntrack_core.c:1470
  resolve_normal_ct net/netfilter/nf_conntrack_core.c:1547 [inline]
  nf_conntrack_in+0xd94/0x1460 net/netfilter/nf_conntrack_core.c:1707
  ipv4_conntrack_local+0x127/0x220 net/netfilter/nf_conntrack_proto.c:200
  nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
  nf_hook_slow+0xbc/0x1e0 net/netfilter/core.c:512
  nf_hook include/linux/netfilter.h:262 [inline]
  __ip_local_out+0x403/0x870 net/ipv4/ip_output.c:114
  ip_local_out+0x2d/0x1b0 net/ipv4/ip_output.c:123
  ip_send_skb+0x42/0xf0 net/ipv4/ip_output.c:1558
  udp_send_skb.isra.0+0x6d5/0x11b0 net/ipv4/udp.c:891
  udp_sendmsg+0x1e8f/0x2810 net/ipv4/udp.c:1178
  inet_sendmsg+0x9e/0xe0 net/ipv4/af_inet.c:807
  sock_sendmsg_nosec net/socket.c:638 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:658
  kernel_sendmsg+0x44/0x50 net/socket.c:678
  rxrpc_send_data_packet+0x10cb/0x36b0 net/rxrpc/output.c:416
  rxrpc_queue_packet net/rxrpc/sendmsg.c:220 [inline]
  rxrpc_send_data+0x1097/0x4130 net/rxrpc/sendmsg.c:427
  rxrpc_do_sendmsg+0xb8e/0x1d5f net/rxrpc/sendmsg.c:736
  rxrpc_sendmsg+0x4d6/0x5f0 net/rxrpc/af_rxrpc.c:585
  sock_sendmsg_nosec net/socket.c:638 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:658
  ___sys_sendmsg+0x3e2/0x920 net/socket.c:2312
  __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2414
  __do_sys_sendmmsg net/socket.c:2443 [inline]
  __se_sys_sendmmsg net/socket.c:2440 [inline]
  __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2440
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 27585:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3426 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3757
  nf_ct_ext_destroy+0x2ab/0x2e0 net/netfilter/nf_conntrack_extend.c:38
  nf_conntrack_free+0x8f/0xe0 net/netfilter/nf_conntrack_core.c:1418
  destroy_conntrack+0x1a2/0x270 net/netfilter/nf_conntrack_core.c:626
  nf_conntrack_destroy+0xed/0x230 net/netfilter/core.c:600
  nf_conntrack_put include/linux/netfilter/nf_conntrack_common.h:34 [inline]
  nf_conntrack_put include/linux/netfilter/nf_conntrack_common.h:31 [inline]
  nf_ct_resolve_clash net/netfilter/nf_conntrack_core.c:915 [inline]
  __nf_conntrack_confirm+0x21ca/0x2830 net/netfilter/nf_conntrack_core.c:1038
  nf_conntrack_confirm include/net/netfilter/nf_conntrack_core.h:63 [inline]
  nf_confirm+0x3e7/0x4d0 net/netfilter/nf_conntrack_proto.c:154
  ipv4_confirm+0x14c/0x240 net/netfilter/nf_conntrack_proto.c:169
  nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
  nf_hook_slow+0xbc/0x1e0 net/netfilter/core.c:512
  nf_hook include/linux/netfilter.h:262 [inline]
  NF_HOOK_COND include/linux/netfilter.h:295 [inline]
  ip_output+0x40d/0x670 net/ipv4/ip_output.c:432
  dst_output include/net/dst.h:436 [inline]
  ip_local_out+0xbb/0x1b0 net/ipv4/ip_output.c:125
  ip_send_skb+0x42/0xf0 net/ipv4/ip_output.c:1558
  udp_send_skb.isra.0+0x6d5/0x11b0 net/ipv4/udp.c:891
  udp_sendmsg+0x1e8f/0x2810 net/ipv4/udp.c:1178
  inet_sendmsg+0x9e/0xe0 net/ipv4/af_inet.c:807
  sock_sendmsg_nosec net/socket.c:638 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:658
  kernel_sendmsg+0x44/0x50 net/socket.c:678
  rxrpc_send_data_packet+0x10cb/0x36b0 net/rxrpc/output.c:416
  rxrpc_queue_packet net/rxrpc/sendmsg.c:220 [inline]
  rxrpc_send_data+0x1097/0x4130 net/rxrpc/sendmsg.c:427
  rxrpc_do_sendmsg+0xb8e/0x1d5f net/rxrpc/sendmsg.c:736
  rxrpc_sendmsg+0x4d6/0x5f0 net/rxrpc/af_rxrpc.c:585
  sock_sendmsg_nosec net/socket.c:638 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:658
  ___sys_sendmsg+0x3e2/0x920 net/socket.c:2312
  __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2414
  __do_sys_sendmmsg net/socket.c:2443 [inline]
  __se_sys_sendmmsg net/socket.c:2440 [inline]
  __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2440
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88806bb2dc00
  which belongs to the cache kmalloc-128 of size 128
The buggy address is located 4 bytes inside of
  128-byte region [ffff88806bb2dc00, ffff88806bb2dc80)
The buggy address belongs to the page:
page:ffffea0001aecb40 refcount:1 mapcount:0 mapping:ffff8880aa400700  
index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea0002506788 ffffea00026a2c48 ffff8880aa400700
raw: 0000000000000000 ffff88806bb2d000 0000000100000010 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88806bb2db00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88806bb2db80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff88806bb2dc00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                    ^
  ffff88806bb2dc80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88806bb2dd00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
