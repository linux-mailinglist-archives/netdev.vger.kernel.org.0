Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31E22FE519
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 09:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbhAUIf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 03:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727653AbhAUIfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 03:35:03 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2BAC061575;
        Thu, 21 Jan 2021 00:34:17 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id o18so976612qtp.10;
        Thu, 21 Jan 2021 00:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hMOAJyfPO68mVIjv580xYZQF8xaJ8E997+OoMF8/OQI=;
        b=m6v+CB1tAJROh1IfPBd3d0qoHGG9tXhZJgICBYrpTkiUHcqor0trYUvUjERJX3duTX
         b5ah/EJjECkOvsZpG82MOxLYWCjDT4ILuovxZWCwqC8RIc9XZBC/SQQSqO7MuPpsxFqb
         i1t3aQlyLYA+vu5GqiWvwFVVGdSf2Wa8v4x4ymosLFDl+mRPx9Eq/cCQJlovfG1lSLzh
         UtJB2FPExquH5rhjeXsRtlT73xw7UUWArgap6isYreLCrQvYDtuwWJrZ9fCtnNRLpr5+
         eQcqbLE3XCMl680j/PdcFymDPLU7veM86EGO1R2jjJAzIrRLTBdQt8OBl47TB+TkGhr8
         Siwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hMOAJyfPO68mVIjv580xYZQF8xaJ8E997+OoMF8/OQI=;
        b=CtzSMYsj+tCIUps06/kc7aNDr22VQnEvfLj3ZQU86GBsdeggPAEamusZ9BHFEwWkl5
         +XAVT+jqCA2MdT5VUs1+UkS58ScBM6ehODCLXKBTKmGaF6TU6LTI/smpxJtg/BqbaLGe
         WmDwjzrP4y0lxNiLFVciQasN6n/VOpotBZkYd4RZPGoGNAc/Bl8+H+9bRE6DrbhQXGxp
         IGWBLlB/wTXZnKQs8MfSB7Sqt6tWuxbaKFsk+zG8BmIfqL6CqQBhLq0kzdOVjDkwF69o
         atd81R6Q6iqXSlJl8v5eBHYfEo8dbqOLnE9oneCbvzIL70fooM6hEQVT1rkG78/hahQ9
         RQBg==
X-Gm-Message-State: AOAM532gVa8uW06ACaxQLExWabcsEsol3vLvvUJbP6FHFPFbx2vvec3H
        pnnvvqv4KvdT2GyZgyk4guo=
X-Google-Smtp-Source: ABdhPJwNQQUh5RWU6qcVZEFDjxxzztzm7rOUWZ9CI1Oz0N+6tyLmkA2oEWaBnkJ8c93skU7BAFnlmA==
X-Received: by 2002:ac8:4f43:: with SMTP id i3mr9092551qtw.140.1611218056570;
        Thu, 21 Jan 2021 00:34:16 -0800 (PST)
Received: from localhost.localdomain ([45.32.7.59])
        by smtp.gmail.com with ESMTPSA id e185sm2343003qkb.127.2021.01.21.00.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 00:34:15 -0800 (PST)
From:   Su Yanjun <suyanjun218@gmail.com>
To:     mkl@pengutronix.de, manivannan.sadhasivam@linaro.org,
        thomas.kopp@microchip.com, wg@grandegger.com, davem@davemloft.net,
        kuba@kernel.org, lgirdwood@gmail.com, broonie@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Su Yanjun <suyanjun218@gmail.com>
Subject: [PATCH v1] can: mcp251xfd: replace sizeof(u32) with val_bytes in regmap
Date:   Thu, 21 Jan 2021 16:33:13 +0800
Message-Id: <20210121083313.71296-1-suyanjun218@gmail.com>
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
index f07e8b737d31..cc48ccee4694 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -181,6 +181,12 @@ static int mcp251xfd_clks_and_vdd_disable(const struct mcp251xfd_priv *priv)
 	return 0;
 }
 
+static inline int
+mcp251xfd_get_val_bytes(const struct mcp251xfd_priv *priv)
+{
+	return priv->map_reg->format.val_bytes;
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

