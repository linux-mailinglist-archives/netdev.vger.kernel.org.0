Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFF898776
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 00:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731208AbfHUWiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 18:38:09 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:51653 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729787AbfHUWiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 18:38:09 -0400
Received: by mail-io1-f72.google.com with SMTP id a13so4157673ioh.18
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 15:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=BTtJUMszNrujEPFC3wQT6l7FYC6eZ4EtPS5uVqWHKZc=;
        b=FxN2ufe66m01/dyinhj94xe3h8DZ17cWb0tcUy0LiYsWFbxOTxl4XyYmoJ6D0UfmuZ
         3pgz3vVklj4Zse+DOjChX1TuQBfqQ9s9nOXjBEXcooplTG4SJo4/hHn9lrgOGzu42U7W
         s6I0SXHP9hrU00nc44Ik9YiaD4jc7pboSLQ83VVlcPdR2Zo7I4rupQLWaSV+JJJr+KyJ
         v56bphzCGHMcuFpxl3UQskB1vTr6CuX1eKuEW4qsKHFxWzdrPSwfuoq3Y2G+QQipOZEN
         jAllJX53mxXD91IP9j8jbtXtXzlpjCDqOQaFANSnpWFy6SKY6/KwEtihjLEf0Zaiy2q/
         MxAw==
X-Gm-Message-State: APjAAAXbHRQlasRF9wmakTjtpPpbXlMVgvaYJuk4zjhYuEWSPINQWtBA
        FXE9D7zILpaXuNovFvt1tIQrBRu24lDTgu7eHrjwqf9uJA4C
X-Google-Smtp-Source: APXvYqzOluyNlTC3a21ScZvzJi76nxi43xLQVkD9qQOF0Qspti0r4r1Pja6nog2TC39cP1WafA+H4oMWutoHWRL5P1FhBGMyCnCU
MIME-Version: 1.0
X-Received: by 2002:a02:1441:: with SMTP id 62mr13101565jag.21.1566427087791;
 Wed, 21 Aug 2019 15:38:07 -0700 (PDT)
Date:   Wed, 21 Aug 2019 15:38:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000226dc30590a83a39@google.com>
Subject: KMSAN: uninit-value in batadv_iv_send_outstanding_bat_ogm_packet
From:   syzbot <syzbot+355cab184197dbbfa384@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    61ccdad1 Revert "drm/bochs: Use shadow buffer for bochs fr..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=13d6909c600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=27abc558ecb16a3b
dashboard link: https://syzkaller.appspot.com/bug?extid=355cab184197dbbfa384
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1612b9d2600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d388ac600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+355cab184197dbbfa384@syzkaller.appspotmail.com

==================================================================
BUG: KMSAN: uninit-value in batadv_iv_ogm_send_to_if  
net/batman-adv/bat_iv_ogm.c:317 [inline]
BUG: KMSAN: uninit-value in batadv_iv_ogm_emit  
net/batman-adv/bat_iv_ogm.c:383 [inline]
BUG: KMSAN: uninit-value in  
batadv_iv_send_outstanding_bat_ogm_packet+0x6cd/0xcc0  
net/batman-adv/bat_iv_ogm.c:1657
CPU: 1 PID: 290 Comm: kworker/u4:7 Not tainted 5.3.0-rc3+ #17
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x162/0x2d0 mm/kmsan/kmsan_report.c:109
  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:294
  batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:317 [inline]
  batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:383 [inline]
  batadv_iv_send_outstanding_bat_ogm_packet+0x6cd/0xcc0  
