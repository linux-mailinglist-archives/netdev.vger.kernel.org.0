Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC84399F8E
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 13:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhFCLKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 07:10:55 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3046 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbhFCLKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 07:10:54 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FwjhR6jZLzWr77;
        Thu,  3 Jun 2021 19:04:23 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 19:09:08 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 19:09:07 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] can: esd_usb2: use DEVICE_ATTR_RO() helper macro
Date:   Thu, 3 Jun 2021 19:09:02 +0800
Message-ID: <20210603110902.11930-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEVICE_ATTR_RO() helper macro instead of plain DEVICE_ATTR(), which
makes the code a bit shorter and easier to read.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/net/can/usb/esd_usb2.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 65b58f8fc3287cd..60f3e0ca080afdb 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -474,7 +474,7 @@ static void esd_usb2_write_bulk_callback(struct urb *urb)
 	netif_trans_update(netdev);
 }
 
-static ssize_t show_firmware(struct device *d,
+static ssize_t firmware_show(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
 	struct usb_interface *intf = to_usb_interface(d);
@@ -485,9 +485,9 @@ static ssize_t show_firmware(struct device *d,
 		       (dev->version >> 8) & 0xf,
 		       dev->version & 0xff);
 }
-static DEVICE_ATTR(firmware, 0444, show_firmware, NULL);
+static DEVICE_ATTR_RO(firmware);
 
-static ssize_t show_hardware(struct device *d,
+static ssize_t hardware_show(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
 	struct usb_interface *intf = to_usb_interface(d);
@@ -498,9 +498,9 @@ static ssize_t show_hardware(struct device *d,
 		       (dev->version >> 24) & 0xf,
 		       (dev->version >> 16) & 0xff);
 }
-static DEVICE_ATTR(hardware, 0444, show_hardware, NULL);
+static DEVICE_ATTR_RO(hardware);
 
-static ssize_t show_nets(struct device *d,
+static ssize_t nets_show(struct device *d,
 			 struct device_attribute *attr, char *buf)
 {
 	struct usb_interface *intf = to_usb_interface(d);
@@ -508,7 +508,7 @@ static ssize_t show_nets(struct device *d,
 
 	return sprintf(buf, "%d", dev->net_count);
 }
-static DEVICE_ATTR(nets, 0444, show_nets, NULL);
+static DEVICE_ATTR_RO(nets);
 
 static int esd_usb2_send_msg(struct esd_usb2 *dev, struct esd_usb2_msg *msg)
 {
-- 
2.26.0.106.g9fadedd


