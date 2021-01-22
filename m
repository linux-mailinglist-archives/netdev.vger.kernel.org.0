Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5F42FFAC6
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 04:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbhAVDCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 22:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbhAVDCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 22:02:41 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32B0C061756;
        Thu, 21 Jan 2021 19:02:00 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id e15so3181343qte.9;
        Thu, 21 Jan 2021 19:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kVNLPZX2Is3ycnlzX7A58ZukkRC0VL4VTzXrQJbpzRk=;
        b=fL+zdBfHVyiAg09PtF0vqXHQ0qyVTu9xERSrL3N8odSBV2cTW3NiGUeiFXcObD0tmb
         MbqncBt2+cRNojto+USFf8vLj2mwfbc0RHfqkyeghpw3gLfVRCp0pJK5PwHVhjRl4yV/
         oJB4SQv6OSm0zm0FUQ3GKeN5sYlrDmvQs4/LosJmMwfkYwp8V8nfamJBzh7K7C3kVhSm
         8d514NEmYsy4qBb2R5jEOuX4CvCQ4HdrbBNzELwhzjF1NeBUh9GskoxV89fdUOeyPipk
         n8FV4X7rJjSJfi382M3bS6R6xHFX4qJ51cDkxMM5EICpF4vRo9diQQxU78AtRRME9R3y
         nd7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kVNLPZX2Is3ycnlzX7A58ZukkRC0VL4VTzXrQJbpzRk=;
        b=OaKnUvwsUvj28x5yqUMER+hqal1OrXtWRUV3xeeVagzQ5Hm7ZAgZhKMmanRBR/YIV6
         MwgKXHI5u3WkAtWmZMXjRk/TAki/8no7ZFDsz+s69nUE9Ju0oiOmZUBPOYLsx9pSBtr4
         Br570s5jIGRtW0UmLla/VHzKORP8Jf8KlJZ0siiR+oCCPrezDkWYDf1anUWsQGmFbhFM
         kT67yNIuiEIyKI+RXNh6p+D8Wh+fuWs1jkUY/wKfBYuQOe4UtBA56mlpobpbiEifT7sC
         iqzdbB5dlKSCRXwdNAZvNRMz1pTlGPgnCww6R1xdDSwIfU6JDSYejecdMFDB9v5gU9dP
         kpGA==
X-Gm-Message-State: AOAM532ozpl7CMXJgcCABwKF9B33+4z4hl9GKo/4/Ujcc4hC1OObDt6w
        NXgO/TZBI2kCejvAnw3cr8FL3U67hPKCnfm7vvM=
X-Google-Smtp-Source: ABdhPJwqRA4GUZR0yWlIM98EtjAEC1PeB3HR9HXXYMiTU8SG8TfvB+h5r2uePUzf6MekQVkJrzogXg==
X-Received: by 2002:a05:622a:303:: with SMTP id q3mr2565544qtw.235.1611284520198;
        Thu, 21 Jan 2021 19:02:00 -0800 (PST)
Received: from localhost.localdomain ([45.32.7.59])
        by smtp.gmail.com with ESMTPSA id 23sm2928792qks.71.2021.01.21.19.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 19:01:59 -0800 (PST)
From:   Su Yanjun <suyanjun218@gmail.com>
To:     mkl@pengutronix.de, manivannan.sadhasivam@linaro.org,
        thomas.kopp@microchip.com, wg@grandegger.com, davem@davemloft.net,
        kuba@kernel.org, lgirdwood@gmail.com, broonie@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Su Yanjun <suyanjun218@gmail.com>
Subject: [PATCH v3] can: mcp251xfd: replace sizeof(u32) with val_bytes in regmap
Date:   Fri, 22 Jan 2021 11:01:30 +0800
Message-Id: <20210122030130.166242-1-suyanjun218@gmail.com>
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
+	int val_bytes = regmap_get_val_bytes(priv->map_reg);
 
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
+	int val_bytes = regmap_get_val_bytes(priv->map_reg);
 
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

