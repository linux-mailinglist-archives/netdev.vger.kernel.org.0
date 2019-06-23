Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C660F4FB21
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 12:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfFWKhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 06:37:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:56594 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfFWKhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 06:37:06 -0400
Received: by mail-io1-f72.google.com with SMTP id u25so17753568iol.23
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 03:37:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=R+foo+kvOx4dze7eA0jrIqas8dcjlWlwn4IxLmthvzc=;
        b=HnYrpYR3845d5oBaQwLnZ/Gi4yJsiV9Fd9vtfpfYueoihK2W3n5gtAomAlELuDbSlk
         xJFs8phj3VFGqTq5n5l/9kQP7qVcitsQmQCbBQC/UrMKJOCu2G4QkClogLU4RxX7ncAC
         CKtNCP/MqkEIcabEksNGLLDgUS+JYRHPtwVDU4Ls+gpkCrSvLJN2SYXEBJTgSIKDFxPD
         E1WbKhad12w1jlRxs74TcEpCfI/xF76//pqeTdPWLhdunE3Y7LPsOf5V6kiXvJgL4Iiz
         kb9tB7zySzatgRSkOlSjTW8uULdx2OTJ0M0ZYf4Zzy/iWu2hWlm1viZMcnsEkIdJI55J
         oIbg==
X-Gm-Message-State: APjAAAWcaZ/E1IOoI9p3u/ag/EfANQPslt7Dc3BvpRdbV58lReGYaRqT
        aie9ZWvZYKiBWwzwRdmT/BB+95+J1V2QIqmnfuX1wYmMaO9j
X-Google-Smtp-Source: APXvYqyPxwE4xAz+WhN3dfZXCppVb0lL7NKPYBVn3COzs2MWVK0jgJS4T4arjDFDY7e+4G6g6DxZHZNUAnAn/hhS8aVRYB718/BZ
MIME-Version: 1.0
X-Received: by 2002:a6b:7a42:: with SMTP id k2mr29879531iop.214.1561286225444;
 Sun, 23 Jun 2019 03:37:05 -0700 (PDT)
Date:   Sun, 23 Jun 2019 03:37:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dc4531058bfb4605@google.com>
Subject: KMSAN: uninit-value in gre_parse_header
From:   syzbot <syzbot+f583ce3d4ddf9836b27a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xeb@mail.ru,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    088c01ea kmsan: fix comment, NFC
git tree:       kmsan
console output: https://syzkaller.appspot.com/x/log.txt?x=15efc163200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=68044283f8b8640d
dashboard link: https://syzkaller.appspot.com/bug?extid=f583ce3d4ddf9836b27a
compiler:       clang version 8.0.0 (trunk 350509)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10775ecd200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1364b30f200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f583ce3d4ddf9836b27a@syzkaller.appspotmail.com

