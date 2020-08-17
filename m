Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE05A245F3F
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgHQITx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgHQITq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:19:46 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7F5C061388;
        Mon, 17 Aug 2020 01:19:46 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y206so7845256pfb.10;
        Mon, 17 Aug 2020 01:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=C5F0nnOTh5Z2C3fK8ewqMRIq3Z/HzN1bhDJR1BeVHS8=;
        b=Zv4j3ZnQEwlXKTmQMcr9yGw2Wg9syVGPoOFVEo88aRFfTusau3D/jPmgBPE/UoEk7W
         6hVOMVLjy3IjuqSmajCe4ICoCGHzdbeVf7neS0HcR2YvB15zP0WtFq0EwGdBnKlAumKK
         pm4gyCCSGQB/BieYkhoO84f8+D2FscxxVCgUc6aTVRfHCkccWQAFyh99LK4NhB4I+ZQy
         5lM9ffV8CDoqkPhd7hdzLsDaMzhLwQU/QxUNq87pEqaXMMxpEEWlxDhCCQluK5XBiIpg
         8oLWvIoJkd8CK2/7WfDRfvxHktayMAXa1HOW8Vg+seOGKtokTogysyzUUm3IyE76OF9f
         RuSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=C5F0nnOTh5Z2C3fK8ewqMRIq3Z/HzN1bhDJR1BeVHS8=;
        b=nVAT/IAd1j6VBhyFsjUs+U7NXWrhfoaKanZfvtf0MMdDokIUxntqy0fKbqTTUg/uMG
         8UNyfgeVw6OiJC4pDxcQiP/Oz/dnG/Quk8gow+cU0qrm6Ac5YcLitoXUWCOwdedblnJM
         +48cNdvONcNs0cBxr23DzIk5g4OVS+p3t93H9MgHhPDxp87XSB+BF3C3KTvkHWO1Ajne
         E9HUKGDRiIUH5n3pItIox1Mr0s/DCvwPRHWZyW2lTxkWNXgFV9d9XIS/gU+B5cN/EJVY
         UGS5Dp+I/4KyaVmVi8D/K9Fn5uqq5uX59eny4qBDOV3Zzav+1p/Ch8V6doxvR9rS2cZQ
         dJBg==
X-Gm-Message-State: AOAM531zL/JBK+DC1NhtwPd7uHXRYSGce1DxhD7lPIfHy1A8rG08Vrpz
        P2wJkrciaLUfjtlOKHvLxSE=
X-Google-Smtp-Source: ABdhPJwNz0WCRvYD0EzUq3bpg+5UrV7v8gJCanPc+Hu+vgv/oJ4AIpPuVHmHeKtfyGccvGps8amOKg==
X-Received: by 2002:a63:fc4b:: with SMTP id r11mr9016761pgk.342.1597652385686;
        Mon, 17 Aug 2020 01:19:45 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:19:45 -0700 (PDT)
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
Subject: [PATCH 12/35] dma: k3dma: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:03 +0530
Message-Id: <20200817081726.20213-13-allen.lkml@gmail.com>
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
 drivers/dma/k3dma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
index c5c1aa0dcaed..f609a84c493c 100644
--- a/drivers/dma/k3dma.c
+++ b/drivers/dma/k3dma.c
@@ -297,9 +297,9 @@ static int k3_dma_start_txd(struct k3_dma_chan *c)
 	return -EAGAIN;
 }
 
-static void k3_dma_tasklet(unsigned long arg)
+static void k3_dma_tasklet(struct tasklet_struct *t)
 {
-	struct k3_dma_dev *d = (struct k3_dma_dev *)arg;
+	struct k3_dma_dev *d = from_tasklet(d, t, task);
 	struct k3_dma_phy *p;
 	struct k3_dma_chan *c, *cn;
 	unsigned pch, pch_alloc = 0;
@@ -962,7 +962,7 @@ static int k3_dma_probe(struct platform_device *op)
 
 	spin_lock_init(&d->lock);
 	INIT_LIST_HEAD(&d->chan_pending);
-	tasklet_init(&d->task, k3_dma_tasklet, (unsigned long)d);
+	tasklet_setup(&d->task, k3_dma_tasklet);
 	platform_set_drvdata(op, d);
 	dev_info(&op->dev, "initialized\n");
 
-- 
2.17.1