net/batman-adv/bat_iv_ogm.c:1657
  process_one_work+0x1572/0x1ef0 kernel/workqueue.c:2269
  worker_thread+0x111b/0x2460 kernel/workqueue.c:2415
  kthread+0x4b5/0x4f0 kernel/kthread.c:256
  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Uninit was created at:
  kmsan_save_stack_with_flags+0x37/0x70 mm/kmsan/kmsan.c:187
  kmsan_internal_alloc_meta_for_pages+0x123/0x510 mm/kmsan/kmsan_hooks.c:114
  kmsan_alloc_page+0x7a/0xf0 mm/kmsan/kmsan_hooks.c:244
  __alloc_pages_nodemask+0x142d/0x5fa0 mm/page_alloc.c:4768
  __alloc_pages include/linux/gfp.h:475 [inline]
  __alloc_pages_node include/linux/gfp.h:488 [inline]
  alloc_pages_node include/linux/gfp.h:502 [inline]
  __page_frag_cache_refill mm/page_alloc.c:4843 [inline]
  page_frag_alloc+0x35b/0x890 mm/page_alloc.c:4873
  __napi_alloc_skb+0x195/0x980 net/core/skbuff.c:519
  napi_alloc_skb include/linux/skbuff.h:2808 [inline]
  page_to_skb+0x134/0x1150 drivers/net/virtio_net.c:384
  receive_mergeable drivers/net/virtio_net.c:924 [inline]
  receive_buf+0xe7b/0x8810 drivers/net/virtio_net.c:1033
  virtnet_receive drivers/net/virtio_net.c:1323 [inline]
  virtnet_poll+0x666/0x19d0 drivers/net/virtio_net.c:1428
  napi_poll net/core/dev.c:6347 [inline]
  net_rx_action+0x74b/0x1950 net/core/dev.c:6413
  __do_softirq+0x4a1/0x83a kernel/softirq.c:293
  invoke_softirq kernel/softirq.c:375 [inline]
  irq_exit+0x230/0x280 kernel/softirq.c:416
  exiting_irq arch/x86/include/asm/apic.h:537 [inline]
  do_IRQ+0x20d/0x3a0 arch/x86/kernel/irq.c:259
  ret_from_intr+0x0/0x33
  kmsan_get_shadow_origin_ptr+0x6/0x3a0 mm/kmsan/kmsan.c:656
  __msan_metadata_ptr_for_load_8+0x10/0x20 mm/kmsan/kmsan_instr.c:55
  compound_head include/linux/compiler.h:206 [inline]
  PageReferenced include/linux/page-flags.h:315 [inline]
  mark_page_accessed+0x30c/0xa00 mm/swap.c:391
  touch_buffer fs/buffer.c:60 [inline]
  __find_get_block+0x1681/0x19e0 fs/buffer.c:1303
  __getblk_gfp+0xc5/0x1080 fs/buffer.c:1321
  sb_getblk include/linux/buffer_head.h:325 [inline]
  __ext4_get_inode_loc+0x647/0x1c80 fs/ext4/inode.c:4611
  ext4_get_inode_loc fs/ext4/inode.c:4726 [inline]
  ext4_reserve_inode_write+0x15d/0x430 fs/ext4/inode.c:5919
  ext4_mark_inode_dirty+0x2dd/0xca0 fs/ext4/inode.c:6071
  ext4_dirty_inode+0x187/0x1d0 fs/ext4/inode.c:6110
  __mark_inode_dirty+0x486/0x1380 fs/fs-writeback.c:2170
  mark_inode_dirty include/linux/fs.h:2138 [inline]
  generic_write_end+0x3f7/0x460 fs/buffer.c:2164
  ext4_da_write_end+0x1050/0x1240 fs/ext4/inode.c:3217
  generic_perform_write+0x618/0x990 mm/filemap.c:3341
  __generic_file_write_iter+0x421/0xa30 mm/filemap.c:3459
  ext4_file_write_iter+0xc97/0x2010 fs/ext4/file.c:270
  call_write_iter include/linux/fs.h:1870 [inline]
  new_sync_write fs/read_write.c:483 [inline]
  __vfs_write+0xa2c/0xcb0 fs/read_write.c:496
  vfs_write+0x481/0x920 fs/read_write.c:558
  ksys_write+0x265/0x430 fs/read_write.c:611
  __do_sys_write fs/read_write.c:623 [inline]
  __se_sys_write+0x92/0xb0 fs/read_write.c:620
  __x64_sys_write+0x4a/0x70 fs/read_write.c:620
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:297
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
