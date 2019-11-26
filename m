Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6F3109A9D
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 10:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfKZJAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 04:00:08 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:45449 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfKZJAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 04:00:08 -0500
Received: by mail-io1-f72.google.com with SMTP id c17so12813910ioh.12
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 01:00:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=LbIvRs+899J2V/QiiU/DsViVNjfmXkRsZX5XX/Yo8Qw=;
        b=RJyQi7N1hCi0GYtqj7BV5sK5rpJTidRdKoyYnYy9f8ks71qKTDR9XkzQcd8VqGzn66
         AmaiABieYLufGacinEd44DFRMws7RcqE+mL4QAXaN/nA6aBS4gXsGbgqVEuCXk1U2lEf
         UIVYrpudW6XhC6NgePKAp199gJX67K2VPSNuKMP5fylMBFz2uYBPnGfEgBIJMk9oLsVg
         SlHKn9p1FVRplos/B3V4ETC2zbeuHRcvEYIWJ3bFQPKBjKlxexSWS4v/Lr0VO/l0TcZU
         KljZGvuh2fqdwtOVX0r+k7vC6fq1a8kQCr2fDcmjo2X9tng+GnfHV/nniUVRgiV9/Dvt
         G6tQ==
X-Gm-Message-State: APjAAAVJtlz2k1LDz9Lz/aU3hdGBV32BXJBU81DZYygG6u3xsw+KcSrp
        BbidiaqzcoTWE6mp7reDofggf9HhBfbka0rXuVPdE0YZ22ok
X-Google-Smtp-Source: APXvYqzDc2gKE6kDHcB+Vfy4pPhmHFLV9TQgoYGRJs4hTAMNzYXomSVBv4BDHj19fTTebdov6DH5BtnXI4CpztizVEgmqh/UY0LB
MIME-Version: 1.0
X-Received: by 2002:a92:5b86:: with SMTP id c6mr36371042ilg.135.1574758807587;
 Tue, 26 Nov 2019 01:00:07 -0800 (PST)
Date:   Tue, 26 Nov 2019 01:00:07 -0800
In-Reply-To: <0000000000005c08d10597a3a05d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000055558105983c1b38@google.com>
Subject: Re: KMSAN: uninit-value in can_receive
From:   syzbot <syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dvyukov@google.com, eric.dumazet@gmail.com,
        glider@google.com, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, o.rempel@pengutronix.de,
        socketcan@hartkopp.net, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    4a1d41e3 net: kasan: kmsan: support CONFIG_GENERIC_CSUM on..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1632f75ae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fde150fb1e865232
dashboard link: https://syzkaller.appspot.com/bug?extid=b02ff0707a97e4e79ebb
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15696e36e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132b3636e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in can_receive+0x23c/0x5e0 net/can/af_can.c:650
CPU: 0 PID: 11833 Comm: syz-executor463 Not tainted 5.4.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x220 lib/dump_stack.c:118
  kmsan_report+0x128/0x220 mm/kmsan/kmsan_report.c:108
  __msan_warning+0x64/0xc0 mm/kmsan/kmsan_instr.c:245
  can_receive+0x23c/0x5e0 net/can/af_can.c:650
  canfd_rcv+0x188/0x3a0 net/can/af_can.c:703
  __netif_receive_skb_one_core net/core/dev.c:4929 [inline]
  __netif_receive_skb net/core/dev.c:5043 [inline]
  process_backlog+0x12a6/0x13c0 net/core/dev.c:5874
  napi_poll net/core/dev.c:6311 [inline]
  net_rx_action+0x7a6/0x1aa0 net/core/dev.c:6379
  __do_softirq+0x4a1/0x83a kernel/softirq.c:293
  do_softirq_own_stack+0x49/0x80 arch/x86/entry/entry_64.S:1091
  </IRQ>
  do_softirq kernel/softirq.c:338 [inline]
  __local_bh_enable_ip+0x184/0x1d0 kernel/softirq.c:190
  local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
  rcu_read_unlock_bh include/linux/rcupdate.h:688 [inline]
  __dev_queue_xmit+0x38e8/0x4200 net/core/dev.c:3819
  dev_queue_xmit+0x4b/0x60 net/core/dev.c:3825
  packet_snd net/packet/af_packet.c:2959 [inline]
  packet_sendmsg+0x8234/0x9100 net/packet/af_packet.c:2984
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  ___sys_sendmsg+0x14ff/0x1590 net/socket.c:2311
  __sys_sendmmsg+0x53a/0xae0 net/socket.c:2413
  __do_sys_sendmmsg net/socket.c:2442 [inline]
  __se_sys_sendmmsg+0xbd/0xe0 net/socket.c:2439
  __x64_sys_sendmmsg+0x56/0x70 net/socket.c:2439
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x442129
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 5b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffef5083a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000442129
RDX: 000000000400004e RSI: 0000000020000d00 RDI: 0000000000000003
RBP: 0000000000000004 R08: 0000000000000025 R09: 0000000000000025
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00000000004036a0 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:149 [inline]
  kmsan_internal_poison_shadow+0x60/0x120 mm/kmsan/kmsan.c:132
  kmsan_slab_alloc+0x97/0x100 mm/kmsan/kmsan_hooks.c:86
  slab_alloc_node mm/slub.c:2773 [inline]
  __kmalloc_node_track_caller+0xe27/0x11a0 mm/slub.c:4381
  __kmalloc_reserve net/core/skbuff.c:141 [inline]
  __alloc_skb+0x306/0xa10 net/core/skbuff.c:209
  alloc_skb include/linux/skbuff.h:1049 [inline]
  alloc_skb_with_frags+0x18c/0xa80 net/core/skbuff.c:5662
  sock_alloc_send_pskb+0xafd/0x10a0 net/core/sock.c:2244
  packet_alloc_skb net/packet/af_packet.c:2807 [inline]
  packet_snd net/packet/af_packet.c:2902 [inline]
  packet_sendmsg+0x63a6/0x9100 net/packet/af_packet.c:2984
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  ___sys_sendmsg+0x14ff/0x1590 net/socket.c:2311
  __sys_sendmmsg+0x53a/0xae0 net/socket.c:2413
  __do_sys_sendmmsg net/socket.c:2442 [inline]
  __se_sys_sendmmsg+0xbd/0xe0 net/socket.c:2439
  __x64_sys_sendmmsg+0x56/0x70 net/socket.c:2439
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================

