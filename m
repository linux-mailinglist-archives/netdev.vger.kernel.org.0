Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7F43B61EA
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 16:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbhF1OkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 10:40:21 -0400
Received: from mout01.posteo.de ([185.67.36.65]:57321 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234570AbhF1OiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 10:38:25 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 1726924002B
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 16:35:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1624890958; bh=ALDlTvxIe3ykDRTBGondySmeGFvUACUQLrZIeO34JYs=;
        h=From:To:Subject:Date:From;
        b=Z82Qj8XVIYx9pVADLNH6dDGRL9o9jQ4VD89CQUqEHpkG04pf/6X6ErssxBzWIz8hs
         38cZ5tF1D8lae2+GhWQIuaQwGZOEfT5hfO4PDKL0/FI5PYA3xQG+7YFs8xtmTECPU8
         l1+bhlP0c5sxFjM9y3UMo44j9Wgtqz2FXbzzOaBST18IYkoQLfKvzq0clOi1RXdVXn
         IOzN9rGDsVowzBMMiqpfXCrPh0ss7aXnMynBJtkwcNq+qTeZgrVM6XSgbfgT0F+RQX
         l96aBG3UbGwWDUtTsZwjquIqv7/SdpQzZug39YLIR+oAoe41YcwQVCojwX8rmt5pUX
         2zIoVl9IogaNA==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4GD9C115qsz9rxM;
        Mon, 28 Jun 2021 16:35:57 +0200 (CEST)
From:   Marco De Marco <marco.demarco@posteo.net>
To:     johan@kernel.org, linux-usb@vger.kernel.org, bjorn@mork.no,
        netdev@vger.kernel.org
Subject: [PATCH] usb: net: Add support for u-blox LARA-R6 modules family
Date:   Mon, 28 Jun 2021 14:35:56 +0000
Message-ID: <4911218.dTlGXAFRqV@mars>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for u-blox LARA-R6 modules family.

Signed-off-by: Marco De Marco <marco.demarco@posteo.net>

---

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index d08e1de26..cb92c7c1e 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1115,6 +1115,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x05c6, 0x9083, 3)},
 	{QMI_FIXED_INTF(0x05c6, 0x9084, 4)},
 	{QMI_FIXED_INTF(0x05c6, 0x90b2, 3)},    /* ublox R410M */
+	{QMI_QUIRK_SET_DTR(0x05c6, 0x90fA, 3)}, /* ublox R6XX  */
 	{QMI_FIXED_INTF(0x05c6, 0x920d, 0)},
 	{QMI_FIXED_INTF(0x05c6, 0x920d, 5)},
 	{QMI_QUIRK_SET_DTR(0x05c6, 0x9625, 4)},	/* YUGA CLM920-NC5 */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index aeaa3756f..05d0379c9 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -238,6 +238,7 @@ static void option_instat_callback(struct urb *urb);
 #define QUECTEL_PRODUCT_UC15			0x9090
 /* These u-blox products use Qualcomm's vendor ID */
 #define UBLOX_PRODUCT_R410M			0x90b2
+#define UBLOX_PRODUCT_R6XX          0x90FA
 /* These Yuga products use Qualcomm's vendor ID */
 #define YUGA_PRODUCT_CLM920_NC5			0x9625
 
@@ -1101,6 +1102,8 @@ static const struct usb_device_id option_ids[] = {
 	/* u-blox products using Qualcomm vendor ID */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R410M),
 	  .driver_info = RSVD(1) | RSVD(3) },
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R6XX),
+	  .driver_info = RSVD(3) },
 	/* Quectel products using Quectel vendor ID */
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC21, 0xff, 0xff, 0xff),
 	  .driver_info = NUMEP2 },



