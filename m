Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F4D5AB9C6
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiIBVCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiIBVC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:02:28 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C97B4424
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 14:02:27 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id 62so2656237iov.5
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 14:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=wXtVbgfVAjAnFG+gl8zfcyZNigB/A7fWYjmIjrEWnFw=;
        b=tJ5pt1iOrDE9HnmuU2z91c5o+GjTXTa8xAjYRYQKVx3qijRfKzjWWMIWGcjqfDgZ2v
         0Sodk0RcMNFYfD6MJeZaUzOWwef4lr3T+anFkraj3Y8tKWIH4oMz3f+yMOX+mayO2b6+
         owNRcbl8hwj2AQ/8o/gLPXdfcO5rdQbdnMcnF0YnsleKf3S+b6wqixm3f7hIe8OyD+6U
         xNZgPwXc66i3qahVCbNpAnQezUB0RnSaTm3BrdiP/RNh/9Bkwxk/mzBXefzHNXn4vWDo
         /aBIzL4jCT0IRBLTv9Qh4PCqdXatpTX+cF6TeJIh67N6OspPedGn34FuS9Qyk/nfOwrS
         Uw1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=wXtVbgfVAjAnFG+gl8zfcyZNigB/A7fWYjmIjrEWnFw=;
        b=XboHow7AQ1/AdhjWZVtWNAJYsmYWwTbg2QCLER10PMmRjhDuuu37TuDfAXL8Fd9Mqb
         5zxnK/7+nYP1t0ZwkIQIdZllytfH2AEbPadfehMMKV0D7q7zFcYYBGdGSkzGQp0AY5X8
         wtUbKV6s0N+ddqONoUEcx+iharRYVYMqqRdPidkjtrkHP6pKJsRQUsELPOLYPwb2mbx9
         Bvgxv5elVjOjqrALupxReESroYZ3qLTXn6pfEjDqEab6T3l3bhXBUvWrQsbeDNs5rRqd
         xg2WwOydo+ywm2CVTWugdPfc6B3v9L8A+SOpSjty+ElDWEH0egQBXGinP+YCs6Pxx12N
         dboA==
X-Gm-Message-State: ACgBeo2g3L1yrueZgWD37e0swtpyEdG37Tf1k9+5A9QVdzbWDboM3dtr
        mYcx81mRCHme+emzou00V9jOOw==
X-Google-Smtp-Source: AA6agR4HufdtD/9OxH2qjCZXSXxQ/SwmvJ369EXBIREDC4zPnp6YUXWazsZ5BRIui3Crg4Vudg3Z/w==
X-Received: by 2002:a02:b60d:0:b0:343:5ddd:66b3 with SMTP id h13-20020a02b60d000000b003435ddd66b3mr20698508jam.8.1662152546588;
        Fri, 02 Sep 2022 14:02:26 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id i7-20020a0566022c8700b00689e718d971sm1259208iow.51.2022.09.02.14.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 14:02:26 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: ipa: simplify gsi_channel_trans_last()
Date:   Fri,  2 Sep 2022 16:02:16 -0500
Message-Id: <20220902210218.745873-5-elder@linaro.org>
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

Using a little logic we can simplify gsi_channel_trans_last().

The first condition in that function looks like this:
    if (trans_info->allocated_id != trans_info->free_id)
And if that's false, we proceed to the next one:
    if (trans_info->committed_id != trans_info->allocated_id)

Failure of the first test implies:
    trans_info->allocated_id == trans_info->free_id
And therefore, the second one can be rewritten this way:
    if (trans_info->committed_id != trans_info->free_id)

Substituting free_id for allocated_id and committed_id can also be
done in the code blocks executed when these conditions yield true.
The net result is that all three blocks for TX endpoints can be
consolidated into just one.

The two blocks of code at the end of that function (used for both TX
and RX channels) can be similarly consolidated into a single block.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 0983a11409f2d..841a946bc286a 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -718,46 +718,27 @@ static struct gsi_trans *gsi_channel_trans_last(struct gsi_channel *channel)
 	 * before we disabled transmits, so check for that.
 	 */
 	if (channel->toward_ipa) {
-		/* The last allocated transaction precedes the first free */
-		if (trans_info->allocated_id != trans_info->free_id) {
+		/* The last allocated, committed, or pending transaction
+		 * precedes the first free transaction.
+		 */
+		if (trans_info->pending_id != trans_info->free_id) {
 			trans_id = trans_info->free_id - 1;
 			trans_index = trans_id % channel->tre_count;
 			trans = &trans_info->trans[trans_index];
 			goto done;
 		}
-
-		/* Last committed transaction precedes the first allocated */
-		if (trans_info->committed_id != trans_info->allocated_id) {
-			trans_id = trans_info->allocated_id - 1;
-			trans_index = trans_id % channel->tre_count;
-			trans = &trans_info->trans[trans_index];
-			goto done;
-		}
-
-		/* Last pending transaction precedes the first committed */
-		if (trans_info->pending_id != trans_info->committed_id) {
-			trans_id = trans_info->committed_id - 1;
-			trans_index = trans_id % channel->tre_count;
-			trans = &trans_info->trans[trans_index];
-			goto done;
-		}
 	}
 
 	/* Otherwise (TX or RX) we want to wait for anything that
 	 * has completed, or has been polled but not released yet.
 	 *
-	 * The last pending transaction precedes the first committed.
+	 * The last completed or polled transaction precedes the
+	 * first pending transaction.
 	 */
-	if (trans_info->completed_id != trans_info->pending_id) {
+	if (trans_info->polled_id != trans_info->pending_id) {
 		trans_id = trans_info->pending_id - 1;
 		trans_index = trans_id % channel->tre_count;
 		trans = &trans_info->trans[trans_index];
-		goto done;
-	}
-	if (trans_info->polled_id != trans_info->completed_id) {
-		trans_id = trans_info->completed_id - 1;
-		trans_index = trans_id % channel->tre_count;
-		trans = &trans_info->trans[trans_index];
 	} else {
 		trans = NULL;
 	}
-- 
2.34.1

