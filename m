Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0642D90E1
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 23:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406692AbgLMWNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 17:13:51 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:36194 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731431AbgLMWNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 17:13:50 -0500
Received: by mail-io1-f71.google.com with SMTP id y197so9739346iof.3
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 14:13:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=w1iVowg0N/qJHYngp+HBkLQGVichd+3RsxM7hOiF15A=;
        b=Ok1k8Lwog9WXx+2I+JkRpcv7mio1mmV2QKIYgpEXYIfYGoqOKLIZ49itPHr5eErHTG
         /7IIN+zLfFNkSJNzUzM3BvRJO3q/d2mHHd+lbB/IH0frkc0RDz5tn7jxyvh4w+nP/e5e
         pRiFohsv4/qfONcc3Na7tj5Jmc/nn3L6my44BzZxJqveQr/pn7RuYOLcKB8lnyPgzK0v
         vstJpFCDMieV1oo7HNhYnPWol9xCLsIqyEMGvG/4xigEHH36r3EXgdE1+QRLohEV05Dx
         QPdSyc6B/YRwwbAeRTHB4UxL2q5I4NO03dXgXLJ/pF12H2jBcqZ+S3ttbWazq8EppNy8
         i2ZA==
X-Gm-Message-State: AOAM532cdsjp/23ZUzYSP2L7mJgAnDG2k5QiKCIQ4aoe2j50opunXr6z
        A9A4OfIOpf6fgAo+3i1tGmtUQM6ft0e2Mx/ARest7XWEwlG9
X-Google-Smtp-Source: ABdhPJy3JTr8hqGI3zGv/Wkdcx+RazBV8t/O0wjfDZjAg7HdB7z/TLVmseVqVktqODfQ2IusqJ7AbuAItL4bAzdFjI44jn30Phbu
MIME-Version: 1.0
X-Received: by 2002:a92:d8c4:: with SMTP id l4mr29201837ilo.38.1607897589768;
 Sun, 13 Dec 2020 14:13:09 -0800 (PST)
Date:   Sun, 13 Dec 2020 14:13:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ac68ed05b65fd4d2@google.com>
Subject: UBSAN: shift-out-of-bounds in hash_mac_create
From:   syzbot <syzbot+d66bfadebca46cf61a2b@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, vvs@virtuozzo.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a9e26cb5 Add linux-next specific files for 20201208
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16f05123500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e259434a8eaf0206
dashboard link: https://syzkaller.appspot.com/bug?extid=d66bfadebca46cf61a2b
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13afdcbd500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b14b37500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d66bfadebca46cf61a2b@syzkaller.appspotmail.com

================================================================================
UBSAN: shift-out-of-bounds in net/netfilter/ipset/ip_set_hash_gen.h:151:6
shift exponent 32 is too large for 32-bit type 'unsigned int'
CPU: 0 PID: 8498 Comm: syz-executor519 Not tainted 5.10.0-rc7-next-20201208-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 htable_bits net/netfilter/ipset/ip_set_hash_gen.h:151 [inline]
 hash_mac_create.cold+0x58/0x9b net/netfilter/ipset/ip_set_hash_gen.h:1524
 ip_set_create+0x610/0x1380 net/netfilter/ipset/ip_set_core.c:1115
 nfnetlink_rcv_msg+0xecc/0x1180 net/netfilter/nfnetlink.c:252
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:600
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x907/0xe40 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440419
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd29571ba8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440419
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000009 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000401c20
R13: 0000000000401cb0 R14: 0000000000000000 R15: 0000000000000000
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
