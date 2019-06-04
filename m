Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3697534985
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbfFDN4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:56:08 -0400
Received: from mail-it1-f197.google.com ([209.85.166.197]:37217 "EHLO
        mail-it1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727515AbfFDN4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:56:07 -0400
Received: by mail-it1-f197.google.com with SMTP id q20so90782itq.2
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=e0x3CjfxT+Tc9OfQE9UyUP0v/CUgs1KGy0Ok9Cy7y8Q=;
        b=LnOaewh31ZFXAL/d9Lfi0MndAioB+zmU0m/v/5NLd94gHXT8jg3N4TJVHdig+5/BJ0
         QCXgtVN9OOORcEWH2QMU7IFdc4HqOQRL0uK19MgJvzFaTGygOTFTCawq5jKaIyr3VMsD
         jgq8YSHjSKsHT9S+4iQulBWgFaq+WUE5w35a4YOV8I6WOoUVq4om8/JM9vnQ6TtEQw3b
         CuUOTexXqdkjR2JLd/CFE8Tel1cA1YopO35sK8WgRY7JBd5Tp+iRGVyjgC+wi+vtX66u
         wsKGS7HTLlLVwLTcc/voAEokcA270/T+LBoSz/QnOqJfapJxwGdQZ+bYbQaBaVaWASg4
         p5Rw==
X-Gm-Message-State: APjAAAUxpeFoph9vigzMcKe9Wcpzcn/7F83yjHkAqT6aAr5pAD99n2KS
        uOlXwWLQaN1hN974XKmzp7Rb5t+r774Nd3JvumGlPO8Nr5YG
X-Google-Smtp-Source: APXvYqxswE3V/GpTEDke+LgJdIgEgE7AHZepq4QIp7VgGjhnjLYEetNn3M4bxurDFjITYWRV/6FI9+281KrpB9Zvomf/8KvUcPy8
MIME-Version: 1.0
X-Received: by 2002:a5d:9f12:: with SMTP id q18mr16396879iot.250.1559656566027;
 Tue, 04 Jun 2019 06:56:06 -0700 (PDT)
Date:   Tue, 04 Jun 2019 06:56:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000097025d058a7fd785@google.com>
Subject: KASAN: slab-out-of-bounds Read in css_task_iter_advance
From:   syzbot <syzbot+9343b7623bc03dc680c1@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org,
        daniel@iogearbox.net, hannes@cmpxchg.org, kafai@fb.com,
        linux-kernel@vger.kernel.org, lizefan@huawei.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tj@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    56b697c6 Add linux-next specific files for 20190604
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=170d747ca00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4248d6bc70076f7d
dashboard link: https://syzkaller.appspot.com/bug?extid=9343b7623bc03dc680c1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9343b7623bc03dc680c1@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in css_task_iter_advance+0x49b/0x540  
kernel/cgroup/cgroup.c:4507
Read of size 4 at addr ffff88809ae59d64 by task syz-executor.2/28895

CPU: 1 PID: 28895 Comm: syz-executor.2 Not tainted 5.2.0-rc3-next-20190604  
#8
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
  kasan_report+0x12/0x20 mm/kasan/common.c:614
  __asan_report_load4_noabort+0x14/0x20 mm/kasan/generic_report.c:131
  css_task_iter_advance+0x49b/0x540 kernel/cgroup/cgroup.c:4507
  css_task_iter_start+0x18b/0x230 kernel/cgroup/cgroup.c:4543
  update_tasks_flags+0x85/0x100 kernel/cgroup/cpuset.c:1836
  update_flag+0x232/0x470 kernel/cgroup/cpuset.c:1886
  cpuset_write_u64+0x222/0x270 kernel/cgroup/cpuset.c:2268
  cgroup_file_write+0x4db/0x790 kernel/cgroup/cgroup.c:3727
  kernfs_fop_write+0x2b8/0x480 fs/kernfs/file.c:316
  __vfs_write+0x8a/0x110 fs/read_write.c:494
  vfs_write+0x268/0x5d0 fs/read_write.c:558
  ksys_write+0x14f/0x290 fs/read_write.c:611
  __do_sys_write fs/read_write.c:623 [inline]
  __se_sys_write fs/read_write.c:620 [inline]
  __x64_sys_write+0x73/0xb0 fs/read_write.c:620
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459279
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8d15ef2c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459279
RDX: 0000000000000011 RSI: 00000000200000c0 RDI: 0000000000000004
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f8d15ef36d4
R13: 00000000004c8eb1 R14: 00000000004dfb68 R15: 00000000ffffffff

Allocated by task 9803:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:489 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
  kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:497
  slab_post_alloc_hook mm/slab.h:444 [inline]
  slab_alloc mm/slab.c:3320 [inline]
  kmem_cache_alloc+0x11a/0x6f0 mm/slab.c:3482
  getname_flags fs/namei.c:138 [inline]
  getname_flags+0xd6/0x5b0 fs/namei.c:128
  getname fs/namei.c:209 [inline]
  do_renameat2+0x199/0xc40 fs/namei.c:4543
  __do_sys_rename fs/namei.c:4671 [inline]
  __se_sys_rename fs/namei.c:4669 [inline]
  __x64_sys_rename+0x61/0x80 fs/namei.c:4669
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9803:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3426 [inline]
  kmem_cache_free+0x86/0x320 mm/slab.c:3692
  putname+0xef/0x130 fs/namei.c:259
  do_renameat2+0x2b4/0xc40 fs/namei.c:4647
  __do_sys_rename fs/namei.c:4671 [inline]
  __se_sys_rename fs/namei.c:4669 [inline]
  __x64_sys_rename+0x61/0x80 fs/namei.c:4669
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88809ae58440
  which belongs to the cache names_cache of size 4096
The buggy address is located 2340 bytes to the right of
  4096-byte region [ffff88809ae58440, ffff88809ae59440)
The buggy address belongs to the page:
page:ffffea00026b9600 refcount:1 mapcount:0 mapping:ffff8880aa593ac0  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea00018b4308 ffffea0001afb488 ffff8880aa593ac0
raw: 0000000000000000 ffff88809ae58440 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88809ae59c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88809ae59c80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff88809ae59d00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                                        ^
  ffff88809ae59d80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88809ae59e00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
