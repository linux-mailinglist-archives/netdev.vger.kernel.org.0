Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E984B549DB0
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 21:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241860AbiFMT3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 15:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349457AbiFMTWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 15:22:10 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46904A181
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 10:18:11 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gd1so6229824pjb.2
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 10:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xzqDsv8rtz2ntmcXP4PLB6njoMFSh8lVBgrQ9sAi0RI=;
        b=LkveocfuKKqxyt9m9cKzjRpx55OA9njIHmeO7J/rmpVv/eQ7lyZNJbx2vLCJR1IKQ+
         eiaz9Ohld7Dk02cgTBzZ6oAIlH0qIqmrHEzsxnT/e+CLn9HVwpbuXImqNpeYUpHBiXVy
         FRzlEWlJLhN6/cs1vp9fNR2mWDM5h75IBgPJe15tQ+onkyTJCZfmO8lBvleiRrsz0Bda
         M1H6pW0r2rgNWQ0MvvGh1I4Cf8GkbcZOSzcXxs8nJbBTS1z0ap+2SkNDATbYgRfqHhgh
         qNyDeMuPO4W4t2W0oG5EQPonrMF2moXpJ7CLGup3ilMPoH16dgLCAGJf/XUVJUQiqAZN
         P6mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xzqDsv8rtz2ntmcXP4PLB6njoMFSh8lVBgrQ9sAi0RI=;
        b=l+FyWgE1UKUTcereYd1ZWpq/Lm2BLR/2ilalDlsW3gP9siEvjVDUQJNEKMFxleM6Ct
         Plwu0jndRZhhUEv9rsx6oPLhXsOuodQHaI5uJ2oeaBvfFJAy8yZI2VgM65vSWYaDzAqk
         eFiRicK7Zjf4uj1Amkyv5SEHTXONdGsbL7xCybQrwVAifPE/nBRCd5jeCfDeEhnk/+U5
         jZwMFhOrpRZMtmNUJDM4+vPER99WG5nHIkFS6TsIM/MZpTzkAESWnyOehMxGnxq51dN3
         Pr8qcnQ51eciIlmFuo7bwmv6GWjpwTjaXdL3Dprwb1n0Gsbw94da09qPq/Zzk+AEXmBh
         n/lw==
X-Gm-Message-State: AJIora/RzGc/RDimlFxCNPZtfmk/UfyBb+T/q7BxpXxvCfcIthHapkh0
        UtcBx0WzTraqgt3LGdGTtjCMkQ==
X-Google-Smtp-Source: AGRyM1tbugpngnjnsVxDW/H2h+O7cqrQ4cPBWb75KKvzvcsQ4VozsdbIv0BdVetKwulfcfrTLtHVPw==
X-Received: by 2002:a17:90b:3701:b0:1ea:9f82:59ef with SMTP id mg1-20020a17090b370100b001ea9f8259efmr810334pjb.239.1655140690712;
        Mon, 13 Jun 2022 10:18:10 -0700 (PDT)
Received: from localhost.localdomain ([192.77.111.2])
        by smtp.gmail.com with ESMTPSA id u17-20020a62d451000000b0050dc762812csm5646641pfl.6.2022.06.13.10.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 10:18:10 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: ipa: simplify TX completion statistics
Date:   Mon, 13 Jun 2022 12:17:57 -0500
Message-Id: <20220613171759.578856-5-elder@linaro.org>
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

When a TX request is issued, its channel's accumulated byte and
transaction counts are recorded.  This currently does *not* take
into account the transaction being committed.

Later, when the transaction completes, the number of bytes and
transactions that have completed since the transaction was committed
are reported to the network stack.  The transaction and its byte
count are accounted for at that time.

Instead, record the transaction and its bytes in the counts recorded
at commit time.  This avoids the need to do so when the transaction
completes, and provides a (small) simplification of that code.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 1091ac23567d5..4f8187c543824 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -995,11 +995,11 @@ void gsi_trans_tx_committed(struct gsi_trans *trans)
 {
 	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
 
-	trans->trans_count = channel->trans_count;
-	trans->byte_count = channel->byte_count;
-
 	channel->trans_count++;
 	channel->byte_count += trans->len;
+
+	trans->trans_count = channel->trans_count;
+	trans->byte_count = channel->byte_count;
 }
 
 void gsi_trans_tx_queued(struct gsi_trans *trans)
@@ -1047,13 +1047,11 @@ void gsi_trans_tx_queued(struct gsi_trans *trans)
 static void
 gsi_channel_tx_update(struct gsi_channel *channel, struct gsi_trans *trans)
 {
-	u64 byte_count = trans->byte_count + trans->len;
-	u64 trans_count = trans->trans_count + 1;
+	u64 trans_count = trans->trans_count - channel->compl_trans_count;
+	u64 byte_count = trans->byte_count - channel->compl_byte_count;
 
-	byte_count -= channel->compl_byte_count;
-	channel->compl_byte_count += byte_count;
-	trans_count -= channel->compl_trans_count;
 	channel->compl_trans_count += trans_count;
+	channel->compl_byte_count += byte_count;
 
 	ipa_gsi_channel_tx_completed(channel->gsi, gsi_channel_id(channel),
 				     trans_count, byte_count);
-- 
2.34.1

