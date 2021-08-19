Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFACF3F14DC
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 10:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbhHSIKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 04:10:55 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:55129 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236878AbhHSIKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 04:10:54 -0400
Received: by mail-il1-f199.google.com with SMTP id r6-20020a92c506000000b002246015b2a4so2803889ilg.21
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 01:10:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=VLMWKMsTun8f1GPH/VyUO/C5MN+JOvRdiw23QeqF200=;
        b=ftV82n3lhJSDhm6zdxBSo55OopfQxe0FVvVePaU4a3H00CSNeI5FuXyGF3wy1uyFu9
         LUHQHM5npOlNZ2eKh6D2C6zOk77MEc4SJA53KwbskGeXj811DmM7WFT74E+3HVaGn6Q6
         CPG2nxFThaEVZxp6AWyv48G3S7hzHzVtt0z2DinkNHj+0LwFYmtVkIjlwJ2C3GPUiWlI
         3ZjZfYJVQR/7bo1jFwEs4zAM8UTSKSYLlXRbhwmsvvzDGP7nDl8EQI1BLcPpf/p9n0B4
         8NzAyvwRz3y7OW8zbm6BJsMOytO5DOdi6FTvYKFk2x/HJppEf68/949Mwog5PUTCuK9G
         VW9g==
X-Gm-Message-State: AOAM530oB+GJZ/k8qx4N2N1APKk+FgPcVXs2PBrTteyl2QKuQCzrXiUM
        4Thvz9Mmk5p98Y3qJz6qit7NNZT5opryUTfreG8ihA64mbXp
X-Google-Smtp-Source: ABdhPJzWaicSivhm3PGO7iRjyzTxLxqsHbGoPoQp3LIjt8mKPWxAMqXJ0YHiMGvXsjGaeAPSiKeWefmLNuwNvgUwPRzor3b+rEI+
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1905:: with SMTP id w5mr9110685ilu.165.1629360618799;
 Thu, 19 Aug 2021 01:10:18 -0700 (PDT)
Date:   Thu, 19 Aug 2021 01:10:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e5080305c9e51453@google.com>
Subject: [syzbot] KASAN: slab-out-of-bounds Write in ext4_write_inline_data_end
From:   syzbot <syzbot+13146364637c7363a7de@syzkaller.appspotmail.com>
To:     a@unstable.cc, adilger.kernel@dilger.ca, arnd@arndb.de,
        b.a.t.m.a.n@lists.open-mesh.org, christian@brauner.io,
        davem@davemloft.net, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    614cb2751d31 Merge tag 'trace-v5.14-rc6' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=130112c5300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f61012d0b1cd846f
dashboard link: https://syzkaller.appspot.com/bug?extid=13146364637c7363a7de
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104d7cc5300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1333ce0e300000

The issue was bisected to:

commit a154d5d83d21af6b9ee32adc5dbcea5ac1fb534c
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Mon Mar 4 20:38:03 2019 +0000

    net: ignore sysctl_devconf_inherit_init_net without SYSCTL

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13f970b6300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=100570b6300000
console output: https://syzkaller.appspot.com/x/log.txt?x=17f970b6300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+13146364637c7363a7de@syzkaller.appspotmail.com
Fixes: a154d5d83d21 ("net: ignore sysctl_devconf_inherit_init_net without SYSCTL")

==================================================================
BUG: KASAN: slab-out-of-bounds in ext4_write_inline_data fs/ext4/inline.c:245 [inline]
BUG: KASAN: slab-out-of-bounds in ext4_write_inline_data_end+0x4d4/0x960 fs/ext4/inline.c:754
Write of size 70 at addr ffff8880195444ef by task syz-executor279/8426

