Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4BC114FD1
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 12:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfLFLfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 06:35:10 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:48396 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfLFLfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 06:35:09 -0500
Received: by mail-io1-f70.google.com with SMTP id e15so4588715ioh.15
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 03:35:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lnm0cl0FYyjfMVu1hmBtm3CNHH8DAMmn2e+a6NxkJN4=;
        b=pEAr1C/YDN4BDhBnOCgct+qQXTi1n+YGmDQiiKrayt4GLELcxlnJ+Y7RcFppEM/kwj
         sNr5Crsm17t3GUWw4tj6ed11d3vUweMxctXybJyZ4EXf3cJPeWkYa0JA+6HLRVqa8l6F
         gr6EfPr1Vz6cvFVbvMFQR3eT9j4Yg34dQNaYSWS2lW5Ai630TLznPYaobJYiD6EnLV70
         suCBGm/sMtm38tL7vVyl+n7BqgK+iGfUG/sbt3z554m6KUkr37Y0PSMSGbYT0d/++qMv
         znHdsuPXbiqF3blwYKtTh86Ia1zh01NsXxxVUvAAafFC6cCwuMx5npwprvwywjWHRud2
         N7Dw==
X-Gm-Message-State: APjAAAVnbrEL1og6JdpUQOjVMFVvSh5UuenV7lfWPfNmM0QGWpDgVW2T
        N1r4JDQQNnfSi/Wmk1aD3ZWSTgy5yhSLPuCCopoLZ4OZbNtP
X-Google-Smtp-Source: APXvYqxMcB5yEJydF3g2Tam754dWo3xuQQzD58x8CYuFo2PAo4XKYT23eZZq784zK9sokEOnDWUTHd/B1pS2jYo94j+NpoCoTRxF
MIME-Version: 1.0
X-Received: by 2002:a6b:4402:: with SMTP id r2mr9836660ioa.119.1575632108657;
 Fri, 06 Dec 2019 03:35:08 -0800 (PST)
Date:   Fri, 06 Dec 2019 03:35:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002220b705990770d8@google.com>
Subject: general protection fault in pegasus_probe
From:   syzbot <syzbot+41b0e2cc7adc40d57974@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, davem@davemloft.net,
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

HEAD commit:    1f22d15c usb: gadget: add raw-gadget interface
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=129ce77ae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8ccee2968018adcb
dashboard link: https://syzkaller.appspot.com/bug?extid=41b0e2cc7adc40d57974
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+41b0e2cc7adc40d57974@syzkaller.appspotmail.com

kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] SMP KASAN
CPU: 1 PID: 3279 Comm: kworker/1:7 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:workqueue_sysfs_unregister kernel/workqueue.c:5689 [inline]
RIP: 0010:destroy_workqueue+0x2e/0x6b0 kernel/workqueue.c:4349
Code: 49 89 fe 41 55 41 54 55 53 48 83 ec 08 e8 1a 7e 23 00 49 8d be 08 01  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 e0 05 00 00 49 8b 9e 08 01 00 00 48 85 db 74 19
RSP: 0018:ffff8881aed87178 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000ec45000
RDX: 0000000000000021 RSI: ffffffff811affe6 RDI: 0000000000000108
RBP: ffff8881d16e0000 R08: ffff8881d34a3100 R09: fffffbfff11aeca6
R10: fffffbfff11aeca5 R11: ffffffff88d7652f R12: ffff8881c6aa0000
R13: 00000000fffffffb R14: 0000000000000000 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff8881db500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000207e0000 CR3: 00000001d9871000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  pegasus_dec_workqueue drivers/net/usb/pegasus.c:1130 [inline]
  pegasus_dec_workqueue drivers/net/usb/pegasus.c:1126 [inline]
  pegasus_probe+0x1071/0x15d0 drivers/net/usb/pegasus.c:1225
  usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
  really_probe+0x281/0x6d0 drivers/base/dd.c:548
  driver_probe_device+0x104/0x210 drivers/base/dd.c:721
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
  bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:430
  __device_attach+0x217/0x360 drivers/base/dd.c:894
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:490
  device_add+0x1480/0x1c20 drivers/base/core.c:2487
  usb_set_configuration+0xe67/0x1740 drivers/usb/core/message.c:2023
  generic_probe+0x9d/0xd5 drivers/usb/core/generic.c:210
  usb_probe_device+0x99/0x100 drivers/usb/core/driver.c:266
  really_probe+0x281/0x6d0 drivers/base/dd.c:548
  driver_probe_device+0x104/0x210 drivers/base/dd.c:721
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
  bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:430
  __device_attach+0x217/0x360 drivers/base/dd.c:894
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:490
  device_add+0x1480/0x1c20 drivers/base/core.c:2487
  usb_new_device.cold+0x6a4/0xe79 drivers/usb/core/hub.c:2537
  hub_port_connect drivers/usb/core/hub.c:5184 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5324 [inline]
  port_event drivers/usb/core/hub.c:5470 [inline]
  hub_event+0x1e59/0x3860 drivers/usb/core/hub.c:5552
  process_one_work+0x92b/0x1530 kernel/workqueue.c:2264
  process_scheduled_works kernel/workqueue.c:2326 [inline]
  worker_thread+0x7ab/0xe20 kernel/workqueue.c:2412
  kthread+0x318/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace b659e9aea6e4f6c5 ]---
RIP: 0010:workqueue_sysfs_unregister kernel/workqueue.c:5689 [inline]
RIP: 0010:destroy_workqueue+0x2e/0x6b0 kernel/workqueue.c:4349
Code: 49 89 fe 41 55 41 54 55 53 48 83 ec 08 e8 1a 7e 23 00 49 8d be 08 01  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 e0 05 00 00 49 8b 9e 08 01 00 00 48 85 db 74 19
RSP: 0018:ffff8881aed87178 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000ec45000
RDX: 0000000000000021 RSI: ffffffff811affe6 RDI: 0000000000000108
RBP: ffff8881d16e0000 R08: ffff8881d34a3100 R09: fffffbfff11aeca6
R10: fffffbfff11aeca5 R11: ffffffff88d7652f R12: ffff8881c6aa0000
R13: 00000000fffffffb R14: 0000000000000000 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff8881db500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000207e0000 CR3: 00000001d9871000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
