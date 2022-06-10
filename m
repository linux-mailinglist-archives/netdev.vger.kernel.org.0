Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3BB5469C5
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347679AbiFJPrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346074AbiFJPq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:46:29 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20110419BD
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:46:25 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id e80so4202465iof.3
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H+HiH5kTQtRHo/h67V+G+1rByOl+HT84huwB93SdFF4=;
        b=MH0/ex7pQYFU3FynRa4guAtnpYUYFfOE1ZX5ue+Gmxj4XgtT4ogdKvu1cIv8iLBXoO
         TyfqAjFjPhG5x+RFtPCRjvzVB1NiW34107TsVJIW/T1AiEqnEcd3YQK5+kBprjipX47Q
         kqtU8OBDeroN5akL+XEiqGJB3FEARjkGJ+CB2rtipWBjleiR4z9zc/RGRmX1bSRFU/bY
         S8KVMJj9n7uiQ6hVyMe4yi35qNUuffb+7HnVReGwIOVro/pdbi8LhIHBxAzjoX3I9pxg
         ldZXwYdfYfDtvXoTo8kHTWBIFGpo/ixLk04+xqrZPKjUyJZMRBzHxv4DG8uBjlPOppJm
         8zXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H+HiH5kTQtRHo/h67V+G+1rByOl+HT84huwB93SdFF4=;
        b=MyhXviJ5LlKT7hMDPVXzzF9vdGqLYAz1llP61CiQMIfGs10zCGNoa1CsoErdYmCPvo
         C+3L8Cf6q9hx5yC/kbPrJPashorGcxw1BHRf66dWik0uVmLi2ZIf+QrNQ3ZpMEivesqH
         ISiMv02z2i1HYsQfn6Gobx1gAFymRTBoN++tO966uzIuS+A8+G1JLmUGtktpMPf5U46t
         9N4kCid9zzA81sHcrhU0Blrb5nkCsjn20cPmJ1Bsp3nKBKeVl3VOvAQGszySbh3b0bfW
         TAusrIIRsS63+rXeT+Uhix1a1c0pa1KMCUyHavQGZkGzWPr+9yRVcZGHa1So1KyNPegh
         lDnA==
X-Gm-Message-State: AOAM533jy4BLIddyvsRvZtKrKyiMPQwqCij/hS2kb6wseLwpKhvhS22B
        rGXdwyc2ggbXrZp1BjzFE1trRw==
X-Google-Smtp-Source: ABdhPJwEUXLBB1sJj2ow0lN3MVJyaVknIOgVftb4vBlLCWs24AAQCOfuiBkb89Ee/8sfXH3FFDrd9A==
X-Received: by 2002:a05:6602:72f:b0:669:488c:ff79 with SMTP id g15-20020a056602072f00b00669488cff79mr15187211iox.27.1654875984459;
        Fri, 10 Jun 2022 08:46:24 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y15-20020a92950f000000b002d3adf71893sm12100488ilh.20.2022.06.10.08.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 08:46:24 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: ipa: determine channel from event
Date:   Fri, 10 Jun 2022 10:46:14 -0500
Message-Id: <20220610154616.249304-6-elder@linaro.org>
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

Each event in an event ring describes the TRE whose completion
caused the event.  Currently, every event ring is dedicated to a
single channel, so the channel is easily derived from the event
ring.

An event ring can actually be shared by more than one channel
though, and to distinguish events for one channel from another, the
event structure contains a field indicating which channel the event
is associated with.

In gsi_event_trans(), use the channel ID in an event to determine
which channel the event is for.  This makes the channel pointer now
passed to that function irrelevant; pass the GSI pointer to that
function instead.

And although it shouldn't happen, warn if an event arrives that
records a channel ID that's not in use, or if the event does not
have a transaction associated with it.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index b1acc7d36b23b..64417668b8a9a 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1327,17 +1327,29 @@ static int gsi_irq_init(struct gsi *gsi, struct platform_device *pdev)
 }
 
 /* Return the transaction associated with a transfer completion event */
-static struct gsi_trans *gsi_event_trans(struct gsi_channel *channel,
-					 struct gsi_event *event)
+static struct gsi_trans *
+gsi_event_trans(struct gsi *gsi, struct gsi_event *event)
 {
+	u32 channel_id = event->chid;
+	struct gsi_channel *channel;
+	struct gsi_trans *trans;
 	u32 tre_offset;
 	u32 tre_index;
 
+	channel = &gsi->channel[channel_id];
+	if (WARN(!channel->gsi, "event has bad channel %u\n", channel_id))
+		return NULL;
+
 	/* Event xfer_ptr records the TRE it's associated with */
 	tre_offset = lower_32_bits(le64_to_cpu(event->xfer_ptr));
 	tre_index = gsi_ring_index(&channel->tre_ring, tre_offset);
 
-	return gsi_channel_trans_mapped(channel, tre_index);
+	trans = gsi_channel_trans_mapped(channel, tre_index);
+
+	if (WARN(!trans, "channel %u event with no transaction\n", channel_id))
+		return NULL;
+
+	return trans;
 }
 
 /**
@@ -1381,7 +1393,9 @@ static void gsi_evt_ring_rx_update(struct gsi_evt_ring *evt_ring, u32 index)
 	 */
 	old_index = ring->index;
 	event = gsi_ring_virt(ring, old_index);
-	trans = gsi_event_trans(channel, event);
+	trans = gsi_event_trans(channel->gsi, event);
+	if (!trans)
+		return;
 
 	/* Compute the number of events to process before we wrap,
 	 * and determine when we'll be done processing events.
@@ -1493,7 +1507,9 @@ static struct gsi_trans *gsi_channel_update(struct gsi_channel *channel)
 		return NULL;
 
 	/* Get the transaction for the latest completed event. */
-	trans = gsi_event_trans(channel, gsi_ring_virt(ring, index - 1));
+	trans = gsi_event_trans(gsi, gsi_ring_virt(ring, index - 1));
+	if (!trans)
+		return NULL;
 
 	/* For RX channels, update each completed transaction with the number
 	 * of bytes that were actually received.  For TX channels, report
-- 
2.34.1

