Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF70E3F1AA3
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240254AbhHSNkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240200AbhHSNkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:40:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD0CC061796
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:39:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGiGS-0004PE-Qt
        for netdev@vger.kernel.org; Thu, 19 Aug 2021 15:39:24 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 875E366A810
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 13:39:22 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1490766A7FC;
        Thu, 19 Aug 2021 13:39:20 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id addc6840;
        Thu, 19 Aug 2021 13:39:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 07/22] can: etas_es58x: clean-up documentation of struct es58x_fd_tx_conf_msg
Date:   Thu, 19 Aug 2021 15:38:58 +0200
Message-Id: <20210819133913.657715-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210819133913.657715-1-mkl@pengutronix.de>
References: <20210819133913.657715-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The documentation of struct es58x_fd_tx_conf_msg explains in details
the different TDC parameters. However, those description are redundant
with the documentation of struct can_tdc.

Remove most of the description.

Also, fixes a typo in the reference to the datasheet (E701 -> E70).

Link: https://lore.kernel.org/r/20210815033248.98111-8-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/etas_es58x/es58x_fd.h | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.h b/drivers/net/can/usb/etas_es58x/es58x_fd.h
index ee18a87e40c0..a191891b8777 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_fd.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.h
@@ -96,23 +96,14 @@ struct es58x_fd_bittiming {
  * @ctrlmode: type enum es58x_fd_ctrlmode.
  * @canfd_enabled: boolean (0: Classical CAN, 1: CAN and/or CANFD).
  * @data_bittiming: Bittiming for flexible data-rate transmission.
- * @tdc_enabled: Transmitter Delay Compensation switch (0: disabled,
- *	1: enabled). On very high bitrates, the delay between when the
- *	bit is sent and received on the CANTX and CANRX pins of the
- *	transceiver start to be significant enough for errors to occur
- *	and thus need to be compensated.
- * @tdco: Transmitter Delay Compensation Offset. Offset value, in time
- *	quanta, defining the delay between the start of the bit
- *	reception on the CANRX pin of the transceiver and the SSP
- *	(Secondary Sample Point). Valid values: 0 to 127.
- * @tdcf: Transmitter Delay Compensation Filter window. Defines the
- *	minimum value for the SSP position, in time quanta. The
- *	feature is enabled when TDCF is configured to a value greater
- *	than TDCO. Valid values: 0 to 127.
+ * @tdc_enabled: Transmitter Delay Compensation switch (0: TDC is
+ *	disabled, 1: TDC is enabled).
+ * @tdco: Transmitter Delay Compensation Offset.
+ * @tdcf: Transmitter Delay Compensation Filter window.
  *
- * Please refer to the microcontroller datasheet: "SAM
- * E701/S70/V70/V71 Family" section 49 "Controller Area Network
- * (MCAN)" for additional information.
+ * Please refer to the microcontroller datasheet: "SAM E70/S70/V70/V71
+ * Family" section 49 "Controller Area Network (MCAN)" for additional
+ * information.
  */
 struct es58x_fd_tx_conf_msg {
 	struct es58x_fd_bittiming nominal_bittiming;
-- 
2.32.0


