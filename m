Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78C95A8915
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 00:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbiHaWk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 18:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbiHaWk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 18:40:26 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F60B85F86
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:40:24 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id b17so1010918ilh.0
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=xr5LlJafNYPtsRXFWcggz2TXxTu5qcopLJfaNmU/uX0=;
        b=s5uW3vqCPy4yTk5IW2Fzx7gJsfZQyEFZxK0exzAZA4rr/GN7/oM04jx09bxOWq6rPM
         MmnLYMmvUcMVxBMU4w4hHGXFHZkFj0eICzQfoMFgBuWFYhwoQFu1xqX8eA8fh07lsoy9
         YVI75RZE0OOsMYAhuW9efX3MOcQH7wjVMAJfoLYCYVTJnhgMMwKRRYold39anoFMeihO
         FBw9BCWi9+IpwONUswMcjcb6FLe1WSyBvBntdMQZtRiJ5Ac2/eH9VGJlyMRT0c1zrjie
         4i0atnTa0l0g9AnrgiF1HsEwB30RHyqIte9kpk8TmKj3VF6nt9IHwfcPk4fYEeXOa4n1
         GrQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=xr5LlJafNYPtsRXFWcggz2TXxTu5qcopLJfaNmU/uX0=;
        b=kMnnEuVK48iBNyj089rdldzVD2/CPbvifSD0ui7go/NMV1Jpq7SU4UMqW5lk4PV1DR
         ltlR26oFZreQDT65iP+aLGUtmuuL9hyk2MuJMBR4DVQE1yoBrBRblkhGCViM7hwDVa96
         KdRCy+JCe9zDVTE6xuyJ2CO5ai2sJOZDGjfXn1/IdOa2KpdIDjlAcXo9cKFTbEXhnUpT
         0S78q9lXXJ+c5TZqhLFYDq/4fJOJIoYFKSlGj2gUJu6QzawoVbZXWjP2zjZPxLSByn7t
         fYsGinLg2Vu+JH3QuWUBYYUYC0cSU8uHDZPN/dWsviJedvzlNJBQJL/KzxVXnDO5ysUh
         uexg==
X-Gm-Message-State: ACgBeo1dpRwgSwGA2xhWuQ3DBIP5MOPZGW/iBMen17f/+bcN8483niPK
        XRzbLetvu6bDtm0rKd8PMHGB5A==
X-Google-Smtp-Source: AA6agR4S8XU3EC4IdjW8yeW28mePPsI4gLVqcu8XuWnsJieRoTmxZqgsDBjJUkYZXh7gCZ9WWEAmjw==
X-Received: by 2002:a92:c265:0:b0:2ea:8f5b:f759 with SMTP id h5-20020a92c265000000b002ea8f5bf759mr13095686ild.73.1661985623886;
        Wed, 31 Aug 2022 15:40:23 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id n30-20020a02a19e000000b0034c0db05629sm1392005jah.161.2022.08.31.15.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 15:40:23 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net: ipa: track allocated transactions with an ID
Date:   Wed, 31 Aug 2022 17:40:13 -0500
Message-Id: <20220831224017.377745-3-elder@linaro.org>
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

Transactions for a channel are now managed in an array, with a free
transaction ID indicating which is the next one free.

Add another transaction ID field to track the first element in the
array that has been allocated.  Advance it when a transaction is
committed (because that is when that transaction leaves allocated
state).

Temporarily add warnings that verify that the first allocated
transaction tracked by the ID matches the first element on the
allocated list, both when allocating and committing a transaction.

Signed-off-by: Alex Elder <elder@linaro.org>
---

NOTE: I find these temporary WARN_ON() calls helpful in proving
      the new index refers to the same transaction as the first
      element of an "old" list.  I'll gladly remove these if
      requested.  (This comment applies throughout this series.)

 drivers/net/ipa/gsi.h       |  1 +
 drivers/net/ipa/gsi_trans.c | 28 ++++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 4a88aec7e7d92..6bbbda6f27eae 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -84,6 +84,7 @@ struct gsi_trans_info {
 	atomic_t tre_avail;		/* TREs available for allocation */
 
 	u16 free_id;			/* first free trans in array */
+	u16 allocated_id;		/* first allocated transaction */
 	struct gsi_trans *trans;	/* transaction array */
 	struct gsi_trans **map;		/* TRE -> transaction map */
 
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 9775e50d0423f..d84400e13487f 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -246,12 +246,26 @@ static void gsi_trans_move_committed(struct gsi_trans *trans)
 {
 	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
 	struct gsi_trans_info *trans_info = &channel->trans_info;
+	u16 trans_index;
 
 	spin_lock_bh(&trans_info->spinlock);
 
 	list_move_tail(&trans->links, &trans_info->committed);
 
+	trans = list_first_entry_or_null(&trans_info->alloc,
+					 struct gsi_trans, links);
+
 	spin_unlock_bh(&trans_info->spinlock);
+
+	/* This allocated transaction is now committed */
+	trans_info->allocated_id++;
+
+	if (trans) {
+		trans_index = trans_info->allocated_id % channel->tre_count;
+		WARN_ON(trans != &trans_info->trans[trans_index]);
+	} else {
+		WARN_ON(trans_info->allocated_id != trans_info->free_id);
+	}
 }
 
 /* Move transactions from the committed list to the pending list */
@@ -378,8 +392,14 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 
 	list_add_tail(&trans->links, &trans_info->alloc);
 
+	trans = list_first_entry(&trans_info->alloc, struct gsi_trans, links);
+
 	spin_unlock_bh(&trans_info->spinlock);
 
+	WARN_ON(trans_info->allocated_id == trans_info->free_id);
+	trans_index = trans_info->allocated_id % channel->tre_count;
+	WARN_ON(trans != &trans_info->trans[trans_index]);
+
 	return trans;
 }
 
@@ -408,7 +428,10 @@ void gsi_trans_free(struct gsi_trans *trans)
 	if (!last)
 		return;
 
-	if (trans->used_count)
+	/* Unused transactions are allocated but never committed */
+	if (!trans->used_count)
+		trans_info->allocated_id++;
+	else
 		ipa_gsi_trans_release(trans);
 
 	/* Releasing the reserved TREs implicitly frees the sgl[] and
@@ -744,7 +767,8 @@ int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
 				    GFP_KERNEL);
 	if (!trans_info->trans)
 		return -ENOMEM;
-	trans_info->free_id = 0;	/* modulo channel->tre_count */
+	trans_info->free_id = 0;	/* all modulo channel->tre_count */
+	trans_info->allocated_id = 0;
 
 	/* A completion event contains a pointer to the TRE that caused
 	 * the event (which will be the last one used by the transaction).
-- 
2.34.1

