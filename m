Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83552D477E
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 18:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731177AbgLIRHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 12:07:53 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:39842 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbgLIRHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 12:07:53 -0500
Received: by mail-io1-f70.google.com with SMTP id n9so1711369iog.6
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 09:07:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qIQXaAtoA55Hqp6Kor3EGs7q2VqDGIx+EnbuDJObsv8=;
        b=dXlPC/iPNxTtMcLknIZ02HpF5RFw3XoiXhXZYIhc2bFKIqhLw5+Y2Q2AK89gR/mp1t
         FuwA0GC1h21/abFYQp1nCc2sK99Ued8qeAuGPtJWT9uofFxvS99uPZu/wWrPO9vN2vHO
         2ilmRlE4mLqo8h0mnWyAMdQT5nDgxqFLNlfygp3Cn4HByEWbgc0/MYPabGFyep/v7ESB
         xXqdKOtc3J7s3zMX/PzLN0Xu8/FI9HPnip90JipSN1EuTJeHOc2YZnQlVD3SKSIi/1q5
         V/nQb/6oHnU4140fo3KF8K8jHY8OO4Sfd0xOAufA1uHMhcrl/kYw2X7+SHTtGQ4Sel9C
         Fy6g==
X-Gm-Message-State: AOAM5338rodMqDU+0HK/jXzH1sqRH2SNqG6pZv77viFR8Puw9SlwmxNF
        g2ohGFpvL0+yMQar9zSMt24jtpjyS9Pefiu+4MWrCs7euEd3
X-Google-Smtp-Source: ABdhPJwZHYGmrSkJnViQUI8+0O4v34jj5sW5H/8BnMCITxzEl4tPD5tUBuvAExx5+9blqJ4XkSFsTkDJ7TT6yuQoO9aQKxqV2UCU
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2e81:: with SMTP id m1mr3965175iow.131.1607533632436;
 Wed, 09 Dec 2020 09:07:12 -0800 (PST)
Date:   Wed, 09 Dec 2020 09:07:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000020460105b60b17b5@google.com>
Subject: INFO: task can't die in p9_client_rpc (2)
From:   syzbot <syzbot+4ff9239a00671c7c656f@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, ericvh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0eedceaf Add linux-next specific files for 20201201
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11111df7500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=55aec7153b7827ea
dashboard link: https://syzkaller.appspot.com/bug?extid=4ff9239a00671c7c656f
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4ff9239a00671c7c656f@syzkaller.appspotmail.com

INFO: task syz-executor.2:10555 can't die for more than 143 seconds.
task:syz-executor.2  state:D stack:27024 pid:10555 ppid:  8514 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4325 [inline]
 __schedule+0x8cd/0x2150 kernel/sched/core.c:5076
 schedule+0xcf/0x270 kernel/sched/core.c:5155
 p9_client_rpc+0x400/0x1240 net/9p/client.c:759
 p9_client_flush+0x1f9/0x430 net/9p/client.c:667
 p9_client_rpc+0xfde/0x1240 net/9p/client.c:784
 p9_client_version net/9p/client.c:955 [inline]
 p9_client_create+0xae1/0x1110 net/9p/client.c:1055
 v9fs_session_init+0x1dd/0x1770 fs/9p/v9fs.c:406
 v9fs_mount+0x79/0x9b0 fs/9p/vfs_super.c:126
 legacy_get_tree+0x105/0x220 fs/fs_context.c:592
 vfs_get_tree+0x89/0x2f0 fs/super.c:1549
 do_new_mount fs/namespace.c:2896 [inline]
 path_mount+0x12ae/0x1e70 fs/namespace.c:3227
 do_mount fs/namespace.c:3240 [inline]
 __do_sys_mount fs/namespace.c:3448 [inline]
 __se_sys_mount fs/namespace.c:3425 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3425
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45de79
RSP: 002b:00007f4ba88a6c68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 000000000045de79
RDX: 0000000020000200 RSI: 0000000020000000 RDI: 0000000000000000
RBP: 000000000118bf70 R08: 0000000020000140 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007fff44b1496f R14: 00007f4ba88a79c0 R15: 000000000118bf2c

Showing all locks held in the system:
2 locks held by kworker/u4:3/81:
1 lock held by khungtaskd/1618:
 #0: ffffffff8b33a7a0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6254
1 lock held by systemd-journal/4903:
1 lock held by in:imklog/8195:
 #0: ffff88801dba7270 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:923

=============================================



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
