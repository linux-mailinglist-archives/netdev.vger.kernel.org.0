Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111BD60B46C
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 19:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbiJXRn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 13:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbiJXRnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 13:43:06 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A2DA50DF;
        Mon, 24 Oct 2022 09:17:59 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id o4so8812687wrq.6;
        Mon, 24 Oct 2022 09:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7aiClwPR9sAvkuS66cGq13emR+XEGSOWezje9CRd5Ko=;
        b=AXE1YHREz/ElPMozg6VRmr+8PZ5DdwECsVZN7yJ4+M7mMjSuztlivbhKAGSPlpO8xS
         mVyPlRhBrJ4UV7tEiyzPBNqT8sOhCp2I/SCgVpB2ffO6n7BhMASip8PXg85j18sD9ybG
         VzqiFw2yKpDaaQ6tRZ6yhHM/qi4r1iRhKLjZUZhwOuXOjn+7buIwW8gmw/ppPFAQvXw5
         SwhpwSCZauJoF3nJMna0pVro0QhhpmPydJ7MXabd7CbJDBUsvsVEerLJ2yzz7DOCig5c
         m+K9nvR+SI3JHF3UE9QIseWkYn7rx74gahSTUQkqTV90/O5VJZ6M77gIkJz2V5Nr8Mf2
         27RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7aiClwPR9sAvkuS66cGq13emR+XEGSOWezje9CRd5Ko=;
        b=OsatyBm0RJPxmdBfYKd2xJSrkiq02WOBO/t38SR0feOyDcaX+BXLnArTtHgaMEdbhW
         23HreML8fEAKJ5Octm/ZsSW1NEmh4drGF8AZRa5CDs+kXVXUjoNMNgq74SfG31gmRIs3
         yIbFgXCg2BP7GkqOPx3Cw8orYPUohXHWri9jQVKScLLaE+qA4hfGi0W8OtuNDo+r+SLK
         xqh81EeZLeTUq66EnMijhnhvdtDyNkTP36CFk480cp6Dn1zOnXuZN9iOcRFmvP16h6et
         VAyDCxzQtKxAxYGzID3e3oWFgTh0ko9LUtwrDXxndCvPv/eX/YuO3UBG23W2BzUnLHHQ
         Lhwg==
X-Gm-Message-State: ACrzQf3ZgWsxKlnX3FMjQpY0Yo0Lcyn0cSiLCMRIpu55GP3sGrJ8VWzI
        0o1vNTTTHyA0O8S+hd0RkJBIdHsV9L9nK4Ga
X-Google-Smtp-Source: AMsMyM79gyjjA1L/l7GuLr9GMJwmIUmhcGN19aJsAyi2OUBUUVgXjjYM2Ikso+u3DDCb8NxBRju7WQ==
X-Received: by 2002:adf:e3c1:0:b0:236:6d5d:ffa2 with SMTP id k1-20020adfe3c1000000b002366d5dffa2mr5420960wrm.557.1666625995849;
        Mon, 24 Oct 2022 08:39:55 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id h17-20020a5d4311000000b002366ded5864sm4241575wrq.116.2022.10.24.08.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 08:39:55 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: remove variable sent
Date:   Mon, 24 Oct 2022 16:39:54 +0100
Message-Id: <20221024153954.2168503-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable sent is just being incremented and it's never used
anywhere else. The variable and the increment are redundant so
remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index ba271a10d4ab..39abb59d8771 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1678,7 +1678,6 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 	struct ieee80211_tx_info *info;
 	struct list_head bf_q;
 	struct ath_buf *bf_tail = NULL, *bf = NULL;
-	int sent = 0;
 	int i, ret;
 
 	INIT_LIST_HEAD(&bf_q);
@@ -1707,7 +1706,6 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 
 			bf_tail = bf;
 			nframes--;
-			sent++;
 			TX_STAT_INC(sc, txq->axq_qnum, a_queued_hw);
 
 			if (an->sta && skb_queue_empty(&tid->retry_q))
-- 
2.37.3

