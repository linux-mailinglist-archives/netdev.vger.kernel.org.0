Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1D715AB9D0
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiIBVCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiIBVC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:02:26 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE060AD9AA
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 14:02:25 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id z72so2620736iof.12
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 14:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=jw3usGZHwB7uL2kMRS8aZbuB6wC7nfp91WF72vctvXA=;
        b=pUIZ44+Vfp8hE1PdqhEqNHazsPJPGPN8uOffVif6e3FHXbgg4VT9ySgFV2JyzY+RcN
         sKbDltAGT7Y1Epr0Hm2lBof04pprbdPymdkocC/1M0NN3FyKyD9E7EpNKkjBHGe/clw2
         GVATAoPMTSteF9inOIXTA1mXiENXBjFtmC6WfIYQNQFyunoL+ytiivPMPtkIRik7OqnA
         Ydcm6byeFMJgSrjoHqW7HAAv7LxBFXN/wCyrx/jVCDEsMbZvph3UTgaeRcrpGgiA+yPE
         fB6JfRVreyqmS2e+Ou9+sQeh2xyfo14+YHt5h0MraxGCOCXONMtG8HAVcrfAQfs7ZNVS
         Om1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=jw3usGZHwB7uL2kMRS8aZbuB6wC7nfp91WF72vctvXA=;
        b=19yK9VpeXn8+py7Uw/o3lV+Jss3wm0B/ZLXL8UiF/HCkWzzQR9R3Jg7WttTJHvYthi
         JfkENIe+uEzh/6+YWTs9uIlrfrsR8so5hhyq+ut9TDs89F4Gp+OCuxzGenniWV0UXzVH
         lgKvvHg5mpDjgI53EzfVPCvd9xkWYG6NJSq1Cdgey52raWTlPGuahWiPIk24KGQTO9cn
         c57FHwJKS3ak8vdq84JVyqomw9XSzkj0BpNvh8jHGpxka/OSXdSOgmdIjXou+4UWCUsc
         sKxJLv0wkQ4Mgu9VSVroz0z7IH183VWpp7cRK26qlu1YrI6j3dTlh+7rebIMkvrnPZPw
         05LQ==
X-Gm-Message-State: ACgBeo2MapDdK15kuRvZBUiUkxEmEkf4zCqzRNCn7xBqenC5bWSIJA8x
        C1mFT4DYQHkuJFBrUQcDJ0+N8A==
X-Google-Smtp-Source: AA6agR56sEYtb+xFIJK9ZN3slkJslKVczqNlXp8oZ6J9kYrILNPIc3WJA+BjTGXmuRlwDR/DdhuxwQ==
X-Received: by 2002:a05:6638:488a:b0:342:6d75:dfa6 with SMTP id ct10-20020a056638488a00b003426d75dfa6mr19147130jab.319.1662152545368;
        Fri, 02 Sep 2022 14:02:25 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id i7-20020a0566022c8700b00689e718d971sm1259208iow.51.2022.09.02.14.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 14:02:24 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: ipa: use IDs exclusively for last transaction
Date:   Fri,  2 Sep 2022 16:02:15 -0500
Message-Id: <20220902210218.745873-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220902210218.745873-1-elder@linaro.org>
References: <20220902210218.745873-1-elder@linaro.org>
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

Always use transaction IDs when finding the "last" transaction to
await when quiescing a channel.  This basically extends what was
done in the previous patch to all other transaction state IDs.

As a result we are no longer updating any transaction lists inside
gsi_channel_trans_last(), so there's no need to take the spinlock.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 135e51980d793..0983a11409f2d 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -714,8 +714,6 @@ static struct gsi_trans *gsi_channel_trans_last(struct gsi_channel *channel)
 	u16 trans_index;
 	u16 trans_id;
 
-	spin_lock_bh(&trans_info->spinlock);
-
 	/* There is a small chance a TX transaction got allocated just
 	 * before we disabled transmits, so check for that.
 	 */
@@ -728,32 +726,46 @@ static struct gsi_trans *gsi_channel_trans_last(struct gsi_channel *channel)
 			goto done;
 		}
 
-		trans = list_last_entry_or_null(&trans_info->committed,
-						struct gsi_trans, links);
-		if (trans)
+		/* Last committed transaction precedes the first allocated */
+		if (trans_info->committed_id != trans_info->allocated_id) {
+			trans_id = trans_info->allocated_id - 1;
+			trans_index = trans_id % channel->tre_count;
+			trans = &trans_info->trans[trans_index];
 			goto done;
-		trans = list_last_entry_or_null(&trans_info->pending,
-						struct gsi_trans, links);
-		if (trans)
+		}
+
+		/* Last pending transaction precedes the first committed */
+		if (trans_info->pending_id != trans_info->committed_id) {
+			trans_id = trans_info->committed_id - 1;
+			trans_index = trans_id % channel->tre_count;
+			trans = &trans_info->trans[trans_index];
 			goto done;
+		}
 	}
 
 	/* Otherwise (TX or RX) we want to wait for anything that
 	 * has completed, or has been polled but not released yet.
+	 *
+	 * The last pending transaction precedes the first committed.
 	 */
-	trans = list_last_entry_or_null(&trans_info->complete,
-					struct gsi_trans, links);
-	if (trans)
+	if (trans_info->completed_id != trans_info->pending_id) {
+		trans_id = trans_info->pending_id - 1;
+		trans_index = trans_id % channel->tre_count;
+		trans = &trans_info->trans[trans_index];
 		goto done;
-	trans = list_last_entry_or_null(&trans_info->polled,
-					struct gsi_trans, links);
+	}
+	if (trans_info->polled_id != trans_info->completed_id) {
+		trans_id = trans_info->completed_id - 1;
+		trans_index = trans_id % channel->tre_count;
+		trans = &trans_info->trans[trans_index];
+	} else {
+		trans = NULL;
+	}
 done:
 	/* Caller will wait for this, so take a reference */
 	if (trans)
 		refcount_inc(&trans->refcount);
 
-	spin_unlock_bh(&trans_info->spinlock);
-
 	return trans;
 }
 
-- 
2.34.1

