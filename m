Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8241C6E2F76
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 09:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjDOHYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 03:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjDOHYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 03:24:20 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAF159E7
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 00:24:18 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id dm2so51287317ejc.8
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 00:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681543457; x=1684135457;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RK28hzg8zR/EJQwiFtx4DmL6CkIIAfbAnzEygXZr6i4=;
        b=QnLVFJREcDej01wZXmrrCEqVP5PMHc1tKeS11ZKOMEgvFL/HZeCFGERcGzbyNiD05N
         tKB5R85dO5m8qgKGj3EwXlCmTSv0VMHofs25aNIDUhbvDwTKrcX+MzUKXHvDwhYo7ewR
         ukuJTZczkW9sr/OvTFodhsy+8X73ZF6krR4cA0NL8ZVzV0eFmj/6/SwC7b654UpQT//V
         yGsPT/iEPxfV+AxzxW81RJSRWM3b9JbATm5gAF2EedxUx5LIqRZFT/b8Q1Z1WC1oY9lH
         4SDHCw3RWLXDQcf11Lz7NEbJeBBThO7KaGInBNucaAZ8KoyjOBa7/RuazL/yZaPUylYU
         iYaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681543457; x=1684135457;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RK28hzg8zR/EJQwiFtx4DmL6CkIIAfbAnzEygXZr6i4=;
        b=Wh2psmN/q+/1ig6T7738ALhBLzZwcRbrOTZASV8kk5qaIk1JC7C5/5kNYYSUobD7Qa
         9GZ2a4kEwVkSAH8JhspamcUQ5w5+FhFZBjUbT1WOhGSe1aJZrGPFO3ciSacjYk9Ia/YD
         78WNHaYi4BddvDxvQc56pX0svALuRbRMy3aZT+jorOtYmoXwhGsl6JN9RwMmzySX27oW
         MJRw/O/X6XK+g3WbbOj4zLcBQWD8FdlWfCfNwI8tVGtmWmov/w5yu0ZF+pi1XMp6PJNY
         mhC9OUQgze/RG22zGMaCsGyy9orB5D3I6z1Tc2vzarL5Q9+pKnjTcL6eZ0mSW3l8ubrq
         abtQ==
X-Gm-Message-State: AAQBX9f+RZBywp/1pgkFuNp8My6iAgVBUfGOTELP+q6xSTV1ZPqWYHTC
        Sp8x9xRHMGAW0M90SA3MMwU=
X-Google-Smtp-Source: AKy350bb37QeeBiKl0snsAU32aINK4zbm5Ud5au+djjkhOJcvyvDu2eTfYDAyoa2PtGwU5wj/WeVFw==
X-Received: by 2002:a17:906:a84d:b0:93b:1c78:5796 with SMTP id dx13-20020a170906a84d00b0093b1c785796mr1373373ejb.43.1681543457209;
        Sat, 15 Apr 2023 00:24:17 -0700 (PDT)
Received: from ?IPV6:2a01:c22:76c9:5300:c449:604e:39a7:3bce? (dynamic-2a01-0c22-76c9-5300-c449-604e-39a7-3bce.c22.pool.telefonica.de. [2a01:c22:76c9:5300:c449:604e:39a7:3bce])
        by smtp.googlemail.com with ESMTPSA id p3-20020a17090635c300b0094ed14a5b75sm2327049ejb.51.2023.04.15.00.24.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Apr 2023 00:24:16 -0700 (PDT)
Message-ID: <69c2eec2-d82c-290a-d6ce-fba64afb32c6@gmail.com>
Date:   Sat, 15 Apr 2023 09:22:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: [PATCH net-next v2 2/3] r8169: use new macro
 netif_subqueue_maybe_stop in rtl8169_start_xmit
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f07fd01b-b431-6d8d-bd14-d447dffd8e64@gmail.com>
In-Reply-To: <f07fd01b-b431-6d8d-bd14-d447dffd8e64@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new net core macro netif_subqueue_maybe_stop in the start_xmit path
to simplify the code. Whilst at it, set the tx queue start threshold to
twice the stop threshold. Before values were the same, resulting in
stopping/starting the queue more often than needed.

v2:
- ring doorbell if queue was stopped

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 39 +++++++----------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9f8357bbc..fff44d46b 100644
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
@@ -4245,27 +4244,10 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 
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
+	stop_queue = !netif_subqueue_maybe_stop(dev, 0, rtl_tx_slots_avail(tp),
+						R8169_TX_STOP_THRS,
+						R8169_TX_START_THRS);
+	if (door_bell || stop_queue)
 		rtl8169_doorbell(tp);
 
 	return NETDEV_TX_OK;
@@ -4400,7 +4382,8 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
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


