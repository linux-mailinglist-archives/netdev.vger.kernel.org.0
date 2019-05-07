Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF5616125
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 11:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfEGJjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 05:39:07 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:55215 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbfEGJjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 05:39:06 -0400
Received: by mail-io1-f72.google.com with SMTP id t7so2899341iof.21
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 02:39:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=seh7Jcu+DGhKTOzFDKk7Bwtr6Qx87ZkY90LaQ/XmHik=;
        b=Uj5yG4loX0gkkMWATVVAHIhYxQLu4E2s75CpI0rzvRfr6tfCH4eMfBjpZIjM+uCnS9
         FcDAQKlAIZ+p5biLVlYwPz1gLRVO/D6YuSIZ4QAfON2jv5QjwlLOkrryOFXv16AvAxWA
         D2+D4E43Ze4Nka5XRn5tt1O8iXfXWuwcLYn5QzxiVxUMgJli+cLOWkWhSh41wsMOSaJq
         1i2wdVHelLFdmbwj9/ZnfuVvavB3n/bBkDGW0C3kaXeaLRDQ645q5LEY+F2ZoZcSikLH
         9VC3Bmt97BBAA/fJWFStFW26H6las90PAOc51b+g0kClWKWu8sZK+nDCqeIWkUDg4ijx
         M3sQ==
X-Gm-Message-State: APjAAAXR2PdMQEd0qfwl9lxsi6ZUcKkaXSDiqFz4fV8qp6j+Xd+JBa3Z
        qon3uzeEV5Dg53RmxwCbB/DP20+Rji6vUeau2h0hApnXrB0r
X-Google-Smtp-Source: APXvYqzhQdtYCf9AuCkazjNvFsoXGV3TM7jBAyBdjzO6ZADS0bXCtPMfHIspD6C8F8DVz9oBGjZJkYUdyUJTKlANlk+vBR5IXJuN
MIME-Version: 1.0
X-Received: by 2002:a02:c88d:: with SMTP id m13mr22359439jao.63.1557221945874;
 Tue, 07 May 2019 02:39:05 -0700 (PDT)
Date:   Tue, 07 May 2019 02:39:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000eba333058848fcc1@google.com>
Subject: KASAN: use-after-free Read in ip6_hold_safe (3)
From:   syzbot <syzbot+1de7f57dd018a516ae89@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4dd2b82d udp: fix GRO packet of death
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=11c916c2a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a42d110b47dd6b36
dashboard link: https://syzkaller.appspot.com/bug?extid=1de7f57dd018a516ae89
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1de7f57dd018a516ae89@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in atomic_read  
include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in atomic_fetch_add_unless  
include/linux/atomic-fallback.h:1086 [inline]
BUG: KASAN: use-after-free in atomic_add_unless  
include/linux/atomic-fallback.h:1111 [inline]
BUG: KASAN: use-after-free in atomic_inc_not_zero  
include/linux/atomic-fallback.h:1127 [inline]
BUG: KASAN: use-after-free in dst_hold_safe include/net/dst.h:308 [inline]
BUG: KASAN: use-after-free in ip6_hold_safe+0xb3/0x3a0 net/ipv6/route.c:1020
Read of size 4 at addr ffff8880a9426d9c by task syz-executor.0/22551