IPv6: ADDRCONF(NETDEV_CHANGE): hsr_slave_1: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): hsr0: link becomes ready
8021q: adding VLAN 0 to HW filter on device batadv0
raw_sendmsg: syz-executor949 forgot to set AF_INET. Fix it!
==================================================================
BUG: KMSAN: uninit-value in __arch_swab32  
arch/x86/include/uapi/asm/swab.h:10 [inline]
BUG: KMSAN: uninit-value in __fswab32 include/uapi/linux/swab.h:59 [inline]
BUG: KMSAN: uninit-value in gre_parse_header+0x1396/0x1690  
net/ipv4/gre_demux.c:136
CPU: 1 PID: 10485 Comm: syz-executor949 Not tainted 5.1.0-rc2+ #21
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x173/0x1d0 lib/dump_stack.c:113
  kmsan_report+0x131/0x2a0 mm/kmsan/kmsan.c:624
  __msan_warning+0x7a/0xf0 mm/kmsan/kmsan_instr.c:310
  __arch_swab32 arch/x86/include/uapi/asm/swab.h:10 [inline]
  __fswab32 include/uapi/linux/swab.h:59 [inline]
  gre_parse_header+0x1396/0x1690 net/ipv4/gre_demux.c:136
  gre_rcv+0x1c3/0x1800 net/ipv4/ip_gre.c:409
  gre_rcv+0x2dd/0x3c0 net/ipv4/gre_demux.c:160
  ip_protocol_deliver_rcu+0x584/0xbb0 net/ipv4/ip_input.c:208
  ip_local_deliver_finish net/ipv4/ip_input.c:234 [inline]
  NF_HOOK include/linux/netfilter.h:289 [inline]
  ip_local_deliver+0x624/0x7b0 net/ipv4/ip_input.c:255
  dst_input include/net/dst.h:450 [inline]
  ip_rcv_finish net/ipv4/ip_input.c:414 [inline]
  NF_HOOK include/linux/netfilter.h:289 [inline]
  ip_rcv+0x6bd/0x740 net/ipv4/ip_input.c:524
  __netif_receive_skb_one_core net/core/dev.c:4973 [inline]
  __netif_receive_skb net/core/dev.c:5083 [inline]
  process_backlog+0x756/0x10e0 net/core/dev.c:5923
  napi_poll net/core/dev.c:6346 [inline]
  net_rx_action+0x78b/0x1a60 net/core/dev.c:6412
  __do_softirq+0x53f/0x93a kernel/softirq.c:294
  do_softirq_own_stack+0x49/0x80 arch/x86/entry/entry_64.S:1039
  </IRQ>
  do_softirq kernel/softirq.c:339 [inline]
  __local_bh_enable_ip+0x1a3/0x1f0 kernel/softirq.c:191
  local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
  rcu_read_unlock_bh include/linux/rcupdate.h:684 [inline]
  ip_finish_output2+0x1721/0x1930 net/ipv4/ip_output.c:231
  ip_finish_output+0xd2b/0xfd0 net/ipv4/ip_output.c:317
  NF_HOOK_COND include/linux/netfilter.h:278 [inline]
  ip_output+0x53f/0x610 net/ipv4/ip_output.c:405
  dst_output include/net/dst.h:444 [inline]
  ip_local_out net/ipv4/ip_output.c:124 [inline]
  ip_send_skb net/ipv4/ip_output.c:1465 [inline]
  ip_push_pending_frames+0x243/0x460 net/ipv4/ip_output.c:1485
  raw_sendmsg+0x2e31/0x4650 net/ipv4/raw.c:676
  inet_sendmsg+0x54a/0x720 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:622 [inline]
  sock_sendmsg net/socket.c:632 [inline]
  ___sys_sendmsg+0xdb3/0x1220 net/socket.c:2137
  __sys_sendmmsg+0x580/0xad0 net/socket.c:2232
  __do_sys_sendmmsg net/socket.c:2261 [inline]
  __se_sys_sendmmsg+0xbd/0xe0 net/socket.c:2258
  __x64_sys_sendmmsg+0x56/0x70 net/socket.c:2258
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x441999
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 bb 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd647de1c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441999
RDX: 0000000000000001 RSI: 00000000200006c0 RDI: 0000000000000004
RBP: 00000000004a9030 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402ee0
R13: 0000000000402f70 R14: 0000000000000000 R15: 0000000000000000

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:205 [inline]
  kmsan_save_stack mm/kmsan/kmsan.c:220 [inline]
  kmsan_internal_chain_origin+0x134/0x230 mm/kmsan/kmsan.c:426
  kmsan_memcpy_memmove_metadata+0xb5b/0xfe0 mm/kmsan/kmsan.c:304
  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:324
  __msan_memcpy+0x58/0x70 mm/kmsan/kmsan_instr.c:139
  pskb_expand_head+0x3aa/0x1a30 net/core/skbuff.c:1478
  __skb_cow include/linux/skbuff.h:3029 [inline]
  skb_cow_head include/linux/skbuff.h:3063 [inline]
  ip_tunnel_xmit+0x2c4e/0x3310 net/ipv4/ip_tunnel.c:824
  __gre_xmit net/ipv4/ip_gre.c:444 [inline]
  erspan_xmit+0x1f5e/0x3640 net/ipv4/ip_gre.c:679
  __netdev_start_xmit include/linux/netdevice.h:4411 [inline]
  netdev_start_xmit include/linux/netdevice.h:4420 [inline]
  xmit_one net/core/dev.c:3278 [inline]
  dev_hard_start_xmit+0x604/0xc40 net/core/dev.c:3294
  sch_direct_xmit+0x58a/0x880 net/sched/sch_generic.c:327
  qdisc_restart net/sched/sch_generic.c:390 [inline]
  __qdisc_run+0x1cd7/0x34b0 net/sched/sch_generic.c:398
  qdisc_run include/net/pkt_sched.h:121 [inline]
  __dev_xmit_skb net/core/dev.c:3473 [inline]
  __dev_queue_xmit+0x1e51/0x3ce0 net/core/dev.c:3832
  dev_queue_xmit+0x4b/0x60 net/core/dev.c:3897
  neigh_resolve_output+0xab7/0xb40 net/core/neighbour.c:1487
  neigh_output include/net/neighbour.h:508 [inline]
  ip_finish_output2+0x1709/0x1930 net/ipv4/ip_output.c:229
  ip_finish_output+0xd2b/0xfd0 net/ipv4/ip_output.c:317
  NF_HOOK_COND include/linux/netfilter.h:278 [inline]
  ip_output+0x53f/0x610 net/ipv4/ip_output.c:405
  dst_output include/net/dst.h:444 [inline]
  ip_local_out net/ipv4/ip_output.c:124 [inline]
  ip_send_skb net/ipv4/ip_output.c:1465 [inline]
  ip_push_pending_frames+0x243/0x460 net/ipv4/ip_output.c:1485
  raw_sendmsg+0x2e31/0x4650 net/ipv4/raw.c:676
  inet_sendmsg+0x54a/0x720 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:622 [inline]
  sock_sendmsg net/socket.c:632 [inline]
  ___sys_sendmsg+0xdb3/0x1220 net/socket.c:2137
  __sys_sendmmsg+0x580/0xad0 net/socket.c:2232
  __do_sys_sendmmsg net/socket.c:2261 [inline]
  __se_sys_sendmmsg+0xbd/0xe0 net/socket.c:2258
  __x64_sys_sendmmsg+0x56/0x70 net/socket.c:2258
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

