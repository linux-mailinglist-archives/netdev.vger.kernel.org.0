Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05E4A19F9B2
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 18:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgDFQGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 12:06:21 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:45217 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729369AbgDFQGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 12:06:16 -0400
Received: by mail-io1-f71.google.com with SMTP id g5so202977ioh.12
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 09:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TctIDdVeh0zTC3Sh8bVpm1XRU56EagRQHXsvYpdgUks=;
        b=Oc1+FTiVF1hzvs3qKiiNh7yD1LHxfaK6v/IGgTm4+gxO8NarABmXf36ouM9z9hCtpd
         ZQtyvq8g2hI8mbX3AQgCU+txWUWeD+wKEOv950zrhfl73o5nUKDjJJ8LewDJBkvP6S4B
         eAT8SriuEOs+SQdksKj2Vc7Jb5kEU2a91yE31+JfwoBioTOx611iqd9fIti15EsFjef3
         yertLT8nemOMJ8zPzsftgDl9XhPUq96yp+JAYXpKLwrAeTpXMg81b9RVZq8dVC55+MeP
         rjhufTjlSNWF5M74MFqbLsbAy3Gbp/fR4WUhtu4REYSXkRD8qMu6QP0ClSorspb5B3up
         g7kg==
X-Gm-Message-State: AGi0PuaFJXV+gGCg/laiufgweOTdPk3KhLtw5k/Hup4ucqONct4bWs+F
        A1hxa3wUzTu7ctnRvQrwYazgp1vYjpVD0cSNka/0s3fLhi1l
X-Google-Smtp-Source: APiQypJvs6wcQue85oIKF4W5vZB0eFwGSndx1OwAYeqIULpCiqEuJs+eWCl9+cLoVOi6T2wSDWQv+4wv0u/ZS/qQPHBLwk1Cy1fD
MIME-Version: 1.0
X-Received: by 2002:a92:5dc7:: with SMTP id e68mr22121257ilg.205.1586189173234;
 Mon, 06 Apr 2020 09:06:13 -0700 (PDT)
Date:   Mon, 06 Apr 2020 09:06:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000037a2ac05a2a17202@google.com>
Subject: general protection fault in tipc_conn_delete_sub
From:   syzbot <syzbot+55a38037455d0351efd3@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    919dce24 Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1250d0c7e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d6a1e2f9a9986236
dashboard link: https://syzkaller.appspot.com/bug?extid=55a38037455d0351efd3
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=118ff0c7e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+55a38037455d0351efd3@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000014: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000a0-0x00000000000000a7]
CPU: 1 PID: 113 Comm: kworker/u4:3 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: tipc_send tipc_conn_send_work
RIP: 0010:tipc_conn_delete_sub+0x54/0x440 net/tipc/topsrv.c:231
Code: 48 c1 ea 03 80 3c 02 00 0f 85 f0 03 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 18 48 8d bd a0 00 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c0 03 00 00 48 c7 c0 34 0b 8a 8a 4c 8b a5 a0 00
RSP: 0018:ffffc900012d7b58 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff8880a8269c00 RCX: ffffffff8789ca01
RDX: 0000000000000014 RSI: ffffffff8789a059 RDI: 00000000000000a0
RBP: 0000000000000000 R08: ffff8880a8d88380 R09: fffffbfff18577a8
R10: fffffbfff18577a7 R11: ffffffff8c2bbd3f R12: dffffc0000000000
R13: ffff888093d35a18 R14: ffff8880a8269c00 R15: ffff888093d35a00
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000076c000 CR3: 000000009441d000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tipc_conn_send_to_sock+0x380/0x560 net/tipc/topsrv.c:266
 tipc_conn_send_work+0x6f/0x90 net/tipc/topsrv.c:304
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace 2c161a84be832606 ]---
RIP: 0010:tipc_conn_delete_sub+0x54/0x440 net/tipc/topsrv.c:231
Code: 48 c1 ea 03 80 3c 02 00 0f 85 f0 03 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 18 48 8d bd a0 00 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c0 03 00 00 48 c7 c0 34 0b 8a 8a 4c 8b a5 a0 00
RSP: 0018:ffffc900012d7b58 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff8880a8269c00 RCX: ffffffff8789ca01
RDX: 0000000000000014 RSI: ffffffff8789a059 RDI: 00000000000000a0
RBP: 0000000000000000 R08: ffff8880a8d88380 R09: fffffbfff18577a8
R10: fffffbfff18577a7 R11: ffffffff8c2bbd3f R12: dffffc0000000000
R13: ffff888093d35a18 R14: ffff8880a8269c00 R15: ffff888093d35a00
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020800000 CR3: 0000000091b8e000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
