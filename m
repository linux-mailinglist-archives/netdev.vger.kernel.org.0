Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A412990A4
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 16:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2444073AbgJZPJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 11:09:49 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33052 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2444031AbgJZPJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 11:09:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id b8so13056476wrn.0;
        Mon, 26 Oct 2020 08:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QjFg0mZ8avC6idJO43FWcJE7MDWVLercfhu1t4ztzhU=;
        b=iWk0r6VgHJ/idi7eaEAYLS+0sY3MiDKm325KVAaG43StA7S4Ftm049iusCYU32fYqS
         ZdfJT+zXzfHb6B8l4LlEyKstwDdRcQbsJq03D2XmwaVt8PI3+lNJujLq7EwimFmtp8uW
         4KM0/L9acgUuSKonOvl1LHGZApmYDNiE7fIUtAtieRqeM8InrzMJ97HXa9vKsoEiogmn
         caPUknB9w/yEq8QCJp9geZk3fg3um/xx4ickm3nvNJ1RleRfHjKaRwhPbLoogjXKmo+e
         b+dUgnJk4l2QlIC6WhnN2beZadd5LT1FHXU1LZlep5AoxwAqoAjlElv7QE378+Nll5zE
         mI1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QjFg0mZ8avC6idJO43FWcJE7MDWVLercfhu1t4ztzhU=;
        b=SESs2xhZXCaNxe1QKIAwUAUH3SUhP60lW2J5UEjUfl+p4fKERFRrdJ1Ggn4tSxGCWj
         MVrsRinVYQtr259VTRFYtYN5TKWYkfSrsCNHhZTqDfG1fiYaSHucWNS02ii1yc2bOBjg
         1ioSOK2OgGwwGx7lZ5Jjoh3Wdtx3k1pEKW4s8LL0jhOK4UmL8HddWUSmHVp6kJ+Jv6n/
         o7yXw0PdZCChSFjLzCoOX5scdK6ItD7PzwsuuMhhW6FgvBfH8FnmdD0fG6Ihj+cg4BEM
         rCCNNy80auvHk4ByS2sEquSwGnh45oMVSlHwN38RVhP1Q1feBlXxSmj0UmfYyadk28aR
         TbxA==
X-Gm-Message-State: AOAM532psujFooljYf1vHbtCiZAi0iTss9hFFrxD60NMBhqIa2qQ+tfc
        4TfVO6E83YimMOVBK+UIv24=
X-Google-Smtp-Source: ABdhPJw53dWIv9EQncXT5M/kVl6SJeogeatP8PgPx1AAH9Pr252TUzKJFjlNPda4mkM8Rw6ki5+Nvw==
X-Received: by 2002:adf:bc13:: with SMTP id s19mr19057557wrg.338.1603724983034;
        Mon, 26 Oct 2020 08:09:43 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 24sm20043967wmf.44.2020.10.26.08.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 08:09:42 -0700 (PDT)
From:   Aleksandr Nogikh <aleksandrnogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>
Subject: [PATCH v3 3/3] mac80211: add KCOV remote annotations to incoming frame processing
Date:   Mon, 26 Oct 2020 15:08:51 +0000
Message-Id: <20201026150851.528148-4-aleksandrnogikh@gmail.com>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
In-Reply-To: <20201026150851.528148-1-aleksandrnogikh@gmail.com>
References: <20201026150851.528148-1-aleksandrnogikh@gmail.com>
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
2.29.0.rc1.297.gfa9743e501-goog

