Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C352F544A
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 21:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbhAMUsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 15:48:06 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:49843 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbhAMUsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 15:48:05 -0500
Received: by mail-io1-f71.google.com with SMTP id v7so4968721ioj.16
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 12:47:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Bpw2qFZAo7VI9U1TOGN9QUmbH4YufW23rvZI+QUopQA=;
        b=SdtGG/9UivV4fWf8UDoOzlJHNtC1vvtd3LFOq6MMDtwlUEU5heJpM7JexN1VrjkFUr
         6/as9ZzgFDGi0VgucsmtoMF1BaKp+0mfI+gaLb2HeMccH7n7s9Zr5c6nZpXmhGgmifws
         OOYIRDcMppsR8ls6Oj3I6EXmqprTeuVW8GeGzQmySmERvBA2OPtRcqr2Z6ce5QtWNHx9
         edRgK3vWD9EzzGRZLkI0rkxSGfMH7eiF1YcwDZX0Z4lwLmfCCUaGRicURl19eTU4Nx30
         iXqueJ9C2NmVe/2k8hcdbnz+wrmll7hetB5qw8PYkkWgIVB4o3zs/5gPyWZv269N2VP/
         V/eg==
X-Gm-Message-State: AOAM532gn7e8n7yGbXXU6Skt83zGZp+TE3xFpJLBtImKlYu08SnKe5vZ
        Ll5vH13zFJ9vbT09dQijwiQZM5sEn3pux9NZzrAyeTeh8WUK
X-Google-Smtp-Source: ABdhPJwJxq1hnlzW0bsfWpFZNSa+eV6rbNK8ojmlRKcHakNST27l8F9GHEFIfJr1zTiwVnw/e43Mvenr0IaaXF64mbtOk+vnWbh0
MIME-Version: 1.0
X-Received: by 2002:a6b:cd02:: with SMTP id d2mr3138648iog.4.1610570844187;
 Wed, 13 Jan 2021 12:47:24 -0800 (PST)
Date:   Wed, 13 Jan 2021 12:47:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000db99b05b8ce3fb7@google.com>
Subject: KMSAN: uninit-value in ip_route_output_key_hash_rcu (4)
From:   syzbot <syzbot+549e451574ba8bfd0fd6@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    73d62e81 kmsan: random: prevent boot-time reports in _mix_..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=10998e93500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2cdf4151c9653e32
dashboard link: https://syzkaller.appspot.com/bug?extid=549e451574ba8bfd0fd6
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+549e451574ba8bfd0fd6@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ip_route_output_key_hash_rcu+0xe77/0x1f20 net/ipv4/route.c:2588
CPU: 1 PID: 8547 Comm: syz-executor.0 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 ip_route_output_key_hash_rcu+0xe77/0x1f20 net/ipv4/route.c:2588
 ip_route_output_key_hash+0x21b/0x2d0 net/ipv4/route.c:2507
 __ip_route_output_key include/net/route.h:126 [inline]
 xfrmi_xmit+0x4cb/0x1fd0 net/xfrm/xfrm_interface.c:376
 __netdev_start_xmit include/linux/netdevice.h:4718 [inline]
 netdev_start_xmit include/linux/netdevice.h:4732 [inline]
 xmit_one+0x2b9/0x770 net/core/dev.c:3564
 dev_hard_start_xmit net/core/dev.c:3580 [inline]
 __dev_queue_xmit+0x33f2/0x4520 net/core/dev.c:4140
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4173
 packet_snd net/packet/af_packet.c:2992 [inline]
 packet_sendmsg+0x86f9/0x99d0 net/packet/af_packet.c:3017
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0xc7a/0x1240 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmmsg+0xa56/0x1060 net/socket.c:2497
 __do_sys_sendmmsg net/socket.c:2526 [inline]
 __se_sys_sendmmsg+0xbd/0xe0 net/socket.c:2523
 __x64_sys_sendmmsg+0x56/0x70 net/socket.c:2523
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e219
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f2026f42c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 000000000045e219
RDX: 0000000000000001 RSI: 00000000200066c0 RDI: 0000000000000003
RBP: 000000000119c070 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119c034
R13: 00000000016afb5f R14: 00007f2026f439c0 R15: 000000000119c034

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 __msan_chain_origin+0x57/0xa0 mm/kmsan/kmsan_instr.c:147
 decode_session4 net/xfrm/xfrm_policy.c:3285 [inline]
 __xfrm_decode_session+0x15d5/0x3890 net/xfrm/xfrm_policy.c:3481
 xfrm_decode_session include/net/xfrm.h:1137 [inline]
 xfrmi_xmit+0x243/0x1fd0 net/xfrm/xfrm_interface.c:369
 __netdev_start_xmit include/linux/netdevice.h:4718 [inline]
 netdev_start_xmit include/linux/netdevice.h:4732 [inline]
 xmit_one+0x2b9/0x770 net/core/dev.c:3564
 dev_hard_start_xmit net/core/dev.c:3580 [inline]
 __dev_queue_xmit+0x33f2/0x4520 net/core/dev.c:4140
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4173
 packet_snd net/packet/af_packet.c:2992 [inline]
 packet_sendmsg+0x86f9/0x99d0 net/packet/af_packet.c:3017
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0xc7a/0x1240 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmmsg+0xa56/0x1060 net/socket.c:2497
 __do_sys_sendmmsg net/socket.c:2526 [inline]
 __se_sys_sendmmsg+0xbd/0xe0 net/socket.c:2523
 __x64_sys_sendmmsg+0x56/0x70 net/socket.c:2523
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2906 [inline]
 __kmalloc_node_track_caller+0xc61/0x15f0 mm/slub.c:4512
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x309/0xae0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1094 [inline]
 alloc_skb_with_frags+0x1f3/0xc20 net/core/skbuff.c:5832
 sock_alloc_send_pskb+0xc73/0xe40 net/core/sock.c:2329
 packet_alloc_skb net/packet/af_packet.c:2840 [inline]
 packet_snd net/packet/af_packet.c:2935 [inline]
 packet_sendmsg+0x6aa3/0x99d0 net/packet/af_packet.c:3017
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0xc7a/0x1240 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmmsg+0xa56/0x1060 net/socket.c:2497
 __do_sys_sendmmsg net/socket.c:2526 [inline]
 __se_sys_sendmmsg+0xbd/0xe0 net/socket.c:2523
 __x64_sys_sendmmsg+0x56/0x70 net/socket.c:2523
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
