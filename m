Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E07150B03E
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 08:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442272AbiDVGKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 02:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441871AbiDVGKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 02:10:20 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C374550462;
        Thu, 21 Apr 2022 23:07:28 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h5so6548626pgc.7;
        Thu, 21 Apr 2022 23:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RKXep+OukE4SdMu+cRqxBY4lHOeFUaKFcve1sEKphTA=;
        b=jCZAmk1J3ai9mz8LMYhy0icEUgmMobhYJOM9rZP/QZ8VIOGWFCIsnEbVX8GH9uBLFj
         QfSjjArjgiyCEWsmRlujguU1HdcUoypu10BuTqAZbOu+VK33Axfbb7j1sdjscz8iNc+Q
         S3Gjv7IqKqodjaP2KwYY68LlyhF/vqCWaHlm9KrtLHrt/w6wtNpCZNxHONMnyWabt3qV
         1oeh6yykcCbjMwNvN9zEunXZLeAknr+i/xGjbs/LiOPCy+Xmgs+rK+7g4AsmCW1JFqlj
         lDjqBjbzfPS/E7btQ+EtdlGMvkfg9ir27+egMbPEnlddMJbR9pBUdlQpkZ+/YVgFQguY
         EKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RKXep+OukE4SdMu+cRqxBY4lHOeFUaKFcve1sEKphTA=;
        b=YlhcbrCn+VUP55dR5kCHPC5H8mN/ipxQ6CT9ohI1n4b9MUmv+uX+1Cbipg6afRJNuF
         sAtLiixmVxsNaXQSfDfDbLXDADtiHjn6Rhntc27cnRmEViBer0pRzcqNAg4l0D5Pb+s3
         NjbXMe73ce8IDvm+P5VgCKBQiNny8yM5BCcFtsObFI3MAGJtyhzoQNpmcdjjWyzfDq8O
         HzhtbHmPfgb/Y71ytU6vzInffBwEtGxSGXu+hPDA2UAX/Y0QWDTbSMxpNqY6PSZ8qium
         GmWnU+cbNnXvsR509W88VtWLCessmHm12xDgzVlFxdqSGa/KLLQfhwskYfo7FqBDk3ah
         zV8Q==
X-Gm-Message-State: AOAM533+mjNZuAqnNZpBRtDTdrJ9RTHVW+jkAc9PmXYKNSKuckSuWffR
        ChzqMkq3q06OrwByc7oKmb0=
X-Google-Smtp-Source: ABdhPJySViXl8wduQ1NeG0I3VsxtliLWMqqABy+BwpIMEwoXPK2LckYjJVk7VmCSpzVnZev2TQfOlw==
X-Received: by 2002:a05:6a00:1354:b0:50c:e672:edfc with SMTP id k20-20020a056a00135400b0050ce672edfcmr2963574pfu.50.1650607648237;
        Thu, 21 Apr 2022 23:07:28 -0700 (PDT)
Received: from localhost ([58.251.76.82])
        by smtp.gmail.com with ESMTPSA id 124-20020a621982000000b0050a73577a37sm1120679pfz.45.2022.04.21.23.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 23:07:27 -0700 (PDT)
From:   Yunbo Yu <yuyunbo519@gmail.com>
To:     nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, yuyunbo519@gmail.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] =?UTF-8?q?mt76=EF=BC=9Amt7603=EF=BC=9A=20move=20spin=5Flo?= =?UTF-8?q?ck=5Fbh()=20to=20spin=5Flock()?=
Date:   Fri, 22 Apr 2022 14:07:23 +0800
Message-Id: <20220422060723.424862-1-yuyunbo519@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

