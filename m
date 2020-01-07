Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B674C132272
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgAGJdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:33:22 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8230 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726485AbgAGJdT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 04:33:19 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 68A2A4D00D3646B735E1;
        Tue,  7 Jan 2020 17:33:17 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Tue, 7 Jan 2020 17:33:07 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <chenzhou10@huawei.com>
Subject: [PATCH next 1/2] net: ch9200: use __func__ in debug message
Date:   Tue, 7 Jan 2020 17:28:55 +0800
Message-ID: <20200107092856.97742-2-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200107092856.97742-1-chenzhou10@huawei.com>
References: <20200107092856.97742-1-chenzhou10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use __func__ to print the function name instead of hard coded string.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 drivers/net/usb/ch9200.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/usb/ch9200.c b/drivers/net/usb/ch9200.c
index 9df3c1f..3c2dc74 100644
--- a/drivers/net/usb/ch9200.c
+++ b/drivers/net/usb/ch9200.c
@@ -111,8 +111,8 @@ static int control_read(struct usbnet *dev,
 		request_type = (USB_DIR_IN | USB_TYPE_VENDOR |
 				USB_RECIP_DEVICE);
 
-	netdev_dbg(dev->net, "Control_read() index=0x%02x size=%d\n",
-		   index, size);
+	netdev_dbg(dev->net, "%s() index=0x%02x size=%d\n",
+		   __func__, index, size);
 
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf) {
@@ -151,8 +151,8 @@ static int control_write(struct usbnet *dev, unsigned char request,
 		request_type = (USB_DIR_OUT | USB_TYPE_VENDOR |
 				USB_RECIP_DEVICE);
 
-	netdev_dbg(dev->net, "Control_write() index=0x%02x size=%d\n",
-		   index, size);
+	netdev_dbg(dev->net, "%s() index=0x%02x size=%d\n",
+		   __func__, index, size);
 
 	if (data) {
 		buf = kmemdup(data, size, GFP_KERNEL);
@@ -181,8 +181,8 @@ static int ch9200_mdio_read(struct net_device *netdev, int phy_id, int loc)
 	struct usbnet *dev = netdev_priv(netdev);
 	unsigned char buff[2];
 
-	netdev_dbg(netdev, "ch9200_mdio_read phy_id:%02x loc:%02x\n",
-		   phy_id, loc);
+	netdev_dbg(netdev, "%s phy_id:%02x loc:%02x\n",
+		   __func__, phy_id, loc);
 
 	if (phy_id != 0)
 		return -ENODEV;
@@ -199,8 +199,8 @@ static void ch9200_mdio_write(struct net_device *netdev,
 	struct usbnet *dev = netdev_priv(netdev);
 	unsigned char buff[2];
 
-	netdev_dbg(netdev, "ch9200_mdio_write() phy_id=%02x loc:%02x\n",
-		   phy_id, loc);
+	netdev_dbg(netdev, "%s() phy_id=%02x loc:%02x\n",
+		   __func__, phy_id, loc);
 
 	if (phy_id != 0)
 		return;
@@ -219,8 +219,8 @@ static int ch9200_link_reset(struct usbnet *dev)
 	mii_check_media(&dev->mii, 1, 1);
 	mii_ethtool_gset(&dev->mii, &ecmd);
 
-	netdev_dbg(dev->net, "link_reset() speed:%d duplex:%d\n",
-		   ecmd.speed, ecmd.duplex);
+	netdev_dbg(dev->net, "%s() speed:%d duplex:%d\n",
+		   __func__, ecmd.speed, ecmd.duplex);
 
 	return 0;
 }
@@ -309,7 +309,7 @@ static int get_mac_address(struct usbnet *dev, unsigned char *data)
 	unsigned char mac_addr[0x06];
 	int rd_mac_len = 0;
 
-	netdev_dbg(dev->net, "get_mac_address:\n\tusbnet VID:%0x PID:%0x\n",
+	netdev_dbg(dev->net, "%s:\n\tusbnet VID:%0x PID:%0x\n", __func__,
 		   le16_to_cpu(dev->udev->descriptor.idVendor),
 		   le16_to_cpu(dev->udev->descriptor.idProduct));
 
-- 
2.7.4

