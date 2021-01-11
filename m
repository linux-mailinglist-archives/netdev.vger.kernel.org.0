Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E992F19AB
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 16:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbhAKPa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 10:30:57 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:48714 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbhAKPa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 10:30:56 -0500
Received: by mail-io1-f71.google.com with SMTP id 191so12766306iob.15
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 07:30:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yDdM1YuzlRSxHmushVuEYsuGmbOyLKabLgjSNNrBhjc=;
        b=W0emknvPnF3aE6VgAohiSpyZeN927euzVWFt6dSUweHsuehG2urHsAB1HTaMcjqnya
         lj+YRl8E27brUInB9Un9yBHUSmbqhgc8Gw2SMLUIAWjtuZjQU35xn81L1oEYpLldeLBL
         UgrBI0STBQSrv5Ei21GYGlVTLgrt/CGRnBHpAAirhEySo/VX9WqBQrWpWKktJUztNW2G
         bcqiI+ak7O+6cE/nTfdD0hk6Ph8SwK4NaJZTQb1B++nsO0vvnJPLaKaYw8yd0x+4s/ne
         wLb0A5QQszAlealkqXc3gwoGWUkQ4I5m4Xu24N4XfGhilbhJ/zzx/pzNwa/qMIV9cuIt
         38fA==
X-Gm-Message-State: AOAM533qygKi/P8PBAHNxIePdW/zcCCEUFXEzQt48/qUtFgkwW24hXOk
        azTEDhsSJJ5I5vfZyVH4D+enCtj3hC5XWuMDtQab0wB8rEGS
X-Google-Smtp-Source: ABdhPJzZ+3a0xbrJgD3OkN1v1dn3EycFYpNWWAsHBUQt32IhJnImsR5xZJXY35DagJYk6/HKQpuwOgZ8fj3xsusPnrFHsYg3D3pG
MIME-Version: 1.0
X-Received: by 2002:a92:d44e:: with SMTP id r14mr12393751ilm.299.1610379015503;
 Mon, 11 Jan 2021 07:30:15 -0800 (PST)
Date:   Mon, 11 Jan 2021 07:30:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002c458f05b8a195cf@google.com>
Subject: KMSAN: uninit-value in __nla_validate_parse (2)
From:   syzbot <syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    73d62e81 kmsan: random: prevent boot-time reports in _mix_..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=153a38f7500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2cdf4151c9653e32
dashboard link: https://syzkaller.appspot.com/bug?extid=2624e3778b18fc497c92
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ef8c3f500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12bee8f7500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com

netlink: 4 bytes leftover after parsing attributes in process `syz-executor224'.
=====================================================
BUG: KMSAN: uninit-value in nla_ok include/net/netlink.h:1159 [inline]
BUG: KMSAN: uninit-value in __nla_validate_parse+0x5fd/0x4e00 lib/nlattr.c:576
CPU: 0 PID: 8270 Comm: syz-executor224 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 nla_ok include/net/netlink.h:1159 [inline]
 __nla_validate_parse+0x5fd/0x4e00 lib/nlattr.c:576
 __nla_parse+0x141/0x150 lib/nlattr.c:685
 nla_parse_nested include/net/netlink.h:1212 [inline]
 fl_set_erspan_opt+0x39a/0xe60 net/sched/cls_flower.c:1206
 fl_set_enc_opt net/sched/cls_flower.c:1365 [inline]
 fl_set_key+0x810d/0xbb60 net/sched/cls_flower.c:1642
 fl_set_parms net/sched/cls_flower.c:1880 [inline]
 fl_change+0x1226/0x7ae0 net/sched/cls_flower.c:1979
 tc_new_tfilter+0x37c1/0x58e0 net/sched/cls_api.c:2129
 rtnetlink_rcv_msg+0xe94/0x18b0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x70a/0x820 net/netlink/af_netlink.c:2494
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5580
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x11da/0x14b0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x173c/0x1840 net/netlink/af_netlink.c:1919
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
RIP: 0033:0x441739
Code: e8 5c ad 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 bb 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffca52cefc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441739
RDX: 010efe10675dec16 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 00007ffca52cefd0 R08: 0000000120080522 R09: 0000000120080522
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004a2a70
R13: 0000000000402610 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2906 [inline]
 __kmalloc_node_track_caller+0xc61/0x15f0 mm/slub.c:4512
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x309/0xae0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1094 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1176 [inline]
 netlink_sendmsg+0xdb8/0x1840 net/netlink/af_netlink.c:1894
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
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
