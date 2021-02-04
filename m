Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0949B30F353
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 13:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbhBDMnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 07:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbhBDMne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 07:43:34 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D943DC0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 04:42:53 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id u14so3354690wri.3
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 04:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=monstr-eu.20150623.gappssmtp.com; s=20150623;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sf0cEHgoBjUUrSmCunlnTaOhu9gA+20DyV3BPL25Fks=;
        b=CL6P0Yz49baJM/ZPXSPCSKTQ0dQoM9DUs/ZLFFBLST1y3bly48kVvNhc1Vodu6yVuN
         dokdIZYyDV1Zlx2rTlzw7kbDt7ewU5+NZfN82391SzjhSh+Ko+2nql0fQKYS0H9oPV88
         bUBJuGgDU2AOMVKQcXAwmDk+q8NcMRdOXZFXW5YJ3hrolxcm6BtrH9WX3ikrxCku0lPp
         W7csdecqx3qZjQBDv7sJauhIhhWBsGTYUzY/xxh7Bon5GlvWsBUsJe3L4aUsZMu6Vh24
         I1XEOePCh7jfdb/tgimGwrl4CTVus+bnDIGWZ/ROozjC0YS5hYff2AlKhVrqOhxopbwr
         L+QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Sf0cEHgoBjUUrSmCunlnTaOhu9gA+20DyV3BPL25Fks=;
        b=c5pN64gRC3C4PvFWq1WJUKvvpl1Czl2jW0VhDePg16qatFZ/LRnUazWpPFvnipOYsE
         20qmxNX1uOwb4j3oBss6V/EeJvwKjsr1f5HerNxu7qJblPhhfLCKdrfwRwQUVmAOhEkY
         27DZP+6uFjLbBR5S5fB8DI0TUpYAB5x7VdUvlcIGh2RKKvkqvbgHrBdINTiFHNi227/J
         S7KhBf0Be4vqahtCQptlWU4fSZkXrhtvNnF/av1J5FHeQxsY1pKavWJLDImbikdVU9hk
         V5T0Ux0p0ZnomLTSz8eDn8u05DJY5EyU4S3JiauHhT7AwKD6eR13dYinOC1TvBgT1H1l
         P7sg==
X-Gm-Message-State: AOAM532rJNzXe2XaPlB7paImolC2eJ+/nUTDFnUlUawBpEIt6rleztFM
        ij2wyA/vkuUyds2pKvE10llbTA==
X-Google-Smtp-Source: ABdhPJwWFBGTfCzIYxIPWUtexWvAA0VI/2/svkzdxTyaMfgZnW0iMb8TFf7+LLz9Xunn4f+HSOji/g==
X-Received: by 2002:a5d:6510:: with SMTP id x16mr8884764wru.175.1612442572651;
        Thu, 04 Feb 2021 04:42:52 -0800 (PST)
Received: from localhost (nat-35.starnet.cz. [178.255.168.35])
        by smtp.gmail.com with ESMTPSA id r25sm8546181wrr.64.2021.02.04.04.42.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Feb 2021 04:42:52 -0800 (PST)
Sender: Michal Simek <monstr@monstr.eu>
From:   Michal Simek <michal.simek@xilinx.com>
To:     linux-kernel@vger.kernel.org, monstr@monstr.eu,
        michal.simek@xilinx.com, git@xilinx.com
Cc:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] can: xilinx_can: Simplify code by using dev_err_probe()
Date:   Thu,  4 Feb 2021 13:42:48 +0100
Message-Id: <91af0945ed7397b08f1af0c829450620bd92b804.1612442564.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use already prepared dev_err_probe() introduced by commit a787e5400a1c
("driver core: add device probe log helper").
It simplifies EPROBE_DEFER handling.

Also unify message format for similar error cases.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/net/can/xilinx_can.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 37fa19c62d73..3b883e607d8b 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1772,17 +1772,15 @@ static int xcan_probe(struct platform_device *pdev)
 	/* Getting the CAN can_clk info */
 	priv->can_clk = devm_clk_get(&pdev->dev, "can_clk");
 	if (IS_ERR(priv->can_clk)) {
-		if (PTR_ERR(priv->can_clk) != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "Device clock not found.\n");
-		ret = PTR_ERR(priv->can_clk);
+		ret = dev_err_probe(&pdev->dev, PTR_ERR(priv->can_clk),
+				    "device clock not found\n");
 		goto err_free;
 	}
 
 	priv->bus_clk = devm_clk_get(&pdev->dev, devtype->bus_clk_name);
 	if (IS_ERR(priv->bus_clk)) {
-		if (PTR_ERR(priv->bus_clk) != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "bus clock not found\n");
-		ret = PTR_ERR(priv->bus_clk);
+		ret = dev_err_probe(&pdev->dev, PTR_ERR(priv->bus_clk),
+				    "bus clock not found\n");
 		goto err_free;
 	}
 
-- 
2.30.0

