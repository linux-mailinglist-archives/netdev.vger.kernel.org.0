Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169EC235A4A
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 21:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgHBT70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 15:59:26 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:35056 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgHBT70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 15:59:26 -0400
Received: by mail-il1-f197.google.com with SMTP id g6so11043101iln.2
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 12:59:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=F10XM7hC+E3LYcPRivzOjDTSVfMfyhzmJcx4FWkMrXc=;
        b=gWT9/CNrtfELT/IaFZ3u3/oMqHRa1YAfdVz5HrrhJpm4lef+Dqovr0b9pvFSeWzLBo
         EWCuCwU8bbmd9zUZGhqSGjL0M00i+Kz+8xE09XrB9U37t4zsdrehtwwCrDdEhaeuzC7K
         ZyWaPWF19TjSuhuGiN/1JG4wk8OfOKF/uNJ7JZmN5wHWTEEQGUnGteddw9zLJUYlq3aO
         ZGSwH8tRSm6PhnJuJvl6AeBAxp5P5OBWEifuuyrgJE9QZyTk8Jq8FA0XFIXn/tvGBTdj
         /JLiwFaHZjIgxc/cXy/2d2Rdi5DRnfjaMiEr2FGuUqRBNK8c19z9fl/3l9mQoJolB8vV
         Ts9A==
X-Gm-Message-State: AOAM532xY5CyQxw0LCl9H4f26+9mbnbPhwLYGjnOlz9Ww1I0QTo3GN+o
        o0fsRMtSJwi6lNML4U2k/ue7aI1p6TTLfSxU3uW7B8jhIVoo
X-Google-Smtp-Source: ABdhPJzfyholBojvTdXf18niTb+bG+GT/Pvyc0HPQj3ZJQzGGF27xphs6kDRmpgZm2imxrZ3RckHwdO2JIWfbXiCvUf2Hmw/beIP
MIME-Version: 1.0
X-Received: by 2002:a02:84ac:: with SMTP id f41mr12062153jai.56.1596398365555;
 Sun, 02 Aug 2020 12:59:25 -0700 (PDT)
Date:   Sun, 02 Aug 2020 12:59:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007fbe6605abea7514@google.com>
Subject: INFO: task can't die in p9_client_rpc
From:   syzbot <syzbot+a42aa715d3d32226792a@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, ericvh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    01830e6c Add linux-next specific files for 20200731
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=176146cc900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2e226b2d1364112c
dashboard link: https://syzkaller.appspot.com/bug?extid=a42aa715d3d32226792a
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a42aa715d3d32226792a@syzkaller.appspotmail.com

INFO: task syz-executor.5:24879 can't die for more than 143 seconds.
syz-executor.5  D25688 24879   7480 0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3669 [inline]
 __schedule+0x8e5/0x21e0 kernel/sched/core.c:4418
 schedule+0xd0/0x2a0 kernel/sched/core.c:4493
 p9_client_rpc+0x3b5/0x11f0 net/9p/client.c:757
 p9_client_flush+0x1f9/0x430 net/9p/client.c:665
 p9_client_rpc+0xf93/0x11f0 net/9p/client.c:782
 p9_client_version net/9p/client.c:953 [inline]
 p9_client_create+0xa8f/0x10c0 net/9p/client.c:1053
 v9fs_session_init+0x1dd/0x1770 fs/9p/v9fs.c:406
 v9fs_mount+0x79/0x970 fs/9p/vfs_super.c:124
 legacy_get_tree+0x105/0x220 fs/fs_context.c:592
 vfs_get_tree+0x89/0x2f0 fs/super.c:1549
 do_new_mount fs/namespace.c:2912 [inline]
 do_mount+0x14f6/0x1e20 fs/namespace.c:3238
 __do_sys_mount fs/namespace.c:3448 [inline]
 __se_sys_mount fs/namespace.c:3425 [inline]
 __x64_sys_mount+0x18f/0x230 fs/namespace.c:3425
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cc79
Code: Bad RIP value.
RSP: 002b:00007f92f26b9c78 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000020480 RCX: 000000000045cc79
RDX: 0000000020000100 RSI: 0000000020000040 RDI: 0000000000000000
RBP: 000000000078bf50 R08: 0000000020000200 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 00007fff9a822f9f R14: 00007f92f26ba9c0 R15: 000000000078bf0c

Showing all locks held in the system:
1 lock held by khungtaskd/1164:
 #0: ffffffff89c52a80 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5823
1 lock held by in:imklog/6729:
 #0: ffff8880a97c7db0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:930

=============================================



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
