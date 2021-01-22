Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0032FFDFD
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 09:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbhAVIPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 03:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbhAVIO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 03:14:59 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE203C061786;
        Fri, 22 Jan 2021 00:14:15 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id v126so4342878qkd.11;
        Fri, 22 Jan 2021 00:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j9WFwnkI02ep3Zjvdj1Uqy/+MDbNFHZwwnPFmhXv7IQ=;
        b=DKU52w2ZIfEETZOzXJtm56X6DbLG+6QwWX/dvJfo9NmvEb4stLQ6yoavYmnGjsd32X
         ETvu2q5JkphB/v5duewNkzzCljIYTjZeaQa6rQA2OuyD5ISzTng/4futdSrfwqNbm96V
         htXB3w2xu4LuedJMUMWKDo1OsrWKhelihDWYSmUlZUMyaGdxLDFdLkOV0k5ba3XC9IDr
         h10GAzMbaumbSBeVHlhyhS48ACmo5Thn6ouI5E2B0IvdQnaRn3qwdUCOdqgCH/quXBql
         BBu7TpOZPGCjqsITiwqrCcFn7Do3PitR4N27TcvMf6qlzcDuz4b/3YKn+7DK6QBAwuuk
         mNaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j9WFwnkI02ep3Zjvdj1Uqy/+MDbNFHZwwnPFmhXv7IQ=;
        b=njEFtrfWYy/khxp5olI+qhEB/H7R7s/XKgE2OLlMCTitf4O2AcLIDOgEqN8CSB3zfv
         tQyVmNEpo8WntHt7OmEi6/DtxO6OlO9gVaoltgUj0CytHailXvSn8KcopXq0exSphDgc
         TXUaRhBDGHQPLKAa1DuMYNlajlatC7mbIPxxgijbB4y9Aur2gCC9JRGLfxaEx0QxNyeD
         roZlmq9mzZSSxj0baDoV3ksLbEvhh6eJ95QTQjD+f558jmCKMnDudNR2dCRUEuSFXwtP
         R7nEzdJTAivISJ3aKPYTXkrbts6KoRAWtpKBw63+xSybPh+U/vN26GWKaPt/fgQ5V9Tb
         8uuw==
X-Gm-Message-State: AOAM531drjrSVIr5HG6DPMWhI+UHwxlhaKt4+00p2sN8K9gmwiPw8Jfw
        cfvMpLR/Un+olfvC71M5K+U=
X-Google-Smtp-Source: ABdhPJwrz4ohm9c7mWJB6FvpHRMBPQ0ca5ylqR8DG8B3GsDLaNh/RDdVFjvZ512SJvpF8dkHLJrMYA==
X-Received: by 2002:a05:620a:f92:: with SMTP id b18mr3765133qkn.146.1611303255275;
        Fri, 22 Jan 2021 00:14:15 -0800 (PST)
Received: from localhost.localdomain ([45.32.7.59])
        by smtp.gmail.com with ESMTPSA id y25sm5751624qky.14.2021.01.22.00.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 00:14:14 -0800 (PST)
From:   Su Yanjun <suyanjun218@gmail.com>
To:     mkl@pengutronix.de, manivannan.sadhasivam@linaro.org,
        thomas.kopp@microchip.com, wg@grandegger.com, davem@davemloft.net,
        kuba@kernel.org, lgirdwood@gmail.com, broonie@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Su Yanjun <suyanjun218@gmail.com>
Subject: [PATCH v4] can: mcp251xfd: replace sizeof(u32) with val_bytes in regmap
Date:   Fri, 22 Jan 2021 16:13:34 +0800
Message-Id: <20210122081334.213957-1-suyanjun218@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sizeof(u32) is hardcoded. It's better to use the config value in
regmap.

It increases the size of target object, but it's flexible when new mcp chip
need other val_bytes.

Signed-off-by: Su Yanjun <suyanjun218@gmail.com>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index f07e8b737d31..3dde52669343 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1308,6 +1308,7 @@ mcp251xfd_tef_obj_read(const struct mcp251xfd_priv *priv,
 		       const u8 offset, const u8 len)
 {
 	const struct mcp251xfd_tx_ring *tx_ring = priv->tx;
+	int val_bytes = regmap_get_val_bytes(priv->map_rx);
 
 	if (IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY) &&
 	    (offset > tx_ring->obj_num ||
@@ -1322,7 +1323,7 @@ mcp251xfd_tef_obj_read(const struct mcp251xfd_priv *priv,
 	return regmap_bulk_read(priv->map_rx,
 				mcp251xfd_get_tef_obj_addr(offset),
 				hw_tef_obj,
-				sizeof(*hw_tef_obj) / sizeof(u32) * len);
+				sizeof(*hw_tef_obj) / val_bytes * len);
 }
 
 static int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
@@ -1511,11 +1512,12 @@ mcp251xfd_rx_obj_read(const struct mcp251xfd_priv *priv,
 		      const u8 offset, const u8 len)
 {
 	int err;
+	int val_bytes = regmap_get_val_bytes(priv->map_rx);
 
 	err = regmap_bulk_read(priv->map_rx,
 			       mcp251xfd_get_rx_obj_addr(ring, offset),
 			       hw_rx_obj,
-			       len * ring->obj_size / sizeof(u32));
+			       len * ring->obj_size / val_bytes);
 
 	return err;
 }
@@ -2139,6 +2141,7 @@ static irqreturn_t mcp251xfd_irq(int irq, void *dev_id)
 	struct mcp251xfd_priv *priv = dev_id;
 	irqreturn_t handled = IRQ_NONE;
 	int err;
+	int val_bytes = regmap_get_val_bytes(priv->map_reg);
 
 	if (priv->rx_int)
 		do {
@@ -2162,7 +2165,7 @@ static irqreturn_t mcp251xfd_irq(int irq, void *dev_id)
 		err = regmap_bulk_read(priv->map_reg, MCP251XFD_REG_INT,
 				       &priv->regs_status,
 				       sizeof(priv->regs_status) /
-				       sizeof(u32));
+				       val_bytes);
 		if (err)
 			goto out_fail;
 
-- 
2.25.1

