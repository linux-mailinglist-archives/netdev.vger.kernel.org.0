Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3E53446A
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 12:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfFDKcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 06:32:06 -0400
Received: from mail-it1-f198.google.com ([209.85.166.198]:53825 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbfFDKcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 06:32:05 -0400
Received: by mail-it1-f198.google.com with SMTP id p19so13064777itm.3
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 03:32:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=1m6TKgfavLqedI80h4GeN37aD/ishsl+xGNUcBpfgL0=;
        b=NMDMInXtMAjeQw488wWjsJCeJeiNXjdetg8jXZSm4dF7hNVETvsYG1uOSUl4M5qFz5
         k6eOmYLUhAskwgVCEVGJ8r37y7XhEq03lgzvyazjeNVH9AXVIUD4WeSeaOWNwo9735dD
         iNBK483GZ/9KH+evVIoFptSFGsP9IKJN/w2wWhbNkwlD/6CgGveVt1QPdqwFD5tcx7BB
         DKygVGO9kBkrZQr2iXo0CUM+bVUCkNOtDORiHIlGXBtVqic6RKvaSPjJGhyRL6xikhO2
         87Tac1v+lmakmTsOm+P3ZizXu18Lil5R4sczPjkWZyBD8Q3U9aTPVT7a66ODQ9GnuSE4
         mXMQ==
X-Gm-Message-State: APjAAAW0o5plKwPg02K7TX58sNx9k+Iq/8ipUgsrmkAx6B71Qogjx0pR
        5uTlSdfCnqinK9rO3Xfnc6OYmjGD9HuAp8qIPtVws5cH1lvA
X-Google-Smtp-Source: APXvYqz2/2fnshkYs6p86u1DujGRHTgNt/I+YtkkqZxQ6GXhexSSXm33EBXprTu9rgy7GjmXUxriRXm1tThlAuwpzgzyKIk/U8EK
MIME-Version: 1.0
X-Received: by 2002:a24:3cb:: with SMTP id e194mr19206965ite.132.1559644324957;
 Tue, 04 Jun 2019 03:32:04 -0700 (PDT)
Date:   Tue, 04 Jun 2019 03:32:04 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f71859058a7cfdc8@google.com>
Subject: KMSAN: uninit-value in mii_nway_restart
From:   syzbot <syzbot+1f53a30781af65d2c955@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f75e4cfe kmsan: use kmsan_handle_urb() in urb.c
git tree:       kmsan
console output: https://syzkaller.appspot.com/x/log.txt?x=1180360ea00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=602468164ccdc30a
dashboard link: https://syzkaller.appspot.com/bug?extid=1f53a30781af65d2c955
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
06d00afa61eef8f7f501ebdb4e8612ea43ec2d78)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a2b4f2a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=107f4e86a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1f53a30781af65d2c955@syzkaller.appspotmail.com

ax88179_178a 1-1:0.186 (unnamed net_device) (uninitialized): Failed to  
write reg index 0x000d: -71
ax88179_178a 1-1:0.186 (unnamed net_device) (uninitialized): Failed to  
write reg index 0x000e: -71
ax88179_178a 1-1:0.186 (unnamed net_device) (uninitialized): Failed to  
write reg index 0x000d: -71
ax88179_178a 1-1:0.186 (unnamed net_device) (uninitialized): Failed to  
write reg index 0x000e: -71
ax88179_178a 1-1:0.186 (unnamed net_device) (uninitialized): Failed to read  
reg index 0x0000: -71
==================================================================
BUG: KMSAN: uninit-value in mii_nway_restart+0x141/0x260  
drivers/net/mii.c:467
CPU: 1 PID: 3353 Comm: kworker/1:2 Not tainted 5.1.0+ #1
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:622
  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
  mii_nway_restart+0x141/0x260 drivers/net/mii.c:467
  ax88179_bind+0xee3/0x1a10 drivers/net/usb/ax88179_178a.c:1329
  usbnet_probe+0x10f5/0x3940 drivers/net/usb/usbnet.c:1728
  usb_probe_interface+0xd66/0x1320 drivers/usb/core/driver.c:361
  really_probe+0xdae/0x1d80 drivers/base/dd.c:513
  driver_probe_device+0x1b3/0x4f0 drivers/base/dd.c:671
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:778
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
  __device_attach+0x454/0x730 drivers/base/dd.c:844
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:891
  bus_probe_device+0x137/0x390 drivers/base/bus.c:514
  device_add+0x288d/0x30e0 drivers/base/core.c:2106
  usb_set_configuration+0x30dc/0x3750 drivers/usb/core/message.c:2027
  generic_probe+0xe7/0x280 drivers/usb/core/generic.c:210
  usb_probe_device+0x14c/0x200 drivers/usb/core/driver.c:266
  really_probe+0xdae/0x1d80 drivers/base/dd.c:513
  driver_probe_device+0x1b3/0x4f0 drivers/base/dd.c:671
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:778
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
  __device_attach+0x454/0x730 drivers/base/dd.c:844
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:891
  bus_probe_device+0x137/0x390 drivers/base/bus.c:514
  device_add+0x288d/0x30e0 drivers/base/core.c:2106
  usb_new_device+0x23e5/0x2ff0 drivers/usb/core/hub.c:2534
  hub_port_connect drivers/usb/core/hub.c:5089 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
  port_event drivers/usb/core/hub.c:5350 [inline]
  hub_event+0x48d1/0x7290 drivers/usb/core/hub.c:5432
  process_one_work+0x1572/0x1f00 kernel/workqueue.c:2269
  worker_thread+0x111b/0x2460 kernel/workqueue.c:2415
  kthread+0x4b5/0x4f0 kernel/kthread.c:254
  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Local variable description: ----buf.i@ax88179_mdio_read
Variable was created at:
  __ax88179_read_cmd drivers/net/usb/ax88179_178a.c:199 [inline]
  ax88179_read_cmd drivers/net/usb/ax88179_178a.c:311 [inline]
  ax88179_mdio_read+0x7b/0x240 drivers/net/usb/ax88179_178a.c:369
  mii_nway_restart+0xcf/0x260 drivers/net/mii.c:465
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
