Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6875AF295
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 19:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiIFR2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 13:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238688AbiIFR2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 13:28:09 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3972C666
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 10:19:52 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id e195so9492045iof.1
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 10:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=iyM6dtbNFzdJQR32hgHiDgJSwSi9j8lAYdcvFPMbXJQ=;
        b=JuA28ed5jfpBvyjkILaIrZc370JCraCfaVZn0DwL/4XC41roAyCqdnFq6wu5ilJPe8
         eoWcn+CF5cnYMI+CZsOPAmW8Cm6SOsL0uoXmlXjgd0G933yf2HdAEPZATZgyeKG3643P
         wo8AEnhlzk4tT0kl7vimXVaDzY/I+Hc4FNG6Z4344k7fu+oXyf7Td6Nfs/+hXL0dKpRf
         twpDyDuurRHgnOt8Er1gujlyEHl4hi658FnSs0YYAMzlP47tpPxNwniaDiBsNltPXKti
         8xswIFw9fL1e/NMq7A3wgMkrlIf7zYb3dQ1avCH+hoVmPaNcfEFCa6Fx4lif9SfuupIP
         2RJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=iyM6dtbNFzdJQR32hgHiDgJSwSi9j8lAYdcvFPMbXJQ=;
        b=1uBOilmb6Hwdgr8kuNdXS3Wt8uEiuKVNmYAr5qphIkSUVzWiCjKkh9A1EAB5grdrGa
         jYkxJiy4soD6sUhzV5rLG5jhEkVytfOAZ/E/hs+z/mlrIUtbiZkXqLDMZCxsidH84+L6
         U0FxWkcf3gSBWhARFe5Y1fv9tBQDobiLvScdthd7qh5dRW0HQqNpK/o/wMniNZU3GH+/
         c5nasM1dzaKTuyq0Tqjc5s/1sj5NED9dNMoyawgU5VAs+RalM65SoDMl7u6JxVWA8Z3L
         kHDg2tcjcP8laWLIEkP2sei/tcHFNrvVWD3e4IeZSUHCq8tvUWGg2xlWY4hvdLqSoPJg
         hw6Q==
X-Gm-Message-State: ACgBeo2ujhmLLngKQ96Bht+xPeNJBYVBf34QN98s3PT2X8/Z7oEz2D6i
        woOODzDDxh/4Csc1em1Qg4zEYQ==
X-Google-Smtp-Source: AA6agR6w7W/TozARn63hxlzaI23dFAQKaWq+NONJ95SyRshkKGSZ8QqS4uF3yMhJkXqBdv4i/6+TWA==
X-Received: by 2002:a05:6602:2d41:b0:688:e962:2b53 with SMTP id d1-20020a0566022d4100b00688e9622b53mr25867027iow.79.1662484792111;
        Tue, 06 Sep 2022 10:19:52 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id q10-20020a056e020c2a00b002eb3f5fc4easm5292204ilg.27.2022.09.06.10.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 10:19:51 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/5] net: ipa: don't have gsi_channel_update() return a value
Date:   Tue,  6 Sep 2022 12:19:42 -0500
Message-Id: <20220906171942.957704-6-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220906171942.957704-1-elder@linaro.org>
References: <20220906171942.957704-1-elder@linaro.org>
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

If it finds no completed transactions, gsi_channel_trans_complete()
calls gsi_channel_update() to check hardware.  If new transactions
have completed, gsi_channel_update() records that, then calls
gsi_channel_trans_complete() to return the first of those found.
This recursion won't go any further, but can be avoided if we
have gsi_channel_update() only be responsible for updating state
after accessing hardware.

Change gsi_channel_update() so it simply checks for and handles
new completions, without returning a value.  If it needs to call
that function, have gsi_channel_trans_complete() determine whether
there are new transactions available after the update.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c         | 8 +++-----
 drivers/net/ipa/gsi_private.h | 6 +++---
 drivers/net/ipa/gsi_trans.c   | 7 +++++--
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 5471843b665fc..3f97653450bb9 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1475,7 +1475,7 @@ void gsi_channel_doorbell(struct gsi_channel *channel)
 }
 
 /* Consult hardware, move any newly completed transactions to completed list */
-struct gsi_trans *gsi_channel_update(struct gsi_channel *channel)
+void gsi_channel_update(struct gsi_channel *channel)
 {
 	u32 evt_ring_id = channel->evt_ring_id;
 	struct gsi *gsi = channel->gsi;
@@ -1494,12 +1494,12 @@ struct gsi_trans *gsi_channel_update(struct gsi_channel *channel)
 	offset = GSI_EV_CH_E_CNTXT_4_OFFSET(evt_ring_id);
 	index = gsi_ring_index(ring, ioread32(gsi->virt + offset));
 	if (index == ring->index % ring->count)
-		return NULL;
+		return;
 
 	/* Get the transaction for the latest completed event. */
 	trans = gsi_event_trans(gsi, gsi_ring_virt(ring, index - 1));
 	if (!trans)
-		return NULL;
+		return;
 
 	/* For RX channels, update each completed transaction with the number
 	 * of bytes that were actually received.  For TX channels, report
@@ -1507,8 +1507,6 @@ struct gsi_trans *gsi_channel_update(struct gsi_channel *channel)
 	 * up the network stack.
 	 */
 	gsi_evt_ring_update(gsi, evt_ring_id, index);
-
-	return gsi_channel_trans_complete(channel);
 }
 
 /**
diff --git a/drivers/net/ipa/gsi_private.h b/drivers/net/ipa/gsi_private.h
index a937811bb1bb7..af4cc13864e21 100644
--- a/drivers/net/ipa/gsi_private.h
+++ b/drivers/net/ipa/gsi_private.h
@@ -95,12 +95,12 @@ void gsi_channel_trans_exit(struct gsi_channel *channel);
 void gsi_channel_doorbell(struct gsi_channel *channel);
 
 /* gsi_channel_update() - Update knowledge of channel hardware state
- * @channel:	Channel whose doorbell should be rung
+ * @channel:	Channel to be updated
  *
  * Consult hardware, move any newly completed transactions to a
- * channel's completed list
+ * channel's completed list.
  */
-struct gsi_trans *gsi_channel_update(struct gsi_channel *channel);
+void gsi_channel_update(struct gsi_channel *channel);
 
 /**
  * gsi_ring_virt() - Return virtual address for a ring entry
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 0b78ae904bacf..03e54fc4376a6 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -240,8 +240,11 @@ struct gsi_trans *gsi_channel_trans_complete(struct gsi_channel *channel)
 	struct gsi_trans_info *trans_info = &channel->trans_info;
 	u16 trans_id = trans_info->completed_id;
 
-	if (trans_id == trans_info->pending_id)
-		return gsi_channel_update(channel);
+	if (trans_id == trans_info->pending_id) {
+		gsi_channel_update(channel);
+		if (trans_id == trans_info->pending_id)
+			return NULL;
+	}
 
 	return &trans_info->trans[trans_id %= channel->tre_count];
 }
-- 
2.34.1

