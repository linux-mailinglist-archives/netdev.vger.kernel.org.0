Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7B22F03A6
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 21:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbhAIU6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 15:58:01 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:36002 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbhAIU6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 15:58:00 -0500
Received: by mail-il1-f198.google.com with SMTP id z15so13581591ilb.3
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 12:57:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=3TTiu2M3RHn4JcWH5ej08s7USChU5t3nyfHhSBosYAQ=;
        b=MhGiWN9v9ghwOHM5YZsPptNZxMHZ55qne+NPoL9DMiGJLH/+Eg9cI1VrdK4VCPq4o3
         UqfiICuCaVW3uLBJIJVB1vqTM1BbjBL68rZc1fxN1B/NbMVAjVYI5sQeI0xa9QloDKuA
         Aq6pxU8zc2/PHXlnhy8UCvjM+7lU4ju8nvisbidwq49clnvCaDYrUybHURV9LzIZz6Y7
         1qSSPCvRLCH4NuZdftJiA/o+2bmyAmcKx8BdsyQls9Z3Dyx1y8ZAmERSIRc4VhhOYZdL
         7EicIZXWwFed7gjrvZuhY7tRQMXUszIRbW0hL5j57jPOm5i8hZiJrSFjLMIwv1Nml3yG
         HtQQ==
X-Gm-Message-State: AOAM532iFAFP4DjJlr3MQA4QJb0VoD9XcUahuFKB6GmEFmyGdXzaNF8Y
        yMO2P4GFEe07Imt4MNT85IIkYHvZ1t32bO/F8FerAQktL4nu
X-Google-Smtp-Source: ABdhPJyX3C5PwImyAsveNRBLPtx9Zfawm9AJWFt2P8oE5ukfFdBeoLh6aEFEo/O9Jd+1c3J6CRWnJyZEDQMgfRNpkWOR2Ztqv6Ax
MIME-Version: 1.0
X-Received: by 2002:a02:8790:: with SMTP id t16mr8947810jai.80.1610225839814;
 Sat, 09 Jan 2021 12:57:19 -0800 (PST)
Date:   Sat, 09 Jan 2021 12:57:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000030bc3305b87debd4@google.com>
Subject: WARNING in rds_rdma_extra_size
From:   syzbot <syzbot+1bd2b07f93745fa38425@syzkaller.appspotmail.com>
To:     a@unstable.cc, akpm@linux-foundation.org, ast@kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, daniel@iogearbox.net,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mareklindner@neomailbox.ch,
        mdroth@linux.vnet.ibm.com, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6207214a Merge tag 'afs-fixes-04012021' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=146967c0d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8aa30b9da402d224
dashboard link: https://syzkaller.appspot.com/bug?extid=1bd2b07f93745fa38425
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1351c11f500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1710cb50d00000

The issue was bisected to:

commit fdadd04931c2d7cd294dc5b2b342863f94be53a3
Author: Daniel Borkmann <daniel@iogearbox.net>
Date:   Tue Dec 11 11:14:12 2018 +0000

    bpf: fix bpf_jit_limit knob for PAGE_SIZE >= 64K

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10056f70d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12056f70d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14056f70d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1bd2b07f93745fa38425@syzkaller.appspotmail.com
Fixes: fdadd04931c2 ("bpf: fix bpf_jit_limit knob for PAGE_SIZE >= 64K")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8462 at mm/page_alloc.c:4976 __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5011
Modules linked in:
CPU: 1 PID: 8462 Comm: syz-executor292 Not tainted 5.11.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:4976
Code: 00 00 0c 00 0f 85 a7 00 00 00 8b 3c 24 4c 89 f2 44 89 e6 c6 44 24 70 00 48 89 6c 24 58 e8 d0 d7 ff ff 49 89 c5 e9 ea fc ff ff <0f> 0b e9 b5 fd ff ff 89 74 24 14 4c 89 4c 24 08 4c 89 74 24 18 e8
RSP: 0018:ffffc9000169f790 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff920002d3ef6 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000040dc0
RBP: 0000000000040dc0 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81b1f7f1 R11: 0000000000000000 R12: 0000000000000018
R13: 0000000000000018 R14: 0000000000000000 R15: 0000000ffffff1f0
FS:  0000000000f3c880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6b332916c0 CR3: 00000000133c3000 CR4: 0000000000350ee0
Call Trace:
 alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
 alloc_pages include/linux/gfp.h:547 [inline]
 kmalloc_order+0x2e/0xb0 mm/slab_common.c:837
 kmalloc_order_trace+0x14/0x120 mm/slab_common.c:853
 kmalloc_array include/linux/slab.h:592 [inline]
 kcalloc include/linux/slab.h:621 [inline]
 rds_rdma_extra_size+0xb2/0x3b0 net/rds/rdma.c:568
 rds_rm_size net/rds/send.c:928 [inline]
 rds_sendmsg+0x20d7/0x3020 net/rds/send.c:1265
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440359
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe89376b68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440359
RDX: 0000000000000000 RSI: 0000000020001600 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401b60
R13: 0000000000401bf0 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
