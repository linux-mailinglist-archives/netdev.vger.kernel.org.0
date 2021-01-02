Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB792E86BF
	for <lists+netdev@lfdr.de>; Sat,  2 Jan 2021 09:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbhABIJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jan 2021 03:09:54 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:40827 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbhABIJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jan 2021 03:09:53 -0500
Received: by mail-il1-f197.google.com with SMTP id g1so21797429ilq.7
        for <netdev@vger.kernel.org>; Sat, 02 Jan 2021 00:09:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=u/hcWmFoCUOsJZZCZd4p8P1YGS4HzWWUJU8J3bBrFl8=;
        b=ME4txl8bvcaSf4tOdKNL3++F5xbNxS/T8jUqQ3USEE45kXp9CRqE1bBfKfjnaRAmZa
         MRomxynzFgwvBZc7PjgSbMwQ/aRk258TwEY4hqeHkE+bvFSRB5twQQ2KYYUyWOxCPQl5
         3yilK5mIgb2eaCkZx2t6gyQtior7Azfb5dAVcWcPSE+r207MTXHX6PNAxLvuexNVqM0d
         zeSEspI0O0RVHusbTC9PZSWeW8A5jfGEALFB5eOZ2szYR94nkPNeeL8FbXKd6wui+pSa
         tvt1xjHgsXkNYbqJ2RkcQmweagofW+YgVsZj+vjqo5equkIZYl3fpn4ZXEVF2WwGkvHP
         Ef1g==
X-Gm-Message-State: AOAM532mvW+JFEjmaKQRVvi8NL5QKh7SZZeSKqIo88vhg/8VYVqSrpgH
        fyDbqaWIKjG7D5Ba9AgeZCofAzaFaG9XaVXH3+P2wRJnCqz0
X-Google-Smtp-Source: ABdhPJxOiljgFbqoVX2tPkY0VrhSEmqcBsfvutyQQpNPKDd8d2FpWmfp1jEAi711Wk2pf/ChD/kCC6VLfKZa/60ZNv06yzvffPn8
MIME-Version: 1.0
X-Received: by 2002:a92:c682:: with SMTP id o2mr61935404ilg.97.1609574952068;
 Sat, 02 Jan 2021 00:09:12 -0800 (PST)
Date:   Sat, 02 Jan 2021 00:09:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000041eaff05b7e65f96@google.com>
Subject: memory leak in nfcmrvl_nci_register_dev
From:   syzbot <syzbot+19bcfc64a8df1318d1c3@syzkaller.appspotmail.com>
To:     alex.shi@linux.alibaba.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    dea8dcf2 Merge tag 'for-5.11/dm-fix' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15e26077500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f182e38c52a35dc6
dashboard link: https://syzkaller.appspot.com/bug?extid=19bcfc64a8df1318d1c3
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119df6a3500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1147e40b500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+19bcfc64a8df1318d1c3@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88811332dc00 (size 1024):
  comm "kworker/1:3", pid 4910, jiffies 4294942229 (age 33.170s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 e8 f1 11 81 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000ef906e9b>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000ef906e9b>] kzalloc include/linux/slab.h:682 [inline]
    [<00000000ef906e9b>] nci_hci_allocate+0x21/0xd0 net/nfc/nci/hci.c:784
    [<000000002450a09c>] nci_allocate_device net/nfc/nci/core.c:1170 [inline]
    [<000000002450a09c>] nci_allocate_device+0x10b/0x160 net/nfc/nci/core.c:1132
    [<000000001de82881>] nfcmrvl_nci_register_dev+0x10a/0x1c0 drivers/nfc/nfcmrvl/main.c:153
    [<0000000079b32ad1>] nfcmrvl_probe+0x223/0x290 drivers/nfc/nfcmrvl/usb.c:345
    [<000000009f085cef>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
    [<00000000a872208e>] really_probe+0x159/0x480 drivers/base/dd.c:561
    [<000000005f458884>] driver_probe_device+0x84/0x100 drivers/base/dd.c:745
    [<00000000c18df89f>] __device_attach_driver+0xee/0x110 drivers/base/dd.c:851
    [<0000000071a719ab>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:431
    [<00000000a2659ebf>] __device_attach+0x122/0x250 drivers/base/dd.c:919
    [<00000000b52c481d>] bus_probe_device+0xc6/0xe0 drivers/base/bus.c:491
    [<0000000085c0e1c8>] device_add+0x5be/0xc30 drivers/base/core.c:3091
    [<000000002a5183f1>] usb_set_configuration+0x9d9/0xb90 drivers/usb/core/message.c:2164
    [<000000009ca139a5>] usb_generic_driver_probe+0x8c/0xc0 drivers/usb/core/generic.c:238
    [<000000002de27e2d>] usb_probe_device+0x5c/0x140 drivers/usb/core/driver.c:293
    [<00000000a872208e>] really_probe+0x159/0x480 drivers/base/dd.c:561

BUG: memory leak
unreferenced object 0xffff888111b0a400 (size 1024):
  comm "kworker/1:3", pid 4910, jiffies 4294942861 (age 26.850s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 f0 6c 0d 81 88 ff ff  ..........l.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000ef906e9b>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000ef906e9b>] kzalloc include/linux/slab.h:682 [inline]
    [<00000000ef906e9b>] nci_hci_allocate+0x21/0xd0 net/nfc/nci/hci.c:784
    [<000000002450a09c>] nci_allocate_device net/nfc/nci/core.c:1170 [inline]
    [<000000002450a09c>] nci_allocate_device+0x10b/0x160 net/nfc/nci/core.c:1132
    [<000000001de82881>] nfcmrvl_nci_register_dev+0x10a/0x1c0 drivers/nfc/nfcmrvl/main.c:153
    [<0000000079b32ad1>] nfcmrvl_probe+0x223/0x290 drivers/nfc/nfcmrvl/usb.c:345
    [<000000009f085cef>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
    [<00000000a872208e>] really_probe+0x159/0x480 drivers/base/dd.c:561
    [<000000005f458884>] driver_probe_device+0x84/0x100 drivers/base/dd.c:745
    [<00000000c18df89f>] __device_attach_driver+0xee/0x110 drivers/base/dd.c:851
    [<0000000071a719ab>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:431
    [<00000000a2659ebf>] __device_attach+0x122/0x250 drivers/base/dd.c:919
    [<00000000b52c481d>] bus_probe_device+0xc6/0xe0 drivers/base/bus.c:491
    [<0000000085c0e1c8>] device_add+0x5be/0xc30 drivers/base/core.c:3091
    [<000000002a5183f1>] usb_set_configuration+0x9d9/0xb90 drivers/usb/core/message.c:2164
    [<000000009ca139a5>] usb_generic_driver_probe+0x8c/0xc0 drivers/usb/core/generic.c:238
    [<000000002de27e2d>] usb_probe_device+0x5c/0x140 drivers/usb/core/driver.c:293
    [<00000000a872208e>] really_probe+0x159/0x480 drivers/base/dd.c:561



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
