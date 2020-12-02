Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766702CBC8A
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgLBML5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:11:57 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:49302 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgLBML4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:11:56 -0500
Received: by mail-io1-f69.google.com with SMTP id v15so1051301ioq.16
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 04:11:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=QqPpHQA1fIJqu0PfLlY2cR0fVGR5zz5fFdnTFoGskKA=;
        b=aTagdFfqKAbmiStt294gQpsOEKvIFr1ICuMs08dTclOexfr1+MrOxd2HwJvRla3Z3p
         tP7HFr7rOLdW8gxELbYvl+/MJ3AYyRlHASKwhQzoCcCgJuljKCy/Dk62uy7nSosABYSB
         kpPTN1mRc0IxAH4QhuLiKlK22ld0pfFXdjpw95pVlKEcVSl/xsCI7xWc3w3/qzQedsPF
         NZEort9HK8nc4qCrrhEXI6iPnAOUz2pVQA/JPEegUkQR1TQedTLOL9w/zn4zK7a/20C6
         2K9JJ5yTNW8fzOoJmV2UrXKqKnTZod2xYQtQnrB5e9e7+SxlwqzU3Hp9NW9S06CbgEEY
         1odA==
X-Gm-Message-State: AOAM530sCtwu0M2gA0eMozGao7Kkvv0w4Sg+5CAgAXj35qkY+i3v5m2/
        /3y75dOlndODMqui3Unv53105+BrYsqxwJBekbxlN83H7RDi
X-Google-Smtp-Source: ABdhPJwMtjOMoTWIbg5jcEX6WRpa7LmP3exVpQtgwSotWBQX0/eTE3eZI0eWrlVps9dkgqS4oIHkV1xf2fhoNgFVOpC8x7rz1URd
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2dcf:: with SMTP id l15mr1581967iow.120.1606911075661;
 Wed, 02 Dec 2020 04:11:15 -0800 (PST)
