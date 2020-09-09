Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A747326382F
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgIIVFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:05:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729876AbgIIVFq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 17:05:46 -0400
Received: from lore-desk.redhat.com (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8836C20BED;
        Wed,  9 Sep 2020 21:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599685546;
        bh=jnavtOrpEXRrYtbiMLyW5T0GKSbDx1+ePk/fZYobvgM=;
        h=From:To:Cc:Subject:Date:From;
        b=pJ3gySlez3ZEGn0TXDvpaYGRB3NAI7MhqumCbJ9y8Urb4IxxOR463ytzpYJi03BGI
         lPDy2dN6RLLyg31WQ0uQzZ/i+XhipIsu3CvtcgaRS1Gi9CXxGYHknLCRibC/CnMaCf
         P2wLH9e7S6jXOw3mfeLZE3K5mKQn7wLj6XLYyQWw=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        echaudro@redhat.com
Subject: [PATCH net-next] net: mventa: drop mvneta_stats from mvneta_swbm_rx_frame signature
Date:   Wed,  9 Sep 2020 23:05:23 +0200
Message-Id: <24f6f0436b4c574b3c2ab83503ba4004078d6dbe.1599685320.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove mvneta_stats from mvneta_swbm_rx_frame signature since now stats
are accounted in mvneta_run_xdp routine

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index fa3c0b9f69fe..f75e05e899bb 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2226,8 +2226,7 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 		     struct mvneta_rx_desc *rx_desc,
 		     struct mvneta_rx_queue *rxq,
 		     struct xdp_buff *xdp, int *size,
-		     struct page *page,
-		     struct mvneta_stats *stats)
+		     struct page *page)
 {
 	unsigned char *data = page_address(page);
 	int data_len = -MVNETA_MH_SIZE, len;
@@ -2380,7 +2379,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			desc_status = rx_desc->status;
 
 			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
-					     &size, page, &ps);
+					     &size, page);
 		} else {
 			if (unlikely(!xdp_buf.data_hard_start))
 				continue;
-- 
2.26.2

