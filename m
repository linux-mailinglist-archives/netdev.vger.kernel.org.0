Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAAC2EAB5E
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 14:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbhAENB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 08:01:58 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:42002 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbhAENB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 08:01:58 -0500
Received: by mail-io1-f69.google.com with SMTP id m9so13882781ioa.9
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 05:01:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ru5bjWzHIyRK6ZRwLgZl3qBHXsr7G9Z+i9Dvu4uenWc=;
        b=pA5EKCua3yKr+T2y487N3vezrnW0amQPRSz77q2ouD8uS3l8LTGLljpcOgx/9KlW/K
         JuJnKcpVNKZDVYZvzhxDwr5vOWt0Utrsd+5ALjB4h9I4zHO8BnTcVwvgT4FyPfLqdLk3
         LCYuESoib8ZNH8SUGgdLvFIOi6ZyChLtddLEzl+XK2AFMsGNubD3I7Vf5WPdw0ikinc5
         G4gIBodpUqGWSayetsW6vfaTyoEl77zm8xbeKlFNa2VkofBPmal6KptL3yOwiboe3lLA
         UMhJvjwcetSdF8fqCEM7gCIJA7zdSHBmb2z1P/22I4ws3rfU4YY8MoMssS/s6W5+i77a
         uEOA==
X-Gm-Message-State: AOAM531smvBO9hRkMkqbWB9jWOnxUnxVWf6LhZG55W2O0IcqrkO7e5uh
        hKB/vu4QrM2SeJopWXzVxqeL/5Fi3jS4+bnmvaxEKfUVAyKb
X-Google-Smtp-Source: ABdhPJyofSzreOMWmIpdQM3UdYWqIn4pvNONeOx8NKjjsHQTu404iL2qhxZHzn1yjb+vIpXIB1phN2pTmte+ML7V93JcD0QySR7J
MIME-Version: 1.0
X-Received: by 2002:a92:cec3:: with SMTP id z3mr73680933ilq.256.1609851677209;
 Tue, 05 Jan 2021 05:01:17 -0800 (PST)
Date:   Tue, 05 Jan 2021 05:01:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005c7c1005b826cd7f@google.com>
Subject: UBSAN: division-overflow in netem_enqueue
From:   syzbot <syzbot+c32f013ef7b11871dba6@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, stephen@networkplumber.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3db1a3fa Merge tag 'staging-5.11-rc1' of git://git.kernel...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1213cf60d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a6e6725884106332
dashboard link: https://syzkaller.appspot.com/bug?extid=c32f013ef7b11871dba6
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c32f013ef7b11871dba6@syzkaller.appspotmail.com

================================================================================
UBSAN: division-overflow in net/sched/sch_netem.c:516:27
division by zero
CPU: 0 PID: 12279 Comm: syz-executor.4 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_divrem_overflow.cold+0x7c/0xd0 lib/ubsan.c:252
 netem_enqueue.cold+0x17/0xbc net/sched/sch_netem.c:516
 netem_enqueue+0x2095/0x34e0 net/sched/sch_netem.c:483
 __dev_xmit_skb net/core/dev.c:3789 [inline]
 __dev_queue_xmit+0x19ec/0x2ef0 net/core/dev.c:4101
 __netlink_deliver_tap_skb net/netlink/af_netlink.c:295 [inline]
 __netlink_deliver_tap net/netlink/af_netlink.c:313 [inline]
 netlink_deliver_tap+0x9cb/0xc00 net/netlink/af_netlink.c:326
 netlink_deliver_tap_kernel net/netlink/af_netlink.c:335 [inline]
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x5e5/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x907/0xe10 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd3/0x130 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2336
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2390
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2423
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e219
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f735a38fc68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e219
RDX: 0000000020000000 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 000000000119bfc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007ffecded56ef R14: 00007f735a3909c0 R15: 000000000119bf8c
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
