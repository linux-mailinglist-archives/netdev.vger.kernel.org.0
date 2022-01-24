Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12020498770
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244812AbiAXSAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244809AbiAXSAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:00:01 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF51C061747
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:00:01 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nC3dH-0005Ag-Pj
        for netdev@vger.kernel.org; Mon, 24 Jan 2022 18:59:59 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A7CDF210AA
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 17:59:56 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 613D32108C;
        Mon, 24 Jan 2022 17:59:56 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 3e162d36;
        Mon, 24 Jan 2022 17:59:56 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 4/5] can: tcan4x5x: regmap: fix max register value
Date:   Mon, 24 Jan 2022 18:59:54 +0100
Message-Id: <20220124175955.3464134-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124175955.3464134-1-mkl@pengutronix.de>
References: <20220124175955.3464134-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MRAM of the tcan4x5x has a size of 2K and starts at 0x8000. There
are no further registers in the tcan4x5x making 0x87fc the biggest
addressable register.

This patch fixes the max register value of the regmap config from
0x8ffc to 0x87fc.

Fixes: 6e1caaf8ed22 ("can: tcan4x5x: fix max register value")
Link: https://lore.kernel.org/all/20220119064011.2943292-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/tcan4x5x-regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
index ca80dbaf7a3f..26e212b8ca7a 100644
--- a/drivers/net/can/m_can/tcan4x5x-regmap.c
+++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
@@ -12,7 +12,7 @@
 #define TCAN4X5X_SPI_INSTRUCTION_WRITE (0x61 << 24)
 #define TCAN4X5X_SPI_INSTRUCTION_READ (0x41 << 24)
 
-#define TCAN4X5X_MAX_REGISTER 0x8ffc
+#define TCAN4X5X_MAX_REGISTER 0x87fc
 
 static int tcan4x5x_regmap_gather_write(void *context,
 					const void *reg, size_t reg_len,
-- 
2.34.1


