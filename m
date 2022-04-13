Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88B74FF349
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbiDMJWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiDMJWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:22:13 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0D027FE3;
        Wed, 13 Apr 2022 02:19:53 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id o5so1421959pjr.0;
        Wed, 13 Apr 2022 02:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VcH59zF+dctf551WHnbQ12CBZrBTk1QyNCXHeCJxPYs=;
        b=GODgMQZWF1A/DdWdiet5pSlKbmIKlS7ErLdt5jhTBUL2rfHzfy037I7mXBmawSqlaC
         mXcwh72oX/OEwUoYXaRMSIzULnd30tTzEP6NPGhDzlPjkU/sSDUQgvcKMf/kl/RE1naF
         S81vCZw+u/4C+2HczIMrhLaI2P74o2DKkXW4AvGfXbhut9Wn656+W0KTeQq2zuaR9HzJ
         bK3bdeF7yUG+rNwCJ/fFU3sLfkB43ZSKo2AUdqdQwpJT6ShLNykk8dYVuGVNcghcQzij
         pWXS+RYj33uIeUL/2Y4ttbEoOpfcULSWDKhrMvt3/kNSb3N4XySQchIQm1CyDAfVtcXB
         bsow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VcH59zF+dctf551WHnbQ12CBZrBTk1QyNCXHeCJxPYs=;
        b=c7tl6czZWruRR4OJQLgQYsI3bjORLwp++X/sKHTwZrTPpEq7i0Sxz0tc3dqk61jFbX
         etKzB/iRzrK5uqsJ/uQSSommf/3OEDey+akSgWYdps6ZWZBd86yALLmVBD4Myv9Whlk+
         2YkHQwEyLG/XTRXxQqiP5nAuDGvT72WXz0GQzivEjVYHdsNOcDfa0djJu9TMaeNYPAVn
         DQZrTA/YS3tj6Fe9s2SZqP5hkfdkZVMNSMFnwugHmJOFVASu+g/M14sdq6WgQUUfGVIc
         LSh8JecteQhtaHi3FqY1Ks06TmzvDlxy4Y86Hz9a7tBOijm8AUF6lLHBE88SLbLZhb8V
         1HLw==
X-Gm-Message-State: AOAM533RegOSvUb9VtXpEYX8+SmdwGEV8vcf6ORV1tZCnHl3IJpQipv1
        Zan+eNlcj8j55GL+Tq6fdu/AdD2O59gnLg==
X-Google-Smtp-Source: ABdhPJzhR/qSnXNVUgZC6oRIwgAwLXem1L7YTxsn5eHM0vJqISYDKA6dHOLDK2SMEwLOXiiVGItuNg==
X-Received: by 2002:a17:90b:38d2:b0:1c6:fa94:96bb with SMTP id nn18-20020a17090b38d200b001c6fa9496bbmr9772967pjb.206.1649841592967;
        Wed, 13 Apr 2022 02:19:52 -0700 (PDT)
Received: from slim.das-security.cn ([103.84.139.54])
        by smtp.gmail.com with ESMTPSA id q61-20020a17090a17c300b001cc91fe38e9sm2320305pja.43.2022.04.13.02.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 02:19:46 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH net] mac80211: tx: delete a redundant if statement in ieee80211_check_fast_xmit()
Date:   Wed, 13 Apr 2022 17:19:02 +0800
Message-Id: <20220413091902.27438-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If statement is meaningless because the code will goto out regardless of
whether fast_tx is NULL or not.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/mac80211/tx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b6b20f38de0e..0e53d9d60cd4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3150,8 +3150,6 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 
 	fast_tx = kmemdup(&build, sizeof(build), GFP_ATOMIC);
 	/* if the kmemdup fails, continue w/o fast_tx */
-	if (!fast_tx)
-		goto out;
 
  out:
 	/* we might have raced against another call to this function */
-- 
2.25.1

