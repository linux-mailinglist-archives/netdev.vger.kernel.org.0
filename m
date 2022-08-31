Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52D95A8921
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 00:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbiHaWkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 18:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbiHaWkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 18:40:31 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5303490820
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:40:29 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id v15so5673628iln.6
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=iA+ZsMRaFINLBa2q6rRWWDvmtN6jkG3m27+u4i2eWYk=;
        b=H+H0lsqEzdDcbzgUWISig1YUnIg/aehePSBnNojWIJj5QTRJWpJDhTDUIdVUWGmvrR
         frN9CtxPw+IA143oPez6mRWiKyGjGVU8bBjA3Wn59GA8d4910uqHdvCkbBQnEbv+xZZM
         i1k0g0/aGgThMCXoGwoX4NZk+tcIv6H3oZb4vEQDwwM8Qnk5RW4vNcNLUyhgp6exbeoU
         CYCd74UaJDUEw46FOi8MDuoBE6J+Edd3nx+kWSckyZhYh4HVYyQr6P5Ga6T1LDyCTHmD
         1N50leIh8WybO3pC/EV1I+fwMyiKKLaOCP2og3t7ZdxRC32HCtZKfbOw1lVzzfp2IPPN
         TpcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=iA+ZsMRaFINLBa2q6rRWWDvmtN6jkG3m27+u4i2eWYk=;
        b=YsJP/7d7b5HTjrHh5UbFys1aQQcciV7OS3NjbI1qK7MezbYg4I3LCPKZmpp7W9xk/z
         8ZWNj1RzzcK2WaNkqP10w0/eUD5+XYICEdvnwOmpQXfy5IAtNbNSsiSOkzcpX4Zr1rZ1
         5pPW6+XFmiL8rfZLzSmhVTmKWpCyCPaPCMLciGa9Pzt3v3/giOkxyea96rTtA4rg1W0c
         p/DR6WQSU3xfbtFB97zR2KYVDMKeLLljUl7lqzErFZsZ4K2ps1+Pd1PgG0t4f/U8xlpE
         Wyyj1mKg+AFW39fbkJeSCVnRlU/e0wCARLhlg8r2KUluoDWuo1p6X5DDBrKplzGLlOSV
         2aGA==
X-Gm-Message-State: ACgBeo1dmWIoJdhAUjxl3+//St5Zs8PDKI+BCZg2xumsA1gWSe07/Bby
        PwJKg+YFQgg7daNoHEJTeDtMVw==
X-Google-Smtp-Source: AA6agR5x6getp83xkq0Tm4yf3gx4pL6enoWi1EqhzDjZt9MysZ1jzL7YI7dQgbx0LXwOTlUroLP0Ug==
X-Received: by 2002:a92:8e09:0:b0:2eb:15a:c449 with SMTP id c9-20020a928e09000000b002eb015ac449mr8091188ild.162.1661985628119;
        Wed, 31 Aug 2022 15:40:28 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id n30-20020a02a19e000000b0034c0db05629sm1392005jah.161.2022.08.31.15.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 15:40:27 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: track polled transactions with an ID
Date:   Wed, 31 Aug 2022 17:40:17 -0500
Message-Id: <20220831224017.377745-7-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220831224017.377745-1-elder@linaro.org>
References: <20220831224017.377745-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a transaction ID to track the first element in the transaction
array that has been polled.  Advance the ID when we are releasing a
transaction.

Temporarily add warnings that verify that the first polled
transaction tracked by the ID matches the first element on the
polled list, both when polling and freeing.

