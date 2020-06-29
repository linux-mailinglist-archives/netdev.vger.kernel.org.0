Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9B020E588
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732331AbgF2ViF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388613AbgF2Vhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:37:45 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2617DC08C5DB
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:37:45 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id i4so18783703iov.11
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Af+/9CSUqiL8+Q2/NBMEqVxoFlpAKXhf/eB3TWyxOp0=;
        b=zGsVB1+MMLrSD2Ry7w7m2IEZ22N2/s30BIJKpqZjygc3KdGr8QFP4dNKGUpJ0ICZn/
         g2a6IMaHNbXSBpTyPGc/RZokJhWkFcmkJ2nDuZ29kxJHOfYE/QNpUyZOSMQ6HZ8dU4JX
         ZuwFBHpqk8thm4EBpD/QQYXOGonGXYxvUiCNiPphEDBRHChTpHiJAA7Sqigb/MhdFXnj
         iPvkwv/YlsEnUYfzP+k3kwuHEOdW0z27+Zgm8VIbBEch1xCRcDIpsDDm32pmXk9JbtWL
         eUWPEZkgIPvR6KV+DEp3jvkYhX1mkRPBLyg7F6XhepV6aerCg1oGlR4FMQyZf1rNppPU
         VwuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Af+/9CSUqiL8+Q2/NBMEqVxoFlpAKXhf/eB3TWyxOp0=;
        b=JsHHyqk6J7FNb/TE/SegfkJCweCYby932SUQMIwNqyybFDm6FEvBFv8g5Rss1VJo/Z
         vI3JpiQfYJV8uduZuF090JOwaNEnKrQ+dfbKmSRuB0gGuX/vt/OTBYVeAODz/hg4wVjG
         tqS+wQas7BWGOGojuR7cq1Ig8jiG167EWX2wWfJHNYGd0Kua/MLKdTqn9uQb5QiKpW6V
         9EOsX1I6xvDqBSgdcPnCLFgz9DnbBZAOrvNJB8saJMGRDmkPI4Y0YrW/TWLbTX1XYRaB
         tyhx5Ms50tv4f53cHi4pX20C7qjuCX04Bu7i0tmN/LUwHvQdDhTUZQ7+HCB+IUJA95Ml
         3IbA==
X-Gm-Message-State: AOAM531NpaFdfEoV3XsqviWMCHN3+9OffjMKgzJ1JGRaRiyypkE35fO2
        5qpBIj4na3M20f5sMRyJSihvnQ==
X-Google-Smtp-Source: ABdhPJweAkCU1I/gVxr3kiGGIzaWQ9PhwzaBoQ5br97ZsRMbjJFhGfIXWg7VOBTeCr3MRLX243ybqw==
X-Received: by 2002:a05:6602:2d89:: with SMTP id k9mr18775417iow.41.1593466664460;
        Mon, 29 Jun 2020 14:37:44 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u6sm571353ilg.32.2020.06.29.14.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 14:37:44 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] net: ipa: standarize more GSI error messages
Date:   Mon, 29 Jun 2020 16:37:37 -0500
Message-Id: <20200629213738.1180618-3-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629213738.1180618-1-elder@linaro.org>
References: <20200629213738.1180618-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make minor updates to error messages reported in "gsi.c":
  - Use local variables to reduce multi-line function calls
  - Don't use parentheses in messages
  - Do some slight rewording in a few cases

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 57 ++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 7e4e54ee09b1..f8d5b8d86335 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -336,6 +336,7 @@ static int evt_ring_command(struct gsi *gsi, u32 evt_ring_id,
 {
 	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
 	struct completion *completion = &evt_ring->completion;
+	struct device *dev = gsi->dev;
 	u32 val;
 
 	val = u32_encode_bits(evt_ring_id, EV_CHID_FMASK);
@@ -344,8 +345,8 @@ static int evt_ring_command(struct gsi *gsi, u32 evt_ring_id,
 	if (gsi_command(gsi, GSI_EV_CH_CMD_OFFSET, val, completion))
 		return 0;	/* Success! */
 
-	dev_err(gsi->dev, "GSI command %u to event ring %u timed out "
-		"(state is %u)\n", opcode, evt_ring_id, evt_ring->state);
+	dev_err(dev, "GSI command %u for event ring %u timed out, state %u\n",
+		opcode, evt_ring_id, evt_ring->state);
 
 	return -ETIMEDOUT;
 }
@@ -431,6 +432,7 @@ gsi_channel_command(struct gsi_channel *channel, enum gsi_ch_cmd_opcode opcode)
 	struct completion *completion = &channel->completion;
 	u32 channel_id = gsi_channel_id(channel);
 	struct gsi *gsi = channel->gsi;
+	struct device *dev = gsi->dev;
 	u32 val;
 
 	val = u32_encode_bits(channel_id, CH_CHID_FMASK);
@@ -439,8 +441,7 @@ gsi_channel_command(struct gsi_channel *channel, enum gsi_ch_cmd_opcode opcode)
 	if (gsi_command(gsi, GSI_CH_CMD_OFFSET, val, completion))
 		return 0;	/* Success! */
 
-	dev_err(gsi->dev,
-		"GSI command %u to channel %u timed out (state is %u)\n",
+	dev_err(dev, "GSI command %u for channel %u timed out, state %u\n",
 		opcode, channel_id, gsi_channel_state(channel));
 
 	return -ETIMEDOUT;
@@ -1154,8 +1155,8 @@ static irqreturn_t gsi_isr(int irq, void *dev_id)
 				break;
 			default:
 				dev_err(gsi->dev,
-					"%s: unrecognized type 0x%08x\n",
-					__func__, gsi_intr);
+					"unrecognized interrupt type 0x%08x\n",
+					gsi_intr);
 				break;
 			}
 		} while (intr_mask);
