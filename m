Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA71F8F77
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKLMOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:14:08 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:37987 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfKLMOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:14:08 -0500
Received: by mail-il1-f200.google.com with SMTP id f6so19775542ilg.5
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 04:14:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=sLQVy0wHNgrrvXHOJoKgmqY97Gox0lEP0K7KxqsGea0=;
        b=OXYHV0rXQWV+QNiZXNsWIWTjEsCRfdQ5liS7MU7Ef6CSUsMhA7NVgV2r50pJJK6JNj
         Z96lKR2Re4+AEn6J2irIAvCAo96zawzgmK3YjgeUA8cLDJo7BFaB/fwW9Nr6P/sKQ/KE
         HWPEmEpswCISi5oOvK5qWx9pJd5s7VPYsM561J7Ff+8NRiSxHRxFpgiN4Q/Sh2jqXUvp
         hVUFwrqvKaFcUusGy/9TgwYjHsO+Dz6u3DSooLCHYoQj8VrexPZ4D01gGCQ0F5q0r/dy
         krPfOCkjvDEs4jdMquC5pZv5uK2hukyDcT5xs36Ln+M2BEeuR+fb2e9ak6q+/v3XGdxA
         cQ8Q==
X-Gm-Message-State: APjAAAWLY+eoGhzg6epmo/MvOkTzFqm9zoWaZF4jU8i0krWuK8krg9F5
        Dc77xKXcjzomSAnYp9f7aOV/7BcKt+2lgE+CcvBajhSMu1ey
X-Google-Smtp-Source: APXvYqzUVPQwEZuSHWrKZitQChADIZ95Q4zEdiIUrjKvsymskCsNRquCzM8X17yJiG7NsoQfUhuJLDYuP+IQ0CJkT+W5XkpnXNd6
MIME-Version: 1.0
X-Received: by 2002:a92:104a:: with SMTP id y71mr34841674ill.220.1573560846930;
 Tue, 12 Nov 2019 04:14:06 -0800 (PST)
Date:   Tue, 12 Nov 2019 04:14:06 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005062e00597252f5e@google.com>
Subject: KMSAN: uninit-value in __flow_hash_from_keys (2)
From:   syzbot <syzbot+3bfc4436d26db9a5ca18@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, glider@google.com, jianbol@mellanox.com,
        jiri@mellanox.com, kafai@fb.com, linux-kernel@vger.kernel.org,
        mkubecek@suse.cz, netdev@vger.kernel.org, ogerlitz@mellanox.com,
        pabeni@redhat.com, ppenkov@google.com, sdf@google.com,
        simon.horman@netronome.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, zhongjiang@huawei.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    088c01ea kmsan: fix comment, NFC
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1556e137200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=68044283f8b8640d
dashboard link: https://syzkaller.appspot.com/bug?extid=3bfc4436d26db9a5ca18
compiler:       clang version 8.0.0 (trunk 350509)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3bfc4436d26db9a5ca18@syzkaller.appspotmail.com

