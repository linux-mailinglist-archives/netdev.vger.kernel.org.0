Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABF92A4FFD
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgKCTWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:22:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgKCTWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 14:22:31 -0500
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68D8B21D91;
        Tue,  3 Nov 2020 19:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604431351;
        bh=tQk7Liv7Ew6R+yA2uiNFP7Cd8ahfxZciOHKS8EMP/yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvuOzuSCfzqUzozAye1/z2Pwfpwh/m95NdxYhLD5ZP02hEWphaHp7GEWAaTz5Bwm2
         hGuUSUNDup1h9QfeKzmgSrZH6lOzPtHmlNZXj2n/9YSBtKi8cG1jE4r5sgyo0T9QPr
         eioRAvJI0ANZ7O1S/E0tMKccpCTwB0cq9HXRTNlQ=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 1/5] r8152: use generic USB macros to define product table
Date:   Tue,  3 Nov 2020 20:22:22 +0100
Message-Id: <20201103192226.2455-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103192226.2455-1-kabel@kernel.org>
References: <20201103192226.2455-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can now use macros USB_DEVICE_INTERFACE_CLASS and
USB_DEVICE_AND_INTERFACE_INFO to define r8152 product table.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/usb/r8152.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index b1770489aca5..85dda591c838 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6862,20 +6862,12 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 }
 
 #define REALTEK_USB_DEVICE(vend, prod)	\
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
-		       USB_DEVICE_ID_MATCH_INT_CLASS, \
-	.idVendor = (vend), \
-	.idProduct = (prod), \
-	.bInterfaceClass = USB_CLASS_VENDOR_SPEC \
+	USB_DEVICE_INTERFACE_CLASS(vend, prod, USB_CLASS_VENDOR_SPEC) \
 }, \
 { \
-	.match_flags = USB_DEVICE_ID_MATCH_INT_INFO | \
-		       USB_DEVICE_ID_MATCH_DEVICE, \
-	.idVendor = (vend), \
-	.idProduct = (prod), \
-	.bInterfaceClass = USB_CLASS_COMM, \
-	.bInterfaceSubClass = USB_CDC_SUBCLASS_ETHERNET, \
-	.bInterfaceProtocol = USB_CDC_PROTO_NONE
+	USB_DEVICE_AND_INTERFACE_INFO(vend, prod, USB_CLASS_COMM, \
+				      USB_CDC_SUBCLASS_ETHERNET, \
+				      USB_CDC_PROTO_NONE)
 
 /* table of devices that work with this driver */
 static const struct usb_device_id rtl8152_table[] = {
-- 
2.26.2

