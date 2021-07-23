Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C303D4360
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 01:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbhGWWjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 18:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbhGWWjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 18:39:40 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880CEC061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 16:20:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v4-20020a2583c40000b029055bc7fcfebdso4032454ybm.12
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 16:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=EZlokOB22z2MIAKScM9ZvB/rZGXlyCqa4nDdA9q2Lcc=;
        b=bln5N38XacwjEbHwprh0u2jFDNvgajEy7vS+hGZVUEgcN8PVIVKVSUwL5oNi1x+bjE
         HE+dWl/Mug5kzxEk4UV87rj5oRaUW7nkxxLWY+zau2OyL1wQ81I4AmYuGa1opAo+x0eC
         7Mez9SenfgLWGXMrQj1dlXxTvwTBWUe4Y/e06UseddfdgarJnbqp5QjSP31EP6bQY3NB
         vrDNMSKOzYdDHg+0pLw/xdo6jMn/wtnzl5rlZMPSp3QgCnVv7NegN+GjdvkdrH3ZJkgo
         i1oxYkYZlft9qh95FvTm+9VUGEkom2C3/jHdc32UitovQAIXDGbU/tUyLVbYL/lyM/TX
         fLKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=EZlokOB22z2MIAKScM9ZvB/rZGXlyCqa4nDdA9q2Lcc=;
        b=Vz3T9Jp+7F2e3bk86DukUZCwFaQc4pCmk/OSdK37/5bvm4xY6AigQx5oPyTyLH+0Qz
         X3xgRWk9UNK56YqTECWs+tuy/Lx1NuDhFMT7fS0OVupdnAMaj3x8BKD3px47dJpH6Z2X
         Pttpzb+F/Ek5c4Gdxwk0Bvf53r0NaEGdX/7V7wSVgRfXc47VcryBzdyeOrLOUBDfXMgC
         Cij4mgylv+sNFH7FxJaZwxhwCqNO9oaGlWlYiaKYgtDs+LSozGS81Rp9+NDbAPK3W5bN
         l68w4ggGWhq8tPShvnDIRHBiEYWCpQucpuiAeWuM6/h8ExUAv4X6kl6Oh5sq3ccBjS5C
         /7Dw==
X-Gm-Message-State: AOAM531Fxxgn1W1aoPLIa1qsrW25psCrbOLqQjv4BSvJlSdBprQinZfW
        9Uh6f/EzvjXq9FU1mEXX2BWlOHI=
X-Google-Smtp-Source: ABdhPJyBncCC5MFfRqFAp19aFSPhyrbRa2Bss6DkIyb7TwUMo+nv8b1sqpb6DANMAjAo/UkZYUy4ZOI=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:25f:31ee:ddb4:a885])
 (user=bcf job=sendgmr) by 2002:a25:b98d:: with SMTP id r13mr9381041ybg.430.1627082412783;
 Fri, 23 Jul 2021 16:20:12 -0700 (PDT)
Date:   Fri, 23 Jul 2021 16:19:57 -0700
Message-Id: <20210723231957.1113800-1-bcf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH net] gve: DQO: Suppress unused var warnings
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some variables become unused when `CONFIG_NEED_DMA_MAP_STATE=n`.

We only suppress when `CONFIG_NEED_DMA_MAP_STATE=n` in order to avoid
false negatives.

Fixes: a57e5de476be ("gve: DQO: Add TX path")
Signed-off-by: Bailey Forrest <bcf@google.com>
---
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index 05ddb6a75c38..f873321c022e 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -87,6 +87,9 @@ static void gve_tx_clean_pending_packets(struct gve_tx_ring *tx)
 		for (j = 0; j < cur_state->num_bufs; j++) {
 			struct gve_tx_dma_buf *buf = &cur_state->bufs[j];
 
+#ifndef CONFIG_NEED_DMA_MAP_STATE
+			(void)buf;  // Suppress unused variable.
+#endif
 			if (j == 0) {
 				dma_unmap_single(tx->dev,
 						 dma_unmap_addr(buf, dma),
@@ -459,9 +462,14 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 
 	struct gve_tx_pending_packet_dqo *pending_packet;
 	struct gve_tx_metadata_dqo metadata;
+	struct gve_tx_dma_buf *buf;
 	s16 completion_tag;
 	int i;
 
+#ifndef CONFIG_NEED_DMA_MAP_STATE
+	(void)buf;  // Suppress unused variable.
+#endif
+
 	pending_packet = gve_alloc_pending_packet(tx);
 	pending_packet->skb = skb;
 	pending_packet->num_bufs = 0;
@@ -493,8 +501,6 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 
 	/* Map the linear portion of skb */
 	{
-		struct gve_tx_dma_buf *buf =
-			&pending_packet->bufs[pending_packet->num_bufs];
 		u32 len = skb_headlen(skb);
 		dma_addr_t addr;
 
@@ -502,6 +508,7 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 		if (unlikely(dma_mapping_error(tx->dev, addr)))
 			goto err;
 
+		buf = &pending_packet->bufs[pending_packet->num_bufs];
 		dma_unmap_len_set(buf, len, len);
 		dma_unmap_addr_set(buf, dma, addr);
 		++pending_packet->num_bufs;
@@ -512,8 +519,6 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 	}
 
 	for (i = 0; i < shinfo->nr_frags; i++) {
-		struct gve_tx_dma_buf *buf =
-			&pending_packet->bufs[pending_packet->num_bufs];
 		const skb_frag_t *frag = &shinfo->frags[i];
 		bool is_eop = i == (shinfo->nr_frags - 1);
 		u32 len = skb_frag_size(frag);
@@ -523,6 +528,7 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 		if (unlikely(dma_mapping_error(tx->dev, addr)))
 			goto err;
 
+		buf = &pending_packet->bufs[pending_packet->num_bufs];
 		dma_unmap_len_set(buf, len, len);
 		dma_unmap_addr_set(buf, dma, addr);
 		++pending_packet->num_bufs;
@@ -555,6 +561,9 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 	for (i = 0; i < pending_packet->num_bufs; i++) {
 		struct gve_tx_dma_buf *buf = &pending_packet->bufs[i];
 
+#ifndef CONFIG_NEED_DMA_MAP_STATE
+		(void)buf;  // Suppress unused variable.
+#endif
 		if (i == 0) {
 			dma_unmap_single(tx->dev, dma_unmap_addr(buf, dma),
 					 dma_unmap_len(buf, len),
-- 
2.32.0.432.gabb21c7263-goog

