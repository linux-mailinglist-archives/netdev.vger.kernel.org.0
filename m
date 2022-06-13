Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A3F549D78
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 21:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243923AbiFMTWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 15:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239269AbiFMTVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 15:21:36 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A5E32058
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 10:18:07 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id e9so6203414pju.5
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 10:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WtNMojkay1TGl3veVsLBCL1IdXBJpZKRASa03E0Bjrk=;
        b=bD24dxGKfFGeICbVrf9DLa7VMCKl7hRiega5n95H/eRXArWOFPAijUtmC8XnhIs344
         MVS8fyo8pPj1M5rKcmAnIfOYtcwbNMqSL9vZYMTaVwB7idEGvuS5UPOwdvUVHTkf7WJI
         Qp+dfmBTkTqZbhSL4lQM14CfJl2WjLkE+csJXn8gFOLD75H8Swz0u6USqEWWaVkjm6Ir
         2/OhGrtbDgC1d6vVjwqGaPGgaD0FDt3cs/mmmwQIbZgb6rkSPupDSE0bCOBWjBmYkjIU
         tIYwarv0ZUhF0HKlinhT4RsfcZbijiu0esNDtQvbMFuiey8l6572d2ljoHbCPNklFv7j
         cTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WtNMojkay1TGl3veVsLBCL1IdXBJpZKRASa03E0Bjrk=;
        b=H2YX3GQgvTqH4v/jxvpy0Io/bGU+EF0bhqy006x4QKpof0qLgqnFZ34egiEXb0PIAc
         jm8xOOJADioBTawaWL0QlfVodqlyworyWvs+KZpKABuZ0/DGvJtp2C5bAKSdVhRo4ael
         dqoYWrgZAILE5g5kpHEtZLQQKV6yHjJk3FvxsPr7vbohcKq27BKfHbuxTc/en+rVf3gw
         fSKsjuLusWvE8WN3y2HMUZBYK/U8Ls54vK+2fpP70jIHTZCsJK45SlLcO9LKk9P8ZvxO
         oGgL2Z978bAD5x0POIclvx7x/2oE1wDl5oi7WvGXXnATCI3p1bN+vru0i1Aog1YNmlLz
         X0+g==
X-Gm-Message-State: AJIora8yLfxz7y6x43LO5Eg+xN1HF5JL4eDmYu8454Vtad/apXxJFMD2
        XRH1UX2pIRR6Mp0M25KEFLMeVQ==
X-Google-Smtp-Source: AGRyM1v/xmb1YOfRGIydVrWS4Zge68b0oTo5AEN1qZItO+KXP82nbbG7O45y1BuRTZIM0E+/iHssfA==
X-Received: by 2002:a17:902:bf45:b0:15c:df47:3d6 with SMTP id u5-20020a170902bf4500b0015cdf4703d6mr347304pls.58.1655140687192;
        Mon, 13 Jun 2022 10:18:07 -0700 (PDT)
Received: from localhost.localdomain ([192.77.111.2])
        by smtp.gmail.com with ESMTPSA id u17-20020a62d451000000b0050dc762812csm5646641pfl.6.2022.06.13.10.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 10:18:06 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net: ipa: rename two transaction fields
Date:   Mon, 13 Jun 2022 12:17:55 -0500
Message-Id: <20220613171759.578856-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220613171759.578856-1-elder@linaro.org>
References: <20220613171759.578856-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two fields in a GSI transaction that keep track of TRE
counts.  The first represents the number of TREs reserved for the
transaction in the TRE ring; that's currently named "tre_count".
The second is the number of TREs that are actually *used* by the
transaction at the time it is committed.

Rename the "tre_count" field to be "rsvd_count", to make its meaning
a little more specific.  The "_count" is present in the name mainly
to avoid interpreting it as a reserved (not-to-be-used) field.  This
name also distinguishes it from the "tre_count" field associated
with a channel.

Rename the "used" field to be "used_count", to match the convention
used for reserved TREs.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_trans.c | 41 +++++++++++++++++++------------------
 drivers/net/ipa/gsi_trans.h |  8 ++++----
 2 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index e3f3c736c7409..986857eb39296 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -355,7 +355,7 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 	trans = gsi_trans_pool_alloc(&trans_info->pool, 1);
 	trans->gsi = gsi;
 	trans->channel_id = channel_id;
-	trans->tre_count = tre_count;
+	trans->rsvd_count = tre_count;
 	init_completion(&trans->completion);
 
 	/* Allocate the scatterlist and (if requested) info entries. */
@@ -405,17 +405,17 @@ void gsi_trans_free(struct gsi_trans *trans)
 	/* Releasing the reserved TREs implicitly frees the sgl[] and
 	 * (if present) info[] arrays, plus the transaction itself.
 	 */
-	gsi_trans_tre_release(trans_info, trans->tre_count);
+	gsi_trans_tre_release(trans_info, trans->rsvd_count);
 }
 
 /* Add an immediate command to a transaction */
 void gsi_trans_cmd_add(struct gsi_trans *trans, void *buf, u32 size,
 		       dma_addr_t addr, enum ipa_cmd_opcode opcode)
 {
-	u32 which = trans->used++;
+	u32 which = trans->used_count++;
 	struct scatterlist *sg;
 
-	WARN_ON(which >= trans->tre_count);
+	WARN_ON(which >= trans->rsvd_count);
 
 	/* Commands are quite different from data transfer requests.
 	 * Their payloads come from a pool whose memory is allocated
@@ -446,9 +446,9 @@ int gsi_trans_page_add(struct gsi_trans *trans, struct page *page, u32 size,
 	struct scatterlist *sg = &trans->sgl[0];
 	int ret;
 
-	if (WARN_ON(trans->tre_count != 1))
+	if (WARN_ON(trans->rsvd_count != 1))
 		return -EINVAL;
-	if (WARN_ON(trans->used))
+	if (WARN_ON(trans->used_count))
 		return -EINVAL;
 
 	sg_set_page(sg, page, size, offset);
@@ -456,7 +456,7 @@ int gsi_trans_page_add(struct gsi_trans *trans, struct page *page, u32 size,
 	if (!ret)
 		return -ENOMEM;
 
-	trans->used++;	/* Transaction now owns the (DMA mapped) page */
+	trans->used_count++;	/* Transaction now owns the (DMA mapped) page */
 
 	return 0;
 }
