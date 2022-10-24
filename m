Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5CD760B9EF
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbiJXUXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbiJXUWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 16:22:43 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2FCEBD;
        Mon, 24 Oct 2022 11:38:23 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j15so7007872wrq.3;
        Mon, 24 Oct 2022 11:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dJnt2GP1pm08BDpQHAhmkmMOzHCfFoZgxhdL+wvVQI0=;
        b=gtZvIN8K3k7r1uHwhEc7+/ToiepvXrRLoYCsg65dKsJr7+zp+7Rd4BFPZHYq6xmI/s
         U+BDXTd/r9PFSVMu/yjZ4Sf07IW0+jlWi5BvINZdqDm7Y7z4eQR2TmQ6RwSPTAdoTQQ9
         jlARxJ/PCtHlhQUtJC0b66o3+iM/th1/2R2yyBOOVgiXpWltxMzpg0iH2T11K9+PdsH/
         E6CT8BeZgFfsW1cADQNx54JCen+tOKsRze5ykzfigG/1Lghwvzyt39qVHE4SUCPGAbUx
         p2pN82oHtzogmLIxs9vJScr2XN1xZHXZYehB8JEPVtddts4gJdARWTKXjZstKe6ZfFVD
         6Xqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dJnt2GP1pm08BDpQHAhmkmMOzHCfFoZgxhdL+wvVQI0=;
        b=3JwS7y9uEWRqhjI6bK7MrBztLA6eyfQsKvfY9/KUpJ7wx5uSQyY/ThkqskjTFFBWhC
         9tcHyT6Q6cOIW77HE9pU6buqxSJH9WzkpGAX7+ySP1UzRF+qmyAGeerCGi2ZpaLTCCF4
         s5yY/6VCnXIBO4yqr+qijCmv2mDxONEi9+ZdfjYCkrLish3XsfH4nSVQq0rYgFXtu5Tp
         KyrVrgjUXgVQPnx1d8edJcLPSAk2kZZyT86FygIzihdgi4oPoMI4XlqbTJkBvEZELco3
         Y5ppkKyAiAFXs/Cp8rsG+ZZxWQSlRAPxR6rRSfVeT+Uqmavv0Z/H3PWMifaW5SW0Y2lH
         4qag==
X-Gm-Message-State: ACrzQf2eUFmVHWCjybvIqRMM+WOR3uI6egmJT63egOV4LuwMgnJQS9Vu
        Ka3GwU7ksgQPz50FD7we7kYUL0YCm+CdEVxo
X-Google-Smtp-Source: AMsMyM4QQftM+1SbPAw/eMbzp1P4w7OUi/TXYHqvMABQeyIe0BWWf6rzp6zV9CjBu1IrRbbVd+x63Q==
X-Received: by 2002:adf:d843:0:b0:236:6231:113b with SMTP id k3-20020adfd843000000b002366231113bmr7525187wrl.42.1666622102639;
        Mon, 24 Oct 2022 07:35:02 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id r2-20020adfe682000000b002366fb99cdasm3413379wrm.50.2022.10.24.07.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 07:35:02 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dl2k: remove variable tx_use
Date:   Mon, 24 Oct 2022 15:35:01 +0100
Message-Id: <20221024143501.2163720-1-colin.i.king@gmail.com>
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

Variable tx_use is just being incremented and it's never used
anywhere else. The variable and the increment are redundant so
remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/dlink/dl2k.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index 2c67a857a42f..db6615aa921b 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -814,7 +814,6 @@ rio_free_tx (struct net_device *dev, int irq)
 {
 	struct netdev_private *np = netdev_priv(dev);
 	int entry = np->old_tx % TX_RING_SIZE;
-	int tx_use = 0;
 	unsigned long flag = 0;
 
 	if (irq)
@@ -839,7 +838,6 @@ rio_free_tx (struct net_device *dev, int irq)
 
 		np->tx_skbuff[entry] = NULL;
 		entry = (entry + 1) % TX_RING_SIZE;
-		tx_use++;
 	}
 	if (irq)
 		spin_unlock(&np->tx_lock);
-- 
2.37.3

