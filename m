Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDBD75C63E
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 02:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfGBALF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 20:11:05 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36550 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbfGBALF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 20:11:05 -0400
Received: by mail-pl1-f193.google.com with SMTP id k8so8149701plt.3;
        Mon, 01 Jul 2019 17:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x+M8pyHOh8wnU/N1sq2vqAdxSLmeMsZF3+ahIEr1iWA=;
        b=FfVqSzn4DGQou1Gdk63DkEcX75P08PHGIpiPwK4Qecvmfn1+tL93FAFwgvycHpj3aO
         PgLdkAYNV/sAHyaBH29lmCm9r4WyxIE18o5e++h2Wgj2Od1aMrRDnjQ7lkVW7mzXtmWg
         LtMtUuViiwWcZqE3xOHWvxYFc8VcQWJMsdKqA4bWbI3ar8PV1qsxrPvo2+eqWpElHKPV
         HsoHfOH/+1q4P4/deipBUCtKsI4jt/1/RcI098kVQkyTsn+3RPgQvGEYUdh9qWAN7kEG
         hZMLSz14k0WNAeC7JjcK45HhUKB7cRDNQr+YSZA+NryfevNyNdLzQOYxxem+YHKyTtlm
         GDdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=x+M8pyHOh8wnU/N1sq2vqAdxSLmeMsZF3+ahIEr1iWA=;
        b=Q+Rac+ESsWAv2ZpmuENKnhOHMitMhgRKxLVvetaBv1XEPxSB4X77OBlTIIEdH7ceS+
         yo7kbVX2bvsROEgTAGz1OujUmF9GanbPAnKu94KNO6wkWf2zhD6hZDG5rn9So5myM4F5
         mloqWMvihptxFQ/gR9TOV0QRrnsn5RBeqlWhSpcd6AQs4I/2yzs2xjUDUb4Qho32Y2gc
         Up4c338pykZSPORCusbYDYpkcg1WgvD2nGNTq+ziup20DTMr2Cn9BsXAEVs5Hcr/QZ6s
         blqrpSEV2AiJVdyfXXahFUFcghzaxVkOhwAld4waVCF5hQkkIhix8oEeNXZu0lfmXxy7
         elYg==
X-Gm-Message-State: APjAAAX3+4C5BSvGKsEtriO8uuSQfVUc2VchVc1hAb2YhVO0AVAHsM7L
        HzKVdt+wOzhMgb8CeN/mVSA=
X-Google-Smtp-Source: APXvYqzbzD8/VZFKySWga7bo++gFJO5uqk7NoRYczzeonvHFIfJ70ULtzKxO/rMMOCwEC3WkyQRpHQ==
X-Received: by 2002:a17:902:7c8e:: with SMTP id y14mr29846500pll.298.1562026263665;
        Mon, 01 Jul 2019 17:11:03 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id q19sm13443704pfc.62.2019.07.01.17.10.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 17:11:02 -0700 (PDT)
From:   Phong Tran <tranmanphong@gmail.com>
To:     davem@davemloft.net, dcbw@redhat.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc:     glider@google.com, linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, lynxis@fe80.eu,
        marcel.ziswiler@toradex.com, skhan@linuxfoundation.org,
        syzbot+8a3fc6674bbc3978ed4e@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yang.wei9@zte.com.cn,
        zhang.run@zte.com.cn, tranmanphong@gmail.com
Subject: [PATCH V2] net: usb: asix: init MAC address buffers
Date:   Tue,  2 Jul 2019 07:10:08 +0700
Message-Id: <20190702001008.26048-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190630234533.15089-1-tranmanphong@gmail.com>
References: <20190630234533.15089-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is for fixing bug KMSAN: uninit-value in ax88772_bind

Tested by
https://groups.google.com/d/msg/syzkaller-bugs/aFQurGotng4/eB_HlNhhCwAJ

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
Changes since v1:
- replace memset() by array init
---
 drivers/net/usb/asix_devices.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index c9bc96310ed4..ef548beba684 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -226,7 +226,7 @@ static void asix_phy_reset(struct usbnet *dev, unsigned int reset_bits)
 static int ax88172_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	int ret = 0;
-	u8 buf[ETH_ALEN];
+	u8 buf[ETH_ALEN] = {0};
 	int i;
 	unsigned long gpio_bits = dev->driver_info->data;
 
@@ -677,7 +677,7 @@ static int asix_resume(struct usb_interface *intf)
 static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	int ret, i;
-	u8 buf[ETH_ALEN], chipcode = 0;
+	u8 buf[ETH_ALEN] = {0}, chipcode = 0;
 	u32 phyid;
 	struct asix_common_private *priv;
 
@@ -1061,7 +1061,7 @@ static const struct net_device_ops ax88178_netdev_ops = {
 static int ax88178_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	int ret;
-	u8 buf[ETH_ALEN];
+	u8 buf[ETH_ALEN] = {0};
 
 	usbnet_get_endpoints(dev,intf);
 
-- 
2.11.0