Uninit was created at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:205 [inline]
  kmsan_internal_poison_shadow+0x92/0x150 mm/kmsan/kmsan.c:159
  kmsan_kmalloc+0xa9/0x130 mm/kmsan/kmsan_hooks.c:173
  kmsan_slab_alloc+0xe/0x10 mm/kmsan/kmsan_hooks.c:182
  slab_post_alloc_hook mm/slab.h:441 [inline]
  slab_alloc_node mm/slub.c:2771 [inline]
  __kmalloc_node_track_caller+0xead/0x1000 mm/slub.c:4396
  __kmalloc_reserve net/core/skbuff.c:140 [inline]
  __alloc_skb+0x309/0xa20 net/core/skbuff.c:208
  alloc_skb include/linux/skbuff.h:1059 [inline]
  __ip_append_data+0x3671/0x5000 net/ipv4/ip_output.c:1005
  ip_append_data+0x324/0x480 net/ipv4/ip_output.c:1220
  raw_sendmsg+0x2d2a/0x4650 net/ipv4/raw.c:670
  inet_sendmsg+0x54a/0x720 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:622 [inline]
  sock_sendmsg net/socket.c:632 [inline]
  ___sys_sendmsg+0xdb3/0x1220 net/socket.c:2137
  __sys_sendmmsg+0x580/0xad0 net/socket.c:2232
  __do_sys_sendmmsg net/socket.c:2261 [inline]
  __se_sys_sendmmsg+0xbd/0xe0 net/socket.c:2258
  __x64_sys_sendmmsg+0x56/0x70 net/socket.c:2258
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
