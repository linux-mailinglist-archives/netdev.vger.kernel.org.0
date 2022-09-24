Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237705E8713
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 03:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbiIXBxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 21:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbiIXBxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 21:53:45 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E81106529;
        Fri, 23 Sep 2022 18:53:44 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id l14so1038916qvq.8;
        Fri, 23 Sep 2022 18:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=H1UaOTpezQWNyZKXRTONOpsHys97wRpqFpTI6Zr1YuY=;
        b=inp7n0QA5p8anUYe8CCsOphpF3rIrxEVB1QR+ClplsUiGfl+QW5A4WUIKYfWC76Nb3
         7pJqgukW+yh4J4/NKWLfrRHTVEzNEBGQY2iq6Tk6DgLwnhWPgbXlRnkPBg3OCQhMIdit
         u74U4kxvL+EF29wIQPWkUPt2Yg9RrAZ0pFIi9Da+DJFRgrIfaXJww+LUVlNnYiOGDvyw
         NDqlvGza4O8YCYyUYHJe4VAAV7eF3WiLBb114qa+vFtvFUcgSfzl232ipbiV1uUEHC/w
         yObPUMif1RmXBhdlEN3H9Bn7x9DCX8/k6KByxHtd48F1IPAjLLm3EGhIgpmc3KzfHFqP
         tEdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=H1UaOTpezQWNyZKXRTONOpsHys97wRpqFpTI6Zr1YuY=;
        b=GbDr7nh7FsKP0IJJ+MmT0ZORvGirKwmL43K4KjZ5V8ryrZUsRoNrXUpTQjytT7HXh0
         A15e78Q7DeXGQcNDUQkYRhihs4601WqsdYAB6ABm4XqdA1v3SyprKtjSUtFzUjddFa9d
         IOZsGw8WBXcNBT9hNGRiBpeHtMzoR1c+mUysHp4b0KES84hUPeZTRjW4FoCGUdU6iC0b
         esvTVzy9GCZooem4UDaRES+idIfP+PgHLe07fZNQ3LMpksFptpTGpvOZyaXpo6Byhm1r
         gmdQYzkCu1gxukqNO955o2cAe5wS9lHDJnYvF2uw+g+lIZHRFmVGpXqjXpYjuye5nCoe
         CIxA==
X-Gm-Message-State: ACrzQf14hVSzBwJMXMqE4rv6trfiLIXoHzk734hVZKUPgSzNS0nSvnKB
        QEJ84AU/kgLcRX7gfWq41B4=
X-Google-Smtp-Source: AMsMyM6SaF7yVnz7G9pkKIWzOtbx0ys3YxyqEi6q6nbRya0jENAUE+CkV/4R2no91GsXh8Y66WCgDQ==
X-Received: by 2002:a05:6214:2303:b0:4ad:58f2:7ca4 with SMTP id gc3-20020a056214230300b004ad58f27ca4mr9134294qvb.89.1663984423937;
        Fri, 23 Sep 2022 18:53:43 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id i10-20020ac8764a000000b0035badb499c7sm6962360qtr.21.2022.09.23.18.53.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 18:53:43 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Zheyu Ma <zheyuma97@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v2 01/13] sunhme: remove unused tx_dump_ring()
Date:   Fri, 23 Sep 2022 21:53:27 -0400
Message-Id: <20220924015339.1816744-2-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220924015339.1816744-1-seanga2@gmail.com>
References: <20220924015339.1816744-1-seanga2@gmail.com>
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

(no changes since v1)

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

