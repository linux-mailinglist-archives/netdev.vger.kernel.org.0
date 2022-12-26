Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB99656627
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 00:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbiLZXvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 18:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiLZXvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 18:51:11 -0500
Received: from cavan.codon.org.uk (cavan.codon.org.uk [176.126.240.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F244DE7;
        Mon, 26 Dec 2022 15:51:08 -0800 (PST)
Received: from x2100.. (52-119-115-32.PUBLIC.monkeybrains.net [52.119.115.32])
        by cavan.codon.org.uk (Postfix) with ESMTPSA id 5429A424AD;
        Mon, 26 Dec 2022 23:51:06 +0000 (GMT)
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     johan@kernel.org, bjorn@mork.no
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH V2 3/3] USB: serial: option: Add Novatel MiFi 8800L diag endpoint
Date:   Mon, 26 Dec 2022 15:47:51 -0800
Message-Id: <20221226234751.444917-4-mjg59@srcf.ucam.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221226234751.444917-1-mjg59@srcf.ucam.org>
References: <20221226234751.444917-1-mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Novatel MiFi 8800L can be configured into exposing additional
endpoints by sending four bytes of 0s to the HID endpoint it exposes by
default. One of the additional exposed endpoints is a Qualcomm DIAG protocol
interface. Add the information for that in order to allow it to be used.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
---
 drivers/usb/serial/option.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 5025810db8c9..40a4ccb888f9 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -161,6 +161,7 @@ static void option_instat_callback(struct urb *urb);
 #define NOVATELWIRELESS_PRODUCT_U620L		0x9022
 #define NOVATELWIRELESS_PRODUCT_G2		0xA010
 #define NOVATELWIRELESS_PRODUCT_MC551		0xB001
+#define NOVATELWIRELESS_PRODUCT_8800L		0xB023
 
 #define UBLOX_VENDOR_ID				0x1546
 
@@ -1055,6 +1056,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_E362, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_E371, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_U620L, 0xff, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_8800L, 0xff, 0xff, 0xff) },
 
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01A) },
-- 
2.38.1

