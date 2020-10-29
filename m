Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6069229F369
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 18:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgJ2RhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 13:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728239AbgJ2RhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 13:37:01 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2614DC0613D2;
        Thu, 29 Oct 2020 10:37:01 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id t9so3657085wrq.11;
        Thu, 29 Oct 2020 10:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZN9q/Y6OeE8OvjE9ndjDIiPBe9AYlM9WA2uqyySHQFo=;
        b=X062sv2F77/9qubOAoCI37thsjJ50BF1Y3PUc5MmOFVeG//ofi/GyN9EpSosRdn/9x
         L/qmahRaLZ2GxTlkdsTB4WnoX258mxaPo9ekM3tSu1na0P+P5EYvDoZ3iV6L539Ul++E
         x9lGSjXobUakyEbw/qg9t56iFNUN5H+vDJLZikBZPpUF+cM+g1KcpYvOeAX5TsSQc+vg
         /TjNLd+ZhKsRE4EDqT4dQONBV9mRnEUT4Y6PiHZYn5+9o1htNSeqyXynP3/60J23D3gF
         bnz878mPB6uHTqIHlj38UVz4vRNiibp0sbo/5q/Ohp7H7UFxdE0zz+SsYV+mwlnLDA4D
         ltQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZN9q/Y6OeE8OvjE9ndjDIiPBe9AYlM9WA2uqyySHQFo=;
        b=nwbJAmbNY1XxQ/I7FBmvv3jL6Gi1lwv4S1JReZkAmV2dh+lqn+vTgSGm+xXN4IM2Qz
         eHCZ3tLQ5ja1ok0O23fsYHCSQI0nQ1s/5BNCsuBVlikKFotMODnOjpJRnCCOnDsbq5/g
         7kkqLxeNKizzD2kUPJ1ijMTkBxtjPk73z6+GMknDfHEXS5HqCABoO+kLpsmLxxJiS+vV
         LgvFoaECLPao8ZcaBcw0eP2VJMTAmJTnj1eg6ex2C3Yg42zZYjlexurmcCn1VivDLLqL
         qKmsYxmN1IwKZ7RXEW2PhMysX0kDtOAytdK7I3NpXOT9qQwmV/4RWqnSKXdSpD19mNJG
         v3Vg==
X-Gm-Message-State: AOAM531cfF2iwn5/uIcnBziQvfoMO1ZThZblVA4TBXZI/WKtaABWJ/ik
        BtKYIqOKz3ny0fnhpluUbyY=
X-Google-Smtp-Source: ABdhPJwyxEmFJ7sOA+MoFS7OiaPnIPW2KZ/huG4RZHcCpk/PAiKDqSKBDL0uaj3t+pA1T+dPjWav6Q==
X-Received: by 2002:adf:f212:: with SMTP id p18mr7221470wro.386.1603993019951;
        Thu, 29 Oct 2020 10:36:59 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id t4sm852122wmb.20.2020.10.29.10.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 10:36:59 -0700 (PDT)
From:   Aleksandr Nogikh <aleksandrnogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>
Subject: [PATCH v5 3/3] mac80211: add KCOV remote annotations to incoming frame processing
Date:   Thu, 29 Oct 2020 17:36:20 +0000
Message-Id: <20201029173620.2121359-4-aleksandrnogikh@gmail.com>
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
In-Reply-To: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
References: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>

Add KCOV remote annotations to ieee80211_iface_work() and
ieee80211_rx_list(). This will enable coverage-guided fuzzing of
mac80211 code that processes incoming 802.11 frames.

Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
---
v4 -> v5:
* Using ieee80211_rx_list() instead of ieee80211_rx().
v1 -> v2:
* The commit now affects ieee80211_rx() instead of
  ieee80211_tasklet_handler().
---
 net/mac80211/iface.c |  2 ++
 net/mac80211/rx.c    | 16 +++++++++-------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 1be775979132..56a1bcea2c1c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1356,6 +1356,7 @@ static void ieee80211_iface_work(struct work_struct *work)
 	while ((skb = skb_dequeue(&sdata->skb_queue))) {
 		struct ieee80211_mgmt *mgmt = (void *)skb->data;
 
+		kcov_remote_start_common(skb_get_kcov_handle(skb));
 		if (ieee80211_is_action(mgmt->frame_control) &&
 		    mgmt->u.action.category == WLAN_CATEGORY_BACK) {
 			int len = skb->len;
@@ -1465,6 +1466,7 @@ static void ieee80211_iface_work(struct work_struct *work)
 		}
 
 		kfree_skb(skb);
+		kcov_remote_stop();
 	}
 
 	/* then other type-dependent work */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1e2e5a406d58..09d1c9fb8872 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4742,6 +4742,8 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 
 	status->rx_flags = 0;
 
+	kcov_remote_start_common(skb_get_kcov_handle(skb));
+
 	/*
 	 * Frames with failed FCS/PLCP checksum are not returned,
 	 * all other frames are returned without radiotap header
@@ -4749,15 +4751,15 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 	 * Also, frames with less than 16 bytes are dropped.
 	 */
 	skb = ieee80211_rx_monitor(local, skb, rate);
-	if (!skb)
-		return;
-
-	ieee80211_tpt_led_trig_rx(local,
-			((struct ieee80211_hdr *)skb->data)->frame_control,
-			skb->len);
+	if (skb) {
+		ieee80211_tpt_led_trig_rx(local,
+					  ((struct ieee80211_hdr *)skb->data)->frame_control,
+					  skb->len);
 
-	__ieee80211_rx_handle_packet(hw, pubsta, skb, list);
+		__ieee80211_rx_handle_packet(hw, pubsta, skb, list);
+	}
 
+	kcov_remote_stop();
 	return;
  drop:
 	kfree_skb(skb);
-- 
2.29.1.341.ge80a0c044ae-goog

