Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4BC513759
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348631AbiD1OzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348524AbiD1Oy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:54:56 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6765C87D;
        Thu, 28 Apr 2022 07:51:40 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id g6so10095830ejw.1;
        Thu, 28 Apr 2022 07:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sHYM7FZ7flhs082HViFIxV2vfk2Us4kPGD+KKmAh1Vs=;
        b=L79K8paf+nvvtoCzl3IMFopubCwaAVSOX3w0q5lEk2wc22QRuWcJRAjFTEag8Rsh4w
         4jefT6tpnzbZgxdTbH+FSj6KsuLDEiYr13Bx7PWH4Zo6nTGCSWyEt7UDLPdTGvXqKhn9
         r84g3+jq7XgQtY+M5dYDhKpmIgdAouhG/0v1AgIrzjVWrUqmL/4X/BgMINpZHJbFPv0q
         A4yRePrvk49eWAi0Cn3ULXflMZZdZByC1WZCMQM6LA885hrq+JmHbKYluRmeCdrb1zyh
         nwqDW7GXUBbCli3mI/rsfAXa3tUn9VteXVCRAuI3BdAPacv1AEiCQ/aGPdt8LmfWDWoy
         WwEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sHYM7FZ7flhs082HViFIxV2vfk2Us4kPGD+KKmAh1Vs=;
        b=aAKMOQCU3jZvlsvOvCYPnHBuhxBpdEN0Pxinao5k4K5skjlPBsXai5fSqx30vAbD0D
         DKLf/tIbkR4HazuHkugdetfLp4E7NMry/YkCVsxt69XvfELU6dSZPaFl3NjYa8TYZYKZ
         QNTldJ2nFFTHUgwtmQIo/e+B93LeSD3wtNxcWjgZ8h0tfzvnNGc8p1TDldN15d6VNbWr
         FQbtXxm6XoXje4+kLs4qYI/fuJUcCb396FFZl0+zhlIq2fmpi1lZGpaQM4TV1Oc37jen
         6Atm0z1JPqkI4rs9VaK0FaM8GOVKam9sNApheVxuajMGM2AkCETCe7sI79/5GUEx3fb9
         9NlQ==
X-Gm-Message-State: AOAM531+GUJ46cftzOU4/TYmDoZHtP1O4cS/lVBq3cAFY5zo1jOacvXp
        620iKMNqGz+hpiVVY4hJ47A=
X-Google-Smtp-Source: ABdhPJzWlV9lwW74NqP3RKApB0jNXyJnJAnRmcJUAc6xTX6qIRNoSWWC/I+7tYeq1iZNZkqRgi7cWA==
X-Received: by 2002:a17:907:7fac:b0:6ef:e068:f5aa with SMTP id qk44-20020a1709077fac00b006efe068f5aamr25543538ejc.238.1651157499364;
        Thu, 28 Apr 2022 07:51:39 -0700 (PDT)
Received: from anparri.mshome.net (host-79-49-65-106.retail.telecomitalia.it. [79.49.65.106])
        by smtp.gmail.com with ESMTPSA id x18-20020a170906b09200b006e8baac3a09sm61616ejy.157.2022.04.28.07.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 07:51:39 -0700 (PDT)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Subject: [PATCH hyperv-next v2 5/5] Drivers: hv: vmbus: Refactor the ring-buffer iterator functions
Date:   Thu, 28 Apr 2022 16:51:07 +0200
Message-Id: <20220428145107.7878-6-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220428145107.7878-1-parri.andrea@gmail.com>
References: <20220428145107.7878-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With no users of hv_pkt_iter_next_raw() and no "external" users of
hv_pkt_iter_first_raw(), the iterator functions can be refactored
and simplified to remove some indirection/code.

Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
---
 drivers/hv/ring_buffer.c | 32 +++++++++-----------------------
 include/linux/hyperv.h   | 35 ++++-------------------------------
 2 files changed, 13 insertions(+), 54 deletions(-)

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index e101b11f95e5d..59a4aa86d1f35 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -429,7 +429,7 @@ int hv_ringbuffer_read(struct vmbus_channel *channel,
 	memcpy(buffer, (const char *)desc + offset, packetlen);
 
 	/* Advance ring index to next packet descriptor */
-	__hv_pkt_iter_next(channel, desc, true);
+	__hv_pkt_iter_next(channel, desc);
 
 	/* Notify host of update */
 	hv_pkt_iter_close(channel);
@@ -464,22 +464,6 @@ static u32 hv_pkt_iter_avail(const struct hv_ring_buffer_info *rbi)
 		return (rbi->ring_datasize - priv_read_loc) + write_loc;
 }
 
