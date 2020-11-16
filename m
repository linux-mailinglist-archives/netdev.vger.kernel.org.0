Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C332B4A3D
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 17:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731658AbgKPQDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 11:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728858AbgKPQDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 11:03:21 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE44CC0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 08:03:20 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id k2so19292909wrx.2
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 08:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=bnqh0OEhBL9mIoFHsAn9gkENvfOLGade58j+JVAhPBw=;
        b=OZFJdgAcDL0DMQ/ouvQFAPEZ3Li84/rVGl7l5PEUPQUHv2O3bxxkg6/eY6E7ajbah+
         1Dd/hzHx9qy2WTkaHlPu6++jnWPs1KWWQDBMHwVGfmjnTYn9dElAQA9+T3yJ9anxnkfJ
         KWn7PUMcyuvBrOYSVWCkerX7DEOq53vHsEAdB+nXNVPxHTkK1f+fdvh/n+5lGpR8Dr++
         UYEf6pCm0/X4ICN6tGmxsbeJ3VqevFA19m2e/hdWJxnbdKCtAdoKm6G9JP4Px31HHgtY
         9900oPTAEESpDLR7JVPqXfrWNNKlzf0jB6HLwRP07l2i+E9MgpoCDaa5PulSzRD1U8tz
         MD5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=bnqh0OEhBL9mIoFHsAn9gkENvfOLGade58j+JVAhPBw=;
        b=GOFrVb3UmyAK/5w4Gp+a6aqOOfw9RfD9f+AM55BvQsuHWFPZF3poegNofoMuSegU+2
         gghjVH6hAFr7GtWU9H2PUnxwJ1ccQ2fu/qORfh3/Va4X5g4bsVVMefxgf5DThpyxjndq
         CMTCW9cPG7jPtIiDXY/Awa5Z8eOlzeRYsCaALUYITZDYbXZgeAXbcd7lH2f79cj802il
         Xta9AhmahpUhsgX0pGkE5FpuG0MYHqzW4FUINLTF1DCxcNGUDV+pHKumh7q/r5TaEZNp
         nCF96S2dZWOgtxUvPOhKWbI8G6G5jYTicpoYFu98xeFvYRtI4mA56Tgv6N1DMa62l+R8
         7sdA==
X-Gm-Message-State: AOAM53116PFcVg88RsOTeZa+oe4OCxv2CbZn1aHr/cwK8XpGRjaTb5Fw
        hAw9omadxUCs1BOHPRneUeRz4xu3/g4MUg==
X-Google-Smtp-Source: ABdhPJz0A120ofDBvVxs1qlne2ovwxVsXhlvPO9ANMXvaqclq1bR3Il9H4QdNvi1qSLldv+Jl2pokQ==
X-Received: by 2002:adf:ed04:: with SMTP id a4mr21292857wro.172.1605542598821;
        Mon, 16 Nov 2020 08:03:18 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:8d69:63ef:3641:27b7? (p200300ea8f2328008d6963ef364127b7.dip0.t-ipconnect.de. [2003:ea:8f23:2800:8d69:63ef:3641:27b7])
        by smtp.googlemail.com with ESMTPSA id k1sm19938364wrp.23.2020.11.16.08.03.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 08:03:18 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH RESEND net-next] r8169: remove nr_frags argument from
 rtl_tx_slots_avail
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <3d1f2ad7-31d5-2cac-4f4a-394f8a3cab63@gmail.com>
Date:   Mon, 16 Nov 2020 17:03:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only time when nr_frags isn't SKB_MAX_FRAGS is when entering
rtl8169_start_xmit(). However we can use SKB_MAX_FRAGS also here
because when queue isn't stopped there should always be room for
MAX_SKB_FRAGS + 1 descriptors.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8fd56ebad..e05df043c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4141,14 +4141,13 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 	return true;
 }
 
-static bool rtl_tx_slots_avail(struct rtl8169_private *tp,
-			       unsigned int nr_frags)
+static bool rtl_tx_slots_avail(struct rtl8169_private *tp)
 {
 	unsigned int slots_avail = READ_ONCE(tp->dirty_tx) + NUM_TX_DESC
 					- READ_ONCE(tp->cur_tx);
 
 	/* A skbuff with nr_frags needs nr_frags+1 entries in the tx queue */
-	return slots_avail > nr_frags;
+	return slots_avail > MAX_SKB_FRAGS;
 }
 
 /* Versions RTL8102e and from RTL8168c onwards support csum_v2 */
@@ -4183,7 +4182,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 
 	txd_first = tp->TxDescArray + entry;
 
-	if (unlikely(!rtl_tx_slots_avail(tp, frags))) {
+	if (unlikely(!rtl_tx_slots_avail(tp))) {
 		if (net_ratelimit())
 			netdev_err(dev, "BUG! Tx Ring full when queue awake!\n");
 		goto err_stop_0;
@@ -4228,7 +4227,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 
 	WRITE_ONCE(tp->cur_tx, tp->cur_tx + frags + 1);
 
-	stop_queue = !rtl_tx_slots_avail(tp, MAX_SKB_FRAGS);
+	stop_queue = !rtl_tx_slots_avail(tp);
 	if (unlikely(stop_queue)) {
 		/* Avoid wrongly optimistic queue wake-up: rtl_tx thread must
 		 * not miss a ring update when it notices a stopped queue.
@@ -4243,7 +4242,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 		 * can't.
 		 */
 		smp_mb__after_atomic();
-		if (rtl_tx_slots_avail(tp, MAX_SKB_FRAGS))
+		if (rtl_tx_slots_avail(tp))
 			netif_start_queue(dev);
 		door_bell = true;
 	}
@@ -4395,10 +4394,8 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 		 * ring status.
 		 */
 		smp_store_mb(tp->dirty_tx, dirty_tx);
-		if (netif_queue_stopped(dev) &&
-		    rtl_tx_slots_avail(tp, MAX_SKB_FRAGS)) {
+		if (netif_queue_stopped(dev) && rtl_tx_slots_avail(tp))
 			netif_wake_queue(dev);
-		}
 		/*
 		 * 8168 hack: TxPoll requests are lost when the Tx packets are
 		 * too close. Let's kick an extra TxPoll request when a burst
-- 
2.29.2

