Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B91D8215
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 23:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730247AbfJOVWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 17:22:14 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:44412 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729861AbfJOVWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 17:22:09 -0400
Received: by mail-io1-f69.google.com with SMTP id y2so34112881ioj.11
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 14:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=W9H2Jyij3I30jNtk0dJhDsK7Rn6xdgfvFDolckv/dcM=;
        b=b9MQ2nD3tHatTRaX4GLir09vWj/y9imL5CKTgNfBADfhWMs5caiynmFzW0//gCiGG4
         zAaN/uNL4zi3CgMAknGZoh8pI6I6dS6VwxQl/meLlhItVpFpSouVrI1+IAyqnP4oxM/a
         5vxfIoeDYoWHJbFiRBQ9mj3UJvZReebnQKnTZvO5vi9TDlzdbPVCV0MLqGWKdjwfrMGk
         X6gjQo+vOX+2hVNjvsSHO7Vpsa0J1GxRJI9zzF3ewfecv0PObgMHMHZqmjCqwK7cXlCH
         E2u7nYHradojsh+SC4jnsGeGiKd/MqR+yRVStr1J7Vx86ZP2eqRWdmTeVXuBG9KSkDJ1
         KZ/A==
X-Gm-Message-State: APjAAAWxogPPlK6Ydvi6ucm+YpGT/DgK0Zk6+pnGl8TLL/IolCzz7PQt
        MthiQYAWsyMe7XEHHHS5KT4aofIBC+2IUKo8ILZho7BKgsHK
X-Google-Smtp-Source: APXvYqx3DGy4mcOujal7G9G4z0bx7s+9nwpyUU3yANKuVDgMTl9EpbTc9HH41V+GdnJ2KcKvJdle6F+7l6ibGFNL104q4Hul3LOK
MIME-Version: 1.0
X-Received: by 2002:a02:c608:: with SMTP id i8mr27404680jan.40.1571174527867;
 Tue, 15 Oct 2019 14:22:07 -0700 (PDT)
Date:   Tue, 15 Oct 2019 14:22:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009d211f0594f99317@google.com>
Subject: KMSAN: uninit-value in sysfs_format_mac
From:   syzbot <syzbot+dac45508e04ca7aba764@syzkaller.appspotmail.com>
To:     allison@lohutok.net, bgolaszewski@baylibre.com,
        daniel@iogearbox.net, davem@davemloft.net, glider@google.com,
        hkallweit1@gmail.com, linux-kernel@vger.kernel.org,
        lirongqing@baidu.com, maximmi@mellanox.com, netdev@vger.kernel.org,
        olteanv@gmail.com, saeedm@mellanox.com, sdf@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c2453450 kmsan: kcov: prettify the code unpoisoning area->..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1342116f600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3684f3c73f43899a
