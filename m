Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4974504DA7
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 10:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbiDRIVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 04:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiDRIV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 04:21:29 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598C2167D8;
        Mon, 18 Apr 2022 01:18:51 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id k14so17650103pga.0;
        Mon, 18 Apr 2022 01:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RKXep+OukE4SdMu+cRqxBY4lHOeFUaKFcve1sEKphTA=;
        b=GWCh7Axovc+n32OceNnsigXAf/o8hGt3MJRtpKvMZoGI9wr3zWxS6HY+G7ePpWxnuE
         K7rkGYJVcee7UIgwJ/up6hqHYVB3675nYqpKT31MZkmQZe1jr7HiQKoVslAEVN6Pazle
         NQPuPQGvEZktumhJJUFBce0Mwykn2Zs2Ee9JMk192atchDJBmtEAuGaaUFamJxSBCdHS
         PJ8adGyrcT4JvgqndH5IKFwkAqlVzusobcohzdv+8HwWSbPhCzBte4LPptJ8BDt5Bqir
         iHLhDGvS2+Csu5sdDcw8aPeyN8L5b+fGT529kNwQlMHsqJU0ORIJKQBTCUfVC0lofzkP
         rNDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RKXep+OukE4SdMu+cRqxBY4lHOeFUaKFcve1sEKphTA=;
        b=K2Q/pS5h6baqLZq/IZX1whxCoadt1I0/hiCViVOXtfTcsFiquemCaFkvI9YDOBSDMk
         BUmWUPorsC0e8427RhKqGeuX6tzIu4fYcIdo2gpoAOJY8iKfWY61DlFuxWIG1Pn+THgC
         cMs6P2X3grG+ITyHaWQBHA+ttz4/NYNx9hTsdMACZ6ezr2O9K10K3HL8DCSGU06iZUFM
         WQJfF75zThrClNLesakcOKQvvxiZ2NQcs+WE9aPOlLZTb28iM2QfHOCUmv9jUfkS97xY
         deyVABsOC6CV8oz3hymy6sg9us+I2su4xM95NPjItcYE83BL3esQLxqpLymkx7sB0bRc
         GcXQ==
X-Gm-Message-State: AOAM5316aBIrDx0xiIm4teRcNG0l6bFJ0FtgTP5heYccu0wJrQbgLmux
        GkkYqmuSMpQIA3K6fF/HFeY=
X-Google-Smtp-Source: ABdhPJy5ecPy3tYjBbv8BqYjQDZ9JlHc+eZlWxXe+vT/jIZeYVzhGPIQlHzbHEFym/a3gTfYiMmGog==
X-Received: by 2002:a63:450d:0:b0:3a8:f2ed:1aa5 with SMTP id s13-20020a63450d000000b003a8f2ed1aa5mr6024926pga.367.1650269930978;
        Mon, 18 Apr 2022 01:18:50 -0700 (PDT)
Received: from localhost ([58.251.76.82])
        by smtp.gmail.com with ESMTPSA id t20-20020a63eb14000000b0039e28245722sm12048717pgh.54.2022.04.18.01.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 01:18:50 -0700 (PDT)
From:   Yunbo Yu <yuyunbo519@gmail.com>
To:     nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, yuyunbo519@gmail.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] =?UTF-8?q?mt76=EF=BC=9Amt7603=EF=BC=9A=20move=20spin=5Flo?= =?UTF-8?q?ck=5Fbh()=20to=20spin=5Flock()?=
Date:   Mon, 18 Apr 2022 16:18:44 +0800
Message-Id: <20220418081844.1236577-1-yuyunbo519@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is unnecessary to call spin_lock_bh(), for you are already in a tasklet.

Signed-off-by: Yunbo Yu <yuyunbo519@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
index 5d4522f440b7..b5e8308e0cc7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
@@ -82,12 +82,12 @@ void mt7603_pre_tbtt_tasklet(struct tasklet_struct *t)
 	__skb_queue_head_init(&data.q);
 
 	q = dev->mphy.q_tx[MT_TXQ_BEACON];
-	spin_lock_bh(&q->lock);
+	spin_lock(&q->lock);
 	ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
 		IEEE80211_IFACE_ITER_RESUME_ALL,
 		mt7603_update_beacon_iter, dev);
 	mt76_queue_kick(dev, q);
-	spin_unlock_bh(&q->lock);
+	spin_unlock(&q->lock);
 
 	/* Flush all previous CAB queue packets */
 	mt76_wr(dev, MT_WF_ARB_CAB_FLUSH, GENMASK(30, 16) | BIT(0));
@@ -117,7 +117,7 @@ void mt7603_pre_tbtt_tasklet(struct tasklet_struct *t)
 		mt76_skb_set_moredata(data.tail[i], false);
 	}
 
-	spin_lock_bh(&q->lock);
+	spin_lock(&q->lock);
 	while ((skb = __skb_dequeue(&data.q)) != NULL) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 		struct ieee80211_vif *vif = info->control.vif;
@@ -126,7 +126,7 @@ void mt7603_pre_tbtt_tasklet(struct tasklet_struct *t)
 		mt76_tx_queue_skb(dev, q, skb, &mvif->sta.wcid, NULL);
 	}
 	mt76_queue_kick(dev, q);
-	spin_unlock_bh(&q->lock);
+	spin_unlock(&q->lock);
 
 	for (i = 0; i < ARRAY_SIZE(data.count); i++)
 		mt76_wr(dev, MT_WF_ARB_CAB_COUNT_B0_REG(i),
-- 
2.25.1

