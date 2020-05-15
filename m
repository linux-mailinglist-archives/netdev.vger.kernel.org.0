Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FB51D4F55
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 15:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgEONgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 09:36:17 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:44655 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgEONgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 09:36:16 -0400
Received: by mail-il1-f200.google.com with SMTP id b8so2144887ilr.11
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 06:36:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=tmWgxPICzcyq48JmdJNpYrHTpVkuRalZAn+LO5vWeSw=;
        b=WaKk0usAULe+Q91VVIaYq8IbNJKVikQ/JcMqzufTbNE/9QszLBVuAULDq35Y5CNevl
         ukfckpRxPbXEupXMXarkjj5UVWaSk1iwH69vzUgc0oIsSTj8g9oFckevVnbvvYT1JBQO
         VHzK19UsWV11iCmv1KffJIVIN/QP/sRK2tFcmpYVBXdc1HW2F4vJhbfo0mJHSHflwbYI
         eii9UusLj0sGuUFKzApFdm8K/bO6ZVAbygyaR09p4omqNC3JHCZvbiN0nW+QQvVCA/Sh
         /jrWkaGvjc2zzLaIk4YpQdvGZf6zPXraw1NdmrJKU80batn7FR4fl6KoW4AurLs336RJ
         7LYw==
X-Gm-Message-State: AOAM532Ovt/wZwkW+780l9Wdv6sJ/th6xNka6VR3dWc3RpTXbMw7ENXu
        i6xC6t3CtohVo+ifz91QPCVGwf4gizPY1JGzkl2LREkhwvR0
X-Google-Smtp-Source: ABdhPJwGq5Hzcz/7b3zbnRJSKX9fmii7bXab8ueIXy9KCP0sqBwAwkOilUBT3ZQx8H1oUJVgtD5oHe7+MleeIrOnhVFCWEt+SHMg
MIME-Version: 1.0
X-Received: by 2002:a5e:c203:: with SMTP id v3mr3077147iop.152.1589549774831;
 Fri, 15 May 2020 06:36:14 -0700 (PDT)
Date:   Fri, 15 May 2020 06:36:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ae936d05a5afe5fc@google.com>
Subject: KMSAN: uninit-value in nf_ip6_checksum
From:   syzbot <syzbot+266e61dcc3259a67d5ec@syzkaller.appspotmail.com>
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

syzbot found the following crash on:

