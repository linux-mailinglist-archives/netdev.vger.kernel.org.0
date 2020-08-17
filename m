Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D27245F62
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgHQIVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728161AbgHQIU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:20:57 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99149C061388;
        Mon, 17 Aug 2020 01:20:57 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id f193so7853804pfa.12;
        Mon, 17 Aug 2020 01:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dBdUK8kTW7LlD2iWbT6JIJ3+2TeLAftGafICpZAEwWI=;
        b=DhBo3QVZ7RG3vmgoNkItvwt1S5mOvic4xOre9KplQouw/zjrMkde3nmUrVsRNShSgQ
         tPrNCl473k5OZbUWRxdiDJpQXpEIYG14b+73qK8djI5DITUJ6lihsmtYD7kPn1KlDVX2
         ZtX0p/IGpjDOl4xzqiKlPdZfFh+q96wAvw/z5dqY/kpvVYALHYAYtGZzvFEd4k1jYUTa
         QYPpbUn5w1xwiPMA3ppiW0gqQX1HFzJUDf85kqm+UcfpWqbypl3AQdwR1TfnHTaB0lvq
         bYrknS9FRIOZUI/R2DT1dEU2sI7BXsnpQLIayv3U4tE70PZpg0yne09vnOwYATGXrAWi
         AeEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dBdUK8kTW7LlD2iWbT6JIJ3+2TeLAftGafICpZAEwWI=;
        b=O4WDQhhYSwGSeCu6Q/pNwjplr04nEpLpE/1Tx5oKQd+sPa+LSLeAvItoZONF313+RK
         340BAwOQbxupxhGz7jtGpX/iYCmwkBrzaQ9OHai+wLch0asPRQp2jNJ3YroxIqc5VGSO
         35LMzZ8Y7/ypJpCcJ3tisNYAxrR6doutJi7pgPV9166e1xm2yIEVUe1dp1T1IiFzbWeR
         HSBkYCS4KJXzMMunGlUqhhIzmWWCgPOJcNrAZLMGBCEgjBxvxCt92vHUgi8Srs9iVQ1S
         FUi5W/K1zduoq3IGw+ILZuWL3hPzmasYQgpzvgW/p0IbL7BTUFyxEUi/i7JML2I0x4tX
         C77w==
X-Gm-Message-State: AOAM532mhMViZi74lA4u7jAx9/8rC/YqaFrP93UrAqT0yQfGx3WBPOL6
        0GO3CmwCjfiihkt/pzqd7rw=
X-Google-Smtp-Source: ABdhPJxV6aGgsyONYJ85KZCc26Mwj2MNfgxuNI7M/Y4k7HNeoWAcKtP56vFtLZwXEmS9pw15U3I4EQ==
X-Received: by 2002:a63:d40d:: with SMTP id a13mr385021pgh.232.1597652457198;
        Mon, 17 Aug 2020 01:20:57 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:20:56 -0700 (PDT)
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
Subject: [PATCH 19/35] dma: pch_dma: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:10 +0530
Message-Id: <20200817081726.20213-20-allen.lkml@gmail.com>
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
 drivers/dma/pch_dma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index a3b0b4c56a19..0cd0311e6e87 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -670,9 +670,9 @@ static int pd_device_terminate_all(struct dma_chan *chan)
 	return 0;
 }
 
-static void pdc_tasklet(unsigned long data)
+static void pdc_tasklet(struct tasklet_struct *t)
 {
-	struct pch_dma_chan *pd_chan = (struct pch_dma_chan *)data;
+	struct pch_dma_chan *pd_chan = from_tasklet(pd_chan, t, tasklet);
 	unsigned long flags;
 
 	if (!pdc_is_idle(pd_chan)) {
@@ -898,8 +898,7 @@ static int pch_dma_probe(struct pci_dev *pdev,
 		INIT_LIST_HEAD(&pd_chan->queue);
 		INIT_LIST_HEAD(&pd_chan->free_list);
 
-		tasklet_init(&pd_chan->tasklet, pdc_tasklet,
-			     (unsigned long)pd_chan);
+		tasklet_setup(&pd_chan->tasklet, pdc_tasklet);
 		list_add_tail(&pd_chan->chan.device_node, &pd->dma.channels);
 	}
 
-- 
2.17.1

