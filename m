Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF4CB4FF9
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 16:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfIQOJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 10:09:02 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:40343 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfIQOJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 10:09:02 -0400
Received: by mail-io1-f70.google.com with SMTP id r20so1382935ioh.7
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 07:09:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=WqQlIC0n0CcCCC4uJWk2cZrYgshHpkTBy0xlz3DgXWg=;
        b=Ew7+/CterD4a9SpIig0dGWBRBom89fA2KzeGoH43mq+nsZjx2IGM7haIqDG88mhthO
         xbfKA9YkzXZZqgB8BnzrFkOUt+GWn1t1Tm8xXH7OvSYbHH10X/rIMqm0VvQGLgL+IRsa
         giJtfLH0GrVxZjrjH1zl/e/Rk1cSecvUjhVBWnKAdpBQZ0vmqeIOyPAR0N3vuTCE+XZb
         vxO3b/JBo1TU51k/8tRCKEUwvzNkrY2+tuBCm+v5jboT3mGopqxr9cmvZtuDQ8gAduJ1
         WtKQcJpaNdxVQ2VcCKrGnAayQdNff1A/0W+wqOUI+ErIboiC5IhayfaJgoLa5CW340y9
         jJdQ==
X-Gm-Message-State: APjAAAVi1nJiP8r4kBYSdv7k/3E2dDmuNsyuqJt2gjZAnHX/OAuTkVw8
        rxXWwGzScnH30xH6n6ikgrQmRGXE8XwnYoxPPQwfTVD2zXur
X-Google-Smtp-Source: APXvYqyT088wysYFq/5SP8eluZXiLb2Qh5Ol3ISm4MLrC2qkyFDEM0ixQe8yELSmvbsyFZ6a3r1lRbipkTAk/kSq1lMpl8V/jtGx
MIME-Version: 1.0
X-Received: by 2002:a5d:88cf:: with SMTP id i15mr1093898iol.280.1568729340629;
 Tue, 17 Sep 2019 07:09:00 -0700 (PDT)
Date:   Tue, 17 Sep 2019 07:09:00 -0700
In-Reply-To: <87h85bm3nh.fsf@miraculix.mork.no>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000018e4250592c043c3@google.com>
Subject: Re: divide error in cdc_ncm_update_rxtx_max
From:   syzbot <syzbot+ce366e2b8296e25d84f5@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, bjorn@mork.no, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, oliver@neukum.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer still triggered  
crash:
divide error in usbnet_update_max_qlen

cdc_ncm 5-1:1.0: setting tx_max = 16384
divide error: 0000 [#1] SMP KASAN
CPU: 1 PID: 1737 Comm: kworker/1:2 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:usbnet_update_max_qlen drivers/net/usb/usbnet.c:344 [inline]
RIP: 0010:usbnet_update_max_qlen+0x231/0x370 drivers/net/usb/usbnet.c:338
Code: 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 46 01  
00 00 48 8d bb f4 00 00 00 31 d2 b8 c8 63 01 00 48 89 f9 <48> f7 b3 a8 01  
00 00 48 ba 00 00 00 00 00 fc ff df 48 c1 e9 03 0f
RSP: 0018:ffff8881c05c7010 EFLAGS: 00010246
RAX: 00000000000163c8 RBX: ffff8881c7334ec0 RCX: ffff8881c7334fb4
RDX: 0000000000000000 RSI: ffffffff8344ecde RDI: ffff8881c7334fb4
RBP: 0000000000000003 R08: ffff8881d4a9b000 R09: ffffed1038e6688a
R10: ffffed1038e66889 R11: ffff8881c733444f R12: 0000000000004000
R13: ffff8881c7334ec0 R14: 0000000000000000 R15: ffff8881d62e77ac
FS:  0000000000000000(0000) GS:ffff8881db300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5a513e8000 CR3: 00000001d6436000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  cdc_ncm_update_rxtx_max+0xa61/0xf30 drivers/net/usb/cdc_ncm.c:437
  cdc_ncm_setup drivers/net/usb/cdc_ncm.c:664 [inline]
  cdc_ncm_bind_common+0x1005/0x2570 drivers/net/usb/cdc_ncm.c:921
  cdc_ncm_bind+0x7c/0x1c0 drivers/net/usb/cdc_ncm.c:1035
  usbnet_probe+0xb43/0x23cf drivers/net/usb/usbnet.c:1722
  usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
  really_probe+0x281/0x6d0 drivers/base/dd.c:548
  driver_probe_device+0x101/0x1b0 drivers/base/dd.c:721
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
  bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:454
  __device_attach+0x217/0x360 drivers/base/dd.c:894
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
  device_add+0xae6/0x16f0 drivers/base/core.c:2165
  usb_set_configuration+0xdf6/0x1670 drivers/usb/core/message.c:2023
  generic_probe+0x9d/0xd5 drivers/usb/core/generic.c:210
  usb_probe_device+0x99/0x100 drivers/usb/core/driver.c:266
  really_probe+0x281/0x6d0 drivers/base/dd.c:548
  driver_probe_device+0x101/0x1b0 drivers/base/dd.c:721
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
  bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:454
  __device_attach+0x217/0x360 drivers/base/dd.c:894
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
  device_add+0xae6/0x16f0 drivers/base/core.c:2165
  usb_new_device.cold+0x6a4/0xe79 drivers/usb/core/hub.c:2536
  hub_port_connect drivers/usb/core/hub.c:5098 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
  port_event drivers/usb/core/hub.c:5359 [inline]
  hub_event+0x1b5c/0x3640 drivers/usb/core/hub.c:5441
  process_one_work+0x92b/0x1530 kernel/workqueue.c:2269
  worker_thread+0x96/0xe20 kernel/workqueue.c:2415
  kthread+0x318/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace 472dbe98145a6d5e ]---
RIP: 0010:usbnet_update_max_qlen drivers/net/usb/usbnet.c:344 [inline]
RIP: 0010:usbnet_update_max_qlen+0x231/0x370 drivers/net/usb/usbnet.c:338
Code: 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 46 01  
00 00 48 8d bb f4 00 00 00 31 d2 b8 c8 63 01 00 48 89 f9 <48> f7 b3 a8 01  
00 00 48 ba 00 00 00 00 00 fc ff df 48 c1 e9 03 0f
RSP: 0018:ffff8881c05c7010 EFLAGS: 00010246
RAX: 00000000000163c8 RBX: ffff8881c7334ec0 RCX: ffff8881c7334fb4
RDX: 0000000000000000 RSI: ffffffff8344ecde RDI: ffff8881c7334fb4
RBP: 0000000000000003 R08: ffff8881d4a9b000 R09: ffffed1038e6688a
R10: ffffed1038e66889 R11: ffff8881c733444f R12: 0000000000004000
R13: ffff8881c7334ec0 R14: 0000000000000000 R15: ffff8881d62e77ac
FS:  0000000000000000(0000) GS:ffff8881db300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5a513e8000 CR3: 00000001d6436000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


Tested on:

commit:         f0df5c1b usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git
console output: https://syzkaller.appspot.com/x/log.txt?x=173ea979600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5c6633fa4ed00be5
dashboard link: https://syzkaller.appspot.com/bug?extid=ce366e2b8296e25d84f5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1538611d600000

