Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56075BC088
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 01:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiIRX0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 19:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIRX0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 19:26:32 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B3815FEC;
        Sun, 18 Sep 2022 16:26:31 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id j10so16825642qtv.4;
        Sun, 18 Sep 2022 16:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=1+b05cqSjYOhMfSGBFr62HIBLVaTy7MEzbuck1eH+8Y=;
        b=N6NyIgfZB82Ka5NyWlidDmf7Okir7WBPDTc/jWpI0waszy8mwzp/hyvd0RrBYV/a9B
         EN0XLs/hVH35FS2qDnjGjGBgQzOMjYYEAtRJxXFnDb5KywtOMo+QIuRydpXyOJtXqyke
         yqQ3bdWnisPz5tZUdTRTq/onf1FUOB6Hra4l3fFyeK0I2t93RDAbL626kHB7Jq2TG67g
         9OWKkdjOfhgPlT/SirAsNE905H4DsNes1Vtuw7CJVj2oyfP26FkDJ4sBFFE7rAsQSXPg
         PejL5ym+CRreYE06HOwuujmKkyuSd9+9ztv+4dMlNGC5KxexjHyoks4nFo8lpPKVb3tf
         Nw/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=1+b05cqSjYOhMfSGBFr62HIBLVaTy7MEzbuck1eH+8Y=;
        b=mlvTzkRjeCPm560dcroKpS57RXlts6tSWMgmELOT4676CM+zne4GCluGNYk/VhT8C/
         76MqSDT7W9HiprzKG6KYYPNXwQ6ZOQVZLPCiG3trY8otoKe00kuD0V0klaHus8OfMjlm
         KHKuoQMNDODy1LssSSqFmVYLedOEXbInCHiRTddNETDK7zFLSsgElNFf/I1WczjnJiHR
         rkDQm0D7CO8/YPGVO0QEitjqfgpGjPyRiwR4PriVaDPBWthDnqY4zXcj+GffmvupV/x5
         svtSQ2333IkOw+YHXeOJf4TvV/EWuQ6BfNtZYirxLTUtqzC/OmYYNag5Qcyr7NXml4N2
         KBUA==
X-Gm-Message-State: ACrzQf0a6ENsf1H2K2C6o2ca9e8fnjvYCMvb31CxbssGxIimUM84I6SA
        FEB/UcTgx9AQS872g8EeB0w=
X-Google-Smtp-Source: AMsMyM7uUQXU294s9Ff4coj0w1UhznDiWom1HV45ftfLHNuvsE8YNFpxIppWEsCpEWlYCG4Nbz2w3g==
X-Received: by 2002:ac8:7f03:0:b0:35c:e89b:f972 with SMTP id f3-20020ac87f03000000b0035ce89bf972mr2558090qtk.679.1663543591001;
        Sun, 18 Sep 2022 16:26:31 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id h188-20020a37b7c5000000b006ce622e6c96sm10941488qkf.30.2022.09.18.16.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 16:26:30 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list),
        Zheyu Ma <zheyuma97@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next 01/13] sunhme: remove unused tx_dump_ring()
Date:   Sun, 18 Sep 2022 19:26:14 -0400
Message-Id: <20220918232626.1601885-2-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220918232626.1601885-1-seanga2@gmail.com>
References: <20220918232626.1601885-1-seanga2@gmail.com>
MIME-Version: 1.0
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

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

I can't find a reference to it in the entire git history.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 drivers/net/ethernet/sun/sunhme.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index e660902cfdf7..987f4c7338f5 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -135,25 +135,9 @@ static __inline__ void tx_dump_log(void)
 		this = (this + 1) & (TX_LOG_LEN - 1);
 	}
 }
-static __inline__ void tx_dump_ring(struct happy_meal *hp)
-{
-	struct hmeal_init_block *hb = hp->happy_block;
-	struct happy_meal_txd *tp = &hb->happy_meal_txd[0];
-	int i;
-
-	for (i = 0; i < TX_RING_SIZE; i+=4) {
-		printk("TXD[%d..%d]: [%08x:%08x] [%08x:%08x] [%08x:%08x] [%08x:%08x]\n",
-		       i, i + 4,
-		       le32_to_cpu(tp[i].tx_flags), le32_to_cpu(tp[i].tx_addr),
-		       le32_to_cpu(tp[i + 1].tx_flags), le32_to_cpu(tp[i + 1].tx_addr),
-		       le32_to_cpu(tp[i + 2].tx_flags), le32_to_cpu(tp[i + 2].tx_addr),
-		       le32_to_cpu(tp[i + 3].tx_flags), le32_to_cpu(tp[i + 3].tx_addr));
-	}
-}
 #else
 #define tx_add_log(hp, a, s)		do { } while(0)
 #define tx_dump_log()			do { } while(0)
-#define tx_dump_ring(hp)		do { } while(0)
 #endif
 
 #ifdef HMEDEBUG
-- 
2.37.1

