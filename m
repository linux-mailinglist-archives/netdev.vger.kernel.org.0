Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00C46E150F
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 21:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjDMTRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 15:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjDMTR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 15:17:27 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252A19005
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:17:09 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id s2so11977961wra.7
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681413427; x=1684005427;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=raFo48GDQifsTU8IasICU/ffWeXP8x/4SWkf8yN3YHo=;
        b=aNZGMXB3OhSNIUqGfHlYiBiW5VPgQ//i26dKMhqAwJ8W2TULEJFrBC7dBMdO6t1U3W
         /BBv3ql03HvsymfpdVymQgef0996x2B8ek79GP8hOlkUdo2C9cl5LF33PHli0w62b6sJ
         sG/2rRGRJ0rY5UtWJJGY8ZDEMWJ142qIY4N4cwTe30fRP0kNUp17T14oVXJPMfznWwKB
         1pZkkhtUftDdV1qSgxT5wWZpVVtM6mMUufidYL5cD62t5hdsBOC1yc3VapI+NgMrm2of
         jgoOx97AMZqrszyv5j1cvP2S1kRRqDscs1J76UL+iy58krCRz7YdjDSThdKKDdehRqgj
         8dzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681413427; x=1684005427;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=raFo48GDQifsTU8IasICU/ffWeXP8x/4SWkf8yN3YHo=;
        b=V870IHJiUw9X4re/9iOB30dl5MC3BDHpZTq6cKZ0d1DYyLX85r4aDr7Fr+mVNiwvPU
         tZNFOvF/DH+TMIEhnr3MN9HDyThjyg95xHr1tqepN2Y1/Cj6iSqLX+Zk757cLCtvwfll
         E1R3YrtoOMUc0HBxIAZzdOuiH6C0Q7KPc7pZ7NFYiGFt/o89ykrCqpCWd0W2RBfw1l1H
         e6RgjPdFPdDDt++rFsispBdh7RpeFn9dKGNjYHBXQdDuFcxXJQvWvOGXhxf6IzlEcOWA
         BaAPI4t/IebOnezcrdvj45HZ4npJLnCFpT0pH2nEOzc3ka7ovQQPHdL0XViXVdJdEYI4
         XUxw==
X-Gm-Message-State: AAQBX9fgZoeEdDOP6MuLW+JCrF67XDfFqiaYzmQDcG27htxWhlVjkNp1
        kuacPv0rY760TQC87fEkZfY=
X-Google-Smtp-Source: AKy350Z5kKKmMxHmvE8BmAYn/AtmkxF+XTNmnCGLCQNo/DhpLEDahF4jzVDoQDQo/ykTYr1cUQ/oWw==
X-Received: by 2002:a5d:6a89:0:b0:2f5:ce19:8ec2 with SMTP id s9-20020a5d6a89000000b002f5ce198ec2mr2208121wru.11.1681413427543;
        Thu, 13 Apr 2023 12:17:07 -0700 (PDT)
Received: from ?IPV6:2a01:c22:738e:4400:f580:be04:1a64:fc5e? (dynamic-2a01-0c22-738e-4400-f580-be04-1a64-fc5e.c22.pool.telefonica.de. [2a01:c22:738e:4400:f580:be04:1a64:fc5e])
        by smtp.googlemail.com with ESMTPSA id b5-20020a5d45c5000000b002c6e8af1037sm1855372wrs.104.2023.04.13.12.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 12:17:07 -0700 (PDT)
Message-ID: <ad9be871-92a6-6c72-7485-ebb424f2381d@gmail.com>
Date:   Thu, 13 Apr 2023 21:15:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: [PATCH net-next 2/3] r8169: use new macro netif_subqueue_maybe_stop
 in rtl8169_start_xmit
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <32e7eaf4-7e1c-04ce-eee5-a190349b31f9@gmail.com>
In-Reply-To: <32e7eaf4-7e1c-04ce-eee5-a190349b31f9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new net core macro netif_subqueue_maybe_stop in the start_xmit path
to simplify the code. Whilst at it, set the tx queue start threshold to
twice the stop threshold. Before values were the same, resulting in
stopping/starting the queue more often than needed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 42 +++++++----------------
 1 file changed, 13 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9f8357bbc..3f0b78fd9 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -30,6 +30,7 @@
 #include <linux/ipv6.h>
 #include <asm/unaligned.h>
 #include <net/ip6_checksum.h>
