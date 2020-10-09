Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C683D288F7E
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390103AbgJIRCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390096AbgJIRCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:02:20 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809EAC0613D6;
        Fri,  9 Oct 2020 10:02:19 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id p15so10491933wmi.4;
        Fri, 09 Oct 2020 10:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uY8AHriRhxYN61KH+Nw1rNj+BG4lqoDeyxKcZuRICOs=;
        b=BYuP0tGFxuFiTfww2CuCbb7rhHuPx2sDskJk7MkFvflRFAHyJh5h1J0PRYULO3WSMb
         buZu/AwfQNWwwba64irHYtdg4ZmBLJmMxeBoy+ON1H9fk0QPXmBvjnCGDCJgk73goW1J
         1Ux1JEGHTyRaPeNpKdHX1NDhwrBJ+JgwdW40IVTy1FZwbDVwdgjsZxlq67DB0r47oUKv
         TudcZNxcDy6zW7LYeen6PcBg0qQQj5GVmZvtc9uuk4jLSrYJtHgGfgpIeOVtBD9VPsUD
         FCZq4adU1jdAbI8xwAclSfSNvvlPhUmzWtsdqel2ILqWca2qK4qEElUVYxPZN4sFAPXS
         PDrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uY8AHriRhxYN61KH+Nw1rNj+BG4lqoDeyxKcZuRICOs=;
        b=QaqfTj8Nn4mA516ZlA3SnYuy17aZib7OmKBRQxsqFDpjxS9Y2ChFcQc5ou89nZFAj5
         XRT8lTv8c2x+4B3adHehKJAsjHlsZ1/8aO1zgy3560klPgYx8rNnQKIa4muHnTZ2fGxY
         0xoKAEViDKgsCwErefwqP06unAbxyEiT+xQmdhVl6m0nfZCG4+QcW8pK9b/PR4cvC3lf
         2glZgdGkPY+CT1bAVy9ePOaLCsPSPv3qQENxtyXkRWzmaPRkPPc7LfZwsWN5LbVZVcda
         lW+0UT+xcVg8TJpNjrr2nklLUKLR9gaE67/j4QcU0+ekf2HeMxWpuDfkUhiI31+M8wun
         0yig==
X-Gm-Message-State: AOAM530f7jTs4oqyn+IgPiqYumPwuexWROIpAedaK9e4uHsN3mglebhB
        mmDS17SQml7HouXeThuSs1IoW+rVS+gLcw==
X-Google-Smtp-Source: ABdhPJwu9zsObeTPfUgps2qb+XQeR/efNG+zDE71lWRn94krJdU0+G9KSGSmNPbnEnCv1Ig3fxqxIg==
X-Received: by 2002:a1c:770e:: with SMTP id t14mr12065057wmi.34.1602262938269;
        Fri, 09 Oct 2020 10:02:18 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id s6sm13211092wrg.92.2020.10.09.10.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:02:17 -0700 (PDT)
From:   Aleksandr Nogikh <a.nogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net,
        akpm@linux-foundation.org
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        nogikh@google.com
Subject: [PATCH v2 3/3] mac80211: add KCOV remote annotations to incoming frame processing
Date:   Fri,  9 Oct 2020 17:02:02 +0000
Message-Id: <20201009170202.103512-4-a.nogikh@gmail.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
In-Reply-To: <20201009170202.103512-1-a.nogikh@gmail.com>
References: <20201009170202.103512-1-a.nogikh@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>

Add KCOV remote annotations to ieee80211_iface_work and
ieee80211_rx. This will enable coverage-guided fuzzing of mac80211
code that processes incoming 802.11 frames.

Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
---
v2:
* The commit now affects ieee80211_rx instead of
  ieee80211_tasklet_handler.
---
 include/net/mac80211.h | 2 ++
 net/mac80211/iface.c   | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4747d446179a..011d9e115ebb 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4496,7 +4496,9 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
  */
 static inline void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
+	kcov_remote_start_common(skb_get_kcov_handle(skb));
 	ieee80211_rx_napi(hw, NULL, skb, NULL);
+	kcov_remote_stop();
 }
 
 /**
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 240862a74a0f..482d2ae46e71 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1377,6 +1377,7 @@ static void ieee80211_iface_work(struct work_struct *work)
 	while ((skb = skb_dequeue(&sdata->skb_queue))) {
 		struct ieee80211_mgmt *mgmt = (void *)skb->data;
 
+		kcov_remote_start_common(skb_get_kcov_handle(skb));
 		if (ieee80211_is_action(mgmt->frame_control) &&
 		    mgmt->u.action.category == WLAN_CATEGORY_BACK) {
 			int len = skb->len;
@@ -1486,6 +1487,7 @@ static void ieee80211_iface_work(struct work_struct *work)
 		}
 
 		kfree_skb(skb);
+		kcov_remote_stop();
 	}
 
 	/* then other type-dependent work */
-- 
2.28.0.1011.ga647a8990f-goog

