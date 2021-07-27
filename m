Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFD33D7548
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 14:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhG0MrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 08:47:24 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:54002 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbhG0MrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 08:47:21 -0400
Received: by mail-io1-f72.google.com with SMTP id w3-20020a0566020343b02905393057ad92so10977767iou.20
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 05:47:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2d+TOuGtvJGgz3vuVsGSX8Tp9+Eg4KJ09YS1h9Stn6Q=;
        b=t+P+YhWDkJv4fycJNS4DbmWibVFF4yg3Jr70WXYRfzppdVaiR6cqzKR/ZmWRyaCOTS
         FOIRpNgk1iVeUhzGydZL8Dt9swpBv/Mg8GlEXsXOlTgdJiJuzjVAAqp486cDS+P8VFxH
         M5kjq66aEGjaukGr8Tq7h3hUBpsdOD7ibAUkfkycskfXlvXUBB1OCA/zFsi0+adbp27F
         RoafM4ZKIUg0rZdrSf3PEn+22GCmPTvrhE6dj4M8CvbPhJU5IjuS1Vrtu73DFnFosoIV
         W70Yq6qEJLxlKzKO0tj4YhcIvhqRCYmss1Wy2AaZu+f5k5qJWuFHrcaRWu4mZZ4DVO+B
         eKaQ==
X-Gm-Message-State: AOAM532MUR81qebpu94DUV/KdDmaoHaVvUiPWhoCPDRwFp3WGZykPPj4
        BKJj9tIj00Ye7RlumBW9r0QYmBHwIno3Bkr9oEBtI9S9O8q2
X-Google-Smtp-Source: ABdhPJySr5hZvAcfZg5mG19/JowkwPOV8j5zj0KK5mItwRcXbf6jOEhgftmFtUw/svz5f72wnPDiUicllXxB1xUfQSaqxUh108WO
MIME-Version: 1.0
X-Received: by 2002:a02:85a5:: with SMTP id d34mr21210692jai.132.1627390041086;
 Tue, 27 Jul 2021 05:47:21 -0700 (PDT)
Date:   Tue, 27 Jul 2021 05:47:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004f5de905c81a45e7@google.com>
Subject: [syzbot] UBSAN: shift-out-of-bounds in xfrm_set_default
From:   syzbot <syzbot+9cd5837a045bbee5b810@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    90d856e71443 Add linux-next specific files for 20210723
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=133fd00a300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=298516715f6ad5cd
dashboard link: https://syzkaller.appspot.com/bug?extid=9cd5837a045bbee5b810
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1263bba6300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1066b4d4300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9cd5837a045bbee5b810@syzkaller.appspotmail.com

netlink: 228 bytes leftover after parsing attributes in process `syz-executor669'.
================================================================================
UBSAN: shift-out-of-bounds in net/xfrm/xfrm_user.c:1969:18
shift exponent 255 is too large for 32-bit type 'int'
CPU: 0 PID: 8437 Comm: syz-executor669 Not tainted 5.14.0-rc2-next-20210723-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:327
 xfrm_set_default.cold+0x21/0x102 net/xfrm/xfrm_user.c:1969
 xfrm_user_rcv_msg+0x430/0xa20 net/xfrm/xfrm_user.c:2864
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2886
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f0d9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc71f859f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f0d9
RDX: 0000000000000000 RSI: 0000000020000740 RDI: 0000000000000003
RBP: 00000000004030c0 R08: 0000000000000000 R09: 0000000000400488
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000403150
R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
