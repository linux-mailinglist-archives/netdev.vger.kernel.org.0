Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8FC9A1F6
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 23:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392170AbfHVVQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 17:16:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50694 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390234AbfHVVPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 17:15:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so6966475wml.0;
        Thu, 22 Aug 2019 14:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vLzZPpo7b0N4+qTOHWyLVFeSUhJJ41N2hRhJ91Biag0=;
        b=QhSAuL86oZE7z8vStZrL/1VLl49cTe+y2W1fOmraQT+MOyBrvXFGT7IHj62FpZoomy
         dfWWRQdKhd/Hi4Ac0X6j+sORjYC3o+3njUqBAJbtxguZ4YdDP7B3pJo3FxlfefLftzht
         TUaVyzirgrwVfLis7UGWNmvlcRzu9fp6809EvhwT3zKr2LXNVd6nfxBlhDQxHMUe63ya
         eO9jJvxwu7gA+ysRwt+IK5j4FsSzawPPqOeUYvN+YNQBVlTUoh7ClQTDFbl+nGMPZEke
         /DauZ1hRcwOvSp33bXcCxEJeVXecaLZCjuzYx822Jlz5z8anAdipUdVinzF5a/BiNrrA
         Yang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vLzZPpo7b0N4+qTOHWyLVFeSUhJJ41N2hRhJ91Biag0=;
        b=ZizuYO13dt/Nukzb84EF+FCbm9P5Wev9+/vkt4nFFjx+98hbOB6w3EzhW3vHqBsFtC
         8jkdq1SD7biV5I/GX37UxQewlR3siyvwC8MmoAsG09Jto3nmtTRSic0mh55EWhXnLAmL
         7DDhfqv/oJFZ0uIzL7bJ3eefhg0k2CqGgb/vsxJvZFmAnL1y4qpuYzP+2RZMv21O2I+l
         Rtbrszw+dk7FGWIYUA16d3n1fOp6tpLJWhDNi0DM2DdlT0tPKH7YlY9BVa554nc8sjFg
         Yx1yv8ExS7s8pNgm3zNgKBUVZ0ZttJ/6PkZe1tpymLkO1nTf4YebN1sDTsxNTK9Z7BGd
         oH1A==
X-Gm-Message-State: APjAAAVx3SPNJXyh4/FTktImo6WEP7g/XQ+1N1cE3MtECpzA0yzGZOBC
        d77g4YrBZpB8+e/tTGUGD+nZeyG3
X-Google-Smtp-Source: APXvYqxzIkDLviXhj68Uika9G99ME5VzuGwztSEnEdSTySaZJZgC7br8yE0qywfVYlxIzj7PoXq0Hg==
X-Received: by 2002:a1c:3d89:: with SMTP id k131mr1033954wma.24.1566508550015;
        Thu, 22 Aug 2019 14:15:50 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id g197sm578488wme.30.2019.08.22.14.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 14:15:49 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 1/5] spi: spi-fsl-dspi: Reduce indentation level in dspi_interrupt
Date:   Fri, 23 Aug 2019 00:15:10 +0300
Message-Id: <20190822211514.19288-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190822211514.19288-1-olteanv@gmail.com>
References: <20190822211514.19288-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the entire function depends on the SPI status register having the
interrupt bits asserted, then just check it and exit early if those bits
aren't set (such as in the case of the shared IRQ being triggered for
the other peripheral). Cosmetic patch.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/spi/spi-fsl-dspi.c | 79 +++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 790cb02fc181..c90db7db4121 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -658,47 +658,48 @@ static irqreturn_t dspi_interrupt(int irq, void *dev_id)
 	regmap_read(dspi->regmap, SPI_SR, &spi_sr);
 	regmap_write(dspi->regmap, SPI_SR, spi_sr);
 
+	if (!(spi_sr & (SPI_SR_EOQF | SPI_SR_TCFQF)))
+		return IRQ_HANDLED;
+
+	/* Get transfer counter (in number of SPI transfers). It was
+	 * reset to 0 when transfer(s) were started.
+	 */
+	regmap_read(dspi->regmap, SPI_TCR, &spi_tcr);
+	spi_tcnt = SPI_TCR_GET_TCNT(spi_tcr);
+	/* Update total number of bytes that were transferred */
+	msg->actual_length += spi_tcnt * dspi->bytes_per_word;
+
+	trans_mode = dspi->devtype_data->trans_mode;
+	switch (trans_mode) {
+	case DSPI_EOQ_MODE:
+		dspi_eoq_read(dspi);
+		break;
+	case DSPI_TCFQ_MODE:
+		dspi_tcfq_read(dspi);
+		break;
+	default:
+		dev_err(&dspi->pdev->dev, "unsupported trans_mode %u\n",
+			trans_mode);
+			return IRQ_HANDLED;
+	}
 
-	if (spi_sr & (SPI_SR_EOQF | SPI_SR_TCFQF)) {
-		/* Get transfer counter (in number of SPI transfers). It was
-		 * reset to 0 when transfer(s) were started.
-		 */
-		regmap_read(dspi->regmap, SPI_TCR, &spi_tcr);
-		spi_tcnt = SPI_TCR_GET_TCNT(spi_tcr);
-		/* Update total number of bytes that were transferred */
-		msg->actual_length += spi_tcnt * dspi->bytes_per_word;
-
-		trans_mode = dspi->devtype_data->trans_mode;
-		switch (trans_mode) {
-		case DSPI_EOQ_MODE:
-			dspi_eoq_read(dspi);
-			break;
-		case DSPI_TCFQ_MODE:
-			dspi_tcfq_read(dspi);
-			break;
-		default:
-			dev_err(&dspi->pdev->dev, "unsupported trans_mode %u\n",
-				trans_mode);
-				return IRQ_HANDLED;
-		}
+	if (!dspi->len) {
+		dspi->waitflags = 1;
+		wake_up_interruptible(&dspi->waitq);
+		return IRQ_HANDLED;
+	}
 
-		if (!dspi->len) {
-			dspi->waitflags = 1;
-			wake_up_interruptible(&dspi->waitq);
-		} else {
-			switch (trans_mode) {
-			case DSPI_EOQ_MODE:
-				dspi_eoq_write(dspi);
-				break;
-			case DSPI_TCFQ_MODE:
-				dspi_tcfq_write(dspi);
-				break;
-			default:
-				dev_err(&dspi->pdev->dev,
-					"unsupported trans_mode %u\n",
-					trans_mode);
-			}
-		}
+	switch (trans_mode) {
+	case DSPI_EOQ_MODE:
+		dspi_eoq_write(dspi);
+		break;
+	case DSPI_TCFQ_MODE:
+		dspi_tcfq_write(dspi);
+		break;
+	default:
+		dev_err(&dspi->pdev->dev,
+			"unsupported trans_mode %u\n",
+			trans_mode);
 	}
 
 	return IRQ_HANDLED;
-- 
2.17.1

