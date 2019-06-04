Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9272335297
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 00:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfFDWMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 18:12:07 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:44812 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfFDWMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 18:12:06 -0400
Received: by mail-io1-f72.google.com with SMTP id i133so17541388ioa.11
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 15:12:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=4zrtG0XmRafv3j5Yib6bgh6/3I23mwuyh2DcSRuqNzk=;
        b=Q6w+ahxIXv5hP18QHw9HMYPeq1KmuiBvE/joqspKMRtDnGB0KH6Kw1kgYqMcn03ic5
         yIo/binaBsiAptLkUQHHhA53Ikk8byENUbHY/K9h6bdaxSxLgnairMUtGk84zfgFqu0R
         LfzOPQir27N3TuKCjCdK0ZmixTYwE27BQAcFJepT4PVFjKEuhY1Usuef06q2drXcy0OJ
         a1pJj+AoHzMya+dkXmNY7SkKlw/Cn62xMa/tedj+XjxDHNtuskde0fNETejJo6ehD7jT
         vVAIuxl2k9mIDyLAcDr0AR61YSy4fYhNsoORCei8SQsclgW/5AK6No7QYduu5dVcL/aO
         XO+Q==
X-Gm-Message-State: APjAAAXNAobC8+Y7Xt1Yx9S5vz+4UUmPJoxIEQjV0l01kXW/FZdsC2OH
        Onu/6ie2TVWVnynJxAx4MEMClQyR0qxGqOeHTFn4LsoNiMZo
X-Google-Smtp-Source: APXvYqyNJ+gd5jysKsWYyTwYnobocMOkgWWRkeyweRn8et0HytOaI9WhC680fGF93uhAY2xSNGZ1sHTsisk9c/7/ehL/n8R/wmnL
MIME-Version: 1.0
X-Received: by 2002:a5d:81c6:: with SMTP id t6mr6110231iol.86.1559686325550;
 Tue, 04 Jun 2019 15:12:05 -0700 (PDT)
Date:   Tue, 04 Jun 2019 15:12:05 -0700
In-Reply-To: <00000000000097025d058a7fd785@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000065453c058a86c539@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in css_task_iter_advance
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

syzbot has found a reproducer for the following crash on:

HEAD commit:    56b697c6 Add linux-next specific files for 20190604
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=122c965aa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4248d6bc70076f7d
dashboard link: https://syzkaller.appspot.com/bug?extid=9343b7623bc03dc680c1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=102ab292a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15f0e27ca00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9343b7623bc03dc680c1@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in css_task_iter_advance+0x49b/0x540  
kernel/cgroup/cgroup.c:4507
Read of size 4 at addr ffff8880a2013d64 by task syz-executor561/8892

CPU: 0 PID: 8892 Comm: syz-executor561 Not tainted 5.2.0-rc3-next-20190604  
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
  css_task_iter_next+0x101/0x190 kernel/cgroup/cgroup.c:4569
  pidlist_array_load+0x1bf/0xa80 kernel/cgroup/cgroup-v1.c:373
  cgroup_pidlist_start+0x37e/0x4c0 kernel/cgroup/cgroup-v1.c:442
  cgroup_seqfile_start+0xa4/0xd0 kernel/cgroup/cgroup.c:3752
  kernfs_seq_start+0xdc/0x190 fs/kernfs/file.c:118
  seq_read+0x2a7/0x1110 fs/seq_file.c:224
  kernfs_fop_read+0xed/0x560 fs/kernfs/file.c:252
  do_loop_readv_writev fs/read_write.c:714 [inline]
  do_loop_readv_writev fs/read_write.c:701 [inline]
  do_iter_read+0x4a4/0x660 fs/read_write.c:935
  vfs_readv+0xf0/0x160 fs/read_write.c:997
  do_preadv+0x1c4/0x280 fs/read_write.c:1089
  __do_sys_preadv fs/read_write.c:1139 [inline]
  __se_sys_preadv fs/read_write.c:1134 [inline]
  __x64_sys_preadv+0x9a/0xf0 fs/read_write.c:1134
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4471c9
Code: e8 4c bb 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 5b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f7fb370bdb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 00000000006dcc58 RCX: 00000000004471c9
RDX: 0000000000000001 RSI: 0000000020000100 RDI: 0000000000000004
RBP: 00000000006dcc50 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc5c
R13: 00007fffdb647a6f R14: 00007f7fb370c9c0 R15: 0000000000000001

Allocated by task 8773:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:489 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:503
  __do_kmalloc mm/slab.c:3654 [inline]
  __kmalloc+0x15c/0x740 mm/slab.c:3663
  kmalloc include/linux/slab.h:552 [inline]
  tomoyo_realpath_from_path+0xcd/0x7a0 security/tomoyo/realpath.c:277
  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
  tomoyo_path_number_perm+0x1dd/0x520 security/tomoyo/file.c:723
  tomoyo_file_ioctl+0x23/0x30 security/tomoyo/tomoyo.c:335
  security_file_ioctl+0x77/0xc0 security/security.c:1366
  ksys_ioctl+0x57/0xd0 fs/ioctl.c:711
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8773:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3426 [inline]
  kfree+0x106/0x2a0 mm/slab.c:3753
  tomoyo_realpath_from_path+0x1de/0x7a0 security/tomoyo/realpath.c:319
  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
  tomoyo_path_number_perm+0x1dd/0x520 security/tomoyo/file.c:723
  tomoyo_file_ioctl+0x23/0x30 security/tomoyo/tomoyo.c:335
  security_file_ioctl+0x77/0xc0 security/security.c:1366
  ksys_ioctl+0x57/0xd0 fs/ioctl.c:711
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a20127c0
  which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1444 bytes to the right of
  4096-byte region [ffff8880a20127c0, ffff8880a20137c0)
The buggy address belongs to the page:
page:ffffea0002880480 refcount:1 mapcount:0 mapping:ffff8880aa400dc0  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002311108 ffffea0002885488 ffff8880aa400dc0
raw: 0000000000000000 ffff8880a20127c0 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a2013c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880a2013c80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8880a2013d00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                                        ^
  ffff8880a2013d80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880a2013e00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

