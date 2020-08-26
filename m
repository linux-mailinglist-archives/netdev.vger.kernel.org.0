Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90199253A4F
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgHZWi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:38:26 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:37683 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbgHZWiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:38:23 -0400
Received: by mail-io1-f71.google.com with SMTP id 80so1630301iou.4
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 15:38:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=z29wO0Ex0+rV9PlYlCXGwrCYo33qvhLT9sFtsrRFHus=;
        b=b/aTGuZgIlroy0BvDDiewOV8fPEV6800B1HMPT1CYMoMDrgY32IGVrxVXHwT6tQLCn
         ciblv0MovUt7UR4qKUsRzmrsMIQ/M8r2DGW+LKbhYCMGNfu1W/J06eE78x94wkNlqPjp
         I2bHcCH7O6kVU12KJM80GJbkaKUTBit8xy0qzy11dzjzksGKQrAMhsdIB5YDMHXkFkqM
         +j681iLiuMEgRrT8Oi2ffjWO6jPxb27dGj18cm9ifL8WmWqHZg7Dg8ikfgcsLJ5j9frh
         fJh2dQKKKXAnJQ//hr/rR2yaYQVtXma+ftFG7VbyH8JYcQ3BzydTJHk/Zhfpvksn6zVE
         3cJg==
X-Gm-Message-State: AOAM533EQaHR1zZOnZQIqMqoOjqyDhzF8npLAtLP5Dms7Y8PGuyyUVK1
        drmFjzAcosYF8MVhe2R7T9FY6H3HgI4tAGLIeQDwVrtNE4pE
X-Google-Smtp-Source: ABdhPJzlGKIw3FvjpEPxKs4VaW+IwCDliEWSZwSkhLdJ6Em0ZA43rRsriwtexKsjHMvNneilab6nMjd1nZ4V1TfG/2VQnBNxwa5n
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2439:: with SMTP id g25mr14420642iob.5.1598481502069;
 Wed, 26 Aug 2020 15:38:22 -0700 (PDT)
Date:   Wed, 26 Aug 2020 15:38:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001c687805adcf7a37@google.com>
Subject: kernel BUG at fs/ext4/page-io.c:LINE!
From:   syzbot <syzbot+9e6957d9489b099e95bf@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4af7b32f Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=1425b649900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3d400a47d1416652
dashboard link: https://syzkaller.appspot.com/bug?extid=9e6957d9489b099e95bf
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9e6957d9489b099e95bf@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/ext4/page-io.c:126!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 25034 Comm: syz-executor.2 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ext4_finish_bio+0x6a0/0x820 fs/ext4/page-io.c:126
Code: 10 4c 8b 60 28 48 89 44 24 50 e9 2b fb ff ff e8 c6 65 68 ff 48 c7 c6 60 b8 5d 88 4c 89 e7 e8 a7 c8 96 ff 0f 0b e8 b0 65 68 ff <0f> 0b e8 a9 65 68 ff 48 c7 c6 60 b7 5d 88 4c 89 e7 e8 8a c8 96 ff
RSP: 0018:ffffc90000da8b28 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000001000 RCX: ffffffff820bd8f6
RDX: ffff88809a8e4380 RSI: ffffffff820bdbd0 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8880857a8ddf
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8880857a8dd8
R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
FS:  00007fb6570cf700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcfa3e6800 CR3: 00000000a3c6b000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 ext4_end_bio+0x179/0x5e0 fs/ext4/page-io.c:368
 bio_endio+0x3cf/0x7f0 block/bio.c:1447
 req_bio_endio block/blk-core.c:259 [inline]
 blk_update_request+0x68c/0x1230 block/blk-core.c:1576
 scsi_end_request+0x7e/0x8f0 drivers/scsi/scsi_lib.c:566
 scsi_io_completion+0x1df/0x1310 drivers/scsi/scsi_lib.c:938
 scsi_softirq_done+0x327/0x3c0 drivers/scsi/scsi_lib.c:1464
 blk_done_softirq+0x2db/0x430 block/blk-mq.c:586
 __do_softirq+0x2de/0xa24 kernel/softirq.c:298
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x1f3/0x230 kernel/softirq.c:435
 common_interrupt+0xa3/0x1f0 arch/x86/kernel/irq.c:239
 asm_common_interrupt+0x1e/0x40 arch/x86/include/asm/idtentry.h:572
