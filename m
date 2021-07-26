Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1418C3D5B36
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhGZNc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234781AbhGZNcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:32:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC626C0613D5
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:23 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81LC-0001dU-7X
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:22 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C19E165822F
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:07 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 055446581AE;
        Mon, 26 Jul 2021 14:11:53 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bf57c323;
        Mon, 26 Jul 2021 14:11:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Zhen Lei <thunder.leizhen@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 20/46] can: esd_usb2: use DEVICE_ATTR_RO() helper macro
Date:   Mon, 26 Jul 2021 16:11:18 +0200
Message-Id: <20210726141144.862529-21-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

Use DEVICE_ATTR_RO() helper macro instead of plain DEVICE_ATTR(), which
makes the code a bit shorter and easier to read.

Link: https://lore.kernel.org/r/20210603110902.11930-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/esd_usb2.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 65b58f8fc328..60f3e0ca080a 100644
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
2.30.2


