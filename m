Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E1534DA6C
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhC2WWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231928AbhC2WVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:21:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FC876196E;
        Mon, 29 Mar 2021 22:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056509;
        bh=Z9wWLHsGHt21P8puljHuk63i5M/sIAFknRTpJamjAP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=shQRLkIXwUdA5pQONhWlQY8O1GGSvCXx1o6zU8RA97tl2ikfzj0xhy1htHNfpUHgi
         fgkcmYiAqKlC6pTT+F1N5rSreWHx4fGFc9c1n6+F0b3vEW3vu6QdBDDkEthqIcTHQt
         ftNKst4KuwSxp3Zm5ReRK48ZBv+on/WmxhvRY7672M1SOH9yT+CzW/Jqh+a9hKiomP
         7T+1hI/kEML1DLW1VvYLWIiuJ/ImzcZ8nlqhhwS1geQ3MMeJ4vkwN44GZd8WKCmC72
         ceJu+CLpGVvXLIRLj2OQZaHuczXlo0ws4ekP9m/QbaBwti0v8Bc3R8W9qN/yOzq3GF
         40RszT/knqDyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 12/38] can: kvaser_usb: Add support for USBcan Pro 4xHS
Date:   Mon, 29 Mar 2021 18:21:07 -0400
Message-Id: <20210329222133.2382393-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit 7507479c46b120c37ef83e59be7683a526e98e1a ]

Add support for Kvaser USBcan Pro 4xHS.

Link: https://lore.kernel.org/r/20210309091724.31262-2-jimmyassarsson@gmail.com
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/Kconfig                      | 1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
index c1e5d5b570b6..538f4d9adb91 100644
--- a/drivers/net/can/usb/Kconfig
+++ b/drivers/net/can/usb/Kconfig
@@ -73,6 +73,7 @@ config CAN_KVASER_USB
 	    - Kvaser Memorator Pro 5xHS
 	    - Kvaser USBcan Light 4xHS
 	    - Kvaser USBcan Pro 2xHS v2
+	    - Kvaser USBcan Pro 4xHS
 	    - Kvaser USBcan Pro 5xHS
 	    - Kvaser U100
 	    - Kvaser U100P
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index e2d58846c40c..073c4a39e718 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -86,8 +86,9 @@
 #define USB_U100_PRODUCT_ID			273
 #define USB_U100P_PRODUCT_ID			274
 #define USB_U100S_PRODUCT_ID			275
+#define USB_USBCAN_PRO_4HS_PRODUCT_ID		276
 #define USB_HYDRA_PRODUCT_ID_END \
-	USB_U100S_PRODUCT_ID
+	USB_USBCAN_PRO_4HS_PRODUCT_ID
 
 static inline bool kvaser_is_leaf(const struct usb_device_id *id)
 {
@@ -193,6 +194,7 @@ static const struct usb_device_id kvaser_usb_table[] = {
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100P_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100S_PRODUCT_ID) },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_PRO_4HS_PRODUCT_ID) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, kvaser_usb_table);
-- 
2.30.1

