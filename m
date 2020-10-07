Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B85E286A25
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgJGVcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728624AbgJGVcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 17:32:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2B1C0613D2
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 14:32:08 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kQH2c-0005qi-UT; Wed, 07 Oct 2020 23:32:07 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 03/17] can: c_can: reg_map_{c,d}_can: mark as __maybe_unused
Date:   Wed,  7 Oct 2020 23:31:45 +0200
Message-Id: <20201007213159.1959308-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007213159.1959308-1-mkl@pengutronix.de>
References: <20201007213159.1959308-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch marks the arrays reg_map_c_can and reg_map_d_can as __maybe_unused,
as they are indeed unused in the c_can driver. This warning shows up, when
compiling the kernel with "W=1":

    drivers/net/can/c_can/c_can.c:45:
    drivers/net/can/c_can/c_can.h:124:18: warning: ‘reg_map_d_can’ defined but not used [-Wunused-const-variable=]
    drivers/net/can/c_can/c_can.h:84:18: warning: ‘reg_map_c_can’ defined but not used [-Wunused-const-variable=]

Link: http://lore.kernel.org/r/20201006203748.1750156-4-mkl@pengutronix.de
Fixes: 33f810097769 ("can: c_can: Move overlay structure to array with offset as index")
Fixes: 69927fccd96b ("can: c_can: Add support for Bosch D_CAN controller")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index d5567a7c1c6d..92213d3d96eb 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -81,7 +81,7 @@ enum reg {
 	C_CAN_FUNCTION_REG,
 };
 
-static const u16 reg_map_c_can[] = {
+static const u16 __maybe_unused reg_map_c_can[] = {
 	[C_CAN_CTRL_REG]	= 0x00,
 	[C_CAN_STS_REG]		= 0x02,
 	[C_CAN_ERR_CNT_REG]	= 0x04,
@@ -121,7 +121,7 @@ static const u16 reg_map_c_can[] = {
 	[C_CAN_MSGVAL2_REG]	= 0xB2,
 };
 
-static const u16 reg_map_d_can[] = {
+static const u16 __maybe_unused reg_map_d_can[] = {
 	[C_CAN_CTRL_REG]	= 0x00,
 	[C_CAN_CTRL_EX_REG]	= 0x02,
 	[C_CAN_STS_REG]		= 0x04,
-- 
2.28.0

