Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0977C244BA4
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 17:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgHNPJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 11:09:21 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:45037 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgHNPJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 11:09:18 -0400
Received: by mail-il1-f199.google.com with SMTP id z15so6747077ile.11
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 08:09:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=3Dv/nNZ0R5QJf8EggrUkyhwJ6CWsJ93Cph1VJZyEMSA=;
        b=Fnl1cYIqZdMq/Ly+nbQlIZgYNG1N0G2ViEz0XE7Tis5aEWaDzWA0RCJjYLIlM9zizP
         mjgipGHCKBq3XnQ5GsHqSyCdAZk7yV+6z32hvwmZzenJenCj9u4ymuxIj59fwpm9BH3a
         WbiEuwRRSrYfkAyv+7WON+F6/+rupFxHdNNsEEV7zgfQuYp5MgRvoO2Qh3R3ijVTyUnn
         lcSI7qLGIUrV7VDf6aA3bY8I7y48c71fEIMpmpKTVQF8DxXpzIwLMxl9enQ1X5ZsmSe8
         qEcIMy9e4/vFVdEJVFkqlmxJqydiBK0c4rSzZeL7TUZCh74+QY3KmlOyFDkw8ECe6LH+
         igbQ==
X-Gm-Message-State: AOAM532SK92evXdBxXhcsdIuNfPzL0CJkDMBGouRlWtkc5D89M0gI5r5
        pWpKuOtJhBDxhg1bvLz4Y6AalL5CEOH4djo0LHIuZ36IHYpy
X-Google-Smtp-Source: ABdhPJz1ToDlQKsvW+vJGNVeQUMPYy/AB6pv4ykvLLnYnggx0X8IYBNzKvGeK02QiskysUT1ufVMK4NxeTEY2qdnQnEqVY6c19vl
MIME-Version: 1.0
X-Received: by 2002:a92:1589:: with SMTP id 9mr2904670ilv.234.1597417756817;
 Fri, 14 Aug 2020 08:09:16 -0700 (PDT)
