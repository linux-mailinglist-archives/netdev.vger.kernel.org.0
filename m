Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443D5655E49
	for <lists+netdev@lfdr.de>; Sun, 25 Dec 2022 22:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiLYVCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 16:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiLYVCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 16:02:00 -0500
Received: from cavan.codon.org.uk (cavan.codon.org.uk [176.126.240.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4D02DEE;
        Sun, 25 Dec 2022 13:01:54 -0800 (PST)
Received: from x2100.. (unknown [IPv6:2607:f598:b99a:480:2da1:ebcf:44f5:35ad])
        by cavan.codon.org.uk (Postfix) with ESMTPSA id 964D8424AB;
        Sun, 25 Dec 2022 20:52:44 +0000 (GMT)
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     johan@kernel.org, bjorn@mork.no
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Matthew Garrett <mgarrett@aurora.tech>
Subject: [PATCH 1/3] USB: serial: option: Add generic MDM9207 configurations
Date:   Sun, 25 Dec 2022 12:52:22 -0800
Message-Id: <20221225205224.270787-2-mjg59@srcf.ucam.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221225205224.270787-1-mjg59@srcf.ucam.org>
References: <20221225205224.270787-1-mjg59@srcf.ucam.org>
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

The Orbic Speed RC400L presents as a generic MDM9207 device that supports
multiple configurations. Add support for the two that expose a set of serial
ports.

Signed-off-by: Matthew Garrett <mgarrett@aurora.tech>
---
 drivers/usb/serial/option.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index dee79c7d82d5..edbb6054de91 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1119,6 +1119,12 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x0023)}, /* ONYX 3G device */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x9000), /* SIMCom SIM5218 */
 	  .driver_info = NCTRL(0) | NCTRL(1) | NCTRL(2) | NCTRL(3) | RSVD(4) },
+	/* Qualcomm MDM9207 - 0: DIAG, 2: AT, 3: NMEA */
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0xf601),
+	  .driver_info = RSVD(1) | RSVD(4) | RSVD(5) },
+	/* Qualcomm MDM9207 - 2: DIAG, 4: AT, 5: NMEA */
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0xf622),
+	  .driver_info = RSVD(0) | RSVD(1) | RSVD(3) | RSVD(6) },
 	/* Quectel products using Qualcomm vendor ID */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, QUECTEL_PRODUCT_UC15)},
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, QUECTEL_PRODUCT_UC20),
-- 
2.38.1

