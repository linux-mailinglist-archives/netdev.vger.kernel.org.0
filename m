Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74034F8BAB
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbiDHAD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 20:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbiDHADX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 20:03:23 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98821F95E9;
        Thu,  7 Apr 2022 17:01:21 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0V9SkcgY_1649376078;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V9SkcgY_1649376078)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 08 Apr 2022 08:01:18 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        loic.poulain@linaro.org, toke@toke.dk, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next 2/2] ath9k: Remove unnecessary print function dev_err()
Date:   Fri,  8 Apr 2022 08:01:13 +0800
Message-Id: <20220408000113.129906-2-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
In-Reply-To: <20220408000113.129906-1-yang.lee@linux.alibaba.com>
References: <20220408000113.129906-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The print function dev_err() is redundant because
platform_get_irq_byname() already prints an error.

Eliminate the follow coccicheck warning:
./drivers/net/wireless/ath/ath9k/ahb.c:103:2-9: line 103 is redundant
because platform_get_irq() already prints an error

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index c9b853af41d1..9cd12b20b18d 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -99,10 +99,8 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		dev_err(&pdev->dev, "no IRQ resource found\n");
+	if (irq < 0)
 		return irq;
-	}
 
 	ath9k_fill_chanctx_ops();
 	hw = ieee80211_alloc_hw(sizeof(struct ath_softc), &ath9k_ops);
-- 
2.20.1.7.g153144c

