Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53FB500039
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238693AbiDMUuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 16:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238729AbiDMUuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 16:50:40 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33E983B1D;
        Wed, 13 Apr 2022 13:48:13 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bg10so6377349ejb.4;
        Wed, 13 Apr 2022 13:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+zgbrTLpNU3XbVpcZAEA03NRL/Qn9JM6rnRzwV0uwFE=;
        b=jmorgWFE3Zkh2E6vy9kyEQFLtT5S6q5gSJdf23Pix4smxSFMp3p3vZam5vSEdmF9r8
         YqDFp7QzrJZ8RDxpJHB9XXeL89mMBXZOpcotPUPqAHPVYyvhiukswiS9Ee25tY2kibgA
         dekV6K1YfdMQDu0emncIBrqqOYSyZjwelSTDYcO/JxmBX+g+AkEyc4ltLHi06tTrw2hD
         vpd5CcHNMcVohRzCrpZKlaSHW0TmzaFhpKtX7N8qnJvFpwaNXFhNLY4YOmzmpVgmZjva
         7wKTKEUN9Qbd2glEqtm1c86SUDxyFEcWejRYQlXGhUxBrprTmv9lT45xQCk7Tbi8DaIV
         XaSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+zgbrTLpNU3XbVpcZAEA03NRL/Qn9JM6rnRzwV0uwFE=;
        b=55fPZ+FAr0cD6LAJlEj1AOhIJX7voDRqgPdDMYU0guomNujCDw4ib3aUSy1I/XONrM
         gvpedYlFhr/V/bzg68JykaOQgmQns1aU0JhahXYlp9l8CC8V9mudfr8GwkooWomb2RWF
         yNyiGX3YJVG/VvLLhRlbVKYbF9kQqRpZYDubTXAZtNVpgOakndIkdLgjgBfE5XRd6lif
         Y7+xO65xtWpBDMnxTMoiTK9rZg4sIZ3GDSJ0M5lsg0ihWVZ7YFDc0wa/h6tfJMXyVkgW
         Y0qvLXnHI3O1tEikk0Pnbc5L4+y83LxidiPBN/3exuhy7V6PSVD/aD2JQgNqhckjKHV0
         b5FQ==
X-Gm-Message-State: AOAM531iCH37eFxlvlgcZF9DXgBUDcL0+8JABtUJEx+0w7e2Pojjx3YN
        OEmckr/l1BWiAT+5jBJ6zId64AUvhE6/0hh9
X-Google-Smtp-Source: ABdhPJyu9eKM4t589+KiDfysMd52ZbJVG8i+76iicT//pZfSwCoJGqTSTngOFI83dkHofzdn+iOA+A==
X-Received: by 2002:a17:907:9493:b0:6e0:59f5:6705 with SMTP id dm19-20020a170907949300b006e059f56705mr41913922ejc.289.1649882892317;
        Wed, 13 Apr 2022 13:48:12 -0700 (PDT)
Received: from anparri.mshome.net (host-79-52-64-69.retail.telecomitalia.it. [79.52.64.69])
        by smtp.gmail.com with ESMTPSA id u6-20020a170906408600b006e87d654270sm5021ejj.44.2022.04.13.13.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 13:48:11 -0700 (PDT)
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
Subject: [RFC PATCH 6/6] Drivers: hv: vmbus: Refactor the ring-buffer iterator functions
Date:   Wed, 13 Apr 2022 22:47:42 +0200
Message-Id: <20220413204742.5539-7-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413204742.5539-1-parri.andrea@gmail.com>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/hv/ring_buffer.c | 11 +++++------
 include/linux/hyperv.h   | 35 ++++-------------------------------
 2 files changed, 9 insertions(+), 37 deletions(-)

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 3d215d9dec433..c9357dae2a2c8 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -421,7 +421,7 @@ int hv_ringbuffer_read(struct vmbus_channel *channel,
 	memcpy(buffer, (const char *)desc + offset, packetlen);
 
 	/* Advance ring index to next packet descriptor */
-	__hv_pkt_iter_next(channel, desc, true);
+	__hv_pkt_iter_next(channel, desc);
 
 	/* Notify host of update */
 	hv_pkt_iter_close(channel);
@@ -459,7 +459,8 @@ static u32 hv_pkt_iter_avail(const struct hv_ring_buffer_info *rbi)
 /*
  * Get first vmbus packet without copying it out of the ring buffer
  */
-struct vmpacket_descriptor *hv_pkt_iter_first_raw(struct vmbus_channel *channel)
+static struct vmpacket_descriptor *
+hv_pkt_iter_first_raw(struct vmbus_channel *channel)
 {
 	struct hv_ring_buffer_info *rbi = &channel->inbound;
 
@@ -470,7 +471,6 @@ struct vmpacket_descriptor *hv_pkt_iter_first_raw(struct vmbus_channel *channel)
 
 	return (struct vmpacket_descriptor *)(hv_get_ring_buffer(rbi) + rbi->priv_read_index);
 }
-EXPORT_SYMBOL_GPL(hv_pkt_iter_first_raw);
 
 /*
  * Get first vmbus packet from ring buffer after read_index
@@ -534,8 +534,7 @@ EXPORT_SYMBOL_GPL(hv_pkt_iter_first);
  */
 struct vmpacket_descriptor *
 __hv_pkt_iter_next(struct vmbus_channel *channel,
-		   const struct vmpacket_descriptor *desc,
-		   bool copy)
+		   const struct vmpacket_descriptor *desc)
 {
 	struct hv_ring_buffer_info *rbi = &channel->inbound;
 	u32 packetlen = desc->len8 << 3;
@@ -548,7 +547,7 @@ __hv_pkt_iter_next(struct vmbus_channel *channel,
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