-/*
- * Get first vmbus packet without copying it out of the ring buffer
- */
-struct vmpacket_descriptor *hv_pkt_iter_first_raw(struct vmbus_channel *channel)
-{
-	struct hv_ring_buffer_info *rbi = &channel->inbound;
-
-	hv_debug_delay_test(channel, MESSAGE_DELAY);
-
-	if (hv_pkt_iter_avail(rbi) < sizeof(struct vmpacket_descriptor))
-		return NULL;
-
-	return (struct vmpacket_descriptor *)(hv_get_ring_buffer(rbi) + rbi->priv_read_index);
-}
-EXPORT_SYMBOL_GPL(hv_pkt_iter_first_raw);
-
 /*
  * Get first vmbus packet from ring buffer after read_index
  *
@@ -491,11 +475,14 @@ struct vmpacket_descriptor *hv_pkt_iter_first(struct vmbus_channel *channel)
 	struct vmpacket_descriptor *desc, *desc_copy;
 	u32 bytes_avail, pkt_len, pkt_offset;
 
-	desc = hv_pkt_iter_first_raw(channel);
-	if (!desc)
+	hv_debug_delay_test(channel, MESSAGE_DELAY);
+
+	bytes_avail = hv_pkt_iter_avail(rbi);
+	if (bytes_avail < sizeof(struct vmpacket_descriptor))
 		return NULL;
+	bytes_avail = min(rbi->pkt_buffer_size, bytes_avail);
 
-	bytes_avail = min(rbi->pkt_buffer_size, hv_pkt_iter_avail(rbi));
+	desc = (struct vmpacket_descriptor *)(hv_get_ring_buffer(rbi) + rbi->priv_read_index);
 
 	/*
 	 * Ensure the compiler does not use references to incoming Hyper-V values (which
@@ -542,8 +529,7 @@ EXPORT_SYMBOL_GPL(hv_pkt_iter_first);
  */
 struct vmpacket_descriptor *
 __hv_pkt_iter_next(struct vmbus_channel *channel,
-		   const struct vmpacket_descriptor *desc,
-		   bool copy)
+		   const struct vmpacket_descriptor *desc)
 {
 	struct hv_ring_buffer_info *rbi = &channel->inbound;
 	u32 packetlen = desc->len8 << 3;
@@ -556,7 +542,7 @@ __hv_pkt_iter_next(struct vmbus_channel *channel,
 		rbi->priv_read_index -= dsize;
 
 	/* more data? */
-	return copy ? hv_pkt_iter_first(channel) : hv_pkt_iter_first_raw(channel);
+	return hv_pkt_iter_first(channel);
 }
 EXPORT_SYMBOL_GPL(__hv_pkt_iter_next);
 
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index b028905d8334e..c440c45887c26 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1706,55 +1706,28 @@ static inline u32 hv_pkt_len(const struct vmpacket_descriptor *desc)
 	return desc->len8 << 3;
 }
 
-struct vmpacket_descriptor *
-hv_pkt_iter_first_raw(struct vmbus_channel *channel);
-
 struct vmpacket_descriptor *
 hv_pkt_iter_first(struct vmbus_channel *channel);
 
 struct vmpacket_descriptor *
 __hv_pkt_iter_next(struct vmbus_channel *channel,
-		   const struct vmpacket_descriptor *pkt,
-		   bool copy);
+		   const struct vmpacket_descriptor *pkt);
 
 void hv_pkt_iter_close(struct vmbus_channel *channel);
 
 static inline struct vmpacket_descriptor *
-hv_pkt_iter_next_pkt(struct vmbus_channel *channel,
-		     const struct vmpacket_descriptor *pkt,
-		     bool copy)
+hv_pkt_iter_next(struct vmbus_channel *channel,
+		 const struct vmpacket_descriptor *pkt)
 {
 	struct vmpacket_descriptor *nxt;
 
-	nxt = __hv_pkt_iter_next(channel, pkt, copy);
+	nxt = __hv_pkt_iter_next(channel, pkt);
 	if (!nxt)
 		hv_pkt_iter_close(channel);
 
 	return nxt;
 }
 
-/*
- * Get next packet descriptor without copying it out of the ring buffer
- * If at end of list, return NULL and update host.
- */
-static inline struct vmpacket_descriptor *
-hv_pkt_iter_next_raw(struct vmbus_channel *channel,
-		     const struct vmpacket_descriptor *pkt)
-{
-	return hv_pkt_iter_next_pkt(channel, pkt, false);
-}
-
-/*
- * Get next packet descriptor from iterator
- * If at end of list, return NULL and update host.
- */
-static inline struct vmpacket_descriptor *
-hv_pkt_iter_next(struct vmbus_channel *channel,
-		 const struct vmpacket_descriptor *pkt)
-{
-	return hv_pkt_iter_next_pkt(channel, pkt, true);
-}
-
 #define foreach_vmbus_pkt(pkt, channel) \
 	for (pkt = hv_pkt_iter_first(channel); pkt; \
 	    pkt = hv_pkt_iter_next(channel, pkt))
-- 
2.25.1

