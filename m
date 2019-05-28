Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070422BEB8
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 07:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfE1FsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 01:48:07 -0400
Received: from mail-it1-f198.google.com ([209.85.166.198]:59632 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfE1FsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 01:48:06 -0400
Received: by mail-it1-f198.google.com with SMTP id h133so1411723ith.9
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 22:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=nUKhwxbNxZ9sD3FLYrCIiC9v9dylgsFF4TAhQyd8XCg=;
        b=pl2AKP1wMlUc92ajbJBmN1vInRyoe67Pfuvk1eBynAtr3vIE3h6Q/7cM8x2tR4dTxG
         GGd8uz9rGxVjS1z/KvngWx0yUmnF2GLqnkEbN3AcV84n/iuVn3PM3T6ey7zdaCfK3jr9
         ittdB2BYRzlx+ab/ML+JWkythL4A2pJbqVVR3L463HQOjDe/olW1SfGroZN0eHGnkiFW
         9M4isepLZFnXCmXPFPXUTL16dWHfZW9SB3MTh4aUEs8NNHpMuakx7W3L+0WlNcahQDW/
         N3m0WSg1QkUxaCSUAE606XnHpDb+vLOquYaPyehvm1hrMdUcs6jsRX/MzY2nC/bQl8SW
         Xt8A==
X-Gm-Message-State: APjAAAVEEN0W9M6iZGN/DMVWDM5sBxN9IPM9vM3eh1nPffov+lPQiYmZ
        hMwYWPFkiF2md2B6TvDsKlTaaKcv5HX1fI6zAGN7D5gobIlq
X-Google-Smtp-Source: APXvYqyJLrD7DYVNWJiTDYYbtuxXsWJsrNoyzwRM7gay6qwYJMO2ZRox0siuScV6dA6z25GQJgdwFdMoO4qgBQnxkPV1kLB8/7ui
MIME-Version: 1.0
X-Received: by 2002:a24:4d1:: with SMTP id 200mr1755606itb.92.1559022485918;
 Mon, 27 May 2019 22:48:05 -0700 (PDT)
Date:   Mon, 27 May 2019 22:48:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000785e9d0589ec359a@google.com>
Subject: KASAN: invalid-free in tomoyo_realpath_from_path
From:   syzbot <syzbot+9742b1c6c7aedf18beda@syzkaller.appspotmail.com>
To:     jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp, serge@hallyn.com,
        syzkaller-bugs@googlegroups.com, takedakn@nttdata.co.jp
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f4aa8012 cxgb4: Make t4_get_tp_e2c_map static
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=173328baa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d137eb988ffd93c3
dashboard link: https://syzkaller.appspot.com/bug?extid=9742b1c6c7aedf18beda
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9742b1c6c7aedf18beda@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: double-free or invalid-free in  
tomoyo_realpath_from_path+0x1de/0x7a0 security/tomoyo/realpath.c:319

CPU: 1 PID: 11697 Comm: syz-executor.3 Not tainted 5.2.0-rc1+ #2
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
  kasan_report_invalid_free+0x65/0xa0 mm/kasan/report.c:279
  __kasan_slab_free+0x13a/0x150 mm/kasan/common.c:430
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3432 [inline]
  kfree+0xcf/0x220 mm/slab.c:3755
  tomoyo_realpath_from_path+0x1de/0x7a0 security/tomoyo/realpath.c:319
  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
  tomoyo_check_open_permission+0x2a8/0x3f0 security/tomoyo/file.c:771
  tomoyo_file_open security/tomoyo/tomoyo.c:319 [inline]
  tomoyo_file_open+0xa9/0xd0 security/tomoyo/tomoyo.c:314
  security_file_open+0x71/0x300 security/security.c:1458
  do_dentry_open+0x373/0x1250 fs/open.c:765
  vfs_open+0xa0/0xd0 fs/open.c:887
  do_last fs/namei.c:3416 [inline]
  path_openat+0x10e9/0x46d0 fs/namei.c:3533
  do_filp_open+0x1a1/0x280 fs/namei.c:3563
  do_sys_open+0x3fe/0x5d0 fs/open.c:1070
  __do_sys_open fs/open.c:1088 [inline]
  __se_sys_open fs/open.c:1083 [inline]
  __x64_sys_open+0x7e/0xc0 fs/open.c:1083
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4571f0
Code: 31 c0 e9 45 ff ff ff 0f 1f 00 80 3f 00 0f 84 f7 00 00 00 55 53 b9 02  
00 00 00 be 00 08 09 00 89 c8 48 81 ec 98 00 00 00 0f 05 <48> 3d 00 f0 ff  
ff 48 89 c3 0f 87 e9 00 00 00 85 db 0f 88 2f 01 00
RSP: 002b:00007ffee56b06a0 EFLAGS: 00000206 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00000000000cb440 RCX: 00000000004571f0
RDX: 000000000000000c RSI: 0000000000090800 RDI: 00007ffee56b1880
RBP: 0000000000000002 R08: 0000000000000001 R09: 0000555557133940
R10: 0000000000000000 R11: 0000000000000206 R12: 00007ffee56b1880
R13: 00007ffee56b1870 R14: 0000000000000000 R15: 00007ffee56b1880

Allocated by task 11696:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:489 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:503
  __do_kmalloc mm/slab.c:3660 [inline]
  __kmalloc+0x15c/0x740 mm/slab.c:3669
  kmalloc include/linux/slab.h:552 [inline]
  tomoyo_realpath_from_path+0xcd/0x7a0 security/tomoyo/realpath.c:277
  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
  tomoyo_check_open_permission+0x2a8/0x3f0 security/tomoyo/file.c:771
  tomoyo_file_open security/tomoyo/tomoyo.c:319 [inline]
  tomoyo_file_open+0xa9/0xd0 security/tomoyo/tomoyo.c:314
  security_file_open+0x71/0x300 security/security.c:1458
  do_dentry_open+0x373/0x1250 fs/open.c:765
  vfs_open+0xa0/0xd0 fs/open.c:887
  do_last fs/namei.c:3416 [inline]
  path_openat+0x10e9/0x46d0 fs/namei.c:3533
  do_filp_open+0x1a1/0x280 fs/namei.c:3563
  do_sys_open+0x3fe/0x5d0 fs/open.c:1070
  __do_sys_open fs/open.c:1088 [inline]
  __se_sys_open fs/open.c:1083 [inline]
  __x64_sys_open+0x7e/0xc0 fs/open.c:1083
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 11696:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3432 [inline]
  kfree+0xcf/0x220 mm/slab.c:3755
  tomoyo_realpath_from_path+0x1de/0x7a0 security/tomoyo/realpath.c:319
  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
  tomoyo_check_open_permission+0x2a8/0x3f0 security/tomoyo/file.c:771
  tomoyo_file_open security/tomoyo/tomoyo.c:319 [inline]
  tomoyo_file_open+0xa9/0xd0 security/tomoyo/tomoyo.c:314
  security_file_open+0x71/0x300 security/security.c:1458
  do_dentry_open+0x373/0x1250 fs/open.c:765
  vfs_open+0xa0/0xd0 fs/open.c:887
  do_last fs/namei.c:3416 [inline]
  path_openat+0x10e9/0x46d0 fs/namei.c:3533
  do_filp_open+0x1a1/0x280 fs/namei.c:3563
  do_sys_open+0x3fe/0x5d0 fs/open.c:1070
  __do_sys_open fs/open.c:1088 [inline]
  __se_sys_open fs/open.c:1083 [inline]
  __x64_sys_open+0x7e/0xc0 fs/open.c:1083
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88808b756780
  which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1792 bytes inside of
  4096-byte region [ffff88808b756780, ffff88808b757780)
The buggy address belongs to the page:
page:ffffea00022dd580 refcount:1 mapcount:0 mapping:ffff8880aa400dc0  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002924e08 ffffea00027a6588 ffff8880aa400dc0
raw: 0000000000000000 ffff88808b756780 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88808b756d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88808b756e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88808b756e80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    ^
  ffff88808b756f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff88808b756f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
