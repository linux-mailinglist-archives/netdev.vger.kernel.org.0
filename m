Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB9C57A184
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238596AbiGSOah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238767AbiGSOaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:30:16 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4B11EEE6
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:18:59 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id l11so5560174ilf.11
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dub3l+aOrPRkN0Y4VnwahemV1ZVLd29nIudTXm2vmc4=;
        b=aI5HBTN/i9Y4rExE5UISfrsk5S/TrVNkYCyCqofhxbFzBxJKgqNCot1zEG4EST9wTx
         8XclWoiO4FI5yU6b/3ABCpWgw6Bzd37Ha0+5iUl3eA0S+8DHHwzJTRUuZmswtyTjL6vb
         fZnbVEn1WcAtZkxo7iHo4HV8LoxOQyqGoZDxIYi7ggEfbOOEQkhv3qZ8HrTtUeR3MPIs
         WfhwmvBOEjCD09pbNYo9txkbKEOsKpXTV5QVLjZBsOn2y6lB+jk3eqO3lhD6dzoBDcTS
         5Zg9r4BT7sjEaIEVGNHK/16275tm989FPlew43Xv+j1BdxCJc0ZHJ1oWmg31yNyFuy/P
         E7gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dub3l+aOrPRkN0Y4VnwahemV1ZVLd29nIudTXm2vmc4=;
        b=sdtL6c1m17JDY5S5nwqBo5T71dCh6m2WZM46HROKJ0eS7B7Jb+Z+bNXot7Qcgq/pqq
         R6lZsrvm79cJK33jlIb64xefvCyfqWGFdPWjQjxaZGAZyqe0AmCPVhibXgCNwbt7/4Cb
         4YZ6ASUTNCdaTgKdTloXN8q/EoNlc1z2J+8lLBnz6DngvI3z1T2b00XRFVomS9EkUm/r
         XtbGR892m8r5lBG/ZUR2XNZPDNiANg1Gk3aDvvFfaPoVm/c0kJMHgfNEXb84FKP/IUTB
         X3zeel58oIBuyOStAw005swbL4hcbYQ+hqD/p8Q5oe3+eqmW6A3Zh4NBf6BAoJPRf/ir
         Cd9A==
X-Gm-Message-State: AJIora/UR2DDUbtKPt7B/GhFWMCmT2OMK3hfy8svlzDcNCm4xiGbsmzT
        CUB+ODq/Byfafh7rORrDoRTjJ8PCX4Z4GQ==
X-Google-Smtp-Source: AGRyM1txDBUxGqaVEnpinafRgW6YDaawbDT3CmfZl10EDxtDS5S9aFQ1+S3qQv2Hc4X9mCE332I2jA==
X-Received: by 2002:a05:6e02:152c:b0:2dc:9b02:b590 with SMTP id i12-20020a056e02152c00b002dc9b02b590mr16028278ilu.320.1658240338375;
        Tue, 19 Jul 2022 07:18:58 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x9-20020a026f09000000b00339cdf821dasm6713826jab.51.2022.07.19.07.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 07:18:58 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: ipa: initialize ring indexes to 0
Date:   Tue, 19 Jul 2022 09:18:55 -0500
Message-Id: <20220719141855.245994-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a GSI channel is initially allocated, and after it has been
reset, the hardware assumes its ring index is 0.  And although we
do initialize channels this way, the comments in the IPA code don't
really explain this.  For event rings, it doesn't matter what value
we use initially, so using 0 is just fine.

Add some information about the assumptions made by hardware above
the definition of the gsi_ring structure in "gsi.h".

Zero the index field for all rings (channel and event) when the ring
is allocated.  As a result, that function initializes all fields in
the structure.

Stop zeroing the index the top of gsi_channel_program().  Initially
we'll use the index value set when the channel ring was allocated.
And we'll explicitly zero the index value in gsi_channel_reset()
before programming the hardware, adding a comment explaining why
it's required.

For event rings, use the index initialized by gsi_ring_alloc()
rather than 0 when ringing the doorbell in gsi_evt_ring_program().
(It'll still be zero, but we won't assume that to be the case.)

