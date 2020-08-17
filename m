Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76FD245F94
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgHQIX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727773AbgHQIXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:23:23 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94145C061388;
        Mon, 17 Aug 2020 01:23:23 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 189so7125042pgg.13;
        Mon, 17 Aug 2020 01:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FY/yCtkR8zuQxnB1ct+rZA02HMp31w5fOwHETAQ8JTM=;
        b=V6/1sUEYrVGxUbYI5Mw0RPVY2l1DNf9AoBECR8rJv2FS5zpCQ4vRaGm3Fg3pj0EWMs
         ICd3A9AIogbTBN5xCLrvRE5XzkjMP/8069uNKQxhxmnjMaIZgycsLiFa7QsQpNyn7uoD
         JY/v3ZlyjbcMD7nOpsqwN7V9LxYfpo+e9jGCGGXB1yMrZPjCZFFH0A+wtxceSwYSPlYy
         gg5rNMQWHmTaRWDNmsmwqSFuWgvJzPFkDAVW0kFfXBKMw2Dbj0owdE6nJR6/N3abx/Tf
         fZiKxpIrNr0c1ECdQJgRN66qOVRjrqsxAOW5BbmpeuYHhLb1v99+tEvslnWKYePr7n/+
         Z9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FY/yCtkR8zuQxnB1ct+rZA02HMp31w5fOwHETAQ8JTM=;
        b=majmIT3KMTwcHNOjHzSbO78dHg8xnUWJ6/Yeb33d0gmmyU098iYZyqI2oXpcrxb/JD
         Aj+GtZDOW6wqWf8x5n2zyWxSoa6mpdHj9/nokDhV+K6L7/gIeZapoi96vxZqt0e4zlIV
         jchU2uEJT+87YiDPrCosKuUgcYzNs6CImScR6lkhuaJRz7gpz6pcjv69317gKRb9tc5a
         qdmKEFtapxgwWWRoasMuIgOVITCiTNwdiHbyKaq+NbgnYeffKqcWnE+VC4lOe4wd0RpS
         /JyBfjakaCKYTb/J05KNZZUs2tWepS+E4yvOjjSFBzAB+fYfORk4soTYAi2lpJA6mI6p
         kMug==
X-Gm-Message-State: AOAM5335X1yIYv7rmYLjJNKzAeSoYz3vVvdQoZWu0+l6D4+Y5WxNytBz
        /TRJFBv+cVGyre7YBLWPoPs=
X-Google-Smtp-Source: ABdhPJw+C+LHXjo2QNGKQK9LRY0Ze/kxlofPgLmIl9c1IL5T30PTyN87aaiVYIql2jWjMWTuoSRDQQ==
X-Received: by 2002:aa7:96e5:: with SMTP id i5mr7573327pfq.108.1597652603195;
        Mon, 17 Aug 2020 01:23:23 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:23:22 -0700 (PDT)
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
        Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 34/35] dma: sf-pdma: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:25 +0530
Message-Id: <20200817081726.20213-35-allen.lkml@gmail.com>
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

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/dma/sf-pdma/sf-pdma.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/sf-pdma/sf-pdma.c b/drivers/dma/sf-pdma/sf-pdma.c
index 6e530dca6d9e..a2d91074bc6f 100644
--- a/drivers/dma/sf-pdma/sf-pdma.c
+++ b/drivers/dma/sf-pdma/sf-pdma.c
@@ -281,9 +281,9 @@ static void sf_pdma_free_desc(struct virt_dma_desc *vdesc)
 	desc->in_use = false;
 }
 
-static void sf_pdma_donebh_tasklet(unsigned long arg)
+static void sf_pdma_donebh_tasklet(struct tasklet_struct *t)
 {
-	struct sf_pdma_chan *chan = (struct sf_pdma_chan *)arg;
+	struct sf_pdma_chan *chan = from_tasklet(chan, t, done_tasklet);
 	struct sf_pdma_desc *desc = chan->desc;
 	unsigned long flags;
 
@@ -298,9 +298,9 @@ static void sf_pdma_donebh_tasklet(unsigned long arg)
 	dmaengine_desc_get_callback_invoke(desc->async_tx, NULL);
 }
 
-static void sf_pdma_errbh_tasklet(unsigned long arg)
+static void sf_pdma_errbh_tasklet(struct tasklet_struct *t)
 {
-	struct sf_pdma_chan *chan = (struct sf_pdma_chan *)arg;
+	struct sf_pdma_chan *chan = from_tasklet(chan, t, err_tasklet);
 	struct sf_pdma_desc *desc = chan->desc;
 	unsigned long flags;
 
@@ -476,10 +476,8 @@ static void sf_pdma_setup_chans(struct sf_pdma *pdma)
 
 		writel(PDMA_CLEAR_CTRL, chan->regs.ctrl);
 
-		tasklet_init(&chan->done_tasklet,
-			     sf_pdma_donebh_tasklet, (unsigned long)chan);
-		tasklet_init(&chan->err_tasklet,
-			     sf_pdma_errbh_tasklet, (unsigned long)chan);
+		tasklet_setup(&chan->done_tasklet, sf_pdma_donebh_tasklet);
+		tasklet_setup(&chan->err_tasklet, sf_pdma_errbh_tasklet);
 	}
 }
 
-- 
2.17.1

