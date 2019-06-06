Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D92537038
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 11:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbfFFJmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 05:42:06 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:52939 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbfFFJmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 05:42:05 -0400
Received: by mail-it1-f200.google.com with SMTP id z128so1310093itb.2
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 02:42:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=C/QbVAlBAgg/UuzgwU/C8xKEj8HudJCp6V+oPIiI0Pw=;
        b=MfIiI7VfldEQt+aoP7f8V+SqjnSx538oQRYf6UaWSIzH740mW+VLnZfVpNl0rVxWfe
         w82h7Jpl6wJ4pt4/2ptU7J6qw4yQG6C4j8bo/P5EsXbtYjJ11Ent0CViSFgOypvoN+HM
         HuOh3LOBM9/4AICM2tXvQXPiWIJ29DS4SzG09/J5G8w/EQvKdAeZeEs81VS+TTplqdyY
         BnvcruKTJK3c4eFApqf72QPDR7EHGMQhs3wBJmlKc6nvYRC9ZkX9SoMDwyrE8s3lJqbO
         M26l2VZ+leX49Ry62TJxzsthbew+45A/9xgVWb5gqHuuKriqZi76ReDbGRtJUJdDWJGW
         eP9Q==
X-Gm-Message-State: APjAAAURGJ5xx2hGblZQZDFzGATGMhJJ6Bo9g+ltpX53v+A50PMeAnVn
        EDCsKo521ozuxz4UNgIk0t/FkUyjHvcs5FCgxwEsQA0HgKQn
X-Google-Smtp-Source: APXvYqwOJhbXNCC7cvoLr6vQcA/kxUlviAaQhZZvu32rd1jGFllr0Y6eLPIl4tji7avmxMkEpWSCCnddXjEUxekPkABZErr6e8LK
MIME-Version: 1.0
X-Received: by 2002:a05:660c:8f:: with SMTP id t15mr12219147itj.107.1559814124560;
 Thu, 06 Jun 2019 02:42:04 -0700 (PDT)
Date:   Thu, 06 Jun 2019 02:42:04 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cf6a70058aa48695@google.com>
Subject: KMSAN: uninit-value in rt2500usb_bbp_read
From:   syzbot <syzbot+a106a5b084a6890d2607@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com,
        helmut.schaa@googlemail.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, sgruszka@redhat.com,
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
console output: https://syzkaller.appspot.com/x/log.txt?x=12f8b01ea00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=602468164ccdc30a
dashboard link: https://syzkaller.appspot.com/bug?extid=a106a5b084a6890d2607
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
06d00afa61eef8f7f501ebdb4e8612ea43ec2d78)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f746f2a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=153072d2a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a106a5b084a6890d2607@syzkaller.appspotmail.com

usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-1: config 0 descriptor??
usb 1-1: reset high-speed USB device number 2 using dummy_hcd
usb 1-1: device descriptor read/64, error -71
ieee80211 phy3: rt2x00usb_vendor_request: Error - Vendor Request 0x09  
failed for offset 0x0000 with error -71
ieee80211 phy3: rt2x00usb_vendor_request: Error - Vendor Request 0x07  
failed for offset 0x04d0 with error -71
==================================================================
BUG: KMSAN: uninit-value in rt2500usb_regbusy_read  
drivers/net/wireless/ralink/rt2x00/rt2500usb.c:116 [inline]
BUG: KMSAN: uninit-value in rt2500usb_bbp_read+0x174/0x640  
drivers/net/wireless/ralink/rt2x00/rt2500usb.c:172
CPU: 1 PID: 4943 Comm: kworker/1:2 Not tainted 5.1.0+ #1
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:622
  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
  rt2500usb_regbusy_read drivers/net/wireless/ralink/rt2x00/rt2500usb.c:116  
[inline]
  rt2500usb_bbp_read+0x174/0x640  
drivers/net/wireless/ralink/rt2x00/rt2500usb.c:172
  rt2500usb_validate_eeprom  
drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1387 [inline]
  rt2500usb_probe_hw+0x3b1/0x2230  
drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1764
  rt2x00lib_probe_dev+0xb81/0x3090  
drivers/net/wireless/ralink/rt2x00/rt2x00dev.c:1427
  rt2x00usb_probe+0x7c7/0xf70  
drivers/net/wireless/ralink/rt2x00/rt2x00usb.c:837
  rt2500usb_probe+0x50/0x60  
drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1977
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

Local variable description: ----reg.i.i@rt2500usb_bbp_read
Variable was created at:
  rt2500usb_register_read_lock  
drivers/net/wireless/ralink/rt2x00/rt2500usb.c:72 [inline]
  rt2500usb_regbusy_read drivers/net/wireless/ralink/rt2x00/rt2500usb.c:115  
[inline]
  rt2500usb_bbp_read+0xa4/0x640  
drivers/net/wireless/ralink/rt2x00/rt2500usb.c:172
  rt2500usb_validate_eeprom  
drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1387 [inline]
  rt2500usb_probe_hw+0x3b1/0x2230  
drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1764
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
