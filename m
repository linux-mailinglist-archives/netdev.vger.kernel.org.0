Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA82A10EC41
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 16:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfLBPZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 10:25:11 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:43301 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727420AbfLBPZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 10:25:11 -0500
Received: by mail-io1-f70.google.com with SMTP id b17so13655414ioh.10
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 07:25:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HuDfrZ1OF+dWnnebJjn3ik7xCXcbbjobtTApG9H/SS4=;
        b=jFpaAO6Kzr9+KOFZOP8yliwteqIW1H6QZmrlP2aLt4ssmKXDsdXj6n0ZOPv8Y1T1oC
         H7BmSnJpYe1VolApu8wAFhWtM2Ca5OI090eATChx49kCdSe3KdP2V1/Fpgkvh73NRcVr
         CiJ/yJrPXt3YeOOpbj0KduAdgK/APbbD/YJTe5G4awuWntnvefVBXmP8tszf+oG6tCtx
         qT3hYDZjV2LCVQ66FQ3scShNF7etch2jCYHEiEkiCjTTKuET+9JiNU5TmZFZV4WczI38
         mjTsvzy7j32hncuvEtN2IrQOSyRvf1S08vtUnHKVMpwTPa3Ajt4AHS41zfuvkMy01pY7
         9TZA==
X-Gm-Message-State: APjAAAUiq4BO+senVgK13KvNSsaxqTpRZ5/+/MtNRwU0y7rLF5h57vbD
        QhUKWvzFDPYA43dBqTdPg9Xo3HiQhM8xJ8+2ijvSdMDd5A67
X-Google-Smtp-Source: APXvYqzriBKJ3tzLGjQMUUrMkC55k/YsKi/GH0zcp3Xaak4Ph6RO7qqhFv/wCX7c9X2JXe/NQKC2rmT7RhrdCHYXILlhFAe08Ei8
MIME-Version: 1.0
X-Received: by 2002:a5e:8b03:: with SMTP id g3mr22807234iok.279.1575300309112;
 Mon, 02 Dec 2019 07:25:09 -0800 (PST)
Date:   Mon, 02 Dec 2019 07:25:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000056e0330598ba2fe5@google.com>
Subject: WARNING in generic_make_request_checks (2)
From:   syzbot <syzbot+452bda868799d5a80da8@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, axboe@kernel.dk,
        bpf@vger.kernel.org, daniel@iogearbox.net, idryomov@gmail.com,
        kafai@fb.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sagi@grimberg.me, snitzer@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        wgh@torlan.ru, yhs@fb.com, zkabelac@redhat.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    a6ed68d6 Merge tag 'drm-next-2019-11-27' of git://anongit...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=128c4432e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6349516b24252b37
dashboard link: https://syzkaller.appspot.com/bug?extid=452bda868799d5a80da8
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144180a6e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b9afcee00000

The bug was bisected to:

commit a32e236eb93e62a0f692e79b7c3c9636689559b9
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Aug 3 19:22:09 2018 +0000

     Partially revert "block: fail op_is_write() requests to read-only  
partitions"

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1634767ee00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1534767ee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1134767ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+452bda868799d5a80da8@syzkaller.appspotmail.com
Fixes: a32e236eb93e ("Partially revert "block: fail op_is_write() requests  
to read-only partitions"")

------------[ cut here ]------------
generic_make_request: Trying to write to read-only block-device loop0  
(partno 0)
WARNING: CPU: 0 PID: 9114 at block/blk-core.c:800 bio_check_ro  
block/blk-core.c:800 [inline]
WARNING: CPU: 0 PID: 9114 at block/blk-core.c:800  
generic_make_request_checks+0x1c78/0x2190 block/blk-core.c:901
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9114 Comm: syz-executor056 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  panic+0x2e3/0x75c kernel/panic.c:221
  __warn.cold+0x2f/0x3e kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  fixup_bug arch/x86/kernel/traps.c:169 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:bio_check_ro block/blk-core.c:800 [inline]
RIP: 0010:generic_make_request_checks+0x1c78/0x2190 block/blk-core.c:901
Code: 00 00 44 8b ab 5c 05 00 00 48 8d b5 78 ff ff ff 4c 89 ff e8 5a 94 05  
00 48 c7 c7 c0 47 05 88 48 89 c6 44 89 ea e8 a7 e4 0e fe <0f> 0b 48 b8 00  
00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 80 3c 02
RSP: 0018:ffff8880957071c0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8880a3af2000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815dc196 RDI: ffffed1012ae0e2a
RBP: ffff8880957072c0 R08: ffff888093ace600 R09: ffffed1015d06621
R10: ffffed1015d06620 R11: ffff8880ae833107 R12: ffff8880a8dbc008
R13: 0000000000000000 R14: 0000000000000001 R15: ffff8880a8dbc000
  generic_make_request+0x8f/0xb50 block/blk-core.c:1020
  submit_bio+0x113/0x600 block/blk-core.c:1192
  submit_bh_wbc+0x6b6/0x900 fs/buffer.c:3095
  __block_write_full_page+0x7fe/0x11b0 fs/buffer.c:1767
  block_write_full_page+0x21f/0x270 fs/buffer.c:2953
  blkdev_writepage+0x25/0x30 fs/block_dev.c:609
  __writepage+0x66/0x110 mm/page-writeback.c:2303
  write_cache_pages+0x80c/0x13f0 mm/page-writeback.c:2238
  generic_writepages mm/page-writeback.c:2329 [inline]
  generic_writepages+0xed/0x160 mm/page-writeback.c:2318
  blkdev_writepages+0x1e/0x30 fs/block_dev.c:2060
  do_writepages+0xfa/0x2a0 mm/page-writeback.c:2344
  __filemap_fdatawrite_range+0x2bc/0x3b0 mm/filemap.c:421
  __filemap_fdatawrite mm/filemap.c:429 [inline]
  filemap_fdatawrite mm/filemap.c:434 [inline]
  filemap_write_and_wait mm/filemap.c:640 [inline]
  filemap_write_and_wait+0xf8/0x1e0 mm/filemap.c:635
  __sync_blockdev fs/block_dev.c:491 [inline]
  sync_blockdev fs/block_dev.c:500 [inline]
  __blkdev_put+0x204/0x810 fs/block_dev.c:1889
  blkdev_put+0x98/0x560 fs/block_dev.c:1958
  blkdev_close+0x8b/0xb0 fs/block_dev.c:1965
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x8e7/0x2e00 kernel/exit.c:797
  do_group_exit+0x135/0x360 kernel/exit.c:895
  __do_sys_exit_group kernel/exit.c:906 [inline]
  __se_sys_exit_group kernel/exit.c:904 [inline]
  __x64_sys_exit_group+0x44/0x50 kernel/exit.c:904
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x442c38
Code: 00 00 ea dc 40 00 00 00 00 00 c8 de 40 00 00 00 00 00 ea dc 40 00 00  
00 00 00 ea dc 40 00 00 00 00 00 ea dc 40 00 00 00 00 00 <ea> dc 40 00 00  
00 00 00 ea dc 40 00 00 00 00 00 ea dc 40 00 00 00
RSP: 002b:00007fffc31b9748 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000442c38
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004c2548 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 00000000004002e0 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d41a0 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
