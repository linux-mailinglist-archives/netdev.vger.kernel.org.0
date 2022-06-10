Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12BB35469C2
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349165AbiFJPqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345910AbiFJPq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:46:29 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D6D5A0A0
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:46:26 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id p69so6884510iod.0
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rzg7Iow9fAmaKgsdU7mGzgw2dtvwGPhEQmm7lb2v2dI=;
        b=Go3UU13RUL7Su3WFcFQZEQWn19aFNSiLMT4iZEqcX5aXxDh7U8Gg9rTXlMFcHMpOZ+
         0gHSPaiNYkNQujued/pPga7cYZNSq0DXDatYShLZXacJ7r/609m2c1xqjf513rhDAHi3
         nf0WsnhopAGSDvCjKYrP/8t7+uhMOi9FVn9PYZ8soB5Os10HWdYQdYp6Atym4N5SdRPR
         3/i8pF++h1oaRthygyMqzgxNRr6PsE3TH2F8Ik2VLWJjl9yua8b9Kfs0J+ZIz6tu0dUU
         jEFWqR9X96G/JWqNo3HyZmfYGWOrTKyNUfY3gBENo3tEuMWkQ3iQU2R/8/sWTuyKlijP
         iEoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rzg7Iow9fAmaKgsdU7mGzgw2dtvwGPhEQmm7lb2v2dI=;
        b=sQeE+HWnRw2FY7ODOtp/txCI4L6AilIjX+9cR23eS63Ph1Fnp19YmOMJpH+jD55CVD
         J+qQN6H1N0FAoyBuxnbazkxzv//inQ+FCVObYzB44uxbvfUVBGv/CW2NRKWoMWNEFhe2
         sQLOH3KPk99TmvPhxbo17ERO+A3RHm5tbWwO9lr14Q6P/5WtkyNqMf52RhsdifVzj6uU
         N24YS7kaXH3GqxM3Xbil6T7DmBUFC97U4zAIBj1lsse23hWD0GtvuXJbrcPhtUhj4p7O
         OcEFUIvhCrW/bvc69aSiooQwiG6aXBBEExB+AvsMUC0CvDJ8ngBAKnrYpll/2twWBN0+
         5EiQ==
X-Gm-Message-State: AOAM5302aVcio0M/Snh+4GU1wRK6EimOhIWeRjLBUoRr4GOcLitcqUIj
        lTifMJS4zOYsVTc15IBav3/kzQ==
X-Google-Smtp-Source: ABdhPJwwDcev7BFxOZ5NvJzSfIKGesXaHnnwWB1/bTwAMkR3fPANEeZunQbbYB4U6VSI1GWR+bqhhw==
X-Received: by 2002:a05:6638:1346:b0:331:b571:9fd6 with SMTP id u6-20020a056638134600b00331b5719fd6mr14413045jad.266.1654875985510;
        Fri, 10 Jun 2022 08:46:25 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y15-20020a92950f000000b002d3adf71893sm12100488ilh.20.2022.06.10.08.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 08:46:25 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: derive channel from transaction
Date:   Fri, 10 Jun 2022 10:46:15 -0500
Message-Id: <20220610154616.249304-7-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610154616.249304-1-elder@linaro.org>
References: <20220610154616.249304-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In gsi_channel_tx_queued(), we report when a transaction gets passed
to hardware.  Change that function so it takes transaction rather
than a channel as its argument, and derive the channel from the
transaction.  Rename the function accordingly.

Delete the header comments above the function definition; the ones
above the declaration in "gsi_private.h" should suffice.  In
addition, the comments above gsi_channel_tx_update() do a fine job
of explaining what's going on.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c         | 28 +++++++---------------------
 drivers/net/ipa/gsi_private.h | 12 +++++-------
 drivers/net/ipa/gsi_trans.c   |  2 +-
 3 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 64417668b8a9a..5b446d2a07c8a 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -991,36 +991,22 @@ void gsi_resume(struct gsi *gsi)
 	enable_irq(gsi->irq);
 }
 
-/**
- * gsi_channel_tx_queued() - Report queued TX transfers for a channel
- * @channel:	Channel for which to report
- *
- * Report to the network stack the number of bytes and transactions that
- * have been queued to hardware since last call.  This and the next function
- * supply information used by the network stack for throttling.
- *
- * For each channel we track the number of transactions used and bytes of
- * data those transactions represent.  We also track what those values are
- * each time this function is called.  Subtracting the two tells us
- * the number of bytes and transactions that have been added between
- * successive calls.
- *
- * Calling this each time we ring the channel doorbell allows us to
- * provide accurate information to the network stack about how much
- * work we've given the hardware at any point in time.
- */
-void gsi_channel_tx_queued(struct gsi_channel *channel)
+void gsi_trans_tx_queued(struct gsi_trans *trans)
 {
+	u32 channel_id = trans->channel_id;
+	struct gsi *gsi = trans->gsi;
+	struct gsi_channel *channel;
 	u32 trans_count;
 	u32 byte_count;
 
+	channel = &gsi->channel[channel_id];
+
 	byte_count = channel->byte_count - channel->queued_byte_count;
 	trans_count = channel->trans_count - channel->queued_trans_count;
 	channel->queued_byte_count = channel->byte_count;
 	channel->queued_trans_count = channel->trans_count;
 
-	ipa_gsi_channel_tx_queued(channel->gsi, gsi_channel_id(channel),
-				  trans_count, byte_count);
+	ipa_gsi_channel_tx_queued(gsi, channel_id, trans_count, byte_count);
 }
 
 /**
diff --git a/drivers/net/ipa/gsi_private.h b/drivers/net/ipa/gsi_private.h
index ea333a244cf5e..56450a1899074 100644
--- a/drivers/net/ipa/gsi_private.h
+++ b/drivers/net/ipa/gsi_private.h
@@ -105,14 +105,12 @@ void gsi_channel_doorbell(struct gsi_channel *channel);
 void *gsi_ring_virt(struct gsi_ring *ring, u32 index);
 
 /**
- * gsi_channel_tx_queued() - Report the number of bytes queued to hardware
- * @channel:	Channel whose bytes have been queued
+ * gsi_trans_tx_queued() - Report a queued TX channel transaction
+ * @trans:	Transaction being passed to hardware
  *
- * This arranges for the the number of transactions and bytes for
- * transfer that have been queued to hardware to be reported.  It
- * passes this information up the network stack so it can be used to
- * throttle transmissions.
+ * Report to the network stack that a TX transaction is being supplied
+ * to the hardware.
  */
-void gsi_channel_tx_queued(struct gsi_channel *channel);
+void gsi_trans_tx_queued(struct gsi_trans *trans);
 
 #endif /* _GSI_PRIVATE_H_ */
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 870a4c1752838..278e467c5430b 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -603,7 +603,7 @@ static void __gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
 	if (ring_db || !atomic_read(&channel->trans_info.tre_avail)) {
 		/* Report what we're handing off to hardware for TX channels */
 		if (channel->toward_ipa)
-			gsi_channel_tx_queued(channel);
+			gsi_trans_tx_queued(trans);
 		gsi_channel_doorbell(channel);
 	}
 }
-- 
2.34.1

