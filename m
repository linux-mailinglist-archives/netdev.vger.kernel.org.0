Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67971151510
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 05:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgBDEnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 23:43:12 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:52688 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgBDEnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 23:43:12 -0500
Received: by mail-il1-f198.google.com with SMTP id o5so13905109ilg.19
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 20:43:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=i5yXvtiH1y6cVNcs98LhuiQSJ2L1URSUSXCgGl2kp4o=;
        b=hidqGe1Erxcv77NHilEF3+R7AvbAGFRCs437OkNW77YwZZenurOJTyy2O4mhLWJTLO
         8ppLWlNWj/s+Qq2oCJwUPYhC5i/HKZ0uw57Ola7cKBK3Dvl/DbdRcjTEvS5Qodnv+3hG
         sYH6xuMzvR17TBMmpMGLyLUrq+JfkbNfQpI2wN15SrP9cUuoYyDG6u+EV5HhY58d/sNQ
         sQl/QeM3jIMcysZzG8729VZk96BY3cJl9ks44qoN4y+OMxn5QklMH6scZYrHaDiQbuHf
         GKpEifTZuDRQ0aFd3BKhRK8mUBwww6DY/BynPLExy0fC8TwyFXVCe/6QjWJeNdGcM9Ik
         Dc2Q==
X-Gm-Message-State: APjAAAX44R3ji0Zpjk7Vcde6f5zgU/KotU0SAm2CBZ1//DCh83BuOzWF
        jtZ00NKhs21hBDSAMRUhAhCOhqYcq9SQAYuKa+JBcm7j2kjB
X-Google-Smtp-Source: APXvYqxX6zG1qzU/DrmwB5dQxqB0SZivucTEFYJ6/NtVlFWzr7KkIpkeW5qBL1EBhh8tbFZUS27zAjdxQZK85VfxZFGD/7ffPaId
MIME-Version: 1.0
X-Received: by 2002:a02:ccea:: with SMTP id l10mr14889099jaq.114.1580791391626;
 Mon, 03 Feb 2020 20:43:11 -0800 (PST)
Date:   Mon, 03 Feb 2020 20:43:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005cad20059db8adba@google.com>
Subject: BUG: stack guard page was hit in update_stack_state
From:   syzbot <syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jannh@google.com, jpoimboe@redhat.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b3a60822 Merge branch 'for-v5.6' of git://git.kernel.org:/..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=147ae5f1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=614e56d86457f3a7
dashboard link: https://syzkaller.appspot.com/bug?extid=c2fb6f9ddcea95ba49b5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com

8021q: adding VLAN 0 to HW filter on device bond40
BUG: stack guard page was hit at 0000000018e8ec40 (stack is 000000008cfdf90e..000000000f88bd28)
kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 28658 Comm: syz-executor.3 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:update_stack_state+0x4b/0x5f0 arch/x86/kernel/unwind_frame.c:194
Code: fd 41 54 49 8d 0c 06 53 48 81 ec a0 00 00 00 48 c7 45 80 42 54 41 89 48 c7 85 78 ff ff ff b3 8a b5 41 48 c7 45 88 00 3f 33 81 <48> 89 b5 68 ff ff ff c7 01 f1 f1 f1 f1 c7 41 04 00 f3 f3 f3 48 89
RSP: 0018:ffffc9000769ffc0 EFLAGS: 00010286
RAX: dffffc0000000000 RBX: ffffc900076a01a8 RCX: fffff52000ed4000
RDX: 1ffff92000ed4033 RSI: ffffc900076a0230 RDI: ffffc900076a01a8
RBP: ffffc900076a0088 R08: ffffc900076a01d0 R09: ffffc900076a0200
R10: ffffc900076a01d0 R11: ffffc900076a01e0 R12: 1ffff92000ed4018
R13: ffffc900076a01a8 R14: 1ffff92000ed4000 R15: ffffc900076a0230
FS:  00007fd172d8f700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc9000769ffb8 CR3: 0000000097238000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
Modules linked in:
---[ end trace 04286e13cba26a71 ]---
RIP: 0010:update_stack_state+0x4b/0x5f0 arch/x86/kernel/unwind_frame.c:194
Code: fd 41 54 49 8d 0c 06 53 48 81 ec a0 00 00 00 48 c7 45 80 42 54 41 89 48 c7 85 78 ff ff ff b3 8a b5 41 48 c7 45 88 00 3f 33 81 <48> 89 b5 68 ff ff ff c7 01 f1 f1 f1 f1 c7 41 04 00 f3 f3 f3 48 89
RSP: 0018:ffffc9000769ffc0 EFLAGS: 00010286
RAX: dffffc0000000000 RBX: ffffc900076a01a8 RCX: fffff52000ed4000
RDX: 1ffff92000ed4033 RSI: ffffc900076a0230 RDI: ffffc900076a01a8
RBP: ffffc900076a0088 R08: ffffc900076a01d0 R09: ffffc900076a0200
R10: ffffc900076a01d0 R11: ffffc900076a01e0 R12: 1ffff92000ed4018
R13: ffffc900076a01a8 R14: 1ffff92000ed4000 R15: ffffc900076a0230
FS:  00007fd172d8f700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc9000769ffb8 CR3: 0000000097238000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
