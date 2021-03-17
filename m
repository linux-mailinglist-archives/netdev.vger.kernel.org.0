Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA9133E945
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 06:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhCQFtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 01:49:51 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:37970 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhCQFtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 01:49:19 -0400
Received: by mail-il1-f197.google.com with SMTP id o7so28600123ilt.5
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 22:49:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=9YdkGevB3HdkHkmfKATNeADUt1YQP8td1/6C+RHiBp0=;
        b=MCJ/a6M9HozC6vISzMNsC8pnnUy8o7VNoKy4X01ZmxOo27k3PT7vcRNQnZxP86rhJX
         ICa8wdXIN/NXNjJiqInb+FpB7QsdLVu4bJ/jqj2GbdlYedV2k5l0M2HUJPEi2to0laX0
         +Z0c4jsw5MMorKlcQb2jZgP1NM4Yo6SOTURS5V4O1ohD7IH6wCaJD5U7ul4Vcw337n7k
         qrwCoauWHMpe6GVrxf8rQvbrFi5e4jq67lY8juE3GYDogtIfHFMuV3Vsnm3nnMjDProp
         EhDwyRgHdux9u1q2CODRqhGlcoD7PPkr2z1cK1Qt4Dvx1dEVWqWB0s1x1zC7RUX+wH71
         hH2Q==
X-Gm-Message-State: AOAM531o4TcPAmtQwneFFcWN6QdXlFQzCW/FrGIQHIn/hAF+MgBekW50
        SZUXLiaFUx5CkYjFgvb4WCsvpbTejTr0yRze8g/+O1WxYIlz
X-Google-Smtp-Source: ABdhPJxqyX+rD7OPc3p2Jp4qhw5m25auzEBBH7JhRWIrnJZ0rgiAfFWEhl4RrGdOA6ClkbKDy5zqFcvLTJ0dAjFT9i4FmZSkeSg9
MIME-Version: 1.0
X-Received: by 2002:a02:604b:: with SMTP id d11mr1592853jaf.128.1615960158449;
 Tue, 16 Mar 2021 22:49:18 -0700 (PDT)
Date:   Tue, 16 Mar 2021 22:49:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003736df05bdb50bf3@google.com>
Subject: [syzbot] KMSAN: uninit-value in iptable_mangle_hook (5)
From:   syzbot <syzbot+9b5e12c49c015d4c1aeb@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        fw@strlen.de, glider@google.com, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    29ad81a1 arch/x86: add missing include to sparsemem.h
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=179b38f6d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8b976581f6bd1e7d
dashboard link: https://syzkaller.appspot.com/bug?extid=9b5e12c49c015d4c1aeb
compiler:       Debian clang version 11.0.1-2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9b5e12c49c015d4c1aeb@syzkaller.appspotmail.com

netlink: 24 bytes leftover after parsing attributes in process `syz-executor.4'.
=====================================================
BUG: KMSAN: uninit-value in ipt_mangle_out net/ipv4/netfilter/iptable_mangle.c:61 [inline]
BUG: KMSAN: uninit-value in iptable_mangle_hook+0x75a/0x8c0 net/ipv4/netfilter/iptable_mangle.c:81
CPU: 1 PID: 25792 Comm: syz-executor.4 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 ipt_mangle_out net/ipv4/netfilter/iptable_mangle.c:61 [inline]
 iptable_mangle_hook+0x75a/0x8c0 net/ipv4/netfilter/iptable_mangle.c:81
 nf_hook_entry_hookfn include/linux/netfilter.h:136 [inline]
 nf_hook_slow+0x17b/0x460 net/netfilter/core.c:589
 nf_hook include/linux/netfilter.h:256 [inline]
 __ip_local_out+0x78c/0x840 net/ipv4/ip_output.c:115
 ip_local_out+0xa1/0x1e0 net/ipv4/ip_output.c:124
 iptunnel_xmit+0x931/0xf20 net/ipv4/ip_tunnel_core.c:82
 udp_tunnel_xmit_skb+0x526/0x640 net/ipv4/udp_tunnel_core.c:190
 geneve_xmit_skb drivers/net/geneve.c:959 [inline]
 geneve_xmit+0x209e/0x3c20 drivers/net/geneve.c:1059
 __netdev_start_xmit include/linux/netdevice.h:4778 [inline]
 netdev_start_xmit include/linux/netdevice.h:4792 [inline]
 xmit_one+0x2b6/0x760 net/core/dev.c:3574
 dev_hard_start_xmit net/core/dev.c:3590 [inline]
 __dev_queue_xmit+0x3426/0x45c0 net/core/dev.c:4151
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4184
 packet_snd net/packet/af_packet.c:3006 [inline]
 packet_sendmsg+0x8778/0x9a60 net/packet/af_packet.c:3031
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2432
 __do_sys_sendmsg net/socket.c:2441 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2439
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2439
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x465f69
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fae1692d188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465f69
RDX: 0000000000008844 RSI: 00000000200005c0 RDI: 0000000000000003
RBP: 00000000004bfa8f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 0000000000a9fb1f R14: 00007fae1692d300 R15: 0000000000022000

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 __msan_chain_origin+0x57/0xa0 mm/kmsan/kmsan_instr.c:147
 iptunnel_xmit+0xbd6/0xf20 net/ipv4/ip_tunnel_core.c:76
 udp_tunnel_xmit_skb+0x526/0x640 net/ipv4/udp_tunnel_core.c:190
 geneve_xmit_skb drivers/net/geneve.c:959 [inline]
 geneve_xmit+0x209e/0x3c20 drivers/net/geneve.c:1059
 __netdev_start_xmit include/linux/netdevice.h:4778 [inline]
 netdev_start_xmit include/linux/netdevice.h:4792 [inline]
 xmit_one+0x2b6/0x760 net/core/dev.c:3574
 dev_hard_start_xmit net/core/dev.c:3590 [inline]
 __dev_queue_xmit+0x3426/0x45c0 net/core/dev.c:4151
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4184
 packet_snd net/packet/af_packet.c:3006 [inline]
 packet_sendmsg+0x8778/0x9a60 net/packet/af_packet.c:3031
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2432
 __do_sys_sendmsg net/socket.c:2441 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2439
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2439
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

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
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2432
 __do_sys_sendmsg net/socket.c:2441 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2439
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2439
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
