Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 023685B25F
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 01:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbfF3Xqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 19:46:55 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43852 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbfF3Xqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 19:46:55 -0400
Received: by mail-pl1-f195.google.com with SMTP id cl9so6301957plb.10;
        Sun, 30 Jun 2019 16:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=A6kq3xfcTnwLBiBV3ctiAErmF3NRCSlEnFmtaNhnXok=;
        b=Ygn7+cu41HkcAPBkxqiMdAycsuSTCUphtFxUkI+FHiF3u/96Ok7FsVXwNXFMrguz2C
         Ol/+CdkVaaC5+b2mvHxdDvHxBJ5F/eWfKNr3Lt8HoHr3fWTUEZf+3Ae7Z7+ConwL4XOe
         Ir8AO9zDxsUe0TQleJZTH8J8CxqphD48wc3jDP6PQcs8KOpNz8SlaHrvHNdQ92FoRoV9
         Wx6lyGSeQZ2klx42HTXspC16tYOwghK+q9UfQa4949J+Alqwuh1qoEkI3Rbqw9i06LBH
         kLfCkFXEVqzYSmse6Rv38Lk277rBnXJOdnhzUE2CvPdwiPZvWj+NEZcNRJKrJaoFjvRp
         eXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=A6kq3xfcTnwLBiBV3ctiAErmF3NRCSlEnFmtaNhnXok=;
        b=KmzQFPTg37nyirQWhve8XYoVOmRmULpMkN9zQXFg4Qj67VyI1K6SOV0ffCYcTWQhnn
         3HhLCspvRFkzrYkvCCz4+jOD3XDxdCpv6hlZi6zH6Xu3/AvkPRRz1HTfMsoJGJfGV5im
         Bx/9C4Nq5xGT05qNruWAw7gJM5i2xLoLShey+ukhlF+ae6jq/HuXt2U//FW98CA5m8uZ
         HSDz+Tm0hNPKa1ropVK7NhiCps9WqFESgPLnWpfCpvLTf4mv7qDH3Lwpst0RxpqE9meq
         uDHTVdVvf9Rp1fbvdk3KI0hb6lJN2XLJLpH5Yly1eDrQ/Yy+/O2Rgv7kFVvbECk16gFq
         An1w==
X-Gm-Message-State: APjAAAXT2B0l3HVfDVj0ijGf1EGMzG9Tn6q979ssdQ7Vodgk92cLeg1Q
        fvqosT/JqIoMfGyKFMJ/o1sTjl2FnCY=
X-Google-Smtp-Source: APXvYqzzDTDlwaZQT6F4ZDmY0tHy7f+zo0oVdXhG3651u2LCun4cOzlCfadDtb1yBZxrHOgRZcyj4w==
X-Received: by 2002:a17:902:bcc4:: with SMTP id o4mr24884473pls.90.1561938413906;
        Sun, 30 Jun 2019 16:46:53 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id t8sm289092pji.24.2019.06.30.16.46.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 16:46:53 -0700 (PDT)
From:   Phong Tran <tranmanphong@gmail.com>
To:     syzbot+8a3fc6674bbc3978ed4e@syzkaller.appspotmail.com
Cc:     davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        lynxis@fe80.eu, marcel.ziswiler@toradex.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yang.wei9@zte.com.cn, zhang.run@zte.com.cn,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH] net: usb: asix: init MAC address buffers
Date:   Mon,  1 Jul 2019 06:45:33 +0700
Message-Id: <20190630234533.15089-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <00000000000008f06d058a6e9783@google.com>
References: <00000000000008f06d058a6e9783@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is for fixing bug KMSAN: uninit-value in ax88772_bind

Tested by
https://groups.google.com/d/msg/syzkaller-bugs/aFQurGotng4/cFe9nxMCCwAJ

Reported-by: syzbot+8a3fc6674bbc3978ed4e@syzkaller.appspotmail.com

syzbot found the following crash on:

