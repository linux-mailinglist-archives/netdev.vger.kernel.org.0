Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6F0319D0
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 08:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfFAGFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 02:05:12 -0400
Received: from mail-it1-f197.google.com ([209.85.166.197]:39320 "EHLO
        mail-it1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfFAGFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 02:05:07 -0400
Received: by mail-it1-f197.google.com with SMTP id q13so10133395itk.4
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 23:05:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lT9g1a8Jz+3l58k+6DJ9mGkbBuPDfzIGdcwqTqL45gU=;
        b=FIECJJWg/EpL1JVRrOLRo8OHfSxgsdTe7QzeoStaqEk46YhPEYJJ2SWOzAn+hGLOnU
         nPW5BDQlYqenu83KeOwUC3cIU5Cq8E0lPuN7ZT51GriJeNBsoeKgsFvhDFsc5WEup7Je
         W898NZhn3d3Ao1smKAWnqyETtk7KB8zHJFjU2vpY+6LNjioLsGocxiHNS/RagL2HHshN
         avKGDTbhkqH/Hm1ete1zdLVCiduUszpROmpXZXfUZCvUzKg7u5kFj1sC2+Z6Ac81k/A9
         R0I77p2mNh7DqJ5vf5iXjfzKTsbk9z2rrdA++1RVVC3wVj/FGqnL9iFXa0w5n8ZNdfPJ
         R7Xg==
X-Gm-Message-State: APjAAAXZM8GbifKmzYMCBL+ZLo6RdngQ4k98tCtWK4d3GD5h0eHTcNVO
        PuyEty2NVqbKWRDlNnYKUre2rJgcRZXSXlXPpuUL8nYnUCYV
X-Google-Smtp-Source: APXvYqwkuNOq3KwVRLsW7nAdjeXFj3pLzGZcjf3e6nd2rCXJSUGddk7PrOysX5AEUooodzX2c1Tu3M9lZR2avUmqGOJwkTscsYQc
MIME-Version: 1.0
X-Received: by 2002:a24:1c0a:: with SMTP id c10mr9570178itc.45.1559369106288;
 Fri, 31 May 2019 23:05:06 -0700 (PDT)
Date:   Fri, 31 May 2019 23:05:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a7776f058a3ce9db@google.com>
Subject: KASAN: user-memory-access Read in ip6_hold_safe (3)
From:   syzbot <syzbot+a5b6e01ec8116d046842@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    dfb569f2 net: ll_temac: Fix compile error
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10afcb8aa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc045131472947d7
dashboard link: https://syzkaller.appspot.com/bug?extid=a5b6e01ec8116d046842
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a5b6e01ec8116d046842@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: user-memory-access in atomic_read  
include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: user-memory-access in atomic_fetch_add_unless  
include/linux/atomic-fallback.h:1086 [inline]
BUG: KASAN: user-memory-access in atomic_add_unless  
include/linux/atomic-fallback.h:1111 [inline]
BUG: KASAN: user-memory-access in atomic_inc_not_zero  
include/linux/atomic-fallback.h:1127 [inline]
BUG: KASAN: user-memory-access in dst_hold_safe include/net/dst.h:297  
[inline]
BUG: KASAN: user-memory-access in ip6_hold_safe+0xad/0x380  
net/ipv6/route.c:1050
Read of size 4 at addr 0000000000001ec4 by task syz-executor.0/10106

CPU: 0 PID: 10106 Comm: syz-executor.0 Not tainted 5.2.0-rc1+ #5
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  __kasan_report.cold+0x5/0x40 mm/kasan/report.c:321
  kasan_report+0x12/0x20 mm/kasan/common.c:614
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x123/0x190 mm/kasan/generic.c:191
  kasan_check_read+0x11/0x20 mm/kasan/common.c:94
  atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
  atomic_fetch_add_unless include/linux/atomic-fallback.h:1086 [inline]
  atomic_add_unless include/linux/atomic-fallback.h:1111 [inline]
  atomic_inc_not_zero include/linux/atomic-fallback.h:1127 [inline]
  dst_hold_safe include/net/dst.h:297 [inline]
  ip6_hold_safe+0xad/0x380 net/ipv6/route.c:1050
  rt6_get_pcpu_route net/ipv6/route.c:1277 [inline]
  ip6_pol_route+0x339/0x1050 net/ipv6/route.c:1956
  ip6_pol_route_output+0x54/0x70 net/ipv6/route.c:2132
  fib6_rule_lookup+0x133/0x5a0 net/ipv6/fib6_rules.c:116
  ip6_route_output_flags+0x2c4/0x350 net/ipv6/route.c:2161
  ip6_route_output include/net/ip6_route.h:89 [inline]
  ip6_dst_lookup_tail+0xd10/0x1b30 net/ipv6/ip6_output.c:966
  ip6_dst_lookup_flow+0xa8/0x220 net/ipv6/ip6_output.c:1094
  sctp_v6_get_dst+0x785/0x1d80 net/sctp/ipv6.c:293
  sctp_transport_route+0x12d/0x360 net/sctp/transport.c:312
  sctp_assoc_add_peer+0x53e/0xfc0 net/sctp/associola.c:678
  sctp_process_param net/sctp/sm_make_chunk.c:2546 [inline]
  sctp_process_init+0x2491/0x2b10 net/sctp/sm_make_chunk.c:2359
  sctp_cmd_process_init net/sctp/sm_sideeffect.c:682 [inline]
  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1384 [inline]
  sctp_side_effects net/sctp/sm_sideeffect.c:1194 [inline]
  sctp_do_sm+0x3a30/0x50e0 net/sctp/sm_sideeffect.c:1165
  sctp_assoc_bh_rcv+0x343/0x660 net/sctp/associola.c:1074
  sctp_inq_push+0x1e4/0x280 net/sctp/inqueue.c:95
  sctp_backlog_rcv+0x196/0xbe0 net/sctp/input.c:354
  sk_backlog_rcv include/net/sock.h:950 [inline]
  __release_sock+0x129/0x390 net/core/sock.c:2418
  release_sock+0x59/0x1c0 net/core/sock.c:2934
  sctp_wait_for_connect+0x316/0x540 net/sctp/socket.c:9054
  __sctp_connect+0xab2/0xcd0 net/sctp/socket.c:1241
  __sctp_setsockopt_connectx+0x133/0x1a0 net/sctp/socket.c:1349
  sctp_setsockopt_connectx_old net/sctp/socket.c:1365 [inline]
  sctp_setsockopt net/sctp/socket.c:4659 [inline]
  sctp_setsockopt+0x22c0/0x6d10 net/sctp/socket.c:4623
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3130
  __sys_setsockopt+0x17a/0x280 net/socket.c:2078
  __do_sys_setsockopt net/socket.c:2089 [inline]
  __se_sys_setsockopt net/socket.c:2086 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2086
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459279
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ff1e859ec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000459279
RDX: 000000000000006b RSI: 0000000000000084 RDI: 0000000000000006
RBP: 000000000075bf20 R08: 000000000000001c R09: 0000000000000000
R10: 000000002055bfe4 R11: 0000000000000246 R12: 00007ff1e859f6d4
R13: 00000000004cea80 R14: 00000000004dced0 R15: 00000000ffffffff
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
