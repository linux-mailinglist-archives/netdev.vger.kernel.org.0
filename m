Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3AE2D4159
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730912AbgLILsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:48:53 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:34406 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730837AbgLILsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 06:48:52 -0500
Received: by mail-il1-f197.google.com with SMTP id c72so1041892ila.1
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 03:48:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=CwYMHQEl9E1lkCAq4q/oSzHEtTEatdQZWZYCFTonNmQ=;
        b=cOAml0Lz6oAtKmBQb7kqk0UrYleX/s92kUzR2NsR8xLWT1TdgMbVF3XNZCOr9AdYSl
         cGaXynIobXYh/vm89EKFxiQzkLVa9n9J3iwS7AI6KGTSioaMgWzLQuXfPTSzBjizk+Z+
         MYrCSjTtQ36njZ8QBil0fP0Qnaas2tVPEBlf1q6sq6Phvq+1jLJtG2dgMF+UlJrXIETj
         e+p+YNPdoLtz71+4wPBBg/i+oSgS1wCFy4+Nd2jMa/lfvM5IGMRgE3rL4crLKT9eB1Ln
         pgPtDe6eyc635+ALamfWJ3Oj9Zke+iTy7vWDGivBa4hbLjOBxZ8zhjWNLoFZaLGyvxkJ
         m1ww==
X-Gm-Message-State: AOAM530pTGWwm/dFQBEyORWno668Byq/xaLLJdk+l35GPMQoZQJBBOpk
        5dH3m86UyNtlCvA4k1piLf7VAVdawYEM6K5ZYPHK/+lc6WhN
X-Google-Smtp-Source: ABdhPJyx90XS84buHbh6eiTsEACsTsp1ncpdlSTMbGyWDi0udWPcvKTtpqljZC+AzzNom9NPPbqXv3GcM3XKPt1qDNrONpmftY72
MIME-Version: 1.0
X-Received: by 2002:a92:c7b2:: with SMTP id f18mr2429109ilk.120.1607514490523;
 Wed, 09 Dec 2020 03:48:10 -0800 (PST)
Date:   Wed, 09 Dec 2020 03:48:10 -0800
In-Reply-To: <000000000000c79c6b05ac027164@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002dd77405b606a278@google.com>
Subject: Re: WARNING in __queue_work (3)
From:   syzbot <syzbot+63bed493aebbf6872647@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, bp@alien8.de, davem@davemloft.net,
        hkallweit1@gmail.com, hpa@zytor.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org, marcel@holtmann.org,
        mingo@redhat.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    7d8761ba Merge branch 'fixes' of git://git.kernel.org/pub/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14859745500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=59df2a4dced5f928
dashboard link: https://syzkaller.appspot.com/bug?extid=63bed493aebbf6872647
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1431cc13500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+63bed493aebbf6872647@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 24939 at kernel/workqueue.c:1416 __queue_work+0xb59/0xf00 kernel/workqueue.c:1416
Modules linked in:
CPU: 1 PID: 24939 Comm: syz-executor.3 Not tainted 5.10.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__queue_work+0xb59/0xf00 kernel/workqueue.c:1416
Code: e0 07 83 c0 03 38 d0 7c 09 84 d2 74 05 e8 3f d0 69 00 8b 5b 24 31 ff 83 e3 20 89 de e8 20 4b 28 00 85 db 75 7c e8 c7 52 28 00 <0f> 0b e9 dc fa ff ff e8 bb 52 28 00 0f 0b e9 55 fa ff ff e8 af 52
RSP: 0018:ffffc9000266f750 EFLAGS: 00010093
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff8147b1a0
RDX: ffff88801f184ec0 RSI: ffffffff8147b1a9 RDI: 0000000000000005
RBP: ffff88804d3d4b00 R08: 0000000000000000 R09: ffffffff8f12d1a3
R10: 0000000000000000 R11: 0000000000000000 R12: ffff888059ce4ac8
R13: ffff88803f6b5800 R14: 0000000000000293 R15: ffff88803f6b5800
FS:  00007f4e91751700(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007effff766db8 CR3: 0000000059bc0000 CR4: 0000000000350ee0
Call Trace:
 queue_work_on+0xc7/0xd0 kernel/workqueue.c:1521
 l2cap_do_send+0x248/0x480 net/bluetooth/l2cap_core.c:987
 l2cap_chan_send+0xcc3/0x2ac0 net/bluetooth/l2cap_core.c:2706
 l2cap_sock_sendmsg+0x235/0x2f0 net/bluetooth/l2cap_sock.c:1134
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x331/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmmsg+0x195/0x470 net/socket.c:2497
 __do_sys_sendmmsg net/socket.c:2526 [inline]
 __se_sys_sendmmsg net/socket.c:2523 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2523
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e0f9
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f4e91750c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 000000000045e0f9
RDX: 0000000000000500 RSI: 0000000020003f00 RDI: 0000000000000005
RBP: 000000000119c070 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119c034
R13: 00007ffd9c18ecaf R14: 00007f4e917519c0 R15: 000000000119c034