+#include <net/netdev_queues.h>
 
 #include "r8169.h"
 #include "r8169_firmware.h"
@@ -68,6 +69,8 @@
 #define NUM_RX_DESC	256	/* Number of Rx descriptor registers */
 #define R8169_TX_RING_BYTES	(NUM_TX_DESC * sizeof(struct TxDesc))
 #define R8169_RX_RING_BYTES	(NUM_RX_DESC * sizeof(struct RxDesc))
+#define R8169_TX_STOP_THRS	(MAX_SKB_FRAGS + 1)
+#define R8169_TX_START_THRS	(2 * R8169_TX_STOP_THRS)
 
 #define OCP_STD_PHY_BASE	0xa400
 
@@ -4162,13 +4165,9 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 	return true;
 }
 
-static bool rtl_tx_slots_avail(struct rtl8169_private *tp)
+static unsigned int rtl_tx_slots_avail(struct rtl8169_private *tp)
 {
-	unsigned int slots_avail = READ_ONCE(tp->dirty_tx) + NUM_TX_DESC
-					- READ_ONCE(tp->cur_tx);
-
-	/* A skbuff with nr_frags needs nr_frags+1 entries in the tx queue */
-	return slots_avail > MAX_SKB_FRAGS;
+	return READ_ONCE(tp->dirty_tx) + NUM_TX_DESC - READ_ONCE(tp->cur_tx);
 }
 
 /* Versions RTL8102e and from RTL8168c onwards support csum_v2 */
@@ -4198,7 +4197,8 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	struct rtl8169_private *tp = netdev_priv(dev);
 	unsigned int entry = tp->cur_tx % NUM_TX_DESC;
 	struct TxDesc *txd_first, *txd_last;
-	bool stop_queue, door_bell;
+	bool door_bell;
+	int stop_queue;
 	u32 opts[2];
 
 	if (unlikely(!rtl_tx_slots_avail(tp))) {
@@ -4245,27 +4245,10 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 
 	WRITE_ONCE(tp->cur_tx, tp->cur_tx + frags + 1);
 
-	stop_queue = !rtl_tx_slots_avail(tp);
-	if (unlikely(stop_queue)) {
-		/* Avoid wrongly optimistic queue wake-up: rtl_tx thread must
-		 * not miss a ring update when it notices a stopped queue.
-		 */
-		smp_wmb();
-		netif_stop_queue(dev);
-		/* Sync with rtl_tx:
-		 * - publish queue status and cur_tx ring index (write barrier)
-		 * - refresh dirty_tx ring index (read barrier).
-		 * May the current thread have a pessimistic view of the ring
-		 * status and forget to wake up queue, a racing rtl_tx thread
-		 * can't.
-		 */
-		smp_mb__after_atomic();
-		if (rtl_tx_slots_avail(tp))
-			netif_start_queue(dev);
-		door_bell = true;
-	}
-
-	if (door_bell)
+	stop_queue = netif_subqueue_maybe_stop(dev, 0, rtl_tx_slots_avail(tp),
+					       R8169_TX_STOP_THRS,
+					       R8169_TX_START_THRS);
+	if (door_bell || stop_queue < 0)
 		rtl8169_doorbell(tp);
 
 	return NETDEV_TX_OK;
@@ -4400,7 +4383,8 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 		 * ring status.
 		 */
 		smp_store_mb(tp->dirty_tx, dirty_tx);
-		if (netif_queue_stopped(dev) && rtl_tx_slots_avail(tp))
+		if (netif_queue_stopped(dev) &&
+		    rtl_tx_slots_avail(tp) >= R8169_TX_START_THRS)
 			netif_wake_queue(dev);
 		/*
 		 * 8168 hack: TxPoll requests are lost when the Tx packets are
-- 
2.40.0


