Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0280654CF35
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 19:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350084AbiFOQ7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352018AbiFOQ7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:59:39 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBCF381AF
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 09:59:37 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 31so10263116pgv.11
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 09:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lZ2eXkpiTB+9jl0HokhuJqpkh8lZk8zY1cp/z4xtYvI=;
        b=l9Mpq1W0KjZEmbKPUv1rBTxHL0HBBVf0Ns4SFqtn+/mkDhfYR3K6V/purrC8pPC9CS
         mpnA06nBuCh6seBBgPNsh+Qvuqk9NLynCVDJtgyvqsr6sBOR9viD0SiIloyJa/teuDGm
         ruZ25bQoLZLuy0apE5H9S3KQ+mZQGzUsZ5BM5aDj1u7yC88Uw1BAApBnq7ww8MNuB1Pv
         PM/n8C4aiZqgKW1Vhlq52Xtpee2XT3iP3GkQWaMmwN7sdNXWChlfTCBmYTIHTNGEECYP
         Rbe/8p5s2h6K3AtVYTbVYTeNp8nfXX8nksU9uz9A5ZkRPd7dMV4C7yuPpl9Jp+jQJBTL
         j6Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lZ2eXkpiTB+9jl0HokhuJqpkh8lZk8zY1cp/z4xtYvI=;
        b=qMx2cqws2Qgw7LlwZZaajjcuFnusDPyrlIYEAU7blGxiMH+WXdripZb5wQhRbtNbgz
         eFBnIUIzY7MvnXe0QgaYS4lr7lEjmZ7ELHKG8XwIp47taRBajkgw7GhavsEeN/wTT7kc
         XKDYRcG7Hn2jsE2R98g9uS/HTA6saFN0utqvTjy00gVGHl7bvTlbMn9Zn7Ngi6OsiCIV
         o+rAkIr/F9hpaSBcul0t7jTsnrSWQ/fLD0RNm7h3GmA/eYGjKlu/ANWanj81ueLYU5SJ
         X6HnyIXo3RtqLDG+wUR+Z/M5QWZqJLZ6CfdlMdLjlRO41QVwI0dicwt8MLDw3ebE85dY
         0sXg==
X-Gm-Message-State: AJIora8yNWlXm12ZQVuNWXYe30AgjrJjIKuIrDG16tTCX2uBTbTYKeHM
        9DEU47AWugxfuMKUf2ULVXc2xg==
X-Google-Smtp-Source: AGRyM1scPWmtV+ed1tWRQRcdPCDvfos5dt6Mby8svxYYWHAdYffmpN6MfVa9W5JNzydMdtkhEbHFUg==
X-Received: by 2002:aa7:85d1:0:b0:51b:f4b5:db7b with SMTP id z17-20020aa785d1000000b0051bf4b5db7bmr512545pfn.41.1655312376492;
        Wed, 15 Jun 2022 09:59:36 -0700 (PDT)
Received: from localhost.localdomain ([192.77.111.2])
        by smtp.gmail.com with ESMTPSA id s194-20020a6377cb000000b003fd1111d73csm10618513pgc.4.2022.06.15.09.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:59:36 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] net: ipa: pass GSI pointer to gsi_evt_ring_rx_update()
Date:   Wed, 15 Jun 2022 11:59:27 -0500
Message-Id: <20220615165929.5924-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220615165929.5924-1-elder@linaro.org>
References: <20220615165929.5924-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only reason the event ring's channel pointer is needed in
gsi_evt_ring_rx_update() is so we can get at its GSI pointer.

We can pass the GSI pointer as an argument, along with the event
ring ID, and thereby avoid using the event ring channel pointer.
This is another step toward no longer assuming an event ring
services a single channel.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 0e9064c043adf..2c531ba1af2eb 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1345,8 +1345,9 @@ gsi_event_trans(struct gsi *gsi, struct gsi_event *event)
 
 /**
  * gsi_evt_ring_rx_update() - Record lengths of received data
- * @evt_ring:	Event ring associated with channel that received packets
- * @index:	Event index in ring reported by hardware
+ * @gsi:		GSI pointer
+ * @evt_ring_id:	Event ring ID
+ * @index:		Event index in ring reported by hardware
  *
  * Events for RX channels contain the actual number of bytes received into
  * the buffer.  Every event has a transaction associated with it, and here
@@ -1362,9 +1363,9 @@ gsi_event_trans(struct gsi *gsi, struct gsi_event *event)
  *
  * Note that @index always refers to an element *within* the event ring.
  */
-static void gsi_evt_ring_rx_update(struct gsi_evt_ring *evt_ring, u32 index)
+static void gsi_evt_ring_rx_update(struct gsi *gsi, u32 evt_ring_id, u32 index)
 {
-	struct gsi_channel *channel = evt_ring->channel;
+	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
 	struct gsi_ring *ring = &evt_ring->ring;
 	struct gsi_event *event_done;
 	struct gsi_event *event;
@@ -1387,7 +1388,7 @@ static void gsi_evt_ring_rx_update(struct gsi_evt_ring *evt_ring, u32 index)
 	do {
 		struct gsi_trans *trans;
 
-		trans = gsi_event_trans(channel->gsi, event);
+		trans = gsi_event_trans(gsi, event);
 		if (!trans)
 			return;
 
@@ -1500,7 +1501,7 @@ static struct gsi_trans *gsi_channel_update(struct gsi_channel *channel)
 	if (channel->toward_ipa)
 		gsi_trans_tx_completed(trans);
 	else
-		gsi_evt_ring_rx_update(evt_ring, index);
+		gsi_evt_ring_rx_update(gsi, evt_ring_id, index);
 
 	gsi_trans_move_complete(trans);
 
-- 
2.34.1

