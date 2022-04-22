Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B13750BAFE
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449107AbiDVPCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449101AbiDVPCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:02:08 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E70FA5D189
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 07:59:07 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id E245F320133;
        Fri, 22 Apr 2022 15:59:04 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhukR-00079q-2s; Fri, 22 Apr 2022 15:59:03 +0100
Subject: [PATCH net-next 09/28] sfc/siena: Remove unused functions in tx.h
 to avoid conflicts with sfc
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 15:59:01 +0100
Message-ID: <165063954186.27138.18272619085324035103.stgit@palantir17.mph.net>
In-Reply-To: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Habets <martinh@xilinx.com>

Several functions are not used in Siena, so they are removed.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/tx.c |    8 --------
 drivers/net/ethernet/sfc/siena/tx.h |    7 -------
 2 files changed, 15 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/tx.c b/drivers/net/ethernet/sfc/siena/tx.c
index 9199cddfa536..bfc15c018e66 100644
--- a/drivers/net/ethernet/sfc/siena/tx.c
+++ b/drivers/net/ethernet/sfc/siena/tx.c
@@ -41,14 +41,6 @@ static inline u8 *efx_tx_get_copy_buffer(struct efx_tx_queue *tx_queue,
 	return (u8 *)page_buf->addr + offset;
 }
 
-u8 *efx_tx_get_copy_buffer_limited(struct efx_tx_queue *tx_queue,
-				   struct efx_tx_buffer *buffer, size_t len)
-{
-	if (len > EFX_TX_CB_SIZE)
-		return NULL;
-	return efx_tx_get_copy_buffer(tx_queue, buffer);
-}
-
 static void efx_tx_maybe_stop_queue(struct efx_tx_queue *txq1)
 {
 	/* We need to consider all queues that the net core sees as one */
diff --git a/drivers/net/ethernet/sfc/siena/tx.h b/drivers/net/ethernet/sfc/siena/tx.h
index f2c4d2f89919..ee801950c909 100644
--- a/drivers/net/ethernet/sfc/siena/tx.h
+++ b/drivers/net/ethernet/sfc/siena/tx.h
@@ -11,13 +11,6 @@
 #include <linux/types.h>
 
 /* Driver internal tx-path related declarations. */
-
-unsigned int efx_tx_limit_len(struct efx_tx_queue *tx_queue,
-			      dma_addr_t dma_addr, unsigned int len);
-
-u8 *efx_tx_get_copy_buffer_limited(struct efx_tx_queue *tx_queue,
-				   struct efx_tx_buffer *buffer, size_t len);
-
 /* What TXQ type will satisfy the checksum offloads required for this skb? */
 static inline unsigned int efx_tx_csum_type_skb(struct sk_buff *skb)
 {

