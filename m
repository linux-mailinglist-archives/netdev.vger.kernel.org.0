Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E3C245F81
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgHQIWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgHQIWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:22:33 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEE6C061389;
        Mon, 17 Aug 2020 01:22:32 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mt12so7451108pjb.4;
        Mon, 17 Aug 2020 01:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VoLKiIOVUrOaN4l287TMDMySry9ropfMxje6XIuCNNc=;
        b=UbD9RvpwGYRa7E78/0SmXu8D+0uU3CLlGpUwz6Png9gNJGr8BMiroIF/PYP33AfP9J
         NS8l01XJqvYO/jMsso1BDEdLaGclwZ3gk+aL2Pm8a5HDdGHsioV3TMN4dOq/YOgV9yoJ
         V8kEU+s8RDsRF1oa+Sclql4CTvvpYcBjnRPDZfBf+rfgWn5Oe3QtfUuvmGGHPpiHVR8l
         OztVqA0QEdskNrxv8FNjsfSqr6P9ab5mjNbhW9jJNJSyrZ6KEteHRxI02A/jTTAxIg2g
         FAWtgOnrjNlx0Js75Qo/We+hTjdoZq52Vv0B5M/wrKoumVIKQeOoBwXc0hyVCfrCc1F7
         sWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VoLKiIOVUrOaN4l287TMDMySry9ropfMxje6XIuCNNc=;
        b=j/7W25gZ8+IqVRIfydq6p6h9ySwpiOlqvvFdY37S9Rx5xV12cedefToQm5wCTlWgvJ
         ajPYOVm/hpoPBWyomPDryvgEjihciy3RTN0NLBaor1a2oUTrkOE5FfLRA15EMvFH0HXf
         BDSNpM/7FPQFqzUWSVi4sSBLQMEig4H1jMWYJe4dYCRiDl8wgjXmZNHPrwvYj/8TXMQi
         RZBud7XQQXsbuOaF2bLDl91M7xhdhum8DBWOBICgx5wLEYe042Cid5JJsJeTVt4fOqlJ
         t1xYoSQ/7WXitf8VamOsZsuGgVIyJHZ6JmrLFtNi/+LDLsHiKkiw8NmHYtY5BaRw0Ubx
         lymA==
X-Gm-Message-State: AOAM532tNe6/Yk/80BOiuvCTKG8huOOIKWxj4OcW1wI/q1fVGofXEfgG
        nn0UAxMPGr0bCNU2aVTtwas=
X-Google-Smtp-Source: ABdhPJzY54Yr9p3SvkQUHcoT5x+SSSopPxxu/Za5BaDZ45wgGC+HtEgVNCmuV51vEiJI8I7eV/mlXg==
X-Received: by 2002:a17:90a:f2c7:: with SMTP id gt7mr11342682pjb.204.1597652551979;
        Mon, 17 Aug 2020 01:22:31 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:22:31 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, baohua@kernel.org, mripard@kernel.org,
        wens@csie.org, thierry.reding@gmail.com, jonathanh@nvidia.com,
        michal.simek@xilinx.com, matthias.bgg@gmail.com
Cc:     keescook@chromium.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 29/35] dma: txx9dmac: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:20 +0530
Message-Id: <20200817081726.20213-30-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817081726.20213-1-allen.lkml@gmail.com>
References: <20200817081726.20213-1-allen.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/dma/txx9dmac.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index 628bdf4430c7..5b6b375a257e 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -601,13 +601,13 @@ static void txx9dmac_scan_descriptors(struct txx9dmac_chan *dc)
 	}
 }
 
-static void txx9dmac_chan_tasklet(unsigned long data)
+static void txx9dmac_chan_tasklet(struct tasklet_struct *t)
 {
 	int irq;
 	u32 csr;
 	struct txx9dmac_chan *dc;
 
-	dc = (struct txx9dmac_chan *)data;
+	dc = from_tasklet(dc, t, tasklet);
 	csr = channel_readl(dc, CSR);
 	dev_vdbg(chan2dev(&dc->chan), "tasklet: status=%x\n", csr);
 
@@ -638,13 +638,13 @@ static irqreturn_t txx9dmac_chan_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void txx9dmac_tasklet(unsigned long data)
+static void txx9dmac_tasklet(struct tasklet_struct *t)
 {
 	int irq;
 	u32 csr;
 	struct txx9dmac_chan *dc;
 
-	struct txx9dmac_dev *ddev = (struct txx9dmac_dev *)data;
+	struct txx9dmac_dev *ddev = from_tasklet(ddev, t, tasklet);
 	u32 mcr;
 	int i;
 
@@ -1113,8 +1113,7 @@ static int __init txx9dmac_chan_probe(struct platform_device *pdev)
 		irq = platform_get_irq(pdev, 0);
 		if (irq < 0)
 			return irq;
-		tasklet_init(&dc->tasklet, txx9dmac_chan_tasklet,
-				(unsigned long)dc);
+		tasklet_setup(&dc->tasklet, txx9dmac_chan_tasklet);
 		dc->irq = irq;
 		err = devm_request_irq(&pdev->dev, dc->irq,
 			txx9dmac_chan_interrupt, 0, dev_name(&pdev->dev), dc);
@@ -1200,8 +1199,7 @@ static int __init txx9dmac_probe(struct platform_device *pdev)
 
 	ddev->irq = platform_get_irq(pdev, 0);
 	if (ddev->irq >= 0) {
-		tasklet_init(&ddev->tasklet, txx9dmac_tasklet,
-				(unsigned long)ddev);
+		tasklet_setup(&ddev->tasklet, txx9dmac_tasklet);
 		err = devm_request_irq(&pdev->dev, ddev->irq,
 			txx9dmac_interrupt, 0, dev_name(&pdev->dev), ddev);
 		if (err)
-- 
2.17.1

