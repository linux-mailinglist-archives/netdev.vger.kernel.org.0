Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE102DB95D
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 03:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbgLPCpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 21:45:50 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:51972 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbgLPCpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 21:45:50 -0500
Received: by mail-io1-f72.google.com with SMTP id h206so15220863iof.18
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 18:45:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=rDUW7r87onx/RWl3unGJ4GmRrVMni5cJjxiJLLepcRI=;
        b=i8Z26SMxNgRhIxLOS12n8sb+V4qNLRiRkXmRHw29g3PDe88YzqcVIUZ7WaNWDQ+YI6
         asHe0F11cjaR1ZCWNfUbtlob7nbdGf8IaagK5XTi4oE5934G41ZAcjgXq6dhyNCvemnC
         BoWJWkOgUOD5OMtLWrRcseO4gOpvDauMcP7jPLVHGXuzL3Nm/i78EE33PEAyFIA3lb42
         QUoCNJf9FqUrnLTJCl+tznNZ82milNLGjz0HL/OP/2+AvoquiRVxSEK0YpuKNsLF6wF/
         Kjfh9IohaTLT5MZo7zzOwXmf8YoRcVcolszFaN52HkEeSHtZe7fRiMzLzLfTh4JLpp+d
         uJFQ==
X-Gm-Message-State: AOAM532Pj5U1TeFv5mAsWsVwrZnF5SaNO4pvfrOm42OIVqOprZ8WQt3Y
        gb9c8wd2+FzbvuJ4mQx/vd9jj+dH6me5MtDogWDLALhkz8DN
X-Google-Smtp-Source: ABdhPJxRkIbvQahC67PlL1n+oMTqKog23TOdu43rxkB6n4ivsNsa9DqMa47EvkdhQW92i8e7RoA4zZNKG7dVAfJd4z/qtCMLBPkv
MIME-Version: 1.0
X-Received: by 2002:a92:6f12:: with SMTP id k18mr1959322ilc.66.1608086709308;
 Tue, 15 Dec 2020 18:45:09 -0800 (PST)
Date:   Tue, 15 Dec 2020 18:45:09 -0800
In-Reply-To: <0000000000005b303e05b62d6674@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000013920205b68bdd58@google.com>
Subject: Re: INFO: task can't die in corrupted (2)
From:   syzbot <syzbot+61cb1d04bf13f0c631b1@syzkaller.appspotmail.com>
To:     ast@kernel.org, christian.brauner@ubuntu.com, daniel@iogearbox.net,
        davem@davemloft.net, gnault@redhat.com, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    9317f948 Add linux-next specific files for 20201215
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=151add97500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5c81cc44aa25b5b3
dashboard link: https://syzkaller.appspot.com/bug?extid=61cb1d04bf13f0c631b1
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=177df703500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1342f30f500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+61cb1d04bf13f0c631b1@syzkaller.appspotmail.com

INFO: task syz-executor656:8498 can't die for more than 143 seconds.
task:syz-executor656 state:R  running task     stack:27904 pid: 8498 ppid:  8493 flags:0x00004006
Call Trace:

Showing all locks held in the system:
1 lock held by khungtaskd/1647:
 #0: ffffffff8b78f920 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x28c kernel/locking/lockdep.c:6254
1 lock held by in:imklog/8185:
 #0: ffff88801ad9e0f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:923
3 locks held by syz-executor656/8498:

=============================================

Kernel panic - not syncing: hung_task: blocked tasks
CPU: 0 PID: 1647 Comm: khungtaskd Not tainted 5.10.0-next-20201215-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 panic+0x343/0x77f kernel/panic.c:231
 check_hung_uninterruptible_tasks kernel/hung_task.c:257 [inline]
 watchdog.cold+0x157/0x31d kernel/hung_task.c:338
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Kernel Offset: disabled
Rebooting in 86400 seconds..

