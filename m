Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B21282A11
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 12:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgJDKCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 06:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJDKCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 06:02:46 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4B5C0613CE;
        Sun,  4 Oct 2020 03:02:46 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s12so6343512wrw.11;
        Sun, 04 Oct 2020 03:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/8rwI5kq36ra1JROFynqhEO5qXOq3K5Mukw9A9ozDaU=;
        b=T74VMZRo+gOA0DqbMFWPz/hxrJTtv4jciiHZZLZ7ePD1k50ti+jrdYUs3cHCJeRSzu
         hyAu0hJvDQaqaydH+3M6AsqQHoXuJzf+9cd3nYVGwxo4LkJTQvvAEtxE2WIK6TszA9z1
         IvsMsv8+wyZ+HjwyS2ItoU1Fj+CXsBjARJ6dmcgrs3LMONwPJnwHpasnteyvjECz3xTq
         PrAqQMyOv9FkazZhmhngZrGx4sCvBTq1kf42RleIsNFQcVHG6zxHFhLpxEu92o7Gw+B3
         NQwbxskFev3/7J8wOEpguJvXw4H5fL7IA5mp4RMNdUDKxbSwOI9fQBlKQ3IAa82FyBys
         APyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/8rwI5kq36ra1JROFynqhEO5qXOq3K5Mukw9A9ozDaU=;
        b=Z/SRyUjfdrzs+axCIQ3tjHBy4qlcju5tlKphQzJ4vouv4ZL20sqEvP0CA2vNHHIKrc
         ENJnIQsOfLuk6IYVBKr/uly/ASA0MP2ZomWboC6PSliofVi4kg7OryjC2/UJj3vn3wB9
         RRdn6LdBYOLsrgYfPuCD51uSj9r6zU/2Dc/n1xwO+RSmwUY/Z0MmquoSGctk5R5CPb3u
         Sr08/L8DkIDOrMgc24g1xukGEQPujwVAqKUlCo+fuQCHR4IA0IXCCpMGMoH23a5gMSH6
         3mfap8EpVs8T2dugiKfFn6Mc84A93makx+pwDNRAVHwPE0zb+rkorrhodM+dapmUm4FM
         esIw==
X-Gm-Message-State: AOAM531zq80K7WiFM4rXE5DMYsKNrTUgD9jnOIRiSh81SW5yU4tP80uM
        6wzEjXMhWVWKO535xfzkFcA=
X-Google-Smtp-Source: ABdhPJxC4RsKMVZk0jlDlKFWaZ5szexulTFJhzThUJQKjEw6S+8j3YbUICzSiX02mZspStTq2872YA==
X-Received: by 2002:adf:ce8e:: with SMTP id r14mr11903160wrn.257.1601805765224;
        Sun, 04 Oct 2020 03:02:45 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id a10sm8301340wmb.23.2020.10.04.03.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 03:02:44 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ath11k: Handle errors if peer creation fails
Date:   Sun,  4 Oct 2020 11:02:17 +0100
Message-Id: <20201004100218.311653-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ath11k_peer_create() is called without its return value being checked,
meaning errors will be unhandled. Add missing check and, as the mutex is
unconditionally unlocked on leaving this function, simplify the exit
path.

Addresses-Coverity-ID: 1497531 ("Code maintainability issues")
Fixes: 701e48a43e15 ("ath11k: add packet log support for QCA6390")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 7f8dd47d2333..58db1b57b941 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -5211,7 +5211,7 @@ ath11k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 	struct ath11k *ar = hw->priv;
 	struct ath11k_base *ab = ar->ab;
 	struct ath11k_vif *arvif = (void *)vif->drv_priv;
-	int ret;
+	int ret = 0;
 	struct peer_create_params param;
 
 	mutex_lock(&ar->conf_mutex);
@@ -5225,13 +5225,12 @@ ath11k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 	    arvif->vdev_type != WMI_VDEV_TYPE_AP &&
 	    arvif->vdev_type != WMI_VDEV_TYPE_MONITOR) {
 		memcpy(&arvif->chanctx, ctx, sizeof(*ctx));
-		mutex_unlock(&ar->conf_mutex);
-		return 0;
+		goto unlock;
 	}
 
 	if (WARN_ON(arvif->is_started)) {
-		mutex_unlock(&ar->conf_mutex);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto unlock;
 	}
 
 	if (ab->hw_params.vdev_start_delay) {
@@ -5239,6 +5238,8 @@ ath11k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 		param.peer_type = WMI_PEER_TYPE_DEFAULT;
 		param.peer_addr = ar->mac_addr;
 		ret = ath11k_peer_create(ar, arvif, NULL, &param);
+		if (ret)
+			goto unlock;
 	}
 
 	ret = ath11k_mac_vdev_start(arvif, &ctx->def);
@@ -5246,23 +5247,19 @@ ath11k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 		ath11k_warn(ab, "failed to start vdev %i addr %pM on freq %d: %d\n",
 			    arvif->vdev_id, vif->addr,
 			    ctx->def.chan->center_freq, ret);
-		goto err;
+		goto unlock;
 	}
 	if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR) {
 		ret = ath11k_monitor_vdev_up(ar, arvif->vdev_id);
 		if (ret)
-			goto err;
+			goto unlock;
 	}
 
 	arvif->is_started = true;
 
 	/* TODO: Setup ps and cts/rts protection */
 
-	mutex_unlock(&ar->conf_mutex);
-
-	return 0;
-
-err:
+unlock:
 	mutex_unlock(&ar->conf_mutex);
 
 	return ret;
-- 
2.28.0

