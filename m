Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A57C7A80C
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 14:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730186AbfG3MSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 08:18:06 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:50858 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730151AbfG3MSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 08:18:06 -0400
Received: by mail-io1-f71.google.com with SMTP id m26so71253564ioh.17
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 05:18:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vOp35uav6zh6iUogGIdHDW0ZffcUAcQZbpm1cUh2gsk=;
        b=b0sBlr6Pc0RgJfy6qJj8qCkAMPrBja5FWDV2FLrbcJfEVDpzCkAryqeilmBNHYYSxr
         uj4TKWhEASGDqAIOZPdqDHjzzT1KnmT1AT3WhJdcqGkfYbgCw67TBvYV3oSi1UjTcXgV
         7KBaDjqHXanQaNU69fH7zISZKS8yZqd0GtdCm0jiPIlSY8D93z5jadqhfGQ0N4L2RZy9
         mAgHDblrb/9/KRM/C9NpD3Tp/khe6DN8CwhdNU7NnSn+xhDeamdMtKtqjV0u/OvdwAxM
         MyWrX9CXls89/raUsFwKltQiyHUbNV94I9XWs/PecyzdX+5F2xZYSaQ4Jx2m9jb2zQq4
         B+0w==
X-Gm-Message-State: APjAAAUrsk5qlXf1776KJJcpRTdxzpRuNCyuLNKnEeM3Xa1jhfUDE8iA
        g6yktOFdTql+upQNWSrVCG4E3BaPIu8NBhQbLOQHFePSSMQE
X-Google-Smtp-Source: APXvYqwAcFjNISUetpHLf3iUtsi5axYdZZuZ4PkEUlomcatXIk3ZfI8jdVD9HcxIZep6w20pZmstqMHjJ3uAbifdwvsr8aI2XQ5h
MIME-Version: 1.0
X-Received: by 2002:a5e:8618:: with SMTP id z24mr5855572ioj.174.1564489085363;
 Tue, 30 Jul 2019 05:18:05 -0700 (PDT)
Date:   Tue, 30 Jul 2019 05:18:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000302d82058ee5002d@google.com>
Subject: KMSAN: uninit-value in smsc95xx_wait_eeprom
From:   syzbot <syzbot+136c17d735f025fc86a7@syzkaller.appspotmail.com>
To:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        glider@google.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        steve.glendinning@shawell.net, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    beaab8a3 fix KASAN build
git tree:       kmsan
console output: https://syzkaller.appspot.com/x/log.txt?x=1685d8bfa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4db781fe35a84ef5
dashboard link: https://syzkaller.appspot.com/bug?extid=136c17d735f025fc86a7
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+136c17d735f025fc86a7@syzkaller.appspotmail.com

usb 1-1: New USB device found, idVendor=0424, idProduct=9908,  
bcdDevice=6a.5e
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-1: config 0 descriptor??
smsc95xx v1.0.6
==================================================================
BUG: KMSAN: uninit-value in smsc95xx_wait_eeprom+0x1fb/0x3d0  
drivers/net/usb/smsc95xx.c:300
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.2.0+ #15
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x162/0x2d0 mm/kmsan/kmsan_report.c:109
  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:294
  smsc95xx_wait_eeprom+0x1fb/0x3d0 drivers/net/usb/smsc95xx.c:300
  smsc95xx_read_eeprom+0x3c2/0x920 drivers/net/usb/smsc95xx.c:357
  smsc95xx_init_mac_address drivers/net/usb/smsc95xx.c:914 [inline]
  smsc95xx_bind+0x467/0x1690 drivers/net/usb/smsc95xx.c:1286
  usbnet_probe+0x10d3/0x3950 drivers/net/usb/usbnet.c:1722
  usb_probe_interface+0xd19/0x1310 drivers/usb/core/driver.c:361
  really_probe+0x1344/0x1d90 drivers/base/dd.c:513
  driver_probe_device+0x1ba/0x510 drivers/base/dd.c:670
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:777
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
  __device_attach+0x489/0x750 drivers/base/dd.c:843
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:890
  bus_probe_device+0x131/0x390 drivers/base/bus.c:514
  device_add+0x25b5/0x2df0 drivers/base/core.c:2111
  usb_set_configuration+0x309f/0x3710 drivers/usb/core/message.c:2027
  generic_probe+0xe7/0x280 drivers/usb/core/generic.c:210
  usb_probe_device+0x146/0x200 drivers/usb/core/driver.c:266
  really_probe+0x1344/0x1d90 drivers/base/dd.c:513
  driver_probe_device+0x1ba/0x510 drivers/base/dd.c:670
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:777
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
  __device_attach+0x489/0x750 drivers/base/dd.c:843
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:890
  bus_probe_device+0x131/0x390 drivers/base/bus.c:514
  device_add+0x25b5/0x2df0 drivers/base/core.c:2111
  usb_new_device+0x23e5/0x2fb0 drivers/usb/core/hub.c:2534
  hub_port_connect drivers/usb/core/hub.c:5089 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
  port_event drivers/usb/core/hub.c:5350 [inline]
  hub_event+0x5853/0x7320 drivers/usb/core/hub.c:5432
  process_one_work+0x1572/0x1f00 kernel/workqueue.c:2269
  worker_thread+0x111b/0x2460 kernel/workqueue.c:2415
  kthread+0x4b5/0x4f0 kernel/kthread.c:256
  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Local variable description: ----buf.i.i@smsc95xx_wait_eeprom
Variable was created at:
  __smsc95xx_read_reg drivers/net/usb/smsc95xx.c:80 [inline]
  smsc95xx_read_reg drivers/net/usb/smsc95xx.c:144 [inline]
  smsc95xx_wait_eeprom+0xb6/0x3d0 drivers/net/usb/smsc95xx.c:294
  smsc95xx_read_eeprom+0x3c2/0x920 drivers/net/usb/smsc95xx.c:357
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
