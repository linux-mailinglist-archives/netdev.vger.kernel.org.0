Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAEC2D3653
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 23:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731527AbgLHWdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 17:33:51 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:34053 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731360AbgLHWdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 17:33:51 -0500
Received: by mail-io1-f70.google.com with SMTP id r16so15741844ioa.1
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 14:33:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5N8UKcVWDRDZehTYxR/1/iB/xs2w750hku+tRRbXm28=;
        b=l49ePRLvTmD1URjeDZKgMf6xoXsFAfHWY+Rrc2MNXuGpsrJ2C5Rv/fHqCqinbW4Q/M
         qih5ScyDIipBQzFGjj8tBiYxtugX+hqafVY1s06Qn5gLTYWqFmW2sRFUQn9/QSCZ/6tK
         f/0dYAkMY44sXYXzvKmP1aoW9gFv4fEHIb7q3/KX3QfM6pL9IyhQAzfSBAyoqorH/MJJ
         35kTpLZmseKvEnJCHwjNEh0alxx8TXZexrqs9157DOXHhn9G+gFAnIsHksgLrrNuEIAy
         9UpsRogExeMb+Cnq0HVmSkxkjlUzKW9JVEf5eSFbiyHeeEMGRf2WTObAT6HibYqL94uW
         POxA==
X-Gm-Message-State: AOAM5336L0UHFk9huxm6zR3YTKyM4+D8RQAIevjDlZYP/rcVykWWOn3V
        +wjZc4IuY/h7Ictd+OpGTeaIImEfA3SMnDe2S04bwwE0NHbz
X-Google-Smtp-Source: ABdhPJxTCiOFZJBvc0dE/asUctDs0YhPWft6cBWXWFDcz6/g7eOwGBnIHImZ9xCyWIig6yvXUTNsZfOm1ya+drU89FlAddQr4bEa
MIME-Version: 1.0
X-Received: by 2002:a5d:91cf:: with SMTP id k15mr28658ior.161.1607466790502;
 Tue, 08 Dec 2020 14:33:10 -0800 (PST)
Date:   Tue, 08 Dec 2020 14:33:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000953b005b5fb870e@google.com>
Subject: memory leak in pcan_usb_pro_init
From:   syzbot <syzbot+215ecdbae76bb8c36b7e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, gustavoars@kernel.org, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        liushixin2@huawei.com, mkl@pengutronix.de, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, wg@grandegger.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0477e928 Linux 5.10-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14ef3f45500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4305fa9ea70c7a9f
dashboard link: https://syzkaller.appspot.com/bug?extid=215ecdbae76bb8c36b7e
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1207c05b500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b7b613500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+215ecdbae76bb8c36b7e@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff888110d22380 (size 96):
  comm "kworker/0:3", pid 4912, jiffies 4294942219 (age 8.820s)
  hex dump (first 32 bytes):
    40 89 17 12 81 88 ff ff 00 00 00 00 00 00 00 00  @...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000706edd19>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000706edd19>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000706edd19>] pcan_usb_pro_init+0x120/0x280 drivers/net/can/usb/peak_usb/pcan_usb_pro.c:856
    [<0000000025ad9e43>] peak_usb_create_dev drivers/net/can/usb/peak_usb/pcan_usb_core.c:850 [inline]
    [<0000000025ad9e43>] peak_usb_probe+0x389/0x490 drivers/net/can/usb/peak_usb/pcan_usb_core.c:948
    [<0000000064acbdae>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
    [<0000000032f135d3>] really_probe+0x159/0x480 drivers/base/dd.c:554
    [<00000000e1ce8490>] driver_probe_device+0x84/0x100 drivers/base/dd.c:738
    [<00000000bfd26436>] __device_attach_driver+0xee/0x110 drivers/base/dd.c:844
    [<00000000cc4dd83e>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:431
    [<00000000f1b1aa05>] __device_attach+0x122/0x250 drivers/base/dd.c:912
    [<0000000034abf9f3>] bus_probe_device+0xc6/0xe0 drivers/base/bus.c:491
    [<00000000ade05bb4>] device_add+0x5ac/0xc30 drivers/base/core.c:2936
    [<00000000a596bcb5>] usb_set_configuration+0x9de/0xb90 drivers/usb/core/message.c:2159
    [<0000000008726818>] usb_generic_driver_probe+0x8c/0xc0 drivers/usb/core/generic.c:238
    [<00000000c9e87a33>] usb_probe_device+0x5c/0x140 drivers/usb/core/driver.c:293
    [<0000000032f135d3>] really_probe+0x159/0x480 drivers/base/dd.c:554
    [<00000000e1ce8490>] driver_probe_device+0x84/0x100 drivers/base/dd.c:738
    [<00000000bfd26436>] __device_attach_driver+0xee/0x110 drivers/base/dd.c:844



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