CPU: 1 PID: 22551 Comm: syz-executor.0 Not tainted 5.1.0-rc6+ #192
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:187
  kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x123/0x190 mm/kasan/generic.c:191
  kasan_check_read+0x11/0x20 mm/kasan/common.c:102
  atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
  atomic_fetch_add_unless include/linux/atomic-fallback.h:1086 [inline]
  atomic_add_unless include/linux/atomic-fallback.h:1111 [inline]
  atomic_inc_not_zero include/linux/atomic-fallback.h:1127 [inline]
  dst_hold_safe include/net/dst.h:308 [inline]
  ip6_hold_safe+0xb3/0x3a0 net/ipv6/route.c:1020
  rt6_get_pcpu_route net/ipv6/route.c:1242 [inline]
  ip6_pol_route+0x348/0x1080 net/ipv6/route.c:1901
  ip6_pol_route_output+0x54/0x70 net/ipv6/route.c:2077
  fib6_rule_lookup+0x128/0x560 net/ipv6/fib6_rules.c:118
  ip6_route_output_flags+0x2c4/0x350 net/ipv6/route.c:2106
  ip6_route_output include/net/ip6_route.h:88 [inline]
  ip6_dst_lookup_tail+0xd10/0x1b30 net/ipv6/ip6_output.c:966
  ip6_dst_lookup_flow+0xa8/0x220 net/ipv6/ip6_output.c:1094
  sctp_v6_get_dst+0x785/0x1d80 net/sctp/ipv6.c:293
  sctp_transport_route+0x132/0x370 net/sctp/transport.c:312
  sctp_assoc_add_peer+0x53e/0xfc0 net/sctp/associola.c:678
  sctp_process_param net/sctp/sm_make_chunk.c:2548 [inline]
  sctp_process_init+0x249f/0x2b20 net/sctp/sm_make_chunk.c:2361
  sctp_sf_do_5_1B_init+0x8ba/0xe50 net/sctp/sm_statefuns.c:416
  sctp_do_sm+0x12c/0x5500 net/sctp/sm_sideeffect.c:1162
  sctp_endpoint_bh_rcv+0x451/0x950 net/sctp/endpointola.c:458
  sctp_inq_push+0x1ea/0x290 net/sctp/inqueue.c:95
  sctp_rcv+0x2850/0x3600 net/sctp/input.c:271
  sctp6_rcv+0x17/0x30 net/sctp/ipv6.c:1063
  ip6_protocol_deliver_rcu+0x303/0x16c0 net/ipv6/ip6_input.c:394
  ip6_input_finish+0x84/0x170 net/ipv6/ip6_input.c:434
  NF_HOOK include/linux/netfilter.h:289 [inline]
  NF_HOOK include/linux/netfilter.h:283 [inline]
  ip6_input+0xe4/0x3f0 net/ipv6/ip6_input.c:443
  dst_input include/net/dst.h:450 [inline]
  ip6_rcv_finish+0x1e7/0x320 net/ipv6/ip6_input.c:76
  NF_HOOK include/linux/netfilter.h:289 [inline]
  NF_HOOK include/linux/netfilter.h:283 [inline]
  ipv6_rcv+0x10e/0x420 net/ipv6/ip6_input.c:272
  __netif_receive_skb_one_core+0x115/0x1a0 net/core/dev.c:4987
  __netif_receive_skb+0x2c/0x1c0 net/core/dev.c:5099
  process_backlog+0x206/0x750 net/core/dev.c:5939
  napi_poll net/core/dev.c:6362 [inline]
  net_rx_action+0x4fa/0x1070 net/core/dev.c:6428
  __do_softirq+0x266/0x95a kernel/softirq.c:293
  do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1027
  </IRQ>
  do_softirq.part.0+0x11a/0x170 kernel/softirq.c:338
  do_softirq kernel/softirq.c:330 [inline]
  __local_bh_enable_ip+0x211/0x270 kernel/softirq.c:190
  local_bh_enable include/linux/bottom_half.h:32 [inline]
  rcu_read_unlock_bh include/linux/rcupdate.h:684 [inline]
  ip6_finish_output2+0xbcf/0x2550 net/ipv6/ip6_output.c:121
  ip6_finish_output+0x577/0xc30 net/ipv6/ip6_output.c:154
  NF_HOOK_COND include/linux/netfilter.h:278 [inline]
  ip6_output+0x235/0x7f0 net/ipv6/ip6_output.c:171
  dst_output include/net/dst.h:444 [inline]
  NF_HOOK include/linux/netfilter.h:289 [inline]
  NF_HOOK include/linux/netfilter.h:283 [inline]
  ip6_xmit+0xe41/0x20c0 net/ipv6/ip6_output.c:275
  sctp_v6_xmit+0x313/0x660 net/sctp/ipv6.c:232
  sctp_packet_transmit+0x1bc4/0x36f0 net/sctp/output.c:641
  sctp_packet_singleton net/sctp/outqueue.c:787 [inline]
  sctp_outq_flush_ctrl.constprop.0+0x6d4/0xd50 net/sctp/outqueue.c:918
  sctp_outq_flush+0xe8/0x2780 net/sctp/outqueue.c:1200
  sctp_outq_uncork+0x6c/0x80 net/sctp/outqueue.c:772
  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1791 [inline]
  sctp_side_effects net/sctp/sm_sideeffect.c:1194 [inline]
  sctp_do_sm+0x265c/0x5500 net/sctp/sm_sideeffect.c:1165
  sctp_primitive_ASSOCIATE+0x9d/0xd0 net/sctp/primitive.c:88
  __sctp_connect+0x8cd/0xce0 net/sctp/socket.c:1226
  __sctp_setsockopt_connectx+0x133/0x1a0 net/sctp/socket.c:1349
  sctp_setsockopt_connectx_old net/sctp/socket.c:1365 [inline]
  sctp_setsockopt net/sctp/socket.c:4656 [inline]
  sctp_setsockopt+0x15db/0x6fe0 net/sctp/socket.c:4620
  sock_common_setsockopt+0x9a/0xe0 net/core/sock.c:3120
  __sys_setsockopt+0x180/0x280 net/socket.c:2046
  __do_sys_setsockopt net/socket.c:2057 [inline]
  __se_sys_setsockopt net/socket.c:2054 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2054
  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x458da9
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f10cef0fc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000458da9
RDX: 000000000000006b RSI: 0000000000000084 RDI: 0000000000000009
RBP: 000000000073bf00 R08: 000000000000001c R09: 0000000000000000
R10: 000000002055bfe4 R11: 0000000000000246 R12: 00007f10cef106d4
R13: 00000000004ce210 R14: 00000000004dc380 R15: 00000000ffffffff

