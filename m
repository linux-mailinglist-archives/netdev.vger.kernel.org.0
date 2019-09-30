Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC490C29BC
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 00:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731079AbfI3Wje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 18:39:34 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:42680 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729245AbfI3WjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 18:39:15 -0400
Received: by mail-io1-f72.google.com with SMTP id w1so33485828ioj.9
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 15:39:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=S+VQhWYaAUm9S3kTD+g6Uv25dCXpksl3TXWhnx7EUec=;
        b=MK9vptryfkmxzoTBi+s8By3Z1EasmZOjqzHZiisvDhI2Rd3jpQKdmny60qYqeb9xQ+
         gu+RCutbPKsygqIgRBqR559U5qkEQWyagvFvk84TGl3PivTK8h6kCF5sAMhLf4n53g9Z
         /MxTnS6nawQF0Rd/ee8ed69dqA/BW+ObfYvtA+jRmbfevSyBvInxgpf1mKgpyF8Od7t+
         4VE/aWsI9DdcipEO3XXgpKTZwbvzjKdtuzVScmwzkvCryVtsybVLPJbWx8/OfTvc0nrV
         PRyTGKzp7aIqESdDwYYdVLYn5lbacEa9FFjdssoR+UpJfKWjQl05Gb53eD7skA85zVAH
         7+5A==
X-Gm-Message-State: APjAAAVfMYT6oNqIbanqBdHpBnfRhgUcYiBCL5dpqNPDqylpcPdwXT7x
        nqL/V2VfjcckcIllTSVtJgJQbjjjQg2GEKwFKUcGj9BcBIKH
X-Google-Smtp-Source: APXvYqxAGOFqID5P9o7rvH8Pzpjjiu8fp5lk/fQqSI7vrHaUe3UxQ9GKkfOrTWJQgAMXWBPCV+e/RjA9RFpV6uo1Iw2++fmbRajX
MIME-Version: 1.0
X-Received: by 2002:a5d:9457:: with SMTP id x23mr7302480ior.14.1569883154839;
 Mon, 30 Sep 2019 15:39:14 -0700 (PDT)
Date:   Mon, 30 Sep 2019 15:39:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c889570593cce77b@google.com>
Subject: KMSAN: uninit-value in rt2500usb_probe_hw
From:   syzbot <syzbot+35c80b2190255a410f66@syzkaller.appspotmail.com>
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

HEAD commit:    cebbfdbc kmsan: merge set_no_shadow_page() and set_no_orig..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1125cb59600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f03c659d0830ab8d
dashboard link: https://syzkaller.appspot.com/bug?extid=35c80b2190255a410f66
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=146abd21600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=106a19b5600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+35c80b2190255a410f66@syzkaller.appspotmail.com

usb 1-1: config 0 descriptor??
usb 1-1: reset high-speed USB device number 2 using dummy_hcd
usb 1-1: device descriptor read/64, error -71
usb 1-1: Using ep0 maxpacket: 16
ieee80211 phy3: rt2x00usb_vendor_request: Error - Vendor Request 0x09  
failed for offset 0x0000 with error -71
ieee80211 phy3: rt2x00_set_chip: Info - Chipset detected - rt: 2570, rf:  
0000, rev: 8771
==================================================================
BUG: KMSAN: uninit-value in rt2500usb_init_eeprom  
drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1443 [inline]
BUG: KMSAN: uninit-value in rt2500usb_probe_hw+0xb5e/0x22a0  
drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1757
CPU: 0 PID: 3369 Comm: kworker/0:2 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x162/0x2d0 mm/kmsan/kmsan_report.c:109
  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:294
  rt2500usb_init_eeprom drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1443  
[inline]
  rt2500usb_probe_hw+0xb5e/0x22a0  
drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1757
  rt2x00lib_probe_dev+0xba9/0x3260  
drivers/net/wireless/ralink/rt2x00/rt2x00dev.c:1427
  rt2x00usb_probe+0x7ae/0xf60  
drivers/net/wireless/ralink/rt2x00/rt2x00usb.c:842
  rt2500usb_probe+0x50/0x60  
drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1966
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

Local variable description: ----reg.i.i@rt2500usb_probe_hw
Variable was created at:
  rt2500usb_register_read drivers/net/wireless/ralink/rt2x00/rt2500usb.c:51  
[inline]
  rt2500usb_init_eeprom drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1440  
[inline]
  rt2500usb_probe_hw+0x774/0x22a0  
drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1757
  rt2x00lib_probe_dev+0xba9/0x3260  
drivers/net/wireless/ralink/rt2x00/rt2x00dev.c:1427
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