@@ -465,25 +465,26 @@ int gsi_trans_page_add(struct gsi_trans *trans, struct page *page, u32 size,
 int gsi_trans_skb_add(struct gsi_trans *trans, struct sk_buff *skb)
 {
 	struct scatterlist *sg = &trans->sgl[0];
-	u32 used;
+	u32 used_count;
 	int ret;
 
-	if (WARN_ON(trans->tre_count != 1))
+	if (WARN_ON(trans->rsvd_count != 1))
 		return -EINVAL;
-	if (WARN_ON(trans->used))
+	if (WARN_ON(trans->used_count))
 		return -EINVAL;
 
 	/* skb->len will not be 0 (checked early) */
 	ret = skb_to_sgvec(skb, sg, 0, skb->len);
 	if (ret < 0)
 		return ret;
-	used = ret;
+	used_count = ret;
 
-	ret = dma_map_sg(trans->gsi->dev, sg, used, trans->direction);
+	ret = dma_map_sg(trans->gsi->dev, sg, used_count, trans->direction);
 	if (!ret)
 		return -ENOMEM;
 
-	trans->used += used;	/* Transaction now owns the (DMA mapped) skb */
+	/* Transaction now owns the (DMA mapped) skb */
+	trans->used_count += used_count;
 
 	return 0;
 }
@@ -559,7 +560,7 @@ static void __gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
 	u32 avail;
 	u32 i;
 
-	WARN_ON(!trans->used);
+	WARN_ON(!trans->used_count);
 
 	/* Consume the entries.  If we cross the end of the ring while
 	 * filling them we'll switch to the beginning to finish.
@@ -569,8 +570,8 @@ static void __gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
 	cmd_opcode = channel->command ? &trans->cmd_opcode[0] : NULL;
 	avail = tre_ring->count - tre_ring->index % tre_ring->count;
 	dest_tre = gsi_ring_virt(tre_ring, tre_ring->index);
-	for_each_sg(trans->sgl, sg, trans->used, i) {
-		bool last_tre = i == trans->used - 1;
+	for_each_sg(trans->sgl, sg, trans->used_count, i) {
+		bool last_tre = i == trans->used_count - 1;
 		dma_addr_t addr = sg_dma_address(sg);
 		u32 len = sg_dma_len(sg);
 
@@ -583,7 +584,7 @@ static void __gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
 		gsi_trans_tre_fill(dest_tre, addr, len, last_tre, bei, opcode);
 		dest_tre++;
 	}
-	tre_ring->index += trans->used;
+	tre_ring->index += trans->used_count;
 
 	if (channel->toward_ipa) {
 		/* We record TX bytes when they are sent */
@@ -611,7 +612,7 @@ static void __gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
 /* Commit a GSI transaction */
 void gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
 {
-	if (trans->used)
+	if (trans->used_count)
 		__gsi_trans_commit(trans, ring_db);
 	else
 		gsi_trans_free(trans);
@@ -620,7 +621,7 @@ void gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
 /* Commit a GSI transaction and wait for it to complete */
 void gsi_trans_commit_wait(struct gsi_trans *trans)
 {
-	if (!trans->used)
+	if (!trans->used_count)
 		goto out_trans_free;
 
 	refcount_inc(&trans->refcount);
@@ -638,7 +639,7 @@ void gsi_trans_complete(struct gsi_trans *trans)
 {
 	/* If the entire SGL was mapped when added, unmap it now */
 	if (trans->direction != DMA_NONE)
-		dma_unmap_sg(trans->gsi->dev, trans->sgl, trans->used,
+		dma_unmap_sg(trans->gsi->dev, trans->sgl, trans->used_count,
 			     trans->direction);
 
 	ipa_gsi_trans_complete(trans);
diff --git a/drivers/net/ipa/gsi_trans.h b/drivers/net/ipa/gsi_trans.h
index 020c3b32de1d7..b5f80250ca006 100644
--- a/drivers/net/ipa/gsi_trans.h
+++ b/drivers/net/ipa/gsi_trans.h
@@ -33,8 +33,8 @@ struct gsi_trans_pool;
  * @gsi:	GSI pointer
  * @channel_id: Channel number transaction is associated with
  * @cancelled:	If set by the core code, transaction was cancelled
- * @tre_count:	Number of TREs reserved for this transaction
- * @used:	Number of TREs *used* (could be less than tre_count)
+ * @rsvd_count:	Number of TREs reserved for this transaction
+ * @used_count:	Number of TREs *used* (could be less than rsvd_count)
  * @len:	Total # of transfer bytes represented in sgl[] (set by core)
  * @data:	Preserved but not touched by the core transaction code
  * @cmd_opcode:	Array of command opcodes (command channel only)
@@ -56,8 +56,8 @@ struct gsi_trans {
 
 	bool cancelled;			/* true if transaction was cancelled */
 
-	u8 tre_count;			/* # TREs requested */
-	u8 used;			/* # entries used in sgl[] */
+	u8 rsvd_count;			/* # TREs requested */
+	u8 used_count;			/* # entries used in sgl[] */
 	u32 len;			/* total # bytes across sgl[] */
 
 	union {
-- 
2.34.1