dashboard link: https://syzkaller.appspot.com/bug?extid=dac45508e04ca7aba764
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11083f9f600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c7073b600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+dac45508e04ca7aba764@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in hex_string+0x7d8/0x8d0 lib/vsprintf.c:1098
CPU: 0 PID: 12732 Comm: udevd Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x14a/0x2f0 mm/kmsan/kmsan_report.c:109
  __msan_warning+0x73/0xf0 mm/kmsan/kmsan_instr.c:245
  hex_string+0x7d8/0x8d0 lib/vsprintf.c:1098
  pointer+0xbfe/0x1d10 lib/vsprintf.c:2136
  vsnprintf+0x1c0c/0x3210 lib/vsprintf.c:2514
  vscnprintf lib/vsprintf.c:2613 [inline]
  scnprintf+0x235/0x300 lib/vsprintf.c:2667
  sysfs_format_mac+0xde/0x100 net/ethernet/eth.c:444
  address_show+0x159/0x1d0 net/core/net-sysfs.c:150
  dev_attr_show+0xd8/0x1e0 drivers/base/core.c:967
  sysfs_kf_seq_show+0x434/0x7b0 fs/sysfs/file.c:60
  kernfs_seq_show+0x164/0x1e0 fs/kernfs/file.c:167
  seq_read+0xac6/0x1d90 fs/seq_file.c:229
  kernfs_fop_read+0x2c3/0x9a0 fs/kernfs/file.c:251
  __vfs_read+0x1a9/0xc90 fs/read_write.c:425
  vfs_read+0x359/0x6f0 fs/read_write.c:461
  ksys_read+0x265/0x430 fs/read_write.c:587
  __do_sys_read fs/read_write.c:597 [inline]
  __se_sys_read+0x92/0xb0 fs/read_write.c:595
  __x64_sys_read+0x4a/0x70 fs/read_write.c:595
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x7f90a0b58310
Code: 73 01 c3 48 8b 0d 28 4b 2b 00 31 d2 48 29 c2 64 89 11 48 83 c8 ff eb  
ea 90 90 83 3d e5 a2 2b 00 00 75 10 b8 00 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 73 31 c3 48 83 ec 08 e8 6e 8a 01 00 48 89 04 24
RSP: 002b:00007ffdd54d89d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f90a0b58310
RDX: 0000000000001000 RSI: 00007ffdd54d8e80 RDI: 0000000000000005
RBP: 00007ffdd54d9fb0 R08: 00007ffdd54d9fb0 R09: 00007f90a0bae7d0
R10: 342f346273752f33 R11: 0000000000000246 R12: 00000000024071f0
R13: 00000000024072e0 R14: 0000000000000001 R15: 0000000002410159

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:150 [inline]
  kmsan_internal_chain_origin+0xbd/0x170 mm/kmsan/kmsan.c:317
  kmsan_memcpy_memmove_metadata+0x25c/0x2e0 mm/kmsan/kmsan.c:253
  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:273
  __msan_memcpy+0x56/0x70 mm/kmsan/kmsan_instr.c:129
  set_ethernet_addr drivers/net/usb/rtl8150.c:282 [inline]
  rtl8150_probe+0x1143/0x14a0 drivers/net/usb/rtl8150.c:912
  usb_probe_interface+0xd19/0x1310 drivers/usb/core/driver.c:361
  really_probe+0xd91/0x1f90 drivers/base/dd.c:552
  driver_probe_device+0x1ba/0x510 drivers/base/dd.c:721
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:828
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:430
  __device_attach+0x489/0x750 drivers/base/dd.c:894
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:941
  bus_probe_device+0x131/0x390 drivers/base/bus.c:490
  device_add+0x25b5/0x2df0 drivers/base/core.c:2201
  usb_set_configuration+0x309f/0x3710 drivers/usb/core/message.c:2027
  generic_probe+0xe7/0x280 drivers/usb/core/generic.c:210
  usb_probe_device+0x146/0x200 drivers/usb/core/driver.c:266
  really_probe+0xd91/0x1f90 drivers/base/dd.c:552
  driver_probe_device+0x1ba/0x510 drivers/base/dd.c:721
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:828
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:430
  __device_attach+0x489/0x750 drivers/base/dd.c:894
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:941
  bus_probe_device+0x131/0x390 drivers/base/bus.c:490
  device_add+0x25b5/0x2df0 drivers/base/core.c:2201
  usb_new_device+0x23e5/0x2fb0 drivers/usb/core/hub.c:2536
  hub_port_connect drivers/usb/core/hub.c:5098 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
  port_event drivers/usb/core/hub.c:5359 [inline]
  hub_event+0x581d/0x72f0 drivers/usb/core/hub.c:5441
  process_one_work+0x1572/0x1ef0 kernel/workqueue.c:2269
  worker_thread+0x111b/0x2460 kernel/workqueue.c:2415
  kthread+0x4b5/0x4f0 kernel/kthread.c:256
  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Local variable description: ----node_id.i@rtl8150_probe
Variable was created at:
  get_registers drivers/net/usb/rtl8150.c:911 [inline]
  set_ethernet_addr drivers/net/usb/rtl8150.c:281 [inline]
  rtl8150_probe+0xdc8/0x14a0 drivers/net/usb/rtl8150.c:912
  get_registers drivers/net/usb/rtl8150.c:911 [inline]
  set_ethernet_addr drivers/net/usb/rtl8150.c:281 [inline]
  rtl8150_probe+0xdc8/0x14a0 drivers/net/usb/rtl8150.c:912
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
