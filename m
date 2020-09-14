Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D6F26885A
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 11:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgINJaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 05:30:24 -0400
Received: from mail-il1-f207.google.com ([209.85.166.207]:38184 "EHLO
        mail-il1-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgINJ3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 05:29:18 -0400
Received: by mail-il1-f207.google.com with SMTP id m10so12234099ild.5
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 02:29:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TH4I0FLdiIpGQ5Tl/2ypovGARPOu1ONo1HGqptIa4OQ=;
        b=slKBczRYWi9zQlZf054IDE/2P9cQE9sxiFQpQwsxFPEXL33kpmx3UYYZ+KKtX1KTEc
         tnVF06E7uNZwIj9wLWSUuDCMnhLXk7ZgGt9K8jsUdn2fPXF7fGV7pulMS8XIlzCVzjFG
         uoM2dFjD1332A63x5RMaSn0SVZ7gkcsv27lhCoTEAOadiS6089glEKEcmXnUm10voDry
         Y0LVZBEvqnHrzMz/H9l9VcMTPrWzOZQrpb4ENQKIAk623fnanPtkDD8SgWBUaTY0Ok0t
         TUn1QJxMZddliFnx7pn+n3nv78n+GHM0wiUVSIBs791YnIgTjXE3Z7mvuWqTXek8kyUt
         yHxA==
X-Gm-Message-State: AOAM531yhGdFLFPa1pR6gJyDg3Y0d16KluPa6vjwnIiPwntYkrTQaPWy
        dzHZgq7CqBVqFtn7k/Nmz7uuAAbKe4yAhll3MzwOMhFVo7pl
X-Google-Smtp-Source: ABdhPJzP23iVG+WXX/FkJ2v54zMWyx+UEXTrxJNY+GFVWlpIiEJEP44cezQz5Ln1yXBtRMM98RGo39wurcMIIk41Im6zXNAL0w0f
MIME-Version: 1.0
X-Received: by 2002:a92:dc47:: with SMTP id x7mr2965857ilq.127.1600075756567;
 Mon, 14 Sep 2020 02:29:16 -0700 (PDT)
Date:   Mon, 14 Sep 2020 02:29:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000015820705af42ab4d@google.com>
Subject: INFO: trying to register non-static key in cfg80211_release_pmsr
From:   syzbot <syzbot+7c0d914f0ea7b89ad50c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7fe10096 Merge branch 'linus' of git://git.kernel.org/pub/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1655e245900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a9075b36a6ae26c9
dashboard link: https://syzkaller.appspot.com/bug?extid=7c0d914f0ea7b89ad50c
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7c0d914f0ea7b89ad50c@syzkaller.appspotmail.com

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 1483 Comm: syz-executor.4 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 assign_lock_key kernel/locking/lockdep.c:894 [inline]
 register_lock_class+0x157d/0x1630 kernel/locking/lockdep.c:1206
 __lock_acquire+0xf9/0x5570 kernel/locking/lockdep.c:4305
 lock_acquire+0x1f3/0xae0 kernel/locking/lockdep.c:5006
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 cfg80211_release_pmsr+0x33/0x166 net/wireless/pmsr.c:621
 nl80211_netlink_notify net/wireless/nl80211.c:17301 [inline]
 nl80211_netlink_notify+0x32e/0x970 net/wireless/nl80211.c:17265
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 __blocking_notifier_call_chain kernel/notifier.c:284 [inline]
 __blocking_notifier_call_chain kernel/notifier.c:271 [inline]
 blocking_notifier_call_chain kernel/notifier.c:295 [inline]
 blocking_notifier_call_chain+0x67/0x90 kernel/notifier.c:292
 netlink_release+0xc51/0x1cf0 net/netlink/af_netlink.c:775
 __sock_release+0xcd/0x280 net/socket.c:596
 sock_close+0x18/0x20 net/socket.c:1277
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:163 [inline]
 exit_to_user_mode_prepare+0x1e1/0x200 kernel/entry/common.c:190
 syscall_exit_to_user_mode+0x7e/0x2e0 kernel/entry/common.c:265
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x416f01
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007fe5ec9199c0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 00007fe5ec919a40 RCX: 0000000000416f01
RDX: 0000000000000200 RSI: 00007fe5ec919a40 RDI: 0000000000000004
RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000004
R13: 000000000169fb6f R14: 00007fe5ec91a9c0 R15: 000000000118cf4c
BUG: unable to handle page fault for address: ffffffffffffffec
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 9a90067 P4D 9a90067 PUD 9a92067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 1483 Comm: syz-executor.4 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:cfg80211_release_pmsr+0xce/0x166 net/wireless/pmsr.c:623
Code: 39 c5 74 6b e8 f3 a6 e8 f9 48 8d 7b 14 48 89 f8 48 c1 e8 03 42 0f b6 14 20 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 62 <44> 8b 7b 14 89 ee 44 89 ff e8 c4 a2 e8 f9 41 39 ef 75 9f e8 ba a6
RSP: 0018:ffffc90018e2fbe0 EFLAGS: 00010246
RAX: 0000000000000007 RBX: ffffffffffffffd8 RCX: ffffc90010d5b000
RDX: 0000000000000000 RSI: ffffffff878ba68d RDI: ffffffffffffffec
RBP: 0000000000001751 R08: 0000000000000001 R09: 0000000000000003
R10: fffff520031c5f6e R11: 0000000038343154 R12: dffffc0000000000
R13: ffff8880001010e0 R14: ffff888000100c10 R15: 0000000000000000
FS:  00007fe5ec91a700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffec CR3: 000000020d667000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 nl80211_netlink_notify net/wireless/nl80211.c:17301 [inline]
 nl80211_netlink_notify+0x32e/0x970 net/wireless/nl80211.c:17265
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 __blocking_notifier_call_chain kernel/notifier.c:284 [inline]
 __blocking_notifier_call_chain kernel/notifier.c:271 [inline]
 blocking_notifier_call_chain kernel/notifier.c:295 [inline]
 blocking_notifier_call_chain+0x67/0x90 kernel/notifier.c:292
 netlink_release+0xc51/0x1cf0 net/netlink/af_netlink.c:775
 __sock_release+0xcd/0x280 net/socket.c:596
 sock_close+0x18/0x20 net/socket.c:1277
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:163 [inline]
 exit_to_user_mode_prepare+0x1e1/0x200 kernel/entry/common.c:190
 syscall_exit_to_user_mode+0x7e/0x2e0 kernel/entry/common.c:265
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x416f01
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007fe5ec9199c0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 00007fe5ec919a40 RCX: 0000000000416f01
RDX: 0000000000000200 RSI: 00007fe5ec919a40 RDI: 0000000000000004
RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000004
R13: 000000000169fb6f R14: 00007fe5ec91a9c0 R15: 000000000118cf4c
Modules linked in:
CR2: ffffffffffffffec
---[ end trace 5d967f6ee373c846 ]---
RIP: 0010:cfg80211_release_pmsr+0xce/0x166 net/wireless/pmsr.c:623
Code: 39 c5 74 6b e8 f3 a6 e8 f9 48 8d 7b 14 48 89 f8 48 c1 e8 03 42 0f b6 14 20 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 62 <44> 8b 7b 14 89 ee 44 89 ff e8 c4 a2 e8 f9 41 39 ef 75 9f e8 ba a6
RSP: 0018:ffffc90018e2fbe0 EFLAGS: 00010246
RAX: 0000000000000007 RBX: ffffffffffffffd8 RCX: ffffc90010d5b000
RDX: 0000000000000000 RSI: ffffffff878ba68d RDI: ffffffffffffffec
RBP: 0000000000001751 R08: 0000000000000001 R09: 0000000000000003
R10: fffff520031c5f6e R11: 0000000038343154 R12: dffffc0000000000
R13: ffff8880001010e0 R14: ffff888000100c10 R15: 0000000000000000
FS:  00007fe5ec91a700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffec CR3: 000000020d667000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
