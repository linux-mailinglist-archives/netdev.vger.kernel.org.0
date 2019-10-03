Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8C1C96FB
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 05:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbfJCDjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 23:39:08 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:35685 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbfJCDjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 23:39:07 -0400
Received: by mail-io1-f71.google.com with SMTP id r5so3077029iop.2
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 20:39:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=fNcmM8dDxJueHNsixPYAMzRv/o66qgp37A7jQpDFaDU=;
        b=BTczbriZ6p6CDHOWHcmUbKhPTj2w4JneRU4nkGAM7H4wWJnZq1DzGbJ1VrCX4LZj2z
         xOenGKGYFSXIQMhJQyC6DXB79/cMoarOVhabEE7RPTa/0F6CUYXKTWv8CCLd5FHZEy/N
         ObXHZroPJ4Ok7PLDXzn99uhT2Up80Qb8bmRsaM2PxWvfc6ftUJOYtnYtFKornPcTS24+
         jtpxQfqLt4BL6s9of4KKHbd8oNjsz5tkSwy8djCf/s3FNStRMp7CAiHqukrxb4RHstpC
         fZIXonYDyRXOx6hwjI3I0hGRzwuJZnmqIQtcVsELY+xGDi11e+Wky9iRwQ6ChBKTqCTx
         +nXw==
X-Gm-Message-State: APjAAAUxHzLjUMxmEY7c4t3ZTZiTqTZVlk6DZzS9Zhl4zVziuDeuxSvb
        c86Mj6PRWk8n/HOchue9dZ7MQUh0h42KyuxEVMYDdWsK785G
X-Google-Smtp-Source: APXvYqwFzhhBhYUtdnc9rPslh+XB3usOsuQcTSKUHt81F5Fwbea+PqEz88pROA3THyedDW94PkexFESBJJCjCpPBDRjU5iD/ggaV
MIME-Version: 1.0
X-Received: by 2002:a92:cb10:: with SMTP id s16mr8001468ilo.79.1570073947045;
 Wed, 02 Oct 2019 20:39:07 -0700 (PDT)
Date:   Wed, 02 Oct 2019 20:39:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e288f40593f953a9@google.com>
Subject: KMSAN: uninit-value in sr9800_bind
From:   syzbot <syzbot+f1842130bbcfb335bac1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, oneukum@suse.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    124037e0 kmsan: drop inlines, rename do_kmsan_task_create()
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=10f7e0cd600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f03c659d0830ab8d
dashboard link: https://syzkaller.appspot.com/bug?extid=f1842130bbcfb335bac1
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142acef3600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11811bbd600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f1842130bbcfb335bac1@syzkaller.appspotmail.com

CoreChips 2-1:0.159 (unnamed net_device) (uninitialized): Error reading  
RX_CTL register:ffffffb9
CoreChips 2-1:0.159 (unnamed net_device) (uninitialized): Failed to enable  
software MII access
CoreChips 2-1:0.159 (unnamed net_device) (uninitialized): Failed to enable  
hardware MII access
=====================================================
BUG: KMSAN: uninit-value in usbnet_probe+0x10ae/0x3960  
drivers/net/usb/usbnet.c:1722
CPU: 1 PID: 11159 Comm: kworker/1:4 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x13a/0x2b0 mm/kmsan/kmsan_report.c:108
  __msan_warning+0x73/0xe0 mm/kmsan/kmsan_instr.c:250
  sr_get_phyid drivers/net/usb/sr9800.c:380 [inline]
  sr9800_bind+0xd39/0x1b10 drivers/net/usb/sr9800.c:800
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
  process_scheduled_works kernel/workqueue.c:2331 [inline]
  worker_thread+0x189c/0x2460 kernel/workqueue.c:2417
  kthread+0x4b5/0x4f0 kernel/kthread.c:256
  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Local variable description: ----res@sr_mdio_read
Variable was created at:
  sr_mdio_read+0x78/0x360 drivers/net/usb/sr9800.c:341
  sr_get_phyid drivers/net/usb/sr9800.c:379 [inline]
  sr9800_bind+0xce9/0x1b10 drivers/net/usb/sr9800.c:800
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
