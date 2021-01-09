Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C570B2F0363
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 21:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbhAIUR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 15:17:58 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:44367 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbhAIUR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 15:17:57 -0500
Received: by mail-io1-f71.google.com with SMTP id a1so10343465ioa.11
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 12:17:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DOtSLUgu9OHp2xhaOIkH4fbkHc8mfJ2oKCEW3M693y0=;
        b=qZRhScGeBoG/0Op7345ocdy2LjCC6ZXRgJI/6dBk/iqqR/HYmtvgAcZK9eobb1dSRJ
         GVYpnSjzzgWrAESlZEeHoUHjlQt5q/kf/q2vfpBwu2FNP/3HY0o2LeBFbzS/4drQ3mtC
         Xe1yv/1CgbUvwc/tsXoWwdM81lcyfdhNNUi1bvbCETBj3+MHr0jnn8hr5GJmMEdw7XzN
         4TEVBzKw+dCV9lpeYhXTUYyx5AE6cfQhp56E6rxKy9rfvk2ncMUUGl7PqWME6WkPrZUf
         Mttj4d99NPGaWRwEq/rMxtdFU81wyGfmzEv58uPTZ9/iK0y1eeBx4dXsT7c2Gv+De7vd
         hawg==
X-Gm-Message-State: AOAM532kGSGQpFRKIeeELce2ZO9rNFrHhRU5kxCmPSFASZccF6C7NTXM
        R0NpnNfubPZ+3gxVFf5kboIJy8lhnst2qRC+QJzgxP7ZBe7C
X-Google-Smtp-Source: ABdhPJxxwioHJph+8kt6pb9ZunIYl4nLWF909hlBmmyLcDiQTwOXNZ+LPJZkNYdvHjaMWgkLnaRw86MYW/RmzyKPvNI1vDmTxsBd
MIME-Version: 1.0
X-Received: by 2002:a5d:9c57:: with SMTP id 23mr9875259iof.43.1610223436678;
 Sat, 09 Jan 2021 12:17:16 -0800 (PST)
Date:   Sat, 09 Jan 2021 12:17:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f3cf2e05b87d5bcd@google.com>
Subject: WARNING in bpf_prog_test_run_raw_tp
From:   syzbot <syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f6e7a024 Merge tag 'arc-5.11-rc3' of git://git.kernel.org/..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16f6472b500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8aa30b9da402d224
dashboard link: https://syzkaller.appspot.com/bug?extid=4f98876664c7337a4ae6
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1004b248d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1773c767500000

The issue was bisected to:

commit 1b4d60ec162f82ea29a2e7a907b5c6cc9f926321
Author: Song Liu <songliubraving@fb.com>
Date:   Fri Sep 25 20:54:29 2020 +0000

    bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15e5b0f7500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17e5b0f7500000
console output: https://syzkaller.appspot.com/x/log.txt?x=13e5b0f7500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com
Fixes: 1b4d60ec162f ("bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8484 at mm/page_alloc.c:4976 __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5011
Modules linked in:
CPU: 1 PID: 8484 Comm: syz-executor862 Not tainted 5.11.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:4976
Code: 00 00 0c 00 0f 85 a7 00 00 00 8b 3c 24 4c 89 f2 44 89 e6 c6 44 24 70 00 48 89 6c 24 58 e8 d0 d7 ff ff 49 89 c5 e9 ea fc ff ff <0f> 0b e9 b5 fd ff ff 89 74 24 14 4c 89 4c 24 08 4c 89 74 24 18 e8
RSP: 0018:ffffc900012efb10 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff9200025df66 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000140dc0
RBP: 0000000000140dc0 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81b1f7e1 R11: 0000000000000000 R12: 0000000000000014
R13: 0000000000000014 R14: 0000000000000000 R15: 0000000000000000
FS:  000000000190c880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f08b7f316c0 CR3: 0000000012073000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
 alloc_pages include/linux/gfp.h:547 [inline]
 kmalloc_order+0x2e/0xb0 mm/slab_common.c:837
 kmalloc_order_trace+0x14/0x120 mm/slab_common.c:853
 kmalloc include/linux/slab.h:557 [inline]
 kzalloc include/linux/slab.h:682 [inline]
 bpf_prog_test_run_raw_tp+0x4b5/0x670 net/bpf/test_run.c:282
 bpf_prog_test_run kernel/bpf/syscall.c:3120 [inline]
 __do_sys_bpf+0x1ea9/0x4f10 kernel/bpf/syscall.c:4398
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440499
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe1f3bfb18 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440499
RDX: 0000000000000048 RSI: 0000000020000600 RDI: 000000000000000a
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401ca0
R13: 0000000000401d30 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
