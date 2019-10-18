Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F285BDC702
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634051AbfJROMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:12:14 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:40178 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439192AbfJROMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 10:12:10 -0400
Received: by mail-io1-f69.google.com with SMTP id r20so8654408ioh.7
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 07:12:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HlcGe5jN7UTtW7EzEkZIqtzO8rSWJ3S7oFgrifLHZeQ=;
        b=b4QgwnoHtQ/xgEDMN6cLbhDPZ8MqyhQscV/YklAcjjRiB9uIUnVfDhxjclhSb+ZR1/
         /coXk2wmXIBKjn/zTLBkuzIHN1Tq818ty64PW8eF0BhyDDfUE6beaT67C/QZzjItt+l8
         NGMoLkd6xqtzRWQcTSRp6BTxIoMLmRMzfVGCI1iQ6ixvskkFxfs7Ei5bKcZyNcs8NDSp
         3lnzPEW5sTLyfTpOB/CTvOeLYMt0U3gORN1OaSXgJpBEg25VHYXqxRlriFWoo/EufELr
         gEPZ7509fGpotjUDeGA4N8nN1iPO34bglBAaDgLCdVFeLtdjaYGuO+iD6tlQ5Hc429Fu
         CWvQ==
X-Gm-Message-State: APjAAAXKHzq7yXi2lgDu2+ONB71xKvjdKmzGJCRTo+XM0kS8IkcA71XN
        SxXCmsY4TfyGYajHYpy42Ozn3pzA0Grc9xavL6ZvEIM4lsCu
X-Google-Smtp-Source: APXvYqxvl2Lf6XKaDD09V7d6S8o3rUzYZfEVOGj49scmvgTSC1qxYluaaBlj+UCPfz21cGsQ5Cjzs4ZHYGWHrMzxbpUPB6AIUrb1
MIME-Version: 1.0
X-Received: by 2002:a6b:7115:: with SMTP id q21mr6729959iog.303.1571407928563;
 Fri, 18 Oct 2019 07:12:08 -0700 (PDT)
Date:   Fri, 18 Oct 2019 07:12:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006120c905952febbd@google.com>
Subject: KMSAN: uninit-value in batadv_hard_if_event
From:   syzbot <syzbot+0183453ce4de8bdf9214@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c2453450 kmsan: kcov: prettify the code unpoisoning area->..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=10b0c06b600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3684f3c73f43899a
dashboard link: https://syzkaller.appspot.com/bug?extid=0183453ce4de8bdf9214
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0183453ce4de8bdf9214@syzkaller.appspotmail.com

usb 1-1: config 0 has no interface number 0
usb 1-1: New USB device found, idVendor=0411, idProduct=0012,  
bcdDevice=56.5f
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-1: config 0 descriptor??
=====================================================
BUG: KMSAN: uninit-value in batadv_check_known_mac_addr  
net/batman-adv/hard-interface.c:511 [inline]
BUG: KMSAN: uninit-value in batadv_hardif_add_interface  
net/batman-adv/hard-interface.c:942 [inline]
BUG: KMSAN: uninit-value in batadv_hard_if_event+0x23c0/0x3260  
net/batman-adv/hard-interface.c:1032
CPU: 0 PID: 13223 Comm: kworker/0:3 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x14a/0x2f0 mm/kmsan/kmsan_report.c:109
  __msan_warning+0x73/0xf0 mm/kmsan/kmsan_instr.c:245
  batadv_check_known_mac_addr net/batman-adv/hard-interface.c:511 [inline]
  batadv_hardif_add_interface net/batman-adv/hard-interface.c:942 [inline]
  batadv_hard_if_event+0x23c0/0x3260 net/batman-adv/hard-interface.c:1032
  notifier_call_chain kernel/notifier.c:95 [inline]
  __raw_notifier_call_chain kernel/notifier.c:396 [inline]
  raw_notifier_call_chain+0x13d/0x240 kernel/notifier.c:403
  call_netdevice_notifiers_info net/core/dev.c:1749 [inline]
  call_netdevice_notifiers_extack net/core/dev.c:1761 [inline]
  call_netdevice_notifiers net/core/dev.c:1775 [inline]
  register_netdevice+0x2126/0x26a0 net/core/dev.c:8810
  register_netdev+0x93/0xd0 net/core/dev.c:8901
  rtl8150_probe+0x11ef/0x14a0 drivers/net/usb/rtl8150.c:916
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
