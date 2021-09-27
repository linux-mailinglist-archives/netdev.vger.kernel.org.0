Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888EB419751
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbhI0PJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:09:44 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:52958
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234994AbhI0PJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 11:09:42 -0400
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C3970402DE
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 15:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1632755283;
        bh=1q/DcpUc3XiR6bWmSAxCheMZIC3a2GduwPENrVEfX+Q=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=eXE/txZpIV2+fxANN9Ox66B3tFfzEY3V0PsootPnsxm1flfq6ePaVAqgPhEWsVJ9t
         OOqRFF3h1rx+ohaUDw4NjJyrehqoy1FPAQxiyp6LF3Nu5cXRROUPXzKe3kJx5BuBYn
         Q+78ynW1/R7V5+Tf2qLrDQhfsO2kQigoBX/chXsGRHaeCTQp75EcJ7vnr0uLe2tXTa
         +DiqlOVR5HMAU8BGtTG6p6C6wYu/Usw+jnwDaXnWxW3pLb9gwlvCpdiL17l/AvDS3Z
         mtyHKEIfCVehM+JxgjSksge+61RvpoCaQQIN8TzBpRonGTIPW65xHCNKXPT8EfXrGz
         iM7Iu0k/v/yuQ==
Received: by mail-pf1-f200.google.com with SMTP id f83-20020a623856000000b0043d21dae12eso11802584pfa.2
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 08:08:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1q/DcpUc3XiR6bWmSAxCheMZIC3a2GduwPENrVEfX+Q=;
        b=jHP/0HFxOpvSGFzoYjSn+cHzmXQ703ivECMeGOzy9OQYK6CMA2JZZ2YvRpGakmeJim
         q19KbbUaIMuoaLmmjpdLnP/+bKYQzKN7JsfT5r/XZkpK8My77pWvjkXx898vbtIs7+oL
         C0wGVr6+rQBmHDQDO7vg6tyEU/e0IggMqpm12J6JKl2no3YEzEQiP2eXJzV3WqkBQtjK
         u1CkU3PL8dutQ2QYkXyP33P80FH+o0DslWG1+mMJZjgutVU2wIe0KoZ8U7U22IzPaWgV
         te7KeZtBe7IA7NyBm46aO/VIAirbXXj+eIi4X+EcSoaMv+svQKhnDVZWA89LLnQztrYX
         Kyvg==
X-Gm-Message-State: AOAM532FKzeNDKADlmTdg6IzZRk7l1OOswAfkVVHjOi48RWXNP1sO1zU
        cBanKq5lKyE7xsjfNNrMCKYft5NnQChwTeHMmCFMJvgbMvxxKnyhpRhN7XQofqseYk9TdBAmJv7
        6lahem3ml2JWc4df0oUMQA1ZQvoUyZrC7og==
X-Received: by 2002:a17:90a:311:: with SMTP id 17mr20487552pje.121.1632755281933;
        Mon, 27 Sep 2021 08:08:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFzOCZGKP1K5PJtBQasVhwsqVTuP6aOioiRpVP9zX9xcJNqrJjCrwwR7QVLL8geh28dmBKLQ==
X-Received: by 2002:a17:90a:311:: with SMTP id 17mr20487527pje.121.1632755281710;
        Mon, 27 Sep 2021 08:08:01 -0700 (PDT)
Received: from localhost.localdomain ([69.163.84.166])
        by smtp.gmail.com with ESMTPSA id i27sm17510152pfq.184.2021.09.27.08.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 08:08:01 -0700 (PDT)
From:   Tim Gardner <tim.gardner@canonical.com>
To:     ath11k@lists.infradead.org
Cc:     tim.gardner@canonical.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath11k: Remove unused variable in ath11k_dp_rx_mon_merg_msdus()
Date:   Mon, 27 Sep 2021 09:07:43 -0600
Message-Id: <20210927150743.19816-1-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coverity complains that a constant variable guards dead code. In fact,
mpdu_buf is set NULL and never updated.

4834err_merge_fail:
    	null: At condition mpdu_buf, the value of mpdu_buf must be NULL.
    	dead_error_condition: The condition mpdu_buf cannot be true.
CID 92162 (#1 of 1): 'Constant' variable guards dead code (DEADCODE)
dead_error_line: Execution cannot reach the expression decap_format !=
  DP_RX_DECAP_TYPE_RAW inside this statement: if (mpdu_buf && decap_forma....
Local variable mpdu_buf is assigned only once, to a constant value, making it
  effectively constant throughout its scope. If this is not the intent, examine
  the logic to see if there is a missing assignment that would make mpdu_buf not
  remain constant.
4835        if (mpdu_buf && decap_format != DP_RX_DECAP_TYPE_RAW) {

Fix this by removing mpdu_buf and unreachable code.

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 9a224817630a..7d57952fd73c 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -4740,7 +4740,7 @@ ath11k_dp_rx_mon_merg_msdus(struct ath11k *ar,
 			    struct ieee80211_rx_status *rxs)
 {
 	struct ath11k_base *ab = ar->ab;
-	struct sk_buff *msdu, *mpdu_buf, *prev_buf;
+	struct sk_buff *msdu, *prev_buf;
 	u32 wifi_hdr_len;
 	struct hal_rx_desc *rx_desc;
 	char *hdr_desc;
@@ -4748,8 +4748,6 @@ ath11k_dp_rx_mon_merg_msdus(struct ath11k *ar,
 	struct ieee80211_hdr_3addr *wh;
 	struct rx_attention *rx_attention;
 
-	mpdu_buf = NULL;
-
 	if (!head_msdu)
 		goto err_merge_fail;
 
@@ -4832,12 +4830,6 @@ ath11k_dp_rx_mon_merg_msdus(struct ath11k *ar,
 	return head_msdu;
 
 err_merge_fail:
-	if (mpdu_buf && decap_format != DP_RX_DECAP_TYPE_RAW) {
-		ath11k_dbg(ab, ATH11K_DBG_DATA,
-			   "err_merge_fail mpdu_buf %pK", mpdu_buf);
-		/* Free the head buffer */
-		dev_kfree_skb_any(mpdu_buf);
-	}
 	return NULL;
 }
 
-- 
2.33.0

