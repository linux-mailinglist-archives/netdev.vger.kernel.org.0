Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E64148967C
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 11:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244037AbiAJKhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 05:37:23 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:53200 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244041AbiAJKhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 05:37:20 -0500
Received: by mail-io1-f71.google.com with SMTP id g26-20020a056602243a00b00604a6a4e0e9so4187176iob.19
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 02:37:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cF9yMMM0LXw4+7p5DQb3zA2JCMu73Tc7rO6lZ4gxgdY=;
        b=O0elwD3I+3htZMEC08Z5Lg3H0c/riDBVaZlWed7HPlaiXrbiCqkehEBgSoUXDapKYA
         fJ4jIwU5mhOJymTvAhshDSarc6KWof9f/k6IzriZW4QOtWAPrsHOhasePl/1wjydTfxi
         X1mbUjtTjKBNxmep+641t/21gCBzWkzyiLGvoGc7rMt2EGwf4xiZ9HLJC5+Dbp5IPoa9
         bskU6xbUJaC5yXqLcMgb5IGphixwKkS0MckdBleTGN/Raa87OQCIjoVxdghVMPgOM9jr
         u6GI92ZyvhqtFGo7qK6Xnos7mAoUdwIpPw0LjtHcqa5VjpItUo0sHvl4YzPsyOgfCxKM
         vEPA==
X-Gm-Message-State: AOAM532DWGiezDE91WjC+exL0y6IQhKkKneuAo4vmREqp+dHfYNvGvQb
        oicmI8ZUUCXQMfxxm8+/whlq/d8Zxch2M1sOHpY4QIgE3Tr0
X-Google-Smtp-Source: ABdhPJwK7h9XQeOTKKEbkI+yM+q6pIh7wdRTvuICG7cv2ZF8jJlbbXiqTqqpMvQjBMy0uXymJNvZ/e0uYFB5r8oI/hXaMC+dyQcP
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2507:: with SMTP id v7mr34538579jat.70.1641811039627;
 Mon, 10 Jan 2022 02:37:19 -0800 (PST)
Date:   Mon, 10 Jan 2022 02:37:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ce327f05d537ebf7@google.com>
Subject: [syzbot] WARNING: bad unlock balance in rxrpc_do_sendmsg
From:   syzbot <syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        marc.dionne@auristor.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    438645193e59 Merge tag 'pinctrl-v5.16-3' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17046cfdb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=48863e33ecce99a5
dashboard link: https://syzkaller.appspot.com/bug?extid=7f0483225d0c94cb3441
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a9dd99b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12fdd6fdb00000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16a5b595b00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15a5b595b00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11a5b595b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com

=====================================
WARNING: bad unlock balance detected!
5.16.0-rc6-syzkaller #0 Not tainted
-------------------------------------
syz-executor011/3597 is trying to release lock (&call->user_mutex) at:
[<ffffffff885163a3>] rxrpc_do_sendmsg+0xc13/0x1350 net/rxrpc/sendmsg.c:748
but there are no more locks to release!

other info that might help us debug this:
no locks held by syz-executor011/3597.

stack backtrace:
CPU: 1 PID: 3597 Comm: syz-executor011 Not tainted 5.16.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_unlock_imbalance_bug include/trace/events/lock.h:58 [inline]
 __lock_release kernel/locking/lockdep.c:5306 [inline]
 lock_release.cold+0x49/0x4e kernel/locking/lockdep.c:5657
 __mutex_unlock_slowpath+0x99/0x5e0 kernel/locking/mutex.c:900
 rxrpc_do_sendmsg+0xc13/0x1350 net/rxrpc/sendmsg.c:748
 rxrpc_sendmsg+0x420/0x630 net/rxrpc/af_rxrpc.c:561
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f65339e7df9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 81 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f653399a318 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f6533a703e8 RCX: 00007f65339e7df9
RDX: 00


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
