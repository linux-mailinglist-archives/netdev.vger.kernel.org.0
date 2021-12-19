Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC4F47A2EA
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 23:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbhLSWwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 17:52:25 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:33558 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbhLSWwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 17:52:24 -0500
Received: by mail-il1-f197.google.com with SMTP id w1-20020a056e021a6100b0029f42663adcso4094257ilv.0
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 14:52:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=4NH3sBvIMAeiYgbo5czpybq8fYvHsvr6r3AhzTfYRso=;
        b=os8+FYdcWEM1kq2whuePWQjQUPgAZrnz/ydB1T6erjihYHB5zUyT91kyvcC5oWrKDp
         2IEiL6M7O+wTVG2u806ud8kM9NjdPGU4bumi4LBFDmMmwCei9JwpPm+cx6tGAUPqFBle
         o/uJ+ehzvY+fMevRVN9c7YyQNu4Z4kXuZOOewyj5fcaQ8jzfJCBC8m5CTTUraOfALjTC
         GUYCM4VtRqQxCwJ612UQhyx0plFwkUgARbsZS6hdt93R85hqLPNf4B0DX65w2REqWNVw
         LoX7XCCvnh5Upf1BVdoU5XTZoxYIROWLy3sBjdLHEC4xJhN/CKobsG2i7RjIvNsdyrKH
         l7eQ==
X-Gm-Message-State: AOAM530M7dJFZcp/zuGlFQTJv0uUjglOV9MTLKr2BBQ08UDxOQHTTHNP
        cEqDQyARjn3JoragVcSenH18lklDmO76/iTIqPAAvpNhjfJx
X-Google-Smtp-Source: ABdhPJx1aFF225Ckr+pUNw29VIPf9G58O7H8TvhDS4oWG+sCvyVO5St3aZsvQIOIf0wRZNwI4Yuo4eF5U1SnOf3jIAldddwHLIzJ
MIME-Version: 1.0
X-Received: by 2002:a02:c72e:: with SMTP id h14mr3969671jao.103.1639954344245;
 Sun, 19 Dec 2021 14:52:24 -0800 (PST)
Date:   Sun, 19 Dec 2021 14:52:24 -0800
In-Reply-To: <0000000000005fb57e05d1620da1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000230b0d05d387a02f@google.com>
Subject: Re: [syzbot] KMSAN: uninit-value in ax88772a_hw_reset
From:   syzbot <syzbot+8d179821571093c5f928@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, davem@davemloft.net, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux@rempel-privat.de,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    b0a8b5053e8b kmsan: core: add dependency on DEBUG_KERNEL
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=14ad9c43b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=46a956fc7a887c60
dashboard link: https://syzkaller.appspot.com/bug?extid=8d179821571093c5f928
compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=101553cbb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10187949b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8d179821571093c5f928@syzkaller.appspotmail.com

asix 1-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0016: -71
asix 1-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 1-1:0.0 (unnamed net_device) (uninitialized): Failed to enable hardware MII access
=====================================================
BUG: KMSAN: uninit-value in ax88772a_hw_reset+0xc55/0x12e0 drivers/net/usb/asix_devices.c:523 drivers/net/usb/asix_devices.c:523
 ax88772a_hw_reset+0xc55/0x12e0 drivers/net/usb/asix_devices.c:523 drivers/net/usb/asix_devices.c:523
 ax88772_bind+0x750/0x1770 drivers/net/usb/asix_devices.c:762 drivers/net/usb/asix_devices.c:762
 usbnet_probe+0x1284/0x4140 drivers/net/usb/usbnet.c:1747 drivers/net/usb/usbnet.c:1747
 usb_probe_interface+0xf19/0x1600 drivers/usb/core/driver.c:396 drivers/usb/core/driver.c:396
 really_probe+0x67d/0x1510 drivers/base/dd.c:596 drivers/base/dd.c:596
 __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:751 drivers/base/dd.c:751
 driver_probe_device drivers/base/dd.c:781 [inline]
 driver_probe_device drivers/base/dd.c:781 [inline] drivers/base/dd.c:898
 __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:898 drivers/base/dd.c:898
 bus_for_each_drv+0x2d6/0x3f0 drivers/base/bus.c:427 drivers/base/bus.c:427
 __device_attach+0x593/0x8e0 drivers/base/dd.c:969 drivers/base/dd.c:969
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:1016 drivers/base/dd.c:1016
 bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487 drivers/base/bus.c:487
 device_add+0x1d3e/0x2400 drivers/base/core.c:3394 drivers/base/core.c:3394
 usb_set_configuration+0x37e9/0x3ed0 drivers/usb/core/message.c:2170 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0x13c/0x300 drivers/usb/core/generic.c:238 drivers/usb/core/generic.c:238
 usb_probe_device+0x309/0x570 drivers/usb/core/driver.c:293 drivers/usb/core/driver.c:293
 really_probe+0x67d/0x1510 drivers/base/dd.c:596 drivers/base/dd.c:596
 __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:751 drivers/base/dd.c:751
 driver_probe_device drivers/base/dd.c:781 [inline]
 driver_probe_device drivers/base/dd.c:781 [inline] drivers/base/dd.c:898
 __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:898 drivers/base/dd.c:898
 bus_for_each_drv+0x2d6/0x3f0 drivers/base/bus.c:427 drivers/base/bus.c:427
 __device_attach+0x593/0x8e0 drivers/base/dd.c:969 drivers/base/dd.c:969
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:1016 drivers/base/dd.c:1016
 bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487 drivers/base/bus.c:487
 device_add+0x1d3e/0x2400 drivers/base/core.c:3394 drivers/base/core.c:3394
 usb_new_device+0x1b8e/0x2950 drivers/usb/core/hub.c:2563 drivers/usb/core/hub.c:2563
 hub_port_connect drivers/usb/core/hub.c:5353 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5497 [inline]
 port_event drivers/usb/core/hub.c:5643 [inline]
 hub_port_connect drivers/usb/core/hub.c:5353 [inline] drivers/usb/core/hub.c:5725
 hub_port_connect_change drivers/usb/core/hub.c:5497 [inline] drivers/usb/core/hub.c:5725
 port_event drivers/usb/core/hub.c:5643 [inline] drivers/usb/core/hub.c:5725
 hub_event+0x5ad2/0x8910 drivers/usb/core/hub.c:5725 drivers/usb/core/hub.c:5725
 process_one_work+0xdb9/0x1820 kernel/workqueue.c:2298 kernel/workqueue.c:2298
 worker_thread+0x10bc/0x21f0 kernel/workqueue.c:2445 kernel/workqueue.c:2445
 kthread+0x721/0x850 kernel/kthread.c:327 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30

Local variable smsr.i created at:
 asix_mdio_read_nopm+0xb9/0xa50 drivers/net/usb/asix_common.c:574 drivers/net/usb/asix_common.c:574
 ax88772a_hw_reset+0x83c/0x12e0 drivers/net/usb/asix_devices.c:511 drivers/net/usb/asix_devices.c:511

CPU: 1 PID: 115 Comm: kworker/1:2 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
=====================================================

