Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D1251194D
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235349AbiD0NRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 09:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbiD0NQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 09:16:53 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFC21BA7AD;
        Wed, 27 Apr 2022 06:13:07 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id k23so3339098ejd.3;
        Wed, 27 Apr 2022 06:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mBP/GAzMTLsxy2cYFH2pCl1g7q1hH9iiBkvTHN3bMu4=;
        b=ZmL/tGhgkZj1WGf42JDRnueRaVLUnPsmgFIIo9CjBqLzZ3qYJf0ZF96Uz3+BwwWGQ2
         D6VUAixplWRmPP9ozGjmrzgFINgzde9jH0XwBdWm9IGdees9RzZFX1GocwromdmdGO2M
         q3F2x37B6Ye3Wii8jphtjVzJeuhxosY7b4lRHvJXzp77rli8G+gC/UV/P1vO8sVDCWkp
         xs6VQm8rEaeywfzYmZecNH8NjvNkAbZJv28J1LUA9/T+67FOVM2AkvHelneXs38zBFZG
         8Oe6hO60Jx60CBPrJbr+L66RHFX0YMxB5wyUWFTFkBHr2oQWu2UMpDA0ZO90y8CUN3Az
         hqGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mBP/GAzMTLsxy2cYFH2pCl1g7q1hH9iiBkvTHN3bMu4=;
        b=hRe8AkHDjhNKhUAIxkUqTqMmPJAtvNz2O6V29hjz9ylfky2RIHiSldoM5dvvKvCRi7
         EzcnN9rjgXNq2dT4oNV8bnFHzGkjIdQ6lW2G7g7TJqKudspzgK3Mn5uSC4urcPwyoC93
         29kq0GdF4ubg35j1fkrnW22DCICFGDHQngK8RZOnbhZK07dKLgGJL6LPuHUX/iExGZhL
         EHjCYL0VM86ZwQo/ydntfaEqzmie0yifEa9OLT1A8Z0BHh48hAjM5rQO0fEWnsEu/fC2
         oH7qpR4TOyt40LzrhlYutLzH18cxwz5HIm9O8xN9BIEz4vgof4G/V5PvhZIyFwcKWMxY
         xwZQ==
X-Gm-Message-State: AOAM532dETAXAwMHSaoDrkafO1CI0T1YzjIHQQdsnF/JcU5jZad04WEJ
        51AwNVyijZAjBP8jNQHatME=
X-Google-Smtp-Source: ABdhPJxfXtkK60iYqNjHMF36d1saufevUF/WlgdmQNQBC1nA5sj/B4xamCDWtnsSQCtQYn3laxNkJQ==
X-Received: by 2002:a17:907:6d23:b0:6d9:ac9d:222 with SMTP id sa35-20020a1709076d2300b006d9ac9d0222mr26640258ejc.595.1651065185974;
        Wed, 27 Apr 2022 06:13:05 -0700 (PDT)
Received: from anparri.mshome.net (host-79-49-65-106.retail.telecomitalia.it. [79.49.65.106])
        by smtp.gmail.com with ESMTPSA id u6-20020a170906124600b006e843964f9asm6668987eja.55.2022.04.27.06.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 06:13:05 -0700 (PDT)
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
Subject: [PATCH v2 5/5] Drivers: hv: vmbus: Refactor the ring-buffer iterator functions
Date:   Wed, 27 Apr 2022 15:12:25 +0200
Message-Id: <20220427131225.3785-6-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220427131225.3785-1-parri.andrea@gmail.com>
References: <20220427131225.3785-1-parri.andrea@gmail.com>
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

