Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192112211BD
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgGOPy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:54:58 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60343 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgGOPy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:54:57 -0400
Received: from cwh (fob.gandi.net [217.70.181.1])
        (Authenticated sender: wxcafe@wxcafe.net)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 1F73160006;
        Wed, 15 Jul 2020 15:54:54 +0000 (UTC)
Message-ID: <0367bce2f9005fc61adf8519dd27f00471ad31e3.camel@wxcafe.net>
Subject: [PATCH 2/4] cdc_ether: export usbnet_cdc_update_filter
From:   =?ISO-8859-1?Q?Wxcaf=E9?= <wxcafe@wxcafe.net>
To:     linux-usb@vger.kernel.org
Cc:     Miguel =?ISO-8859-1?Q?Rodr=EDguez_P=E9rez?= 
        <miguel@det.uvigo.gal>, oliver@neukum.org, netdev@vger.kernel.org
Date:   Wed, 15 Jul 2020 11:54:51 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From 72f2f013dd5eceb3fb51971ddd217f57b759192a Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Miguel Rodr=C3=ADguez P=C3=A9rez? <miguel@det.uvigo.gal>
Date: Tue, 14 Jul 2020 18:07:19 -0400
Subject: [PATCH 2/4] cdc_ether: export usbnet_cdc_update_filter

This makes the function avaiable to other drivers, like cdn_ncm.

Signed-off-by: Miguel Rodríguez Pérez <miguel@det.uvigo.gal>
Signed-off-by: Wxcafé <wxcafe@wxcafe.net>
---
 drivers/net/usb/cdc_ether.c | 3 ++-
 include/linux/usb/usbnet.h  | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 2afe258e3648..8c1d61c2cbac 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -63,7 +63,7 @@ static const u8 mbm_guid[16] = {
 	0xa6, 0x07, 0xc0, 0xff, 0xcb, 0x7e, 0x39, 0x2a,
 };
 
-static void usbnet_cdc_update_filter(struct usbnet *dev)
+void usbnet_cdc_update_filter(struct usbnet *dev)
 {
 	struct net_device	*net = dev->net;
 
@@ -90,6 +90,7 @@ static void usbnet_cdc_update_filter(struct usbnet *dev)
 			USB_CTRL_SET_TIMEOUT
 		);
 }
+EXPORT_SYMBOL_GPL(usbnet_cdc_update_filter);
 
 /* probes control interface, claims data interface, collects the bulk
  * endpoints, activates data interface (if needed), maybe sets MTU.
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index b0bff3083278..33e7803b85af 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -286,4 +286,5 @@ extern void usbnet_update_max_qlen(struct usbnet *dev);
 extern void usbnet_get_stats64(struct net_device *dev,
 			       struct rtnl_link_stats64 *stats);
 
+extern void usbnet_cdc_update_filter(struct usbnet *);
 #endif /* __LINUX_USB_USBNET_H */
-- 
2.27.0

-- 
Wxcafé <wxcafe@wxcafe.net>

