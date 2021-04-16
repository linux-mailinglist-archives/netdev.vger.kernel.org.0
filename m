Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A925A362A32
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344327AbhDPVXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244459AbhDPVXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 17:23:35 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF38AC061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:09 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h20so14663207plr.4
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o6qUF/9QARUcG0OSjqxHZaTtsldWq9ieK8qJAMVi9t4=;
        b=QrKUqzbgvxPLR0BHflxtBCPZYWgqQO8kpHRRi4XM68T+FAqQSc94lVItq5Ijerya50
         NoR1o3/jiZcyiyEwVLZYljaApOJW846SxR7DgVoMn5TD12eTO5jyHp2POkMTUZLdofRz
         YweaqICcjhTJAzLrPaaNzcEr1dXgCIh9krY5ReUx3GEBke6FJwHPdeeEobvyLRvfvezQ
         zJ/OIxKfQQFV/HDCNth1TF4HkqhWLE8OIURkChMzRtjOX7VfbHMB0jPVU87zv9kjsKOz
         GzdpryvEJQp1NAf3BXDAdLK0zESqTeei0LZ9yL4/Tm+8AfklQa8wUgUOf2f4I9urJ8kl
         1MGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o6qUF/9QARUcG0OSjqxHZaTtsldWq9ieK8qJAMVi9t4=;
        b=GPPGatT3m4DtP+zVO4xWfaNHJeUNwlQcMXgmwuGMXWwQKfjYFdMFS8qaLo/c5asnC3
         ZovJBbYs5RoHg4b1aHU1CF/yHvRy5xIxOyqfpTEm476SpjFphe7XROx012FmWs93hYDf
         J+VpYfUsNAJYzTFgSMMBL6CGJ1r9hZ4ynMJXnopJwmpEHzJF33MVprPCutpxRKllVPuK
         RV1zyeXVxYAuktomoRV188bSc+0oqHPfUGwNYo8IM7anl2Ir5sxdnyf1mrw7kczsAaEU
         0b1nQMDnFOOghlVtzXyp/mnuvHofxWOzYFkAXmUKmpTOeDZFCkwIN5ML/D0ZwW2bBEh4
         gkrw==
X-Gm-Message-State: AOAM531NEIwt13qktNa/aFaqcjRsdbPZIS0VcFGUxXwOveT1lojiFWCC
        VmoWeWkjG4Z2g5sW9V2ca3U=
X-Google-Smtp-Source: ABdhPJwz4jzRlYGGlW1GGRpWciz9xFPwC12rQ5IjbGZSMNvjTWQkTVxlzHuj95yulp1Cp/zgZRJgmw==
X-Received: by 2002:a17:902:fe8a:b029:e6:5f:62e with SMTP id x10-20020a170902fe8ab02900e6005f062emr11407676plm.48.1618608189298;
        Fri, 16 Apr 2021 14:23:09 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t23sm6069132pju.15.2021.04.16.14.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 14:23:08 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 02/10] net: enetc: rename the buffer reuse helpers
Date:   Sat, 17 Apr 2021 00:22:17 +0300
Message-Id: <20210416212225.3576792-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416212225.3576792-1-olteanv@gmail.com>
References: <20210416212225.3576792-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

enetc_put_xdp_buff has nothing to do with XDP, frankly, it is just a
helper to populate the recycle end of the shadow RX BD ring
(next_to_alloc) with a given buffer.

On the other hand, enetc_put_rx_buff plays more tricks than its name
would suggest.

So let's rename enetc_put_rx_buff into enetc_flip_rx_buff to reflect the
half-page buffer reuse tricks that it employs, and enetc_put_xdp_buff
into enetc_put_rx_buff which suggests a more garden-variety operation.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 54 +++++++++-----------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index c7f3c6e691a1..c4ff090f29ec 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -751,27 +751,35 @@ static struct enetc_rx_swbd *enetc_get_rx_buff(struct enetc_bdr *rx_ring,
 	return rx_swbd;
 }
 
