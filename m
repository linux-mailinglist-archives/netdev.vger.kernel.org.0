Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A7B2198C8
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 08:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgGIGnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 02:43:21 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:49535 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgGIGnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 02:43:20 -0400
Received: by mail-io1-f70.google.com with SMTP id c17so673050iow.16
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 23:43:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Zdtg9CvaIkqpqKBWCexbbCyZM1ziH+MgmbOSOczf1dc=;
        b=W/YIsSBuVT7C1jMP9TnXc/29HY9INDIMn1yExi5JBMis6iJJgJWmaWNX1qcxEL/VqJ
         o8daPMGoJod+dwXiatKHeixZGl29dns+BU6Wkz4OUPirlTxjC/k0HboRKQC6oI49+bb2
         O5ztfIEVH+EIxeNzgrVuKFOHXqRdCV8MCt4mv9cpaBlftpCtXLzm4YvFNW0rs589K8rn
         5AkGP0SOphAP4k8NAAF4f2KVUQeMR3rJKiFqUYdgFMBJ7tjnnniG7a9s1JpFFUEd5Xhu
         2ZkIWUeTuweYyHwxl+EO5G0n6JRVxSV2Hhi6290v97kvIZ7puxm0YRjRmS5Il/56Bl/t
         ZPbw==
X-Gm-Message-State: AOAM531NBEoNHdI+3EaJA+qJD3X+keKPnS4O+h7aNwmp46vndGOWjgOf
        UASPBkA0kdfY45bcbYIHMZMloY+KNSD62PcUQeTg15sJjLuF
X-Google-Smtp-Source: ABdhPJwsHokFN3PjulLLWNJk/Xuyv+sv7UwCN/zonGpHb6NVTEYSQHzt8ZHqJ+/GN9O/HywOanBt/qveH2lDSrfBvRrrXndRvuMi
MIME-Version: 1.0
X-Received: by 2002:a92:c703:: with SMTP id a3mr41528262ilp.159.1594276999168;
 Wed, 08 Jul 2020 23:43:19 -0700 (PDT)
Date:   Wed, 08 Jul 2020 23:43:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000358aec05a9fc8aa8@google.com>
Subject: general protection fault in khugepaged
From:   syzbot <syzbot+ed318e8b790ca72c5ad0@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    e44f65fd xen-netfront: remove redundant assignment to vari..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15de54a7100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=829871134ca5e230
dashboard link: https://syzkaller.appspot.com/bug?extid=ed318e8b790ca72c5ad0
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=113406a7100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=175597d3100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ed318e8b790ca72c5ad0@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 1155 Comm: khugepaged Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:anon_vma_lock_write include/linux/rmap.h:120 [inline]
RIP: 0010:collapse_huge_page mm/khugepaged.c:1110 [inline]
RIP: 0010:khugepaged_scan_pmd mm/khugepaged.c:1349 [inline]
RIP: 0010:khugepaged_scan_mm_slot mm/khugepaged.c:2110 [inline]
RIP: 0010:khugepaged_do_scan mm/khugepaged.c:2193 [inline]
RIP: 0010:khugepaged+0x3bba/0x5a10 mm/khugepaged.c:2238
Code: 01 00 00 48 8d bb 88 00 00 00 48 89 f8 48 c1 e8 03 42 80 3c 30 00 0f 85 fa 0f 00 00 48 8b 9b 88 00 00 00 48 89 d8 48 c1 e8 03 <42> 80 3c 30 00 0f 85 d4 0f 00 00 48 8b 3b 48 83 c7 08 e8 9f ff 30
RSP: 0018:ffffc90004be7c80 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff81a72d8b
RDX: ffff8880a69d8100 RSI: ffffffff81b7606b RDI: ffff88809f0577c0
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8881ff213a7f
R10: 0000000000000080 R11: 0000000000000000 R12: ffffffff8aae6110
R13: ffffc90004be7de0 R14: dffffc0000000000 R15: 0000000020000000
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000001fe0cf000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
Modules linked in:
---[ end trace f1f03dbd2ea0777e ]---
RIP: 0010:anon_vma_lock_write include/linux/rmap.h:120 [inline]
RIP: 0010:collapse_huge_page mm/khugepaged.c:1110 [inline]
RIP: 0010:khugepaged_scan_pmd mm/khugepaged.c:1349 [inline]
RIP: 0010:khugepaged_scan_mm_slot mm/khugepaged.c:2110 [inline]
RIP: 0010:khugepaged_do_scan mm/khugepaged.c:2193 [inline]
RIP: 0010:khugepaged+0x3bba/0x5a10 mm/khugepaged.c:2238
Code: 01 00 00 48 8d bb 88 00 00 00 48 89 f8 48 c1 e8 03 42 80 3c 30 00 0f 85 fa 0f 00 00 48 8b 9b 88 00 00 00 48 89 d8 48 c1 e8 03 <42> 80 3c 30 00 0f 85 d4 0f 00 00 48 8b 3b 48 83 c7 08 e8 9f ff 30
RSP: 0018:ffffc90004be7c80 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff81a72d8b
RDX: ffff8880a69d8100 RSI: ffffffff81b7606b RDI: ffff88809f0577c0
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8881ff213a7f
R10: 0000000000000080 R11: 0000000000000000 R12: ffffffff8aae6110
R13: ffffc90004be7de0 R14: dffffc0000000000 R15: 0000000020000000
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004c00c8 CR3: 00000001f7ac5000 CR4: 00000000001406f0
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
