Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA5FB3B5F
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387417AbfIPN3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:29:41 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:44361 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733213AbfIPN3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 09:29:11 -0400
Received: by mail-io1-f72.google.com with SMTP id m3so24310169ion.11
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 06:29:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=b5laotBV7ygHpU70Ga/Xbaed4IgwjEvAckEgAO+A7E8=;
        b=UdG18l2z6nYaBIPqaRinRm/BY5HeG210Iikobr4XrXp0U33IFeT9WG/I0+ewwknfmP
         9CL33kzrhyhrTBHXIKeWsGqA+cyrL2chPSO+Tc28t3uhufy+dXxtWGrGX31jombZPKK9
         9paoD5JCZvz0dLjW3kmgFkM5tFdfKt7AledZQI450LKo91XnaiE3xQwZf7N5OTeSTDcA
         DrW9p/OJf8sgIWiMp8mpxjYIWBNs+1VwSV3Z6FsYLNfAhOf/e0/BOp93nWhajbDobdvq
         jqkzVv4mRIVZpMRTxyJvX82t7QUsiPvm8JKbKUkoM4ZwSNe6HAZIHQFVo8aeDede71nU
         ecsw==
X-Gm-Message-State: APjAAAVX6YC6uZJhGcuPGrTG25a+axlVap+XRv2sl63wGqz5lpA03/UX
        Hnlx2NOla8hmejVB6S3HZCn+w9MvatzCTQjTBYrvTjH+Rofa
X-Google-Smtp-Source: APXvYqzi3HjEwadA9ulwQBRY9iUGavcX/vVVGFLeZR/XwfithihO18DjX/LM54HCCZu8WQ65c8N5fPz3R86+MdTtRUQE9pSvYtAc
MIME-Version: 1.0
X-Received: by 2002:a02:245:: with SMTP id 66mr10946896jau.30.1568640550276;
 Mon, 16 Sep 2019 06:29:10 -0700 (PDT)
Date:   Mon, 16 Sep 2019 06:29:10 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c7b6940592ab9606@google.com>
Subject: divide error in cdc_ncm_update_rxtx_max
From:   syzbot <syzbot+ce366e2b8296e25d84f5@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, oliver@neukum.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f0df5c1b usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=14cd1459600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5c6633fa4ed00be5
dashboard link: https://syzkaller.appspot.com/bug?extid=ce366e2b8296e25d84f5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12b4dd85600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=179b7fc1600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ce366e2b8296e25d84f5@syzkaller.appspotmail.com

cdc_ncm 1-1:1.0: dwNtbInMaxSize=0 is too small. Using 2048
cdc_ncm 1-1:1.0: setting rx_max = 2048
cdc_ncm 1-1:1.0: setting tx_max = 16384
divide error: 0000 [#1] SMP KASAN
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:cdc_ncm_update_rxtx_max+0xc6e/0xef0 drivers/net/usb/cdc_ncm.c:419
Code: e0 07 38 c2 0f 9e c1 84 d2 0f 95 c0 84 c1 0f 85 35 02 00 00 0f b7 5b  
04 81 e3 ff 07 00 00 e8 29 47 f7 fd 31 d2 44 89 e0 31 ff <f7> f3 41 89 d5  
89 d6 e8 86 48 f7 fd 45 85 ed 0f 85 17 f7 ff ff e8
RSP: 0018:ffff8881da20f030 EFLAGS: 00010246
RAX: 0000000000004000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffffffff83469377 RDI: 0000000000000000
RBP: ffff8881c7ba0000 R08: ffff8881da1f9800 R09: ffffed103b645d58
R10: ffffed103b645d57 R11: ffff8881db22eabf R12: 0000000000004000
R13: 0000000000000000 R14: ffff8881d35f3dc0 R15: ffff8881d2a70f00
FS:  0000000000000000(0000) GS:ffff8881db200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1059879000 CR3: 00000001d49db000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  cdc_ncm_setup drivers/net/usb/cdc_ncm.c:667 [inline]
  cdc_ncm_bind_common+0x1005/0x2570 drivers/net/usb/cdc_ncm.c:924
  cdc_ncm_bind+0x7c/0x1c0 drivers/net/usb/cdc_ncm.c:1038
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
---[ end trace ab75cc10e099d8e9 ]---
RIP:


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