CPU: 0 PID: 8426 Comm: syz-executor279 Not tainted 5.14.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1ae/0x29f lib/dump_stack.c:105
 print_address_description+0x66/0x3b0 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report+0x163/0x210 mm/kasan/report.c:436
 check_region_inline mm/kasan/generic.c:135 [inline]
 kasan_check_range+0x2b5/0x2f0 mm/kasan/generic.c:189
 memcpy+0x3c/0x60 mm/kasan/shadow.c:66
 ext4_write_inline_data fs/ext4/inline.c:245 [inline]
 ext4_write_inline_data_end+0x4d4/0x960 fs/ext4/inline.c:754
 ext4_write_end+0x1ff/0xbd0 fs/ext4/inode.c:1290
 generic_perform_write+0x361/0x580 mm/filemap.c:3667
 ext4_buffered_write_iter+0x41c/0x590 fs/ext4/file.c:269
 ext4_file_write_iter+0x8f7/0x1b90 fs/ext4/file.c:519
 call_write_iter include/linux/fs.h:2114 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0xa39/0xc90 fs/read_write.c:605
 ksys_write+0x171/0x2a0 fs/read_write.c:658
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x44ac89
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff12e8852f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00000000004ce4d0 RCX: 000000000044ac89
RDX: 0000000000000082 RSI: 0000000020000180 RDI: 0000000000000006
RBP: 000000000049de98 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0030656c69662f2e
R13: 024645fc87234f45 R14: 26e1d8b70aefbc5b R15: 00000000004ce4d8

Allocated by task 1:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 __kasan_slab_alloc+0x96/0xd0 mm/kasan/common.c:467
 kasan_slab_alloc include/linux/kasan.h:254 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 slab_alloc_node mm/slub.c:2959 [inline]
 slab_alloc mm/slub.c:2967 [inline]
 kmem_cache_alloc+0x1d1/0x340 mm/slub.c:2972
 kmem_cache_zalloc include/linux/slab.h:711 [inline]
 acpi_os_acquire_object include/acpi/platform/aclinuxex.h:67 [inline]
 acpi_ut_allocate_object_desc_dbg+0xd8/0x165 drivers/acpi/acpica/utobject.c:359
 acpi_ut_create_internal_object_dbg+0x21/0x195 drivers/acpi/acpica/utobject.c:69
 acpi_ds_build_internal_object+0x15f/0x732 drivers/acpi/acpica/dsobject.c:94
 acpi_ds_create_node+0xe9/0x1a8 drivers/acpi/acpica/dsobject.c:281
 acpi_ds_load2_end_op+0x7d0/0xebc drivers/acpi/acpica/dswload2.c:618
 acpi_ds_exec_end_op+0x6ce/0x11d4 drivers/acpi/acpica/dswexec.c:637
 acpi_ps_parse_loop+0xd9f/0x1cf0 drivers/acpi/acpica/psloop.c:525
 acpi_ps_parse_aml+0x1d5/0x955 drivers/acpi/acpica/psparse.c:475
 acpi_ps_execute_table+0x317/0x3ef drivers/acpi/acpica/psxface.c:295
 acpi_ns_execute_table+0x436/0x5bf drivers/acpi/acpica/nsparse.c:116
 acpi_ns_load_table+0x5e/0x120 drivers/acpi/acpica/nsload.c:71
 acpi_tb_load_namespace+0x456/0x6b9 drivers/acpi/acpica/tbxfload.c:186
 acpi_load_tables+0x45/0xf5 drivers/acpi/acpica/tbxfload.c:59
 acpi_bus_init+0x9a/0x993 drivers/acpi/bus.c:1213
 acpi_init+0x8c/0x22c drivers/acpi/bus.c:1324
 do_one_initcall+0x197/0x3f0 init/main.c:1287
 do_initcall_level+0x14a/0x1f5 init/main.c:1360
 do_initcalls+0x4b/0x8c init/main.c:1376
 kernel_init_freeable+0x3f1/0x57e init/main.c:1598
 kernel_init+0x19/0x2a0 init/main.c:1490
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff8880195444e0
 which belongs to the cache Acpi-Operand of size 72
The buggy address is located 15 bytes inside of
 72-byte region [ffff8880195444e0, ffff888019544528)
