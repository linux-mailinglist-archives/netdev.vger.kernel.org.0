Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9722D7D6F
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436742AbgLKRyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:54:31 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:56159 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436724AbgLKRxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:53:52 -0500
Received: by mail-io1-f72.google.com with SMTP id j25so7046668iog.22
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 09:53:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=F6lzTl7DMvKOhUGDjmWZdH0v8anPBofwp1kBR+QwaMU=;
        b=Q02u9lAs89TAaEFtzBcFswmXPYT7YElXCeKlMktftyKL6enJDV9xsMKLpud9XUSGlm
         CMOBE1pdm97WkDzIc3CC4MAOK0zPsqNDnr9/ucvhBtyX8ggXiGB83ZaURefLPln78b2g
         bEeMYyLa8mTgWVZt3sEqF63tSEP3diRZwkfGDW0ef6OkzIOqURbPPjq3LUZtumNLrAac
         3I3OQK+NTt3W3yQMijkA1Ry5fc8iGRhHL3AOw8Mk5NXTQB3ecdw2+kkhtrL8SSIashy1
         Ja5EFtbSy1RenDhHkAUUUoKuBxny7s7LWmpjrftPylxqrMzReB2xPm02pPHpbzo0wAQm
         ZwPw==
X-Gm-Message-State: AOAM533Jq3QXgsfqT0Jx88zLLmELER0HXvEjUlyA3MHgO2R4rPFd8tOi
        FemmjWQ4U2ViYcQq/WTwp0yxARdbjV7shsen3eSb6Qm/rsBO
X-Google-Smtp-Source: ABdhPJydbqtHo4VrlKJPWk9c4B7TNVmbpOjyjLinDbvsSX2Yr3fAV/34+U9i/lN2ICGcMOiFL7KY1rbHjlN6oM0pkXxiARMpZ2Ft
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2211:: with SMTP id n17mr16332255ion.107.1607709191262;
 Fri, 11 Dec 2020 09:53:11 -0800 (PST)
Date:   Fri, 11 Dec 2020 09:53:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003f58a605b633f77d@google.com>
Subject: memory leak in pcan_usb_fd_init
From:   syzbot <syzbot+91adee8d9ebb9193d22d@syzkaller.appspotmail.com>
To:     dan.carpenter@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        mkl@pengutronix.de, netdev@vger.kernel.org,
        s.grosjean@peak-system.com, syzkaller-bugs@googlegroups.com,
        wg@grandegger.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0477e928 Linux 5.10-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16dacc13500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4305fa9ea70c7a9f
dashboard link: https://syzkaller.appspot.com/bug?extid=91adee8d9ebb9193d22d
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e1d00f500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=153ac2cb500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+91adee8d9ebb9193d22d@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88810f4cc200 (size 128):
  comm "kworker/1:1", pid 34, jiffies 4294942277 (age 8.590s)
  hex dump (first 32 bytes):
    40 09 42 12 81 88 ff ff 00 00 00 00 00 00 00 00  @.B.............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000a24b3bdd>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000a24b3bdd>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000a24b3bdd>] pcan_usb_fd_init+0x156/0x210 drivers/net/can/usb/peak_usb/pcan_usb_fd.c:865
    [<000000007ba29c7f>] peak_usb_create_dev drivers/net/can/usb/peak_usb/pcan_usb_core.c:850 [inline]
    [<000000007ba29c7f>] peak_usb_probe+0x389/0x490 drivers/net/can/usb/peak_usb/pcan_usb_core.c:948
    [<00000000ea93b2ea>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
    [<000000001ee8e05e>] really_probe+0x159/0x480 drivers/base/dd.c:554
    [<0000000010c7fe39>] driver_probe_device+0x84/0x100 drivers/base/dd.c:738
    [<0000000020e41d8d>] __device_attach_driver+0xee/0x110 drivers/base/dd.c:844
    [<000000000272c5fa>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:431
    [<00000000d3b1aa42>] __device_attach+0x122/0x250 drivers/base/dd.c:912
    [<00000000a0b053c3>] bus_probe_device+0xc6/0xe0 drivers/base/bus.c:491
    [<00000000dfb5e550>] device_add+0x5ac/0xc30 drivers/base/core.c:2936
    [<00000000d6321aa6>] usb_set_configuration+0x9de/0xb90 drivers/usb/core/message.c:2159
    [<000000003d1efb2f>] usb_generic_driver_probe+0x8c/0xc0 drivers/usb/core/generic.c:238
    [<000000000a7312a8>] usb_probe_device+0x5c/0x140 drivers/usb/core/driver.c:293
    [<000000001ee8e05e>] really_probe+0x159/0x480 drivers/base/dd.c:554
    [<0000000010c7fe39>] driver_probe_device+0x84/0x100 drivers/base/dd.c:738
    [<0000000020e41d8d>] __device_attach_driver+0xee/0x110 drivers/base/dd.c:844

BUG: memory leak
unreferenced object 0xffff88810f7a4800 (size 512):
  comm "kworker/1:1", pid 34, jiffies 4294942277 (age 8.590s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff ff ff ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000009ddd23ca>] kmalloc include/linux/slab.h:552 [inline]
    [<000000009ddd23ca>] kzalloc include/linux/slab.h:664 [inline]
    [<000000009ddd23ca>] pcan_usb_fd_init+0x181/0x210 drivers/net/can/usb/peak_usb/pcan_usb_fd.c:870
    [<000000007ba29c7f>] peak_usb_create_dev drivers/net/can/usb/peak_usb/pcan_usb_core.c:850 [inline]
    [<000000007ba29c7f>] peak_usb_probe+0x389/0x490 drivers/net/can/usb/peak_usb/pcan_usb_core.c:948
    [<00000000ea93b2ea>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
    [<000000001ee8e05e>] really_probe+0x159/0x480 drivers/base/dd.c:554
    [<0000000010c7fe39>] driver_probe_device+0x84/0x100 drivers/base/dd.c:738
    [<0000000020e41d8d>] __device_attach_driver+0xee/0x110 drivers/base/dd.c:844
    [<000000000272c5fa>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:431
    [<00000000d3b1aa42>] __device_attach+0x122/0x250 drivers/base/dd.c:912
    [<00000000a0b053c3>] bus_probe_device+0xc6/0xe0 drivers/base/bus.c:491
    [<00000000dfb5e550>] device_add+0x5ac/0xc30 drivers/base/core.c:2936
    [<00000000d6321aa6>] usb_set_configuration+0x9de/0xb90 drivers/usb/core/message.c:2159
    [<000000003d1efb2f>] usb_generic_driver_probe+0x8c/0xc0 drivers/usb/core/generic.c:238
    [<000000000a7312a8>] usb_probe_device+0x5c/0x140 drivers/usb/core/driver.c:293
    [<000000001ee8e05e>] really_probe+0x159/0x480 drivers/base/dd.c:554
    [<0000000010c7fe39>] driver_probe_device+0x84/0x100 drivers/base/dd.c:738
    [<0000000020e41d8d>] __device_attach_driver+0xee/0x110 drivers/base/dd.c:844



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
