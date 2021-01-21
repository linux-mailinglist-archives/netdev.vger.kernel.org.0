Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A5F2FE60C
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 10:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbhAUJOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 04:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727249AbhAUJLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 04:11:08 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063A3C0613ED;
        Thu, 21 Jan 2021 01:10:28 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id l14so584653qvh.2;
        Thu, 21 Jan 2021 01:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+h3XO1KHkOJ1WE2lVC/8D0t/DmItYejrYEfvh5uWFfA=;
        b=CefFG/UZeDEyOZR6R1hkPmmASHVpA8OFOj2xdj3iY7d4oQ5ctaUKOQLkEisCJrPe/+
         RK8rKKh0qkgfztY9mZ9gj82lD2fPGlkmWJPhilA2HvvYnxCBwF8o0VI5fWuE/GX2sYnw
         M9ja4/mLLTugc5nmForFBjElcVeFsQQdC+mLclAN6Rmukt9wUtRMp+VAQW2zZK5E5iFM
         wraCd8m4gBTEmDYMjzUn1fm/4ukVUEm8zZB8srJtU6ZYFoOXeAjw8UE6HzZiZNFRj4oT
         0z8AMM2uSB/bA48XUdFEGtLjWXw8IadTltZ36zdh7fj2Xa5XeR0UvUGT66aGrPet04B5
         YUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+h3XO1KHkOJ1WE2lVC/8D0t/DmItYejrYEfvh5uWFfA=;
        b=OUne90d4yzOGoIBc6ya9683FC3PcchXV5+cRpFyIP3/zr+LRm55Cu2smnu2ago/PZ8
         PgYRTsDr7G9Y85lpdUbSQnGJ0hGbD92KG26By2kcnzbPSDoBf8X1C9U0mw8HGORT2rn5
         +5oTBDKyJOTHSnGjoJ4yZCMq/Gh2i+HqCf9uuvBnqQQ+u0l0pVWoZxCZQJRBHBGsIv8f
         qMK6kb8EkEPHAPe2+G+sxlQvr1NSA0Q2YdvAMmv4xVkhGDEUfAX+k+63oPc0xQUMtPED
         GMp0QDkF47AjFnq6PapcV5BoMHB1J7zNTHfxLB3syc+M2+BpsUNG7Tqr70j+KSPHJlTH
         Uz5w==
X-Gm-Message-State: AOAM5310C+cbXHswyS+Ih/YlJlYDlc16tmZ7WgTJoKZW9X35MGMdEpe3
        10GuZibc0g7pBhuSvxWcStk=
X-Google-Smtp-Source: ABdhPJyUlF4d0UezjmzlvVLRM4fC3skEghQEEetNaz4NlKgT6QmXaTfR9rbccpFGIbqyQEvgvUMdMg==
X-Received: by 2002:ad4:5187:: with SMTP id b7mr13655408qvp.2.1611220227359;
        Thu, 21 Jan 2021 01:10:27 -0800 (PST)
Received: from localhost.localdomain ([45.32.7.59])
        by smtp.gmail.com with ESMTPSA id b16sm2903733qtx.85.2021.01.21.01.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 01:10:26 -0800 (PST)
From:   Su Yanjun <suyanjun218@gmail.com>
To:     mkl@pengutronix.de, manivannan.sadhasivam@linaro.org,
        thomas.kopp@microchip.com, wg@grandegger.com, davem@davemloft.net,
        kuba@kernel.org, lgirdwood@gmail.com, broonie@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Su Yanjun <suyanjun218@gmail.com>
Subject: [PATCH v2] can: mcp251xfd: replace sizeof(u32) with val_bytes in regmap
Date:   Thu, 21 Jan 2021 17:10:05 +0800
Message-Id: <20210121091005.74417-1-suyanjun218@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional effect.

Signed-off-by: Su Yanjun <suyanjun218@gmail.com>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index f07e8b737d31..b15bfd50b863 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -181,6 +181,12 @@ static int mcp251xfd_clks_and_vdd_disable(const struct mcp251xfd_priv *priv)
 	return 0;
 }
 
+static inline int
+mcp251xfd_get_val_bytes(const struct mcp251xfd_priv *priv)
+{
+	return regmap_get_val_bytes(priv->map_reg);
+}
+
 static inline u8
 mcp251xfd_cmd_prepare_write_reg(const struct mcp251xfd_priv *priv,
 				union mcp251xfd_write_reg_buf *write_reg_buf,
@@ -1308,6 +1314,7 @@ mcp251xfd_tef_obj_read(const struct mcp251xfd_priv *priv,
 		       const u8 offset, const u8 len)
 {
 	const struct mcp251xfd_tx_ring *tx_ring = priv->tx;
+	int val_bytes = mcp251xfd_get_val_bytes(priv);
 
 	if (IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY) &&
 	    (offset > tx_ring->obj_num ||
@@ -1322,7 +1329,7 @@ mcp251xfd_tef_obj_read(const struct mcp251xfd_priv *priv,
 	return regmap_bulk_read(priv->map_rx,
 				mcp251xfd_get_tef_obj_addr(offset),
 				hw_tef_obj,
-				sizeof(*hw_tef_obj) / sizeof(u32) * len);
+				sizeof(*hw_tef_obj) / val_bytes * len);
 }
 
 static int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
@@ -1511,11 +1518,12 @@ mcp251xfd_rx_obj_read(const struct mcp251xfd_priv *priv,
 		      const u8 offset, const u8 len)
 {
 	int err;
+	int val_bytes = mcp251xfd_get_val_bytes(priv);
 
 	err = regmap_bulk_read(priv->map_rx,
 			       mcp251xfd_get_rx_obj_addr(ring, offset),
 			       hw_rx_obj,
-			       len * ring->obj_size / sizeof(u32));
+			       len * ring->obj_size / val_bytes);
 
 	return err;
 }
@@ -2139,6 +2147,7 @@ static irqreturn_t mcp251xfd_irq(int irq, void *dev_id)
 	struct mcp251xfd_priv *priv = dev_id;
 	irqreturn_t handled = IRQ_NONE;
 	int err;
+	int val_bytes = mcp251xfd_get_val_bytes(priv);
 
 	if (priv->rx_int)
 		do {
@@ -2162,7 +2171,7 @@ static irqreturn_t mcp251xfd_irq(int irq, void *dev_id)
 		err = regmap_bulk_read(priv->map_reg, MCP251XFD_REG_INT,
 				       &priv->regs_status,
 				       sizeof(priv->regs_status) /
-				       sizeof(u32));
+				       val_bytes);
 		if (err)
 			goto out_fail;
 
-- 
2.25.1

