Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC6F2211C6
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgGOP5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:57:18 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:38769 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgGOP5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:57:17 -0400
Received: from cwh (fob.gandi.net [217.70.181.1])
        (Authenticated sender: wxcafe@wxcafe.net)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id D362010001A;
        Wed, 15 Jul 2020 15:57:14 +0000 (UTC)
Message-ID: <5de5aa7b8a3c78b2772551601223f5b807e4e38a.camel@wxcafe.net>
Subject: [PATCH 4/4] cdc_ncm: hook into set_rx_mode to admit multicast
 traffic
From:   =?ISO-8859-1?Q?Wxcaf=E9?= <wxcafe@wxcafe.net>
To:     linux-usb@vger.kernel.org
Cc:     Miguel =?ISO-8859-1?Q?Rodr=EDguez_P=E9rez?= 
        <miguel@det.uvigo.gal>, oliver@neukum.org, netdev@vger.kernel.org
Date:   Wed, 15 Jul 2020 11:57:11 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From 8094e9fbdcfe9ae983ad74fc509cee9930a1ee64 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Miguel Rodr=C3=ADguez P=C3=A9rez? <miguel@det.uvigo.gal>
Date: Tue, 14 Jul 2020 18:12:59 -0400
Subject: [PATCH 4/4] cdc_ncm: hook into set_rx_mode to admit multicast traffic

We set set_rx_mode to usbnet_cdc_update_filter provided
by cdc_ether that simply admits all multicast traffic
if there is more than one multicast filter configured.

Signed-off-by: Miguel Rodríguez Pérez <miguel@det.uvigo.gal>
Signed-off-by: Wxcafé <wxcafe@wxcafe.net>
---
 drivers/net/usb/cdc_ncm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 2abaf5f8b23b..c58aae2c90d1 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1888,6 +1888,7 @@ static const struct driver_info cdc_ncm_info = {
 	.status = cdc_ncm_status,
 	.rx_fixup = cdc_ncm_rx_fixup,
 	.tx_fixup = cdc_ncm_tx_fixup,
+	.set_rx_mode = usbnet_cdc_update_filter,
 };
 
 /* Same as cdc_ncm_info, but with FLAG_WWAN */
@@ -1901,6 +1902,7 @@ static const struct driver_info wwan_info = {
 	.status = cdc_ncm_status,
 	.rx_fixup = cdc_ncm_rx_fixup,
 	.tx_fixup = cdc_ncm_tx_fixup,
+	.set_rx_mode = usbnet_cdc_update_filter,
 };
 
 /* Same as wwan_info, but with FLAG_NOARP  */
@@ -1914,6 +1916,7 @@ static const struct driver_info wwan_noarp_info = {
 	.status = cdc_ncm_status,
 	.rx_fixup = cdc_ncm_rx_fixup,
 	.tx_fixup = cdc_ncm_tx_fixup,
+	.set_rx_mode = usbnet_cdc_update_filter,
 };
 
 static const struct usb_device_id cdc_devs[] = {
-- 
2.27.0

-- 
Wxcafé <wxcafe@wxcafe.net>

