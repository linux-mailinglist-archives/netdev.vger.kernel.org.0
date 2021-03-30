Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB63E34E90D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbhC3N0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:26:45 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:42317 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbhC3N0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 09:26:21 -0400
Received: by mail-il1-f198.google.com with SMTP id f4so8418781ilj.9
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 06:26:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yCd+Hfl80LN5BCKjCkkfSE23KR1n57lste6JoMSf5pc=;
        b=bqVzsrLQovlrPZTJUg8izr/V9G2g9ePxD8pdkeVPLhbWIXEWcqKxcf4p0jlj2fpBr6
         3WgoKLJrDbyusqFipUKKkS1VJeggTca3DdqdL6rpR97+JT5Y2jr1BdH3yUnAjRkm81l3
         qviO4U9ls/eSNMSoR8mJaOzvF65nJdR4GBO+Fwc6OrxGt9YKbbRdCvJ2l3oaZAvbta7q
         rgyz93tQOkAw87VDCtL7hdbBihTdylJmH1o3SwW6GQlHD2ECNDm3nHcJ4IKMvwXFxz+w
         fiSQqQp/TjQbhhRvir7Qbxkeh6hOkCC/4R/zWUNIlskEtRtEgjSTKcY7UzuFiIUbw5gY
         /Eag==
X-Gm-Message-State: AOAM530md9+tLcBkHMN+jvN0DZsb49sVP8r7OGAR68PVVwLesc2uEi9q
        1SFexPAtKi0LtoRvwKd66/FoSRI0mVlVUdpTQxISfu5IZ5PA
X-Google-Smtp-Source: ABdhPJw8Mer60mvRAwGBfLM9qexOORx3upAe0NXsf6zLsCtLJxPSc0BAgcn0GXq38jOZXhEtQ1LLkqIPDU4ZuEzzBjpjRjM8AIor
MIME-Version: 1.0
X-Received: by 2002:a6b:b251:: with SMTP id b78mr24123601iof.95.1617110778508;
 Tue, 30 Mar 2021 06:26:18 -0700 (PDT)
Date:   Tue, 30 Mar 2021 06:26:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000083f82005bec0f1ad@google.com>
Subject: [syzbot] KMSAN: uninit-value in INET_ECN_decapsulate (2)
From:   syzbot <syzbot+5e9c61d74e52a82b8ace@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    29ad81a1 arch/x86: add missing include to sparsemem.h
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=166fe481d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b573c14b733efb1c
dashboard link: https://syzkaller.appspot.com/bug?extid=5e9c61d74e52a82b8ace
compiler:       Debian clang version 11.0.1-2
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5e9c61d74e52a82b8ace@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __INET_ECN_decapsulate include/net/inet_ecn.h:236 [inline]
BUG: KMSAN: uninit-value in INET_ECN_decapsulate+0x329/0x1db0 include/net/inet_ecn.h:258
CPU: 1 PID: 9058 Comm: syz-executor.1 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 __INET_ECN_decapsulate include/net/inet_ecn.h:236 [inline]
 INET_ECN_decapsulate+0x329/0x1db0 include/net/inet_ecn.h:258
 geneve_rx+0x216e/0x29d0 include/net/inet_ecn.h:304
 geneve_udp_encap_recv+0x1055/0x1340 drivers/net/geneve.c:377
 udp_queue_rcv_one_skb+0x1943/0x1af0 net/ipv4/udp.c:2095
 udp_queue_rcv_skb+0x286/0x1040 net/ipv4/udp.c:2169
 udp_unicast_rcv_skb net/ipv4/udp.c:2327 [inline]
 __udp4_lib_rcv+0x3a1f/0x58f0 net/ipv4/udp.c:2396
 udp_rcv+0x5c/0x70 net/ipv4/udp.c:2567
 ip_protocol_deliver_rcu+0x572/0xc50 net/ipv4/ip_input.c:204
 ip_local_deliver_finish net/ipv4/ip_input.c:231 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_local_deliver+0x585/0x8d0 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:447 [inline]
 ip_rcv_finish net/ipv4/ip_input.c:428 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_rcv+0x599/0x820 net/ipv4/ip_input.c:539
 __netif_receive_skb_one_core net/core/dev.c:5323 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5437
 process_backlog+0x517/0xbd0 net/core/dev.c:6328
 napi_poll+0x428/0x15c0 net/core/dev.c:6806
 net_rx_action+0x34c/0xd30 net/core/dev.c:6889
 __do_softirq+0x1b9/0x715 kernel/softirq.c:343
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0x6e/0x90 arch/x86/kernel/irq_64.c:77
 do_softirq kernel/softirq.c:246 [inline]
 __local_bh_enable_ip+0x184/0x1d0 kernel/softirq.c:196
 local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
 rcu_read_unlock_bh include/linux/rcupdate.h:737 [inline]
 __dev_queue_xmit+0x3b3e/0x45c0 net/core/dev.c:4178
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4184
 packet_snd net/packet/af_packet.c:3006 [inline]
 packet_sendmsg+0x8778/0x9a60 net/packet/af_packet.c:3031
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 __sys_sendto+0x9ea/0xc60 net/socket.c:1975
 __do_sys_sendto net/socket.c:1987 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:1983
 __ia32_sys_sendto+0x6e/0x90 net/socket.c:1983
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x102/0x160 arch/x86/entry/common.c:141
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:166
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:209
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f84549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f557e5fc EFLAGS: 00000296 ORIG_RAX: 0000000000000171
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020000980
RDX: 000000000000000e RSI: 0000000000000000 RDI: 00000000200002c0
RBP: 0000000000000014 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 alloc_skb_with_frags+0x1f3/0xc10 net/core/skbuff.c:5894
 sock_alloc_send_pskb+0xdc1/0xf90 net/core/sock.c:2348
 packet_alloc_skb net/packet/af_packet.c:2854 [inline]
 packet_snd net/packet/af_packet.c:2949 [inline]
 packet_sendmsg+0x6aab/0x9a60 net/packet/af_packet.c:3031
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 __sys_sendto+0x9ea/0xc60 net/socket.c:1975
 __do_sys_sendto net/socket.c:1987 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:1983
 __ia32_sys_sendto+0x6e/0x90 net/socket.c:1983
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x102/0x160 arch/x86/entry/common.c:141
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:166
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:209
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