HEAD commit:    8b97c627 kmsan: drop the opportunity to ignore pages
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=17830eac100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6f048d804e1a47a0
dashboard link: https://syzkaller.appspot.com/bug?extid=266e61dcc3259a67d5ec
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+266e61dcc3259a67d5ec@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in nf_ip6_checksum+0x58d/0x610 net/netfilter/utils.c:74
CPU: 1 PID: 16 Comm: ksoftirqd/1 Not tainted 5.7.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 nf_ip6_checksum+0x58d/0x610 net/netfilter/utils.c:74
 nf_nat_icmpv6_reply_translation+0x24b/0x10c0 net/netfilter/nf_nat_proto.c:802
 nf_nat_ipv6_fn+0x394/0x4d0 net/netfilter/nf_nat_proto.c:875
 nf_nat_ipv6_in+0x126/0x3c0 net/netfilter/nf_nat_proto.c:894
 nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
 nf_hook_slow+0x16e/0x400 net/netfilter/core.c:512
 nf_hook include/linux/netfilter.h:262 [inline]
 NF_HOOK include/linux/netfilter.h:305 [inline]
 ipv6_rcv+0x273/0x710 net/ipv6/ip6_input.c:307
 __netif_receive_skb_one_core net/core/dev.c:5188 [inline]
 __netif_receive_skb net/core/dev.c:5302 [inline]
 process_backlog+0xa41/0x1410 net/core/dev.c:6134
 napi_poll net/core/dev.c:6572 [inline]
 net_rx_action+0x786/0x1aa0 net/core/dev.c:6640
 __do_softirq+0x311/0x83d kernel/softirq.c:293
 run_ksoftirqd+0x25/0x40 kernel/softirq.c:608
 smpboot_thread_fn+0x493/0x980 kernel/smpboot.c:165
 kthread+0x4b5/0x4f0 kernel/kthread.c:269
 ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:353

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 __msan_chain_origin+0x50/0x90 mm/kmsan/kmsan_instr.c:165
 __skb_checksum_complete+0x422/0x540 net/core/skbuff.c:2858
 nf_ip6_checksum+0x501/0x610 net/netfilter/utils.c:91
 nf_nat_icmpv6_reply_translation+0x24b/0x10c0 net/netfilter/nf_nat_proto.c:802
 nf_nat_ipv6_fn+0x394/0x4d0 net/netfilter/nf_nat_proto.c:875
 nf_nat_ipv6_local_fn+0xb0/0x690 net/netfilter/nf_nat_proto.c:948
 nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
 nf_hook_slow+0x16e/0x400 net/netfilter/core.c:512
 nf_hook include/linux/netfilter.h:262 [inline]
 __ip6_local_out+0x56d/0x750 net/ipv6/output_core.c:167
 ip6_local_out+0xa4/0x1d0 net/ipv6/output_core.c:177
 ip6_send_skb net/ipv6/ip6_output.c:1865 [inline]
 ip6_push_pending_frames+0x213/0x4f0 net/ipv6/ip6_output.c:1885
 icmpv6_push_pending_frames+0x674/0x6b0 net/ipv6/icmp.c:304
 icmp6_send+0x32a3/0x39d0 net/ipv6/icmp.c:617
 icmpv6_send+0xe4/0x110 net/ipv6/ip6_icmp.c:43
 ip6_link_failure+0x68/0x590 net/ipv6/route.c:2640
 dst_link_failure include/net/dst.h:418 [inline]
 ndisc_error_report+0x106/0x1a0 net/ipv6/ndisc.c:710
 neigh_invalidate+0x348/0x8d0 net/core/neighbour.c:993
 neigh_timer_handler+0xb1a/0x1530 net/core/neighbour.c:1080
 call_timer_fn+0x218/0x510 kernel/time/timer.c:1405
 expire_timers kernel/time/timer.c:1450 [inline]
 __run_timers+0xcff/0x1210 kernel/time/timer.c:1774
 run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1787
 __do_softirq+0x311/0x83d kernel/softirq.c:293

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 csum_partial_copy+0xae/0x100 lib/checksum.c:174
 skb_copy_and_csum_bits+0x227/0x1130 net/core/skbuff.c:2737
 icmpv6_getfrag+0x15f/0x350 net/ipv6/icmp.c:319
 __ip6_append_data+0x50d7/0x63e0 net/ipv6/ip6_output.c:1623
 ip6_append_data+0x3cb/0x660 net/ipv6/ip6_output.c:1757
 icmp6_send+0x306a/0x39d0 net/ipv6/icmp.c:609
 icmpv6_send+0xe4/0x110 net/ipv6/ip6_icmp.c:43
 ip6_link_failure+0x68/0x590 net/ipv6/route.c:2640
 dst_link_failure include/net/dst.h:418 [inline]
 ndisc_error_report+0x106/0x1a0 net/ipv6/ndisc.c:710
 neigh_invalidate+0x348/0x8d0 net/core/neighbour.c:993
 neigh_timer_handler+0xb1a/0x1530 net/core/neighbour.c:1080
 call_timer_fn+0x218/0x510 kernel/time/timer.c:1405
 expire_timers kernel/time/timer.c:1450 [inline]
 __run_timers+0xcff/0x1210 kernel/time/timer.c:1774
 run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1787
 __do_softirq+0x311/0x83d kernel/softirq.c:293

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 pskb_expand_head+0x38b/0x1b00 net/core/skbuff.c:1636
 __skb_cow include/linux/skbuff.h:3171 [inline]
 skb_cow_head include/linux/skbuff.h:3205 [inline]
 geneve_build_skb+0x4c0/0xe00 drivers/net/geneve.c:754
 geneve6_xmit_skb drivers/net/geneve.c:969 [inline]
 geneve_xmit+0x1b21/0x2c20 drivers/net/geneve.c:1001
 __netdev_start_xmit include/linux/netdevice.h:4533 [inline]
 netdev_start_xmit include/linux/netdevice.h:4547 [inline]
 xmit_one net/core/dev.c:3477 [inline]
 dev_hard_start_xmit+0x531/0xab0 net/core/dev.c:3493
 __dev_queue_xmit+0x2f8d/0x3b20 net/core/dev.c:4052
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4085
 batadv_send_skb_packet+0x59b/0x8c0 net/batman-adv/send.c:108
 batadv_send_broadcast_skb+0x76/0x90 net/batman-adv/send.c:127
 batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:393 [inline]
 batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:419 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0x97e/0xd50 net/batman-adv/bat_iv_ogm.c:1710
 process_one_work+0x1555/0x1f40 kernel/workqueue.c:2268
 worker_thread+0xef6/0x2450 kernel/workqueue.c:2414
 kthread+0x4b5/0x4f0 kernel/kthread.c:269
 ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:353

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 pskb_expand_head+0x38b/0x1b00 net/core/skbuff.c:1636
 __skb_cow include/linux/skbuff.h:3171 [inline]
 skb_cow_head include/linux/skbuff.h:3205 [inline]
 batadv_skb_head_push+0x234/0x350 net/batman-adv/soft-interface.c:74
 batadv_send_skb_packet+0x1a7/0x8c0 net/batman-adv/send.c:86
 batadv_send_broadcast_skb+0x76/0x90 net/batman-adv/send.c:127
 batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:393 [inline]
 batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:419 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0x97e/0xd50 net/batman-adv/bat_iv_ogm.c:1710
 process_one_work+0x1555/0x1f40 kernel/workqueue.c:2268
 worker_thread+0xef6/0x2450 kernel/workqueue.c:2414
 kthread+0x4b5/0x4f0 kernel/kthread.c:269
 ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:353

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:144
 kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:269 [inline]
 kmsan_alloc_page+0xb9/0x180 mm/kmsan/kmsan_shadow.c:293
 __alloc_pages_nodemask+0x56a2/0x5dc0 mm/page_alloc.c:4848
 __alloc_pages include/linux/gfp.h:504 [inline]
 __alloc_pages_node include/linux/gfp.h:517 [inline]
 alloc_pages_node include/linux/gfp.h:531 [inline]
 __page_frag_cache_refill mm/page_alloc.c:4923 [inline]
 page_frag_alloc+0x3ae/0x910 mm/page_alloc.c:4953
 __netdev_alloc_skb+0x703/0xbb0 net/core/skbuff.c:456
 __netdev_alloc_skb_ip_align include/linux/skbuff.h:2852 [inline]
 netdev_alloc_skb_ip_align include/linux/skbuff.h:2862 [inline]
 batadv_iv_ogm_aggregate_new net/batman-adv/bat_iv_ogm.c:558 [inline]
 batadv_iv_ogm_queue_add+0x10da/0x1900 net/batman-adv/bat_iv_ogm.c:670
 batadv_iv_ogm_schedule_buff net/batman-adv/bat_iv_ogm.c:849 [inline]
 batadv_iv_ogm_schedule+0x10cb/0x1430 net/batman-adv/bat_iv_ogm.c:869
 batadv_iv_send_outstanding_bat_ogm_packet+0xbae/0xd50 net/batman-adv/bat_iv_ogm.c:1722
 process_one_work+0x1555/0x1f40 kernel/workqueue.c:2268
 worker_thread+0xef6/0x2450 kernel/workqueue.c:2414
 kthread+0x4b5/0x4f0 kernel/kthread.c:269
 ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:353
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
