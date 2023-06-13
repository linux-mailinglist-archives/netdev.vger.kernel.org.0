Return-Path: <netdev+bounces-10439-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD4D872E805
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:16:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9546D280D9E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A617E3C0AB;
	Tue, 13 Jun 2023 16:16:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7E623DB
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 16:16:15 +0000 (UTC)
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C08C1BFB
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 09:16:10 -0700 (PDT)
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-777a93b3277so620211639f.3
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 09:16:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686672969; x=1689264969;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HjzB5ZogMCMAXiS6nJY/dEPDSCC8PcZdW4N8dElRAZk=;
        b=dpOIzeMwuswk2QF0ybcrfDKp/e3hj5Qm7YVgQAOVrRmWj7mYzFDCDASW2O8JIEkPVK
         DItlD1Gy6b5oQrlBKBj0YbDWvMWOuSskf4Bof2OpGQqDV7TbD/sVOxF8HS7Z/FxkDzYC
         auNyyjRGErZ5hCjxNOAnJgzoswgWoX6Gg48uRSUsuHTNJ8djIfNDepveT44a7VJET9J7
         x2PM0UsZbfFXjqXxap8wOK9qU2EDEeEYpSyEt506S1/UB/+e87I4z2PzMORTUJ0v/4oy
         P5Spu8hrFNhDGowNGJ2vBi7ydTh8XGOsQyAU32ARjP/j4TiFF9jMrVcI4O/nWXx+bRBs
         XJhg==
X-Gm-Message-State: AC+VfDz3r4dSEwdOA/bDwI7/Wu/tFqA4Rok3DKGLZhNHFWlBHsn/bjA0
	EHPligHR1PjJeJ+3KNr0DHnlQQqseqAyzXVo5Fpgh+2QLQfA
X-Google-Smtp-Source: ACHHUZ5cbjV5+iu597wn2wOTTlbWmghFWU5S0DmcoQdpqOHMx9WLVcDC/74qPlWegpU0yNja/teZmrW117k58ehn1z7EZk2yaRyI
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:9487:0:b0:41d:76e2:9f17 with SMTP id
 x7-20020a029487000000b0041d76e29f17mr5495895jah.2.1686672969569; Tue, 13 Jun
 2023 09:16:09 -0700 (PDT)
Date: Tue, 13 Jun 2023 09:16:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000342a9105fe052726@google.com>
Subject: [syzbot] [net?] WARNING in unreserve_psock
From: syzbot <syzbot+dd1339599f1840e4cc65@syzkaller.appspotmail.com>
To: bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    c29e012eae29 selftests: forwarding: Fix layer 2 miss test ..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14505343280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=dd1339599f1840e4cc65
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=170f2663280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f1c5e7280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/12ab2dfeec70/disk-c29e012e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/424354551939/vmlinux-c29e012e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/40982e9df534/bzImage-c29e012e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dd1339599f1840e4cc65@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5007 at net/kcm/kcmsock.c:533 unreserve_psock+0x2e1/0x6e0 net/kcm/kcmsock.c:533
Modules linked in:
CPU: 0 PID: 5007 Comm: syz-executor222 Not tainted 6.4.0-rc5-syzkaller-01194-gc29e012eae29 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
RIP: 0010:unreserve_psock+0x2e1/0x6e0 net/kcm/kcmsock.c:533
Code: 3c f8 48 89 ef e8 df b1 ff ff 4c 89 f7 e8 e7 f5 cd 00 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f e9 c4 f2 3c f8 e8 bf f2 3c f8 <0f> 0b 4c 89 f7 e8 c5 f5 cd 00 eb dc e8 ae f2 3c f8 0f 0b e9 f0 fe
RSP: 0018:ffffc90003a9f6a0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888077f60000 RCX: 0000000000000000
RDX: ffff8880284d3b80 RSI: ffffffff89475391 RDI: ffffc90003a9f630
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52000753ec6 R11: 0000000000000005 R12: ffff88802cfd8000
R13: ffff888077f60000 R14: ffff88802cfd81c0 R15: ffff888077f60598
FS:  000055555562f300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200006c8 CR3: 0000000025a48000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kcm_write_msgs+0x571/0x14b0 net/kcm/kcmsock.c:699
 kcm_sendmsg+0x1fe1/0x2720 net/kcm/kcmsock.c:903
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 ____sys_sendmsg+0x344/0x920 net/socket.c:2493
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2547
 __sys_sendmmsg+0x18f/0x460 net/socket.c:2633
 __do_sys_sendmmsg net/socket.c:2662 [inline]
 __se_sys_sendmmsg net/socket.c:2659 [inline]
 __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2659
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7efed1630b39
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff10fc2e08 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007efed1630b39
RDX: 0000000000000001 RSI: 00000000200006c0 RDI: 0000000000000003
RBP: 00007efed15f4ce0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007efed15f4d70
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