Allocated by task 21829:
  save_stack+0x45/0xd0 mm/kasan/common.c:75
  set_track mm/kasan/common.c:87 [inline]
  __kasan_kmalloc mm/kasan/common.c:497 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:470
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:511
  __do_kmalloc_node mm/slab.c:3687 [inline]
  __kmalloc_node+0x4e/0x70 mm/slab.c:3694
  kmalloc_node include/linux/slab.h:590 [inline]
  kvmalloc_node+0x68/0x100 mm/util.c:430
  kvmalloc include/linux/mm.h:605 [inline]
  seq_buf_alloc fs/seq_file.c:32 [inline]
  seq_read+0x832/0x1130 fs/seq_file.c:204
  __vfs_read+0x8d/0x110 fs/read_write.c:416
  vfs_read+0x194/0x3e0 fs/read_write.c:452
  ksys_read+0x14f/0x2d0 fs/read_write.c:579
  __do_sys_read fs/read_write.c:589 [inline]
  __se_sys_read fs/read_write.c:587 [inline]
  __x64_sys_read+0x73/0xb0 fs/read_write.c:587
  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 21829:
  save_stack+0x45/0xd0 mm/kasan/common.c:75
  set_track mm/kasan/common.c:87 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:459
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:467
  __cache_free mm/slab.c:3499 [inline]
  kfree+0xcf/0x230 mm/slab.c:3822
  kvfree+0x61/0x70 mm/util.c:459
  seq_release fs/seq_file.c:359 [inline]
  single_release+0x7e/0xc0 fs/seq_file.c:596
  __fput+0x2e5/0x8d0 fs/file_table.c:278
  ____fput+0x16/0x20 fs/file_table.c:309
  task_work_run+0x14a/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x52d/0x610 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a94266c0
  which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1756 bytes inside of
  4096-byte region [ffff8880a94266c0, ffff8880a94276c0)
The buggy address belongs to the page:
page:ffffea0002a50980 count:1 mapcount:0 mapping:ffff88812c3f0dc0 index:0x0  
compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea00019e4d88 ffffea0001a0ca88 ffff88812c3f0dc0
raw: 0000000000000000 ffff8880a94266c0 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a9426c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a9426d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8880a9426d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                             ^
  ffff8880a9426e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a9426e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
