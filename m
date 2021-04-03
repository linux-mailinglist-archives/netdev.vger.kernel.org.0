Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2DB353218
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 04:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbhDCCWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 22:22:21 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:51835 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbhDCCWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 22:22:20 -0400
Received: by mail-io1-f69.google.com with SMTP id s13so7184158iow.18
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 19:22:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yojHr0LL9tcz8C/ih+uZXwDOxxsE8tJwilH+vxkwGEU=;
        b=nVz8h3f9nrMsh2JU/rR9Z201uofHokqvbaSnDfdgWoosqetM/pMp1Rc2aHJnx2D+OB
         tIcsGN5wnZSp+F9kUxHUWPdW9+8LJDUWfRH0FxMZxEQWp9mgMD1KNLxJ2bQeSKuO8yvY
         IsV/V/iNNXEb+RNbErH3eYWCfFqqNqjkSY3dDyQqRylEASoPpPGM1oetsiC0V5O1W3fG
         0meEtUT05YJyYRA9w+nc4d7NZ1LCZPvaqcLna12bLfkUcScnL7iplI/5q9lD5hy9muri
         u0JWSPtRjNmPsbiheo4rqRZLrc5Jc/1gY6NgACPWR9690jJIGJa7vjnnG9Ajee/Cf23K
         H4Xg==
X-Gm-Message-State: AOAM533nJLYYpivdbDYr2IHppKiHR+HgNUiqzIjgKn+f8F6X0qm03TQv
        hyThdFtiWrZETZcvG8CvxMJj5QQUeJn8se6c0oZEakDxnOpw
X-Google-Smtp-Source: ABdhPJyBAx5lpsWCs2cfBehnz27AczKqw16RcM1me3OBSZwRId03i5qPHagW0vP7xRMo5UKXyafMcKO0ycDaUet4TolL/MQdcZaA
MIME-Version: 1.0
X-Received: by 2002:a5d:9917:: with SMTP id x23mr12821675iol.22.1617416537245;
 Fri, 02 Apr 2021 19:22:17 -0700 (PDT)
Date:   Fri, 02 Apr 2021 19:22:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000028104905bf0822ce@google.com>
Subject: [syzbot] WARNING: suspicious RCU usage in find_inlist_lock
From:   syzbot <syzbot+b221933e5f9ad5b0e2fd@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        nikolay@nvidia.com, pablo@netfilter.org, roopa@nvidia.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1e43c377 Merge tag 'xtensa-20210329' of git://github.com/j..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=114cdd4ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=78ef1d159159890
dashboard link: https://syzkaller.appspot.com/bug?extid=b221933e5f9ad5b0e2fd

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b221933e5f9ad5b0e2fd@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.12.0-rc5-syzkaller #0 Not tainted
-----------------------------
kernel/sched/core.c:8294 Illegal context switch in RCU-sched read-side critical section!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 0
no locks held by syz-executor.1/8425.

stack backtrace:
CPU: 1 PID: 8425 Comm: syz-executor.1 Not tainted 5.12.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ___might_sleep+0x266/0x2c0 kernel/sched/core.c:8294
 __mutex_lock_common kernel/locking/mutex.c:928 [inline]
 __mutex_lock+0xa9/0x1120 kernel/locking/mutex.c:1096
 find_inlist_lock_noload net/bridge/netfilter/ebtables.c:316 [inline]
 find_inlist_lock.constprop.0+0x26/0x220 net/bridge/netfilter/ebtables.c:330
 find_table_lock net/bridge/netfilter/ebtables.c:339 [inline]
 do_ebt_get_ctl+0x208/0x790 net/bridge/netfilter/ebtables.c:2329
 nf_getsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:116
 ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
 ip_getsockopt+0x164/0x1c0 net/ipv4/ip_sockglue.c:1756
 tcp_getsockopt+0x86/0xd0 net/ipv4/tcp.c:4239
 __sys_getsockopt+0x21f/0x5f0 net/socket.c:2161
 __do_sys_getsockopt net/socket.c:2176 [inline]
 __se_sys_getsockopt net/socket.c:2173 [inline]
 __x64_sys_getsockopt+0xba/0x150 net/socket.c:2173
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x467a6a
Code: 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe660d82f8 EFLAGS: 00000202 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00000000005401a0 RCX: 0000000000467a6a
RDX: 0000000000000081 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffe660d831c R09: 00007ffe660d83a0
R10: 00007ffe660d8320 R11: 0000000000000202 R12: 0000000000000003
R13: 00007ffe660d8320 R14: 0000000000540128 R15: 00007ffe660d831c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
