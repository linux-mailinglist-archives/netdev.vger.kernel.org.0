Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBFC2356E2
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 14:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgHBMWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 08:22:44 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:44801 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgHBMWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 08:22:39 -0400
Received: from localhost.localdomain ([93.22.148.198])
        by mwinf5d46 with ME
        id AcNV230034H42jh03cNV1n; Sun, 02 Aug 2020 14:22:35 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 02 Aug 2020 14:22:35 +0200
X-ME-IP: 93.22.148.198
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        pillair@codeaurora.org
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ath10k: Fix the size used in a 'dma_free_coherent()' call in an error handling path
Date:   Sun,  2 Aug 2020 14:22:27 +0200
Message-Id: <20200802122227.678637-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the size used in 'dma_free_coherent()' in order to match the one
used in the corresponding 'dma_alloc_coherent()'.

Fixes: 1863008369ae ("ath10k: fix shadow register implementation for WCN3990")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch looks obvious to me, but commit 1863008369ae looks also simple.
So it is surprising that such a "typo" slipped in.
---
 drivers/net/wireless/ath/ath10k/ce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 294fbc1e89ab..e6e0284e4783 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1555,7 +1555,7 @@ ath10k_ce_alloc_src_ring(struct ath10k *ar, unsigned int ce_id,
 		ret = ath10k_ce_alloc_shadow_base(ar, src_ring, nentries);
 		if (ret) {
 			dma_free_coherent(ar->dev,
-					  (nentries * sizeof(struct ce_desc_64) +
+					  (nentries * sizeof(struct ce_desc) +
 					   CE_DESC_RING_ALIGN),
 					  src_ring->base_addr_owner_space_unaligned,
 					  base_addr);
-- 
2.25.1

