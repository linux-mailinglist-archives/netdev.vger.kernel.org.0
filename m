Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62C1488236
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 09:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbiAHIA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 03:00:28 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:39685 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbiAHIAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 03:00:25 -0500
Received: by mail-io1-f69.google.com with SMTP id m6-20020a0566022e8600b005ec18906edaso5969785iow.6
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 00:00:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zoA6QDxz3PS7MAyLWApYsQnm2pFkixHDdjsPGCEpEk0=;
        b=C82v/uLFPkYltSS0Ne5ySZK0rMsgiQjYF2d1nBrxX4DTs3bX+yIaN+fzKrcnbdmES3
         lZxbV0VRFI7jvst0P4f4yXt45YM9sSTn/Cja1Wr6oDiCvR1/mR2hk15+ZYPcgzyapbga
         wR6UvyeLPBCxvk3DEHel60uSGzo2DS0rWVs7W6c5eGeNs0aCX4fqwLU1pTs7Wfj4ypYl
         gyLS7Fk4C2jc4AEImKqyuaEjnlKnvaPLCG771OHu/Zb9Pq/Lrq5JGQT1vk1YCxudZWOE
         IcW8IorrsG+VE6hEPIt0ViEZ32aTpzs2Q6TTMdjnDZs1NBRp7Z4sDpO+NYvsqqFuGzRj
         3k/Q==
X-Gm-Message-State: AOAM533eBC7YAhLzt6SWbmucSOGukU2DX3RAruADrufwi/9tMIqrFz8k
        /8sH4Y6rRDWnqgPIgwMFjA9hb5BgsEqvS/YeNEqiKDm6JnBn
X-Google-Smtp-Source: ABdhPJxxpIIw13W+L4C0NlnaAdtY0cniTk8F77x4I1lVeU+b4ButZnGQ6oEy6MS0PSxZFLkoX7rS/l+itUJumD6f0ADmOF3fZEVX
MIME-Version: 1.0
X-Received: by 2002:a92:dc8c:: with SMTP id c12mr29429570iln.43.1641628825031;
 Sat, 08 Jan 2022 00:00:25 -0800 (PST)
Date:   Sat, 08 Jan 2022 00:00:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f81aa305d50d7e4c@google.com>
Subject: [syzbot] KMSAN: uninit-value in sctp_inq_pop (2)
From:   syzbot <syzbot+70a42f45e76bede082be@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    81c325bbf94e kmsan: hooks: do not check memory in kmsan_in..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=15dad2c3b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2d8b9a11641dc9aa
dashboard link: https://syzkaller.appspot.com/bug?extid=70a42f45e76bede082be
compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=173a7b0db00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14de2ffdb00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+70a42f45e76bede082be@syzkaller.appspotmail.com

netlink: 244 bytes leftover after parsing attributes in process `syz-executor678'.
=====================================================
BUG: KMSAN: uninit-value in sctp_inq_pop+0x15c8/0x18f0 net/sctp/inqueue.c:205
 sctp_inq_pop+0x15c8/0x18f0 net/sctp/inqueue.c:205
 sctp_assoc_bh_rcv+0x1fa/0xdd0 net/sctp/associola.c:1000
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_backlog_rcv+0x30f/0x10b0 net/sctp/input.c:344
 sk_backlog_rcv include/net/sock.h:1030 [inline]
 __release_sock+0x256/0x640 net/core/sock.c:2768
 release_sock+0x98/0x2e0 net/core/sock.c:3300
 sctp_wait_for_connect+0x52a/0x9e0 net/sctp/socket.c:9306
 sctp_sendmsg_to_asoc+0x1c47/0x1f90 net/sctp/socket.c:1881
 sctp_sendmsg+0x3eaa/0x5460 net/sctp/socket.c:2027
 inet_sendmsg+0x15b/0x1d0 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 __sys_sendto+0x9ef/0xc70 net/socket.c:2036
 __do_sys_sendto net/socket.c:2048 [inline]
 __se_sys_sendto net/socket.c:2044 [inline]
 __x64_sys_sendto+0x19c/0x210 net/socket.c:2044
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was stored to memory at:
 sctp_inq_pop+0x155c/0x18f0 net/sctp/inqueue.c:201
 sctp_assoc_bh_rcv+0x1fa/0xdd0 net/sctp/associola.c:1000
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_backlog_rcv+0x30f/0x10b0 net/sctp/input.c:344
 sk_backlog_rcv include/net/sock.h:1030 [inline]
 __release_sock+0x256/0x640 net/core/sock.c:2768
 release_sock+0x98/0x2e0 net/core/sock.c:3300
 sctp_wait_for_connect+0x52a/0x9e0 net/sctp/socket.c:9306
 sctp_sendmsg_to_asoc+0x1c47/0x1f90 net/sctp/socket.c:1881
 sctp_sendmsg+0x3eaa/0x5460 net/sctp/socket.c:2027
 inet_sendmsg+0x15b/0x1d0 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 __sys_sendto+0x9ef/0xc70 net/socket.c:2036
 __do_sys_sendto net/socket.c:2048 [inline]
 __se_sys_sendto net/socket.c:2044 [inline]
 __x64_sys_sendto+0x19c/0x210 net/socket.c:2044
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:3251 [inline]
 __kmalloc_node_track_caller+0xe0c/0x1510 mm/slub.c:4974
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1126 [inline]
 sctp_packet_pack net/sctp/output.c:471 [inline]
 sctp_packet_transmit+0x194c/0x45a0 net/sctp/output.c:620
 sctp_outq_flush_transports net/sctp/outqueue.c:1163 [inline]
 sctp_outq_flush+0x17d9/0x5eb0 net/sctp/outqueue.c:1211
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_side_effects net/sctp/sm_sideeffect.c:1195 [inline]
 sctp_do_sm+0x946f/0x9b50 net/sctp/sm_sideeffect.c:1166
 sctp_assoc_bh_rcv+0xa15/0xdd0 net/sctp/associola.c:1054
 sctp_inq_push+0x31c/0x440 net/sctp/inqueue.c:80
 sctp_backlog_rcv+0x30f/0x10b0 net/sctp/input.c:344
 sk_backlog_rcv include/net/sock.h:1030 [inline]
 __release_sock+0x256/0x640 net/core/sock.c:2768
 release_sock+0x98/0x2e0 net/core/sock.c:3300
 sctp_wait_for_connect+0x52a/0x9e0 net/sctp/socket.c:9306
 sctp_sendmsg_to_asoc+0x1c47/0x1f90 net/sctp/socket.c:1881
 sctp_sendmsg+0x3eaa/0x5460 net/sctp/socket.c:2027
 inet_sendmsg+0x15b/0x1d0 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 __sys_sendto+0x9ef/0xc70 net/socket.c:2036
 __do_sys_sendto net/socket.c:2048 [inline]
 __se_sys_sendto net/socket.c:2044 [inline]
 __x64_sys_sendto+0x19c/0x210 net/socket.c:2044
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

CPU: 0 PID: 3479 Comm: syz-executor678 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