The buggy address belongs to the page:
page:ffffea0000655100 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888019544068 pfn:0x19544
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea0000654f88 ffffea0000654e08 ffff8880110c2b40
raw: ffff888019544068 000000000027001d 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 1, ts 3012488798, free_ts 0
 prep_new_page mm/page_alloc.c:2436 [inline]
 get_page_from_freelist+0x779/0xa30 mm/page_alloc.c:4169
 __alloc_pages+0x26c/0x5f0 mm/page_alloc.c:5391
 alloc_page_interleave+0x22/0x1c0 mm/mempolicy.c:2119
 alloc_slab_page mm/slub.c:1691 [inline]
 allocate_slab+0xf1/0x540 mm/slub.c:1831
 new_slab mm/slub.c:1894 [inline]
 new_slab_objects mm/slub.c:2640 [inline]
 ___slab_alloc+0x1cf/0x350 mm/slub.c:2803
 __slab_alloc mm/slub.c:2843 [inline]
 slab_alloc_node mm/slub.c:2925 [inline]
 slab_alloc mm/slub.c:2967 [inline]
 kmem_cache_alloc+0x299/0x340 mm/slub.c:2972
 kmem_cache_zalloc include/linux/slab.h:711 [inline]
 acpi_os_acquire_object include/acpi/platform/aclinuxex.h:67 [inline]
 acpi_ut_allocate_object_desc_dbg+0xd8/0x165 drivers/acpi/acpica/utobject.c:359
 acpi_ut_create_internal_object_dbg+0x21/0x195 drivers/acpi/acpica/utobject.c:69
 acpi_ds_build_internal_object+0x15f/0x732 drivers/acpi/acpica/dsobject.c:94
 acpi_ds_create_node+0xe9/0x1a8 drivers/acpi/acpica/dsobject.c:281
 acpi_ds_load2_end_op+0x7d0/0xebc drivers/acpi/acpica/dswload2.c:618
 acpi_ds_exec_end_op+0x6ce/0x11d4 drivers/acpi/acpica/dswexec.c:637
 acpi_ps_parse_loop+0xd9f/0x1cf0 drivers/acpi/acpica/psloop.c:525
 acpi_ps_parse_aml+0x1d5/0x955 drivers/acpi/acpica/psparse.c:475
 acpi_ps_execute_table+0x317/0x3ef drivers/acpi/acpica/psxface.c:295
 acpi_ns_execute_table+0x436/0x5bf drivers/acpi/acpica/nsparse.c:116
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888019544400: fc fc 00 00 00 00 00 00 00 00 00 fc fc fc fc 00
 ffff888019544480: 00 00 00 00 00 00 00 00 fc fc fc fc 00 00 00 00
>ffff888019544500: 00 00 00 00 00 fc fc fc fc fb fb fb fb fb fb fb
                                  ^
 ffff888019544580: fb fb fc fc fc fc 00 00 00 00 00 00 00 00 00 fc
 ffff888019544600: fc fc fc 00 00 00 00 00 00 00 00 00 fc fc fc fc
==================================================================
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	ff c3                	inc    %ebx
   2:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
   9:	00 00 00 
   c:	0f 1f 40 00          	nopl   0x0(%rax)
  10:	48 89 f8             	mov    %rdi,%rax
  13:	48 89 f7             	mov    %rsi,%rdi
  16:	48 89 d6             	mov    %rdx,%rsi
  19:	48 89 ca             	mov    %rcx,%rdx
  1c:	4d 89 c2             	mov    %r8,%r10
  1f:	4d 89 c8             	mov    %r9,%r8
  22:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
  27:	0f 05                	syscall 
  29:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax <-- trapping instruction
  2f:	73 01                	jae    0x32
  31:	c3                   	retq   
  32:	48 c7 c1 b8 ff ff ff 	mov    $0xffffffffffffffb8,%rcx
  39:	f7 d8                	neg    %eax
  3b:	64 89 01             	mov    %eax,%fs:(%rcx)
  3e:	48                   	rex.W


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
