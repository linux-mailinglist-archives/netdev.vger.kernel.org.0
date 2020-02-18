Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE85162117
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 07:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgBRGrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 01:47:14 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:47054 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgBRGrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 01:47:14 -0500
Received: by mail-il1-f197.google.com with SMTP id a2so16282841ill.13
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 22:47:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2uIvG8n91WjAK+8Fc4AV0UFGKDnjSDw2pznJjQ1AoWI=;
        b=m67cG8RUfBlwV7OeGvfoEsZX4MAgm60COSc3C3nUefD8tNS715B7s79Kws2t410FRG
         pDoxtfJRqbEDbDn1XSd+hZLKheN0B/ebBz9g1sjbDi48V3xolnXKMUo2bTESzvx2srjx
         YppPzymGHpxDBmEP1Z6DlhIHH0WCcxtEPVrlPVgVLpIvHYmhhSn3mUaQ5js80XkVIzpY
         GGoNbhDGLCvCBYDkFwLoTRUG7gkLK+UEX/eMirfJNOphSsliyVaFgqsP3pBkoDt05kck
         Mpm0NJT4kYlwdpfv+shiv8yxYoQ3vPSLdZze3Ef3eTghc07yruoD813Rf6gtvJqbXPgG
         xyHw==
X-Gm-Message-State: APjAAAXlxyA3HFML3EXEXWm4vhl2eSVpi21bQIDYFPTN0d24W+W14N0R
        4UALFx7IzJ29hosxO5FhBgXnxtgYg8OzCBYTG3G26jsIIxKu
X-Google-Smtp-Source: APXvYqyl+yC5vY8YiRKB6Nj+2QlehHRz/NDgCroTLCqKaqYUOiL9cwZlR8Nwrb/BTXe5y7Qx+Y6WRTSbs4MQ49+t3mAlTgzvI1NM
MIME-Version: 1.0
X-Received: by 2002:a5e:940e:: with SMTP id q14mr13738130ioj.247.1582008433632;
 Mon, 17 Feb 2020 22:47:13 -0800 (PST)
Date:   Mon, 17 Feb 2020 22:47:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b7ee04059ed40af8@google.com>
Subject: general protection fault in sco_sock_getsockopt
From:   syzbot <syzbot+4a38d3795200fd59a9eb@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c25a951c Add linux-next specific files for 20200217
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=127e5865e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c727d8fc485ff049
dashboard link: https://syzkaller.appspot.com/bug?extid=4a38d3795200fd59a9eb
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=158849e9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e3d711e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4a38d3795200fd59a9eb@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 9807 Comm: syz-executor290 Not tainted 5.6.0-rc2-next-20200217-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:sco_sock_getsockopt+0x33a/0x910 net/bluetooth/sco.c:966
Code: df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 74 05 00 00 49 8b 9e b8 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 45 05 00 00 48 8b 3b e8 44 d1 f3 ff be c8 03 00
RSP: 0018:ffffc90007a97d40 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff87282cb2
RDX: 0000000000000000 RSI: ffffffff87282cc0 RDI: ffff88808cc7b4b8
RBP: ffffc90007a97e00 R08: ffff8880a8fc0380 R09: fffffbfff1709225
R10: fffffbfff1709224 R11: 0000000000000003 R12: 0000000000000000
R13: 1ffff92000f52fab R14: ffff88808cc7b000 R15: 0000000000000000
FS:  00000000009c3880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 00000000a6d61000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __sys_getsockopt+0x16d/0x310 net/socket.c:2175
 __do_sys_getsockopt net/socket.c:2190 [inline]
 __se_sys_getsockopt net/socket.c:2187 [inline]
 __x64_sys_getsockopt+0xbe/0x150 net/socket.c:2187
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440199
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd6ad93468 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440199
RDX: 000000000000000e RSI: 0000000000000084 RDI: 0000000000000005
RBP: 00000000006ca018 R08: 0000000020000080 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a20
R13: 0000000000401ab0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 2241e8fa1d14b6d0 ]---
RIP: 0010:sco_sock_getsockopt+0x33a/0x910 net/bluetooth/sco.c:966
Code: df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 74 05 00 00 49 8b 9e b8 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 45 05 00 00 48 8b 3b e8 44 d1 f3 ff be c8 03 00
RSP: 0018:ffffc90007a97d40 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff87282cb2
RDX: 0000000000000000 RSI: ffffffff87282cc0 RDI: ffff88808cc7b4b8
RBP: ffffc90007a97e00 R08: ffff8880a8fc0380 R09: fffffbfff1709225
R10: fffffbfff1709224 R11: 0000000000000003 R12: 0000000000000000
R13: 1ffff92000f52fab R14: ffff88808cc7b000 R15: 0000000000000000
FS:  00000000009c3880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 00000000a6d61000 CR4: 00000000001406f0
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