Remove the temporary warnings added by the previous commit.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.h       |  1 +
 drivers/net/ipa/gsi_trans.c | 39 ++++++++++++++++++++++---------------
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 987f9f5f35d36..13468704c4000 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -88,6 +88,7 @@ struct gsi_trans_info {
 	u16 committed_id;		/* first committed transaction */
 	u16 pending_id;			/* first pending transaction */
 	u16 completed_id;		/* first completed transaction */
+	u16 polled_id;			/* first polled transaction */
 	struct gsi_trans *trans;	/* transaction array */
 	struct gsi_trans **map;		/* TRE -> transaction map */
 
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 40852b1dd5b98..4eef1480c2005 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -296,19 +296,12 @@ void gsi_trans_move_complete(struct gsi_trans *trans)
 	list_cut_position(&list, &trans_info->pending, &trans->links);
 	list_splice_tail(&list, &trans_info->complete);
 
-	trans = list_first_entry(&trans_info->complete,
-				 struct gsi_trans, links);
-
 	spin_unlock_bh(&trans_info->spinlock);
 
 	/* These pending transactions are now completed */
 	delta = trans_index - trans_info->pending_id + 1;
 	delta %= channel->tre_count;
 	trans_info->pending_id += delta;
-
-	WARN_ON(trans_info->completed_id == trans_info->pending_id);
-	trans_index = trans_info->completed_id % channel->tre_count;
-	WARN_ON(trans != &trans_info->trans[trans_index]);
 }
 
 /* Move a transaction from the completed list to the polled list */
@@ -322,21 +315,17 @@ void gsi_trans_move_polled(struct gsi_trans *trans)
 
 	list_move_tail(&trans->links, &trans_info->polled);
 
-	trans = list_first_entry_or_null(&trans_info->complete,
-					 struct gsi_trans, links);
+	trans = list_first_entry(&trans_info->polled,
+				 struct gsi_trans, links);
 
 	spin_unlock_bh(&trans_info->spinlock);
 
 	/* This completed transaction is now polled */
 	trans_info->completed_id++;
 
-	if (trans) {
-		trans_index = trans_info->completed_id % channel->tre_count;
-		WARN_ON(trans != &trans_info->trans[trans_index]);
-	} else {
-		WARN_ON(trans_info->completed_id !=
-			trans_info->pending_id);
-	}
+	WARN_ON(trans_info->polled_id == trans_info->completed_id);
+	trans_index = trans_info->polled_id % channel->tre_count;
+	WARN_ON(trans != &trans_info->trans[trans_index]);
 }
 
 /* Reserve some number of TREs on a channel.  Returns true if successful */
@@ -424,8 +413,11 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 /* Free a previously-allocated transaction */
 void gsi_trans_free(struct gsi_trans *trans)
 {
+	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
 	refcount_t *refcount = &trans->refcount;
 	struct gsi_trans_info *trans_info;
+	struct gsi_trans *polled;
+	u16 trans_index;
 	bool last;
 
 	/* We must hold the lock to release the last reference */
@@ -441,6 +433,9 @@ void gsi_trans_free(struct gsi_trans *trans)
 	if (last)
 		list_del(&trans->links);
 
+	polled = list_first_entry_or_null(&trans_info->polled,
+					  struct gsi_trans, links);
+
 	spin_unlock_bh(&trans_info->spinlock);
 
 	if (!last)
@@ -458,6 +453,17 @@ void gsi_trans_free(struct gsi_trans *trans)
 		ipa_gsi_trans_release(trans);
 	}
 
+	/* This transaction is now free */
+	trans_info->polled_id++;
+
+	if (polled) {
+		trans_index = trans_info->polled_id % channel->tre_count;
+		WARN_ON(polled != &trans_info->trans[trans_index]);
+	} else {
+		WARN_ON(trans_info->polled_id !=
+			trans_info->completed_id);
+	}
+
 	/* Releasing the reserved TREs implicitly frees the sgl[] and
 	 * (if present) info[] arrays, plus the transaction itself.
 	 */
@@ -796,6 +802,7 @@ int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
 	trans_info->committed_id = 0;
 	trans_info->pending_id = 0;
 	trans_info->completed_id = 0;
+	trans_info->polled_id = 0;
 
 	/* A completion event contains a pointer to the TRE that caused
 	 * the event (which will be the last one used by the transaction).
-- 
2.34.1

