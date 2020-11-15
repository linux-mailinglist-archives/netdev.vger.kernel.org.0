Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8F52B3941
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 21:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgKOUzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 15:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbgKOUzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 15:55:41 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF9BC0613CF
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 12:55:40 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id s8so16599640wrw.10
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 12:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=bnqh0OEhBL9mIoFHsAn9gkENvfOLGade58j+JVAhPBw=;
        b=Qkw1vruaTgcAXc/dyBon4uzwFe8HJQyA2K9X7O2z4KSUk18wNvH0VcEEUTdSQrhyYe
         TWqb7QxATVy/AIfUyv1YS9O8jRqs+QxT6v2QmBnLtP3zCB6yKTOR70oHtwUkFYFBhpgC
         2u83glsxSXoJ32oFvLoDp/q+T45iI4uRJSeMP+zKlWjKYA+Nmp/MSYHR40ULJzuU6MMx
         Wcub1HwuHEM9S9cz5H6jQTYZX6W45/2CEXoRLgiBTBMDQ1etH1ee2iAwDx9B3sMqyThQ
         iuc3hntONYaw/+kX48hRIhqMeKwFV3TDJEW1IIdv46YxnxCB4Zvhs8ZYl4dQxaP9vjKr
         nuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=bnqh0OEhBL9mIoFHsAn9gkENvfOLGade58j+JVAhPBw=;
        b=W9bLHNFn3AHeBOgxhY+3lJ/AUJcly37CogYI0QAAK1mi+ZbhI3aO5wwChlONXKGOTY
         pE6qSX3TEPANSYCeK2f/C5jaQnPr3uT1WwOXh6Ub8u/kdBpha4IT069xNMpxtQWveRcO
         8/ghgYaOQrcl4diX0hw2CO0TSyGAnviI0mcz3DusXEVPcqAdSITgEt58u1qoYCfPbNLf
         4dDD9t9pvxG9J1ITUfp6506Xt2UZtzC8sVAB/QwzqYVXJLTdITqVmBmPE7HxfZaGd3un
         TElYTdh+p10y/Bf5LtFrhXIA89Y4XlYVaVb5H8j0KXiLEigYcfMEXJ599iIjsuhkHxlC
         Xf6Q==
X-Gm-Message-State: AOAM5339967P4iIkFv5QlBLqMnZjze++6HWGqYPj0PaaLbFd68SRFJ56
        FqMf0BzjVWXOTQZAFziQP7p7PBJW0b5OQQ==
X-Google-Smtp-Source: ABdhPJwIkcTeq4CFv65zXO3zJ8L/WCDswO5oWs4rEn7TASUFzm8QvjXupHfFeILV4bJTL/twbgwsFA==
X-Received: by 2002:a5d:5291:: with SMTP id c17mr15449568wrv.311.1605473739185;
        Sun, 15 Nov 2020 12:55:39 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:a8ab:4fab:3f88:f3fd? (p200300ea8f232800a8ab4fab3f88f3fd.dip0.t-ipconnect.de. [2003:ea:8f23:2800:a8ab:4fab:3f88:f3fd])
        by smtp.googlemail.com with ESMTPSA id x2sm14162704wru.44.2020.11.15.12.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Nov 2020 12:55:38 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: remove nr_frags argument from
 rtl_tx_slots_avail
Message-ID: <34cdb172-c5d5-fb18-dd15-e502a5c23966@gmail.com>
Date:   Sun, 15 Nov 2020 21:55:32 +0100
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

