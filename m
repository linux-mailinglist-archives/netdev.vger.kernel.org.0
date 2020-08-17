Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E2F245F53
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgHQIUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbgHQIUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:20:30 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D474BC061388;
        Mon, 17 Aug 2020 01:20:29 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id f9so7332852pju.4;
        Mon, 17 Aug 2020 01:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zY00DfBPk2FI3CMNWn52CBXvi0OzneRvuEaVydUrqYM=;
        b=JHXohDxeJ/Dh1zXnUGOIBhnD05rLIOt0WPhf5lY0Z1SOp2iutpPlMhSNVdP842Ujnn
         MDU3wcpMFCC3NAPRruONdOxR58Iu4lTi1Tt+xUudFOxXyNWG+U2tONhNCyIoxOOrbFKU
         2oIt00L630r9KMmiXtkYWvRJNRJfF62nHnvc6hmqFqtPMZCIjpjBxma0W4k9Me3G2iNm
         kelj92TPaz96JgekkO5nuv2nmqBA2LGFDNJFNou0XvCWKbUiJOfNfwsXBA6Y43f3ThAQ
         Ju7n8KKdnB/MnHns8wOt4ve7rjgpzVpfXJOmZr2gp1ui3RHfoohqHG48mxAtJKPC83tb
         CZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zY00DfBPk2FI3CMNWn52CBXvi0OzneRvuEaVydUrqYM=;
        b=n7fmhf6tnF+sbduNeobruenmnldkrzLUPdqnDF3goAcuSu8Pf9A5tjMzKRYHWoM4tW
         YPUCPtOZi2iSn1vKp5wajVSHIbbQQQHl1zvKKAkg94OSPx46pVw62YO+QpZuZSrllg3A
         2HGmPG3CrRBtZGdv+dDDoLD+DhSQ06v7Rs3+KBLpqSR7RRmCB3W1xq6xebtDQbZA3dC4
         sJwwv5COWO47dm1x0vmnBW0YEzDhmr/yjYleLJ3WCT0XjVuMvgmpHyB6uTafCJG2qZow
         ZE6Vb6mfdCPB+w87typ/HaJQJT+MA5LF7kzKOY0wmbWvPlzQbO1mzlCA2qAABlBSHCjY
         tzng==
X-Gm-Message-State: AOAM531DyFZei9DyfmE/4sqZSCQfgBQpilyQKNKEmhR9XPOb3YMjIeZI
        jzrp5FeTW2DQlhvChZxKClTGzo1KwJJjxw==
X-Google-Smtp-Source: ABdhPJy9hNIs3sa3AQpSygkE4NBuQaTMYIQe8TcPYBT2GBobmrg/Uht24FGujnLWHAiWPhcMsHqZ2Q==
X-Received: by 2002:a17:90a:dc06:: with SMTP id i6mr11151231pjv.161.1597652429423;
        Mon, 17 Aug 2020 01:20:29 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:20:28 -0700 (PDT)
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
Subject: [PATCH 16/35] dma: mv_xor: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:07 +0530
Message-Id: <20200817081726.20213-17-allen.lkml@gmail.com>
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
 drivers/dma/mv_xor.c    | 7 +++----
 drivers/dma/mv_xor_v2.c | 8 ++++----
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 0ac8e7b34e12..00cd1335eeba 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -336,9 +336,9 @@ static void mv_chan_slot_cleanup(struct mv_xor_chan *mv_chan)
 		mv_chan->dmachan.completed_cookie = cookie;
 }
 
-static void mv_xor_tasklet(unsigned long data)
+static void mv_xor_tasklet(struct tasklet_struct *t)
 {
-	struct mv_xor_chan *chan = (struct mv_xor_chan *) data;
+	struct mv_xor_chan *chan = from_tasklet(chan, t, irq_tasklet);
 
 	spin_lock(&chan->lock);
 	mv_chan_slot_cleanup(chan);
@@ -1097,8 +1097,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 
 	mv_chan->mmr_base = xordev->xor_base;
 	mv_chan->mmr_high_base = xordev->xor_high_base;
-	tasklet_init(&mv_chan->irq_tasklet, mv_xor_tasklet, (unsigned long)
-		     mv_chan);
+	tasklet_setup(&mv_chan->irq_tasklet, mv_xor_tasklet);
 
 	/* clear errors before enabling interrupts */
 	mv_chan_clear_err_status(mv_chan);
diff --git a/drivers/dma/mv_xor_v2.c b/drivers/dma/mv_xor_v2.c
index 9225f08dfee9..2753a6b916f6 100644
--- a/drivers/dma/mv_xor_v2.c
+++ b/drivers/dma/mv_xor_v2.c
@@ -553,9 +553,10 @@ int mv_xor_v2_get_pending_params(struct mv_xor_v2_device *xor_dev,
 /*
  * handle the descriptors after HW process
  */
-static void mv_xor_v2_tasklet(unsigned long data)
+static void mv_xor_v2_tasklet(struct tasklet_struct *t)
 {
-	struct mv_xor_v2_device *xor_dev = (struct mv_xor_v2_device *) data;
+	struct mv_xor_v2_device *xor_dev = from_tasklet(xor_dev, t,
+							irq_tasklet);
 	int pending_ptr, num_of_pending, i;
 	struct mv_xor_v2_sw_desc *next_pending_sw_desc = NULL;
 
@@ -780,8 +781,7 @@ static int mv_xor_v2_probe(struct platform_device *pdev)
 	if (ret)
 		goto free_msi_irqs;
 
-	tasklet_init(&xor_dev->irq_tasklet, mv_xor_v2_tasklet,
-		     (unsigned long) xor_dev);
+	tasklet_setup(&xor_dev->irq_tasklet, mv_xor_v2_tasklet);
 
 	xor_dev->desc_size = mv_xor_v2_set_desc_size(xor_dev);
 
-- 
2.17.1

