Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6342A5967
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbgKCWHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731418AbgKCWG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:06:56 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADF4C061A4E
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 14:06:54 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ka4S4-0006Ui-C4; Tue, 03 Nov 2020 23:06:52 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 25/27] can: flexcan: add ECC initialization for LX2160A
Date:   Tue,  3 Nov 2020 23:06:34 +0100
Message-Id: <20201103220636.972106-26-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103220636.972106-1-mkl@pengutronix.de>
References: <20201103220636.972106-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

After double check with Layerscape CAN owner (Pankaj Bansal), confirm
that LX2160A indeed supports ECC feature, so correct the feature table.

For SoCs with ECC supported, even use FLEXCAN_QUIRK_DISABLE_MECR quirk to
disable non-correctable errors interrupt and freeze mode, had better use
FLEXCAN_QUIRK_SUPPORT_ECC quirk to initialize all memory.

Fixes: 2c19bb43e5572 ("can: flexcan: add lx2160ar1 support")
Cc: Pankaj Bansal <pankaj.bansal@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Link: https://lore.kernel.org/r/20201020155402.30318-5-qiangqing.zhang@nxp.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 586e1417a697..c2330eab3595 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -217,7 +217,7 @@
  *   MX8MP FlexCAN3  03.00.17.01    yes       yes        no      yes       yes          yes
  *   VF610 FlexCAN3  ?               no       yes        no      yes       yes?          no
  * LS1021A FlexCAN2  03.00.04.00     no       yes        no       no       yes           no
- * LX2160A FlexCAN3  03.00.23.00     no       yes        no       no       yes          yes
+ * LX2160A FlexCAN3  03.00.23.00     no       yes        no      yes       yes          yes
  *
  * Some SOCs do not have the RX_WARN & TX_WARN interrupt line connected.
  */
@@ -411,7 +411,8 @@ static const struct flexcan_devtype_data fsl_ls1021a_r2_devtype_data = {
 static const struct flexcan_devtype_data fsl_lx2160a_r1_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_SUPPORT_FD,
+		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_SUPPORT_FD |
+		FLEXCAN_QUIRK_SUPPORT_ECC,
 };
 
 static const struct can_bittiming_const flexcan_bittiming_const = {
-- 
2.28.0

