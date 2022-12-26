Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9107656626
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 00:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbiLZXvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 18:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiLZXvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 18:51:10 -0500
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64443DDD;
        Mon, 26 Dec 2022 15:51:05 -0800 (PST)
Received: from x2100.. (52-119-115-32.PUBLIC.monkeybrains.net [52.119.115.32])
        by cavan.codon.org.uk (Postfix) with ESMTPSA id AF080424AA;
        Mon, 26 Dec 2022 23:51:02 +0000 (GMT)
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     johan@kernel.org, bjorn@mork.no
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Matthew Garrett <mgarrett@aurora.tech>
Subject: [PATCH V2 1/3] USB: serial: option: Add generic MDM9207 configurations
Date:   Mon, 26 Dec 2022 15:47:49 -0800
Message-Id: <20221226234751.444917-2-mjg59@srcf.ucam.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221226234751.444917-1-mjg59@srcf.ucam.org>
References: <20221226234751.444917-1-mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,KHOP_HELO_FCRDNS,SPF_HELO_NEUTRAL,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Orbic Speed RC400L presents as a generic MDM9207 device that supports
multiple configurations. Add support for the two that expose a set of serial
ports.

Signed-off-by: Matthew Garrett <mgarrett@aurora.tech>
---
 drivers/usb/serial/option.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index dee79c7d82d5..5025810db8c9 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1119,6 +1119,12 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x0023)}, /* ONYX 3G device */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x9000), /* SIMCom SIM5218 */
 	  .driver_info = NCTRL(0) | NCTRL(1) | NCTRL(2) | NCTRL(3) | RSVD(4) },
+	/* Qualcomm MDM9207 - 0: DIAG, 1: modem, 2: AT, 3: NMEA, 4: adb, 5: QMI */
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0xf601),
+	  .driver_info = RSVD(4) | RSVD(5) },
+	/* Qualcomm MDM9207 - 0,1: RNDIS, 2: DIAG, 3: modem, 4: AT, 5: NMEA, 6: adb */
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0xf622),
+	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
 	/* Quectel products using Qualcomm vendor ID */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, QUECTEL_PRODUCT_UC15)},
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, QUECTEL_PRODUCT_UC20),
-- 
2.38.1

