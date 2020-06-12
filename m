Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793F61F7CD3
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 20:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgFLSYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 14:24:17 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:54009 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgFLSYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 14:24:15 -0400
Received: by mail-il1-f197.google.com with SMTP id c29so6999413ilf.20
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 11:24:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=IdyGwOTrPxdodvIu8w1ax19AtuMuHO1Ym/F9HSipt30=;
        b=emWL6CroZfitmqip+svu6JVgQqVlXSbrHhVGt5tUWC61MFJtSyePafLFE7wPXnqbsJ
         TURlUnvDAW+jsv6M7cSRpfWnpZvHKzPSrJCpneHBrgV+Gr8yBiKTW/s2nSicaAIxsCgL
         GFrAXz+dWVse2fUDekJVaiRULJqzf67pMjpVIjWb1JizliiifbSt0qvm7vS3CoaxhH1K
         I7epebyLGl05mxWBlBMy1h/uqWL0qrSCEdvGQDVTLZsB0bqG4g9dyN64ydQYPpuzqA8L
         MXCk3qNwUEbj9Q6xZGyodSSDIpltOda3XBZ+lFyG42KUOYadkocPUFSFPG3W6IiiiB0W
         mMZg==
X-Gm-Message-State: AOAM533ZJku6xLSrEQsDzN8u8g7tKYdFgYfJvs1boTE3DVrBfRDFqFlz
        FYOjJcDAZMVHbrpHugWCgTb3zQki7KxtnZmoQMIaFYoP9ekf
X-Google-Smtp-Source: ABdhPJwAAS9my4o1VRLp6PK98sOKFFJZWZfIVQi9U62+owNQEL39aMd+aOKnIeke1xLbVEIVeqlDgOfB6r8bqw46HhD1B9zwgvtU
MIME-Version: 1.0
X-Received: by 2002:a92:c50f:: with SMTP id r15mr14352497ilg.76.1591986252918;
 Fri, 12 Jun 2020 11:24:12 -0700 (PDT)
Date:   Fri, 12 Jun 2020 11:24:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000017bacf05a7e72f45@google.com>
Subject: net-next test error: BUG: using smp_processor_id() in preemptible
 code in ext4_mb_new_blocks
From:   syzbot <syzbot+2ad52db2be557736dd15@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, davem@davemloft.net, kuba@kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    af7b4801 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15fe909e100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b366fd92adf6f8b4
dashboard link: https://syzkaller.appspot.com/bug?extid=2ad52db2be557736dd15
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2ad52db2be557736dd15@syzkaller.appspotmail.com

 process_one_work+0x965/0x16a0 kernel/workqueue.c:2269
 worker_thread+0x96/0xe10 kernel/workqueue.c:2415
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
BUG: using smp_processor_id() in preemptible [00000000] code: kworker/u4:1/21
caller is ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
CPU: 0 PID: 21 Comm: kworker/u4:1 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: writeback wb_workfn (flush-8:0)
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 check_preemption_disabled lib/smp_processor_id.c:47 [inline]
 debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
 ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
 ext4_ext_map_blocks+0x2044/0x3410 fs/ext4/extents.c:4244
 ext4_map_blocks+0x4cb/0x1640 fs/ext4/inode.c:626
 mpage_map_one_extent fs/ext4/inode.c:2377 [inline]
 mpage_map_and_submit_extent fs/ext4/inode.c:2430 [inline]
 ext4_writepages+0x1ab7/0x3400 fs/ext4/inode.c:2782
 do_writepages+0xfa/0x2a0 mm/page-writeback.c:2354
 __writeback_single_inode+0x12a/0x1410 fs/fs-writeback.c:1452
 writeback_sb_inodes+0x515/0xdd0 fs/fs-writeback.c:1716
 __writeback_inodes_wb+0xc3/0x250 fs/fs-writeback.c:1785
 wb_writeback+0x910/0xd90 fs/fs-writeback.c:1894
 wb_check_old_data_flush fs/fs-writeback.c:1996 [inline]
 wb_do_writeback fs/fs-writeback.c:2049 [inline]
 wb_workfn+0xadf/0x10d0 fs/fs-writeback.c:2078
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2269
 worker_thread+0x96/0xe10 kernel/workqueue.c:2415
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
BUG: using smp_processor_id() in preemptible [00000000] code: kworker/u4:1/21
caller is ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
CPU: 0 PID: 21 Comm: kworker/u4:1 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: writeback wb_workfn (flush-8:0)
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 check_preemption_disabled lib/smp_processor_id.c:47 [inline]
 debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
 ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
 ext4_ext_map_blocks+0x2044/0x3410 fs/ext4/extents.c:4244
 ext4_map_blocks+0x4cb/0x1640 fs/ext4/inode.c:626
 mpage_map_one_extent fs/ext4/inode.c:2377 [inline]
 mpage_map_and_submit_extent fs/ext4/inode.c:2430 [inline]
 ext4_writepages+0x1ab7/0x3400 fs/ext4/inode.c:2782
 do_writepages+0xfa/0x2a0 mm/page-writeback.c:2354
 __writeback_single_inode+0x12a/0x1410 fs/fs-writeback.c:1452
 writeback_sb_inodes+0x515/0xdd0 fs/fs-writeback.c:1716
 __writeback_inodes_wb+0xc3/0x250 fs/fs-writeback.c:1785
 wb_writeback+0x910/0xd90 fs/fs-writeback.c:1894
 wb_check_old_data_flush fs/fs-writeback.c:1996 [inline]
 wb_do_writeback fs/fs-writeback.c:2049 [inline]
 wb_workfn+0xadf/0x10d0 fs/fs-writeback.c:2078
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2269
 worker_thread+0x96/0xe10 kernel/workqueue.c:2415
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
BUG: using smp_processor_id() in preemptible [00000000] code: kworker/u4:1/21
caller is ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
CPU: 0 PID: 21 Comm: kworker/u4:1 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: writeback wb_workfn (flush-8:0)
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 check_preemption_disabled lib/smp_processor_id.c:47 [inline]
 debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
 ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
 ext4_ext_map_blocks+0x2044/0x3410 fs/ext4/extents.c:4244
 ext4_map_blocks+0x4cb/0x1640 fs/ext4/inode.c:626
 mpage_map_one_extent fs/ext4/inode.c:2377 [inline]
 mpage_map_and_submit_extent fs/ext4/inode.c:2430 [inline]
 ext4_writepages+0x1ab7/0x3400 fs/ext4/inode.c:2782
 do_writepages+0xfa/0x2a0 mm/page-writeback.c:2354
 __writeback_single_inode+0x12a/0x1410 fs/fs-writeback.c:1452
 writeback_sb_inodes+0x515/0xdd0 fs/fs-writeback.c:1716
 __writeback_inodes_wb+0xc3/0x250 fs/fs-writeback.c:1785
 wb_writeback+0x910/0xd90 fs/fs-writeback.c:1894
 wb_check_old_data_flush fs/fs-writeback.c:1996 [inline]
 wb_do_writeback fs/fs-writeback.c:2049 [inline]
 wb_workfn+0xadf/0x10d0 fs/fs-writeback.c:2078
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2269
 worker_thread+0x96/0xe10 kernel/workqueue.c:2415
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