Use a local variable in gsi_evt_ring_program() that represents the
address of the event ring's ring structure.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 18 ++++++++++--------
 drivers/net/ipa/gsi.h |  5 +++--
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 4e46974a69ecd..fcd05acf893b3 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -665,7 +665,8 @@ static void gsi_evt_ring_doorbell(struct gsi *gsi, u32 evt_ring_id, u32 index)
 static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
 {
 	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
-	size_t size = evt_ring->ring.count * GSI_RING_ELEMENT_SIZE;
+	struct gsi_ring *ring = &evt_ring->ring;
+	size_t size;
 	u32 val;
 
 	/* We program all event rings as GPI type/protocol */
@@ -674,6 +675,7 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
 	val |= u32_encode_bits(GSI_RING_ELEMENT_SIZE, EV_ELEMENT_SIZE_FMASK);
 	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_0_OFFSET(evt_ring_id));
 
+	size = ring->count * GSI_RING_ELEMENT_SIZE;
 	val = ev_r_length_encoded(gsi->version, size);
 	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_1_OFFSET(evt_ring_id));
 
@@ -681,9 +683,9 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
 	 * high-order 32 bits of the address of the event ring,
 	 * respectively.
 	 */
-	val = lower_32_bits(evt_ring->ring.addr);
+	val = lower_32_bits(ring->addr);
 	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_2_OFFSET(evt_ring_id));
-	val = upper_32_bits(evt_ring->ring.addr);
+	val = upper_32_bits(ring->addr);
 	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_3_OFFSET(evt_ring_id));
 
 	/* Enable interrupt moderation by setting the moderation delay */
@@ -700,8 +702,8 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
 	iowrite32(0, gsi->virt + GSI_EV_CH_E_CNTXT_12_OFFSET(evt_ring_id));
 	iowrite32(0, gsi->virt + GSI_EV_CH_E_CNTXT_13_OFFSET(evt_ring_id));
 
-	/* Finally, tell the hardware we've completed event 0 (arbitrary) */
-	gsi_evt_ring_doorbell(gsi, evt_ring_id, 0);
+	/* Finally, tell the hardware our "last processed" event (arbitrary) */
+	gsi_evt_ring_doorbell(gsi, evt_ring_id, ring->index);
 }
 
 /* Find the transaction whose completion indicates a channel is quiesced */
@@ -770,9 +772,6 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 	u32 wrr_weight = 0;
 	u32 val;
 
-	/* Arbitrarily pick TRE 0 as the first channel element to use */
-	channel->tre_ring.index = 0;
-
 	/* We program all channels as GPI type/protocol */
 	val = chtype_protocol_encoded(gsi->version, GSI_CHANNEL_TYPE_GPI);
 	if (channel->toward_ipa)
@@ -949,6 +948,8 @@ void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool doorbell)
 	if (gsi->version < IPA_VERSION_4_0 && !channel->toward_ipa)
 		gsi_channel_reset_command(channel);
 
+	/* Hardware assumes this is 0 following reset */
+	channel->tre_ring.index = 0;
 	gsi_channel_program(channel, doorbell);
 	gsi_channel_trans_cancel_pending(channel);
 
@@ -1433,6 +1434,7 @@ static int gsi_ring_alloc(struct gsi *gsi, struct gsi_ring *ring, u32 count)
 
 	ring->addr = addr;
 	ring->count = count;
+	ring->index = 0;
 
 	return 0;
 }
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index bad1a78a96ede..982c57550ef37 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -48,12 +48,13 @@ struct gsi_ring {
 	 *
 	 * A channel ring consists of TRE entries filled by the AP and passed
 	 * to the hardware for processing.  For a channel ring, the ring index
-	 * identifies the next unused entry to be filled by the AP.
+	 * identifies the next unused entry to be filled by the AP.  In this
+	 * case the initial value is assumed by hardware to be 0.
 	 *
 	 * An event ring consists of event structures filled by the hardware
 	 * and passed to the AP.  For event rings, the ring index identifies
 	 * the next ring entry that is not known to have been filled by the
-	 * hardware.
+	 * hardware.  The initial value used is arbitrary (so we use 0).
 	 */
 	u32 index;
 };
-- 
2.34.1

