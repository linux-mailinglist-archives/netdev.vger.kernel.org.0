Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5990354F57
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 14:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731983AbfFYMva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 08:51:30 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33299 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731674AbfFYMv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 08:51:29 -0400
Received: by mail-pf1-f193.google.com with SMTP id x15so9459953pfq.0;
        Tue, 25 Jun 2019 05:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ChUqfbkNJtY1QVoFfhG4SYZiQSZDx5qq4T80tyOZU8Y=;
        b=dJkcRi0eQAGd7DCe1OFlYbJ7wXvOC3ososcoWh2IsgW8/jf+yfbEC1EKf4RWEMwquI
         l1aOrWH5IFWsTvFQJ8GKrPFOX9bJd8t5ZmFx9tZzYZxED4qkgIy7bP6h/hbNkFz8Pqlt
         z6rQO0qvTKL/7nGXhxjG17ysKU6AEPqQ939gGKqf+4BNeuFHt40q/VvTjYpoDy8gpIMX
         JOo9mv/GHk0F/bQAoMmKbTb520KsXEZT1FiuWm8LcfbQ70y4z+PQ6SSE9s8H2RtTVTwn
         zFlvr83zzkuR9+ERoROBz3smDpIqUzqViELQxEjzq5GRTq8bxDlkGnJ5YYidJSPCUNIk
         GdJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ChUqfbkNJtY1QVoFfhG4SYZiQSZDx5qq4T80tyOZU8Y=;
        b=RrJVhMF6Geix7S8mfLV3vjrpV/aqfJoTTqWbucV1tzf7MLDxaBWzE/rIlyLF5vn0yB
         whSGN4m3wFQipwSEqH3qzVZTeXESUMTeUGaFV48xnEBD3eli/7T3p9GaV2Zi/luX71Um
         1Swr2wvpaR2Ip+Wy+x+u9n2AkPLLDrm+LPinf1q2u7UxgC+4BHiQBiVsoj/dVdpnuMGO
         6Id1h1QjP1Ydzj28pr9P2+Vrw0YY0lbHXZnFMGlpAEaTc7y5PNJXzxns3/z5IxfWPvV+
         dfe7tzqJGqRJl8KUo3Y0VSzEUMpcaYVUqOdl7j7p0dkqYfAtfQO+q3R0UmXueLM6CABs
         y/lQ==
X-Gm-Message-State: APjAAAXrYvS9S3ctkJTlUPX8slXERwWOwkuW3bW3fjpAA8GsFjtDIQtf
        mTjsxFo4FjBUKY3ZJa105uo=
X-Google-Smtp-Source: APXvYqzgqqbLbw1cC+98rhu4N+kdSFSfWgUwa1Qwo8yyNnBtVvr4/1BqqAP7009ikXjidkA77WW6EA==
X-Received: by 2002:a63:dc50:: with SMTP id f16mr39307235pgj.447.1561467088625;
        Tue, 25 Jun 2019 05:51:28 -0700 (PDT)
Received: from localhost ([43.224.245.181])
        by smtp.gmail.com with ESMTPSA id u10sm12405396pfh.54.2019.06.25.05.51.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 05:51:28 -0700 (PDT)
From:   Weitao Hou <houweitaoo@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        gregkh@linuxfoundation.org, allison@lohutok.net,
        houweitaoo@gmail.com, tglx@linutronix.de, sean@geanix.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] can: mcp251x: add error check when wq alloc failed
Date:   Tue, 25 Jun 2019 20:50:48 +0800
Message-Id: <20190625125048.28849-1-houweitaoo@gmail.com>
X-Mailer: git-send-email 2.18.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add error check when workqueue alloc failed, and remove
redundant code to make it clear

Signed-off-by: Weitao Hou <houweitaoo@gmail.com>
---
 drivers/net/can/spi/mcp251x.c | 49 ++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 44e99e3d7134..2aec934fab0c 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -664,17 +664,6 @@ static int mcp251x_power_enable(struct regulator *reg, int enable)
 		return regulator_disable(reg);
 }
 
-static void mcp251x_open_clean(struct net_device *net)
-{
-	struct mcp251x_priv *priv = netdev_priv(net);
-	struct spi_device *spi = priv->spi;
-
-	free_irq(spi->irq, priv);
-	mcp251x_hw_sleep(spi);
-	mcp251x_power_enable(priv->transceiver, 0);
-	close_candev(net);
-}
-
 static int mcp251x_stop(struct net_device *net)
 {
 	struct mcp251x_priv *priv = netdev_priv(net);
@@ -940,37 +929,43 @@ static int mcp251x_open(struct net_device *net)
 				   flags | IRQF_ONESHOT, DEVICE_NAME, priv);
 	if (ret) {
 		dev_err(&spi->dev, "failed to acquire irq %d\n", spi->irq);
-		mcp251x_power_enable(priv->transceiver, 0);
-		close_candev(net);
-		goto open_unlock;
+		goto out_close;
 	}
 
 	priv->wq = alloc_workqueue("mcp251x_wq", WQ_FREEZABLE | WQ_MEM_RECLAIM,
 				   0);
+	if (!priv->wq) {
+		ret = -ENOMEM;
+		goto out_clean;
+	}
 	INIT_WORK(&priv->tx_work, mcp251x_tx_work_handler);
 	INIT_WORK(&priv->restart_work, mcp251x_restart_work_handler);
 
 	ret = mcp251x_hw_reset(spi);
-	if (ret) {
-		mcp251x_open_clean(net);
-		goto open_unlock;
-	}
+	if (ret)
+		goto out_free_wq;
 	ret = mcp251x_setup(net, spi);
-	if (ret) {
-		mcp251x_open_clean(net);
-		goto open_unlock;
-	}
+	if (ret)
+		goto out_free_wq;
 	ret = mcp251x_set_normal_mode(spi);
-	if (ret) {
-		mcp251x_open_clean(net);
-		goto open_unlock;
-	}
+	if (ret)
+		goto out_free_wq;
 
 	can_led_event(net, CAN_LED_EVENT_OPEN);
 
 	netif_wake_queue(net);
+	mutex_unlock(&priv->mcp_lock);
 
-open_unlock:
+	return 0;
+
+out_free_wq:
+	destroy_workqueue(priv->wq);
+out_clean:
+	free_irq(spi->irq, priv);
+	mcp251x_hw_sleep(spi);
+out_close:
+	mcp251x_power_enable(priv->transceiver, 0);
+	close_candev(net);
 	mutex_unlock(&priv->mcp_lock);
 	return ret;
 }
-- 
2.18.0

