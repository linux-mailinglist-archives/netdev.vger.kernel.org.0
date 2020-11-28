Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1631D2C7453
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388639AbgK1Vtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:42 -0500
Received: from mail-pg1-f200.google.com ([209.85.215.200]:33454 "EHLO
        mail-pg1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733151AbgK1R7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 12:59:54 -0500
Received: by mail-pg1-f200.google.com with SMTP id c4so5733493pgb.0
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 09:59:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=YA1jEZH9DUw8fd/5LkjY5oTcYXBqQ8fvTP8D6li4UzQ=;
        b=bmu+L5GMvTMev223cBS2u/WpXvTRn8hZcK2NxUMjrphqh6p2gudooKB43sLNB1qwHd
         Y3Rg8D/bcLLkPaJfl9l3xY+mEPXOp/57IxxTWv1HOMb7nMPce0T07o88xRFwKzJqefZm
         S0uzaJ+lr+KlpPtHjDUEePcoLadGI+PpHFvP9sv+3UFzpAgio4Qof8ahXhRX5YZdwRld
         rlGjGiTU3jJk2L8h9ujj92KgxpHL6kGW9KqyeJ1dFFw1HgAlAcB4JKSnq1EFDnGAgsRN
         nRfQsEHINz60nFZglkGcnLi+lqVPWe8Ne/QLORkXs5Mx2RDjdEjLRqS9wjLs1BUTHPon
         OPxg==
X-Gm-Message-State: AOAM5301ypbqPDooh8G45txEfen3NSvigHmifeyrSEblAyGM/t9/0aoQ
        hv/+pzgbU96sq7hipdopwT6EEWNuzU5Dwt5y4HdsP7gtimoS
X-Google-Smtp-Source: ABdhPJyji2gDC7WtN/ChYTST3Mwi2LaRMQWgD2FMydNRqtUmm2JR0gkHJNwTIteZk+3bc00MYoW0F50xK+J9dY8xnE7Lc3BcfgGg
MIME-Version: 1.0
X-Received: by 2002:a92:358a:: with SMTP id c10mr12024363ilf.258.1606577833855;
 Sat, 28 Nov 2020 07:37:13 -0800 (PST)
Date:   Sat, 28 Nov 2020 07:37:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001750e305b52c8d02@google.com>
Subject: KMSAN: uninit-value in validate_beacon_head
From:   syzbot <syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    73d62e81 kmsan: random: prevent boot-time reports in _mix_..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=164bda95500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eef728deea880383
dashboard link: https://syzkaller.appspot.com/bug?extid=72b99dcf4607e8c770f3
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in validate_beacon_head+0x51e/0x5c0 net/wireless/nl80211.c:225
CPU: 1 PID: 21060 Comm: syz-executor.4 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 validate_beacon_head+0x51e/0x5c0 net/wireless/nl80211.c:225
 validate_nla lib/nlattr.c:544 [inline]
 __nla_validate_parse+0x241a/0x4e00 lib/nlattr.c:588
 __nla_parse+0x141/0x150 lib/nlattr.c:685
 __nlmsg_parse include/net/netlink.h:733 [inline]
 genl_family_rcv_msg_attrs_parse+0x417/0x5a0 net/netlink/genetlink.c:548
 genl_family_rcv_msg_doit net/netlink/genetlink.c:717 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0xbd9/0x1610 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x70a/0x820 net/netlink/af_netlink.c:2494
 genl_rcv+0x63/0x80 net/netlink/genetlink.c:811
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
RIP: 0023:0xf7fa8549
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f55a20cc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020000380
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

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
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