Date:   Wed, 02 Dec 2020 04:11:15 -0800
In-Reply-To: <000000000000f3ffc205acd7cd06@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d9bf1205b57a23f6@google.com>
Subject: Re: KMSAN: uninit-value in __skb_checksum_complete (5)
From:   syzbot <syzbot+b024befb3ca7990fea37@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        glider@google.com, kadlec@netfilter.org, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    73d62e81 kmsan: random: prevent boot-time reports in _mix_..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=13bd4607500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eef728deea880383
dashboard link: https://syzkaller.appspot.com/bug?extid=b024befb3ca7990fea37
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126c8379500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17cdf7b5500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b024befb3ca7990fea37@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __skb_checksum_complete+0x421/0x630 net/core/skbuff.c:2846
CPU: 0 PID: 497 Comm: kworker/u4:11 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 __skb_checksum_complete+0x421/0x630 net/core/skbuff.c:2846
 __skb_checksum_validate_complete include/linux/skbuff.h:4014 [inline]
 icmp_rcv+0x94b/0x1d70 net/ipv4/icmp.c:1081
 ip_protocol_deliver_rcu+0x572/0xc50 net/ipv4/ip_input.c:204
 ip_local_deliver_finish net/ipv4/ip_input.c:231 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_local_deliver+0x583/0x8d0 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:449 [inline]
 ip_rcv_finish net/ipv4/ip_input.c:428 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_rcv+0x5c3/0x840 net/ipv4/ip_input.c:539
 __netif_receive_skb_one_core net/core/dev.c:5315 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5429
 process_backlog+0x523/0xc10 net/core/dev.c:6319
 napi_poll+0x420/0x1010 net/core/dev.c:6763
 net_rx_action+0x35c/0xd40 net/core/dev.c:6833
 __do_softirq+0x1a9/0x6fa kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0x6e/0x90 arch/x86/kernel/irq_64.c:77
 do_softirq kernel/softirq.c:343 [inline]
 __local_bh_enable_ip+0x184/0x1d0 kernel/softirq.c:195
 local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
 rcu_read_unlock_bh include/linux/rcupdate.h:730 [inline]
 __dev_queue_xmit+0x3a9b/0x4520 net/core/dev.c:4167
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4173
 batadv_send_skb_packet+0x622/0x970 net/batman-adv/send.c:108
 batadv_send_broadcast_skb+0x76/0x90 net/batman-adv/send.c:127
 batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:394 [inline]
 batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:420 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0xb3a/0xf00 net/batman-adv/bat_iv_ogm.c:1712
 process_one_work+0x121c/0x1fc0 kernel/workqueue.c:2272
 worker_thread+0x10cc/0x2740 kernel/workqueue.c:2418
 kthread+0x51c/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 kmsan_memcpy_memmove_metadata+0x25e/0x2d0 mm/kmsan/kmsan.c:226
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:246
 __msan_memcpy+0x46/0x60 mm/kmsan/kmsan_instr.c:110
 csum_partial_copy_nocheck include/net/checksum.h:51 [inline]
 skb_copy_and_csum_bits+0x23e/0x13e0 net/core/skbuff.c:2733
 icmp_glue_bits+0x155/0x400 net/ipv4/icmp.c:356
 __ip_append_data+0x4f8e/0x6210 net/ipv4/ip_output.c:1139
 ip_append_data+0x326/0x490 net/ipv4/ip_output.c:1323
 icmp_push_reply+0x1f8/0x810 net/ipv4/icmp.c:374
 __icmp_send+0x2a98/0x3a90 net/ipv4/icmp.c:762
 icmp_send include/net/icmp.h:43 [inline]
 __udp4_lib_rcv+0x421f/0x5880 net/ipv4/udp.c:2405
 udp_rcv+0x5c/0x70 net/ipv4/udp.c:2564
 ip_protocol_deliver_rcu+0x572/0xc50 net/ipv4/ip_input.c:204
 ip_local_deliver_finish net/ipv4/ip_input.c:231 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_local_deliver+0x583/0x8d0 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:449 [inline]
 ip_rcv_finish net/ipv4/ip_input.c:428 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_rcv+0x5c3/0x840 net/ipv4/ip_input.c:539
 __netif_receive_skb_one_core net/core/dev.c:5315 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5429
 process_backlog+0x523/0xc10 net/core/dev.c:6319
 napi_poll+0x420/0x1010 net/core/dev.c:6763
 net_rx_action+0x35c/0xd40 net/core/dev.c:6833
 __do_softirq+0x1a9/0x6fa kernel/softirq.c:298

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 kmsan_memcpy_memmove_metadata+0x25e/0x2d0 mm/kmsan/kmsan.c:226
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:246
 __msan_memcpy+0x46/0x60 mm/kmsan/kmsan_instr.c:110
 pskb_expand_head+0x3eb/0x1df0 net/core/skbuff.c:1631
 __skb_cow include/linux/skbuff.h:3165 [inline]
 skb_cow_head include/linux/skbuff.h:3199 [inline]
 batadv_skb_head_push+0x2ce/0x410 net/batman-adv/soft-interface.c:75
 batadv_send_skb_packet+0x1ed/0x970 net/batman-adv/send.c:86
 batadv_send_broadcast_skb+0x76/0x90 net/batman-adv/send.c:127
 batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:394 [inline]
 batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:420 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0xb3a/0xf00 net/batman-adv/bat_iv_ogm.c:1712
 process_one_work+0x121c/0x1fc0 kernel/workqueue.c:2272
 worker_thread+0x10cc/0x2740 kernel/workqueue.c:2418
 kthread+0x51c/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:121
 kmsan_alloc_page+0xd3/0x1f0 mm/kmsan/kmsan_shadow.c:274
 __alloc_pages_nodemask+0x84e/0xfb0 mm/page_alloc.c:4989
 __alloc_pages include/linux/gfp.h:511 [inline]
 __alloc_pages_node include/linux/gfp.h:524 [inline]
 alloc_pages_node include/linux/gfp.h:538 [inline]
 __page_frag_cache_refill mm/page_alloc.c:5065 [inline]
 page_frag_alloc+0x35b/0x890 mm/page_alloc.c:5095
 __napi_alloc_skb+0x1c0/0xab0 net/core/skbuff.c:519
 napi_alloc_skb include/linux/skbuff.h:2870 [inline]
 page_to_skb+0x142/0x1640 drivers/net/virtio_net.c:389
 receive_mergeable+0xee6/0x5be0 drivers/net/virtio_net.c:949
 receive_buf+0x2db/0x2ba0 drivers/net/virtio_net.c:1059
 virtnet_receive drivers/net/virtio_net.c:1351 [inline]
 virtnet_poll+0xa51/0x1d10 drivers/net/virtio_net.c:1456
 napi_poll+0x420/0x1010 net/core/dev.c:6763
 net_rx_action+0x35c/0xd40 net/core/dev.c:6833
 __do_softirq+0x1a9/0x6fa kernel/softirq.c:298
=====================================================

