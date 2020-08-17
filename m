Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FAA245F5D
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgHQIU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgHQISo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:18:44 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39ACC061388;
        Mon, 17 Aug 2020 01:18:44 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id m8so7871549pfh.3;
        Mon, 17 Aug 2020 01:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KmEcBHcde06arqa/qnAKRl0EaY2afCtuj8GLj4ZTRM0=;
        b=ZPj6GIc3bq6Ex5uJOYWUiGSZFLN/814K7fHM5oA+Mq5dpIS8LCQPwVQNUGtj44Ywuf
         8JGtsTJ5CYKCtK8MFgtkNaoVPuAzeoHi+Tf3kpf+KX/PviAbimyTxiPKekd25Jr4pMVy
         UCEnQYTEvlOVJ0m/i6dJ8djGZdkbONwIig2dW9klIJEKOz/te71+Z0SNAVizpQ8BCtCA
         WFL7ORtS8TH2YerqRUJ9EvA9XeGa7yQV7z9UH/4tqceHCXwSO0uNAaMdNJMJH8OlIb5H
         U/inY8+aVvTB9Fx/gLIu/Qpk4P+/FpisLIjv90NGEiWRW3fmCAqamLg/CeJUW/Ku0hVg
         fRaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KmEcBHcde06arqa/qnAKRl0EaY2afCtuj8GLj4ZTRM0=;
        b=lASCnhsKP8DQLAvf6i+z2GReozSV3NDJzh3yz7xTtw8L2AfKrrIofII8y4cJBmUjZU
         7j+iSThynhTXDpy8dP2uiU3xbSI7IpGHTlSRWIonXxy1zExip9NGh7zeTkrAdQ5bH6uu
         24BkViMqCULVmxJUjOm6kJ+JSy32UzLuU1hlnmzs9ykzN6vRc2hW93xD+x4kymUnGuMz
         ufwxZRzpOvFAtlxGITvinNMzBONZq1jAdgcZ2CFOAW/RvPN3cG5zz6QDP4ZWuwkFERL1
         kR8NEN/8Uji9iExbBAVBho6PzSMCMvZ16ln9f7czsk1I+tZNZQHEhw08c4mPMQwLPy8F
         tA+A==
X-Gm-Message-State: AOAM530H16M9DFx1ycgsAEIhW+9OxlthxvSxZ5Br1JnSWNORbHL5Dm6x
        M3+X8/3VIUcF+8xsvBi1WE8=
X-Google-Smtp-Source: ABdhPJzTO4xmXekUKvlKfpAmGwBic+Bzzl9KrxVjZgG/u8ypYaxKauNmxFYJuyl0vzE9Xwqlt1/nCA==
X-Received: by 2002:a63:ed07:: with SMTP id d7mr8896251pgi.414.1597652324466;
        Mon, 17 Aug 2020 01:18:44 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:18:44 -0700 (PDT)
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
Subject: [PATCH 06/35] dma: ep93xx: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:46:57 +0530
Message-Id: <20200817081726.20213-7-allen.lkml@gmail.com>
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
 drivers/dma/ep93xx_dma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index 87a246012629..01027779beb8 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -745,9 +745,9 @@ static void ep93xx_dma_advance_work(struct ep93xx_dma_chan *edmac)
 	spin_unlock_irqrestore(&edmac->lock, flags);
 }
 
-static void ep93xx_dma_tasklet(unsigned long data)
+static void ep93xx_dma_tasklet(struct tasklet_struct *t)
 {
-	struct ep93xx_dma_chan *edmac = (struct ep93xx_dma_chan *)data;
+	struct ep93xx_dma_chan *edmac = from_tasklet(edmac, t, tasklet);
 	struct ep93xx_dma_desc *desc, *d;
 	struct dmaengine_desc_callback cb;
 	LIST_HEAD(list);
@@ -1353,8 +1353,7 @@ static int __init ep93xx_dma_probe(struct platform_device *pdev)
 		INIT_LIST_HEAD(&edmac->active);
 		INIT_LIST_HEAD(&edmac->queue);
 		INIT_LIST_HEAD(&edmac->free_list);
-		tasklet_init(&edmac->tasklet, ep93xx_dma_tasklet,
-			     (unsigned long)edmac);
+		tasklet_setup(&edmac->tasklet, ep93xx_dma_tasklet);
 
 		list_add_tail(&edmac->chan.device_node,
 			      &dma_dev->channels);
-- 
2.17.1

