Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C75169FDD
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgBXISP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:18:15 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:54585 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgBXISO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 03:18:14 -0500
Received: by mail-il1-f199.google.com with SMTP id t4so16872379ili.21
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 00:18:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JLPU87tnj1f/dwZOZUf4sgSYUIjyyQgE9NDCtchiKHg=;
        b=HEpJAlp+e5de7zmQTvkLuZGycVah2HUjt9aObWQAzOmV/Ae/1/w7L+DsBRjt81pBfN
         p7SWZOwDRC2wiUd2d+wsFkTvrSeEuot8hUvBPyqgHCN9bfsbrHHKzAnmHgF58b4UGulU
         vJKomaHIMy+GIzJBB+hhKcFvEiOMwgpi7FeNV6NByPp6gkedYfMFH5JSQrRQigBf9e1B
         3vnqV1QuTeciB7ItURF0jRlvQVQbZajbpnLDpOer+Dpb8UXoeHr0iTqBR0ZnnPQuB9e0
         nkspTU/DCNqJjiEEWOIMnJeTCVqw5yi8vGpOdSwjS2Jimdmzl8FKnrZTionMOA9IecpZ
         Q6cg==
X-Gm-Message-State: APjAAAWvxvkJr7b5+gW8M668DUIltprPqqzSwfsErhNWf2epgRQhDOt/
        bnfubNk74Gu+LKiOzHjivjIQuk5Mn/NU0temQzkmX6Oyl8dV
X-Google-Smtp-Source: APXvYqweqrylK3pukroyPFpF1CqM/vmRCGM+KOrt5PclygW/HBOfAPZfaJMekDpiEsgrLRmdG8dMFShCCyW/LuXmtBU0b3/BSwvs
MIME-Version: 1.0
X-Received: by 2002:a92:3a07:: with SMTP id h7mr57387937ila.203.1582532294128;
 Mon, 24 Feb 2020 00:18:14 -0800 (PST)
Date:   Mon, 24 Feb 2020 00:18:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003cbb40059f4e0346@google.com>
Subject: kernel panic: audit: backlog limit exceeded
From:   syzbot <syzbot+9a5e789e4725b9ef1316@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        dan.carpenter@oracle.com, davem@davemloft.net, eparis@redhat.com,
        fzago@cray.com, gregkh@linuxfoundation.org, john.hammond@intel.com,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        paul@paul-moore.com, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    36a44bcd Merge branch 'bnxt_en-shutdown-and-kexec-kdump-re..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=148bfdd9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=768cc3d3e277cc16
dashboard link: https://syzkaller.appspot.com/bug?extid=9a5e789e4725b9ef1316
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=151b1109e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=128bfdd9e00000

The bug was bisected to:

commit 0c1b9970ddd4cc41002321c3877e7f91aacb896d
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Fri Jul 28 14:42:27 2017 +0000

    staging: lustre: lustre: Off by two in lmv_fid2path()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17e6c3e9e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1416c3e9e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1016c3e9e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9a5e789e4725b9ef1316@syzkaller.appspotmail.com
Fixes: 0c1b9970ddd4 ("staging: lustre: lustre: Off by two in lmv_fid2path()")

audit: audit_backlog=13 > audit_backlog_limit=7
audit: audit_lost=1 audit_rate_limit=0 audit_backlog_limit=7
Kernel panic - not syncing: audit: backlog limit exceeded
CPU: 1 PID: 9913 Comm: syz-executor024 Not tainted 5.6.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 audit_panic.cold+0x32/0x32 kernel/audit.c:307
 audit_log_lost kernel/audit.c:377 [inline]
 audit_log_lost+0x8b/0x180 kernel/audit.c:349
 audit_log_start kernel/audit.c:1788 [inline]
 audit_log_start+0x70e/0x7c0 kernel/audit.c:1745
 audit_log+0x95/0x120 kernel/audit.c:2345
 xt_replace_table+0x61d/0x830 net/netfilter/x_tables.c:1413
 __do_replace+0x1da/0x950 net/ipv6/netfilter/ip6_tables.c:1084
 do_replace net/ipv6/netfilter/ip6_tables.c:1157 [inline]
 do_ip6t_set_ctl+0x33a/0x4c8 net/ipv6/netfilter/ip6_tables.c:1681
 nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
 nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
 ipv6_setsockopt net/ipv6/ipv6_sockglue.c:949 [inline]
 ipv6_setsockopt+0x147/0x180 net/ipv6/ipv6_sockglue.c:933
 tcp_setsockopt net/ipv4/tcp.c:3165 [inline]
 tcp_setsockopt+0x8f/0xe0 net/ipv4/tcp.c:3159
 sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
 __sys_setsockopt+0x261/0x4c0 net/socket.c:2130
 __do_sys_setsockopt net/socket.c:2146 [inline]
 __se_sys_setsockopt net/socket.c:2143 [inline]
 __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2143
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x44720a
Code: 49 89 ca b8 37 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 1a e0 fb ff c3 66 0f 1f 84 00 00 00 00 00 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 fa df fb ff c3 66 0f 1f 84 00 00 00 00 00
RSP: 002b:00007ffd032dec78 EFLAGS: 00000286 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000044720a
RDX: 0000000000000040 RSI: 0000000000000029 RDI: 0000000000000003
RBP: 00007ffd032deda0 R08: 00000000000003b8 R09: 0000000000004000
R10: 00000000006d7b40 R11: 0000000000000286 R12: 00007ffd032deca0
R13: 00000000006d9d60 R14: 0000000000000029 R15: 00000000006d7ba0
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
