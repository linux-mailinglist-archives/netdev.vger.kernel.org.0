Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618204683E2
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 10:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344226AbhLDJ6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 04:58:43 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:33515 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbhLDJ6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 04:58:43 -0500
Received: by mail-io1-f70.google.com with SMTP id 85-20020a6b0258000000b005ed47a95f03so4518797ioc.0
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 01:55:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DyhRK3ttUVN6VH347d06HzFlgqVT0ZOXZFQ3OlFIC+Q=;
        b=nkgYcAxMQ8HwBdi6tN4BQe5mjwMMGExuJNkStqHm5hVqEmI+RmJzMYc7ju3x81Zf5f
         aONeVRjuErHDOcClhT9JRbb2B0iRekQCEyEMJUDE/HhJtEB/7xrLTcXjYhKjMOF7sjaV
         cDBpEv8NfwcR1+MUU5vldXci717bjsiBvjSj4JyZX4g76gzruSuqelqeVH0zEeA9LUmR
         HfQX7AoeLfATxnHpluDnDx+8K3D2stNTcZDz37qRSCVZMtzer39/kU7PejvO2Qc9J9kz
         fHi8V1NelN+7aRv6Njii5Qtq5a+k9Lg38qdSxPUUuvmdqJ9QyiKKkg8AMq6TsPUGY4Ge
         jgSQ==
X-Gm-Message-State: AOAM533wQLE/W5JPObI9RJys/g7jshZoiSm/wfaBliLlQOodxIuuLiws
        tYw8L2NT+rYNZINkvjfAvG0Tplpba0LJOHm7LwOSJkRWKVS6
X-Google-Smtp-Source: ABdhPJx5XhbPvyMCmR8YL5bei9Iw8lSBb9m2ZHtxGrojbG9yjSvWW18D//6dKVseTS6/IkXQ2IoRyPdVM4Hl+rWn2HWwKHn8ui3x
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1845:: with SMTP id b5mr21113973ilv.168.1638611717729;
 Sat, 04 Dec 2021 01:55:17 -0800 (PST)
Date:   Sat, 04 Dec 2021 01:55:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005c30f405d24f05e1@google.com>
Subject: [syzbot] general protection fault in tipc_conn_close (2)
From:   syzbot <syzbot+d28b439975080ea97feb@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    40c93d7fff6f Merge tag 'x86-urgent-2021-11-21' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15fa11eeb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5999a5ee199b97
dashboard link: https://syzkaller.appspot.com/bug?extid=d28b439975080ea97feb
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d28b439975080ea97feb@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 1 PID: 9168 Comm: kworker/u4:4 Not tainted 5.16.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:tipc_conn_close+0x4c/0x210 net/tipc/topsrv.c:157
Code: 5d 08 49 89 dc 49 c1 ec 03 43 80 3c 34 00 74 08 48 89 df e8 e6 b3 0a f8 48 89 1c 24 48 8b 1b 48 83 c3 18 48 89 d8 48 c1 e8 03 <42> 80 3c 30 00 74 08 48 89 df e8 c5 b3 0a f8 48 8b 1b 4c 8d bb b0
RSP: 0018:ffffc90004777ad8 EFLAGS: 00010206
RAX: 0000000000000003 RBX: 0000000000000018 RCX: ffff888077731d00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88807a888000
RBP: ffff88807a888000 R08: dffffc0000000000 R09: fffffbfff1ff33de
R10: fffffbfff1ff33de R11: 0000000000000000 R12: 1ffff1100f511001
R13: ffff88807a888000 R14: dffffc0000000000 R15: ffff88807d345098
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000560b6e50e788 CR3: 0000000089eb7000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 tipc_topsrv_stop net/tipc/topsrv.c:694 [inline]
 tipc_topsrv_exit_net+0xf8/0x310 net/tipc/topsrv.c:715
 ops_exit_list net/core/net_namespace.c:168 [inline]
 cleanup_net+0x758/0xc50 net/core/net_namespace.c:593
 process_one_work+0x853/0x1140 kernel/workqueue.c:2298
 worker_thread+0xac1/0x1320 kernel/workqueue.c:2445
 kthread+0x468/0x490 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30
 </TASK>
Modules linked in:
---[ end trace ff1ddf3c30f0c3d0 ]---
RIP: 0010:tipc_conn_close+0x4c/0x210 net/tipc/topsrv.c:157
Code: 5d 08 49 89 dc 49 c1 ec 03 43 80 3c 34 00 74 08 48 89 df e8 e6 b3 0a f8 48 89 1c 24 48 8b 1b 48 83 c3 18 48 89 d8 48 c1 e8 03 <42> 80 3c 30 00 74 08 48 89 df e8 c5 b3 0a f8 48 8b 1b 4c 8d bb b0
RSP: 0018:ffffc90004777ad8 EFLAGS: 00010206
RAX: 0000000000000003 RBX: 0000000000000018 RCX: ffff888077731d00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88807a888000
RBP: ffff88807a888000 R08: dffffc0000000000 R09: fffffbfff1ff33de
R10: fffffbfff1ff33de R11: 0000000000000000 R12: 1ffff1100f511001
R13: ffff88807a888000 R14: dffffc0000000000 R15: ffff88807d345098
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe625c1d058 CR3: 000000003b6ba000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	5d                   	pop    %rbp
   1:	08 49 89             	or     %cl,-0x77(%rcx)
   4:	dc 49 c1             	fmull  -0x3f(%rcx)
   7:	ec                   	in     (%dx),%al
   8:	03 43 80             	add    -0x80(%rbx),%eax
   b:	3c 34                	cmp    $0x34,%al
   d:	00 74 08 48          	add    %dh,0x48(%rax,%rcx,1)
  11:	89 df                	mov    %ebx,%edi
  13:	e8 e6 b3 0a f8       	callq  0xf80ab3fe
  18:	48 89 1c 24          	mov    %rbx,(%rsp)
  1c:	48 8b 1b             	mov    (%rbx),%rbx
  1f:	48 83 c3 18          	add    $0x18,%rbx
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 30 00       	cmpb   $0x0,(%rax,%r14,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	48 89 df             	mov    %rbx,%rdi
  34:	e8 c5 b3 0a f8       	callq  0xf80ab3fe
  39:	48 8b 1b             	mov    (%rbx),%rbx
  3c:	4c                   	rex.WR
  3d:	8d                   	.byte 0x8d
  3e:	bb                   	.byte 0xbb
  3f:	b0                   	.byte 0xb0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
