Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CA12ECD42
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbhAGJvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727283AbhAGJvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AE0C0612A8
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:49:58 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kxRvZ-0001A9-3z
        for netdev@vger.kernel.org; Thu, 07 Jan 2021 10:49:57 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6B7695BBA9B
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:49:07 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9D8E75BBA1E;
        Thu,  7 Jan 2021 09:49:02 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bac80afb;
        Thu, 7 Jan 2021 09:49:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>, Sean Nyekjaer <sean@geanix.com>
Subject: [net-next 08/19] can: tcan4x5x: rename regmap_spi_gather_write() -> tcan4x5x_regmap_gather_write()
Date:   Thu,  7 Jan 2021 10:48:49 +0100
Message-Id: <20210107094900.173046-9-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107094900.173046-1-mkl@pengutronix.de>
References: <20210107094900.173046-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch renames the regmap_spi_gather_write() function to
tcan4x5x_regmap_gather_write(). Now it has a "tcan4x5x_" prefix as all other
functions in this driver.

Reviewed-by: Dan Murphy <dmurphy@ti.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20201215231746.1132907-9-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/tcan4x5x-regmap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
index 8905fc36b00a..8f718f4395c3 100644
--- a/drivers/net/can/m_can/tcan4x5x-regmap.c
+++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
@@ -14,9 +14,9 @@
 
 #define TCAN4X5X_MAX_REGISTER 0x8fff
 
-static int regmap_spi_gather_write(void *context, const void *reg,
-				   size_t reg_len, const void *val,
-				   size_t val_len)
+static int tcan4x5x_regmap_gather_write(void *context, const void *reg,
+					size_t reg_len, const void *val,
+					size_t val_len)
 {
 	struct device *dev = context;
 	struct spi_device *spi = to_spi_device(dev);
@@ -41,7 +41,7 @@ static int tcan4x5x_regmap_write(void *context, const void *data, size_t count)
 	u16 *reg = (u16 *)(data);
 	const u32 *val = data + 4;
 
-	return regmap_spi_gather_write(context, reg, 4, val, count - 4);
+	return tcan4x5x_regmap_gather_write(context, reg, 4, val, count - 4);
 }
 
 static int tcan4x5x_regmap_read(void *context,
@@ -65,7 +65,7 @@ static const struct regmap_config tcan4x5x_regmap = {
 
 static const struct regmap_bus tcan4x5x_bus = {
 	.write = tcan4x5x_regmap_write,
-	.gather_write = regmap_spi_gather_write,
+	.gather_write = tcan4x5x_regmap_gather_write,
 	.read = tcan4x5x_regmap_read,
 	.reg_format_endian_default = REGMAP_ENDIAN_NATIVE,
 	.val_format_endian_default = REGMAP_ENDIAN_NATIVE,
-- 
2.29.2


