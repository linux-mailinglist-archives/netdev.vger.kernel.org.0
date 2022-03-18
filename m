Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EED4DE2E9
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240884AbiCRUyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240863AbiCRUyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B0CDECE
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:53:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E5D760DB9
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616B0C340E8;
        Fri, 18 Mar 2022 20:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636794;
        bh=TP6PdUvovSb01HJ++NN4PdrlMD7bwKEH3q0W1Cd9Efo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pe/iqAE40KHXkWn0pG+Ib7n5zAeJopKAdUJ6vaq/O8LxLiRsfuIFkNtq8hd4fCiCP
         vle1dExcXEeJeUZIdDPDX2/ev7f3Yg5AuyelLo+nPzUi4sjS86yrI35drrxT+dG55e
         fmD2Qz8stD08DVVcL/Fmm1CIA3VPNGlO2F6BJiIJlwaoQVu4WzmdKnSPHRWeLcEInV
         9qJVtUDxZwqvgy+KivxpBGOCHeukqfaZrnMIgNxljg7q+v26Yp/0tyhML7Qx/hnPzi
         3SFMqEtV0PTPWe2dCBZ4zA2cJHNL9LXtE5c0dWiReuuhXJfkHnPFWyeB66zGk0yUOI
         iHdLX7sk59TeA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: Unindent the else-block in mlx5e_xmit_xdp_buff
Date:   Fri, 18 Mar 2022 13:52:43 -0700
Message-Id: <20220318205248.33367-11-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220318205248.33367-1-saeed@kernel.org>
References: <20220318205248.33367-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

The next commit will add more indentation levels to mlx5e_xmit_xdp_buff.
To keep indentation minimal, unindent the else-block of the if-statement
by doing an early return.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 34 +++++++++++--------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 52e0f0028c35..368e54949614 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -101,24 +101,30 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 		xdptxd.dma_addr     = dma_addr;
 		xdpi.frame.xdpf     = xdpf;
 		xdpi.frame.dma_addr = dma_addr;
-	} else {
-		/* Driver assumes that xdp_convert_buff_to_frame returns
-		 * an xdp_frame that points to the same memory region as
-		 * the original xdp_buff. It allows to map the memory only
-		 * once and to use the DMA_BIDIRECTIONAL mode.
-		 */
-
-		xdpi.mode = MLX5E_XDP_XMIT_MODE_PAGE;
 
-		dma_addr = page_pool_get_dma_addr(page) + (xdpf->data - (void *)xdpf);
-		dma_sync_single_for_device(sq->pdev, dma_addr, xdptxd.len,
-					   DMA_TO_DEVICE);
+		if (unlikely(!INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
+					      mlx5e_xmit_xdp_frame, sq, &xdptxd, NULL, 0)))
+			return false;
 
-		xdptxd.dma_addr = dma_addr;
-		xdpi.page.rq    = rq;
-		xdpi.page.page = page;
+		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
+		return true;
 	}
 
+	/* Driver assumes that xdp_convert_buff_to_frame returns an xdp_frame
+	 * that points to the same memory region as the original xdp_buff. It
+	 * allows to map the memory only once and to use the DMA_BIDIRECTIONAL
+	 * mode.
+	 */
+
+	xdpi.mode = MLX5E_XDP_XMIT_MODE_PAGE;
+
+	dma_addr = page_pool_get_dma_addr(page) + (xdpf->data - (void *)xdpf);
+	dma_sync_single_for_device(sq->pdev, dma_addr, xdptxd.len, DMA_TO_DEVICE);
+
+	xdptxd.dma_addr = dma_addr;
+	xdpi.page.rq = rq;
+	xdpi.page.page = page;
+
 	if (unlikely(!INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
 				      mlx5e_xmit_xdp_frame, sq, &xdptxd, NULL, 0)))
 		return false;
-- 
2.35.1

