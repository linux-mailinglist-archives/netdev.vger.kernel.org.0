Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DDB34987
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfFDN4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:56:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:34275 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbfFDN4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:56:07 -0400
Received: by mail-io1-f69.google.com with SMTP id m1so16582032iop.1
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=LCdbntvhYYZKRFof+Yh6ukzQ5F55ULY7kbPPhoeYtys=;
        b=qTqLflu57jtJCwS9veqpx4hixGl6A7GrYCERWUWFapbsxn/wx5+6xez09U4+nMQipN
         gV6dBvAPbDd4hTpbSNRImFLG/g33Vy+4vpd82D9ewrgNQ+OflTdC34VHRIUptnyId5Gq
         +7Cvf/hRlfXDZkc3n5tGUNQKraphvtAH8YOUVw/4RqKu99YR9V2kcWnRIwSlxT1hg/Gx
         nvK4VtaAr+GVKZwqwdmXjk6uDdcazSiDF9qnKz7JQC4cXLfsrNBr4/5jaB+gWZ5RNXMo
         IyJRdZzmbi7iuXuecbx5rkgza6BPQFMqkdzLcy/8upy3y1vPsghNbm0duismMJSYuRJk
         4Beg==
X-Gm-Message-State: APjAAAXsqF+dA8vraEGMdn7aokJuJVBWraJ4NByjWS+TyDfB941hG1Rh
        7bnIcrFdpLVn6vzrwAFSTpTvg/0iqajsAYGO9oGtg4l/nYaa
X-Google-Smtp-Source: APXvYqx8CytJgHtRoktHUU2J1oDCyXLYUV8bPq8r3+mr2+5Ym9d9ysvUSJwqeGwsF4dYnASG9SHlZMgmViBDfPpQiF6QK3loO23s
MIME-Version: 1.0
X-Received: by 2002:a05:6638:38f:: with SMTP id y15mr21667600jap.143.1559656565809;
 Tue, 04 Jun 2019 06:56:05 -0700 (PDT)
Date:   Tue, 04 Jun 2019 06:56:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000093abc2058a7fd715@google.com>
Subject: KASAN: use-after-free Read in css_task_iter_advance
From:   syzbot <syzbot+678796542f88f534c79e@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=1310e25aa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4248d6bc70076f7d
dashboard link: https://syzkaller.appspot.com/bug?extid=678796542f88f534c79e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+678796542f88f534c79e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in css_task_iter_advance+0x49b/0x540  
kernel/cgroup/cgroup.c:4507
Read of size 4 at addr ffff888096f20fe4 by task syz-executor.4/24150

CPU: 1 PID: 24150 Comm: syz-executor.4 Not tainted 5.2.0-rc3-next-20190604  
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
  __cgroup_procs_start.isra.0+0x32f/0x400 kernel/cgroup/cgroup.c:4634
  cgroup_threads_start+0x23/0x30 kernel/cgroup/cgroup.c:4741
  cgroup_seqfile_start+0xa4/0xd0 kernel/cgroup/cgroup.c:3752
  kernfs_seq_start+0xdc/0x190 fs/kernfs/file.c:118
  traverse fs/seq_file.c:108 [inline]
  traverse+0x165/0x740 fs/seq_file.c:91
  seq_read+0x8dd/0x1110 fs/seq_file.c:188
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
RIP: 0033:0x459279
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f55b7e66c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000000459279
RDX: 0000000000000001 RSI: 0000000020000b40 RDI: 0000000000000004
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000246 R12: 00007f55b7e676d4
R13: 00000000004c614c R14: 00000000004da9a8 R15: 00000000ffffffff

Allocated by task 8993:
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
  getname+0x1a/0x20 fs/namei.c:209
  do_sys_open+0x2c9/0x5d0 fs/open.c:1064
  __do_sys_open fs/open.c:1088 [inline]
  __se_sys_open fs/open.c:1083 [inline]
  __x64_sys_open+0x7e/0xc0 fs/open.c:1083
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8993:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3426 [inline]
  kmem_cache_free+0x86/0x320 mm/slab.c:3692
  putname+0xef/0x130 fs/namei.c:259
  do_sys_open+0x318/0x5d0 fs/open.c:1079
  __do_sys_open fs/open.c:1088 [inline]
  __se_sys_open fs/open.c:1083 [inline]
  __x64_sys_open+0x7e/0xc0 fs/open.c:1083
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888096f20d40
  which belongs to the cache names_cache of size 4096
The buggy address is located 676 bytes inside of
  4096-byte region [ffff888096f20d40, ffff888096f21d40)
The buggy address belongs to the page:
page:ffffea00025bc800 refcount:1 mapcount:0 mapping:ffff8880aa593ac0  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002a01388 ffffea0002315988 ffff8880aa593ac0
raw: 0000000000000000 ffff888096f20d40 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888096f20e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888096f20f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff888096f20f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                        ^
  ffff888096f21000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888096f21080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
