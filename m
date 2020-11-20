Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E6A2BAB7B
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgKTNo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgKTNo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:44:58 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CDDC0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:44:58 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6iU-0000F3-GL; Fri, 20 Nov 2020 14:44:46 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     linux-can@vger.kernel.org, kernel@pengutronix.de, kuba@kernel.org,
        davem@davemloft.net, Kaixu Xia <kaixuxia@tencent.com>,
        Tosk Robot <tencent_os_robot@tencent.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 25/25] can: mcp251xfd: remove useless code in mcp251xfd_chip_softreset
Date:   Fri, 20 Nov 2020 14:44:28 +0100
Message-Id: <20201120134428.3430191-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120133318.3428231-1-mkl@pengutronix.de>
References: <20201120133318.3428231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

It would directly return if the variable err equals to 0 or other errors.
Only when the err equals to -ETIMEDOUT it can reach the 'if (err)'
statement, so the 'if (err)' and last 'return -ETIMEDOUT' statements are
useless. Romove them.

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Link: https://lore.kernel.org/r/1605605352-25298-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
Hello,

I had to manually resend the patch, as it was lost for unknown reasons.

regards,
Marc

 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index afa8cfc729b5..3297eb7ecc9c 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -644,10 +644,7 @@ static int mcp251xfd_chip_softreset(const struct mcp251xfd_priv *priv)
 		return 0;
 	}
 
-	if (err)
-		return err;
-
-	return -ETIMEDOUT;
+	return err;
 }
 
 static int mcp251xfd_chip_clock_init(const struct mcp251xfd_priv *priv)
-- 
2.29.2

