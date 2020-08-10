Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58600240A00
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 17:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgHJPhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 11:37:40 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:40354 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgHJPhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 11:37:19 -0400
Received: by mail-io1-f71.google.com with SMTP id t22so7310916iob.7
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 08:37:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=mwA0VxfKC9y1ldI67xR8GxayzqreYluyj2U7Ecr/ZxE=;
        b=QU+q5c2I3vVqS5isX1w0SPgSfO+btzPMWYKsDQCO+AhughM0iwJ8sURGAIyUWCeeip
         /vQBBMgdAv6z9rsoEFR/tEwq/Ui4u1CokkpIHgNcSuRGmoCY6MWNxkmPGyihD4JMf1Ip
         6MGXvw0cvpuVj7seoQBYA0OZZMY5cRy+Zn7XpcR9b5JtNliEUprvyqu7+5wQR/KFkoEs
         ttemeJPoRHkekl0CUqwqh2RPuSVQQIuGnBVzx0oUMb0YSYI4VroyCouIhQvczMHK37DS
         sLMGFFgk/vuccAv/gybEUf2Lc/frIHNF0IS9F8jVDFLZuiJzGGg5LbgWpkrIxxPnlmzq
         qGSw==
X-Gm-Message-State: AOAM532rNd5tcqrHM8KdSFpGvzNMUkI8EjFOv8dVFk4uSyuD0RB7J5UU
        S2E2wBwlOAIpoifzmIVGRpL2nP2v64FlMZmL6nFSEw3/NxaL
X-Google-Smtp-Source: ABdhPJyE6YD/UF3JeesR4M8V3eeWNcRlU/BoaOUyj//sfBL8naXLYfJwRAQYZPJ4ploP62y5lKzHhSKJlVBTW63XgXdgQE1ZrUxF
MIME-Version: 1.0
X-Received: by 2002:a92:4403:: with SMTP id r3mr17862137ila.17.1597073838611;
 Mon, 10 Aug 2020 08:37:18 -0700 (PDT)
Date:   Mon, 10 Aug 2020 08:37:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d4adc705ac87ba8e@google.com>
Subject: general protection fault in sctp_ulpevent_notify_peer_addr_change
From:   syzbot <syzbot+8f2165a7b1f2820feffc@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fffe3ae0 Merge tag 'for-linus-hmm' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12f34d3a900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=50463ec6729f9706
dashboard link: https://syzkaller.appspot.com/bug?extid=8f2165a7b1f2820feffc
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1517701c900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11b7e0e2900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8f2165a7b1f2820feffc@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000004c: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000260-0x0000000000000267]
CPU: 0 PID: 12765 Comm: syz-executor391 Not tainted 5.8.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:sctp_ulpevent_notify_peer_addr_change+0xa9/0xad0 net/sctp/ulpevent.c:346
Code: 03 80 3c 18 00 0f 85 9f 08 00 00 48 8b 9d b0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb 60 02 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 3a 08 00 00 44 8b a3 60 02 00
RSP: 0018:ffffc90000d27380 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000004c RSI: ffffffff875c9422 RDI: 0000000000000260
RBP: ffff8880235da158 R08: 0000000000000001 R09: ffff8880234cdd48
R10: fffffbfff155f111 R11: 0000000000000000 R12: 0000000000000001
R13: 1ffff920001a4e76 R14: 0000000000000004 R15: 0000000000000000
FS:  00007fdd571b7700(0000) GS:ffff88802ce00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 000000001c9d0000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 sctp_assoc_set_primary+0x6c/0x300 net/sctp/associola.c:435
 sctp_assoc_rm_peer+0x6f7/0x950 net/sctp/associola.c:508
 sctp_assoc_update+0x588/0xfd0 net/sctp/associola.c:1116
 sctp_cmd_assoc_update net/sctp/sm_sideeffect.c:836 [inline]
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1305 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x27f8/0x4d80 net/sctp/sm_sideeffect.c:1156
 sctp_assoc_bh_rcv+0x386/0x6c0 net/sctp/associola.c:1044
 sctp_inq_push+0x1da/0x270 net/sctp/inqueue.c:80
 sctp_backlog_rcv+0x19e/0x5c0 net/sctp/input.c:344
 sk_backlog_rcv include/net/sock.h:1001 [inline]
 __release_sock+0x134/0x3a0 net/core/sock.c:2550
 release_sock+0x54/0x1b0 net/core/sock.c:3087
 sctp_wait_for_connect+0x30f/0x540 net/sctp/socket.c:9302
 __sctp_connect+0x96b/0xc00 net/sctp/socket.c:1247
 __sctp_setsockopt_connectx+0x12d/0x180 net/sctp/socket.c:1343
 sctp_setsockopt_connectx net/sctp/socket.c:1375 [inline]
 sctp_setsockopt net/sctp/socket.c:4720 [inline]
 sctp_setsockopt+0x1642/0x70d0 net/sctp/socket.c:4677
 __sys_setsockopt+0x24a/0x480 net/socket.c:2127
 __do_sys_setsockopt net/socket.c:2143 [inline]
 __se_sys_setsockopt net/socket.c:2140 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2140
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x43e119
Code: e8 4c b5 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 bb d0 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fdd571b6ce8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00000000006c7c58 RCX: 000000000043e119
RDX: 000000000000006e RSI: 0000000000000084 RDI: 0000000000000003
RBP: 00000000006c7c50 R08: 0000000000000020 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 00000000006c7c5c
R13: 00007ffdb7fcef0f R14: 00007fdd57197000 R15: 0000000000000003
Modules linked in:
---[ end trace 49c057cb66761ca9 ]---
RIP: 0010:sctp_ulpevent_notify_peer_addr_change+0xa9/0xad0 net/sctp/ulpevent.c:346
Code: 03 80 3c 18 00 0f 85 9f 08 00 00 48 8b 9d b0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb 60 02 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 3a 08 00 00 44 8b a3 60 02 00
RSP: 0018:ffffc90000d27380 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000004c RSI: ffffffff875c9422 RDI: 0000000000000260
RBP: ffff8880235da158 R08: 0000000000000001 R09: ffff8880234cdd48
R10: fffffbfff155f111 R11: 0000000000000000 R12: 0000000000000001
R13: 1ffff920001a4e76 R14: 0000000000000004 R15: 0000000000000000
FS:  00007fdd571b7700(0000) GS:ffff88802cf00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 000000001c9d0000 CR4: 0000000000350ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