RIP: 0010:partial_name_hash include/linux/stringhash.h:45 [inline]
RIP: 0010:kernfs_name_hash+0x93/0x120 fs/kernfs/dir.c:304
Code: 48 c1 e8 03 83 e2 07 42 0f b6 04 20 38 d0 7f 08 84 c0 0f 85 8f 00 00 00 49 0f be 77 ff 31 ff 48 89 f0 48 c1 ee 04 48 c1 e0 04 <48> 01 c6 4c 01 f6 48 8d 04 b6 4c 8d 34 46 89 ee e8 98 97 8b ff 49
RSP: 0018:ffffc9000659f950 EFLAGS: 00000202
RAX: 0000000000000620 RBX: ffffffff89007753 RCX: ffffc9000ce73000
RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000000
RBP: 000000000000000a R08: 000000000000000a R09: ffff88808acdfbcf
R10: 0000000000000000 R11: 0000000000000001 R12: dffffc0000000000
R13: 000000008900773f R14: 000000666c06666f R15: ffffffff89007749
 kernfs_add_one+0x1e6/0x4c0 fs/kernfs/dir.c:785
 __kernfs_create_file+0x299/0x350 fs/kernfs/file.c:1031
 sysfs_add_file_mode_ns+0x226/0x540 fs/sysfs/file.c:305
 create_files fs/sysfs/group.c:64 [inline]
 internal_create_group+0x328/0xb20 fs/sysfs/group.c:149
 internal_create_groups.part.0+0x90/0x140 fs/sysfs/group.c:189
 internal_create_groups fs/sysfs/group.c:185 [inline]
 sysfs_create_groups+0x25/0x50 fs/sysfs/group.c:215
 device_add_groups drivers/base/core.c:2024 [inline]
 device_add_attrs drivers/base/core.c:2183 [inline]
 device_add+0x12fc/0x1c40 drivers/base/core.c:2881
 netdev_register_kobject+0x17d/0x3b0 net/core/net-sysfs.c:1898
 register_netdevice+0xd29/0x1540 net/core/dev.c:9829
 __tun_chr_ioctl.isra.0+0x2c09/0x41b0 drivers/net/tun.c:2804
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d4d9
Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fb6570cec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000019e00 RCX: 000000000045d4d9
RDX: 00000000200000c0 RSI: 00000000400454ca RDI: 0000000000000006
RBP: 000000000118cf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007ffdc2238a7f R14: 00007fb6570cf9c0 R15: 000000000118cf4c
Modules linked in:
---[ end trace 59bc8db21b5f0a1a ]---
RIP: 0010:ext4_finish_bio+0x6a0/0x820 fs/ext4/page-io.c:126
Code: 10 4c 8b 60 28 48 89 44 24 50 e9 2b fb ff ff e8 c6 65 68 ff 48 c7 c6 60 b8 5d 88 4c 89 e7 e8 a7 c8 96 ff 0f 0b e8 b0 65 68 ff <0f> 0b e8 a9 65 68 ff 48 c7 c6 60 b7 5d 88 4c 89 e7 e8 8a c8 96 ff
RSP: 0018:ffffc90000da8b28 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000001000 RCX: ffffffff820bd8f6
RDX: ffff88809a8e4380 RSI: ffffffff820bdbd0 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8880857a8ddf
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8880857a8dd8
R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
FS:  00007fb6570cf700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcfa3e6800 CR3: 00000000a3c6b000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
