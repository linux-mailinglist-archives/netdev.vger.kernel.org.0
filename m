Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5421DBC64
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 20:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgETSMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 14:12:20 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:36395 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETSMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 14:12:17 -0400
Received: by mail-io1-f69.google.com with SMTP id n20so2839774iog.3
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:12:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+ftmxr79gDcB9k8pr/AIQ9vrfM5009Yqd32Ubdl2t9g=;
        b=j+YWcNKmqpjUq+kmkkG8G4izMnHOsT5N1NQoIR//UPfEBzicVoPqY8kKk7YHUF81fl
         Ty1/6YFNw5gkJc5nn9BwtZTgUnJC7CQ1alzGfOB8L2ujVUKd7m/t+VeNTIV4HIauHfQP
         PIP+db2dDAiGiS6KDb9woeVRtxhpdhKKWn0HP+NZtFIKooQYru3q8DeOubuIy/9uZXbA
         D8y+zVLmBMEIxERECbxA4ChLPMndyBjV/M535AcGaWed9Fu6Zrbrr61L7XKOqSeRfN2N
         7ki/XOESDcSjqQWxQzP5PqqpQH2Nd83om2qRBWBRxm2NlBv7uB7I2AV/Dr3VbwKnH1Zt
         y8bA==
X-Gm-Message-State: AOAM530QdfWRW+oUspr/Glegw2UZlWXR19rIgDFF3G/jJrlhSV7Zatyi
        R93lod+1BDU7eH4Z4NzwhN+QY1gL3CNpSHRmLpMjNqEt2y+z
X-Google-Smtp-Source: ABdhPJzXSZ/EqbcKubHsOn2N59N7VYkouBS+q85pvXnoAF9hczJOPQFJMSNbnH6SCiHnOONuuEfDC4j+bzVTnG4BgLqkvmmC/T2T
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1616:: with SMTP id x22mr4594960iow.70.1589998335872;
 Wed, 20 May 2020 11:12:15 -0700 (PDT)
Date:   Wed, 20 May 2020 11:12:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000000d71e05a6185662@google.com>
Subject: general protection fault in unpin_user_pages
From:   syzbot <syzbot+118ac0af4ac7f785a45b@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, davem@davemloft.net,
        jhubbard@nvidia.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    dbfe7d74 rds: convert get_user_pages() --> pin_user_pages()
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10218e6e100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3df83be5e281f34b
dashboard link: https://syzkaller.appspot.com/bug?extid=118ac0af4ac7f785a45b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117ca33a100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16a9044a100000

The bug was bisected to:

commit dbfe7d74376e187f3c6eaff822e85176bc2cd06e
Author: John Hubbard <jhubbard@nvidia.com>
Date:   Sun May 17 01:23:36 2020 +0000

    rds: convert get_user_pages() --> pin_user_pages()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10e3d84a100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12e3d84a100000
console output: https://syzkaller.appspot.com/x/log.txt?x=14e3d84a100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+118ac0af4ac7f785a45b@syzkaller.appspotmail.com
Fixes: dbfe7d74376e ("rds: convert get_user_pages() --> pin_user_pages()")

RBP: 0000000000000004 R08: 0000000020000000 R09: 00007ffcb8e40031
R10: 0000000020c35fff R11: 0000000000000246 R12: 0000000000401e40
R13: 0000000000401ed0 R14: 0000000000000000 R15: 0000000000000000
general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 7038 Comm: syz-executor593 Not tainted 5.7.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:unpin_user_pages+0x38/0x80 mm/gup.c:338
Code: 56 d3 ff 31 ff 4c 89 e6 e8 a5 57 d3 ff 4d 85 e4 74 3f 49 bd 00 00 00 00 00 fc ff df 31 ed e8 ff 55 d3 ff 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00 75 2b 48 8b 3b 48 83 c5 01 48 83 c3 08 e8 51 f8 ff
RSP: 0018:ffffc90002537cc8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff819fdc9b
RDX: 0000000000000000 RSI: ffffffff819fdcb1 RDI: 0000000000000007
RBP: 0000000000000000 R08: ffff88809ff6e0c0 R09: ffffed1015ce7164
R10: ffff8880ae738b1b R11: ffffed1015ce7163 R12: 0000000000000011
R13: dffffc0000000000 R14: 0000000000000011 R15: 0000000020c35fff
FS:  0000000000d95880(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6870abd000 CR3: 000000009a8e7000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rds_info_getsockopt+0x291/0x410 net/rds/info.c:237
 rds_getsockopt+0x172/0x2d0 net/rds/af_rds.c:502
 __sys_getsockopt+0x14b/0x2e0 net/socket.c:2172
 __do_sys_getsockopt net/socket.c:2187 [inline]
 __se_sys_getsockopt net/socket.c:2184 [inline]
 __x64_sys_getsockopt+0xba/0x150 net/socket.c:2184
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x440559
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b 14 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffcb8e48ea8 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00007ffcb8e48eb0 RCX: 0000000000440559
RDX: 0000000000002710 RSI: 0000000000000114 RDI: 0000000000000003
RBP: 0000000000000004 R08: 0000000020000000 R09: 00007ffcb8e40031
R10: 0000000020c35fff R11: 0000000000000246 R12: 0000000000401e40
R13: 0000000000401ed0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace c9d832ffc8da59ec ]---
RIP: 0010:unpin_user_pages+0x38/0x80 mm/gup.c:338
Code: 56 d3 ff 31 ff 4c 89 e6 e8 a5 57 d3 ff 4d 85 e4 74 3f 49 bd 00 00 00 00 00 fc ff df 31 ed e8 ff 55 d3 ff 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00 75 2b 48 8b 3b 48 83 c5 01 48 83 c3 08 e8 51 f8 ff
RSP: 0018:ffffc90002537cc8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff819fdc9b
RDX: 0000000000000000 RSI: ffffffff819fdcb1 RDI: 0000000000000007
RBP: 0000000000000000 R08: ffff88809ff6e0c0 R09: ffffed1015ce7164
R10: ffff8880ae738b1b R11: ffffed1015ce7163 R12: 0000000000000011
R13: dffffc0000000000 R14: 0000000000000011 R15: 0000000020c35fff
FS:  0000000000d95880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbc58039178 CR3: 000000009a8e7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
