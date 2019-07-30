Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C127A4A1
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 11:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731732AbfG3JiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 05:38:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:53527 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731718AbfG3JiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 05:38:07 -0400
Received: by mail-io1-f69.google.com with SMTP id h3so70820454iob.20
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 02:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2OxJdfFz7EXPUFxZSAkGeqLhpVqopEfytgC58RNP5Gc=;
        b=AIyShEfCh6DrFWr0AUKcvM8qaOuJCAZF6Eg14hTcOxmhcyz3pRewNN6PlZy5ByY9Ep
         b3JJeGPsdRWrOiv6mxc0D3KKh/b7SdE0yOI9O5OmhR92tfu7kEkVJwpgSg8mF6ISh9cP
         3Yxxi1ukht4ds/JzgHbPDZmRdyQKEXdvhy0RqLp899I+6ODhtp0NkInsSGX8Lon+Citi
         eTLmmn5e3pjh2b6mD5yxdxzeRU5sAUvyxFmOhSibIMxJd5rFYQCX5d8VYdxcjRM6p4Z1
         PpfSzKQkkriyk/8WrOWpLe+iW0seW58/F2bhosKVHCZDZd8xuvOFcVkeUyM9/xXuaSU7
         eI7A==
X-Gm-Message-State: APjAAAWfk3hAY1klJ6wEvuK3k7gWLvPjkxDODcycIl7u0eXw+XnxvvT2
        UJ1py+T/DYLSGqmHRyP2PG2q01yiWn5WA88VA9hCpLA2Zsz5
X-Google-Smtp-Source: APXvYqw5hgWauHtzaXEFR1NpdBVBL9tsFEOEgmMAiftBVH8cSyfGBBbn6hV47aB3GYF1zBU2F9cUNyLG8jyNxk2ysFfHtl80CPG6
MIME-Version: 1.0
X-Received: by 2002:a6b:f203:: with SMTP id q3mr57765986ioh.208.1564479486675;
 Tue, 30 Jul 2019 02:38:06 -0700 (PDT)
Date:   Tue, 30 Jul 2019 02:38:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000fd432058ee2c46c@google.com>
Subject: KMSAN: uninit-value in read_eprom_word
From:   syzbot <syzbot+3499a83b2d062ae409d4@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, petkan@nucleusys.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3351e2b9 usb-fuzzer: main usb gadget fuzzer driver
git tree:       kmsan
console output: https://syzkaller.appspot.com/x/log.txt?x=13105d85a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=40511ad0c5945201
dashboard link: https://syzkaller.appspot.com/bug?extid=3499a83b2d062ae409d4
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1257755ea00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1327e5a5a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3499a83b2d062ae409d4@syzkaller.appspotmail.com

usb 1-1: Using ep0 maxpacket: 8
usb 1-1: config 0 has an invalid interface number: 150 but max is 0
usb 1-1: config 0 has no interface number 0
usb 1-1: New USB device found, idVendor=050d, idProduct=0122,  
bcdDevice=c1.69
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-1: config 0 descriptor??
==================================================================
BUG: KMSAN: uninit-value in read_eprom_word+0x947/0xdd0  
drivers/net/usb/pegasus.c:298
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.2.0-rc4+ #5
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x162/0x2d0 mm/kmsan/kmsan.c:611
  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:304
  read_eprom_word+0x947/0xdd0 drivers/net/usb/pegasus.c:298
  get_interrupt_interval drivers/net/usb/pegasus.c:758 [inline]
  pegasus_probe+0xf2b/0x4be0 drivers/net/usb/pegasus.c:1192
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

Local variable description: ----data.addr.i13@read_eprom_word
Variable was created at:
  set_register drivers/net/usb/pegasus.c:174 [inline]
  read_eprom_word+0x498/0xdd0 drivers/net/usb/pegasus.c:294
  get_interrupt_interval drivers/net/usb/pegasus.c:758 [inline]
  pegasus_probe+0xf2b/0x4be0 drivers/net/usb/pegasus.c:1192
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
