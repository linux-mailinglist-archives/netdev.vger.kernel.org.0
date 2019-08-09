Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89C548748D
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 10:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406005AbfHIIsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 04:48:07 -0400
Received: from mail-ot1-f71.google.com ([209.85.210.71]:55239 "EHLO
        mail-ot1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405976AbfHIIsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 04:48:07 -0400
Received: by mail-ot1-f71.google.com with SMTP id h26so67478356otr.21
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 01:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RE8A2YvlWxvXHPUb5cpPDBeHEbJXVJXdXz/K9INznBw=;
        b=I3jKUUoTkJsfaB3zX3ICIhtiY/YResobc4WDNFPioxzjtFeNtC+yHsTrPMuq7vi+Q9
         IZjGkJR+GtADG324lJ7RBuw4pEl8pRJOlwe/srTTNSjrO6IjxECOoxQ5/PkkqAENboNe
         /b9qTwE7Rt7P9ZOfFi6/1cUFyS9svLGyzvfO7nxAuIm/CQab9xBAi4KV4yJ5FjWGCGH4
         uIxFKUfNE3/abhxlKRlqc6aKzkomhlgTAI7HqeiLw548JLUj6jWv4ptHFdUVsKTtwHPU
         hGwVanCoQL+hATVCci82kzAXslpbASDKpg3ujIB+bBLIRzAVh7/zHMC9JXd9URBVSvfx
         zDqQ==
X-Gm-Message-State: APjAAAW5a3HiatMr6uJsCsnFHwmXb4sUZuxke2DJ+O4eO39CnDYL25jz
        ZExEUYZYwfBAB1kkO0PyDuSMhvcuT19L+PwDkqdSagKFQff1
X-Google-Smtp-Source: APXvYqzval70mnAgWNiLZL2ZWVjPp0Ex13XwcQQM2QIhkxYlbuR4801kNczIBTyu3+jH55i4+T11rjJyd7JbxzZi1tOCTlO3hEuj
MIME-Version: 1.0
X-Received: by 2002:a05:6602:259a:: with SMTP id p26mr219550ioo.154.1565340486024;
 Fri, 09 Aug 2019 01:48:06 -0700 (PDT)
Date:   Fri, 09 Aug 2019 01:48:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009f4316058fab3bd7@google.com>
Subject: KMSAN: uninit-value in smsc75xx_bind
From:   syzbot <syzbot+6966546b78d050bb0b5d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, steve.glendinning@shawell.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    beaab8a3 fix KASAN build
git tree:       kmsan
console output: https://syzkaller.appspot.com/x/log.txt?x=13d7b65c600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4db781fe35a84ef5
dashboard link: https://syzkaller.appspot.com/bug?extid=6966546b78d050bb0b5d
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ab9ef0600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11be2b34600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6966546b78d050bb0b5d@syzkaller.appspotmail.com

==================================================================
BUG: KMSAN: uninit-value in smsc75xx_wait_ready  
drivers/net/usb/smsc75xx.c:976 [inline]
BUG: KMSAN: uninit-value in smsc75xx_bind+0x541/0x12d0  
drivers/net/usb/smsc75xx.c:1483
CPU: 0 PID: 2892 Comm: kworker/0:2 Not tainted 5.2.0+ #15
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x162/0x2d0 mm/kmsan/kmsan_report.c:109
  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:294
  smsc75xx_wait_ready drivers/net/usb/smsc75xx.c:976 [inline]
  smsc75xx_bind+0x541/0x12d0 drivers/net/usb/smsc75xx.c:1483
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
  process_scheduled_works kernel/workqueue.c:2331 [inline]
  worker_thread+0x189c/0x2460 kernel/workqueue.c:2417
  kthread+0x4b5/0x4f0 kernel/kthread.c:256
  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Local variable description: ----buf.i93@smsc75xx_bind
Variable was created at:
  __smsc75xx_read_reg drivers/net/usb/smsc75xx.c:83 [inline]
  smsc75xx_wait_ready drivers/net/usb/smsc75xx.c:969 [inline]
  smsc75xx_bind+0x44c/0x12d0 drivers/net/usb/smsc75xx.c:1483
  usbnet_probe+0x10d3/0x3950 drivers/net/usb/usbnet.c:1722
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
