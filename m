Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997BC3FFA59
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 08:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345805AbhICGZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 02:25:37 -0400
Received: from m12-16.163.com ([220.181.12.16]:33641 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230128AbhICGZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 02:25:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=gwsSz
        w+Owsx9E4ND5+dICrWSiwl4/4CbypIPkR7vonI=; b=Ndzlx7LlgcBchTm16OBPA
        D9z5qAA3g/mFnDrTiU5yV35+osDXdAbtU0u2Hgm3KvgrLzGBTtfdTOay9uSphwet
        HHsiTgWCvuo1FuNJF0F0aVr4zhwwpeEfj9LEgOcCuFrv5gMyoirzL+6Mw+pJy3sG
        GPDrwnGH1JHMbWcZ0shV4M=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp12 (Coremail) with SMTP id EMCowABn+2yHvzFh91wlAg--.14S2;
        Fri, 03 Sep 2021 14:24:19 +0800 (CST)
From:   dingsenjie@163.com
To:     jirislaby@kernel.org, mickflemm@gmail.com, mcgrof@kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH] wireless: ath5k: Remove unnecessary label of ath5k_beacon_update
Date:   Fri,  3 Sep 2021 14:23:16 +0800
Message-Id: <20210903062316.11756-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EMCowABn+2yHvzFh91wlAg--.14S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFyfWr1rJryxJr4fCF1rZwb_yoWDuwc_ur
        WI93Z7JF15GryYgrsrC3y3Z34IkFW8uF95G3WjqFW7KF13CrWkAr95Zr9rGw17uw4xAFnx
        uFsrAFy3tw1jvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0D73DUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbiYxQDyFaEEMIYRAAAsg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

The label just used as return, so we delete it and
use the return statement instead of the goto statement.

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 drivers/net/wireless/ath/ath5k/base.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 4c6e57f..9739189 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1896,23 +1896,18 @@ static int ath5k_remove_padding(struct sk_buff *skb)
 	struct ath5k_vif *avf;
 	struct sk_buff *skb;
 
-	if (WARN_ON(!vif)) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (WARN_ON(!vif))
+		return -EINVAL;
 
 	skb = ieee80211_beacon_get(hw, vif);
 
-	if (!skb) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!skb)
+		return -ENOMEM;
 
 	avf = (void *)vif->drv_priv;
 	ath5k_txbuf_free_skb(ah, avf->bbuf);
 	avf->bbuf->skb = skb;
 	ret = ath5k_beacon_setup(ah, avf->bbuf);
-out:
 	return ret;
 }
 
-- 
1.9.1


