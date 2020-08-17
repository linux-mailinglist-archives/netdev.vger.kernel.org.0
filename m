Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12484245F65
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgHQIVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgHQIVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:21:07 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5FBC061388;
        Mon, 17 Aug 2020 01:21:07 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id v15so7758514pgh.6;
        Mon, 17 Aug 2020 01:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2u/40339c50ypFs7M618Prb7hCf6hscGSknPACX7w9w=;
        b=iMJgXHftMkSl4iNyizZ354moFN14rzQi5QK+tsbFIeiCkQVJgOcb4cFOkDwqwHn8p6
         RW9U+l9OAhcSuILZYFOEuHFOfiufeK7Muf76t7X5rfoJNJNRY9aI7JyxEmfsE4MKJzI3
         oKpRg2L9JOBnMg7DKsTu7pgeUWYEUQsofw1NXS6KesdoB2kjZfjXKQdqb9de6VUvzjj4
         fSUgAq/rbcI1IEyjk9wHzfEFF8akM/JLknmS5KMWJOYvYsn5zf/xIPvEZgLADDg6rXAo
         6QgNrVRH6d+Qs05Jy11I6QzJS2SlA5B/7I4XrIw3CArYIMUWUYvQ4ZPSbabLMjncdi+6
         6EVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2u/40339c50ypFs7M618Prb7hCf6hscGSknPACX7w9w=;
        b=VfBhAf7OxOOpKOBLruNBZyE21mahhO1jlyiUE5bFRswJeRcn1WjdwPjp5suFGFHNKT
         XzGC/8pGPGZPL5RsHE4uihzf8ss9ig8b6AcHM3WC5woAnjGsVeGiyVxqEhFdLQUvLOUJ
         RjsAtBqPU0zEu/AvGN8Tgmm0b0w5arJlOftWTzXhhsIl/qHMiRI8Y3vt3qnwivp5pSuT
         uUlfhABYKSACdfQJG8kCFgZ5+OMHTbw330hvjtn4/mnrnCLQrXgsrnIn/vMPMQSnfr2o
         kyaE+4bOxBPYy2bMMJdR77cgsMGk2HXIkaXXH4/krDm5T+mH+uqZ1Ft6fWxRjsIqavG7
         neMg==
X-Gm-Message-State: AOAM533OeIKkzPCcrrF7p/FKK0nEl13dL+QKL3M624do9hYBrPWuYSHR
        268wxlvPqHPwrSRBp4aKWl8=
X-Google-Smtp-Source: ABdhPJwsXsOO//FysPu6rGzdVl2xfR2M5Qe2SU66dgM2Vu9dNZn8EtINnA+NMrA0VuD5J6Ua73aLqQ==
X-Received: by 2002:a05:6a00:91:: with SMTP id c17mr10267047pfj.151.1597652466999;
        Mon, 17 Aug 2020 01:21:06 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:21:06 -0700 (PDT)
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
Subject: [PATCH 20/35] dma: pl330: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:11 +0530
Message-Id: <20200817081726.20213-21-allen.lkml@gmail.com>
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
 drivers/dma/pl330.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 2c508ee672b9..5599d350ec79 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1580,9 +1580,9 @@ static void dma_pl330_rqcb(struct dma_pl330_desc *desc, enum pl330_op_err err)
 	tasklet_schedule(&pch->task);
 }
 
-static void pl330_dotask(unsigned long data)
+static void pl330_dotask(struct tasklet_struct *t)
 {
-	struct pl330_dmac *pl330 = (struct pl330_dmac *) data;
+	struct pl330_dmac *pl330 = from_tasklet(pl330, t, tasks);
 	unsigned long flags;
 	int i;
 
@@ -1986,7 +1986,7 @@ static int pl330_add(struct pl330_dmac *pl330)
 		return ret;
 	}
 
-	tasklet_init(&pl330->tasks, pl330_dotask, (unsigned long) pl330);
+	tasklet_setup(&pl330->tasks, pl330_dotask);
 
 	pl330->state = INIT;
 
@@ -2069,9 +2069,9 @@ static inline void fill_queue(struct dma_pl330_chan *pch)
 	}
 }
 
-static void pl330_tasklet(unsigned long data)
+static void pl330_tasklet(struct tasklet_struct *t)
 {
-	struct dma_pl330_chan *pch = (struct dma_pl330_chan *)data;
+	struct dma_pl330_chan *pch = from_tasklet(pch, t, task);
 	struct dma_pl330_desc *desc, *_dt;
 	unsigned long flags;
 	bool power_down = false;
@@ -2179,7 +2179,7 @@ static int pl330_alloc_chan_resources(struct dma_chan *chan)
 		return -ENOMEM;
 	}
 
-	tasklet_init(&pch->task, pl330_tasklet, (unsigned long) pch);
+	tasklet_setup(&pch->task, pl330_tasklet);
 
 	spin_unlock_irqrestore(&pl330->lock, flags);
 
-- 
2.17.1

