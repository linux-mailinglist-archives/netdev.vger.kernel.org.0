Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C796E4422
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjDQJkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjDQJjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:39:46 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6660E1BCB
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:38:59 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id u3so10439063ejj.12
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681724333; x=1684316333;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VGc/AXBbd3S7d1pfj4NXOSpGX22EGMAWawOhVjM8r1Y=;
        b=SBXMJP8x4UF5byWwUAKoX68wMXB1iy+JYIKx4DgcaEvcx06aSb5EHlK5YwL3NyOgHP
         RxVUrn4QzesZfAiEfQnP5MKHEofTeER61tfS86tgIznH+CLAaYJ5U0TSo5CIG9zK9fDK
         1bfO+GjtdUl9By6e7065lDqagiLNUP4U7RK59Mx0jqY/bA+ObIojmb5qK12rurr9I610
         WO1F64bnQESuxxZgoRwoiqMaskxMhVPA5LOPW04UucOWo/2NN+yK7ZrvN1UD6lIJjBsz
         jzmNMiR1ms1hUlIxrI7I3Vhb9YD1WhttiVKz3xEN7zHuacZjgbtjDYBP04AI46xVaHw7
         PLUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681724333; x=1684316333;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VGc/AXBbd3S7d1pfj4NXOSpGX22EGMAWawOhVjM8r1Y=;
        b=GfidH6iNuEYo+OGUjZCWlMDrGLQs+h9zCqC5WQsdfqOCLVP2lSxT9jbqL3m8AQBzA2
         y+juXGu3HJ8lmK+k3ZFKH1CM5ZzBmwyCnksxrPOqL3JYN3BbvuK2BG/3qLXCjYYz0EK7
         f813o2oAXo2VpRpHy3D5c2OKd1P8pcQ1CsLTlRnyu51qjEZGqEiLpAduth4uWpZDJ3fI
         +qf6702RsNHhi47gNvu9zCyOf6+GGr5C7HIAvJEqq5lX4Ec4i1Ksja6wXt2wB/9kjn3O
         RFIX0KXx9msTdvz9HElVdBdJQf4cq9O1H1fC10e+cRLAtoFzVwyi21K0gbWU9I+GEKd1
         V1RQ==
X-Gm-Message-State: AAQBX9flf3ZugqBtFMEofrNJtEFdWuGvxZbU6XpQShZCV6QhehgWM715
        8rZzAZbtfdaGpfdEMD89eBQ=
X-Google-Smtp-Source: AKy350bWfPlfY83PQ/nuCszjfxi7O2zL+vfXiP37NGqtKAz5zFCQf3tQ5LAeg2vU2bhLJpMYb/Pljw==
X-Received: by 2002:a17:906:4e53:b0:930:f953:9614 with SMTP id g19-20020a1709064e5300b00930f9539614mr7008362ejw.1.1681724332714;
        Mon, 17 Apr 2023 02:38:52 -0700 (PDT)
Received: from ?IPV6:2a01:c22:770d:1c00:59f1:1548:39fc:ccd5? (dynamic-2a01-0c22-770d-1c00-59f1-1548-39fc-ccd5.c22.pool.telefonica.de. [2a01:c22:770d:1c00:59f1:1548:39fc:ccd5])
        by smtp.googlemail.com with ESMTPSA id gy23-20020a170906f25700b0094f31208918sm2923500ejb.108.2023.04.17.02.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 02:38:52 -0700 (PDT)
Message-ID: <8a12a0fd-849a-82c2-fdd5-8ece23111318@gmail.com>
Date:   Mon, 17 Apr 2023 11:37:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: [PATCH net-next v3 2/3] r8169: use new macro
 netif_subqueue_maybe_stop in rtl8169_start_xmit
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7147a001-3d9c-a48d-d398-a94c666aa65b@gmail.com>
In-Reply-To: <7147a001-3d9c-a48d-d398-a94c666aa65b@gmail.com>
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

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2:
- ring doorbell if queue was stopped
v3:
- remove change log from commit message
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

