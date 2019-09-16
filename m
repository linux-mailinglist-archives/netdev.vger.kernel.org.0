Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD87B3B59
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733241AbfIPN3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:29:13 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:52882 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733221AbfIPN3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 09:29:11 -0400
Received: by mail-io1-f69.google.com with SMTP id g8so5840648iop.19
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 06:29:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Is+d6dqD59UDWyRn9HoG+eKzIMsqRNy0LD3MnVyhGVI=;
        b=KOncstS/mkY4laYXmdIShikQBGnNXdDwLa7oEOtTU3RmqjHb6pHzIWfNRUsINFnKU5
         ouDgOwnDEzTNVbei+Itap+NuaJGovgfkwnClcT1D4eGModvOvO8WokJmWRQcocbiVJ23
         74b5OHRv/hNcu8kvfeDHISlBj0j6+ZWFL/PQvjkbmnivtHov2l0APjC6ikik1WETD9Pb
         gdpHP8MSk3WaTXld9dGbkv/Mz1C3jkM4qcOUwtHZzs54cDpcFXWhSqbtoiY1T2VOFpJu
         PVqE5Sj4Ux0lJggmPeDUYvnjxqAuYlxkcrg2PB1N0vSxQ9v0aUok8+5llOWEywn20xMy
         YN2g==
X-Gm-Message-State: APjAAAWVnuTXVJigexbzOnnl0xNq4m3un9qVuBoKugzsrj/r23xIzM4I
        q+3BTg4n0G0wO7hPs4ZD8ooMAYoJiwLuJdz0ciDjt1uZYRR5
X-Google-Smtp-Source: APXvYqyLzrn6iiZVIWcm8eZceVi2PWZgTGKMtrYR8hDkGckeZGGAiakb+t1cexOZtT1aVd0Pc+k6T4mPfu7iBujPeYOMDpVBs75b
MIME-Version: 1.0
X-Received: by 2002:a02:c8cd:: with SMTP id q13mr402813jao.133.1568640549268;
 Mon, 16 Sep 2019 06:29:09 -0700 (PDT)
Date:   Mon, 16 Sep 2019 06:29:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b83b550592ab965b@google.com>
Subject: divide error in usbnet_update_max_qlen
From:   syzbot <syzbot+6102c120be558c885f04@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, davem@davemloft.net,
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

HEAD commit:    f0df5c1b usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=117659fa600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5c6633fa4ed00be5
dashboard link: https://syzkaller.appspot.com/bug?extid=6102c120be558c885f04
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12107ba9600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=146014e6600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6102c120be558c885f04@syzkaller.appspotmail.com

usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
cdc_ncm 1-1:1.0: MAC-Address: 42:42:42:42:42:42
cdc_ncm 1-1:1.0: dwNtbInMaxSize=0 is too small. Using 2048
cdc_ncm 1-1:1.0: setting rx_max = 2048
divide error: 0000 [#1] SMP KASAN
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:usbnet_update_max_qlen drivers/net/usb/usbnet.c:344 [inline]
RIP: 0010:usbnet_update_max_qlen+0x231/0x370 drivers/net/usb/usbnet.c:338
Code: 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 46 01  
00 00 48 8d bb f4 00 00 00 31 d2 b8 c8 63 01 00 48 89 f9 <48> f7 b3 a8 01  
00 00 48 ba 00 00 00 00 00 fc ff df 48 c1 e9 03 0f
RSP: 0018:ffff8881da20f010 EFLAGS: 00010246
RAX: 00000000000163c8 RBX: ffff8881d5ad8ac0 RCX: ffff8881d5ad8bb4
RDX: 0000000000000000 RSI: ffffffff8344ecde RDI: ffff8881d5ad8bb4
RBP: 0000000000000003 R08: ffff8881da1f9800 R09: ffffed103ab5b00a
R10: ffffed103ab5b009 R11: ffff8881d5ad804f R12: 0000000000000000
R13: ffff8881d5ad8c38 R14: ffff8881d5ad8ac0 R15: ffff8881d2820c80
FS:  0000000000000000(0000) GS:ffff8881db200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f26d0180000 CR3: 00000001d38dd000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  cdc_ncm_update_rxtx_max+0x8e9/0xef0 drivers/net/usb/cdc_ncm.c:440
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


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
