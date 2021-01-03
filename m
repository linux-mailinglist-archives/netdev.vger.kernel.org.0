Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D802E8B3C
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 08:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbhACG7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 01:59:53 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:51544 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbhACG7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 01:59:52 -0500
Received: by mail-io1-f71.google.com with SMTP id h206so9928481iof.18
        for <netdev@vger.kernel.org>; Sat, 02 Jan 2021 22:59:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SKFTyH6GpSngEjt28zWqwVmWACXNO7dXtaBjX92qW1o=;
        b=nMxw4JZzzRdBEtQPPQVYH9ZOPI+Ehi1a3UZqkWEa0dggVqaDYkhvR+N1zq9qOj4JEU
         xcG8Xopo5Vxi5x9ELnh1Y1IBnfnz5NHpzqBaym7nv/mmQ/3plRYYiY2ZILAkPL7CS6fG
         dsO5nXg7VjKwcDqoWiBmXjygx61VbYMfVkRHitBdBuqBU841qmknPLYnJyzDdXxxxgeT
         I8foPMRxDYBAnM0fJ5oShbteVvEKzQ3HIHn61vrIp9EUbH1MSqOdZFH4Z82AwQfIATMn
         SS0n63E1D25UIquJjEWyzf6BUoh7qrEfAe8vXVMoz47fQZW1N8tFPicvmSLlgo+gm4Rd
         9xoQ==
X-Gm-Message-State: AOAM53045chNDcAFPtxReFFr94Cy53nN3sTVIOVN6U5WfTSbjisbnDHc
        F/Cj2os5h4Sx3cjpzRl0zy+4VLcUN5G1uiz5vx/Im07ATIpV
X-Google-Smtp-Source: ABdhPJx9lgYc0IRnirJhJY5Y5hI/5Ca36a+lcRmG6EQgu7U40hbcm6w6qQUyPvFIIs3dP+vaHTZfQWP6jPqge1KMaDSPN/Q5XZpz
MIME-Version: 1.0
X-Received: by 2002:a6b:3f54:: with SMTP id m81mr53996917ioa.113.1609657151611;
 Sat, 02 Jan 2021 22:59:11 -0800 (PST)
Date:   Sat, 02 Jan 2021 22:59:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bb654d05b7f98286@google.com>
Subject: KMSAN: uninit-value in xfrm_user_rcv_msg_compat
From:   syzbot <syzbot+f00248cacdd6d71ea79c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com,
        herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    73d62e81 kmsan: random: prevent boot-time reports in _mix_..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=17e7a0eb500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2cdf4151c9653e32
dashboard link: https://syzkaller.appspot.com/bug?extid=f00248cacdd6d71ea79c
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f00248cacdd6d71ea79c@syzkaller.appspotmail.com

netlink: 8 bytes leftover after parsing attributes in process `syz-executor.3'.
=====================================================
BUG: KMSAN: uninit-value in xfrm_user_rcv_msg_compat+0x1c7b/0x1ec0 net/xfrm/xfrm_compat.c:562
CPU: 0 PID: 12365 Comm: syz-executor.3 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 xfrm_user_rcv_msg_compat+0x1c7b/0x1ec0 net/xfrm/xfrm_compat.c:562
 xfrm_user_rcv_msg+0x489/0xf20 net/xfrm/xfrm_user.c:2714
 netlink_rcv_skb+0x70a/0x820 net/netlink/af_netlink.c:2494
 xfrm_netlink_rcv+0xb2/0xf0 net/xfrm/xfrm_user.c:2764
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x11da/0x14b0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x173c/0x1840 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0xc7a/0x1240 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x6d5/0x830 net/socket.c:2440
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:80 [inline]
 __do_fast_syscall_32+0x102/0x160 arch/x86/entry/common.c:139
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:162
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:205
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f10549
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f550a0cc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020000100
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Local variable ----attrs@xfrm_user_rcv_msg_compat created at:
 xfrm_user_rcv_msg_compat+0xf7/0x1ec0 net/xfrm/xfrm_compat.c:539
 xfrm_user_rcv_msg_compat+0xf7/0x1ec0 net/xfrm/xfrm_compat.c:539
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
