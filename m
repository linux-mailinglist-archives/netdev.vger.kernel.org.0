Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A91DF14CF39
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 18:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbgA2RHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 12:07:12 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:50424 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgA2RHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 12:07:12 -0500
Received: by mail-il1-f197.google.com with SMTP id z12so298224ilh.17
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 09:07:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hu0b6Hnn4RYdnGMr5jlk/MzHOIXpnm4FzgaoyFlKw4k=;
        b=AAUByWGk8r94Rr+MInB4A6yUiLKS5jBPGd00rXn9OHTPCRfYXoqC3oNmIaqrh84s04
         ooXyBBVpUHkArmAuLbOUPGo9thuBnuS1T/Xj75R8Kf+r/K3a0yDjMSaSEiqUSMRwnUxR
         vJtd6hvww1vTBUwmvJCyO6WqKWkzQ/YgM6s0Y9pgVU60+04h1PGZt/kncg5Vg4GfH+oo
         dt8A+oeSaHl39rkUHpEB5W503P0M9c0irLvHKDRv2uv6VrR8Zyb0R7LRZ5UsBLQuMFS3
         BlAfjz9KgDSWP/bXqeCRqdD2uIyucQtqY5WRQfz6iB8IwEex09lyHe9Z7EnuHEgtiO1t
         OodA==
X-Gm-Message-State: APjAAAV1s9DUYV68iCTfwTjyCrIEHmMZmFCQsNWe4AtErQOtpERXTjvI
        jzpOKz32MhtnIFyIHZSrxi6hI0IpFIgAykGH//Jm29hHcGVx
X-Google-Smtp-Source: APXvYqwZcpn/ShCdDXzgmGEsXSTg0Ixdu+0uzSZMJcU+Xig2+fokym2mXvsggxBXgmltmyXiWXd+FgaqbWc4LkawJXRm3fUVHLQm
MIME-Version: 1.0
X-Received: by 2002:a92:d98e:: with SMTP id r14mr208093iln.15.1580317631894;
 Wed, 29 Jan 2020 09:07:11 -0800 (PST)
Date:   Wed, 29 Jan 2020 09:07:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000014dbdc059d4a5fc4@google.com>
Subject: KMSAN: uninit-value in udp_tunnel6_xmit_skb
From:   syzbot <syzbot+0f342f32d39f96d04947@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    686a4f77 kmsan: don't compile memmove
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=12696a4ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e10654781bc1f11c
dashboard link: https://syzkaller.appspot.com/bug?extid=0f342f32d39f96d04947
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0f342f32d39f96d04947@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __arch_swab32 arch/x86/include/uapi/asm/swab.h:10 [inline]
BUG: KMSAN: uninit-value in __fswab32 include/uapi/linux/swab.h:59 [inline]
BUG: KMSAN: uninit-value in ip6_flow_hdr include/net/ipv6.h:942 [inline]
BUG: KMSAN: uninit-value in udp_tunnel6_xmit_skb+0xb74/0xec0 net/ipv6/ip6_udp_tunnel.c:107
CPU: 0 PID: 22812 Comm: syz-executor.3 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 __arch_swab32 arch/x86/include/uapi/asm/swab.h:10 [inline]
 __fswab32 include/uapi/linux/swab.h:59 [inline]
 ip6_flow_hdr include/net/ipv6.h:942 [inline]
 udp_tunnel6_xmit_skb+0xb74/0xec0 net/ipv6/ip6_udp_tunnel.c:107
 geneve6_xmit_skb drivers/net/geneve.c:973 [inline]
 geneve_xmit+0x1d9a/0x2c20 drivers/net/geneve.c:1001
 __netdev_start_xmit include/linux/netdevice.h:4447 [inline]
 netdev_start_xmit include/linux/netdevice.h:4461 [inline]
 xmit_one net/core/dev.c:3420 [inline]
 dev_hard_start_xmit+0x531/0xab0 net/core/dev.c:3436
 __dev_queue_xmit+0x37de/0x4220 net/core/dev.c:4013
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4046
 packet_snd net/packet/af_packet.c:2966 [inline]
 packet_sendmsg+0x8436/0x92f0 net/packet/af_packet.c:2991
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45b349
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fd193e8ec78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fd193e8f6d4 RCX: 000000000045b349
RDX: 0000000000000881 RSI: 0000000020007780 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009c0 R14: 00000000004cb2b4 R15: 000000000075bf2c

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:82
 slab_alloc_node mm/slub.c:2774 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4382
 __kmalloc_reserve net/core/skbuff.c:141 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:209
 alloc_skb include/linux/skbuff.h:1049 [inline]
 alloc_skb_with_frags+0x18c/0xa70 net/core/skbuff.c:5664
 sock_alloc_send_pskb+0xada/0xc60 net/core/sock.c:2242
 packet_alloc_skb net/packet/af_packet.c:2814 [inline]
 packet_snd net/packet/af_packet.c:2909 [inline]
 packet_sendmsg+0x656e/0x92f0 net/packet/af_packet.c:2991
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
