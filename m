Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82186CE6B7
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 17:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbfJGPJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 11:09:15 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:47108 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729297AbfJGPJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 11:09:12 -0400
Received: by mail-io1-f72.google.com with SMTP id k14so27178435iot.14
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 08:09:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gmo3MNz9xfKzNnITqaWUMkwRN0WlLGJGgGYObtDrNng=;
        b=aKNxeQJs9Ozc2t6ZvAcj9Hw+Iesq95jR/T8jTI2FcS0sWyxw7BNKQczwoCbA4eyw6r
         WeQ5EYkgs8FzKX8bfB2SrKaPFSLTTMKkdLh7l6idTifUNumn4qsR1xYwQhw4Neyx49PH
         Nr5KELYQ8Rz9c8tAzFwiyZFJ8rrEk6pBUSbBiPbSr4ithDU6fPBT5e2fn4+9neFkeg+B
         gdKuLfFnZZQpuXhgYN59LfJNkco8i27QvsV/PoyvkepeUeL1UaGUPP9B62q20/hyFcOC
         aE0JV1lk53thj3/JqfZGKAVbVX4/+aGI/GrTv6HlUeYjq867yXBzje1mGfgQYbyBuY3v
         PXyw==
X-Gm-Message-State: APjAAAU+w63YS7aIgxlqYHGHOZJd4gE00n8eytlmlpFdzkUJwh5yvyWG
        mtnzqtjqBjj5NKhm07nSFZPN4MLjRAWBA/xEvBWiqehJ/dqD
X-Google-Smtp-Source: APXvYqyoxl0OUNr6+mTzCmNDiY9rlgQM5WIhwnJ3imJhR2nES9yjP9P3VZU+njR7WPuRJWlf6++jH9ZrXDmb/JHSnjHggf4rQZGu
MIME-Version: 1.0
X-Received: by 2002:a5d:87d7:: with SMTP id q23mr23388461ios.126.1570460948564;
 Mon, 07 Oct 2019 08:09:08 -0700 (PDT)
Date:   Mon, 07 Oct 2019 08:09:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f91a330594536e3c@google.com>
Subject: KMSAN: uninit-value in ax88772_hw_reset
From:   syzbot <syzbot+bf5335246831e5f75f99@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        swinslow@gmail.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, tranmanphong@gmail.com, yang.wei9@zte.com.cn,
        zhang.run@zte.com.cn
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    1e76a3e5 kmsan: replace __GFP_NO_KMSAN_SHADOW with kmsan_i..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=149bdd47600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f03c659d0830ab8d
dashboard link: https://syzkaller.appspot.com/bug?extid=bf5335246831e5f75f99
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+bf5335246831e5f75f99@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ax88772_bind+0x6ad/0x11f0  
drivers/net/usb/asix_devices.c:730
CPU: 1 PID: 31 Comm: kworker/1:1 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x13a/0x2b0 mm/kmsan/kmsan_report.c:108
  __msan_warning+0x73/0xe0 mm/kmsan/kmsan_instr.c:250
  ax88772_hw_reset+0x507/0xb40 drivers/net/usb/asix_devices.c:368
  ax88772_bind+0x6ad/0x11f0 drivers/net/usb/asix_devices.c:730
  usbnet_probe+0x10ae/0x3960 drivers/net/usb/usbnet.c:1722
  usb_probe_interface+0xd19/0x1310 drivers/usb/core/driver.c:361
  really_probe+0x1373/0x1dc0 drivers/base/dd.c:552
  driver_probe_device+0x1ba/0x510 drivers/base/dd.c:709
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:816
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
  __device_attach+0x489/0x750 drivers/base/dd.c:882
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:929
  bus_probe_device+0x131/0x390 drivers/base/bus.c:514
  device_add+0x25b5/0x2df0 drivers/base/core.c:2165
  usb_set_configuration+0x309f/0x3710 drivers/usb/core/message.c:2027
  generic_probe+0xe7/0x280 drivers/usb/core/generic.c:210
  usb_probe_device+0x146/0x200 drivers/usb/core/driver.c:266
  really_probe+0x1373/0x1dc0 drivers/base/dd.c:552
  driver_probe_device+0x1ba/0x510 drivers/base/dd.c:709
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:816
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
  __device_attach+0x489/0x750 drivers/base/dd.c:882
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:929
  bus_probe_device+0x131/0x390 drivers/base/bus.c:514
  device_add+0x25b5/0x2df0 drivers/base/core.c:2165
  usb_new_device+0x23e5/0x2fb0 drivers/usb/core/hub.c:2536
  hub_port_connect drivers/usb/core/hub.c:5098 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
  port_event drivers/usb/core/hub.c:5359 [inline]
  hub_event+0x581d/0x72f0 drivers/usb/core/hub.c:5441
  process_one_work+0x1572/0x1ef0 kernel/workqueue.c:2269
  worker_thread+0x111b/0x2460 kernel/workqueue.c:2415
  kthread+0x4b5/0x4f0 kernel/kthread.c:256
  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:150 [inline]
  kmsan_internal_chain_origin+0xd2/0x170 mm/kmsan/kmsan.c:314
  __msan_chain_origin+0x6b/0xe0 mm/kmsan/kmsan_instr.c:184
  ax88772_bind+0xa12/0x11f0 drivers/net/usb/asix_devices.c:720
  usbnet_probe+0x10ae/0x3960 drivers/net/usb/usbnet.c:1722
  usb_probe_interface+0xd19/0x1310 drivers/usb/core/driver.c:361
  really_probe+0x1373/0x1dc0 drivers/base/dd.c:552
  driver_probe_device+0x1ba/0x510 drivers/base/dd.c:709
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:816
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
  __device_attach+0x489/0x750 drivers/base/dd.c:882
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:929
  bus_probe_device+0x131/0x390 drivers/base/bus.c:514
  device_add+0x25b5/0x2df0 drivers/base/core.c:2165
  usb_set_configuration+0x309f/0x3710 drivers/usb/core/message.c:2027
  generic_probe+0xe7/0x280 drivers/usb/core/generic.c:210
  usb_probe_device+0x146/0x200 drivers/usb/core/driver.c:266
  really_probe+0x1373/0x1dc0 drivers/base/dd.c:552
  driver_probe_device+0x1ba/0x510 drivers/base/dd.c:709
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:816
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
  __device_attach+0x489/0x750 drivers/base/dd.c:882
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:929
  bus_probe_device+0x131/0x390 drivers/base/bus.c:514
  device_add+0x25b5/0x2df0 drivers/base/core.c:2165
  usb_new_device+0x23e5/0x2fb0 drivers/usb/core/hub.c:2536
  hub_port_connect drivers/usb/core/hub.c:5098 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
  port_event drivers/usb/core/hub.c:5359 [inline]
  hub_event+0x581d/0x72f0 drivers/usb/core/hub.c:5441
  process_one_work+0x1572/0x1ef0 kernel/workqueue.c:2269
  worker_thread+0x111b/0x2460 kernel/workqueue.c:2415
  kthread+0x4b5/0x4f0 kernel/kthread.c:256
  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Local variable description: ----buf.i@asix_get_phy_addr
Variable was created at:
  asix_read_cmd drivers/net/usb/asix_common.c:313 [inline]
  asix_read_phy_addr drivers/net/usb/asix_common.c:296 [inline]
  asix_get_phy_addr+0x4d/0x280 drivers/net/usb/asix_common.c:315
  ax88772_bind+0x472/0x11f0 drivers/net/usb/asix_devices.c:720
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
