Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C4C509120
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 22:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382096AbiDTULU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 16:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382066AbiDTUKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 16:10:44 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252594738F;
        Wed, 20 Apr 2022 13:07:52 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id f17so3759819edt.4;
        Wed, 20 Apr 2022 13:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jgbU6+UKMrFaCyV2cRMHk+0IULMTYKeEHlBySELDljA=;
        b=k4l0mt+CPkmxIn2s/XBG5DM9kpYWuVHWRLSOarEzjqOPxZwGfBONSzl5nSNPsrXwzh
         wvg6/oO2H9ZW9qy3y9i4hc0/TPlmIOjf/ssPlGwtY9RAre7q5xSLqzWgGBxEtMJHQM5Y
         55kmmKFiM6J77fQuT8vWRy0J8B+IbtxKAZG4oGgc4ywFAzlpcSGDuMKY4dWqoambEIIU
         n/XsTQ7ktiYYHy88ZwaFBlj08dCPA77bpyvf0jBZ5886XJBVSo0t+eHFuLCGYPdmk6fs
         lGXX9to3SE0myYhpLyD9hdXa7ecs25IPVJepGXvAtn9vQmeLFBN3Ps568marx9PzyqsV
         vWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jgbU6+UKMrFaCyV2cRMHk+0IULMTYKeEHlBySELDljA=;
        b=unQw4HLyUPhhS82gCO3szf1tN/+NeK2CTWl2GG/3jM6JSYsIBR9gmR8VS0Sx6Ym3Lz
         5h1CqOlfFWzVf7FNyGoyxNZmCqqvAy+71AmvlmNcRyqnLXb9wT5bQb80lAtDka7BLxwo
         yfQT1vVQYwzWITUR8BISm1wsJG0uKZKUFOLyXG0FsOvYbLF1P+IWU3PfFuZNCY9o5uUF
         wS+GlF2TI2Mz1tjXZt5/6TPiKfB6i9GYLcfxBWpLI7PobjfUnKQa29xdyLOCGp0kOyBZ
         XolUA3E28Om6NrzTGJgHjUJ1HquOeXhjIxSkSs4FAYmNZXPukRB3bOrPYWdzTe0ukSaV
         g+/Q==
X-Gm-Message-State: AOAM533UUhWsUAbI8SDTFmu6CSj3l2b4YE4B9c9RBYI2miTpzTGuGn3D
        olrOU9CMMqhJpoMiktl2DOc2kQQuwALhvsJd
X-Google-Smtp-Source: ABdhPJyRPMuB76L1g7iwvZj7xk/t0HTeEYFXgzyK0fRO/y7PZhA4FyYJe4doPA/3rcCveWfsIF3tVQ==
X-Received: by 2002:aa7:d047:0:b0:41d:57cf:d588 with SMTP id n7-20020aa7d047000000b0041d57cfd588mr24916641edo.172.1650485270544;
        Wed, 20 Apr 2022 13:07:50 -0700 (PDT)
Received: from anparri.mshome.net (host-82-53-3-95.retail.telecomitalia.it. [82.53.3.95])
        by smtp.gmail.com with ESMTPSA id gy10-20020a170906f24a00b006e894144707sm7126853ejb.53.2022.04.20.13.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 13:07:50 -0700 (PDT)
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
Subject: [PATCH 5/5] Drivers: hv: vmbus: Refactor the ring-buffer iterator functions
Date:   Wed, 20 Apr 2022 22:07:20 +0200
Message-Id: <20220420200720.434717-6-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220420200720.434717-1-parri.andrea@gmail.com>
References: <20220420200720.434717-1-parri.andrea@gmail.com>
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
---
 drivers/hv/ring_buffer.c | 32 +++++++++-----------------------
 include/linux/hyperv.h   | 35 ++++-------------------------------
 2 files changed, 13 insertions(+), 54 deletions(-)

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 3d215d9dec433..fa98b3a91206a 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -421,7 +421,7 @@ int hv_ringbuffer_read(struct vmbus_channel *channel,
 	memcpy(buffer, (const char *)desc + offset, packetlen);
 
 	/* Advance ring index to next packet descriptor */
-	__hv_pkt_iter_next(channel, desc, true);
+	__hv_pkt_iter_next(channel, desc);
 
 	/* Notify host of update */
 	hv_pkt_iter_close(channel);
@@ -456,22 +456,6 @@ static u32 hv_pkt_iter_avail(const struct hv_ring_buffer_info *rbi)
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
@@ -483,11 +467,14 @@ struct vmpacket_descriptor *hv_pkt_iter_first(struct vmbus_channel *channel)
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
@@ -534,8 +521,7 @@ EXPORT_SYMBOL_GPL(hv_pkt_iter_first);
  */
 struct vmpacket_descriptor *
 __hv_pkt_iter_next(struct vmbus_channel *channel,
-		   const struct vmpacket_descriptor *desc,
-		   bool copy)
+		   const struct vmpacket_descriptor *desc)
 {
 	struct hv_ring_buffer_info *rbi = &channel->inbound;
 	u32 packetlen = desc->len8 << 3;
@@ -548,7 +534,7 @@ __hv_pkt_iter_next(struct vmbus_channel *channel,
 		rbi->priv_read_index -= dsize;
 
 	/* more data? */
-	return copy ? hv_pkt_iter_first(channel) : hv_pkt_iter_first_raw(channel);
+	return hv_pkt_iter_first(channel);
 }
 EXPORT_SYMBOL_GPL(__hv_pkt_iter_next);
 
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 1112c5cf894e6..370adc9971d3e 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1673,55 +1673,28 @@ static inline u32 hv_pkt_len(const struct vmpacket_descriptor *desc)
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

