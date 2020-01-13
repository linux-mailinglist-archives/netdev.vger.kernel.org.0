Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0690D138DC6
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 10:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgAMJ21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 04:28:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:53510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbgAMJ21 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 04:28:27 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC4602082E;
        Mon, 13 Jan 2020 09:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578907706;
        bh=ygHpcQTSgJvmKr3qjvk9ydPGZAd2LHo2CwCBvdhfPC4=;
        h=From:To:Cc:Subject:Date:From;
        b=w9exuz7KHMROvwGdNxLoCen/gV4UdgaylbyEkNUVSb1VZzHmlXDjogTXV++MxFrFW
         2XMsiuTTamb0wp2XkwbeR8mcHzSckj4yPn1hqGp0Bc+sc3ePYjSZte7P0neXVsXIg7
         fAOmEhHjtjtr0U8vAbVqQKIPZ5ghHKO1jdEWbTBY=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, brouer@redhat.com
Subject: [PATCH] net: mvneta: change page pool nid to NUMA_NO_NODE
Date:   Mon, 13 Jan 2020 10:28:12 +0100
Message-Id: <70183613cb1a0253f25709e640d88cdd0584a813.1578907338.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With 'commit 44768decb7c0 ("page_pool: handle page recycle for NUMA_NO_NODE
condition")' we can safely change nid to NUMA_NO_NODE and accommodate
future NUMA aware hardware using mvneta network interface

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index dcf831005ce6..4b4b2177982d 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3072,7 +3072,7 @@ static int mvneta_create_page_pool(struct mvneta_port *pp,
 		.order = 0,
 		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
 		.pool_size = size,
-		.nid = cpu_to_node(0),
+		.nid = NUMA_NO_NODE,
 		.dev = pp->dev->dev.parent,
 		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
 		.offset = pp->rx_offset_correction,
-- 
2.21.1

