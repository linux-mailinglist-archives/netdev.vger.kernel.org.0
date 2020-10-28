Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6BA29DCCD
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387532AbgJ1W3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387519AbgJ1W3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:29:09 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A4FC0613CF;
        Wed, 28 Oct 2020 15:29:09 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id h22so754139wmb.0;
        Wed, 28 Oct 2020 15:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DQuN3G1QJvsPZrMdEIGvp5UTrwD1/Moi8emoV7bj3lU=;
        b=LC4YHuuaO3S5nUzs7zaNiLYtN3uzYyBPbHmVlyELMjyYQI2K3s5mLTvKZeYQKRBMcq
         sjORrjlPXAScZvnJSKJ8jtshEw1AYZMyrcZWgtzut8M6MgvPhyNXHh9gFG8nMaYMQlv8
         w7zxui7LntcCnup3JLTHNAVtq2+d4tyQjUwm9i4mkglptLWMEXCD/0MeW7e/13G6o8zJ
         qMsdpNv4Pt4d0ZHaeLfukoJoc6YJQxyvV94n6/9IzcOdRoFHPaJUTXXVglbDM7A6iON0
         UF/JQkV5NVgN9uavRPtlf7UXj7XIiaALHyl6dfFnZmqE7UT7TI52KNfa+BlxgyFb6bX8
         ixaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DQuN3G1QJvsPZrMdEIGvp5UTrwD1/Moi8emoV7bj3lU=;
        b=ZoAKWHN4xrrhF33LxhxhJa+4/x/xR0nFrQgmjd9cg763cSTR2xMeog1ThCi7RInAhf
         s8Yzk3EsvtRWo6DmHhynsyCWlAyX2ebC7ntsd7EH3XE7RRSmGHpymNWqghF1XnEf2ui+
         ME14FTBMAkf3wwCNxQyfQYQ7WMLfRun8qZaMxZMpvKIUtLmRTx+rpQIBOXxrrrn24x/Y
         rz27cDFB5nC0wvJTVBOMudppKEfEzwnaAjQzzOq1Wo037sxSUJ4UXR5I9X/uLfdNq3Q5
         KUIWJDZgbvwj9a/gV2DJDXXJfqXX7XBWzYrgKuOWRNxHRdBpDRTl7IU+GPxGbapOdMRv
         XKoA==
X-Gm-Message-State: AOAM530T95ROvDGRYt3xZ/PyHYuZMSm9ae3/FP4i6epIhd48TczPnKZC
        PZk3IqZV9g9sKIKRCZ0QqEue68grazVRNw==
X-Google-Smtp-Source: ABdhPJxeUhBlNyysFLBT7LARqEkmyOal5vA/3C8IvhTxsjlghwyoGttTKXfUBkKui85S/NaXf8eFCw==
X-Received: by 2002:a1c:7d49:: with SMTP id y70mr40839wmc.103.1603909267772;
        Wed, 28 Oct 2020 11:21:07 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id r28sm531178wrr.81.2020.10.28.11.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 11:21:07 -0700 (PDT)
From:   Aleksandr Nogikh <aleksandrnogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>
Subject: [PATCH v4 3/3] mac80211: add KCOV remote annotations to incoming frame processing
Date:   Wed, 28 Oct 2020 18:20:18 +0000
Message-Id: <20201028182018.1780842-4-aleksandrnogikh@gmail.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
In-Reply-To: <20201028182018.1780842-1-aleksandrnogikh@gmail.com>
References: <20201028182018.1780842-1-aleksandrnogikh@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>

Add KCOV remote annotations to ieee80211_iface_work and
ieee80211_rx. This will enable coverage-guided fuzzing of
mac80211 code that processes incoming 802.11 frames.

Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
---
v1 -> v2:
* The commit now affects ieee80211_rx instead of
  ieee80211_tasklet_handler.
---
 include/net/mac80211.h | 2 ++
 net/mac80211/iface.c   | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e8e295dae744..f4c37a1b381e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4499,7 +4499,9 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
  */
 static inline void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
+	kcov_remote_start_common(skb_get_kcov_handle(skb));
 	ieee80211_rx_napi(hw, NULL, skb, NULL);
+	kcov_remote_stop();
 }
 
 /**
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
-- 
2.29.0.rc2.309.g374f81d7ae-goog