@@ -1259,7 +1260,7 @@ static int gsi_ring_alloc(struct gsi *gsi, struct gsi_ring *ring, u32 count)
 	if (ring->virt && addr % size) {
 		dma_free_coherent(dev, size, ring->virt, ring->addr);
 		dev_err(dev, "unable to alloc 0x%zx-aligned ring buffer\n",
-				size);
+			size);
 		return -EINVAL;	/* Not a good error value, but distinct */
 	} else if (!ring->virt) {
 		return -ENOMEM;
@@ -1650,12 +1651,13 @@ static void gsi_channel_teardown(struct gsi *gsi)
 /* Setup function for GSI.  GSI firmware must be loaded and initialized */
 int gsi_setup(struct gsi *gsi, bool legacy)
 {
+	struct device *dev = gsi->dev;
 	u32 val;
 
 	/* Here is where we first touch the GSI hardware */
 	val = ioread32(gsi->virt + GSI_GSI_STATUS_OFFSET);
 	if (!(val & ENABLED_FMASK)) {
-		dev_err(gsi->dev, "GSI has not been enabled\n");
+		dev_err(dev, "GSI has not been enabled\n");
 		return -EIO;
 	}
 
@@ -1663,24 +1665,24 @@ int gsi_setup(struct gsi *gsi, bool legacy)
 
 	gsi->channel_count = u32_get_bits(val, NUM_CH_PER_EE_FMASK);
 	if (!gsi->channel_count) {
-		dev_err(gsi->dev, "GSI reports zero channels supported\n");
+		dev_err(dev, "GSI reports zero channels supported\n");
 		return -EINVAL;
 	}
 	if (gsi->channel_count > GSI_CHANNEL_COUNT_MAX) {
-		dev_warn(gsi->dev,
-			"limiting to %u channels (hardware supports %u)\n",
+		dev_warn(dev,
+			"limiting to %u channels; hardware supports %u\n",
 			 GSI_CHANNEL_COUNT_MAX, gsi->channel_count);
 		gsi->channel_count = GSI_CHANNEL_COUNT_MAX;
 	}
 
 	gsi->evt_ring_count = u32_get_bits(val, NUM_EV_PER_EE_FMASK);
 	if (!gsi->evt_ring_count) {
-		dev_err(gsi->dev, "GSI reports zero event rings supported\n");
+		dev_err(dev, "GSI reports zero event rings supported\n");
 		return -EINVAL;
 	}
 	if (gsi->evt_ring_count > GSI_EVT_RING_COUNT_MAX) {
-		dev_warn(gsi->dev,
-			"limiting to %u event rings (hardware supports %u)\n",
+		dev_warn(dev,
+			"limiting to %u event rings; hardware supports %u\n",
 			 GSI_EVT_RING_COUNT_MAX, gsi->evt_ring_count);
 		gsi->evt_ring_count = GSI_EVT_RING_COUNT_MAX;
 	}
@@ -1766,19 +1768,19 @@ static bool gsi_channel_data_valid(struct gsi *gsi,
 
 	/* Make sure channel ids are in the range driver supports */
 	if (channel_id >= GSI_CHANNEL_COUNT_MAX) {
-		dev_err(dev, "bad channel id %u (must be less than %u)\n",
+		dev_err(dev, "bad channel id %u; must be less than %u\n",
 			channel_id, GSI_CHANNEL_COUNT_MAX);
 		return false;
 	}
 
 	if (data->ee_id != GSI_EE_AP && data->ee_id != GSI_EE_MODEM) {
-		dev_err(dev, "bad EE id %u (AP or modem)\n", data->ee_id);
+		dev_err(dev, "bad EE id %u; not AP or modem\n", data->ee_id);
 		return false;
 	}
 
 	if (!data->channel.tlv_count ||
 	    data->channel.tlv_count > GSI_TLV_MAX) {
-		dev_err(dev, "channel %u bad tlv_count %u (must be 1..%u)\n",
+		dev_err(dev, "channel %u bad tlv_count %u; must be 1..%u\n",
 			channel_id, data->channel.tlv_count, GSI_TLV_MAX);
 		return false;
 	}
@@ -1796,13 +1798,13 @@ static bool gsi_channel_data_valid(struct gsi *gsi,
 	}
 
 	if (!is_power_of_2(data->channel.tre_count)) {
-		dev_err(dev, "channel %u bad tre_count %u (not power of 2)\n",
+		dev_err(dev, "channel %u bad tre_count %u; not power of 2\n",
 			channel_id, data->channel.tre_count);
 		return false;
 	}
 
 	if (!is_power_of_2(data->channel.event_count)) {
-		dev_err(dev, "channel %u bad event_count %u (not power of 2)\n",
+		dev_err(dev, "channel %u bad event_count %u; not power of 2\n",
 			channel_id, data->channel.event_count);
 		return false;
 	}
@@ -1956,6 +1958,7 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev, bool prefetch,
 	     u32 count, const struct ipa_gsi_endpoint_data *data,
 	     bool modem_alloc)
 {
+	struct device *dev = &pdev->dev;
 	struct resource *res;
 	resource_size_t size;
 	unsigned int irq;
@@ -1963,7 +1966,7 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev, bool prefetch,
 
 	gsi_validate_build();
 
-	gsi->dev = &pdev->dev;
+	gsi->dev = dev;
 
 	/* The GSI layer performs NAPI on all endpoints.  NAPI requires a
 	 * network device structure, but the GSI layer does not have one,
@@ -1974,43 +1977,41 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev, bool prefetch,
 	/* Get the GSI IRQ and request for it to wake the system */
 	ret = platform_get_irq_byname(pdev, "gsi");
 	if (ret <= 0) {
-		dev_err(gsi->dev,
-			"DT error %d getting \"gsi\" IRQ property\n", ret);
+		dev_err(dev, "DT error %d getting \"gsi\" IRQ property\n", ret);
 		return ret ? : -EINVAL;
 	}
 	irq = ret;
 
 	ret = request_irq(irq, gsi_isr, 0, "gsi", gsi);
 	if (ret) {
-		dev_err(gsi->dev, "error %d requesting \"gsi\" IRQ\n", ret);
+		dev_err(dev, "error %d requesting \"gsi\" IRQ\n", ret);
 		return ret;
 	}
 	gsi->irq = irq;
 
 	ret = enable_irq_wake(gsi->irq);
 	if (ret)
-		dev_warn(gsi->dev, "error %d enabling gsi wake irq\n", ret);
+		dev_warn(dev, "error %d enabling gsi wake irq\n", ret);
 	gsi->irq_wake_enabled = !ret;
 
 	/* Get GSI memory range and map it */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gsi");
 	if (!res) {
-		dev_err(gsi->dev,
-			"DT error getting \"gsi\" memory property\n");
+		dev_err(dev, "DT error getting \"gsi\" memory property\n");
 		ret = -ENODEV;
 		goto err_disable_irq_wake;
 	}
 
 	size = resource_size(res);
 	if (res->start > U32_MAX || size > U32_MAX - res->start) {
-		dev_err(gsi->dev, "DT memory resource \"gsi\" out of range\n");
+		dev_err(dev, "DT memory resource \"gsi\" out of range\n");
 		ret = -EINVAL;
 		goto err_disable_irq_wake;
 	}
 
 	gsi->virt = ioremap(res->start, size);
 	if (!gsi->virt) {
-		dev_err(gsi->dev, "unable to remap \"gsi\" memory\n");
+		dev_err(dev, "unable to remap \"gsi\" memory\n");
 		ret = -ENOMEM;
 		goto err_disable_irq_wake;
 	}
-- 
2.25.1

