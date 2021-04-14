Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED7A35F73E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbhDNPKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbhDNPJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:09:56 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D78C061574;
        Wed, 14 Apr 2021 08:09:31 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id w3so31986530ejc.4;
        Wed, 14 Apr 2021 08:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zNR2ZsKG0MRQTk4mD0NvQOy/soVEyxQ0ldq25AQksjU=;
        b=C3Yt5HKq2DA42QPLSGFQ6rIKSXSvi5Av5qONZYPdUAuuS2MLNB7xVpf/YqaCFK7+4w
         A+Io5pZdzfTqdNTdFcQVL94NyD9U9bX6oG3exNQ8bPvkJuGMmQsututfI9NB9I6oOFSW
         1oyyCy5EWK8k0EYT1k/HcZRCZYQx5NkBPw/6+SfEIBw30WeXOj5r0tWhppZ81IglNicu
         lKkM+jAdSn3q3aMsFdTi8sFB/x7Srtz62XegHLMGCKho/XdskJy7mOLP1wme3S02rjXt
         qloWBnGfxeI3Vk0gh927xTyfMMbF0YUvg3KH6gRis6wAkbVRGd/dn4hP6tsnZ1wIZ4Bs
         tpzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zNR2ZsKG0MRQTk4mD0NvQOy/soVEyxQ0ldq25AQksjU=;
        b=bTcs4U3eMh6/0fbi5UmRcfWeFJJfli6QvG6Qc3wocHwGUMY4ZwbqGmtNj9oeMGAcF/
         aTycg6SaFRdbv0Yh08eS6hXqAskvr21FBTFWNEMqWjRnzEtVra7mUIVcY9LJBrJYpEtY
         WWZWCsRgJbNqTB6jmKFssTEK5eIq7E4KkpzpqxbInUktgJjkKFwavwAEAbJvEEPFWlIE
         b2QT1IULW+2ee2Fl4zZBBwkiSz992Syt4nIWYw2lC13MKepcSUPt3ynIrjtKAQqDwGP3
         sRykJZzViGnz/EI5sC00CElUqzhRamnf4o7vxxXR0POXZSZ8j7gd4ZlS7t49gCD5P+eY
         4WUw==
X-Gm-Message-State: AOAM531C7Lg7nTO14nxEIYUSnhTU8t9/SyTf/nNHnGTloHSSBB2S+HGi
        RbZwSEBWyeGlJ+vcTup7m7g=
X-Google-Smtp-Source: ABdhPJxAGK2RrBeKzGTzZ8ahx4LH8T7RyrUrkuaKAOvYb5UIouS+9BS9WQkpmNrdus7QPZ76ge0MSg==
X-Received: by 2002:a17:906:7104:: with SMTP id x4mr12087306ejj.101.1618412970611;
        Wed, 14 Apr 2021 08:09:30 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id n11sm2048695edo.15.2021.04.14.08.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 08:09:29 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH] Revert "net: stmmac: re-init rx buffers when mac resume back"
Date:   Wed, 14 Apr 2021 17:10:07 +0200
Message-Id: <20210414151007.563698-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This reverts commit 9c63faaa931e443e7abbbee9de0169f1d4710546, which
introduces a suspend/resume regression on Jetson TX2 boards that can be
reproduced every time. Given that the issue that this was supposed to
fix only occurs very sporadically the safest course of action is to
revert before v5.12 and then we can have another go at fixing the more
rare issue in the next release (and perhaps backport it if necessary).

The root cause of the observed problem seems to be that when the system
is suspended, some packets are still in transit. When the descriptors
for these buffers are cleared on resume, the descriptors become invalid
and cause a fatal bus error.

Link: https://lore.kernel.org/r/708edb92-a5df-ecc4-3126-5ab36707e275@nvidia.com/
Reported-by: Jonathan Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
David, Jakub,

I noticed that a couple of patches got merged on top of this in
net-next, so the revert is going to cause conflicts. However, I've based
this revert on v5.12-rc7 because it targets v5.12. Let me know if I can
help resolve the conflict with net-next.

Thierry

 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 84 +------------------
 1 file changed, 1 insertion(+), 83 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 208cae344ffa..4749bd0af160 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1379,88 +1379,6 @@ static void stmmac_free_tx_buffer(struct stmmac_priv *priv, u32 queue, int i)
 	}
 }
 
-/**
- * stmmac_reinit_rx_buffers - reinit the RX descriptor buffer.
- * @priv: driver private structure
- * Description: this function is called to re-allocate a receive buffer, perform
- * the DMA mapping and init the descriptor.
- */
-static void stmmac_reinit_rx_buffers(struct stmmac_priv *priv)
-{
-	u32 rx_count = priv->plat->rx_queues_to_use;
-	u32 queue;
-	int i;
-
-	for (queue = 0; queue < rx_count; queue++) {
-		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
-
-		for (i = 0; i < priv->dma_rx_size; i++) {
-			struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
-
-			if (buf->page) {
-				page_pool_recycle_direct(rx_q->page_pool, buf->page);
-				buf->page = NULL;
-			}
-
-			if (priv->sph && buf->sec_page) {
-				page_pool_recycle_direct(rx_q->page_pool, buf->sec_page);
-				buf->sec_page = NULL;
-			}
-		}
-	}
-
-	for (queue = 0; queue < rx_count; queue++) {
-		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
-
-		for (i = 0; i < priv->dma_rx_size; i++) {
-			struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
-			struct dma_desc *p;
-
-			if (priv->extend_desc)
-				p = &((rx_q->dma_erx + i)->basic);
-			else
-				p = rx_q->dma_rx + i;
-
-			if (!buf->page) {
-				buf->page = page_pool_dev_alloc_pages(rx_q->page_pool);
-				if (!buf->page)
-					goto err_reinit_rx_buffers;
-
-				buf->addr = page_pool_get_dma_addr(buf->page);
-			}
-
-			if (priv->sph && !buf->sec_page) {
-				buf->sec_page = page_pool_dev_alloc_pages(rx_q->page_pool);
-				if (!buf->sec_page)
-					goto err_reinit_rx_buffers;
-
-				buf->sec_addr = page_pool_get_dma_addr(buf->sec_page);
-			}
-
-			stmmac_set_desc_addr(priv, p, buf->addr);
-			if (priv->sph)
-				stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, true);
-			else
-				stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, false);
-			if (priv->dma_buf_sz == BUF_SIZE_16KiB)
-				stmmac_init_desc3(priv, p);
-		}
-	}
-
-	return;
-
-err_reinit_rx_buffers:
-	do {
-		while (--i >= 0)
-			stmmac_free_rx_buffer(priv, queue, i);
-
-		if (queue == 0)
-			break;
-
-		i = priv->dma_rx_size;
-	} while (queue-- > 0);
-}
-
 /**
  * init_dma_rx_desc_rings - init the RX descriptor rings
  * @dev: net device structure
@@ -5428,7 +5346,7 @@ int stmmac_resume(struct device *dev)
 	mutex_lock(&priv->lock);
 
 	stmmac_reset_queues_param(priv);
-	stmmac_reinit_rx_buffers(priv);
+
 	stmmac_free_tx_skbufs(priv);
 	stmmac_clear_descriptors(priv);
 
-- 
2.30.2

