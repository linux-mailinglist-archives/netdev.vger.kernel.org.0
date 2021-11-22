Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCED4459110
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239798AbhKVPPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:15:32 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:42757 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239776AbhKVPPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:15:31 -0500
Received: by mail-il1-f199.google.com with SMTP id r5-20020a92cd85000000b0029e6b5a7a2fso2443645ilb.9
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 07:12:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=9zfPbTH6EhmbuWX63gHOJAyXkrLkLRUhWK2123YhmQU=;
        b=P4Qxz0XZp9DG3iLtVKw+7h51rZTOCS45FK1gWGrWjvM57HpCRq88fc0/eSq77QAerb
         v2NINdIDdJ6oiHnvxBvG6u3uNx9a0/ApK8rbmx7iKx17TZgZhF7Inu+bQGWIs2chgmsP
         SkK0xAFiqjSBO4zRuHj+s3COcU3NFVvifdmIyc12FTmO0VlWGqV4qKRqFsQ0z6s790Ru
         Npsxr0uzuPi1qstifkZqE2ranC0oc7Z5N0x8bGEs6s9IPK/MQW1o9eT1fJFrIlDoxSgH
         AKxrwtBY7IqdkDt2oqwd8FScH3q8uzSKY6lsZfdaP9FKLmTwc55SKO6lmLDHUcwS9EIu
         lSSQ==
X-Gm-Message-State: AOAM5309gtCc4Zc3cbH1bb0RJbDcDNvm46v7QzpJrxjuQz7LIFqfy+/H
        COBxP4Lkl7dNFBCn4WrTvxHqFz9eh18LTys6FPPy5cLm4xTE
X-Google-Smtp-Source: ABdhPJxpb8fXburtZmWEWzHRgC3xOXswoUcS3J5LPKIv8I1k+S+xlrEillNqV5iwDtaSGP4BvLpQ619CtH7LIplCbVIx0mT+zy1h
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aa2:: with SMTP id l2mr19554392ilv.114.1637593944927;
 Mon, 22 Nov 2021 07:12:24 -0800 (PST)
Date:   Mon, 22 Nov 2021 07:12:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005fb57e05d1620da1@google.com>
Subject: [syzbot] KMSAN: uninit-value in ax88772a_hw_reset
From:   syzbot <syzbot+8d179821571093c5f928@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, davem@davemloft.net, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux@rempel-privat.de,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    412af9cd936d ioremap.c: move an #include around
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=136fb126b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2d142cdf4204061
dashboard link: https://syzkaller.appspot.com/bug?extid=8d179821571093c5f928
compiler:       clang version 14.0.0 (git@github.com:llvm/llvm-project.git 0996585c8e3b3d409494eb5f1cad714b9e1f7fb5), GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8d179821571093c5f928@syzkaller.appspotmail.com

asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0016: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable hardware MII access
=====================================================
BUG: KMSAN: uninit-value in ax88772a_hw_reset+0xc2a/0x12c0 drivers/net/usb/asix_devices.c:523
 ax88772a_hw_reset+0xc2a/0x12c0 drivers/net/usb/asix_devices.c:523
 ax88772_bind+0x838/0x19b0 drivers/net/usb/asix_devices.c:762
 usbnet_probe+0x1285/0x40c0 drivers/net/usb/usbnet.c:1745
 usb_probe_interface+0xf15/0x1530 drivers/usb/core/driver.c:396
 really_probe+0x66e/0x1510 drivers/base/dd.c:596
 __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:751
 driver_probe_device drivers/base/dd.c:781 [inline]
 __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:898
 bus_for_each_drv+0x2f0/0x410 drivers/base/bus.c:427
 __device_attach+0x593/0x8e0 drivers/base/dd.c:969
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:1016
 bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487
 device_add+0x1d46/0x2400 drivers/base/core.c:3396
 usb_set_configuration+0x389f/0x3ee0 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0x13c/0x300 drivers/usb/core/generic.c:238
 usb_probe_device+0x309/0x570 drivers/usb/core/driver.c:293
 really_probe+0x66e/0x1510 drivers/base/dd.c:596
 __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:751
 driver_probe_device drivers/base/dd.c:781 [inline]
 __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:898
 bus_for_each_drv+0x2f0/0x410 drivers/base/bus.c:427
 __device_attach+0x593/0x8e0 drivers/base/dd.c:969
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:1016
 bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487
 device_add+0x1d46/0x2400 drivers/base/core.c:3396
 usb_new_device+0x1b9a/0x2960 drivers/usb/core/hub.c:2563
 hub_port_connect drivers/usb/core/hub.c:5348 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5488 [inline]
 port_event drivers/usb/core/hub.c:5634 [inline]
 hub_event+0x57cf/0x8690 drivers/usb/core/hub.c:5716
 process_one_work+0xdc7/0x1760 kernel/workqueue.c:2297
 worker_thread+0x1101/0x22b0 kernel/workqueue.c:2444
 kthread+0x66b/0x780 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30

Local variable smsr.i created at:
 asix_mdio_read_nopm+0xb7/0xab0 drivers/net/usb/asix_common.c:574
 ax88772a_hw_reset+0x822/0x12c0 drivers/net/usb/asix_devices.c:511
=====================================================
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0014: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable hardware MII access
=====================================================
BUG: KMSAN: uninit-value in ax88772a_hw_reset+0xc37/0x12c0 drivers/net/usb/asix_devices.c:527
 ax88772a_hw_reset+0xc37/0x12c0 drivers/net/usb/asix_devices.c:527
 ax88772_bind+0x838/0x19b0 drivers/net/usb/asix_devices.c:762
 usbnet_probe+0x1285/0x40c0 drivers/net/usb/usbnet.c:1745
 usb_probe_interface+0xf15/0x1530 drivers/usb/core/driver.c:396
 really_probe+0x66e/0x1510 drivers/base/dd.c:596
 __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:751
 driver_probe_device drivers/base/dd.c:781 [inline]
 __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:898
 bus_for_each_drv+0x2f0/0x410 drivers/base/bus.c:427
 __device_attach+0x593/0x8e0 drivers/base/dd.c:969
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:1016
 bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487
 device_add+0x1d46/0x2400 drivers/base/core.c:3396
 usb_set_configuration+0x389f/0x3ee0 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0x13c/0x300 drivers/usb/core/generic.c:238
 usb_probe_device+0x309/0x570 drivers/usb/core/driver.c:293
 really_probe+0x66e/0x1510 drivers/base/dd.c:596
 __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:751
 driver_probe_device drivers/base/dd.c:781 [inline]
 __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:898
 bus_for_each_drv+0x2f0/0x410 drivers/base/bus.c:427
 __device_attach+0x593/0x8e0 drivers/base/dd.c:969
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:1016
 bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487
 device_add+0x1d46/0x2400 drivers/base/core.c:3396
 usb_new_device+0x1b9a/0x2960 drivers/usb/core/hub.c:2563
 hub_port_connect drivers/usb/core/hub.c:5348 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5488 [inline]
 port_event drivers/usb/core/hub.c:5634 [inline]
 hub_event+0x57cf/0x8690 drivers/usb/core/hub.c:5716
 process_one_work+0xdc7/0x1760 kernel/workqueue.c:2297
 worker_thread+0x1101/0x22b0 kernel/workqueue.c:2444
 kthread+0x66b/0x780 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30

Local variable smsr.i created at:
 asix_mdio_read_nopm+0xb7/0xab0 drivers/net/usb/asix_common.c:574
 ax88772a_hw_reset+0x8af/0x12c0 drivers/net/usb/asix_devices.c:513
=====================================================
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