==================================================================
BUG: KMSAN: uninit-value in __flow_hash_consistentify  
net/core/flow_dissector.c:1318 [inline]
BUG: KMSAN: uninit-value in __flow_hash_from_keys+0x544/0x1070  
net/core/flow_dissector.c:1347
CPU: 0 PID: 14493 Comm: syz-executor.2 Not tainted 5.1.0-rc2+ #21
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x173/0x1d0 lib/dump_stack.c:113
  kmsan_report+0x131/0x2a0 mm/kmsan/kmsan.c:624
  __msan_warning+0x7a/0xf0 mm/kmsan/kmsan_instr.c:310
  __flow_hash_consistentify net/core/flow_dissector.c:1318 [inline]
  __flow_hash_from_keys+0x544/0x1070 net/core/flow_dissector.c:1347
  ___skb_get_hash net/core/flow_dissector.c:1370 [inline]
  __skb_get_hash+0x16d/0x3e0 net/core/flow_dissector.c:1433
  skb_get_hash include/linux/skbuff.h:1326 [inline]
  ip_tunnel_xmit+0x99c/0x3310 net/ipv4/ip_tunnel.c:750
  __gre_xmit net/ipv4/ip_gre.c:444 [inline]
  gre_tap_xmit+0xaa5/0xbb0 net/ipv4/ip_gre.c:707
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
  br_dev_queue_push_xmit+0x803/0x8b0 net/bridge/br_forward.c:56
  NF_HOOK include/linux/netfilter.h:289 [inline]
  br_forward_finish net/bridge/br_forward.c:69 [inline]
  NF_HOOK include/linux/netfilter.h:289 [inline]
  __br_forward+0xa58/0xe10 net/bridge/br_forward.c:113
  deliver_clone net/bridge/br_forward.c:129 [inline]
  maybe_deliver net/bridge/br_forward.c:184 [inline]
  br_flood+0xc65/0x10b0 net/bridge/br_forward.c:226
  br_dev_xmit+0x1610/0x16a0 net/bridge/br_device.c:99
  __netdev_start_xmit include/linux/netdevice.h:4411 [inline]
  netdev_start_xmit include/linux/netdevice.h:4420 [inline]
  xmit_one net/core/dev.c:3278 [inline]
  dev_hard_start_xmit+0x604/0xc40 net/core/dev.c:3294
  __dev_queue_xmit+0x2e9f/0x3ce0 net/core/dev.c:3864
  dev_queue_xmit+0x4b/0x60 net/core/dev.c:3897
  neigh_resolve_output+0xab7/0xb40 net/core/neighbour.c:1487
  neigh_output include/net/neighbour.h:508 [inline]
  ip_finish_output2+0x1709/0x1930 net/ipv4/ip_output.c:229
  ip_finish_output+0xd2b/0xfd0 net/ipv4/ip_output.c:317
  NF_HOOK_COND include/linux/netfilter.h:278 [inline]
  ip_output+0x53f/0x610 net/ipv4/ip_output.c:405
  dst_output include/net/dst.h:444 [inline]
  ip_local_out+0x164/0x1d0 net/ipv4/ip_output.c:124
  iptunnel_xmit+0x8a7/0xde0 net/ipv4/ip_tunnel_core.c:91
  ip_tunnel_xmit+0x2f46/0x3310 net/ipv4/ip_tunnel.c:831
  __gre_xmit net/ipv4/ip_gre.c:444 [inline]
  ipgre_xmit+0x1098/0x11c0 net/ipv4/ip_gre.c:628
  __netdev_start_xmit include/linux/netdevice.h:4411 [inline]
  netdev_start_xmit include/linux/netdevice.h:4420 [inline]
  xmit_one net/core/dev.c:3278 [inline]
  dev_hard_start_xmit+0x604/0xc40 net/core/dev.c:3294
  __dev_queue_xmit+0x2e9f/0x3ce0 net/core/dev.c:3864
  dev_queue_xmit+0x4b/0x60 net/core/dev.c:3897
  packet_snd net/packet/af_packet.c:2931 [inline]
  packet_sendmsg+0x80f5/0x8ff0 net/packet/af_packet.c:2956
  sock_sendmsg_nosec net/socket.c:622 [inline]
  sock_sendmsg net/socket.c:632 [inline]
  ___sys_sendmsg+0xdb3/0x1220 net/socket.c:2137
  __sys_sendmsg net/socket.c:2175 [inline]
  __do_sys_sendmsg net/socket.c:2184 [inline]
  __se_sys_sendmsg+0x305/0x460 net/socket.c:2182
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2182
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x458209
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007febe94fac78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000458209
RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 000000000073bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007febe94fb6d4
R13: 00000000004c581a R14: 00000000004d9ad8 R15: 00000000ffffffff

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:205 [inline]
  kmsan_save_stack mm/kmsan/kmsan.c:220 [inline]
  kmsan_internal_chain_origin+0x134/0x230 mm/kmsan/kmsan.c:426
  kmsan_memcpy_memmove_metadata+0xb5b/0xfe0 mm/kmsan/kmsan.c:304
  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:324
  __msan_memcpy+0x58/0x70 mm/kmsan/kmsan_instr.c:139
  __skb_flow_dissect+0x3303/0x7570 net/core/flow_dissector.c:856
  skb_flow_dissect_flow_keys include/linux/skbuff.h:1303 [inline]
  ___skb_get_hash net/core/flow_dissector.c:1367 [inline]
  __skb_get_hash+0x142/0x3e0 net/core/flow_dissector.c:1433
  skb_get_hash include/linux/skbuff.h:1326 [inline]
  ip_tunnel_xmit+0x99c/0x3310 net/ipv4/ip_tunnel.c:750
  __gre_xmit net/ipv4/ip_gre.c:444 [inline]
  gre_tap_xmit+0xaa5/0xbb0 net/ipv4/ip_gre.c:707
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
  br_dev_queue_push_xmit+0x803/0x8b0 net/bridge/br_forward.c:56
  NF_HOOK include/linux/netfilter.h:289 [inline]
  br_forward_finish net/bridge/br_forward.c:69 [inline]
  NF_HOOK include/linux/netfilter.h:289 [inline]
  __br_forward+0xa58/0xe10 net/bridge/br_forward.c:113
  deliver_clone net/bridge/br_forward.c:129 [inline]
  maybe_deliver net/bridge/br_forward.c:184 [inline]
  br_flood+0xc65/0x10b0 net/bridge/br_forward.c:226
  br_dev_xmit+0x1610/0x16a0 net/bridge/br_device.c:99
  __netdev_start_xmit include/linux/netdevice.h:4411 [inline]
  netdev_start_xmit include/linux/netdevice.h:4420 [inline]
  xmit_one net/core/dev.c:3278 [inline]
  dev_hard_start_xmit+0x604/0xc40 net/core/dev.c:3294
  __dev_queue_xmit+0x2e9f/0x3ce0 net/core/dev.c:3864
  dev_queue_xmit+0x4b/0x60 net/core/dev.c:3897
  neigh_resolve_output+0xab7/0xb40 net/core/neighbour.c:1487
  neigh_output include/net/neighbour.h:508 [inline]
  ip_finish_output2+0x1709/0x1930 net/ipv4/ip_output.c:229
  ip_finish_output+0xd2b/0xfd0 net/ipv4/ip_output.c:317
  NF_HOOK_COND include/linux/netfilter.h:278 [inline]
  ip_output+0x53f/0x610 net/ipv4/ip_output.c:405
  dst_output include/net/dst.h:444 [inline]
  ip_local_out+0x164/0x1d0 net/ipv4/ip_output.c:124
  iptunnel_xmit+0x8a7/0xde0 net/ipv4/ip_tunnel_core.c:91
  ip_tunnel_xmit+0x2f46/0x3310 net/ipv4/ip_tunnel.c:831
  __gre_xmit net/ipv4/ip_gre.c:444 [inline]
  ipgre_xmit+0x1098/0x11c0 net/ipv4/ip_gre.c:628
  __netdev_start_xmit include/linux/netdevice.h:4411 [inline]
  netdev_start_xmit include/linux/netdevice.h:4420 [inline]
  xmit_one net/core/dev.c:3278 [inline]
  dev_hard_start_xmit+0x604/0xc40 net/core/dev.c:3294
  __dev_queue_xmit+0x2e9f/0x3ce0 net/core/dev.c:3864
  dev_queue_xmit+0x4b/0x60 net/core/dev.c:3897
  packet_snd net/packet/af_packet.c:2931 [inline]
  packet_sendmsg+0x80f5/0x8ff0 net/packet/af_packet.c:2956
  sock_sendmsg_nosec net/socket.c:622 [inline]
  sock_sendmsg net/socket.c:632 [inline]
  ___sys_sendmsg+0xdb3/0x1220 net/socket.c:2137
  __sys_sendmsg net/socket.c:2175 [inline]
  __do_sys_sendmsg net/socket.c:2184 [inline]
  __se_sys_sendmsg+0x305/0x460 net/socket.c:2182
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2182
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

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
  gre_tap_xmit+0x7dd/0xbb0 net/ipv4/ip_gre.c:704
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
  br_dev_queue_push_xmit+0x803/0x8b0 net/bridge/br_forward.c:56
  NF_HOOK include/linux/netfilter.h:289 [inline]
  br_forward_finish net/bridge/br_forward.c:69 [inline]
  NF_HOOK include/linux/netfilter.h:289 [inline]
  __br_forward+0xa58/0xe10 net/bridge/br_forward.c:113
  deliver_clone net/bridge/br_forward.c:129 [inline]
  maybe_deliver net/bridge/br_forward.c:184 [inline]
  br_flood+0xc65/0x10b0 net/bridge/br_forward.c:226
  br_dev_xmit+0x1610/0x16a0 net/bridge/br_device.c:99
  __netdev_start_xmit include/linux/netdevice.h:4411 [inline]
  netdev_start_xmit include/linux/netdevice.h:4420 [inline]
  xmit_one net/core/dev.c:3278 [inline]
  dev_hard_start_xmit+0x604/0xc40 net/core/dev.c:3294
  __dev_queue_xmit+0x2e9f/0x3ce0 net/core/dev.c:3864
  dev_queue_xmit+0x4b/0x60 net/core/dev.c:3897
  neigh_resolve_output+0xab7/0xb40 net/core/neighbour.c:1487
  neigh_output include/net/neighbour.h:508 [inline]
  ip_finish_output2+0x1709/0x1930 net/ipv4/ip_output.c:229
  ip_finish_output+0xd2b/0xfd0 net/ipv4/ip_output.c:317
  NF_HOOK_COND include/linux/netfilter.h:278 [inline]
  ip_output+0x53f/0x610 net/ipv4/ip_output.c:405
  dst_output include/net/dst.h:444 [inline]
  ip_local_out+0x164/0x1d0 net/ipv4/ip_output.c:124
  iptunnel_xmit+0x8a7/0xde0 net/ipv4/ip_tunnel_core.c:91
  ip_tunnel_xmit+0x2f46/0x3310 net/ipv4/ip_tunnel.c:831
  __gre_xmit net/ipv4/ip_gre.c:444 [inline]
  ipgre_xmit+0x1098/0x11c0 net/ipv4/ip_gre.c:628
  __netdev_start_xmit include/linux/netdevice.h:4411 [inline]
  netdev_start_xmit include/linux/netdevice.h:4420 [inline]
  xmit_one net/core/dev.c:3278 [inline]
  dev_hard_start_xmit+0x604/0xc40 net/core/dev.c:3294
  __dev_queue_xmit+0x2e9f/0x3ce0 net/core/dev.c:3864
  dev_queue_xmit+0x4b/0x60 net/core/dev.c:3897
  packet_snd net/packet/af_packet.c:2931 [inline]
  packet_sendmsg+0x80f5/0x8ff0 net/packet/af_packet.c:2956
  sock_sendmsg_nosec net/socket.c:622 [inline]
  sock_sendmsg net/socket.c:632 [inline]
  ___sys_sendmsg+0xdb3/0x1220 net/socket.c:2137
  __sys_sendmsg net/socket.c:2175 [inline]
  __do_sys_sendmsg net/socket.c:2184 [inline]
  __se_sys_sendmsg+0x305/0x460 net/socket.c:2182
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2182
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

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
  ipgre_xmit+0x1098/0x11c0 net/ipv4/ip_gre.c:628
  __netdev_start_xmit include/linux/netdevice.h:4411 [inline]
  netdev_start_xmit include/linux/netdevice.h:4420 [inline]
  xmit_one net/core/dev.c:3278 [inline]
  dev_hard_start_xmit+0x604/0xc40 net/core/dev.c:3294
  __dev_queue_xmit+0x2e9f/0x3ce0 net/core/dev.c:3864
  dev_queue_xmit+0x4b/0x60 net/core/dev.c:3897
  packet_snd net/packet/af_packet.c:2931 [inline]
  packet_sendmsg+0x80f5/0x8ff0 net/packet/af_packet.c:2956
  sock_sendmsg_nosec net/socket.c:622 [inline]
  sock_sendmsg net/socket.c:632 [inline]
  ___sys_sendmsg+0xdb3/0x1220 net/socket.c:2137
  __sys_sendmsg net/socket.c:2175 [inline]
  __do_sys_sendmsg net/socket.c:2184 [inline]
  __se_sys_sendmsg+0x305/0x460 net/socket.c:2182
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2182
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
  alloc_skb_with_frags+0x186/0xa60 net/core/skbuff.c:5287
  sock_alloc_send_pskb+0xafd/0x10a0 net/core/sock.c:2220
  packet_alloc_skb net/packet/af_packet.c:2781 [inline]
  packet_snd net/packet/af_packet.c:2874 [inline]
  packet_sendmsg+0x6349/0x8ff0 net/packet/af_packet.c:2956
  sock_sendmsg_nosec net/socket.c:622 [inline]
  sock_sendmsg net/socket.c:632 [inline]
  ___sys_sendmsg+0xdb3/0x1220 net/socket.c:2137
  __sys_sendmsg net/socket.c:2175 [inline]
  __do_sys_sendmsg net/socket.c:2184 [inline]
  __se_sys_sendmsg+0x305/0x460 net/socket.c:2182
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2182
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
