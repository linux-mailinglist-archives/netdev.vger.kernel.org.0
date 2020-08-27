Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D129225427C
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 11:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgH0Jd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 05:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728447AbgH0Jd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 05:33:56 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3A0C061232
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 02:33:54 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u18so4520557wmc.3
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 02:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=s5e7PAlfYft9eFvmMXp+FriUBHbpOi2nhrqdvKXRL50=;
        b=dYuJGVBmRmkmXcoI/V4nntaTYx0qVN96dznRjB5R99zgjt5H9u2l2suAYGkf2qk4ZR
         RsUF2Uz5WhB1nfeZXqMidyIy+q4T6fVEwGcLaNB7Edoeha/7YEeM556KKBTSV7eMXuF6
         Krva4Tp7eXmq2Cq1coYzDJCPsBvSCoExnMmb9DadVQY0ADbqBnoxz76CmueCHXwuB7t4
         Cdmlpq2WBEN0fGM0Fm6nsxVeLbqMvPqR4JDzUDNUhB+b0NtYmhMq53ROTjzCpejkw+k1
         aJnVc9hay1VHePkWxNQApXCtZt9Ofh0sgfBQdtvsahoiWizIFVfTK+5W285a/FFH27hv
         MTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=s5e7PAlfYft9eFvmMXp+FriUBHbpOi2nhrqdvKXRL50=;
        b=VIXJU/yAd1zz/CQrO9V60CLy9yzEk7NQqZPXsnn8J7PFbHmjNQ695f+cwIqKU7bZkY
         fDvV+wFDhKLlINAQV9tWG2Mo5e4iWhtWhyj9KM0eUR/Q1UKR9R1QA2pum+fxmQmeOkRL
         JSvg1SSKg+CewCSmQlEeQ6ZLQ2IAJUX7gH+1Chl2FylFTLhZXpEBb73G8ViTtOdju7vi
         wN++I7hg2nVPmpKMtdzicWEJb6eO43619VZbSWi+Ag8+d+kVsdrrkqB6wlH5M4k0tLxj
         oxp2TJ+CZpPg8r/KfCKnWGrufq8IMCebSRa673ULYtrMVGdetW0wAlJHKeJTGgobaRZF
         Dh+w==
X-Gm-Message-State: AOAM533nQ5NuM7lk2pEbdzF9AXhLTLBjAKjz3IGChDkMuGckZjVsDTvh
        HhPx632f2srvx4R8eQeLPM6EiQ==
X-Google-Smtp-Source: ABdhPJxh3MiG9wj6HGV/dnuv7EM7Uw1UBREO8gCQvp6ytS6Ki4av4AnJOt6sdwhcW3suy7Gn9E7xfA==
X-Received: by 2002:a1c:f00a:: with SMTP id a10mr10797514wmb.84.1598520833319;
        Thu, 27 Aug 2020 02:33:53 -0700 (PDT)
Received: from dell ([91.110.221.141])
        by smtp.gmail.com with ESMTPSA id z8sm3879309wmf.42.2020.08.27.02.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 02:33:52 -0700 (PDT)
Date:   Thu, 27 Aug 2020 10:33:51 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 08/30] net: wireless: ath: carl9170: Convert 'ar9170_qmap'
 to inline function
Message-ID: <20200827093351.GA1627017@dell>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
 <20200814113933.1903438-9-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200814113933.1903438-9-lee.jones@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'ar9170_qmap' is used in some source files which include carl9170.h,
but not all of them.  A 'defined but not used' warning is thrown when
compiling the ones which do not use it.

Fixes the following W=1 kernel build warning(s)

 from drivers/net/wireless/ath/carl9170/carl9170.h:57,
 In file included from drivers/net/wireless/ath/carl9170/carl9170.h:57,
 drivers/net/wireless/ath/carl9170/carl9170.h:71:17: warning: ‘ar9170_qmap’ defined but not used [-Wunused-const-variable=]

 NB: Snipped - lots of these repeat

Cc: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/carl9170/carl9170.h | 5 ++++-
 drivers/net/wireless/ath/carl9170/main.c     | 2 +-
 drivers/net/wireless/ath/carl9170/tx.c       | 6 +++---
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 237d0cda1bcb0..0d38100d6e4f5 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -68,7 +68,10 @@
 
 #define PAYLOAD_MAX	(CARL9170_MAX_CMD_LEN / 4 - 1)
 
-static const u8 ar9170_qmap[__AR9170_NUM_TXQ] = { 3, 2, 1, 0 };
+static inline u8 ar9170_qmap(u8 idx)
+{
+	return 3 - idx; /* { 3, 2, 1, 0 } */
+}
 
 #define CARL9170_MAX_RX_BUFFER_SIZE		8192
 
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 816929fb5b143..dbef9d8fc893b 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1374,7 +1374,7 @@ static int carl9170_op_conf_tx(struct ieee80211_hw *hw,
 	int ret;
 
 	mutex_lock(&ar->mutex);
-	memcpy(&ar->edcf[ar9170_qmap[queue]], param, sizeof(*param));
+	memcpy(&ar->edcf[ar9170_qmap(queue)], param, sizeof(*param));
 	ret = carl9170_set_qos(ar);
 	mutex_unlock(&ar->mutex);
 	return ret;
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 2407931440edb..2f9e275db8ef0 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -663,7 +663,7 @@ static void __carl9170_tx_process_status(struct ar9170 *ar,
 	unsigned int r, t, q;
 	bool success = true;
 
-	q = ar9170_qmap[info & CARL9170_TX_STATUS_QUEUE];
+	q = ar9170_qmap(info & CARL9170_TX_STATUS_QUEUE);
 
 	skb = carl9170_get_queued_skb(ar, cookie, &ar->tx_status[q]);
 	if (!skb) {
@@ -979,7 +979,7 @@ static int carl9170_tx_prepare(struct ar9170 *ar,
 		((CARL9170_TX_SUPER_MISC_VIF_ID >>
 		 CARL9170_TX_SUPER_MISC_VIF_ID_S) + 1));
 
-	hw_queue = ar9170_qmap[carl9170_get_queue(ar, skb)];
+	hw_queue = ar9170_qmap(carl9170_get_queue(ar, skb));
 
 	hdr = (void *)skb->data;
 	info = IEEE80211_SKB_CB(skb);
@@ -1279,7 +1279,7 @@ void carl9170_tx_drop(struct ar9170 *ar, struct sk_buff *skb)
 
 	super = (void *)skb->data;
 	SET_VAL(CARL9170_TX_SUPER_MISC_QUEUE, q,
-		ar9170_qmap[carl9170_get_queue(ar, skb)]);
+		ar9170_qmap(carl9170_get_queue(ar, skb)));
 	__carl9170_tx_process_status(ar, super->s.cookie, q);
 }
 
-- 
2.25.1