Date:   Fri, 14 Aug 2020 08:09:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f3ffc205acd7cd06@google.com>
Subject: KMSAN: uninit-value in __skb_checksum_complete (5)
From:   syzbot <syzbot+b024befb3ca7990fea37@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        glider@google.com, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ce8056d1 wip: changed copy_from_user where instrumented
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=149f894a900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3afe005fb99591f
dashboard link: https://syzkaller.appspot.com/bug?extid=b024befb3ca7990fea37
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b024befb3ca7990fea37@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __skb_checksum_complete+0x425/0x630 net/core/skbuff.c:2850
CPU: 1 PID: 8705 Comm: kworker/u4:2 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 __skb_checksum_complete+0x425/0x630 net/core/skbuff.c:2850
 nf_ip6_checksum+0x565/0x670 net/netfilter/utils.c:91
 nf_nat_icmpv6_reply_translation+0x312/0x1360 net/netfilter/nf_nat_proto.c:800
 nf_nat_ipv6_fn+0x3c4/0x570 net/netfilter/nf_nat_proto.c:873
 nf_nat_ipv6_local_fn+0xaa/0x800 net/netfilter/nf_nat_proto.c:946
 nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
 nf_hook_slow+0x17b/0x460 net/netfilter/core.c:512
 nf_hook include/linux/netfilter.h:262 [inline]
 __ip6_local_out+0x696/0x7c0 net/ipv6/output_core.c:167
 ip6_local_out+0xa1/0x1e0 net/ipv6/output_core.c:177
 ip6_send_skb net/ipv6/ip6_output.c:1865 [inline]
 ip6_push_pending_frames+0x252/0x5b0 net/ipv6/ip6_output.c:1885
 icmpv6_push_pending_frames+0x6d1/0x710 net/ipv6/icmp.c:304
 icmp6_send+0x3979/0x40e0 net/ipv6/icmp.c:617
 icmpv6_send+0xdf/0x110 net/ipv6/ip6_icmp.c:43
 ip6_pkt_drop+0x906/0xa00 net/ipv6/route.c:4406
 ip6_pkt_discard_out+0xbb/0x130 net/ipv6/route.c:4419
 dst_output include/net/dst.h:443 [inline]
 ip6_local_out+0x17b/0x1e0 net/ipv6/output_core.c:179
 ip6tunnel_xmit include/net/ip6_tunnel.h:160 [inline]
 udp_tunnel6_xmit_skb+0x818/0xf80 net/ipv6/ip6_udp_tunnel.c:109
 geneve6_xmit_skb drivers/net/geneve.c:973 [inline]
 geneve_xmit+0x2b5d/0x3200 drivers/net/geneve.c:1002
 __netdev_start_xmit include/linux/netdevice.h:4611 [inline]
 netdev_start_xmit include/linux/netdevice.h:4625 [inline]
 xmit_one+0x3cf/0x750 net/core/dev.c:3556
 dev_hard_start_xmit net/core/dev.c:3572 [inline]
 __dev_queue_xmit+0x3aad/0x4470 net/core/dev.c:4131
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4164
 batadv_send_skb_packet+0x622/0x970 net/batman-adv/send.c:108
 batadv_send_broadcast_skb+0x76/0x90 net/batman-adv/send.c:127
 batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:393 [inline]
 batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:419 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0xb2e/0xef0 net/batman-adv/bat_iv_ogm.c:1710
 process_one_work+0x1688/0x2140 kernel/workqueue.c:2269
 worker_thread+0x10bc/0x2730 kernel/workqueue.c:2415
 kthread+0x551/0x590 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 csum_partial_copy+0xae/0x100 lib/checksum.c:154
 skb_copy_and_csum_bits+0x261/0x1360 net/core/skbuff.c:2737
 icmpv6_getfrag+0x148/0x3b0 net/ipv6/icmp.c:319
 __ip6_append_data+0x5a33/0x71b0 net/ipv6/ip6_output.c:1623
 ip6_append_data+0x44b/0x6e0 net/ipv6/ip6_output.c:1757
 icmp6_send+0x3711/0x40e0 net/ipv6/icmp.c:609
 icmpv6_send+0xdf/0x110 net/ipv6/ip6_icmp.c:43
 ip6_pkt_drop+0x906/0xa00 net/ipv6/route.c:4406
 ip6_pkt_discard_out+0xbb/0x130 net/ipv6/route.c:4419
 dst_output include/net/dst.h:443 [inline]
 ip6_local_out+0x17b/0x1e0 net/ipv6/output_core.c:179
 ip6tunnel_xmit include/net/ip6_tunnel.h:160 [inline]
 udp_tunnel6_xmit_skb+0x818/0xf80 net/ipv6/ip6_udp_tunnel.c:109
 geneve6_xmit_skb drivers/net/geneve.c:973 [inline]
 geneve_xmit+0x2b5d/0x3200 drivers/net/geneve.c:1002
 __netdev_start_xmit include/linux/netdevice.h:4611 [inline]
 netdev_start_xmit include/linux/netdevice.h:4625 [inline]
 xmit_one+0x3cf/0x750 net/core/dev.c:3556
 dev_hard_start_xmit net/core/dev.c:3572 [inline]
 __dev_queue_xmit+0x3aad/0x4470 net/core/dev.c:4131
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4164
 batadv_send_skb_packet+0x622/0x970 net/batman-adv/send.c:108
 batadv_send_broadcast_skb+0x76/0x90 net/batman-adv/send.c:127
 batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:393 [inline]
 batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:419 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0xb2e/0xef0 net/batman-adv/bat_iv_ogm.c:1710
 process_one_work+0x1688/0x2140 kernel/workqueue.c:2269
 worker_thread+0x10bc/0x2730 kernel/workqueue.c:2415
 kthread+0x551/0x590 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 pskb_expand_head+0x3fd/0x1e30 net/core/skbuff.c:1636
 __skb_cow include/linux/skbuff.h:3145 [inline]
 skb_cow_head include/linux/skbuff.h:3179 [inline]
 geneve_build_skb+0x575/0xf90 drivers/net/geneve.c:754
 geneve6_xmit_skb drivers/net/geneve.c:969 [inline]
 geneve_xmit+0x286c/0x3200 drivers/net/geneve.c:1002
 __netdev_start_xmit include/linux/netdevice.h:4611 [inline]
 netdev_start_xmit include/linux/netdevice.h:4625 [inline]
 xmit_one+0x3cf/0x750 net/core/dev.c:3556
 dev_hard_start_xmit net/core/dev.c:3572 [inline]
 __dev_queue_xmit+0x3aad/0x4470 net/core/dev.c:4131
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4164
 batadv_send_skb_packet+0x622/0x970 net/batman-adv/send.c:108
 batadv_send_broadcast_skb+0x76/0x90 net/batman-adv/send.c:127
 batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:393 [inline]
 batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:419 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0xb2e/0xef0 net/batman-adv/bat_iv_ogm.c:1710
 process_one_work+0x1688/0x2140 kernel/workqueue.c:2269
 worker_thread+0x10bc/0x2730 kernel/workqueue.c:2415
 kthread+0x551/0x590 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 pskb_expand_head+0x3fd/0x1e30 net/core/skbuff.c:1636
 __skb_cow include/linux/skbuff.h:3145 [inline]
 skb_cow_head include/linux/skbuff.h:3179 [inline]
 batadv_skb_head_push+0x2cc/0x410 net/batman-adv/soft-interface.c:75
 batadv_send_skb_packet+0x1ed/0x970 net/batman-adv/send.c:86
 batadv_send_broadcast_skb+0x76/0x90 net/batman-adv/send.c:127
 batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:393 [inline]
 batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:419 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0xb2e/0xef0 net/batman-adv/bat_iv_ogm.c:1710
 process_one_work+0x1688/0x2140 kernel/workqueue.c:2269
 worker_thread+0x10bc/0x2730 kernel/workqueue.c:2415
 kthread+0x551/0x590 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:144
 kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:269 [inline]
 kmsan_alloc_page+0xc5/0x1a0 mm/kmsan/kmsan_shadow.c:293
 __alloc_pages_nodemask+0xdf0/0x1030 mm/page_alloc.c:4889
 __alloc_pages include/linux/gfp.h:509 [inline]
 __alloc_pages_node include/linux/gfp.h:522 [inline]
 alloc_pages_node include/linux/gfp.h:536 [inline]
 __page_frag_cache_refill mm/page_alloc.c:4964 [inline]
 page_frag_alloc+0x35b/0x880 mm/page_alloc.c:4994
 __netdev_alloc_skb+0xc3d/0xc90 net/core/skbuff.c:456
 __netdev_alloc_skb_ip_align include/linux/skbuff.h:2826 [inline]
 netdev_alloc_skb_ip_align include/linux/skbuff.h:2836 [inline]
 batadv_iv_ogm_aggregate_new net/batman-adv/bat_iv_ogm.c:558 [inline]
 batadv_iv_ogm_queue_add+0x13bf/0x1c60 net/batman-adv/bat_iv_ogm.c:670
 batadv_iv_ogm_schedule_buff net/batman-adv/bat_iv_ogm.c:849 [inline]
 batadv_iv_ogm_schedule+0x126d/0x1660 net/batman-adv/bat_iv_ogm.c:869
 batadv_iv_send_outstanding_bat_ogm_packet+0xd69/0xef0 net/batman-adv/bat_iv_ogm.c:1722
 process_one_work+0x1688/0x2140 kernel/workqueue.c:2269
 worker_thread+0x10bc/0x2730 kernel/workqueue.c:2415
 kthread+0x551/0x590 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
