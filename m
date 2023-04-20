Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9216E99EA
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjDTQu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjDTQuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:50:17 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D362423C
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:50:13 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 46e09a7af769-6a606135408so950691a34.0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682009412; x=1684601412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cs1rgUVYEUaBUygucR5J5yk/3/ZXB2QN68zo7YB/Jr4=;
        b=zno2wKqhtyUkUyK+a5wIl5yEklpqUNQ9dKdjQPoBTWI89fChlEmKJ46iqeGCSQ+UhV
         kSgxKO++PVS/nttb4Fb+80QBudyDHm9MTKXb1vK2yJ6MvWsQEuK+aBpRA+8wb6lTe1sU
         QVKg1CCslMGqm52vB+EhHj+HtGAN+xLEQX3BQ42pinSqA0NTHOauY8TShh5Z4Z1ARDSF
         kbX7mzdtDZA26MUuu0tF9u8bm6kqfGDoGFhPywkVsZtUCrjTR+kwCTHSH51WbDonfe5t
         r9TkLuhsnpTHNarCY26ONe71/gmoXISwkPC4pcd2byFVv1GcE5usJ47zjWTOl+BqTegL
         wDxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682009412; x=1684601412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cs1rgUVYEUaBUygucR5J5yk/3/ZXB2QN68zo7YB/Jr4=;
        b=WzilExYdQnL9y/Cqge1OFLN330SKg4Fms0ArvuLmchcVv6evxVVeVr72fjHJdjI0QC
         GfauHGsakLv1d1BoThjYSLrv1Mmo7asAfzvJInlqacbL/Eyg1sDES1VjMqnrMztQ5BS3
         N73Z7QgjhuxvxzBuGMp05tQvkIAmJAGl2lh1hEFshHEsty1HzU1wlrZOPDBF/JGrCgAC
         8KSsFh0Ezfy1rC8JWIRyY7qPJxGXqC2p8ez0lrbvjU5IvVZyCFqx6RMWcCze6ynwo0Sj
         bi2WAQmw+B2meofv4OwCraZKGl4Yr2Mpl/dFTc7uUKYXxW8xaCxwPZGqO9mje76W1cid
         GSIA==
X-Gm-Message-State: AAQBX9c/38LAJKQl2ERA6PeYRIX+pSUZ/GJWK32Fxjvx7Qgw4EMhLHHY
        5DFBOV2qPjsVJoZylvAKqbyHj4GBCmipOaB6lvo=
X-Google-Smtp-Source: AKy350arIE6PnmoAqenvkRkEPwnVOWcw+HdiDRRGijMSjOXc+C2Iv8X6CmIlpTdKG4tTD7YnEPtkLw==
X-Received: by 2002:a9d:6251:0:b0:69f:8fe4:38b9 with SMTP id i17-20020a9d6251000000b0069f8fe438b9mr1020373otk.21.1682009412571;
        Thu, 20 Apr 2023 09:50:12 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7668:3bb3:e9e3:6d75])
        by smtp.gmail.com with ESMTPSA id p26-20020a9d695a000000b006a13dd5c8a2sm894542oto.5.2023.04.20.09.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 09:50:12 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v3 5/5] net/sched: sch_qfq: BITify two bound definitions
Date:   Thu, 20 Apr 2023 13:49:28 -0300
Message-Id: <20230420164928.237235-6-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420164928.237235-1-pctammela@mojatatu.com>
References: <20230420164928.237235-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the sake of readability, change these two definitions to BIT()
macros.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/sch_qfq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index dfd9a99e6257..4b9cc8a46e2a 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -105,7 +105,7 @@
 #define QFQ_MAX_INDEX		24
 #define QFQ_MAX_WSHIFT		10
 
-#define	QFQ_MAX_WEIGHT		(1<<QFQ_MAX_WSHIFT) /* see qfq_slot_insert */
+#define	QFQ_MAX_WEIGHT		BIT(QFQ_MAX_WSHIFT) /* see qfq_slot_insert */
 #define QFQ_MAX_WSUM		(64*QFQ_MAX_WEIGHT)
 
 #define FRAC_BITS		30	/* fixed point arithmetic */
@@ -113,7 +113,7 @@
 
 #define QFQ_MTU_SHIFT		16	/* to support TSO/GSO */
 #define QFQ_MIN_LMAX		512	/* see qfq_slot_insert */
-#define QFQ_MAX_LMAX		(1UL << QFQ_MTU_SHIFT)
+#define QFQ_MAX_LMAX		BIT(QFQ_MTU_SHIFT)
 
 #define QFQ_MAX_AGG_CLASSES	8 /* max num classes per aggregate allowed */
 
-- 
2.34.1