HEAD commit:    f75e4cfe kmsan: use kmsan_handle_urb() in urb.c
git tree:       kmsan
console output: https://syzkaller.appspot.com/x/log.txt?x=136d720ea00000
kernel config:
https://syzkaller.appspot.com/x/.config?x=602468164ccdc30a
dashboard link:
https://syzkaller.appspot.com/bug?extid=8a3fc6674bbc3978ed4e
compiler:       clang version 9.0.0 (/home/glider/llvm/clang
06d00afa61eef8f7f501ebdb4e8612ea43ec2d78)
syz repro:
https://syzkaller.appspot.com/x/repro.syz?x=12788316a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=120359aaa00000

==================================================================
BUG: KMSAN: uninit-value in is_valid_ether_addr
include/linux/etherdevice.h:200 [inline]
BUG: KMSAN: uninit-value in asix_set_netdev_dev_addr
drivers/net/usb/asix_devices.c:73 [inline]
BUG: KMSAN: uninit-value in ax88772_bind+0x93d/0x11e0
drivers/net/usb/asix_devices.c:724
CPU: 0 PID: 3348 Comm: kworker/0:2 Not tainted 5.1.0+ #1
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:622
  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
  is_valid_ether_addr include/linux/etherdevice.h:200 [inline]
  asix_set_netdev_dev_addr drivers/net/usb/asix_devices.c:73 [inline]
  ax88772_bind+0x93d/0x11e0 drivers/net/usb/asix_devices.c:724
  usbnet_probe+0x10f5/0x3940 drivers/net/usb/usbnet.c:1728
  usb_probe_interface+0xd66/0x1320 drivers/usb/core/driver.c:361
  really_probe+0xdae/0x1d80 drivers/base/dd.c:513
  driver_probe_device+0x1b3/0x4f0 drivers/base/dd.c:671
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:778
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
  __device_attach+0x454/0x730 drivers/base/dd.c:844
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:891
  bus_probe_device+0x137/0x390 drivers/base/bus.c:514
  device_add+0x288d/0x30e0 drivers/base/core.c:2106
  usb_set_configuration+0x30dc/0x3750 drivers/usb/core/message.c:2027
  generic_probe+0xe7/0x280 drivers/usb/core/generic.c:210
  usb_probe_device+0x14c/0x200 drivers/usb/core/driver.c:266
  really_probe+0xdae/0x1d80 drivers/base/dd.c:513
  driver_probe_device+0x1b3/0x4f0 drivers/base/dd.c:671
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:778
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
  __device_attach+0x454/0x730 drivers/base/dd.c:844
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:891
  bus_probe_device+0x137/0x390 drivers/base/bus.c:514
  device_add+0x288d/0x30e0 drivers/base/core.c:2106
  usb_new_device+0x23e5/0x2ff0 drivers/usb/core/hub.c:2534
  hub_port_connect drivers/usb/core/hub.c:5089 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
  port_event drivers/usb/core/hub.c:5350 [inline]
  hub_event+0x48d1/0x7290 drivers/usb/core/hub.c:5432
  process_one_work+0x1572/0x1f00 kernel/workqueue.c:2269
  process_scheduled_works kernel/workqueue.c:2331 [inline]
  worker_thread+0x189c/0x2460 kernel/workqueue.c:2417
  kthread+0x4b5/0x4f0 kernel/kthread.c:254
  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/net/usb/asix_devices.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index c9bc96310ed4..f514d19316b1 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -230,6 +230,7 @@ static int ax88172_bind(struct usbnet *dev, struct usb_interface *intf)
 	int i;
 	unsigned long gpio_bits = dev->driver_info->data;
 
+	memset(buf, 0, sizeof(buf));
 	usbnet_get_endpoints(dev,intf);
 
 	/* Toggle the GPIOs in a manufacturer/model specific way */
@@ -681,6 +682,7 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 	u32 phyid;
 	struct asix_common_private *priv;
 
+	memset(buf, 0, sizeof(buf));
 	usbnet_get_endpoints(dev, intf);
 
 	/* Maybe the boot loader passed the MAC address via device tree */
@@ -1063,6 +1065,7 @@ static int ax88178_bind(struct usbnet *dev, struct usb_interface *intf)
 	int ret;
 	u8 buf[ETH_ALEN];
 
+	memset(buf, 0, sizeof(buf));
 	usbnet_get_endpoints(dev,intf);
 
 	/* Get the MAC address */
-- 
2.11.0

