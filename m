Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E4E549D8F
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 21:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348575AbiFMTYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 15:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349569AbiFMTWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 15:22:20 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0703326F9
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 10:18:14 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id l4so5040306pgh.13
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 10:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VP4KQHv/fOTk1uSuALx0rQHJbV2oSTFRWBWAJzpP+gE=;
        b=ypBkktvD0AWy15WiMJmTTqief/l8LnhS6sft/yvTkNe4TXAbwY1giPwzMIVIlJMj/T
         CG0DiU0Z9HAOIWlLTwxcdY65JSdAp96GOdfzUr/xEWTSzSFhCYTBrG9vvKHr4mjlCQzG
         uu/fL66iivcNZjZC6w4MChZkLTr4NCqQXa6kL9NujPJj97GqO3wp9KmQxP7on8qHnn2p
         sbNONY8N5/rEqCFcw4KnIxPtZ9Ffzwd2mCAr0X1rJ+n6ZG48MYenk6NkgJvEFvXQuns0
         Ch55V77MnQKOMUlXWtkUMewKXmb0zyHXOF4FVJvRjUbSxMb3+UGHXQmXg2WhFFfCTK13
         v8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VP4KQHv/fOTk1uSuALx0rQHJbV2oSTFRWBWAJzpP+gE=;
        b=l1mgA8i81ZnCWfDUvX3z0Ua8UCLh052qLAPQ2cvF9Y4DPSdabIrIxBsL/T52y03hZz
         +PjY7mqErJzHyVeJ5GfOWqd7DL7GctBddeoSvmDowevTMUEYqv7FczY/ENztPibK1JPC
         hWsrYTw6Ae3mEemSQYd6J4FQEHF7SQPUKTdSq026sd9Vr+nDT9QHj6KOdcfGGg5N6dqV
         JCD1CopEur4EGYVCQP2LtnRUaP3eX0QHw7HWIuX6huQvUzSE5c8sITsmtSK2EQwG/bOz
         OWE6OPJnjk7dGAigatXIN8eGZvWBm1m5WYhng9iNvyY/0q3Zdi+JXdaoHIzUPLAdKfsC
         w1RA==
X-Gm-Message-State: AOAM5321TdQ1ZBgxd4cRI3tGxKNAf2IV2o28Vow1Qa7LI9kJ1EVtkLuA
        m2DzsGP+Et7soLmLgqH23Nq0aCHZEzBNzA==
X-Google-Smtp-Source: ABdhPJwWO6p1O1jMAWb63Gp7Nr1Qe4p+1PNjRbbTIJ63//BsAb8NehROChTlbDkjmUEAREnOZIhpEQ==
X-Received: by 2002:a63:a0e:0:b0:3fd:a62e:fa5f with SMTP id 14-20020a630a0e000000b003fda62efa5fmr588604pgk.126.1655140694122;
        Mon, 13 Jun 2022 10:18:14 -0700 (PDT)
Received: from localhost.localdomain ([192.77.111.2])
        by smtp.gmail.com with ESMTPSA id u17-20020a62d451000000b0050dc762812csm5646641pfl.6.2022.06.13.10.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 10:18:13 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: rework gsi_channel_tx_update()
Date:   Mon, 13 Jun 2022 12:17:59 -0500
Message-Id: <20220613171759.578856-7-elder@linaro.org>
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

Rename gsi_channel_tx_update() to be gsi_trans_tx_completed(), and
pass it just the transaction pointer, deriving the channel from the
transaction.  Update the comments above the function to provide a
more concise description of how statistics for TX endpoints are
maintained and used.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 54 ++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index c2cafd9247a70..df8af1f00fc8b 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1021,40 +1021,36 @@ void gsi_trans_tx_queued(struct gsi_trans *trans)
 }
 
 /**
- * gsi_channel_tx_update() - Report completed TX transfers
- * @channel:	Channel that has completed transmitting packets
- * @trans:	Last transation known to be complete
- *
- * Compute the number of transactions and bytes that have been transferred
- * over a TX channel since the given transaction was committed.  Report this
- * information to the network stack.
- *
- * At the time a transaction is committed, we record its channel's
- * committed transaction and byte counts *in the transaction*.
- * Completions are signaled by the hardware with an interrupt, and
- * we can determine the latest completed transaction at that time.
- *
- * The difference between the byte/transaction count recorded in
- * the transaction and the count last time we recorded a completion
- * tells us exactly how much data has been transferred between
- * completions.
- *
- * Calling this each time we learn of a newly-completed transaction
- * allows us to provide accurate information to the network stack
- * about how much work has been completed by the hardware at a given
- * point in time.
+ * gsi_trans_tx_completed() - Report completed TX transactions
+ * @trans:	TX channel transaction that has completed
+ *
+ * Report that a transaction on a TX channel has completed.  At the time a
+ * transaction is committed, we record *in the transaction* its channel's
+ * committed transaction and byte counts.  Transactions are completed in
+ * order, and the difference between the channel's byte/transaction count
+ * when the transaction was committed and when it completes tells us
+ * exactly how much data has been transferred while the transaction was
+ * pending.
+ *
+ * We report this information to the network stack, which uses it to manage
+ * the rate at which data is sent to hardware.
  */
-static void
-gsi_channel_tx_update(struct gsi_channel *channel, struct gsi_trans *trans)
+static void gsi_trans_tx_completed(struct gsi_trans *trans)
 {
-	u64 trans_count = trans->trans_count - channel->compl_trans_count;
-	u64 byte_count = trans->byte_count - channel->compl_byte_count;
+	u32 channel_id = trans->channel_id;
+	struct gsi *gsi = trans->gsi;
+	struct gsi_channel *channel;
+	u32 trans_count;
+	u32 byte_count;
+
+	channel = &gsi->channel[channel_id];
+	trans_count = trans->trans_count - channel->compl_trans_count;
+	byte_count = trans->byte_count - channel->compl_byte_count;
 
 	channel->compl_trans_count += trans_count;
 	channel->compl_byte_count += byte_count;
 
-	ipa_gsi_channel_tx_completed(channel->gsi, gsi_channel_id(channel),
-				     trans_count, byte_count);
+	ipa_gsi_channel_tx_completed(gsi, channel_id, trans_count, byte_count);
 }
 
 /* Channel control interrupt handler */
@@ -1504,7 +1500,7 @@ static struct gsi_trans *gsi_channel_update(struct gsi_channel *channel)
 	 * up the network stack.
 	 */
 	if (channel->toward_ipa)
-		gsi_channel_tx_update(channel, trans);
+		gsi_trans_tx_completed(trans);
 	else
 		gsi_evt_ring_rx_update(evt_ring, index);
 
-- 
2.34.1

