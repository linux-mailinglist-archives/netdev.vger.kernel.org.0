Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85AB539556
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 21:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfFGTNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 15:13:07 -0400
Received: from mail-it1-f197.google.com ([209.85.166.197]:38870 "EHLO
        mail-it1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729456AbfFGTNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 15:13:06 -0400
Received: by mail-it1-f197.google.com with SMTP id j83so2630688ita.3
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 12:13:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cyqCrDVt2dXVqI86R5kiLgCbIofZNHXYbbR1FIOGENY=;
        b=Phx4bRZU4j1zJJMmrDa3Oinizc3NNI8D9wgOCulv+1BkSruAftXMiT8+3Z1dLyZuM2
         09RuQ/yKK2amTcWpBkLe5rdc7Un3JZLZJz1gE4WHr8pCGiPM6PvLPVbHTjIErg9KTutE
         PA0Z8gC5dK6O4/rqOz1CXvxUFx7aEcY71j5J7Sg2qolxjQ1DFC7dmG7j/BXJCv4tGeOt
         sVftKEps82VYpZJQNrGH7xTAx4G/KlWVZsk5sbnjePjlSiD2JuBGZKyiU9aiHjsB177G
         Ew4OUv2EC6Akdpnl3a5fEEVP6PS9H9qBaouwf7ux0MGzPAtoz8Gj88NziSupz/dX9Uzu
         bLyQ==
X-Gm-Message-State: APjAAAWcEs+AsNFL2cAtEfVI751VfyVCWIKVJCdi0uBsjob/LTIbfcEY
        zg1cpk131Q+a+EKVji3sLApaszs+jKJMJeQbKDKl6kwGeDLC
X-Google-Smtp-Source: APXvYqx/BdEP9lMOAedJ3yRv8lpTdqGerTLV44sx8ug8pFLGAgLn7Qp6CZoPRXvcthgfYfh0AMdPOBh/Q8emJuHLVG9uCw6Qhx3o
MIME-Version: 1.0
X-Received: by 2002:a5d:860e:: with SMTP id f14mr1413298iol.242.1559934786049;
 Fri, 07 Jun 2019 12:13:06 -0700 (PDT)
Date:   Fri, 07 Jun 2019 12:13:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cba2b6058ac09eeb@google.com>
Subject: KMSAN: uninit-value in ax88178_bind
From:   syzbot <syzbot+abd25d675d47f23f188c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        lynxis@fe80.eu, marcel.ziswiler@toradex.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yang.wei9@zte.com.cn, zhang.run@zte.com.cn
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f75e4cfe kmsan: use kmsan_handle_urb() in urb.c
git tree:       kmsan
console output: https://syzkaller.appspot.com/x/log.txt?x=10b2622ea00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=602468164ccdc30a
dashboard link: https://syzkaller.appspot.com/bug?extid=abd25d675d47f23f188c
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
06d00afa61eef8f7f501ebdb4e8612ea43ec2d78)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+abd25d675d47f23f188c@syzkaller.appspotmail.com

usb 2-1: Using ep0 maxpacket: 8
usb 2-1: config 0 has an invalid interface number: 81 but max is 0
usb 2-1: config 0 has no interface number 0
usb 2-1: New USB device found, idVendor=04bb, idProduct=0930, bcdDevice=  
f.22
usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 2-1: config 0 descriptor??
==================================================================
BUG: KMSAN: uninit-value in is_valid_ether_addr  
include/linux/etherdevice.h:200 [inline]
BUG: KMSAN: uninit-value in asix_set_netdev_dev_addr  
drivers/net/usb/asix_devices.c:73 [inline]
BUG: KMSAN: uninit-value in ax88178_bind+0x635/0xad0  
drivers/net/usb/asix_devices.c:1087
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.1.0+ #1
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:622
  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
  is_valid_ether_addr include/linux/etherdevice.h:200 [inline]
  asix_set_netdev_dev_addr drivers/net/usb/asix_devices.c:73 [inline]
  ax88178_bind+0x635/0xad0 drivers/net/usb/asix_devices.c:1087
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

Local variable description: ----buf@ax88178_bind
Variable was created at:
  ax88178_bind+0x60/0xad0 drivers/net/usb/asix_devices.c:1076
  usbnet_probe+0x10f5/0x3940 drivers/net/usb/usbnet.c:1728
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
