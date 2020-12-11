Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162DC2D7275
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 10:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437305AbgLKJAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 04:00:45 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:54978 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389034AbgLKJAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 04:00:19 -0500
Received: from localhost.localdomain (unknown [124.16.141.241])
        by APP-05 (Coremail) with SMTP id zQCowADX1HjrNNNfGmwDAA--.10988S2;
        Fri, 11 Dec 2020 16:59:24 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] net: qlcnic: remove casting dma_alloc_coherent
Date:   Fri, 11 Dec 2020 08:59:20 +0000
Message-Id: <20201211085920.85807-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: zQCowADX1HjrNNNfGmwDAA--.10988S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xw15CFWrWFWfAFyxJrykGrg_yoWfAwb_WF
        WkZr1rXa15Jryqkw47trW7J34a9FZ7Zan5A3WIgayaq34DAF4UW34UJryxZr47W3yfCFyU
        G3W3t3y3Aw1I9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbwAYjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVW8Jr0_Cr
        1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCF
        x2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14
        v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY
        67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2
        IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAF
        wI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j1tC7UUUUU=
X-Originating-IP: [124.16.141.241]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCgcHA1z4jNw3IQAAsr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove casting the values returned by dma_alloc_coherent.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
index 87f76bac2e46..c263c7769444 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
@@ -569,7 +569,7 @@ int qlcnic_alloc_hw_resources(struct qlcnic_adapter *adapter)
 
 	for (ring = 0; ring < adapter->drv_tx_rings; ring++) {
 		tx_ring = &adapter->tx_ring[ring];
-		ptr = (__le32 *)dma_alloc_coherent(&pdev->dev, sizeof(u32),
+		ptr = dma_alloc_coherent(&pdev->dev, sizeof(u32),
 					 &tx_ring->hw_cons_phys_addr,
 					 GFP_KERNEL);
 		if (ptr == NULL) {
-- 
2.17.1

