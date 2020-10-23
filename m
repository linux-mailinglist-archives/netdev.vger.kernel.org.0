Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA14E296AF0
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 10:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460463AbgJWIKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 04:10:05 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:35260 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S460446AbgJWIHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 04:07:20 -0400
Received: by mail-io1-f69.google.com with SMTP id w16so519320ioa.2
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 01:07:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=tY4Chwt2lim2tU/fW6X+MittzJYJbxA26up1ghmDZFU=;
        b=EWEgpPQM0m0j21Tf7qc3tcPnK5yo6k88Z1Udjl2k3lU4ex7qViUisB5q59CsM7uGOU
         j+nXMMkbKlFIxwgBjjtWvTSyWdfKLkwIr6itXrG8f30Nogc2NUj8poiEP5hJSaih/4aS
         6Ifju1LZtNEjIPuluW7iRfUW0Jk8BCOayF1y0vqoaXNSLEl9EsTToMKpuJddptalunRv
         TcHchVSgm9RhXqY3Sj6agtcZp/SrzvJGXeZ5M1OOtNp1UioNPlQDYJUEpY1zXOe0tLC4
         KdP15NnGncqv13KEyw/e86tlZ9eUEGY0uTF5U8J5l4x3NwToSGq6xAaTck6BiButk9pg
         UfYA==
X-Gm-Message-State: AOAM530+bTXxMAVW6iKZg1LqG7RPL+86KKTgRqoZG1Bbsor6LfQDcb4V
        u+4Jk/iNKoSf5mr4h1n2PImitKpCrtgkzuOjN1VoLT4SinsJ
X-Google-Smtp-Source: ABdhPJwfJOsQ74vN0cP494oodhvYDJXImc680fvWiKW8A0FOKM9DBN5EQQLjHzs8KjYkPeR2r7LJDvBU6tYB/Y/pyoOjtk25Clry
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1651:: with SMTP id a17mr1033900jat.39.1603440437832;
 Fri, 23 Oct 2020 01:07:17 -0700 (PDT)
Date:   Fri, 23 Oct 2020 01:07:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b731f405b2521197@google.com>
Subject: KMSAN: uninit-value in ax88179_get_mac_addr
From:   syzbot <syzbot+4993e4a0e237f1b53747@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, besslein.andreas@gmail.com,
        bjorn.andersson@linaro.org, colin.king@canonical.com,
        davem@davemloft.net, glider@google.com, jk@ozlabs.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        pfink@christ-es.de, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ce8056d1 wip: changed copy_from_user where instrumented
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=11212a66900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3afe005fb99591f
dashboard link: https://syzkaller.appspot.com/bug?extid=4993e4a0e237f1b53747
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12ceb4b6900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1645f266900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4993e4a0e237f1b53747@syzkaller.appspotmail.com

ax88179_178a 1-1:101.123 (unnamed net_device) (uninitialized): Failed to write reg index 0x0002: -71
ax88179_178a 1-1:101.123 (unnamed net_device) (uninitialized): Failed to write reg index 0x0002: -71
ax88179_178a 1-1:101.123 (unnamed net_device) (uninitialized): Failed to write reg index 0x0001: -71
ax88179_178a 1-1:101.123 (unnamed net_device) (uninitialized): Failed to read reg index 0x0006: -71
=====================================================
BUG: KMSAN: uninit-value in is_valid_ether_addr include/linux/etherdevice.h:195 [inline]
BUG: KMSAN: uninit-value in ax88179_get_mac_addr+0x481/0x850 drivers/net/usb/ax88179_178a.c:1310
CPU: 0 PID: 3337 Comm: kworker/0:2 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 is_valid_ether_addr include/linux/etherdevice.h:195 [inline]
 ax88179_get_mac_addr+0x481/0x850 drivers/net/usb/ax88179_178a.c:1310
 ax88179_bind+0x3ec/0x19c0 drivers/net/usb/ax88179_178a.c:1348
 usbnet_probe+0x1152/0x3f90 drivers/net/usb/usbnet.c:1737
 usb_probe_interface+0xece/0x1550 drivers/usb/core/driver.c:374
 really_probe+0xf20/0x20b0 drivers/base/dd.c:529
 driver_probe_device+0x293/0x390 drivers/base/dd.c:701
 __device_attach_driver+0x63f/0x830 drivers/base/dd.c:807
 bus_for_each_drv+0x2ca/0x3f0 drivers/base/bus.c:431
 __device_attach+0x4e2/0x7f0 drivers/base/dd.c:873
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:920
 bus_probe_device+0x177/0x3d0 drivers/base/bus.c:491
 device_add+0x3b0e/0x40d0 drivers/base/core.c:2680
 usb_set_configuration+0x380f/0x3f10 drivers/usb/core/message.c:2032
 usb_generic_driver_probe+0x138/0x300 drivers/usb/core/generic.c:241
 usb_probe_device+0x311/0x490 drivers/usb/core/driver.c:272
 really_probe+0xf20/0x20b0 drivers/base/dd.c:529
 driver_probe_device+0x293/0x390 drivers/base/dd.c:701
 __device_attach_driver+0x63f/0x830 drivers/base/dd.c:807
 bus_for_each_drv+0x2ca/0x3f0 drivers/base/bus.c:431
 __device_attach+0x4e2/0x7f0 drivers/base/dd.c:873
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:920
 bus_probe_device+0x177/0x3d0 drivers/base/bus.c:491
 device_add+0x3b0e/0x40d0 drivers/base/core.c:2680
 usb_new_device+0x1bd4/0x2a30 drivers/usb/core/hub.c:2554
 hub_port_connect drivers/usb/core/hub.c:5208 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 port_event drivers/usb/core/hub.c:5494 [inline]
 hub_event+0x5e7b/0x8a70 drivers/usb/core/hub.c:5576
 process_one_work+0x1688/0x2140 kernel/workqueue.c:2269
 worker_thread+0x10bc/0x2730 kernel/workqueue.c:2415
 kthread+0x551/0x590 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Local variable ----mac@ax88179_get_mac_addr created at:
 ax88179_get_mac_addr+0x4d/0x850 drivers/net/usb/ax88179_178a.c:1297
 ax88179_get_mac_addr+0x4d/0x850 drivers/net/usb/ax88179_178a.c:1297
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