+/* Reuse the current page without performing half-page buffer flipping */
 static void enetc_put_rx_buff(struct enetc_bdr *rx_ring,
 			      struct enetc_rx_swbd *rx_swbd)
 {
-	if (likely(enetc_page_reusable(rx_swbd->page))) {
-		size_t buffer_size = ENETC_RXB_TRUESIZE - rx_ring->buffer_offset;
+	size_t buffer_size = ENETC_RXB_TRUESIZE - rx_ring->buffer_offset;
+
+	enetc_reuse_page(rx_ring, rx_swbd);
 
+	dma_sync_single_range_for_device(rx_ring->dev, rx_swbd->dma,
+					 rx_swbd->page_offset,
+					 buffer_size, rx_swbd->dir);
+
+	rx_swbd->page = NULL;
+}
+
+/* Reuse the current page by performing half-page buffer flipping */
+static void enetc_flip_rx_buff(struct enetc_bdr *rx_ring,
+			       struct enetc_rx_swbd *rx_swbd)
+{
+	if (likely(enetc_page_reusable(rx_swbd->page))) {
 		rx_swbd->page_offset ^= ENETC_RXB_TRUESIZE;
 		page_ref_inc(rx_swbd->page);
 
-		enetc_reuse_page(rx_ring, rx_swbd);
-
-		/* sync for use by the device */
-		dma_sync_single_range_for_device(rx_ring->dev, rx_swbd->dma,
-						 rx_swbd->page_offset,
-						 buffer_size, rx_swbd->dir);
+		enetc_put_rx_buff(rx_ring, rx_swbd);
 	} else {
 		dma_unmap_page(rx_ring->dev, rx_swbd->dma, PAGE_SIZE,
 			       rx_swbd->dir);
+		rx_swbd->page = NULL;
 	}
-
-	rx_swbd->page = NULL;
 }
 
 static struct sk_buff *enetc_map_rx_buff_to_skb(struct enetc_bdr *rx_ring,
@@ -791,7 +799,7 @@ static struct sk_buff *enetc_map_rx_buff_to_skb(struct enetc_bdr *rx_ring,
 	skb_reserve(skb, rx_ring->buffer_offset);
 	__skb_put(skb, size);
 
-	enetc_put_rx_buff(rx_ring, rx_swbd);
+	enetc_flip_rx_buff(rx_ring, rx_swbd);
 
 	return skb;
 }
@@ -804,7 +812,7 @@ static void enetc_add_rx_buff_to_skb(struct enetc_bdr *rx_ring, int i,
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_swbd->page,
 			rx_swbd->page_offset, size, ENETC_RXB_TRUESIZE);
 
-	enetc_put_rx_buff(rx_ring, rx_swbd);
+	enetc_flip_rx_buff(rx_ring, rx_swbd);
 }
 
 static bool enetc_check_bd_errors_and_consume(struct enetc_bdr *rx_ring,
@@ -1142,20 +1150,6 @@ static void enetc_build_xdp_buff(struct enetc_bdr *rx_ring, u32 bd_status,
 	}
 }
 
-/* Reuse the current page without performing half-page buffer flipping */
-static void enetc_put_xdp_buff(struct enetc_bdr *rx_ring,
-			       struct enetc_rx_swbd *rx_swbd)
-{
-	enetc_reuse_page(rx_ring, rx_swbd);
-
-	dma_sync_single_range_for_device(rx_ring->dev, rx_swbd->dma,
-					 rx_swbd->page_offset,
-					 ENETC_RXB_DMA_SIZE_XDP,
-					 rx_swbd->dir);
-
-	rx_swbd->page = NULL;
-}
-
 /* Convert RX buffer descriptors to TX buffer descriptors. These will be
  * recycled back into the RX ring in enetc_clean_tx_ring. We need to scrub the
  * RX software BDs because the ownership of the buffer no longer belongs to the
@@ -1194,8 +1188,8 @@ static void enetc_xdp_drop(struct enetc_bdr *rx_ring, int rx_ring_first,
 			   int rx_ring_last)
 {
 	while (rx_ring_first != rx_ring_last) {
-		enetc_put_xdp_buff(rx_ring,
-				   &rx_ring->rx_swbd[rx_ring_first]);
+		enetc_put_rx_buff(rx_ring,
+				  &rx_ring->rx_swbd[rx_ring_first]);
 		enetc_bdr_idx_inc(rx_ring, &rx_ring_first);
 	}
 	rx_ring->stats.xdp_drops++;
@@ -1316,8 +1310,8 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 			tmp_orig_i = orig_i;
 
 			while (orig_i != i) {
-				enetc_put_rx_buff(rx_ring,
-						  &rx_ring->rx_swbd[orig_i]);
+				enetc_flip_rx_buff(rx_ring,
+						   &rx_ring->rx_swbd[orig_i]);
 				enetc_bdr_idx_inc(rx_ring, &orig_i);
 			}
 
-- 
2.25.1

