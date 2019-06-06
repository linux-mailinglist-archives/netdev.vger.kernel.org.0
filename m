Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3EA36BAE
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 07:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfFFFdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 01:33:10 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:54940 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfFFFdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 01:33:07 -0400
Received: by mail-io1-f69.google.com with SMTP id n8so762566ioo.21
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 22:33:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=W5FF42zVDo3trtwvrjbtAnVcsXKoMkINuTi+BPyFgek=;
        b=l1NaWD/jH5ok4PX9t8a/atDlBTrxQkeXaK2LKbx33pu2nPL4nlAHo0nOLKuM9XKsSS
         e/pfNRz8IhbyseeYzqBmDptilNVzKB0BbJptpSY2y2hJYKrrWsIxCo7M+r4ZGPcUwJ/T
         jrSwJWnze03e4gjAvWRT/5KYuiS0klQH45ESjO+eiswxL7wJw+KLFoo60QlhvU7gccPf
         t88AbTS49OkdEfB1UfypqmZ4f4sy3mFfDv9CieysWmUfmArvm4wLKZJPTp0NEXiA7GFE
         CaDq00lx6t0ne1YYaqBXqEr6yGtjjmz0+n5Xp4HEcSVCWN37I/xzFNmLKqUSUnGqdUEd
         UUhg==
X-Gm-Message-State: APjAAAXbJ0erFFgcBGI1edw76QhSJLCgKILloPBmTFHg1Yw8wcMU9Jbe
        bwJXPUaMaD76+i4z3cear33rPXyc2lYhVNBtRtWO37KzCmu1
X-Google-Smtp-Source: APXvYqz9VSUc/8eq6b84tHBQ+U7qjz624v0EGp0dlfT+6ewmxPMDHxVvliMgENV/TnWGADV2fbh3yhNDyGIqQ+am2toYAWdTda+c
MIME-Version: 1.0
X-Received: by 2002:a05:660c:887:: with SMTP id o7mr5081314itk.159.1559799186165;
 Wed, 05 Jun 2019 22:33:06 -0700 (PDT)
Date:   Wed, 05 Jun 2019 22:33:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006994aa058aa10cb8@google.com>
Subject: WARNING: refcount bug in css_task_iter_next
From:   syzbot <syzbot+644dc16442b3a35f3629@syzkaller.appspotmail.com>
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

HEAD commit:    b2924447 Add linux-next specific files for 20190605
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11c492d2a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4248d6bc70076f7d
dashboard link: https://syzkaller.appspot.com/bug?extid=644dc16442b3a35f3629
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+644dc16442b3a35f3629@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: increment on 0; use-after-free.
WARNING: CPU: 0 PID: 4184 at lib/refcount.c:156 refcount_inc_checked  
lib/refcount.c:156 [inline]
WARNING: CPU: 0 PID: 4184 at lib/refcount.c:156  
refcount_inc_checked+0x61/0x70 lib/refcount.c:154
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 4184 Comm: syz-executor.3 Not tainted 5.2.0-rc3-next-20190605 #9
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2cb/0x744 kernel/panic.c:219
  __warn.cold+0x20/0x4d kernel/panic.c:576
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:986
RIP: 0010:refcount_inc_checked lib/refcount.c:156 [inline]
RIP: 0010:refcount_inc_checked+0x61/0x70 lib/refcount.c:154
Code: 1d db 0e 68 06 31 ff 89 de e8 1b c4 3b fe 84 db 75 dd e8 d2 c2 3b fe  
48 c7 c7 e0 b6 c4 87 c6 05 bb 0e 68 06 01 e8 dd db 0d fe <0f> 0b eb c1 90  
90 90 90 90 90 90 90 90 90 90 55 48 89 e5 41 57 41
RSP: 0018:ffff8882000ef290 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815b04b6 RDI: ffffed104001de44
RBP: ffff8882000ef2a0 R08: ffff8882035744c0 R09: ffffed1015d040f1
R10: ffffed1015d040f0 R11: ffff8880ae820787 R12: ffff88804436a660
R13: ffff8882000ef368 R14: ffff88804436a640 R15: 1ffff1104001de5d
  css_task_iter_next+0xf9/0x190 kernel/cgroup/cgroup.c:4568
  mem_cgroup_scan_tasks+0xbb/0x180 mm/memcontrol.c:1168
  select_bad_process mm/oom_kill.c:374 [inline]
  out_of_memory mm/oom_kill.c:1088 [inline]
  out_of_memory+0x6b2/0x1280 mm/oom_kill.c:1035
  mem_cgroup_out_of_memory+0x1ca/0x230 mm/memcontrol.c:1573
  mem_cgroup_oom mm/memcontrol.c:1905 [inline]
  try_charge+0xfbe/0x1480 mm/memcontrol.c:2468
  mem_cgroup_try_charge+0x24d/0x5e0 mm/memcontrol.c:6073
  __add_to_page_cache_locked+0x425/0xe70 mm/filemap.c:839
  add_to_page_cache_lru+0x1cb/0x760 mm/filemap.c:916
  pagecache_get_page+0x357/0x850 mm/filemap.c:1655
  grab_cache_page_write_begin+0x75/0xb0 mm/filemap.c:3157
  simple_write_begin+0x36/0x2c0 fs/libfs.c:438
  generic_perform_write+0x22a/0x520 mm/filemap.c:3207
  __generic_file_write_iter+0x25e/0x630 mm/filemap.c:3336
  generic_file_write_iter+0x360/0x610 mm/filemap.c:3368
  call_write_iter include/linux/fs.h:1870 [inline]
  new_sync_write+0x4d3/0x770 fs/read_write.c:483
  __vfs_write+0xe1/0x110 fs/read_write.c:496
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
RSP: 002b:00007f9a334d9c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459279
RDX: 0000000003d3427e RSI: 0000000020000180 RDI: 0000000000000004
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f9a334da6d4
R13: 00000000004c8ee8 R14: 00000000004dfbb0 R15: 00000000ffffffff
Shutting down cpus with NMI
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
