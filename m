Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA6A100BF5
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 20:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfKRTFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 14:05:12 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:48508 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfKRTFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 14:05:11 -0500
Received: by mail-il1-f197.google.com with SMTP id j68so17151337ili.15
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 11:05:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JN/WIzRL3xgiIAMfN7W4EDclVvEnXiBKfc2rvVhShA0=;
        b=X/I6bbEO7G64GunltTNI5Tlq5x2t1WyUrtKPcK18SZVdgczp7yVf9CefIsWaSd/+0Q
         Lf8yPWO/uGppWr543IlfcDVv5laLfqpgCWTCUPdqRq/oHL70iUCJ3vSz5Z72sCIeBjex
         COrdu7XriLD/5tkcl7JI90NyTXj4BKblqXGlR+dlxsMmCBZY8EJFdpoF6eK2eaUoemgy
         +Mpd7sACErEuztjp/P8iPaPqw9VyYglyCRGlVPRpO/aDS20O1puGraJya/0SoCEqOezK
         +Hx8ooyqp5BCrPExHVJWmpI6UN3AjGvkM2lE69vAKqgG/wOOgVMK6G0dHP3VVKSHfejI
         T1CA==
X-Gm-Message-State: APjAAAWRdA8FKg4O+25jKyxWQaL91LjuTKeTIBDGg8mGhmgJqt3mBclC
        skseT3LwGlfO+Q4EXSiw1yd68+Lwe50agG64Ykne4Wdh6OR/
X-Google-Smtp-Source: APXvYqzQv3IIi/EFnLlvpMQdjMEXk2J9nVzgCVUHWEnLUbkGSRF3p8znLbD8SbilYWbLCnXsHJtBk7RT8Zz8xLBUcMmQ/qQ2wWkW
MIME-Version: 1.0
X-Received: by 2002:a92:6611:: with SMTP id a17mr18116394ilc.208.1574103909400;
 Mon, 18 Nov 2019 11:05:09 -0800 (PST)
Date:   Mon, 18 Nov 2019 11:05:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005c08d10597a3a05d@google.com>
Subject: KMSAN: uninit-value in can_receive
From:   syzbot <syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9c6a7162 kmsan: remove unneeded annotations in bio
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=14563416e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9e324dfe9c7b0360
dashboard link: https://syzkaller.appspot.com/bug?extid=b02ff0707a97e4e79ebb
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in can_receive+0x23c/0x5e0 net/can/af_can.c:649
CPU: 1 PID: 3490 Comm: syz-executor.2 Not tainted 5.4.0-rc5+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x128/0x220 mm/kmsan/kmsan_report.c:108
  __msan_warning+0x73/0xe0 mm/kmsan/kmsan_instr.c:245
  can_receive+0x23c/0x5e0 net/can/af_can.c:649
  can_rcv+0x188/0x3a0 net/can/af_can.c:685
  __netif_receive_skb_one_core net/core/dev.c:5010 [inline]
  __netif_receive_skb net/core/dev.c:5124 [inline]
  process_backlog+0x12e8/0x1410 net/core/dev.c:5955
  napi_poll net/core/dev.c:6392 [inline]
  net_rx_action+0x7a6/0x1aa0 net/core/dev.c:6460
  __do_softirq+0x4a1/0x83a kernel/softirq.c:293
  do_softirq_own_stack+0x49/0x80 arch/x86/entry/entry_64.S:1093
  </IRQ>
  do_softirq kernel/softirq.c:338 [inline]
  __local_bh_enable_ip+0x184/0x1d0 kernel/softirq.c:190
  local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
  rcu_read_unlock_bh include/linux/rcupdate.h:688 [inline]
  __dev_queue_xmit+0x38e8/0x4200 net/core/dev.c:3900
  dev_queue_xmit+0x4b/0x60 net/core/dev.c:3906
  packet_snd net/packet/af_packet.c:2959 [inline]
  packet_sendmsg+0x82d7/0x92e0 net/packet/af_packet.c:2984
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  ___sys_sendmsg+0x14ff/0x1590 net/socket.c:2311
  __sys_sendmsg net/socket.c:2356 [inline]
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg+0x305/0x460 net/socket.c:2363
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2363
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x45a639
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ff1b9c14c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045a639
RDX: 0000000000000050 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ff1b9c156d4
R13: 00000000004c8acf R14: 00000000004df078 R15: 00000000ffffffff

Uninit was created at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:151 [inline]
  kmsan_internal_poison_shadow+0x60/0x120 mm/kmsan/kmsan.c:134
  kmsan_slab_alloc+0xaa/0x120 mm/kmsan/kmsan_hooks.c:88
  slab_alloc_node mm/slub.c:2799 [inline]
  __kmalloc_node_track_caller+0xd7b/0x1390 mm/slub.c:4407
  __kmalloc_reserve net/core/skbuff.c:141 [inline]
  __alloc_skb+0x306/0xa10 net/core/skbuff.c:209
  alloc_skb include/linux/skbuff.h:1050 [inline]
  alloc_skb_with_frags+0x18c/0xa80 net/core/skbuff.c:5662
  sock_alloc_send_pskb+0xafd/0x10a0 net/core/sock.c:2244
  packet_alloc_skb net/packet/af_packet.c:2807 [inline]
  packet_snd net/packet/af_packet.c:2902 [inline]
  packet_sendmsg+0x6785/0x92e0 net/packet/af_packet.c:2984
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  ___sys_sendmsg+0x14ff/0x1590 net/socket.c:2311
  __sys_sendmsg net/socket.c:2356 [inline]
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg+0x305/0x460 net/socket.c:2363
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2363
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
