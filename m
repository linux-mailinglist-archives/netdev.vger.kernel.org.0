Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FBF2678BA
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 09:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgILH7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 03:59:23 -0400
Received: from mail-il1-f207.google.com ([209.85.166.207]:55519 "EHLO
        mail-il1-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgILH7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 03:59:21 -0400
Received: by mail-il1-f207.google.com with SMTP id a15so8817757ilb.22
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 00:59:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=K1eC26npFM21iPLw1juw36UDuBwQmF7YJQ6JoHuHm1A=;
        b=l0x1tRzlkeP4OX0YTjaI+ISl6Uvlvx1WBhVulwcafiCDmgSJ801tIyv0lZOnjOdrHE
         xk8RS4lpsDw6nVB6XQDqZesNF8cZKaeFN0y8zQI2YuoPPZj/bXdrsiZ6d1wZGkKS9/1L
         hYV6vWFsITUqRn1oOaZGXgIolvyW0ywPRVdbGncpKods8MfFtNMN9rkeZiQvutGtuUTR
         QcqGA/X+PQQjopOIcAHNzFV7cEuNEB21wCTt7OSDq0B2YJxW1maCmzDCwCdqSeNE3U9p
         mw1WEunu6gUAvJcajBIVrMru6Rrv8cNexUcL4zkDAF1/cuJKpX+UrPj7y6iz0F2zAv8J
         9E3w==
X-Gm-Message-State: AOAM533AS7hdYkDI0PVmqimMqiIQ1ex4dU54x4c1jkeDfAIYkvkvYrtg
        dxLu8VYKqKe+oeY9wu+e4v1YFd61t9B6fWqKZugskxaS0jyp
X-Google-Smtp-Source: ABdhPJx8BT91wIrjo3ZFIkeNWjp3bA7Tx8/VkHjR4AYJhKe7MStiXZUnh34Zbo82o5LDE38tJwMTN5jzpXY67/mN3qXG4tGgSOzE
MIME-Version: 1.0
X-Received: by 2002:a92:5eda:: with SMTP id f87mr4745204ilg.279.1599897559904;
 Sat, 12 Sep 2020 00:59:19 -0700 (PDT)
Date:   Sat, 12 Sep 2020 00:59:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc383005af192dac@google.com>
Subject: KMSAN: uninit-value in ip_check_mc_rcu (3)
From:   syzbot <syzbot+64be9532cb0d88808aad@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3b3ea602 x86: add failure injection to get/put/clear_user
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1357bd3e900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3afe005fb99591f
dashboard link: https://syzkaller.appspot.com/bug?extid=64be9532cb0d88808aad
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+64be9532cb0d88808aad@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ip_check_mc_rcu+0x340/0x840 net/ipv4/igmp.c:2707
CPU: 0 PID: 8708 Comm: syz-executor.0 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 ip_check_mc_rcu+0x340/0x840 net/ipv4/igmp.c:2707
 __mkroute_output+0x6a6/0x2860 net/ipv4/route.c:2388
 ip_route_output_key_hash_rcu+0x1eb4/0x2000 net/ipv4/route.c:2669
 ip_route_output_key_hash net/ipv4/route.c:2495 [inline]
 __ip_route_output_key include/net/route.h:126 [inline]
 ip_route_output_flow+0x211/0x420 net/ipv4/route.c:2758
 ip_route_output_key include/net/route.h:142 [inline]
 ip_tunnel_xmit+0x1772/0x3aa0 net/ipv4/ip_tunnel.c:751
 __gre_xmit net/ipv4/ip_gre.c:466 [inline]
 ipgre_xmit+0x12a2/0x13c0 net/ipv4/ip_gre.c:650
 __netdev_start_xmit include/linux/netdevice.h:4611 [inline]
 netdev_start_xmit include/linux/netdevice.h:4625 [inline]
 xmit_one+0x3cf/0x750 net/core/dev.c:3556
 dev_hard_start_xmit net/core/dev.c:3572 [inline]
 __dev_queue_xmit+0x3aad/0x4470 net/core/dev.c:4131
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4164
 packet_snd net/packet/af_packet.c:2979 [inline]
 packet_sendmsg+0x8542/0x9a80 net/packet/af_packet.c:3004
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0xc82/0x1240 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x6d1/0x840 net/socket.c:2439
 __do_sys_sendmsg net/socket.c:2448 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2446
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2446
 do_syscall_64+0xad/0x160 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5b9
Code: Bad RIP value.
RSP: 002b:00007f2932958c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002ccc0 RCX: 000000000045d5b9
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000005
RBP: 000000000118cf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 000000000169fb6f R14: 00007f29329599c0 R15: 000000000118cf4c

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 __msan_chain_origin+0x50/0x90 mm/kmsan/kmsan_instr.c:165
 ip_tunnel_init_flow include/net/ip_tunnels.h:248 [inline]
 ip_tunnel_xmit+0xe3d/0x3aa0 net/ipv4/ip_tunnel.c:733
 __gre_xmit net/ipv4/ip_gre.c:466 [inline]
 ipgre_xmit+0x12a2/0x13c0 net/ipv4/ip_gre.c:650
 __netdev_start_xmit include/linux/netdevice.h:4611 [inline]
 netdev_start_xmit include/linux/netdevice.h:4625 [inline]
 xmit_one+0x3cf/0x750 net/core/dev.c:3556
 dev_hard_start_xmit net/core/dev.c:3572 [inline]
 __dev_queue_xmit+0x3aad/0x4470 net/core/dev.c:4131
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4164
 packet_snd net/packet/af_packet.c:2979 [inline]
 packet_sendmsg+0x8542/0x9a80 net/packet/af_packet.c:3004
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0xc82/0x1240 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x6d1/0x840 net/socket.c:2439
 __do_sys_sendmsg net/socket.c:2448 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2446
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2446
 do_syscall_64+0xad/0x160 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 pskb_expand_head+0x3fd/0x1e30 net/core/skbuff.c:1636
 __skb_cow include/linux/skbuff.h:3145 [inline]
 skb_cow_head include/linux/skbuff.h:3179 [inline]
 ipgre_xmit+0x88c/0x13c0 net/ipv4/ip_gre.c:629
 __netdev_start_xmit include/linux/netdevice.h:4611 [inline]
 netdev_start_xmit include/linux/netdevice.h:4625 [inline]
 xmit_one+0x3cf/0x750 net/core/dev.c:3556
 dev_hard_start_xmit net/core/dev.c:3572 [inline]
 __dev_queue_xmit+0x3aad/0x4470 net/core/dev.c:4131
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4164
 packet_snd net/packet/af_packet.c:2979 [inline]
 packet_sendmsg+0x8542/0x9a80 net/packet/af_packet.c:3004
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0xc82/0x1240 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x6d1/0x840 net/socket.c:2439
 __do_sys_sendmsg net/socket.c:2448 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2446
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2446
 do_syscall_64+0xad/0x160 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2839 [inline]
 __kmalloc_node_track_caller+0xeab/0x12e0 mm/slub.c:4478
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x35f/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 alloc_skb_with_frags+0x1f2/0xc10 net/core/skbuff.c:5770
 sock_alloc_send_pskb+0xc83/0xe50 net/core/sock.c:2356
 packet_alloc_skb net/packet/af_packet.c:2827 [inline]
 packet_snd net/packet/af_packet.c:2922 [inline]
 packet_sendmsg+0x6abb/0x9a80 net/packet/af_packet.c:3004
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0xc82/0x1240 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x6d1/0x840 net/socket.c:2439
 __do_sys_sendmsg net/socket.c:2448 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2446
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2446
 do_syscall_64+0xad/0x160 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
