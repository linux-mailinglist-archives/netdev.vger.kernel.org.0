Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 982F93978F
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731309AbfFGVQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:16:07 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58693 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731221AbfFGVPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 17:15:50 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <mkl@pengutronix.de>)
        id 1hZMDE-00006I-Ju; Fri, 07 Jun 2019 23:15:48 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Anssi Hannula <anssi.hannula@bitwise.fi>,
        Shubhrajyoti Datta <shubhrajyoti.datta@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3/9] can: xilinx_can: use correct bittiming_const for CAN FD core
Date:   Fri,  7 Jun 2019 23:15:35 +0200
Message-Id: <20190607211541.16095-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190607211541.16095-1-mkl@pengutronix.de>
References: <20190607211541.16095-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anssi Hannula <anssi.hannula@bitwise.fi>

Commit 9e5f1b273e6a ("can: xilinx_can: add support for Xilinx CAN FD
core") added a new can_bittiming_const structure for CAN FD cores that
support larger values for tseg1, tseg2, and sjw than previous Xilinx CAN
cores, but the commit did not actually take that into use.

Fix that.

Tested with CAN FD core on a ZynqMP board.

Fixes: 9e5f1b273e6a ("can: xilinx_can: add support for Xilinx CAN FD core")
Reported-by: Shubhrajyoti Datta <shubhrajyoti.datta@gmail.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Cc: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Shubhrajyoti Datta <shubhrajyoti.datta@gmail.com>
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/xilinx_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index f2024404b8d6..63203ff452b5 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1435,7 +1435,7 @@ static const struct xcan_devtype_data xcan_canfd_data = {
 		 XCAN_FLAG_RXMNF |
 		 XCAN_FLAG_TX_MAILBOXES |
 		 XCAN_FLAG_RX_FIFO_MULTI,
-	.bittiming_const = &xcan_bittiming_const,
+	.bittiming_const = &xcan_bittiming_const_canfd,
 	.btr_ts2_shift = XCAN_BTR_TS2_SHIFT_CANFD,
 	.btr_sjw_shift = XCAN_BTR_SJW_SHIFT_CANFD,
 	.bus_clk_name = "s_axi_aclk",
-- 
2.20.1

